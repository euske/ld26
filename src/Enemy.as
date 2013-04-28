package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Enemy
//
public class Enemy extends Actor
{
  public var lethal:Boolean;

  // Enemy(scene)
  public function Enemy(scene:Scene, lethal:Boolean, x:int, y:int, w:int, h:int)
  {
    super(scene, x, y);
    this.lethal = lethal;

    graphics.beginFill(lethal? 0x880000 : 0x444444);
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
    _orbit = new Rectangle(x*unit, y*unit, w*unit, h*unit);
    _dx = +1; _dy = 0;
  }

  private var _orbit:Rectangle;
  private var _dx:int, _dy:int;

  protected override function get blinking():Boolean
  {
    return !_construction;
  }
  
  // update()
  public override function update():void
  {
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
      vx = _dx*8;
      vy = _dy*8;
    }
    super.update();
  }
}

} // package
