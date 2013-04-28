package {

import flash.geom.Rectangle;
import flash.media.Sound;
import Factory;

//  RoastingFactory
//
public class RoastingFactory extends Factory
{
  public function RoastingFactory(bounds:Rectangle)
  {
    super(bounds, 0x884444, "ROAST");
  }
    
  // putMaterial(material): makes the material roasted.
  public override function putMaterial(material:Material):void
  {
    super.putMaterial(material);
    material.roast();
  }
}

} // package

