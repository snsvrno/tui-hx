package tui.types;

class App {

	private var isRunning : Bool = true;
	private var inputQueue : Array<Int> = [];
	private var waitingOnResponse : Bool = false;

	private static final thing : Bool = true;

	private var secondsBetweenDraw : Float = 0.1;
	private var rows : Int;
	private var columns : Int;

	private var objects : Array<tui.objects.Object> = [];

	public function new() {

	}

	public function run() {
		ansi.Command.clearScreen();
		ansi.Command.hideCursor();

		// creates the input thread
		sys.thread.Thread.create(inputLoop);
		// starts the main loop
		mainLoop();

		ansi.Command.clearScreen();
		ansi.Command.showCursor();
	}

	/**
	 * the loop that runs on the main process
	 */
	final private function mainLoop() {
		var time = Sys.time();

		var size = ansi.Command.getSize();
		columns = size.c;
		rows = size.r;

		init();
		internalDraw();

		while(isRunning) {
	
			// checks if we need to draw something
			if (Sys.time() - time > secondsBetweenDraw) {
				time = Sys.time();
				internalDraw();
			}

			// processes input.
			while(inputQueue.length > 0) {
				var c = inputQueue.shift();
				input(c);
			}

			waitingOnResponse = true;
		}

	}

	/**
	 * the loop that runs in a thread to get keypresses
	 */
	final private function inputLoop() {
		while(isRunning) {
			if (waitingOnResponse) {
				inputQueue.push(Sys.getChar(false));
				waitingOnResponse = false;
			}
		}
	}

	private function input(key : Int) {

	}

	final private function internalDraw() {
		for (o in objects) o.update();
		draw();
	}

	private function draw() {

	}

	private function init() {

	}

}
