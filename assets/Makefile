# Makefile

LAME=lame
SOUNDS=move.mp3 push.mp3 switch.mp3 jump1.mp3 jump2.mp3 jump3.mp3 attack.mp3 connected.mp3

all: $(SOUNDS)

.SUFFIXES: .mp3 .wav

clean:
	-$(RM) $(SOUNDS)

.wav.mp3:
	$(LAME) $< $@
