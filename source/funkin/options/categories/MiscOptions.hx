package funkin.options.categories;

class MiscOptions extends OptionsScreen {
	public override function new() {
		super("Miscellaneous", "Change some other options like enabling Developer Mode, resetting data...");
		add(new Checkbox(
			"Developer Mode",
			"If checked, you will be able to access developer features like certain keybinds, editors, developer options, state reloads, console and more.",
			"devMode"));
		#if UPDATE_CHECKING
		add(new Checkbox(
			"Enable Nightly Updates",
			"If checked, will also include nightly builds in the update checking.",
			"betaUpdates"));,
		add(new TextOption(
			"Check for Updates",
			"Select this option to check for new engine updates.",
			function() {
				var report = funkin.backend.system.updating.UpdateUtil.checkForUpdates();
				if (report.newUpdate) {
					FlxG.switchState(new funkin.backend.system.updating.UpdateAvailableScreen(report));
				} else {
					CoolUtil.playMenuSFX(CANCEL);
					updateDescText("No update found.");
				}
		}));,
		#end
		add(new TextOption(
			"Reset Save Data",
			"Select this option to reset save data. This will remove all of your highscores.",
			function() {
				// TODO: SAVE DATA RESETTING
		}));
	}
}
