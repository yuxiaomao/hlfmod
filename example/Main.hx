class Main {
	static function main() {
		var sys = fmod.Native.System.create();
		sys.getEvent(@:privateAccess "aaa".toUtf8());
		sys.release();
		trace(sys);
	}
}