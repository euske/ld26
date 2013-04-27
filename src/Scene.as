package {

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
//import TileMap;
import Entity;
import Actor;
import Material;

//  Scene
// 
public class Scene extends Sprite
{
  //private var _tilemap:TileMap;
  private var _mapsize:Point;
  private var _window:Rectangle;
  private var _mode:int = 0;

  // actors
  public var actors:Array = [];
  // materials
  public var materials:Array = [];
  // factories
  public var factories:Array = [];

  // Scene(width, height)
  public function Scene(width:int, height:int)
  {
    //_tilemap = tilemap;
    //_mapsize = new Point(tilemap.mapwidth*tilemap.tilesize,
    //tilemap.mapheight*tilemap.tilesize);
    _mapsize = new Point(width, height);
    _window = new Rectangle(0, 0, width, height);
    
    graphics.beginFill(0xffffff);
    graphics.drawEllipse(0, 0, width, height);
    graphics.endFill();
    graphics.lineStyle(4, 0x000000);
    graphics.drawEllipse(width/8, height/8, width*3/4, height*3/4);
    
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
    var d:int = 16;
    var bounds:Rectangle = material.bounds;
    var x1:int = (_mapsize.x-bounds.width)/d;
    var y1:int = (_mapsize.y-bounds.height)/d;
    for (;;) {
      bounds.x = Math.floor(Math.random()*x1)*d;
      bounds.y = Math.floor(Math.random()*y1)*d;
      if (!hasEntityOverlapping(bounds)) break;
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

  // hasEntityOverlapping(rect)
  public function hasEntityOverlapping(rect:Rectangle):Boolean
  {
    for each (var entity:Entity in materials) {
	if (entity.bounds.intersects(rect)) return true;
    }
    return false;
  }

  // getOverlappingEntities(rect)
  public function getOverlappingEntities(rect:Rectangle):Array
  {
    var contacts:Array = new Array();
    for each (var entity:Entity in materials) {
      if (entity.bounds.intersects(rect)) {
	contacts.push(entity);
      }
    }
    return contacts;
  }

  // toggleMode()
  public function toggleMode():void
  {
    _mode = 1-_mode;
    for each (var actor:Actor in actors) {
      actor.setMode(_mode);
    }
  }

  // update()
  public function update():void
  {
    var entity:Entity;
    for each (entity in materials) {
      entity.clearForce();
      entity.clearConnection();
    }
    for each (entity in materials) {
       for each (var entity2:Entity in materials) {
	  if (entity.hasContact(entity2)) {
	    entity.connectEntity(entity2);
	  }
	}
    }
    var groups:Array = new Array();
    for each (entity in materials) {
	if (entity.group != null && groups.indexOf(entity.group) == -1) {
	  groups.push(entity.group);
	}
      }
    for each (var actor:Actor in actors) {
      actor.update();
    }
    for each (entity in materials) {
      entity.update();
      for each (var factory:Factory in factories) {
	  if (factory.canAcceptEntity(entity)) {
	    factory.putEntity(entity);
	  }
      }
    }
  }

  // repaint()
  public function repaint():void
  {
    for each (var actor:Actor in actors) {
      actor.repaint();
    }
    for each (var entity:Entity in materials) {
      entity.repaint();
    }
    //_tilemap.repaint(_window);
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
    } else if (_mapsize.x < _window.x+_window.width) {
      _window.x = _mapsize.x-_window.width;
    }
    if (_window.y < 0) {
      _window.y = 0;
    } else if (_mapsize.y < _window.y+_window.height) {
      _window.y = _mapsize.y-_window.height;
    }
  }

  // translatePoint(p)
  public function translatePoint(p:Point):Point
  {
    return new Point(p.x-_window.x, p.y-_window.y);
  }
}

} // package
