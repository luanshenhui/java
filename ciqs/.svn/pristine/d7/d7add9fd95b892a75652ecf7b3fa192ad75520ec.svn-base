<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>企业监督检查表</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 

</script>
<style type="text/css">
table{
    font-size: 15px;
    width:800px;
}
tr{
    height: 35px;
}
td{
    border: 1px solid #000;
}
.tableLine_1,.tableLine_2{
    font-size:25px;
    font-family:'楷体_GB2312';
    font-weight: bold;
    width:800px;
    text-align:center;
}
.col_title{
	text-align:center
}
.tableLine_3{
    font-size:20px;
    font-family:'楷体_GB2312';
    text-align:right;
    border-color: white  white  #000 white;
}
.tableLine_title{
    height:180px;
    width:40px;
}
.tableCol_1{
    height:30px;
    width:210px;
}
.tableCol_2{
    height:30px;
    width:200px;
}
.tableCol_3{
    width:190px;
}
.tableCol_4{
    width:100px;
}
.tableCol_5{
    width:100px;
}
.tableCol_6{
    width:55px;
}
.tableCol_7{
    width:55px;
}
.tableCol_8{
    width:55px;
}
.tableCol_9{
    width:55px;
}
.tableLine_8,.tableLine_11{    
    height:110px;
}
.tableLine_9_2,.tableLine_12_2{
   border-style:hidden;
}
.tableLine_9_3,.tableLine_12_3{
   border-top-style:hidden;
   border-bottom-style:hidden;
}
.tableLine_10_2,.tableLine_13_2{
   border-right-style:hidden;
}
.tableLine_14{
   height:145px;
   border-bottom-style:hidden;
}
.tableLeft{
    display: block;
    margin-left: 0px;
    float: left;
}
.tableRight{
    display: block;
    float: right;
    margin-right: 20px;
}
.tableWords{
    display: block;
    white-space: normal;
    width: 651px;
}
    
</style>
</head>
<script type="text/javascript">
	$(function(){
		$("#imgd1").hide();
		$("#CuPlayerMiniV").hide();
	});
	
	//图片预览
	function showPic(path){
	    url = "/ciqs/showVideo?imgPath="+path;
		$("#imgd1").attr("src",url);
		$("#imgd1").click();	
	}
	
	/**
	 * 查看视频
	 * path 数据库保存的视频地址 E:/201708/20170823/22.3gp
	 * wangzhy
	 */
	function showVideo(path){
	    path=path.substring(path.indexOf('/')+1,path.length);
		$("#CuPlayerMiniV").show();
		CuPlayerMiniV(path);
	}
	
/**
 * 关闭视频
 * wangzhy
 */
function hideVideo(){
	$("#CuPlayerMiniV").hide();
}
</script>
<body>
<div id="content">
  <form id="form" action="/ciqs/generalPunishment/toPage" method="post">
  <input type="hidden" name="id" value="${id }"/>
  <input type="hidden" name="step" value="${step }"/>
  <input type="hidden" name="update" value="update"/>
  <input type="hidden" name="page" value="gp_lian_spb"/>
  
  <input type="hidden" name="doc_id" value="${doc.doc_id }"/>
  <table class="table">
  	<tr>
  	  <td colspan="5" class="tableLine_1">备案出口食品生产企业监督检查表</td>
  	</tr>
  	<tr>
  	  <td colspan="5" align="left">企业名称：${compname }</td>
  	</tr>
    <tr>
      <td class="tableCol_1 col_title"><span>《出口食品生产企业安全卫生要求》内容</span></td>
      <td class="tableCol_2 col_title"><span>企业落实要求</span></td>
      <td class="tableCol_3 col_title"><span>递交证据</span></td>
      <td class="tableCol_4 col_title"><span>符合性</span></td>
      <td class="tableCol_5 col_title"><span>记录方式</span></td>
    </tr>
    <tr>
      <td colspan="5">第二条（基本原则）  申请出口备案的食品生产、加工、储存企业（以下简称出口食品生产企业）应依照国家和相关进口国（地区）法律、法规和食品安全卫生标准进行生产、加工、储存、运输等，并遵守以下基本原则：</td>
    </tr>
    <tr>
      <td>（一）承担食品安全的主体责任</td>
      <td>企业遵守国内外相关法律、法规、标准并承担主体责任。</td>
      <td>
      	<c:forEach items="${V_SP_A_C_1.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_1.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_1.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      </td>
      <td>${V_SP_A_C_1.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）建立和实施以危害分析和预防控制措施为核心的食品安全卫生控制体系，并保证体系有效运行</td>
      <td>企业建立和有效实施以危害分析和预防控制措施为核心的食品安全卫生控制体系；体系需包含第三条和其他有程序建立要求条款中所明确的内容。</td>
      <td>提供企业的质量手册和程序文件<br/>
      	<c:forEach items="${V_SP_A_C_2.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_2.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_2.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      </td>
      <td>${V_SP_A_C_2.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）保留食品链的食品安全信息，保持产品的可追溯性</td>
      <td>企业建立了保留食品链的安全信息的制度，并保持产品可追溯性。记录备查。</td>
      <td>
      	<c:forEach items="${V_SP_A_C_3.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_3.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_3.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      </td>
      <td>${V_SP_A_C_3.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）配备与生产相适应的专业技术人员和卫生质量管理人员；</td>
      <td>企业的专业技术人员和卫生质量管理人员的能力数量可与生产相匹配。</td>
      <td>提供两类人员的名单，包括姓名、学历、工作和培训经历、资格证书（若有）<br/>
      	<c:forEach items="${V_SP_A_C_4.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_4.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_4.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      </td>
      <td>${V_SP_A_C_4.check.check_disc }</td>
    </tr>
    <tr>
      <td>（五）评估生产过程中存在的人为故意污染风险及可能的突发问题，建立预防性控制措施，必要时实施食品防护计划</td>
      <td>企业要对可能的人为蓄意污染行为和各种突发问题建立预防控制措施，做好应急准备；在必要时，建立和实施食品防护计划。企业的应急预案和食品防护计划（必要时）备查</td>
      <td>
      	<c:forEach items="${V_SP_A_C_5.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_5.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_5.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      </td>
      <td>${V_SP_A_C_5.check.check_disc }</td>
    </tr>
    <tr>
      <td>（六）建立诚信机制，确保提供的资料和信息真实有效</td>
      <td>企业建立诚信体系，为向检验检疫机构等提供的资料负责</td>
      <td>提供诚信体系文件<br/>
      	<c:forEach items="${V_SP_A_C_6.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_6.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_6.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      </td>
      <td>${V_SP_A_C_6.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第三条 （食品安全卫生控制体系组成及运行）  出口食品生产企业应建立并有效运行食品安全卫生控制体系，并达到如下要求：</td>
    </tr>
    <tr>
      <td>（一）分析产品的来源、预期用途、包装方式、消费方式及产品工艺流程等信息，识别食品本身和生产加工过程中可能存在的危害，采取相应的预防控制措施；对影响食品安全卫生的关键工序，应制定明确的操作规程，保证控制有效、及时纠正偏差、持续改进不足，做好记录；</td>
      <td>根据产品说明（包括来源、预期用途、包装方式、储存条件和消费方式）和工艺，识别食品本身和生产过程可能存在的危害，确定预防措施；对关键工序，进行监控、纠偏、持续改进不足等，并有效记录。
记录备查。
	  </td>
      <td>提供产品说明和工艺流程图；
提供食品本身和生产过程相关的潜在危害；
提供对关键工序的监控、纠偏、持续改进不足措施的程序文件。<br/>
		<c:forEach items="${V_SP_A_C_7.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_7.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_7.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_7.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_7.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）建立并有效执行原辅料、食品添加剂、食品相关产品的合格供应商评价程序；</td>
      <td>企业建立并有效实施合格供应商评价程序。
记录备查
	  </td>
      <td>
        <c:forEach items="${V_SP_A_C_8.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
      <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_8.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_8.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_8.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_8.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）建立并有效执行食品加工卫生控制程序，确保加工用水（冰）、食品接触表面、加工操作卫生、人员健康卫生、卫生间设施、外来污染物、虫害防治、有毒有害物质等处于受控状态，并记录；</td>
      <td>企业建立并有效实施合格供应商评价程序。
记录备查
	  </td>
      <td>
        <c:forEach items="${V_SP_A_C_9.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_9.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_9.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_9.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_9.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）建立并有效执行产品追溯系统，准确记录并保持食品链相关食品安全信息和批次、标识信息，实现产品追溯的完整性和有效性；</td>
      <td>企业建立并有效实施全过程的标识和追溯体系。
记录备查
	  </td>
      <td>
		提供某工作日从原辅料、加工到成品入库各环节的全套追溯记录<br/>
		<c:forEach items="${V_SP_A_C_10.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_10.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_10.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_10.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_10.check.check_disc }</td>
    </tr>
    <tr>
      <td>（五）建立并有效执行产品召回制度，确保出厂产品在出现安全卫生质量问题时及时发出警示，必要时召回；</td>
      <td>企业建立并有效执行产品召回制度。
记录备查
	  </td>
      <td>
        <c:forEach items="${V_SP_A_C_11.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_11.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_11.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_11.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_11.check.check_disc }</td>
    </tr>
    <tr>
      <td>（六）建立并有效执行对不合格品的控制制度，包括不合格品的标识、记录、评价、隔离和处置等内容；</td>
      <td>企业建立和有效执行对不合格品的控制制度。
记录备查
	  </td>
      <td>
        <c:forEach items="${V_SP_A_C_12.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_12.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_12.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_12.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_12.check.check_disc }</td>
    </tr>
    <tr>
      <td>（七）建立并有效执行加工设备、设施的维护程序，保证加工设备、设施满足生产加工的需要；</td>
      <td>企业建立并有效执行设备、设施的维护保养程序。
记录备查
	  </td>
      <td>
        <c:forEach items="${V_SP_A_C_13.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_13.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_13.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_13.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_13.check.check_disc }</td>
    </tr>
    <tr>
      <td>（八）建立并有效执行员工培训计划并做好培训记录，保证不同岗位的人员熟练完成本职工作；</td>
      <td>企业建立并有效执行对各类员工的培训计划并做好培训记录，培训内容应与相关岗位相匹配。记录备查</td>
      <td>
		提供当年的培训计划<br/>
		<c:forEach items="${V_SP_A_C_14.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_14.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_14.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_14.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_14.check.check_disc }</td>
    </tr>
    <tr>
      <td>（九）建立管理体系内部审核制度，持续完善改进企业的安全卫生控制体系；</td>
      <td>企业建立并有效执行内部审核制度，持续改进。
记录备查
	  </td>
      <td>
		提供当年的培训计划<br/>
		<c:forEach items="${V_SP_A_C_15.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_15.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_15.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_15.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_15.check.check_disc }</td>
    </tr>
    <tr>
      <td>（十）对反映产品卫生控制情况的有关记录，应制定并执行标记、收集、编目、归档、存储、保管和处理等管理规定。所有记录应真实、准确、规范并具有可追溯性，保存期不少于2年。</td>
      <td>企业建立和有效实施记录管理规定，记录真实、准确、规范。相关记录保存期不少于2年。</td>
      <td>
        <c:forEach items="${V_SP_A_C_16.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_16.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_16.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_16.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_16.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第四条 （必须实施危害分析与关键控制点（HACCP）体系验证的企业类型）</td>
    </tr>
    <tr>
      <td>列入必须实施危害分析与关键控制点（HACCP）体系验证的出口食品生产企业范围的出口食品生产企业，应按照国际食品法典委员会《HACCP体系及其应用准则》的要求建立和实施HACCP体系。</td>
      <td>列入范围的企业，需按照国际食品法典委员会的要求建立了控制所有显著危害的HACCP计划，并有效、持续地实施。
HACCP支持性文件，CCP的监控、纠偏、验证记录备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_17.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_17.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_17.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_17.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_17.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第五条 （生产和管理人员） 出口食品生产企业应保证其生产和管理人员适合其岗位需要，并符合下列要求：</td>
    </tr>
    <tr>
      <td>（一）进入生产区域应保持良好的个人清洁卫生和操作卫生；进入车间时应更衣、洗手、消毒；工作服、帽和鞋应保持清洁卫生；</td>
      <td>进入生产区域的人员应保持清洁卫生和操作卫生。应制定个人卫生检查要求，每日填写个人卫生检查表。</td>
      <td>
		<c:forEach items="${V_SP_A_C_18.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_18.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_18.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_18.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_18.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="2">（二）与食品生产相关的人员应经体检合格后方可上岗，凡出现伤口感染或者患有可能污染食品的皮肤病、消化道疾病或呼吸道疾病者，应立即报告其症状或疾病，不得继续工作；</td>
      <td>与食品生产相关人员应定期体检、体检合格后方可上岗。
企业人员花名册和参加体检人员记录备查
	  </td>
      <td>提供相关人员体检证<br/>
      	<c:forEach items="${V_SP_A_C_19.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_19.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_19.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_19.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_19.check.check_disc }</td>
    </tr>
    <tr>
      <td>卫生管理人员应对员工的健康状况进行检查，患病后不得继续工作。员工患病后处理记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_81.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_81.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_81.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_81.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_81.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）从事监督、指导、员工培训的卫生质量管理人员，应熟悉国家和相关进口国（地区）的相关法律法规、食品安全卫生标准，具备适应其工作相关的资质和能力，考核合格后方可上岗。</td>
      <td>企业的卫生质量管理人员熟悉相关法律法规标准，具备相应资质和能力；能够回答检查人员的询问。相关的国内外法律、法规、标准备查。</td>
      <td>提供相关法律法规、食品安全卫生标准的清单<br/>
      	<c:forEach items="${V_SP_A_C_20.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_20.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_20.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_20.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_20.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第六条 （环境卫生）出口食品生产企业的厂区环境应避免污染，并符合下列要求：</td>
    </tr>
    <tr>
      <td>（一）企业选址应远离有毒有害场所及其他污染源，其设计和建造应避免形成污垢聚集、接触有毒材料，厂区内不得兼营、生产、存放有碍食品卫生的其他产品；</td>
      <td>厂区选址、设计、建造时，应保证周边及内部不存在有碍食品卫生的情况。
厂区内所有房间均可开启、备查。
	  </td>
      <td>提供厂区门口照片、厂区平面图<br/>
      	<c:forEach items="${V_SP_A_C_21.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_21.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_21.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_21.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_21.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）生产区域宜与非生产区域隔离，否则应采取有效措施使得生产区域不会受到非生产区域污染和干扰；</td>
      <td>生产区不受非生产区的污染和干扰。</td>
      <td>
		<c:forEach items="${V_SP_A_C_22.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_22.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_22.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_22.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_22.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）建有与生产能力相适应并符合卫生要求的原料、辅料、成品、化学物品和包装物料的储存设施，以及污水处理、废弃物和垃圾暂存等设施；</td>
      <td>相应储存设施、污水处理、废弃物和垃圾暂存等设施与生产能力相匹配。
企业的生产能力、各储存库的面积和储存能力数据备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_23.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_23.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_23.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_23.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_23.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）主要道路应铺设适于车辆通行的硬化路面（如混凝土或沥青路面等），路面平整、无积水、无积尘；</td>
      <td>厂区地面符合要求</td>
      <td>
		<c:forEach items="${V_SP_A_C_24.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_24.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_24.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_24.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_24.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="2">（五）避免存有卫生死角和蚊蝇孳生地，废弃物和垃圾应用防溢味、不透水、防腐蚀的容器具盛放和运输，放置废弃物和垃圾的场所应保持整洁，废弃物和垃圾应及时清理出厂；</td>
      <td>厂区内没有卫生死角和蚊蝇滋生地；盛放和运输废弃物的容器，应防溢味、不透水、防腐蚀</td>
      <td>
		<c:forEach items="${V_SP_A_C_25.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_25.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_25.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_25.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_25.check.check_disc }</td>
    </tr>
    <tr>
      <td>放置废弃物和垃圾的场所保持整洁，废弃物和垃圾应及时清理出厂</td>
      <td>
		<c:forEach items="${V_SP_A_C_84.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_84.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_84.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_84.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_84.check.check_disc }</td>
    </tr>
    <tr>
      <td>（六）卫生间应有冲水、洗手、防蝇、防虫、防鼠设施，保持足够的自然通风或机械通风，保持清洁、无异味；</td>
      <td>厂区卫生间具有相应设施，可洗手、通风、清洁、防蝇虫、无异味。</td>
      <td>
		<c:forEach items="${V_SP_A_C_26.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_26.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_26.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_26.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_26.check.check_disc }</td>
    </tr>
    <tr>
      <td>（七）排水系统应保持畅通、无异味</td>
      <td>厂区排水没有拥堵、外溢，无异味</td>
      <td>
		<c:forEach items="${V_SP_A_C_27.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_27.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_27.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_27.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_27.check.check_disc }</td>
    </tr>
    <tr>
      <td>（八）应有防鼠、防虫蝇设施，不得使用有毒饵料；不宜饲养与生产加工无关的动物，为安全目的饲养的犬只等不得进入生产区域；</td>
      <td>企业防鼠、防蝇虫措施符合要求；若为外包，有委托书或合同。不饲养与生产无关的动物，为安全目的饲养的犬只等不得进入生产区域。防鼠、防蝇虫图和设施备查。</td>
      <td>提供照片和委托书或合同<br/>
      	<c:forEach items="${V_SP_A_C_28.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_28.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_28.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_28.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	${V_SP_A_C_28.check.check_disc }
      </td>
    </tr>
    <tr>
      <td>（九）生产中产生的废水、废料、烟尘的处理和排放应符合国家有关规定。</td>
      <td>废水、废料、烟尘的处理符合国家有关规定</td>
      <td>提供废水、废料、烟尘的处理记录<br/>
      	<c:forEach items="${V_SP_A_C_29.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_29.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_29.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_29.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_29.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第七条（车间及设施）  食品生产加工车间及设施均应设置合理，易于进行适当的维护和清洗，与食品接触的物品、装置和设备表面均应保持清洁、光滑，以合适的频次进行有效清洗和消毒，并符合下列要求：</td>
    </tr>
    <tr>
      <td rowspan="3">（一）车间的面积、高度应与生产能力和设备的安置相适应，满足所加工的食品工艺流程和加工卫生要求；车间地面应用防滑、密封性好、防吸附、易清洗的无毒材料修建，具有便于排水和清洗的构造，保持清洁、无积水，确保污水从清洁区域流向非清洁区域；车间出口及与外界连通处应有防鼠、防虫蝇措施；</td>
      <td>车间的面积、高度与生产能力相适应；布局合理。
企业各车间面积和人员数量的数据备查，车间内所有房间备查
	  </td>
      <td>提供车间平面图
和主要工序照片<br/>
		<c:forEach items="${V_SP_A_C_30.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_30.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_30.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_30.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_30.check.check_disc }</td>
    </tr>
    <tr>
      <td>车间地面材料符合要求、无积水，污水流向合理。</td>
      <td>地面材质：<br/>
      	<c:forEach items="${V_SP_A_C_31.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_31.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_31.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_31.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_31.check.check_disc }</td>
    </tr>
    <tr>
      <td>车间出口处，排水口、通风口有有效的防虫防鼠／防虫设施。</td>
      <td>
      	<p>车间出口处采用：</p><br/>
      	<c:forEach items="${V_SP_A_C_32.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      	<!-- 
		<p><input type="checkbox" disabled="disabled"/>风幕</p>
		<p><input type="checkbox" disabled="disabled"/>水幕</p>
		<p><input type="checkbox" disabled="disabled"/>暗道</p>
		<p><input type="checkbox" disabled="disabled"/>帘子</p>
		<p><input type="checkbox" disabled="disabled"/>其他</p>
		 -->
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_32.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_32.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_32.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_32.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）车间内墙面、门窗应用浅色、密封性好、防吸附、易清洗的无毒材料修建，保持清洁、光滑，必要时应消毒，可开启的窗户应装有防虫蝇窗纱；</td>
      <td>车间内墙面、门窗材料符合要求；可开启的窗户装有防虫蝇窗纱</td>
      <td>
      	<c:forEach items="${V_SP_A_C_33.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_33.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_33.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_33.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_33.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）车间屋顶或者天花板及架空构件应能防止灰尘、霉斑和冷凝水的形成以及脱落，保持清洁；</td>
      <td>车间屋顶、天花板及架空构件能防止灰尘、霉斑和冷凝水，保持清洁。
企业控制冷凝水的措施备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_34.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_34.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_34.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_34.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_34.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）车间内应具备充足的自然或人工照明，光线以不改变被加工物的本色为宜，光线强度应能保证生产、检验各岗位正常操作；固定的照明设施应具有保护装置，防止碎片落入食品；</td>
      <td>所有车间内有足够的照明设施；光线强度适宜；固定的照明设施应具有保护装置。
所有人工照明设施均可开启、备查
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_35.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_35.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_35.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_35.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_35.check.check_disc }</td>
    </tr>
    <tr>
      <td>（五）在有温度、湿度控制要求的工序和场所安装温湿度显示装置；</td>
      <td>在有温湿度控制要求的工序和场所，安装温湿度显示装置。关键工序的温湿度显示装置的温度准确性及校准记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_36.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_36.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_36.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_36.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	${V_SP_A_C_36.check.check_disc }
      </td>
    </tr>
    <tr>
      <td>（六）车间应具有适宜的自然或机械通风设施，保持车间内通风良好。进排风系统在设计和建造上应便于维护和清洁，使空气从高清洁区域流向低清洁区域；</td>
      <td>车间内通风良好。空气从清洁区域流向非清洁区域</td>
      <td>
		<c:forEach items="${V_SP_A_C_37.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_37.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_37.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_37.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_37.check.check_disc }</td>
    </tr>
    <tr>
      <td>（七）在车间内适当的地点设足够数量的洗手、消毒、干手设备或者用品、鞋靴消毒设施，洗手水龙头应为非手动开关，必要时车间还应供应用于洗手的适宜温度热水；</td>
      <td>车间内有足够数量的洗手、消毒、干手设备或者用品、鞋靴消毒设施（适用时），洗手水龙头为非手动开关；必要时，车间还应供应温水</td>
      <td>
		<c:forEach items="${V_SP_A_C_38.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_38.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_38.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_38.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_38.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="2">（八）设有与车间连接并与员工数量相适应的更衣室，不同清洁要求的区域设有单独的更衣室，视需要设立符合卫生要求的卫生间，更衣室和卫生间应保持清洁卫生、无异味，其设施和布局应避免对车间造成污染；</td>
      <td>更衣室与车间相连接、与员工数量匹配，不同清洁程度要求的区域设有单独的更衣室</td>
      <td>
		<c:forEach items="${V_SP_A_C_39.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_39.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_39.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_39.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_39.check.check_disc }</td>
    </tr>
    <tr>
      <td>更衣室、卫生间保持清洁卫生，其设施和布局不得对车间造成污染</td>
      <td>
		<c:forEach items="${V_SP_A_C_82.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_82.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_82.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_82.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_82.check.check_disc }</td>
    </tr>
    <tr>
      <td>（九）车间内宜有独立区域用于食品容器和工器具的清洗消毒，防止清洗消毒区域对加工区域的污染，清洗消毒设施应易于清洁，具有充分的水供应和排水能力，必要时供应热水；</td>
      <td>清洗消毒工器具的区域不会对加工区域造成污染；
清洗消毒区设施应易于清洁，必要时，有热水工艺。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_40.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_40.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_40.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_40.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_40.check.check_disc }</td>
    </tr>
    <tr>
      <td>（十）与食品接触的设备和容器（一次性使用的容器和包装除外），应用耐腐蚀、防锈、防吸附、易清洗的无毒材料制成，其构造应易于清洗消毒，摆放整齐并维护良好；</td>
      <td>食品接触表面材料符合要求，易于清洗消毒，无锈、无损坏</td>
      <td>
		<c:forEach items="${V_SP_A_C_41.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_41.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_41.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_41.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_41.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="2">（十一）盛装废弃物及非食用产品的容器应由防渗透材料制成并予以特别标明。盛装化学物质的容器应标识，必要时上锁；</td>
      <td>盛装废弃物及非食用产品容器的材料符合要求且有标识</td>
      <td>
		<c:forEach items="${V_SP_A_C_42.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_42.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_42.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_42.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_42.check.check_disc }</td>
    </tr>
    <tr>
      <td>盛装化学物质的容器有明显标识，必要时上锁。</td>
      <td>
		<c:forEach items="${V_SP_A_C_43.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_43.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_43.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_43.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_43.check.check_disc }</td>
    </tr>
    <tr>
      <td>（十二）应设有充分的污水排放系统并保持通畅，应设有适宜的废弃物处理设施，避免其污染食品或生产加工用水；</td>
      <td>污水排放和废弃物处置符合要求，不会污染食品或加工用水</td>
      <td>
		<c:forEach items="${V_SP_A_C_44.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_44.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_44.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_44.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_44.check.check_disc }</td>
    </tr>
    <tr>
      <td>（十三）原辅料库应满足储存要求，保持卫生和整洁，必要时控制温度和湿度；不同原辅料分别存放，避免受到损坏和污染。</td>
      <td>车间内的原辅料储藏设施要符合要求，防止受到污染</td>
      <td>
		<c:forEach items="${V_SP_A_C_45.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_45.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_45.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_45.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_45.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第八条 （水） 生产加工用水（包括冰、蒸汽）应确保安全卫生，并符合以下要求：</td>
    </tr>
    <tr>
      <td>（一）属于城市供水的，应按当地卫生行政部门要求每年检测并取得官方出具的检测合格证明；</td>
      <td>生产加工用水若使用自来水，每年一次送到官方机构进行检测，并且检测合格。</td>
      <td>
		<c:forEach items="${V_SP_A_C_46.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_46.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_46.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_46.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_46.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）属于自备水源的，应在使用前经当地卫生行政部门检测合格；使用中应至少每半年检测一次并取得官方出具的检测合格证明；</td>
      <td>若为自备水源，在使用前及每半年一次送到官方机构进行检测，并且检测合格。</td>
      <td>
		<c:forEach items="${V_SP_A_C_47.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_47.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_47.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_47.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_47.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）进口国（地区）对水质有明确要求的，按相关要求执行；</td>
      <td>若进口国（地区）有额外要求，需要遵照执行。记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_48.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_48.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_48.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_48.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_48.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）储水设施、输水管道应用无毒材料制成，出水口应有防止回流的装置。储水设施应建在无污染区域，定期清洗消毒，并加以防护；</td>
      <td>适用时，储水设施、输水管道须符合卫生要求；出水口应有防止回流的装置</td>
      <td>
		<c:forEach items="${V_SP_A_C_49.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_49.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_49.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_49.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_49.check.check_disc }</td>
    </tr>
    <tr>
      <td>（五）非生产加工用水应在充分标识的独立系统中循环，不得进入生产加工用水系统。</td>
      <td>适用时，非饮用水管道独立且标识清楚，不得进入饮用水系统。</td>
      <td>
		<c:forEach items="${V_SP_A_C_50.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_50.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_50.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_50.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_50.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第九条 （原辅料、食品添加剂、食品相关产品）出口食品生产企业应采取有效措施保证原辅料、食品添加剂、食品相关产品的安全性，符合下列要求：</td>
    </tr>
    <tr>
      <td>（一）根据原辅料特性，应避免其初级生产过程中受到环境污染物、农业投入品、化学物质、有害生物和动植物病害等污染；</td>
      <td>对原辅料供应商现场审核时，关注初级生产过程中，是否受到环境污染物、农业投入品、化学物质、有害生物和动植物病害的污染。记录备查。</td>
      <td>提供对初级农产品供应商的现场审核文件（适用时）<br/>
      	<c:forEach items="${V_SP_A_C_51.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
      </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_51.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_51.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_51.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_51.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）应采购、使用符合安全卫生规定要求的原辅料、食品添加剂、食品相关产品，要求供应商提供许可证和产品合格证明文件，并对供应商进行全面评价；对无法提供合格证明文件的食品原辅料，应依照食品安全标准进行检验；</td>
      <td>原辅料、食品添加剂、食品相关产品的采购符合要求，要求供应商提供相应证明并对其全面评价；对无法提供合格证明文件的原辅料进行检验。
供应商评价、采购、检验记录备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_52.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_52.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_52.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_52.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_52.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）二次加工的动物源性原料应来自检验检疫机构备案的出口食品生产企业；</td>
      <td>对于次级生产商，其动物源性原料，应来自检验检疫机构备案的出口食品企业。记录备查</td>
      <td>
		<c:forEach items="${V_SP_A_C_53.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_53.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_53.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_53.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_53.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）不改变食品性状或仅进行简单切割、不使用其他物理或化学方法处理食品的分包装出口食品生产企业，其原料应来自检验检疫机构备案的出口食品生产企业；</td>
      <td>分包装企业，其原料来自检验检疫机构备案的出口食品企业。记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_54.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_54.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_54.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_54.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_54.check.check_disc }</td>
    </tr>
    <tr>
      <td>（五）进口原辅料应提供有效的出口国（地区）证明文件及检验检疫机构出具的进口检验合格证明；</td>
      <td>进口原辅料应有出口国（地区）证明文件及CIQ的合格证明。
记录备查（适用时）。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_55.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_55.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_55.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_55.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_55.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="3">（六）应建立食品原辅料、食品添加剂、食品相关产品进货查验记录制度，如实记录其名称、规格、数量、供货者名称及联系方式、进货日期等内容；食品的原辅料、食品添加剂、食品相关产品经进厂验收合格后方准使用；超过保质期的以及非食品用途的原辅料、食品添加剂、食品相关产品不应用于食品生产；</td>
      <td>建立进货查验制度，相关记录内容符合要求。
记录备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_56.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_56.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_56.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_56.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_56.check.check_disc }</td>
    </tr>
    <tr>
      <td>具备原辅料、食品添加剂、食品相关产品的验收标准；每批有验收合格后才使用。
验收标准和记录备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_84.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_84.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_84.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_84.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_84.check.check_disc }</td>
    </tr>
    <tr>
      <td>有对超过保质期的原辅料、食品添加剂、食品相关产品的处置符合规定。记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_57.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_57.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_57.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_57.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_57.check.check_disc }</td>
    </tr>
    <tr>
      <td>（七）应依照国家和相关进口国（地区）标准中食品添加剂的品种、使用范围、用量的规定使用食品添加剂。</td>
      <td>企业使用食品添加剂需符合相关要求。添加剂的要求及使用记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_58.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_58.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_58.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_58.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_58.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第十条 （加工）。食品生产加工过程应防止交叉污染，确保产品适合消费者食用，并符合下列要求：</td>
    </tr>
    <tr>
      <td>（一）加工工艺应设计合理，防止交叉污染；根据加工工艺和产品特性，通过物理分隔或时间交错，将不同清洁卫生要求的区域分开设置，控制加工区域人流、物流方向，防止交叉污染；</td>
      <td>加工过程应防止发生各类交叉污染；不同清洁卫生要求的区域须分开设置。</td>
      <td>
		<c:forEach items="${V_SP_A_C_59.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_59.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_59.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_59.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_59.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）根据加工工艺、产品特性和预期消费方式，控制加工时间、产品温度和车间的环境温度，保证温度测量装置的准确性并定期进行校准；</td>
      <td>适用时，建立并有效实施对有温度控制要求的工艺，进行加工时间、产品温度和环境温度的控制；经常测量温度显示装置的准确性、定期对其校准。准确性检测和校准记录备查。</td>
      <td>有温度控制要求的工艺：<br/>
		<c:forEach items="${V_SP_A_C_60.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_60.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_60.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_60.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_60.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）应对速冻、冷藏、冷却、热处理、干燥、辐照、化学保藏、真空或改良空气包装等与食品安全卫生密切相关的特殊加工环节进行有效控制，应有科学的依据或国际公认的标准证明该环节采取的措施能够满足安全卫生要求；</td>
      <td>适用时，企业对其特殊加工环节进行有效控制，控制措施应有依据</td>
      <td>
      	<p>特殊环节名称：</p>
		<p>控制措施的依据：</p>
		<p>提供文件</p><br/>
		<c:forEach items="${V_SP_A_C_61.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_61.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_61.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_61.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_61.check.check_disc }</td>
    </tr>
    <tr>
      <td>（四）建立并有效执行生产设备、工具、容器、场地等清洗消毒程序，班前班后进行卫生清洁工作，专人负责检查；</td>
      <td>建立并执行车间内的清洗消毒程序，专人负责检查。
每日清洗消毒记录现场备查
	  </td>
      <td>
      	<p>文件名称：</p>
		<p>第   页</p>
		<p>提供文件</p><br/>
		<c:forEach items="${V_SP_A_C_62.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_62.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_62.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_62.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_62.check.check_disc }</td>
    </tr>
    <tr>
      <td>（五）盛放食品的容器不得直接接触地面；对加工过程中产生的不合格品、跌落地面的产品和废弃物，用有明显标志的专用容器分别收集盛装，并由专人及时处理，其容器和运输工具及时消毒；</td>
      <td>对盛放食品的容器、不合格品、跌落地面产品、废弃物的管理符合要求。</td>
      <td>
		<c:forEach items="${V_SP_A_C_63.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_63.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_63.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_63.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_63.check.check_disc }</td>
    </tr>
    <tr>
      <td>（六）加工过程中产生的废水、废料不得对产品及车间卫生造成污染；</td>
      <td>废水、废料不对产品和车间卫生造成污染</td>
      <td>
		<c:forEach items="${V_SP_A_C_64.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_64.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_64.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_64.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_64.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="3">（七）内外包装过程应防止交叉污染，必要时内外包装间应分开设置；用于包装食品的内、外包装材料符合安全卫生标准并保持清洁和完整，防止污染食品；再次利用的食品内外包装材料要易于清洁，必要时要进行消毒；包装标识应符合国家和相关进口国（地区）有关法律法规标准要求；包装物料间应保持干燥，内、外包装物料分别存放，避免受到污染。</td>
      <td>内外包装过程要防止交叉污染；包装材料要防止污染食品</td>
      <td>
		<c:forEach items="${V_SP_A_C_65.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_65.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_65.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_65.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_65.check.check_disc }</td>
    </tr>
    <tr>
      <td>包装的标识应符合国家和相关进口国（地区）有关法律法规标准的要求。
国内外对标识的要求备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_66.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_66.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_66.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_66.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_66.check.check_disc }</td>
    </tr>
    <tr>
      <td>包装物料间保持干燥。内、外包材分开存放，防止受到污染。</td>
      <td>
      	<!-- 
		<p><input type="checkbox" disabled="disabled"/>不同区域</p>
      	<p><input type="checkbox" disabled="disabled"/>独立库房</p>
      	<p><input type="checkbox" disabled="disabled"/>其他：</p>
      	 -->
      	<c:forEach items="${V_SP_A_C_67.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_67.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_67.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_67.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_67.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第十一条 （储存、运输）出口食品的储存、运输过程应卫生清洁，并符合下列要求：</td>
    </tr>
    <tr>
      <td>（一）储存库应保持清洁，定期消毒，有防霉、防鼠、防蝇虫设施；库内产品应有明显标识以便追溯，并与墙壁、地面保持一定距离；库内不得存放有碍卫生的物品；</td>
      <td>储存库及库内产品应符合要求</td>
      <td>
		<c:forEach items="${V_SP_A_C_68.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_68.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_68.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_68.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_68.check.check_disc }</td>
    </tr>
    <tr>
      <td rowspan="2">（二）预冷库、速冻库、冷藏库应满足产品温度、湿度控制要求，配备自动温度记录装置并定期校准；定期除霜，除霜操作不得污染库内产品或造成库内产品不符合温度要求；</td>
      <td>各类冷库的温度、湿度符合工艺要求，配备自动温度记录装置。每日人工检测并与自动温度记录装置比对，定期校准。记录备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_69.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_69.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_69.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_69.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      <td>${V_SP_A_C_69.check.check_disc }</td>
    </tr>
    <tr>
      <td>定期除霜，除霜操作不得污染库内产品或造成库内产品不符合温度要求；</td>
      <td>
		<c:forEach items="${V_SP_A_C_70.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_70.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_70.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_70.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_70.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）运输工具应保持卫生清洁并维护良好，根据产品特点配备防雨、防尘、制冷、保温等设施；运输过程中保持必要的温度和湿度，确保产品不受损坏和污染，必要时应将不同食品进行有效隔离。</td>
      <td>运输工具符合卫生要求，并根据产品特点配备相关设施。</td>
      <td>
		<c:forEach items="${V_SP_A_C_71.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_71.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_71.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_71.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_71.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第十二条（化学物品）企业使用化学物品应避免污染产品，并符合下列要求：</td>
    </tr>
    <tr>
      <td>（一）厂区、车间和实验室使用的洗涤剂、消毒剂、杀虫剂、燃油、润滑油、化学试剂等应专库存放，标识清晰，建立并严格执行化学品储存和领用管理规定，设立专人保管并记录，按照产品的使用说明谨慎使用；</td>
      <td>化学物品应专库存放，标识清晰，建立并严格执行化学品储存和领用管理规定，有专人保管并记录。
记录备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_72.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_72.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_72.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_72.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_72.check.check_disc }</td>
    </tr>
    <tr>
      <td>（二）在生产加工区域临时使用的化学物品应专柜上锁并由专人保管；</td>
      <td>在生产加工区域临时使用的化学物品，应专柜上锁并由专人保管</td>
      <td>
		<c:forEach items="${V_SP_A_C_73.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_73.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_73.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_73.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_73.check.check_disc }</td>
    </tr>
    <tr>
      <td>（三）避免对食品、食品接触表面和食品包装物料造成污染。</td>
      <td>化学物品的使用，应避免对食品、食品接触表面、食品包装物料造成污染。</td>
      <td>
		<c:forEach items="${V_SP_A_C_74.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_74.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_74.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_74.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>${V_SP_A_C_74.check.check_disc }</td>
    </tr>
    <tr>
      <td colspan="5">第十三条 （检测）。企业应通过检测监控产品的安全卫生，并符合下列要求：</td>
    </tr>
    <tr>
      <td rowspan="3">（一）企业如内设实验室，其应布局合理，避免对生产加工和产品造成污染，应配备相应专业技术资格的检测人员，具备开展工作所需要的实验室管理文件、标准资料、检验设施和仪器设备；检测仪器应按规定进行计量或校准；应按照规定的程序和方法抽样，按照相关国家标准、行业标准、企业标准等对产品进行检测判定，并保有检测结果记录；</td>
      <td>若有内设实验室，则不可对生产加工和产品造成污染。
检验人员具备履行实验室程序和检测要求的能力。
	  </td>
      <td>
		<p>提供照片及实验室人员的相关资质证明。</p><br/>
		<c:forEach items="${V_SP_A_C_75.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_75.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_75.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_75.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	${V_SP_A_C_75.check.check_disc }
      </td>
    </tr>
    <tr>
      <td>实验室具备相应的管理文件、标准资料、检验设施和仪器设备，实验设备需经过校准和计量。相关资料备查。</td>
      <td>
		<c:forEach items="${V_SP_A_C_76.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_76.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_76.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_76.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	${V_SP_A_C_76.check.check_disc }
      </td>
    </tr>
    <tr>
      <td>应按照规定抽样、检验和判定，并保有相应检验记录。
记录备查。
	  </td>
      <td>
		<c:forEach items="${V_SP_A_C_77.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_77.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_77.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_77.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	${V_SP_A_C_77.check.check_disc }
      </td>
    </tr>
    <tr>
      <td>（二）企业如委托社会实验室，其承担的企业产品检测项目，应具有经主管部门认定或批准的相应资质和能力，并签订合同。</td>
      <td>如果企业有外部委托实验室，应有委托合同，被委托实验室具有相关资质。</td>
      <td>
		<p>适用时，提供委托合同和被委托实验室的资质证明</p><br/>
		<c:forEach items="${V_SP_A_C_78.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_78.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_78.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_78.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	${V_SP_A_C_78.check.check_disc }
      </td>
    </tr>
    <tr>
      <td colspan="5">第十四条（新技术/新工艺/传统生产工艺）  新技术/新工艺应提供科学的依据或国际公认的标准证明其符合安全卫生要求。</td>
    </tr>
    <tr>
      <td>新技术/新工艺应提供科学的依据或国际公认的标准证明其符合安全卫生要求，经主管部门批准后方可应用</td>
      <td>若有新技术/新工艺，应提供依据或证明，经主管部门批准后方可使用。</td>
      <td>
		<c:forEach items="${V_SP_A_C_79.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_79.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_79.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_79.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	<p>${V_SP_A_C_79.check.check_disc }</p>
      </td>
    </tr>
    <tr>
      <td>在保证食品安全卫生的前提下，必要时可按传统工艺生产加工产品。</td>
      <td>若有传统工艺，须有保证食品安全卫生的措施</td>
      <td>
		<p>相关措施：</p><br/>
		<c:forEach items="${V_SP_A_C_80.files }" var="file">
      		<c:if test="${file.file_type == 1 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${file.file_name}')"/>
      		</c:if>
      		<c:if test="${file.file_type == 2 }">
      			<img style="cursor: pointer;" src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="视频查看" onclick="showVideo('${file.file_name}')"/>
      		</c:if>
      	</c:forEach>
	  </td>
	  <td>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_80.check.check_result == '1' }">checked="checked"</c:if>/>符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_80.check.check_result == '2' }">checked="checked"</c:if>/>不符合</p>
      	<p><input type="checkbox" disabled="disabled" <c:if test="${V_SP_A_C_80.check.check_result == '3' }">checked="checked"</c:if>/>不适用</p>
      </td>
      <td>
      	<p>${V_SP_A_C_80.check.check_disc }</p>
      </td>
    </tr>
    <tr>
      <td>相关注册卫生规范和进口国（地区）技术法规、相关议定书或中方的相关承诺确定的卫生要求。</td>
      <td></td>
      <td></td>
	  <td></td>
      <td></td>
    </tr>
    <tr>
      <td style="border-bottom-width: 0px; border-right-width: 0px; text-align: left;">检查组长签名：</td>
      <td colspan="4" style="border-bottom-width: 0px; border-left-width: 0px; text-align: left">检查组成员签名：</td>
    </tr>
    <tr rowspan="2">
      <td colspan="5" style="border-bottom-width: 0px; border-top-width: 0px;"></td>
    </tr>
    <tr>
      <td colspan="2" style="border-bottom-width: 0px; border-right-width: 0px; border-top-width: 0px;"></td>
      <td colspan="3" style="border-bottom-width: 0px; border-left-width: 0px; border-top-width: 0px; text-align: left;">企业负责人签名：</td>
    </tr>
    <tr>
      <td colspan="5" style="border-top-width: 0px;"><span class="tableRight">${doc.option_35 } 年     ${doc.option_36 }   月   ${doc.option_37 }   日</span></td>
    </tr>
  </table>
  <input type="button" style="margin: 40px 40px 0px 660px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
  <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="关闭" onclick=" window.close()"/>
  </form>
</div>   
<!-- 图片 -->
<div class="row" style="z-index:200000;">
 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
      	<div class="docs-galley" style="z-index:200000;">
	       	<ul class="docs-pictures clearfix" style="z-index:200000;">
         		<li>
         			<img id="imgd1" style="z-index:200000;" <%-- data-original="${ctx}/static/viewer/assets/img/tibet-1.jpg" --%> 
         			src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
         		</li>
	       	</ul>
      	</div>
   	</div>
</div>
<!--酷播迷你 CuPlayerMiniV3.0 代码开始-->
<div id="CuPlayerMiniV" style="width:620px;height:500px;position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;">
<div style="width:30px;margin:0px 500px 0px 602px;background:white;cursor: pointer;" onclick="hideVideo()">关闭</div>
<div id="CuPlayer" style="position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;"> 
<strong>提示：您的Flash Player版本过低！</strong> 
<script type="text/javascript">
function CuPlayerMiniV(path){
	var so = new SWFObject("/ciqs/cuplayer/CuPlayerMiniV3_Black_S.swf","CuPlayer","600","400","9","#000000");
	so.addParam("allowfullscreen","true");
	so.addParam("allowscriptaccess","always");
	so.addParam("wmode","opaque");
	so.addParam("quality","high");
	so.addParam("salign","lt");
	so.addVariable("CuPlayerFile","http://localhost:7001/ciqs/showVideo?imgPath="+path);
	so.addVariable("CuPlayerImage","/ciqs/cuplayer/Images/flashChangfa2.jpg");
	so.addVariable("CuPlayerLogo","/ciqs/cuplayer/Images/Logo.png");
	so.addVariable("CuPlayerShowImage","true");
	so.addVariable("CuPlayerWidth","600");
	so.addVariable("CuPlayerHeight","400");
	so.addVariable("CuPlayerAutoPlay","false");
	so.addVariable("CuPlayerAutoRepeat","false");
	so.addVariable("CuPlayerShowControl","true");
	so.addVariable("CuPlayerAutoHideControl","false");
	so.addVariable("CuPlayerAutoHideTime","6");
	so.addVariable("CuPlayerVolume","80");
	so.addVariable("CuPlayerGetNext","false");
	so.write("CuPlayer");
}
</script>
</div>
</div>     
</body>
</html>