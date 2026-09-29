# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Research agent project for searching UK and EU academic funding opportunities.

## Skills

### academic-funding-search

Location: `.claude/skills/academic-funding-search/`

Searches UK and EU academic funding opportunities personalized to a user's CV. Covers 8 funding sources:

**UK**: UKRI, Leverhulme Trust, British Academy, Wellcome Trust, Royal Academy of Engineering, Royal Society

**EU**: Horizon Europe (EU Funding Portal), European Research Council (ERC)

**Usage**: Provide a CV file path, and Claude will extract the researcher profile and match relevant funding opportunities, flagging changes since the last report.

**Output**: Results are saved to `output/funding_opportunities_YYYY-MM-DD.md`

## Claude Commands

### /funding-search

Run the academic funding search with a CV file.

```
/funding-search                    # Uses the CV file in cv/
/funding-search cv/other_cv.md     # Uses specified CV
```

## How It Works

The skill is **WebFetch-driven**: Claude fetches each funding source live, extracts the
researcher profile from the CV, and ranks opportunities by Fit and Timing. Each report is
compared against the previous one to flag new or changed calls.

The one exception is the EU Funding & Tenders Portal, which is JavaScript-rendered and whose
search API only accepts POST. `scripts/eu_calls.sh` queries it with curl and needs only `python3`
from the macOS base system. There are no Python packages to install.

## Shell Commands

```bash
# Run from command line (non-interactive)
claude -p "/funding-search cv/my_cv.md"
```

Non-interactive runs rely on the `allowed-tools` in `.claude/commands/funding-search.md`
(and the allow list in `.claude/settings.local.json`) to fetch pages, run the EU helper and
write to `output/` without prompting.

## Scheduling (macOS)

A launchd job template for a weekly run (Mondays 09:00) is in `scheduling/funding-search.plist.template`.
From the project root, fill in your paths and install it:

```bash
sed -e "s#__PROJECT_DIR__#$PWD#g" -e "s#__CLAUDE_BIN__#$(command -v claude)#g" \
  scheduling/funding-search.plist.template > ~/Library/LaunchAgents/local.funding-search.plist
launchctl load ~/Library/LaunchAgents/local.funding-search.plist
launchctl start local.funding-search      # test run now; log at output/schedule.log
```

launchd is used instead of cron because cron has a minimal PATH and struggles with the
space-containing OneDrive path. If the Mac is asleep at 09:00, launchd runs the job on wake.
To run in the cloud instead, use the `/schedule` skill.

## Architecture

```
.claude/
├── commands/
│   └── funding-search.md           # /funding-search command (+ allowed-tools)
└── skills/academic-funding-search/
    ├── SKILL.md                    # Skill instructions: workflow, matching, output
    ├── REFERENCE.md                # Funder details, career-stage/discipline maps, UKRI filter IDs
    └── scripts/
        └── eu_calls.sh             # Horizon Europe search via EU portal API

cv/                                 # Your CV (git-ignored; see cv/README.md)

output/                             # Generated funding reports (git-ignored)
└── funding_opportunities_YYYY-MM-DD.md

scheduling/
└── funding-search.plist.template   # launchd weekly job (paths filled in at install)
```
