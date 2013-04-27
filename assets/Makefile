# Makefile

LAME=lame
SOUNDS=move.mp3 jump.mp3 switch.mp3

all: $(SOUNDS)

.SUFFIXES: .mp3 .wav

clean:
	-$(RM) $(SOUNDS)

.wav.mp3:
	$(LAME) $< $@
