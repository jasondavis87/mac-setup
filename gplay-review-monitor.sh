#!/bin/bash
# Cross-app Google Play review monitor + permanent archiver for Mobile Tech Media apps.
# Tracked in mac-setup; run by the local.gplay-reviews launchd agent (9am daily) or manually.
#
# WHY ARCHIVE: Google Play's Reviews API only returns TEXT reviews from ~the last 7 days.
# This script appends every review it sees (keyed by reviewId) to a permanent archive,
# so reviews are never lost once captured, and you only get alerted on NEW ones.
#
# Data (archive/seen/log) lives in ~/.gplay/ and is NOT tracked in git.

set -euo pipefail

# launchd runs with a minimal PATH; ensure Homebrew bins (gplay, jq) are found.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

APPS=(
  com.mobiletechmedia.matrix      # Focus Matrix Pro
  com.mobiletechmedia.rekal       # Rekal
  com.mobiletechmedia.crosspaste  # CrossPaste
  com.mobiletechmedia.realadai    # RealadAI
  app.mobiletechmedia.actionmind  # ActionMind
)

ARCHIVE="$HOME/.gplay/reviews-archive.jsonl"   # one JSON review per line, permanent
SEEN="$HOME/.gplay/reviews-seen.txt"           # reviewIds already archived
mkdir -p "$HOME/.gplay"
touch "$ARCHIVE" "$SEEN"

echo "=== Play Review Monitor — $(date '+%Y-%m-%d %H:%M') ==="
NEW_TOTAL=0
UNREPLIED_TOTAL=0

for PKG in "${APPS[@]}"; do
  JSON=$(gplay reviews list --package "$PKG" --paginate 2>/dev/null || echo 'null')
  COUNT=$(echo "$JSON" | jq '(.reviews // []) | length' 2>/dev/null || echo 0)

  if [ "$COUNT" -eq 0 ]; then
    echo "[$PKG] no text reviews in last 7 days"
    continue
  fi

  # Archive any review whose reviewId we haven't stored before.
  NEW_THIS_APP=0
  while IFS= read -r line; do
    RID=$(echo "$line" | jq -r '.reviewId')
    if ! grep -qxF "$RID" "$SEEN"; then
      echo "$line" | jq -c --arg pkg "$PKG" --arg seen "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '. + {_package:$pkg, _firstSeen:$seen}' >> "$ARCHIVE"
      echo "$RID" >> "$SEEN"
      NEW_THIS_APP=$((NEW_THIS_APP + 1))
    fi
  done < <(echo "$JSON" | jq -c '.reviews[]')
  NEW_TOTAL=$((NEW_TOTAL + NEW_THIS_APP))

  UNREPLIED=$(echo "$JSON" | jq '[.reviews[] | select([.comments[].developerComment] | map(select(. != null)) | length == 0)] | length')
  UNREPLIED_TOTAL=$((UNREPLIED_TOTAL + UNREPLIED))

  echo "[$PKG] $COUNT visible, $NEW_THIS_APP new-to-archive, $UNREPLIED unreplied"
  # Show unreplied reviews with reviewId + reply command.
  echo "$JSON" | jq -r --arg pkg "$PKG" '
    .reviews[]
    | select([.comments[].developerComment] | map(select(. != null)) | length == 0)
    | .comments[0].userComment as $u
    | "   ⭐\($u.starRating)  id=\(.reviewId)\n      \"\($u.text // "(no text)" | gsub("\n";" "))\"\n      reply: gplay reviews reply --package \($pkg) --review \(.reviewId) --text \"...\""
  '
done

echo ""
echo "New reviews archived this run: $NEW_TOTAL | Unreplied in window: $UNREPLIED_TOTAL"
echo "Archive: $ARCHIVE  ($(wc -l < "$ARCHIVE" | tr -d ' ') total captured)"
if [ "$UNREPLIED_TOTAL" -gt 0 ]; then
  echo "⚠️  Reply within 24-48h — see commands above."
fi
