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
function isIdUsed8()
{
	var targ; 
	var comid=$("#repairs_id").val();
	$.post("isIdUsed8",{
		repairs_id:comid
	},function(result){
		if(result==1)
		{
			alert("编号重复");
			$("#repairs_id").val("");
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
<form action="f5rep_insertRepairs.action" method="get">
<table align="center" bgcolor="d5d4d4" border="0" cellpadding="0" cellspacing="1" width="100%">
  <tbody>
  <tr>
    <td class="STYLE1" colspan="4" bgcolor="#FFFFFF"><table align="center" border="0" cellpadding="0" cellspacing="0" width="70%">
      <tbody><tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">报修编号</div></td>
        <td class="STYLE1" height="35" width="352"><div align="left">
          <input name="repairs_id" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " onblur="isIdUsed8();" type="text" id="repairs_id" ></div></td>
        
      </tr>     
     
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">设备编号</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
        <!-- 
          <input name="houses_comid" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text">
         -->
          <select name="repairs_plantid">
          	<s:iterator value="plantIdList" id="plant">
				<option value='<s:property value="plant"/>'><s:property value="plant"/>
				</option>
			</s:iterator>
		</select>
          
         
          </div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">报修时间</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="repairs_date" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left"></div>报修原因</td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="repairs_reason" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">检修方式</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="repairs_way" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
      </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">检修人员</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="repairs_person" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
       
      </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">检修结果</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="repairs_result" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
       
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

