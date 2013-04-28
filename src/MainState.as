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
  // Start sound.
  [Embed(source="../assets/start.mp3")]
  private static const StartSoundCls:Class;
  private static const startsound:Sound = new StartSoundCls();

  // Dead sound.
  [Embed(source="../assets/dead.mp3")]
  private static const DeadSoundCls:Class;
  private static const deadsound:Sound = new DeadSoundCls();

  /// Game-related functions

  private var scene:Scene;
  private var player:Player;
  private var _startpos:Point;

  public function MainState(width:int, height:int)
  {
    scene = new Scene(width, height);

    player = scene.setLevel(0);
    scene.setMode(true);
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
    if (scene.hasPlayerStarted(player)) {
      _startpos = new Point(player.bounds.x, player.bounds.y);
      scene.setMode(false);
      startsound.play();
    } else if (player.dead) {
      player.setPosition(_startpos.x, _startpos.y-Entity.unit);
      scene.setMode(true);
      deadsound.play();
    } else if (scene.hasPlayerGoaled(player)) {
      try {
	player = scene.setLevel(scene.level+1);
	scene.setMode(true);
      } catch (e:Error) {
	if (e.message == "MLG") {
	  dispatchEvent(new Event(CHANGED));
	}
      }
    }
  }

  // keydown(keycode)
  public override function keydown(keycode:int):void
  {
    switch (keycode) {
    case Keyboard.LEFT:
    case 65:			// A
    case 72:			// H
      player.setDirectionX(-1);
      break;

    case Keyboard.RIGHT:
    case 68:			// D
    case 76:			// L
      player.setDirectionX(+1);
      break;

    case Keyboard.UP:
    case 87:			// W
    case 75:			// K
      player.setDirectionY(-1);
      break;

    case Keyboard.DOWN:
    case 83:			// S
    case 74:			// J
      player.setDirectionY(+1);
      break;

    case Keyboard.SPACE:
    case 88:			// X
    case 90:			// Z
      player.jump();
      break;

    case Keyboard.ENTER:
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
      player.setDirectionX(0);
      break;

    case Keyboard.UP:
    case Keyboard.DOWN:
    case 87:			// W
    case 75:			// K
    case 83:			// S
    case 74:			// J
    case Keyboard.SPACE:
    case 88:			// X
    case 90:			// Z
      player.setDirectionY(0);
      break;

    }
  }
}

} // package
