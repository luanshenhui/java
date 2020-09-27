<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>页面设置管理</title>
	<meta name="decorator" content="default"/>
	<dca:resources/>
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/pageConfig.css" />
	
	<script type="text/javascript">
		$(document).ready(function() {
			
			$("#save").on("click",function(){
				// 总业务流程数
				var workflowNum = $("#workflowNum").val() || "0";
				// 系统中启动的工作流数
				var workflowCount = $("#workflowCount").val() || "0";
				if(parseInt(workflowNum) < parseInt(workflowCount)){
					alertx("输入的总业务流程数需大于等于系统中设置的流程数！");
					return false;
				}else{
					// 校验时间维度和涉及部门
					var msg = vaildate();
					if(msg){
						alertx(msg);
						return false;
					}else{
						submit_btn();
					}
				}
			});
			
			// 限制文本框只能输入数字
			$(".onlyNum").keyup(function(){
		        var tmptxt=$(this).val();     
		        $(this).val(tmptxt.replace(/\D/g,''));     
		    }).bind("paste",function(){     
		        var tmptxt=$(this).val();     
		        $(this).val(tmptxt.replace(/\D/g,''));     
		    }).css("ime-mode", "disabled");
			
			// 限制文本框只能输入0～100
			$(".only100").keyup(function(){
		        var tmptxt=$(this).val();
		        if (parseInt(tmptxt) > 100) {
		        	return $(this).val("100");
		        }     
		    })
		    
		    // 限制文本框输入不为0
			$(".minZero").keyup(function(){
		        var tmptxt=$(this).val();
		        if (parseInt(tmptxt) <= 0) {
		        	return $(this).val("1");
		        }     
		    })
		
		});
		
		// 数据校验
		function vaildate(){
			var message = "";												
			var flag = true;
			// 时间维度
			$($("#timeTable tbody tr"),this).each(function() {				
				var alarmNum = $("input[name=alarmNum]",this).val() || "0";
				var riskNum = $("input[name=riskNum]",this).val() || "0";
				if(parseInt(alarmNum) < parseInt(riskNum)){
					flag = false;
					return false;
				}				
			});	
			
			if(!flag){
				message = "输入的告警数需大于等于风险数！";
			}else{
				// 涉及部门（风险占比数值之和等于100）
				var total = 0;
				$($("#deptTable tbody tr"),this).each(function() {
					// 风险占比				
					var riskRatio = $("input[name=riskRatio]",this).val() || "0";
					total += parseInt(riskRatio);
				});
				if(total != 100){
					message = "当前占比值为："+ total +"。风险占比数值之和需等于100！";
				}
			}			
			return message;
		}
		
		// 数据提交
		function submit_btn(){
			var _data = combineData();				
			var json_str = JSON.stringify(_data);
			var url = ctx+"/dca/dcaPageConfig/saveData";			
			$.post(url,{dataList : json_str},function(result){
				document.frames("mainFrame").location.reload(true);
				alertx("保存成功！");				
			})			
		}
		
		// 组合数据
		function combineData(){
			var _data = {					
					overallDataList: [],
					timeDimensionList: [],
					involveDeptList: [],
					efficacyAnalysisList: []					
			};
			
			// 总体数据
			$($("#dataTable tbody tr"),this).each(function() {
				var obj = {				
					// 指标名称
					targetName: $(".overallData",this).text(),
					// 指标值
					targetValue: $("input[name=dataValue]",this).val()
				};
				_data.overallDataList.push(obj);
			});
			
			// 时间维度
			$($("#timeTable tbody tr"),this).each(function() {
				var obj = {
					// 季度
					quarter: $(".timeDimension",this).attr("data-value"),
					// 季度名称
					quarterName: $(".timeDimension",this).text(),
					// 告警数
					alarmNum: $("input[name=alarmNum]",this).val(),
					// 风险数
					riskNum: $("input[name=riskNum]",this).val()
				};				
				_data.timeDimensionList.push(obj);
			});
						
			// 涉及部门
			$($("#deptTable tbody tr"),this).each(function() {
				var obj = {				
					// 部门
					dept: $("input[name=riskRatio]",this).attr("data-value"),
					// 风险占比
					riskRatio: $("input[name=riskRatio]",this).val() || "0",				
				};
				_data.involveDeptList.push(obj);
			});
			
			// 综合效能分析
			$($("#efficacyTable tbody tr"),this).each(function() {
				var obj = {
					// 效能名
					efficacyName: $("input[name=efficacyValue]",this).attr("data-value"),					
					// 效能值
					efficacyValue: $("input[name=efficacyValue]",this).val(),
					// 临界值
					green: $("input[name=green]",this).val(),
					yellow: $("input[name=yellow]",this).val(),
					orange: $("input[name=orange]",this).val(),
					red: $("input[name=red]",this).val()	
				};
				_data.efficacyAnalysisList.push(obj);
			});
						
			return _data;
		}
				
	</script>
</head>
<body>
	<div class="wrap">
	    <form action="">
	        <div class="container">
	            <h2 class="title">首页设置</h2>
	            <div class= " line"></div>
	            <div class="content">
	                <p class="sub-title">总体数据：</p>
	                <p class="right m-r-20 info">说明：只能输入数字，企业效能  &le;100</p>
	                 <input id="workflowCount" type="hidden" value="${workflowCount}"/>
	                <table id="dataTable" class="table-index" border="0" cellpadding="0" cellspacing="0" >	                   
	                    <thead>
		                    <tr>
		                        <th class="right-no-border wh50">指标名称</th>
		                        <th class="wh50">指标值</th>
		                    </tr>
	                    </thead>
	                    <tbody>
	                    <c:if test="${not empty overallDataList}">
	                    	<c:forEach  items="${overallDataList}" var="data" varStatus="status">
		                    	<c:choose>
		                    		<c:when test="${data.code eq 1}">
		                    			<tr>
					                        <td class="right-no-border overallData" >${data.targetName }</td>		                        
					                        <td><input type="text" name="dataValue" class="m-r-20 onlyNum minZero" maxlength="9" value="${data.targetValue }" />分钟</td>		                        
					                    </tr>
		                    		</c:when>
		                    		<c:when test="${data.code eq 2}">
		                    			<tr>
					                        <td class="right-no-border overallData">${data.targetName }</td>
					                        <td><input type="text" id="workflowNum" name="dataValue" class="m-r-43 onlyNum" maxlength="9" value="${data.targetValue }" /></td>
					                    </tr>
		                    		</c:when>
		                    		<c:when test="${data.code eq 3}">
		                    			<tr>
					                        <td class="right-no-border overallData">${data.targetName }</td>
					                        <td><input type="text" name="dataValue" class="m-r-43 onlyNum only100" maxlength="9" value="${data.targetValue }"/></td>
					                    </tr>
		                    		</c:when>
		                    		<c:when test="${data.code eq 4}">
			                    		<tr>
					                        <td class="right-no-border overallData">${data.targetName }</td>
					                        <td><input type="text" name="dataValue" class="m-r-30 onlyNum minZero" maxlength="9" value="${data.targetValue }" />秒</td>
					                    </tr>
		                    		</c:when>
		                    	</c:choose>	                    
		                    </c:forEach>	                    
	                    </c:if>
	                    
	                    <c:if test="${empty overallDataList}">
	                    	<tr>
		                        <td class="right-no-border overallData" >刷新时间</td>		                        
		                        <td><input type="text" name="dataValue" class="m-r-20 onlyNum only100" maxlength="9" />分钟</td>		                        
		                    </tr>
		                    <tr>
		                        <td class="right-no-border overallData">总业务流程数</td>
		                        <td><input type="text" id="workflowNum" name="dataValue" class="m-r-43 onlyNum" maxlength="9" /></td>
		                    </tr>
		                    <tr>
		                        <td class="right-no-border overallData">企业效能</td>
		                        <td><input type="text" name="dataValue" class="m-r-43 onlyNum only100" maxlength="3" /></td>
		                    </tr>
		                    <tr>
		                        <td class="right-no-border overallData">自动播放频次</td>
		                        <td><input type="text" name="dataValue" class="m-r-30 onlyNum" maxlength="9" />秒</td>
		                    </tr>	                    
	                    </c:if>	                    	                   
	                    </tbody>
	                </table>
	            </div>
	            <div class="content m-t-10">
	                <p class="sub-title">时间维度：</p>
	                <p class="right m-r-20 info2">说明：告警数，风险数输入0和正整数，告警数 >= 风险数</p>
	                <table id="timeTable" class="table-index" border="0" cellpadding="0" cellspacing="0" >
	                    <thead>
	                    <tr>
	                        <th class="right-no-border">时间</th>
	                        <th class="right-no-border">告警数</th>
	                        <th>风险数</th>
	                    </tr>
	                    </thead>
	                    <tbody>
	                    <c:if test="${not empty timeDimensionList}">
	                    	<c:forEach items="${timeDimensionList }" var="timeData" varStatus="index">
	                    		<tr>
			                        <td class="right-no-border timeDimension" data-value="${timeData.quarter }">${timeData.quarterName }</td>
			                        <td class="right-no-border">
			                            <input type="text" name="alarmNum" class="onlyNum" maxlength="9" value="${timeData.alarmNum }"/>
			                        </td>
			                        <td>
			                            <input type="text" name="riskNum" class="onlyNum" maxlength="9" value="${timeData.riskNum }"/>
			                        </td>
			                    </tr>			                   
	                    	</c:forEach>
	                    </c:if>
	                    <c:if test="${empty timeDimensionList}">	                    	                    	                    
		                    <tr>
		                        <td class="right-no-border timeDimension" data-value="1">第一季度</td>
		                        <td class="right-no-border">
		                            <input type="text" name="alarmNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                        <td>
		                            <input type="text" name="riskNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                    </tr>
		                    <tr>
		                        <td class="right-no-border timeDimension" data-value="2">第二季度</td>
		                        <td class="right-no-border">
		                            <input type="text" name="alarmNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                        <td>
		                            <input type="text" name="riskNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                    </tr>
		                    <tr>
		                        <td class="right-no-border timeDimension" data-value="3">第三季度</td>
		                        <td class="right-no-border">
		                            <input type="text" name="alarmNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                        <td>
		                            <input type="text" name="riskNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                    </tr>
		                    <tr>
		                        <td class="right-no-border timeDimension" data-value="4">第四季度</td>
		                        <td class="right-no-border">
		                            <input type="text" name="alarmNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                        <td>
		                            <input type="text" name="riskNum" class="onlyNum" maxlength="9"/>
		                        </td>
		                    </tr>
	                    </c:if>
	                    </tbody>	
	                </table>
	            </div>
	            
	            <div class="content m-t-10">
	                <p class="sub-title">涉及部门：</p>
	                <p class="right m-r-20 info">说明：风险占比数输入大于等于0小于等于100的整数，添加的风险占比数值之和等于100</p>
	                <table id="deptTable" class="table-index" border="0" cellpadding="0" cellspacing="0" >
	                    <thead class="scrollthead">
	                    <tr>
	                        <th class="right-no-border">部门</th>
	                        <th>风险占比</th>
	                    </tr>
	                    </thead>
	                    <tbody class="scorllbody">
		                    <c:if test="${not empty involveDeptList}">
		                    	<c:forEach items="${involveDeptList}" var="item">
				                    <tr>
				                        <td class="right-no-border dept"> 
				                        	<c:out value="${item.dept}"></c:out>
				                        </td>
				                        <td><input type="text" name="riskRatio" class="onlyNum only100" maxlength="3" data-value="${item.dept}" value="${item.riskRatio }"  min="0" max="100"/></td>
				                    </tr>	                    
			                    </c:forEach>	                    
		                    </c:if>	
		                    <c:if test="${empty involveDeptList}">
		                    	<c:forEach items="${list}" var="item">
				                    <tr>
				                        <td class="right-no-border dept"> 
				                        	<c:out value="${item.name}"></c:out>
				                        </td>
				                        <td><input type="text" name="riskRatio" class="onlyNum only100" maxlength="3" data-value="${item.name}" min="0" max="100"/></td>
				                    </tr>	                    
			                    </c:forEach>	                    
		                    </c:if>
	                    </tbody>	
	                </table>	
	            </div>
	        
	            <div class="content m-t-10">
	                <p class="sub-title wh120">业务综合效能分析：</p>
	                <p class="right  info2">说明：临界值 绿色 &lt;黄色 &lt;橙色 &lt;红色 </p>
	                <table id="efficacyTable" class="table-index" border="0" cellpadding="0" cellspacing="0" >
	                    <thead class="scrollthead2">
	                    <tr>
	                        <th class="right-no-border">效能名</th>
	                        <th class="wh274">效能值</th>
	                        <th class="wh328">临界值</th>
	                    </tr>
	                    </thead>
	                    <tbody class="scorllbody2">
	                    	<c:if test="${not empty efficacyAnalysisList}">
	                    		<c:forEach items="${efficacyAnalysisList}" var="dict">
			                    	<tr>
				                        <td class="right-no-border efficacyName">
				                        	<c:out value="${dict.efficacyName}"></c:out>
				                        </td>
				                        <td class="right-no-border">
				                            <input type="text" name="efficacyValue" class="onlyNum" maxlength="9" data-value="${dict.efficacyName}" value="${dict.efficacyValue }"/>
				                        </td>
				                        <td class="wh350">
				                            	绿色<input type="text" class="wh30 onlyNum" name="green" maxlength="9" value="${dict.green }"/>
				                            	～黄色<input type="text" class="wh30 onlyNum" name="yellow" maxlength="9" value="${dict.yellow }"/>
				                            	～橙色<input type="text" class="wh30 onlyNum" name="orange" maxlength="9" value="${dict.orange }"/>
				                            	～红色<input type="text" class="wh30 onlyNum" name="red" maxlength="9" value="${dict.red }"/>
				                        </td>
				                    </tr>
			                    </c:forEach>
		                    </c:if>	
		                    <c:if test="${empty efficacyAnalysisList}">
			                    <c:forEach items="${dictList}" var="dict">
			                    	<tr>
				                        <td class="right-no-border efficacyName">
				                        	<c:out value="${dict.label}"></c:out>
				                        </td>
				                        <td class="right-no-border">
				                            <input type="text" name="efficacyValue" class="onlyNum" maxlength="9" data-value="${dict.label}"/>
				                        </td>
				                        <td class="wh350">
				                            	绿色<input type="text" class="wh30 onlyNum" name="green" maxlength="9"/>
				                            	～黄色<input type="text" class="wh30 onlyNum" name="yellow" maxlength="9"/>
				                            	～橙色<input type="text" class="wh30 onlyNum" name="orange" maxlength="9"/>
				                            	～红色<input type="text" class="wh30 onlyNum" name="red" maxlength="9"/>
				                        </td>
				                    </tr>
			                    </c:forEach>
		                    </c:if>
	                    </tbody>	
	                </table>
	            </div>
	            <div class="clear"></div>
	            <div class="btn-group">
	                <button id="save" class="btn m-r-20">保存</button>
	                <button id="cancel" class="btn">取消</button>
	            </div>
	        </div>
	    </form>
	</div>
</body>
</html>