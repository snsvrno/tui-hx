package tui.errors;

class ECommand implements error.Error {
	public var command : String;

	public function new(command : String) {
		this.command = command;
	}

	public function msg() : String {
		return '$command command not found';
	}

}
