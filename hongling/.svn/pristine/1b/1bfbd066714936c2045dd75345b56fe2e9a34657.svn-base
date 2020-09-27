jQuery.csAssembleCommon = {
	fillClothCategorys : function() {
		var cloths = $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/getClothCategorys'));
		$.csControl.fillOptions('clothingID', cloths, "ID", "name", "请选择");
	},
	fillStyleIDS : function(clothingID) {
		if (clothingID == null || clothingID == "") {
			var clothingID = $('#clothingID').val();
		}
		var param = $.csControl.appendKeyValue('', 'clothingID', clothingID);
		var styleIDs = $.csCore.invoke($.csCore
				.buildServicePath('/service/assemble/getStyleByClothingId'),
				param);
		$.csControl.fillOptions('styleID', styleIDs, "ID", "NAME", "请选择");
	}
}