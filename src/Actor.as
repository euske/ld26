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

  // Actor(scene, x, y)
  public function Actor(scene:Scene, x:int, y:int)
  {
    super(scene, new Rectangle(x*unit, y*unit, unit, unit));
  }

  // isBlocked(dx, dy): returns true if movement (dx,dy) is blocked.
  private function isBlocked(dx:int, dy:int):Boolean
  {
    var r:Rectangle = getOffsetRect(dx, dy);
    var contacts:Array = scene.getOverlappingMaterials(r);
    return (contacts.length != 0) || scene.hasOverlappingPlatforms(r);
  }

  // setMode(construction)
  public virtual function setMode(construction:Boolean):void
  {
    _construction = construction;
  }

  // setVelocity()
  public virtual function setVelocity(velocity:int):void
  {
    if (vy == 0 && isBlocked(0, +1)) {
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
      var contacts:Array = scene.getOverlappingMaterials(r);
      var material:Material;
      for each (material in contacts) {
	  if (!material.applyForce(_dx, _dy)) {
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
	for each (material in contacts) {
	  material.clearForce();
	}
      }
      _dx = 0;
      _dy = 0;
    } else {
      // platformer mode.
      vy += 2;
      vx = _dx;
      while (vx != 0 || vy != 0) {
	if (!isBlocked(vx, vy)) break;
       	vx = (vx < 0)? Math.ceil(vx*0.9) : Math.floor(vx*0.9);
      	vy = (vy < 0)? Math.ceil(vy*0.9) : Math.floor(vy*0.9);
      }
    }
    super.update();
  }
}

} // package
