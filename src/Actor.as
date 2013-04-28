package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Actor
//
public class Actor extends Entity
{
  // _construction:
  protected var _construction:Boolean = true;
  // _dx, _dy: intent to move.
  protected var _dx:int, _dy:int;
  
  public static const gravity:int = 2;

  // Actor(scene, x, y)
  public function Actor(scene:Scene, x:int, y:int)
  {
    super(scene, new Rectangle(x*unit, y*unit, unit, unit));
  }

  // setMode(construction)
  public override function setMode(construction:Boolean):void
  {
    super.setMode(construction);
    _construction = construction;
    if (construction) {
      setPosition(Math.floor(bounds.x/unit)*unit,
		  Math.floor(bounds.y/unit)*unit);
    }
    vx = 0;
    vy = 0;
    _dx = 0;
    _dy = 0;
  }

  // setVelocity()
  public virtual function setVelocity(velocity:int):void
  {
    if (vy == 0 && isBlocked(0, -velocity)) {
      vy = velocity;
    }
  }
  
  // update()
  public override function update():void
  {
    if (_construction) {
      // construction mode.
      _dx *= unit;
      _dy *= unit;
      var r:Rectangle = getOffsetRect(_dx, _dy);
      var allowed:Boolean = scene.isInsideScreen(r);
      var entities:Array = scene.getOverlappingEntities(r);
      var entity:Entity;
      for each (entity in entities) {
	  if (!entity.applyForce(_dx, _dy)) {
	    allowed = false;
	    break;
	  }
	}
      if (allowed) {
	vx = _dx;
	vy = _dy;
      } else {
	vx = 0;
	vy = 0;
	for each (entity in entities) {
	  entity.clearForce();
	}
      }
      _dx = 0;
      _dy = 0;
    } else {
      // platformer mode.
      vy += gravity;
      vx = _dx;
      while (vx != 0 || vy != 0) {
	if (!isBlocked(vx, vy)) break;
       	vx = (vx < 0)? Math.ceil(vx*0.9) : Math.floor(vx*0.9);
      	vy = (vy < 0)? Math.ceil(vy*0.9) : Math.floor(vy*0.9);
      }
    }
    super.update();
  }

  // isBlocked(dx, dy): returns true if movement (dx,dy) is blocked.
  private function isBlocked(dx:int, dy:int):Boolean
  {
    var r:Rectangle = getOffsetRect(dx, dy);
    if (!scene.isInsideScreen(r) ||
	scene.hasOverlappingPlatforms(r)) return true;
    var entities:Array = scene.getOverlappingEntities(r);
    return (entities.length != 0);
  }

}

} // package
