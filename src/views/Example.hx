package views;

import away3d.bounds.*;
import away3d.cameras.*;
import away3d.containers.*;
import away3d.controllers.*;
import away3d.core.base.*;
import away3d.core.pick.*;
import away3d.debug.*;
import away3d.entities.*;
import away3d.events.*;
import away3d.library.assets.*;
import away3d.lights.*;
import away3d.loaders.parsers.*;
import away3d.materials.*;
import away3d.materials.lightpickers.*;
import away3d.primitives.*;
import away3d.textures.*;
import away3d.library.Asset3DLibrary;

import openfl.display.*;
import openfl.events.*;
import openfl.geom.*;
import openfl.ui.*;
import openfl.utils.ByteArray;

import openfl.Lib;
import openfl.Assets;

class Example extends Away3dView
{
	private var HeadAsset:ByteArray;
	
	//material objects
	var painter:Sprite;
	var blackMaterial:ColorMaterial;
	var whiteMaterial:ColorMaterial;
	var grayMaterial:ColorMaterial;
	var blueMaterial:ColorMaterial;
	var redMaterial:ColorMaterial;

	//scene objects
	var pickingPositionTracer:Mesh;
	var scenePositionTracer:Mesh;
	var pickingNormalTracer:SegmentSet;
	var sceneNormalTracer:SegmentSet;
	var previoiusCollidingObject:PickingCollisionVO;
	
	var head:Mesh;
	var cubeGeometry:CubeGeometry;
	var sphereGeometry:SphereGeometry;
	var cylinderGeometry:CylinderGeometry;
	var torusGeometry:TorusGeometry;

	var PAINT_TEXTURE_SIZE:UInt = 1024;

	public function new()
	{
		super();
	}

	/**
	 * Initialise the material
	 */
	override private function initMaterials()
	{
		// uv painter
		painter = new Sprite();
		painter.graphics.beginFill( 0xFF0000 );
		painter.graphics.drawCircle( 0, 0, 10 );
		painter.graphics.endFill();

		// locator materials
		whiteMaterial = new ColorMaterial( 0xFFFFFF );
		whiteMaterial.lightPicker = lightPicker;
		blackMaterial = new ColorMaterial( 0x333333 );
		blackMaterial.lightPicker = lightPicker;
		grayMaterial = new ColorMaterial( 0xCCCCCC );
		grayMaterial.lightPicker = lightPicker;
		blueMaterial = new ColorMaterial( 0x0000FF );
		blueMaterial.lightPicker = lightPicker;
		redMaterial = new ColorMaterial( 0xFF0000 );
		redMaterial.lightPicker = lightPicker;
	}
	
	/**
	 * Initialise the scene objects
	 */
	override private function initObjects()
	{
		// To trace mouse hit position.
		pickingPositionTracer = new Mesh( new SphereGeometry( 2 ), new ColorMaterial( 0x00FF00, 0.5 ) );
		pickingPositionTracer.visible = false;
		pickingPositionTracer.mouseEnabled = false;
		pickingPositionTracer.mouseChildren = false;
		scene.addChild(pickingPositionTracer);
		
		scenePositionTracer = new Mesh( new SphereGeometry( 2 ), new ColorMaterial( 0x0000FF, 0.5 ) );
		scenePositionTracer.visible = false;
		scenePositionTracer.mouseEnabled = false;
		scene.addChild(scenePositionTracer);
		
		
		// To trace picking normals.
		pickingNormalTracer = new SegmentSet();
		pickingNormalTracer.mouseEnabled = pickingNormalTracer.mouseChildren = false;
		var lineSegment1:LineSegment = new LineSegment( new Vector3D(), new Vector3D(), 0xFFFFFF, 0xFFFFFF, 3 );
		pickingNormalTracer.addSegment( lineSegment1 );
		pickingNormalTracer.visible = false;
		view.scene.addChild( pickingNormalTracer );
		
		sceneNormalTracer = new SegmentSet();
		sceneNormalTracer.mouseEnabled = sceneNormalTracer.mouseChildren = false;
		var lineSegment2:LineSegment = new LineSegment( new Vector3D(), new Vector3D(), 0xFFFFFF, 0xFFFFFF, 3 );
		sceneNormalTracer.addSegment( lineSegment2 );
		sceneNormalTracer.visible = false;
		view.scene.addChild( sceneNormalTracer );
		
		
		// Load a head model that we will be able to paint on on mouse down.
		HeadAsset = Assets.getBytes("3d/head.obj");
		Asset3DLibrary.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetComplete);
		Asset3DLibrary.loadData(HeadAsset, null, null, new OBJParser(25));
		
		// Produce a bunch of objects to be around the scene.
		createABunchOfObjects();
		
		raycastPicker.setIgnoreList([sceneNormalTracer, scenePositionTracer]);
		raycastPicker.onlyMouseEnabled = false;
	}

	
	private function onAssetComplete( event:Asset3DEvent )
	{
		if( event.asset.assetType == Asset3DType.MESH ) {
			initializeHeadModel( cast( event.asset, Mesh) );
		}
	}

	
	
	private function initializeHeadModel( model:Mesh )
	{

		head = model;

		// Apply a bitmap material that can be painted on.
		var bmd:BitmapData = new BitmapData( PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0x888888 );
		#if html5
		// No perlin noise on html5 target
		for (i in 0...100) {
			var grey = Std.int(Math.random()*0xff);
			bmd.fillRect( new Rectangle( Math.random()*PAINT_TEXTURE_SIZE, Math.random()*PAINT_TEXTURE_SIZE, Math.random()*PAINT_TEXTURE_SIZE, Math.random()*PAINT_TEXTURE_SIZE), grey<<16 | grey<<8 | grey );
		}
		#else
		bmd.perlinNoise( 50, 50, 8, 1, false, true, 7, true );
		#end
		var bitmapTexture:BitmapTexture = new BitmapTexture( bmd );
		var textureMaterial:TextureMaterial = new TextureMaterial( bitmapTexture );
		textureMaterial.lightPicker = lightPicker;
		model.material = textureMaterial;

		// Set up a ray picking collider.
		// Due to the number of triangles Flash used PixelBender to calculate the hit however on all other targets
		// PixelBender is not available so has been removed.
		model.pickingCollider = PickingColliderType.BEST_HIT;
		
		// Apply mouse interactivity.
		model.mouseEnabled = model.mouseChildren = model.shaderPickingDetails = true;
		enableMeshMouseListeners( model );

		view.scene.addChild( model );
	}

	
	
	private function createABunchOfObjects() {

		cubeGeometry = new CubeGeometry( 25, 25, 25 );
		sphereGeometry = new SphereGeometry( 12 );
		cylinderGeometry = new CylinderGeometry( 12, 12, 25 );
		torusGeometry = new TorusGeometry( 12, 12 );

		for ( i in 0...40 ) {

			// Create object.
			var object:Mesh = createSimpleObject();

			// Random orientation.
			object.rotationX = 360 * Math.random();
			object.rotationY = 360 * Math.random();
			object.rotationZ = 360 * Math.random();

			// Random position.
			var r:Float = 200 + 100 * Math.random();
			var azimuth:Float = 2 * Math.PI * Math.random();
			var elevation:Float = 0.25 * Math.PI * Math.random();
			object.x = r * Math.cos(elevation) * Math.sin(azimuth);
			object.y = r * Math.sin(elevation);
			object.z = r * Math.cos(elevation) * Math.cos(azimuth);
		}
	}
	
	
	
	private function createSimpleObject():Mesh {

		var geometry:Geometry;
		var bounds:BoundingVolumeBase = null;
		
		// Chose a random geometry.
		var randGeometry:Float = Math.random();
		if( randGeometry > 0.75 ) {
			geometry = cubeGeometry;
		}
		else if( randGeometry > 0.5 ) {
			geometry = sphereGeometry;
			bounds = new BoundingSphere(); // better on spherical meshes with bound picking colliders
		}
		else if( randGeometry > 0.25 ) {
			geometry = cylinderGeometry;
			
		}
		else {
			geometry = torusGeometry;
		}
		
		var mesh:Mesh = new Mesh(geometry);
		
		if (bounds != null)
			mesh.bounds = bounds;

		// For shader based picking.
		mesh.shaderPickingDetails = true;

		// Randomly decide if the mesh has a triangle collider.
		var usesTriangleCollider:Bool = Math.random() > 0.5;
		if( usesTriangleCollider ) {
			mesh.pickingCollider = PickingColliderType.FIRST_ENCOUNTERED;
		}

		// Enable mouse interactivity?
		var isMouseEnabled:Bool = Math.random() > 0.25;
		mesh.mouseEnabled = mesh.mouseChildren = isMouseEnabled;

		// Enable mouse listeners?
		var listensToMouseEvents:Bool = Math.random() > 0.25;
		if( isMouseEnabled && listensToMouseEvents ) {
			enableMeshMouseListeners( mesh );
		}

		// Apply material according to the random setup of the object.
		choseMeshMaterial( mesh );

		// Add to scene and store.
		view.scene.addChild( mesh );

		return mesh;
	}

	private function choseMeshMaterial( mesh:Mesh ) {
		if( !mesh.mouseEnabled ) {
			mesh.material = blackMaterial;
		}
		else {
			if( !mesh.hasEventListener( MouseEvent3D.MOUSE_MOVE ) ) {
				mesh.material = grayMaterial;
			}
			else {
				if( mesh.pickingCollider != PickingColliderType.BOUNDS_ONLY ) {
					mesh.material = redMaterial;
				}
				else {
					mesh.material = blueMaterial;
				}
			}
		}
	}

	/**
	 * Initialise the listeners
	 */
	override private function initListeners()
	{
		super.initListeners();
		
		view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	/**
	 * Navigation and render loop
	 */
	override private function onEnterFrame(event:Event)
	{
		super.onEnterFrame(event);
		
		// Move light with camera.
		pointLight.position = camera.position;
		
		var collidingObject:PickingCollisionVO = raycastPicker.getSceneCollision(camera.position, view.camera.forwardVector, view.scene);
		//var mesh:Mesh;
		
		if (previoiusCollidingObject != null && previoiusCollidingObject != collidingObject) { //equivalent to mouse out
			scenePositionTracer.visible = sceneNormalTracer.visible = false;
			scenePositionTracer.position = new Vector3D();
		}
		
		if (collidingObject != null) {
			// Show tracers.
			scenePositionTracer.visible = sceneNormalTracer.visible = true;
			
			// Update position tracer.
			scenePositionTracer.position = collidingObject.entity.sceneTransform.transformVector(collidingObject.localPosition);
			
			// Update normal tracer.
			sceneNormalTracer.position = scenePositionTracer.position;
			var normal:Vector3D = collidingObject.entity.sceneTransform.deltaTransformVector(collidingObject.localNormal);
			normal.normalize();
			normal.scaleBy( 25 );
			var lineSegment:LineSegment = cast sceneNormalTracer.getSegment( 0 );
			lineSegment.end = normal.clone();
		}
		
		
		previoiusCollidingObject = collidingObject;
		
		// Render 3D.
		view.render();
	}
	
	/**
	 * Key down listener for camera control
	 */
	private function onKeyDown(event:KeyboardEvent)
	{
		switch (event.keyCode) {
			case Keyboard.UP, Keyboard.W:
				tiltIncrement = tiltSpeed;
			case Keyboard.DOWN, Keyboard.S:
				tiltIncrement = -tiltSpeed;
			case Keyboard.LEFT, Keyboard.A:
				panIncrement = panSpeed;
			case Keyboard.RIGHT, Keyboard.D:
				panIncrement = -panSpeed;
			case Keyboard.Z:
				distanceIncrement = distanceSpeed;
			case Keyboard.X:
				distanceIncrement = -distanceSpeed;
		}
	}
	
	/**
	 * Key up listener for camera control
	 */
	private function onKeyUp(event:KeyboardEvent)
	{
		switch (event.keyCode) {
			case Keyboard.UP, Keyboard.W, Keyboard.DOWN, Keyboard.S:
				tiltIncrement = 0;
			case Keyboard.LEFT, Keyboard.A, Keyboard.RIGHT, Keyboard.D:
				panIncrement = 0;
			case Keyboard.Z, Keyboard.X:
				distanceIncrement = 0;
		}
	}
	
	/**
	 * Mouse stage leave listener for navigation
	 */
	private function onStageMouseLeave(event:Event)
	{
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}


	/**
	 * Mouse up listener for navigation
	 */
	private function onMouseUp(event:MouseEvent)
	{
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}

	/**
	 * Mouse down listener for navigation
	 */
	private function onMouseDown(event:MouseEvent)
	{
		move = true;
		lastPanAngle = cameraController.panAngle;
		lastTiltAngle = cameraController.tiltAngle;
		lastMouseX = stage.mouseX;
		lastMouseY = stage.mouseY;
		stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}

	
	
	
	// ---------------------------------------------------------------------
	// 3D mouse event handlers.
	// ---------------------------------------------------------------------

	private function enableMeshMouseListeners( mesh:Mesh )
	{
		mesh.addEventListener( MouseEvent3D.MOUSE_OVER, onMeshMouseOver );
		mesh.addEventListener( MouseEvent3D.MOUSE_OUT, onMeshMouseOut );
		mesh.addEventListener( MouseEvent3D.MOUSE_MOVE, onMeshMouseMove );
		mesh.addEventListener( MouseEvent3D.MOUSE_DOWN, onMeshMouseDown );
	}

	/**
	 * mesh listener for mouse down interaction
	 */
	private function onMeshMouseDown( event:MouseEvent3D ) 
	{
		var mesh:Mesh = cast event.object;
		// Paint on the head's material.
		if( mesh == head ) {
			var uv:Point = event.uv;
			var textureMaterial:TextureMaterial = cast ( cast( event.object,Mesh ) ).material;
			var bmd:BitmapData = cast( textureMaterial.texture, BitmapTexture ).bitmapData;
			var x = Std.int( PAINT_TEXTURE_SIZE * uv.x );
			var y = Std.int( PAINT_TEXTURE_SIZE * uv.y );
			var matrix:Matrix = new Matrix();
			matrix.translate( x, y );
			bmd.draw( painter, matrix );
			cast( textureMaterial.texture, BitmapTexture ).invalidateContent();
		}
	}

	/**
	 * mesh listener for mouse over interaction
	 */
	private function onMeshMouseOver(event:MouseEvent3D)
	{
		var mesh:Mesh = cast event.object;
		mesh.showBounds = true;
		if( mesh != head ) mesh.material = whiteMaterial;
		pickingPositionTracer.visible = pickingNormalTracer.visible = true;
		onMeshMouseMove(event);
	}

	/**
	 * mesh listener for mouse out interaction
	 */
	private function  onMeshMouseOut(event:MouseEvent3D)
	{
		var mesh:Mesh = cast event.object;
		mesh.showBounds = false;
		if( mesh != head ) choseMeshMaterial( mesh );
		pickingPositionTracer.visible = pickingNormalTracer.visible = false;
		pickingPositionTracer.position = new Vector3D();
	}

	/**
	 * mesh listener for mouse move interaction
	 */
	private function  onMeshMouseMove(event:MouseEvent3D)
	{
		// Show tracers.
		pickingPositionTracer.visible = pickingNormalTracer.visible = true;

		// Update position tracer.
		pickingPositionTracer.position = event.scenePosition;

		// Update normal tracer.
		pickingNormalTracer.position = pickingPositionTracer.position;
		var normal:Vector3D = event.sceneNormal.clone();
		normal.scaleBy( 25 );
		var lineSegment:LineSegment = cast pickingNormalTracer.getSegment( 0 );
		lineSegment.end = normal.clone();
	}
}
