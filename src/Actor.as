package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Actor
//
public class Actor extends Entity
{
  public var skin:Bitmap;
  public var dx:int, dy:int;

  // Actor(scene, image)
  public function Actor(scene:Scene, skin:Bitmap)
  {
    var rect:Rectangle = new Rectangle(skin.x, skin.y, skin.width, skin.height);
    super(scene, rect);
    this.skin = skin;
    addChild(this.skin);
  }

  // setDirection(dx, dy)
  public function setDirection(dx:int, dy:int):void
  {
    this.dx = dx*8;
    this.dy = dy*8;
  }

  // update()
  public override function update():void
  {
    var entity:Entity;
    var allowed:Boolean = true;
    var contacts:Array = getContacts(dx, dy);
    for each (entity in contacts) {
      if (entity != this) {
	if (!entity.applyForce(dx, dy)) {
	  allowed = false;
	  break;
	}
      }
    }
    if (allowed) {
      vx = dx;
      vy = dy;
    } else {
      vx = 0;
      vy = 0;
      for each (entity in contacts) {
	entity.clearForce();
      }
    }
    super.update();
  }
}

} // package
