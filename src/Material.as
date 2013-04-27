package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Material
//
public class Material extends Entity
{
  // Material(scene, pt)
  public function Material(scene:Scene, pt:Point)
  {
    super(scene, 
	  new Rectangle(pt.x, pt.y,
			Math.floor(Math.random()*2+1)*32,
			Math.floor(Math.random()*2+1)*32));
    graphics.clear();
    graphics.beginFill(0xffff00);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
  }

}

} // package
