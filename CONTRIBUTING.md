# Contributing to wine-container

Thank you for your interest in contributing to wine-container! This project welcomes contributions from everyone.

## How to Contribute

### Reporting Issues

- Search existing issues first to avoid duplicates
- Use a clear, descriptive title
- Include your OS, Podman/Buildah versions, and Wine source used
- Provide steps to reproduce the problem
- Include any relevant error messages or logs

### Suggesting Enhancements

- Check if the enhancement has already been suggested
- Explain why this enhancement would be useful
- Provide specific examples of how it would work

### Code Contributions

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following these guidelines:
    - Keep changes focused and atomic
    - Follow the existing code style
    - Test your changes with different Wine sources (debian, winehq, crossover)
    - Update documentation if needed
3. **Add yourself to CONTRIBUTORS.md** as part of your pull request
4. **Submit a pull request** with:
    - Clear description of what you changed and why
    - Reference any related issues
    - Test results on your system

### Development Setup

```bash
git clone https://github.com/tonywalker1/wine-container.git
cd wine-container

# Test the build process
./build_wine_container --help
./run_wine_container --help

# Make your changes and test
./build_wine_container -d TestVolume -n TestContainer
./run_wine_container -d TestVolume -n TestContainer -r "winecfg"
```