jQuery.csOrdenStatistic={
	bindLabel:function (){
//		$.csCore.getValue("Orden_Statistic",null,"#orden_statistic_form h1");
//		$.csCore.getValue("Button_Statistic",null,"#btnStatistic");
//		$.csCore.getValue("Button_Export",null,"#btnExportStatistic");
		$.csDate.datePicker("fromStatisticDate",$.csDate.getLastYear());
		$.csDate.datePicker("toStatisticDate");
	},
	bindEvent:function (){
		$("#btnStatistic").click($.csOrdenStatistic.ordenStatistic);
		$("#btnExportStatistic").click($.csOrdenStatistic.exportStatistic);
	},
	fillMoneySign:function (){
	    $.csControl.fillOptions('moneySignID',$.csCore.getDicts(DICT_CATEGORY_MONEYSIGN), "ID" , "name", $.csCore.getValue("Common_All"));
	    $("#moneySignID").change($.csOrdenStatistic.fillSubMembers);
	},
	fillStatus:function (){
	    $.csControl.fillOptions('ordenStatusID',$.csCore.getDicts(DICT_CATEGORY_ORDEN_STATUS) , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	ordenStatistic:function(){
		var orden = $.csCore.invoke($.csCore.buildServicePath("/service/orden/getordenstatistic"),$.csOrdenStatistic.buildSearchParam());
		var domGrid = "<table class='list_result' style='width:80%;margin:auto;'>";
		domGrid += "<tr class='header'><td>"+$.csCore.getValue("Orden_ClothingCategory")+"</td><td>"+$.csCore.getValue("Common_Amount")+"</td><td>"+$.csCore.getValue("Cash_Num")+"</td></tr>";
		$.each(orden,function(i,item){
			var name = $.csCore.getValue("Dict_" + item[0]);
			domGrid += "<tr><td>"+name+"</td><td>"+item[1]+"</td><td>"+item[2]+"</td></tr>";
		});
		domGrid+="</table>";
		$('#statistic_grid').html(domGrid);
		
		var categories=new Array();
		var data = new Array();
		$.each(orden,function(i,item){
			categories[i] = $.csCore.getValue("Dict_" + item[0]);
			data[i] = item[1];
		});

		var chart = new Highcharts.Chart({
			lang:{
				printButtonTitle:$.csCore.getValue("Button_PrintTitle"),
				exportButtonTitle:$.csCore.getValue("Button_ExportTitle"),
				downloadPNG:$.csCore.getValue("Button_DownloadPNG"),
				downloadJPEG:$.csCore.getValue("Button_DownloadJPEG"),
				downloadPDF:$.csCore.getValue("Button_DownloadPDF"),
				downloadSVG:$.csCore.getValue("Button_DownloadSVG"),
			},
			chart: {
				renderTo: 'statistic_chart',
				defaultSeriesType: 'column',
				margin: [ 50, 50, 100, 80]
			},
			title: {
				text: $.csCore.getValue('Common_Statistic')
			},
			xAxis: {
				categories: categories,
				labels: {
					rotation: -45
				}
			},
			yAxis: {
				min: 0,
				title: {
					text: $.csCore.getValue('Common_Amount')
				}
			},
			legend: {
				enabled: false
			},
			series: [{
				name: $.csCore.getValue('Common_Amount'),
				data: data,
				dataLabels: {
					enabled: true,
					rotation: -90,
					color: '#FFFFFF',
					align: 'right',
					x: -3,
					y: 10,
					formatter: function() {
						return this.y;
					}
				}
			}]
		});
	},
	fillSubMembers:function(){
		var url = $.csCore.buildServicePath('/service/member/getsubmembers');
		var param = $.csControl.appendKeyValue("","moneySignID",$("#moneySignID").val());
	    var members = $.csCore.invoke(url,param);
		$.csControl.fillOptions('memberID',members, "ID" , "username", $.csCore.getValue("Common_All"));
	},
	exportStatistic:function(){
		var url = $.csCore.buildServicePath("/service/orden/exportstatistic?formData=" + $.csOrdenStatistic.buildSearchParam());
		window.open(url);
	},
	buildSearchParam:function(){
		var param = $.csControl.appendKeyValue("","memberid",$('#memberID').val());
		param = $.csControl.appendKeyValue(param,"from",$("#fromStatisticDate").val());
		param = $.csControl.appendKeyValue(param,"to",$("#toStatisticDate").val());
		param = $.csControl.appendKeyValue(param,"moneySignid",$("#moneySignID").val());
		param = $.csControl.appendKeyValue(param,"ordenStatusID",$("#ordenStatusID").val());
		return param;
	},
	init:function(){
		$.csOrdenStatistic.bindLabel();
		$.csOrdenStatistic.bindEvent();
		$.csOrdenStatistic.fillMoneySign();
		$.csOrdenStatistic.fillSubMembers();
		$.csOrdenStatistic.ordenStatistic();
		$.csOrdenStatistic.fillStatus();
	}
};