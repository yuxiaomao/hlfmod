package fmod;

class Api {
	static var initialized = false;
	static var system : Native.System;
	static var basePath : String;

	public static function init(basePath : String, masterBank : String) {
		system = Native.System.create();
		// set additional config here
		system.initialize(32, NORMAL, NORMAL, null);
		initialized = true;
		Api.basePath = basePath + "/";
		system.loadBankFile(@:privateAccess (basePath + masterBank).toUtf8(), NORMAL);
	}

	public static function release() {
		system.release();
	}

	public static function loadBank(name : String) {
		if (!initialized) return;
		system.loadBankFile(name, NORMAL);
	}

	public static function unloadBank(name : String) {

	}

}