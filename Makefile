V=20120618

PREFIX = /usr/local

BINPROGS = arch-chroot genfstab pacstrap

all: $(BINPROGS)

%: %.in Makefile common
	@echo "GEN $@"
	@$(RM) "$@"
	@m4 -P $@.in >$@
	@chmod a-w "$@"
	@chmod +x "$@"

clean:
	rm -f $(BINPROGS)

install:
	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BINPROGS} $(DESTDIR)$(PREFIX)/bin

uninstall:
	for f in ${BINPROGS}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done

dist:
	git archive --format=tar --prefix=arch-install-scripts-$(V)/ $(V) | gzip -9 > arch-install-scripts-$(V).tar.gz
	gpg --detach-sign --use-agent arch-install-scripts-$(V).tar.gz

.PHONY: all clean install uninstall dist
