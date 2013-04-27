package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Factory
//
public class Factory extends Sprite
{
  private var _bounds:Rectangle;
  private var _materials:Array = [];
  
  public function Factory(bounds:Rectangle, color:uint, name:String)
  {
    graphics.beginFill(0xffffff);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    graphics.lineStyle(4, color);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    x = bounds.x;
    y = bounds.y;
    addChild(Main.Font.render(name, 0x000000, 2));
    _bounds = bounds;
  }
    
  // canAcceptMaterial(material): returns true if it can accept the material.
  public function canAcceptMaterial(material:Material):Boolean
  {
    return (_bounds.intersects(material.bounds) &&
	    _materials.indexOf(material) == -1);
  }

  // putMaterial(material): put the material into "in" state and make some change.
  public virtual function putMaterial(material:Material):void
  {
    _materials.push(material);
  }
}

} // package

