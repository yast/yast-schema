# Makefile.am for schema/doc

htmldir = $(docdir)

doc_DATA = README
html_DATA = profile.html

EXTRA_DIST = $(doc_DATA) $(html_DATA) $(wildcard *.xsl)



profile.html:
	xsltproc RngToRncHtml.xsl ../src/rng/profile.rng > profile.html
