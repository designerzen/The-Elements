package models.events;

import openfl.events.Event;
import views.ElementMesh;

class ElementEvent extends Event
{
	static public inline var PRESSED:String = 'pressed';
	static public inline var OVER:String = "over";
	static public inline var OUT:String = "out";
	
	var elementMesh:ElementMesh;
	
	public var mesh(get_mesh,never):ElementMesh;
	public var model(get_model,never):Element;
	 /**
	 * The vertical coordinate at which the event occurred in view coordinates.
	 */
     public var screenX:Float;
   public var screenY:Float;
   
	function get_mesh():ElementMesh
	{
		return elementMesh;
	}
	function get_model():Element
	{
		return elementMesh.element;
	}
	
	public function new( type:String, mesh:ElementMesh, bubbles:Bool = false, cancelable:Bool = false ) 
	{
		elementMesh = mesh;
		super( type, bubbles, cancelable );
	}
	
	override public function clone():Event 
	{
		return new ElementEvent( type, elementMesh, bubbles, cancelable );
	}
}