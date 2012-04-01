SUBDIRS = linha-de-euler

all clean flash html5:
	@for i in $(SUBDIRS) ; do \
		$(MAKE) -C $$i $@ ; \
	done
