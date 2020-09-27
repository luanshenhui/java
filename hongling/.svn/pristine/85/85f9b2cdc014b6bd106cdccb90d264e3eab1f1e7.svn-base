jQuery.csBackend={
	loadMenu:function (){
		var menus = $.csCore.getDicts(DICT_CATEGORY_BACKEND_MENU);
		var dom = "";
		$.each(menus,function(i,menu){
			if ($.csCore.isInRole(menu.ID)==true) {
				dom += "<div><div class='accordion' onclick=$.csCore.loadPage('desktop_content','"+menu.extension+"',"+menu.memo+")>"+menu.name+"</div></div>";
	        }
		});

		$('#menu').html(dom);
	}
};

$(document).ready(function(){
	$.csBase.init(this);
	$.csCore.getValue("Button_Exit",null,"#signOut");
	$("#signOut").bind("click", $.csCore.signOut);
	$.csBackend.loadMenu();
	$.csCore.getValue("Button_ChangePassword",null,"#changePassword");
	$("#changePassword").bind("click",$.csBase.loadChangePassword);
});