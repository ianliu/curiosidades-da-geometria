PROGRAMS = linha-de-euler
linha_de_euler_MAIN = EulerLine
linha_de_euler_SOURCES = EulerLine.hx
AM_HXFLAGS = -cp ../common

# Do not change the lines below, only if you know what you are doing.
#
HAXE  = haxe
FLASH = $(PROGRAMS).swf
HTML5 = $(PROGRAMS).html

all: flash html5

$(FLASH): $(linha_de_euler_SOURCES)
	$(HAXE) -main $(linha_de_euler_MAIN) $(AM_HXFLAGS) $(HXFLAGS) -swf9 $@ -swf-header 400:300:30:FFFFFF

# TODO: Learn to compile this
$(HTML5):
	@true

clean:
	-rm -rf $(FLASH) $(HTML5)

flash: $(FLASH)

html5: $(HTML5)

