<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<div id="taskConstraint">
	<div class="PopMain">
	    <form:form id="taskForm" action="" class="popForm form-horizontal" modelAttribute="dcaWorkflowTaskContentPop">
	    <div class="basicMes mainModule">
	    	<form:hidden path="wfId" data-id="wfId" />
	    	<form:hidden path="taskId" />
	        <h2>基本信息</h2>
	        <div class="mesName singleDiv">
	            <span class="spanTit label-width"><font color="red">*</font>任务节点名称：</span>
	            <form:input data-id="taskName" htmlEscape="true" maxlength="30" path="taskName" />
	        </div>
	        <div class="mesRole singleDiv">
	            <span class="spanTit label-width"><font color="red">*</font>关联业务角色：</span>
	            <div class="chkRoleD">
	            	<c:forEach items="${dcaWorkflowTaskContentPop.bizRoleIdList}" var="item">
		                <span class="chkRole">
		                	<input type="checkbox" id="${item.uuid}" class="chkR" name="bizRole" data-value="${item.uuid}" />
	                    	<label for="${item.uuid}" class="labelChk checkedOff"></label>${item.bizRoleName}
	                    </span>
					</c:forEach>
					<c:if test="${empty dcaWorkflowTaskContentPop.bizRoleIdList}">
						<span class="chkRole">暂无业务角色</span>
					</c:if>
	            </div>
	            <form:hidden data-id="bizRoleIds" path="bizRoleId" />
	        </div>
	        <div class="condtUse singleDiv">
                <span class="spanTit label-width">是否启用：</span>
            	<i class="${dcaWorkflowTaskContentPop.isShow == 0 ? 'closeImg' : 'openImg'} isOpen switch" 
            		data-id="isShow" data-value="${dcaWorkflowTaskContentPop.isShow == 0 ? 0 : 1}"></i>
            	<form:hidden path="isShow"/>
            </div>
	        <div class="mesId singleDiv">
	            <span class="spanTit label-width"><font color="red">*</font>业务节点ID：</span>
	            <form:input data-id="bizTaskId" htmlEscape="true" maxlength="15" path="bizTaskId" />
	        </div>
	    </div>
	    <div class="cstCondition mainModule">
	        <h2>约束条件</h2>
	        <ul class="TabCondt">
	            <li class="tabOn">时间约束</li>
	            <li>职能约束</li>
	            <li>行为约束</li>
	            <li>互证约束</li>
	        </ul>
	        <div class="TabTime TabMain TabMainOn" >
	            <div class="condtUse singleDiv">
	                <span class="spanTit">是否有效：</span>
	            	<i class="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'openImg' : 'closeImg'} isOpen"
	            	data-role="hasUsed" data-type="timeSwitch" data-content="timeConstraint" data-id="isEffectiveTime"
	            	data-value="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 1 : 0}" ></i>
	            	<form:hidden path="isEffectiveTime"/>
	            </div>
	            <div id="timeConstraint">
		            <div class="CondtTrigger singleDiv">
		                <span class="spanTit">触发条件：</span><br/>
		                <ul class="TriggerConUl">
		                    <li class="triggerRadio">
		                        <span>该节点任务需在  </span>
		                        <div class="trigTime">
		                        	<form:input data-id="noteEndAll" htmlEscape="true" maxlength="3" path="timeNeed" 
		                        		disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" />
		                        	<div class="selectS">
			                            <form:select path="timeNeedUnit" class="selectUnit" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}">
			                            	<form:options items="${fns:getDictList('time_interval_unit')}" itemLabel="label" itemValue="value" htmlEscape="true" />
			                            </form:select>
		                            </div>
		                        </div>内完成
		                    </li>
		                    <li class="alertY alertLi">
		                    	<form:input data-id="noteEndY1" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeStart1" /> - <form:input data-id="noteEndY2" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeEnd1" /> 内完成，告警等级为黄色 <i class="alertCircle"></i>
		                    </li>
		                    <li class="alertO alertLi">
		                    	<form:input data-id="noteEndO1" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeStart2" /> - <form:input data-id="noteEndO2" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeEnd2" /> 内完成，告警等级为橙色 <i class="alertCircle"></i>
		                    </li>
		                    <li class="alertR alertLi">
		                    	<form:input data-id="noteEndR1" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeStart3" /> - <form:input data-id="noteEndR2" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeEnd3" /> 内完成，告警等级为红色 <i class="alertCircle"></i>
		                    </li>
		                    <li class="triggerRadio">
		                        <span>自流程发起需在  </span>
		                        <div class="trigTime">
		                        	<form:input data-id="toNoteEndAll" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSum" />
		                        	<div class="selectS">
			                            <form:select path="timeSumUnit" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" class="selectUnit">
			                                <form:options items="${fns:getDictList('time_interval_unit')}" itemLabel="label" itemValue="value" htmlEscape="true" />
			                            </form:select>
		                            </div>
		                        </div>内完成本节点任务
		                    </li>
		                    <li class="alertY alertLi">
		                    	<form:input data-id="toNoteEndY1" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSumStart1" /> - <form:input data-id="toNoteEndY2" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSumEnd1" /> 内完成，告警等级为黄色 <i class="alertCircle"></i>
		                    </li>
		                    <li class="alertO alertLi">
		                    	<form:input data-id="toNoteEndO1" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSumStart2" /> - <form:input data-id="toNoteEndO2" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSumEnd2" /> 内完成，告警等级为橙色 <i class="alertCircle"></i>
		                    </li>
		                    <li class="alertR alertLi">
		                    	<form:input data-id="toNoteEndR1" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSumStart3" /> - <form:input data-id="toNoteEndR2" htmlEscape="true" maxlength="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}" path="timeSumEnd3" /> 内完成，告警等级为红色 <i class="alertCircle"></i>
		                   	</li>
		                </ul>
		            </div>
		            <div><span class="fontRed">说明：超期即为风险</span></div>
		            <div class="condtRelated singleDiv  mt-15">
		                <span class="spanTit">关联风险清单：</span>
		                <form:select path="riskIdTime" class="selectL" data-id="timeRiskId" disabled="${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'false' : 'true'}">
		                    <form:option value="" label="请选择" />
		                    <form:options items="${dcaWorkflowTaskContentPop.riskList}" itemLabel="riskName" itemValue="riskId" htmlEscape="true" />
		                </form:select>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否可以人工界定风险：</span>
		                <i class="${dcaWorkflowTaskContentPop.isManualJudgeTime == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveTime == 1 ? 'switch' : ''}" 
		                data-value="${dcaWorkflowTaskContentPop.isManualJudgeTime == 1 ? 1 : 0}" data-role="switch" data-id="isManualJudgeTime"></i>
		                <form:hidden path="isManualJudgeTime" value="${dcaWorkflowTaskContentPop.isManualJudgeTime == 1 ? 1 : 0}"/>
		            </div>
	            </div>
	            <div class="tabRemark singleDiv">
	                <span class="spanTit">说明：</span>
	                <span class="alertG">正常<i class="alertCircle"></i></span>
	                <span class="alertY">初级告警<i class="alertCircle"></i></span>
	                <span class="alertO">中级告警<i class="alertCircle"></i></span>
	                <span class="alertR">严重告警<i class="alertCircle"></i></span>
	            </div>
	        </div>
	        <div class="TabFunc TabMain">
	            <div class="condtUse singleDiv">
	                <span class="spanTit">是否有效：</span>
	                <i class="${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 'openImg' : 'closeImg'} isOpen" data-risk="riskIdCompetency" data-isRisk="isRiskCompetency"
	                data-role="hasUsed" data-type="functionalSwitch" data-content="functionalConstraint" data-id="isEffectiveCompetency" data-manualJudge="isManualJudgeCompetency"
	                data-value="${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 1 : 0}"></i>
	                <form:hidden path="isEffectiveCompetency" />
	            </div>
	            <div id="functionalConstraint">
		            <div class="CondtTrigger singleDiv">
		                <span class="spanTit">触发条件：</span><br/>
		                <div class="conTriDiv">须由
		                    <sys:treeselect id="post" name="postId" value="${dcaWorkflowTaskContentPop.postId}" labelName="postName" labelValue="${dcaWorkflowTaskContentPop.postName}"
							title="岗位" url="/sys/dcaTraceUserRole/treeData" cssClass="" allowClear="true"
							notAllowSelectParent="false" disabled="${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? '' : 'disabled'}"/>完成该节点任务
		                </div>
		            </div>
		            <p style="height: 50px;"></p>
		            <div class="alertDiv singleDiv">
		                <span class="spanTit">告警等级：</span>
		                <span class="alertSpan alertG">
		                	<i class="alertCircle"></i>
		                </span>
	                	<span class="alertSpan alertY">
	                		<form:radiobutton path="alarmLevelCompetency" htmlEscape="true" value="2" data-value="2" disabled="${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 'false' : 'true'}" />
	                    	<i class="alertCircle"></i>
	                    </span>
	                	<span class="alertSpan alertO">
	                		<form:radiobutton path="alarmLevelCompetency" htmlEscape="true" value="3" data-value="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 'false' : 'true'}" />
	                    	<i class="alertCircle"></i>
	                    </span>
	                	<span class="alertSpan alertR">
	                		<form:radiobutton path="alarmLevelCompetency" htmlEscape="true" value="4" data-value="4" disabled="${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 'false' : 'true'}" />
	                    	<i class="alertCircle"></i>
	                    </span>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否是风险项目：</span>
		                <i class="${dcaWorkflowTaskContentPop.isRiskCompetency == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 'switch' : ''}" 
		                data-role="switch" data-id="isRiskCompetency" data-risk="riskIdCompetency" data-manualJudge="isManualJudgeCompetency"
		                data-value="${dcaWorkflowTaskContentPop.isRiskCompetency == 1 ? 1 : 0}"></i>
		                <form:hidden path="isRiskCompetency" />
		            </div>
		            <div class="condtRelated singleDiv mt-15">
		                <span class="spanTit">关联风险清单：</span>
		                <form:select path="riskIdCompetency" class="selectL" data-id="functionalRiskId"  disabled="${dcaWorkflowTaskContentPop.isRiskCompetency == 1 && dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 ? 'false' : 'true'}">
		                    <form:option value="" label="请选择" />
		                    <form:options items="${dcaWorkflowTaskContentPop.riskList}" itemLabel="riskName" itemValue="riskId" htmlEscape="true" />
		                </form:select>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否可以人工界定风险：</span>
		                <i class="${dcaWorkflowTaskContentPop.isManualJudgeCompetency == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveCompetency == 1 && dcaWorkflowTaskContentPop.isRiskCompetency == 1 ? 'switch' : ''}" 
		                data-id="isManualJudgeCompetency" data-value="${dcaWorkflowTaskContentPop.isManualJudgeCompetency == 1 ? 1 : 0}"></i>
		                <form:hidden path="isManualJudgeCompetency" value="${dcaWorkflowTaskContentPop.isManualJudgeCompetency == 1 ? 1 : 0}"/>
		            </div>
		        </div>
	            <div class="tabRemark singleDiv">
	                <span class="spanTit">说明：</span>
	                <span class="alertG">正常<i class="alertCircle"></i></span>
	                <span class="alertY">初级告警<i class="alertCircle"></i></span>
	                <span class="alertO">中级告警<i class="alertCircle"></i></span>
	                <span class="alertR">严重告警<i class="alertCircle"></i></span>
	            </div>
	        </div>
	        <div class="TabBehaviour TabMain">
	            <div class="condtUse singleDiv">
	                <span class="spanTit">是否有效：</span>
	                <i class="${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'openImg' : 'closeImg'} isOpen" data-risk="riskIdAction" data-manualJudge="isManualJudgeAction"
	                data-role="hasUsed" data-type="behaviourSwitch" data-content="behaviourConstraint" data-id="isEffectiveAction" data-isRisk="isRiskAction" 
	                data-value="${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 1 : 0}"></i>
	                <form:hidden path="isEffectiveAction" />
	            </div>
	            <div id="behaviourConstraint">
		            <div class="CondtTrigger singleDiv">
		                <span class="spanTit">触发条件：</span><br/>
		                <div class="conTriDiv">
	                		<span class="label-rule">符合指标</span>
		                    <form:textarea path="computeRuleAction" htmlEscape="true" class="trigInput" rows="5" placeholder="填写计算公式" data-id="behaviourFormula" maxlength="300" disabled="${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'false' : 'true'}" />
		                    <span class="p-t-0">条件。</span>
		                </div>
		                <div class="info-text">
		                	<p>说明：</p>
		                	<p>1，适用的逻辑运算符号 “+” 加，“-”减，“*”乘，“/”除，">"大于，"<"小于，">="大于或等于，"<="小于或等于，"!="不等于，"AND"而且，"OR"或者，"0～9"数字。</p>
		                	<p>2，指标用"{}"标注；指标指：指标名称。</p>
		                	<p>3，上述输入的表达式成立时，即为风险告警的条件。</p>
		           		</div>
		            </div>
		            <div class="alertDiv singleDiv">
		                <span class="spanTit">告警等级：</span>
		                <span class="alertSpan alertG">
		                	<i class="alertCircle"></i>
		                </span>
		                <span class="alertSpan alertY">
		                	<form:radiobutton path="alarmLevelAction" htmlEscape="true" value="2" data-value="2" disabled="${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'false' : 'true'}" />
		                    <i class="alertCircle"></i>
		                </span>
		                <span class="alertSpan alertO">
		                	<form:radiobutton path="alarmLevelAction" htmlEscape="true" value="3" data-value="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'false' : 'true'}" />
		                    <i class="alertCircle"></i>
		                </span>
		                <span class="alertSpan alertR">
		                	<form:radiobutton path="alarmLevelAction" htmlEscape="true" value="4" data-value="4" disabled="${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'false' : 'true'}" />
		                    <i class="alertCircle"></i>
		                </span>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否是风险项目：</span>
		                <i class="${dcaWorkflowTaskContentPop.isRiskAction == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'switch' : ''}" 
		                 data-value="${dcaWorkflowTaskContentPop.isRiskAction == 1 ? 1 : 0}" data-risk="riskIdAction" data-manualJudge="isManualJudgeAction"
		                 data-role="switch" data-id="isRiskAction"></i>
		                <form:hidden path="isRiskAction" />
		            </div>
		            <div class="condtRelated singleDiv  mt-15">
		                <span class="spanTit">关联风险清单：</span>
		                <form:select path="riskIdAction" class="selectL" data-id="behaviourRiskId" disabled="${dcaWorkflowTaskContentPop.isRiskAction == 1 && dcaWorkflowTaskContentPop.isEffectiveAction == 1 ? 'false' : 'true'}">
		                    <form:option value="" label="请选择" />
		                    <form:options items="${dcaWorkflowTaskContentPop.riskList}" itemLabel="riskName" itemValue="riskId" htmlEscape="true" />
		                </form:select>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否可以人工界定风险：</span>
		                <i class="${dcaWorkflowTaskContentPop.isManualJudgeAction == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveAction == 1 && dcaWorkflowTaskContentPop.isRiskAction == 1 ? 'switch' : ''}" 
		                data-value="${dcaWorkflowTaskContentPop.isManualJudgeAction == 1 ? 1 : 0}" data-id="isManualJudgeAction"></i>
		                <form:hidden path="isManualJudgeAction" value="${dcaWorkflowTaskContentPop.isManualJudgeAction == 1 ? 1 : 0}"/>
		            </div>
		        </div>
	            <div class="tabRemark singleDiv">
	                <span class="spanTit">说明：</span>
	                <span class="alertG">正常<i class="alertCircle"></i></span>
	                <span class="alertY">初级告警<i class="alertCircle"></i></span>
	                <span class="alertO">中级告警<i class="alertCircle"></i></span>
	                <span class="alertR">严重告警<i class="alertCircle"></i></span>
	            </div>
	        </div>
	
	        <div class="TabMutually TabMain">
	            <div class="condtUse singleDiv">
	                <span class="spanTit">是否有效：</span>
	                <i class="${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'openImg' : 'closeImg'} isOpen" data-risk="riskIdMutually" data-manualJudge="isManualJudgeMutually"
	                data-role="hasUsed" data-type="proveSwitch" data-content="proveConstraint" data-id="isEffectiveMutually" data-isRisk="isRiskMutually" 
	                data-value="${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 1 : 0}"></i>
	                <form:hidden path="isEffectiveMutually" />
	            </div>
	            <div id="proveConstraint">
		            <div class="CondtTrigger singleDiv">
		                <span class="spanTit">触发条件：</span><br/>
		                <div class="conTriDiv">
		                	<span class="label-rule">符合指标</span>
		                    <form:textarea path="computeRuleMutually" htmlEscape="true" class="trigInput" rows="5" placeholder="填写计算公式" data-id="proveFormula" maxlength="300" disabled="${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'false' : 'true'}" />
		                    <span class="p-t-0">条件的业务流程。</span>
		                </div>
		                <div class="info-text">
		                	<p>说明：</p>
		                	<p>1，适用的逻辑运算符号 “+” 加，“-”减，“*”乘，“/”除，">"大于，"<"小于，">="大于或等于，"<="小于或等于，"!="不等于，"AND"而且，"OR"或者，"0～9"数字。</p>
		                	<p>2，指标用"{}"标注；指标指：指标名称。</p>
		                	<p>3，上述输入的表达式成立时，即为风险告警的条件。</p>
		           		</div>
		            </div>
		            <div class="alertDiv singleDiv">
		                <span class="spanTit">告警等级：</span>
		                <span class="alertSpan alertG">
		                	<i class="alertCircle"></i>
		                </span>
		                <span class="alertSpan alertY">
		                	<form:radiobutton path="alarmLevelMutually" htmlEscape="true" value="2" data-value="2" disabled="${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'false' : 'true'}" />
		                    <i class="alertCircle"></i>
		                </span>
		                <span class="alertSpan alertO">
		                	<form:radiobutton path="alarmLevelMutually" htmlEscape="true" value="3" data-value="3" disabled="${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'false' : 'true'}" />
		                    <i class="alertCircle"></i>
		                </span>
		                <span class="alertSpan alertR">
		                	<form:radiobutton path="alarmLevelMutually" htmlEscape="true" value="4" data-value="4" disabled="${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'false' : 'true'}" />
		                    <i class="alertCircle"></i>
		                </span>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否是风险项目：</span>
		                <i class="${dcaWorkflowTaskContentPop.isRiskMutually == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'switch' : ''}" 
		                data-value="${dcaWorkflowTaskContentPop.isRiskMutually == 1 ? 1 : 0}" data-risk="riskIdMutually" data-manualJudge="isManualJudgeMutually"
		                data-role="switch" data-id="isRiskMutually"></i>
		                <form:hidden path="isRiskMutually" />
		            </div>
		            <div class="condtRelated singleDiv  mt-15">
		                <span class="spanTit">关联风险清单：</span>
		                <form:select path="riskIdMutually" class="selectL" data-id="proveRiskId" disabled="${dcaWorkflowTaskContentPop.isRiskMutually == 1 && dcaWorkflowTaskContentPop.isEffectiveMutually == 1 ? 'false' : 'true'}">
		                    <form:option value="" label="请选择" />
		                    <form:options items="${dcaWorkflowTaskContentPop.riskList}" itemLabel="riskName" itemValue="riskId" htmlEscape="true" />
		                </form:select>
		            </div>
		            <div class="condtDefine singleDiv">
		                <span class="spanTit">是否可以人工界定风险：</span>
		                <i class="${dcaWorkflowTaskContentPop.isManualJudgeMutually == 1 ? 'openImg' : 'closeImg'} isOpen ${dcaWorkflowTaskContentPop.isEffectiveMutually == 1 && dcaWorkflowTaskContentPop.isRiskMutually == 1 ? 'switch' : ''}" 
		                data-value="${dcaWorkflowTaskContentPop.isManualJudgeMutually == 1 ? 1 : 0}" data-id="isManualJudgeMutually"></i>
		                <form:hidden path="isManualJudgeMutually" value="${dcaWorkflowTaskContentPop.isManualJudgeMutually == 1 ? 1 : 0}"/>
		            </div>
		        </div>
	            <div class="tabRemark singleDiv">
	                <span class="spanTit">说明：</span>
	                <span class="alertG">正常<i class="alertCircle"></i></span>
	                <span class="alertY">初级告警<i class="alertCircle"></i></span>
	                <span class="alertO">中级告警<i class="alertCircle"></i></span>
	                <span class="alertR">严重告警<i class="alertCircle"></i></span>
	            </div>
	        </div>
	    </div>
	    </form:form>
	</div>
</div>