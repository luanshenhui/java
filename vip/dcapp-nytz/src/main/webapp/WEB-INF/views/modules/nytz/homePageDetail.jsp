<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="/static/nytz/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/nytz/css/detail.css" />
<script src="${ctxStatic}/jquery/dist/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/echarts/echarts.min.js" type="text/javascript"></script>
<script src="/static/nytz/js/jquery.homepage.detail.js" type="text/javascript"></script>
<script src="/static/nytz/js/jquery.redirect.js" type="text/javascript"></script>
<div class="wrap" id="homePageDetail">
    <div>
        <div class="t-box">
            <div class="index left">
                <a href="${ctx}/index/homepageInfo"><i></i><span class="index-bg"></span><span>首页</span></a>
            </div>

            <div class="t-box-title left" data-id="powerTitle"></div>
			<input type="hidden" id="powerId" value="${powerId}">
            <!-- <div class="right btn-group">
                <ul class="btn">
                    <li class="prev-btn"><span></span><a href="#" ><i class="left-arrow"></i></a></li>
                    <li class="next-btn"><span></span><a href="#" ><i class="right-arrow"></i></a></li>
                </ul>
            </div> -->
        </div>
        <div class="clear"></div>
        <div class="detail-box">
            <div class="left m-r-20 left-box">
                <div class="xs-box hg-100">
                    <div class="xs-title">
                        <span>覆盖业务</span>
                        <span class="right font-42 bold" data-id="overlayService"></span>
                    </div>
                </div>
                <div class="xs-box">
                        <div class="l-title">
                            <span>风险等级</span>
                            <p class="right">
                                <span class="end"></span><span class="m-r-20 font-size12">已处理</span>
                            </p>
                        </div>
                    <div class="line2"></div>
                        <div class="l-content m-t-25">
                            <div>红色<span class="red-font">风险</span>
                                <p>
                                    <span class="line-font green" data-id="riskGR"></span><span class="line-font red" data-id="riskRR"></span>
                                </p>
                                <span class="right m-r-20" data-id="riskRCount"></span>
                            </div>
                            <div>橙色<span class="red-font">风险</span>
                                <p>
                                    <span class="line-font green" data-id="riskGO"></span><span class="line-font orange" data-id="riskOO"></span>
                                </p>

                                <span class="right m-r-20" data-id="riskOCount"></span>
                            </div>
                            <div>黄色<span class="red-font">风险</span>
                                <p>
                                    <span class="line-font green" data-id="riskGY"></span><span class="line-font yellow" data-id="riskYY"></span>
                                </p>
                                <span class="right m-r-20" data-id="riskYCount"></span>
                            </div>
                        </div>
                    </div>
                <div class="xs-box">
                        <div class="l-title">
                            <span>告警等级</span>
                            <p class="right">
                                <span class="end"></span><span class="m-r-20 font-size12">已处理</span>
                            </p>
                        </div>
                    <div class="line2"></div>
                        <div class="l-content m-t-25" data-id="alram">
                            <div>红色<span class="yellow-font">告警</span>
                                <p>
                                    <span class="line-font green" data-id="alarmGR"></span><span class="line-font red" data-id="alarmRR"></span>
                                </p>

                                <span class="right m-r-20" data-id="alarmRCount"></span>
                            </div>

                            <div>橙色<span class="yellow-font">告警</span>
                                <p>
                                    <span class="line-font green" data-id="alarmGO"></span><span class="line-font orange" data-id="alarmOO"></span>
                                </p>

                                <span class="right m-r-20" data-id="alarmOCount"></span>
                            </div>
                            <div>黄色<span class="yellow-font">告警</span>
                                <p>
                                    <span class="line-font green" data-id="alarmGY"></span><span class="line-font yellow" data-id="alarmYY"></span>
                                </p><span class="right m-r-20" data-id="alarmYCount"></span>
                            </div>
                        </div>
                </div>

                <div class="xs-box hg-237">
					<div id="dataEngine" class="dataEngine"></div>
                </div>
            </div>
            <div class="center-box2 left m-l-10" data-id="middleImg">
            </div>
            <div class="pop-up">
                <div class="pop-up-box">
                    <a class="close"></a>
                    <h2>财务部审批</h2>
                    <div class="alarm">
                        <i class="alarm-icon"></i><span class="yellow-font m-l-10">告警数</span>:<span>24</span>
                        <ul>
                            <li>时间约束：<span>10</span></li>
                            <li>互证约束：<span>6</span></li>
                            <li>职能约束：<span>4</span></li>
                            <li>行为约束：<span>4</span></li>
                        </ul>
                    </div>
                    <div class="risk">
                        <i class="risk-icon m-b-10"></i><span class="red-font m-l-10 m-b-10">风险数</span>:<span>18</span>
                        <ul>
                            <li>时间约束：<span>9</span></li>
                            <li>互证约束：<span>3</span></li>
                            <li>职能约束：<span>4</span></li>
                            <li>行为约束：<span>5</span></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="right m-l-20">
                <div class="long-box">
                    <p>系统播报</p>
                    <div id="systemScroll" class="hg-720 overflow-h">
	                    <ul id="sp"></ul>
                    </div>
                    <div id="systemScrollHidden" class="hiddenDiv">暂无相关数据</div>
                </div>
            </div>
        </div>
       <!--  <div class="clear"></div>
        <div class="footer">截至<span data-id="closingTime"></span></div> -->

    </div>
</div>
<script>
   $(document).ready(function(){
        var myar = setInterval('autoScroll("#systemScroll")', 3000);
        //当鼠标放上去的时候，滚动停止，鼠标离开的时候滚动开始
        $("#systemScroll").hover(
       		function () {
       			clearInterval(myar); 
       		}, 
       		function () { 
       			myar = setInterval('autoScroll("#systemScroll")', 3000);
       		}
        );
       
   }); 
   
   function autoScroll(obj){
   		$(obj).find("#sp:first").animate({marginTop: "-80px"}, 3000, function() {
		   $(this).css({marginTop:"0px"}).find("li:first").appendTo(this);
	   	}); 
   }
</script>