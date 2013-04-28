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
  public var bounds:Rectangle;
  public var vx:int, vy:int;

  public function Entity(scene:Scene, bounds:Rectangle)
  {
    this.scene = scene;
    this.bounds = bounds;
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
