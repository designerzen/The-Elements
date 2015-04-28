package views;

/*

A 3D WebGL View that let's you explore the individual Elements

*/

import away3d.core.base.Geometry;
import away3d.entities.Mesh;
import away3d.entities.SegmentSet;
import away3d.events.MouseEvent3D;
import away3d.primitives.LineSegment;
import models.layouts.ILayout;
import models.layouts.MendelevLayout;
import models.layouts.SpiralLayout;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;

import models.Element;
import models.Elements;
import models.events.ElementEvent;

import views.Away3dView;
import views.ElementMesh;

class ElementExplorer extends Away3dView
{
	var elementModels:Elements;
	var elementMeshes:Array<ElementMesh>;
	
	public function new( allElements:Elements ) 
	{
		elementModels = allElements;
		elementMeshes = new Array();
		super();
	}
	
	//////////////////////////////////////////////////////////////
	// Initialise the Materials that we will use on our world
	//////////////////////////////////////////////////////////////
	override private function initMaterials():Void
	{
		
	}
	
	//////////////////////////////////////////////////////////////
	// Initialise Objects
	//////////////////////////////////////////////////////////////
	override private function initObjects():Void
	{
		//var layout:ILayout = new SpiralLayout();
		var layout:ILayout = new MendelevLayout();
		// loop through elements...
		for ( element in elementModels.all )	
		{
			// Add to scene and store.
			trace( "Creating " + element + ' light:'+lightPicker );
			// Create an element and pass in our shared light
			var elementMesh:ElementMesh = new ElementMesh( element, lightPicker );
			// position according to rules set out in layout
			layout.position( elementMesh );
			// allow mouse events such as click to be recognised
			enableMeshMouseListeners( elementMesh );
			// save our element for use later
			elementMeshes.push( elementMesh );
			// add the element to our screen view
			view.scene.addChild( elementMesh );
		}
		
		// draw lines between elements
		var segmentSet:SegmentSet = new SegmentSet();
		
		for ( i in 1...elementMeshes.length )
		{
			var previous:ElementMesh = elementMeshes[i-1];
			var next:ElementMesh = elementMeshes[i];
			var connectingLine:LineSegment = new LineSegment( previous.position, next.position, 0xefefef, 0xdedede, 1 );
		
			segmentSet.addSegment( connectingLine );
		}
		
		view.scene.addChild( segmentSet );
	}
	
	override private function initListeners()
	{
		super.initListeners();
		
		view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel );
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	//////////////////////////////////////////////////////////////////
	// On Every Frame
	// Update camera.
	//////////////////////////////////////////////////////////////////
	override private function onEnterFrame(event:Event)
	{
		super.onEnterFrame(event);
	
		// Move light with camera.
		pointLight.position = camera.position;
		
		// Render 3D.
		view.render();
	}
	
	public function focusOn(mesh:ElementMesh) 
	{
		camera.lookAt(mesh.position);
	}
	
	// Keyboard interactions -------------------------------------------
	
	private function onKeyDown(event:KeyboardEvent)
	{
		switch (event.keyCode)
		{
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
	
	private function onKeyUp(event:KeyboardEvent)
	{
		switch (event.keyCode)
		{
			case Keyboard.UP, Keyboard.W, Keyboard.DOWN, Keyboard.S:
				tiltIncrement = 0;
			case Keyboard.LEFT, Keyboard.A, Keyboard.RIGHT, Keyboard.D:
				panIncrement = 0;
			case Keyboard.Z, Keyboard.X:
				distanceIncrement = 0;
		}
	}
	
	// Mouse interactions ----------------------------------------------
	
	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onStageMouseLeave(event:Event)
	{
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onMouseUp(event:MouseEvent)
	{
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onMouseDown(event:MouseEvent)
	{
		move = true;
		lastPanAngle = cameraController.panAngle;
		lastTiltAngle = cameraController.tiltAngle;
		lastMouseX = stage.mouseX;
		lastMouseY = stage.mouseY;
		stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	private function onMouseWheel(e:MouseEvent):Void 
	{
		var direction:Int = e.delta < 0 ? -1 : 1;
		//distanceIncrement = distanceSpeed * direction;
		cameraController.distance += distanceSpeed * direction;
	}
	
	// Mesh interactions ---------------------------------------------
	
	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function enableMeshMouseListeners( mesh:Mesh ):Void
	{
		mesh.addEventListener( MouseEvent3D.MOUSE_OVER, onMeshMouseOver );
		mesh.addEventListener( MouseEvent3D.MOUSE_OUT, onMeshMouseOut );
		mesh.addEventListener( MouseEvent3D.MOUSE_MOVE, onMeshMouseMove );
		mesh.addEventListener( MouseEvent3D.MOUSE_DOWN, onMeshMouseDown );
	}

	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onMeshMouseDown( event:MouseEvent3D ):Void
	{
		var mesh:ElementMesh = cast event.object;
		var element:Element = mesh.model;
		// show information about this element
		
		var event:ElementEvent = new ElementEvent( ElementEvent.PRESSED, mesh );
		dispatchEvent( event );
	}

	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onMeshMouseOver(event:MouseEvent3D):Void
	{
		var mesh:ElementMesh = cast event.object;
		mesh.showBounds = true;
		//pickingPositionTracer.visible = pickingNormalTracer.visible = true;
		onMeshMouseMove(event);
		
		var event:ElementEvent = new ElementEvent( ElementEvent.OVER, mesh );
		dispatchEvent( event );
	}

	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onMeshMouseOut(event:MouseEvent3D):Void
	{
		var mesh:ElementMesh = cast event.object;
		mesh.showBounds = false;
		
		//pickingPositionTracer.visible = pickingNormalTracer.visible = false;
		//pickingPositionTracer.position = new Vector3D();
		
		var event:ElementEvent = new ElementEvent( ElementEvent.OUT, mesh );
		dispatchEvent( event );
	}

	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	private function onMeshMouseMove(event:MouseEvent3D):Void
	{
		/*
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
		*/
	}
}