/* 风险统计报表 */
+(function ($) {
	function ReportRisk(element, options) {
        this.$element = $(element)
        this.options = $.extend({}, {}, options);
        _buildEvent.call(this);
    }
	
	function _buildEvent() {
        var $this = this;
      
        //年份选择监听
        this.$element.on('change', '#selectYear', function () {
        	selectData(); 
        }); 
        
      //操作人选择监听
        this.$element.on('change', '#operator', function () {
        	selectData(); 
        });  
        //所属部门选择监听
        this.$element.on('change', '#bizOperPostId', function () {
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
		$.get(ctx+'/dca/dcaReportRiskCount/findReportRisk', params, function (result) {
			if (!result) {
	                alertx('获取数据失败');
			}else {
				var data = JSON.parse(result);

				//年度数据
				_showYearList(data.yearList,year);
				
				//操作人数据
				_showOperList(data.operator,data.operatorId);
			
				//部门数据
				_showDepartList(data.officeName,data.officeId);
				
				//绘制表格
				_drawTable(data.reportList);
			}
		});
	}
	
	//显示年份数据
	function _showYearList(yearList,selectYear){
		
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
		
		$("#selectYear").html(yearHtml);
		$("#selectYear").select2("val", selectYear);
	}

	//显示操作人数据
	function _showOperList(operator,operatorId){
		
		if(operator !=null){
			$("#operator").val(operator);
			$("#operatorHidden").val(operatorId);
		} else {
			$(".operatorBox").hide();
		}
		
	}

	//显示所属部门数据
	function _showDepartList(userOfficeName,officeId){
		
		if(userOfficeName !=null){
			$("bizOperPostId").val(officeId);
			$("#bizOperPostName").val(userOfficeName);
			$("#bizOperPostButton").addClass("disabled");
		} else {
			$("#bizOperPostName").val(null);
			
		}
	}

	//格式化,一位数补0
	function formatAddZero(value){
		return value < 10 ? '0' + value: value;
	}
	//绘制表格
	function _drawTable(data){
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
				var flowName = data[i].flowName;
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
				if(item.flowName != lastflowName){
					//下一个业务事项
					flowName = item.flowName;
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
				
				lastflowName = item.flowName;
				
				
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
					+ item.dataName + '</td><td>' 
					+ item.yellowCount + '</td><td>' 
					+ item.orangeCount + '</td><td>' 
					+ item.redCount + '</td><td>' 
					+ item.totalCount + '</td><td></td></tr>';
				} else {
					tableHtml = tableHtml + '<tr><td>' 
					+ item.dataName + '</td><td>' 
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
					
		$("#riskTable").html(tableHtml);
		
		var nowDate = new Date();
		//获取当前年
		var year = nowDate.getFullYear();
		//获取当前月
		var month = nowDate.getMonth()+1;
		//获取当前日
		var date = nowDate.getDate(); 
		//如果没有数据报表生成日期不显示
		if(data.length == 0){
			$("#createDate").text("----");
		}else{
			var createDate = year + '年' + formatAddZero(month) + '月' + formatAddZero(date) + '日';
			$("#createDate").text(createDate);
			$("#createYear").text(year);
		}
		
		
	}
	
	//选择事件
	function selectData(obj){
		getStatData($("#selectYear").val(),$("#operatorHidden").val(),$("#bizOperPostId").val());
	}
	
	function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1)
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.ReportRisk')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.ReportRisk', (data = new ReportRisk(this, options)))
            }

            if (typeof option == 'string') {
                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.reportRisk;

    $.fn.reportRisk = Plugin;
    $.fn.reportRisk.Constructor = ReportRisk;
    
    $.fn.reportRisk.noConflict = function () {
        $.fn.reportRisk = old;
        return this;
    }
})(jQuery);

$(function () {
    $('#reportRisk').reportRisk({
    })
})