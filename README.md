# seatermUSB-sbe56-linux
## About
As part of their software tools, Sea-Bird releases *SeatermUSB-SBE56* for Windows. Interestingly, it runs with Java so it can be used on Linux as long as you provide a suitable library to communicate with the FTDI USB chip on the SBE56.

The project makes use of the following components :
- SeatermUSB-SBE56, downloaded and unpacked from https://www.seabird.com/software
- A copy of the FTDI D2XX drivers, from https://ftdichip.com/drivers/d2xx-drivers/
- A copy of the FTD2xxj library source code available at https://sourceforge.net/projects/ftd2xxj/files/ftd2xxj/2.1/ and released under the Eclipse Public License

## Requirements
You will need wget, unzip, gcc and _unshield_ (https://github.com/twogood/unshield) which are probably already available for your Linux distribution.

## How To
Get and build the whole thing :
```bash
git clone https://github.com/chrisnoisel/seatermUSB-sbe56-linux.git
cd seatermUSB-sbe56-linux
make assemble
```
You should get a directory named _seatermUSB_sbe56_ that contains the final result.
Run the thing with `make run` or by calling directly the bash script `./seatermUSB_sbe56/seatermusb-sbe56.sh`

While this seems to put everything into motion, a difference in device scanning between Windows and Linux prevents to detect any SBE56. As a temporary workaround, you can use the command `make sniff` to patch the software.

## Building issues
Depending on your Linux distro, your Java library can be in a different location. Change the variables _JNI_HEADERS_ and _JVM_LIB_ at the top of _./src/ftd2xxj-native/Makefile_. Use `make libftd2xxj` to only build the library and test the setup.

## Note
With a bit of work, it should work fine on Mac too.