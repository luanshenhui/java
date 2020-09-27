/**
 * 物理表管理新建、编辑
 */

+(function($) {

	function TopicPhysics(element, options) {

		this.$element = $(element);

		this.options = $.extend({},
								{msg1:'新建的物理表在数据库中已存在，请修改物理表英文名！',
								 msg2:'当前物理表中数据存在，保存后，物理表将按照新的结构重建，表中数据将被清除！！！是否确定保存？',
								 msg3:'字段（英文）已存在，是否覆盖字段信息？',
								 msg4:'新建物理表表名不能为空！',
								 msg5:'新建物理表至少一条以上字段信息！',
								 msg6:'新建物理表至少一条以上字段信息！',
								 msg7:'当前物理表中没有数据，保存后，物理表将按照新的结构重建！是否确定保存？'
								},
								options);
		
		_buildEvent.call(this);
		
		_itemDisplay();

	}

	/**
	 * 字段信息操作事件绑定
	 * 
	 */
	function _buildEvent() {

		var $this = this;
		
		var _columnNameList = [];

		this.$element
		// 数据类型change实践，控制是否显示小数位数设置选项
		.on('change', '.columnType', function(e) {

			_itemDisplay();

		})
		
		// 保存-物理表字段保存
		.on('click', '.btnColumnSave', function() {
				
			if ($("#topicPhysicsTableForm").valid()) {
				
				// 当前字段英文名
				var _columnName = $(".columnName").val();
				
				$.get(ctx+'/dca/dcaTopicPhysics/checkColumnName', {name : _columnName}, function (res) {
					
					// 字段英文名重复验证
					if (res=="true"){
						// 确认则覆盖原有数据
		        		confirmx($this.options.msg3, function(){
		        			
		        			$("#topicPhysicsTableForm")
		    		        
		    		        .attr('action',ctx+'/dca/dcaTopicPhysics/columnAdd')
		    		        
		    		        .get(0).submit();  
						});
					} else {
						
						$("#topicPhysicsTableForm")
	    		        
	    		        .attr('action',ctx+'/dca/dcaTopicPhysics/columnAdd')
	    		        
	    		        .get(0).submit();  
					}
				});
				
				
			}
		})
		// 保存-物理表
		.on('click', '#tphSubmit', function() {
			
			// 物理表英文名
			var _tableName = $(".tableName").val();
			
			if (_tableName) {
				
				// 字段条数
				var _rowCount = $("#tbody tr[data-item='row']").length;

				if (_rowCount > 0) {
					
					 $.get(ctx+'/dca/dcaTopicPhysics/checkTableName', {name : _tableName}, function (result) {
							var res = JSON.parse(result);
							// 判断新建的场合物理表是否存在
							if (res.existFlag=="true") {
								
								
								alertx($this.options.msg1)
							} else {
								var _oldName = $("#oldIdxName").val();
								var _tableName = $(".tableName").val();
								if (_oldName == _tableName) {
									//判断物理表中是否存在数据
									var msgStr;
									if(res.hasData == "true"){
										//表中存在数据
										msgStr = $this.options.msg2;
									} else {
										msgStr = $this.options.msg7;
									}
									confirmx(msgStr, function(){

										$("#topicPhysicsTableForm")

											.attr('action',ctx+'/dca/dcaTopicPhysics/tableSave')

											.get(0).submit();
									});
								} else {
									$("#topicPhysicsTableForm")
							        
							        .attr('action',ctx+'/dca/dcaTopicPhysics/tableSave')
							        
							        .get(0).submit();  
								}
							}
						});
					
				} else {
					alertx($this.options.msg5)
				}
				 
			 } else {
				 alertx($this.options.msg4)
			 }
				
		})// 保存-物理表
		.on('click', '#tphCancel', function() {
			window.location.href=ctx+'/dca/dcaTopicPhysics/list'; 
			
		});
	}

	/**
	 * 字段属性信息添加后，所有选项值初始化
	 * 
	 */
	function _inputFormClear() {
		
		// 英文名、中文名、位数、小数点、主键、是否唯一、是否为空、默认值值清空
		$(".columItem").val("");
		
		// 数据类型初始化
		$(".columnType option:first").prop("selected", 'selected');
	}
	
	
	/**
	 * 字段属性信息添加后，所有选项值初始化
	 * 
	 */
	function _itemDisplay() {
		
		var _type = $(".columnType option:selected").val();
		
		// 判断数据类型是否为number类型
		if (_type == 1) {
			
			// 显示小数位数dom结构
			$("#decimalDigitsDiv").removeClass("hide");
			
		} else {
			
			// 隐藏小数位数dom结构
			$("#decimalDigitsDiv").addClass("hide");
			// 数据清空
			$(".decimalDigits").val("");
		}
		
		// date类型
		if (_type == 4 || _type == 5) {

			// 隐藏位数dom结构
			$("#dataLengthDiv").addClass("hide");
			// 隐藏默认值dom结构
			$("#colDefaultDiv").addClass("hide");
			
		} else {
			
			// 显示位数dom结构
			$("#dataLengthDiv").removeClass("hide");
			// 显示默认值dom结构
			$("#colDefaultDiv").removeClass("hide");
		}

	}
	
	/**
	 * 去空格，转译处理
	 * 
	 */
	function _trim(_item) {
		
		if (_item) {
			
			if (_item =='undefined') {
				
				return "";
			} else {
				return $.trim(_item);
			}
			
		} else {
			return "";
		}
	}
	
	function Plugin(option) {

		var args = Array.prototype.slice.call(arguments, 1);

		return this.each(function() {
			
			var $this = $(this);
			var data = $this.data('dcapp.topicPhysics');
			var options = typeof option == 'object' && option;

			if (!data) {
				
				$this.data('dcapp.topicPhysics',
						(data = new TopicPhysics(this, options)));
			}
			if (typeof option == 'string') {
				
				data[option].apply(data, args);
			}
		})
	}

	var old = $.fn.topicPhysics;

	$.fn.topicPhysics = Plugin;
	$.fn.topicPhysics.Constructor = TopicPhysics;

	$.fn.topicPhysics.noConflict = function() {
		
		$.fn.topicPhysics = old;
		return this
	}

})(jQuery);

$(function() {
	
	// 初始化调用
	$('#topicPhysicsBody').topicPhysics({});

	// 自定义校验（物理表英文名校验）
	jQuery.validator.addMethod("tableNameCheck",function(value, element) {
		
		// 自定义开头格式
		var begin = new RegExp("DCA_PHY_");
		
		// 表名的头的格式限定
		if (!begin.test(value)) {
			
			return this.optional(element) || false;
			
		// 验证方法-只允许输入数字、字母、下划线，并且长度在1~25
		} else if ( !/^[a-zA-Z][a-zA-Z0-9_]{0,24}$/.test(value)) {
			
			return this.optional(element) || false;
		} else {
			
			// 合法格式
			return this.optional(element) || true;
		}
		
	},"允许输入数字、字母、下划线，并以'DCA_PHY_'开头的长度为1~25的名称");
	
	// 自定义校验（物理表中文名校验）
	jQuery.validator.addMethod("tableCommentCheck", function(value, element) {
		
		// 验证方法-只允许输入汉字，并且长度在1~25
	    return this.optional(element) || /^[\u4e00-\u9fa5]{1,25}$/.test(value);
	    
	    
	}, "允许输入1-25个汉字的名称");
	
  	
	// 自定义校验（物理表的字段名（英文）验证方法）
	jQuery.validator.addMethod("columnNameCheck",function(value, element) {
		
		// 自定义开头格式
		var begin = new RegExp("[a-zA-Z]");
		
		// 字段名称（英文）必须以字母开头
		if (!begin.test(value)) {
			
	  		return this.optional(element) || false;
	  		
	  	// 只允许输入数字、字母、下划线，并且长度在1~20	
		} else if (!/^[a-zA-Z][a-zA-Z0-9_]{0,19}$/.test(value)) {
			return this.optional(element) || false;
			
		} else {
			
			// 合法格式
			return this.optional(element) || true;
		}
		
	},"允许输入数字、字母、下划线，并以字母开头的长度为1~20的名称");
	
	
	// 自定义校验（字段中文名校验-只允许输入汉字，并且长度在1~10）
	jQuery.validator.addMethod("columnCommentCheck", function(value, element) {
		
	    return this.optional(element) || /^[\u4e00-\u9fa5]{1,10}$/.test(value);
	    
	}, "字段名(中文)只能为1-10个汉字");
	
	// 自定义校验（字段中文名校验-只允许输入汉字，并且长度在1~10）
	jQuery.validator.addMethod("requiredType", function(value, element) {
		
		 var _type = $(".columnType option:selected").val();
		 
		 if (_type < 4) {
			 
			 if ($.trim(value) === "") {
				 return this.optional(element) || false;
			 } else {
				 return this.optional(element) || true;
			 }
			 
		 } else {
			 return this.optional(element) || true;
		 }
		
	   
	    
	}, "位数不能为空");
  	
     // 自定义校验（验证方法-数据类型（number）的小数不能大于位数）
  	jQuery.validator.addMethod("dataLengthMax", function(value,element) {
  		
        var sumreward = $(".dataLength").val();
        var _type = $(".columnType option:selected").val();
        if (!/^[0-9_]{0,12}$/.test(value)) {
        	return this.optional(element) || false;
        }
        
        if (_type == 1) {
            if (13 < sumreward){

    			return this.optional(element) || false;
            } 
        } else {
        	if (2000 < sumreward){

    			return this.optional(element) || false;
            }
        }

    	return this.optional(element) || true;
           
    }, "NUMBER类型的数据长度不能大于13,NVARCHAR2和NCHAR不能大于2000");
  	
  	 // 自定义校验（验证方法-数据类型（number）的小数不能大于位数）
  	jQuery.validator.addMethod("equelTOdataLength", function(value,element) {
  		
        var sumreward = $(".dataLength").val();
 
    	return this.optional(element) || Number(sumreward) > Number(value);
           
    }, "小数不能大于位数");
  	
    // 物理表字段属性信息校验
	$("#topicPhysicsTableForm").validate({
		
		ignore: "input.select2-offscreen,input.select2-input",
		// 校验对象（物理表英文名、物理表中文）
		onfocusout : function(element){$(element).valid();},
        debug: true,
        // 校验对象（字段英文名、中文名、数据类型、位数、小数点）
        rules: {
			tableName: {
				
	    		required : true,
	    		// 自定义校验方法
	    		tableNameCheck : true
			},
			tableComment: {
				// 自定义校验方法
				maxlength: 25
			},
			"currentFiled.columnName": {
    		
        		required : true,
        		// 自定义校验方法-格式
        		columnNameCheck : true
        		
    		},
    		"currentFiled.columnComment": {
   			
        		required : true,
        		// 自定义校验方法
        		maxlength: 10
    		},
    		"currentFiled.columnType": {
       			
        		required : true
    		},
    		"currentFiled.dataLength": {
    			requiredType : true,
    			digits :true,
        		dataLengthMax : true
    		},
    		"currentFiled.decimalDigits": {
    			equelTOdataLength : true,
    			digits:true,
    			max:4,
    			min: 0
    		}
        },
        // 校验对象非法对应的校验信息
        messages: {
	    	tableName: {
	    		
				required : "物理表（英文）不能为空！"
			},
			tableComment: {
			},
        	
			"currentFiled.columnName": {
    			
    			required : "字段名(英文)不能为空！"
    		},
    		"currentFiled.columnComment": {
    			
    			required : "字段名(中文)不能为空"
    		},
    		"currentFiled.columnType": {
    			
    			required : "数据类型不能为空"
    		},
    		"currentFiled.dataLength": {
    			
        		required : "位数不能为空",
        		digits : "请输入整数"
    		},
    		"currentFiled.decimalDigits": {
    			equelTOdataLength : "小数点位数不能大于长度",
    			digits : "小数点只能是整数"
    		}
        }
    });
})
