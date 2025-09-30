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
	install -D -m 644 build/libsbl.so  $(DESTDIR)$(PREFIX)/lib/libsbl.so

.PHONY: all clean distclean install

