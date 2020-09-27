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

    
    <script type="text/javascript">
        function changeContent(targetUrl) {
            if (!targetUrl) {
                return;
            }
           window.location.href=targetUrl;
        }
        
    </script>