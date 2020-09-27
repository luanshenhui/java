/**
 * Created by 11150221050069 on 2016/12/28.
 */

var url='/a/index/api?';

+(function ($) {

    function AlarmDetailPage(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {}, options);

        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;
        
        this.$element

	        .on('click','span[data-id=treeBtn]',function(){
	        	$('#treeDemo').show();
	        })
	        .on('click','[data-id=tree-close]',function(){
	        	$('#treeDemo').hide();
	        })
	        .on('click','[data-id=search]',function(){
	        	_alarmDetail();
	        })
    }
    
    //告警级别
    function _alarmLevel(){
    	
    	$.getJSON(url+'_id=nytz-alarmLevel',function(data){
    		var option='';
    		$('[data-id=alarmLevel]').empty();
    		option +='<option></option>'
    		for(var i = 0; i < data.length; i++){
    			option +='<option value="'+data[i].VALUE+'">' + data[i].LABEL+'</option>'
    		}
    		$('[data-id=alarmLevel]').append(option);
    	})
    }
    //告警状态
    function _alarmStatus(){
    	
    	$.getJSON(url+'_id=nytz-alarmStatus',function(data){
    		var option='';
    		$('[data-id=alarmStatus]').empty();
    		option +='<option></option>'
    		for(var i = 0; i < data.length; i++){
    			option +='<option value="'+data[i].VALUE+'">' + data[i].LABEL+'</option>'
    		}
    		$('[data-id=alarmStatus]').append(option);
    	})
    }
    //操作人
   /* function _bizOperPersonName(id){
    	var param ={
    			cPost:id
    	}
    	 var option='';
    	option +='<option></option>'
    	$.get(url+'_id=nytz_operPerson',param,function(data){
    		
    		for(var i = 0; i < data.length; i++){
    			option +='<option value="'+data[i].ID+'">' + data[i].NAME+'</option>'
    		}
    		$('[data-id=person]').append(option);
    	})
    }*/
    
    //告警数据
   function _alarmDetail(){
	  
    	var params={};
    	if($('input[data-id=inputBox]').val()){
			params.cPost = $('input[data-id=inputBox]').val();
		}
		if($('[data-id=operPerson]').val()){
			params.cPerson = $('[data-id=operPerson]').val();
		}
		if($('[data-id=alarmStatus]').val()){
			params.cStatus = $('[data-id=alarmStatus]').val();
		}
		if($('[data-id=alarmLevel]').val()){
			params.cLevel = $('[data-id=alarmLevel]').val();
		}
        	$.get(url+'_id=nytz_alarmDetail',params,function(allData){
        		 $('[data-id=viewDetail]').empty();
        		console.log(allData);
        		var tbody='';
        		if(allData){
        			for(var i = 0; i < allData.length; i++){
        				tbody +='<tr>';
        				tbody +='<td class="border-right">'+allData[i].bizFlowName +'</td>';
        				tbody +='<td class="border-right">'+allData[i].bizOperPersonName+'</td>';
        				tbody +='<td class="border-right">'+allData[i].bizOperPostName+'</td>';
        				tbody +='<td class="border-right">'+allData[i].bizDataName+'</td>';
        				tbody +='<td class="border-right">'+allData[i].alarmMsg+'</td>';
        				if(allData[i].alarmLevel == '1'){
        					tbody +='<td class="border-right"><div class="risk-point risk-green"></div></td>';
        				}else if(allData[i].alarmLevel == '2'){
        					tbody +='<td class="border-right"><div class="risk-point risk-yellow"></div></td>';
        				}else if(allData[i].alarmLevel == '3'){
        					tbody +='<td class="border-right"><div class="risk-point risk-orange"></div></td>';
        				}else if(allData[i].alarmLevel == '4'){
        					tbody +='<td class="border-right"><div class="risk-point risk-red"></div></td>';
        				}
        				
        				tbody +=' <td class="border-right">'+allData[i].status+'</td>';
        				tbody +='</tr>';
        			}
        			$('[data-id=viewDetail]').append(tbody);
        		}
        	})
    }
    
    AlarmDetailPage.prototype.getData = function(){
    	_alarmStatus();
    	_alarmLevel();
    	_alarmDetail();
    	_getTree();
    	
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
    						
    						 /*if(treeNode.name != null){
    					    		_bizOperPersonName(treeNode.id);
    					    	}*/
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
            var data = $this.data('dcapp.alarmDetailPage');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.alarmDetailPage', (data = new AlarmDetailPage(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.alarmDetailPage;

    $.fn.alarmDetailPage = Plugin;
    $.fn.alarmDetailPage.Constructor = AlarmDetailPage;
    
    $.fn.alarmDetailPage.noConflict = function () {
        $.fn.alarmDetailPage = old;
        return this;
    }
    	  
})(jQuery);


$(function () {
	
	 $('div[data-id=alarmDetailPage]').alarmDetailPage('getData');
})

