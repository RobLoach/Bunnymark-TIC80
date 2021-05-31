TIC80 = tic80

BASE = bunnymark.tic

VPATH = src
OUTPUT_DIR = dist

SOURCES := $(wildcard src/bunnymark.*)

OUTPUTS := $(addprefix $(OUTPUT_DIR)/,$(SOURCES:src/bunnymark.%=bunnymark-%.tic))

.PHONY: clean run all

all: $(OUTPUTS)

run: $(OUTPUTS)
	for o in $^; do $(TIC80) --skip $$o; done

clean:
	rm $(OUTPUT_DIR)/*

# main rule
$(OUTPUT_DIR)/bunnymark-%.tic: bunnymark.%
	$(TIC80) --skip --fs . --cmd "load $(BASE) & import code $< & save $@ & exit"
