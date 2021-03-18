.PHONY: assemble run clean

target_dir	:= seatermUSB_sbe56
seaterm_dir	:= cache/seaterm

	
assemble: $(target_dir)/seatermusb-sbe56.sh

run: assemble
	$(target_dir)/seatermusb-sbe56.sh

$(target_dir)/seatermusb-sbe56.sh: $(target_dir) ./src/ftd2xxj-native/libftd2xxj.so
	cp ./src/ftd2xxj-native/libftd2xxj.so $(target_dir)
	cp ./src/ftd2xx/libftd2xx.so $(target_dir)
	cp ./src/launcher.sh $(target_dir)/seatermusb-sbe56.sh
	chmod +x $(target_dir)/seatermusb-sbe56.sh

cache:
	mkdir -p $(seaterm_dir)

clean:
	@rm -Rf ./cache
	make -C ./src/ftd2xxj-native/ clean
	make -C ./src/inject/ clean
	
# ------------------------------------------- SeatermUSB-SBE56

$(seaterm_dir)/seatermv2.exe.zip: | cache
	wget -O $(seaterm_dir)/seatermv2.exe.zip "https://www.seabird.com/asset-get.download-en.jsa?code=251934"

$(seaterm_dir)/SeatermV2.8.0-b40.exe: $(seaterm_dir)/seatermv2.exe.zip
	unzip -u $(seaterm_dir)/seatermv2.exe.zip -d $(seaterm_dir)
	touch $@

$(seaterm_dir)/data1.hdr: $(seaterm_dir)/SeatermV2.8.0-b40.exe
	tail -c+8597364 $(seaterm_dir)/SeatermV2.8.0-b40.exe | head -c69220 > $(seaterm_dir)/data1.hdr

$(seaterm_dir)/data2.cab: $(seaterm_dir)/SeatermV2.8.0-b40.exe
	tail -c+8666670 $(seaterm_dir)/SeatermV2.8.0-b40.exe | head -c77548020 > $(seaterm_dir)/data2.cab
	
$(target_dir): $(seaterm_dir)/data1.hdr $(seaterm_dir)/data2.cab
	unshield -g "SeatermUSB-SBE56" -d ./ x $(seaterm_dir)/data2.cab
	mv SeatermUSB-SBE56 $(target_dir)
	unshield -g "lib" -d $(target_dir) x $(seaterm_dir)/data2.cab
	unshield -g "WebHelp" -d $(target_dir) x $(seaterm_dir)/data2.cab
	unshield -g "whgdata" -d $(target_dir)/WebHelp x $(seaterm_dir)/data2.cab
	unshield -g "whdata" -d $(target_dir)/WebHelp x $(seaterm_dir)/data2.cab
	

# ------------------------------------------- ftd2xxj
	
./src/ftd2xxj-native/libftd2xxj.so:
	make -C ./src/ftd2xxj-native/ libftd2xxj.so

# ------------------------------------------- sniff

./src/inject/preload.so: ./src/ftd2xxj-native/libftd2xxj.so
	make -C ./src/inject/ preload.so

sniff: assemble ./src/inject/preload.so
	$(target_dir)/seatermusb-sbe56.sh ./src/inject/preload.so