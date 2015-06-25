package models.layouts;
import openfl.geom.Vector3D;
import views.ElementMesh;

class HarrisonSpiralLayout implements ILayout
{
	public var showTrails:Bool = false;
	public var type:String = 'Spiral periodic table (Robert W Harrison)';
	
	private static var rows:Int = 9;
	private static var columns:Int = 19;//18;
	private static var gap:Float = 100;
	
	private var offsetX:Float = 0;
	private var offsetY:Float = 0;
	
	private var table:Map<Int, TableItemPosition>;
	
	public function new() 
	{
		var atomicNumber:Int = 1;
		table = new Map<Int, TableItemPosition>();
		
		// Spiral starting with least dense around the outside
		// so the spiral has denser elements in the middle
		
		// Row 1
		var row:Int = 0;
		for ( r in 0...200 )
		{
			var column:Int = 0;
			switch (r)
			{
				case 27:
				case 28:
				case 29:
					
				case 44:
				case 45:
				case 46:
					
				case 76:
				case 77:
				case 78:
						
				case 108:
				case 109:
				case 110:
					
				default:
					row++;
			}
			column++;
			
			var position:TableItemPosition = new TableItemPosition( column, row );
				
			table.set( atomicNumber++, position );

			row++;
		}
	}
	// Simply provide an atomic number...
	public function getPosition( atomicNumber:Int ):Vector3D 
	{
		var position:TableItemPosition = table.get( atomicNumber );
		var x:Float =  200  * Math.sin(position.column);
		var y:Float = 0;
		var z:Float = 200  * Math.cos(position.row);

		return new Vector3D( x,y,z );
	}
	
	public function position(element:ElementMesh ):Void 
	{
		// this is a 2D Table where specific rules about
		// electron shells dictate where on the table they
		// should be positioned.
		// This reveals certain trends and characteristics
		// in properties in sub sections of the table
		var model:Element = element.model;
		var position:Vector3D = getPosition( model.atomicNumber );
		
		element.x = position.x;
		element.y = position.y;		
		element.z = position.z;	
	}
}