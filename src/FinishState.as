package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.ui.Keyboard;
import GameState;

//  FinishState
// 
public class FinishState extends GameState
{
  private var text:Bitmap;

  public function FinishState(width:int, height:int)
  {
    text = Main.Font.render("CONGRATS!\nYER SO MLG!!", 0xffff00, 3);
    text.x = (width-text.width)/2;
    text.y = (height-text.height)/2;
  }

  // open()
  public override function open():void
  {
    addChild(text);
  }

  // close()
  public override function close():void
  {
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
