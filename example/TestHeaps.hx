
class TestHeaps extends SampleApp {

	var time = 0.;
	var music : fmod.Api.Event;
	var sfx : fmod.Api.Event;

	var camCtrl : h3d.scene.CameraController;

	var beeper:Bool = true;
	var obj : h3d.scene.Mesh;
	var objPosition : h3d.Vector;

	var slider : h2d.Slider;
	var musicPosition : h2d.Text;

	override function init() {
		super.init();

		camCtrl = new h3d.scene.CameraController(s3d);
		camCtrl.loadFromCamera();
		camCtrl.set(15);
		camCtrl.toTarget();
		var defaultCamera = s3d.camera.clone();

		addCube(0.025, 0xFFFFFF);
		var gizmo = new h3d.scene.Graphics(s3d);
		gizmo.lineStyle(3, 0xFF0000);
		gizmo.drawLine(new h3d.col.Point(0, 0, 0), new h3d.col.Point(1, 0, 0));
		gizmo.setColor(0x00FF00);
		gizmo.drawLine(new h3d.col.Point(0, 0, 0), new h3d.col.Point(0, 1, 0));
		gizmo.setColor(0x0000FF);
		gizmo.drawLine(new h3d.col.Point(0, 0, 0), new h3d.col.Point(0, 0, 1));

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
		if( music != null ) {
			trace("Playing "+music);
			music.play();
		}

		// Timeline
		if( music != null ) {
			var f = new h2d.Flow(fui);
			slider = new h2d.Slider(300, 10, f);
			slider.onChange = function() {
				if( music != null ) {
					music.setTimelinePosition(Std.int(slider.value * music.getLength()));
				}
			};
			musicPosition = new h2d.Text(getFont(), f);
			slider.x = 150;
			slider.y = 80;
			musicPosition.setPosition(460, 80);
		}

		// Control
		addSlider("Music vol", function() { return fmod.Api.getBusVolume("bus:/Music"); }, function(v) { fmod.Api.setBusVolume("bus:/Music", v); });
		addSlider("SFX vol", function() { return fmod.Api.getBusVolume("bus:/SFX"); }, function(v) { fmod.Api.setBusVolume("bus:/SFX", v); });
		addCheck("Beeper", function() { return beeper; }, function(v) { beeper = v; });
		if ( sfx != null ) {
			var soundRange = 20;
			addText("SFX Position");
			addSlider("X", function() { return objPosition.x; }, function(v) { objPosition.x = v; obj.x = v; sfx.setPosition(objPosition);}, -soundRange, soundRange);
			addSlider("Y", function() { return objPosition.y; }, function(v) { objPosition.y = v; obj.y = v; sfx.setPosition(objPosition);}, -soundRange, soundRange);
			addSlider("Z", function() { return objPosition.z; }, function(v) { objPosition.z = v; obj.z = v; sfx.setPosition(objPosition);}, -soundRange, soundRange);
			addButton("Center Camera", function() { s3d.camera.load(defaultCamera); camCtrl.loadFromCamera(); } );
		}

		// Dialog
		addButton("Load EN", function() { fmod.Api.unloadBank("Dialogue_CN.bank"); fmod.Api.loadBank("Dialogue_EN.bank"); } );
		addButton("Load CN", function() { fmod.Api.unloadBank("Dialogue_EN.bank"); fmod.Api.loadBank("Dialogue_CN.bank"); } );
		addButton("Welcome", function() {
			var dialogue = fmod.Api.getEvent("event:/Character/Dialogue");
			dialogue.enableProgrammerSound();
			dialogue.play("welcome");
		});
		addButton("Main Menu", function() {
			var dialogue = fmod.Api.getEvent("event:/Character/Dialogue");
			dialogue.enableProgrammerSound();
			dialogue.play("main menu");
		} );
		addButton("Play music", function() {
			if( music == null )
				music = fmod.Api.getEvent("event:/Music/Level 02");
			music.play();
		} );
		addButton("Stop music", function() {
			if( music != null ) {
				music.remove();
			}
			music = null;
		} );
	}

	override function update(dt:Float) {
		fmod.Api.setCameraListenerPosition(s3d.camera, 0);
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
		fmod.Api.update(dt);
	}

}
