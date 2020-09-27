
<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="card!editCard.action" method="post">
	<input type="hidden" name="card.id" value="${card.id}" />
	<table cellspacing="0" cellpadding="0" width="98%" align="center"
		border="0" class="margtb5">
		<tr>
			<td align="left" class="padl5 lan12">
				<img src="<%=path%>/images/img-11.gif" width="12" height="12">
				<span id="titleLabel"></span>
			</td>
		</tr>
	</table>

	<table cellspacing="1" cellpadding="0" width="98%" align="center"
		border="0" class="bgcolor2 margb5">
		<tr>
			<td colspan="4" align="left" class="bkuang zi13b bgcolor2 padl5">
				<bean:message key='card.title.info' bundle="label" />
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				会员卡号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${card.cardNo}" name="card.cardNo" id="cardNo"
					maxlength="15" class="box1" />

&nbsp;<font color="red">*</font>

			</td>
			<td width="20%" align="right" class="zi13">
				卡类型：
			</td>
			<td width="30%" class="pad2 zi13">

<s:select list="#request.cardType" theme="simple" name="card.cardType"
					cssClass="box1"  listKey="key" listValue="value"></s:select>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				金额：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${card.money}" name="card.money" id="money"
					maxlength="22" class="box1" />元
&nbsp;<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				积分：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${card.score}" name="card.score" id="score"
					maxlength="11" class="box1" />


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				会员：
			</td>
			<td width="30%" colspan="3" class="pad2 zi13">
			    <input type="hidden" name="card.memberId" value="${card.memberId}"/>
				${card.memberName}


			</td>
		</tr>

	</table>

	<p>
	<p>
	<p>
	<table width="98%" align="center" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td align="center">
				<input type="button" class="buttonbg" onclick="save();" value="保存" />

				&nbsp;&nbsp;&nbsp;
				<input type="button" class="buttonbg" onclick="back();" value="返回" />
		</tr>
	</table>

</form>
</body>
</html>


<script>
  var title = "会员管理 > 会员卡管理 > 编辑";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

  function save(){

if($("#cardNo").val() == ""){
          $.messager.alert('警告','会员卡号不能为空！','warning');
          return;
     }
     if($("#money").val() == ""){
          $.messager.alert('警告','金额不能为空！','warning');
          return;
     }
		   	 document.forms[0].action= "<%=path%>/card!editCard.action";
	 document.forms[0].submit();
 } 
 
  $("#money").keyup(function(){   
       var value = $(this).val();   
        $("#integral").val(value);   
       if((/^(\+|-)?\d+$/.test( value ))|| value<0){   
        return true;   
   }else{   
         $.messager.alert('警告','金额请输入正整数！','warning'); 
        $("#money").val("0");    
      return false;   
    }   
       
    });
    
     	 $("#score").keyup(function(){   
       var value = $(this).val();   
        $("#integral").val(value);   
       if((/^(\+|-)?\d+$/.test( value ))|| value<0){   
        return true;   
   }else{   
         $.messager.alert('警告','积分请输入正整数！','warning'); 
        $("#score").val("0");    
      return false;   
    }   
     });
</script>
