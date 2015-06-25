package models.layouts;

import openfl.geom.Vector3D;
import views.ElementMesh;

interface ILayout 
{
	public var type:String;
	public var showTrails:Bool;
	public function getPosition( atomicNumber:Int ):Vector3D;
	public function position(element:ElementMesh ):Void;
}