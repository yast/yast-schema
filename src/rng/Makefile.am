# Makefile.am for schema/src/rng

# not srcdir, they are collected at build time
RNCDIR=../rnc
RNCS=$(wildcard $(RNCDIR)/*.rnc)

all-local: profile.rng rules.rng classes-decl.rng
profile.rng: $(RNCS)
	trang -I rnc -O rng $(RNCDIR)/profile.rnc $@
# generic rule
# FIXME: it fails because common.rnc is in a different directory
# but trang exits with 0 anyway, grr
%.rng: $(schemadir)/autoyast/rnc/%.rnc
	trang $< $@

clean-local:
	rm -rf *.rng

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(schemadir)/autoyast/rng
	$(INSTALL) -m 644 *.rng $(DESTDIR)$(schemadir)/autoyast/rng
