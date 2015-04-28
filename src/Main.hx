package;

import haxe.Json;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageScaleMode;
import openfl.display.StageAlign;

import models.Elements;
import models.Element;
import models.ElementType;
import models.events.ElementEvent;

import views.ElementExplorer;
import views.Interaction;
import views.ElementInfoView;
import views.ElementMesh;

class Main extends Sprite 
{
	var explorer:ElementExplorer;
	var infoView:ElementInfoView;
	
	public function new() 
	{
		super();
		
		// set stage
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		createExplorer();
		createUI();
	}
	
	//////////////////////////////////////////////////////////////////
	//
	//////////////////////////////////////////////////////////////////
	function createExplorer() 
	{
		// second, create all elements...
		var elements:Elements = new Elements();
		elements.importJSON( "json/elements.json" );
		
		// third create our 3D world
		// and feed it our elements!
		explorer = new ElementExplorer( elements );
		explorer.addEventListener( ElementEvent.OVER, onElementMouseOver );
		explorer.addEventListener( ElementEvent.OUT, onElementMouseOut );
		explorer.addEventListener( ElementEvent.PRESSED, onElementMousePressed );
		addChild( explorer );
	}
	
	function createUI():Void
	{
		infoView = new ElementInfoView();
		addChild( infoView );
	}
	
	function onElementMousePressed(e:ElementEvent):Void 
	{
		trace( 'Mesh pressed ', e.model );
		// zoom into model!
		explorer.focusOn( e.mesh );
		infoView.show( e.model );
	}
	
	function onElementMouseOut(e:ElementEvent):Void 
	{
		infoView.hide();
	}
	
	function onElementMouseOver(e:ElementEvent):Void 
	{
		infoView.show( e.model );
	}
}
