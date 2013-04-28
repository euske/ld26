package {

import flash.geom.Rectangle;
import flash.media.Sound;
import Factory;

//  SeasoningFactory
//
public class SeasoningFactory extends Factory
{
  public function SeasoningFactory(bounds:Rectangle)
  {
    super(bounds, 0xddcc44, "SEASON");
  }

  // putMaterial(material): makes the material seasoned.
  public override function putMaterial(material:Material):void
  {
    super.putMaterial(material);
    material.season();
  }
}

} // package

