package tui.types;

import error.Error;

interface Program {
	public var name : String;
	public var version : String;
	public var description : String;
	public var globalSwitches : Array<tui.types.Switch>;
	public var commands : Array<tui.types.Command>;

	public var usageCommandOverride : String;

	public function error(e:Error) : Void;
	public function debug(text:String) : Void;
	public function warning(text:String) : Void;
}
