class Main {
	static function main() {
		var sys = hlfmod.Native.System.create();
		sys.getEvent(@:privateAccess "aaa".toUtf8());
		sys.release();
		trace(sys);
	}
}