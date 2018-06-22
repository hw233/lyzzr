/**Created by the LayaAirIDE,do not modify.*/
package ui.jiban {
	import laya.ui.*;
	import laya.display.*; 

	public class JibanUI extends View {
		public var tab:Tab;
		public var nameTab:Tab;
		public var list:List;
		public var back:Button;
		public var liushibtn:Button;
		public var splist:List;
		public var lslist:List;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1300,"height":1920},"child":[{"type":"Image","props":{"y":0,"x":0,"width":1300,"skin":"ui/bgImg/1011.png","height":2635}},{"type":"Tab","props":{"y":145,"x":342,"var":"tab"},"child":[{"type":"Button","props":{"y":0,"x":0,"stateNum":2,"skin":"button/btn_wodjibananniu.png","selected":true,"name":"item0","labelSize":33,"labelPadding":"10,20,18","labelColors":"#f1fdfd,#f1fdfd","label":"我的羁绊"}},{"type":"Button","props":{"y":0,"x":257,"stateNum":2,"skin":"button/btn_jibansuipiananiu.png","selected":false,"name":"item1","labelStrokeColor":"#c1c1c1","labelSize":33,"labelPadding":"10,-10,20","labelColors":"#f1fdfd,#f1fdfd","label":"羁绊碎片"}}]},{"type":"Tab","props":{"y":267,"x":11,"var":"nameTab"},"child":[{"type":"Button","props":{"y":0,"x":0,"stateNum":2,"skin":"button/btn_yeqian.png","selected":true,"name":"item0","labelSize":33,"labelColors":"#f1fdfd,#f1fdfd","labelAlign":"center","label":"全部"}},{"type":"Button","props":{"y":0,"x":241,"stateNum":2,"skin":"button/btn_yeqian.png","name":"item1","labelSize":33,"labelColors":"#f1fdfd,#f1fdfd","labelAlign":"center","label":"项天羽"}},{"type":"Button","props":{"y":0,"x":483,"stateNum":2,"skin":"button/btn_yeqian.png","name":"item2","labelSize":33,"labelColors":"#f1fdfd,#f1fdfd","labelAlign":"center","label":"欧阳末晓"}},{"type":"Button","props":{"y":0,"x":724,"stateNum":2,"skin":"button/btn_yeqian.png","name":"item3","labelSize":33,"labelColors":"#f1fdfd,#f1fdfd","labelAlign":"center","label":"何楚升"}},{"type":"Button","props":{"y":0,"x":966,"stateNum":2,"skin":"button/btn_yeqian.png","name":"item4","labelSize":33,"labelColors":"#f1fdfd,#f1fdfd","labelAlign":"center","label":"韩泰"}}]},{"type":"List","props":{"y":388,"x":51,"width":1214,"var":"list","repeatY":10,"repeatX":60,"height":1503}},{"type":"Button","props":{"y":15,"x":38,"var":"back","stateNum":1,"skin":"button/btn_fanhui.png"}},{"type":"Button","props":{"y":143,"x":962,"var":"liushibtn","stateNum":2,"skin":"button/btn_liushianniu.png","labelSize":33,"labelPadding":"10,-35,20","labelColors":"#f1fdfd,#f1fdfd","label":"流逝羁绊"},"child":[{"type":"Image","props":{"y":24,"x":34,"skin":"icon/liushiicon.png"}}]},{"type":"List","props":{"y":388,"x":51,"width":1214,"var":"splist","repeatY":10,"repeatX":60,"height":1503}},{"type":"List","props":{"y":388,"x":51,"width":1214,"var":"lslist","repeatY":10,"repeatX":60,"height":1503}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}