class Main {
	static function main() {
		// Init with basic config
		fmod.Api.init("res/audio", "Master.bank");
		fmod.Api.loadBank("Master.strings.bank"); // Do not forgot load strings bank
		fmod.Api.loadBank("Music.bank");
		fmod.Api.loadBank("SFX.bank");

		// Display event list in a loaded bank
		var list = fmod.Api.getBankEventList("Music.bank");
		for (e in list) {
			trace(e.getPath());
		}

		#if !heaps
		// Try play some music
		var e = fmod.Api.getEvent("event:/Music/Level 02");
		trace("start playing");
		e.play();
		while (true) {
			fmod.Api.update();
		}
		e.release();
		fmod.Api.release();
		#else
		hxd.Res.initLocal();
		new TestHeaps();
		#end
	}
}