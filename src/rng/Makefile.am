# Makefile.am for schema/src/rng

# not srcdir, they are collected at build time
RNCDIR=../rnc
RNCS=$(wildcard $(RNCDIR)/*.rnc)

# Decrease some JRE space to fit in limited memory on ci.opensuse.org
# Prevents "Could not allocate metaspace: 1073741824 bytes"
# https://rce-docs.hmdc.harvard.edu/faq/why-do-i-get-java-error-could-not-reserve-enough-space-object-heap
export _JAVA_OPTIONS="-XX:CompressedClassSpaceSize=200M"

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

# Test with a minimal valid profile that the schema is correct
check-local:
	echo '<profile xmlns="http://www.suse.com/1.0/yast2ns"/>' | jing profile.rng /dev/stdin
	echo '<profile xmlns="http://www.suse.com/1.0/yast2ns"/>' | xmllint --noout --relaxng profile.rng /dev/stdin

install-data-local:
	$(INSTALL) -d $(DESTDIR)$(schemadir)/autoyast/rng
	$(INSTALL) -m 644 *.rng $(DESTDIR)$(schemadir)/autoyast/rng
