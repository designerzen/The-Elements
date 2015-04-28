package views;

import away3d.cameras.Camera3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.controllers.HoverController;
import away3d.core.pick.PickingType;
import away3d.core.pick.RaycastPicker;
import away3d.debug.AwayStats;
import away3d.lights.PointLight;
import away3d.materials.lightpickers.StaticLightPicker;

import openfl.display.Sprite;
import openfl.events.Event;

class Away3dView extends Sprite
{
	// engine variables
	var scene:Scene3D;
	var camera:Camera3D;
	var view:View3D;
	var awayStats:AwayStats;
	var cameraController:HoverController;
	
	var raycastPicker:RaycastPicker;
	var pointLight:PointLight;
	var lightPicker:StaticLightPicker;
	
	// navigation variables
	var move:Bool = false;
	var lastPanAngle:Float;
	var lastTiltAngle:Float;
	var lastMouseX:Float;
	var lastMouseY:Float;
	var tiltSpeed:Float = 4;
	var panSpeed:Float = 4;
	var distanceSpeed:Float = 4;
	var tiltIncrement:Float = 0;
	var panIncrement:Float = 0;
	var distanceIncrement:Float = 0;
	
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	function onAddedToStage( event:Event ):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		init();		
	}
	
	/**
	 * Global initialise function
	 */
	private function init():Void
	{
		initEngine();
		initLights();
		initMaterials();
		initObjects();
		initListeners();
	}
	
	/**
	 * Initialise the engine
	 */
	private function initEngine():Void
	{
		raycastPicker = new RaycastPicker(false);

		view = new View3D();
		view.forceMouseMove = true;
		
		scene = view.scene;
		camera = view.camera;

		// Chose global picking method ( chose one ).
		// view.mousePicker = PickingType.SHADER; // Uses the GPU, considers gpu animations, and suffers from Stage3D's drawToBitmapData()'s bottleneck.
		// view.mousePicker = PickingType.RAYCAST_FIRST_ENCOUNTERED; // Uses the CPU, fast, but might be inaccurate with intersecting objects.
		view.mousePicker = PickingType.RAYCAST_BEST_HIT; // Uses the CPU, guarantees accuracy with a little performance cost.

		//setup controller to be used on the camera
		cameraController = new HoverController(camera, null, 180, 20, 320, 5);
		
		addChild(view);
		
		awayStats = new AwayStats(view);
		addChild(awayStats);
	}
	
	/**
	 * Initialise the lights
	 */
	private function initLights():Void
	{
		//create a light for the camera
		pointLight = new PointLight();
		scene.addChild(pointLight);
		lightPicker = new StaticLightPicker([pointLight]);
	}
	
	/**
	 * Initialise the material
	 */
	private function initMaterials():Void
	{

	}
	
	/**
	 * Initialise the scene objects
	 */
	private function initObjects():Void
	{
		
	}

	/**
	 * Initialise the listeners
	 */
	private function initListeners():Void
	{
		view.setRenderCallback(onEnterFrame);
		stage.addEventListener(Event.RESIZE, onResize);
		onResize();
	}
	
	public function onResize(event:Event = null):Void
	{
		view.width = stage.stageWidth;
		view.height = stage.stageHeight;
		awayStats.x = stage.stageWidth - awayStats.width;
	}
	
	private function onEnterFrame(event:Event):Void
	{
		if (move) {
			cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
			cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
		}
		cameraController.panAngle += panIncrement;
		cameraController.tiltAngle += tiltIncrement;
		cameraController.distance += distanceIncrement;
	}
	
}