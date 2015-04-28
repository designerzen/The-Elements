package models.layouts;

import views.ElementMesh;

class MendelevLayout implements ILayout
{

	var table:Map<Int, TableItemPosition>;
	
	private static var rows:Int = 9;
	private static var columns:Int = 19;//18;
	private static var gap:Float = 100;
	
	private var heavyMetals:Int = 14;
	
	private var atomicNumber:Int = 1;
	private var offsetX:Float = (columns * gap )/2;
	private var offsetY:Float = (rows * gap )/2;
	
	public function new() 
	{
		
		table = new Map<Int, TableItemPosition>();
		
		// Row 1
		var row:Int = 0;
		for ( r in 0...rows )
		{
			var column:Int = 0;
			
			// Loop through the columns
			for ( c in 0...columns )
			{
				if ( column >= columns )
				{
					break;
				}
				
				// depending on row
				if ( (column == 1) && ( row == 0) ) 
				{
					column += 16;
				}
				else if ( (column == 2) && ( row == 1) ) 
				{
					column += 10;
				}
				else if ( (column == 2) && ( row == 2) )
				{
					column += 10;
				}
				else if ( (column == 12) && ( row == 6) )
				{
					column = 0;
					break;
				}
				else if ( (row > 6) && (column >= heavyMetals) )
				{
					break;
				}
				var position:TableItemPosition = new TableItemPosition( column, row );
				trace( atomicNumber, position.toString() );
				
				table.set( atomicNumber++, position );
				column++;
				
			}
			row++;
		}
		
	}
	
	
	public function position(element:ElementMesh):Void 
	{
		// this is a 2D Table where specific rules about
		// electron shells dictate where on the table they
		// should be positioned.
		// This reveals certain trends and characteristics
		// in properties in sub sections of the table
		var model:Element = element.model;
		var position:TableItemPosition = table.get( model.atomicNumber );
		
		element.x = gap * position.column - offsetX;
		//element.z = r;
		element.y = -gap * position.row + offsetY;		
	}
	
}