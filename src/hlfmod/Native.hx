package hlfmod;

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

#if !disable_sound
@:hlNative("hlfmod", "studio_system_")
#end
abstract System(hl.Abstract<"FMOD_STUDIO_SYSTEM">) {
	public static function create() : System { return null; }
	public function release() : Bool { return false; }
	public function getCoreSystem() : CoreSystem { return null; }
	// public function setAdvancedSettings(...)
	public function initialize(maxchannels : Int, studioflags : InitFlags, coreflags : CoreInitFlags, extradriverdata : Dynamic) : Bool { return false; }
	public function update() : Bool { return false; }
	public function loadBankFile(filename : hl.Bytes, flags : LoadBankFlags) : Bank { return null; }
	public function getEvent(pathOrId : hl.Bytes) : EventDescription { return null; }
}

#if !disable_sound
@:hlNative("hlfmod", "core_system_")
#end
abstract CoreSystem(hl.Abstract<"FMOD_SYSTEM">) {
	// public function setSoftwareFormat(...)
}

#if !disable_sound
@:hlNative("hlfmod", "studio_bank_")
#end
abstract Bank(hl.Abstract<"FMOD_STUDIO_BANK">) {
	public function unload() : Bool { return false; }
	// public function getLoadingState(...) // asynchronous only
}

#if !disable_sound
@:hlNative("hlfmod", "studio_event_description_")
#end
abstract EventDescription(hl.Abstract<"FMOD_STUDIO_EVENTDESCRIPTION">) {
}

@:keep
class Native {
}
