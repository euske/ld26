# Makefile

ZIP=zip
RM=rm -f
CP=cp -f
MKDIR=mkdir -p
RSYNC=rsync -av
JAVA=java

FLEX_HOME=../as/flex_sdk4
AS3COMPILE=$(JAVA) -jar $(FLEX_HOME)/lib/mxmlc.jar +flexlib=$(FLEX_HOME)/frameworks -static-rsls

TARGET=main.swf
LIVE_URL=ld48.tabesugi.net:public/file/ld48.tabesugi.net/ld26/

all: $(TARGET)

clean:
	-$(RM) $(TARGET)

upload: $(TARGET)
	$(RSYNC) main.html $(TARGET) $(LIVE_URL)

$(TARGET): ./src/*.as ./assets/*.png ./assets/*.mp3
	$(AS3COMPILE) -compiler.source-path=$(SRCDIR) -o $@ ./src/Main.as
