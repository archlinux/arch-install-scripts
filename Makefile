VER=11

PREFIX = /usr/local

BINPROGS = \
	arch-chroot \
	genfstab \
	pacstrap

all: $(BINPROGS)

V_GEN = $(_v_GEN_$(V))
_v_GEN_ = $(_v_GEN_0)
_v_GEN_0 = @echo "  GEN     " $@;

edit = $(V_GEN) m4 -P $@.in >$@ && chmod go-w,+x $@

%: %.in common
	$(edit)

clean:
	$(RM) $(BINPROGS)

check: all
	for f in $(BINPROGS); do bash -O extglob -n $$f; done

install: all
	install -dm755 $(DESTDIR)$(PREFIX)/bin
	install -m755 $(BINPROGS) $(DESTDIR)$(PREFIX)/bin
	install -Dm644 zsh-completion $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_archinstallscripts

uninstall:
	for f in $(BINPROGS); do $(RM) $(DESTDIR)$(PREFIX)/bin/$$f; done
	$(RM) $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_archinstallscripts

dist:
	git archive --format=tar --prefix=arch-install-scripts-$(VER)/ v$(VER) | gzip -9 > arch-install-scripts-$(VER).tar.gz
	gpg --detach-sign --use-agent arch-install-scripts-$(VER).tar.gz

.PHONY: all clean install uninstall dist
