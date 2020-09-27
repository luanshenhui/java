+(function ($) {
	
    function WorkFlowCheck(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {
        	
        	workFlowCheckMsg1 : "工作流定义时，有且只能有一个开始节点，请修改后重新保存！",
        	workFlowCheckMsg2 : "工作流定义时，有且只能有一个结束节点，请修改后重新保存！",
        	workFlowCheckMsg3 : "工作流定义时，开始节点和结束节点中至少有一个任务节点，请修改后重新保存！",
        	workFlowCheckMsg4 : "工作流定义时，从开始节点开始的任务数有且只有一个，请修改后重新保存！",
        	workFlowCheckMsg5 : "工作流定义时，以结束节点结束的任务数有且只有一个，请修改后重新保存！",
        	workFlowCheckMsg6 : "工作流定义时，除去开始和结束节点，其他的任务节点均应该有来源和去向，请修改后重新保存！"
        	
        }, options);

    }
    
    WorkFlowCheck.prototype.check = function (data, fn) {

        var data = this.checkWorkFlow(data);

        fn && fn(data);
    }
    
    WorkFlowCheck.prototype.checkWorkFlow = function (workFlow){
    	var $this = this;
    	
    	var nodes = workFlow.nodes;
    	var arr = [];
    	// 开始节点
    	var startNode;
    	// 结束节点
    	var endNode;
    	// 中间任务节点
    	var taskNodes = [];
    	
    	// 获取节点类型
    	$.each(nodes, function(key, value){
    		arr.push(value.type);
    		
    		if(value.type == "start round"){
    			startNode = key;
    		}
    		if(value.type == "end round"){
    			endNode = key;
    		}
    		if(value.type == "mutiselect"){
    			taskNodes.push(key);
    		}
    	})
    	
    	// 判断开始节点
    	var startCount = 0;
    	for(var i=0;i<arr.length;i++){
    		 if(arr[i] == "start round"){
    			 startCount++;
    		 }
    	}
    	// 有且只能有一个开始节点
    	if(startCount != 1){
    		alertx($this.options.workFlowCheckMsg1);
    		return false;
    	}
    	
    	// 判断结束节点
    	var endCount = 0;
    	for(var i=0;i<arr.length;i++){
    		 if(arr[i] == "end round"){
    			 endCount++;
    		 }
    	}
    	// 有且只能有一个结束节点
    	if(endCount != 1){
    		alertx($this.options.workFlowCheckMsg2);
    		return false;
    	}
    	
    	// 判断是否含有工作流节点
    	var indexEnd = $.inArray("mutiselect", arr);
    	if(indexEnd == -1){
    		alertx($this.options.workFlowCheckMsg3);
    		return false;
    	}
    	
    	var lines = workFlow.lines;
    	var fromNodes = [];
    	var toNodes = [];
    	// 获取连线
    	$.each(lines, function(key, value){
    		fromNodes.push(value.from);
    		toNodes.push(value.to);
    	})
    	
    	// 开始节点连线
    	var hasStartCount = 0;
    	for(var i=0;i<fromNodes.length;i++){
    		 if(fromNodes[i] == startNode){
    			 hasStartCount++;
    		 }
    	}
    	if(hasStartCount != 1){
    		alertx($this.options.workFlowCheckMsg4);
    		return false;
    	}
    	
    	// 结束节点连线
    	var hasEndCount = 0;
    	for(var i=0;i<toNodes.length;i++){
    		 if(toNodes[i] == endNode){
    			 hasEndCount++;
    		 }
    	}
    	if(hasEndCount != 1){
    		alertx($this.options.workFlowCheckMsg5);
    		return false;
    	}
    	
		// 判断中间节点是否连线
    	for(var i=0;i<taskNodes.length;i++){

        	var taskStart = $.inArray(taskNodes[i], fromNodes);
        	var taskEnd = $.inArray(taskNodes[i], toNodes);
        	if(taskStart == -1 || taskEnd == -1){
        		alertx($this.options.workFlowCheckMsg6);
        		return false;
        	}
    	}
    	
    	return true;
    }
    
    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1);

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.workFlowCheck');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.workFlowCheck', (data = new WorkFlowCheck(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.workFlowCheck;

    $.fn.workFlowCheck = Plugin;
    $.fn.workFlowCheck.Constructor = WorkFlowCheck;
    
    $.fn.workFlowCheck.noConflict = function () {
        $.fn.workFlowCheck = old;
        return this;
    }
})(jQuery);