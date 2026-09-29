# Funding Sources Reference

Detailed information about each funding source for the academic funding search skill.

**Last verified**: 2026-09-29 (ERC eligibility windows, ERC Plus, and Leverhulme fellowship amounts checked
against live pages; other additions taken from the 2026-09-28 run's Reference Discrepancies).
Scheme amounts and dates drift year to year. **Live pages always take precedence over this file.**
Record any discrepancies under "Reference Discrepancies" in the report.

## UK Funding Sources

### 1. UKRI (UK Research and Innovation)

**URL**: https://www.ukri.org/opportunity/
**Coverage**: All disciplines through 9 research councils

**Research Councils**:

- AHRC - Arts and Humanities Research Council
- BBSRC - Biotechnology and Biological Sciences Research Council
- EPSRC - Engineering and Physical Sciences Research Council
- ESRC - Economic and Social Research Council
- MRC - Medical Research Council
- NERC - Natural Environment Research Council
- STFC - Science and Technology Facilities Council
- Innovate UK - Business innovation
- Research England - University funding

**Typical schemes**:

- New Investigator Awards (early career)
- Standard grants
- Programme grants
- Fellowships (various career stages)
- Doctoral training partnerships

**Eligibility**: UK research organisations (universities, research institutes)

#### UKRI Filter IDs

Used to build filtered listing URLs (see SKILL.md → Source-specific instructions).

| Council | `filter_council[]` |
|---------|--------------------|
| AHRC | 814 |
| BBSRC | 816 |
| ESRC | 818 |
| EPSRC | 820 |
| Innovate UK | 822 |
| MRC | 824 |
| NERC | 826 |
| Research England | 828 |
| STFC | 830 |
| UKRI-wide | 1730 |

| Funding type | `filter_funding_type[]` |
|--------------|-------------------------|
| Grant | 16 |
| Fellowship | 18 |
| Loan | 34 |
| Other | 82 |

Status values: `filter_status[]=open`, `upcoming`, `closed`. Always add `filter_submitted=true`.
Pagination: `/opportunity/page/N/?<same query string>`.

---

### 2. Leverhulme Trust

**URL**: https://www.leverhulme.ac.uk/schemes-at-a-glance
**Coverage**: All disciplines, preference for cross-disciplinary

**Key schemes**:
| Scheme | Amount | Career Stage |
|--------|--------|--------------|
| Research Project Grants | Up to £500k | Established |
| Research Fellowships | Up to £70k, 3–24 months | Experienced researchers, any discipline **except clinical/medical research** |
| Early Career Fellowships | ~£130k over 3 years (salary up to £56k yr 1, 50% up to £28k yrs 2–3, + £6k/yr expenses) | Early career |
| Major Research Fellowships | Up to 3 years | Established — **humanities & social sciences only** |
| Emeritus Fellowships | Up to £24k | Retired academics |
| Philip Leverhulme Prizes | £100k | Early career leaders |
| Research Leadership Awards | Up to £1M | Established; next round expected to open Jan 2028 |
| Research Centres | £1M/year for 10 years | Established, large-scale institutional bids |

**Eligibility**: UK-based researchers

---

### 3. British Academy

**URL**: https://www.thebritishacademy.ac.uk/funding/
**Coverage**: Humanities and Social Sciences only

**Key schemes**:

- BA/Leverhulme Small Research Grants (up to £10k)
- Postdoctoral Fellowships (3 years)
- Mid-Career Fellowships
- Newton International Fellowships (for overseas researchers)
- Global Professorships

**Eligibility**: UK-based researchers in humanities/social sciences

---

### 4. Wellcome Trust

**URL**: https://wellcome.org/grant-funding
**Coverage**: Health and biomedical research
**Schemes directory**: https://wellcome.org/research-funding/schemes

**Strategic areas**:

1. Discovery Research
2. Climate and Health
3. Infectious Disease
4. Mental Health

**Budget**: £16 billion (2022-2032)

**Key schemes**:

- Career Development Awards
- Senior Research Fellowships
- Investigator Awards
- Discovery Awards
- Collaborative Awards

**Eligibility**: Health/biomedical researchers worldwide (host institution requirements apply)

---

### 5. Royal Society

**URL**: https://royalsociety.org/grants/
**Coverage**: Natural sciences

**Key schemes**:
| Scheme | Amount | Duration | Career Stage |
|--------|--------|----------|--------------|
| University Research Fellowships | Up to £1.87M | 8 years | Early career |
| Dorothy Hodgkin Fellowships | Up to £1.87M | 8 years | Flexible working |
| Newton International Fellowships | 2 years | 2 years | Non-UK early career |
| Career Development Fellowship | Up to £690k | 4 years | Underrepresented groups |
| Faraday Discovery Fellowships | Up to £8M | 10 years | Mid-career leaders |

**Eligibility**: Scientists in UK or Republic of Ireland

---

### 6. Royal Academy of Engineering

**URL**: https://raeng.org.uk/programmes-and-prizes/programmes/uk-grants-and-prizes/
**Coverage**: Engineering disciplines

**Key schemes**:

- Research Fellowships (£625k over 5 years)
- Research Chairs & Senior Research Fellowships (up to £450k over 5 years, industry co-funded)
- Green Future Fellowships (up to £3M over 10 years; net-zero / sustainability engineering)
- Chair in Emerging Technologies (£2.5M over 10 years; opening date on the scheme page has been inconsistent, so check it each run)
- Industrial Fellowships (up to £50k/yr, academic–industry secondments)
- Ingenious Public Engagement Grants (up to £30k)
- Enterprise Fellowships (for commercialisation)
- Distinguished Visiting Fellowships

**Eligibility**: Engineering researchers, typically UK-based

---

## EU Funding Sources

### 7. EU Funding & Tenders Portal (Horizon Europe)

**URL**: https://ec.europa.eu/info/funding-tenders/opportunities/portal/
**Access**: JavaScript-rendered, so query it with `scripts/eu_calls.sh` (POST to the portal's search API)
**Coverage**: All disciplines, collaborative research

**Key programmes**:

- Horizon Europe (€95.5bn, 2021-2027)
- Marie Skłodowska-Curie Actions (researcher mobility)
- European Innovation Council

**Eligibility**:

- EU Member States
- Associated Countries (including UK under Horizon Europe association)
- Third countries (limited)

---

### 8. European Research Council (ERC)

**URL**: https://erc.europa.eu/apply-grant
**Coverage**: Frontier research in all disciplines

**Grant types**:
| Grant | Amount | Career Stage | Years post-PhD |
|-------|--------|--------------|----------------|
| Starting Grant | €1.5M (+€1M) | Early career | **0–10 years** |
| Consolidator Grant | €2M (+€1M) | Mid-career | **5–15 years** |
| Advanced Grant | €2.5M (+€1M) | Established | Any |
| Synergy Grant | €10M | Collaborative (2–4 PIs) | Any |
| ERC Plus Grant | Up to €7M, 4–7 years | Outstanding researchers, transformative research beyond other ERC schemes | Any |
| Proof of Concept | €150k | Commercialisation | ERC grantees |

The ERC windows were widened and no longer line up with the career stages below. Use the
years-post-PhD column here, not the stage name, to judge ERC eligibility. Advanced Grant 2026 and
2027 run as lump-sum pilot calls.

**ERC Panels**:

- PE (Physical Sciences & Engineering): PE1-PE10
- LS (Life Sciences): LS1-LS9
- SH (Social Sciences & Humanities): SH1-SH6

**Eligibility**: Must conduct research in EU/Associated Country

---

## Career Stage Mapping

This is the single source of truth for career stages. SKILL.md refers here.
Ranges overlap on purpose: use current title and PI record to decide borderline cases.

| Stage        | Years post-PhD | Typical schemes                     |
| ------------ | -------------- | ----------------------------------- |
| PhD Student  | N/A            | Doctoral training, studentships     |
| Postdoc      | 0-3 years      | Fellowships, small grants           |
| Early Career | 2-7 years      | ERC Starting (0–10 yrs), URF, New Investigator |
| Mid-Career   | 7-12 years     | ERC Consolidator (5–15 yrs), project grants |
| Established  | 12+ years      | ERC Advanced, programme grants      |

---

## Discipline Mapping

| Discipline        | UK Funders                        | EU Panels |
| ----------------- | --------------------------------- | --------- |
| Arts & Humanities | AHRC, British Academy, Leverhulme | SH1-SH6   |
| Social Sciences   | ESRC, British Academy, Leverhulme | SH1-SH6   |
| Life Sciences     | BBSRC, MRC, Wellcome              | LS1-LS9   |
| Physical Sciences | EPSRC, STFC                       | PE1-PE10  |
| Engineering       | EPSRC, RAEng                      | PE1-PE10  |
| Environmental     | NERC                              | PE10, LS8 |
| Health/Medical    | MRC, Wellcome                     | LS1-LS9   |
| Interdisciplinary | Leverhulme, UKRI                  | Any       |
