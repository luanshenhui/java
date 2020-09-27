<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.dpn.com.cn/dpn" prefix="dpn"%>
    <div class="dpn-frame-menu">
        <input type="hidden" id="parameter_first" value=""/>
        <input type="hidden" id="parameter_second" value=""/>
        <input type="hidden" id="parameter_third" value=""/>
        <div class="loca">
            <ul class="nav">
                <li>
	            	<a href="javascript:void(0);">口岸卫生许可证受理</a>
                    <ul>
						<li ><a href="javascript:changeContent('/ciqs/xk/findLicenseDecs');" style="width:140px;text-align:center">卫生许可证查询</a></li>
						<li ><a href="javascript:changeContent('/ciqs/xk/findAddpesons');" style="width:140px;text-align:center">随机人员查询</a></li>	
						<li ><a href="javascript:changeContent('/ciqs/xk/findReviews');" style="width:140px;text-align:center">现场评审查询</a></li>											
                    </ul>
	            </li>
                <li>
	            	<a href="javascript:void(0);">系统管理</a>
                    <ul>
						<li><a href="javascript:changeContent('/ciqs/users/findUsers');">用户管理</a></li>
						<li><a href="javascript:changeContent('/ciqs/users/findOrganizes');">组织管理</a></li>
						<li><a href="javascript:changeContent('/ciqs/users/findRoles');">角色管理</a></li>
						<li><a href="javascript:changeContent('/ciqs/users/findAuth');">权限管理</a></li>
						<li><a href="javascript:changeContent('/ciqs/users/findRes');">资源管理</a></li>
                    </ul>
	            </li>
	            <li style="width:110px;">
	            	<a href="javascript:void(0);">一般处罚</a>
                    <ul>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=1');">立案申报</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=2');">立案预审核</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=3');">稽查受理</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=4');">稽查审批</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=5');">法制受理</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=6');">法制审批</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=7');">立案审批</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=8');">延期审批表审批</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=9');">调查报告填写</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=10');">调查报告预审批</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=11');">调查报告提交</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=12');">调查报告审批</a></li>
						<li><a style="width:110px;" href="javascript:changeContent('/ciqs/generalPunishment/list?step=13');">调查报告局审批</a></li>
                    </ul>
	            </li>
	            <!-- <li>
	            	<a href="javascript:void(0);">模板管理</a>
                    <ul>
						<li><a style="width:100px" href="javascript:changeContent('/ciqs/template/template1');">模板1</a></li>
						<li><a style="width:100px" href="javascript:changeContent('/ciqs/template/anjianyisonghan');">案件移送函</a></li>
						<li><a style="width:100px" href="javascript:changeContent('/ciqs/template/lianshenpibiao');">立案审批表</a></li>
						<li><a style="width:100px" href="javascript:changeContent('/ciqs/template/banlishenpibiao');">办理审批表</a></li>
						<li><a style="width:100px" href="javascript:changeContent('/ciqs/template/chuanranbingjilubiao');">传染病记录表</a></li>
						<li><a style="width:100px" href="javascript:changeContent('/ciqs/template/chuanranbiandiaochabiao');">传染病调查表</a></li>
                        <li><a style="width:100px" href="javascript:changeContent('/ciqs/template/weishengkaohepingfenbiao');">卫生处理现场操作检查考核评分表</a></li>
                        <li><a style="width:100px" href="javascript:changeContent('/ciqs/template/weishengjiandujilubiao');">卫生监督记录表</a></li>
                        <li><a style="width:100px" href="javascript:changeContent('/ciqs/template/weishenggongzuojilubiao');">卫生处理效果评价工作记录表</a></li>
                        <li><a style="width:100px" href="javascript:changeContent('/ciqs/template/jianyijiandujilubiao1');">检疫查验卫生监督记录1</a></li>
                        <li><a style="width:100px" href="javascript:changeContent('/ciqs/template/jianyijiandujilubiao2');">检疫查验卫生监督记录2</a></li>
                        <li><a style="width:100px" href="javascript:changeContent('/ciqs/template/dangchangxingzhengchufapanjueshu');">当场行政处罚决定书</a></li>
                    </ul>
	            </li> -->
            </ul>
        </div>
    </div>
    <style type="text/css" >
    a{width:69px}  
    </style>