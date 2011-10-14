PREFIX = /usr/local/bin

SCRIPT = $(notdir $(CURDIR)).sh
FILE_PATH = $(CURDIR)/$(SCRIPT)
INSTALL_FILE_PATH = $(PREFIX)/$(basename $(SCRIPT))

test:
	$(CURDIR)/test.sh

$(INSTALL_FILE_PATH):
	cp $(FILE_PATH) $(INSTALL_FILE_PATH)

.PHONY: install
install: $(INSTALL_FILE_PATH)

include tools.mk
