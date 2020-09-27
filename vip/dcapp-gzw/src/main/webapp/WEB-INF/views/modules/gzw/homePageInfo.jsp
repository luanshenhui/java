<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<script src="${ctxStatic}/jquery/dist/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<script src="/static/gzw/js/jquery.homepageInfo.js" type="text/javascript"></script>
<div id="homePageInfoGZW" class="wrap">
	<div class="container">
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
					<div class="big-box">
						<div class="small-box-form6" id="riskScatter" ></div>
					</div>
		        </div>	
			</div>
		</div>
    </div>
</div>
