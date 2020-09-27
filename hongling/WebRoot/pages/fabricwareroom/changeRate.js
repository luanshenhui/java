jQuery.csFabricWareroomChange={
		
		change:function(){
			var us=$("#usrate").val();
			var cn=$("#cnrate").val();
			var zh=/^(?:0\.\d+|[01](?:\.0)?)$/;
			if(zh.test(us)){
				$("#info").html("");
				$("#exchange").val(us);
				$("#uachange").val(cn);
				us=us+","+cn;
				var data=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/changeRateFabricWareroom'),us);
				if(data=='OK'){
					$.csFabricWareroomList.list(0);
					$.csCore.close();
				}	
					
			}
			else
			{
				$("#info").html("请输入小于或者等于1的小数");
			}
		}
		,
		bindEvent:function(){
			$("#btnSave").click(function(){$.csFabricWareroomChange.change();});
		}
		,
		init:function(us,cn){
			$("#usrate").val(us);
			$("#cnrate").val(cn);
			$.csFabricWareroomChange.bindEvent();
			
		}
};