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

enum abstract EventCallbackType(Int) {
	var CREATE_PROGRAMMER_SOUND = 0x00000080;
	var DESTROY_PROGRAMMER_SOUND = 0x00000100;
	@:op(a | b) static function or(a:EventCallbackType, b:EventCallbackType) : EventCallbackType;
}

enum abstract LoadBankFlags(Int) {
	var NORMAL = 0x00000000;
	var NONBLOCKING = 0x00000001;
	var DECOMPRESS_SAMPLES = 0x00000002;
	var UNENCRYPTED = 0x00000004;
	@:op(a | b) static function or(a:LoadBankFlags, b:LoadBankFlags) : LoadBankFlags;
}

enum abstract LoadingState(Int) from Int {
	var UNLOADING;
	var UNLOADED;
	var LOADING;
	var LOADED;
	var ERROR;
}

enum abstract LoadMemoryMode(Int) from Int {
	var DEFAULT;
	var POINT;
}

enum abstract PlaybackState(Int) from Int {
	var ERROR = -1;
	var PLAYING = 0;
	var SUSTAINING;
	var STOPPED;
	var STARTING;
	var STOPPING;
}

enum abstract StopMode(Int) {
	var ALLOWFADEOUT;
	var IMMEDIATE;
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

	@:to public inline function toVector() : h3d.Vector {
		return new h3d.Vector(this.x, -this.z, this.y);
	}
	#end
}

@:struct class F3DAttributes {
	// Assign struct to packed does not work well, so we'll just set them manually
	@:packed public var position(default, set) : FVector;
	@:packed public var velocity(default, set) : FVector;
	@:packed public var forward(default, set) : FVector;
	@:packed public var up(default, set) : FVector;

	public function new() {}
	public inline function set_position(p : FVector) {
		position.x = p.x;
		position.y = p.y;
		position.z = p.z;
		return position;
	}

	public inline function set_velocity(p : FVector) {
		velocity.x = p.x;
		velocity.y = p.y;
		velocity.z = p.z;
		return velocity;
	}

	public inline function set_forward(p : FVector) {
		forward.x = p.x;
		forward.y = p.y;
		forward.z = p.z;
		return forward;
	}

	public inline function set_up(p : FVector) {
		up.x = p.x;
		up.y = p.y;
		up.z = p.z;
		return up;
	}
}

class ProgrammerSoundContext {
	public var studioSystem : System;
	public var coreSystem : CoreSystem;
	public var dialogueKey : hl.Bytes;

	public function new(system : System) {
		studioSystem = system;
		coreSystem = @:privateAccess system.getCoreSystem();
		dialogueKey = null;
	}
}

#if !disable_sound
@:hlNative("?hlfmod", "studio_system_")
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
	function getVCA(pathOrId : hl.Bytes) : Vca { return null; }
	function getParameterByName(name : hl.Bytes) : Single { return 0; }
	function setParameterByName(name : hl.Bytes, value : Single, ignoreseekspeed : Bool) : Bool { return false; }
	function setParameterByNameWithLabel(name : hl.Bytes, label : hl.Bytes, ignoreseekspeed : Bool) : Bool { return false; }
	function setListenerAttributes(index : Int, attributes : F3DAttributes, attenuationposition : FVector) : Bool { return false; }
	function loadBankFile(filename : hl.Bytes, flags : LoadBankFlags) : Bank { return null; }
	function loadBankMemory(buffer : hl.Bytes, length : Int, mode : LoadMemoryMode, flags : LoadBankFlags) : Bank { return null; }
	function flushCommands() : Bool { return false; }
	function flushSampleLoading() : Bool { return false; }
	function getCpuUsage() : Single { return 0; }
}

#if !disable_sound
@:hlNative("?hlfmod", "studio_eventdescription_")
#end
abstract EventDescription(hl.Abstract<"FMOD_STUDIO_EVENTDESCRIPTION">) {
	function isValid() : Bool { return false; }
	function getPath(path : hl.Bytes, size : Int) : Int { return 0; }
	function getParameterDescriptionCount() : Int { return 0; }
	function getParameterDescriptionNameByIndex(index : Int) : hl.Bytes { return null; }
	function getLength() : Int { return 0; }
	function getSoundSize() : Single { return 0; }
	function getMinDistance() : Single { return 0; }
	function getMaxDistance() : Single { return 0; }
	function isSnapshot() : Bool { return false; }
	function isOneshot() : Bool { return false; }
	function isStream() : Bool { return false; }
	function is3d() : Bool { return false; }
	function isDopplerEnabled() : Bool { return false; }
	function createInstance() : EventInstance { return null; }
	function loadSampleData() : Bool { return false; }
	function unloadSampleData() : Bool { return false; }
	function getSampleLoadingState() : Int { return 0; }
}

#if !disable_sound
@:hlNative("?hlfmod", "studio_eventinstance_")
#end
abstract EventInstance(hl.Abstract<"FMOD_STUDIO_EVENTINSTANCE">) {
	function isValid() : Bool { return false; }
	function getSystem() : System { return null; }
	#if !disable_sound @:hlNative("?hlfmod", "studio_eventinstance_get_3d_attributes") #end
	function get3DAttributes() : F3DAttributes { return null; }
	#if !disable_sound @:hlNative("?hlfmod", "studio_eventinstance_set_3d_attributes") #end
	function set3DAttributes(attributes : F3DAttributes) : Bool { return false; }
	function start() : Bool { return false; }
	function stop(mode : StopMode) : Bool { return false; }
	function getTimelinePosition() : Int { return 0; }
	function setTimelinePosition(position : Int) : Bool { return false; }
	function getPlaybackState() : Int { return 0; }
	function release() : Bool { return false; }
	function getParameterByName(name : hl.Bytes) : Single { return 0; }
	function setParameterByName(name : hl.Bytes, value : Single, ignoreseekspeed : Bool) : Bool { return false; }
	function setParameterByNameWithLabel(name : hl.Bytes, label : hl.Bytes, ignoreseekspeed : Bool) : Bool { return false; }
	function setCallback(mask : EventCallbackType) : Bool { return false; }
	function setUserData(userdata : Dynamic) : Bool { return false; }
}

#if !disable_sound
@:hlNative("?hlfmod", "studio_bus_")
#end
abstract Bus(hl.Abstract<"FMOD_STUDIO_BUS">) {
	function isValid() : Bool { return false; }
	function getVolume() : Single { return 0; }
	function setVolume(volume : Single) : Bool { return false; }
	function getPaused() : Bool { return false; }
	function setPaused(paused : Bool) : Bool { return false; }
	function getMute() : Bool { return false; }
	function setMute(mute : Bool) : Bool { return false; }
}

#if !disable_sound
@:hlNative("?hlfmod", "studio_vca_")
#end
abstract Vca(hl.Abstract<"FMOD_STUDIO_VCA">) {
	function isValid() : Bool { return false; }
	function getVolume() : Single { return 0; }
	function setVolume(volume : Single) : Bool { return false; }
}

#if !disable_sound
@:hlNative("?hlfmod", "studio_bank_")
#end
abstract Bank(hl.Abstract<"FMOD_STUDIO_BANK">) {
	function isValid() : Bool { return false; }
	function unload() : Bool { return false; }
	function loadSampleData() : Bool { return false; }
	function unloadSampleData() : Bool { return false; }
	function getLoadingState() : Int { return 0; }
	function getSampleLoadingState() : Int { return 0; }
	function getEventCount() : Int { return 0; }
	function getEventList(arr : hl.NativeArray<EventDescription>) : Int { return 0; }
}

#if !disable_sound
@:hlNative("?hlfmod", "core_system_")
#end
abstract CoreSystem(hl.Abstract<"FMOD_SYSTEM">) {
	// public function setSoftwareFormat(...)
}

@:keep
class Native {
}
