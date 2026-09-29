---
name: academic-funding-search
description: Search UK and EU academic funding opportunities personalized to the user's CV. Covers UKRI, Horizon Europe, ERC, Wellcome Trust, Leverhulme, British Academy, Royal Society, and Royal Academy of Engineering. Use when finding research grants, fellowships, or project funding.
---

# Academic Funding Search

Search for UK and EU academic funding opportunities matched to your research profile.

**Before starting, read [REFERENCE.md](REFERENCE.md)** in this folder. It holds the career-stage
and discipline mappings, UKRI filter IDs, and background on each funder's schemes. Treat its
scheme amounts and dates as background only: **the live page always wins**, and any discrepancy
you find should be noted in the report.

## Workflow

Use the **Read** tool for local files (CV, REFERENCE.md, previous report) and **Glob** to list
`output/`. Do not use `cat`, `ls` or other shell commands: unattended runs only allow the EU helper
script in Bash.

1. **Read the user's CV** if provided (PDF, DOCX, or text file)
2. **Extract researcher profile**: research areas, career stage, disciplines, institution
3. **Load the previous report**: Glob `output/funding_opportunities_*.md` and Read the most
   recent one dated *before today* (skip if none exists)
4. **Fetch funding opportunities** from every source below (see Source-specific instructions)
5. **Match and rank** opportunities using Fit and Timing (see Matching Logic)
6. **Compare with the previous report** and tag each opportunity (see Changes Since Last Report)
7. **Save results** to a markdown file in the `output/` folder
8. **Inform the user** of the output file location

## CV Profile Extraction

From the CV, identify:
- **Career stage**: use the five stages in REFERENCE.md → *Career Stage Mapping*
  (PhD Student, Postdoc, Early Career, Mid-Career, Established). Base it on years since PhD,
  adjusted for current title and PI track record.
- **Disciplines**: map to funder categories using REFERENCE.md → *Discipline Mapping*
- **Research keywords**: topics, methods, application domains
- **Institution type**: university, research institute, industry
- **Location**: UK-based, EU-based, international

## Funding Sources

### UK Sources
| Source | URL | Focus |
|--------|-----|-------|
| UKRI | https://www.ukri.org/opportunity/ | All research councils |
| Leverhulme Trust | https://www.leverhulme.ac.uk/schemes-at-a-glance | Research grants, fellowships |
| British Academy | https://www.thebritishacademy.ac.uk/funding/ | Humanities, social sciences |
| Wellcome Trust | https://wellcome.org/grant-funding | Health, biomedical |
| Royal Academy of Engineering | https://raeng.org.uk/programmes-and-prizes/programmes/uk-grants-and-prizes/ | Engineering |
| Royal Society | https://royalsociety.org/grants/ | Natural sciences, fellowships |

### EU Sources
| Source | URL | Focus |
|--------|-----|-------|
| EU Funding Portal | via `scripts/eu_calls.sh` (see below) | Horizon Europe |
| ERC | https://erc.europa.eu/apply-grant | Frontier research |

### Source-specific instructions

**UKRI**: the unfiltered listing runs to 12+ pages. Instead, WebFetch a *filtered* listing built
from the councils relevant to the profile (IDs in REFERENCE.md → *UKRI Filter IDs*), always
including UKRI-wide (1730), with status open + upcoming:

```
https://www.ukri.org/opportunity/?filter_council%5B%5D=820&filter_council%5B%5D=1730&filter_status%5B%5D=open&filter_status%5B%5D=upcoming&filter_submitted=true
```

Then fetch every result page by inserting `page/N/` after `/opportunity/` with the same query
string (for example `https://www.ukri.org/opportunity/page/2/?filter_council%5B%5D=820&...`)
until a page returns no new opportunities. Report how many pages were fetched.

**EU Funding & Tenders Portal**: the portal is JavaScript-rendered and its search API only accepts
POST, so do not WebFetch it. Run the helper once for each of 3–5 of the researcher's core keyword
phrases:

```bash
bash .claude/skills/academic-funding-search/scripts/eu_calls.sh "digital twin infrastructure"
```

It prints `identifier<TAB>title<TAB>next deadline<TAB>url` for Horizon Europe calls with a future
deadline. Merge the results and drop duplicates. For the strongest candidates (up to 5), get budget
per grant, expected number of grants, type of action and scope in one call:

```bash
bash .claude/skills/academic-funding-search/scripts/eu_calls.sh --details HORIZON-CL3-2026-01-INFRA-01 HORIZON-NEB-2026-01-REGEN-02
```

Do not WebFetch topic URLs, which are JavaScript-only and return nothing. Do not call the API with
your own `curl` commands either: unattended runs only allow this helper.

**Wellcome Trust and British Academy**: these sometimes return HTTP 403 to WebFetch (British Academy
almost always). Try each **once**. If it is blocked, don't retry. List it under Sources Checked as
"Blocked (403) — check manually" with the URL, and do not invent schemes from memory. If Wellcome's
landing page loads, also try https://wellcome.org/research-funding/schemes for scheme detail.

**Detail pages**: for every opportunity scored High Fit, and any Medium Fit with Timing = Open,
WebFetch its scheme page to confirm amount, deadline and eligibility. Limit this to 15 detail
pages per run.

## Output Format

For each opportunity, extract:
- **Title**: Name of the funding call
- **Funder**: Organization name
- **Amount**: Funding range (e.g., "£100k-£500k", "Up to €1.5M")
- **Deadline**: Application closing date (exact date where available)
- **Eligibility**: Career stage, discipline, location requirements
- **Timing**: Open / Opening soon / Closed (see Matching Logic)
- **Change**: 🆕 New / ✏️ Changed / (blank if unchanged), relative to the previous report
- **URL**: Direct link to apply/details

**Each opportunity appears exactly once in the report**, in the section for its Fit level.
Never list the same scheme under two headings. If it fits several themes, say so in its row.

## Output File

### File Location
- **Directory**: `output/` (create if it doesn't exist)
- **Filename**: `funding_opportunities_YYYY-MM-DD.md` (use current date). Re-running on the same
  day overwrites that day's file. The comparison always uses the latest report from an
  earlier date.

### File Structure
```markdown
# Funding Opportunities Report

**Generated**: [Current date and time]
**Researcher**: [Name from CV]
**Institution**: [Institution from CV]
**Compared against**: [previous report filename, or "none (first run)"]

## Researcher Profile Summary
- Career Stage: [one of the five stages]
- Disciplines: [extracted]
- Research Keywords: [extracted]

## Changes Since Last Report
- 🆕 New: [titles]
- ✏️ Changed: [title: what changed, e.g. deadline moved, now open]
- ❌ Gone / closed since last report: [titles]

## High Fit
### Open now
[table, sorted by deadline, soonest first]
### Opening soon
[table, sorted by expected opening date]
### Closed — plan for next round
[table]

## Medium Fit
[same three sub-sections; omit empty ones]

## Low Fit
[table: Title | Funder | Why low]

## Recommended Priority Actions
[Numbered list of immediate actions with deadlines, drawn from Open now + Opening soon]

## Sources Checked
- [Each funding source with fetch status, pages fetched, and any gaps]

## Reference Discrepancies
- [Any place where the live page contradicts REFERENCE.md; omit if none]
```

### After Saving
- Confirm the file path to the user
- Give a brief summary: counts per Fit level, how many are open now, and how many are new

## Example Queries

- "Find funding opportunities for my CV at ./cv.pdf"
- "Search for grants matching my research profile"
- "What ERC grants am I eligible for?"
- "Find engineering fellowships for early career researchers"
- "Show me open UKRI opportunities in computer science"

## Matching Logic

Score **Fit** and **Timing** separately. Fit measures how well the call matches the researcher.
Timing measures whether they can apply now. A strong-fit call that is closed is still worth
reporting, but it goes under "Closed — plan for next round", not next to open calls.

### Fit
**High** if all of:
- Career stage matches eligibility exactly
- Discipline aligns with funder focus
- Research keywords overlap with call themes

**Medium** if:
- Career stage is adjacent (e.g., Mid-Career applying for an Established scheme), or
- Discipline is related but not exact, or
- Only some keyword overlap

**Low** if:
- Only geographic eligibility matches, or
- Broad calls with no specific discipline

**Excluded**: the researcher is ineligible (wrong career stage, restricted discipline, e.g.
Leverhulme Major Research Fellowships are humanities/social sciences only). List these under
Low Fit with the reason, so the user can see they were checked.

### Timing
- **Open now**: accepting applications and the deadline is in the future
- **Opening soon**: announced or expected to open within ~6 months
- **Closed**: deadline passed, paused, or the next round is not yet announced

A deadline earlier than today always means Closed, whatever the page's status label says.

## Changes Since Last Report

Match opportunities to the previous report by URL, or by title plus funder if the URL changed:
- 🆕 **New**: not in the previous report
- ✏️ **Changed**: deadline, amount, or Timing differs (say what changed)
- ❌ **Gone**: in the previous report but no longer found, or now Closed

If there is no previous report, write "First run — no comparison" in that section and leave the
Change column blank.

## Error Handling

- If a source is unavailable, report it and continue with others
- If CV cannot be parsed, ask user for manual profile input
- If no matches found, suggest broadening search criteria
