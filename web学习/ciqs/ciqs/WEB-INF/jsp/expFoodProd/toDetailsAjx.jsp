<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品生产企业备案</title>
<%@ include file="/common/resource_show.jsp"%>
<link type="text/css" rel="stylesheet" href="${ctx}/static/dec/styles/dpn.css" />
		
<style type="text/css">
	input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
</style>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"/>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"/>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"/>
<style>
a:link, a:visited {
    color:white;
    text-decoration: none;
}
.mutd {
    border: solid 1px #dcdcdc;
}
</style>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript"> 
		$(function(){
			  $.ajax({
    			url:"getDetailsListData"+location.search,
    			type:"get",
    			dataType:"json",
    			success:function(data){
    				var o = data.obj;
    				var certificationList = data.certificationList;
    				var equipmentList = data.equipmentList;
    				var checkEquList = data.checkEquList;
    				var productList = data.productList;
    				var fileList =  data.fileList;
	    			if(o){
	    				var t0=$("#t0");
	    				var t1=$("#t1");
		    			var t3=$("#t3");
		    			t0.children().remove();
		    			t1.children().remove();
		    			t3.children().remove();
		    				t0.append(
		    				  "<tr class=\"table_xqlbbj\">"+
							  	"<td width='34%'>生产企业名称 :<span>"+o.orgname+"</span></td>"+
							  	"<td width='33%'>本次备案厂区及车间简称 :<span>"+o.factoryname+"</span></td>"+
							  	"<td width='33%'>组织机构代码 :<span>"+o.orgcode+"</span></td>"+
							  "</tr>"+
							  "<tr>"+
							  	"<td>备案受理机构 :<span>"+o.accpetorgname+"</span></td>"+
							  	"<td>法人或授权负责人:<span>"+o.headname+"</span></td>"+
							  	"<td>E-Mail:<span>"+o.email+"</span></td>"+
							  "</tr>"+
							  "<tr class=\"table_xqlbbj\">"+
							  	"<td>邮政编码:<span>"+o.zipcode+"</span></td>"+
							  	"<td>电话传真:<span>"+o.movetel+"</span></td>"+
							  	"<td>联系人姓名:<span>"+o.contactname+"</span></td>"+
							  "</tr>"+
							  "<tr>"+
							  	"<td>联系人电话 :<span>"+o.movetel+"</span></td>"+
							  	"<td>营业执照编号 :<span>"+o.blno+"</span></td>"+
							  	"<td>营业执照成立日期 :<span>"+new Date(o.bldate).toLocaleDateString().replace("/", "-").replace("/", "-")+"</span></td>"+
							  "</tr>"+
							  "<tr class=\"table_xqlbbj\">"+
							  	"<td>生产企业地址（指实际生产地址）:<span>"+o.fullname+"</span></td>"+
							  	"<td></td>"+
							  	"<td></td>"+
							  "</tr>"
		    				);
		    				
		    				t1.append(
		    				 "<tr class=\"table_xqlbbj\">"+
							  	"<td width='34%'>厂区面积:<span>"+o.factoryarea+"</span> 平方米 </td>"+
							  	"<td width='33%'>建厂时间:<span>"+new Date(o.cfdate).toLocaleDateString().replace("/", "-").replace("/", "-")+"</span></td>"+
							  	"<td width='33%'>最后改扩建时间 :<span>"+new Date(o.lccfdate).toLocaleDateString().replace("/", "-").replace("/", "-")+"</span></td>"+
							  "</tr>"+
							  "<tr>"+
							  	"<td>加工车间总面积:<span>"+o.wsarea+"</span>平方米</td>"+
							  	"<td>冷藏库容量:<span>"+o.coldcap+"</span>吨</td>"+
							  	"<td>冷藏库面积:<span>"+o.warehosearea+"</span>平方米</td>"+
							  "</tr>"+
							  "<tr class=\"table_xqlbbj\">"+
							  	"<td>本次申请品种的车间面积:<span>"+o.awsarea+"</span>平方米</td>"+
							  	"<td>仓库面积:<span>"+o.warehosearea+"</span>平方米</td>"+
							  	"<td>仓库容量:<span>"+o.warehosecap+"</span>吨</td>"+
							  "</tr>"+
							  "<tr>"+
							  	"<td>速冻库容积:<span>"+o.frozenarea+"</span>平方米</td>"+
							  	"<td>速冻库容量:<span>"+o.frozencap+"</span>吨</td>"+
							  	"<td>速冻机能力:<span>"+o.frozenabi+"</span>吨/时</td>"+
							  "</tr>" +
							  "<tr class=\"table_xqlbbj\">"+
							  	"<td>最后改扩建内容（1000字以内）:<span>"+o.lccfcontent+"</span></td>"+
							  	"<td></td>"+
							  	"<td></td>"+
							  "</tr>" 
		    				);
		    			
		    				t3.append(
			    				"<tr class=\"table_xqlbbj\"><td align='right' valign='middle' width='20%' style='padding: 10px' class='mutd'>管理负责人姓名：</td><td valign='middle' width='26%' align='center' ><span style='color: red'>*</span>总负责人：<span>"+o.mahead+"</span></td>"+
									"<td align='center' valign='middle' width='26%' style='padding: 10px'><span style='color: red'>*</span>生产负责人：<span>"+o.prohead+"</span></td><td align='center' valign='middle' width='26%'><span style='color: red'>*</span>质量管理负责人：<span>"+o.quahead+"</span></td></tr>"+
								"<tr><td align='right' valign='middle' width='20%' style='padding: 10px' class='mutd'>企业人数：</td><td valign='middle' width='26%' align='center' ><span style='color: red'>*</span>总人数：<span>"+o.mano+"</span></td><td><span style='color: red'>*</span>生产人员数：<span>"+o.prono+"</span></td>"+
									"<td align='center' valign='middle' width='26%'><span style='color: red'>*</span>质量管理人员数：<span>"+o.quano+"</span></td></tr>"+
								"<tr class=\"table_xqlbbj\"><td align='right' valign='middle' width='20%' style='padding: 10px' class='mutd'>HACCP实施情况：</td><td valign='middle' width='26%'>HACCP实施时间：<span>"+o.haccpdate+"</span></td><td colspan='2'>HACCP小组成员：<span>"+o.haccptemnames+"</span></td></tr>"+
								"<tr><td align='right' valign='middle' width='20%' style='padding: 10px' class='mutd'>企业内审员：</td><td valign='middle' colspan='3'><span>"+o.internalauditor+"</span></td></tr>"
		    				);
				    	
						var html1="<tr>"+
			    					"<td align='right' valign='middle' width='20%' style='padding: 10px' >生产企业认证情况：</td>"+
									"<td valign='middle' colspan='3' style='padding: 0px'>"+
										"<table border='0' align='center' class='table-date' width='100%'>"+
											"<tr>"+
												"<td width='25%'>认证种类</td><td width='25%'>认证机构</td><td width='25%'>认证编号</td><td width='25%'>有效期限</td>"+
											"</tr>";
				    	for(var i=0;i<certificationList.length;i++){
								html1+="<tr><td><span>"+certificationList[i].cerkind+"</span></td><td><span>"+certificationList[i].cerorg+"</span></td><td><span>"+certificationList[i].cerno+"</span></td><td><span>"+new Date(certificationList[i].limitdate).toLocaleDateString().replace("/", "-").replace("/", "-")+"</span></td></tr>";
				    	}
				    	html1+="</table></td></tr>";
		    			t3.append(html1);
// 		    			for(var i=0;i<list.length;i++){
							t3.append("<tr><td align='right' valign='middle' width='20%' style='padding: 10px' class='mutd'>食品安全卫生控制体系运行状况（1000字以内）：</td><td colspan='3'><span>"+o.foodsafetysit+"</span></td></tr>");
// 				    	}	
		    			var html2="<tr>"+
									"<td align='right' valign='middle' width='20%' style='padding:10px'>"+
										"<span style='color: red'>*</span>主要生产设备："+
									"</td>"+
									"<td valign='middle' width='80%' colspan='3' style='padding: 0px'>"+
										"<table border='0' align='center' class='table-date' width='100%'>"+
											"<tr>"+
												"<td width='20%'>设备名称</td><td width='20%'>规格型号</td><td width='20%'>购置年份</td><td width='20%'>运行现状</td><td width='20%'>操作负责人</td>"+
											"</tr>";
						for(var i=0;i<equipmentList.length;i++){
								html2+="<tr><td><span>"+equipmentList[i].equname+"</span></td><td><span>"+equipmentList[i].equspec+"</span></td><td><span>"+new Date(equipmentList[i].purdate).toLocaleDateString().replace("/", "-").replace("/", "-")+"</span></td><td><span>"+equipmentList[i].runquo+"</span></td><td><span>"+equipmentList[i].operhead+"</span></td></tr>";
				    	}					
						html2+="</table></td></tr>";
						t3.append(html2);
// 						for(var i=0;i<list.length;i++){
							t3.append("<tr><td align='right' valign='middle' width='20%' style='padding: 10px' class='mutd'>企业实验室获得资质认定的情况（1000字以内）：</td><td colspan='3'><span>"+o.aptitudesit+"</span></td></tr>");
// 				    	}	
				    	var html3="<tr>"+
									"<td align='right' valign='middle' width='20%' style='padding: 10px'>"+
										"<span style='color: red'>*</span>主要检验设备："+
									"</td>"+
									"<td valign='middle' style='padding: 0px' width='80%' colspan='3'>"+
										"<table border='0' align='center' class='table-date' width='100%'>"+
											"<tr>"+
												"<td width='20%'>设备名称</td><td width='20%'>检测项目</td><td width='20%'>计量检定情况</td><td width='20%'>操作负责人</td><td width='20%'>备注</td>"+
											"</tr>";
						for(var i=0;i<checkEquList.length;i++){
							html3+="<tr><td><span>"+checkEquList[i].equname+"</span></td><td><span>"+checkEquList[i].checkproject+"</span></td><td><span>"+checkEquList[i].culatesitua+"</span></td><td><span>"+checkEquList[i].operperson+"</span></td><td><span>"+checkEquList[i].note+"</span></td></tr>";
				    	}	
				    	html3+="</table></td></tr>";
				    	t3.append(html3);
	    			}
	    			if(productList.length>0){
	    				for(var i=0;i<productList.length;i++){
	    					if(productList[i].producttype==1){
	    						$("#tt").append("<tr><td><span>"+productList[i].productkind+"</span></td><td><span>"+productList[i].productname+"</span></td><td><span>"+productList[i].regtrademark+"</span></td><td><span>"+productList[i].productabi+"</span></td><td><span>"+productList[i].exportarea+"</span></td></tr>");
	    					}
	    					if(productList[i].producttype==2){
	    						$("#to").append("<tr><td><span>"+productList[i].productkind+"</span></td><td><span>"+productList[i].productname+"</span></td><td><span>"+productList[i].regtrademark+"</span></td><td><span>"+productList[i].productabi+"</span></td><td><span>"+productList[i].exportarea+"</span></td></tr>");
	    					}
	    				}
	    			}
	    			if(fileList.length>0){
	    				var t4=$("#t4");
	    				for(var i=0;i<fileList.length;i++){
	    					t4.append("<tr class=\"table_xqlbbj2\"><td width='30%'>"+
	    				//	"<img src="+li1[i].attach_list+" width='60' height='20' title='查看' onclick='toImgDetail(\""+li1[i].attach_list+"\")'/>"+
	    					"<span>"+fileList[i].filename+"</span></td>"+
	    					"<td><span>"+new Date(fileList[i].startdate).toLocaleDateString().replace("/", "-").replace("/", "-")+"</span></td><td>"+
// 	    					"<a href='javascript:toImgDetail(\""+fileList[i].filename+"\")'><span class=\"title-cxjg_xq\">查看+</span></a>&nbsp;&nbsp;"+
// 	    					"<a href='javascript:download(\""+fileList[i].path+fileList[i].filename+"\")'><span class=\"title-cxjg_xq\">下载+</span></a>"+
	    					"<a href='fileList?fileid="+fileList[i].accessoryid+"&filetype="+fileList[i].filetype+"&filename="+fileList[i].filename+"&path="+fileList[i].path+"&startdate="+fileList[i].startdateStr+"'><span class=\"title-cxjg_xq\">下载+</span></a>"+
	    					"</td></tr>");
	    				}
	    			}  
	    			$("span").each(function(k,v){
							if($(v).text()=='undefined' || $(v).text()=='null'){
								$(v).text("  ");
							}
	    			});
    			}
    		}); 
		});

		function FormSubmit(){
			$("#select_form").attr("action", "/ciqs/expFoodPOF/expFoodList");
			$("#Intercepe_form").attr("method", "get");
			$("#select_form").submit();
		}
		/**
		 * 显示图片浏览
		 * path 数据库保存的图片地址 201708/20170823/1B083FEA24D6E00004df8.jpg
		 * wangzhy
		 */
		function toImgDetail(path){
		    //var url ="/ciqs/showVideo?imgPath=201708/20170823/tibet-1.jpg";
			var url = "/ciqs/showVideo?imgPath="+path;
			$("#imgd1").attr("src",url);
			$("#imgd1").click();
		}
		
		function download(file){
			window.location.href="/ciqs/expFoodPOF/download?fileName="+file;
		}
</script>

</head>
<body class="bg-gary">
<%@ include file="myOrg.jsp"%>
<!-- 图片查看 -->
		<div class="row" style="z-index:200000;">
		 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
		      <div class="docs-galley" style="z-index:200000;">
		        	<ul class="docs-pictures clearfix" style="z-index:200000;">
		          	<li>
		          	<img id="imgd1" style="z-index:200000;display: none" src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
		          	</li>
		        	</ul>
		      </div>
		   	</div> 
		</div>
<!-- *************************************************************************************** -->
<div class="title-cxjg">企业基本信息</div>
<div class="margin-chx">
<table class="table-xqlb" border="0" cellspacing="0" cellpadding="0" id="t0">
  <tr class="table_xqlbbj">
  	<td width="34%">生产企业名称 : </td>
  	<td width="33%">本次备案厂区及车间简称 :</td>
  	<td width="33%">组织机构代码 :</td>
  </tr>
  <tr>
  	<td>备案受理机构 :</td>
  	<td>法人或授权负责人:</td>
  	<td>E-Mail:</td>
  </tr>
  <tr>
  	<td>邮政编码:</td>
  	<td>电话传真:</td>
  	<td>联系人姓名:</td>
  </tr>
  <tr>	
  	<td>联系人电话 :</td>
  	<td>营业执照编号 :</td>
  	<td>营业执照成立日期 :</td>
  </tr> 
  <tr>	
  	<td>生产企业地址（指实际生产地址）:</td>
  	<td></td>
  	<td></td>
  </tr> 
</table>
</div>
<div class="title-cxjg">厂区基本信息</div>
<div class="margin-chx">
<table class="table-xqlb" border="0" cellspacing="0" cellpadding="0" id="t1">
  <tr>
  	<td width="34%">厂区面积: </td>
  	<td width="33%">建厂时间:</td>
  	<td width="33%">最后改扩建时间 :</td>
  </tr>
  <tr>
  	<td>加工车间总面积:</td>
  	<td>冷藏库容量:</td>
  	<td>冷藏库面积:</td>
  </tr>
  <tr>
  	<td>本次申请品种的车间面积:</td>
  	<td>仓库面积:</td>
  	<td>仓库容量:</td>
  </tr>
  <tr>	
  	<td>速冻库容积:</td>
  	<td>速冻库容量:</td>
  	<td>速冻机能力:</td>
  </tr> 
  <tr>	
  	<td>最后改扩建内容（1000字以内）:</td>
  	<td></td>
  	<td></td>
  </tr> 
</table>
</div>
<div class="title-cxjg">产品信息（本次申请的产品列表）</div>
	<div class="margin-chx">
		<table class="table-xqlb" border="0" cellspacing="0" cellpadding="0" id="tt">
			<tr class="table_xqlbbj">
				<td style="width:15%">产品类别</td>
				<td style="width:25%">产品名称</td>
				<td style="width:15%">注册商标</td>
				<td style="width:25%">设计生产能力（吨/年）</td>
				<td style="width:20%">主要出口国家或地区</td>
			</tr>
		</table>
	</div>
<div class="title-cxjg">产品信息（其他产品列表）</div>
	<div class="margin-chx">
		<table class="table-xqlb" border="0" cellspacing="0" cellpadding="0" id="to">
			<tr class="table_xqlbbj">
				<td style="width:15%">产品类别</td>
				<td style="width:25%">产品名称</td>
				<td style="width:15%">注册商标</td>
				<td style="width:25%">设计生产能力（吨/年）</td>
				<td style="width:20%">主要出口国家或地区</td>
			</tr>
		</table>
	</div>
	<div class="title-cxjg">人员、认证、设备信息</div>
		<div class="margin-chx">
		<table class="table-xqlb" border="0" cellspacing="0" cellpadding="0"id="t3">
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px" class="mutd">
						管理负责人姓名:
					</td>
					<td valign="middle" width="26%" align="center" >
						<span style="color: red">*</span>总负责人：
					</td>
					<td align="center" valign="middle" width="26%" style="padding: 10px">
						<span style="color: red">*</span>生产负责人：
					</td>
					<td align="center" valign="middle" width="26%">
						<span style="color: red">*</span>质量管理负责人：
					</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px" class="mutd">
						企业人数:
					</td>
					<td valign="middle" width="26%" align="center" >
						<span style="color: red">*</span>总人数：
					</td>
					<td align="center" valign="middle" width="26%" style="padding: 10px" >
						<span style="color: red">*</span>生产人员数：
					</td>
					<td align="center" valign="middle" width="26%">
						<span style="color: red">*</span>质量管理人员数：
					</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px" class="mutd">
						HACCP实施情况:
					</td>
					<td valign="middle" width="26%" align="left" >
						HACCP实施时间：
					</td>
					<td align="center" valign="middle" style="padding: 10px" colspan="2">
						HACCP小组成员：
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px" class="mutd">
						企业内审员：
					</td>
					<td valign="middle" colspan="3"></td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px" >
						生产企业认证情况：
					</td>
					<td valign="middle" colspan="3" style="padding: 0px;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
							<tr class="table_bg_color">
								<td width="25%">认证种类</td>
								<td width="25%">认证机构</td>
								<td width="25%">认证编号</td>
								<td width="25%">有效期限</td>
								
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red"></span>主要生产设备：
					</td>
					<td valign="middle"  width="80%" colspan="3" style="padding: 0px;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
							<tr>
								<td width="20%">设备名称</td>
								<td width="20%">规格型号</td>
								<td width="20%">购置年份</td>
								<td width="20%">运行现状</td>
								<td width="20%">操作负责人</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red"></span>主要检验设备：
					</td>
					<td valign="middle" width="80%" colspan="3" style="padding: 0px;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
							<tr>
								<td width="20%">设备名称</td>
								<td width="20%">检测项目</td>
								<td width="20%">计量检定情况</td>
								<td width="20%">操作负责人</td>
								<td width="20%">备注</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</div>
			<div class="title-cxjg">附件列表</div>
			<div class="margin-chx">
			<table class="table-xqlb" border="0" cellspacing="0" cellpadding="0" id="t4">
				<tr class="table_xqlbbj2">
					<td  align="left">
					
					</td>
				</tr>
			</table>
			</div>
			<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
			<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
	</body>
</html>
