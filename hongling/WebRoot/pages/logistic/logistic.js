$(document).ready(function (){
//	var id='XXXX13120587';
//	var id='XXXX13120586';
//	var id='XXXX13120585';
//	var id='XXXX13120584';
	var id= window.location.search.split("?")[1];
	jQuery.csLogistic.init(id);
});
$.csLogistic = {
	getLogistic : function(ordenNo) {
		var param = $.csControl.appendKeyValue('','id',ordenNo);
	    var data = $.csCore.invoke($.csCore.buildServicePath("/service/logistic/getordenlogisticbyid"),param);
	    $("#kdgs").text(data.logisticCompany);
		$("#ordenNo").text(ordenNo);
		$("#ydh").text(data.logisticNo);
	    
	    var param = $.csControl.appendKeyValue('','id',data.logisticNo);
	    param = $.csControl.appendKeyValue(param,'company',data.logisticCompany);
	    var result = $.csCore.invoke($.csCore.buildServicePath("/service/logistic/getinfobylogisticno"),param);
		var html = "没有查询到数据，请稍候再试";
		if (result!="") {
			var html="";
			var data="";
			var i=0;
			if (result.logisticProviderID=="ND") {
				$.each(result.orders.order.steps, function(n, value) {
					  html+="<li id=\"li_"+n+"\" class=\"liebiao2\"><div id=\"div_"+n+"\" class=\"wuliu_liebiaox fr\">"+value.acceptAddress+"  <b class=\"wuliu_biaoti\">"+value.name+"</b>  "+value.remark+"</div>"+value.acceptTime+"</li>";
				});
				i=result.orders.order.steps.length;
				data=result.orders.order.steps[i-1].remark;
			}else if(result.service=="RouteService"){
				$.each(result.Body.RouteResponse.Route, function(n, value) {
					  html+="<li id=\"li_"+n+"\" class=\"liebiao2\"><div id=\"div_"+n+"\" class=\"wuliu_liebiaox fr\">"+value.accept_address+"  "+value.remark+"</div>"+value.accept_time+"</li>";
				});
				i=result.Body.RouteResponse.Route.length;
				data=result.Body.RouteResponse.Route[i-1].remark;
			}else if(result.logisticProviderID=="YTO"){
				$.each(result.orders.order.steps, function(n, value) {
					  html+="<li id=\"li_"+n+"\" class=\"liebiao2\"><div id=\"div_"+n+"\" class=\"wuliu_liebiaox fr\">"+value.acceptAddress+"  <b class=\"wuliu_biaoti\">"+value.name+"</b>  "+value.remark+"</div>"+value.acceptTime+"</li>";
				});
				i=result.orders.order.steps.length;
				data=result.orders.order.steps[i-1].remark;
			}else{
				$.each(result.traces, function(n, value) {
					  html+="<li id=\"li_"+n+"\" class=\"liebiao2\"><div id=\"div_"+n+"\" class=\"wuliu_liebiaox fr\">"+value.acceptAddress+"  "+value.remark+"</div>"+value.acceptTime+"</li>";
				});
				i=result.traces.length;
				data=result.traces[i-1].remark;
			}
			
			$("#info").html(html);
			$("#li_0").attr("class","liebiao1");
			if (data.indexOf("已签收")>=0||data.indexOf("妥投")>=0) {
				$("#li_"+(i-1)).attr("class","liebiao4");
			}else{
				$("#li_"+(i-1)).attr("class","liebiao3");
			}
			$("#div_"+(i-1)).attr("class","wuliu_liebiaox last");
		}
	},
	init : function(ordenNo) {
		$.csLogistic.getLogistic(ordenNo);
	}
}