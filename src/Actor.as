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
    if (isBlocked(0, -velocity)) {
      vy = velocity;
    }
  }
  
  // blinking status.
  private var _blink:int;
  private static const cycle:int = 10;
  protected virtual function get blinking():Boolean
  {
    return false;
  }

  protected virtual function get gravity():int
  {
    return 2;
  }

  // update()
  public override function update():void
  {
    if (moving) {
      _blink = 0;
    }
    if (blinking) {
      var phase:int = (_blink % (cycle*2));
      this.alpha = ((phase < cycle)? (cycle-phase) : (phase-cycle))/(cycle-1);
      _blink++;
    }
    if (_construction) {
      // construction mode.
      var dx:int = _dx*unit;
      var dy:int = _dy*unit;
      var r:Rectangle = getOffsetRect(dx, dy);
      var allowed:Boolean = scene.isInsideScreen(r);
      var entities:Array = scene.getOverlappingEntities(r);
      var entity:Entity;
      for each (entity in entities) {
	  if (!entity.applyForce(dx, dy)) {
	    allowed = false;
	    break;
	  }
	}
      if (allowed) {
	vx = dx;
	vy = dy;
      } else {
	vx = 0;
	vy = 0;
	for each (entity in entities) {
	  entity.clearForce();
	}
      }
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
    for each (var entity:Entity in scene.getOverlappingEntities(r)) {
      if (entity != this) return true;
    }
    return false;
  }

}

} // package
