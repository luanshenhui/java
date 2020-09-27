// 档案管理的浏览页面JS
jQuery.csAssembleView = {
	view : function(id) {
		var assemble = $.csAssembleView.getAssembleByID(id);
		$.csCore.viewWithJSON('view_assemble', assemble);
		$("#_view_assembleCode").html(assemble.code);
		$("#_view_assembleClothing").html(assemble.clothName);
		$("#_view_assembleStyle").html(assemble.styleName);
		
		if(!$.csValidator.isNull(assemble.process)){
			var domDetail = "";
			var pro = assemble.process.split(",");
			$.each(pro,function(i,detail){
				domDetail += "<span><label>"+pro[i]+"</label></span><br />";
			});
			$("#_view_assembleProcess").html(domDetail);
		}
		
		
		if(!$.csValidator.isNull(assemble.specialProcess)){
			var domDetail = "";
			var pro = assemble.specialProcess.split(",");
			$.each(pro,function(i,detail){
				domDetail += "<span><label>"+pro[i]+"</label></span><br />";
			});
			$("#_view_assemblespecialProcess").html(domDetail);
		}
		
		$("#_view_assemblebrands").html(assemble.brands);
		$("#_view_assembledefaultFabric").html(assemble.defaultFabric);
		$("#_view_assemblefabrics").html(assemble.fabrics);
		$("#_view_assembletitleCn").html(assemble.titleCn);
		$("#_view_assembletitleEn").html(assemble.titleEn);
		$("#_view_created").html(assemble.createBy);
		$("#_view_pubDate").html($.csDate
				.formatMillisecondDate(assemble.createTime));

	},
	init : function(id) {
		// $.csAssembleView.bindLabel();
		$.csAssembleView.view(id);
		$.csCore.addValueLine('view_assemble');
	},

	getAssembleByID : function(id) {
		var param = $.csControl.appendKeyValue("", "id", id);
		return $.csCore
				.invoke(
						$.csCore
								.buildServicePath('/service/assemble/getAssembleByID?view=view'),
						param);
	}
};