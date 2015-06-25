package models.layouts;
import openfl.geom.Vector3D;
import views.ElementMesh;

class SingleRowLayout implements ILayout
{
	public var showTrails:Bool = true;
	public var type:String = 'Row';
	
	private var table:Map<Int, TableItemPosition>;
	
	private static var gap:Int = 1;
	
	private var offsetX:Float = 0;
	private var offsetY:Float = 0;
	
	public function new() 
	{
		var atomicNumber:Int = 1;
		var x:Int = 0;
		table = new Map<Int, TableItemPosition>();
		for ( i in 0...180 )
		{
			var position:TableItemPosition = new TableItemPosition( x, 0 );
			trace( atomicNumber, position.toString() );
			x += i + gap;
			
			table.set( i, position );
		}
	}
	// Simply provide an atomic number...
	public function getPosition( atomicNumber:Int ):Vector3D 
	{
		var position:TableItemPosition = table.get( atomicNumber );
		var x:Float = position.column - offsetX;
		var y:Float = position.row + offsetY;
		var z:Float = 0;
		
		return new Vector3D( x,y,z );
	}
	
	public function position(element:ElementMesh):Void 
	{
		// we want these in one long row, seperated by widths...
		var model:Element = element.model;
		var position:Vector3D = getPosition( model.atomicNumber );
		
		element.x = position.x;
		element.y = position.y;		
		element.z = position.z;
	}
	
}