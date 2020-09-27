<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<title>数据铁笼三重一大1</title>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/model.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/risk-level.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/three-important1.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/jquery-webflow/src/css/webflow.css" />
<script src="/static/gzw/js/echarts.min.js"></script>
<script src="/static/gzw/js/jquery-1.8.3.js"></script>
<script src="/static/gzw/js/js.js"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/gzw/jquery-webflow/dist/jquery.webflow.simple.js" type="text/javascript"></script>
<script src="/static/gzw/jquery-webflow/dist/jquery.modalFloat.js" type="text/javascript"></script>
<script src="/static/gzw/js/jquery.three.important.js" type="text/javascript"></script>
		<div class="box" id="threeImportantGZW">
			<div class="box-head">
				<a href="${ctx}/gzw/homepageInfo" class="arrow-back"><i></i>首页</a>
                <p class="box-title">三重一大</p>
                <!--<a href="javascript:void(0)" class="arrow-left"><i></i></a>
                <a href="javascript:void(0)" class="arrow-right"><i></i></a>-->
			</div>
            <div class="box-container">
                <div class="box-left">
                    <ul>
                        <li class="on" data-powerId="01">
                            <a href="javascript:void(0);">重大事项</a>
                        </li>
                        <li data-powerId="02">
                            <a href="javascript:void(0);">重大项目</a>
                        </li>
                        <li data-powerId="03">
                            <a href="javascript:void(0);">重要人事</a>
                        </li>
                        <li data-powerId="04">
                            <a href="javascript:void(0);">大额资金</a>
                        </li>
                    </ul>
                </div>
                <div class="box-right">
                    <div class="box-right-title">
                        <p data-id="impTitle"><i></i>重大事项
                           
                        </p>
                        <input type="hidden" id="powerId" value="${powerId}">
                        <span class="tab title-tab" data-id="tab">
                                <a href="javascript:void(0)" class="title-tab1 on" data-id="workflowpoint">流程节点分析</a>
                                <a href="javascript:void(0)" class="title-tab2" data-id="riskTotal">风险汇总分析</a>
                        </span>
                    </div>
                    <div class="box-right-form  three-important1 display-block" data-id="first">
                        <div class="risk-form-main">
                           <div class="form-left" data-id="tree-left"></div>
                           <div class="form-right" data-id="msg-right">
                               <div class="lg-box">
                                   <p>系统播报</p>
		                         <div id="systemScroll" class="hg-520 overflow-h">
					                    <ul id="sp"></ul>
				                  </div>
		                    	<div id="systemScrollHidden" class="hiddenDiv">暂无相关数据</div>
                               </div>
                           </div>
                        </div>
                    </div>
                    <div class="box-right-form display-none" data-id="second">
                        <div class="risk-form-main">
                           <div class="form-left" data-id="bar-left">
                           <div class="decision-making" data-id="menu">
	                            <ul>
		                           	<li data-id="A" class="on"><a href="javasript:void(0)" >投资运营专委会</a></li>
		                           	<li data-id="B"><a href="javasript:void(0)" >业务绩效专委会</a></li>
		                           	<li data-id="C"><a href="javasript:void(0)" >经营性资产监控专委会</a></li>
		                           	<li data-id="D"><a href="javasript:void(0)" >产权管理专委会</a></li>
		                           	<li data-id="E"><a href="javasript:void(0)" >财务监控专委会</a></li>
		                           	<li data-id="F"><a href="javasript:void(0)" >改革重组专委会</a></li>
		                           </ul>
                           </div>
	                           <div id="chart1"></div>
                           </div>
                           
                           <input type="hidden" id="speCommittee" value="${speCommittee}"/>
                           <div class="form-right" data-id="pie-right">
                               <div class="lg-box">
                                   <p>各专委会风险状况</p>
                                   <span class="tab title-tab" data-id="time-btn">
                                        <a href="javascript:void(0)" class="title-tab1 " data-id="1"><span class="">本月</span> </a>
                                        <a href="javascript:void(0)" class="title-tab3 on" data-id="2">近半年</a>
                                        <a href="javascript:void(0)" class="title-tab2" data-id="3"> <span class="">近一年</span></a>
                                     </span>
                                      <input type="hidden" id="timeType" value="${timeType}"/>
                                  <div id="chart2"></div>
		                   
                               </div>
                           </div>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
		</div>
	
	<div class="tree-pop">
        <div class="pop-head" data-id="close">
            <p>财务部审批</p>
            <i class="pop-close" ></i>
        </div>
        <div class="pop-main">
            <div class="pop-alarm pop-main-div">
                <p><i></i><span class="font-yellow">告警数：</span><span data-id="alarmCount"></span></p>
                <div>
                    <span>时间约束：</span><span data-id="alarm1"></span>
                    <span>互证约束：</span><span data-id="alarm4"></span>
                    <span>职能约束：</span><span data-id="alarm3"></span>
                    <span>行为约束：</span><span data-id="alarm2"></span>
                </div>
            </div>
            <div class="pop-risk pop-main-div">
                <p><i></i><span class="font-red">风险数：</span><span data-id="riskCount"></span></p>
                <div>
                   <span>时间约束：</span><span data-id="risk1"></span>
					 <span>互证约束：</span><span data-id="risk4"></span>
				    <span>职能约束：</span><span data-id="risk3"></span>
				     <span>行为约束：</span><span data-id="risk2"></span>
                </div>
            </div>
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
        
        $('.pop-close').click(function(){
            $('.tree-pop').hide();
        });
       
   }); 
   function autoScroll(obj){
   		$(obj).find("#sp:first").animate({marginTop: "-85px"}, 3000, function() {
		   $(this).css({marginTop:"0px"}).find("li:first").appendTo(this);
	   	}); 
   }
</script>
