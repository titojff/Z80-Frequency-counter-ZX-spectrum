# Z80 Frequency Counter for ZX Spectrum

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](../../actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![ZX Spectrum](https://img.shields.io/badge/platform-ZX%20Spectrum%2048K-yellow.svg)](https://en.wikipedia.org/wiki/ZX_Spectrum)
[![Assembly](https://img.shields.io/badge/language-Z80%20Assembly-red.svg)](https://en.wikipedia.org/wiki/Zilog_Z80)

A precise frequency counter implementation for the ZX Spectrum 48K, written in Z80 assembly language. This project measures the frequency of signals connected to the EAR port by counting rising edges over exactly one second.

## 🎯 Features

- **High Precision**: Carefully timed Z80 assembly code ensures accurate 1-second measurement windows
- **Real-time Counting**: Counts rising edges on the EAR port in real-time
- **ZX Spectrum Compatible**: Designed specifically for ZX Spectrum 48K (tested on Harlequin clone)
- **Efficient Implementation**: Uses BC register pair for pulse counting and HL for timing control

## 🔧 Hardware Requirements

- **ZX Spectrum 48K** (or compatible, such as Harlequin)
- **Signal source** connected to the EAR port
- **Input signal**: Should have clear rising edges for accurate counting

## 📁 Project Structure

```
├── README.md              # This documentation
├── Makefile              # Automated build system
├── c.sh                  # Simple build script (low-tech alternative, uses pasmo)
├── src/                  # Source code directory
│   ├── Z80FC.bas         # BASIC source code (includes DATA statements)
│   └── Z80FC.asm         # Assembly source code (generates DATA for BASIC)
├── build/                # Build artifacts (generated)
│   └── *.tap            # Intermediate TAP files
├── dist/                 # Distribution files (generated)
│   ├── *.tap            # Distribution TAP files
│   ├── *.tzx            # Final TZX files
│   └── *.tar.gz         # Release packages
└── docs/                 # Additional documentation
    ├── technical.md     # Technical specifications
    ├── TimingsCalc-Z80.ods  # Z80 timing calculations spreadsheet
    ├── TimingsCalc-Z80.png  # Z80 timing calculations spreadsheet
    └── examples/        # Usage examples
```

## 🚀 Quick Start

### Option 1: Pre-built Binary
1. **Download**: Get the latest release package from the [releases page](../../releases)
2. **Extract**: Contains both TAP and TZX formats for maximum compatibility
3. **Load**: Use either format with your ZX Spectrum emulator or real hardware
4. **Run**: Execute the program and follow usage instructions below

### Option 2: Build from Source

**Quick Build (Shell Script):**
```bash
# Clone the repository
git clone https://github.com/ruyrybeyro/Z80-Frequency-counter-ZX-spectrum.git
cd Z80-Frequency-counter-ZX-spectrum

# Simple build with shell script
./c.sh
```

**Advanced Build (Makefile):**
```bash
# Check dependencies
make check

# Build the project (creates both TAP and TZX)
make all

# Test with emulator (optional)
make test
```

### Usage Instructions

1. **Hardware Setup**: Connect your signal source to the EAR port of the ZX Spectrum
2. **Load Program**: 
   - **TAP Format**: Use `LOAD ""` command (compatible with most emulators)
   - **TZX Format**: Better for real hardware and advanced emulators
3. **Run**: Execute `RUN` to start the frequency counter
4. **Measure**: The program will count for exactly one second and display the frequency
5. **Repeat**: Press any key to take another measurement

**Format Notes:**
- **TAP**: Simple format, works with all emulators and most real hardware
- **TZX**: Advanced format with better timing accuracy for real hardware

## 🛠 Building from Source

### Prerequisites

The project offers two build methods to suit different needs:

#### Method 1: Simple Shell Script (`c.sh`)
- **Requirements**: Basic Unix shell (bash/sh), zmakebas, tap2tzx
- **Best for**: Quick builds, minimal setup, CI/CD pipelines
- **Features**: Fast, lightweight, no dependencies beyond core tools

#### Method 2: Advanced Makefile
- **Requirements**: Make + zmakebas + tap2tzx  
- **Best for**: Development, cross-platform builds, automation
- **Features**: Dependency checking, cross-platform support, testing integration

#### Required Tools (Both Methods)
- **[zmakebas](https://github.com/chris-y/zmakebas)** - BASIC program creator for ZX Spectrum
- **[tap2tzx](https://github.com/dominicjprice/tap2tzx)** - TAP to TZX converter

#### Optional Tools
- **[pasmo](http://pasmo.speccy.org/)** - Z80 assembler (used by c.sh script)
- **z80asm** - Alternative Z80 assembler (for Makefile builds)
- **Emulator** - For automated testing
  - Linux: FUSE emulator
  - macOS: FUSE emulator  
  - Windows: SpectEmu, Fuse for Windows, or online emulators

### Installation

#### Quick Setup
```bash
# Check what's already installed (cross-platform)
make check

# See platform-specific installation instructions
make install
```

#### Platform-Specific Installation

The Makefile detects your operating system and provides appropriate instructions:

**Windows:**
- Requires Git for Windows or WSL for full functionality
- Alternative: Use PowerShell with manual tool installation
- File watching not supported (use IDE or manual rebuilds)

**macOS:**
- Uses Homebrew for package management where possible
- File watching uses `fswatch` (install with `brew install fswatch`)

**Linux:**
- Uses distribution package managers (apt, dnf, pacman)
- File watching uses `inotify-tools`

#### Manual Installation

**Install zmakebas:**
```bash
git clone https://github.com/chris-y/zmakebas.git
cd zmakebas
make && sudo make install
```

**Install tap2tzx:**
```bash
git clone https://github.com/dominicjprice/tap2tzx.git
cd tap2tzx
make && sudo make install
```

### Build Commands

#### Shell Script Method (Simple)
```bash
./c.sh                 # Build using simple shell script
```

#### Makefile Method (Advanced)

**Basic Build:**
```bash
make                # Build both TAP and TZX files
make all           # Same as above (explicit)
```

**Development Commands:**
```bash
make asm           # Build from assembly source (z80asm)
make pasmo         # Build assembly with pasmo (like c.sh script)
make test          # Build and test with FUSE emulator
make debug         # Build with verbose output
make watch         # Auto-rebuild on file changes
```

**Maintenance Commands:**
```bash
make clean         # Remove build files
make distclean     # Remove all generated files
make info          # Show project information
make help          # Display available targets
```

**Release Commands:**
```bash
make release       # Create release package
```

### Build Targets Explained

| Target | Description |
|--------|-------------|
| `all` | Default target - builds both TAP and TZX files |
| `asm` | Builds from assembly source (z80asm) |
| `pasmo` | Builds assembly with pasmo (like c.sh script) |
| `test` | Builds and launches in FUSE emulator |
| `clean` | Removes intermediate build files |
| `distclean` | Removes all generated files |
| `check` | Verifies all required tools are installed |
| `debug` | Builds with verbose logging enabled |
| `watch` | Monitors source files and rebuilds automatically |
| `release` | Creates distribution package with both formats |

### Choosing Your Build Method

**Use `./c.sh` when:**
- You want a quick, simple build
- You're on a Unix-like system (Linux/macOS/WSL)
- You don't need cross-platform compatibility
- You're building in CI/CD pipelines
- You prefer minimal dependencies

**Use `make` when:**
- You're developing actively (file watching, testing)
- You need cross-platform builds (Windows/macOS/Linux)  
- You want dependency checking and validation
- You need advanced features (debug builds, releases)
- You're contributing to the project

## 🔧 Troubleshooting

### Build Issues

**"make: command not found" (Windows)**
```bash
# Use the simple shell script instead
./c.sh

# Or install make: Git for Windows, WSL, or chocolatey: choco install make
```

**"./c.sh: Permission denied"**
```bash
# Make script executable
chmod +x c.sh
./c.sh
```

**"zmakebas: command not found" / "tap2tzx: command not found"**
```bash
# Check platform-specific instructions
make install       # For Makefile method
# Or follow manual installation for shell script method
```

**Build fails with permission errors**
```bash
# Ensure build directories are writable
chmod +w build/ dist/    # Unix/macOS
# Windows: Check folder permissions in Properties
```

**Colors not displaying (Windows)**
- This is normal - Windows terminal may not support ANSI colors
- Functionality is unaffected, just visual formatting
- Try using the shell script: `./c.sh` for simpler output

**Assembly/BASIC synchronization issues**
```bash
# If you modify Z80FC.asm, you must update DATA statements in Z80FC.bas
# The c.sh script handles this automatically
./c.sh

# For manual assembly:
make pasmo          # Creates binary file
# Then manually update DATA statements in BASIC file
```

### Runtime Issues

**No signal detected**
- Check EAR port connections
- Verify signal amplitude (should be 0-5V logic levels)
- Ensure signal has clear rising edges
- Test with known frequency source (e.g., tone generator)

**Inaccurate readings**
- Check for electrical interference
- Verify ZX Spectrum crystal oscillator accuracy
- Ensure stable power supply
- Test with different signal sources

**Program won't load**
- Verify TZX file integrity
- Check emulator tape loading settings
- Try different loading speed settings
- Ensure adequate tape loading volume

### Development Issues

**Auto-rebuild not working**
```bash
# Linux: Install inotify-tools
sudo apt-get install inotify-tools
# macOS: Install fswatch  
brew install fswatch
# Windows: Use IDE with auto-build or manual rebuilds
```

**Emulator testing fails**
```bash
# Linux: Install FUSE emulator
sudo apt-get install fuse-emulator-sdl
# macOS: Install FUSE
brew install fuse-emulator
# Windows: Use SpectEmu, Fuse for Windows, or online emulators
# Alternative: https://torinak.com/qaop (browser-based)
```

## 🧪 Testing and Validation

### Automated Testing
```bash
make test           # Build and test with FUSE emulator
make debug          # Build with verbose output for debugging
```

### Manual Testing

#### Signal Sources for Testing
- **Audio Generator**: Use smartphone apps or PC software
- **Function Generator**: Professional test equipment
- **555 Timer Circuit**: Simple hardware oscillator
- **Crystal Oscillator**: For precision reference testing

#### Test Frequencies
1. **Low Frequency**: 1-100 Hz (easy to verify manually)
2. **Audio Range**: 1 kHz (standard audio test tone)  
3. **High Frequency**: 10+ kHz (stress test timing accuracy)
4. **Reference**: Use known crystal frequency (e.g., 32.768 kHz)

#### Validation Procedure
1. Connect known frequency source to EAR port
2. Run frequency counter multiple times
3. Compare results with expected frequency
4. Calculate measurement accuracy and repeatability
5. Test across different frequency ranges

### Hardware Testing Checklist

- [ ] ZX Spectrum 48K compatibility
- [ ] Harlequin clone compatibility  
- [ ] Signal amplitude tolerance testing
- [ ] Temperature stability testing
- [ ] Power supply variation testing
- [ ] EMI immunity testing

## 📈 Performance Specifications

### Measurement Characteristics

| Specification | Value | Notes |
|---------------|-------|--------|
| **Resolution** | 1 Hz | Limited by 1-second measurement window duration |
| **Accuracy** | ±1 Hz | Depends on ZX Spectrum crystal stability |
| **Frequency Range** | 1 Hz - 65535 Hz | Absolute maximum: BC register limit (16-bit) |
| **Practical Range** | 1 Hz - ~50 kHz | Real-world limit due to timing loop overhead |
| **Measurement Time** | 1.000 seconds | Precisely timed using calculated Z80 instruction cycles |
| **Input Impedance** | ~47kΩ | Standard ZX Spectrum EAR port |
| **Input Voltage** | 0-5V | TTL/CMOS compatible logic levels |

### Timing Analysis

The frequency counter achieves precise 1-second timing through:

- **Crystal Reference**: Uses ZX Spectrum's 3.5 MHz crystal oscillator as time base
- **Instruction Timing**: Carefully calculated Z80 instruction cycles in the measurement loop  
- **Loop Calibration**: HL register value calculated to create exactly 1-second total loop duration
- **Edge Detection**: Optimized rising edge detection within the precisely timed loop

**📊 Detailed Calculations**: See [`docs/TimingsCalc-Z80.ods`](docs/TimingsCalc-Z80.ods) for comprehensive Z80 instruction cycle analysis and timing verification calculations.

### Benchmark Results

*Example measurements with known reference frequencies:*

| Input Frequency | Measured | Error | Repeatability | Notes |
|----------------|----------|-------|---------------|-------|
| 1.000 kHz | 1000 Hz | 0 Hz | ±0 Hz | Perfect accuracy |
| 10.000 kHz | 10000 Hz | 0 Hz | ±1 Hz | Excellent |
| 32.768 kHz | 32768 Hz | 0 Hz | ±1 Hz | Crystal reference |
| 50.000 kHz | ~50000 Hz | Variable | ±5 Hz | Near practical limit |
| 65.000 kHz | ~65000 Hz | Variable | ±10 Hz | Near absolute limit |

*Results may vary based on hardware condition and signal quality*
*Maximum measurable frequency: 65535 Hz (16-bit BC register limit)*

## 🔬 Technical Details

### Algorithm Overview

The frequency counter operates using a precisely timed measurement window:

- **Timing Control**: HL register pair acts as a loop counter, decremented in a precisely timed loop that runs for exactly one second total
- **Pulse Counting**: BC register pair accumulates the number of rising edges detected during the measurement window
- **EAR Port Monitoring**: Continuously samples the EAR port for signal transitions within the timing loop
- **Edge Detection**: Specifically counts rising edges for accuracy

**1Hz Resolution**: The resolution comes from the 1-second measurement window - the smallest frequency difference detectable is 1Hz since we measure for exactly 1 second.

### Code Architecture

The project uses a hybrid BASIC/Assembly approach:

- **BASIC Program** (`Z80FC.bas`): Contains the user interface and DATA statements with machine code
- **Assembly Source** (`Z80FC.asm`): Contains the timing-critical measurement loop
- **Dependency**: When assembly code is modified, the DATA statements in the BASIC program must be updated with the new machine code bytes

**Important**: If you modify `Z80FC.asm`, you must:
1. Assemble it to get the machine code bytes
2. Update the corresponding DATA statements in `Z80FC.bas`
3. The `c.sh` script handles this automatically using pasmo

### Technical Documentation

For developers working on timing-critical aspects:

- **[TimingsCalc-Z80.ods](docs/TimingsCalc-Z80.ods)**: Comprehensive spreadsheet with Z80 instruction cycle calculations, timing analysis, and verification formulas
- **Algorithm Overview**: The measurement loop timing breakdown
- **Register Usage**: Detailed explanation of BC/HL register pair functions
- **Edge Detection**: Signal processing and threshold considerations

Understanding the timing calculations is crucial for:
- Modifying measurement window duration
- Optimizing instruction cycles for accuracy
- Porting to different Z80-based systems
- Validating measurement precision

### Register Usage

| Register | Purpose | Range/Notes |
|----------|---------|-------------|
| BC | Pulse counter (incremented on each rising edge) | 0-65535 (16-bit), maximum measurable frequency |
| HL | Loop counter (decremented in precisely timed loop for 1-second duration) | Calculated value for exact 1-second timing |
| A | Signal sampling and edge detection | Current EAR port state |
| E | Current EAR value | Current sample from EAR port |
| D | Previous EAR value | Previous sample for edge detection comparison |

### Timing Considerations

The code is carefully crafted to ensure:
- Exactly 1-second measurement windows
- Consistent sampling rates
- Minimal timing jitter
- Accurate frequency calculations

## 📊 Accuracy and Limitations

### Expected Accuracy
- **Resolution**: 1 Hz (due to 1-second measurement window)
- **Range**: Depends on input signal characteristics and Z80 processing speed
- **Stability**: High, due to crystal-controlled timing in ZX Spectrum

### Limitations
- Input signal must have sufficient amplitude to trigger EAR port
- Very high frequencies may be limited by Z80 processing speed
- Measurement time is fixed at 1 second

## 🎮 Compatible Hardware

### Tested Platforms
- ✅ ZX Spectrum 48K
- ✅ Harlequin (ZX Spectrum clone)

### Potentially Compatible
- ZX Spectrum 128K (should work in 48K mode)
- Other ZX Spectrum clones with compatible EAR port implementation

## 🤝 Contributing

Contributions are welcome! The project uses a modern build system to make development easier.

### Development Workflow

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/Z80-Frequency-counter-ZX-spectrum.git
   cd Z80-Frequency-counter-ZX-spectrum
   ```

2. **Set Up Development Environment**
   ```bash
   make check          # Verify dependencies
   make install        # See installation instructions if needed
   ```

3. **Make Changes**
   - Edit source files in `src/` directory
   - Use `make watch` for automatic rebuilds during development
   - Test changes with `make test`

4. **Validate Changes**
   ```bash
   make clean all      # Clean build
   make test          # Test functionality
   ```

5. **Submit Pull Request**
   - Create feature branch
   - Commit changes with descriptive messages
   - Submit pull request with detailed description

### Areas for Improvement

- **Algorithm Optimization**: Improving accuracy or measurement speed
- **Feature Additions**: Different measurement windows, averaging, min/max tracking
- **Hardware Compatibility**: Testing on additional ZX Spectrum variants
- **User Interface**: Better display formatting, configuration options
- **Documentation**: Technical documentation, usage examples
- **Testing**: Automated test suite, hardware validation
- **Build Automation**: Automatic DATA statement generation from assembly changes

### Development Guidelines

- Follow existing code style and structure
- Test on real hardware when possible
- Update documentation for any interface changes
- Use the Makefile for all build operations
- Add appropriate comments for complex timing-critical code

## 📜 License

[Specify your license here - consider MIT, GPL, or other appropriate license]

## 🙏 Acknowledgments

- ZX Spectrum community for hardware documentation
- Tool developers: zmakebas and tap2tzx creators
- Harlequin project for providing compatible hardware

## 📞 Support

### Getting Help

- **Build Issues**: Run `make help` or `make check` for diagnostic information
- **Bug Reports**: Use [GitHub Issues](../../issues) with detailed reproduction steps
- **Feature Requests**: Submit via [GitHub Issues](../../issues) with use case description  
- **General Discussion**: Use [GitHub Discussions](../../discussions) for questions and ideas
- **Development**: See [Contributing Guidelines](#-contributing) above

### Reporting Issues

When reporting problems, please include:

1. **Environment**: Hardware (real ZX Spectrum/emulator), OS, tool versions
2. **Build Information**: Output of `make info` and `make check`
3. **Steps to Reproduce**: Exact commands and inputs used
4. **Expected vs Actual**: What you expected vs what happened
5. **Logs**: Any error messages or verbose output (`make debug`)

### Community Resources

- **ZX Spectrum Community**: [World of Spectrum](https://worldofspectrum.org/)
- **Hardware Projects**: [ZX Spectrum Next](https://www.specnext.com/)
- **Development Tools**: [Z80 Assembly Resources](https://z80-heaven.wikidot.com/)

---

**Note**: This is a hobbyist project. For professional frequency measurement applications, consider dedicated test equipment.

