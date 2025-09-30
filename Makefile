CC = gcc
CFLAGS = -Wall -c `pkg-config --cflags libsbl`

LDFLAGS = -lm `pkg-config --libs libsbl`

PREFIX ?= /usr/local

BINARIES = build/sbl_get_version \
		   build/sbl_find_video

all: build $(BINARIES)

build/sbl_get_version: build/sbl_get_version.o
	$(CC) $(LDFLAGS) -o $@ $<

build:
	mkdir -p build

build/%.o: src/%.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f build/*.o

distclean:
	rm -fr build

install:
	install -D -m 755 build/sbl_get_version  $(DESTDIR)$(PREFIX)/bin/sbl_get_version
	install -D -m 755 build/sbl_find_video   $(DESTDIR)$(PREFIX)/bin/sbl_find_video

.PHONY: all clean distclean install

