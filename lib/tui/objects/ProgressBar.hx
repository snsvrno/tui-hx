package tui.objects;

import tui.types.Last;

class ProgressBar extends Object {

	public var width : Last<Int>;
	public var value : Int = 0;
	private var title : Last<String>;

	public var barColor : tui.types.Color = tui.Colors.black();
	public var barBGColor : tui.types.Color = tui.Colors.red();

	public function new(r : Int, c : Int, width : Int) {
		this.r = new Last(r);
		this.c = new Last(c);
		this.width = new Last(width);
		title = new Last();
	}

	public inline function setTitle(newTitle : String) title.current = newTitle;
	public inline function setValue(newValue : Int) value = newValue;

	override function update() {
		if (title.last != null) {
			if (r.last != null || c.last != null) {
				tui.Commands.fill(r.getLastOrCurrent(), c.getLastOrCurrent(), 1, tui.ColorsTools.trueLength(title.last), " ");
				r.reset();
				c.reset();
			} else {
				tui.Commands.fill(r, c, 1, tui.ColorsTools.trueLength(title.last), " ");
			}
			title.reset();
		}

		var start = tui.Commands.write(r, c, title);
		var fillSize = Math.floor(value/100 * width.current);

		// HACK: is the -1 a hack?

		// draw the background
		tui.Commands.fill(r, c.current + start - 1 + fillSize, 1, width.current - fillSize, tui.Colors.paint("█", barBGColor));
		tui.Commands.fill(r, c.current + start - 1, 1, fillSize, tui.Colors.paint("█", barColor));
	}
}
