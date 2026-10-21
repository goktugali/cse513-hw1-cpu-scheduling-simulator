#!/bin/sh
# Runs the engine self-tests from index.html outside the browser (macOS JavaScriptCore via osascript).
# Usage: sh tests/run-tests.sh
set -e
cd "$(dirname "$0")/.."
tmp=$(mktemp -t engine-tests).js
sed -n '/===== ENGINE-BEGIN =====/,/===== ENGINE-END =====/p' index.html > "$tmp"
cat >> "$tmp" <<'JS'
;(function () {
  const results = runSelfTests();
  const lines = results.map((r) => (r.pass ? "PASS  " : "FAIL  ") + r.name + (r.pass ? "" : "\n      " + r.detail));
  const failed = results.filter((r) => !r.pass).length;
  lines.push("", (results.length - failed) + " / " + results.length + " tests passed");
  if (failed) throw new Error(lines.join("\n"));
  return lines.join("\n");
})();
JS
osascript -l JavaScript "$tmp"
rm -f "$tmp"
