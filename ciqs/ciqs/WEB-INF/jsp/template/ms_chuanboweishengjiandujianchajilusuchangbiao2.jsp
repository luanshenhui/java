<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>船舶卫生监督检查记录表
</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div{
   width:1000px;
   margin: 5px auto;
}
/* div{
   overflow:auto;
   font-size: 22px;
} */
.chatTitle{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
}
.tableheadLine {
	border: 1px solid #000;
	font-weight:bold;
}
.tableLine{
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
	padding-left: 3px;
	padding-right: 3px;
}
.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px; 
}
.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}
.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}
</style>
</head>
<body>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>  	
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>   	 	
<script type="text/javascript">
	$(function(){
      $.ajax({
    			url:"findHlthcheckdetail"+location.search,
    			type:"get",
    			dataType:"json",
    			success:function(data){
    			        if(data.status=="OK"){
    			             var results=data.results;
    			             
    			        }
    			}
    	});
	//图片预览
	function showPic(path){
	    url = "/ciqs/showVideo?imgPath="+path;
		$("#imgd1").attr("src",url);
		$("#imgd1").click();		
	}
</script>
<div>
<div class="chatTitle">船舶卫生监督检查记录表宿舱Quarters</div>
	  	<div style="font-weight:bold" align="center"></div>
	   	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
	  		<tr>
			 <td  height="44" align="center" class="tableheadLine"  >
				检查项目
			</td>
			 <td  height="44" align="center" class="tableheadLine" >
				检查要点
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine" >
				检查结果			
			</td>
			 <td  height="44" width="120" align="center" class="tableheadLine" >
				所见证据
			</td>
			<td  height="44" width="120"  align="center" class="tableheadLine" >
				采样
			</td>
			<td  height="44" width="120"  align="center" class="tableheadLine"  >
				检疫处理
			</td>
			</tr>
			
			<tr>
			<td height="44" align="center" class="tableheadLine">
				通风采光Ventilation and lighting
			</td>
			<td height="44" align="center" class="tableLine">
				采光良好
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox" /><br/>   
				否No<input type="checkbox" /> <br/>   
			</td>
			<td height="44" align="center" class="tableLine">
					
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
			</tr>
			<tr>
				<td height="44" align="center" class="tableLine" rowspan="2">
				
				</td>
				<td height="44" align="center" class="tableLine" >
					无灰尘、废弃物、媒介生物、孳生地和化学物质污染等
				</td>
				<td height="44" align="center" class="tableLine" >
					是Yes<input type="checkbox" /> <br/>   
					否No<input type="checkbox" /> <br/>   
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
			</tr>
			
			<tr>
				<td height="44" align="center" class="tableLine" >
					有清洁和维护计划
				</td>
				<td height="44" align="center" class="tableLine" >
					是Yes<input type="checkbox"  /> <br/>   
					否No<input type="checkbox"/> <br/>   
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
				<td height="44" align="center" class="tableLine">
					
				</td>
			</tr>
			
	  </table>
	  
	
	 <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>
<!-- 图片 -->
	<div class="row" style="z-index:200000;visibility: hidden;">
	 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
	      <div class="docs-galley" style="z-index:200000;">
	        	<ul class="docs-pictures clearfix" style="z-index:200000;">
	          	<li>
	          	<img id="imgd1" style="z-index:200000;"src="/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
	          	</li>
	        	</ul>
	      </div>
	   	</div>
	</div>
</body>
</html>