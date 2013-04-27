package {

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import TileMap;
import Entity;

//  Scene
// 
public class Scene extends Sprite
{
  private var _tilemap:TileMap;
  private var _window:Rectangle;
  private var _mapsize:Point;

  // entities
  public var entities:Array = [];

  // Scene(width, height, tilemap)
  public function Scene(width:int, height:int, tilemap:TileMap)
  {
    _window = new Rectangle(0, 0, width, height);
    _tilemap = tilemap;
    _mapsize = new Point(tilemap.mapwidth*tilemap.tilesize,
			 tilemap.mapheight*tilemap.tilesize);
  }

  // add(entity)
  public function add(entity:Entity):void
  {
    addChild(entity);
    entities.push(entity);
  }

  // remove(entity)
  public function remove(entity:Entity):void
  {
    removeChild(entity);
    entities.splice(entities.indexOf(entity), 1);
  }

  // getContacts(rect)
  public function getContacts(rect:Rectangle):Array
  {
    var contacts:Array = new Array();
    for each (var entity:Entity in entities) {
      if (entity.bounds.intersects(rect)) {
	contacts.push(entity);
      }
    }
    return contacts;
  }

  // update()
  public function update():void
  {
    for each (var entity:Entity in entities) {
      entity.update();
    }
  }

  // repaint()
  public function repaint():void
  {
    for each (var entity:Entity in entities) {
      entity.repaint();
    }
    _tilemap.repaint(_window);
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
