<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>提单详情</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet"
	href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
<style type="text/css">
input.datepick {
	background: #FFF url(/ciqs/static/dec/images/dpn.date.pick.gif)
		no-repeat right /* 	position: absolute; */
}

#title_a {
	color: #ccc
}

#title_a:hover {
	color: white;
}

.box-img-bg {
	background-image: url(../static/show/disc/bg.png);
	box-sizing: border-box;
	width: 1198px;
	height: 164px;
	padding: 0 200px;
	position: absolute;
	display: none;
	font-size: 20px;
	line-height: 35px;
	color: white;
}

.box-content-style {
	display: table-cell;
	vertical-align: middle;
	text-align: center;
}

.table_form tr th {
	background-color: #F7F7F7;
}

.table_form tr td, .table_form tr th {
	border-color: #DADADA;
}

th {
	font-size: 13px;
}

td {
	font-size: 13px;
}
</style>
<script type="text/javascript">
	$(function() {
	});
</script>
</head>
<body class="bg-gary">
	<div>
		<div class="title-bg">
			<div class=" title-position margin-auto white">
				<div class="title">
					<a href="/ciqs/billlading/billladingList" class="font-24px" style="color: white;">动植物产品及废料/</a><a id="title_a">提单详情</a>
				</div>
				<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
			</div>
		</div>
		<div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
		<div class="flow-bg">
			<div class="flow-position margin-auto">
				<ul class="white font-18px flow-height font-weight">
					<li>交通运输工具监管</li>
					<li>报检审单布控</li>
					<li>现场检验检疫</li>
					<li>实验室检验检疫</li>
					<li>综合评定</li>
					<li>签证放行归档</li>
					<li>后续监管</li>
					<li></li>
				</ul>
				<ul>
					<li><img src="${ctx}/static/show/images/billlading/billA1.png"
						width="107" height="103"
						content="交通运输工具监管记录及监控进境船舶卫生监督全过程，具体记录内容包括船舶停靠时间、登船检疫方式、登船检疫结果，并可对船舶运行轨迹进行可视化监控。" /></li>
					<li><img src="${ctx}/static/show/images/billlading/billA2.png"
						width="107" height="103"
						content="报检审单布控即为对随附单证的完整性、一致性，检疫许可证核销情况以及卫生证书等进行核查，核实无误后，勾选《报检受理核查确认事项单》、《审批核销确认事项单》以及《证书审核确认事项单》，依据《出入境检验检疫报检规定》受理企业申报。" /></li>
					<li><img src="${ctx}/static/show/images/billlading/billA3.png"
						width="107" height="103"
						content="现场检验检疫环节通过随机抽查锁定查验对象和查验人员，查验人员需按照规定配备查验装备，进行开箱前查验、开箱查验、感官查验、掏箱查验等，并对查验的关键点信息进行拍照记录，在线填写原始记录单并使用执法记录仪对风险隐患证据进行视频记录并保存。" /></li>
					<li><img src="${ctx}/static/show/images/billlading/billA4.png"
						width="107" height="103"
						content="实验室检验检疫包括抽采制样与送样检测两大环节。按照GB/T 18088-2000《出入境动物检疫采样》抽取代表性样品进行检验检疫。按随机和代表性原则多点抽样检查。具体记录内容包括：抽采样、制样过程记录、抽采样凭证、送样联系单、接样回执单以及检验报告。" /></li>
					<li><img src="${ctx}/static/show/images/billlading/billA5.png"
						width="107" height="103"
						content="综合评定即对经查验不合格的货物进行退运或销毁处理、整改处理、不合格上报、商品复验以及样品管理等操作。具体的记录内容包括：检验检疫处理通知书、出入境动植物检疫处理监管记录表、工作电子记录等。" /></li>
					<li><img src="${ctx}/static/show/images/billlading/billA6.png"
						width="107" height="103"
						content="签证放行归档包括评定放行环节、单据归档环节及档案调阅环节。具体记录内容包括：入境货物检验检疫证明、档案管理记录以及查（借）阅档申请表等。" /></li>
					<li><img src="${ctx}/static/show/images/billlading/billA7.png"
						width="107" height="103"
						content="后续监管即利用车辆在途跟踪对货物从口岸放行至内地监管的流向进行过程监控，具体的记录内容包括货物目的地以及流向轨迹。" /></li>
					<li></li>
				</ul>
			</div>
		</div>
		<div class="title-cxjg" id="module_2">提单信息</div>
		<div class="margin-chx">
			<table width="100%" border="0" class="table-xqlb">
			<tr>
				<td width="120" class="table_xqlbbj2">提单号：</td>
				<td>${billLadingDTO.bill_no}</td>
				<td width="120" class="table_xqlbbj2">船名：</td>
				<td>${billLadingDTO.ship_name_en}</td>
				<td width="120" class="table_xqlbbj2">航次：</td>
				<td>${billLadingDTO.voyage_no}</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">货物名称：</td>
				<td>${billLadingDTO.main_g_name}</td>
				<td class="table_xqlbbj2">运输条款：</td>
				<td>${billLadingDTO.transport_article}</td>
				<td class="table_xqlbbj2">起运港代码：</td>
				<td>${billLadingDTO.loading_port}</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">发货人：</td>
				<td>${billLadingDTO.sender}</td>
				<td class="table_xqlbbj2">收货人：</td>
				<td>${billLadingDTO.receiver}</td>
				<td class="table_xqlbbj2">通知人：</td>
				<td>${billLadingDTO.informer}</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">特殊标识：</td>
				<td>${billLadingDTO.spacialFlag}</td>
				<td class="table_xqlbbj2">布控标识：</td>
				<td>
					<c:if test="${billLadingDTO.flag_monitor eq '1'}">布控</c:if>
					<c:if test="${billLadingDTO.flag_monitor eq '0'}">非布控</c:if>
				</td>
				<td class="table_xqlbbj2">拆拼标识：</td>
				<td>
					<c:if test="${billLadingDTO.flag_pin eq '1'}">拼装</c:if>
					<c:if test="${billLadingDTO.flag_pin eq '0'}">非拼装</c:if>
				</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">当前码头/场站：</td>
				<td>${billLadingDTO.terminal_code_cur }</td>
				<td class="table_xqlbbj2">提箱申报时间：</td>
				<td>${billLadingDTO.delivery_date }</td>
				<td class="table_xqlbbj2">监管人员：</td>
				<td>${billLadingDTO.insp_user }&nbsp;</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">当前监管科室</td>
				<td>${billLadingDTO.port_dept_code }</td>
				<td class="table_xqlbbj2">预审人员：</td>
				<td>${billLadingDTO.approve_user }&nbsp;</td>
				<td class="table_xqlbbj2">预审科室：</td>
				<td>${billLadingDTO.approve_dept }</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">预审结果：</td>
				<td>
					<c:if test="${billLadingDTO.approve_result == '1' }">
						待审核
					</c:if>
					<c:if test="${billLadingDTO.approve_result == '2' }">
						免检直放
					</c:if>
					<c:if test="${billLadingDTO.approve_result == '3' }">
						查验
					</c:if>
					<c:if test="${billLadingDTO.approve_result == '4' }">
						未通过
					</c:if>
					<c:if test="${billLadingDTO.approve_result == '5' }">
						疫区处理
					</c:if>
				</td>
				<td class="table_xqlbbj2">放行人员：</td>
				<td>
					<c:if test="${billLadingDTO.op_code == 'RL' }">
						${billLadingDTO.op_user }
					</c:if>
				</td>
				<td class="table_xqlbbj2">放行时间：</td>
				<td>${billLadingDTO.op_date }</td>
			</tr>
			<tr>
				<td class="table_xqlbbj2">当前状态：</td>
				<td>${billLadingDTO.status }</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</table>
		</div>
	</div>
	<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
		<input type="button" class="search-btn" value="返回"
			onclick="JavaScript:history.go(-1);" />
	</div>
</body>
</html>