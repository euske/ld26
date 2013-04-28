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
  private var _direction:int;
  
  public override function update():void
  {
    if (_direction == 0) {
      if (Math.random() < 0.1) {
	_direction = Math.floor(Math.random()*5);
      }
    } else {
      // _direction != 0
      if (Math.random() < 0.1) {
	_direction = (_direction % 4)+1;
      }
    }
    switch (_direction) {
    case 1:
      _dx = 1; _dy = 0;
      break;
    case 2:
      _dx = 0; _dy = 1;
      break;
    case 3:
      _dx = -1; _dy = 0;
      break;
    case 4:
      _dx = 0; _dy = -1;
      break;
    default:
      break;
    }
    super.update();
  }
}

} // package
