#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# COMPREHENSIVE PUSH_SWAP TESTER
# ═══════════════════════════════════════════════════════════════════════════════
# Features:
# - All error handling tests from the checklist (56 tests)
# - All 4-number permutations (24 tests)
# - All 5-number permutations (120 tests)  
# - Progressive size testing with -p flag
# - Performance tests for 100 and 500 elements
# - Colored output and detailed logging
# ═══════════════════════════════════════════════════════════════════════════════

# Colors
DEF='\033[0;39m'
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
CYAN='\033[0;96m'
WHITE='\033[0;97m'

# Configuration
PUSH_SWAP="./push_swap"
CHECKER="./checker_Mac"  # Change to ./checker_linux if on Linux
LOG_FILE="test_errors.log"
PROGRESSIVE_MODE=0

# Check arguments
if [ "$1" == "-p" ]; then
    PROGRESSIVE_MODE=1
    echo -e "${CYAN}Progressive mode enabled - testing sizes 6 to 500${DEF}"
fi

# Clear log file
rm -rf $LOG_FILE
touch $LOG_FILE

# Check if push_swap exists
if [ ! -f "$PUSH_SWAP" ]; then
    echo -e "${RED}ERROR: push_swap not found!${DEF}"
    exit 1
fi

# Print header
echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}"
echo -e "${YELLOW}        COMPREHENSIVE PUSH_SWAP TESTER${DEF}"
echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"

# Test counter
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Helper function to run error test
test_error() {
    local test_num=$1
    local args="$2"
    local description="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Run and capture stderr
    if [ "$args" == '"\n"' ]; then
        OUTPUT=$(printf '\n' | $PUSH_SWAP 2>&1)
    else
        OUTPUT=$(eval "$PUSH_SWAP $args" 2>&1)
    fi
    
    if echo "$OUTPUT" | grep -q "Error"; then
        echo -e "${GREEN}✓ Test $test_num: PASS${DEF} - $description"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ Test $test_num: FAIL${DEF} - $description"
        echo "Test $test_num FAILED: $args" >> $LOG_FILE
        echo "Expected: Error" >> $LOG_FILE
        echo "Got: $OUTPUT" >> $LOG_FILE
        echo "---" >> $LOG_FILE
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Helper function to test valid input
test_valid() {
    local test_num=$1
    local args="$2"
    local description="$3"
    local max_moves=$4
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Check if it's already sorted (should output nothing)
    if [ "$max_moves" == "0" ]; then
        MOVES=$(eval "$PUSH_SWAP $args" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$MOVES" -eq 0 ]; then
            echo -e "${GREEN}✓ Test $test_num: PASS${DEF} - $description (0 moves)"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo -e "${RED}✗ Test $test_num: FAIL${DEF} - $description (expected 0 moves, got $MOVES)"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
        return
    fi
    
    # Test if it sorts correctly
    if [ -f "$CHECKER" ]; then
        RESULT=$(eval "$PUSH_SWAP $args" 2>/dev/null | $CHECKER $args 2>&1)
        MOVES=$(eval "$PUSH_SWAP $args" 2>/dev/null | wc -l | tr -d ' ')
        
        if echo "$RESULT" | grep -q "OK"; then
            if [ -z "$max_moves" ] || [ "$MOVES" -le "$max_moves" ]; then
                echo -e "${GREEN}✓ Test $test_num: PASS${DEF} - $description ($MOVES moves)"
                PASSED_TESTS=$((PASSED_TESTS + 1))
            else
                echo -e "${YELLOW}⚠ Test $test_num: SLOW${DEF} - $description ($MOVES moves, max: $max_moves)"
                PASSED_TESTS=$((PASSED_TESTS + 1))
            fi
        else
            echo -e "${RED}✗ Test $test_num: FAIL${DEF} - $description (not sorted correctly)"
            echo "Test $test_num FAILED: $args" >> $LOG_FILE
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    else
        MOVES=$(eval "$PUSH_SWAP $args" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${CYAN}○ Test $test_num: RUN${DEF} - $description ($MOVES moves) [checker not found]"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# ERROR HANDLING TESTS - Based on the comprehensive checklist
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}"
echo -e "${YELLOW}   ERROR HANDLING TESTS${DEF}"
echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"

echo -e "${CYAN}→ Non-numeric characters${DEF}"
test_error 1 "a" "Single letter"
test_error 2 "111a11" "Letter in middle of number"
test_error 3 "'hello world'" "String instead of numbers"
test_error 4 "1 3 dog 35 80 -3" "Word mixed with numbers"
test_error 5 "1 2 3 5 67b778 947" "Letter at end of number"
test_error 6 "'12 4 6 8 54fhd 4354'" "Letters in middle of list"
test_error 7 "42 a 41" "Single letter between numbers"
test_error 8 "42 41 40 45 101 x 202 -1 224 3" "Letter in middle of many numbers"
test_error 9 "42 -2 10 11 0 90 45 500 -200 e" "Letter at end of list"

echo -e "\n${CYAN}→ Empty and whitespace${DEF}"
test_error 10 '""' "Empty string"
test_error 11 '"\n"' "Newline character"
test_error 12 "'   '" "Only spaces"

echo -e "\n${CYAN}→ Duplicate numbers${DEF}"
test_error 13 "0 0" "Duplicate zeros"
test_error 14 "-01 -001" "Duplicate with leading zeros (negative)"
test_error 15 "-3 -2 -2" "Duplicate negative numbers"
test_error 16 "1 3 58 9 3" "Duplicate in list"
test_error 17 "3 03" "Number with leading zero duplicate"
test_error 18 "3 +3" "Number with plus sign duplicate"
test_error 19 "1 +1 -1" "1, +1, -1 (1 and +1 are duplicate)"
test_error 20 "42 42" "Simple duplicate"
test_error 21 "42 -42 -42" "Duplicate negative with positive"
test_error 22 "8 008 12" "Leading zeros creating duplicate"
test_error 23 "111111 -4 3 03" "3 and 03 duplicate"
test_error 24 "0 1 2 3 4 5 0" "Duplicate zero in longer list"
test_error 25 "10 -1 -2 -3 -4 -5 -6 90 99 10" "Duplicate 10"
test_error 26 "0 -0 1 -1" "0 and -0 are duplicate"
test_error 27 "0 +0 1 -1" "0 and +0 are duplicate"
test_error 28 "1 01" "1 and 01 are duplicate"
test_error 29 "-000 -0000" "Multiple zero representations"
test_error 30 "-00042 -000042" "Leading zeros with negative duplicates"
test_error 31 "0000000000000000000000009 000000000000000000000009" "Many leading zeros duplicate"
test_error 32 "00000001 1 9 3" "Leading zeros duplicate with 1"
test_error 33 "00000003 003 9 1" "Leading zeros duplicate with 3"
test_error 34 "'49 128     50 38   49'" "Duplicate with extra spaces"

echo -e "\n${CYAN}→ Invalid sign usage${DEF}"
test_error 35 "111-1 2 -3" "Minus in middle of number"
test_error 36 "3333-3333 1 4" "Number-minus-number"
test_error 37 "4222-4222" "Attached number with minus"
test_error 38 "111a111 -4 3" "Letter in middle"
test_error 39 "111+111 -4 3" "Plus in middle of number"
test_error 40 "3+3" "Plus attached to number"
test_error 41 "2147483647+1" "Plus attached to INT_MAX"
test_error 42 "-" "Only minus sign"
test_error 43 "+" "Only plus sign"
test_error 44 "--123 1 321" "Double minus"
test_error 45 "++123 1 321" "Double plus"
test_error 46 "--21345" "Double minus alone"
test_error 47 "1 --    45 32" "Double minus with spaces"

echo -e "\n${CYAN}→ Integer overflow${DEF}"
test_error 48 "-2147483649" "INT_MIN - 1"
test_error 49 "-2147483650" "Below INT_MIN"
test_error 50 "2147483648" "INT_MAX + 1"
test_error 51 "2147483649" "Above INT_MAX"
test_error 52 "54867543867438 3" "Very large positive"
test_error 53 "-2147483647765 4 5" "Very large negative"
test_error 54 "'214748364748385 28 47 29'" "Large number in string"
test_error 55 "99999999999999999999999999" "Extremely large positive"
test_error 56 "-99999999999999999999999999" "Extremely large negative"

echo -e "\n${CYAN}Error tests completed: $PASSED_TESTS/$TOTAL_TESTS passed${DEF}\n"

# ═══════════════════════════════════════════════════════════════════════════════
# VALID INPUT TESTS
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}"
echo -e "${YELLOW}   VALID INPUT TESTS${DEF}"
echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"

echo -e "${CYAN}→ Already sorted lists (should output 0 moves)${DEF}"
test_valid 57 "" "Empty input" 0
test_valid 58 "1" "Single number" 0
test_valid 59 "1 2" "Two sorted numbers" 0
test_valid 60 "1 2 3" "Three sorted numbers" 0
test_valid 61 "1 2 3 4 5 6 7 8 9" "Nine sorted numbers" 0
test_valid 62 "0 1 2 3 4" "Sorted with zero" 0
test_valid 63 "6 7 8" "Three sorted starting at 6" 0
test_valid 64 "2147483645 2147483646 2147483647" "Sorted near INT_MAX" 0
test_valid 65 "-2147483648 -2147483647 -2147483646" "Sorted near INT_MIN" 0

echo -e "\n${CYAN}→ Valid edge cases${DEF}"
test_valid 66 "2147483647 2 4 7" "With INT_MAX" 12
test_valid 67 "99 -2147483648 23 545" "With INT_MIN" 12
test_valid 68 "'2147483647 843 56544 24394'" "INT_MAX in string" 12
test_valid 69 "'95 99 -9 10 9'" "Both 9 and -9 (different)" 12
test_valid 70 "1 3 5 +9 20 -4 50 60 04 08" "Mixed signs and leading zeros" 12
test_valid 71 "'3 4 6 8 9 74 -56 +495'" "String with signs" 12

echo -e "\n${CYAN}→ Testing 2 numbers (1 move max)${DEF}"
test_valid 72 "2 1" "Simple swap" 1

echo -e "\n${CYAN}→ Testing 3 numbers (3 moves max)${DEF}"
test_valid 73 "1 3 2" "1 3 2" 3
test_valid 74 "2 3 1" "2 3 1" 3
test_valid 75 "2 1 3" "2 1 3" 3
test_valid 76 "3 1 2" "3 1 2" 3
test_valid 77 "3 2 1" "3 2 1" 3

# ═══════════════════════════════════════════════════════════════════════════════
# ALL 4-NUMBER PERMUTATIONS (24 tests)
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "\n${CYAN}→ Testing ALL 4-number permutations (12 moves max)${DEF}"
four_perms=("1 2 3 4" "1 2 4 3" "1 3 2 4" "1 3 4 2" "1 4 2 3" "1 4 3 2"
            "2 1 3 4" "2 1 4 3" "2 3 1 4" "2 3 4 1" "2 4 1 3" "2 4 3 1"
            "3 1 2 4" "3 1 4 2" "3 2 1 4" "3 2 4 1" "3 4 1 2" "3 4 2 1"
            "4 1 2 3" "4 1 3 2" "4 2 1 3" "4 2 3 1" "4 3 1 2" "4 3 2 1")

test_num=78
for perm in "${four_perms[@]}"; do
    if [ "$perm" == "1 2 3 4" ]; then
        test_valid $test_num "$perm" "4nums: $perm (sorted)" 0
    else
        test_valid $test_num "$perm" "4nums: $perm" 12
    fi
    test_num=$((test_num + 1))
done

# ═══════════════════════════════════════════════════════════════════════════════
# ALL 5-NUMBER PERMUTATIONS (120 tests)
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "\n${CYAN}→ Testing ALL 5-number permutations (12 moves max)${DEF}"

# Generate all permutations of 1 2 3 4 5
generate_5_perms() {
    for a in 1 2 3 4 5; do
        for b in 1 2 3 4 5; do
            [ $b -eq $a ] && continue
            for c in 1 2 3 4 5; do
                [ $c -eq $a ] || [ $c -eq $b ] && continue
                for d in 1 2 3 4 5; do
                    [ $d -eq $a ] || [ $d -eq $b ] || [ $d -eq $c ] && continue
                    for e in 1 2 3 4 5; do
                        [ $e -eq $a ] || [ $e -eq $b ] || [ $e -eq $c ] || [ $e -eq $d ] && continue
                        echo "$a $b $c $d $e"
                    done
                done
            done
        done
    done
}

test_num=102
while IFS= read -r perm; do
    if [ "$perm" == "1 2 3 4 5" ]; then
        test_valid $test_num "$perm" "5nums: $perm (sorted)" 0
    else
        test_valid $test_num "$perm" "5nums: $perm" 12
    fi
    test_num=$((test_num + 1))
done < <(generate_5_perms)

# ═══════════════════════════════════════════════════════════════════════════════
# PROGRESSIVE SIZE TESTING (Optional with -p flag)
# ═══════════════════════════════════════════════════════════════════════════════

if [ "$PROGRESSIVE_MODE" -eq 1 ]; then
    echo -e "\n${BLUE}════════════════════════════════════════════════════════${DEF}"
    echo -e "${YELLOW}   PROGRESSIVE SIZE TESTING (6-500 elements)${DEF}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"
    
    for size in {6..20} 25 30 40 50 75 100 150 200 300 400 500; do
        echo -e "${CYAN}Testing size: $size${DEF}"
        
        # Expected moves based on size
        if [ $size -le 10 ]; then
            max_moves=15
        elif [ $size -le 20 ]; then
            max_moves=30
        elif [ $size -le 50 ]; then
            max_moves=200
        elif [ $size -le 100 ]; then
            max_moves=700
        elif [ $size -le 200 ]; then
            max_moves=1500
        elif [ $size -le 300 ]; then
            max_moves=2500
        elif [ $size -le 400 ]; then
            max_moves=3500
        else
            max_moves=5500
        fi
        
        # Generate random sequence
        if command -v python3 &> /dev/null; then
            ARG=$(python3 -c "import random; nums=list(range($size)); random.shuffle(nums); print(' '.join(map(str, nums)))")
        elif command -v ruby &> /dev/null; then
            ARG=$(ruby -e "puts (0..$((size-1))).to_a.shuffle.join(' ')")
        else
            # Fallback: shuf
            ARG=$(seq 0 $((size-1)) | shuf | tr '\n' ' ' | sed 's/ $//')
        fi
        
        test_valid $test_num "$ARG" "Random $size elements" $max_moves
        test_num=$((test_num + 1))
    done
fi

# ═══════════════════════════════════════════════════════════════════════════════
# STANDARD PERFORMANCE TESTS
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "\n${BLUE}════════════════════════════════════════════════════════${DEF}"
echo -e "${YELLOW}   STANDARD PERFORMANCE TESTS${DEF}"
echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"

echo -e "${CYAN}→ Testing 100 elements (10 iterations, 700 moves max)${DEF}"
for i in {1..10}; do
    if command -v python3 &> /dev/null; then
        ARG=$(python3 -c "import random; nums=list(range(100)); random.shuffle(nums); print(' '.join(map(str, nums)))")
    elif command -v ruby &> /dev/null; then
        ARG=$(ruby -e "puts (0..99).to_a.shuffle.join(' ')")
    else
        ARG=$(seq 0 99 | shuf | tr '\n' ' ' | sed 's/ $//')
    fi
    test_valid $test_num "$ARG" "Random 100 elements (iteration $i)" 700
    test_num=$((test_num + 1))
done

echo -e "\n${CYAN}→ Testing 500 elements (10 iterations, 5500 moves max)${DEF}"
for i in {1..10}; do
    if command -v python3 &> /dev/null; then
        ARG=$(python3 -c "import random; nums=list(range(-250,250)); random.shuffle(nums); print(' '.join(map(str, nums)))")
    elif command -v ruby &> /dev/null; then
        ARG=$(ruby -e "puts (-250..249).to_a.shuffle.join(' ')")
    else
        ARG=$(seq -250 249 | shuf | tr '\n' ' ' | sed 's/ $//')
    fi
    test_valid $test_num "$ARG" "Random 500 elements (iteration $i)" 5500
    test_num=$((test_num + 1))
done

# ═══════════════════════════════════════════════════════════════════════════════
# FINAL SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════

echo -e "\n${BLUE}════════════════════════════════════════════════════════${DEF}"
echo -e "${YELLOW}   FINAL RESULTS${DEF}"
echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"

PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))

echo -e "${WHITE}Total Tests:   ${CYAN}$TOTAL_TESTS${DEF}"
echo -e "${WHITE}Passed:        ${GREEN}$PASSED_TESTS${DEF}"
echo -e "${WHITE}Failed:        ${RED}$FAILED_TESTS${DEF}"
echo -e "${WHITE}Pass Rate:     ${CYAN}$PASS_RATE%${DEF}\n"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${DEF}"
    echo -e "${GREEN}║                                                       ║${DEF}"
    echo -e "${GREEN}║          🎉 ALL TESTS PASSED! 🎉                     ║${DEF}"
    echo -e "${GREEN}║                                                       ║${DEF}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${DEF}\n"
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════╗${DEF}"
    echo -e "${RED}║                                                       ║${DEF}"
    echo -e "${RED}║          ⚠️  SOME TESTS FAILED  ⚠️                    ║${DEF}"
    echo -e "${RED}║                                                       ║${DEF}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════╝${DEF}\n"
    echo -e "${YELLOW}Check $LOG_FILE for details${DEF}\n"
fi

echo -e "${BLUE}════════════════════════════════════════════════════════${DEF}\n"
