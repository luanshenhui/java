<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript">
$(function(){
		if($("#ok").val()=="ok"){
	        alert("提交成功!");
	    	window.close();
	    }
});
</script>
</head>
<body>
	<div id="content">
		<form action="${ctx}/xk/submitslDoc" method="post">
			<input type ="hidden" id="ok" value="${ok}" />
			<input type ="hidden" name="ProcMainId" value="${license_dno}" />
			<input type ="hidden" name="DocType" value="D_PT_H_L_12" />
			<input type ="hidden" name="DocId" value="${doc.docId}" />
			<table width="700px" align="center">
				<tr>
					<td align="center"
						style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;">
						<p align="center">
							辽宁出入境检验检疫<br> 现场审查监督笔录
						</p>
					</td>
				</tr>
			</table>
			<table align="center" style="font-size: 14px;margin-left:500px;line-height: 30px;"
				class="tableLine">
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">单位名称:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option1"
						value="${doc.option1}" placeholder="单位名称" /></td>
				</tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">经营类别:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option2"
						value="${doc.option2}" placeholder="经营类别" /></td>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">经营地址:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option3"
						value="${doc.option3}" placeholder="经营地址" /></td>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">电话:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option4"
						value="${doc.option4}" placeholder="电话" /></td>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">法人代表:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option5"
						value="${doc.option5}" placeholder="法人代表" /></td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">负责人:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option6"
						value="${doc.option6}" placeholder="负责人" /></td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">卫生监督机构:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option7"
						value="${doc.option7}" placeholder="卫生监督机构" /></td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">申请类型:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option8"
						value="${doc.option8}" placeholder="监督笔录" /></td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">监督笔录:</th>
					<td style="text-align:left;">
					<textarea style="border: none;" rows="8" cols="100" name="option9" placeholder="监督笔录">${doc.option9}</textarea>
					</td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">卫生监督人员:</th>
					<td style="text-align:left;">
						<img src="/ciqs/showVideo?imgPath=${doc.option10}" width="50px" height="50px" />
					</td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">被监督单位:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option11"
						value="${doc.option11}" placeholder="被监督单位" /></td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">陪同人（签字）:</th>
					<td style="text-align:left;">
						<img src="/ciqs/showVideo?imgPath=${doc.option12}" width="50px" height="50px" />
					</td>
				<tr>
				<tr>
					<th style="width:249px;text-align:right;padding-right:5px">日期:</th>
					<td style="text-align:left;"><input type="text"
						style="width:500px;border: none;outline: none" name="option13"
						value="${doc.option13}" placeholder="日期" /></td>
				<tr>
			</table>

			<div style="text-align: center;margin-top:20px;" class="noprint">
				<span> <input onClick="javascript:window.close();"
					type="button" class="btn" value="返回" /> 
					<!-- <input type="submit" value="提交" class="btn" /> -->
				</span>
			</div>
		</form>
	</div>
</body>
