<%@ page  pageEncoding="utf-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>无标题文档</title>
<style type="text/css">
<!--
body {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: 5px;
	margin-bottom: 5px;
}
.STYLE1 {font-size: 12px}
.STYLE3 {font-size: 12px; font-weight: bold; }
.STYLE4 {
	color: #03515d;
	font-size: 12px;
}
-->
</style>

<script type="text/javascript" src="jquery-1.4.3.js"></script>
<script type="text/javascript" src="AjaxUtils.js"></script>

<script type="text/javascript">
function isIdUsed7()
{
	var targ; 
	var comid=$("#pay_id").val();
	$.post("isIdUsed7",{
		pay_id:comid
	},function(result){
		if(result==1)
		{
			alert("编号重复");
			$("#pay_id").val("");
			targ = false;
		}
		else
		{
			targ = true;
		}	
	});

	return targ;
}


</script>



</head>

<body>
<form action="f5pay_insertPay.action" method="get">
<table align="center" bgcolor="d5d4d4" border="0" cellpadding="0" cellspacing="1" width="100%">
  <tbody>
  <tr>
    <td class="STYLE1" colspan="4" bgcolor="#FFFFFF"><table align="center" border="0" cellpadding="0" cellspacing="0" width="70%">
      <tbody><tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">缴费编号</div></td>
        <td class="STYLE1" height="35" width="352"><div align="left">
          <input name="pay_id" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " onblur="isIdUsed7();" type="text" id="pay_id" ></div></td>
        
      </tr>     
     
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">业主编号</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
        <!-- 
          <input name="houses_comid" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text">
         -->
          <select name="pay_resid">
          	<s:iterator value="resiIdList" id="resi">
				<option value='<s:property value="resi"/>'><s:property value="resi"/>
				</option>
			</s:iterator>
		</select>
          
         
          </div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">费用编号</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
        <!-- 
          <input name="pay_feeid" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text">
           -->
           <select name="pay_feeid">
          	<s:iterator value="feeIdList" id="resi">
				<option value='<s:property value="resi"/>'><s:property value="resi"/>
				</option>
			</s:iterator>
		</select> 
          </div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">支付数目</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="pay_number" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">支付时间</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="pay_date" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
      </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">欠费数目</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="pay_overdue" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
       
      </tr>   
      <tr>
       <td height="22"><input type="submit" value="确认"></td>
       </tr>   
      <tr>
        <td class="STYLE1" height="40">&nbsp;</td>
        <td class="STYLE1" colspan="3" height="35"><img src="tab_files/syb.gif" height="21" width="62"><img src="tab_files/xyb.gif" height="21" width="62"></td>
      </tr>
    </tbody></table></td>
  </tr>
</tbody></table>
</form>


</body>
</html>

