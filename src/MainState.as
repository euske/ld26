package {

import flash.display.Bitmap;
import flash.events.Event;
import flash.media.Sound;
import flash.ui.Keyboard;
import flash.geom.Rectangle;
import flash.geom.Point;
import GameState;
import Actor;
import Scene;
import Factory;
//import TileMap;

//  MainState
//
public class MainState extends GameState
{
  // // Tile image:
  // [Embed(source="../assets/tiles.png", mimeType="image/png")]
  // private static const TilesImageCls:Class;
  // private static const tilesimage:Bitmap = new TilesImageCls();

  // // Map image:
  // [Embed(source="../assets/map.png", mimeType="image/png")]
  // private static const MapImageCls:Class;
  // private static const mapimage:Bitmap = new MapImageCls();
  
  // Player image:
  [Embed(source="../assets/player.png", mimeType="image/png")]
  private static const PlayerImageCls:Class;
  private static const playerimage:Bitmap = new PlayerImageCls();

  // Sound:
  [Embed(source="../assets/sound.mp3")]
  private static const JumpSoundCls:Class;
  private static const jump:Sound = new JumpSoundCls();

  /// Game-related functions

  //private var tilemap:TileMap;
  private var scene:Scene;
  private var player:Actor;

  public function MainState(width:int, height:int)
  {
    //tilemap = new TileMap(mapimage.bitmapData, tilesimage.bitmapData, 32);
    scene = new Scene(width, height);
    scene.addFactory(new BoilingFactory(new Rectangle(0, 0, 200, 100), 0xff0000, "OVEN"));
    scene.addFactory(new SeasoningFactory(new Rectangle(400, 0, 200, 100), 0x008844, "SEASONING"));
    
    // cucumber
    scene.addMaterial(new Material(scene, 4, 7, 0x00cc00, 0x88ff00));
    // tomato
    scene.addMaterial(new Material(scene, 6, 6, 0xff0000, 0xff8800));
    // beef
    scene.addMaterial(new Material(scene, 5, 5, 0xcc88cc, 0x884444));
    // pork
    scene.addMaterial(new Material(scene, 7, 3, 0xffcccc, 0xcc8888));
    // lettuce
    scene.addMaterial(new Material(scene, 7, 7, 0x88ffcc, 0x88ff88));
    // tofu
    scene.addMaterial(new Material(scene, 5, 5, 0xcccccc, 0xffffcc));
    // carrot
    scene.addMaterial(new Material(scene, 3, 5, 0xcccc88, 0xcccc88));
    // chicken
    // onion
    // herb?

    player = new Actor(scene, playerimage);
    scene.addActor(player);
  }

  // open()
  public override function open():void
  {
    //addChild(tilemap);
    addChild(scene);
  }

  // close()
  public override function close():void
  {
    //removeChild(tilemap);
    removeChild(scene);
  }

  // update()
  public override function update():void
  {
    scene.update();
    scene.repaint();
  }

  // keydown(keycode)
  public override function keydown(keycode:int):void
  {
    switch (keycode) {
    case Keyboard.LEFT:
    case 65:			// A
    case 72:			// H
      player.setDirection(-1, 0);
      break;

    case Keyboard.RIGHT:
    case 68:			// D
    case 76:			// L
      player.setDirection(+1, 0);
      break;

    case Keyboard.UP:
    case 87:			// W
    case 75:			// K
      player.setDirection(0, -1);
      break;

    case Keyboard.DOWN:
    case 83:			// S
    case 74:			// J
      player.setDirection(0, +1);
      break;

    case Keyboard.SPACE:
    case Keyboard.ENTER:
    case 88:			// X
    case 90:			// Z
      jump.play();
      Main.log("foo");
      break;

    }
  }

  // keyup(keycode)
  public override function keyup(keycode:int):void 
  {
    switch (keycode) {
    case Keyboard.LEFT:
    case Keyboard.RIGHT:
    case 65:			// A
    case 68:			// D
    case 72:			// H
    case 76:			// L
      player.setDirection(0, 0);
      break;

    case Keyboard.UP:
    case Keyboard.DOWN:
    case 87:			// W
    case 75:			// K
    case 83:			// S
    case 74:			// J
      player.setDirection(0, 0);
      break;
    }
  }
}

} // package