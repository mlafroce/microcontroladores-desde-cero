md_files ?= $(wildcard *.md)
tex_files ?= $(patsubst %.md,%.tex,$(md_files))
svg_files ?= $(wildcard img/*.svg)
img_files ?= $(patsubst %.svg, build/%.pdf,$(svg_files))
main_tex ?= "main.tex"

.PHONY: pdf clean

all: $(img_files) $(tex_files) $(main_tex)

%.tex: %.md
	pandoc $< -o $@

build/%.pdf: %.svg
	inkscape -zD --export-pdf=$@ $<

$(main_tex):
	pdflatex $@

clean:
	rm -f *.aux *.log *.out *.pdf build/img/*.pdf *.toc $(tex_files)
