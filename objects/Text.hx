package tui.objects;

import tui.types.Last;

class Text extends Object {

	public var value(get, set) : String;
	private function get_value() : String return text.current;
	private function set_value(newText : String) : String return text.current = newText;

	private var text : Last<String> = new Last();

	public var color(default, set) : Int;
	private function set_color(newColor : Int) : Int {
		return color = newColor;
	}

	public function new(r : Int, c : Int, ?maxWidth : Int) {
		this.r = new Last(r);
		this.c = new Last(c);
	}

	override function update() {
		if (text.last != null) {
			if (r.last != null || c.last != null) {
				tui.Commands.fill(r.getLastOrCurrent(), c.getLastOrCurrent(), 1, tui.ColorsTools.trueLength(text.last), " ");
				r.reset();
				c.reset();
			} else {
				tui.Commands.fill(r, c, 1, tui.ColorsTools.trueLength(text.last), " ");
			}
			text.reset();
		}

		tui.Commands.write(r, c, value);
	}
}
