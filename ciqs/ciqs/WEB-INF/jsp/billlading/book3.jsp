<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>检港联动快速查验系统</title>
		<%@ include file="/common/resource_show.jsp"%>

		<script language="javascript" type="text/javascript">
		jQuery(function() {
			$(document).ready(function() {
			    setDiv('4'); 
			    printTime();
			});
		});	
		function printIt() { 
			window.print(); 
		}
		function printTime(){
			$("#printTime").empty();
			thistime= new Date();
			var years=thistime.getFullYear();
			var months=thistime.getMonth()+1;
			var days=thistime.getDate();
			var hours=thistime.getHours();
			var minutes=thistime.getMinutes();
			var seconds=thistime.getSeconds();
			if (eval(hours) <10) {hours="0"+hours;}
			if (eval(minutes) < 10) {minutes="0"+minutes;}
			if (seconds < 10) {seconds="0"+seconds;}
			thistime = years+"-"+months+"-"+days+" "+hours+":"+minutes+":"+seconds;
			$("#printTime").append('日期：'+thistime);
			$("#decYear").append(years);
			$("#decMonth").append(months);
			$("#decDay").append(days);
		}
	</script>
		<style type="text/css">
		<!--
		#divPrintTitle {
			text-align: center;
		    font-size: 26px;
		    line-height:35px;
		    font-weight: bolder;
		    margin-top: 10px;
		    margin-bottom: 20px;
		}
		#divPrintPage {
			width:768px;
			margin:auto;
		}
		.div_line{
			width:180px; 
			float:left;
		}
		.div_line_left{
			width:300px; 
			float:left;
		}		
		.div_line_right{
			width:100px; 
			float:left;
		}
		.table_printTd tr td{
			border: 1px solid;
			border-color: black;
		}
		.table_print{
			border: 1px solid;
			border-color: black;
			font-size:16px;
			text-align:center;
			line-height:30px;
			table-layout: fixed;
			word-break:break-all;
		}
		@media print {
		.noprint{display:none}
		}
		-->
	</style>
	</head>

	<body>
		<div id="content">
			<div class="table_spacing"></div>
			<div class="table_spacing"></div>
			<div class="table_spacing"></div>
			<div id="divPrintPage">
				
				<div id="divPrintTitle">
					检疫处理报告单
				</div>
				<div class="table_spacing"></div>
<!-- 				<logic:notEmpty name="xunJobDTO"> -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0" height="30px" align="center" style="font-size: 20px">
						<tr>
							<td align="left">
								&nbsp;
<!-- 								<logic:iterate id="codeLibrary" name="DEPTMENTS" -->
<!-- 									type="com.dpn.ciq2.dto.DeptmentsDTO"> -->
<!-- 									<c:if test="${codeLibrary.CODE==xunJobDTO.port_dept_code}"> -->
<!-- 										<bean:write name="codeLibrary" property="NAME" /> -->
<!-- 									</c:if> -->
<!-- 								</logic:iterate> -->
							</td>
							<td align="right">
								&nbsp;No.A ${xunJobDTO.book_no }
							</td>
						</tr>
						<tr>
							<td align="left">
								检疫人员：${xunJobDTO.ciq_check_user_nm}
							</td>
							<td align="right">
								<span id="printTime"></span>
							</td>
						</tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="table_printTd table_print" align="center">
						<tr>
							<td width="12%">
								工作序号
							</td>
							<td width="22%">
								${xunJobDTO.book_no }
							</td>
							<td width="15%">
								申请单位
							</td>
							<td width="20%">
								&nbsp;${xunJobDTO.dec_org_name }
							</td>
							<td width="18%">
								输出/入国
							</td>
							<td>
								&nbsp;${xunJobDTO.origin_country_name }
							</td>
						</tr>
						<tr>
							<td>
								联&nbsp;&nbsp;系&nbsp;&nbsp;人



							</td>
							<td>
								&nbsp;${xunJobDTO.dec_user }
							</td>
							<td>
								电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话



							</td>
							<td>
								&nbsp;${xunJobDTO.telephone }
							</td>
							<td>
								船&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名



							</td>
							<td>
								&nbsp;${xunJobDTO.ship_name_en }
							</td>
						</tr>
						<tr>
							<td>
								货物名称
							</td>
							<td>
								&nbsp;${xunJobDTO.goods_cname }
							</td>
							<td>
								数量/重量
							</td>
							<td>
								&nbsp;
								<c:if test="${xunJobDTO.weight!=null && xunJobDTO.weight!='0' && xunJobDTO.weight!=''}">
				    		${xunJobDTO.weight}${xunJobDTO.weight_unit_name}
						</c:if>
								<c:if test="${xunJobDTO.weight==null || xunJobDTO.weight=='0' || xunJobDTO.weight==''}">
							${xunJobDTO.qty}${xunJobDTO.qty_unit_name}
						</c:if>
							</td>
							<td>
								包装种类
							</td>
							<td>
								&nbsp;${xunJobDTO.pack_type_name }
							</td>
						</tr>
						<tr>
							<td>
								存放场地
							</td>
							<td>
								&nbsp;${xunJobDTO.land_area_code }
							</td>
							<td>
								货&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位



							</td>
							<td>
								&nbsp;${xunJobDTO.land_place }
							</td>
							<td>
								木包装件数



							</td>
							<td>
								&nbsp;${xunJobDTO.wood_count }
							</td>
						</tr>
						<tr>
							<td>
								集装箱号/规格/数量/舱容/体积/垛位
							</td>
							<td colspan="5" align="left">
								20尺×${xunJobDTO.conta_mode20 }/40尺×${xunJobDTO.conta_mode40 }<br/>
								${fn:substring(xunJobDTO.conta_model, 0, 240)}
							</td>
						</tr>
						<tr>
							<td>
								检疫处理

								<br />
								依&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;据

							</td>
							<td colspan="5">
								&nbsp;${xunJobDTO.deal_rsn }
							</td>
						</tr>
						<tr>
							<td>
								处理方法
							</td>
							<td colspan="5">
								<div class="div_line">
									${xunJobDTO.deal_meth}
								</div>
							</td>
						</tr>
						<tr>
							<td>
								药&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;剂



							</td>
							<td colspan="5">
								<div class="div_line">
								${xunJobDTO.deal_medic_cn}
								</div>
							</td>
						</tr>
						<tr>
							<td>
								技术要求



							</td>
							<td colspan="5">
								&nbsp;${xunJobDTO.techno_rqst}
							</td>
						</tr>
						<tr>
							<td>
								处理方法详细描述
							</td>
							<td colspan="5">
								&nbsp;${xunJobDTO.description}
							</td>
						</tr>
						<tr>
							<td rowspan="4">
								处理情况
							</td>
							<td>
								剂&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;量
							</td>
							<td>
								&nbsp;
<%-- 								${xunJobDTO.dosage} --%>
								${xunJobDTO.fb_deal_dosage}
								(克/立方米)
							</td>
							<td>
								外界温度
							</td>
							<td colspan="2">
								&nbsp;
<%-- 								${xunJobDTO.o_tmprtu} --%>
								${xunJobDTO.fb_temp}(°C)
							</td>
						</tr>
						<tr>
							<td>
								作业时间
							</td>
							<td>
								&nbsp;
								${fn:substring(xunJobDTO.fb_deal_end, 0, 10)}
<%-- 								${fn:substring(xunJobDTO.deal_date, 0, 11)} --%>
							</td>
							<td>
								密闭/持续时间
							</td>
							<td colspan="2">
								&nbsp;
<%-- 								${xunJobDTO.duration} --%>
								${xunJobDTO.fb_duration}
								(小时)
							</td>
						</tr>
						<tr>
							<td>
								检测时间
							</td>
							<td>
								&nbsp;
								${xunJobDTO.fb_xun_time}
<%-- 								${xunJobDTO.xun_check_time} --%>
							</td>
							<td>
								检测结果
							</td>
							<td colspan="2">
								&nbsp;
<%-- 								${xunJobDTO.xun_check_rst} --%>
								${xunJobDTO.fb_chk_rst }
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<div class="div_line">
									作业人员：${xunJobDTO.fb_operator}
<%-- 									${xunJobDTO.operator} --%>
								</div>
								<div class="div_line">
									审核人：
								</div>
								
								<div>
									日期：${xunJobDTO.xun_finish_date}
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="6">
								<div class="div_line" style="margin-left: 90px;">
									检疫员：${xunJobDTO.ciq_check_user_nm}
								</div>
								<div class="div_line" style="margin-left: 10px;">
									审&nbsp;&nbsp;核：${xunJobDTO.fb_auditor}
<%-- 									${xunJobDTO.auditor} --%>
								</div>
								<div style = "margin-right: 50px;">
									日&nbsp;&nbsp;期：
								</div>
								
							</td>
						</tr>
						<tr>
							<td>申请人声明</td>
							<td colspan="5"  style="line-height: 30px;">
										<p align="left">
											&nbsp;&nbsp;&nbsp;&nbsp;我司委托辽宁检疫处理集团有限公司对以上货物、货物包装或运输工具进行检疫处理，保证
											所提供的资料真实有效。符合国家有关法律、法规，所做业务将提前24小时通知，并提供检疫处理所要求的足够时间，否则愿意承担由此产生的法律及经济责任。

										</p>
										<div class="div_line_left">
											申请人：${xunJobDTO.dec_org_name}
										</div>
										<div class="div_line_right">
											(盖章)
										</div>
											 <span id="decYear"></span>&nbsp;年&nbsp; <span id="decMonth"></span>&nbsp; 月&nbsp; <span id="decDay"></span>&nbsp; 日

							</td>
						</tr>	
					</table>
<!-- 				</logic:notEmpty> -->
			</div>
			<!--endprint-->
		</div>
		<div class="table_spacing"></div>
		<div class="noprint" align="center">
			<span class="black_12px"> <input id="btnPrint" type="button"
					class="btn" value="打印" onclick="printIt();" /> <input
					id="btnCancl" type="button" class="btn" value="返回"
					onclick="javascript:history.go(-1)" /> </span>
		</div>
	</body>
</html>
