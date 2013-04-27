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

  // _construction:
  protected var _construction:Boolean = true;
  // _dx, _dy: intent to move.
  protected var _dx:int, _dy:int;

  // Actor(scene, image)
  public function Actor(scene:Scene, skin:Bitmap)
  {
    var rect:Rectangle = new Rectangle(128, 128, skin.width, skin.height);
    super(scene, rect);
    this.skin = skin;
    addChild(new Bitmap(skin.bitmapData));
  }

  // setMode(construction)
  public function setMode(construction:Boolean):void
  {
    _construction = construction;
  }
  
  // setDirectionX(dx)
  public function setDirectionX(dx:int):void
  {
    _dx = dx*8;
  }

  // setDirectionY(dy)
  public function setDirectionY(dy:int):void
  {
    _dy = dy*8;
  }

  // isBlocked(dx, dy): returns true if movement (dx,dy) is blocked.
  private function isBlocked(dx:int, dy:int):Boolean
  {
    var r:Rectangle = getOffsetRect(dx, dy);
    var contacts:Array = scene.getOverlappingMaterials(r);
    return (contacts.length != 0);
  }

  // update()
  public override function update():void
  {
    if (_construction) {
      // construction mode.
      var material:Material;
      var allowed:Boolean = true;
      var r:Rectangle = getOffsetRect(_dx, _dy);
      var contacts:Array = scene.getOverlappingMaterials(r);
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
    } else {
      // platformer mode.
      if (_dy < 0 && isBlocked(0, -_dy)) {
	// jump
	vy = _dy*4;
      }
      _dy = 0;
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
