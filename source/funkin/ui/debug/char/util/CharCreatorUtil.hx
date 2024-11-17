package funkin.ui.debug.char.util;

import haxe.io.Path;
import haxe.ui.core.Screen;
import haxe.ui.focus.FocusManager;

class CharCreatorUtil
{
  public static var isCursorOverHaxeUI(get, never):Bool;
  public static var isHaxeUIFocused(get, never):Bool;

  static function get_isCursorOverHaxeUI():Bool
  {
    return Screen.instance.hasSolidComponentUnderPoint(Screen.instance.currentMouseX, Screen.instance.currentMouseY);
  }

  static function get_isHaxeUIFocused()
  {
    return FocusManager.instance.focus == null;
  }

  // accounting for both relative and absolute asset paths yuh
  public static function gimmeTheBytes(path:String):haxe.io.Bytes
  {
    if (openfl.Assets.exists(path)) return openfl.Assets.getBytes(path);
    if (!funkin.util.FileUtil.doesFileExist(path)) return null;
    return funkin.util.FileUtil.readBytesFromPath(path);
  }

  // atlas zip json files get kinda freaky
  public static function normalizeJSONText(text:String)
  {
    while (!text.startsWith("{"))
      text = text.substring(1, text.length);
    return text;
  }

  public static function isPathProvided(path:String, checkFor:String = "images/characters"):Bool
  {
    var cwd = Path.addTrailingSlash(Path.normalize(#if sys sys.FileSystem.fullPath(".") #else "." #end));
    path = Path.normalize(path);
    path = path.replace(cwd, "");
    return !Path.isAbsolute(path) && path.indexOf(checkFor) != -1;
  }
}
