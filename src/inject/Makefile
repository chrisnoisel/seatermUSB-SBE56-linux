CC=gcc

LIB_BIN_PATH	:= ../ftd2xx/libftd2xx.so
LIB_H_PATH		:= ../ftd2xx/ftd2xx.h
LIB_FX_REGEX	:= "^FT_STATUS" "FT_W32_"

BUILD_DEPS		:= -lftd2xx -lpthread

# ----------------------

LIB_DIR := $(shell dirname $(LIB_BIN_PATH))
#LIB_NAME := $(shell echo '$(LIB_BIN_PATH)' | sed -E 's#^.+/lib([^/]+).so$$#\1#')

.PHONY: bootstrap

bootstrap injections.h: $(LIB_H_PATH)
	@./bootstrap.sh $< injections.h $(LIB_FX_REGEX)
	
%.so: %.c injections.h injtools.h injtools.c
# $(CC) -ldl -shared -fPIC -ggdb3 -o $@ preload.c injtools.c
# injection needs the dependency on 'ftd2xx' 
# otherwise dlsym(RTLD_NEXT, "") returns a null pointer

# $(CC) -L../../build/ftd2xxj -ldl -lftd2xxj -shared -fPIC -ggdb3 -o $@ $< injtools.c
# it should be possible to build against a static ftd2xxj but then libjvm must be 
# preloaded as well and it becomes easier to manage a dynamic build
	
	$(CC) -L$(LIB_DIR) -ldl $(BUILD_DEPS) -shared -fPIC -ggdb3 -o $@ $< injtools.c
	ldd $@
	nm -D $@ | awk '{if (substr($$0,18,1)=="T")print $0}'
	
clean:
	rm -f injections.h
	rm -f ./*.so