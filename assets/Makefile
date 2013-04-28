# Makefile

LAME=lame
SOUNDS=move.mp3 push.mp3 switch.mp3 connect1.mp3 connect2.mp3 \
	jump1.mp3 jump2.mp3 jump3.mp3 attack.mp3 \
	roast.mp3 season.mp3 dead.mp3 \
	start.mp3 nextlevel.mp3

all: $(SOUNDS)

.SUFFIXES: .mp3 .wav

clean:
	-$(RM) $(SOUNDS)

.wav.mp3:
	$(LAME) $< $@
