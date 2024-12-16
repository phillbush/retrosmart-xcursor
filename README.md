#                          retrosmart-xcursor

<https://github.com/phillbush/retrosmart-xcursor>

Forked from <https://github.com/mdomlop/retrosmart-x11-cursors>

Retrosmart is an X11 cursor theme created [and expanded] for personal use.
Inspired by old Windows 3.x and OS X cursors, Retrosmart brings an old
school feel to your wobbly-windowed desktop of today.

It is available in white or black version, with or without colorful
appendices and alpha shading.

This fork differs from the original as follows:
* New cursors for drag-and-drop operations (ask, copy, link, move, no-drop).
* All DND cursors are based on the closedhand cursors, ones originally based
  on the regular arrow are linked to the closed hand ones.
* New {ul,ur,ll,lr}_angle cursors.
* New {top,bottom,left,right}_tee cursors.

![demo](./demo.png)

To build, generate a `./config.mk` file by running the `./configure`
script.  Then run `make retrosmart-xcursor-white-color-shadow` to build
the white-colored-shadowed theme; or `make all` to build all themes.
`Imagemagick(1)` and `xcursorgen(1)` are needed to build.

	./configure
	make all        # or "make retrosmart-xcursor-black" etc

To install, copy the directory `./retrosmart-xcursor*` for the theme you
want into your icon path (eg' `~/.icons/` or `/usr/local/share/icons/`).

	cp -R retrosmart-xcursor* ~/.icons/

This fork's building process differs from the original as follows:
* Portable makefile, does not depend on GNU Make anymore (at the cost of
  a messier .src/ directory after built).
* Do not keep different black-and-white and color XPM of some cursors;
  rather keep only colored version, and remove color when generating
  black or white theme.
* Do not generate a new set of XPM for each theme; rather generate PNGs
  directly from source XPMs, or from already generated PNGs (see below).
* Do not re-generate PNGs for a cursor of a colored theme if the cursor
  itself has no color; rather copy the black/white cursor instead.
* Do not convert XPMs into PNGs while shadowing them for the shadow themes;
  rather shadow already converted unshadowed PNGs.
* Distro-specific packaging makefiles have been removed.

Authors
* Manuel Domínguez López `<mdomlop at google mail dot com>`
* Lucas de Sena `<lucas at seninha dot org>`
