package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Enemy
//
public class Enemy extends Actor
{
  // Enemy(scene)
  public function Enemy(scene:Scene, x:int, y:int)
  {
    super(scene, x, y);

    graphics.beginFill(0x444444);
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
  }

  // update()
  public override function update():void
  {
    if (Math.random() < 0.1) {
      _dx = Math.floor(Math.random()*3-1);
    }
    if (Math.random() < 0.1) {
      _dy = Math.floor(Math.random()*3-1);
    }
    super.update();
  }
}

} // package
