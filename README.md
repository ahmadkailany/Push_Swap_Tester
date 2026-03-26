# 🚀 Push_Swap Ultimate Tester v3.1 (2026)

<div align="center">

![Version](https://img.shields.io/badge/version-3.1-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Bash](https://img.shields.io/badge/bash-5.0%2B-orange.svg)

**Comprehensive testing suite for push_swap (2026) with method-specific testing, disorder metric, overflow checks, and performance analysis**

Created by [@akailany](https://github.com/ahmadkailany)

</div>

---

## ✨ Features

### 🎯 Core Testing
- ✅ **Comprehensive Error Testing**
  - Empty & whitespace handling
  - Invalid characters and signs
  - Integer overflow (INT_MAX/MIN)
  - **Long Long overflow (LLONG_MAX x2)**
  - Duplicate detection
  - Edge cases

- ✅ **Valid Input Testing**
  - Single numbers
  - Edge values (INT_MAX, INT_MIN)
  - Already sorted arrays
  - Different input formats
  - Negative numbers
  - Special cases

- ✅ **Performance Testing**
  - 3, 5, 100, and 500 number tests
  - Color-coded operation counts
  - Min/Max/Average statistics
  - Performance thresholds
  - **Disorder ratio displayed on every run**

### 🔥 Advanced Features

- 🎨 **Method-Specific Testing**
  - Test `--simple`, `--medium`, or `--complex` methods individually
  - Compare all 3 methods with `-extra` flag
  - Side-by-side performance analysis

- 📐 **Disorder Metric Testing** *(New in v3.1)*
  - Generate stacks with a **target disorder ratio** (0.0 → 1.0)
  - Measures and displays the **actual disorder** before sorting each test
  - Average actual disorder shown in final statistics
  - Combinable with `-extra`, `-simple`, `-medium`, `-complex` flags

- 📊 **Color-Coded Operation Limits**
  - 🟢 **EXCELLENT**: < 700 ops (100 nums) / < 5500 ops (500 nums)
  - 🔵 **GOOD**: < 1500 ops (100 nums) / < 8000 ops (500 nums)
  - 🟡 **PASS**: < 2000 ops (100 nums) / < 12000 ops (500 nums)
  - 🔴 **TOO MANY**: ≥ 2000 ops (100 nums) / ≥ 12000 ops (500 nums)

- 🧪 **Memory Leak Detection**
  - Automatic valgrind integration
  - Detailed leak reports

- 📈 **Customizable Testing**
  - Custom test sizes (e.g., `./test.sh 100 10`)
  - Adjustable shuffle counts
  - Flexible test modes

---

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ahmadkailany/Push_Swap_Tester.git
cd Push_Swap_Tester
```

### 2. Make the Script Executable

```bash
chmod +x test.sh
```

### 3. Setup Your Push_Swap

Copy the tester to your push_swap project directory:

```bash
cp test.sh /path/to/your/push_swap/
cd /path/to/your/push_swap/
```

### 4. Download checker_linux

Make sure you have `checker_linux` in your push_swap directory:

```bash
# Download from 42's resources or use your own checker
chmod +x checker_linux
```

---

## 🎮 Usage

### Basic Usage

```bash
# Run all standard tests
./test.sh

# Show help
./test.sh --help
```

### Custom Testing

```bash
# Test 100 numbers with 10 shuffles
./test.sh 100 10

# Test 500 numbers with 20 shuffles
./test.sh 500 20
```

### Method-Specific Testing

```bash
# Test only simple method
./test.sh -simple 100 10

# Test only medium method
./test.sh -medium 500 20

# Test only complex method
./test.sh -complex 100 15
```

### Extra Mode (All Methods)

```bash
# Test all 3 methods with same inputs
./test.sh -extra 100 10

# This will run:
# - 10 tests with --simple flag
# - 10 tests with --medium flag  
# - 10 tests with --complex flag
```

---

## 📐 Disorder Metric (`-d` / `--disorder`) *(New in v3.1)*

### What is Disorder?

Disorder is a number between **0.0** and **1.0** that measures how unsorted a stack is before any moves are made:

- `0.0` → already sorted (no inversions)
- `1.0` → worst possible order (every pair is inverted)
- `0.5` → roughly half the pairs are out of order

It is computed using the **inversion count formula**:

```
disorder = number of (i,j) pairs where i < j but a[i] > a[j]
           ─────────────────────────────────────────────────
                       total number of pairs
```

> This is the exact formula required by the push_swap subject (VI.3.2).

---

### Using the `-d` Flag

```bash
./test.sh -d <RATIO> [SIZE] [COUNT]
```

| Argument | Description |
|----------|-------------|
| `RATIO` | Target disorder between `0.0` and `1.0` |
| `SIZE` | Number of elements (default: 500) |
| `COUNT` | Number of test runs (default: 10) |

---

### Examples

```bash
# 500 numbers with ~0.5 disorder, 20 times (default method)
./test.sh -d 0.5 500 20

# 100 numbers with ~0.9 disorder (very messy), 5 times
./test.sh -d 0.9 100 5

# 500 nearly sorted numbers (low disorder), 10 times
./test.sh -d 0.1 500 10

# Already sorted input (disorder = 0)
./test.sh -d 0.0 500 10

# Worst case (maximum disorder)
./test.sh -d 1.0 500 10

# Combine with -extra to test all 3 methods
./test.sh -d 0.5 -extra 500 20

# Combine with a specific method
./test.sh -d 0.7 -complex 500 15
./test.sh -d 0.3 -simple 100 10
```

---

### Sample Output

```
╔══════════════════════════════════════════════════════════════╗
║  DISORDER TEST - size=500 disorder~0.5                     ║
╚══════════════════════════════════════════════════════════════╝

Running 20 disorder tests | size=500 | target disorder=0.5 [Default]...

✓ PASS Test  1/20: [5231 ops - ✓ GOOD]  [disorder: 0.4912]
✓ PASS Test  2/20: [5184 ops - ✓ GOOD]  [disorder: 0.5073]
✓ PASS Test  3/20: [5302 ops - ✓ GOOD]  [disorder: 0.4988]
...

Statistics for 500 numbers [disorder~0.5, Default]:
  Target disorder:     0.5
  Avg actual disorder: 0.4996
  Min ops:  5102
  Max ops:  5489
  Avg ops:  5247
```

> The **actual disorder** of each generated stack is always measured and printed so you can see exactly how messy the input was.

---

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-e, -extra` | Test all 3 methods (simple, medium, complex) |
| `-s, -simple` | Test only simple method |
| `-m, -medium` | Test only medium method |
| `-c, -complex` | Test only complex method |
| `-v, -verbose` | Show detailed output |
| `-d RATIO, --disorder RATIO` | **Test with a specific disorder ratio (0.0–1.0)** |

---

## 📊 Performance Thresholds

### For 100 Numbers:
| Operations | Grade | Color |
|------------|-------|-------|
| < 700 | ⭐ EXCELLENT | 🟢 Green |
| < 1500 | ✓ GOOD | 🔵 Cyan |
| < 2000 | ○ PASS | 🟡 Yellow |
| ≥ 2000 | ✗ TOO MANY | 🔴 Red |

### For 500 Numbers:
| Operations | Grade | Color |
|------------|-------|-------|
| < 5500 | ⭐ EXCELLENT | 🟢 Green |
| < 8000 | ✓ GOOD | 🔵 Cyan |
| < 12000 | ○ PASS | 🟡 Yellow |
| ≥ 12000 | ✗ TOO MANY | 🔴 Red |

---

## 🧪 Test Categories

### Error Tests
- Empty & whitespace
- Invalid characters
- Invalid signs
- Integer overflow (INT_MAX/MIN)
- **Long Long overflow (LLONG_MAX x2)**
- Duplicate detection

### Valid Tests
- No arguments
- Single numbers
- Edge values
- Already sorted
- 2, 3, 5, 10 numbers
- Different formats
- Negative numbers
- Special cases

### Performance Tests
- 3 numbers (≤ 3 ops)
- 5 numbers (≤ 12 ops)
- 100 numbers (≤ 2000 ops to pass)
- 500 numbers (≤ 12000 ops to pass)
- **Disorder ratio printed per run**

### Disorder Tests *(New in v3.1)*
- Target any disorder ratio from 0.0 to 1.0
- Actual disorder verified and displayed per run
- Statistics: target vs avg actual disorder
- Compatible with all method flags

### Stress Tests
- Large reversed sets
- Large sorted sets
- Random distributions

---

## 🎯 Examples

### Example 1: Quick Test
```bash
./test.sh
```
Runs all standard tests (error tests, valid tests, performance tests, stress tests)

### Example 2: Custom Performance Test
```bash
./test.sh 100 20
```
Tests 100 numbers with 20 different random shuffles

### Example 3: Compare Methods
```bash
./test.sh -extra 100 10
```
Compares simple, medium, and complex methods with same inputs

### Example 4: Test Specific Method
```bash
./test.sh -simple 500 15
```
Tests only the simple method with 500 numbers, 15 times

### Example 5: Disorder Test (v3.1)
```bash
./test.sh -d 0.5 500 20
```
Tests 500 numbers with a target disorder of 0.5, repeated 20 times

### Example 6: Disorder + All Methods
```bash
./test.sh -d 0.8 -extra 500 10
```
Runs all 3 methods on 500-number stacks with ~0.8 disorder, 10 times each

---

## 🛠️ Requirements

- **Bash**: 4.0 or higher
- **awk**: For disorder float calculation
- **push_swap**: Your compiled push_swap executable
- **checker_linux**: 42's checker program
- **valgrind** (optional): For memory leak detection
- **make**: For compilation

---

## 📸 Screenshot

```
    ___   __             _  __                    
   /   | / /______ _   (_)/ /_____ _   ____  __  __
  / /| |/ //_/ __ `/  / // // __ `/  / __ \/ / / /
 / ___ / ,< / /_/ /  / // // /_/ /  / / / / /_/ / 
/_/  |_/_/|_|\__,_/  /_//_/ \__,_/  /_/ /_/\__, /  
                                          /____/   

╔══════════════════════════════════════════════════════════════╗
║              PUSH_SWAP ULTIMATE TESTER v3.1              ║
║                    Created by akailany                    ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 🆕 Changelog

### v3.1 — Disorder Metric Update
- 📐 New `-d / --disorder` flag to test stacks with a specific disorder ratio
- 📊 `compute_disorder()` function implementing the exact subject formula (VI.3.2)
- 🔀 `generate_with_disorder()` to produce arrays with approximate target disorder
- 🟣 Actual disorder displayed per test in purple on **all** performance runs
- 📈 Statistics now include target disorder, avg actual disorder, min/max/avg ops
- 🔗 Disorder flag fully combinable with `-extra`, `-simple`, `-medium`, `-complex`
- 🏷️ Version bumped to **v3.1**

### v3.0
- ✨ Enhanced error testing with comprehensive overflow detection
- 🎯 Improved performance benchmarking with detailed statistics
- 🔧 Bug fixes and stability improvements
- 📊 Better output formatting and color-coded results
- 🧪 Additional edge case testing
- 🚀 Optimized test execution speed

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by various push_swap testers in the 42 community
- Thanks to all contributors and testers

---

## 📧 Contact

**Ahmad Kailany**
- 🌐 Website: [https://ahmadkailany.com/](https://ahmadkailany.com/)
- 🎓 42 Intra: [https://profile-v3.intra.42.fr/users/akailany](https://profile-v3.intra.42.fr/users/akailany)
- 💻 GitHub: [@ahmadkailany](https://github.com/ahmadkailany)

---

## ⚠️ Important Note

> **Disclaimer**: This tester is designed to help you test your push_swap project during development. While it covers many test cases and scenarios, it may contain bugs or edge cases that are not covered. **Do not rely on it 100%** - use it as a helpful tool, but always keep potential errors in mind and verify your results. The official evaluation may include additional test cases not covered by this tester. Test thoroughly and understand your implementation!

---

<div align="center">

**Made with ❤️ for the 42 community**

⭐ Star this repo if you find it helpful!

</div>
