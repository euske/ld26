package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Enemy
//
public class Enemy extends Actor
{
  private var _orbit:Rectangle;

  // Enemy(scene)
  public function Enemy(scene:Scene, x:int, y:int, w:int, h:int)
  {
    super(scene, x, y);
    
    graphics.beginFill(0x444444);
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
    _orbit = new Rectangle(x*unit, y*unit, w*unit, h*unit);
  }

  protected override function get blinking():Boolean
  {
    return !_construction;
  }
  
  protected override function get gravity():int
  {
    return 0;
  }

  // update()
  public override function update():void
  {
    if ((_orbit.left == bounds.left && _orbit.top == bounds.top) ||
	(_orbit.right == bounds.right && _orbit.top == bounds.top) ||
	(_orbit.left == bounds.left && _orbit.bottom == bounds.bottom) ||
	(_orbit.right == bounds.right && _orbit.bottom == bounds.bottom)) {
      // turn 90 degree (clockwise)
      if (_dx == 0 && _dy == 0) {
	_dx = 1;
	_dy = 0;
      } else {
	var v:int = _dx;
	_dx = -_dy;
	_dy = v;
      }
    }
    super.update();
  }
}

} // package
