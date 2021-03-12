# if needed, change to your 'jni.h' location :
JNI_HEADERS := /usr/lib/jvm/default/include/
# if needed, change to your 'libjvm.so' location :
JVM_LIB := /usr/lib/jvm/default/lib/server/

CFLAGS = -std=c99 -O0 -Wall -Wextra -c -fmessage-length=0 -fPIC

.PHONY: download extract assemble clean run libftd2xxj
clean:
	rm -Rf ./build

DEPENDENCIES := -lpthread -ljvm 
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
# Mac (unstested)
	DEPENDENCIES += -lobjc -framework IOKit -framework CoreFoundation
else
# Linux
	DEPENDENCIES += -lrt
endif


seaterm_dir := build/seaterm
ftd2xxj_dir := build/ftd2xxj
ftd2xxj_obj := $(ftd2xxj_dir)/device.o $(ftd2xxj_dir)/deviceDescriptor.o $(ftd2xxj_dir)/eeprom.o $(ftd2xxj_dir)/error.o $(ftd2xxj_dir)/ftd2xxj.o $(ftd2xxj_dir)/logger.o $(ftd2xxj_dir)/port.o $(ftd2xxj_dir)/service.o

build:
	mkdir -p $(seaterm_dir)
	mkdir -p $(ftd2xxj_dir)
	
# ------------------------------------------- SeatermUSB-SBE56

$(seaterm_dir)/seatermv2.exe.zip: | build
	wget -O $(seaterm_dir)/seatermv2.exe.zip "https://www.seabird.com/asset-get.download-en.jsa?code=251934"

$(seaterm_dir)/SeatermV2.8.0-b40.exe: $(seaterm_dir)/seatermv2.exe.zip
	unzip -u $(seaterm_dir)/seatermv2.exe.zip -d $(seaterm_dir)
	touch $@

$(seaterm_dir)/data1.hdr: $(seaterm_dir)/SeatermV2.8.0-b40.exe
	tail -c+8597364 $(seaterm_dir)/SeatermV2.8.0-b40.exe | head -c69220 > $(seaterm_dir)/data1.hdr

$(seaterm_dir)/data2.cab: $(seaterm_dir)/SeatermV2.8.0-b40.exe
	tail -c+8666670 $(seaterm_dir)/SeatermV2.8.0-b40.exe | head -c77548020 > $(seaterm_dir)/data2.cab
	
SeatermUSB-SBE56: $(seaterm_dir)/data1.hdr $(seaterm_dir)/data2.cab
	unshield -g "SeatermUSB-SBE56" -d ./ x $(seaterm_dir)/data2.cab
	unshield -g "lib" -d ./SeatermUSB-SBE56 x $(seaterm_dir)/data2.cab
	unshield -g "WebHelp" -d ./SeatermUSB-SBE56 x $(seaterm_dir)/data2.cab
	unshield -g "whgdata" -d ./SeatermUSB-SBE56/WebHelp x $(seaterm_dir)/data2.cab
	unshield -g "whdata" -d ./SeatermUSB-SBE56/WebHelp x $(seaterm_dir)/data2.cab


# ------------------------------------------- ftd2xxj

$(ftd2xxj_dir)/%.o: ftd2xxj-native/src/%.c | build
	$(CC) $(CFLAGS) -I$(JNI_HEADERS) -I$(JNI_HEADERS)/linux -I"./ftd2xxj-native/external/include" -o"$@" "$<"
	
	
$(ftd2xxj_dir)/libftd2xxj.so: $(ftd2xxj_obj)
#	static :
	$(CC) -L$(JVM_LIB) -Xlinker --no-undefined -shared -Wl,-soname=libftd2xxj.so.2 -o "$@" $(ftd2xxj_obj) ./ftd2xxj-native/external/libftd2xx.a $(DEPENDENCIES)
#	dynamic :
#	$(CC) -Lftd2xxj-native/external -L/usr/lib/jvm/java-8-openjdk/jre/lib/amd64/server/ -Xlinker --no-undefined -shared -Wl,-soname=libftd2xxj.so.2 -o "$@" $(ftd2xxj_obj) -lftd2xx $(DEPENDENCIES)

libftd2xxj: $(ftd2xxj_dir)/libftd2xxj.so
	ldd $<

# -------------------------------------------

assemble: $(ftd2xxj_dir)/libftd2xxj.so SeatermUSB-SBE56
	cp $(ftd2xxj_dir)/libftd2xxj.so ./SeatermUSB-SBE56
	cp ./_run.sh ./SeatermUSB-SBE56/seatermusb-sbe56.sh
	chmod +x ./SeatermUSB-SBE56/seatermusb-sbe56.sh

run: assemble
	./SeatermUSB-SBE56/seatermusb-sbe56.sh
