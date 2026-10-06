MARP      := marp
MARPFLAGS := --pdf --allow-local-files --html --no-stdin

SLIDE := dsf_slide.md
PDF   := $(SLIDE:.md=.pdf)

.PHONY: all clean

all: $(PDF)

$(PDF): $(SLIDE) $(wildcard img/*/*)
	$(MARP) $< $(MARPFLAGS)

clean:
	rm -f $(PDF)
