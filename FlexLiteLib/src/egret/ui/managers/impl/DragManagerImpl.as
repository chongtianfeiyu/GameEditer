package egret.ui.managers.impl
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Point;
	
	import egret.core.DragSource;
	import egret.core.UIGlobals;
	import egret.core.ns_egret;
	import egret.ui.core.Cursors;
	import egret.managers.CursorManager;
	import egret.managers.IDragManager;
	import egret.managers.ILayoutManagerClient;
	import egret.managers.dragClasses.DragProxy;
	
	use namespace ns_egret;
	
	
	/**
	 * 有鼠标图标的拖拽管理器实现类
	 * @author 雷羽佳
	 */	
	public class DragManagerImpl implements IDragManager
	{
		/**
		 * 构造函数
		 */		
		public function DragManagerImpl()
		{
		}
		
		/**
		 * 启动拖拽的组件
		 */		
		private var dragInitiator:InteractiveObject;
		/**
		 * 拖拽显示的图标
		 */		
		private var dragProxy:DragProxy;
		
		private var _isDragging:Boolean = false;
		/**
		 * 正在拖拽的标志
		 */	
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		/**
		 * 启动拖拽操作。请在MouseDown事件里执行此方法。
		 * @param dragInitiator 启动拖拽的组件
		 * @param dragSource 拖拽的数据源
		 * @param dragImage 拖拽过程中显示的图像
		 * @param xOffset dragImage相对dragInitiator的x偏移量,默认0。
		 * @param yOffset dragImage相对dragInitiator的y偏移量,默认0。
		 * @param imageAlpha dragImage的透明度，默认0.5。
		 */		
		public function doDrag(
			dragInitiator:InteractiveObject, 
			dragSource:DragSource, 
			dragImage:DisplayObject = null, 
			xOffset:Number = 0,
			yOffset:Number = 0,
			imageAlpha:Number = 0.5):void
		{
			if (_isDragging)
				return;
			
			_isDragging = true;
			
			this.dragInitiator = dragInitiator;
			
			dragProxy = new DragProxy(dragInitiator, dragSource);
			dragProxy.onUnderPointEnable = function():void{
				CursorManager.removeCursor(Cursors.DESKTOP_DISABLE);
				CursorManager.setCursor(Cursors.DESKTOP_DRAG,1);
			};
			dragProxy.onUnderPointDisable = function():void{
				CursorManager.removeCursor(Cursors.DESKTOP_DRAG);
				CursorManager.setCursor(Cursors.DESKTOP_DISABLE,1);
			};
			dragProxy.onExit = function():void{
				CursorManager.removeCursor(Cursors.DESKTOP_DRAG);
				CursorManager.removeCursor(Cursors.DESKTOP_DISABLE);
			};
			var stage:Stage = dragInitiator.stage;
			if(!stage){
				stage = UIGlobals.stages[0];
			}
			if(!stage)
				return;
			stage.addChild(dragProxy);	
			
			if (dragImage)
			{
				dragProxy.addToDisplayList(dragImage);
				if (dragImage is ILayoutManagerClient)
					UIGlobals.layoutManager.validateClient(ILayoutManagerClient(dragImage), true);
			}
			
			dragProxy.alpha = imageAlpha;
			
			var mouseX:Number = stage.mouseX;
			var mouseY:Number = stage.mouseY;
			var proxyOrigin:Point = dragInitiator.localToGlobal(new Point(-xOffset, -yOffset));
			dragProxy.xOffset = mouseX - proxyOrigin.x;
			dragProxy.yOffset = mouseY - proxyOrigin.y;
			dragProxy.x = proxyOrigin.x;
			dragProxy.y = proxyOrigin.y;
			dragProxy.startX = dragProxy.x;
			dragProxy.startY = dragProxy.y;
			if (dragImage) 
				dragImage.cacheAsBitmap = true;
		}
		/**
		 * 接受拖拽的数据源。通常在dragEnter事件处理函数调用此方法。
		 * 传入target后，若放下数据源。target将能监听到dragDrop事件。
		 */	
		public function acceptDragDrop(target:InteractiveObject):void
		{
			if (dragProxy)
				dragProxy.target = target;
			
		}
		/**
		 * 结束拖拽
		 */
		public function endDrag():void
		{
			if (dragProxy)
			{
				dragProxy.parent.removeChild(dragProxy);	
				
				if (dragProxy.numChildren > 0)
					dragProxy.removeFromDisplayListAt(0);
				dragProxy = null;
			}
			dragInitiator = null;
			_isDragging = false;
			
		}
	}
}