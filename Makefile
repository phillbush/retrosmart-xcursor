SHADOWARG = \
	\( +clone -background black -shadow 60x2+5+5 \) \
	+swap -background none -layers merge +repage

.SUFFIXES: \
	.32.xpm .b.32.png .w.32.png .r.32.png .bs.32.png .ws.32.png .rs.32.png \
	.36.xpm .b.36.png .w.36.png .r.36.png .bs.36.png .ws.36.png .rs.36.png \
	.b.cur .w.cur .r.cur .bs.cur .ws.cur .rs.cur .in

.PHONY: all
all: \
	retrosmart-xcursor-white/index.theme \
	retrosmart-xcursor-white-shadow/index.theme \
	retrosmart-xcursor-black/index.theme \
	retrosmart-xcursor-black-shadow/index.theme \
	retrosmart-xcursor-red/index.theme \
	retrosmart-xcursor-red-shadow/index.theme

DESTDIRS = \
	retrosmart-xcursor-white/cursors \
	retrosmart-xcursor-white-shadow/cursors \
	retrosmart-xcursor-black/cursors \
	retrosmart-xcursor-black-shadow/cursors \
	retrosmart-xcursor-red/cursors \
	retrosmart-xcursor-red-shadow/cursors
${DESTDIRS}:
	mkdir -p $@

INDEX = printf "[Icon Theme]\nName=%s\nComment=Retrosmart cursor theme\n"
retrosmart-xcursor-black/index.theme: retrosmart-xcursor-black
	${INDEX} "Retrosmart Black" >$@
retrosmart-xcursor-black-shadow/index.theme: retrosmart-xcursor-black-shadow
	${INDEX} "Retrosmart Black Shadow" >$@
retrosmart-xcursor-white/index.theme: retrosmart-xcursor-white
	${INDEX} "Retrosmart White" >$@
retrosmart-xcursor-white-shadow/index.theme: retrosmart-xcursor-white-shadow
	${INDEX} "Retrosmart White Shadow" >$@
retrosmart-xcursor-red/index.theme: retrosmart-xcursor-red
	${INDEX} "Retrosmart Red" >$@
retrosmart-xcursor-red-shadow/index.theme: retrosmart-xcursor-red-shadow
	${INDEX} "Retrosmart Red Shadow" >$@

# unshadowed cursor
.32.xpm.w.32.png .32.xpm.b.32.png .32.xpm.r.32.png \
.36.xpm.w.36.png .36.xpm.b.36.png .36.xpm.r.36.png:
	@-echo "converting $< -> $@"
	@ case $@ in \
	(*.w*.png) \
		sed "s/cyan/white/;s/coral/black/;" ;; \
	(*.b*.png) \
		sed "s/cyan/black/;s/coral/white/;" ;; \
	(*/crosshair.r*.png|*/text.r*.png) \
		sed "s/cyan/white/;s/coral/red/;" ;; \
	(*.r*.png) \
		sed "s/cyan/red/;s/coral/black/;" ;; \
	esac <$< | convert xpm:- png:$@; \

# shadow cursor (depends on non-shadowed form)
.w.32.png.ws.32.png .b.32.png.bs.32.png .r.32.png.rs.32.png \
.w.36.png.ws.36.png .b.36.png.bs.36.png .r.36.png.rs.36.png:
	@-echo "shadowing $< -> $@"
	@convert png:$< ${SHADOWARG} png:$@

.in.w.cur .in.ws.cur \
.in.b.cur .in.bs.cur \
.in.r.cur .in.rs.cur:
	@-echo "generating $@"
	@color=$@; color=$${color%.*}; color=$${color#*.}; \
	<$< sed "s/\..*\.png/.$$color&/g" | xcursorgen -p src - $@

.PHONY: clean distclean
clean:
	rm -f src/*.png src/*.cur
distclean:
	rm -rf retrosmart-xcursor-{white,black,red}{,-shadow}

PREVIEW = default \
	pointer dnd-ask dnd-copy dnd-no-drop not-allowed \
	context-menu help progress1 wait01 text ll_angle bottom_left_corner \
	pirate color-picker crosshair cell pencil zoom-in zoom-out
PREVIEW_FILES = \
	${PREVIEW:%=src/%.w.32.png}  ${PREVIEW:%=src/%.w.36.png} \
	${PREVIEW:%=src/%.b.32.png}  ${PREVIEW:%=src/%.b.36.png} \
	${PREVIEW:%=src/%.ws.32.png} ${PREVIEW:%=src/%.ws.36.png} \
	${PREVIEW:%=src/%.bs.32.png} ${PREVIEW:%=src/%.bs.36.png}
demo.png: ${PREVIEW_FILES}
	montage -geometry +8+8 -tile 20x0 ${PREVIEW_FILES} $@

config.mk: configure
	./configure

include config.mk
