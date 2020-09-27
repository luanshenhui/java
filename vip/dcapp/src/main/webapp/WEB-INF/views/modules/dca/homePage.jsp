<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>大数据首页</title>
<link rel="stylesheet" type="text/css" href="/static/assets/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/assets/css/detail.css" />
<script src="${ctxStatic}/jquery/dist/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/assets/js/jquery.homepage.js" type="text/javascript"></script>
<script>
$(document).ready(function(){

    var v_len = $(".sub-nav li").length; //总共按钮的个数
    var v_width = $(".sub-nav li a").width() + 40;
    var n=0;
    if(v_len ==5){
    	$('.prev').addClass("disable");
    	$('.next').addClass("disable");
    }else{
    	$('.prev').removeClass("disable");
    	$('.next').removeClass("disable");
    } 
    //向左
    $(".prev").click(function(){
       
        if(!$('.sub-nav').is(':animated') && n){
           
            $('.sub-nav').animate({left:'+='+v_width},500);
            n--;
        }else{
        	$('.prev').addClass("disable");
        }
    });
    
	//向右
    $(".next").click(function(){
       
        if (!$('.sub-nav').is(':animated')&& v_len > n+5 ){
            
            $('.sub-nav').animate({left:'-='+v_width},500);
            n++;
        }else{
        	$('.next').addClass("disable");
        }
    });

});
</script>
</head>
<body>
<div class="wrap" id="homePage">
	<div class="container">
        <div class="header">
            <h1 class="header-log"><a href="${ctx}/login" target="_blank" style="cursor:pointer"><img src="/static/assets/images/logo.png"></a></h1>
            <div class="header-btn display-block" data-id="header-btn-start"><img src="/static/assets/images/header-icon-start.png"><span>自动播放</span></div>
            <div class="header-btn display-none" data-id="header-btn-stop"><img src="/static/assets/images/header-icon-stop.png"><span>暂停</span></div>
            <input type="hidden" id="refreshTime" value="${refreshTime}">
            <input type="hidden" id="frequency" value="${frequency}">
            <div class="header-nav header-nav-spac">
                <ul class="header-nav-btn">
                <li class="prev" style="margin-left:0"><a href="javascript:void(0);" >&lt;</a></li>
                    <li class="next"><a href="javascript:void(0);" >&gt;</a></li>
                </ul>
                 <ul class="sub-nav" data-role="menu">
                    <li data-role="item" data-powerId="0101"><a href="javascript:void(0);" title="重大决策"><i></i>重大决策</a> </li>
                    <li data-role="item" data-powerId="0201"><a href="javascript:void(0);" title="重大事项"><i></i>重大事项</a> </li>
                    <li data-role="item" data-powerId="0301"><a href="javascript:void(0);" title="重要人事"><i></i>重要人事</a> </li>
                    <li data-role="item" data-powerId="0401"><a href="javascript:void(0);" title="大额资金">大额资金</a> </li>
                    <li data-role="item" data-powerId="0501"><a href="javascript:void(0);" title="投资" >投资</a></li>
                    <!-- <li data-role="item" data-powerId="0601"><a href="javascript:void(0);" title="担保">担保</a></li> -->
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
			<iframe id="iframe-main" src="${ctx}/index/homepageInfo" scrolling="no" style="border:none;" width="1920" height="906" allowtransparency="true"></iframe>	
			</div>
	        <div class="footer m-t-10">截至<span data-id="closingTime">${closingTime}</span></div>
       
    </div>
</div>
</body>
</html>