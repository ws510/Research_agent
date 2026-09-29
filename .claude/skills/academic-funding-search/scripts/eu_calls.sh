#!/usr/bin/env bash
# Query Horizon Europe calls via the EU Funding & Tenders Portal search API.
# The portal (including topic pages) is JavaScript-rendered and the API only
# accepts POST, so WebFetch cannot reach either.
#
# Usage:
#   eu_calls.sh "keyword phrase" [page_size]
#       TSV rows — identifier, title, next deadline, url — for calls whose next
#       deadline is today or later (the API's own status flag is stale).
#   eu_calls.sh --details TOPIC-ID [TOPIC-ID ...]
#       Per topic: title, deadlines, type of action, budget per grant,
#       expected number of grants, and the first ~700 characters of scope.

set -euo pipefail

API="https://api.tech.ec.europa.eu/search-api/prod/rest/search?apiKey=SEDIA"

urlencode() {
  python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$1"
}

search() {
  local text="$1" size="$2"
  curl -sS --max-time 60 -X POST \
    "${API}&text=$(urlencode "$text")&pageSize=${size}&pageNumber=1" \
    -F 'query={"bool":{"must":[{"terms":{"type":["1","2","8"]}},{"terms":{"status":["31094501","31094502"]}},{"terms":{"frameworkProgramme":["43108390"]}}]}};type=application/json' \
    -F 'languages=["en"];type=application/json' |
  python3 -c '
import json, sys
from datetime import date

today = date.today().isoformat()
data = json.load(sys.stdin)
seen = set()
for r in data.get("results", []):
    m = r.get("metadata", {})
    ident = (m.get("identifier") or [""])[0]
    if not ident or ident in seen:
        continue
    upcoming = sorted(d[:10] for d in m.get("deadlineDate", []) if d[:10] >= today)
    if not upcoming:
        continue
    seen.add(ident)
    title = (m.get("title") or [""])[0]
    url = f"https://ec.europa.eu/info/funding-tenders/opportunities/portal/screen/opportunities/topic-details/{ident.lower()}"
    print(f"{ident}\t{title}\t{upcoming[0]}\t{url}")
'
}

details() {
  local id="$1"
  curl -sS --max-time 60 -X POST \
    "${API}&text=$(urlencode "\"$id\"")&pageSize=5&pageNumber=1" \
    -F 'languages=["en"];type=application/json' |
  python3 -c '
import html, json, re, sys

ident = sys.argv[1]
data = json.load(sys.stdin)
for r in data.get("results", []):
    m = r.get("metadata", {})
    if (m.get("identifier") or [""])[0] != ident:
        continue
    title = (m.get("title") or [""])[0]
    deadlines = ", ".join(d[:10] for d in m.get("deadlineDate", []))
    model = ", ".join(m.get("deadlineModel", []))
    action = ", ".join(m.get("typesOfAction", []))
    print(f"== {ident} | {title}")
    print(f"   deadlines: {deadlines} | model: {model} | action: {action}")
    try:
        overview = json.loads((m.get("budgetOverview") or ["{}"])[0])
        for actions in overview.get("budgetTopicActionMap", {}).values():
            for a in actions:
                if ident in a.get("action", ""):
                    lo, hi = a.get("minContribution"), a.get("maxContribution")
                    years, grants = a.get("budgetYearMap"), a.get("expectedGrants")
                    print(f"   budget/year: {years} | per grant: {lo}-{hi} EUR | expected grants: {grants}")
    except (ValueError, AttributeError):
        pass
    scope = html.unescape(re.sub("<[^>]+>", " ", (m.get("descriptionByte") or [""])[0]))
    scope = re.sub(r"\s+", " ", scope).strip()[:700]
    print(f"   scope: {scope}")
    print(f"   url: https://ec.europa.eu/info/funding-tenders/opportunities/portal/screen/opportunities/topic-details/{ident.lower()}")
    break
else:
    print(f"== {ident} | not found")
' "$id"
}

if [[ "${1:-}" == "--details" ]]; then
  shift
  [[ $# -gt 0 ]] || { echo "usage: eu_calls.sh --details TOPIC-ID [TOPIC-ID ...]" >&2; exit 1; }
  for id in "$@"; do details "$id"; done
else
  search "${1:?usage: eu_calls.sh \"keywords\" [page_size] | --details TOPIC-ID ...}" "${2:-50}"
fi
