#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORT=8080
COPY_TO_ELECTRON=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy-to-electron) COPY_TO_ELECTRON=1; shift ;;
    -p|--port) PORT="$2"; shift 2 ;;
    -h|--help)
      sed -n '1,200p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

echo "Serving frontend from $ROOT_DIR/docs on port $PORT"

if [ "$COPY_TO_ELECTRON" -eq 1 ]; then
  echo "Copying docs -> FlowDeerTreeElectron/src/site"
  mkdir -p "$ROOT_DIR/FlowDeerTreeElectron/src/site"
  rsync -a --delete "$ROOT_DIR/docs/" "$ROOT_DIR/FlowDeerTreeElectron/src/site/"
  echo "Copy complete"
fi

mkdir -p "$ROOT_DIR/logs"
nohup python3 -m http.server "$PORT" --directory "$ROOT_DIR/docs" > "$ROOT_DIR/logs/frontend.log" 2>&1 &
echo $! > "$ROOT_DIR/logs/frontend.pid"
echo "Frontend server started: http://localhost:$PORT/index.html"
echo "Logs: $ROOT_DIR/logs/frontend.log"
