SHADOWARG = \
	\( +clone -background black -shadow 60x2+5+5 \) \
	+swap -background none -layers merge +repage

.SUFFIXES: \
	.32.xpm .b.32.png .w.32.png .bs.32.png .ws.32.png .bc.32.png .wc.32.png .bcs.32.png .wcs.32.png \
	.36.xpm .b.36.png .w.36.png .bs.36.png .ws.36.png .bc.36.png .wc.36.png .bcs.36.png .wcs.36.png \
	.b.cur .w.cur .bs.cur .ws.cur .bc.cur .wc.cur .bcs.cur .wcs.cur .in

.PHONY: all
all: \
	retrosmart-xcursor-white/index.theme \
	retrosmart-xcursor-white-color/index.theme \
	retrosmart-xcursor-white-shadow/index.theme \
	retrosmart-xcursor-white-color-shadow/index.theme \
	retrosmart-xcursor-black/index.theme \
	retrosmart-xcursor-black-color/index.theme \
	retrosmart-xcursor-black-shadow/index.theme \
	retrosmart-xcursor-black-color-shadow/index.theme

DESTDIRS = \
	retrosmart-xcursor-white/cursors \
	retrosmart-xcursor-white-color/cursors \
	retrosmart-xcursor-white-shadow/cursors \
	retrosmart-xcursor-white-color-shadow/cursors \
	retrosmart-xcursor-black/cursors \
	retrosmart-xcursor-black-color/cursors \
	retrosmart-xcursor-black-shadow/cursors \
	retrosmart-xcursor-black-color-shadow/cursors
${DESTDIRS}:
	mkdir -p $@

INDEX = printf "[Icon Theme]\nName=%s\nComment=Retrosmart cursor theme\n"
retrosmart-xcursor-black/index.theme: retrosmart-xcursor-black
	${INDEX} "Retrosmart Black" >$@
retrosmart-xcursor-black-color/index.theme: retrosmart-xcursor-black-color
	${INDEX} "Retrosmart Black Color" >$@
retrosmart-xcursor-black-shadow/index.theme: retrosmart-xcursor-black-shadow
	${INDEX} "Retrosmart Black Shadow" >$@
retrosmart-xcursor-black-color-shadow/index.theme: retrosmart-xcursor-black-color-shadow
	${INDEX} "Retrosmart Black Shadow Color" >$@
retrosmart-xcursor-white/index.theme: retrosmart-xcursor-white
	${INDEX} "Retrosmart White" >$@
retrosmart-xcursor-white-color/index.theme: retrosmart-xcursor-white-color
	${INDEX} "Retrosmart White Color" >$@
retrosmart-xcursor-white-shadow/index.theme: retrosmart-xcursor-white-shadow
	${INDEX} "Retrosmart White Shadow" >$@
retrosmart-xcursor-white-color-shadow/index.theme: retrosmart-xcursor-white-color-shadow
	${INDEX} "Retrosmart White Shadow Color" >$@

# black and white cursor
.32.xpm.w.32.png .32.xpm.b.32.png \
.36.xpm.w.36.png .36.xpm.b.36.png:
	@-echo "converting $< -> $@"
	@case $@ in \
		(*.w*.png) subs="s/cyan/white/;s/coral/black/;" ;; \
		(*.b*.png) subs="s/cyan/black/;s/coral/white/;" ;; \
	esac ; <$< sed -E " \
		s/(green|red|yellow)1/black/; \
		s/(green|red|yellow)/white/; \
		$$subs \
	" | convert xpm:- png:$@; \

# color cursor (depends on black-and-white form)
.w.32.png.wc.32.png .b.32.png.bc.32.png \
.w.36.png.wc.36.png .b.36.png.bc.36.png:
	@xpm=$@ ; case $@ in \
		(*.w*.png) subs="s/cyan/white/;s/coral/black/;" ;; \
		(*.b*.png) subs="s/cyan/black/;s/coral/white/;" ;; \
	esac ; case $@ in \
		(*.32.png) xpm="$${xpm%%.*}.32.xpm" ;; \
		(*.36.png) xpm="$${xpm%%.*}.36.xpm" ;; \
	esac ; if grep -Eq "green|red|yellow" $$xpm ; then \
		echo "converting $$xpm -> $@" ; \
		sed -E "\
			s/(green|red|yellow)1/\1/; \
			$$subs \
		" $$xpm | convert xpm:- png:$@ ; \
	else \
		echo "copying $< -> $@" ; \
		cp $< $@ ; \
	fi

# shadow cursor (depends on non-shadowed form)
.w.32.png.ws.32.png .wc.32.png.wcs.32.png .b.32.png.bs.32.png .bc.32.png.bcs.32.png \
.w.36.png.ws.36.png .wc.36.png.wcs.36.png .b.36.png.bs.36.png .bc.36.png.bcs.36.png:
	@-echo "shadowing $< -> $@"
	@convert png:$< ${SHADOWARG} png:$@

.in.w.cur .in.wc.cur .in.ws.cur .in.wcs.cur \
.in.b.cur .in.bc.cur .in.bs.cur .in.bcs.cur:
	@-echo "generating $@"
	@color=$@; color=$${color%.*}; color=$${color#*.}; \
	<$< sed "s/\..*\.png/.$$color&/g" | xcursorgen -p src - $@

.PHONY: clean distclean
clean:
	rm -f src/*.png src/*.cur
distclean:
	rm -rf retrosmart-xcursor-{white,black}{,-color}{,-shadow}

PREVIEW = default \
	pointer dnd-ask dnd-copy dnd-no-drop not-allowed \
	context-menu help progress1 wait01 text ll_angle bottom_left_corner \
	pirate color-picker crosshair cell pencil zoom-in zoom-out
PREVIEW_FILES = \
	${PREVIEW:%=src/%.w.32.png}   ${PREVIEW:%=src/%.w.36.png} \
	${PREVIEW:%=src/%.b.32.png}   ${PREVIEW:%=src/%.b.36.png} \
	${PREVIEW:%=src/%.wcs.32.png} ${PREVIEW:%=src/%.wcs.36.png} \
	${PREVIEW:%=src/%.bcs.32.png} ${PREVIEW:%=src/%.bcs.36.png}
demo.png: ${PREVIEW_FILES}
	montage -geometry +8+8 -tile 20x0 ${PREVIEW_FILES} $@


include config.mk
