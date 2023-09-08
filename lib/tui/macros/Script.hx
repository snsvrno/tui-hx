package tui.macros;

import haxe.macro.Expr;
import haxe.macro.Context;

using tui.macros.Helpers;

class Script {
	public static function build() : Array<Field> {
		var fields = Context.getBuildFields();

		var init = fields.getField("init");

		if (init != null && fields.hasField("run")) {
			switch (init.kind) {
				case(FFun(f)):
					f.expr = macro {
						${f.expr}
						_runFunc = run;
					};

				case _:
			}

		}

		return fields;
	}
}
