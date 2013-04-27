package {

import flash.geom.Rectangle;
import Factory;

//  BoilingFactory
//
public class BoilingFactory extends Factory
{
  public function BoilingFactory(bounds:Rectangle, color:uint, name:String)
  {
    super(bounds, color, name);
  }
    
  public override function putEntity(entity:Entity):void
  {
    super.putEntity(entity);
    entity.boil();
  }
}

} // package

