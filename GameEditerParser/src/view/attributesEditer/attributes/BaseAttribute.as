package view.attributesEditer.attributes
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import egret.components.Label;
	import egret.ui.components.TextInput;
	
	import main.data.parsers.ReaderBase;
	import main.data.parsers.command.AttributeEXE;
	import main.events.EventMgr;
	
	import view.component.data.ComponentData;
	import view.events.ComponentAttributeEvent;
	import view.events.EditeComponentEvent;

	public class BaseAttribute extends AttributeBase
	{
		private var nameTxt:TextInput;
		
		public function BaseAttribute(data:ComponentData,reader:ReaderBase)
		{
			super("基本信息",reader);
			
			var label:Label = new Label();
			label.text = "类型:";
			label.y = 25;
			this.addElement(label);
			
			var parent:Label = new Label();
			parent.text = "父对象";
			parent.textColor = 0x9bc5ff;
			parent.x = 150;
			parent.y = 25;
			parent.underline = true;
			this.addElement(parent);
			parent.visible = data.parent?true:false;
//			var parentChange:Function = function(e:Event):void{
//				parent.visible = data.parent?true:false;
//			}
//			data.addEventListener("parent",parentChange);
//			this.addEventListener(Event.REMOVED_FROM_STAGE,function(e:Event):void {
//				data.removeEventListener("parent",parentChange);
//			});
			parent.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
				if(data.parent) {
					EventMgr.ist.dispatchEvent(new EditeComponentEvent(EditeComponentEvent.EDITE_COMPOENET,data.parent));
				}
			});
			
			
			var type:Label = new Label();
			type.text = data.type;
			type.x = 35;
			type.y = 25;
			this.addElement(type);
			
			label = new Label();
			label.text = "名称:";
			label.y = 50;
			this.addElement(label);
			
			
			nameTxt = new TextInput();
			nameTxt.width = 200;
			nameTxt.height = 20;
			nameTxt.x = 35;
			nameTxt.y = 50;
			this.addElement(nameTxt);
			nameTxt.text = data.name;
			nameTxt.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void {
				if(e.keyCode == 13) {
					var val:* = data.name;
					data.name = nameTxt.text;
					if(val != data.name) {
						reader.pushCommand(new AttributeEXE(data,"name",val));
					}
				}
			});
			nameTxt.addEventListener(FocusEvent.FOCUS_OUT,function(e:Event):void {
				var val:* = data.name;
				data.name = nameTxt.text;
				if(val != data.name) {
					reader.pushCommand(new AttributeEXE(data,"name",val));
				}
			});
			var nameFunc:Function = function(e:ComponentAttributeEvent):void {
				nameTxt.text = data.name;
			}
			data.addEventListener("name",nameFunc);
//			this.addEventListener(Event.REMOVED_FROM_STAGE,function(e:Event):void {
//				data.removeEventListener("name",nameFunc);
//			});
			
			this.height = 75;
			
		}
	}
}