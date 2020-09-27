<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>大数据首页</title>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<script src="${ctxStatic}/jquery/dist/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/gzw/js/jquery.homepage.js" type="text/javascript"></script>
</head>
<body>
<div class="wrap" id="homePage-gzw">
	<div class="container">
        <div class="header">
            <h1 class="header-log"><a href="${ctx}/login" target="_blank" style="cursor:pointer"><img src="/static/gzw/image/logo.png"></a></h1>
            <div class="header-btn display-block" data-id="header-btn-start"><img src="/static/assets/images/header-icon-start.png"><span>自动播放</span></div>
            <div class="header-btn display-none" data-id="header-btn-stop"><img src="/static/assets/images/header-icon-stop.png"><span>暂停</span></div>
            <input type="hidden" id="refreshTime" value="${refreshTime}">
            <input type="hidden" id="frequency" value="${frequency}">
            <input type="hidden" data-id="pageIndex" value="${pageIndex}">
            <div class="header-nav header-nav-spac">
                <ul class="header-nav-btn">
                <li class="prev" style="margin-left:0"><a href="javascript:void(0);" >&lt;</a></li>
                    <li class="next"><a href="javascript:void(0);" >&gt;</a></li>
                </ul>
                <ul class="sub-nav" data-role="menu">
					<li data-role="item" data-powerId="businessDataVolume"><a href="javascript:void(0)" title="融合分析"><i></i>融合分析</a> </li>
					<li data-role="item" data-powerId="threeImportant1"><a href="javascript:void(0)" title="三重一大">三重一大</a> </li>
					<li data-role="item" data-powerId=""><a href="javascript:void(0)" title="财务分析" >财务分析</a> </li>
					<li data-role="item" data-powerId=""><a href="javascript:void(0)" title="产权分析"  >产权分析</a> </li>
				</ul>
            </div>
            <div class="header-nav">
                <ul  data-role="menu">
                     <li data-role="item" data-powerId="duty"><a href="javascript:void(0);" title="监管职责"><i></i>监管职责</a> </li>
                     <li data-role="item" data-powerId="workflowinstruction"><a href="javascript:void(0);" title="流程说明">流程说明</a> </li>
                     <li data-role="item" data-powerId="riskpoint"><a href="javascript:void(0);" title="风险点" >风险点</a> </li>
                </ul>
            </div>
        </div>
        <div class="mainbox">
			<iframe id="iframe-main_${pageIndex}" src="${ctx}/gzw/homepageInfo?pageIndex=${pageIndex}" scrolling="no" style="border:none;" width="1920" height="906" allowtransparency="true"></iframe>	
		</div>
        <div class="footer m-t-10">截至<span data-id="closingTime">${closingTime}</span></div>
    </div>
</div>
</body>
</html>