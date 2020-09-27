+(function ($) {
	
	var msglist = [];

    /**
     *	工作流节点设置
     * @param element dom节点
     * @param options  options 参数
     * @constructor
     */
    function ConstraintValidate(element, options) {

        this.$element = $(element);

        this.options = $.extend({}, {
        	
        	taskNameNotNull : "任务节点名称不能为空!",
        	taskNameHasExists : "当前输入的任务节点名称已被使用，请输入其他的名称。",
        	selectBizRole : "请至少选择一个业务角色。",
        	taskBizIdNotNull : "业务节点ID不能为空。",
        	taskBizIdNotNumAlpha : "业务节点ID必须为字母或数字。",
        	setConstraint : "请至少设置一个约束条件。",
        	nodeErrorMsg : "时间约束中，本节点需要时间预警级别设置有误，请确认后再次输入。",
        	toNodeErrorMsg : "时间约束中，至本节点完成所需时间预警级别设置有误，请确认后再次输入。",
        	timeConstraintMsg1 : "时间约束中，本节点需要时间和至本节点完成所需时间至少输入一项。",
        	timeConstraintMsg2 : "时间约束中，本节点需要时间请输入正整数。",
        	timeConstraintMsg3 : "时间约束中，本节点需要时间“未设定”时，告警级别不可设置。",
        	timeConstraintMsg4 : "时间约束中，至本节点完成所需时间请输入正整数。",
        	timeConstraintMsg5 : "时间约束中，至本节点完成所需时间“未设定”时，告警级别不可设置。",
        	timeConstraintMsg6 : "时间约束中，本节点需要时间和至本节点完成所需时间关系有误，请重新输入。",
        	timeConstraintMsg7 : "时间约束中，关联风险清单不能为空。",
        	timeConstraintMsg8 : "时间约束中，本节点需要时间设定的时间单位与至本节点完成所需时间的时间单位必须相同。",
        	functionalConstraintMsg1 : "职能约束中，本节点的触发条件信息必须填写，请信息完善后再进行保存。",
        	functionalConstraintMsg2 : "职能约束中，本节点的告警级别信息必须填写，请信息完善后再进行保存。",
        	functionalConstraintMsg3 : "职能约束已置为风险项，则必须关联风险清单！",
        	behaviourConstraintMsg1 : "行为约束中，本节点的触发条件信息必须填写，请信息完善后再进行保存。",
        	behaviourConstraintMsg2 : "行为约束中，本节点的告警级别信息必须填写，请信息完善后再进行保存。",
        	behaviourConstraintMsg3 : "行为约束已置为风险项，则必须关联风险清单！",
        	proveConstraintMsg1 : "互证约束中，本节点的触发条件信息必须填写，请信息完善后再进行保存。",
        	proveConstraintMsg2 : "互证约束中，本节点的告警级别信息必须填写，请信息完善后再进行保存。",
        	proveConstraintMsg3 : "互证约束已置为风险项，则必须关联风险清单！"

        }, options);

        // 方法绑定
        _buildEvent.call(this);

    }

    function _buildEvent() {

        var $this = this;

        this.$element

            .on('click', 'i[data-role="hasUsed"]', function(){
            	
        		var id = $(this).attr("data-content");
        		var riskType = $(this).attr("data-risk");
        		var idRisk = $(this).attr("data-isRisk");
        		var manualJudge = $(this).attr("data-manualJudge");
        		
            	if($(this).attr("data-value") == 0){
            		$(this).attr("data-value",1);
            		$(this).removeClass("closeImg").addClass("openImg");

            		// 当约束条件设置为有效时，所有条件设为可编辑
            		if(id == "timeConstraint"){
                		$('input,select', $('#'+id)).attr('disabled',false);
            		}else{
            			$('input,a,textarea', $('#'+id)).attr('disabled',false);
            		}
            		
            		$('#postButton').removeClass('disabled');
            		
            		$('i[data-role="switch"]', $('#'+id)).addClass("switch");
            		
            		// 当【是否是风险】为【是】时，设【关联风险清单】、【是否可以人工界定风险】为可编辑；否则不可编辑。
            		if($("#"+idRisk).val() == 1){
                		$("#"+riskType, $('#'+id)).attr('disabled', false);
                		$('i[data-id="'+manualJudge+'"]', $('#'+id)).addClass("switch");
            		}
            		
            	}else{
            		$(this).attr("data-value",0);
            		$(this).removeClass("openImg").addClass("closeImg");
            		
            		// 当约束条件设置为无效时，所有条件设为不可编辑
            		if(id == "timeConstraint"){
                		$('input,select', $('#'+id)).attr('disabled',true);
            		}else{
            			$('input,a,textarea', $('#'+id)).attr('disabled',true);
            		}
            		
            		$('#postButton').addClass('disabled');
            		
            		$('i[data-role="switch"]', $('#'+id)).removeClass("switch");
            		
            		$("#"+riskType).attr('disabled', true);
            		$('i[data-id="'+manualJudge+'"]', $('#'+id)).removeClass("switch");
            		
            	}

            	var switchId = $(this).attr("data-id");
            	$("#"+switchId).val($(this).attr("data-value"));
            	
            })
            
            .on('click', '.switch', function(){
            	
            	var riskType = $(this).attr("data-risk");
            	var manualJudge = $(this).attr("data-manualJudge");
            	
            	if($(this).attr("data-value") == 0){
            		$(this).attr("data-value", 1);
            		$(this).removeClass("closeImg").addClass("openImg");
            		
            		// 当【是否是风险项】为【是】时，【关联风险清单】、【是否可以人工界定风险】设置为可编辑
            		if(riskType){
                		$("#"+riskType).attr('disabled', false);
            		}
            		if(manualJudge){
            			$('i[data-id="'+manualJudge+'"]').addClass("switch");
            		}
            	}else{
            		$(this).attr("data-value", 0);
            		$(this).removeClass("openImg").addClass("closeImg");
            		
            		// 当【是否是风险项】为【否】时，【关联风险清单】设置为不可编辑
            		if(riskType){
                		$("#"+riskType).attr('disabled', true);
            		}
            		// 当【是否是风险项】为【否】时，【是否可以人工界定风险】设置为不可编辑且设置为【否】。
            		if(manualJudge){
            			$('i[data-id="'+manualJudge+'"]').removeClass("switch");
            			$('i[data-id="'+manualJudge+'"]').attr("data-value", 0);
            			$('i[data-id="'+manualJudge+'"]').removeClass("openImg").addClass("closeImg");
            			$('#'+manualJudge).val(0);
            		}
            	}
            	
            	var id = $(this).attr("data-id");
            	$("#"+id).val($(this).attr("data-value"));
            	
            })
            
            .on('click', '.TabCondt li', function(){
            	var i = $(this).index();
 	            $('.cstCondition .TabMain').eq(i).addClass('TabMainOn').siblings().removeClass('TabMainOn');
 	            $(this).addClass('tabOn').siblings().removeClass('tabOn');
            })
            
            .on('click', '.labelChk', function(){
            	// 设置业务角色是否选中
            	if($(this).attr('class') == 'labelChk checkedOn'){
    				$(this).removeClass("checkedOn").addClass("checkedOff");
    				$(this).prev().removeAttr("checked");
    			}else{
    				$(this).removeClass("checkedOff").addClass("checkedOn");
    				$(this).prev().attr("checked", 'true');
    			}
            })
            
            // 初始化界面时，给业务角色赋值
    		var bizRoleId = $('#bizRoleId').val();
    		var str = bizRoleId.split('||');
    		
    		for(var i = 0; i < str.length; i++) {
    			$("input:checkbox[data-value='"+ str[i] +"']").attr('checked','true').next().removeClass("checkedOff").addClass("checkedOn");
			}

    }
    
    ConstraintValidate.prototype.checkTask = function (data, fn) {
    	var $this = this;
    	// 节点验证
    	var data = _taskValidate($this);
    	
    	// 弹出提示框
		if(msglist != null && msglist.length != 0){
			var text = "";
			for(var i=0;i< msglist.length;i++){
				text += "<p>" + msglist[i] + "</p>";
			}
			alertx(text);
			msglist = [];
		}
		
        fn && fn(data);
    }
    
    function _taskValidate(self){
    	// 判断节点名称是否为空
    	var taskName = $('[data-id="taskName"]').val();
    	if(taskName == ""){
    		msglist.push(self.options.taskNameNotNull);
    		return false;
    	}
    	
    	// 校验节点名称是否重复
    	var wfId = $('[data-id="wfId"]').val();
    	var taskId = $('#taskId').val();
    	
    	var url = ctx+"/dca/dcaWorkflowTask/checkTaskName";
    	var param = {
    			taskName : taskName,
    			wfId : wfId,
    			taskId : taskId
    	};
    	var checkNameFlag = false;
    	
    	$.ajax($.extend(true, {
			url: url,
			dataType: "json",
			data: param,
			async: false,
			success: function(response) {
				if(response == true){
	        		checkNameFlag = true;
	    		}else{
	    			checkNameFlag = false;
	    		}
			}
		}, url));
    	
    	// 判断节点名称是否重复
    	if(checkNameFlag){
    		msglist.push(self.options.taskNameHasExists);
    		return false;
    	}

    	// 判断业务角色是否为空 
        var optIDs = '';  
        $('input[name="bizRole"][checked]').each(function() {
        	optIDs += (optIDs ? '||' : '') + $(this).attr("data-value");
        });
    	
        $('#bizRoleId').val(optIDs);
    	
    	if($('#bizRoleId').val() == ""){
    		msglist.push(self.options.selectBizRole);
    		return false;
    	}
    	
    	// 判断业务节点ID是否为空
    	if(_isBlank($('[data-id="bizTaskId"]').val())){
    		msglist.push(self.options.taskBizIdNotNull);
    		return false;
    	}
    	
    	// 判断业务节点ID是否为数字字母组合
    	if(!_isNumAlpha($('[data-id="bizTaskId"]').val())){
    		msglist.push(self.options.taskBizIdNotNumAlpha);
    		return false;
    	}
    	
    	// 所有的约束条件中的是否启用均等于“否”时
    	if($('[data-type="timeSwitch"]').attr("data-value") == 0 && $('[data-type="functionalSwitch"]').attr("data-value") == 0 && $('[data-type="behaviourSwitch"]').attr("data-value") == 0 && $('[data-type="proveSwitch"]').attr("data-value") == 0){
    		msglist.push(self.options.setConstraint);
    		return false;
    	}
		// 时间约束启用
    	if($('[data-type="timeSwitch"]').attr("data-value") == 1){
    		var timeCheckFlag = _timeConstraint(self);
    		if(!timeCheckFlag){
        		return false;
    		}
    	}
    	// 职能约束启用
    	if($('[data-type="functionalSwitch"]').attr("data-value") == 1){
    		var functionalCheckFlag = _functionalConstraint(self);
    		if(!functionalCheckFlag){
        		return false;
    		}
    	}
    	// 行为约束启用
    	if($('[data-type="behaviourSwitch"]').attr("data-value") == 1){
    		var behaviourCheckFlag = _behaviourConstraint(self);
    		if(!behaviourCheckFlag){
        		return false;
    		}
    	}
    	// 互证约束启用
    	if($('[data-type="proveSwitch"]').attr("data-value") == 1){
    		var proveCheckFlag = _proveConstraint(self);
    		if(!proveCheckFlag){
        		return false;
    		}
    	}
    	
    	return true;
    }

    /**
     * 判断是否为空
     * @private
     */
    function _isBlank(value){
		if(value == "" || value == 0 ){
			return true;
		}else{
			return false;
		}
	}
    
    /**
     * 判断是否启用该约束
     * @private
     */
    function _hasUsed(element){
		var value = $(element).val();
		if(value == 0){
			return false;
		}else if(value == 1){
			return true;
		}
	}
    
    /**
     * check时间
     * @private
     */
    function _checkTime(sum, y1, y2, o1, o2, r1, r2){
    	
    	if(_isBlank(y1) || !_isUnsignedInteger(y1) || parseInt(y1) > parseInt(sum)){
    		return false;
    	}
    	if(_isBlank(y2) || !_isUnsignedInteger(y2) || parseInt(y1) > parseInt(y2) || parseInt(y2) > parseInt(sum)){
    		return false;
    	}
    	if(parseInt(y2) == parseInt(sum) && _isBlank(o1) && _isBlank(o2) && _isBlank(r1) && _isBlank(r2)){
    		return true;
    	}
    	if(_isBlank(o1) || !_isUnsignedInteger(o1) || parseInt(o1) > parseInt(sum) || parseInt(o1) - parseInt(y2) != 1){
    		return false;
    	}
    	if(_isBlank(o2) || !_isUnsignedInteger(o2) || parseInt(o1) > parseInt(o2) || parseInt(o2) > parseInt(sum)){
    		return false;
    	}
    	if(parseInt(o2) == parseInt(sum) && _isBlank(r1) && _isBlank(r2)){
    		return true;
    	}
    	if(_isBlank(r1) || !_isUnsignedInteger(r1) || parseInt(r1) > parseInt(sum) || parseInt(r1) - parseInt(o2) != 1){
    		return false;
    	}
    	if(_isBlank(r2) || !_isUnsignedInteger(r2) || parseInt(r1) > parseInt(r2) || parseInt(r2) != parseInt(sum)){
    		return false;
    	}
    	return true;
	}

    function _timeConstraint(self) {

    	// 本节点需要时间
		var noteEndAll = $('[data-id="noteEndAll"]').val();
		var noteEndY1 = $('[data-id="noteEndY1"]').val();
		var noteEndY2 = $('[data-id="noteEndY2"]').val();
		var noteEndO1 = $('[data-id="noteEndO1"]').val();
		var noteEndO2 = $('[data-id="noteEndO2"]').val();
		var noteEndR1 = $('[data-id="noteEndR1"]').val();
		var noteEndR2 = $('[data-id="noteEndR2"]').val();
		// 至本节点完成所需时间
		var toNoteEndAll = $('[data-id="toNoteEndAll"]').val();
		var toNoteEndY1 = $('[data-id="toNoteEndY1"]').val();
		var toNoteEndY2 = $('[data-id="toNoteEndY2"]').val();
		var toNoteEndO1 = $('[data-id="toNoteEndO1"]').val();
		var toNoteEndO2 = $('[data-id="toNoteEndO2"]').val();
		var toNoteEndR1 = $('[data-id="toNoteEndR1"]').val();
		var toNoteEndR2 = $('[data-id="toNoteEndR2"]').val();
		
		// 如果本节点需要时间=[空白 or 0] AND 至本节点完成所需时间 =[空白 or 0]
		if(_isBlank(noteEndAll) && _isBlank(toNoteEndAll)){
			msglist.push(self.options.timeConstraintMsg1);
			return false;
		}
		// 本节点需要时间不为空
		if(!_isBlank(noteEndAll)){
			if(!_isUnsignedInteger(noteEndAll)){
				msglist.push(self.options.timeConstraintMsg2);
				return false;
			}
			var checkTimeFlag = _checkTime(noteEndAll, noteEndY1, noteEndY2, noteEndO1, noteEndO2, noteEndR1, noteEndR2);
			if(!checkTimeFlag){
				msglist.push(self.options.nodeErrorMsg);
				return false;
			}
		}else{
			if(!_isBlank(noteEndY1) || !_isBlank(noteEndY2) || !_isBlank(noteEndO1) || !_isBlank(noteEndO2) || !_isBlank(noteEndR1) || !_isBlank(noteEndR2)){
				// 本节点需要时间=未设定（空白 or 0） AND 本节点需要时间预警级别被设定
				msglist.push(self.options.timeConstraintMsg3);
				return false;
			}
		}
		// 至本节点完成所需时间不为空
		if(!_isBlank(toNoteEndAll)){
			if(!_isUnsignedInteger(toNoteEndAll)){
				msglist.push(self.options.timeConstraintMsg4);
				return false;
			}
			var checkTimeFlag = _checkTime(toNoteEndAll, toNoteEndY1, toNoteEndY2, toNoteEndO1, toNoteEndO2, toNoteEndR1, toNoteEndR2);
			if(!checkTimeFlag){
				msglist.push(self.options.toNodeErrorMsg);
				return false;
			}
		}else{
			if(!_isBlank(toNoteEndY1) || !_isBlank(toNoteEndY2) || !_isBlank(toNoteEndO1) || !_isBlank(toNoteEndO2) || !_isBlank(toNoteEndR1) || !_isBlank(toNoteEndR2)){
				// 至本节点完成所需时间=未设定（空白 or 0） AND 本节点需要时间预警级别被设定
				msglist.push(self.options.timeConstraintMsg5);
				return false;
			}
		}
		// 本节点需要时间 >0 AND 至本节点完成所需时间 >0 AND 本节点需要时间 >至本节点完成所需时间
		if(noteEndAll > 0 && toNoteEndAll > 0 && parseInt(noteEndAll) > parseInt(toNoteEndAll)){
			msglist.push(self.options.timeConstraintMsg6);
			return false;
		}
		
    	// 本节点需要时间设定的时间单位与至本节点完成所需时间的时间单位必须相同
    	if(noteEndAll > 0 && toNoteEndAll > 0 && $('#timeNeedUnit').val() != $('#timeSumUnit').val()){
    		msglist.push(self.options.timeConstraintMsg8);
			return false;
    	}
    	// 判断风险清单id是否为空
    	if($('[data-id="timeRiskId"]').val() == ""){
    		msglist.push(self.options.timeConstraintMsg7);
    		return false;
    	}
    	
		return true;
    }
    
    // 职能约束
    function _functionalConstraint(self){
    	// 完成任务的岗位
    	var station = $('#postId').val();
    	if(_isBlank(station)){
    		msglist.push(self.options.functionalConstraintMsg1);
			return false;
    	}
    	// 告警级别
    	var alarmType = $('input[name="alarmLevelCompetency"]:checked').attr("data-value");
    	if(alarmType == undefined){
    		msglist.push(self.options.functionalConstraintMsg2);
			return false;
    	}
    	// 当是否是风险项目选中时，风险清单是否关联
    	if($('[data-id="isRiskCompetency"]').attr('data-value') == 1 && $('[data-id="functionalRiskId"]').val() == ""){
    		msglist.push(self.options.functionalConstraintMsg3);
    		return false;
    	}
    	return true;
    }
    
    // 行为约束
    function _behaviourConstraint(self){
    	// 匹配的规则公式
    	var formula = $('[data-id="behaviourFormula"]').val();
    	if(_isBlank(formula)){
    		msglist.push(self.options.behaviourConstraintMsg1);
			return false;
    	}
    	// 告警级别
    	var alarmType = $('input[name="alarmLevelAction"]:checked').attr("data-value");
    	if(alarmType == undefined){
    		msglist.push(self.options.behaviourConstraintMsg2);
			return false;
    	}
    	// 当是否是风险项目选中时，风险清单是否关联
    	if($('[data-id="isRiskAction"]').attr('data-value') == 1 && $('[data-id="behaviourRiskId"]').val() == ""){
    		msglist.push(self.options.behaviourConstraintMsg3);
    		return false;
    	}
    	return true;
    }
    
    // 互证约束
    function _proveConstraint(self){
    	// 匹配的规则公式
    	var formula = $('[data-id="proveFormula"]').val();
    	if(_isBlank(formula)){
    		msglist.push(self.options.proveConstraintMsg1);
			return false;
    	}
    	// 告警级别
    	var alarmType = $('input[name="alarmLevelMutually"]:checked').attr("data-value");
    	if(alarmType == undefined){
    		msglist.push(self.options.proveConstraintMsg2);
			return false;
    	}
    	// 当是否是风险项目选中时，风险清单是否关联
    	if($('[data-id="isRiskMutually"]').attr('data-value') == 1 && $('[data-id="proveRiskId"]').val() == ""){
    		msglist.push(self.options.proveConstraintMsg3);
    		return false;
    	}
    	return true;
    }
    
    // 检查是否为正整数
    function _isUnsignedInteger(a){
        var reg =/^[0-9]*[1-9][0-9]*$/;
        return reg.test(a);
    }
    
    // 检查是否为数字和字母
    function _isNumAlpha(a){
        var reg =/^[a-zA-Z0-9]*$/;
        return reg.test(a);
    }

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1);

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.constraintValidate');
            var options = typeof option == 'object' && option;

            if (!data) {
                $this.data('dcapp.constraintValidate', (data = new ConstraintValidate(this, options)));
            }

            if (typeof option == 'string') {

                data[option].apply(data, args);
            }
        })
    }

    var old = $.fn.constraintValidate;

    $.fn.constraintValidate = Plugin;
    $.fn.constraintValidate.Constructor = ConstraintValidate;
    
    $.fn.constraintValidate.noConflict = function () {
        $.fn.constraintValidate = old;
        return this;
    }
})(jQuery);