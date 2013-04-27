package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Material
//
public class Material extends Entity
{
  private var _boiled:Boolean;
  private var _seasoned:Boolean;
  private var _rawcolor:uint;
  private var _boiledcolor:uint;

  // Material(scene, pt)
  public function Material(scene:Scene, 
			   width:int, height:int,
			   rawcolor:uint, boiledcolor:uint)
  {
    super(scene, new Rectangle(0, 0, width*16, height*16));
    _rawcolor = rawcolor;
    _boiledcolor = boiledcolor;
    updateState();
  }
  
  public override function boil():void
  {
    _boiled = true;
    updateState();
  }
  
  public override function season():void
  {
    _seasoned = true;
    updateState();
  }
  
  private function updateState():void
  {
    graphics.clear();
    graphics.beginFill((_boiled)? _boiledcolor : _rawcolor);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    if (_seasoned) {
      graphics.beginFill(0);
      var v:int = (917+bounds.width)*(43+bounds.height);
      for (var i:int = 0; i < 10; i++) {
	var x:int = v % (bounds.width-4);
	v = ((v+729)*899) % 65537;
	var y:int = v % (bounds.height-4);
	v = ((v+729)*899) % 65537;
	graphics.drawRect(x, y, 4, 4);
      }
      graphics.endFill();
    }
  }
}

} // package
