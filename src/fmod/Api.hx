package fmod;

class Event {
	var desc : Native.EventDescription;
	var inst : Native.EventInstance;

	public function new(desc : Native.EventDescription) {
		this.desc = desc;
		this.inst = desc.createInstance();
	}

	public function play() {
		inst.start();
	}

	public function setParameter(name : String, value : Float) {
		inst.setParameterByName(@:privateAccess name.toUtf8(), value, false);
	}

	public function release() {
		inst.release();
	}
}

class Api {
	static var initialized = false;
	static var system : Native.System;
	static var basePath : String;
	static var loadedBank : Map<String, Native.Bank>;

	public static function init(path : String, masterBank : String) {
		system = Native.System.create();
		// set additional config here
		system.initialize(32, NORMAL, NORMAL, null);
		basePath = path + "/";
		loadedBank = [];
		initialized = true;
		loadBank(masterBank);
		return true;
	}

	public static function release() {
		if (!initialized) return;
		initialized = false;
		system.release();
		basePath = "";
		loadedBank = [];
	}

	public static function update() {
		if (!initialized) return;
		system.update();
	}

	public static function loadBank(name : String) {
		if (!initialized) return;
		var p = basePath + name;
		system.loadBankFile(@:privateAccess p.toUtf8(), NORMAL);
	}

	public static function unloadBank(name : String) {
		if (!initialized) return;
		var bank = loadedBank.get(name);
		if (bank != null) {
			bank.unload();
			loadedBank.remove(name);
		}
	}

	public static function getEvent(name : String) : Event {
		if (!initialized) return null;
		var ed = system.getEvent(@:privateAccess name.toUtf8());
		if (ed == null)
			return null;
		return new Event(ed);
	}

}
