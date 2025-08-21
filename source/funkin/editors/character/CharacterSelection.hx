package funkin.editors.character;

import funkin.game.Character;
import funkin.options.OptionsScreen;
import funkin.options.type.IconOption;
import funkin.options.type.NewOption;
import funkin.options.type.TextOption;
import funkin.options.type.OptionType;

class CharacterSelection extends EditorTreeMenu
{
	public override function create()
	{
		bgType = "charter";
		super.create();

		var isMods:Bool = true;
		var modsList:Array<String> = Character.getList(true, true);

		if(modsList.length == 0) {
			modsList = Character.getList(false, true);
			isMods = false;
		}

		function generateList(modsList:Array<String>, isMods:Bool, folderPath:String = ""):Array<OptionType> {
			var list:Array<OptionType> = [];

			for(char in modsList) {
				if(char.endsWith("/")) {
					var folderName = CoolUtil.getFilename(char.substr(0, char.length-1));

					list.push(new TextOption(folderName + " >", "Press ACCEPT to edit this folder.", function() {
						var newModsList = Character.getList(isMods, true, char);
						var newList:Array<OptionType> = generateList(newModsList, isMods, folderPath + folderName + "/");
						optionsTree.add(new OptionsScreen(folderPath + folderName, "Select a character to edit in " + folderPath + folderName + "/", newList));
					}));
				} else {
					list.push(new IconOption(char, "Press ACCEPT to edit this character.", Character.getIconFromCharName(folderPath + char, char),
						function() {
							FlxG.switchState(new CharacterEditor(folderPath + char));
						})
					);
				}
			}

			list.insert(0, new NewOption("New Character", "New Character", function() {
				openSubState(new UIWarningSubstate("New Character: Feature Not Implemented!", "This feature isn't implemented yet. Please wait for more cne updates to have this functional.\n\n\n- Codename Devs", [
					{label: "Ok", color: 0xFFFF0000, onClick: function(t) {}}
				]));
			}));

			return list;
		}

		var list = generateList(modsList, isMods);

		main = new OptionsScreen("Character Editor", "Select a character to edit", list);

		DiscordUtil.call("onEditorTreeLoaded", ["Character Editor"]);
	}

	override function createPost() {
		super.createPost();

		main.changeSelection(1);
	}
}