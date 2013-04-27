package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Factory
//
public class Factory extends Sprite
{
  private var _bounds:Rectangle;
  private var _entities:Array = [];
  
  public function Factory(bounds:Rectangle, name:String)
  {
    graphics.beginFill(0xffffff);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    graphics.lineStyle(4, 0xff0000);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    x = bounds.x;
    y = bounds.y;
    addChild(Main.Font.render(name, 0x000000, 2));
    _bounds = bounds;
  }
    
  public function canAcceptEntity(entity:Entity):Boolean
  {
    return (_bounds.intersects(entity.bounds) &&
	    _entities.indexOf(entity) == -1);
  }

  public function putEntity(entity:Entity):void
  {
    _entities.push(entity);
    entity.process();
  }
}

} // package

