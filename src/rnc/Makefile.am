# Makefile.am for schema/src/rnc

# The collect script also copies other *.rnc files here.

rncdir=$(schemadir)/autoyast/rnc
rnc_DATA=profile.rnc includes.rnc

# make multiple files in a single run. must use artificial patterns to
# distinguish it from a regular make rule
profile.% includes.%:
	PREFIX=$(prefix) SRC=$(srcdir)/.. $(top_srcdir)/scripts/collect.sh

clean-local:
	rm -rf *.rnc
