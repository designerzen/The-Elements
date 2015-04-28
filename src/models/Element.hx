package models;

/*

An individual Element

*/

class Element
{
	public var name:String;						// Hydrogen
	public var symbol:String;					// H
	
	//https://en.wikipedia.org/wiki/CPK_coloring
	public var cpkHexColor:Int;					// FFFFFF
	public var jmolHexColor:Int;				// FFFFFF
	
	public var atomicNumber:Int;				// 1
	public var atomicRadius:Int;				// 37
	public var atomicMass:String;				// 1.00794(4)
	
	public var bondingType:String;				// diatomic
	public var standardState:String;			// gas
	public var electronicConfiguration:String;	// 1s1
	
	
	public var groupBlock:String;				// nonmetal
	public var oxidationStates:String;			// -1, 1
	
	public var electronAffinity:Int;			// -73
	public var electroNegativity:Float;			// :2.2
	public var density:Float;					// 0.0000899
	public var ionRadius:Float;					// 0.0000899
	
	public var vanDelWaalsRadius:Int;			// 120
	public var ionizationEnergy:Int;			// 1312
	public var meltingPoint:Int;				// 14
	public var boilingPoint:Int;				// 20
	public var yearDiscovered:Int;				// 1900
	
	public function new( data:ElementType ) 
	{
		// gah, copy all stuff from type definition to this object...
		name = data.name;
		symbol = data.symbol;
		
		if ( data.cpkHexColor.length < 6 )
		{
			cpkHexColor = 0xffffff;
		}else {
			cpkHexColor = Std.parseInt('0x'+data.cpkHexColor);
		}
		
		atomicNumber = data.atomicNumber;
		atomicRadius = data.atomicRadius;
		atomicMass = data.atomicMass;
		
		bondingType = data.bondingType;
		standardState = data.standardState;
		electronicConfiguration = data.electronicConfiguration;
		
		
		groupBlock = data.groupBlock;
		oxidationStates = data.oxidationStates;
		
		electronAffinity = data.electronAffinity;
		electroNegativity = data.electronegativity;
		
		density = data.density;
		ionRadius = data.ionRadius;
		
		vanDelWaalsRadius = data.vanDelWaalsRadius;
		ionizationEnergy = data.ionizationEnergy;
		meltingPoint = data.meltingPoint;
		boilingPoint = data.boilingPoint;
		yearDiscovered = data.yearDiscovered;
	}
	
	public function toString():String
	{
		var t:String = atomicNumber + ' - ' + name + ' [' + symbol +']';
		t += atomicNumber + ' atomicRadius ' + atomicRadius + ' atomicMass' + atomicMass;
		return t;
	}
}