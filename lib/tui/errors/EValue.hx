package tui.errors;

import ansi.Paint.paint;

class EValue implements error.Error {
	public var command : String;
	public var expected : String;
	public var actual : String;

	public function new(command : String, expected : String, actual : String) {
		this.command = command;
		this.expected = expected;
		this.actual = actual;
	}

	public function msg() : String {
#if ansi
		return '${paint(command,Cyan)} expects "${paint(expected,Green)}" but was given "${paint(actual,Yellow)}"';
#else
		return '$command expects "$expected" but was given "$actual"';
#end
	}
}
