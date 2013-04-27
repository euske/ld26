package {

import flash.geom.Rectangle;
import Factory;

//  SeasoningFactory
//
public class SeasoningFactory extends Factory
{
  public function SeasoningFactory(bounds:Rectangle, color:uint, name:String)
  {
    super(bounds, color, name);
  }
    
  public override function putEntity(entity:Entity):void
  {
    super.putEntity(entity);
    entity.season();
  }
}

} // package

