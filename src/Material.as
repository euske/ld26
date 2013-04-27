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
  private var _highlight:int;
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

  public override function update():void
  {
    super.update();
    var highlight:int = (this.group == null)? 0 : this.group.length;
    if (_highlight != highlight) {
      _highlight = highlight;
      //Main.log("highlight:"+highlight);
      updateState();
    }
  }
  
  private function updateState():void
  {
    graphics.clear();
    graphics.beginFill((_boiled)? _boiledcolor : _rawcolor);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    if (_seasoned) {
      var v:int = (917+bounds.width)*(43+bounds.height);
      for (var i:int = 0; i < 10; i++) {
	var x:int = v % (bounds.width-4);
	v = ((v+729)*899) % 65537;
	var y:int = v % (bounds.height-4);
	v = ((v+729)*899) % 65537;
	graphics.beginFill(0);
	graphics.drawRect(x, y, 4, 4);
	graphics.endFill();
      }
    }
    switch (_highlight) {
    case 2:
      graphics.lineStyle(2, 0xffff00);
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    case 3:
      graphics.lineStyle(4, 0xff8800);
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    case 4:
      graphics.lineStyle(4, 0xcc0000);
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    default:
      break;
    }
  }
}

} // package
