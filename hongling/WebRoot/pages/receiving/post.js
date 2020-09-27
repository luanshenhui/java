jQuery.csReceivingPost = {
	bindLabel : function() {
		$.csCore.getValue("Button_Submit",null,"#btnSave");
		$.csCore.getValue("Button_Cancel",null,"#btnCancel");
		$.csCore.getValue("Orden_Code",null,".lblCode");
		$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
		$.csCore.getValue("Customer_Name",null,".lblName");
		$.csCore.getValue("Member_OwnedStore",null,".lblOwnedStore");
		$.csCore.getValue("Common_Tel",null,".lblTel");
		$.csCore.getValue("Common_Memo",null,".lblMemo");
	},
	bindEvent : function() {
		$("#btnSave").click($.csReceivingPost.save);
		$("#btnCancel").click($.csCore.close);
	},
	autoTemplate:function(){
		var url = $.csCore.buildServicePath('/service/receiving/getordenbykeyword');
		$("#ordenid").autocomplete(url, {
			selectFirst: true,
			multiple: false,
			dataType: "json",
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.ordenID,
						result: row.ordenID
					};
				});
			},
			formatItem: function(item) {
				return item.ordenID + "(" + item.sysCode + ")";
			}
		}).result(function(e, data) {
			$("#ownedStore").val(data.pubMemberName);
			$("#clothingCategory").val(data.clothingName);
			$("#name").val(data.customer.name);
			$("#tel").val(data.customer.tel);
			$("#sortID").val(data.clothingID);
		});
	},
	validate:function (){
		if($.csValidator.checkNull("ownedStore",$.csCore.getValue("Common_Required","Member_OwnedStore"))){
			return false;
		}
		if($.csValidator.checkNull("ordenid",$.csCore.getValue("Common_Required","Orden_Code"))){
			return false;
		}
		return true;
	},
	save : function() {
		if ($.csReceivingPost.validate()) {
			if($.csCore.postData($.csCore.buildServicePath("/service/receiving/savereceiving"), "form")){
				$.csReceivingList.list(0);
				$.csCore.close();
			}
		}
	},
	init : function() {
		$.csCore.getValue("Common_Add","RealmName_Moduler","#form h1");
		$.csReceivingPost.bindLabel();
		$.csReceivingPost.bindEvent();
		$.csReceivingPost.autoTemplate();
		
	}
};