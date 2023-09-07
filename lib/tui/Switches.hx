package tui;

import tui.Formats.*;
import tui.errors.*;

class Switches {

	private static var flags : Array<String> = [];
	private static var values : Map<String, Array<String>> = new Map();

	public static function getFlag(name : String) : Bool {
		return flags.contains(name);
	}

	public static function setFlag(name : String) {
		if (!flags.contains(name)) flags.push(name);
	}

	public static function setValue(name : String , value : String) {
		var vs = if (values.exists(name)) values.get(name); else [ ];
		vs.push(value);
		values.set(name, vs);
	}

	public static function getValues(name : String) : Null<Array<String>> {
		return values.get(name);
	}

	/**
	 * gets the first value
	 */
	public static function getValue(name : String) : Null<String> {
		var value = getValues(name);
		if (value == null) return null;
		else return value[0];
	}


	public static function parse(args : Array<String>, switches : Array<tui.types.Switch>) : Array<String> {
		var params : Array<String> = [];

		var param : Null<String> = null;
		while ((param = args.shift()) != null) {

			// not a switch, so we will return this
			if(param.charAt(0) != "-") params.push(param);

			// checks if the parameter is a switch.
			if (param.charAt(0) == "-") {
				var valid : Bool = false;

				// for every defined switch, we check against the thing
				// we just found ... this is only global (things before the
				// command). the command specific switches will be passed
				// to the command
				for (gs in switches) if (param == gs.long || param == gs.short) {
					if(gs.value == null || gs.value == false) {

						Switches.setFlag(gs.name);
						tui.Script.instance.debug('enabling ${option(gs.name)} command-level switch');

					} else {

						var val = args.shift();
						Switches.setValue(gs.name, val);
						tui.Script.instance.debug('setting command-level ${option(gs.name)}=${value(val)}');

					}

					valid = true;
				}

				if (!valid) {
					tui.Script.instance.error(new ESwitch(param));
					tui.Script.instance.exit(1);
				}
			}
		}

		return params;
	}
}
