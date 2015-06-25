package models;

class TableItemPosition
{
	public var column:Int = -1;
	public var row:Int = -1;
	
	public function new( c:Int, r:Int ) 
	{
		column = c;
		row = r;
	}
	public function toString():String
	{
		return "column : " + column + " row : "  +row;
	}
}