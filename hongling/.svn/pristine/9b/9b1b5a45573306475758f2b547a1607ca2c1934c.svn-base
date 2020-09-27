var dictText = "[";
jQuery.csDictList={
	dictToResource:function(){
		$.csCore.invoke($.csCore.buildServicePath('/service/dict/dicttoresource'));
		alert("Export Success");
	},
	submitMenius : function(){
		var membergroup = $("#membergroup").val(),dictmenius = $("#dictmenius").val();
		if(!!dictmenius&&!!membergroup)
		{
			var param = $.csControl.appendKeyValue("","membergroup",membergroup);
			param = $.csControl.appendKeyValue(param,"dictmenius",dictmenius);
			param = $.csControl.appendKeyValue(param,"type","add");
		    var dates = $.csCore.invoke($.csCore.buildServicePath('/service/member/saveallmembermenu'),param);
		    if(dates == "OK"){
		    	$.csCore.alert("添加成功");
		    }else{
		    	$.csCore.alert("添加失败");
		    }
		}else{
			$.csCore.alert("信息不全！");
		}
		
	},
	deleteMenius : function(){
		var membergroup = $("#membergroup").val(),dictmenius = $("#dictmenius").val();
		if(!!dictmenius&&!!membergroup)
		{
			var param = $.csControl.appendKeyValue("","membergroup",membergroup);
			param = $.csControl.appendKeyValue(param,"dictmenius",dictmenius);
			param = $.csControl.appendKeyValue(param,"type","del");
		    var dates = $.csCore.invoke($.csCore.buildServicePath('/service/member/saveallmembermenu'),param);
		    if(dates == "OK"){
		    	alert("删除成功");
		    }else{
		    	alert("删除失败");
		    }
		}else{
			$.csCore.alert("信息不全！");
		}
	},
	checkMenius : function(){
		var username = $("#username").val();
		var checkMeniusID = $("#checkMeniusID").val();
		if(!!username&&!!checkMeniusID){
			var param = $.csControl.appendKeyValue("","username",username);
			param = $.csControl.appendKeyValue(param,"checkMeniusID",checkMeniusID);
			param = $.csControl.appendKeyValue(param,"type","check");
		    var dates = $.csCore.invoke($.csCore.buildServicePath('/service/member/saveallmembermenu'),param);
		    if(dates == "OK"){
		    	alert("不存在此工艺");
		    }else{
		    	alert(JSON.stringify(dates));
		    }
		}else{
			$.csCore.alert("信息不全！");
		}
	},
	checkDict : function(){
	    $("#type").val("check");
			$.ajax({
	            cache: true,
	            type: "POST",
	            url:$.csCore.buildServicePath('/service/dict/editDict'),
	            data:$('#myDictForm').serialize(),
	            async: false,
	            error: function(request) {
	                alert("Connection error");
	            },
	            success: function(data) {
	        	    if(data == "\"OK\""){
	        	    	alert("数据库无此工艺");
	        	    }else{
	        	    	alert(JSON.stringify(data));
	        	    }
	            }
	        });
	},
	editMenius : function(){
	    $("#type").val("del");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                alert(data);
            }
        });
	},
	clip : function() {
		var clipText = window.clipboardData.getData('Text');
		clipRows = clipText.split(String.fromCharCode(13));
		for (var i=0; i<clipRows.length; i++) {
			clipRows[i] = clipRows[i].split(String.fromCharCode(9));
		}
		newTable = document.createElement("table");
		newTable.border = 1;
		var dictDiv="";
		for (var i=0; i<clipRows.length - 1; i++) {
			newRow = newTable.insertRow();
			dictDiv = "{";
			for (var j=0; j<clipRows[i].length; j++) {
				newCell = newRow.insertCell();
				var text = "";
				if (clipRows[i][j].length == 0) {
					newCell.innerText = '';
					text = '';
				}else {
					newCell.innerText = clipRows[i][j];
					text = clipRows[i][j];
				}
				dictDiv += "\""+j+"\":\""+text+"\",";
				if(j == clipRows[i].length-1){
					dictDiv = dictDiv.substring(0,dictDiv.length-1)+"},";
				}
			}
			dictText += dictDiv;
		}
		document.body.appendChild(newTable);
		$("#divDict").append(newTable);
	},
	submitDict : function(){
		var textJsion = dictText.substring(0,dictText.length-1)+"]";
		$("#myDict").val(textJsion.replace(/[\n]/ig,''));
		$("#type").val("add");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                alert(data);
            }
        });
	},
	checkStyle : function(){
		$("#type").val("checkStyle");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
            	if(data == "\"OK\""){
        	    	alert("数据库无此款式信息");
            	}else{
            		alert(data);
            	}
            }
        });
	},
	styleDel : function(){
		$("#type").val("styleDel");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                alert(data);
            }
        });	
	},
	styleAdd : function(){
		$("#type").val("styleAdd");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                alert(data);
            }
        });		
	},
	exportFabirc : function(){
		$("#type").val("exportFabirc");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                alert(data);
            }
        });		
	},
	exportFabircPrice : function(){
		$("#type").val("exportFabircPrice");
		$.ajax({
            cache: true,
            type: "POST",
            url:$.csCore.buildServicePath('/service/dict/editDict'),
            data:$('#myDictForm').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                alert(data);
            }
        });		
	},
	init:function(){
	},
	/*  这是MixSelectedService的区域    */
	submitMixSelected : function(){
		var membername = $("#membername").val(),mixcodes = $("#mixcodes").val();
		if(!!dictmenius&&!!membergroup)
		{
			var param = $.csControl.appendKeyValue("","membername",membername);
			param = $.csControl.appendKeyValue(param,"mixcodes",mixcodes);
			param = $.csControl.appendKeyValue(param,"type","add");
		    var dates = $.csCore.invoke($.csCore.buildServicePath('/service/member/mixselectedservice'),param);
		    if(dates == "OK"){
		    	$.csCore.alert("添加成功");
		    }else{
		    	$.csCore.alert("失败："+dates);
		    }
		}else{
			$.csCore.alert("信息不全！");
		}
	},
	deleteMixSelected : function(){
		var memberid = $("#membername").val(),mixcodes = $("#mixcodes").val();
		if(!!dictmenius&&!!membergroup)
		{
			var param = $.csControl.appendKeyValue("","membername",memberid);
			param = $.csControl.appendKeyValue(param,"mixcodes",mixcodes);
			param = $.csControl.appendKeyValue(param,"type","delete");
		    var dates = $.csCore.invoke($.csCore.buildServicePath('/service/member/mixselectedservice'),param);
		    if(dates == "OK"){
		    	$.csCore.alert("删除成功");
		    }else{
		    	$.csCore.alert("失败："+dates);
		    }
		}else{
			$.csCore.alert("信息不全！");
		}
	},
	getAllMixcodes :function(){
		var val=$.csCore.invoke($.csCore.buildServicePath('/service/member/mixservice'),null);
		$("#mixcodes").val(val);
	}
};

$(document).ready(function (){
	$("#btnExport").click($.csDictList.dictToResource);
});