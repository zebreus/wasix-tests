#!/usr/bin/env bash
set -e
source ./lib/assert.sh
cd "$(dirname "$0")"

# Ensure tput based color output works even in non-interactive environments
export TERM="${TERM:-xterm-256color}"
export WASIX_SYSROOT="${WASIX_SYSROOT:-/wasix-sysroot}"

disabled_tests=("minimal-threadlocal" "extern-threadlocal-nopic")

# Gather list of enabled tests to calculate total progress steps
enabled_tests=()
for t in ./*/test.sh; do
    dir=$(dirname "$t")
    name=$(basename "$dir")
    if [[ " ${disabled_tests[@]} " =~ " ${name} " ]]; then
        continue
    fi
    enabled_tests+=("$name")
done

# Number of test runs (per toolchain)
total_steps=$(( ${#enabled_tests[@]} * 4 ))
current_step=0

draw_progress() {
    local progress=$1 total=$2 width=40
    local filled=$(( progress * width / total ))
    local empty=$(( width - filled ))
    printf "\r[" >&2
    printf '%0.s#' $(seq 1 $filled) >&2
    printf '%0.s ' $(seq 1 $empty) >&2
    printf "] %d/%d" "$progress" "$total" >&2
}

passed=0
failed=0
declare -a failed_tests
declare -a failed_logs

for tool in wasix-clang emscripten native-clang native-gcc; do
    export PATH="$(pwd)/lib/wrappers:$PATH"
    export CC="${tool}" CXX="${tool}++" RUNNER="${tool}-runner"

    for testfile in ./*/test.sh; do
        testdir=$(dirname "$testfile")
        testname=$(basename "$testdir")

        if [[ " ${disabled_tests[@]} " =~ " ${testname} " ]]; then
            continue
        fi

        ((current_step+=1))
        draw_progress "$current_step" "$total_steps"
        if output=$(bash "$testfile" 2>&1); then
            ((passed+=1))
        else
            ((failed+=1))
            failed_tests+=("$testname ($tool)")
            failed_logs+=("$output")
        fi
    done
done

echo >&2

if [[ $failed -eq 0 ]]; then
    echo -e "${GREEN}✅ ${passed} passed${NORMAL}"
else
    for i in "${!failed_tests[@]}"; do
        echo -e "${BOLD}${MAGENTA}--- ${failed_tests[i]} ---${NORMAL}"
        echo "${failed_logs[i]}"
    done
    for i in "${!failed_tests[@]}"; do
        echo -e "${BOLD}${RED}failed: ${failed_tests[i]}${NORMAL}"
    done
    echo -e "${GREEN}✅ ${passed} passed${NORMAL} | ${RED}❌ ${failed} failed${NORMAL}"
fi

