package;

class CountCommand implements tui.types.Command {
	public var name = "count";
	public var description = "counts to 5";

	// these are local command defined switches
	// only will exist in this command context
	public var switches : Array<tui.types.Switch> = [
		{
			name: "zero padding",
			short: "-p",
			description: "how many zeros to use for padding",
			value: true
		},{
			name: "wait",
			long: "--wait",
			description: "wait XX seconds between prints",
			value: true
		}
	];

	public function run(... args : String) {

		var count = if (args[0] == null) 5 else Std.parseInt(args[0]);
		var padding = tui.Switches.getValue("zero padding");
		var wait = tui.Switches.getValue("wait");

		for (i in 0 ... count) {

			var outputText = '${i+1}';
			if (padding != null) while (outputText.length < Std.parseInt(padding)) 
				outputText = "0" + outputText;

			if (tui.Switches.getFlag("trace"))
				trace(outputText);
			else
				Sys.println(outputText);

			if (wait != null) Sys.sleep(Std.parseFloat(wait));
		}
	}
}
