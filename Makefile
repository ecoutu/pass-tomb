PROG ?= tomb
PREFIX ?= $(HOME)
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
MANDIR ?= $(PREFIX)/share/man
SYSTEMD_DIR ?= $(LIBDIR)/systemd/system

BASHCOMPDIR ?= $(PREFIX)/.config/bash_completion
ZSHCOMPDIR ?= $(PREFIX)/.zsh/functions

all:
	@echo "pass-$(PROG) is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo
	@echo "To run pass $(PROG) one needs to have some tools installed on the system:"
	@echo "     Tomb and password store"

installuser:
	@install -v -d "$(PREFIX)/.local/share/man/man1"
	@install -v -d "$(PREFIX)/.password-store/.extensions/"
	@install -v -d "$(BASHCOMPDIR)" "$(ZSHCOMPDIR)"
	@install -v -d "$(PREFIX)/.config/systemd/user"
	@install -v -m 0755 $(PROG).bash "$(PREFIX)/.password-store/.extensions/$(PROG).bash"
	@install -v -m 0755 open.bash "$(PREFIX)/.password-store/.extensions/open.bash"
	@install -v -m 0755 close.bash "$(PREFIX)/.password-store/.extensions/close.bash"
	@install -v -m 0644 pass-$(PROG).1 "$(PREFIX)/.local/share/man/man1/pass-$(PROG).1"
	@install -v -m 0644 timer/pass-close@.service "$(PREFIX)/.config/systemd/user/pass-close@.service"
	@install -v -m 0644 "completion/pass-$(PROG).bash" "$(BASHCOMPDIR)/pass-$(PROG)"
	@install -v -m 0644 "completion/pass-$(PROG).zsh" "$(ZSHCOMPDIR)/_pass-$(PROG)"
	@install -v -m 0644 "completion/pass-open.zsh" "$(ZSHCOMPDIR)/_pass-open"
	@install -v -m 0644 "completion/pass-close.zsh" "$(ZSHCOMPDIR)/_pass-close"
	@echo
	@echo "pass-$(PROG) is installed succesfully"
	@echo

uninstalluser:
	@rm -vrf \
	  "$(PREFIX)/.password-store/.extensions/$(PROG).bash" \
	  "$(PREFIX)/.password-store/.extensions/open.bash" \
	  "$(PREFIX)/.password-store/.extensions/close.bash" \
	  "$(PREFIX)/.local/share/man/man1/pass-$(PROG).1" \
	  "$(PREFIX)/.config/systemd/user/pass-close@.service" \
	  "$(BASHCOMPDIR)/pass-$(PROG)" \
	  "$(ZSHCOMPDIR)/_pass-$(PROG)" \
	  "$(ZSHCOMPDIR)/_pass-open" \
	  "$(ZSHCOMPDIR)/_pass-close"

install:
	@install -v -d "$(DESTDIR)$(MANDIR)/man1"
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)" "$(DESTDIR)$(ZSHCOMPDIR)"
	@install -v -m 0755 $(PROG).bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash"
	@install -v -m 0755 open.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/open.bash"
	@install -v -m 0755 close.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/close.bash"
	@install -v -m 0644 pass-$(PROG).1 "$(DESTDIR)$(MANDIR)/man1/pass-$(PROG).1"
	@install -v -m 0644 timer/pass-close@.service "$(DESTDIR)$(SYSTEMD_DIR)/pass-close@.service"
	@install -v -m 0644 "completion/pass-$(PROG).bash" "$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"
	@install -v -m 0644 "completion/pass-$(PROG).zsh" "$(DESTDIR)$(ZSHCOMPDIR)/_pass-$(PROG)"
	@install -v -m 0644 "completion/pass-open.zsh" "$(DESTDIR)$(ZSHCOMPDIR)/_pass-open"
	@install -v -m 0644 "completion/pass-close.zsh" "$(DESTDIR)$(ZSHCOMPDIR)/_pass-close"
	@echo
	@echo "pass-$(PROG) is installed succesfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash" \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/open.bash" \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/close.bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-$(PROG).1" \
		"$(DESTDIR)$(SYSTEMD_DIR)/pass-close@.service" \
		"$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)" \
		"$(DESTDIR)$(ZSHCOMPDIR)/_pass-$(PROG)" \
		"$(DESTDIR)$(ZSHCOMPDIR)/_pass-open" \
		"$(DESTDIR)$(ZSHCOMPDIR)/_pass-close"


COVERAGE ?= true
TMP ?= /tmp/pass-tomb
PASS_TEST_OPTS ?= --verbose --immediate --chain-lint --root=/tmp/sharness
T = $(sort $(wildcard tests/*.sh))
export COVERAGE TMP

tests: $(T)
	@tests/results

$(T):
	@$@ $(PASS_TEST_OPTS)


lint:
	shellcheck -s bash $(PROG).bash open.bash close.bash tests/commons tests/results

clean:
	@rm -vrf tests/test-results/ tests/gnupg/random_seed


.PHONY: install installuser uninstall tests $(T) lint clean
