
<%@include file="/common/sub_header.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
    <form name="form1" action="goods!editGoods.action" method="post">
    <input type="hidden" name="goods.id" value="${goods.id}"/> 
	<table cellspacing="0" cellpadding="0" width="98%" align="center"  border="0" class="margtb5">
		    <tr>
		      <td align="left" class="padl5 lan12"><img src="<%=path%>/images/img-11.gif" width="12" height="12"><span id="titleLabel"></span></td>
		    </tr>
       </table>

	    <table cellspacing="1" cellpadding="0" width="98%" align="center"  border="0" class="bgcolor2 margb5">
               <tr>
		   <td colspan="4" align="left" class="bkuang zi13b bgcolor2 padl5"><bean:message key='goods.title.info' bundle="label" /></td>
		</tr>   
            

									<tr class="bgcolor">
							  <td width="20%"  align="right" class="zi13">编号：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.goodNo}" name="goods.goodNo"   maxlength="20" class="box1" />

				      				  				  
			  </td>
													  <td width="20%"  align="right" class="zi13">商品名称：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.goodName}" name="goods.goodName"   maxlength="100" class="box1" />

				      				  				  
			  </td>
							</tr>
									<tr class="bgcolor">
							  <td width="20%"  align="right" class="zi13">类型：</td>
			  <td width="30%"  class="pad2 zi13">
				 				  				    <s:select list="#request.ywfw" theme="simple" name="goods.goodType" cssClass="box1"  listKey="key" listValue="value"  ></s:select> 
				  
			  </td>
													  <td width="20%"  align="right" class="zi13">所属品牌：</td>
			  <td width="30%"  class="pad2 zi13">
				 				  				    <s:select list="#request.ywfw" theme="simple" name="goods.brand" cssClass="box1"  listKey="key" listValue="value"  ></s:select> 
				  
			  </td>
							</tr>
									<tr class="bgcolor">
							  <td width="20%"  align="right" class="zi13">型号：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.goodStyle}" name="goods.goodStyle"   maxlength="30" class="box1" />

				      				  				  
			  </td>
													  <td width="20%"  align="right" class="zi13">单位：</td>
			  <td width="30%"  class="pad2 zi13">
				 				  				    <s:select list="#request.ywfw" theme="simple" name="goods.goodUnit" cssClass="box1"  listKey="key" listValue="value"  ></s:select> 
				  
			  </td>
							</tr>
									<tr class="bgcolor">
							  <td width="20%"  align="right" class="zi13">进货价：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.inCome}" name="goods.inCome"   maxlength="22" class="box1" />

				      				  				  
			  </td>
													  <td width="20%"  align="right" class="zi13">销售价：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.outCome}" name="goods.outCome"   maxlength="22" class="box1" />

				      				  				  
			  </td>
							</tr>
									<tr class="bgcolor">
							  <td width="20%"  align="right" class="zi13">厂商：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.factory}" name="goods.factory"   maxlength="50" class="box1" />

				      				  				  
			  </td>
													  <td width="20%"  align="right" class="zi13">备注：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.remark}" name="goods.remark"   maxlength="400" class="box1" />

				      				  				  
			  </td>
							</tr>
									<tr class="bgcolor">
							  <td width="20%"  align="right" class="zi13">数量：</td>
			  <td width="30%"  class="pad2 zi13">
				 				      
				      <input type="text" value="${goods.goodNum}" name="goods.goodNum"   maxlength="11" class="box1" />

				      				  				  
			  </td>
							</tr>
				
           </table>
 
		<p><p><p>
	
<table width="98%" align="center" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td align="center">
			    <input type="button" class="buttonbg" onclick="save();" value="保存"/>

				&nbsp;&nbsp;&nbsp;
				 <input type="button" class="buttonbg" onclick="back();" value="返回"/>

		</tr>
	</table>

</form>
</body>
</html>


<script>
  var title = "系统管理 > 权限管理 > 角色管理 > 编辑";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

  function save(){


		   	 document.forms[0].action= "<%=path%>/goods!editGoods.action";
	 document.forms[0].submit();
 } 
</script>
