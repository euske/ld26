package {

import flash.geom.Rectangle;
import flash.media.Sound;
import Factory;

//  SeasoningFactory
//
public class SeasoningFactory extends Factory
{
  public function SeasoningFactory(bounds:Rectangle, color:uint, name:String)
  {
    super(bounds, color, name);
  }

  // putMaterial(material): makes the material seasoned.
  public override function putMaterial(material:Material):void
  {
    super.putMaterial(material);
    material.season();
  }
}

} // package

