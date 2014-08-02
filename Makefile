.PRECIOUS: %.o.html %.native %.md %.html %.qbml %.wqbml %.edges %.tex
SHELL=bash
DIR=O
ORDER=order.txt
PACKETS=$(wildcard $(DIR)/*.docx)
FORMATS=$(PACKETS:.docx=.$(1))
PDFS:=$(call FORMATS,pdf)
TEXS:=$(call FORMATS,tex)

all: texs

texs: $(TEXS)
pdfs: $(PDFS)
formats: $(call FORMATS,$(EXT))
# usage: `make formats EXT=html`

clean:
	cd $(DIR) && rm -vf *.html* *.native *.md *.qbml* *.wqbml *.edges *.tex* *.aux *.log *.out *.pdf

-include .deps.mk

.deps.mk: $(ORDER) mk-deps.awk
	awk -f mk-deps.awk $< > $@

%.o.html: %.docx
	textutil -convert html $< -stdout | \
	sed "s/ \(<\/[^>]*>\)/\1 /g" | sed "s/\(<[^/][^>]*>\) / \1/g" > $@

%.native: %.o.html
	pandoc -o $@ $< -f html -t native

%.md: %.o.html
	pandoc -o $@ $< -f html -t markdown

-include x.mk

# does not actually depend on %.md
%.html: %.native %.md transformers/wrap.template
	pandoc -o $@ $< -f native -t html --template=transformers/wrap.template

%.qbml: %.html transformers/html-to-qbml.xsl transformers/fix-qbml.sh
	xsltproc -o $@ transformers/html-to-qbml.xsl $<
	./transformers/fix-qbml.sh < $@ > $@.temp
	mv $@.temp $@
ifdef DIFF
	xsltproc -o $@o         old/html-to-qbml.xsl $<
	./transformers/fix-qbml.sh < $@o > $@o.temp
	mv $@o.temp $@o
	diff <(xmllint --format $@) <(xmllint --format $@o)
endif

%.edges: $(ORDER) transformers/prev-qbml-to-this-edges.sh
	./transformers/prev-qbml-to-this-edges.sh $@ $<

%.xsl: %.pxsl transformers/xslt2.edf
	pxslcc -hx --add=transformers/xslt2.edf $< > $@

%.wqbml: %.qbml transformers/qbml-to-wqbml.xsl
	saxon -o:$@ $< transformers/qbml-to-wqbml.xsl

tests/qbml-to-wqbml.wqbml: tests/qbml-to-wqbml.qbml transformers/qbml-to-wqbml.xsl
	saxon -o:$@ $< transformers/qbml-to-wqbml.xsl

%.tex: %.wqbml %.edges transformers/qbml-to-latex.xsl
	xsltproc -o $@ transformers/qbml-to-latex.xsl $<
ifdef DIFF
	xsltproc -o $@o         old/qbml-to-latex.xsl $<
	diff $@ $@o
endif

%.pdf: %.tex packet.cls
	xelatex -output-directory $(DIR) $< -interaction=batchmode

# %.tex: %.md packet.template
# 	pandoc \
# 	$<				\
# 	-o $@				\
# 	--smart				\
# 	--no-wrap			\
# 	-f markdown			\
# 	-t latex			\
# 	--latex-engine=xelatex		\
# 	--standalone			\
# 	--template=packet.template
