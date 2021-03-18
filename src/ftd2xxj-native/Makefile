# if needed, change to your 'jni.h' location :
JNI_HEADERS := /usr/lib/jvm/default/include
# if needed, change to your 'libjvm.so' location :
JVM_LIB := /usr/lib/jvm/default/lib/server

# ---------------------------------------

FILES = device.c deviceDescriptor.c eeprom.c error.c ftd2xxj.c logger.c port.c service.c
FILES_PATH=$(patsubst %, ./src/%, $(FILES))
CFLAGS = -std=c99 -O0 -Wall -Wextra -fmessage-length=0 -fPIC

DEPENDENCIES := -lpthread -ljvm 
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
# Mac (unstested)
	DEPENDENCIES += -lobjc -framework IOKit -framework CoreFoundation
else
# Linux
	DEPENDENCIES += -lrt
endif

libftd2xxj.so: $(FILES_PATH)
#	static :
#	$(CC) \
#		$(CFLAGS) -I$(JNI_HEADERS) -I$(JNI_HEADERS)/linux -I"../ftd2xx" \
#		-L$(JVM_LIB)  $(DEPENDENCIES) -lftd2xx -Xlinker --no-undefined -shared -Wl,-soname=libftd2xxj.so.1 ../ftd2xx/libftd2xx.a\
#		$(FILES_PATH) \
#		-o $@
#	dynamic :
	$(CC) \
		$(CFLAGS) -I$(JNI_HEADERS) -I$(JNI_HEADERS)/linux -I"../ftd2xx" \
		-L"../ftd2xx" -L$(JVM_LIB)  $(DEPENDENCIES) -lftd2xx -Xlinker --no-undefined -shared -Wl,-soname=libftd2xxj.so.1 \
		$(FILES_PATH) \
		-o $@

clean:
	@rm libftd2xxj.so