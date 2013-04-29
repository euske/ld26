package {

import flash.display.Bitmap;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.events.Event;
import flash.ui.Keyboard;
import flash.geom.ColorTransform;
import GameState;

//  TitleState
// 
public class TitleState extends GameState
{
  private var text:Bitmap;
  private var _channel:SoundChannel;

  // Title image:
  [Embed(source="../assets/title.png", mimeType="image/png")]
  private static const TitleImageCls:Class;
  private static const titleimage:Bitmap = new TitleImageCls();

  public function TitleState(width:int, height:int)
  {
    text = Main.Font.render("\"CONTROLLED DIET\"\n"+
			    "LD26 ENTRY BY EUSKE\n\n"+
			    "PRESS ENTER TO START", 0xffffff, 3);
    text.x = (width-text.width)/2;
    text.y = height-text.height*1.5;
    
    addChild(titleimage);
    titleimage.x = (width-titleimage.width)/2;
    titleimage.y = 20;
    var ct:ColorTransform = new ColorTransform();
    ct.color = 0xffff00;
    titleimage.bitmapData.colorTransform(titleimage.bitmapData.rect, ct);
  }

  // open()
  public override function open():void
  {
    addChild(text);
    _channel = MainState.music1sound.play();
  }

  // close()
  public override function close():void
  {
    _channel.stop();
    removeChild(text);
  }

  // keydown(keycode)
  public override function keydown(keycode:int):void
  {
    switch (keycode) {
    case Keyboard.SPACE:
    case Keyboard.ENTER:
    case 88:			// X
    case 90:			// Z
      dispatchEvent(new Event(CHANGED));
      break;

    }
  }
}

} // package
