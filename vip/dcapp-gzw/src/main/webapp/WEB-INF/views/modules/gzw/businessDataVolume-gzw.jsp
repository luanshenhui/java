<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<title>数据铁笼-融合分析-业务数据量</title>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/model.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/risk-level.css" />
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/gzw/js/echarts.min.js"></script>
<script src="/static/gzw/js/jquery-1.8.3.js"></script>
<script src="/static/gzw/js/jquery.fusion.analysis.js" type="text/javascript"></script>

<div class="wrap" id="fusionAnalysisGZW">
	<div class="container">
		<div class="box">
			<div class="box-head">
				<a href="${ctx}/gzw/homepageInfo" class="arrow-back"><i></i>首页</a>
                <p class="box-title">融合分析</p>
                <!--<a href="javascript:void(0)" class="arrow-left"><i></i></a>
                <a href="javascript:void(0)" class="arrow-right"><i></i></a>-->
			</div>
            <div class="box-container">
                <div class="box-left">
                    <ul>
                        <li class="on" data-id="biz">
                            <a href="javascript:void(0)">业务数据量</a>
                        </li>
                        <li data-id="riskLevel">
                            <a href="javascript:void(0)">风险等级</a>
                        </li>
                        <li data-id="riskDefine">
                            <a href="javascript:void(0)">风险界定</a>
                        </li>
                        <li data-id="alarmLevel">
                            <a href="javascript:void(0)" >告警等级</a>
                        </li>
                    </ul>
                </div>
                <div class="box-right">
                    <div class="box-right-title">
                        <p data-id="fusionAnalysisTitle"><i></i>业务数据量</p>
                        <input type="hidden" id="">
                    </div>
                    <div class="box-right-form risk-level">
                    	<div class="risk-color" data-id="fusionAnalysisColor"></div>
                        <div class="risk-form-main" data-id="main-fusionAnalysis"></div>
                    </div>
                </div>
                <div class="clear"></div>
            </div>

		</div>
	</div>
</div>