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

all: $(BINPROGS) man
man: $(MANS)

V_GEN = $(_v_GEN_$(V))
_v_GEN_ = $(_v_GEN_0)
_v_GEN_0 = @echo "  GEN     " $@;

edit = $(V_GEN) m4 -P $@.in >$@ && chmod go-w,+x $@

%: %.in common
	$(edit)

doc/%: doc/%.asciidoc doc/asciidoc.conf
	$(V_GEN) a2x --no-xmllint --asciidoc-opts="-f doc/asciidoc.conf" -d manpage -f manpage -D doc $<

clean:
	$(RM) $(BINPROGS) $(MANS)

check: all
	@for f in $(BINPROGS); do bash -O extglob -n $$f; done
	@r=0; for t in test/test_*; do $(BASH) $$t || { echo $$t fail; r=1; }; done; exit $$r

install: all
	install -dm755 $(DESTDIR)$(PREFIX)/bin
	install -m755 $(BINPROGS) $(DESTDIR)$(PREFIX)/bin
	install -Dm644 completion/_archinstallscripts.zsh $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_archinstallscripts
	cd completion; for comp in *.bash; do \
		install -Dm644 $$comp $(DESTDIR)$(PREFIX)/share/bash-completion/completions/$${comp%%.*}; \
	done;
	for manfile in $(MANS); do \
		install -Dm644 $$manfile -t $(DESTDIR)$(PREFIX)/share/man/man$${manfile##*.}; \
	done;

.PHONY: all clean install uninstall
