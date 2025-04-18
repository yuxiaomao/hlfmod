package fmod;

@:access(fmod.EventDescription)
@:access(fmod.EventInstance)
class Event {
	var desc : Native.EventDescription;
	var inst : Native.EventInstance;
	var attributes : Native.F3DAttributes;
	var context : Native.ProgrammerSoundContext;
	var added = false;

	public function new(desc : Native.EventDescription) {
		this.desc = desc;
		inst = desc.createInstance();
		attributes = new Native.F3DAttributes();
		attributes.forward = new fmod.Native.FVector(0,0,1);
		attributes.up = new fmod.Native.FVector(0,1,0);
	}

	public function play(?dialogueKey : String = null) {
		if( !added ) {
			added = true;
			Api.register(this);
		}
		if (context != null && dialogueKey != null) {
			context.dialogueKey = @:privateAccess dialogueKey.toUtf8();
		}
		if( inst == null || !inst.isValid() ) {
			inst = desc.createInstance();
		}
		inst.start();
	}

	public function stop(mode : Native.StopMode = Native.StopMode.ALLOWFADEOUT) {
		if( inst != null )
			inst.stop(mode);
	}

	public function release() {
		if( inst != null )
			inst.release();
	}

	public function clearHandle() {
		inst = null;
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

	public function getMinDistance() {
		return desc.getMinDistance();
	}

	public function getMaxDistance() {
		return desc.getMaxDistance();
	}

	public function isOneshot() : Bool {
		return desc.isOneshot();
	}

	public function getTimelinePosition() {
		return inst.getTimelinePosition();
	}

	public function setTimelinePosition(position : Int) {
		inst.setTimelinePosition(position);
	}

	public function getPlaybackState() : Native.PlaybackState {
		return inst.getPlaybackState();
	}

	public function getParameter(name : String) {
		return inst.getParameterByName(@:privateAccess name.toUtf8());
	}

	public function setParameter(name : String, value : Float) {
		return inst.setParameterByName(@:privateAccess name.toUtf8(), value, false);
	}

	public function setParameterWithLabel(name : String, value : String) {
		return inst.setParameterByNameWithLabel(@:privateAccess name.toUtf8(), @:privateAccess value.toUtf8(), false);
	}

	public function hasParameter(name : String) : Bool {
		var count = getParameterDescriptionCount();
		for (i in 0...count) {
			var pname = getParameterDescriptionNameByIndex(i);
			if (name == pname)
				return true;
		}
		return false;
	}

	public inline function getParameterDescriptionCount() : Int {
		return desc.getParameterDescriptionCount();
	}

	public inline function getParameterDescriptionNameByIndex( i : Int ) : String {
		return @:privateAccess String.fromUTF8(desc.getParameterDescriptionNameByIndex(i));
	}

	public function enableProgrammerSound() {
		if (context == null) {
			var system = inst.getSystem();
			context = new Native.ProgrammerSoundContext(system);
			inst.setUserData(context);
			inst.setCallback(CREATE_PROGRAMMER_SOUND | DESTROY_PROGRAMMER_SOUND);
		}
	}

	public function remove() {
		if( isActive() ) {
			stop();
		}
		if( inst.isValid() )
			release();
		clearHandle();
		Api.unregister(this);
		added = false;
	}

	public function update( dt : Float ) {

	}

	public inline function isActive() {
		return inst.isValid() && inst.getPlaybackState() != Native.PlaybackState.STOPPED;
	}

	#if heaps
	public function setTransform(mat: h3d.Matrix) {
		var position = mat.getPosition();
		var up = mat.up();
		var front = mat.front();
		attributes.position = position;
		attributes.up = up;
		attributes.forward = front;
		inst.set3DAttributes(attributes);
	}

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
	public static var LOAD_BANK_MEMORY : Bool = false;

	static var initialized = false;
	static var system : Native.System;
	static var basePath : String;
	static var loadedBanks : Map<String, Native.Bank>;

	static var cacheEventDescriptions : Map<String, Native.EventDescription> = [];

	static var objects : Array<Event> = [];

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

	public static function loadBank(name : String, flags : fmod.Native.LoadBankFlags = NORMAL) {
		if (!initialized) return;
		var bank = null;
		var p = basePath + name;
		if( LOAD_BANK_MEMORY ) {
			var bytes = sys.io.File.getBytes(p);
			bank = system.loadBankMemory(@:privateAccess bytes.b, bytes.length, DEFAULT, flags);
		} else {
			bank = system.loadBankFile(@:privateAccess p.toUtf8(), flags);
		}

		if( bank != null ) {
			loadedBanks.set(name, bank);
		}
	}

	public static function unloadBank(name : String) {
		if (!initialized) return;
		var bank = loadedBanks.get(name);
		if (bank != null) {
			bank.unload();
			loadedBanks.remove(name);
		}
	}

	public static function getBankLoadingState(name : String) : Native.LoadingState {
		if (!initialized) return ERROR;
		var bank = loadedBanks.get(name);
		if (bank == null)
			return ERROR;
		return bank.getLoadingState();
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
		if( !initialized ) return;
		getBus(name).setVolume(volume);
	}

	static inline function getVCA(name : String) {
		return system.getVCA(@:privateAccess name.toUtf8());
	}

	public static function getVcaVolume(name : String) {
		return getVCA(name).getVolume();
	}

	public static function setVcaVolume(name : String, volume : Float) {
		if( !initialized ) return;
		getVCA(name).setVolume(volume);
	}

	public static function getEventDescription(name : String) : Native.EventDescription {
		if (!initialized) return null;
		var ed = cacheEventDescriptions.get(name);
		if( ed == null )
			ed = system.getEvent(@:privateAccess name.toUtf8());
		if (ed == null)
			return null;
		cacheEventDescriptions.set(name, ed);
		return ed;
	}

	public static function getEvent(name : String) : Event {
		if (!initialized) return null;
		var ed = getEventDescription(name);
		if (ed == null)
			return null;
		return new Event(ed);
	}

	static public function register( o : Event) {
		objects.push(o);
	}

	static public function unregister( o : Event ) {
		var i = objects.length;
		while(i-- > 0) {
			if(objects[i] == o) {
				if(i == objects.length-1)
					objects.pop();
				else {
					var last = objects.pop();
					objects[i] = last;
				}
				break;
			}
		}
	}

	public static function update(dt) {
		if (!initialized) return;

		var i = 0;
		while( i < objects.length ) {
			var o = objects[i];
			if( !o.isActive() ) {
				o.remove();
				continue;
			}
			o.update(dt);
			i++;
		}
		system.update();
	}

	#if heaps
	static var cameraAttributes : Native.F3DAttributes;

	public static inline function getListenerPosition() : h3d.Vector {
		return cameraAttributes?.position ?? new h3d.Vector();
	}

	public static function setCameraListenerPosition(camera : h3d.Camera, camDistance : Float, ?attenuationPt : h3d.Vector) {
		if (!initialized) return;
		if (cameraAttributes == null)
			cameraAttributes = new Native.F3DAttributes();
		var forward = camera.getForward();
		var up = camera.getUp();
		var position = camera.pos.add(forward.scaled(camDistance));
		if( forward.x != 0 || forward.y != 0 || forward.z != 0 ) {
			cameraAttributes.position = position;
			cameraAttributes.forward = forward;
			cameraAttributes.up = up;

			system.setListenerAttributes(0, cameraAttributes, null);
		}
	}
	#end

}
