package commands;

import sys.io.File;

class Optimizer {
	public static function main(args:Array<String>) {
		var args = ArgParser.parse(args);
		var saveOld = args.existsOption("no-old");

		if(args.length == 0) {
			Sys.println(Main.curCommand.dDoc);
			return;
		}

		var filename = args.get(0);

		var data = File.getContent(filename);
		var json = null;
		try {
			json = haxe.Json.parse(data);
		} catch(e:Dynamic) {
			Sys.println("Error parsing JSON file.");
			Sys.println(e);
			return;
		}

		if(saveOld)
			File.saveContent(filename + ".old", data);
		File.saveContent(filename, haxe.Json.stringify(json));
	}
}