package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
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
  // Music
  [Embed(source="../assets/music1.mp3")]
  private static const Music1SoundCls:Class;
  public static const music1sound:Sound = new Music1SoundCls();
  [Embed(source="../assets/music2.mp3")]
  private static const Music2SoundCls:Class;
  public static const music2sound:Sound = new Music2SoundCls();

  // Level sound.
  [Embed(source="../assets/nextlevel.mp3")]
  private static const LevelSoundCls:Class;
  private static const levelsound:Sound = new LevelSoundCls();

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
  }

  // open()
  public override function open():void
  {
    player = scene.setLevel(0);
    scene.setMode(true);
    startMusic(music1sound);

    addChild(scene);
  }

  private var _music:Sound;
  private var _channel:SoundChannel;
  
  private function startMusic(music:Sound):void
  {
    if (_channel != null) {
      stopMusic();
    }
    _music = music;
    _channel = music.play();
    _channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
  }
  private function stopMusic():void
  {
    _channel.stop();
    _channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
    _channel = null;
  }
  private function loopMusic(e:Event):void
  {
    var channel:SoundChannel = SoundChannel(e.currentTarget);
    if (channel == _channel) {
      startMusic(_music);
    }
  }

  // close()
  public override function close():void
  {
    stopMusic();
    removeChild(scene);
  }

  // update()
  public override function update():void
  {
    scene.update();
    scene.repaint();
    if (scene.hasPlayerStarted(player)) {
      _startpos = new Point(player.bounds.x, player.bounds.y);
      startsound.play();
      scene.setMode(false);
      startMusic(music2sound);
    } else if (player.dead) {
      player.setPosition(_startpos.x, _startpos.y-Entity.unit);
      deadsound.play();
      scene.setMode(true);
      startMusic(music1sound);
    } else if (scene.hasPlayerGoaled(player)) {
      levelsound.play();
      try {
	player = scene.setLevel(scene.level+1);
	scene.setMode(true);
	startMusic(music1sound);
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
