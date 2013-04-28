package {

import flash.geom.Rectangle;
import flash.media.Sound;
import Factory;

//  RoastingFactory
//
public class RoastingFactory extends Factory
{
  // Roasting sound.
  [Embed(source="../assets/roast.mp3")]
  private static const RoastSoundCls:Class;
  private static const roastsound:Sound = new RoastSoundCls();

  public function RoastingFactory(bounds:Rectangle)
  {
    super(bounds, 0x884444, "ROAST");
  }
    
  // putMaterial(material): makes the material roasted.
  public override function putMaterial(material:Material):void
  {
    super.putMaterial(material);
    material.roast();
    roastsound.play();
  }
}

} // package

