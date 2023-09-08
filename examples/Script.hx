package;

class Script extends tui.Script {
	public static function main() new Script();

	override function init() {
		name = "Example Script";
		version = "0.0.0a";
		description = "an example script, to show how to get something started";

		// this is a global level switch, it will be available 
		// in all commands
		addSwitches({
			name:"trace",
			long:"--trace",
			description:"use trace instead of Sys.println"
		});

		addCommands(
			new CountCommand()
		);
	}

	override function debug(text:String) {
		Sys.println("debug: " + text);
	}
}
