package egret.skins.vector
{

	
	import egret.components.Group;
	import egret.components.ToggleButton;
	import egret.components.UIAsset;
	import egret.layouts.HorizontalLayout;
	import egret.layouts.VerticalAlign;

	/**
	 * TreeItemRenderer默认皮肤
	 * @author dom
	 */
	public class TreeItemRendererSkin extends ItemRendererSkin
	{
		/**
		 * 构造函数
		 */		
		public function TreeItemRendererSkin()
		{
			super();
			this.minHeight = 22;
		}
		
		/**
		 * [SkinPart]图标显示对象
		 */
		public var iconDisplay:UIAsset;
		/**
		 * [SkinPart]子节点开启按钮
		 */
		public var disclosureButton:ToggleButton;
		/**
		 * [SkinPart]用于调整缩进值的容器对象。
		 */
		public var contentGroup:Group;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			contentGroup = new Group();
			contentGroup.top = 0;
			contentGroup.bottom = 0;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 1;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			contentGroup.layout = layout;
			addElement(contentGroup);
			
			disclosureButton = new ToggleButton();
			disclosureButton.skinName = TreeDisclosureButtonSkin;
			contentGroup.addElement(disclosureButton);
			
			iconDisplay = new UIAsset();
			contentGroup.addElement(iconDisplay);
			contentGroup.addElement(labelDisplay);
		}
	}
}