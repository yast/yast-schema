# Makefile.am for schema/src/rnc

# we do not know what files there will be
# but profile.rnc is for sure

all-local: profile.rnc
profile.rnc:
	PREFIX=$(prefix) SRC=$(srcdir)/.. $(top_srcdir)/scripts/collect.sh

clean-local:
	rm -rf *.rnc

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(schemadir)/autoyast/rnc
	$(INSTALL) -m 644 *.rnc $(DESTDIR)$(schemadir)/autoyast/rnc
