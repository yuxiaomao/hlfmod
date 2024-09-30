package fmod;

enum abstract InitFlags(Int) {
	var NORMAL = 0x00000000;
	var LIVEUPDATE = 0x00000001;
	var ALLOW_MISSING_PLUGINS = 0x00000002;
	var SYNCHRONOUS_UPDATE = 0x00000004;
	var DEFERRED_CALLBACKS = 0x00000008;
	var LOAD_FROM_UPDATE = 0x00000010;
	var MEMORY_TRACKING = 0x00000020;
	@:op(a | b) static function or(a:InitFlags, b:InitFlags) : InitFlags;
}

enum abstract CoreInitFlags(Int) {
	var NORMAL = 0x00000000;
	var STREAM_FROM_UPDATE = 0x00000001;
	var MIX_FROM_UPDATE = 0x00000002;
	var F3D_RIGHTHANDED = 0x00000004;
	var CLIP_OUTPUT = 0x00000008;
	var CHANNEL_LOWPASS = 0x00000100;
	var CHANNEL_DISTANCEFILTER = 0x00000200;
	var PROFILE_ENABLE = 0x00010000;
	var VOL0_BECOMES_VIRTUAL = 0x00020000;
	var GEOMETRY_USECLOSEST = 0x00040000;
	var PREFER_DOLBY_DOWNMIX = 0x00080000;
	var THREAD_UNSAFE = 0x00100000;
	var PROFILE_METER_ALL = 0x00200000;
	var MEMORY_TRACKING = 0x00400000;
	@:op(a | b) static function or(a:CoreInitFlags, b:CoreInitFlags) : CoreInitFlags;
}

enum abstract LoadBankFlags(Int) {
	var NORMAL = 0x00000000;
	var NONBLOCKING = 0x00000001;
	var DECOMPRESS_SAMPLES = 0x00000002;
	var UNENCRYPTED = 0x00000004;
	@:op(a | b) static function or(a:LoadBankFlags, b:LoadBankFlags) : LoadBankFlags;
}

enum abstract LoadingState(Int) {
	var UNLOADING;
	var UNLOADED;
	var LOADING;
	var LOADED;
	var ERROR;
}

@:struct class FVectorImpl {
	public var x : Single;
	public var y : Single;
	public var z : Single;

	public function new(x : Single, y : Single, z : Single) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}

@:forward abstract FVector(FVectorImpl) from FVectorImpl to FVectorImpl {
	public inline function new(x : Single, y : Single, z : Single) {
		this = new FVectorImpl(x, y, z);
	}

	#if heaps
	/**
	 * FMOD uses Y up, X right, (default left-handed) Z away;
	 * Heaps uses Z up, X right, left-handed Y towards.
	 */
	@:from public static inline function fromVector(vector : h3d.Vector) {
		return new FVector(vector.x, vector.z, -vector.y);
	}
	#end
}

@:struct class F3DAttributes {
	@:packed public var position : FVector;
	@:packed public var velocity : FVector;
	@:packed public var forward : FVector;
	@:packed public var up : FVector;

	public function new() {}
}

#if !disable_sound
@:hlNative("hlfmod", "studio_system_")
#end
abstract System(hl.Abstract<"FMOD_STUDIO_SYSTEM">) {
	static function create() : System { return null; }
	// function setAdvancedSettings(...)
	function initialize(maxchannels : Int, studioflags : InitFlags, coreflags : CoreInitFlags, extradriverdata : Dynamic) : Bool { return false; }
	function release() : Bool { return false; }
	function update() : Bool { return false; }
	function getCoreSystem() : CoreSystem { return null; }
	function getEvent(pathOrId : hl.Bytes) : EventDescription { return null; }
	function getBus(pathOrId : hl.Bytes) : Bus { return null; }
	function getParameterByName(name : hl.Bytes) : Single { return 0; }
	function setParameterByName(name : hl.Bytes, value : Single, ignoreseekspeed : Bool) : Bool { return false; }
	function setParameterByNameWithLabel(name : hl.Bytes, label : hl.Bytes, ignoreseekspeed : Bool) : Bool { return false; }
	function setListenerAttributes(index : Int, attributes : F3DAttributes, attenuationposition : FVector) : Bool { return false; }
	function loadBankFile(filename : hl.Bytes, flags : LoadBankFlags) : Bank { return null; }
	function flushCommands() : Bool { return false; }
	function flushSampleLoading() : Bool { return false; }
}

#if !disable_sound
@:hlNative("hlfmod", "studio_eventdescription_")
#end
abstract EventDescription(hl.Abstract<"FMOD_STUDIO_EVENTDESCRIPTION">) {
	function createInstance() : EventInstance { return null; }
	function loadSampleData() : Bool { return false; }
	function unloadSampleData() : Bool { return false; }
	function getSampleLoadingState() : LoadingState { return ERROR; }
}

#if !disable_sound
@:hlNative("hlfmod", "studio_eventinstance_")
#end
abstract EventInstance(hl.Abstract<"FMOD_STUDIO_EVENTINSTANCE">) {
	#if !disable_sound @:hlNative("hlfmod", "studio_eventinstance_get_3d_attributes") #end
	function get3DAttributes() : F3DAttributes { return null; }
	#if !disable_sound @:hlNative("hlfmod", "studio_eventinstance_set_3d_attributes") #end
	function set3DAttributes(attributes : F3DAttributes) : Bool { return false; }
	function start() : Bool { return false; }
	function release() : Bool { return false; }
	function getParameterByName(name : hl.Bytes) : Single { return 0; }
	function setParameterByName(name : hl.Bytes, value : Single, ignoreseekspeed : Bool) : Bool { return false; }
	function setParameterByNameWithLabel(name : hl.Bytes, label : hl.Bytes, ignoreseekspeed : Bool) : Bool { return false; }
}

#if !disable_sound
@:hlNative("hlfmod", "studio_bus_")
#end
abstract Bus(hl.Abstract<"FMOD_STUDIO_BUS">) {
	function getVolume() : Single { return 0; }
	function setVolume(volume : Single) : Bool { return false; }
	function getPaused() : Bool { return false; }
	function setPaused(paused : Bool) : Bool { return false; }
	function getMute() : Bool { return false; }
	function setMute(mute : Bool) : Bool { return false; }
}

#if !disable_sound
@:hlNative("hlfmod", "studio_bank_")
#end
abstract Bank(hl.Abstract<"FMOD_STUDIO_BANK">) {
	function unload() : Bool { return false; }
	function loadSampleData() : Bool { return false; }
	function unloadSampleData() : Bool { return false; }
	function getLoadingState() : LoadingState { return ERROR; }
	function getSampleLoadingState() : LoadingState { return ERROR; }
}

#if !disable_sound
@:hlNative("hlfmod", "core_system_")
#end
abstract CoreSystem(hl.Abstract<"FMOD_SYSTEM">) {
	// public function setSoftwareFormat(...)
}

@:keep
class Native {
}
