class Main {
	static function main() {
		// Init with basic config
		fmod.Api.init("res/audio", "Master Bank.bank");
		fmod.Api.loadBank("Master Bank.strings.bank"); // Do not forgot load strings bank
		fmod.Api.loadBank("music.bank");
		fmod.Api.loadBank("sfx.bank");

		#if !heaps
		// Try play some music
		var e = fmod.Api.getEvent("event:/music/remix/01_forsaken_city");
		trace("start playing");
		e.play();
		while (true) {
			fmod.Api.update();
		}
		e.release();
		fmod.Api.release();
		#else
		hxd.Res.initEmbed();
		new TestHeaps();
		#end
	}
}