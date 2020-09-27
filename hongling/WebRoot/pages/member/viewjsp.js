jQuery.csMemberView={
	view:function (id){
		var member = $.csCore.getMemberByID(id);
		//当前用户是虚拟支付且其父级不为管理用户 隐藏CMT价格
		/*var currentMember = $.csCore.getCurrentMember();
		var payType = currentMember.payTypeID;
		var parentMember = $.csCore.getMemberByID(currentMember.parentID);
		var parentGroupID = parentMember.groupID;
		if(payType==10271 && (parentGroupID==10015 || parentGroupID==10016 || parentGroupID==10017 || parentGroupID==10018)){
			$(".lblCmtPrice").hide();
			$("#_view_cmtPriceName").hide();
		}*/
		
		var cash = $.csCore.getCashByMemberByID(id);
		$.csCore.viewWithJSON('view_member',member);
		if(cash != null){
			$("#_view_noticeNum").html(cash.noticeNum);
			$("#_view_stopNum").html(cash.stopNum);
		}
		$("#_view_total").html($.csBase.getTotalCash(id));
	},
	init:function(id){
		$.csMemberCommon.bindLabel();
		$.csMemberView.view(id);
		$.csCore.addValueLine('view_member');
		var currentMember = $.csCore.getCurrentMember();
		var groupID = currentMember.groupID;
		if (groupID==10015 || groupID==10016 || groupID==10017 || groupID==10018){
			$(".lblNoticeNum").hide();
			$("#_view_noticeNum").hide();
		}
//		//当前用户是虚拟支付且其父级不为管理用户 隐藏CMT价格
//		var payType = currentMember.payTypeID;
//		var parentMember = $.csCore.getMemberByID(currentMember.parentID);
//		var parentGroupID = parentMember.groupID;
//		if(payType==10271 && (parentGroupID==10015 || parentGroupID==10016 || parentGroupID==10017 || parentGroupID==10018)){
//			$(".lblCmtPrice").hide();
//			$("#_view_cmtPriceName").hide();
//		}
	}
};