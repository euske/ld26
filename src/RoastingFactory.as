package {

import flash.geom.Rectangle;
import Factory;

//  RoastingFactory
//
public class RoastingFactory extends Factory
{
  public function RoastingFactory(bounds:Rectangle, color:uint, name:String)
  {
    super(bounds, color, name);
  }
    
  // putMaterial(material): makes the material roasted.
  public override function putMaterial(material:Material):void
  {
    super.putMaterial(material);
    material.roast();
  }
}

} // package

