<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<body>
	<div class="appt_list">
					<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
				  <tr>
				    <td height="30"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				      <tr>
				        <td> <span class="STYLE4">已发送的请求</span></td>
				        <td  align="right"><a href="deleteAllAppointment?id=${user.userID}&name='my'" onclick="return confirm('确定删除所有发送的过期请求吗?');" style="font-size:14px;color:#bcf">删除所有的请求</a></td>
				      </tr>
				    </table></td>
				  </tr>
				  <tr>
				    <td>
				    <table id="mgnt1" width="100%" border="0" cellspacing="0" cellpadding="0">
				      <tr>
					
				        <td width="9">&nbsp;</td>
				        <td ><table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" onmouseover="changeto()"  onmouseout="changeback()">
				          <tr>
				            <td width="6%" height="18"  class="STYLE2"><div align="center" >序号</div></td>
				            <td width="6%" height="18"  class="STYLE2"><div align="center" >约会对象</div></td>
				            <td width="6%" height="18"  class="STYLE2"><div align="center" >约会时间</div></td>
				            <td width="8%" height="18"  class="STYLE2"><div align="center" >答复状态</div></td>
				            <td width="3%" height="18"  class="STYLE2"><div align="center" >详情</div></td>
				            <td width="20%" height="18"  class="STYLE2"><div align="center" >操作</div></td>
				          </tr>
				          <c:forEach var="se" items="${sen}">
				           <c:forEach var="s" items="${se}">
				             <tr>
				            <td height="18"  ><div align="center" class="STYLE1">${s.key.id}</div></td>
				            <td width="10%" height="18" ><div align="center" class="STYLE1">${s.value.name}</div></td>
				            <td width="20%" height="18" ><div align="center" class="STYLE1">${s.key.appointmentDate}</div></td>
				            <td height="18" ><div align="center" class="STYLE1">
				            	<c:if test="${s.key.ok=='未答复'}">
				            				<img width="26px" height="26px" src="img/Question.png" alt="未答复">
				            </c:if>
				            <c:if test="${s.key.ok=='同意'}">
				            				<img width="26px" height="26px" src="img/appt_yes.PNG" alt="已同意">
				            </c:if>	
				            <c:if test="${s.key.ok=='拒绝'}">
				            				<img width="26px" height="26px" src="img/appt_no.PNG" alt="拒绝了嗯">
				            </c:if>				   
				            </div></td>
				            <td width="8%" height="18" ><div align="center"><img src="images/037.gif" width="9" height="9" /><span class="STYLE1"> [</span><a href="lookAppointment?id=${s.key.id}">详情</a><span class="STYLE1">]</span></div></td>
				            <td height="18" ><div align="center"><img src="images/010.gif" width="9" height="9" /> <span class="STYLE1">[</span><a href="deleteAppointment?id=${s.key.id}&name='one'" onclick="return confirm('是否撤销约会请求?');" style="font-size:12px;color:#aac">撤销</a><span class="STYLE1">]</span></div></td>
				            </tr>
				             </c:forEach>
				            </c:forEach>
				        </table></td>
				      </tr>
				    </table>
				  <tr>
				    <td height="29"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				      <tr>
				        <td width="15" height="29"></td>
				        <td ><table width="100%" border="0" cellspacing="0" cellpadding="0">
				          <tr>
				            <td width="25%" height="29" nowrap="nowrap"><span class="STYLE1">共${sAll} 条纪录，当前第 ${index+1}/${sp}页，每页5 条纪录</span></td>
				            <td width="75%" valign="top" class="STYLE1"><div align="right">
				              <table width="352" height="20" border="0" cellpadding="0" cellspacing="0">
				                <tr>
				                  <td width="62" height="22" valign="middle"><div align="right"><a href="pagingAppointment?index=0&page=5">首页</a></div></td>
				                  <c:if test="${index==0}">
				                  <td width="50" height="22" valign="middle"><div align="right">上一页</div></td></c:if>
				                   <c:if test="${index!=0}">
				                  <td width="50" height="22" valign="middle"><div align="right"><a href="pagingAppointment?index=${index-1}&page=5">上一页</a></div></td></c:if>
				                  <c:if test="${index+1==sp}">
				                  <td width="54" height="22" valign="middle"><div align="right">下一页</div></td></c:if>
				                   <c:if test="${index+1!=sp}">
				                  <td width="54" height="22" valign="middle"><div align="right"><a href="pagingAppointment?index=${index+1}&page=5">下一页</a></div></td></c:if>
				                  <td width="49" height="22" valign="middle"><div align="right"><a href="pagingAppointment?index=${sp}&page=5">尾页</a></div></td>
				
				                  <td width="59" height="22" valign="middle"><div align="right"class="STYLE1"></div></td>
				                  <td width="25" height="22" valign="middle"><span class="STYLE7">
				                    <!--  <input name="page" id="Num" type="text" class="STYLE1" style="height:20px; width:25px;" size="5" />-->
				                  </span></td>
				                  <td width="23" height="22" valign="middle"class="STYLE1"></td>
				                  <td width="30" height="22" valign="middle">
				                  <a href="javascript:;" onclick=" "></a></td>
				                </tr>
				              </table>
				
				            </div></td>
				          </tr>
				        </table></td>
				      </tr>
				    </table></td>
				  </tr>
				</table>
			</div>
</body>

