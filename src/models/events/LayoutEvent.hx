package models.events;

import models.layouts.ILayout;
import openfl.events.Event;

class LayoutEvent extends Event
{
	static public inline var CHANGED:String = 'laayout changed';
	
	public var layout:ILayout;

	public function new( type:String, newLayout:ILayout, bubbles:Bool = false, cancelable:Bool = false ) 
	{
		layout = newLayout;
		super( type, bubbles, cancelable );
	}
	
	override public function clone():Event 
	{
		return new LayoutEvent( type, layout, bubbles, cancelable );
	}
}