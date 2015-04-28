package views;

import models.Element;
import openfl.display.Sprite;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.filters.DropShadowFilter;

class ElementInfoView extends Sprite
{
	var text:openfl.text.TextField;

	public function new() 
	{
		super();
		mouseEnabled = false;
		initText();
	}
	
	private function initText()
	{
		text = new TextField();
		text.defaultTextFormat = new TextFormat("Verdana", 17, 0xFFFFFF);
		text.width = 1000;
		text.height = 200;
		text.x = 25;
		text.y = 50;
		text.selectable = false;
		text.mouseEnabled = false;
		text.text = "Camera controls -----\n";
		text.text = "  Click and drag on the stage to rotate camera.\n";
		text.appendText("  Keyboard arrows and WASD also rotate camera and Z and X zoom camera.\n");
		text.appendText("Picking ----- \n");
		text.appendText("  Click on the head model to draw on its texture. \n");
		text.appendText("  Red objects have triangle picking precision. \n" );
		text.appendText("  Blue objects have bounds picking precision. \n" );
		text.appendText("  Gray objects are disabled for picking but occlude picking on other objects. \n" );
		text.appendText("  Black objects are completely ignored for picking. \n" );
		text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0), new DropShadowFilter(1, 45+180, 0x0, 1, 0, 0)];
		addChild(text);
	}

	public function show(model:Element) :Void
	{
		text.text = model.toString();
		visible = true;
	}
	
	public function hide() 
	{
		text.text = '';
		visible = false;
	}
	
}