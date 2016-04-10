package flower.binding.compiler.structs
{
	public class ExprAtrItem
	{
		/**
		 * 类型可以为
		 * () 表示 (Expr)
		 * string 字符串
		 * id 
		 * . .id
		 * call 函数调用
		 * object
		 */
		public var type:String;
		public var val:*;
		
		public function ExprAtrItem(type:String,val:*)
		{
			this.type = type;
			this.val = val;
		}
	}
}