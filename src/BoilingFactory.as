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
    
  // putMaterial(material): makes the material boiled.
  public override function putMaterial(material:Material):void
  {
    super.putMaterial(material);
    material.boil();
  }
}

} // package

