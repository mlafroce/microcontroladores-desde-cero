md_files ?= $(wildcard *.md)
tex_files ?= $(patsubst %.md,%.tex,$(md_files))
svg_files ?= $(wildcard *.svg)
img_files ?= $(patsubst %.svg,%.pdf,$(svg_files))
main_tex ?= "main.tex"

.PHONY: pdf clean

all: $(img_files) $(tex_files) $(main_tex)

%.tex: %.md
	pandoc $< -o $@

%.pdf: %.svg
	inkscape -zD --export-pdf=$@ $<

$(main_tex):
	pdflatex $@

clean:
	rm -f *.aux *.log *.out *.pdf *.toc $(tex_files)
