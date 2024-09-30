
class TestHeaps extends SampleApp {

	var time = 0.;
	var music : fmod.Api.Event;
	var sfx : fmod.Api.Event;

	var beeper:Bool = true;
	var obj : h3d.scene.Mesh;
	var objPosition : h3d.Vector;

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
		music = fmod.Api.getEvent("event:/music/remix/01_forsaken_city");
		sfx = fmod.Api.getEvent("event:/game/general/seed_poof");
		if( music != null ) {
			trace("Playing "+music);
			music.play();
		}

		// Control
		addSlider("Music vol", function() { return fmod.Api.getVcaVolume("vca:/music"); }, function(v) { fmod.Api.setVcaVolume("vca:/music", v); });
		addSlider("SFX vol", function() { return fmod.Api.getVcaVolume("vca:/gameplay_sfx"); }, function(v) { fmod.Api.setVcaVolume("vca:/gameplay_sfx", v); });
		addCheck("Beeper", function() { return beeper; }, function(v) { beeper = v; });
		if ( music != null ) {
			addText("SFX Position");
			addSlider("X", function() { return objPosition.x; }, function(v) { objPosition.x = v; obj.x = v; sfx.setPosition(objPosition);}, -500, 500);
			addSlider("Y", function() { return objPosition.y; }, function(v) { objPosition.y = v; obj.y = v; sfx.setPosition(objPosition);}, -500, 500);
			addSlider("Z", function() { return objPosition.z; }, function(v) { objPosition.z = v; obj.z = v; sfx.setPosition(objPosition);}, -500, 500);
			addText("Camera(Listener) Position");
			addSlider("X", function() { return s3d.camera.pos.x; }, function (v) { s3d.camera.pos.x = v; fmod.Api.setCameraListenerPosition(s3d.camera, 0);}, -500, 500);
			addSlider("Y", function() { return s3d.camera.pos.y; }, function (v) { s3d.camera.pos.y = v; fmod.Api.setCameraListenerPosition(s3d.camera, 0);}, -500, 500);
			addSlider("Z", function() { return s3d.camera.pos.z; }, function (v) { s3d.camera.pos.z = v; fmod.Api.setCameraListenerPosition(s3d.camera, 0);}, -500, 500);
		}
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
	}

}