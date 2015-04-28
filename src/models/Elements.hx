package models;

/*

This is a collection of all of the Elements,
In sequence from smallest to largest.

It must be fed from the JSON file

*/

import haxe.Json;
import openfl.Assets;

class Elements
{
	
	public var all (get, never):Array<Element>;
    function get_all():Array<Element> { return elements; }

	var elements:Array<Element>;
	
	public function new() 
	{
		elements = new Array();
	}
	
	public function importJSON( jsonLocation:String ):Void
	{
		// first, let us create the Element List
		var raw:String = Assets.getText( jsonLocation );	// load data
		var table:Array<ElementType> = Json.parse( raw );
		importData( table );
		
	}
	public function importData( table:Array<ElementType> ):Void
	{
		
		// create! from JSON file?
		//elements.push( new Element() );
		for (entry in table)
		{
			var element:Element = new Element( entry );
			elements.push(element);
		}
		
	}
	
	/*
	
	public function exportJSON( ):Dynamic
	{
		
	}
	
	*/
}