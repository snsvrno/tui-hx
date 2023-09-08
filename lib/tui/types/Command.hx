package tui.types;

import tui.types.Command;
import tui.types.Switch;

/**
	* object for a fuction command
	*
	* usage: create a instantaniable class that implements this interface and
	* add it to the `script`. this command will then be available when running
	* that script
	*/
@:autoBuild(tui.macros.Command.defaults())
interface Command {

	/**
	 * optional: the internal name of the command
	 *
	 * will use the class name as lowercase if not defined:
	 * ```haxe
	 * class NewCommand {
	 *   public var name = "newcommand";
	 * }
	 * ```
	 */
	public var name : String;

	/**
	 * optional: is the command normally hidden from the list of available commands
	 *
	 * will be false if not defined:
	 * ```haxe
	 * class NewCommand {
	 *   public var hidden = false;
	 * }
	 * ```
	 */
	public var hidden : Bool;

	/**
	 * required: the one line description of the command
	 */
	public var description : String;

	/**
	 * optional: longer description that is displayed on the man page
	 *
	 * will use the same text as the `description` if not defined:
	 * ```haxe
	 * class NewCommand {
	 *   public var manDescription = description;
	 * }
	 * ```
	 */
	public var manDescription : String;

	/**
	 * optional: the display name of the command, that will be displayed in the man.
	 * if none is provided the build in man will use `name`
	 *
	 * will be null if not defined:
	 * ```haxe
	 * class NewCommand {
	 *   public var display = null;
	 * }
	 * ```
	 */
	public var display : Null<String>;

	/**
	 * optional: list of command specific switches
	 */
	public var switches : Array<Switch>;

	/**
	 * optional: list of command specific subcommands
	 */
	public var commands : Array<Command>;

	/**
	 * required: function that will be automatically executed when running this command
	 */
	public function run(...args : String) : Void;

	/**
	 * optional: use to check if the given parameter is a command.
	 *
	 * used when there could be "command texts" that could trigger this command.
	 * the app/script will pass the non-switch arguements to this function and
	 * it should return true if that arguement should cause this command to run.
	 *
	 * one use case may be commands called "processTxt" and "processXml". you may
	 * want tho script to automatically call processTxt if any file with a ".txt"
	 * extension is passed and processXml when an ".xml" file is passed:
	 *     `script processTxt afile.txt` would be the equivalent to `script afile.txt`
	 *
	 * will match true on name match only if not definded:
	 * ```haxe
	 * function check(param : String) : Bool {
	 *      return param == name;
	 * }
	 * ```
	 */
	public function check(param : String) : Bool;

}
