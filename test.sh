#!/usr/bin/env bash
set -e
source ./lib/assert.sh
cd "$(dirname "$0")"

# Ensure tput based color output works even in non-interactive environments
export TERM="${TERM:-xterm-256color}"
export WASIX_SYSROOT="${WASIX_SYSROOT:-/wasix-sysroot}"

available_tools=(
    "wasix-clang"
    "emscripten"
    "native-clang"
    "native-gcc"
)
selected_tools=()

disabled_tests=("minimal-threadlocal" "extern-threadlocal-nopic")
available_tests=()
enabled_tests=()

selected_tests=( )
use_only_selected_tests=false

for t in ./*/test.sh; do
    dir=$(dirname "$t")
    name=$(basename "$dir")
    available_tests+=("$name")
done

for name in "${available_tests[@]}"; do
    if [[ " ${disabled_tests[@]} " =~ " ${name} " ]]; then
        continue
    fi
    enabled_tests+=("$name")
done

for test in "$@"; do
    if [[ ${available_tools[@]} =~ $test  ]] ; then 
        selected_tools+=("$test")
        continue
    fi
    if [[ " ${available_tests[@]} " =~ " ${test} " ]]; then
        selected_tests+=("$test")
        continue
    fi
    echo "$test is not a test directory or a tool"
done

# use all tools if no specific tools are selected
if [[ ${#selected_tools[@]} -eq 0 ]]; then
    selected_tools=("${available_tools[@]}")
fi
if [[ ${#selected_tests[@]} -eq 0 ]]; then
    selected_tests=("${enabled_tests[@]}")
fi

# Number of test runs (per toolchain)
total_steps=$(( ${#selected_tests[@]} * ${#selected_tools[@]} ))
current_step=0

draw_progress() {
    local progress=$1 total=$2 width=40
    local filled=$(( progress * width / total ))
    local empty=$(( width - filled ))
    printf "\r[" >&2
    for i in $(seq 1 $((filled))); do
        printf '#' >&2
    done
    for i in $(seq 1 $((empty))); do
        printf ' ' >&2
    done
    printf "] %d/%d" "$progress" "$total" >&2
}

passed=0
failed=0
declare -a failed_tests
declare -a failed_logs

for tool in "${selected_tools[@]}"; do
    export PATH="$(pwd)/lib/wrappers:$PATH"
    export CC="${tool}" CXX="${tool}++" RUNNER="${tool}-runner"

    for test in "${selected_tests[@]}"; do
        testfile="./$test/test.sh"
        testdir=$(dirname "$testfile")
        testname=$(basename "$testdir")

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
        echo -e "${BOLD}${MAGENTA}--------${NORMAL}"
    done
    for i in "${!failed_tests[@]}"; do
        echo -e "${BOLD}${RED}failed: ${failed_tests[i]}${NORMAL}"
    done
    echo -e "${GREEN}✅ ${passed} passed${NORMAL} | ${RED}❌ ${failed} failed${NORMAL}"
fi

