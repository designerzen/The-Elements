package models;

typedef ElementType =
{
	var cpkHexColor:String;				// FFFFFF
	var jmolHexColor:String;			// FFFFFF
	
	var atomicNumber:Int;				// 1
	var atomicRadius:Int;				// 37
	var atomicMass:String;				// 1.00794(4)
	
	var symbol:String;					// H
	var name:String;					// Hydrogen
	
	var bondingType:String;				// diatomic
	var standardState:String;			// gas
	var electronicConfiguration:String;	// 1s1
	
	
	var groupBlock:String;				// nonmetal
	var oxidationStates:String;			// -1, 1
	
	
	var electronegativity:Float;		// :2.2
	var density:Float;					// 0.0000899
	var ionRadius:Float;				// 0.0000899
	
	var vanDelWaalsRadius:Int;			// 120
	var electronAffinity:Int;			// -73
	var ionizationEnergy:Int;			// 1312
	var meltingPoint:Int;				// 14
	var boilingPoint:Int;				// 20
	var yearDiscovered:Int;				// 1900	
}