package tui.errors;

class ESwitch implements error.Error {
	public var switchName : String;

	public function new(switchName : String) {
		this.switchName = switchName;
	}

	public function msg() : String {
		return '$switchName switch not found';
	}
}
