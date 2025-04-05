package commands.api;

using StringTools;

typedef LibInfo = {
	var name:String;
	var curversion:String;
	var downloads:Int;
	var contributors:Array<{
		var name:String;
		var fullname:String;
	}>;
	var versions:Array<{
		var name:String;
		var comments:String;
		var downloads:Int;
		var date:String;
	}>;
	var desc:String;
	var owner:String;
	var tags:haxe.ds.List<String>;
	var website:String;
	var license:String;
}

class Haxelib {
	public static function sendHaxelibRequest(path:String, args:Array<String>):Dynamic {
		var data = new haxe.Serializer();
		data.serialize(path.split("/"));
		data.serialize(args);

		var returnValue:Dynamic = null;

		var http = new sys.Http("http://lib.haxe.org/api/3.0/index.n");
		http.setHeader("Content-Type", "application/x-www-form-urlencoded");
		http.setHeader("X-Haxe-Remoting", "1");
		http.onData = function(data) {
			if(data.startsWith("hxr")) {
				//trace(data);
				returnValue = data.substr(3);
			} else {
				trace("Failed to run haxelib command ($path): $data");
			}
		}
		http.onError = function(error) {
			trace('Failed to run haxelib command ($path): $error');
		}
		http.setPostData("__x=" + data.toString().urlEncode());

		http.request();

		return returnValue; // needs to be unserialized
	}

	public static function getLibInfo(lib:String):LibInfo {
		var data = sendHaxelibRequest("api/infos", [lib]);
		var data = haxe.Unserializer.run(data);
		return data;
	}

	public static function getLibPath(name:String, version:String = null):String {
		if(version == null)
			version = getLibInfo(name).curversion;
		return ".haxelib/" + name + "/" + version.replace(".", ",") + "/";
	}

	public static function getVersion(name:String, version:String = null):String {
		if(version == null)
			version = getLibInfo(name).curversion;
		return version;
	}
}