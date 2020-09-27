<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品生产企业备案</title>
<%@ include file="/common/resource_show.jsp"%>
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
			$("#imgd1").hide();
			$("#CuPlayerMiniV").hide();
		});
		
		function toImgDetail(path){
			url = "/ciqs/showVideo?imgPath="+path;
			$("#imgd1").attr("src",url);
			$("#imgd1").click();
		}
// 		function hideVideo(){
// 			$("#CuPlayerMiniV").hide();
// 		}
// 		function showVideo(path){
// 			$("#CuPlayerMiniV").show();
// 			CuPlayerMiniV(path);
// 		}
		
		function checkthis(e){
			$(e).parent().parent().find('input:checked').attr("checked",false);
			$(e).attr("checked","checked");
			$(e).prop("checked","checked");
		}
		
		function loading(){
			location.href="downLoading"+location.search;
		}
		
		function update(){
			var list=new Array();
			$("table tr").each(function(){	
			var obj = new Object();  
// 			var l=$(this).find('input[type="checkbox"]');
			var l=$(this).find('input[type="text"][class!="myadd"]');
				if(l && l.length>1){
					obj.check_disc=$(this).find('input').eq(0).val();    
					obj.check_code_id= $(this).find('input')[0].getAttribute("name");
					obj.id= $(this).find('input')[0].getAttribute("data-id");
// 					obj.check_result= $(this).find('input[type="checkbox"][checked="checked"]').val();
					obj.verdict=$(this).find('input').eq(1).val();
					obj.apply_no=$("#apply_no").val();    
					list.push(obj);
				}
	    	});
	    	var json_str = JSON.stringify(list);
				$.post("${ctx}/expFoodPOF/update",{
					list : json_str,
					docId:$("#docId").val(),
					t1:$("#t1").val(),
					n1:$("#n1").val(),
					t2:$("#t2").val(),
					n2:$("#n2").val()
				}, function(res) {
					if(res=="sucess"){
						alert("修改成功");
					}
				});
		}
		
	</script>
<style type="text/css">
a:link, a:visited {
/*     color:white; */
    text-decoration: none;
}
<!--
.tableLine {
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
/* @media print { */
/* .noprint{display:none} */
/* } */
-->
</style>
</head>
<body  class="bg-gary">
<div class="freeze_div_list">
		<div class="title-bg">
			<div class=" title-position margin-auto white">
				<div class="title">
				<span class="font-24px" style="color:white;">行政许可 /</span><a id="title_a" style="color: white;" href="/ciqs/expFoodPOF/expFoodList">出口食品生产企业备案</a>
				</div>
				<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
			</div>
		</div>
	</div>
<%-- <%@ include file="../myOrg.jsp"%> --%>
<div class="blank_div_dtl" style="height: 70px">
</div>
<div class="margin-auto width-1200  data-box">
<div><h2 ><span style="margin-left: 190px;">出口食品生产企业备案现场审核不符合项及跟踪报告</span></h2>
	  <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;margin-left: 190px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
              <td width="167" height="44" align="center" class="tableLine">企业名称
              <input type="hidden" id="apply_no" value="${apply_no}"/>
              </td>
              <td width="167" height="44" align="center" class="tableLine" colspan="3">${compName}</td>
      </tr>
      <tr>
              <td width="167" height="44" align="center" class="tableLine">不符合项描述</td>
              <td width="167" height="44" align="center" class="tableLine" colspan="2">违反的审核依据内容及条款号</td>
<!--               <td width="167" height="44" align="center" class="tableLine">现场查验</td> -->
              <td width="200" height="44" align="center" class="tableLine">整改完成情况及跟踪审核结论</td>
<!--               <td width="167" height="44" align="center" class="tableLine">说明</td> -->
      </tr>
      <c:if test="${not empty list}">
      	<c:forEach items="${list}" var="row" >
       		<tr>
<!--     	   	  <td width="167" height="44" align="center" class="tableLine">${row.check_title}</td> -->
			  <td width="167" height="44" align="center" class="tableLine">
			  <input type="text" style="border: none;outline: none" name="${row.check_code_id}"  data-id="${row.id}"   value="${row.check_disc}" />
			  </td>
              <td width="167" height="44" align="center" class="tableLine" colspan="2">条款号：${row.tk_nubmer}<br/>${row.check_contents}
              </td>
<!--               <td width="167" height="44" align="center" class="tableLine"> -->
<!--                <c:if test="${not empty row.eventList}"> -->
<!-- 	              <c:forEach items="${row.eventList}" var="row2"> -->
<!-- 		              <c:if test="${row2.fileType == 1}"> -->
<!-- 		             	  <div><a href="javascript:void(0);" onclick="toImgDetail('${row2.fileName}')">查看图片文件</a></div> -->
<!-- 		              </c:if> -->
<!-- 	              </c:forEach> -->
<!-- 	              <c:forEach items="${row.eventList}" var="row2"> -->
<!-- 		              <c:if test="${row2.fileType == 2}"> -->
<!-- 		             	 <div><a href="javascript:void(0);" onclick="showVideo('${row2.fileName}')">查看视频文件</a></div> -->
<!-- 		              </c:if> -->
<!-- 	              </c:forEach> -->
<!--               </c:if> -->
<!--               <c:if test="${empty row.eventList}"> -->
<!-- 		        	  无文件 -->
<!--               </c:if> -->
<!--               </td> -->
              <td width="167" height="44" align="center" class="tableLine">
<!--                <div><input type="checkbox" value="1" onclick="checkthis(this)"  <c:if test="${row.check_result == 1}"> checked="checked" </c:if>/> 符合</div> -->
<!--               <div><input type="checkbox"  value="2" onclick="checkthis(this)"  <c:if test="${row.check_result == 2}"> checked="checked" </c:if>/> 不符合</div> -->
<!--               <div><input type="checkbox"  value="3" onclick="checkthis(this)"  <c:if test="${row.check_result == 3}"> checked="checked" </c:if>/> 不适用</div> -->
               <input type="text" style="border: none;outline: none"   value="${row.verdict}" />
              </td>
<!--               <td width="167" height="44" align="center" class="tableLine">${row.check_disc}</td> -->
            </tr>
            </c:forEach>
      </c:if>
      
       <c:if test="${not empty listQt}">
      	<c:forEach items="${listQt}" var="row" >
       		<tr>
      		<c:if test="${row.option3 == 1}">
			  <td width="167" height="44" align="center" colspan="1" class="tableLine">
			  <input type="text" style="border: none;outline: none" name="option" data-id="${row.docId}"  value="${row.option4}" />
			  </td>
			   <td width="167" height="44" align="center" colspan="2" class="tableLine">${row.option5}</td>
              <td width="167" height="44" align="center" colspan="1" class="tableLine">
               <input type="text" style="border: none;outline: none"   />
              </td>
            </c:if>
            </tr>
            </c:forEach>
      </c:if> 
      
       <tr>
              <td width="167" height="44" align="center" class="tableLine" colspan="2">
              	<div style="margin-top: 25px;">以上不符合项，必须在      ${doc.option1}   日内完成整改。</div>
           		<div style="margin-top: 25px;">评审组长（签名）：
           		<c:if test="${not empty doc.option2}">
	       			<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${doc.option2}" alt="xx" /> 
       			</c:if>
           		        日期：      ${doc.option3} </div>
           		<div style="margin-top: 25px;">企业负责人：    
           		<c:if test="${not empty doc.option4}">
	       			<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${doc.option4}" alt="xx" /> 
       			</c:if>
           		       日期：              ${doc.option5}  </div>
              </td>
            <%--   <td width="167" height="44" align="center" class="tableLine" colspan="3">
				<div style="margin-top: 35px;">跟踪检查人（签名）：  
				<c:if test="${not empty doc.option6}">
	       			<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${doc.option6}" alt="xx" /> 
       			</c:if>
				  日期：   ${doc.option7}</div>
				<div style="margin-top: 35px;">企业负责人：  
				<c:if test="${not empty doc.option8}">
	       			<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${doc.option8}" alt="xx" /> 
       			</c:if>
					  日期：  ${doc.option9}</div>
				<div style="margin-top: 35px;">
				<c:if test="${not empty doc.option10}">
	       			<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${doc.option10}" alt="xx" /> 
       			</c:if>
				</div>
			</td> --%>
			 <td width="167" height="44" align="center" class="tableLine" colspan="3">
               <input type="hidden" id="docId" value="${docId}"/>
				<div style="margin-top: 35px;">跟踪检查人（签名）：   <input type="text" id="n1" value="${doc.option6}" class="myadd" placeholder="签名" style="border: none;outline: none;width: 50px;"   />
				  日期：<input type="text" placeholder="日期" class="myadd" value="${doc.option7}" id="t1" style="border: none;outline: none;width: 50px;"   /></div>
				<div style="margin-top: 35px;">企业负责人：   <input type="text" class="myadd" value="${doc.option8}" id="n2" placeholder="签名" style="border: none;outline: none;width: 40px;"   />
					  日期：  <input type="text" class="myadd" placeholder="日期" id="t2" value="${doc.option9}" style="border: none;outline: none;width: 40px;" /></div>
				<div style="margin-top: 35px;">
				</div>
			</td>
      </tr> 
      </table>
           <!-- 图片查看 -->
		<div class="row" style="z-index:200000;">
	 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
	      <div class="docs-galley" style="z-index:200000;">
	        	<ul class="docs-pictures clearfix" style="z-index:200000;">
	          	<li>
	          	<img id="imgd1" style="z-index:200000;"
	          	src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg"  />
	          	</li>
	        	</ul>
	      </div>
	   	</div>
	</div>  
    </div> 
</div>
	<div style="text-align: left;margin: auto;margin-top: 10px;width:600px;padding-bottom: 10px;">
			<input type="button" class="search-btn" style="display: inline;" value="修改"  onclick="update()"/>
			<input type="button" class="search-btn" style="display: inline;" value="下载"  onclick="loading()"/>
			<input type="button" class="search-btn" style="display: inline;" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
		<%@ include file="/common/player.jsp"%>
</body>
</html>
