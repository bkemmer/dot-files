---
name: mercadolivre-purchases
description: "Use this skill when the user asks to list, export, back up, or build a JSONL/data file of their Mercado Livre purchase history (myaccount.mercadolivre.com.br/my_purchases). Triggers on requests like 'list all my Mercado Livre purchases', 'export my ML order history', 'generate a file with what I bought on Mercado Livre', or similar, for any date range including 'all purchases'. Requires the user to be logged into mercadolivre.com(.br) in the connected browser (Claude in Chrome)."
license: Proprietary. See LICENSE.txt if present.
---

# Mercado Livre purchase history export

Scrapes Mercado Livre "Minhas Compras" (My Purchases) history — every order, every line item,
price breakdown, payment method, shipping address, and return/cancellation status — from a
user-chosen cutoff date forward, and turns it into a JSONL file. Built from a live
reverse-engineering session against `myaccount.mercadolivre.com.br/my_purchases/list`; the DOM
selectors below were verified working as of 2026-08 but Mercado Livre may change its markup, so
re-verify a couple of selectors first if extraction comes back empty.

**Always ask for a cutoff date before scraping** (Step 1b) — don't default to scraping full
history unless the user explicitly says "all time"/"everything". This keeps re-runs fast and
avoids redundant work when the user only wants recent purchases or an incremental update.

## Prerequisites

- Claude in Chrome (`mcp__claude-in-chrome__*` tools) connected, with a tab open and the user
  **already logged in** to mercadolivre.com.br. If `navigate` to the purchases URL redirects to
  a login page, stop and ask the user to log in manually — never enter credentials yourself.
- No format skill is needed for the deliverable itself — the output is a plain JSONL file (one
  JSON object per line), written directly with Python's `json` module. If the user instead asks
  for a spreadsheet, read `/mnt/skills/public/xlsx/SKILL.md` at that point and adapt Step 7
  accordingly, but JSONL is the default for this skill.

## Why this can't be done with simple page reads

The purchases list is paginated (~10 items/page) and each order's financial detail (price
breakdown, payment method, shipping address) only appears on a separate per-order "status" page
reached via "Ver compra". For a full history this can be 15-20 list pages plus 100-200+ detail
pages — far too many to visit one at a time with `navigate` + screenshot. The technique below
fetches the underlying HTML directly from the page's own JS context (same-origin, so the
session cookie is included) instead of navigating the visible tab, which is dramatically faster
and avoids UI timing issues.

## Step 1 — Confirm login and get a tab

Navigate the active tab to `https://myaccount.mercadolivre.com.br/my_purchases/list#menu-user`.
If it redirects to a login URL (`mercadolivre.com/jms/mlb/lgz/...`), tell the user and wait —
do not proceed until they confirm they're logged in.

## Step 1b — Ask for a cutoff date before scraping anything

**Always ask before fetching any list page.** A full history can be 15-20 list pages and
100-200+ detail-page fetches; re-running that in full every time the user wants an updated
export is slow and wasteful, especially when they only care about recent activity or are
re-running this after an earlier export. Use `AskUserQuestion` (fall back to a plain-text
question if that tool isn't available) with options along these lines:

- "All time" — no cutoff, scrape everything (the original behavior).
- "Last 3 months" / "Last 6 months" / "Last 12 months" — computed from today's date.
- "Since my last export" — if the user has an earlier output file from this skill (look for
  `YYYYMMDD_*.jsonl` in the working directory per the filename convention in Step 7 and pick the
  newest by that date prefix), use the newest `data_pedido_iso` inside it as the cutoff, so this
  run only fetches what's new.
- "Custom date" — let them type a specific date; parse it liberally (`2025-01-01`, `01/01/2025`,
  "January 2025", "janeiro de 2025", etc.) and normalize to an ISO date for comparison.

Convert whatever they choose into a single `cutoffISO` (`YYYY-MM-DD`) string, or `null` for "all
time". Everything from Step 2 onward is scoped to `cutoffISO`.

## Step 2 — Scrape the list pages (order index), stopping at the cutoff

Run this in `mcp__claude-in-chrome__javascript_tool` (`javascript_exec`). It fetches each list
page's HTML via `fetch(..., {credentials:'include'})` and parses it with `DOMParser` — no
navigation needed, and much faster than clicking through pages.

**Stop paginating as soon as you cross the cutoff.** List pages are strictly reverse-
chronological (newest first), so once an item's date is older than `cutoffISO` you can stop
fetching further pages entirely — no need to determine the true last page number first. This is
the main point of asking for a cutoff: a "last 3 months" export might only need 2-3 page
fetches and a couple dozen detail fetches instead of the full 15-20 pages / 170+ orders.

Portuguese list dates often omit the year for recent entries (`"6 de agosto"`) but include it
further back (`"18 de dezembro de 2025"`). Since pages are read in descending date order,
reconstruct the year incrementally instead of assuming "this year" for every undated entry:

```js
const MONTHS = {janeiro:1,fevereiro:2,março:3,abril:4,maio:5,junho:6,julho:7,agosto:8,setembro:9,outubro:10,novembro:11,dezembro:12};
let inferredYear = new Date().getFullYear();
let lastTimestamp = Infinity;
function parsePtDate(s) {
  const m = s.match(/(\d{1,2}) de (\w+)(?: de (\d{4}))?/);
  if (!m) return null;
  const day = +m[1], month = MONTHS[m[2]];
  let year = m[3] ? +m[3] : inferredYear;
  let iso = `${year}-${String(month).padStart(2,'0')}-${String(day).padStart(2,'0')}`;
  // walking backward in time: if this date is somehow AFTER the previous one, we've
  // wrapped a year boundary (e.g. "3 de janeiro" appearing after "20 de dezembro" earlier
  // in the same walk) — decrement and reparse.
  if (new Date(iso).getTime() > lastTimestamp) {
    year -= 1;
    iso = `${year}-${String(month).padStart(2,'0')}-${String(day).padStart(2,'0')}`;
  }
  if (!m[3]) inferredYear = year; // only let undated entries update the running year
  lastTimestamp = new Date(iso).getTime();
  return iso;
}
```

Apply `parsePtDate` to each row's date as you collect it; once you see one that is
`< cutoffISO`, discard that row and everything after it on the page, and don't fetch the next
page at all. When `cutoffISO` is `null` ("all time"), skip the early-stop check and fall back to
the page-count approach described below.

Key selectors on the list page:
- `article` — one per date-group (a date can contain multiple `.list-item`s, e.g. a multi-item
  order that was cancelled shows 3 `.list-item`s under one `article`).
- `.list-item-grouper__header` — the date heading text (e.g. "6 de agosto").
- Within each `.list-item`:
  - `.list-item__product img` → `.alt` = product name.
  - `.list-item__intro` = status line (e.g. "Entregue", "Você cancelou a compra").
  - `.list-item__title` = secondary status text (delivery date or refund message).
  - `.list-item__info` = quantity + variant, e.g. `"1 un. | Cor: Prateado"`.
  - The `<a>` whose text is exactly `"Ver compra"` has the detail-page URL. Parse it with `new
    URL(href, location.origin)` and read `.pathname.split('/')[2]` (the order path id) and
    `searchParams.get('packId')` / `.get('orderId')` — **do not fetch or print the raw href**,
    see the output-safety note below.

For the "all time" case (no cutoff), determine the page count from the "N compras" counter
and/or the pagination `nav a` links (`?page=0` is the first page; the last numbered link tells
you the max) and loop `page = 0..max`. For any real cutoff, just loop `page = 0, 1, 2, ...`
incrementing until the early-stop check above trips — you don't need the max page number at
all. Either way, fetch each page, collect rows. **Important finding from the reference run:**
"N compras" counts *orders* (unique path ids), not line items — a single order can have 2+
`.list-item`s (packs) that will double-count if you naively dedupe. Dedupe rows by `pathId +
'|' + packId`, then separately collect the set of unique `pathId`s.

```js
async function fetchListPage(p) {
  const res = await fetch(`https://myaccount.mercadolivre.com.br/my_purchases/list?page=${p}`, {credentials:'include'});
  const doc = new DOMParser().parseFromString(await res.text(), 'text/html');
  const rows = [];
  for (const a of doc.querySelectorAll('article')) {
    const date = (a.querySelector('.list-item-grouper__header')?.textContent||'').replace('Adicionar tudo ao carrinho','').trim();
    for (const it of a.querySelectorAll('.list-item')) {
      const img = it.querySelector('.list-item__product img');
      const verCompra = Array.from(it.querySelectorAll('a')).find(l=>l.textContent.trim()==='Ver compra');
      let pathId=null, orderId=null, packId=null;
      if (verCompra) {
        const u = new URL(verCompra.getAttribute('href'), location.origin);
        pathId = u.pathname.split('/')[2]; orderId = u.searchParams.get('orderId'); packId = u.searchParams.get('packId');
      }
      rows.push({date, product: img?.alt||'', intro: it.querySelector('.list-item__intro')?.textContent.trim()||'',
                 title: it.querySelector('.list-item__title')?.textContent.trim()||'',
                 info: it.querySelector('.list-item__info')?.textContent.trim()||'', pathId, orderId, packId});
    }
  }
  return rows;
}
```

## Step 3 — One fetch per order (not per item!)

**Critical discovery:** the per-order detail URL
`https://myaccount.mercadolivre.com.br/my_purchases/{pathId}/status?packId={anyPackId}` ignores
which `packId` you pass — it always returns the *entire* order, including every item ("Pacote
1", "Pacote 2", ...) as sibling cards. So you only need **one fetch per unique `pathId`**, using
any one of its known `packId`s, not one fetch per line item. This cuts request volume
significantly for orders with multiple products.

Only fetch detail pages for the `pathId`s that survived the Step 2 cutoff filter — this is the
other half of why asking for a cutoff matters, since detail fetches (one full page each) are
the slower part of the whole scrape.

Selectors on the detail page (`.detail-container`):
- `.bf-ui-ticket__subtitle` → `"{date}  |  # {orderNumber}"`.
- `.bf-ui-ticket-row` (repeated) → price-breakdown rows (Produto/Produtos (N), Desconto à
  vista, Cupons, Frete, Impostos, Total, Reembolso — label set varies per order). Read the
  amount from `.andes-visually-hidden` inside the right column — it's spelled out ("29 reais
  com 90 centavos", or "Grátis") and far easier to parse reliably than the visible split
  currency spans.
- `.bf-ui-expandable__content` — there are usually 2+ on the page (one is order info, others
  are unrelated help/FAQ widgets) — pick the one whose `textContent` includes `'Pagamento'` or
  `'Frete'`.
  - Its direct-child `.bf-ui-list-with-title` elements are the "Pagamento" and "Frete" (or
    "Retirada"/"Entrega") sections. Inside each, the `.bf-ui-detail-row`'s `<p>` children carry
    class `bf-ui-detail-row__title` / `__secondary-title` (repeatable) / `__description`.
  - Its direct-child `.bf-ui-card` elements (siblings of the two sections above, **not**
    nested inside them) are the per-item cards — one per product ("Pacote N" label if
    multi-item, no label if single-item). **One of these cards is "Dados para a alfândega"
    (customs data) and contains the buyer's full name and CPF (Brazilian tax ID) — always
    detect and skip it (e.g. `card.textContent.includes('CPF')`); never extract or store that
    card's contents, per the PII rule below.**
  - Within an item card: `.bf-ui-row-with-ellipsis__title` = product name;
    `.bf-ui-row-with-ellipsis__secondary-title` (repeatable, ~1-2 per item) — the first usually
    holds price(s) + qty (`.bf-ui-rich-price--strike` = original price if discounted, the
    sibling non-strike `.bf-ui-rich-price` = final price; read the integer/cents via
    `.bf-ui-price-small` / `.bf-ui-price-small-cents` inside each), a later one (no price
    spans) holds the variant text (color/size/etc).

**Duplicated text problem:** Many elements render both a visible span and an
`.andes-visually-hidden` aria-label span with the *same* text, so naive `.textContent` doubles
strings like `"Mastercard **** 8282Mastercard **** 8282"`. Use this helper to get single clean
text from an element:

```js
function cleanText(el) {
  if (!el) return '';
  const c = el.cloneNode(true);
  c.querySelectorAll('.andes-visually-hidden').forEach(n=>n.remove());
  return c.textContent.replace(/\s+/g,' ').trim();
}
```

Fetch with modest concurrency (5-6 parallel `fetch`es) in a loop over the unique `pathId`s —
170 orders took about 70s total at concurrency 6 in the reference run. Store results in a
`window.__orderDetails` array (or similar) so state survives across multiple `javascript_exec`
calls if you need to chunk the work.

## Step 4 — Getting bulk JSON out of the browser tools (the hard part)

`javascript_tool`'s return value is display-truncated at roughly **800-1000 characters** for
inline results, and a base64-looking or highly repetitive string can trigger a
`[BLOCKED: ...]` false positive — so `JSON.stringify()`-ing the whole dataset and returning it
directly does **not** work for anything but tiny datasets.

**Working technique:** inject the JSON string as `textContent` into the *live* page's DOM
(replace `document.body.innerHTML` entirely first, so nothing else pollutes the extraction),
then call `mcp__claude-in-chrome__get_page_text` on that tab. That tool has a much higher cap
(~50,000 characters before it either truncates or — if the content is large enough to trip a
"result too large" guard — saves the full output to a local `.txt` file you can read/cat
directly, which is even better). For anything under ~50KB you'll get it back inline; for larger
payloads, split into ~35,000-character substrings (`str.substring(a, b)`) across multiple
inject-then-read rounds so each round's *displayed* text stays complyingly under the cap, and
concatenate the pieces back together afterward (they'll split mid-string/mid-object — that's
fine, just concatenate in order, the JSON re-parses cleanly once whole).

```js
document.title = 'SCRAPE_DATA';
document.body.innerHTML = '';
const pre = document.createElement('pre');
pre.textContent = JSON.stringify(window.__orderDetails).substring(0, 35000); // repeat with next slice
document.body.appendChild(pre);
```
Then call `get_page_text` on that tab and capture the result (or the saved file, if one was
reported) into your own workspace with `Write`/`Bash`. **After reconstructing**, always verify:
`json.loads()` the concatenated text, check the parsed length matches your source count, and
diff the set of `pathId`s against the full list you scraped in Step 2 to catch any dropped
records from a bad chunk boundary — this caught 4 silently-dropped orders in the reference run.

Do **not** try `console.log` + `read_console_messages`, downloading a Blob, or `sessionStorage`
across a navigation — none of these reliably move large payloads out in this environment; the
DOM-injection + `get_page_text` route is the one that worked.

## Step 5 — PII rule (non-negotiable)

Mercado Livre's order detail page includes a "Dados para a alfândega" (customs data) card with
the buyer's **full legal name and CPF** (Brazilian government tax ID — equivalent to an SSN).
**Never extract, store, or write this card's contents to any file.** Detect and skip it during
DOM extraction (see Step 3). If you ever notice CPF-shaped text (`\d{3}\.\d{3}\.\d{3}-\d{2}`) in
any captured field, strip that row before it reaches the output file.

## Step 6 — Derive return/cancellation status

The list page's per-item `intro`/`title`/`desc` (Step 2) and the detail page's `ticket` labels
(Step 3) are both needed to flag returns — no single field covers every case:
- `intro` containing "cancel" → order was cancelled (`"Você cancelou a compra"`, `"Compra
  cancelada pelo vendedor"`, etc.)
- `intro` containing "devolveu" → buyer returned the item (`"Você devolveu o produto"`).
- A `Reembolso` key present in the detail page's `ticket` object → a refund was issued (works
  even when `intro` doesn't mention cancellation, e.g. "O vendedor resolveu a reclamação").
- Mercado Livre does **not** expose a distinct "date returned" field on this page — the only
  reliable date is the order date. Say so explicitly in the output rather than inventing one;
  surface the original status text (`title`, e.g. "Seu reembolso foi confirmado") as the closest
  available detail.

## Step 7 — Build the JSONL file

Output is a `.jsonl` file: one line per **item** (not per order) — multi-item orders would
otherwise hide products behind a single order-level record, and "what did I buy" queries are
naturally per-item. Write it with plain Python (`json.dumps(obj, ensure_ascii=False)` + `'\n'`
per line, opened with `encoding='utf-8'`) — no library/skill needed for this format.

**Filename:** prefix it with today's date as `YYYYMMDD_` (the date the scrape was *run*, not an
order date) — e.g. `20260823_compras_mercado_livre.jsonl`. This keeps successive exports (a
full history export today, an incremental "since last export" one next month, etc.) sortable by
filename and makes it trivial to find "my latest export" for the Step 1b "since my last export"
option — pick the newest `YYYYMMDD_*.jsonl` in the working directory.

Use compact `snake_case` keys (not the Portuguese UI labels) so the file is easy to consume
programmatically later. Recommended fields per line:

```
data_pedido, data_pedido_iso, numero_pedido, pacote, item, variante, quantidade,
preco_original, preco_pago, subtotal_produtos, desconto, frete, impostos, total_pedido,
parcelamento, forma_pagamento, status_pagamento, numero_pagamento,
endereco_entrega, cidade_uf, status_entrega, detalhe_status, observacao,
devolvido_cancelado_ou_reembolsado (boolean), tipo_devolucao_cancelamento,
valor_reembolsado, id_pedido_mercadolivre
```

`data_pedido_iso` is a best-effort `YYYY-MM-DD` parse of the Portuguese date string (map month
names, default to the current year when the source string omits one, e.g. "6 de agosto" from
the current list vs. "18 de dezembro de 2025" from an older page) — keep the original
`data_pedido` string alongside it since the parse is a convenience, not authoritative.

Do **not** put a PII/return-date notes blurb inside the data file itself (JSONL has no sidecar
sheet) — mention those caveats in your reply to the user instead, or as a single leading line
in the file only if the user asks for one; by default every line should be a clean, uniform
purchase record.

After writing, validate: read the file back line-by-line with `json.loads`, confirm the line
count matches your row count, and spot-check a couple of records against the source data.

## Known gotchas recap

- Login redirect → stop and ask the user, never authenticate yourself.
- Always ask for a cutoff date (Step 1b) before fetching a single list page — never assume
  "all time" by default.
- List-page dates often omit the year for recent entries; reconstruct it incrementally while
  walking pages (Step 2's `parsePtDate`), don't just assume "current year" for every row.
- `packId` in the detail URL doesn't scope the response — fetch once per order, not per item.
- Visible+hidden duplicate text everywhere → always use the `cleanText()` clone-and-strip helper.
- `javascript_tool` truncates return values hard (~1KB) and false-flags repetitive/base64-looking
  strings → move bulk data out via DOM injection + `get_page_text`, chunked at ~35KB, then
  verify by count and by diffing IDs.
- Skip the "Dados para a alfândega" card — it carries CPF + full name.
- "N compras" = order count, not line-item count; multi-item orders will make your line-item
  total higher than the advertised number, which is expected.
