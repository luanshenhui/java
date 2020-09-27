/**
 * 国资委首页三重一大相关数据
 */

+(function ($) {

    function ThreeImportant(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        $('div[data-id="tree-left"]', this.$element).webFlowSimple();

        _buildEvent.call(this);

    }

    function _buildEvent() {
        var $this = this;
        this.$element
        
        	.on('click', '.box-left>ul li', function (){
        		
        		$(this).addClass('on').siblings().removeClass('on');
        		
        		var id = $(this).attr('data-powerId');

    			$('#powerId').val(id);
        		// 重大事项
	    		if(id == "01"){
	    			
	    			$('p[data-id="impTitle"]').html("<i></i>重大事项 ");
	    			$this.findRiskData();
	    			$this.findSpecialCommitteeRisk();
	    		// 重大项目
	    		}else if(id == "02"){
	    			
	    			$('p[data-id="impTitle"]').html("<i></i>重大项目");
	    			$this.findRiskData();
	    			$this.findSpecialCommitteeRisk();
	    			
	    		// 重要人事
	    		}else if(id == "03"){
	    		
	    			$('p[data-id="impTitle"]').html("<i></i>重要人事");
	    			
	    			$this.findRiskData();
	    			$this.findSpecialCommitteeRisk();
	    			
	    		// 大额资金
	    		}else if(id == "04"){
	    			$('p[data-id="impTitle"]').html("<i></i>大额资金");
	    			
	    			$this.findRiskData();
	    			$this.findSpecialCommitteeRisk();
	    		}
	    		
	    		if(id=="03"){
	    			$('div[data-id=msg-right]').hide();
	    			$('div[data-id=menu]').hide();
	    			$('div[data-id=pie-right]').hide();
	    		}else{
	    			$('div[data-id=msg-right]').show();
	    			$('div[data-id=menu]').show();
	    			$('div[data-id=pie-right]').show();
	    		}
        		
        	})
        	.on('click','span[data-id="tab"] > a',function(){
        		$(this).addClass('on').siblings().removeClass('on');
        		var id = $(this).attr('data-id');
        		if(id == 'workflowpoint'){
        			$('div[data-id=first]').removeClass('display-none').addClass('display-block');
        			$('div[data-id=second]').removeClass('display-block').addClass('display-none');
        		}else if(id == 'riskTotal'){
        			$('div[data-id=first]').removeClass('display-block').addClass('display-none');
        			$('div[data-id=second]').removeClass('display-none').addClass('display-block');
        			
        			$('#speCommittee').val('A');
        			$('#timeType').val('2')
        			$this.findSpeCommitteeRiskData();
        			$this.findSpecialCommitteeRisk();
        		}
        		
        		
        	})
	        .on('click','.GooFlowS_item',function(){
	        	
	        	var name = $(this).find('table span').text();
	        	var param={
	        			powerId:$('#powerId').val(),
	        			taskName:name
	        	}
	        	$.getJSON(ctx+'/gzw/getNodeDetailData',param,function(result){
	        		
	        			var riskList = result.riskList;
	        			var alarmList = result.alarmList;
	        			var totalriskCount = 0,totalalarmCount = 0;
	        			if(name !="开始" && name !="结束"){
	        				if(riskList){
	        					for(var i = 0; i < riskList.length; i++){
			        				var id = riskList[i].alarmType;
			        				var count = riskList[i].count;
			        				
			        				$("span[data-id=risk"+id+"]").text(count);
			        				totalriskCount +=count;
			        			}
	        					$('span[data-id=riskCount]').text(totalriskCount);
	        				}
		        			if(alarmList){
		        				for(var j = 0; j < alarmList.length; j++){
			        				var id = alarmList[j].alarmType;
			        				var count = alarmList[j].count;
			        				$("span[data-id=alarm"+id+"]").text(count);
			        				totalalarmCount +=count;
			        			}
		        				$('span[data-id=alarmCount]').text(totalalarmCount);
		        			}
		        			
		        		}
	        		
	        	})
	        })
	        .on('click','div[data-id=menu] ul > li',function(){
	        	$(this).addClass('on').siblings().removeClass('on');
	        	var speComId =$(this).attr('data-id');
	        	$('#speCommittee').val(speComId);
	        	//点击每个委员会查询每个月的数据
	        	if(speComId == 'A'){
	        		$this.findSpeCommitteeRiskData();
	        		
	        	}else if(speComId == 'B'){
	        		
	        		$this.findSpeCommitteeRiskData();
	        		
	        	}else if(speComId == 'C'){
	        		
	        		$this.findSpeCommitteeRiskData();
	        		
	        	}else if(speComId == 'D'){
	        		
	        		$this.findSpeCommitteeRiskData();
	        		
	        	}else if(speComId == 'E'){
	        		
	        		$this.findSpeCommitteeRiskData();
	        		
	        	}else if(speComId == 'F'){
	        		
	        		$this.findSpeCommitteeRiskData();
	        		
	        	}
	        	
	        })
	        .on('click','span[data-id=time-btn] > a',function(){
	        	$(this).addClass('on').siblings().removeClass('on');
	        	var timeid = $(this).attr('data-id');
	        	$('#timeType').val(timeid);
	        	if(timeid =='1'){
	        		$this.findSpecialCommitteeRisk();
	        	}else if(timeid =='2'){
	        		$this.findSpecialCommitteeRisk();
	        	}else if(timeid =='3'){
	        		$this.findSpecialCommitteeRisk();
	        	}
	        	
	        	
	        })
        
    }
    
    //流程图
    
    function _getWorkFlowXML (powerId) {
    
    		$('div[data-id=tree-left]').webFlowSimple('loadDataAjax',ctx+'/gzw/getWorkFlowXML?powerId='+powerId);
    }
    
    //风险播报
   ThreeImportant.prototype.findRiskData = function () {
	  
	   _getWorkFlowXML($('#powerId').val());
	   
	   var param = {
			   powerId : $('#powerId').val()
	   }
	   $('#sp li').remove();
	   $.getJSON(ctx +'/gzw/getSecondData', param, function(result){
		  
		   var alarmAndRiskList = result.alarmAndRiskList;
	    	if(alarmAndRiskList){
	    		var html = '';
	    		for(var i = 0; i < alarmAndRiskList.length; i++){
	    			// 级别
	    			var alarmLevel = alarmAndRiskList[i].alarmLevel;
	    			// 业务操作人
	    			var operPersonName = alarmAndRiskList[i].operPersonName;
	    			// 用于区分告警和风险（告警-1、风险-2）
	    			var type = alarmAndRiskList[i].type;
	    			// 更新时间
	    			var updateDate = alarmAndRiskList[i].updateDate;
	    			
	    			var iconClass = "";
	    			if(alarmLevel == 1){
	    				iconClass = "icon-green";
	    			}else if(alarmLevel == 2){
	    				iconClass = "icon-yellow";
	    			}else if(alarmLevel == 3){
	    				iconClass = "icon-orange";
	    			}else if(alarmLevel == 4){
	    				iconClass = "icon-red";
	    			}
	    			var typeName = "";
	    			var fontColorClass = "";
	    			if(type == 1){
	    				typeName = "告警";
	    				fontColorClass = "yellow-font";
	    			}else if (type == 2){
	    				typeName = "风险";
	    				fontColorClass = "red-font";
	    			}
	    			html = '<li><i class="'+ iconClass +'"></i><span class="'+ fontColorClass +'">'+ typeName +'</span>：'+ operPersonName + updateDate +'出现'+ typeName +'</li>';
	    			$('#sp').append(html);
	    		}
			   
		    }else{
	    		$('#systemScroll').hide();
	    		$('#systemScrollHidden').show();
	    	}
	   })
	   
    }

    
    ThreeImportant.prototype.findSpeCommitteeRiskData = function () {
    	var param = {
 			   powerId : $('#powerId').val(),
 			  speCommittee: $('#speCommittee').val()
 	   }
    	// 12月份柱状图
	 $.get(ctx+'/gzw/findSpeCommitteeRiskData',param,function(result){
		
		 if(result){
			 _drawBar(result.data);
		 }
		 
	 })
	  
    }
    ThreeImportant.prototype.findSpecialCommitteeRisk = function () {
    var params={
    		powerId : $('#powerId').val(),
    		timeType: $('#timeType').val(),
			  
    	}
	  $.getJSON(ctx+'/gzw/findSpecialCommitteeRisk',params,function(result){
		
		 
		 if(result){
			 var legenName=[];
			 var riskcountList=[];
			 for(var i = 0; i < result.length; i ++){
				
				 var id = result[i].powerId;//委员会ID
				 var name = $("li[data-id="+id+"] a").text(); 
				var item={
						value:result[i].totalCount,//风险个数
						name:name
				}
				riskcountList.push(item);
				legenName.push(name);
			 }
			 
			 
			 _drawPie(riskcountList,legenName);
		 }
		 
	 })
    }
    
	// 绘制饼图
    function _drawPie(riskcountList,legenName){
    	
    	 var myChart2 = echarts.init(document.getElementById('chart2'));
    	   option2 = {
    	       tooltip: {
    	           trigger: 'item',
    	           formatter: "{a} <br/>{b}: {c} ({d}%)"
    	       },
    	       legend: {
                   orient: 'vertical',
                   top: 'bottom',
                   left: 'center',
                   bottom: 200,
                   data: legenName,
                   textStyle: {
                	   fontSize: '16',
                	   color: '#fff'
                   }
               },
    	       series: [
    	           {
    	               type:'pie',
    	               center: ['50%', '35%'],
    	               radius: ['30%', '70%'],
    	               label: {
    	                   normal: {
    	                       position: 'out',
    	                       formatter: "{d}%",
    	                       textStyle:{
    	                           fontSize:14
    	                       }
    	                   }
    	             },
    	             labelLine: {
    	                    normal: {
    	                        show: true
    	                    }
    	                },
    	              data:riskcountList
    	           }
    	       ]
    	   };
    	   myChart2.setOption(option2);
    }
    
   function _drawBar(data){
        var myChart1 = echarts.init(document.getElementById('chart1'));
        option = {
            tooltip: {
                trigger: 'axis'
            },
            xAxis: [
                {
                    type: 'category',
                    data: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
                    axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
                }
            ],
            series: [
                {
                    name:'总量',
                    type:'bar',
                    barWidth:'20',
                    itemStyle : { normal: {color:'#02bdf4',label : {show: true, position: 'top',textStyle:{fontSize:20 }}}},
                    data:data
                },
                {
                    name:'总量',
                    type:'line',
                    itemStyle : { normal: {color:'#ffff00',textStyle:{fontSize:20 }}},
                    data:data

                }
            ]
        };
       myChart1.setOption(option);
    }
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.threeImportant');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.threeImportant', (data = new ThreeImportant(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.threeImportant;

    $.fn.threeImportant = Plugin;
    $.fn.threeImportant.Constructor = ThreeImportant;
    
    $.fn.threeImportant.noConflict = function () {
        $.fn.threeImportant = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
    $('#threeImportantGZW').threeImportant("findRiskData");
   
    
})

