package {

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Factory
//
public class Factory extends Sprite
{
  // bounds:
  private var _bounds:Rectangle;
  // Materials it is processing.
  private var _materials:Array = [];
  
  public function Factory(bounds:Rectangle, color:uint, name:String)
  {
    var text:Bitmap = Main.Font.render(name, 0x000000, 2);
    text.x = (bounds.width-text.width)/2;
    text.y = (bounds.height-text.height)/2;
    addChild(text);
    graphics.beginFill(color);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    graphics.lineStyle(4, 0xffffff);
    graphics.drawRect(8, 8, bounds.width-16, bounds.height-16);
    x = bounds.x;
    y = bounds.y;
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

