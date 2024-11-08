package fmod;

@:access(fmod.EventDescription)
@:access(fmod.EventInstance)
class Event {
	var desc : Native.EventDescription;
	var inst : Native.EventInstance;
	var attributes : Native.F3DAttributes;
	var context : Native.ProgrammerSoundContext;

	public function new(desc : Native.EventDescription) {
		this.desc = desc;
		inst = desc.createInstance();
		attributes = new Native.F3DAttributes();
		attributes.forward = new fmod.Native.FVector(0,0,1);
		attributes.up = new fmod.Native.FVector(0,1,0);
	}

	public function play(?dialogueKey : String = null) {
		if (context != null && dialogueKey != null) {
			context.dialogueKey = @:privateAccess dialogueKey.toUtf8();
		}
		inst.start();
	}

	public function release() {
		if (inst != null) {
			inst.release();
			inst = null;
		}
		context = null;
	}

	public function getPath() {
		var len = desc.getPath(null, 0);
		var path = new hl.Bytes(len);
		desc.getPath(path, len);
		return @:privateAccess String.fromUTF8(path);
	}

	public function getLength() {
		return desc.getLength();
	}

	public function getTimelinePosition() {
		return inst.getTimelinePosition();
	}

	public function setTimelinePosition(position : Int) {
		inst.setTimelinePosition(position);
	}

	public function getParameter(name : String) {
		return inst.getParameterByName(@:privateAccess name.toUtf8());
	}

	public function setParameter(name : String, value : Float) {
		inst.setParameterByName(@:privateAccess name.toUtf8(), value, false);
	}

	public function setParameterWithLabel(name : String, value : String) {
		inst.setParameterByNameWithLabel(@:privateAccess name.toUtf8(), @:privateAccess value.toUtf8(), false);
	}

	public function enableProgrammerSound() {
		if (context == null) {
			var system = inst.getSystem();
			context = new Native.ProgrammerSoundContext(system);
			inst.setUserData(context);
			inst.setCallback(CREATE_PROGRAMMER_SOUND | DESTROY_PROGRAMMER_SOUND);
		}
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

	public static var DEFAULT_INIT_FLAGS : Native.InitFlags = NORMAL;
	public static var DEFAULT_CORE_INIT_FLAGS : Native.CoreInitFlags = NORMAL;

	static var initialized = false;
	static var system : Native.System;
	static var basePath : String;
	static var loadedBanks : Map<String, Native.Bank>;

	public static function init(path : String, masterBank : String) {
		system = Native.System.create();
		// set additional config here
		system.initialize(32, DEFAULT_INIT_FLAGS, DEFAULT_CORE_INIT_FLAGS, null);
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
		var bank = system.loadBankFile(@:privateAccess p.toUtf8(), NORMAL);
		loadedBanks.set(name, bank);
	}

	public static function unloadBank(name : String) {
		if (!initialized) return;
		var bank = loadedBanks.get(name);
		if (bank != null) {
			bank.unload();
			loadedBanks.remove(name);
		}
	}

	public static function getBankEventList(name : String) : Array<Event> {
		if (!initialized) return null;
		var bank = loadedBanks.get(name);
		if (bank == null)
			return null;
		var count = bank.getEventCount();
		var arr = new hl.NativeArray(count);
		bank.getEventList(arr);
		return [for (ed in arr) new Event(ed)];
	}

	static inline function getBus(name : String) {
		return system.getBus(@:privateAccess name.toUtf8());
	}

	public static function getBusVolume(name : String) {
		return getBus(name).getVolume();
	}

	public static function setBusVolume(name : String, volume : Float) {
		getBus(name).setVolume(volume);
	}

	static inline function getVCA(name : String) {
		return system.getVCA(@:privateAccess name.toUtf8());
	}

	public static function getVcaVolume(name : String) {
		return getVCA(name).getVolume();
	}

	public static function setVcaVolume(name : String, volume : Float) {
		getVCA(name).setVolume(volume);
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
