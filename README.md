# Tools-system

[Apio](https://github.com/FPGAwars/apio) package Tool for listing the usb devices and retrieving information from the ftdi chips

## Usage

Edit the target architectures in the `build.sh` script:

```
# -- Target architectures
ARCHS=( linux_x86_64 linux_armv7l )
# ARCHS=( linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows )
# ARCHS=( darwin )
```

Run the script `./build.sh`

Final packages will be generated in **\_packages/build_ARCH/** directory.

## Documentation

[Check the wiki page for the documentation](https://github.com/FPGAwars/tools-usb-ftdi/wiki)

## Author

* [Juan González-Gómez (Obijuan)](https://github.com/Obijuan)
* [Jesús Arroyo Torrens](https://github.com/Jesus89)

## License

![](https://github.com/FPGAwars/tools-usb-ftdi/raw/master/doc/bq-logo-cc-sa-small-150px.png)

Licensed under [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/)
