jQuery.csOrden_Page = {
	bindLabel: function() {},
	bindEvent: function() {},
	loadVersions:function(){
		$.csControl.fillOptions('versions',$.csCore.getVersions(), "ID" , "name", "");
        var currentVersion = $.csCore.getCurrentVersion();
        $.csControl.initSingleCheck(currentVersion);
        $("#versions").change(function(){$.csCore.changeVersion($("#versions").val());});
        $("#signOut").bind("click", $.csCore.signOut);
	},
	loadPage:function(url, fun){
		$.csCore.loadPage("page_url",url,fun);
	},
	init : function(){
		$.csOrden_Page.loadVersions();
		$.csCore.loadPage("page_url","../orden/list.jsp",function(){$.csOrdenList.init();});
	}
};
$(function() {
	$.csOrden_Page.init();
});