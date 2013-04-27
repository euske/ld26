package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Entity
//
public class Entity extends Sprite
{
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
    return (((bounds.left == entity.bounds.right ||
	      bounds.right == entity.bounds.left) &&
	     !(entity.bounds.bottom <= bounds.top ||
	       bounds.bottom <= entity.bounds.top)) ||
	    ((bounds.top == entity.bounds.bottom ||
	      bounds.bottom == entity.bounds.top) &&
	     !(entity.bounds.right <= bounds.left ||
	       bounds.right <= entity.bounds.left)));
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
