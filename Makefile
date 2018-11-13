md_files ?= $(wildcard *.md)
tex_files ?= $(patsubst %.md,%.tex,$(md_files))
svg_files ?= $(wildcard *.svg)
png_files ?= $(patsubst %.svg,%.png,$(svg_files))
main_tex ?= "main.tex"

.PHONY: pdf clean

all: $(png_files) $(tex_files) $(main_tex)

%.tex: %.md
	pandoc $< -o $@

%.png: %.svg
	inkscape -zD -e $@ $<

$(main_tex):
	pdflatex $@

clean:
	rm -f *.aux *.log *.out *.pdf *.toc *.png $(tex_files)