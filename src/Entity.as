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
  public var group:Array;

  // Entity(scene, rect)
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

  // getOverlappingEntities(vx, vy): returns a list of overlapping Entities.
  public function getOverlappingEntities(vx:int, vy:int):Array
  {
    return scene.getOverlappingEntities(getOffsetRect(vx, vy));
  }

  // clearForce(): clear forces.
  public function clearForce():void
  {
    this.vx = 0;
    this.vy = 0;
  }

  // applyForce(vx, vy): apply forces, returns true if it's movable.
  public function applyForce(vx:int, vy:int):Boolean
  {
    if (this.vx != 0 || this.vy != 0) return false;
    for each (var entity:Entity in getOverlappingEntities(vx, vy)) {
      if (entity != this) {
	if (!entity.applyForce(vx, vy)) return false;
      }
    }
    this.vx = vx;
    this.vy = vy;
    return true;
  }

  // hasContact(entity)
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

  // clearConnection(): clear connections.
  public function clearConnection():void
  {
    this.group = null;
  }

  // connectEntity(entity): connect two entities.
  public function connectEntity(entity:Entity):void
  {
    if (this.group == null) {
      if (entity.group != null) {
	this.group = entity.group;
	this.group.push(this);
      } else {
	// this.group == null, entity.group == null
	var a:Array = [ this, entity ];
	this.group = a;
	entity.group = a;
      }
    } else {
      if (entity.group == null) {
	entity.group = this.group;
	entity.group.push(entity);
      } else {
	// this.group != null, entity.group != null
	entity.group.concat(this.group);
	for each (var e:Entity in this.group) {
	  e.group = entity.group;
	}
      }
    }
  }

  // update()
  public virtual function update():void
  {
    bounds.x += vx;
    bounds.y += vy;
  }

  // repaint()
  public virtual function repaint():void
  {
    var p:Point = scene.translatePoint(bounds.topLeft);
    this.x = p.x;
    this.y = p.y;
  }

  // boil()
  public virtual function boil():void
  {
  }

  // season()
  public virtual function season():void
  {
  }
  
}

} // package
