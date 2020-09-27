jQuery.csMemberList={
	moduler : "Member",
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('searchKeywords','btnSearch');
		$("#btnSearch").click(function(){$.csMemberList.list(0);});
		$("#btnRemoveMember").click($.csMemberList.remove);
		$("#btnCreateMember").click(function(){$.csMemberList.openPost(null);});
		$("#btnExportMember").click($.csMemberList.exportMembers);
		$.csCore.autoCompleteUsername("searchParent",false);
		$.csCore.getValue("Button_ChangePassword","#MemberSearch #changePassword");
		$("#MemberSearch #changePassword").bind("click",$.csBase.loadChangePassword);
		$("#changePasswordTwo").click($.csMemberList.changePassword);
		
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
	blDiscountList:function(memberid){
		$.csCore.loadModal('../bldiscount/BlDiscountList.htm',800,500,function(){$.csBlDiscountList.init(memberid,0);});
	},
	openPost:function (id){
		$.csCore.loadModal('../member/post.htm',800,500,function(){$.csMemberPost.init(id);});
	},
	openMenus:function (id,name){
		$.csCore.loadModal('../member/menus.htm',800,500,function(){$.csMemberMenus.init(id,name);});
	},
	openView:function (id){
		$.csCore.loadModal('../member/view.htm',800,500,function(){$.csMemberView.init(id);});
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
		$.csCore.loadModal('../common/changepassword.htm',500,150,function(){$.csChangePassword.init();});
	},
	
	init:function(){
		$("#searchParent").val($.csCore.getCurrentMember().username);
		$.csMemberCommon.fillStatus("searchStatusID");
        $.csMemberCommon.fillGroup("searchGroupID");
        
		$.csMemberList.list(0);
		$.csMemberList.bindEvent();
	}
};