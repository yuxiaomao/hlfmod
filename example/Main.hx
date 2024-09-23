class Main {
	static function main() {
		var sys = hlfmod.Native.System.create();
		sys.release();
		trace(sys);
	}
}