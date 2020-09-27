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
td {
    border: solid 1px #dcdcdc;
}
</style>
<script type="text/javascript"> 
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
<body>
<div class="freeze_div_list" style="height: 0px">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-20px">中国出口食品生产企业备案系统 </span></a></div>
<div class="user-info">你好admin，欢迎登录系统     |      退出</div>
</div>
</div>
</div>
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
	<div class="dpn-content" style="margin-top:60px">
	<div><span style="color: red;float: right">注：红字体已对企业进行修改</span></div>
		<div class="search">
		<div><table border="0" width="100%"><tr><td align="right" valign="middle" width="20%" style="padding: 10px;font-size: 18px;font-weight: 600;">申请类型：</td><td align="left" valign="middle" style="font-size: 18px;font-weight: 600;">初次申请</td></tr></table></div>
			<div style="height: 30px;background-color: rgb(211, 241, 249);font-size: 18px;font-weight: 600;"><span style="float: left;margin-left: 30px;">企业基本信息</span></div>
			
			<table width="100%" class="table-date" border="0" >
			<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row" begin="0" end="0">
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px ">
						<span style="color: red">*</span>生产企业名称：
					</td>
					<td align="left" valign="middle" colspan="3">${row.comp_name}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>本次备案厂区及车间简称：
					</td>
					<td align="left" valign="middle" colspan="3">${row.reg_comp_plc}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>生产企业地址（指实际生产地址）：
					</td>
					<td align="left" valign="middle" colspan="3">${row.comp_plc}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>备案受理机构：
					</td>
					<td align="left" valign="middle" colspan="3">${row.enter_accp}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						法人或授权负责人：
					</td>
					<td align="left" valign="middle" width="30%" >${row.legal_psn}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						邮政编码：
					</td>
					<td align="left" valign="middle" width="30%">${row.post_no}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						E-Mail：
					</td>
					<td align="left" valign="middle" width="30%" >${row.e_mail}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						电话传真：
					</td>
					<td align="left" valign="middle" width="30%">${row.tel_fax}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						联系人姓名：
					</td>
					<td align="left" valign="middle" width="30%" >${row.con_name}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						联系人电话：
					</td>
					<td align="left" valign="middle" width="30%">${row.con_tel}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						营业执照编号：
					</td>
					<td align="left" valign="middle" width="30%" >${row.buness_licen}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						营业执照成立日期：
					</td>
					<td align="left" valign="middle" width="30%">${row.buness_date}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						组织机构代码：
					</td>
					<td align="left" valign="middle" width="30%" >${row.comp_code}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						
					</td>
					<td align="left" valign="middle" width="30%"></td>
				</tr>
				</c:forEach>
						</c:if>
			</table>
			<div style="height: 30px;background-color: rgb(211, 241, 249);font-size: 18px;font-weight: 600;"><span style="float: left;margin-left: 30px;">厂区基本信息</span></div>	
			<table width="100%" class="table-date" border="0" >
			<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row" begin="0" end="0">
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>厂区面积：
					</td>
					<td align="left" valign="middle" width="30%" >${row.plant_area}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
					</td>
					<td align="left" valign="middle" width="30%"></td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>建厂时间：
					</td>
					<td align="left" valign="middle" width="30%" ><fmt:formatDate value="${row.crt_plant}" type="both" pattern="yyyy-MM-dd"/></td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						最后改扩建时间：
					</td>
					<td align="left" valign="middle" width="30%"><fmt:formatDate value="${row.lst_mod_plant_date}" type="both" pattern="yyyy-MM-dd"/></td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px ">
						最后改扩建内容（1000字以内）：
					</td>
					<td align="left" valign="middle" colspan="3">${row.lst_mod_plant_con}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>加工车间总面积：
					</td>
					<td align="left" valign="middle" width="30%" >${row.mach_plant_area}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>本次申请品种的车间面积：
					</td>
					<td align="left" valign="middle" width="30%">${row.cur_plant_area}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						冷藏库面积：
					</td>
					<td align="left" valign="middle" width="30%" >${row.cld_plant_area}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						冷藏库容量：
					</td>
					<td align="left" valign="middle" width="30%">${row.cld_sto_area}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						仓库面积：
					</td>
					<td align="left" valign="middle" width="30%" >${row.weah_area}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						仓库容量：
					</td>
					<td align="left" valign="middle" width="30%">${row.weah_area_cap}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						速冻库容积：
					</td>
					<td align="left" valign="middle" width="30%" >${row.cld_sto_vol}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						速冻库容量：
					</td>
					<td align="left" valign="middle" width="30%">${row.cld_sto_cap}</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						速冻机能力：
					</td>
					<td align="left" valign="middle" width="30%" >${row.cld_mach_bily}</td>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						
					</td>
					<td align="left" valign="middle" width="30%"></td>
				</tr>
				</c:forEach>
						</c:if>
			</table >
			<div style="height: 30px;background-color: rgb(211, 241, 249);font-size: 18px;font-weight: 600;"><span style="float: left;margin-left: 30px;">产品信息</span></div>	
			<table width="100%" class="table-date" border="0" >
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*本次申请的产品列表：</span>
					</td>
					<td valign="middle" width="80%" style="padding: 10px">
						同一产品类型下的多个产品，请用","隔开填写，增加产品类别，请填写所有产品信息，包括增加的和原有的.
						<table border="0" align="center" class="table-date" width="100%">
							<tr>
								<td width="20%">产品类别</td>
								<td width="20%">产品名称</td>
								<td width="20%">注册商标</td>
								<td width="20%">设计生产能力（吨/年）</td>
								<td width="20%">主要出口国家或地区</td>
							</tr>
							<c:if test="${not empty li }">
							<c:forEach items="${li}" var="row">
							<tr>
								<td>${row.prod_type}</td>
								<td>${row.prod_name}</td>
								<td>${row.reg_tradmk}</td>
								<td>${row.dsgn_prod_bily}</td>
								<td>${row.exp_to_country}</td>
							</tr>
							</c:forEach>
						</c:if>
						</table>
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						其他产品：
					</td>
					<td valign="middle" width="80%" style="padding: 10px">
						同一产品类型下的多个产品，请用","隔开填写
						<table border="1" align="center" class="table-date" width="100%">
							<tr>
								<td width="20%">产品类别</td>
								<td width="20%">产品名称</td>
								<td width="20%">注册商标</td>
								<td width="20%">设计生产能力（吨/年）</td>
								<td width="20%">主要出口国家或地区</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<div style="height: 30px;background-color: rgb(211, 241, 249);font-size: 18px;font-weight: 600;"><span style="float: left;margin-left: 30px;">人员、认证、设备信息</span></div>	
			<table width="100%" class="table-date" border="0" >
			<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row" begin="0" end="0">
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						管理负责人姓名
					</td>
					<td valign="middle" width="26%" align="center" >
						<span style="color: red">*</span>总负责人：${row.mana_psn_name}
					</td>
					<td align="center" valign="middle" width="26%" style="padding: 10px">
						<span style="color: red">*</span>生产负责人：${row.prod_psn}
					</td>
					<td align="center" valign="middle" width="26%">
						<span style="color: red">*</span>质量管理负责人：${row.qua_mana_psn}
					</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						企业人数
					</td>
					<td valign="middle" width="26%" align="center" >
						<span style="color: red">*</span>总人数：${row.psn_num}
					</td>
					<td align="center" valign="middle" width="26%" style="padding: 10px">
						<span style="color: red">*</span>生产人员数：${row.prod_psn_num}
					</td>
					<td align="center" valign="middle" width="26%">
						<span style="color: red">*</span>质量管理人员数：${row.qua_psn_num}
					</td>
				</tr>
				<tr>	
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						HACCP实施情况
					</td>
					<td valign="middle" width="26%" align="left" >
						HACCP实施时间：${row.haccp_date}
					</td>
					<td align="center" valign="middle" style="padding: 10px" colspan="2">
						HACCP小组成员：${row.haccp_psn}
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px" >
						企业内审员：
					</td>
					<td valign="middle" colspan="3">${row.comp_audit_psn}</td>
				</tr>
					</c:forEach>
				</c:if>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px" >
						生产企业认证情况：
					</td>
					<td valign="middle" colspan="3" >
						<table border="0" align="center" class="table-date" width="100%">
							<tr>
								<td width="25%">认证种类</td>
								<td width="25%">认证机构</td>
								<td width="25%">认证编号</td>
								<td width="25%">有效期限</td>
							</tr>
							<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
							<tr>
								<td>${row.auth_type}</td>
								<td>${row.auth_org}</td>
								<td>${row.cert_no}</td>
								<td>${row.valid_term}</td>
							</tr>
							</c:forEach>
						</c:if>
						</table>
					</td>
				</tr>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row" begin="0" end="0">
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px" >
						食品安全卫生控制体系运行状况（1000字以内）：
					</td>
					<td colspan="3">${row.vedio_sys_situ}</td>
				</tr>
					</c:forEach>
				</c:if>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>主要生产设备：
					</td>
					<td valign="middle" style="padding: 10px" width="80%" colspan="3">
						<table border="0" align="center" class="table-date" width="100%">
							<tr>
								<td width="20%">设备名称</td>
								<td width="20%">规格型号</td>
								<td width="20%">购置年份</td>
								<td width="20%">运行现状</td>
								<td width="20%">操作负责人</td>
							</tr>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
							<tr>
								<td>${row.eqpm_name}</td>
								<td>${row.spec_models}</td>
								<td>${row.puech_date}</td>
								<td>${row.func_situ}</td>
								<td>${row.func_opr_psn}</td>
							</tr>
							</c:forEach>
						</c:if>
						</table>
					</td>
				</tr>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row" begin="0" end="0">
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px" >
						企业实验室获得资质认定的情况（1000字以内）：
					</td>
					<td colspan="3">${row.labory_situ}</td>
				</tr>
					</c:forEach>
				</c:if>
				<tr>
					<td align="right" valign="middle" width="20%" style="padding: 10px">
						<span style="color: red">*</span>主要检验设备：
					</td>
					<td valign="middle" style="padding: 10px" width="80%" colspan="3">
						<table border="0" align="center" class="table-date" width="100%">
							<tr>
								<td width="20%">设备名称</td>
								<td width="20%">检测项目</td>
								<td width="20%">计量检定情况</td>
								<td width="20%">操作负责人</td>
								<td width="20%">备注</td>
							</tr>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
							<tr>
								<td>${row.faci_name}</td>
								<td>${row.insp_item}</td>
								<td>${row.meter_situ}</td>
								<td>${row.meter_opr_psn}</td>
								<td>${row.rmk}</td>
							</tr>
							</c:forEach>
						</c:if>
						</table>
					</td>
				</tr>
			</table>
			<div style="height: 30px;background-color: rgb(211, 241, 249);font-size: 18px;font-weight: 600;"><span style="float: left;margin-left: 30px;">附件列表</span></div>	
			（说明：以下每行附件总计大小不能超过5m,每行附件如有多个文件请打包上传，<span style="color: red">有模板的文件必须盖章扫描后上传</span>）
			<table>
				<c:if test="${not empty li1 }">
							<c:forEach items="${li1}" var="row">
							<tr>
								<td>
								${row.attach_list}
									<img src="" width="60" height="20" title="查看" onclick="toImgDetail('201712/111.bmp')"/>
									<input  type="button" value="下载" style="width: 70px" onclick="download('201712/111.bmp')"/>
								</td>
							</tr>
							</c:forEach>
						</c:if>
			</table>
		</div>
	</div>
</body>
</html>
