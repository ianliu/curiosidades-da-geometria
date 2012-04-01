PROGRAMS = linha-de-euler
linha_de_euler_MAIN = EulerLine
linha_de_euler_SOURCES = EulerLine.hx

HAXE  = haxe
FLASH = $(PROGRAM).swf
HTML5 = $(PROGRAM).html

$(FLASH): $(linha_de_euler_SOURCES)
	$(HAXE) -main $(linha_de_euler_MAIN) -swf9 $@ -swf-header 400:300:30:FFFFFF

$(HTML5):
	@true

clean:
	-rm -rf $(FLASH) $(HTML5)

flash: $(FLASH)

html5: $(HTML5)

all:flash html5
