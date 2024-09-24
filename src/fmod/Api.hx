package fmod;

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
		loadedBank(masterBank);
	}

	public static function release() {
		if (!initialized) return;
		system.release();
		initialized = false;
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

}