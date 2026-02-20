#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Counters
TOTAL=0
PASSED=0
FAILED=0
LEAKS=0

# Array to store failed tests
declare -a FAILED_TESTS

# Default values
CUSTOM_SIZE=0
CUSTOM_COUNT=10
EXTRA_MODE=0
TEST_SIMPLE=0
TEST_MEDIUM=0
TEST_COMPLEX=0
RUN_STANDARD_TESTS=1

# Usage function
show_usage() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           PUSH_SWAP ULTIMATE TESTER v3.0 - USAGE          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${WHITE}Usage:${NC}"
    echo -e "  ./test.sh [OPTIONS] [SIZE] [COUNT]"
    echo ""
    echo -e "${WHITE}OPTIONS:${NC}"
    echo -e "  ${GREEN}-h, --help${NC}          Show this help message"
    echo -e "  ${GREEN}-e, -extra${NC}          Test all 3 methods (simple, medium, complex)"
    echo -e "  ${GREEN}-s, -simple${NC}         Test only simple method (--simple flag)"
    echo -e "  ${GREEN}-m, -medium${NC}         Test only medium method (--medium flag)"
    echo -e "  ${GREEN}-c, -complex${NC}        Test only complex method (--complex flag)"
    echo -e "  ${GREEN}-v, -verbose${NC}        Show detailed output for each test"
    echo ""
    echo -e "${WHITE}ARGUMENTS:${NC}"
    echo -e "  ${CYAN}SIZE${NC}                Number of elements to test (e.g., 100, 500)"
    echo -e "  ${CYAN}COUNT${NC}               Number of shuffle tries (default: 10)"
    echo ""
    echo -e "${WHITE}EXAMPLES:${NC}"
    echo -e "  ${YELLOW}./test.sh${NC}                    # Run all standard tests"
    echo -e "  ${YELLOW}./test.sh 100 10${NC}            # Test 100 numbers, 10 times"
    echo -e "  ${YELLOW}./test.sh -extra 100 10${NC}     # Test all 3 methods with 100 numbers, 10 times each"
    echo -e "  ${YELLOW}./test.sh -simple 100 5${NC}     # Test only simple method with 100 numbers, 5 times"
    echo -e "  ${YELLOW}./test.sh -medium 500 20${NC}    # Test only medium method with 500 numbers, 20 times"
    echo -e "  ${YELLOW}./test.sh -complex 100 15${NC}   # Test only complex method with 100 numbers, 15 times"
    echo ""
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            ;;
        -e|-extra|--extra)
            EXTRA_MODE=1
            RUN_STANDARD_TESTS=0
            shift
            ;;
        -s|-simple|--simple)
            TEST_SIMPLE=1
            RUN_STANDARD_TESTS=0
            shift
            ;;
        -m|-medium|--medium)
            TEST_MEDIUM=1
            RUN_STANDARD_TESTS=0
            shift
            ;;
        -c|-complex|--complex)
            TEST_COMPLEX=1
            RUN_STANDARD_TESTS=0
            shift
            ;;
        -v|-verbose|--verbose)
            VERBOSE=1
            shift
            ;;
        [0-9]*)
            if [ $CUSTOM_SIZE -eq 0 ]; then
                CUSTOM_SIZE=$1
                RUN_STANDARD_TESTS=0
            else
                CUSTOM_COUNT=$1
            fi
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            ;;
    esac
done

# ASCII Art Header
print_header() {
    clear
    echo -e "${CYAN}"
    echo "    ___   __             _  __                    "
    echo "   /   | / /______ _   (_)/ /_____ _   ____  __  __"
    echo "  / /| |/ //_/ __ \`/  / // // __ \`/  / __ \/ / / /"
    echo " / ___ / ,< / /_/ /  / // // /_/ /  / / / / /_/ / "
    echo "/_/  |_/_/|_|\__,_/  /_//_/ \__,_/  /_/ /_/\__, /  "
    echo "                                          /____/   "
    echo -e "${NC}"
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}              PUSH_SWAP ULTIMATE TESTER v3.0              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${CYAN}                    Created by akailany                    ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Show mode info
    if [ $EXTRA_MODE -eq 1 ]; then
        echo -e "${YELLOW}${BOLD}Mode: Testing ALL METHODS (simple, medium, complex)${NC}"
        if [ $CUSTOM_SIZE -gt 0 ]; then
            echo -e "${YELLOW}Size: ${BOLD}$CUSTOM_SIZE${NC}${YELLOW} numbers × ${BOLD}$CUSTOM_COUNT${NC}${YELLOW} shuffles per method${NC}"
        fi
    elif [ $TEST_SIMPLE -eq 1 ]; then
        echo -e "${CYAN}${BOLD}Mode: Testing SIMPLE method only${NC}"
        if [ $CUSTOM_SIZE -gt 0 ]; then
            echo -e "${CYAN}Size: ${BOLD}$CUSTOM_SIZE${NC}${CYAN} numbers × ${BOLD}$CUSTOM_COUNT${NC}${CYAN} shuffles${NC}"
        fi
    elif [ $TEST_MEDIUM -eq 1 ]; then
        echo -e "${BLUE}${BOLD}Mode: Testing MEDIUM method only${NC}"
        if [ $CUSTOM_SIZE -gt 0 ]; then
            echo -e "${BLUE}Size: ${BOLD}$CUSTOM_SIZE${NC}${BLUE} numbers × ${BOLD}$CUSTOM_COUNT${NC}${BLUE} shuffles${NC}"
        fi
    elif [ $TEST_COMPLEX -eq 1 ]; then
        echo -e "${PURPLE}${BOLD}Mode: Testing COMPLEX method only${NC}"
        if [ $CUSTOM_SIZE -gt 0 ]; then
            echo -e "${PURPLE}Size: ${BOLD}$CUSTOM_SIZE${NC}${PURPLE} numbers × ${BOLD}$CUSTOM_COUNT${NC}${PURPLE} shuffles${NC}"
        fi
    elif [ $CUSTOM_SIZE -gt 0 ]; then
        echo -e "${YELLOW}Custom Mode: Testing ${BOLD}$CUSTOM_SIZE${NC}${YELLOW} numbers with ${BOLD}$CUSTOM_COUNT${NC}${YELLOW} shuffles${NC}"
    fi
    echo ""
}

# Print section header
print_section() {
    echo ""
    echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║${WHITE}  $1${BLUE}${NC}"
    echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Get performance color based on operation count
get_perf_color() {
    local size=$1
    local ops=$2
    
    case $size in
        3)
            if [ $ops -le 3 ]; then
                echo "$GREEN"
            elif [ $ops -le 5 ]; then
                echo "$YELLOW"
            else
                echo "$RED"
            fi
            ;;
        5)
            if [ $ops -le 12 ]; then
                echo "$GREEN"
            else
                echo "$RED"
            fi
            ;;
        100)
            if [ $ops -lt 700 ]; then
                echo "$GREEN"  # Excellent
            elif [ $ops -lt 1500 ]; then
                echo "$CYAN"   # Good
            elif [ $ops -lt 2000 ]; then
                echo "$YELLOW" # Pass
            else
                echo "$RED"    # Too many
            fi
            ;;
        500)
            if [ $ops -lt 5500 ]; then
                echo "$GREEN"  # Excellent
            elif [ $ops -lt 8000 ]; then
                echo "$CYAN"   # Good
            elif [ $ops -lt 12000 ]; then
                echo "$YELLOW" # Pass
            else
                echo "$RED"    # Too many
            fi
            ;;
        *)
            echo "$CYAN"
            ;;
    esac
}

# Get performance label
get_perf_label() {
    local size=$1
    local ops=$2
    
    case $size in
        100)
            if [ $ops -lt 700 ]; then
                echo "⭐ EXCELLENT"
            elif [ $ops -lt 1500 ]; then
                echo "✓ GOOD"
            elif [ $ops -lt 2000 ]; then
                echo "○ PASS"
            else
                echo "✗ TOO MANY"
            fi
            ;;
        500)
            if [ $ops -lt 5500 ]; then
                echo "⭐ EXCELLENT"
            elif [ $ops -lt 8000 ]; then
                echo "✓ GOOD"
            elif [ $ops -lt 12000 ]; then
                echo "○ PASS"
            else
                echo "✗ TOO MANY"
            fi
            ;;
        *)
            echo ""
            ;;
    esac
}

# Test function for error cases
run_error_test() {
    local test_name="$1"
    shift
    local args=("$@")
    
    TOTAL=$((TOTAL + 1))
    
    # Check for memory leaks
    if command -v valgrind &> /dev/null; then
        leak_output=$(valgrind --leak-check=full --error-exitcode=42 --log-fd=9 \
            ./push_swap "${args[@]}" 9>&1 1>/dev/null 2>&1)
        leak_status=$?
        if [ $leak_status -eq 42 ]; then
            LEAKS=$((LEAKS + 1))
            echo -e "${YELLOW}⚠ LEAK${NC} ${test_name}: ${RED}Memory leak detected!${NC}"
            FAILED_TESTS+=("${test_name} - Memory leak")
            return
        fi
    fi
    
    # Run push_swap and capture output
    output=$(./push_swap "${args[@]}" 2>&1)
    
    if echo "$output" | grep -q "Error"; then
        echo -e "${GREEN}✓ PASS${NC} ${test_name}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC} ${test_name}: Expected 'Error', got: '$output'"
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("${test_name} - Expected Error, got: $output")
    fi
}

# Test function for valid cases with method support
run_valid_test() {
    local test_name="$1"
    local expected_size=${2:-0}
    local method_flag=${3:-""}
    shift 3
    local args=("$@")
    
    TOTAL=$((TOTAL + 1))
    
    # Check for memory leaks
    if command -v valgrind &> /dev/null; then
        if [ -n "$method_flag" ]; then
            leak_output=$(valgrind --leak-check=full --error-exitcode=42 --log-fd=9 \
                ./push_swap $method_flag "${args[@]}" 9>&1 1>/dev/null 2>&1)
        else
            leak_output=$(valgrind --leak-check=full --error-exitcode=42 --log-fd=9 \
                ./push_swap "${args[@]}" 9>&1 1>/dev/null 2>&1)
        fi
        leak_status=$?
        if [ $leak_status -eq 42 ]; then
            LEAKS=$((LEAKS + 1))
            echo -e "${YELLOW}⚠ LEAK${NC} ${test_name}: ${RED}Memory leak detected!${NC}"
            FAILED_TESTS+=("${test_name} - Memory leak")
            return
        fi
    fi
    
    # Test with checker
    if [ -n "$method_flag" ]; then
        result=$(./push_swap $method_flag "${args[@]}" 2>/dev/null | ./checker_linux "${args[@]}" 2>&1)
        ops=$(./push_swap $method_flag "${args[@]}" 2>/dev/null | wc -l)
    else
        result=$(./push_swap "${args[@]}" 2>/dev/null | ./checker_linux "${args[@]}" 2>&1)
        ops=$(./push_swap "${args[@]}" 2>/dev/null | wc -l)
    fi
    
    # Get performance color and label
    perf_color=$(get_perf_color $expected_size $ops)
    perf_label=$(get_perf_label $expected_size $ops)
    
    # Add method info to test name
    local full_test_name="$test_name"
    if [ -n "$method_flag" ]; then
        full_test_name="$test_name ${CYAN}($method_flag)${NC}"
    fi
    
    if echo "$result" | grep -q "OK"; then
        if [ -n "$perf_label" ]; then
            echo -e "${GREEN}✓ PASS${NC} ${full_test_name} ${perf_color}[$ops ops - $perf_label]${NC}"
        else
            echo -e "${GREEN}✓ PASS${NC} ${full_test_name} ${CYAN}[$ops ops]${NC}"
        fi
        PASSED=$((PASSED + 1))
    elif echo "$result" | grep -q "KO"; then
        echo -e "${RED}✗ FAIL${NC} ${full_test_name}: Checker says KO"
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("${test_name} ($method_flag) - Checker returned KO")
    else
        echo -e "${RED}✗ FAIL${NC} ${full_test_name}: Unexpected result: $result"
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("${test_name} ($method_flag) - Unexpected result: $result")
    fi
}

# Performance test with enhanced output and method support
perf_test() {
    local size=$1
    local test_count=$2
    local method_flag=${3:-""}
    local method_name=${4:-"Default"}
    local total_ops=0
    local failed_in_perf=0
    local min_ops=999999
    local max_ops=0
    
    if [ -n "$method_flag" ]; then
        echo -e "${YELLOW}Running $test_count tests with $size numbers ${BOLD}[$method_name Method]${NC}${YELLOW}...${NC}"
    else
        echo -e "${YELLOW}Running $test_count tests with $size numbers...${NC}"
    fi
    echo ""
    
    for i in $(seq 1 $test_count); do
        ARG=$(seq 1 $size | sort -R | tr '\n' ' ')
        
        if [ -n "$method_flag" ]; then
            ops=$(./push_swap $method_flag $ARG 2>/dev/null | wc -l)
            result=$(./push_swap $method_flag $ARG 2>/dev/null | ./checker_linux $ARG 2>&1)
        else
            ops=$(./push_swap $ARG 2>/dev/null | wc -l)
            result=$(./push_swap $ARG 2>/dev/null | ./checker_linux $ARG 2>&1)
        fi
        
        total_ops=$((total_ops + ops))
        
        # Track min and max
        if [ $ops -lt $min_ops ]; then
            min_ops=$ops
        fi
        if [ $ops -gt $max_ops ]; then
            max_ops=$ops
        fi
        
        # Get performance color and label
        perf_color=$(get_perf_color $size $ops)
        perf_label=$(get_perf_label $size $ops)
        
        if ! echo "$result" | grep -q "OK"; then
            echo -e "${RED}✗ FAIL${NC} Test $i/$test_count ($size numbers) - checker says KO"
            FAILED=$((FAILED + 1))
            FAILED_TESTS+=("Performance test $i ($size numbers, $method_name) - Checker returned KO")
            failed_in_perf=1
        else
            if [ -n "$perf_label" ]; then
                echo -e "${GREEN}✓ PASS${NC} Test $i/$test_count: ${perf_color}[$ops ops - $perf_label]${NC}"
            else
                echo -e "${GREEN}✓ PASS${NC} Test $i/$test_count: ${CYAN}[$ops ops]${NC}"
            fi
            PASSED=$((PASSED + 1))
        fi
        TOTAL=$((TOTAL + 1))
    done
    
    echo ""
    avg_ops=$((total_ops / test_count))
    
    # Show statistics
    echo -e "${BOLD}${WHITE}Statistics for $size numbers${NC}${WHITE} [$method_name]:${NC}"
    echo -e "  Min ops:  ${CYAN}$min_ops${NC}"
    echo -e "  Max ops:  ${CYAN}$max_ops${NC}"
    echo -e "  Avg ops:  ${CYAN}$avg_ops${NC}"
    
    # Show performance thresholds for 100 and 500
    if [ $size -eq 100 ]; then
        echo ""
        echo -e "${BOLD}Performance Thresholds (100 numbers):${NC}"
        echo -e "  ${GREEN}< 700${NC}   : ⭐ EXCELLENT"
        echo -e "  ${CYAN}< 1500${NC}  : ✓ GOOD"
        echo -e "  ${YELLOW}< 2000${NC}  : ○ PASS"
        echo -e "  ${RED}>= 2000${NC} : ✗ TOO MANY"
    elif [ $size -eq 500 ]; then
        echo ""
        echo -e "${BOLD}Performance Thresholds (500 numbers):${NC}"
        echo -e "  ${GREEN}< 5500${NC}  : ⭐ EXCELLENT"
        echo -e "  ${CYAN}< 8000${NC}  : ✓ GOOD"
        echo -e "  ${YELLOW}< 12000${NC} : ○ PASS"
        echo -e "  ${RED}>= 12000${NC}: ✗ TOO MANY"
    fi
}

# Print failed tests summary
print_failed_tests() {
    if [ ${#FAILED_TESTS[@]} -gt 0 ]; then
        echo ""
        print_section "FAILED TESTS DETAILS"
        echo -e "${RED}${BOLD}The following tests failed:${NC}\n"
        for test in "${FAILED_TESTS[@]}"; do
            echo -e "${RED}  ✗${NC} $test"
        done
        echo ""
    fi
}

# Print summary
print_summary() {
    print_section "TEST SUMMARY"
    echo -e "${BOLD}${WHITE}Total Tests: ${CYAN}$TOTAL${NC}"
    echo -e "${BOLD}${GREEN}Passed: $PASSED${NC}"
    echo -e "${BOLD}${RED}Failed: $FAILED${NC}"
    
    if [ $LEAKS -gt 0 ]; then
        echo -e "${BOLD}${YELLOW}Memory Leaks: $LEAKS${NC}"
    fi
    
    print_failed_tests
    
    if [ $FAILED -eq 0 ] && [ $LEAKS -eq 0 ]; then
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${BOLD}${WHITE}                  🎉 ALL TESTS PASSED! 🎉                   ${GREEN}║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        exit 0
    elif [ $FAILED -eq 0 ]; then
        echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║${BOLD}${WHITE}         Tests passed but memory leaks detected! 🔧         ${YELLOW}║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
        exit 1
    else
        echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${BOLD}${WHITE}                   ❌ SOME TESTS FAILED ❌                  ${RED}║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
        exit 1
    fi
}

# Start tests
print_header

# Compile
print_section "COMPILATION"
echo -e "${YELLOW}Compiling push_swap...${NC}"
make re > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation successful${NC}"
else
    echo -e "${RED}✗ Compilation failed${NC}"
    exit 1
fi

# Handle custom/method-specific modes
if [ $CUSTOM_SIZE -gt 0 ] || [ $EXTRA_MODE -eq 1 ] || [ $TEST_SIMPLE -eq 1 ] || [ $TEST_MEDIUM -eq 1 ] || [ $TEST_COMPLEX -eq 1 ]; then
    
    # If no custom size specified for method tests, use default
    if [ $CUSTOM_SIZE -eq 0 ]; then
        CUSTOM_SIZE=100
    fi
    
    # Extra mode - test all 3 methods
    if [ $EXTRA_MODE -eq 1 ]; then
        print_section "PERFORMANCE TEST - SIMPLE METHOD"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "--simple" "Simple"
        
        print_section "PERFORMANCE TEST - MEDIUM METHOD"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "--medium" "Medium"
        
        print_section "PERFORMANCE TEST - COMPLEX METHOD"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "--complex" "Complex"
    fi
    
    # Individual method tests
    if [ $TEST_SIMPLE -eq 1 ]; then
        print_section "PERFORMANCE TEST - SIMPLE METHOD"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "--simple" "Simple"
    fi
    
    if [ $TEST_MEDIUM -eq 1 ]; then
        print_section "PERFORMANCE TEST - MEDIUM METHOD"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "--medium" "Medium"
    fi
    
    if [ $TEST_COMPLEX -eq 1 ]; then
        print_section "PERFORMANCE TEST - COMPLEX METHOD"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "--complex" "Complex"
    fi
    
    # If only size was specified without method flags, run default method
    if [ $EXTRA_MODE -eq 0 ] && [ $TEST_SIMPLE -eq 0 ] && [ $TEST_MEDIUM -eq 0 ] && [ $TEST_COMPLEX -eq 0 ]; then
        print_section "CUSTOM PERFORMANCE TEST - $CUSTOM_SIZE Numbers"
        perf_test $CUSTOM_SIZE $CUSTOM_COUNT "" "Default"
    fi
    
    print_summary
fi

# Standard mode - run all tests
if [ $RUN_STANDARD_TESTS -eq 1 ]; then
    # ============= ERROR TESTS =============
    print_section "ERROR TESTS - Empty & Whitespace"
    run_error_test "Empty string" ""
    run_error_test "Only spaces" "   "
    run_error_test "Only tabs" "	"
    run_error_test "Empty with valid numbers" 1 2 3 ""
    run_error_test "Multiple empty strings" "" "" ""

    print_section "ERROR TESTS - Invalid Characters"
    run_error_test "Letter in middle" 1 2 a 3
    run_error_test "Letter at end" 1 2 3a
    run_error_test "Letter at start" a1 2 3
    run_error_test "Only letters" abc def
    run_error_test "Special characters" 1 2 @ 3
    run_error_test "Plus attached to number" 1 2 3+4
    run_error_test "Minus attached to number" 1 2 3-4

    print_section "ERROR TESTS - Invalid Signs"
    run_error_test "Only plus sign" +
    run_error_test "Only minus sign" -
    run_error_test "Double plus" ++
    run_error_test "Double minus" --
    run_error_test "Plus minus" +-
    run_error_test "Minus plus" -+
    run_error_test "Double sign in number" 1 2 --3
    run_error_test "Plus at end" 42+
    run_error_test "Minus at end" 42-

    print_section "ERROR TESTS - Integer Overflow (INT_MAX/MIN)"
    run_error_test "INT_MAX + 1" 2147483648
    run_error_test "INT_MIN - 1" -2147483649
    run_error_test "INT_MAX + 1 with valid" 1 2147483648
    run_error_test "INT_MIN - 1 with valid" -2147483649 1
    run_error_test "Multiple overflow" 9999999999 8888888888

    print_section "ERROR TESTS - Long Long Overflow (LLONG_MAX x2)"
    run_error_test "LLONG_MAX" 9223372036854775807
    run_error_test "LLONG_MAX + 1" 9223372036854775808
    run_error_test "LLONG_MIN" -9223372036854775808
    run_error_test "LLONG_MIN - 1" -9223372036854775809
    run_error_test "Double LLONG_MAX" 18446744073709551615
    run_error_test "Beyond LLONG x2" 99999999999999999999
    run_error_test "20 digits positive" 12345678901234567890
    run_error_test "20 digits negative" -12345678901234567890
    run_error_test "Extreme overflow" 999999999999999999999999999999

    print_section "ERROR TESTS - Edge Cases with Overflow"
    run_error_test "Large positive" 999999999999
    run_error_test "Large negative" -999999999999
    run_error_test "Scientific notation attempt" 1e10
    run_error_test "Hex attempt" 0x7FFFFFFF
    run_error_test "Binary attempt" 0b1111

    print_section "ERROR TESTS - Duplicates"
    run_error_test "Simple duplicate" 1 2 3 2
    run_error_test "Adjacent duplicates" 5 5
    run_error_test "Three duplicates" 42 42 42
    run_error_test "Duplicate across args" "1 2" "2 3"
    run_error_test "Zero duplicates" 0 0
    run_error_test "Negative duplicates" -5 -5
    run_error_test "Many duplicates" 1 2 3 4 5 3

    # ============= VALID TESTS =============
    print_section "VALID TESTS - No Arguments"
    TOTAL=$((TOTAL + 1))
    output=$(./push_swap 2>&1)
    if [ -z "$output" ]; then
        echo -e "${GREEN}✓ PASS${NC} No arguments (no output)"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC} No arguments: Expected no output, got: '$output'"
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("No arguments - Expected no output, got: $output")
    fi

    print_section "VALID TESTS - Single Number"
    run_valid_test "Single positive" 0 "" 42
    run_valid_test "Single negative" 0 "" -42
    run_valid_test "Zero" 0 "" 0
    run_valid_test "Negative zero" 0 "" -0
    run_valid_test "Plus zero" 0 "" +0

    print_section "VALID TESTS - Edge Values"
    run_valid_test "INT_MAX" 0 "" 2147483647
    run_valid_test "INT_MIN" 0 "" -2147483648
    run_valid_test "INT_MAX and INT_MIN" 0 "" 2147483647 -2147483648
    run_valid_test "INT_MIN and INT_MAX" 0 "" -2147483648 2147483647
    run_valid_test "With plus sign" 0 "" +42
    run_valid_test "Multiple edge values" 0 "" 2147483647 0 -2147483648

    print_section "VALID TESTS - Already Sorted"
    run_valid_test "2 numbers sorted" 0 "" 1 2
    run_valid_test "3 numbers sorted" 0 "" 1 2 3
    run_valid_test "5 numbers sorted" 0 "" 1 2 3 4 5
    run_valid_test "10 numbers sorted" 0 "" 1 2 3 4 5 6 7 8 9 10
    run_valid_test "Negative sorted" 0 "" -5 -3 -1 0 1 3 5
    run_valid_test "String format sorted" 0 "" "1 2 3 4 5"

    print_section "VALID TESTS - 2 Numbers"
    run_valid_test "2 nums - reverse" 0 "" 2 1
    run_valid_test "2 nums - sorted" 0 "" 1 2
    run_valid_test "2 nums - negative" 0 "" -5 42
    run_valid_test "2 nums - extremes" 0 "" 100 -100
    run_valid_test "2 nums - with zero" 0 "" 0 1

    print_section "VALID TESTS - 3 Numbers"
    run_valid_test "3 nums - 2 1 3" 3 "" 2 1 3
    run_valid_test "3 nums - 3 2 1" 3 "" 3 2 1
    run_valid_test "3 nums - 1 3 2" 3 "" 1 3 2
    run_valid_test "3 nums - 3 1 2" 3 "" 3 1 2
    run_valid_test "3 nums - 2 3 1" 3 "" 2 3 1
    run_valid_test "3 nums - negatives" 3 "" -1 -3 -2

    print_section "VALID TESTS - 5 Numbers"
    run_valid_test "5 nums - reverse" 5 "" 5 4 3 2 1
    run_valid_test "5 nums - random 1" 5 "" 1 5 2 4 3
    run_valid_test "5 nums - random 2" 5 "" 5 1 3 4 2
    run_valid_test "5 nums - random 3" 5 "" 2 4 1 5 3
    run_valid_test "5 nums - with negatives" 5 "" -2 5 -1 3 0

    print_section "VALID TESTS - Different Formats"
    run_valid_test "Single string" 0 "" "5 4 3 2 1"
    run_valid_test "Mixed format 1" 0 "" "1 2" 3 "4 5"
    run_valid_test "Mixed format 2" 0 "" "1" "2" "3"
    run_valid_test "Multiple strings" 0 "" "1 2 3" "4 5 6"
    run_valid_test "Complex mix" 0 "" "5 4" 3 "2 1"

    print_section "VALID TESTS - Negative Numbers"
    run_valid_test "All negatives sorted" 0 "" -1 -2 -3
    run_valid_test "All negatives reverse" 0 "" -3 -2 -1
    run_valid_test "Mixed signs 1" 0 "" -5 0 5
    run_valid_test "Mixed signs 2" 0 "" 5 -5 0
    run_valid_test "Large negatives" 0 "" -100 -50 -1

    print_section "VALID TESTS - 10 Numbers"
    run_valid_test "10 nums - reverse" 0 "" 10 9 8 7 6 5 4 3 2 1
    run_valid_test "10 nums - sorted" 0 "" 1 2 3 4 5 6 7 8 9 10
    run_valid_test "10 nums - random" 0 "" 7 2 9 1 5 3 8 4 10 6

    print_section "VALID TESTS - Special Cases"
    run_valid_test "Single zero" 0 "" 0
    run_valid_test "Alternating" 0 "" 1 3 5 7 2 4 6 8
    run_valid_test "Descending then ascending" 0 "" 5 4 3 6 7 8
    run_valid_test "One out of place" 0 "" 1 2 5 3 4

    # ============= PERFORMANCE TESTS =============
    print_section "PERFORMANCE TESTS - 3 Numbers"
    perf_test 3 10

    print_section "PERFORMANCE TESTS - 5 Numbers"
    perf_test 5 10

    print_section "PERFORMANCE TESTS - 100 Numbers"
    perf_test 100 10

    print_section "PERFORMANCE TESTS - 500 Numbers"
    perf_test 500 10

    # ============= BONUS: STRESS TESTS =============
    print_section "STRESS TESTS - Edge Cases"
    ARG=$(seq 50 -1 1 | tr '\n' ' ')
    run_valid_test "Large set reverse" 0 "" $ARG

    ARG=$(seq 1 50 | tr '\n' ' ')
    run_valid_test "Large set sorted" 0 "" $ARG

    ARG=$(seq 1 20 | sort -R | tr '\n' ' ')
    run_valid_test "Random 20 numbers" 0 "" $ARG

    print_summary
fi
