package fmod;

@:access(fmod.EventDescription)
@:access(fmod.EventInstance)
class Event {
	var desc : Native.EventDescription;
	var inst : Native.EventInstance;
	var attributes : Native.F3DAttributes;

	public function new(desc : Native.EventDescription) {
		this.desc = desc;
		inst = desc.createInstance();
		attributes = new Native.F3DAttributes();
		attributes.forward = new fmod.Native.FVector(0,0,1);
		attributes.up = new fmod.Native.FVector(0,1,0);
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
		attributes.position = position;
		inst.set3DAttributes(attributes);
	}
	#end
}

@:access(fmod)
class Api {
	static var initialized = false;
	static var system : Native.System;
	static var basePath : String;
	static var loadedBanks : Map<String, Native.Bank>;

	public static function init(path : String, masterBank : String) {
		system = Native.System.create();
		// set additional config here
		system.initialize(32, NORMAL, NORMAL, null);
		basePath = path + "/";
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

	static inline function getVCA(vcaName : String) {
		return system.getVCA(@:privateAccess vcaName.toUtf8());
	}

	public static function getVcaVolume(vcaName : String) {
		return getVCA(vcaName).getVolume();
	}

	public static function setVcaVolume(vcaName : String, volume : Float) {
		getVCA(vcaName).setVolume(volume);
	}

	public static function getEvent(name : String) : Event {
		if (!initialized) return null;
		var ed = system.getEvent(@:privateAccess name.toUtf8());
		if (ed == null)
			return null;
		return new Event(ed);
	}

	#if heaps
	static var cameraAttributes : Native.F3DAttributes;
	public static function setCameraListenerPosition(camera : h3d.Camera, camDistance : Float) {
		if (!initialized) return;
		if (cameraAttributes == null)
			cameraAttributes = new Native.F3DAttributes();
		var forward = camera.target.sub(camera.pos).normalized();
		var up = camera.up.normalized();
		var right = forward.cross(up);
		if( right.lengthSq() > 0.1 ) {
			var position = camera.pos.add(forward.scaled(camDistance));
			cameraAttributes.position = position;
			cameraAttributes.forward = forward;
			cameraAttributes.up = up;
			system.setListenerAttributes(0, cameraAttributes, null);
		}
	}
	#end

}
