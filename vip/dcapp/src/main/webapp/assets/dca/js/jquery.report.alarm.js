/* 告警统计报表 */
+(function ($) {
	function ReportAlarm(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }
	
	function _buildEvent() {
        var $this = this;
        //年份选择监听
        this.$element.on('change', '#yearSelect', function () {
        	selectData(); 
        }); 
        
        //操作人选择监听
        this.$element.on('change', '#operSelect', function () {
        	selectData(); 
        });  
        
        //所属部门选择监听
        this.$element.on('change', '#officeSelect', function () {
        	selectData(); 
        });  
        
        getStatData();
	}
	//获取统计数据
	function getStatData(year,oper,office){
		var params = {};
		if(!year){
			var nowDate = new Date();
			//获取当前年
			year = nowDate.getFullYear();
		}
		params.year = year;
		if(oper){
			params.bizOperPerson = oper;
		}
		if(office){
			params.bizOperPost = office;
		}
		$.get(ctx+'/dca/dcaAlarmStatistics/findAlarmStatData', params, function (result) {
			if (!result) {
	                alertx('获取数据失败');
			}else {
				var data = JSON.parse(result);
				//年度数据
				showYearList(data.yearList,year);
				
				//操作人数据
				showOperList(data.operList,oper);
				
				//部门数据
				showOfficeList(data.officeList,office);
				
				//绘制表格
				drawTable(data.alarmList);
			}
		});
	}

	//显示年份数据
	function showYearList(yearList,selectYear){
		if(!selectYear){
			var nowDate = new Date();
			//获取当前年
			selectYear = nowDate.getFullYear();
		}
		var yearHtml = '<option value="-999"> </option>';
		for(var i = 0,len = yearList.length;i < len;i++){
			var year = yearList[i];
			yearHtml += '<option value="' + year + '">' + year + '</option>';
		}
		$("#yearSelect").html(yearHtml);
		$("#yearSelect").select2("val", selectYear);
	}

	//显示操作人数据
	function showOperList(operList,selectOper){
		var operHtml = '<option value="-999"> </option>';
		for(var i = 0,len = operList.length;i < len;i++){
			var oper = operList[i];
			if(oper && oper.name){// 判断操作人名称是否存在
				operHtml += '<option value="' + oper.id + '">' + oper.name + '</option>';
			}
		}
		$("#operSelect").html(operHtml);
		if(selectOper){
			$("#operSelect").select2("val", selectOper);
		} else {
			$("#operSelect").select2("val", -999);
		}
	}

	//显示所属部门数据
	function showOfficeList(officeList,selectOffice){
		var officeHtml = '<option value="-999"> </option>';
		for(var i = 0,len = officeList.length;i < len;i++){
			var office = officeList[i];
			if(office && office.name){// 判断部门名称是否存在
				officeHtml += '<option value="' + office.id + '">' + office.name + '</option>';
			}
		}
		$("#officeSelect").html(officeHtml);
		if(selectOffice){
			$("#officeSelect").select2("val", selectOffice);
		} else {
			$("#officeSelect").select2("val", -999);
		}
	}

	//格式化,一位数补0
	function formatAddZero(value){
		return value < 10 ? '0' + value: value;
	}
	//绘制表格
	function drawTable(data){
		//总合计变量
		var sumYellow = 0;
		var sumOrange = 0;
		var sumRed = 0;
		var sumTotal = 0;
		if(data && data.length > 0){
			var tableHtml = '';
			var lastflowName = '';
			
			//小计变量
			var yellowTempTotal = 0;
			var orangeTempTotal = 0;
			var redTempTotal = 0;
			var totalTempTotal = 0;
			
			var flowMap = {};//用于计算合并单元格个数
			for(var i = 0,len = data.length;i<len;i++){
				var flowName = data[i].bizFlowName;
				if(flowMap[flowName]){
					flowMap[flowName]++;
				} else {
					flowMap[flowName] = 1;
				}
			}

			//序号自增长index
			var addNo = 0;
			for(var i = 0,len = data.length;i<len;i++){
				var item = data[i];
				var flowName = '';
				var isNewFlow = false;
				if(item.bizFlowName != lastflowName){
					//下一个业务事项
					flowName = item.bizFlowName;
					isNewFlow = true;
					if(lastflowName){
						//不是第一行,需要计算合计
						tableHtml = tableHtml + '<tr><td>合 计</td><td>' 
									+ yellowTempTotal + '</td><td>' 
									+ orangeTempTotal + '</td><td>' 
									+ redTempTotal + '</td><td>' 
									+ totalTempTotal + '</td><td></td></tr>';
						//小计清0
						yellowTempTotal = 0;
						orangeTempTotal = 0;
						redTempTotal = 0;
						totalTempTotal = 0;
					}
				}
				
				lastflowName = item.bizFlowName;
				
				//小计
				yellowTempTotal += item.yellowCount;
				orangeTempTotal += item.orangeCount;
				redTempTotal += item.redCount;
				totalTempTotal += item.totalCount;
				
				//总计
				sumYellow += item.yellowCount;
				sumOrange += item.orangeCount;
				sumRed += item.redCount;
				sumTotal += item.totalCount;
				
				if(isNewFlow){
					//新业务事项,设置合并单元格
					tableHtml = tableHtml 
					+ '<tr><td rowspan="'+ (flowMap[flowName]+1) + '" style="vertical-align:middle;">'
					+ (++addNo) + '</td><td rowspan="' + (flowMap[flowName]+1) + '" style="vertical-align:middle;">' 
					+ flowName + '</td><td>' 
					+ item.bizDataName + '</td><td>' 
					+ item.yellowCount + '</td><td>' 
					+ item.orangeCount + '</td><td>' 
					+ item.redCount + '</td><td>' 
					+ item.totalCount + '</td><td></td></tr>';
				} else {
					tableHtml = tableHtml + '<tr><td>' 
					+ item.bizDataName + '</td><td>' 
					+ item.yellowCount + '</td><td>' 
					+ item.orangeCount + '</td><td>' 
					+ item.redCount + '</td><td>' 
					+ item.totalCount + '</td><td></td></tr>';
				}
				
			}
			
			//最后一个业务事项,计算合计
			tableHtml = tableHtml + '<tr><td>合 计</td><td>' 
						+ yellowTempTotal + '</td><td>' 
						+ orangeTempTotal + '</td><td>' 
						+ redTempTotal + '</td><td>' 
						+ totalTempTotal + '</td><td></td></tr>';
		}
		//总合计
		tableHtml = tableHtml + '<tr><td colspan="3">总  合 计</td><td>' 
					+ sumYellow + '</td><td>' 
					+ sumOrange + '</td><td>' 
					+ sumRed + '</td><td>' 
					+ sumTotal + '</td><td></td></tr>';
					
		$("#totalTable").html(tableHtml);
		
		var nowDate = new Date();
		//获取当前年
		var year = nowDate.getFullYear();
		//获取当前月
		var month = nowDate.getMonth()+1;
		//获取当前日
		var date = nowDate.getDate(); 
		var createDate = year + '年' + formatAddZero(month) + '月' + formatAddZero(date) + '日';
		$("#createDate").text(createDate);
		$("#createYear").text(year);
	}
	//选择事件
	function selectData(obj){
		getStatData($("#yearSelect").val(),$("#operSelect").val(),$("#officeSelect").val());
	}
	
	function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1)
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.ReportAlarm')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.ReportAlarm', (data = new ReportAlarm(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.reportAlarm;

    $.fn.reportAlarm = Plugin;
    $.fn.reportAlarm.Constructor = ReportAlarm;
    
    $.fn.reportAlarm.noConflict = function () {
        $.fn.reportAlarm = old;
        return this;
    }
})(jQuery);

$(function () {
    $('#reportAlarm').reportAlarm({
    })
})