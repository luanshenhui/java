<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="goods!addGoods.action" method="post">
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
				商品信息
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				编号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="goods.goodNo" id="goodNo" maxlength="20" class="box1" />
&nbsp;<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				商品名称：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="goods.goodName" id="goodName" maxlength="100"
					class="box1" />
&nbsp;<font color="red">*</font>


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				类型：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.splx" theme="simple" name="goods.goodType"
					cssClass="box1" headerKey="" headerValue="请选择" listKey="key" listValue="value"></s:select>

			</td>
			<td width="20%" align="right" class="zi13">
				所属品牌：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.pp" theme="simple" name="goods.brand"
					cssClass="box1" headerKey="" headerValue="请选择" listKey="name" listValue="name"></s:select>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				型号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="goods.goodStyle" maxlength="30"
					class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				单位：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.unit" theme="simple" name="goods.goodUnit"
					cssClass="box1" headerKey="" headerValue="请选择" listKey="key" listValue="value"></s:select>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				进货价：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="goods.inCome" value="0" maxlength="22" class="box1" id="inCome" />

&nbsp;<font color="red">*</font>

			</td>
			<td width="20%" align="right" class="zi13">
				销售价：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="goods.outCome" value="0" id="outCome"  maxlength="22" class="box1" />
&nbsp;<font color="red">*</font>


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				厂商：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="goods.factory" maxlength="50" class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				数量：
			</td>
			<td width="30%" class="pad2 zi13">

			
<input type="text" name="goods.goodNum" maxlength="11"  readonly="true"  id="goodNum"  value="0" class="box1" />
&nbsp;<font color="red">*</font>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				备注：
			</td>
			<td width="30%" colspan="3" class="pad2 zi13">
                    <textarea rows="4" cols="60"  name="goods.remark" maxlength="400" ></textarea>
					

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
		
				<input type="button" class="buttonbg" onclick="save();"   value="保存" />

				&nbsp;&nbsp;&nbsp;
				<input type="button" class="buttonbg" onclick="closewindow();" value="关闭" />
		</tr>
	</table>

</form>
</body>
</html>


<script>
  var title = "新增商品";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

 function save(){
    
     if($("#goodNo").val() == ""){
          $.messager.alert('警告','编号不能为空！','warning');
          return;
     }
     if($("#goodName").val() == ""){
          $.messager.alert('警告','名称不能为空！','warning');
          return;
     }
     if($("#inCome").val() == ""){
          $.messager.alert('警告','进货价不能为空！','warning');
          return;
     }
     if($("#outCome").val() == ""){
          $.messager.alert('警告','销售价不能为空！','warning');
          return;
     }
     if($("#goodNum").val() == ""){
          $.messager.alert('警告','数量不能为空！','warning');
          return;
     }
    document.forms[0].action= "<%=path%>/goods!addGoods.action";
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
    
    
     $("#inCome").keyup(function(){   
       var value = $(this).val();   
        $("#integral").val(value);   
       if((/^(\+|-)?\d+$/.test( value ))|| value<0){   
        return true;   
   }else{   
         $.messager.alert('警告','金额请输入正整数！','warning'); 
        $("#inCome").val("0");    
      return false;   
    }   
       
    });
    
    
     $("#outCome").keyup(function(){   
       var value = $(this).val();   
        $("#integral").val(value);   
       if((/^(\+|-)?\d+$/.test( value ))|| value<0){   
        return true;   
   }else{   
         $.messager.alert('警告','金额请输入正整数！','warning'); 
        $("#outCome").val("0");    
      return false;   
    }   
       
    });
    
    
     $("#goodNum").keyup(function(){   
       var value = $(this).val();   
        $("#integral").val(value);   
       if((/^(\+|-)?\d+$/.test( value ))|| value<0){   
        return true;   
   }else{   
         $.messager.alert('警告','数量请输入正整数！','warning'); 
        $("#goodNum").val("0");    
      return false;   
    }   
       
    });
    
    function closewindow(){
        window.close();
    }
</script>

