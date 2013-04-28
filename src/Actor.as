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
    this.alpha = 1.0;
    vx = 0;
    vy = 0;
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
  protected function resetblink():void
  {
    _blink = 0;
  }

  // update()
  public override function update():void
  {
    if (blinking) {
      var phase:int = (_blink % (cycle*2));
      this.alpha = ((phase < cycle)? (cycle-phase) : (phase-cycle))/(cycle-1);
      _blink++;
    } else {
      resetblink();
    }
    if (_construction) {
      // push things.
      var r:Rectangle = getOffsetRect(vx, vy);
      var allowed:Boolean = scene.isInsideScreen(r);
      var entities:Array = scene.getOverlappingEntities(r);
      var entity:Entity;
      for each (entity in entities) {
	  if (!entity.applyForce(vx, vy)) {
	    allowed = false;
	    break;
	  }
	}
      if (!allowed) {
	vx = 0;
	vy = 0;
	for each (entity in entities) {
	  entity.clearForce();
	}
      }
    } else {
      while (vx != 0 || vy != 0) {
	if (!isBlocked(vx, vy)) break;
       	vx = (vx < 0)? Math.ceil(vx*0.9) : Math.floor(vx*0.9);
      	vy = (vy < 0)? Math.ceil(vy*0.9) : Math.floor(vy*0.9);
      }
    }
    super.update();
  }

  // isBlocked(dx, dy): returns true if movement (dx,dy) is blocked.
  protected function isBlocked(dx:int, dy:int):Boolean
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
