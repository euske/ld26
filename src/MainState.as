package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.media.Sound;
import flash.ui.Keyboard;
import flash.geom.Rectangle;
import flash.geom.Point;
import GameState;
import Actor;
import Scene;
import Factory;

//  MainState
//
public class MainState extends GameState
{
  // Player image:
  [Embed(source="../assets/player.png", mimeType="image/png")]
  private static const PlayerImageCls:Class;
  private static const playerimage:Bitmap = new PlayerImageCls();

  // Sound:
  [Embed(source="../assets/sound.mp3")]
  private static const JumpSoundCls:Class;
  private static const jump:Sound = new JumpSoundCls();

  /// Game-related functions

  private var scene:Scene;
  private var player:Actor;

  public function MainState(width:int, height:int)
  {
    scene = new Scene(width, height);
    scene.addFactory(new RoastingFactory(new Rectangle(20, height-20-80, 160, 80),
					 0xff0000, "ROAST"));
    scene.addFactory(new SeasoningFactory(new Rectangle(width-20-160, height-20-80, 160, 80),
					  0x008844, "SEASON"));
    
    // cucumber
    scene.addMaterial(new Material(scene, 4, 7, 0x00cc00, 0x88ff00));
    // tomato
    scene.addMaterial(new Material(scene, 6, 6, 0xff0000, 0xff8800));
    // beef
    scene.addMaterial(new Material(scene, 5, 5, 0xcc88cc, 0x884444));
    // pork
    scene.addMaterial(new Material(scene, 7, 3, 0xffcccc, 0xcc8888));
    // lettuce
    scene.addMaterial(new Material(scene, 7, 7, 0x88ffcc, 0x88ff88));
    // tofu
    scene.addMaterial(new Material(scene, 5, 5, 0xcccccc, 0xffffcc));
    // carrot
    scene.addMaterial(new Material(scene, 3, 5, 0xcccc88, 0xcccc88));
    // chicken
    // onion
    // herb?

    player = new Actor(scene, playerimage);
    scene.addActor(player);
  }

  // open()
  public override function open():void
  {
    addChild(scene);
  }

  // close()
  public override function close():void
  {
    removeChild(scene);
  }

  // update()
  public override function update():void
  {
    scene.update();
    scene.repaint();
  }

  // keydown(keycode)
  public override function keydown(keycode:int):void
  {
    switch (keycode) {
    case Keyboard.LEFT:
    case 65:			// A
    case 72:			// H
      player.setDirection(-1, 0);
      break;

    case Keyboard.RIGHT:
    case 68:			// D
    case 76:			// L
      player.setDirection(+1, 0);
      break;

    case Keyboard.UP:
    case 87:			// W
    case 75:			// K
      player.setDirection(0, -1);
      break;

    case Keyboard.DOWN:
    case 83:			// S
    case 74:			// J
      player.setDirection(0, +1);
      break;

    case Keyboard.SPACE:
    case Keyboard.ENTER:
    case 88:			// X
    case 90:			// Z
      scene.toggleMode();
      break;

    }
  }

  // keyup(keycode)
  public override function keyup(keycode:int):void 
  {
    switch (keycode) {
    case Keyboard.LEFT:
    case Keyboard.RIGHT:
    case 65:			// A
    case 68:			// D
    case 72:			// H
    case 76:			// L
      player.setDirection(0, 0);
      break;

    case Keyboard.UP:
    case Keyboard.DOWN:
    case 87:			// W
    case 75:			// K
    case 83:			// S
    case 74:			// J
      player.setDirection(0, 0);
      break;
    }
  }
}

} // package
