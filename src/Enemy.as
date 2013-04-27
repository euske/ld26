package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Enemy
//
public class Enemy extends Actor
{
  private var _gx:int = 128;
  private var _gy:int = 128;

  // Enemy(scene)
  public function Enemy(scene:Scene, x:int, y:int)
  {
    super(scene, x, y);
    graphics.beginFill(0xff8800)
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
  }

  // update()
  public override function update():void
  {
    if (Math.random() < 0.01) {
      _gx = Math.floor(Math.random()*scene.size.x/32)*32;
      _gy = Math.floor(Math.random()*scene.size.y/32)*32;
    }
    if (bounds.x < _gx) {
      _dx = +8;
    } else if (_gx < bounds.x) {
      _dx = -8;
    }
    if (bounds.y < _gy) {
      _dy = +8;
    } else if (_gy < bounds.y) {
      _dy = -8;
    }
    Main.log("_dx="+_dx+", _dy="+_dy);
    super.update();
  }
}

} // package
