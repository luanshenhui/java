jQuery.csMemberCommon = {
	bindLabel : function() {
		$.csCore
				.getValue("$.csCore.getDictResourceName(DICT_BACKEND_MENU_MEMBER_MANAGER)",	null, ".list_search h1");
	},
	fillStatus : function(statusID) {
		$.csControl.fillOptions(statusID, $.csCore.getDicts(DICT_CATEGORY_MEMBER_STATUS), "ID", "name","");
	},
	fillGroup : function(groupID) {
		$.csControl.fillOptions(groupID, $.csCore
				.getDicts(DICT_CATEGORY_MEMBER_GROUP), "ID", "name", $.csCore
				.getValue("Common_PleaseSelect", "Member_Group"));
//		$.csControl.fillOptions(groupID, $.csCore.getDicts(DICT_CATEGORY_MEMBER_GROUP), "ID", "name", "");
	}
};
