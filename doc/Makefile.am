# Makefile.am for schema/doc

htmldir = $(docdir)

doc_DATA = README
html_DATA = autoyast.html
STYLESHEET = RngToRncHtml.xsl RngToRncXml.xsl RngToRncProcessorConfig.xsl

autoyast.html: $(top_srcdir)/src/rng/*.rng
	xsltproc --nonet -o $@ RngToRncHtml.xsl $(top_srcdir)/src/rng/profile.rng

CLEANFILES = autoyast.html
EXTRA_DIST = $(doc_DATA) $(STYLESHEET)
