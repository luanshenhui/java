$(document).ready(function (){
//	var id='AAAA13090108';
//	var id='AAAA13090109';
//	var id='AAAA13090111';
	var id= window.window.location.search.split("?")[1];
	jQuery.csLogisticInfoView.init(id);
});
jQuery.csLogisticInfoView={
	bindLabel:function (){
	},
	bindEvent:function (){
	},
	list:function(id){
		var param = $.csControl.appendKeyValue('','id',id);
	    var data = $.csCore.invoke($.csCore.buildServicePath("/service/logistic/getordenlogisticbyid"),param);
	    $("#logisticCompany").html(data.logisticCompany);
	    if(data.logisticCompany == "EMS"){
	    	$("#mobile").html("11183");
	    }else if(data.logisticCompany == "圆通"){
	    	$("#mobile").html("021-69777888");
	    }else if(data.logisticCompany == "顺风"){
	    	$("#mobile").html("400-811-1111");
	    }else if(data.logisticCompany == "元智捷成"){
	    	$("#mobile").html("400-606-0909");
	    }else if(data.logisticCompany == "DHL"){
	    	$("#mobile").html("800-810-8000 ");
	    }
	    
	    $("#logisticNo").html(data.logisticNo);
//	    $("#logisticStatus").html(data.logisticStatus);
	    
	    var param = $.csControl.appendKeyValue('','id',data.logisticNo);
	    param = $.csControl.appendKeyValue(param,'company',data.logisticCompany);
	    var datas = $.csCore.invoke($.csCore.buildServicePath("/service/logistic/getinfobylogisticno"),param);
	    var info_htm="";
	    if(data.logisticCompany == "DHL"){
	    	$.each(datas,function(i,n){
		    	info_htm += "<tr><td>"+datas[i].number+"</td><td>"+datas[i].operateTime+"</td><td>"+datas[i].operateInfo+"</td></tr>";
		     });
	    }else{
	    	$.each(datas.traces,function(i,n){
		    	info_htm += "<tr><td>"+i+"</td><td>"+datas.traces[i].acceptTime+"</td><td>"+datas.traces[i].acceptAddress+","+datas.traces[i].remark+"</td></tr>";
		     });
	    }
	    if(data.logisticCompany == "圆通"){
	    	$("#logisticStatus").html(datas.status);
	    }

	    $("#logistic_info").html(info_htm);
	},
	init:function(id){
		$.csLogisticInfoView.bindLabel();
		$.csLogisticInfoView.bindEvent();
		$.csLogisticInfoView.list(id);
	}
};