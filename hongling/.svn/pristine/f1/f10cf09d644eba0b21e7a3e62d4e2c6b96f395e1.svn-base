jQuery.csMemberList={
	moduler : "Member",
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('searchKeywords','btnSearch');
		$("#btnSearch").click(function(){$.csMemberList.list(0);});
		$("#btnRemoveMember").click($.csMemberList.remove);
		$("#btnCreateMember").click(function(){$.csMemberList.openPost(null);});
		$("#btnExportMember").click($.csMemberList.exportMembers);
		$.csCore.autoCompleteUsername("searchParent",false);
//		$.csCore.getValue("Button_ChangePassword","#MemberSearch #changePassword");
		$("#MemberSearch #changePassword").bind("click",$.csBase.loadChangePassword);
		$("#changePasswordTwo").click($.csMemberList.changePassword);
		$("#changeMemberRegisterTime").click($.csMemberList.changeMemberRegisterTime);
		
	},
	checkAccess:function(){
		if($.csCore.isAdmin() == false){
			$(".lblParentUsername,#searchParent,#btnCreateMember,#btnRemoveMember,.lblEdit,.lblDiscount,.lblMenus,.list_result .check").hide();
			$(".edit").parent().hide();
			$(".edit").parent().next().hide();
			$(".menus").parent().hide();
		}else{
			$("#MemberSearch #changePassword").hide();
		}
	},
	// js获取项目根路径，如： http://localhost:8080/hongling
	getPath : function getRootPath() {
		// 获取当前网址，如：  http://localhost:8080/hongling/orden/meun.jsp
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址，如： http://localhost:8080
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/hongling
		var projectName = pathName.substring(0,
				pathName.substr(1).indexOf('/') + 1);
		return (localhostPaht + projectName);
	},
	blDiscountList:function(memberid){
		$.csCore.loadModal('../bldiscount/BlDiscountList.jsp',800,550,function(){$.csBlDiscountList.init(memberid,0);});
	},
	openPost:function (id){
		$.csCore.loadModal('../member/post.jsp',900,500,function(){$.csMemberPost.init(id);});
	},
	openMenus:function (id,name){
		$.csCore.loadModal('../member/menus.jsp',800,500,function(){$.csMemberMenus.init(id,name);});
	},
	openQorderMenus:function (id,name){
		$.csCore.loadModal('../member/menusqorder.jsp',800,500,function(){$.csMemberMenusQorder.init(id,name);});
	},
	openFabricMenus:function (id,name){
		$.csCore.loadModal('../member/fabricmenus.jsp',800,500,function(){$.csMemberFabricMenus.init(id,name);});
	},
	openView:function (id){
		$.csCore.loadModal($.csMemberList.getPath()+'/pages/member/view.jsp',800,500,function(){$.csMemberView.init(id);});
	},
	openDictPrice:function(id,name){
		$.csCore.loadModal('../member/dictPrice.jsp',800,500,function(){$.csDictPrice.init(id,name);});
	},
	openFabricConsume:function(name){
		$.csCore.loadModal('../member/fabricConsume.jsp',800,500,function(){$.csFabricConsume.init(name);});
	},
	remove:function (){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/member/removemembers');
		$.csCore.removeData(url,removedIDs);
	},
	list:function (pageIndex){
	    var url = $.csCore.buildServicePath('/service/member/getmembers');
	    var param = $.csControl.getFormData('MemberSearch');
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csMemberList.moduler, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csMemberList.moduler + "Pagination", data.count, PAGE_SIZE, $.csMemberList.list);
	    }
	    $.csMemberCommon.bindLabel();
	    $.csMemberList.checkAccess();
	},
	exportMembers:function(){
		var keywords = $('#searchKeywords').val();
		var url = $.csCore.buildServicePath('/service/member/exportmembers');
		url +="?keywords="+keywords;
		url +="&parent="+$('#searchParent').val();
		window.open(url);
	},
	changePassword:function(){
		$.csCore.loadModal($.csMemberList.getPath()+'/pages/common/changepassword.jsp',500,150,function(){$.csChangePassword.init();});
	},
	changeMemberRegisterTime:function(){
		var keywords = $('#searchKeywords').val();
		var url = $.csCore.buildServicePath('/service/member/changeRegistTime');
		url +="?keywords="+keywords;
		var data=$.csCore.invoke(url);
        if (data != null) {
        $.csCore.alert(data);
        }
	},
	init:function(){
		$("#searchParent").val($.csCore.getCurrentMember().username);
		$.csMemberCommon.fillStatus("searchStatusID");
        $.csMemberCommon.fillGroup("searchGroupID");
        
		$.csMemberList.list(0);
		$.csMemberList.bindEvent();
	}
};