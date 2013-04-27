package {

import flash.events.Event;
import flash.media.Sound;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Player
//
public class Player extends Actor
{
  // Jump sound.
  [Embed(source="../assets/jump.mp3")]
  private static const JumpSoundCls:Class;
  private static const jumpsound:Sound = new JumpSoundCls();

  // Move sound.
  [Embed(source="../assets/move.mp3")]
  private static const MoveSoundCls:Class;
  private static const movesound:Sound = new MoveSoundCls();

  // Player(scene)
  public function Player(scene:Scene, x:int, y:int)
  {
    super(scene, x, y);
  }

  // setDirectionX(dx)
  public function setDirectionX(dx:int):void
  {
    if (_construction) {
      if (dx != 0) {
	_dx = dx*unit;
	_blink = 0;
	movesound.play();
      }
    } else {
      _dx = dx*4;
    }
  }

  // setDirectionY(dy)
  public function setDirectionY(dy:int):void
  {
    if (_construction) {
      if (dy != 0) {
	_dy = dy*unit;
	_blink = 0;
	movesound.play();
      }
    } else {
      jump();
    }
  }

  // jump()
  public override function jump():void
  {
    Main.log("jump!");
    super.jump();
    jumpsound.play();
  }

  // setMode
  public override function setMode(construction:Boolean):void
  {
    super.setMode(construction);

    if (construction) {
      bounds.x = Math.floor(bounds.x/unit)*unit;
      bounds.y = Math.floor(bounds.y/unit)*unit;
    }

    this.alpha = 1.0;
    graphics.clear();
    graphics.beginFill(0x00cc00);
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
  }
  
  // blinking status.
  private var _blink:int;
  private static const cycle:int = 10;

  public override function update():void
  {
    super.update();
    if (_construction) {
      _blink++;
      var phase:int = (_blink % (cycle*2));
      this.alpha = ((phase < cycle)? (cycle-phase) : (phase-cycle))/(cycle-1);
      _dx = 0;
      _dy = 0;
    }
  }
}

} // package
