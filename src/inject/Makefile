CC=gcc

.PHONY: bootstrap filter

bootstrap: injections.h
	
injections.h: ftd2xx_fx.h
	./bootstrap.sh $< $@

ftd2xx_fx.h ftd2xx_types.h: ../ftd2xx/ftd2xx.h
	./filter.sh $< ftd2xx_types.h ftd2xx_fx.h
	
filter: ../ftd2xx/ftd2xx.h
	./filter.sh $< ftd2xx_types.h ftd2xx_fx.h
	
%.so: %.c ftd2xx_fx.h ftd2xx_types.h injections.h injtools.h injtools.c
# $(CC) -ldl -shared -fPIC -ggdb3 -o $@ preload.c injtools.c
# injection needs the dependency on 'ftd2xx' 
# otherwise dlsym(RTLD_NEXT, "") returns a null pointer

# $(CC) -L../../build/ftd2xxj -ldl -lftd2xxj -shared -fPIC -ggdb3 -o $@ $< injtools.c
# it should be possible to build against a static ftd2xxj but then libjvm must be 
# preloaded as well and it becomes easier to manage a dynamic build
	
	$(CC) -L../ftd2xx -ldl -lftd2xx -shared -fPIC -ggdb3 -o $@ $< injtools.c
	ldd $@
	nm -D $@ | awk '{if (substr($$0,18,1)=="T")print $0}'
	
clean:
	@rm ftd2xx_types.h injections.h
	@rm ./*.so