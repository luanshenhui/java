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
</script>

</head>

<body>
<form action="f5comi_insertCominfo.action" method="get">
<table align="center" bgcolor="d5d4d4" border="0" cellpadding="0" cellspacing="1" width="100%">
  <tbody>
  <tr>
    <td class="STYLE1" colspan="4" bgcolor="#FFFFFF"><table align="center" border="0" cellpadding="0" cellspacing="0" width="70%">
      <tbody>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">小区编号</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <select name="cominfo_id">
          	<s:iterator value="comIdList" id="com"  >
				<option  value='<s:property value="com" />'><s:property value="com" />
				</option>
			</s:iterator>
			</select>    
          </div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">周边公交</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="cominfo_bus" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left"></div>周边医疗</td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="cominfo_medical" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
        </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">小区新闻</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="cominfo_news" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
      </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">天气预报</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="cominfo_weather" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
      </tr>
      <tr>
        <td class="STYLE1" height="35" nowrap="nowrap" width="142"><div align="left">小区公告</div></td>
        <td class="STYLE1" colspan="3" height="35"><div align="left">
          <input name="cominfo_notice" style="width:200px; height:17px; font-size:12px; border:solid 1px #ccc; " type="text"></div></td>
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

