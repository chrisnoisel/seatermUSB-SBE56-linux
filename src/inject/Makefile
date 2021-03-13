CC=gcc

filter:
	./filter.sh ../ftd2xx/ftd2xx.h ftd2xx_types.h ftd2xx_fx.h

ftd2xx_fx.h: ../ftd2xx/ftd2xx.h
	./filter.sh ../ftd2xx/ftd2xx.h ftd2xx_types.h ftd2xx_fx.h
	
ftd2xx_types.h: ../ftd2xx/ftd2xx.h
	./filter.sh ../ftd2xx/ftd2xx.h ftd2xx_types.h ftd2xx_fx.h
	
injections.h: ftd2xx_fx.h
	./bootstrap.sh $< injections.h
	
bootstrap:
	./bootstrap.sh ftd2xx_fx.h injections.h
	
%.so: %.c ftd2xx_fx.h injections.h injtools.h injtools.c
	# $(CC) -ldl -shared -fPIC -ggdb3 -o $@ preload.c injtools.c
	# injection needs the dependency on 'ftd2xx' 
	# otherwise dlsym(RTLD_NEXT, "") returns a null pointer
	
	# $(CC) -L../../build/ftd2xxj -ldl -lftd2xxj -shared -fPIC -ggdb3 -o $@ $< injtools.c
	# it should be possible to build against a static ftd2xxj but then libjvm must be 
	# preloaded as well and it becomes easier to manage a dynamic build
	
	$(CC) -L../ftd2xx -ldl -lftd2xx -shared -fPIC -ggdb3 -o $@ $< injtools.c
	ldd $@
	nm -D $@ | awk '{if (substr($$0,18,1)=="T")print $0}'