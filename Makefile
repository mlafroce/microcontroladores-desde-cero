md_files ?= $(wildcard *.md)
tex_files ?= $(patsubst %.md,build/%.tex,$(md_files))
svg_files ?= $(wildcard img/*.svg)
img_files ?= $(patsubst %.svg, build/%.pdf,$(svg_files))
main_tex ?= "main.tex"
output_name ?= "microcontroladores-desde-cero"
output_file ?= $(output_name).pdf

.PHONY: pdf clean

all: $(tex_files) $(img_files) $(output_file)
	mkdir -p build/img

build/%.tex: %.md
	pandoc $< -o $@

build/%.pdf: %.svg
	inkscape -zD --export-pdf=$@ $<

$(main_tex):

$(output_file): $(main_tex)
	pdflatex --jobname $(output_name) $<

clean:
	rm -rf build *.aux *.log *.out *.pdf *.toc $(tex_files)
