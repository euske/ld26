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

  // Enemy(scene, image)
  public function Enemy(scene:Scene, skin:Bitmap)
  {
    super(scene, skin);
  }

  // update()
  public override function update():void
  {
    if (Math.random() < 0.01) {
      _gx = Math.floor(Math.random()*scene.bounds.width/32)*32;
      _gy = Math.floor(Math.random()*scene.bounds.height/32)*32;
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
