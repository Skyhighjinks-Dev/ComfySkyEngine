# ComfySkyEngine

A cross-platform installation and configuration manager for ComfyUI, designed to simplify the setup and management of AI image generation workflows.

## Overview

ComfySkyEngine automates the complex process of installing ComfyUI and its dependencies across Windows and Linux systems. Instead of manually installing Python, Git, CUDA drivers, and various AI models, users can define their desired configuration and let ComfySkyEngine handle the rest.

## Key Features (Planned)

- **Cross-Platform Support**: Native builds for both Windows and Linux
- **Automated Dependency Management**: Handles Python, Git, CUDA/ROCm installation
- **Model Library Management**: Built-in database of verified AI models with automatic downloading
- **Configuration Profiles**: Save and reuse different ComfyUI setups for various workflows
- **Smart Installation**: Detects existing components to avoid redundant downloads
- **CLI-First Design**: Full command-line interface for automation and scripting

## Architecture

The project uses:
- **C++17** for performance and cross-platform compatibility
- **SQLite** for configuration and model library storage
- **CMake** for cross-platform build management
- **Platform abstraction layer** for OS-specific operations

## Usage (Planned)

```bash
# Install ComfyUI with a predefined configuration
comfyskyengine --install flux_dev_setup

# Create a new configuration
comfyskyengine --config create --name my_setup

# List available models
comfyskyengine --models list --type checkpoint --architecture SDXL
```

## Build Requirements

- CMake 3.20+
- C++17 compatible compiler
- Visual Studio 2022 (Windows) or GCC/Clang (Linux)

## Project Status

🚧 **Early Development** - This project is in active development and not yet ready for production use.

## License

Apache-2.0

---

*ComfySkyEngine aims to make AI image generation accessible by removing the technical barriers to entry.*