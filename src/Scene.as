package {

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import Entity;
import Actor;
import Material;

//  Scene
// 
public class Scene extends Sprite
{
  // a list of actors.
  public var actors:Array = [];
  // a list of deployed materials.
  public var materials:Array = [];
  // a list of factories.
  public var factories:Array = [];

  // margin
  public const margin:int = 32;

  // scene size
  private var _scenesize:Point;
  // view
  private var _window:Rectangle;
  // construction
  private var _construction:Boolean = true;
  // plate status (10: full, 0: none)
  private var _plate:int = 0;

  // Scene(width, height)
  public function Scene(width:int, height:int)
  {
    _scenesize = new Point(width, height);
    _window = new Rectangle(0, 0, width, height);

    updatePlate(10);
  }
  
  // setCenter(p)
  public function setCenter(p:Point, hmargin:int, vmargin:int):void
  {
    // Center the window position.
    if (p.x-hmargin < _window.x) {
      _window.x = p.x-hmargin;
    } else if (_window.x+_window.width < p.x+hmargin) {
      _window.x = p.x+hmargin-_window.width;
    }
    if (p.y-vmargin < _window.y) {
      _window.y = p.y-vmargin;
    } else if (_window.y+_window.height < p.y+vmargin) {
      _window.y = p.y+vmargin-_window.height;
    }
    
    // Adjust the window position to fit the world.
    if (_window.x < 0) {
      _window.x = 0;
    } else if (_scenesize.x < _window.x+_window.width) {
      _window.x = _scenesize.x-_window.width;
    }
    if (_window.y < 0) {
      _window.y = 0;
    } else if (_scenesize.y < _window.y+_window.height) {
      _window.y = _scenesize.y-_window.height;
    }
  }

  // translatePoint(p)
  public function translatePoint(p:Point):Point
  {
    return new Point(p.x-_window.x, p.y-_window.y);
  }

  // addActor(actor)
  public function addActor(actor:Actor):void
  {
    addChild(actor);
    actors.push(actor);
  }

  // addMaterial(material)
  public function addMaterial(material:Material):void
  {
    var d:int = margin/2;
    var bounds:Rectangle = material.bounds;
    var x1:int = (_scenesize.x-margin*2-bounds.width)/d;
    var y1:int = (_scenesize.y-margin*2-bounds.height)/d;
    for (;;) {
      bounds.x = Math.floor(Math.random()*x1)*d+margin;
      bounds.y = Math.floor(Math.random()*y1)*d+margin;
      if (!hasMaterialOverlapping(bounds)) break;
    }
    addChild(material);
    materials.push(material);
  }

  // addFactory(factory)
  public function addFactory(factory:Factory):void
  {
    addChild(factory);
    factories.push(factory);
  }

  // removeMaterial(material)
  public function removeMaterial(material:Material):void
  {
    removeChild(material);
    materials.splice(materials.indexOf(material), 1);
  }

  // hasMaterialOverlapping(rect)
  public function hasMaterialOverlapping(rect:Rectangle):Boolean
  {
    for each (var material:Material in materials) {
	if (material.bounds.intersects(rect)) return true;
    }
    return false;
  }

  // getOverlappingMaterials(rect)
  public function getOverlappingMaterials(rect:Rectangle):Array
  {
    var contacts:Array = new Array();
    for each (var material:Material in materials) {
      if (material.bounds.intersects(rect)) {
	contacts.push(material);
      }
    }
    return contacts;
  }

  // isInsideScreen(rect):
  public function isInsideScreen(rect:Rectangle):Boolean
  {
    return (margin <= rect.left && rect.right <= _scenesize.x-margin &&
	    margin <= rect.top && rect.bottom <= _scenesize.y-margin);
  }

  // toggleMode()
  public function toggleMode():void
  {
    _construction = !_construction;

    var factory:Factory;
    for each (var actor:Actor in actors) {
      actor.setMode(_construction);
    }
    if (_construction) {
      for each (factory in factories) {
	addChild(factory);
      }
    } else {
      for each (factory in factories) {
	removeChild(factory);
      }
    }
  }

  // update()
  public function update():void
  {
    var material:Material;
    // initialize.
    for each (material in materials) {
      material.clearForce();
      material.clearConnection();
    }
    // move actors.
    for each (var actor:Actor in actors) {
      actor.update();
    }
    if (_construction) {
      // detect grouped materials.
      var groups:Array = new Array();
      for each (material in materials) {
	  if (material.group != null && groups.indexOf(material.group) == -1) {
	    groups.push(material.group);
	  }
	}
      for each (material in materials) {
	  for each (var m:Material in materials) {
	      if (material.hasContact(m)) {
		material.connectTo(m);
	      }
	    }
	}
      // move/update materials.
      for each (material in materials) {
	  material.update();
	  for each (var factory:Factory in factories) {
	      if (factory.canAcceptMaterial(material)) {
		factory.putMaterial(material);
	      }
	    }
	}
    }
    // update the plate.
    if (_construction) {
      updatePlate(10);
    } else {
      updatePlate(0);
    }
  }

  // repaint()
  public function repaint():void
  {
    for each (var actor:Actor in actors) {
      actor.repaint();
    }
    for each (var material:Material in materials) {
      material.repaint();
    }
  }

  // updatePlate(plate): draws a plate.
  private function updatePlate(plate:int):void
  {
    if (_plate == plate) return;
    if (_plate < plate) {
      // bring up immediately.
      _plate = plate;
    } else {
      // falling down slowly.
      _plate--;
    }
    var h:int = (_window.height-margin*2)*_plate/10;
    var r:Rectangle = new Rectangle(margin, _window.height-h, _window.width-margin*2, h);
    graphics.clear()
    graphics.beginFill(0xffffff);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
    graphics.endFill();
    graphics.lineStyle(4, 0x000000);
    r.inflate(-r.width/8, -r.height/8);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
  }

}

} // package
