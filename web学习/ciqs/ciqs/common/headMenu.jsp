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
                    <a href="javascript:changeContent('/ciqs/expFoodPOF/addpeson');">出口食品生产企业备案核准</a>
                </li>
                <li>
                    <a href="javascript:changeContent('/ciqs/extxz/pesoninit');">出口食品生产企业备案检查</a>
                </li>
                <li>
	            	<a href="javascript:changeContent('/ciqs/dc/toLicenseDecForm');">口岸卫生许可证申报</a>
	            </li>
                <li>
	            	<a href="javascript:changeContent('/ciqs/xk/xkIndex');">口岸卫生许可证受理</a>
	            </li>
                <li>
	            	<a href="javascript:changeContent('/ciqs/generalPunishment/pnIndex');">行政处罚管理系统</a>
	            </li>
	            <li>
	            	<a href="javascript:changeContent('/ciqs/mailSteamer/showdeclarationlist');">进出境邮轮检疫</a>
	            </li>
                <li>
                    <a href="javascript:changeContent('/ciqs/users/findOrganizes');">系统管理</a>
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