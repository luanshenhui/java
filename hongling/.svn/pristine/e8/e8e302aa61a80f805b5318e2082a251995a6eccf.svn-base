jQuery.csBase={
	loadChangePassword:function(){
		$.csCore.loadModal("../common/changepassword.htm",400,240,function(){$.csChangePassword.init();});
	},
	loadMyOrden:function(){
		$.csCore.loadModal("../orden/list.htm",1010,525,function(){$.csOrdenList.init();});
	},
	loadBlDelivery:function(){
		$.csCore.loadModal("../bldelivery/BlDeliveryF.htm",1010,525,function(){$.csBlDeliveryFList.init();});
	},
	loadBlCash:function(){
		$.csCore.loadModal("../blcash/BlDealList.htm",1010,525,function(){$.csBlDealList.init("front",null,null);});
	},
	loadMyFabric:function(){
		$.csCore.loadModal("../fabric/list.htm",970,525,function(){$.csFabricList.init();});
	},
	loadMyUser:function(){
		$.csCore.loadModal("../member/list.htm",970,525,function(){$.csMemberList.init();});
	},
	loadMyInformation:function(){
		$.csCore.loadModal("../information/list.htm",970,490,function(){$.csInformationList.init();});
	},
	loadVersions:function(){
		$.csControl.fillOptions('versions',$.csCore.getVersions(), "ID" , "name", "");
        var currentVersion = $.csCore.getCurrentVersion();
        $.csControl.initSingleCheck(currentVersion);
        $("#versions").change(function(){$.csCore.changeVersion($("#versions").val());});
	},
	loadMyMessage:function(){
		$("#newmessage").html("").hide();
		if($.csCore.isAdmin() == true){
			$.csCore.loadPage("desktop_content","../message/list.htm",function(){$.csMessageList.init();});
		}else{
			$.csCore.loadModal("../message/list.htm",970,525,function(){$.csMessageList.init();});
		}
	},
	loadCoder:function(){
		$.csCore.loadModal("../coder/list.htm",780,430,function(){$.csCoderList.init();});
	},
	checkNewMessage:function(){
		var hidden= $("#newmessage").is(":hidden");
		if(hidden){
			var total = JSON.parse($.csCore.invoke($.csCore.buildServicePath("/service/message/getnewmessagecount")));
			if(total > 0){
				$("#newmessage").show();
				$.csCore.getValue("Message_HaveNewMessage",null,"#newmessage");
				$("#newmessage").unbind("click");
				$("#newmessage").click($.csBase.loadMyMessage);
			}
		}
	},
	loadCurrentMember:function() {
		var currentMember = $.csCore.getCurrentMember();
		$("#hello").html(currentMember.name + "," + $.csCore.getValue("Common_SystemWelcome")).attr("title",$.csCore.getValue("Common_WelcomeToPlatform"));
	},
	getTotalCash:function(memberID) {
		return $.csCore.invoke($.csCore.buildServicePath("/service/cash/gettotal?memberid="+memberID),$.csControl.appendKeyValue('','memberid',memberID));
	},
	init:function(page){
		var systemName = $.csCore.getValue("Common_SystemName");
		$("#system_name").html(systemName);
		$.csCore.setPageTitle(page, systemName);
		//setInterval($.csBase.checkNewMessage,10000);
		$.csBase.loadCurrentMember();
		$.csCore.getValue("Label_Fashion",null,"#fashion_edition");
		if($("#myorden").length>0){
			$.csCore.getValue("Button_MyOrder",null,"#myorden");
			$("#myorden").bind("click",$.csBase.loadMyOrden);
		}
		if($("#myfabric").length>0){
			$.csCore.getValue("Button_FabricSearch",null,"#myfabric");
			$("#myfabric").click($.csBase.loadMyFabric);
		}
		if($("#blDelivery").length>0){
			$.csCore.getValue("Dict_10309",null,"#blDelivery");
			$("#blDelivery").bind("click",$.csBase.loadBlDelivery);
		}
		if($("#blCash").length>0){
			$.csCore.getValue("Dict_10305",null,"#blCash");
			$("#blCash").bind("click",$.csBase.loadBlCash);
		}
		if($("#mymessage").length>0){
			var url = $.csCore.buildServicePath('/service/message/getnewmessagecount');
			var retValue = $.csCore.invoke(url);
			$.csCore.getValue("Dict_10308",null,"#mymessage");
			$("#mymessage").click($.csBase.loadMyMessage);
		}
		if($("#myuser").length>0){
			$.csCore.getValue("Button_User",null,"#myuser");
			$("#myuser").click($.csBase.loadMyUser);
		}
		if($("#myinformation").length>0){
			$.csCore.getValue("Button_MyInformation",null,"#myinformation");
			$("#myinformation").bind("click",$.csBase.loadMyInformation);
		}
		if($("#coder").length>0){
			$.csCore.getValue("Button_Coder",null,"#coder");
			$("#coder").bind("click",$.csBase.loadCoder);
		}

		$.csCore.getValue("Button_Exit",null,"#signOut");
		$("#signOut").bind("click", $.csCore.signOut);
		
		$.csBase.loadVersions();
		$.csCore.getValue("Common_Copyright",null,"#footer");
	}
};