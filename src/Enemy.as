package {

import flash.display.Bitmap;
import flash.media.Sound;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Enemy
//
public class Enemy extends Actor
{
  // Explosion sound.
  [Embed(source="../assets/explosion.mp3")]
  private static const ExplosionSoundCls:Class;
  private static const explosionsound:Sound = new ExplosionSoundCls();

  public var lethal:Boolean;

  // Enemy(scene)
  public function Enemy(scene:Scene, lethal:Boolean, x:int, y:int, w:int, h:int)
  {
    super(scene, x, y);
    this.lethal = lethal;

    _orbit = new Rectangle(x*unit, y*unit, w*unit, h*unit);
    _dx = +1; _dy = 0;
  }

  // setMode
  public override function setMode(construction:Boolean):void
  {
    super.setMode(construction);
    _dead = false;
    updateGraphics();
  }

  // die
  public function die():void
  {
    if (!_dead) {
      _dead = true;
      updateGraphics();
      explosionsound.play();
    }
  }

  // dead
  public function get dead():Boolean
  {
    return _dead;
  }

  private var _dead:Boolean;
  private var _orbit:Rectangle;
  private var _dx:int, _dy:int;

  private function updateGraphics():void
  {
    graphics.clear();
    if (!_dead) {
      graphics.beginFill(lethal? 0x880000 : 0x444444);
      graphics.drawRect(0, 0, unit, unit);
      graphics.endFill();
    }
  }

  protected override function get blinking():Boolean
  {
    return !_construction;
  }
  
  // update()
  public override function update():void
  {
    if (_dead) return;

    var r:Rectangle = getOffsetRect(_dx*unit, _dy*unit);
    if (_orbit.right <= r.left) {
      _dx = 0; _dy = +1;
    } else if (_orbit.bottom <= r.top) {
      _dx = -1; _dy = 0;
    } else if (r.right <= _orbit.left) {
      _dx = 0; _dy = -1;
    } else if (r.bottom <= _orbit.top) {
      _dx = +1; _dy = 0;
    }
    if (_construction) {
      vx = _dx*unit;
      vy = _dy*unit;
    } else {
      if (lethal) {
	vx = _dx*16;
	vy = _dy*16;
      } else {
	vx = _dx*8;
	vy = _dy*8;
      }
    }
    super.update();
  }
}

} // package
