<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>质量监督检验检疫准予行政许可决定书</title>
<%@ include file="/common/resource_new.jsp"%>
<style type="text/css">
body div {
	width: 700px;
	text-align: center;
	margin: 0 auto;
	font-size: 20px;
}

table {
	width: 760px;
}

tr {
	height: 30px;
}

td {
	border: 1px solid #000;
	padding: 3px;
}

tr td:nth-last-child(3) {
	text-align: left;
}

.title_style {
	font-size: 30px;
	font-weight: 600;
}

.subtitle_style {
	font-size: 25px;
}

.tableline_1 td, .tablelinesecond_1 td, .tablelinethird_1 td {
	height: 100px;
	text-align: center !important;
}

.tableline_1_1, .tableline_1_4, .tableline_1_5, .tableline_2_2,
	.tablelinesecond_1_1, .tablelinesecond_1_4, .tablelinesecond_1_5,
	.tablelinesecond_2_2, .tablelinethird_1_1, .tablelinethird_1_4,
	.tablelinethird_1_5, .tablelinethird_2_2 {
	width: 60px;
}

.tableline_30 td, .tablelinesecond_29 td, .tablelinethird_14 td {
	text-align: center !important;
}
</style>
<script type="text/javascript">
	
</script>
</head>
<body>
	<div>
		<h3>
			中华人民共和国出入境检验检疫
		</h3>
		<h2>抽&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;采&nbsp;&nbsp;&nbsp;&nbsp;样&nbsp;&nbsp;&nbsp;&nbsp;凭&nbsp;&nbsp;&nbsp;&nbsp;证</h2>
	</div>
	<div style="font-size:14px">
		<span style="float:left">抽/采样地点：${laboratoryList.chk_place}</span> 
		<span style="float:right">编号：${laboratoryList.chk_no}</span>
	</div>
	<table>
		<tr>
			<td>报检单位：</td>
			<td>${laboratoryList.chk_decl_ent}</td>
			<td>货主：</td>
			<td>${laboratoryList.chk_receiver}</td>
		</tr>
	</table>
	<table>
		<tr>
			<td>品名</td>
			<td>H.S.编码</td>
			<td>产地</td>
			<td>标记号码</td>
			<td>样品规格及数据</td>
			<td>抽/采样依据</td>
		</tr>
		<c:forEach var="labDtail" items="${labDtailList }" >
			<tr>
				<td>${labDtail.chk_goods_name }</td>
				<td>${labDtail.chk_hs_code }</td>
				<td>${labDtail.chk_orign_place }</td>
				<td>${labDtail.chk_mark_no }</td>
				<td>${labDtail.chk_model }</td>
				<c:if test="${labDtail.chk_rsn == null }">
					<td>GB/T18088-2000</td>
				</c:if>
				<c:if test="${labDtail.chk_rsn != null }">
					<td>${labDtail.chk_rsn }</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<table>
		<tr>
			<td>备注</td>
			<td>${laboratoryList.chk_remark}</td>
		</tr>
	</table>
	<table>
		<tr>
			<td>货主签字：</td>
			<td><img style="width:80px;height:80px" src="http://10.21.37.249/ciq-video/showVideo?filePath=${laboratoryList.fileMounth},${laboratoryList.fileDate},${laboratoryList.chk_goods_owner_file_path }" 
				onclick="toImgDetail('http://10.21.37.249/ciq-video/showVideo?filePath=${laboratoryList.fileMounth},${laboratoryList.fileDate},${laboratoryList.chk_goods_owner_file_path }"/>
				<span>${laboratoryList.chk_goods_owner_cre_dt }</span>
				</td>
			<td>抽/采样人员签字：</td>
			<td>
				<img style="width:80px;height:80px" src="http://10.21.37.249/ciq-video/showVideo?filePath=${laboratoryList.fileMounth},${laboratoryList.fileDate},${laboratoryList.chk_cre_file_path }" 
				onclick="toImgDetail('http://10.21.37.249/ciq-video/showVideo?filePath=${laboratoryList.fileMounth},${laboratoryList.fileDate},${laboratoryList.chk_cre_file_path }"/>
				<span>${laboratoryList.chk_cre_dt }</span>
			</td>
		</tr>
	</table>
</body>
</html>