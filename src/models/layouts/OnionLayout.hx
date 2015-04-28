package models.layouts;

class OnionLayout implements ILayout
{

	public function new() 
	{
		
	}
		
	public function position(element:ElementMesh):Void 
	{
		var model:Element = element.model;
		
		// Non-Random position.
		var r:Float = model.atomicNumber * model.atomicNumber * 0.1;
		//var r:Float = model.atomicNumber * 3;
		var azimuth:Float = model.atomicNumber;// 2 * Math.PI;
		var elevation:Float = 0.25 * Math.PI;
		var cosed:Float = Math.cos(elevation);
		element.x = r * cosed * Math.sin(azimuth);
		element.z = r * cosed * Math.cos(azimuth);
		//y = r * Math.sin(elevation);
		element.y = (model.atomicNumber * 3)-56;		
	}
}