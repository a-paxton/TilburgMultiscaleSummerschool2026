#!/usr/bin/env bash
#
# batch-commit-push.sh
# Commit & push ALL new (untracked) files to a GitHub repo in batches.
#
# Batches are sized by total bytes, not file count, so each push stays
# safely under GitHub's 2 GB push limit regardless of the file mix.
#
# Resumable: re-run any time. Already-committed files drop off the
# "untracked" list automatically, so an interrupted run just continues.
#
# Requires: git, bash 3.2+ (macOS default works), git-lfs only if USE_LFS=true.

set -euo pipefail

############################################
# CONFIG  — edit these
############################################
BRANCH="main"                 # branch to push to
MAX_BATCH_MB=1500             # ~1.5 GB of files per commit/push (keep < 2000)
MAX_BATCH_FILES=300           # also cap file count per batch
USE_LFS=true                  # track big binary types via Git LFS (recommended)
LFS_PATTERNS=( "*.mp4" "*.mov" "*.avi" "*.mkv" "*.wav" "*.zip" "*.tar.gz" "*.h5" "*.npy" )
############################################

cd "$(git rev-parse --show-toplevel)"   # move to repo root

MAX_BATCH_BYTES=$(( MAX_BATCH_MB * 1024 * 1024 ))
HARD_FILE_LIMIT=$(( 100 * 1024 * 1024 ))   # GitHub blocks single files > 100 MB (non-LFS)

# portable file size (GNU stat, fall back to BSD/macOS stat)
filesize() { stat -c%s "$1" 2>/dev/null || stat -f%z "$1"; }

# --- One-time Git LFS setup ---
if [ "$USE_LFS" = true ]; then
  if ! command -v git-lfs >/dev/null 2>&1; then
    echo "ERROR: git-lfs not installed (macOS: brew install git-lfs / Ubuntu: sudo apt install git-lfs)" >&2
    exit 1
  fi
  git lfs install
  changed=false
  for pat in "${LFS_PATTERNS[@]}"; do
    if ! grep -qF "$pat" .gitattributes 2>/dev/null; then
      git lfs track "$pat"; changed=true
    fi
  done
  if [ "$changed" = true ]; then
    git add .gitattributes
    git commit -m "Configure Git LFS tracking"
    git push origin "$BRANCH"
  fi
fi

# --- Flush any commits left unpushed by a previous interrupted run ---
git push origin "$BRANCH" || true

# --- Collect all new (untracked, non-ignored) files; null-safe for odd names ---
echo "Scanning for new files ..."
NEW_FILES=()
while IFS= read -r -d '' f; do
  NEW_FILES+=("$f")
done < <(git ls-files --others --exclude-standard -z)

if [ "${#NEW_FILES[@]}" -eq 0 ]; then
  echo "No new files to commit."
  exit 0
fi
echo "Found ${#NEW_FILES[@]} new files."

# --- Safety: catch >100 MB files that AREN'T covered by LFS (they'd be rejected) ---
if [ "$USE_LFS" = true ]; then
  uncovered=()
  for f in "${NEW_FILES[@]}"; do
    if [ "$(filesize "$f")" -gt "$HARD_FILE_LIMIT" ] && ! git check-attr filter -- "$f" | grep -q 'filter: lfs'; then
      uncovered+=("$f")
    fi
  done
  if [ "${#uncovered[@]}" -gt 0 ]; then
    echo "WARNING: these files are > 100 MB and NOT tracked by LFS — GitHub will reject the push:" >&2
    printf '  %s\n' "${uncovered[@]}" >&2
    echo "Add their extensions to LFS_PATTERNS and re-run." >&2
    exit 1
  fi
fi

# --- Commit & push in size-bounded batches ---
batch=(); batch_bytes=0; batch_num=0; done_count=0

flush_batch() {
  [ "${#batch[@]}" -eq 0 ] && return
  batch_num=$(( batch_num + 1 ))
  echo ""
  echo "=== Batch $batch_num : ${#batch[@]} files, ~$(( batch_bytes / 1024 / 1024 )) MB ==="
  for f in "${batch[@]}"; do git add -- "$f"; done
  git commit -m "Add batch $batch_num (${#batch[@]} files)"
  git push origin "$BRANCH"
  done_count=$(( done_count + ${#batch[@]} ))
  batch=(); batch_bytes=0
}

for f in "${NEW_FILES[@]}"; do
  sz=$(filesize "$f")
  if [ "${#batch[@]}" -gt 0 ] && { [ $(( batch_bytes + sz )) -gt "$MAX_BATCH_BYTES" ] || [ "${#batch[@]}" -ge "$MAX_BATCH_FILES" ]; }; then
    flush_batch
  fi
  batch+=("$f"); batch_bytes=$(( batch_bytes + sz ))
done
flush_batch

echo ""
echo "Finished: committed & pushed $done_count files across $batch_num batches."