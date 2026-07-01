# Agent Instructions for cocina-models

## cocina-jq — Build jq queries for Cocina Model JSON

Use this workflow when the user wants to query, filter, or transform a Cocina object (DRO, Collection, AdminPolicy) using jq.

### Step 1 — Check prerequisites

#### Check jq
Run `jq --version`. If jq is not installed, tell the user:
> `jq` is not installed. Install it with `brew install jq`, then retry.

Stop here if jq is missing.

#### Check parallel
Run `parallel --version`. If parallel is not installed, tell the user:
> `parallel` is not installed. Install it with `brew install parallel`, then retry.

#### Check pv
Run `pv --version`. If pv is not installed, tell the user:
> `pv` is not installed. Install it with `brew install pv`, then retry.

### Output format (always apply)

Every jq query produced by this skill **must output a CSV line** using `@csv`. The **first field must always be the external identifier** (`externalIdentifier`). Additional fields follow based on the user's query. By default, multiple values should be joined by " | ". Example:

```
"druid:bc123df4567","some value | another value"
```

Use `[.externalIdentifier, ...] | @csv` as the output expression. Apply this constraint automatically — do not ask the user whether to include the external identifier.

### Step 2 — Resume or collect inputs

First, ask the user:

> Do you want to resume an existing query?

**If yes:** Ask for the filename of the `.jq.txt` file (e.g., `contributor-name-uri-non-loc.jq.txt`). Read that file from the project root. The file header contains the original inputs as comments (query description, expected output description, example JSON, example output). Parse those comments to reconstruct the inputs. Confirm with the user that the loaded values look correct, then proceed to Step 3 with those inputs (skip re-asking for them).

**If no:** Ask the user for each input, one at a time:

1. **Query description** — what should the query do? (e.g., "extract all file labels from structural")
2. **Expected output description** — what additional values (beyond the external identifier) should appear in the output?
3. **Example Cocina object** — paste JSON directly
4. **Example output** — paste the exact expected CSV output (must start with the external identifier as the first field)

Explicitly ask for each input; do not infer or guess.

### Step 3 — Clarify ambiguities

Review the inputs from Step 2. If anything is unclear or underspecified, ask the user targeted questions before proceeding. Examples of things to clarify:

- Is the query meant to return one value per object, or aggregate across many objects?
- Should missing or null fields be skipped, returned as null, or cause an error?
- Are there edge cases in the data structure the query must handle (e.g., empty arrays, nested arrays, optional fields)?
- Is the output format exactly as shown, or is there flexibility (e.g., flat vs. nested)?

Ask only questions that would change how the query is written. Do not ask about things already clear from the inputs. If everything is unambiguous, skip this step silently and proceed.

### Step 4 — Load relevant schema portion

Read `schema.json` from the project root. Extract only the `$defs` entries relevant to the Cocina object type found in the example's `type` field:

- `https://cocina.sul.stanford.edu/models/object` → DRO-related defs
- `https://cocina.sul.stanford.edu/models/collection` → Collection-related defs
- `https://cocina.sul.stanford.edu/models/admin_policy` → AdminPolicy-related defs

Include only the defs actually referenced (follow `$ref` chains up to 2 levels deep). Do not load the entire schema.

### Step 5 — Generate and validate the query (up to 3 attempts)

**Attempt 1:** Use the schema excerpt, example JSON, query description, and expected output to write a jq query.

Run it:
```bash
echo '<example_json>' | jq '<query>'
```

Compare actual output to the example output. If it matches → proceed to Step 5.

**Attempt 2 (if attempt 1 fails):** Run `man jq` to load the jq manual. Use it to refine the query. Re-run and validate.

**Attempt 3 (if attempt 2 fails):** Make a final attempt using all context. Re-run and validate.

**After 3 failures:** Present the best attempt, explain what is wrong, and ask the user to clarify.

### Step 6 — Generate local HTML playground

Write `<slug>-playground.html` in the project root using the template below.

Substitute:
- Every occurrence of `SLUG` → the actual slug string
- `JSON_PLACEHOLDER` → the example JSON (pretty-printed) passed through `JSON.stringify` a second time, producing a valid JS string literal (e.g. `"{\"foo\":\"bar\"}"`)
- `QUERY_PLACEHOLDER` → the validated jq query passed through `JSON.stringify`, producing a valid JS string literal (e.g. `".foo"`)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>jq playground — SLUG</title>
  <style>
    body { font-family: monospace; margin: 2rem; background: #1e1e1e; color: #d4d4d4; }
    h2 { color: #9cdcfe; }
    textarea, input { width: 100%; box-sizing: border-box; background: #252526; color: #d4d4d4; border: 1px solid #444; padding: 8px; font-family: monospace; font-size: 13px; border-radius: 3px; }
    textarea { height: 260px; resize: vertical; }
    #query { height: 120px; }
    button { margin-top: 8px; background: #0e639c; color: white; border: none; padding: 8px 20px; cursor: pointer; font-size: 14px; border-radius: 3px; }
    button:hover { background: #1177bb; }
    label { display: block; margin-top: 16px; margin-bottom: 4px; font-size: 12px; color: #9cdcfe; text-transform: uppercase; letter-spacing: 0.05em; }
    #output { background: #252526; border: 1px solid #444; padding: 12px; min-height: 80px; white-space: pre-wrap; word-break: break-all; border-radius: 3px; }
    .error { color: #f44747; }
  </style>
</head>
<body>
  <h2>jq playground — SLUG</h2>
  <label>JSON Input</label>
  <textarea id="json"></textarea>
  <label>jq Filter</label>
  <textarea id="query"></textarea>
  <button onclick="run()">&#9654; Run</button>
  <label>Output</label>
  <pre id="output">(click Run)</pre>

  <script src="https://cdn.jsdelivr.net/npm/jq-web@0.5.1/jq.wasm.js"></script>
  <script>
    const INITIAL_JSON = JSON_PLACEHOLDER;
    const INITIAL_QUERY = QUERY_PLACEHOLDER;
    document.getElementById('json').value = JSON.stringify(JSON.parse(INITIAL_JSON), null, 2);
    document.getElementById('query').value = INITIAL_QUERY;

    function run() {
      const json = document.getElementById('json').value;
      const query = document.getElementById('query').value;
      const out = document.getElementById('output');
      out.className = '';
      out.textContent = 'Running…';
      jq.promised.raw(json, query)
        .then(r => { out.textContent = r || '(empty output)'; })
        .catch(e => { out.className = 'error'; out.textContent = String(e); });
    }
  </script>
</body>
</html>
```

### Step 7 — Write the query to a .jq.txt file

Generate a short kebab-case slug summarizing the query (e.g., `invalid-encoding`, `file-label-extract`). Write the file `<slug>.jq.txt` in the project root with the following structure:

1. A comment header containing the user's inputs:

```
# Query description: <query description from Step 2>
#
# Expected output: <expected output description from Step 2>
#
# Example input:
# <example Cocina JSON, each line prefixed with "# ">
#
# Example output:
# <example output CSV, each line prefixed with "# ">
```

2. A blank line, then the validated jq query.

The comment lines must use `#` so the file remains valid jq syntax. When resuming (Step 2 resume path), parse these comment sections by their labels to reconstruct the inputs.

Find the most recent `.jsonl.zst` file in the project root by listing `*.jsonl.zst` files sorted by name descending and taking the first result.

### Step 8 — Output

Present:
1. The jq query in a code block
2. A 1–3 sentence explanation of how it works
3. A markdown link to the local playground file using a `file://` URL (e.g. `[Open playground](file:///Users/someuser/data/sdr/cocina-models/<slug>-playground.html)`) — substitute the actual absolute path — plus the equivalent shell command (`open <slug>-playground.html`) for reference
4. A ready-to-run shell snippet:

```
zstdcat <most-recent .jsonl.zst filename> \
  | pv -l -s 5500000 \
  | parallel -j$(sysctl -n hw.logicalcpu) --pipe --block 50M --recend '\n' \
              jq -rcf <slug>.jq.txt \
  | bundle exec bin/enhance-report-csv \
  | tee <slug>.csv
```

Substitute the actual filenames — do not leave placeholders.

Also, remind the user to tunnel to Solr in a separate terminal with:
```
ssh -L 8990:sul-solr-prod-a.stanford.edu:80 lyberadmin@argo-prod-02.stanford.edu
```

### Step 9 — Iterate

After presenting step 7 output, prompt the user:

> Want to refine the query? You can describe a change (e.g., "also filter by `type`") or paste a modified jq expression directly.

**If the user describes a change:** Update the query to satisfy the new requirement, re-run against the example JSON (same validation loop as Step 5, up to 3 attempts), then repeat Steps 6–8 with the updated query and slug.

**If the user pastes a modified query directly:** Validate it by running against the example JSON. If it produces valid output, skip straight to repeating Steps 6–8. If it errors, diagnose and fix (up to 3 attempts), then repeat Steps 5–7.

**Each iteration overwrites the `.jq.txt` file and `<slug>-playground.html`** (same slug unless the query purpose changed significantly, in which case generate a new slug) **and replaces all previous outputs** with updated versions.

Continue offering to iterate after each round until the user is satisfied.
