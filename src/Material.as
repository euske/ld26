package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Material
//
public class Material extends Entity
{
  // group: An array of materials it belongs.
  public var group:Array;
  // shape:
  public var shape:int;
  // raw material color.
  public var rawcolor:uint;
  // roasted material color.
  public var roastedcolor:uint;

  // true if roasted.
  private var _roasted:Boolean;
  // true if seasoned.
  private var _seasoned:Boolean;
  // number of connected components.
  private var _connected:int;

  // Material(scene, pt)
  public function Material(scene:Scene, 
			   x:int, y:int, width:int, height:int, 
			   shape:int, rawcolor:uint, roastedcolor:uint)
  {
    super(scene, new Rectangle(x*unit, y*unit, width*unit, height*unit));
    this.shape = shape;
    this.rawcolor = rawcolor;
    this.roastedcolor = roastedcolor;
    updateGraphics();
  }
  
  // clearForce(): clear forces.
  public function clearForce():void
  {
    vx = 0;
    vy = 0;
  }

  // applyForce(dx, dy): apply forces, returns true if it's movable.
  public function applyForce(dx:int, dy:int):Boolean
  {
    var r:Rectangle = getOffsetRect(dx, dy);
    if (vx != 0 || vy != 0) return false;
    if (!scene.isInsideScreen(r)) return false;
    for each (var material:Material in scene.getOverlappingMaterials(r)) {
      if (material != this) {
	if (!material.applyForce(dx, dy)) return false;
      }
    }
    vx = dx;
    vy = dy;
    return true;
  }

  // clearConnection(): clear connections.
  public function clearConnection():void
  {
    this.group = null;
  }

  // connectTo(material): connect two materials.
  public function connectTo(material:Material):void
  {
    if (this.group == null) {
      if (material.group != null) {
	this.group = material.group;
	this.group.push(this);
      } else {
	// this.group == null, material.group == null
	var a:Array = new Array();
	a.push(this);
	this.group = a;
	a.push(material);
	material.group = a;
      }
    } else {
      if (material.group == null) {
	material.group = this.group;
	material.group.push(material);
      } else {
	// this.group != null, material.group != null
	material.group.concat(this.group);
	for each (var m:Material in this.group) {
	  m.group = material.group;
	}
      }
    }
  }

  // roast()
  public function roast():void
  {
    _roasted = true;
    updateGraphics();
  }

  // season()
  public function season():void
  {
    _seasoned = true;
    updateGraphics();
  }

  // update()
  public override function update():void
  {
    super.update();
    var connected:int = (this.group == null)? 0 : this.group.length;
    if (_connected != connected) {
      _connected = connected;
      //Main.log("connected:"+connected);
      updateGraphics();
    }
  }

  // updateGraphics()
  private function updateGraphics():void
  {
    graphics.clear();
    graphics.beginFill((_roasted)? roastedcolor : rawcolor);
    switch (shape) {
    case 1:
      graphics.drawRoundRect(0, 0, bounds.width, bounds.height, 8, 8);
      break;
    case 2:
      graphics.drawEllipse(0, 0, bounds.width, bounds.height);
      break;
    default:
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    }
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
    switch (_connected) {
    case 0:
    case 1:
      break;
    case 2:
      graphics.lineStyle(2, 0xffff00);
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    case 3:
      graphics.lineStyle(4, 0xff8800);
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    default:
      graphics.lineStyle(4, 0xcc0000);
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    }
  }
}

} // package
