summary=$(tail -n 1 test.log | sed -r 's/\x1b\[[0-9;]*m//g')
failed="$(grep -Po "failed: [a-zA-Z-]+ [(][a-zA-Z-]+[)]" test.log | sed -r 's/failed: /- /g')"
failed_details="$(cat test.log | sed -E 's/^/  /g' |  sed -E 's@  --- ([a-zA-Z-]+ [(][a-zA-Z-]+[)]) ---@* \1 <details><summary>Output</summary>\n  ```@' | sed -E 's@  --------@  ```\n  </details>@' | sed -n '/^  failed:.*/!p' | sed -n '/^  ✅/!p')"
numbers=($(echo "$summary" | grep -oE '[0-9]+'))
pass_count=${numbers[0]:-0}
fail_count=${numbers[1]:-0}
total=$((pass_count + fail_count))
emoji="✅"
if test 0 -ne "$fail_count"; then
    emoji="❌"
fi
cat <<EOF > pr_comment.txt
### Test Results ${emoji}

| Total | Passed | Failed |
|------:|------:|------:|
| $total | $pass_count | $fail_count |

EOF
if test 0 -ne "$fail_count"; then
cat <<EOF >> pr_comment.txt
### Failed Tests:

$failed_details
EOF
fi

cat pr_comment.txt >> "${GITHUB_STEP_SUMMARY}"