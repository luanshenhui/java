jQuery.csCashList={
    moduler : "Cash",
	bindEvent:function (){
//		$.csDate.datePicker("fromDate", $.csDate.getLastYear());
//		$.csDate.datePicker("toDate");
		$.csDate.datePickerNull("fromDate");
		$.csDate.datePickerNull("toDate");
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
		$("#btnSearch").click(function(){$.csCashList.list(0);});
		$("#btnSaveCash").click($.csCashList.saveCash);
		$("#btnCancel").click($.csCore.close);
		$("#btnExportCash").click($.csCashList.exportCash);
		$("#blBtnExcelImport").click($.csCashList.excelUpload);
		$("#btnDealItemList").click($.csCashList.openBlDealItemList);
	},
	/**
	 * 充值
	 * @param cashid
	 * @param memberid
	 * @param flag
	 */
	openBlAddNum:function(cashid, memberid, flag){
		$.csCore.loadModal('../blcash/BlAddNum.htm',350,100,function(){$.csBlAddNum.init(cashid,memberid,flag);});
	},
	/**
	 * 打开交易项目
	 */
	openBlDealItemList:function(){
		$.csCore.loadModal('../blcash/BlDealItemList.htm',800,500,function(){$.csBlDealItemList.init();});
	},
	/**
	 * 打开编辑
	 * @param id
	 */
	openPost:function (id){
		$.csCore.loadModal('../cash/post.htm',500,300,function(){$.csCashPost.init(id);});
	},
	excelUpload:function(){
		$.csCore.loadModal($.csCashList.getPath()+'/pages/style_assemble/importTrafficDeal.jsp',500,300,
				function(){
					$.csCashList.initExcelUpload();
			});
	},
	/**
	 * 打开账款详单
	 * @param blcashid
	 * @param blmemberid
	 */
	openZhangkuanqiangdan:function (blcashid,blmemberid){
		$.csCore.loadModal('../blcash/BlDealList.htm',1000,520,function(){$.csBlDealList.init("hou",blcashid,blmemberid);});
	},
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/cash/getcashs');
		var param =  $.csControl.getFormData("CashSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		var datas = $.csCore.invoke(url,param);
	    //alert(JSON.stringify(datas));
		$.csCore.processList($.csCashList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csCashList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csCashList.list);
	    }
	    $.csCashCommon.bindLabel();
	},
	exportCash:function(){
		var url = $.csCore.buildServicePath('/service/cash/exportcash');
		var param = "?keyword="+$("#keyword").val()+"&fromDate="+$("#fromDate").val()+"&toDate="+$("#toDate").val();
		window.open(url+param);
	},
	init:function(){
		$.csCashCommon.bindLabel();
		$.csCashList.bindEvent();
		$.csCashList.list(0);
	},
	initExcelUpload : function() {
		$.csImportTrafficDealAssemble.bindLabel();
		$.csImportTrafficDealAssemble.bindEvent();
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
	}
};

jQuery.csCashCommon={
		bindLabel:function (){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_CASH_MANAGER),null,".list_search h1");
			$.csCore.getValue("Member_Username",null,".lblCompanyShortName,.lblUsername");
			$.csCore.getValue("Member_CompanyName",null,".lblCompanyName");
			$.csCore.getValue("Cash_SalesName",null,".lblName");
			$.csCore.getValue("Cash_Memo",null,".lblMemo");
			$.csCore.getValue("Cash_RemainMoney",null,".lblNum");
			$.csCore.getValue("Cash_NoticeNum",null,".lblNoticeNum");
			$.csCore.getValue("Cash_StopNum",null,".lblStopNum");
			$.csCore.getValue("Cash_LoanMonth",null,".lblLoanMonth");
			$.csCore.getValue("Cash_IsReconciliation",null,".lblIsReconciliation");
			$.csCore.getValue("Cash_LastDealDate",null,".lblPubDate");
			$.csCore.getValue("Button_Edit",null,".lblEdit,.edit");
			$.csCore.getValue("Common_Keyword",null,".lblKeyword");
			$.csCore.getValue("Cash_AddNum",null,".blLblAddNum,.addNum");
			$.csCore.getValue("Cash_MemberName",null,".lblMemberName");
			$.csCore.getValue("Cash_DealDetail",null,".blLblZhangkuanxiangdan,.zhangkuanxiangdan");
			
			$.csCore.getValue("Cash_AddNum",null,"#blAddNum");
			$.csCore.getValue("Cash_DealProject",null,"#btnDealItemList");
			$.csCore.getValue("blBtnExcelImport",null,"#blBtnExcelImport");
			$.csCore.getValue("Button_Search",null,"#btnSearch");
			$.csCore.getValue("Button_Remove",null,"#btnRemoveCash");
			$.csCore.getValue("Button_Add",null,"#btnCreateCash");
			$.csCore.getValue("Button_Submit",null,"#btnSaveCash");
			$.csCore.getValue("Button_Cancel",null,"#btnCancelCash");
			$.csCore.getValue("Button_Export",null,"#btnExportCash");
			
			// 财务账户----只有“充值功能”
			var currentMemeberGroupID = $.csCore.getCurrentMember().groupID;
			if (currentMemeberGroupID!=null && currentMemeberGroupID==GROUPID_CAIWU){
				$("#btnExportCash").hide();
				$("#btnDealItemList").hide();
//				$(".blLblZhangkuanxiangdan").hide();
//				$(".zhangkuanxiangdan").parent().hide();
//				$(".lblEdit").hide();
//				$(".edit").parent().hide();
			}
			// 非财务账户----没有“充值功能”
			if (currentMemeberGroupID!=null && currentMemeberGroupID!=GROUPID_CAIWU){
				$(".blLblAddNum").hide();
				$(".addNum").parent().hide();
//				$(".blLblZhangkuanxiangdan").hide();
//				$(".zhangkuanxiangdan").parent().hide();
				$(".lblEdit").hide();
				$(".edit").parent().hide();
			}
		},
		getCashByID:function(id){
			var url = $.csCore.buildServicePath('/service/cash/getcashbyid');
			var param = $.csControl.appendKeyValue("","id",id);
			return $.csCore.invoke(url,param);
		},
		
	};