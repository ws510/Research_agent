---
description: Search UK/EU academic funding opportunities matched to a CV
argument-hint: "[cv-path]  (default: the CV file in cv/)"
allowed-tools: Read, Glob, Edit(output/**), WebFetch, Skill(academic-funding-search), Bash(bash .claude/skills/academic-funding-search/scripts/eu_calls.sh:*)
---

# Funding Search Command

Search for academic funding opportunities matched to a researcher's CV.

## Arguments
- `$ARGUMENTS` - Path to CV file (default: the CV file in `cv/`)

## Instructions

Run the academic-funding-search skill with the provided CV path.

1. If no CV path provided in $ARGUMENTS, Glob `cv/*` (ignoring `cv/README.md`) and use the only
   CV file there. If there are none, stop and tell the user to add one. If there are several,
   stop and ask which to use; in a non-interactive run, list them and stop without searching
2. Invoke the `academic-funding-search` skill, passing the CV path from $ARGUMENTS
3. Save results to `output/funding_opportunities_YYYY-MM-DD.md`
4. Report summary of opportunities found, including what changed since the last report
