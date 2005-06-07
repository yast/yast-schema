# Makefile.am for schema/src/rng

# not srcdir, they are collected at build time
RNCDIR=../rnc
RNCS=$(wildcard $(RNCDIR)/*.rnc)

all-local: profile.rng
profile.rng: $(RNCS)
	trang -I rnc -O rng $(RNCDIR)/profile.rnc $@

clean-local:
	rm -rf *.rng

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(schemadir)/autoyast/rng
	$(INSTALL) -m 644 *.rng $(DESTDIR)$(schemadir)/autoyast/rng
