package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Entity
//
public class Entity extends Sprite
{
  // unit size
  public static const unit:int = 32;
  
  public var scene:Scene;
  public var vx:int, vy:int;

  public function Entity(scene:Scene, bounds:Rectangle)
  {
    this.scene = scene;
    this.bounds = bounds;
  }

  // bounds:
  private var _bounds:Rectangle;
  public virtual function get bounds():Rectangle
  {
    return _bounds;
  }
  public virtual function set bounds(rect:Rectangle):void
  {
    _bounds = rect;
  }

  // getOffsetRect(vx, vy): returns an offset rectangle.
  public function getOffsetRect(vx:int, vy:int):Rectangle
  {
    var r:Rectangle = bounds.clone();
    r.offset(vx, vy);
    return r;
  }

  // hasContact(entity): returns true if the entity has a contact.
  public function hasContact(entity:Entity):Boolean
  {
    return (hasContactX(entity) != 0 || 
	    hasContactY(entity) != 0);
  }
  // hasContactX(entity): returns -1, 0, +1
  public function hasContactX(entity:Entity):int
  {
    if (entity.bounds.bottom <= bounds.top ||
	bounds.bottom <= entity.bounds.top) {
      return 0;
    } else if (bounds.left == entity.bounds.right) {
      return -1;		// entity is left
    } else if (bounds.right == entity.bounds.left) {
      return +1;		// entity is right
    } else {
      return 0;
    }
  }
  // hasContactY(entity): returns -1, 0, +1
  public function hasContactY(entity:Entity):int
  {
    if (entity.bounds.right <= bounds.left ||
	bounds.right <= entity.bounds.left) {
      return 0;
    } else if (bounds.top == entity.bounds.bottom) {
      return -1; 		// entity is top
    } else if (bounds.bottom == entity.bounds.top) {
      return +1;		// entity is bottom.
    } else {
      return 0;
    }
  }

  // setMode(construction)
  public virtual function setMode(construction:Boolean):void
  {
  }

  // setPosition():
  public virtual function setPosition(x:int, y:int):void
  {
    bounds.x = x;
    bounds.y = y;
    vx = 0;
    vy = 0;
  }

  // clearForce(): clear forces.
  public virtual function clearForce():void
  {
    vx = 0;
    vy = 0;
  }

  // applyForce(dx, dy): apply forces, returns true if it's movable.
  public virtual function applyForce(dx:int, dy:int):Boolean
  {
    return false;
  }

  // update(): update the position.
  public virtual function update():void
  {
    bounds.x += vx;
    bounds.y += vy;
  }

  // repaint(): display the graphics.
  public virtual function repaint():void
  {
    var p:Point = scene.translatePoint(bounds.topLeft);
    this.x = p.x;
    this.y = p.y;
  }
}

} // package
