/**
 * Created by 11150221050069 on 2016/12/28.
 */

var url='/a/index/api?';
var currentNum = 1;
var pageSize = 10;//显示的行数
var flag = 0;
//弹窗信息
var riskList=[];
+(function ($) {

    function RiskDetailPage(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;

        this.$element

        	// 弹窗
	        .on('click', 'tbody[data-id=viewDetail] tr td > a', function () {
				var index = $(this).attr('data-index');
				var riskManageId = $(this).attr('data-id');
				var detailUrl = url+'_id=nytz_riskDetail_log&riskManageId=' + riskManageId;
				$.getJSON(detailUrl, function(data){
					//解析详情数据
					if(data){

						var detailData = riskList[index];

						var str =detailData.evidence;
						str = str.substring(str.lastIndexOf('/')+1);
						var fileName = decodeURI(str);
						var html="";
						html +='<p><span>风险级别：</span><span class="risk-color">'+detailData.alarmLevelText+'</span></p>';
						html +='<p>风险维度：<span>'+detailData.alarmTypeText+'</span></p>';
						html +=' <p>风险内容：<span>'+detailData.riskMsg+'</span></p>';
						html +=' <div class="highBox">';
						html +='<p>界定结果: ';
						if(detailData.defineStatusText){
							html +='<span>'+detailData.defineStatusText+'</span></p>';
						}
						html +='<p>界定人: ';
						if(detailData.definePerson){
							html +='<span>'+detailData.definePerson+'</span></p>';
						}
						html +='<p>界定时间：';
						if(detailData.defineDate){
							html +='<span>'+detailData.defineDate+'</span></p>';
						}
						html +='<p>界定材料：';
						if(detailData.evidence){
							html +='<span>'+fileName+' <a class="download" download="'+ fileName +'" href="'+detailData.evidence+'" >下载</a></span></p>';
							html +='<p>说明：<span>' + detailData.explains + '</span>';
						}
						html += '</p></div>';
						html +='<span class="s-title">界定履历：</span><ul class="defineList">';
						for(var i = 0,len = data.length;i<len;i++){
							var logItem = data[i];
							html +='<li><span>'+logItem.definePerson +'</span>' +
								' <span>'+getActionText(logItem.action) +'</span>' +
								' <span>'+logItem.createDate+'</span></li>';
						}
						html +='</ul>';

						$('#pop-content').html(html);
						$('.risk-popup').show();
					} else {
						alert('请求失败')
					}
				})

	        })
	        .on('click', 'i[data-id=close]', function () {
	        	 $('.risk-popup').hide();
	        })
	        .on('click','span[data-id=treeBtn]',function(){
	        	$('#treeDemo').show();
	        })
	        .on('click','[data-id=tree-close]',function(){
	        	$('#treeDemo').hide();
	        })
	        .on('click','[data-id=search]',function(){
	        	currentNum = 1;
	        	_riskDetail(currentNum,pageSize);
	        })
	        .on('click','[data-id=up]',function(){
	        	//上一页
	        	flag =1;
	        	var num = parseInt($('[data-id=pageNum]').text());
	        	$('.pagePrev').attr('data-id','down');
	        	$('[data-id=down]').find('a').removeClass('disable');
	        	
	        	currentNum--;
	        	if(currentNum == 1){
	        		$('[data-id=up]').find('a').addClass('disable');
	        		$(this).removeAttr('data-id');

	        	}
	        	_riskDetail(currentNum,pageSize);//取数据
	        })
	        .on('click','[data-id=down]',function(){
	        	//下一页
	        	flag =2
	        	var num = parseInt($('[data-id=pageNum]').text());
	        	$('.pagePrev').attr('data-id','up');
	        	$('[data-id=up]').find('a').removeClass('disable');
	        	currentNum++;
        		
        		if(num == 0){
        			$('[data-id=down]').find('a').addClass('disable');
        			$(this).removeAttr('data-id');

        		}
        		_riskDetail(currentNum,pageSize);//取数据
	        })
    }

	function getActionText(action){
		//动作描述 1-界定;2-撤销界定;3-转发界定
		if(action=='1'){
			return '界定';
		} else if(action=='2'){
			return '撤销界定';
		} else if(action=='3'){
			return '转发界定';
		}
	}

    //界定状态
    function _defineStatus(){

    	$.getJSON(url+'_id=nytz_riskDetail_defineStatus',function(data){
    		var option='';
    		$('[data-id=defineStatus]').empty();
    		option +='<option></option>'
    		for(var i = 0; i < data.length; i++){
    			option +='<option value="'+data[i].VALUE+'">' + data[i].LABEL+'</option>'
    		}
    		$('[data-id=defineStatus]').append(option);
    	})
    }
    //操作人
    function _bizOperPersonName(id){
    	var param ={
    			cPost:id
    	}
    	 var option='';
    	/*option +='<option></option>'*/
    	$.post(url+'_id=nytz_operPerson',param,function(data){
    		
    		for(var i = 0; i < data.length; i++){
    			option +='<option value="'+data[i].ID+'">' + data[i].NAME+'</option>'
    		}
    		$('[data-id=person]').append(option);
    	})
    }
    //总页号
    function _totalpageNum(params){
    	$.get(url+'_id=nytz-risk-pageNum',params,function(result){
    		if(result.length > 0){
    			//总共的页数
    			var pageNum = Math.ceil(parseInt(result[0].totalCount)/ pageSize);
    			
    			if(flag == 2){
    				pageNum = pageNum - 1;
    				$('[data-id=pageNum]').text(pageNum);
    			}else if(flag == 1){
    				pageNum = pageNum;
    				$('[data-id=pageNum]').text(pageNum);
    			}else if(flag == 0){
    				$('[data-id=pageNum]').text(pageNum);
    			}
    			if(pageNum > 1){
    				$('.pageNext').attr('data-id','down');
    				$('.pageNext').find('a').removeClass('disable');
    			}else{
    				$('.pageNext').removeAttr('data-id','down');
    				$('.pageNext').find('a').addClass('disable');
    				
    			}
    		}
    	})
    }

    //风险管理数据
    function _riskDetail(currentNum,pageSize){
    	//开始的页数
		var start = (currentNum-1) * pageSize + 1;
		//结束页数
		var end = currentNum * pageSize;
		
    	var params={
        		cStartNum:start,
        		cEndNum:end
        	};
		if($('input[data-id=inputBox]').val()){
			params.cPost = $('input[data-id=inputBox]').val();
		}
		if($('[data-id=person]').val()){
			params.cPerson = $('[data-id=person]').val();
		}
		if($('[data-id=defineStatus]').val()){
			params.cStatus = $('[data-id=defineStatus]').val();
		}
		var count = _totalpageNum(params);
		if(count == 0){
			
			tbody +='<tr>';
			tbody +='<td colspan="7">暂无数据</td>';
			tbody +='</tr>';
			$('[data-id=viewDetail]').append(tbody);
			return;
		}
        	$.get(url+'_id=nytz_riskDetail',params,function(allData){
    			$('[data-id=viewDetail]').empty();
        		var option='<option></option>';
        		var tbody='';
        		var oper={};
        		riskList = allData;
        		if(allData.length !=0){
        			for(var i = 0; i < allData.length; i++){
						var riskItem = allData[i];
        				tbody +='<tr>';
        				tbody +='<td class="border-right">'+riskItem.bizFlowName +'</td>';
        				tbody +='<td class="border-right">'+riskItem.bizOperPersonName+'</td>';
        				tbody +='<td class="border-right">'+riskItem.bizOperPostName+'</td>';
        				tbody +='<td class="border-right">'+riskItem.bizDataName+'</td>';
        				tbody +='<td class="border-right">'+riskItem.riskMsg+'</td>';
        				if(riskItem.alarmLevel == '1'){
        					tbody +='<td class="border-right"><div class="risk-point risk-green"></div></td>';
        				}else if(riskItem.alarmLevel == '2'){
        					tbody +='<td class="border-right"><div class="risk-point risk-yellow"></div></td>';
        				}else if(riskItem.alarmLevel == '3'){
        					tbody +='<td class="border-right"><div class="risk-point risk-orange"></div></td>';
        				}else if(riskItem.alarmLevel == '4'){
        					tbody +='<td class="border-right"><div class="risk-point risk-red"></div></td>';
        				}
        				
        				tbody +=' <td class="border-right">'+riskItem.definePerson+'</td>';
        				tbody +=' <td class="border-right">'+riskItem.defineStatusText+'</td>';
        				tbody +='<td><a href="javaScript:void(0)" class="btn btn-view" data-index="'+i+'"  data-id="'+riskItem.riskManageId+'">查看</a></td>';
        				tbody +='</tr>';
        			}
        			$('[data-id=person]').append(option);
        			$('[data-id=viewDetail]').append(tbody);
        			
        		}else{
        			tbody +='<tr>';
    				tbody +='<td colspan="9">暂无数据</td>';
    				tbody +='</tr>';
    				$('[data-id=viewDetail]').append(tbody);
        		}
        	});
   }
    
    RiskDetailPage.prototype.getData = function(){
    	_defineStatus();
    	_getTree();
    	

    	currentNum = 1;//当前的页数
    	pageSize = 10;//显示的行数
    	_riskDetail(currentNum,pageSize);
    	
    }
    function _getTree(){
     	// zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
    	 var setting = {
    			 data:{
			    		 simpleData:{
					    		 enable:true,
					    		 idKey:"id",
					    		 pIdKey:"pId",
					    		 rootPId:'0'
			    			 }
			    	 },
    				callback:{onClick:function(event, treeId, treeNode){
    						var id = treeNode.pId == '0' ? '' :treeNode.pId;
    						 $('#treeDemo').hide();
    						 $('input[data-id=inputBox]').val(treeNode.name);
    						
    						 if(treeNode.name != null){
    					    		_bizOperPersonName(treeNode.id);
    					    	}
    					}
    				} 
    			};
    	 var param={
    			 isAll:true
    	 }
    	 $.getJSON("/a/nytz/treeData",param,function(data){
    		
 			$.fn.zTree.init($("#treeDemo"), setting, data).expandAll(true);
 		});
    	
    }
 
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.riskDetailPage');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.riskDetailPage', (data = new RiskDetailPage(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.riskDetailPage;

    $.fn.riskDetailPage = Plugin;
    $.fn.riskDetailPage.Constructor = RiskDetailPage;
    
    $.fn.riskDetailPage.noConflict = function () {
        $.fn.riskDetailPage = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
	 $('div[data-id=riskDetailPage]').riskDetailPage('getData');
})

