// 档案管理的浏览页面JS
jQuery.csPcsSuitView = {
	view : function(id) {
		var kitStyle = $.csPcsSuitView.getKitStyleByID(id);
		$("#_view_kitStyleCode").html(kitStyle.code);
		$("#_view_kitStyledefaultFabric").html(kitStyle.defaultFabric);
		$("#_view_kitStylefabrics").html(kitStyle.fabrics);
		$("#_view_kitStyletitleCn").html(kitStyle.title_Cn);
		$("#_view_kitStyletitleEn").html(kitStyle.title_En);
		$("#_view_kitStyleStyleName").html(kitStyle.styleName);
		$("#_view_kitStyleCategoryID").html($.csCore.getValue("Dict_"+kitStyle.clothingID));
		var category_style = new Array();
		category_style = kitStyle.categoryID.split(",");
		var styleH ="<td class='label'>上衣组合代码</td><td class='value'>"+category_style[0]+"</td><td class='label'>西裤组合代码</td><td class='value'>"+category_style[1]+"</td>";
		$("#category_style").html(styleH);
		if(category_style.length == 3){
			var styleHtm ="<td class='label'>马夹组合代码</td><td class='value'>"+category_style[2]+"</td><td></td><td></td>";
			$("#category_style3").html(styleHtm);
	}
	},
	getKitStyleByID : function(id) {
		var param= $.csControl.appendKeyValue("","id",id);
		var url = $.csCore.buildServicePath('/service/kitstyle/getkitstylebyid');
		var data = $.csCore.invoke(url,param);
		return data;
	},
	init:function(id) {
		$.csPcsSuitView.view(id);
	}
};