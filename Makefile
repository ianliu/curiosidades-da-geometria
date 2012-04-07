SUBDIRS = linha-de-euler triangulo-ortico

all clean flash html5:
	@for i in $(SUBDIRS) ; do \
		$(MAKE) -C $$i $@ ; \
	done
