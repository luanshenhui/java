<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<link rel="stylesheet" type="text/css" href="/static/assets/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/assets/css/detail.css" />
<script src="${ctxStatic}/jquery/dist/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<script src="/static/assets/js/jquery.homepageInfo.js" type="text/javascript"></script>
<div id="homePageInfo" class="wrap">
	<div>
        <div class="mainbox">
			<div class="box" id="box">
				<div class="left m-r-20">
					<div class="small-box">
						<div id="businessGauge" class="businessGauge">
						</div>
						<div class="absoluteSpan businessSpan">企业能效</div>
						<div class="absoluteSpan businessDataSpan">业务数据量</div>
					</div>
					<div class="small-box hg-310">
						<div class="l-title">
							<span>风险等级 / 告警等级</span>
							<p class="right">
								<span class="end"></span><span class="m-r-20 font-size12">已处理</span>
							</p>
						</div>
						<div class="l-content">
							<div>红色<span class="red-font">风险</span>
							<p>
								<span class="line-font green" data-id="riskGR"></span><span class="line-font red " data-id="riskRR"></span>
							</p>
							<span class="right m-r-20" data-id="riskRCount"></span>
							</div>
							<div>橙色<span class="red-font">风险</span>
							<p>
							<span class="line-font green" data-id="riskGO"></span><span class="line-font orange " data-id="riskOO"></span>
							</p>
	
							<span class="right m-r-20" data-id="riskOCount"></span>
							</div>
							<div>黄色<span class="red-font">风险</span>
							<p>
							<span class="line-font green" data-id="riskGY"></span><span class="line-font yellow " data-id="riskYY"></span>
							</p>
							<span class="right m-r-20" data-id="riskYCount"></span>
							</div>
						</div>
						<div class="line"></div>
						<div class="l-content">
							<div>红色<span class="yellow-font">告警</span>
							<p>
								<span class="line-font green" data-id="alarmGR"></span><span class="line-font red " data-id="alarmRR"></span>
							</p>
	
							<span class="right m-r-20" data-id="alarmRCount"></span>
							</div>
	
							<div>橙色<span class="yellow-font">告警</span>
							<p>
							<span class="line-font green" data-id="alarmGO"></span><span class="line-font orange " data-id="alarmOO"></span>
							</p>
	
							<span class="right m-r-20" data-id="alarmOCount"></span>
							</div>
							<div>黄色<span class="yellow-font">告警</span>
							<p>
							<span class="line-font green" data-id="alarmGY"></span><span class="line-font yellow" data-id="alarmYY"></span>
							</p>
							<span class="right m-r-20" data-id="alarmYCount"></span>
							</div>
						</div>
					</div>
					<div class="small-box hg-254">
						<div id="dataEngine" class="dataEngine"></div>
					</div>
				</div>
		        <div class="center-box left">
		        	<div class="c-logo"><span>业务综合效能分析</span></div>
		        	<div id="businessAnalysis" class="businessAnalysis"></div>
		        	<!-- <div class="radarMarks" id="radarMarks">
		        		<span class="gRect"></span>无风险
		        		<span class="yRect"></span>黄色告警
		        		<span class="oRect"></span>橙色告警
		        		<span class="rRect"></span>红色告警
		        	</div> -->
		        	<div id="businessAnalysisHidden" class="hiddenDiv">暂无相关数据</div>
		        </div>
		        <div class="right m-l-20">
		        	<div class="small-box">
						<div id="alarmRiskState" class="alarmriskstate"></div>
						<div id="alarmriskstateHidden" class="hiddenDiv">暂无告警风险对比相关数据</div>
					</div>
					<div class="small-box">
						<div id="riskDeptInfo" class="riskDeptInfo"></div>
						<div id="riskSpan" class="absoluteSpan riskDeptSpan">风险</div>
						<div id="riskDeptInfoHidden" class="hiddenDiv">暂无各部门风险状况相关数据</div>
					</div>
					<div class="small-box">
						<div class="xs-title">
							<span>覆盖业务</span>
							<span class="right font-42" data-id="overlayService"></span>
						</div>
						<ul class="content-list">
							<li>
								<p class="icon">
									<span class="sub-icon icon01"></span>
								</p>
								<p class="describe ">
								<span>职责清单</span>
								<span class="num" data-id="dutyList"></span>
								</p>
							</li>
							<li>
								<p class="icon">
									<span class="sub-icon icon02"></span>
								</p>
								<p class="describe">
								<span>涉及部门</span>
								<span class="num" data-id="involvedDept"></span>
								</p>
							</li>
						</ul>
						<div class="line"></div>
						<ul class="content-list">
							<li>
								<p class="icon">
									<span class="sub-icon icon03"></span>
								</p>
								<p class="describe ">
								<span>关键流程</span>
								<span class="num" data-id="keyProcess"></span>
								</p>
							</li>
							<li>
								<p class="icon">
									<span class="sub-icon icon04"></span>
								</p>
								<p class="describe">
								<span>风险点</span>
								<span class="num" data-id="riskPoint"></span>
								</p>
							</li>
						</ul>
					</div>
		        </div>	
			</div>
		</div>
		<!-- <div class="clear"></div>
		<div class="footer">截至<span data-id="closingTime"></span></div>  -->
    </div>
</div>
