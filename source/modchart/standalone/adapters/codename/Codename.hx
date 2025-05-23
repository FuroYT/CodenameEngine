package modchart.standalone.adapters.codename;

import flixel.FlxCamera;
import flixel.FlxSprite;
import funkin.backend.system.Conductor;
import funkin.game.Note;
import funkin.game.PlayState;
import funkin.game.Strum;
import funkin.game.Splash;
import funkin.options.Options;
import modchart.standalone.IAdapter;

class Codename implements IAdapter {
	private var beatCrochet:Float = 0;

	public function onModchartingInitialization() {
		beatCrochet = Conductor.crochet;
	}

	public function isTapNote(sprite:FlxSprite) {
		return sprite is Note;
	}

	// Song related
	public function getSongPosition():Float {
		return Conductor.songPosition;
	}

	public function getCurrentBeat():Float {
		return Conductor.curBeatFloat;
	}

	public function getStaticCrochet():Float {
		return beatCrochet;
	}

	public function getBeatFromStep(step:Float):Float {
		return step * Conductor.stepsPerBeat;
	}

	public function arrowHit(arrow:FlxSprite) {
		if (arrow is Note) {
			final note:Note = cast arrow;
			return note.wasGoodHit;
		}
		return false;
	}

	public function isHoldEnd(arrow:FlxSprite) {
		if (arrow is Note) {
			final note:Note = cast arrow;
			return note.nextSustain == null;
		}
		return false;
	}

	public function getLaneFromArrow(arrow:FlxSprite) {
		if (arrow is Note) {
			final note:Note = cast arrow;
			return note.strumID;
		} else if (arrow is Strum) {
			final strum:Strum = cast arrow;
			return strum.ID;
		} else if (arrow is Splash) {
			final splash:Splash = cast arrow;
			return splash.strumID != null ? splash.strumID : 0;
		}
		return 0;
	}

	public function getPlayerFromArrow(arrow:FlxSprite) {
		if (arrow is Note) {
			final note:Note = cast arrow;
			return note.strumLine.ID;
		} else if (arrow is Strum) {
			final strum:Strum = cast arrow;
			return strum.strumLine.ID;
		} else if (arrow is Splash) {
			final splash:Splash = cast arrow;
			final strum:Strum = cast splash.strum;
			return strum.strumLine.ID;
		}

		return 0;
	}

	public function getHoldParentTime(arrow:FlxSprite) {
		final note:Note = cast arrow;
		return note.strumTime;
	}

	// im so fucking sorry for those conditionals
	public function getKeyCount(?player:Int = 0):Int {
		return PlayState.instance != null
			&& PlayState.instance.strumLines != null
			&& PlayState.instance.strumLines.members != null
			&& PlayState.instance.strumLines.members[player] != null
			&& PlayState.instance.strumLines.members[player].members != null ? PlayState.instance.strumLines.members[player].members.length : 4;
	}

	public function getPlayerCount():Int {
		return PlayState.instance != null && PlayState.instance.strumLines != null ? PlayState.instance.strumLines.length : 2;
	}

	public function getTimeFromArrow(arrow:FlxSprite) {
		if (arrow is Note) {
			final note:Note = cast arrow;
			return note.strumTime;
		}

		return 0;
	}

	public function getHoldSubdivisions():Int
		return Options.modchartingHoldSubdivisions;

	public function getDownscroll():Bool
		return Options.downscroll;

	public function getDefaultReceptorX(lane:Int, player:Int):Float {
		@:privateAccess
		return PlayState.instance.strumLines.members[player].members[lane].x;
	}

	public function getDefaultReceptorY(lane:Int, player:Int):Float {
		@:privateAccess
		return PlayState.instance.strumLines.members[player].members[lane].y;
	}

	public function getArrowCamera():Array<FlxCamera>
		return [PlayState.instance.camHUD];

	public function getCurrentScrollSpeed():Float {
		return PlayState.instance.scrollSpeed;
	}

	public function getArrowItems() {
		var drawMembers:Array<Array<Array<FlxSprite>>> = [];
		var strumLineMembers = PlayState.instance.strumLines.members;
		var splashHandler = PlayState.instance.splashHandler;

		for (i in 0...strumLineMembers.length) {
			final sl = strumLineMembers[i];

			if (!sl.visible)
				continue;

			// this is somehow more optimized than how i used to do it (thanks neeo for the code!!)
			drawMembers[i] = [];
			drawMembers[i][0] = cast sl.members.copy();
			drawMembers[i][1] = [];
			drawMembers[i][2] = [];
			drawMembers[i][3] = [];

			var st = 0;
			var nt = 0;
			sl.notes.forEachAlive((spr) -> {
				spr.isSustainNote ? st++ : nt++;
			});

			drawMembers[i][1].resize(nt);
			drawMembers[i][2].resize(st);

			for (splash in splashHandler.members)
			{
				if (splash.strum == null)
					continue;

				var id = splash.strum.strumLine.ID;
				if (id == i && splash.active)
				{
					drawMembers[i][3].push(splash);
				}
			}

			var si = 0;
			var ni = 0;
			sl.notes.forEachAlive((spr) -> drawMembers[i][spr.isSustainNote ? 2 : 1][spr.isSustainNote ? si++ : ni++] = spr);
		}

		return drawMembers;
	}
}