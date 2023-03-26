VER=26

PREFIX = /usr/local

BINPROGS = \
	arch-chroot \
	genfstab \
	pacstrap

MANS = \
	doc/arch-chroot.8 \
	doc/genfstab.8 \
	doc/pacstrap.8

BASH = bash
ZSHCOMP := $(wildcard completion/zsh/*)
BASHCOMP := $(wildcard completion/bash/*)

all: $(BINPROGS) man
man: $(MANS)

V_GEN = $(_v_GEN_$(V))
_v_GEN_ = $(_v_GEN_0)
_v_GEN_0 = @echo "  GEN     " $@;

edit = $(V_GEN) m4 -P $@.in >$@ && chmod go-w,+x $@

%: %.in common
	$(edit)

doc/%: doc/%.asciidoc doc/asciidoc.conf doc/footer.asciidoc
	$(V_GEN) a2x --no-xmllint --asciidoc-opts="-f doc/asciidoc.conf" -d manpage -f manpage -D doc $<

clean:
	$(RM) $(BINPROGS) $(MANS)

check: all
	@for f in $(BINPROGS); do bash -O extglob -n $$f; done
	@r=0; for t in test/test_*; do $(BASH) $$t || { echo $$t fail; r=1; }; done; exit $$r

shellcheck: $(BINPROGS)
	shellcheck -W 99 --color $(BINPROGS)
	shellcheck -W 99 --color -x test/test_*

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BINPROGS) $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/share/zsh/site-functions
	install -m 0644 $(ZSHCOMP) $(DESTDIR)$(PREFIX)/share/zsh/site-functions
	install -d $(DESTDIR)$(PREFIX)/share/bash-completion/completions
	install -m 0644 $(BASHCOMP) $(DESTDIR)$(PREFIX)/share/bash-completion/completions
	install -d $(DESTDIR)$(PREFIX)/share/man/man8
	install -m 0644 $(MANS) $(DESTDIR)$(PREFIX)/share/man/man8

.PHONY: all man clean check shellcheck install
