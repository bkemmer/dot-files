---
name: amazon-br-order-tracker
description: Extracts purchase history from a user's Amazon.com.br account (order list + individual order details + related Amazon Pay transaction/installment data) via Claude in Chrome, and produces a JSONL + Markdown summary tracking file. Use when the user asks to list, track, log, or annotate their Amazon Brazil orders/purchases, wants a structured data file of what they bought, or asks to check installment/payment details for an Amazon.com.br order.
---

# Amazon.com.br Order Tracker

## Purpose

Build (or refresh) a structured record of a user's Amazon.com.br purchase
history, combining three data sources:

1. The order history list (`/gp/css/order-history` or `/your-orders/orders`) — dates, order numbers, totals, items, delivery/return status.
2. An individual order details page (`/your-orders/order-details?...`) — full shipping address, exact subtotal/shipping/total, payment method (card, last 4 digits), delivery confirmation.
3. The related Amazon Pay transaction page (`/pay/history?...` and the transaction-detail drill-down) — the exact amount actually charged and whether it was split into installments.

Output: one JSONL file (one JSON object per line, one line per order)
plus one Markdown summary file highlighting totals, returns/refunds,
cancellations, and any specifically requested order's full annotated
detail + transaction/installment info.

## Requirements

- Claude in Chrome must be connected and the user must already be logged
  into their Amazon.com.br account in the active tab. This skill never
  enters credentials or logs in on the user's behalf.
- This only reads data (order history, order details, transaction
  history). It never places orders, cancels orders, initiates returns,
  or modifies account/payment settings. Any such action requires explicit
  user permission per the standing action-category rules.

## Step-by-step

### 0. Ask for a cutoff date before scraping anything

Order history pages 10 orders at a time and can run to dozens of pages
for an active account. Don't default to scraping every page — ask the
user how far back to go, before navigating anywhere:

- "How far back should I go? For example: since your last export/a
  specific date, the last 30 days, the last 3 months, or everything."

If the user already gave a date or range in their request (e.g. "since
July", "last 2 months", "just this last order"), use that directly
without asking again. If this is a refresh of a file this skill
produced before, read the existing JSONL's newest `order_date` and
offer that as the default cutoff ("since your last export on
2026-08-17?") rather than asking from scratch.

When running unattended (a scheduled task, no one to answer) and no
cutoff was given anywhere in the prompt, default to the last 3 months
(Amazon's own default view) and state that assumption plainly in the
output rather than blocking.

"Everything" is a valid answer — it just means don't stop early in
step 1 below; confirm that's really intended if the account looks large,
since it's dozens of extra page loads for comparatively little value
once you're well past the account's recent activity.

### 1. Scrape the order history list, stopping at the cutoff

Navigate to:
```
https://www.amazon.com.br/gp/css/order-history?ref_=nav_AccountFlyout_orders
```
Use `get_page_text` to pull the rendered list. The page shows the total
order count near the top (e.g. "54 pedidos feitos em"). Orders are
paginated 10 per page, newest first, via a `startIndex` query parameter:
```
https://www.amazon.com.br/your-orders/orders?startIndex=0
https://www.amazon.com.br/your-orders/orders?startIndex=10
https://www.amazon.com.br/your-orders/orders?startIndex=20
...
```
Navigating directly to each `startIndex` URL works (no need to click
"Próxima" each time, though that also works if direct navigation ever
fails — find the pagination link via the `find` tool and click it
instead).

Because orders are listed newest-first, stop paginating as soon as a
page's orders are all dated before the cutoff from step 0 — don't keep
incrementing `startIndex` through the rest of the account's history.
Concretely: after parsing each page, check the order dates; if every
order on that page is older than the cutoff, drop the ones before the
cutoff, stop there, and don't fetch the next page. A page can straddle
the cutoff (some orders on it still in range) — include only the
in-range orders from that final page. Only walk every remaining page
when the user explicitly asked for "everything" / "all time".

For each order block in the text, capture:
- Order date ("PEDIDO REALIZADO")
- Order number ("PEDIDO Nº", format NNN-NNNNNNN-NNNNNNN)
- Total ("TOTAL R$ ...") — absent for cancelled orders (no charge) and
  for "Entrega Amazon Now" orders (shown differently, still capture the
  total if present)
- Item name(s) — an order can contain multiple items/products
- Quantity per item if shown (a small number appears above multi-unit
  items)
- Delivery status line (e.g. "Entregue no dia X", "Devolução concluída",
  "Cancelada", "Entrega Amazon Now")
- Devolução/reembolso status — look for and record these possible
  phrases exactly since they matter for the "was this returned"
  question users often ask:
  - "Devolução concluída. Seu reembolso foi emitido." → mark as
    RETURNED/REFUNDED
  - "Elegível até <date>" → still within return window
  - "O período de devolução se encerrou em <date>" → return window
    closed
  - "Os períodos para troca e devolução se encerraram" → window closed
  - "Cancelada. Você não recebeu uma cobrança por este pedido." →
    CANCELLED, no charge (record total as 0 and note cancellation)
- Whether it's a recurring "Programe e Poupe" subscription item (look
  for "Entregue automaticamente: A cada N meses")

### 2. Annotate any specific order the user points to

If the user shares a screenshot or names a specific order, open its
detail page and record exactly what is shown: full shipping name and
address, exact subtotal/frete/total breakdown, payment method with last
4 card digits, delivery confirmation text, item name, seller, and return
eligibility date. Do not infer or guess any of these — record only what
the page/screenshot actually shows.

### 3. Get the exact transaction/installment amount

From the order details page, click "Exibir transações relacionadas" (or
navigate directly to the Amazon Pay history filtered by that order
number):
```
https://www.amazon.com.br/pay/history?tab=ALL&filter={"searchWords":["<ORDER-NUMBER>"]}&ref_=ppx_od_dt_b_th
```
This page renders client-side — `get_page_text` may not capture the
transaction rows/detail panel, so use screenshots to confirm what's
shown. Click the transaction row's amount to expand it, then click into
the individual charge (the row under "Pago com") to open the full
"Detalhes da transação" page, which shows:
- Exact amount charged
- Payment method and last 4 digits
- Whether it was split into installments (parcelas) — if installments
  exist they are listed individually with per-installment amounts and
  dates; if the charge is a single "à vista" payment, only one line
  appears
- Exact date/time of the charge
- Order ID (cross-check it matches)

Record this against the matching order row.

### 4. Produce the output files

Write two files:

- `pedidos_amazon.jsonl` — one JSON object per line, one line per order.
  Use this field set (omit a field, don't null it, when it doesn't
  apply — e.g. `recurring_detail` only when `recurring_purchase` is
  true):
  ```json
  {"order_date": "2026-08-17", "order_number": "701-0356301-4574600", "items": ["Nouê Tonalizante Camuflage Medium 140ml"], "quantity": 1, "total_brl": 147.0, "delivery_status": "Entregue 19/08/2026", "return_refund_status": "Elegivel para devolucao ate 18/09/2026", "recurring_purchase": false}
  ```
  Field notes:
  - `order_date` — ISO 8601 (`YYYY-MM-DD`) for sortability.
  - `items` — always a JSON array, even for a single item, so
    multi-item orders don't need a delimiter hack inside a string.
  - `total_brl` — a JSON number (not a string), `0` for cancelled
    orders with no charge.
  - `quantity` — total units across the order's items, as an integer.
  - `return_refund_status` — free text using the phrases captured in
    step 1 (e.g. "Devolução concluída — reembolso emitido",
    "Elegível até 18/09/2026", "Cancelado — não recebeu cobrança").
  - `recurring_purchase` — boolean; add `recurring_detail` (e.g.
    "a cada 3 meses") only when true.
  - Add a `transaction` object (amount, payment method, last-4 digits,
    installments, charge datetime) on any line where step 3 was run for
    that order.
  Write with `ensure_ascii=False` (or equivalent) so Portuguese
  accented characters are stored as literal UTF-8, not `\uXXXX` escapes.
- `resumo_pedidos.md` — a short summary: total order count, sum of
  charged amounts, a table of returned/refunded orders, a table of
  cancelled orders, and (if applicable) a fully annotated section for
  any order the user specifically asked about, including the related
  transaction/installment detail from step 3.

Verify the JSONL output before delivering: every line parses as valid
JSON, every `order_date` is on or after the cutoff (none should have
slipped past it), and the sum of `total_brl` looks sane — run a quick
`python3 -c` script that reads the file back with `json.loads` per line
and checks count/date-range/sum, rather than trusting manual
transcription. Note in the chat reply and in `resumo_pedidos.md` what
cutoff was used and how many orders it covered (don't just state a raw
count against Amazon's total order count, since that total includes
orders outside the requested range by design).

Deliver both files with `SendUserFile`. If a folder is connected via the
desktop bridge and the user has one for financial/shopping records,
offer to save the files there too.

## Notes and gotchas

- `get_page_text` on the transaction-history and transaction-detail
  pages often returns only the static shell (nav, footer, recommended
  product carousels) because the actual transaction content renders in
  a client-side widget. Fall back to `computer` screenshots for these
  pages specifically.
- Direct URL navigation to `startIndex=N` pages works reliably for the
  order list; if it ever doesn't (returns page 1 unchanged), use `find`
  to locate the "Próxima→" pagination link and click it instead — read
  its `href` via `read_page` first to confirm the `startIndex` pattern
  for that account.
- Always get the cutoff decision (step 0) before the first navigation.
  Asking after already fetching several pages wastes the work if the
  user's answer would have stopped earlier, and re-litigates a decision
  they already tried to make by asking upfront.
- The order list has no server-side date filter/query param — the
  cutoff is enforced client-side by reading dates off each page and
  stopping, not by requesting a narrower page from Amazon.
- Order totals shown in the list are already the final charged amount;
  don't recompute from item prices.
- Never fabricate or infer a return date, refund amount, or installment
  count — only report what a page explicitly states. If a data point
  isn't visible, leave the cell blank or note "-" rather than guessing.
- This skill only reads account/order/payment data already visible to
  the logged-in user. It never submits forms, initiates a return,
  cancels an order, or touches payment/account settings.
