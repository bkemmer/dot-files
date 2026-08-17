---
name: unimed-reembolso
description: Reads one or more medical documents (Nota Fiscal/Recibo, Pedido/Relatório Médico) and fills a lean Markdown checklist with just the fields required by the Unimed Nacional "Solicitação de reembolso" web form, using a shorter field set for Terapias (sessions) vs Consulta Médica. Use when the user wants to prepare data for a Unimed reimbursement request from PDFs or images of invoices/receipts.
---

# Unimed Nacional — Preenchimento de solicitação de reembolso

Extracts the data needed for the Unimed Nacional online reimbursement form
("Solicitação de reembolso") from one or more source documents (PDF or
image: Nota Fiscal, Recibo, Pedido/Relatório Médico) and writes it into a
Markdown file the user can check against while filling the real form.

This skill does NOT submit anything to Unimed — it only prepares the data.

The output only ever contains the fields actually required to fill the
form for the request type at hand — nothing extra (no bank details, no
document-attachment tracking, no optional fields left blank). There are two
request types, each with its own shorter field list — see below.

## Inputs

One or more file paths (PDF or image) passed by the user, e.g. a folder
containing a Nota Fiscal/Recibo and, when available, a Pedido/Relatório
Médico.

If the user gives a folder instead of specific files, glob for
`*.pdf`, `*.jpg`, `*.jpeg`, `*.png` inside it and use all of them together
as the source set for a single reimbursement request.

## Steps

1. **Read every source file.** Use the Read tool on each PDF/image (it
   handles both natively). Do not use `pdftotext` or other CLI extraction —
   Read renders the page and OCRs it, which is more reliable for scanned
   receipts and stamps.

2. **Decide the request type** from the service description on the Nota
   Fiscal/Recibo (and the Pedido Médico, if present):
   - **Terapias**: recurring sessions of the same service — fisioterapia,
     psicoterapia, fonoaudiologia, terapia ocupacional, etc. Signals: "N
     sessões", a per-session unit value, a therapy CBHPM/TUSS code.
   - **Consulta Médica**: a single doctor's appointment. Signals: "consulta",
     one date, one value, billed by a physician (CRM).
   If genuinely ambiguous, ask the user which type it is rather than
   guessing.

3. **Extract only the fields listed for that type** below (do not extract
   or output anything not on the list — e.g. no Tipo de procedimento
   dropdown value, no address components beyond CEP/Número/Complemento, no
   bank details).

4. **Write the output** to a Markdown file (default:
   `reembolso-<nome-paciente>-<AAAA-MM>.md` next to the source documents,
   unless the user names a different path) using the matching template
   below.

5. If any required field truly cannot be found in the documents, still list
   it in the output with `TODO` as the value — don't drop it silently.

## Terapias — campos obrigatórios

- Quantidade de sessões
- Data das sessões (cada uma)
- Valor de cada sessão
- Valor total

**Nota Fiscal**
- Número da nota fiscal

**Dados do médico/clínica (prestador)**
- CPF ou CNPJ do prestador de serviço (CNPJ preferencialmente, quando o
  prestador tiver os dois)
- CEP
- Número do endereço
- Complemento (ap, cj, etc.) — só se houver
- Nome do profissional
- Tipo do conselho (CRM, CREFITO, CRP, CRFa, etc.)
- Estado do conselho (UF)
- Número do registro do profissional no conselho

### Template — Terapias

```markdown
# Solicitação de reembolso — Unimed Nacional (Terapias)

**Paciente:** <nome>
**Gerado a partir de:** <lista de arquivos-fonte>

- Quantidade de sessões: <n>
- Data das sessões: <data1, data2, ...>
- Valor de cada sessão: R$ <valor>
- Valor total: R$ <valor>

- Número da nota fiscal: <valor>

## Dados do médico/clínica
- CPF ou CNPJ do prestador: <valor>
- CEP: <valor>
- Número do endereço: <valor>
- Complemento: <valor, se houver>
- Nome do profissional: <valor>
- Tipo do conselho: <ex. CREFITO>
- Estado do conselho: <UF>
- Número do registro no conselho: <valor>
```

## Consulta Médica — campos obrigatórios

- Especialidade
- Data da consulta
- Valor da consulta

**Nota Fiscal**
- Número da nota fiscal

**Dados do médico/clínica (prestador)**
- CPF ou CNPJ do prestador de serviço
- CEP
- Número do endereço
- Complemento (ap, cj, etc.) — só se houver
- Nome do profissional
- Tipo do conselho (CRM, etc.)
- Estado do conselho (UF)
- Número do registro do profissional no conselho

### Template — Consulta Médica

```markdown
# Solicitação de reembolso — Unimed Nacional (Consulta Médica)

**Paciente:** <nome>
**Gerado a partir de:** <lista de arquivos-fonte>

- Especialidade: <valor>
- Data da consulta: <valor>
- Valor da consulta: R$ <valor>

- Número da nota fiscal: <valor>

## Dados do médico/clínica
- CPF ou CNPJ do prestador: <valor>
- CEP: <valor>
- Número do endereço: <valor>
- Complemento: <valor, se houver>
- Nome do profissional: <valor>
- Tipo do conselho: <ex. CRM>
- Estado do conselho: <UF>
- Número do registro no conselho: <valor>
```

## Notes

- Brazilian CPF/CNPJ, CEP, and currency values should be transcribed exactly
  as printed (keep the formatting, e.g. `51.528.666/0001-58`, `02416-060`,
  `390,00`) — the user will copy-paste these into the form.
- If a provider's professional council appears as "Crefito 3" followed by a
  number (common in fisioterapia NFS-e from São Paulo), the council is
  CREFITO, the number is the digits, and the estado is the state the
  council region covers (Crefito 3 = SP).
- If sessions have different values, list each session's value instead of
  assuming they're all equal, and sum them for "Valor total".
- "Valor total" must match the value on the Nota Fiscal/Recibo exactly —
  the real form validates that the sum of sessions equals it.
- Do not include address fields beyond CEP, Número, and Complemento — the
  form autofills logradouro/bairro/município/UF from the CEP.
- Do not include bank/reimbursement-account fields or a
  documentos-anexados section — they are out of scope for this skill.
