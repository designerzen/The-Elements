package views;

/*

A 3D WebGL View that let's you explore the individual Elements

*/

import away3d.core.base.Geometry;
import away3d.entities.Mesh;
import away3d.entities.SegmentSet;
import away3d.events.MouseEvent3D;
import away3d.primitives.LineSegment;
import models.events.LayoutEvent;
import models.Layouts;
import models.layouts.ILayout;
import models.layouts.MendelevLayout;
import models.layouts.OnionLayout;
import models.layouts.SingleRowLayout;
import models.layouts.SpiralLayout;
import motion.Actuate;
import openfl.geom.Vector3D;

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
	var layouts:Layouts;
	var trailSegments:SegmentSet;
	var currentFocus:ElementMesh;
	
	public function new( allElements:Elements ) 
	{
		elementModels = allElements;
		elementMeshes = new Array();
		layouts = new Layouts();
		
		super();
	}
	
	
	public function focusOn(mesh:ElementMesh) 
	{
		camera.lookAt(mesh.position);
		currentFocus = mesh;
	}
	/*
	//////////////////////////////////////////////////////////////
	// Initialise the Materials that we will use on our world
	//////////////////////////////////////////////////////////////
	override private function initMaterials():Void
	{
		
	}
	*/
	//////////////////////////////////////////////////////////////
	// Initialise Objects
	//////////////////////////////////////////////////////////////
	override private function initObjects():Void
	{
		var layout:ILayout = layouts.current;
		
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
			
		// only if the layout demands it
		trailSegments = new SegmentSet();
		if ( layout.showTrails ) trailSegments = drawConnections( elementMeshes, trailSegments );
		
		// and put it on the screen
		view.scene.addChild( trailSegments );
	}
	
	private function changeLayout( increment:Int=1, animate:Bool=true ):String
	{
		// fetch the layout
		var layout:ILayout = layouts.increment( increment );
		var duration:Float = 0.3;
		var delay:Float = 0;
		var overlap:Float = 1 / 13;
		var quantity:Int = elementMeshes.length;
		var count:Int = 0;
		
		for ( elementMesh in elementMeshes )	
		{
			// position according to rules set out in layout
			if ( animate )
			{
				var destination:Vector3D = layout.getPosition( elementMesh.model.atomicNumber );
				
				if ( count < quantity-1 ) Actuate.tween( elementMesh, duration, {x:destination.x,y:destination.y,z:destination.z} ).delay( delay );
				else  Actuate.tween( elementMesh, duration, {x:destination.x,y:destination.y,z:destination.z} ).delay( delay ).onComplete( onLayoutAnimated );
				
				delay += duration * overlap;
			}
			else {
				layout.position( elementMesh );
			}
			
			count++;
		}
		
		// trails :
		// firstly clear out any existing trails
		trailSegments.removeAllSegments();
		
		// draw trails immediately
		if ( layout.showTrails && !animate ) 
		{
			trailSegments = drawConnections( elementMeshes, trailSegments );
		}
		
		dispatchEvent( new LayoutEvent( LayoutEvent.CHANGED, layout ) );
		
		return layout.type;
	}
	
	private function onLayoutAnimated():Void
	{
		var layout:ILayout = layouts.current;
		if ( layout.showTrails ) 
		{
			trailSegments = drawConnections( elementMeshes, trailSegments );
		}
	}
	
	private function drawConnections( meshes:Array<ElementMesh>, segmentSet:SegmentSet ):SegmentSet
	{
		for ( i in 1...meshes.length )
		{
			var previous:ElementMesh = meshes[i-1];
			var next:ElementMesh = meshes[i];
			var connectingLine:LineSegment = new LineSegment( previous.position, next.position, 0xefefef, 0xdedede, 1 );
		
			segmentSet.addSegment( connectingLine );
		}
		return segmentSet;
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
			case Keyboard.SPACE:
				changeLayout();
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