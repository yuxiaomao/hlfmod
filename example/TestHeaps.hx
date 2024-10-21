
class TestHeaps extends SampleApp {

	var time = 0.;
	var music : fmod.Api.Event;
	var sfx : fmod.Api.Event;
	var dialogue : fmod.Api.Event;

	var beeper:Bool = true;
	var obj : h3d.scene.Mesh;
	var objPosition : h3d.Vector;

	var slider : h2d.Slider;
	var musicPosition : h2d.Text;

	override function init() {
		super.init();

		// 3D Object at position
		obj = addCube();
		objPosition = new h3d.Vector();

		// 3D Light
		var light = new h3d.scene.fwd.DirLight(new h3d.Vector(0.5, 0.5, -0.5), s3d);
		light.enableSpecular = true;
		(cast (s3d.lightSystem, h3d.scene.fwd.LightSystem)).ambientLight.set(0.3, 0.3, 0.3);

		// Sound
		music = fmod.Api.getEvent("event:/Music/Level 02");
		sfx = fmod.Api.getEvent("event:/Interactables/Wooden Collision");
		dialogue = fmod.Api.getEvent("event:/Character/Dialogue");
		dialogue.enableProgrammerSound();
		if( music != null ) {
			trace("Playing "+music);
			music.play();
		}

		// Timeline
		var f = new h2d.Flow(fui);
		slider = new h2d.Slider(300, 10, f);
		slider.onChange = function() {
			music.setTimelinePosition(Std.int(slider.value * music.getLength()));
		};
		musicPosition = new h2d.Text(getFont(), f);
		slider.x = 150;
		slider.y = 80;
		if( music == null ) slider.remove();
		slider.onChange = function() {
			music.setTimelinePosition(Std.int(slider.value * music.getLength()));
		};
		musicPosition.setPosition(460, 80);

		// Control
		addSlider("Music vol", function() { return fmod.Api.getBusVolume("bus:/Music"); }, function(v) { fmod.Api.setBusVolume("bus:/Music", v); });
		addSlider("SFX vol", function() { return fmod.Api.getBusVolume("bus:/SFX"); }, function(v) { fmod.Api.setBusVolume("bus:/SFX", v); });
		addCheck("Beeper", function() { return beeper; }, function(v) { beeper = v; });
		if ( music != null ) {
			var soundRange = 20;
			addText("SFX Position");
			addSlider("X", function() { return objPosition.x; }, function(v) { objPosition.x = v; obj.x = v; sfx.setPosition(objPosition);}, -soundRange, soundRange);
			addSlider("Y", function() { return objPosition.y; }, function(v) { objPosition.y = v; obj.y = v; sfx.setPosition(objPosition);}, -soundRange, soundRange);
			addSlider("Z", function() { return objPosition.z; }, function(v) { objPosition.z = v; obj.z = v; sfx.setPosition(objPosition);}, -soundRange, soundRange);
			addText("Camera(Listener) Position");
			addSlider("X", function() { return s3d.camera.pos.x; }, function (v) { s3d.camera.pos.x = v; fmod.Api.setCameraListenerPosition(s3d.camera, 0);}, -soundRange, soundRange);
			addSlider("Y", function() { return s3d.camera.pos.y; }, function (v) { s3d.camera.pos.y = v; fmod.Api.setCameraListenerPosition(s3d.camera, 0);}, -soundRange, soundRange);
			addSlider("Z", function() { return s3d.camera.pos.z; }, function (v) { s3d.camera.pos.z = v; fmod.Api.setCameraListenerPosition(s3d.camera, 0);}, -soundRange, soundRange);
		}

		// Dialog
		addButton("Load EN", function() { fmod.Api.unloadBank("Dialogue_CN.bank"); fmod.Api.loadBank("Dialogue_EN.bank"); } );
		addButton("Load CN", function() { fmod.Api.unloadBank("Dialogue_EN.bank"); fmod.Api.loadBank("Dialogue_CN.bank"); } );
		addButton("Welcome", () -> dialogue.play("welcome") );
		addButton("Main Menu", () -> dialogue.play("main menu") );
	}

	override function update(dt:Float) {
		// fmod.Api.setCameraListenerPosition(s3d.camera, 0);
		fmod.Api.update();
		if ( beeper ) {
			time += dt;
			if( time > 1 ) {
				time--;
				sfx.play();
				engine.backgroundColor = 0xFFFF0000;
			} else
				engine.backgroundColor = 0;
		}
		if ( music != null ) {
			var position = music.getTimelinePosition();
			var duration = music.getLength();
			slider.value = position / duration;
			musicPosition.text = hxd.Math.fmt(position) + "/" + hxd.Math.fmt(duration);
		}
	}

}
