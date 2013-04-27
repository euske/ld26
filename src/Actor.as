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
  // mode
  private var _mode:int = 0;

  // Actor(scene, image)
  public function Actor(scene:Scene, skin:Bitmap)
  {
    var rect:Rectangle = new Rectangle(skin.x, skin.y, skin.width, skin.height);
    super(scene, rect);
    this.skin = skin;
    addChild(this.skin);
  }

  // setMode(mode)
  public function setMode(mode:int):void
  {
    _mode = mode;
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
    if (_mode == 0) {
      // building.
      var entity:Entity;
      var allowed:Boolean = true;
      var contacts:Array = getOverlappingEntities(dx, dy);
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
    } else {
      // platformer.
      if (dy < 0 && getOverlappingEntities(0, -dy).length != 0) {
	// jump
	vy = dy*4;
      }
      dy = 0;
      vy += 2;
      vx = dx;
      while (vx != 0 || vy != 0) {
	if (getOverlappingEntities(vx, vy).length == 0) break;
	if (vy < 0) { vy = 0; }
	vx = Math.floor(vx*0.9);
	vy = Math.floor(vy*0.9);
      }
    }
    super.update();
  }
}

} // package
