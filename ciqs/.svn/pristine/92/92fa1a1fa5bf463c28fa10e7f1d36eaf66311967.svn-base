<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>有无可疑病例</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 

</script>
<style type="text/css">
table{
    font-size: 15px;
    width:800px;
    margin-top: 50px;
}
tr{
    height: 35px;
}
td{
    border: 1px solid #000;
}
.col_title{
	text-align:center;
	font-weight: bold;
}
</style>
</head>
<script type="text/javascript">
function showTemplate(doc_id){
	window.open("processtemplate?doc_id="+doc_id);
}
</script>
<body>
<div id="content">
  	<form id="form" action="/ciqs/generalPunishment/toPage" method="post">
	  	<input type="hidden" name="id" value="${id }"/>
	  	<input type="hidden" name="page" value="gp_lian_spb"/>
	  	<input type="hidden" name="doc_id" value="${doc.doc_id }"/>
	  	<div style="text-align: center; font-size: 30px; font-weight: 600;">有无可疑病例</div>
	  	<table class="table">
	    	<tr>
	      		<td class="col_title"><span>1.流行病学调查（表）结果</span></td>
	      		<td class="col_title"><span>2.医学检查结果</span></td>
		      	<td class="col_title"><span>3.采样（采、未采）</span></td>
		      	<td class="col_title"><span>4.实验室结果</span></td>
		      	<td class="col_title"><span>5.结论判定</span></td>
		      	<td class="col_title"><span>6.处置</span></td>
		      	<td class="col_title"><span>7.检疫处理</span></td>
	    	</tr>
	    	<tr>
	      		<td>
					<span id="V_D_OC_PAGE_2_1" class="vList">
						<c:forEach items="${V_JC_T_Y_D_3 }" var="v">
							<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
						</c:forEach>
					</span>
				</td>
	      		<td>
					<span id="V_D_OC_PAGE_2_1" class="vList">
						<c:forEach items="${V_D_OC_PAGE_2_1 }" var="v">
							<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
						</c:forEach>
					</span>
				</td>
	      		<td>
					<span id="V_D_OC_PAGE_2_2" class="vList">
						<c:forEach items="${V_D_OC_PAGE_2_2 }" var="v">
							<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
						</c:forEach>
					</span>
				</td>
	      		<td>${results.OPTION_1}</td>
	      		<td>${results.OPTION_2}</td>
	      		<td>
	      			1.无处置；<br/>
	      			2.送医院，<a style="cursor: pointer;" onclick="showTemplate('')">口岸传染病疑似病例转诊单.doc</a><br/>
	      		</td>
	      		<td>
					<span id="V_D_OC_PAGE_2_4_NT" class="vList">
						<c:forEach items="${V_D_OC_PAGE_2_4_NT }" var="v">
							<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
						</c:forEach>
					</span>
				</td>
	    	</tr>
	    	<tr>
	      		<td>
					<a style="cursor: pointer;" onclick="showTemplate('')">入境船舶检疫查验记录表</a>
				</td>
	      		<td></td>
	      		<td></td>
	      		<td></td>
	      		<td></td>
	      		<td>
	      			<span id="V_D_OC_PAGE_2_3" class="vList">
						<c:forEach items="${V_D_OC_PAGE_2_3 }" var="v">
							<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
						</c:forEach>
					</span>
	      		</td>
	      		<td></td>
	    	</tr>
	  	</table>
  	</form>
  	<input type="button" style="margin: 40px 40px 0px 560px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>        
</body>
</html>