package tui;

import error.Error;

import tui.Formats.*;

import tui.errors.*;

@:autoBuild(tui.macros.Script.build())
class Script implements tui.types.Program {

	public var name : String;
	public var version : String;
	public var description : String;

	private var _runFunc : Null<() -> Void> = null;
	
	/** global switch definitions */
	public var globalSwitches : Array<tui.types.Switch> = [
		{ group: "global", name: "debug", short: "-d", description: "show debug information during execution." },
		{ group: "global", name: "quiet", short: "-q", description: "suppress all output except for errors." },
		{ group: "global", name: "version", short: "-v", description: "displays the current version." },
		{ group: "global", name: "help", short: "-h", description: "displays this screen." },
		{ group: "global", name: "bare", long: "--pipe", description: "removes all pretty output." },
	];

	public var commands : Array<tui.types.Command> = [];

	public var usageCommandOverride : String;

	private var args : Array<String> = [];
	private var params : Array<String> = [];

	public function new() {
		init();

		// OPTIM : make this a build macro, and not runtime
		{
			var hasHelp = false;
			
			// if we don't have commands we do want to keep help, but we want this
			// help command to be delisted.
			if (commands.length == 0) {
				var help = new tui.defaults.Help(this);
				help.hidden = true;
				commands.push(help);
			}

			else {
				for (c in commands) if (c.name == "help") hasHelp = true;
				if (!hasHelp) commands.push(new tui.defaults.Help(this));
			}
		}

		// OPTIM: make this a build macro, not runtime
		commands.sort((a,b) -> {
			if (a.name > b.name) return 1;
			else return -1;
		});

		// runs the main loop
		_run();
	}

	public function init() { }

	public function exit(code:Int) {
		Sys.exit(code);
	}

	private function addSwitches(... option : tui.types.Switch) {
		for (a in option) globalSwitches.push(a);
	}

	private function addCommands(... command : tui.types.Command) {
		for (c in command) commands.push(c);
	}

	final private function _run() {
		var args = Sys.args();

		// parces any arguements / parameters passed to the script.
		var param : Null<String> = null;
		while ((param = args.shift()) != null) {

			this.args.push(param);
			if(param.charAt(0) != "-") this.params.push(param);

			// checks if the parameter is a switch.
			if (param.charAt(0) == "-") {
				var valid : Bool = false;
				// for every defined switch, we check against the thing
				// we just found ... this is only global (things before the
				// command). the command specific switches will be passed
				// to the command
				for (gs in globalSwitches) if (param == gs.long || param == gs.short) {
					
					// checks the hard coded switches
					switch(gs.name) {
						case "version": displayVersion();
						case "help": displayHelp();
						case "debug": debugEnabled();
						case "bare": ansi.Mode.mode = Bare;
						case _:
					}

					if(gs.value == null || gs.value == false) {

						Switches.setFlag(gs.name);
						debug('enabling ${option(gs.name)} global switch');

					} else {

						var val = args.shift();
						Switches.setValue(gs.name, val);
						debug('setting ${option(gs.name)}=${value(val)}');

					}

					valid = true;
				}

				if (!valid) {
					error(new ESwitch(param));
					exit(1);
				}
			}

			for (command in commands) if (command.check(param)) {
				command.run(... args);
				exit(0);
			}
	
			if (param == null && _runFunc == null) {
				// if we are here we are not sure what to do with this
				error(new ECommand(unknownCommand(param)));
				exit(1);
			}
		}

		// we should have already run a command (if one was passed) so
		// we are going to check if a default run function was set, and
		// if not then show the basic help screen
		if (_runFunc != null) _runFunc();
		else displayHelp();
	}

	public function debug(text : String) { }
	public function error(e : Error) { trace(e.msg()); }
	public function warning(text : String) { }
	
	/**
	 * called when the built in debug switch is used.
	 * override this to enable debug output.
	 */
	private function debugEnabled() {

	}

	/**
	 * a built in version display.
	 * override to change what is displayed when `--version` is
	 * used
	 */
	private function displayVersion() {
		Sys.println(version);
		exit(0);
	}

	inline private function displayHelp() {
		// to override help you need to add your own help command
		for (comm in commands) if (comm.check("help")) comm.run();
		exit(0);
	}
}
