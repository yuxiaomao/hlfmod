class Main {
	static function main() {
		// Init with basic config
		fmod.Api.init("res/audio", "Master Bank.bank");
		fmod.Api.loadBank("Master Bank.strings.bank"); // Do not forgot load strings bank

		// Try play some music
		fmod.Api.loadBank("music.bank");
		var e = fmod.Api.getEvent("event:/music/remix/01_forsaken_city");
		trace("start playing");
		e.play();
		while (true) {
			fmod.Api.update();
		}
		e.release();
		fmod.Api.release();
	}
}