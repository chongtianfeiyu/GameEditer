package main.panels.directionView
{
	import flash.events.MouseEvent;
	
	import egret.components.Group;
	import egret.components.Menu;
	import egret.ui.components.IconButton;
	
	import main.data.directionData.DirectionDataBase;
	import main.data.parsers.MenuData;
	import main.data.parsers.QuickMenu;
	import main.events.DirectionEvent;
	import main.events.EventMgr;
	import main.menu.MenuID;
	import main.menu.NativeMenuExtend;
	import main.menu.NativeMenuItemExtend;
	import main.panels.components.DirectionTreeItem;

	public class DirectionViewItem extends DirectionTreeItem
	{
		public function DirectionViewItem()
		{
			super();
			this.skinName = DirectionViewItemSkin;
			this.addEventListener(MouseEvent.CLICK,onShow);
		}
		
		public var buttonContainer:Group;
		public var button0:IconButton;
		public var button1:IconButton;
		public var button2:IconButton;
		public var button3:IconButton;
		public var button4:IconButton;
		//		public var button5:IconButton;
		//		public var button6:IconButton;
		//		public var button7:IconButton;
		
		override public function set data(value:Object):void {
			super.data = value;
			
			buttonContainer.visible = this.selected;
			
			for(var i:int = 0; i < 5; i++) {
				this["button" + i].visible = false;
			}
			
			var d:DirectionDataBase = this.data.directionData;
			for(i = 0; i < d.quickMenu.length; i++) {
				var btn:IconButton = this["button" + i];
				var quickMenu:QuickMenu = d.quickMenu[i];
				btn.visible = true;
				btn.icon = d.quickMenu[i].icon;
				if(quickMenu.toolTip) {
					btn.toolTip = quickMenu.toolTip;
				}
				if(quickMenu.clickFunction) {
					quickMenu.clickFunction.dir = d;
					btn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
						quickMenu.clickFunction.call();
					});
				}
			}
			var menuList:Array = [new NativeMenuItemExtend(d.url,MenuID.CLEARLOG,false,null,null)];
			for(i = 0; i < d.menu.length; i++) {
				var menuData:MenuData = d.menu[i];
				menuData.clickFunction.dir = d;
				menuList.push(new NativeMenuItemExtend(menuData.name,MenuID.DIRECTION_ITEM_MENU,false,null,function():void{
					menuData.clickFunction.call();
				}));
			}
			this.contextMenu = new NativeMenuExtend(menuList);
			this.toolTip = null;
			if(d.toolTip) {
				this.toolTip = d.toolTip;
				this.toolTipClass = d.toolTipClass;
			}
		}
		
		private function onShow(e:MouseEvent):void {
			var d:DirectionDataBase = this.data.directionData;
			if(d && d.isDirection == false) {
				var event:DirectionEvent = new DirectionEvent(DirectionEvent.SHOW_FILE,d);
				EventMgr.ist.dispatchEvent(event);
			}
		}
		
		private function clickButton(e:MouseEvent):void {
			(new LoaderPanel("panels/AddModelPanel.swf")).open(true);
		}
		
		override public function set selected(value:Boolean):void {
			super.selected = value;
			buttonContainer.visible = value;
		}
	}
}