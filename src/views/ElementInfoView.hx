package views;

import models.Element;
import openfl.display.Sprite;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.filters.DropShadowFilter;

class ElementInfoView extends Sprite
{
	var textElement:TextField;
	var textLayout:TextField;

	public function new() 
	{
		super();
		mouseEnabled = false;
		initText();
	}
	
	private function createField( fontSize:Int=18, colour:Int=0xffffff ):TextField
	{
		var t:TextField = new TextField();
		t.defaultTextFormat = new TextFormat("Verdana", fontSize, colour);
		t.width = 1000;
		t.height = 200;
		t.selectable = false;
		t.mouseEnabled = false;
		t.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0), new DropShadowFilter(1, 45+180, 0x0, 1, 0, 0)];
	
		return t;
	}
	
	private function initText()
	{
		
		textLayout = createField( 24 );
		textLayout.x = 25;
		textLayout.y = 50;
		
		addChild(textLayout);
		
		textElement = createField( 17 );
		textElement.x = 25;
		textElement.y = 450;
		
		textElement.text = "Camera controls -----\n";
		textElement.text = "  Click and drag on the stage to rotate camera.\n";
		textElement.appendText("  Keyboard arrows and WASD also rotate camera and Z and X zoom camera.\n");
		textElement.appendText("Picking ----- \n");
		textElement.appendText("  Click on the head model to draw on its texture. \n");
		textElement.appendText("  Red objects have triangle picking precision. \n" );
		textElement.appendText("  Blue objects have bounds picking precision. \n" );
		textElement.appendText("  Gray objects are disabled for picking but occlude picking on other objects. \n" );
		textElement.appendText("  Black objects are completely ignored for picking. \n" );
		
		addChild(textElement);
	}

	public function setLayout(text:String) :Void
	{
		textLayout.text = text;
		visible = true;
	}
	
	public function setText(text:String) :Void
	{
		textElement.text = text;
		textElement.visible = true;
	}
	
	public function showElement(model:Element) :Void
	{
		textElement.text = model.toString();
		textElement.visible = true;
	}
	
	public function hide() 
	{
		textElement.text = '';
		textElement.visible = false;
	}
	
	
}