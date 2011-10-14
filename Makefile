PREFIX = /usr/local/bin

SCRIPT = ignore_moves.sh
FILE_PATH = $(CURDIR)/$(SCRIPT)
INSTALL_FILE_PATH = $(PREFIX)/$(basename $(SCRIPT))

test:
	$(CURDIR)/test.sh

$(INSTALL_FILE_PATH):
	cp $(FILE_PATH) $(INSTALL_FILE_PATH)
	chmod 555 $(INSTALL_FILE_PATH)

.PHONY: install
install: $(INSTALL_FILE_PATH)

include tools.mk
