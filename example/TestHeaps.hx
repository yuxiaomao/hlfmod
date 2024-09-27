
class TestHeaps extends SampleApp {

	var time = 0.;
	var slider : h2d.Slider;
	var music : fmod.Api.Event;
	var musicPosition : h2d.Text;
	var beeper:Bool = true;
	// var pitchFilter : hxd.snd.effect.Pitch;
	// var pitchShift:Bool = false;
	// var pitchSlider : h2d.Slider;

	var sound_fx : fmod.Api.Event;

	override function init() {
		super.init();

		music = fmod.Api.getEvent("event:/music/remix/01_forsaken_city");
		sound_fx = fmod.Api.getEvent("event:/game/general/bird_squawk");
		// pitchFilter = new hxd.snd.effect.Pitch();
		// var lowpass = new hxd.snd.effect.LowPass();
		// var spatial = new hxd.snd.effect.Spatialization();
		if( music != null ) {
			trace("Playing "+music);
			music.play();
			//music.queueSound(...);
			// music.onEnd = function() trace("LOOP");
			// // Use effect processing on the channel
			// music.addEffect(pitchFilter);
			// music.addEffect(lowpass);
			// music.addEffect(spatial);
		}

		// slider = new h2d.Slider(300, 10);
		// slider.onChange = function() {
		// 	music.position = slider.value * music.duration;
		// };
		// musicPosition = new h2d.Text(getFont());

		// slider.x = 150;
		// slider.y = 80;
		// if( music == null ) slider.remove();
		// slider.onChange = function() {
		// 	music.position = slider.value * music.duration;
		// };
		// musicPosition.setPosition(460, 80);

		// addSlider("Global vol", function() { return hxd.snd.Manager.get().masterVolume; }, function(v) { hxd.snd.Manager.get().masterVolume = v; });
		addCheck("Beeper", function() { return beeper; }, function(v) { beeper = v; });
		// addButton("Play noise", function() {
		// 	var c = new NoiseChannel();
		// 	haxe.Timer.delay(c.stop, 1000);
		// });
		if ( music != null ) {
			// addCheck("Music mute", function() { return music.mute; }, function(v) { music.mute = v; });
			// addSlider("Music vol", function() { return music.volume; }, function(v) { music.volume = v; });
			var f = new h2d.Flow(fui);
			f.horizontalSpacing = 5;
			var tf = new h2d.Text(getFont(), f);
			tf.text = "Music pos";
			tf.maxWidth = 70;
			tf.textAlign = Right;
			// f.addChild(slider);
			// f.addChild(musicPosition);
			// pitchSlider = addSlider("Pitch val", function() { return pitchFilter.value; }, function(v) { pitchFilter.value = v; }, 0, 2);
			// addCheck("Pitch shift", function() { return pitchShift; }, function (v) { pitchShift = v; });
			// addSlider("Lowpass gain", function() { return lowpass.gainHF; }, function(v) { lowpass.gainHF = v; }, 0, 1);
			addText("Spatialization");
			// addSlider("X", function() { return spatial.position.x; }, function(v) { spatial.position.x = v; }, -10, 10);
			// addSlider("Y", function() { return spatial.position.y; }, function(v) { spatial.position.y = v; }, -10, 10);
			// addSlider("Z", function() { return spatial.position.z; }, function(v) { spatial.position.z = v; }, -10, 10);
			addText("Spatialization Listener");
			// var listener = hxd.snd.Manager.get().listener;
			// addSlider("X", function() { return listener.position.x; }, function (v) { listener.position.x = v; }, -10, 10);
			// addSlider("Y", function() { return listener.position.y; }, function (v) { listener.position.y = v; }, -10, 10);
			// addSlider("Z", function() { return listener.position.z; }, function (v) { listener.position.z = v; }, -10, 10);
		}
	}

	override function update(dt:Float) {
		fmod.Api.update();
		if ( beeper ) {
			time += dt;
			if( time > 1 ) {
				time--;
				sound_fx.play();
				engine.backgroundColor = 0xFFFF0000;
			} else
				engine.backgroundColor = 0;
		}

		// if ( pitchShift ) {
		// 	pitchFilter.value = Math.max(Math.cos(hxd.Timer.lastTimeStamp / 4) + 1, 0.1);
		// 	pitchSlider.value = pitchFilter.value;
		// 	pitchSlider.onChange();
		// }

		// if( music != null ) {
		// 	slider.value = music.position / music.duration;
		// 	musicPosition.text = hxd.Math.fmt(music.position) + "/" + hxd.Math.fmt(music.duration);
		// 	if( hxd.Key.isPressed(hxd.Key.M) ) {
		// 		music.mute = !music.mute;
		// 	}
		// }

		// if( hxd.Key.isPressed(hxd.Key.SPACE) ) {
		// 	var c = new NoiseChannel();
		// 	haxe.Timer.delay(c.stop, 1000);
		// }
	}

}