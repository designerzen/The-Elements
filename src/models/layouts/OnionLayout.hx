package models.layouts;

import openfl.geom.Vector3D;
import views.ElementMesh;

class OnionLayout implements ILayout
{
	public var showTrails:Bool = false;
	public var type:String = 'Onion';
	
	public function new() 
	{
		
	}
		// Simply provide an atomic number...
	public function getPosition( atomicNumber:Int ):Vector3D 
	{
		return new Vector3D( 0,0,0 );
	}
	
	public function position(element:ElementMesh ):Void 
	{
		var model:Element = element.model;
		element.x = 0;
		element.z = 0;
		element.y = 0;		
	}
}