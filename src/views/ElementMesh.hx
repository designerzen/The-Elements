package views;

import away3d.entities.Mesh;
import models.Element;
import away3d.materials.lightpickers.StaticLightPicker;

import away3d.materials.ColorMaterial;

import away3d.primitives.SphereGeometry;
import away3d.core.base.Geometry;

import away3d.bounds.BoundingSphere;
import away3d.bounds.BoundingVolumeBase;

class ElementMesh extends Mesh
{
	static public inline var SCALE:Float = 0.5;
	
	public var model:Element;
	public var element( get_element, never ):Element;
	function get_element():Element
	{
		return model;
	}
	
	var skin:ColorMaterial;
	var lightPicker:StaticLightPicker;
	
	public function new( elementModel:Element, picker:StaticLightPicker ) 
	{
		model = elementModel;
		lightPicker = picker;
		
		var geometry:Geometry = new SphereGeometry( model.atomicNumber * SCALE );
		//var bounds:BoundingVolumeBase = new BoundingSphere();	// better on spherical meshes with bound picking colliders
		
		// if (bounds != null) mesh.bounds = bounds;

		
		// Apply material 
		skin = new ColorMaterial( model.cpkHexColor );
		skin.lightPicker = picker;
		
		super(geometry, skin);
	
		mouseEnabled = mouseChildren = true;
		
		// For shader based picking.
		shaderPickingDetails = true;

		// Use triangle collider
		// pickingCollider = PickingColliderType.FIRST_ENCOUNTERED;
		
		// position based on information
		//model.atomicNumber;
	
	}
	
}