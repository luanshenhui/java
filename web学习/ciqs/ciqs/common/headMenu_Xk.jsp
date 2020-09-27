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
	            	<a href="javascript:changeContent('/ciqs/xk/findLicenseDecs');" style="width:140px;text-align:center">卫生许可证受理</a>
                </li>
                <li>
	            	<a style="width:140px;text-align:center">卫生许可证审查</a>
                	<ul>
	            		<li><a href="javascript:changeContent('/ciqs/xk/findScs1');" style="width:110px;text-align:center">初审</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findScs');"  style="width:110px;text-align:center">部门负责人审核</a></li>
					</ul>
                </li>
	            <!--<li>
                    <a href="javascript:changeContent('/ciqs/xk/findAddpesons2');" style="width:140px;text-align:center">随机人员领导查询</a>
	            </li>-->           
	            <li>
                    <a href="javascript:changeContent('/ciqs/xk/findyScs');" style="width:140px;text-align:center">审查派员</a>
	            </li>
                <li>
	            	<a href="#" style="width:140px;text-align:center">决定与送达</a>
	            	<ul>
	            		<li><a href="javascript:changeContent('/ciqs/xk/findReviews');" style="width:110px;text-align:center">决定与送达</a></li>
						<li><a href="javascript:changeContent('/ciqs/xk/findReviewsSp');" style="width:110px;text-align:center">决定与送达审批</a></li>
					</ul>
	            </li>
	            <li>
	            	<a href="javascript:void(0);">工作任务</a>
	            	<ul>
	            		<li><a href="javascript:changeContent('/ciqs/work/alert');" style="width:70px;text-align:center">工作提醒</a></li>
	            		<li><a href="javascript:changeContent('/ciqs/work/flow');" style="width:70px;text-align:center">工作流程</a></li>
	            	</ul>
	            </li>
	            <li>
	            	<a href="javascript:void(0);">特殊业务受理</a>
                    <ul>
                    	<li><a href="javascript:changeContent('/ciqs/xk/bfList');" style="width:98px;text-align:center">补发审批</a></li>
                    	<li><a href="javascript:changeContent('/ciqs/xk/zzList');" style="width:98px;text-align:center">终止审批</a></li>
                    	<li><a href="javascript:changeContent('/ciqs/xk/cxList');" style="width:98px;text-align:center">撤销审批</a></li>
                    	<li><a href="javascript:changeContent('/ciqs/xk/zxList');" style="width:98px;text-align:center">注销审批</a></li>										
                    </ul>
	            </li>
	            <li>
                    <a href="#" style="width:140px;text-align:center">双随机</a>
	             	<ul>
                    	<li><a href="javascript:changeContent('/ciqs/xk/findAddpesons');" style="width:110px;text-align:center">双随机</a></li>
                    	<li><a href="javascript:changeContent('/ciqs/xk/findAddpesons2');" style="width:110px;text-align:center">双随机审批</a></li>
                    	
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