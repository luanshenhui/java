<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <!-- **** head ********************************************************* -->
   <div class="dpn-frame-head">
        <table>
        	<tr>
        		<td>
        		<span class="logo" style="width:630px;">
        		</span>
        		</td>
        		<td style="font-size: 14px;color: black;margin-top: 30px;a:active{color: black}">
        			<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
        		</td>
        	</tr>
        </table>
   </div>

   <div class="dpn-frame-menu">
        <div class="loca">
            <ul class="nav">
                <li>
                    <a href="javascript:void(0);">企业备案核准</a>
                    <ul>
                        <li><a href="">行政许可人员随机</a></li>
                        <li><a href="javascript:changeContent('/ciqs/expFoodProd/peson');">行政检查人员随机</a></li>
                        <li><a href="javascript:changeContent('/ciqs/expFoodPOF/showFileMessage');">知识库</a></li>
                    </ul>
                </li>
                <li>
	            	<a href="javascript:void(0);">口岸卫生许可证受理</a>
                    <ul>
                    	<li><a href="javascript:changeContent('/ciqs/dc/toLicenseDecForm');" style="width:140px;text-align:center">卫生许可证申报新增</a></li>
                    	<li><a href="javascript:changeContent('/ciqs/dc/getLicenseDecs');" style="width:140px;text-align:center">卫生许可证申报查询</a></li>
                    	<li><a href="javascript:changeContent('/ciqs/dc/getLicenseDecs2?initflag=1');" style="width:140px;text-align:center">后续操作</a></li>
						<!-- <li><a href="javascript:changeContent('/ciqs/xk/findLicenseDecs');" style="width:140px;text-align:center">卫生许可证受理</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findScs');" style="width:140px;text-align:center">卫生许可证审查</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findAddpesons');" style="width:140px;text-align:center">随机人员查询</a></li>	
						<li><a href="javascript:changeContent('/ciqs/xk/findAddpesons2');" style="width:140px;text-align:center">随机人员领导查询</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findyScs');" style="width:140px;text-align:center">审查派员查询</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findReviews');" style="width:140px;text-align:center">决定与送达查询</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findReviewsSp');" style="width:140px;text-align:center">决定与送达审批查询</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/xkzDoStatus');" style="width:140px;text-align:center">许可证状态处理</a></li>
						<li><a href="javascript:changeContent('/ciqs/work/alert');" style="width:140px;text-align:center">工作提醒查询</a></li>	
						<li><a href="javascript:changeContent('/ciqs/work/flow');" style="width:140px;text-align:center">工作流程查询</a></li>	 -->									
                    </ul>
	            </li>
                <li>
	            	<a href="javascript:void(0);">一般处罚</a>
                    <ul>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=1');">立案申报</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=2');">立案预审核</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=3');">稽查受理</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=4');">稽查审批</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=5');">法制受理</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=6');">法制审批</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=7');">立案审批</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=8');">延期审批表审批</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=9');">调查报告填写</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=10');">调查报告预审批</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=11');">调查报告提交</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=12');">调查报告审批</a></li>
						<li><a href="javascript:changeContent('/ciqs/generalPunishment/list?step=13');">调查报告局审批</a></li>
                    </ul>
	            </li>
	            <li>
	            	<a href="javascript:void(0);">进出境邮轮检疫</a>
                    <ul>
						<li><a href="javascript:changeContent('/ciqs/mailSteamer/showdeclarationlist');">邮轮入境检疫申报查询</a></li>
                    </ul>
	            </li>
                <li>
                    <a href="javascript:void(0);">系统管理</a>
                    <ul>
                        <li><a href="javascript:changeContent('/ciqs/users/findOrganizes');" style="width:70px;text-align:center">组织管理</a></li>
                        <li><a href="javascript:changeContent('/ciqs/users/findUsers');" style="width:70px;text-align:center">用户管理</a></li>
                        <li><a href="javascript:changeContent('/ciqs/users/findRoles');" style="width:70px;text-align:center">角色列表</a></li>
                        <li><a href="javascript:changeContent('/ciqs/users/findAuth');" style="width:70px;text-align:center">权限列表</a></li>
                        <li><a href="javascript:changeContent('/ciqs/users/findRes');" style="width:70px;text-align:center">资源列表</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
    
    <script type="text/javascript">
        function changeContent(targetUrl) {
            if (!targetUrl) {
                return;
            }
           window.location.href=targetUrl;
        }
        
    </script>