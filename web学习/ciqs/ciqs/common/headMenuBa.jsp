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
                    <a href="javascript:changeContent('/ciqs/expFoodPOF/addpeson');">人员随机</a>
                </li>
                <li>
                    <a href="javascript:changeContent('/ciqs/expFoodPOF/showFileMessage');">知识库</a>
                </li>
                <li>
                    <a href="javascript:changeContent('/ciqs/expFoodPOF/psyList');">评审员管理</a>
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