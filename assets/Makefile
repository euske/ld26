# Makefile

TIMIDITY=timidity
LAME=lame
SOUNDS=move.mp3 push.mp3 connect1.mp3 connect2.mp3 \
	jump1.mp3 jump2.mp3 jump3.mp3 attack.mp3 \
	roast.mp3 season.mp3 dead.mp3 \
	start.mp3 nextlevel.mp3 explosion.mp3 \
	music1.mp3 music2.mp3

all: $(SOUNDS)

.SUFFIXES: .mp3 .wav .it .xm .mod

clean:
	-$(RM) $(SOUNDS)
.it.mp3:
	$(TIMIDITY) -Ow -o- $< | $(LAME) - $@
.wav.mp3:
	$(LAME) $< $@
