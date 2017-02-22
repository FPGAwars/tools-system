# Tools-system

## Introduction

Static binaries of the **lsftdi** and **lsusb** tools. Packaged for [Apio](https://github.com/FPGAwars/apio).

* lsftdi: display information about connected FTDI devices
* lsusb: display information about USB buses in the system

## Usage

Build:

```
bash build.sh "linux_x86_64 linux_armv7l"
```

Clean:

```
bash clean.sh "linux_x86_64 linux_armv7l"
```

Target architectures:
* linux_x86_64
* linux_i686
* linux_armv7l
* linux_aarch64
* windows
* darwin

Final packages will be generated in **\_packages/build_ARCH/** directory.

# Documentation

[The project documentation is located in the wiki](https://github.com/FPGAwars/tools-system/wiki)

## Authors

* [Juan González-Gómez (Obijuan)](https://github.com/Obijuan)
* [Jesús Arroyo Torrens](https://github.com/Jesus89)

## License

Licensed under [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/)
