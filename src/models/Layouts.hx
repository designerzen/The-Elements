package models;

import models.layouts.*;

class Layouts
{
	var index:Int = 0;
	
	public var all:Array<ILayout>;
	public var current(get_current, set_current):ILayout;
	
	function set_current( layout:ILayout ) :ILayout
	{
		index = all.indexOf( layout );
		return get_current();
	}
	
	function get_current() :ILayout
	{
		return all[ index ];
	}
	
	public function new() 
	{
		all = new Array();
		all.push( new SpiralLayout() );
		all.push( new MendelevLayout() );
		all.push( new OnionLayout() );
		all.push( new HarrisonSpiralLayout() );
		all.push( new SingleRowLayout() );
		all.push( new JanetLeftStepLayout() );
	}
	
	public function increment( quantity:Int=1 ):ILayout
	{
		// fetch the next layout if you can
		var newIndex:Int = index + quantity;
		// jump to beginning
		if ( newIndex > all.length - 1 ) index = 0;
		// jump to end
		else if ( newIndex < 0 ) index = all.length - 1;
		// jump to position!s
		else index = newIndex;
		
		// fetch the layout
		return all[ index ];
	}
}