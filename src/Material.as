package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Material
//
public class Material extends Entity
{
  // Material(scene, pt)
  public function Material(scene:Scene, bounds:Rectangle)
  {
    super(scene, bounds);
    updateState();
  }
  
  public override function process():void
  {
    _boiled = true;
    updateState();
  }

  private var _boiled:Boolean;
  
  private function updateState():void
  {
    var r:int = Math.floor(Math.random()*256);
    var g:int = Math.floor(Math.random()*256);
    var b:int = Math.floor(Math.random()*256);
    graphics.clear();
    graphics.beginFill(r << 16 | g << 8 | b);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
  }
}

} // package
