package models.layouts;

import openfl.geom.Vector3D;
import views.ElementMesh;

class SpiralLayout implements ILayout
{
	public var showTrails:Bool = true;
	public var type:String = 'Spiral';
	
	public function new() 
	{
		
	}
	// Simply provide an atomic number...
	public function getPosition( atomicNumber:Int ):Vector3D 
	{
		var r:Float = 1 + atomicNumber * atomicNumber * 0.04;
		//var r:Float = model.atomicNumber * 3;
		var azimuth:Float = atomicNumber;// 2 * Math.PI;
		var elevation:Float = 0.25 * Math.PI;
		var cosed:Float = Math.cos(elevation);
		var x:Float =   r * cosed * Math.sin(azimuth);
		var y:Float = ( atomicNumber * 5 )-56;
		var z:Float = r * cosed * Math.cos(azimuth);

		return new Vector3D( x,y,z );
	}
	
	public function position(element:ElementMesh ):Void 
	{
		var model:Element = element.model;
		var position:Vector3D = getPosition( model.atomicNumber );
		
		element.x = position.x;
		element.y = position.y;		
		element.z = position.z;		
	}
}