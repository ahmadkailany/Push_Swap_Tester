# 🚀 Push_Swap Ultimate Tester v3.0

<div align="center">

![Version](https://img.shields.io/badge/version-3.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Bash](https://img.shields.io/badge/bash-5.0%2B-orange.svg)

**Comprehensive testing suite for push_swap with method-specific testing, overflow checks, and performance analysis**

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

### 🔥 Advanced Features

- 🎨 **Method-Specific Testing**
  - Test `--simple`, `--medium`, or `--complex` methods individually
  - Compare all 3 methods with `-extra` flag
  - Side-by-side performance analysis

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

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-e, -extra` | Test all 3 methods (simple, medium, complex) |
| `-s, -simple` | Test only simple method |
| `-m, -medium` | Test only medium method |
| `-c, -complex` | Test only complex method |
| `-v, -verbose` | Show detailed output (coming soon) |

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

---

## 🛠️ Requirements

- **Bash**: 4.0 or higher
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
║              PUSH_SWAP ULTIMATE TESTER v3.0              ║
║                    Created by akailany                    ║
╚══════════════════════════════════════════════════════════════╝
```

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
- GitHub: [@ahmadkailany](https://github.com/ahmadkailany)

---

<div align="center">

**Made with ❤️ for the 42 community**

⭐ Star this repo if you find it helpful!

</div>
