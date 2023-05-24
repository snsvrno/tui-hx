package tui.types;

abstract Last<T>(haxe.ds.Vector<T>) {
	public var current(get, set) : T;
	inline public function get_current() return this[0];
	inline public function set_current(v : T) : T {
		if (get_last() == null) set_last(get_current());
		return this[0] = v;
	}

	inline public function getLastOrCurrent() : T {
		if (get_last() == null) return get_current();
		else return get_last();
	}

	public var last(get, set) : T;
	inline public function get_last() return this[1];
	inline public function set_last(v : T) return this[1] = v;
	
	inline public function reset() this[1] = null;

	@:to
	inline public function toType() : T return this[0];
	
	@:from
	inline static public function fromType<T>(t:T) : Last<T> return new Last(t);

	inline public function new(?inital : T) {
		this = new haxe.ds.Vector(2);
		if (inital != null) this[0] = inital;
	}

}
