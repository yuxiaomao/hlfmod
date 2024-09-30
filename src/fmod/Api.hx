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

	public function release() {
		inst.release();
	}

	public function setParameter(name : String, value : Float) {
		inst.setParameterByName(@:privateAccess name.toUtf8(), value, false);
	}

	#if heaps
	public function setPosition(position : h3d.Vector) {
		var attributes = new Native.F3DAttributes();
		attributes.position = position;
		inst.set3DAttributes(attributes);
	}
	#end
}

class Api {
	static var initialized = false;
	static var system : Native.System;
	static var basePath : String;
	static var buses : Map<String, Native.Bus>;
	static var loadedBanks : Map<String, Native.Bank>;

	public static function init(path : String, masterBank : String) {
		system = Native.System.create();
		// set additional config here
		system.initialize(32, NORMAL, NORMAL, null);
		basePath = path + "/";
		buses = [];
		loadedBanks = [];
		initialized = true;
		loadBank(masterBank);
		return true;
	}

	public static function release() {
		if (!initialized) return;
		initialized = false;
		system.release();
		basePath = "";
		loadedBanks = [];
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
		var bank = loadedBanks.get(name);
		if (bank != null) {
			bank.unload();
			loadedBanks.remove(name);
		}
	}

	static inline function getBus(busName : String) {
		var bus = buses.get(busName);
		if (bus == null) {
			bus = system.getBus(@:privateAccess busName.toUtf8());
			buses.set(busName, bus);
		}
		return bus;
	}

	public static function getVolume(busName : String) {
		return getBus(busName).getVolume();
	}


	public static function setVolume(busName : String, volume : Float) {
		getBus(busName).setVolume(volume);
	}

	public static function getMute(busName : String) {
		return getBus(busName).getMute();
	}

	public static function setMute(busName : String, mute : Bool) {
		getBus(busName).setMute(mute);
	}

	public static function getEvent(name : String) : Event {
		if (!initialized) return null;
		var ed = system.getEvent(@:privateAccess name.toUtf8());
		if (ed == null)
			return null;
		return new Event(ed);
	}

	#if heaps
	public static function setCameraListenerPosition(camera : h3d.Camera, camDistance : Float) {
		if (!initialized) return;
		var forward = camera.target.sub(camera.pos).normalized();
		var up = camera.up.normalized();
		var right = forward.cross(up);
		if( right.lengthSq() > 0.1 ) {
			var position = camera.pos.add(forward.scaled(camDistance));
			var attributes = new Native.F3DAttributes();
			attributes.position = position;
			attributes.forward = forward;
			attributes.up = up;
			system.setListenerAttributes(0, attributes, null);
		}
	}
	#end

}
