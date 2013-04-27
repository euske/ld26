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

  // Entity(scene, rect)
  public function Entity(scene:Scene, bounds:Rectangle)
  {
    this.scene = scene;
    this.bounds = bounds;
  }

  // getContacts(vx, vy): returns a list of Entities that would contact.
  public function getContacts(vx:int, vy:int):Array
  {
    var r:Rectangle = bounds.clone();
    r.offset(vx, vy);
    return scene.getContacts(r);
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
    for each (var entity:Entity in getContacts(vx, vy)) {
      if (entity != this) {
	if (!entity.applyForce(vx, vy)) return false;
      }
    }
    this.vx = vx;
    this.vy = vy;
    return true;
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

  // process()
  public virtual function process():void
  {
  }
}

} // package
