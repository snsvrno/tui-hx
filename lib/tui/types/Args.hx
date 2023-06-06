package tui;

import tracer.Debug.debug;
import tracer.Error.error;

import tui.Formats.*;

class Args {
	public static function parse(def : Array<tui.types.Switch>, ... args : String) : tui.types.Parsed {
		var parsed : tui.types.Parsed = {
			switches: [], options: [], parameters : [],
		};

		var args = args.toArray();
		var param : Null<String> = null;

		while ((param = args.shift()) != null) {
			if (param.charAt(0) == "-") {
				var valid : Bool = false;

				// checks if this is an option that expects some kind of value
				if (param.charAt(1) == "-") {
					var value : String = "";
					
					var split = param.split("=");
					if (split.length == 2) {
						param = split[0];
						value == split[1];
					} else {
						value = args.shift();
					}

					for (ds in def) if (param == ds.long) {
						parsed.options.set(ds.name, value);
						debug('setting "${parameter(ds.name)}"="${value}"');
						valid = true;
						break;
					}
							
				// just a normal switch
				} else {
					for (ds in def) if (param == ds.short) {
						if (!parsed.switches.contains(ds.name)) parsed.switches.push(ds.name);
						debug('enabling "${option(ds.name)}" local switch');
						valid = true;
						break;
					}
				}

				if (!valid) {
					error('no switch "$param"');
					exit(1);
				}
			} else {
				parsed.parameters.push(param);
			}

		}

		return parsed;
	}
}
