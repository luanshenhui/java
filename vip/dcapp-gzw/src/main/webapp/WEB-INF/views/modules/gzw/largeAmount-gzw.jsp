<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<title>大额资金</title>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/model.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/risk-level.css" />
<script src="/static/gzw/js/echarts.min.js"></script>
<script src="/static/gzw/js/jquery-1.8.3.js"></script>
<script src="/static/gzw/js/js.js"></script>
<div class="wrap">
	<div class="container">
		<div class="box">
			<div class="box-head">
				<a href="firstpage.html" class="arrow-back"><i></i>首页</a>
                <p class="box-title">三重一大</p>
                <!--<a href="javascript:void(0)" class="arrow-left"><i></i></a>
                <a href="javascript:void(0)" class="arrow-right"><i></i></a>-->
			</div>
            <div class="box-container">
                <div class="box-left">
                    <ul>
                        <li>
                            <a href="gzw-threeImportant1.html">重大事项</a>
                        </li>
                        <li>
                            <a href="gzw-majorProjectArrangement.html">重大项目</a>
                        </li>
                        <li>
                            <a href="gzw-majorPersonnel.html">重要人事</a>
                        </li>
                        <li class="on">
                            <a href="gzw-largeAmount.html">大额资金</a>
                        </li>
                    </ul>
                </div>
                <div class="box-right">
                    <div class="box-right-title">
                        <p><i></i>大额资金
                             <span class="tab title-tab">
                                <a href="javascript:void(0)" class="title-tab1 on">流程节点分析</a>
                                <a href="gzw-threeImportant2.html" class="title-tab2">风险汇总分析</a>
                            </span>
                        </p>
                    </div>
                    <div class="box-right-form  three-important1">
                        <div class="risk-form-main">
                           <div class="form-left">
                               <ul class="form-left-tree">
                                   <li class="tree-green arrow-red tree-down">
                                       <a href="javascript:void(0)">开始</a>
                                   </li>
                                   <li class="tree-step1 tree-blue tree-down arrow-green">
                                       <a href="javascript:void(0)">拟办人意见<span>业务数据量：128<br/>告警数：2 风险数：0</span></a>
                                   </li>
                                   <li class="tree-step2 tree-blue arrow-green tree-row">
                                       <a href="javascript:void(0)">拟办负责人签字<span>业务数据量：168<br/>告警数：3  风险数：1</span></a>
                                   </li>
                                   <div class="tree-div1">
                                       <li class="tree-step3 tree-blue arrow-green tree-down">
                                           <a href="javascript:void(0)">专委会讨论<span>业务数据量：118<br/>告警数：1  风险数：0</span></a>
                                       </li>
                                       <li class="tree-step4 tree-blue arrow-red tree-row">
                                           <a href="javascript:void(0)">专委会领导<span>业务数据量：138<br/>告警数：1  风险数：0</span></a><i></i>
                                       </li>
                                   </div>
                                   <div class="tree-div2">
                                       <li class="tree-step5 tree-blue arrow-red tree-down">
                                           <a href="javascript:void(0)">审委会讨论<span>业务数据量：108<br/>告警数：2  风险数：1</span></a>
                                       </li>
                                       <li class="tree-step6 tree-blue arrow-green tree-down">
                                           <a href="javascript:void(0)">审委会领导审批<span>业务数据量：178<br/>告警数：2  风险数：1</span></a>
                                       </li>
                                   </div>
                                   <li class="tree-red">
                                       <a href="javascript:void(0)">结束</a>
                                   </li>
                               </ul>
                           </div>
                           <div class="form-right">
                               <div class="lg-box">
                                   <p>系统播报</p>
                                   <div>
                                       <span class="font-red">风险：</span>王丹 2016-12-24 6:40:15 出现风险
                                   </div>
                                   <div>
                                       <span class="font-yellow">告警：</span>张桃 2016-10-14 14:20:15 出现告警
                                   </div>
                                   <div>
                                       <span class="font-red">风险：</span>张彬 2016-11-4 11:20:15 出现风险
                                   </div>
                                   <div>
                                       <span class="font-red">风险：</span>李珊 2016-12-5 23:20:15 出现风险
                                   </div>
                               </div>
                           </div>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
		</div>
	</div>
    <div class="tree-pop">
        <div class="pop-head">
            <p>财务部审批</p><i class="pop-close"></i>
        </div>
        <div class="pop-main">
            <div class="pop-alarm pop-main-div">
                <p><i></i><span class="font-yellow">告警数：</span>1</p>
                <div>
                    <span>时间约束：0</span>
                    <span>互证约束：0</span>
                    <span>职能约束：0</span>
                    <span>行为约束：1</span>
                </div>
            </div>
            <div class="pop-risk pop-main-div">
                <p><i></i><span class="font-red">风险数：</span>0</p>
                <div>
                    <span>时间约束：0</span>
                    <span>互证约束：0</span>
                    <span>职能约束：0</span>
                    <span>行为约束：0</span>
                </div>
            </div>
        </div>
    </div>
</div>