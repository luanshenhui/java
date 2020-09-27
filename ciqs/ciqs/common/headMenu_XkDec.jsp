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
	            	<a href="javascript:changeContent('/ciqs/dc/toLicenseDecForm');" style="width:140px;text-align:center">卫生许可证申报新增</a>
                </li>
                <li>
                    <a href="javascript:changeContent('/ciqs/dc/getLicenseDecs');" style="width:140px;text-align:center">卫生许可证申报查询</a>
	            </li>
	            <li>
                    <a href="javascript:changeContent('/ciqs/dc/getLicenseDecs2?initflag=1');" style="width:140px;text-align:center">后续操作</a>
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