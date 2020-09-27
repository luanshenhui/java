<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript">
	$(function(){
		$("#expt_iterm_ta").val($("#expt_iterm").val());
		$("#decl_rmk_ta").val($("#decl_rmk").val());
	});
	
	function submitDec() {
		$("#expt_iterm").val($("#expt_iterm_ta").val());
		$("#decl_rmk").val($("#decl_rmk_ta").val());
		$("#form").submit();
	}
</script>
</head>
<body>
<%@ include file="/common/headMenu.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：</a>出入境邮轮检疫 &gt; 入境检疫申报
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">入境检疫申报</div>
		<div class="form">
			<div class="main">
				<form action="/ciqs/mailSteamer/saveDeclaration" method="post" id="form" enctype="multipart/form-data">
					<input type="hidden" name="id" value="${model.id }"/>
					<input type="hidden" name="dec_master_id" value="${model.dec_master_id }"/>
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%" >
									中文船名：
								</th>
								<td width="25%">
									<input type="text" id="cn_vsl_m" name="cn_vsl_m" size="14" class="text" value="${model.cn_vsl_m }" readonly="readonly"/>
								</td>
								<th width="25%" >
									英文船名：
							  	</th>
								<td width="25%">
									<input type="text" id="full_vsl_m" name="full_vsl_m" size="14" class="text" value="${model.full_vsl_m }" readonly="readonly"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									国籍：
								</th>
								<td width="25%">
									<input readonly="readonly" type="text" size="14" class="text" value=""/>
								</td>
								<th width="25%" >
									呼号：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.vsl_callsign }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									载货种类及数量：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.cargo_last_voy }"/>
								</td>
								<th width="25%" >
									总吨：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.vsl_grt }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									净吨：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.vsl_nrt }"/>
								</td>
								<th width="25%" >
									（拟）靠泊泊位：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.previous_port }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									船员人数：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.sailor_total }"/>
								</td>
								<th width="25%" >
									旅客人数：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.imp_travel_total }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									发航港及出发日期：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.previous_port_date }"/>
								</td>
								<th width="25%" >
									预计抵达日期及时间：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.dec_arrive_time }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									近四周寄港及日期：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.last_four_port }"/>
								</td>
								<th width="25%" >
									免予/卫生控制措施证书签发港及日期：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.ship_sanit_cert }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									交通工具卫生证书签发港及日期 (如果有)：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.traf_cert }"/>
								</td>
								<th width="25%" >
									船上有无病人（包括发热病例） ：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly"  size="14" class="text" value="${model.chk_patients }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									船上有否有人非因意外死亡：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly" size="14" class="text" value="${model.chk_died }"/>
								</td>
								<th width="25%" >
									在航海中船上是否有啮齿动物反常死亡 ：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly" size="14" class="text" value="${model.chk_died_other }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									入境实施检疫方式：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly" size="14" class="text" value="${model.chk_dec }"/>
								</td>
								<th width="25%" >
									船舶代理（签章）：
							  	</th>
								<td width="25%">
									<input type="text" readonly="readonly" size="14" class="text" value="${model.full_vsl_m }"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="25%" >
									日期：
								</th>
								<td width="25%">
									<input type="text" readonly="readonly" size="14" class="text" value="${model.quar_date }"/>
								</td>
								<th width="25%" >
							  	</th>
								<td width="25%">
								</td>
							</tr>
							<tr>
								<th width="25%" >
									总局风险等级：
							  	</th>
								<td width="25%">
									<c:if test="${not empty levels }">
										<c:forEach items="${levels }" var="level">
											<input type="radio" name="cent_war_level" value="${level.code }" <c:if test="${level.code eq model.cent_war_level }">checked="checked"</c:if>/>${level.name }&nbsp;&nbsp;
										</c:forEach>
									</c:if>
								</td>
								<th width="25%" >
									总局疫情报告、警示通报：
							  	</th>
								<td width="25%">
									<input type="radio" name="cent_war_notice" value="0" <c:if test="${model.cent_war_notice eq '0' }">checked="checked"</c:if>/>无&nbsp;&nbsp;
									<input type="radio" name="cent_war_notice" value="1" <c:if test="${model.cent_war_notice eq '1' }">checked="checked"</c:if>/>有&nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<th width="25%" >
									其他方面通报：
							  	</th>
								<td width="25%">
									<input type="radio" name="other_notice" value="0" <c:if test="${model.other_notice eq '0' }">checked="checked"</c:if>/>无&nbsp;&nbsp;
									<input type="radio" name="other_notice" value="1" <c:if test="${model.other_notice eq '1' }">checked="checked"</c:if>/>有&nbsp;&nbsp;
								</td>
								<th width="25%" >
									符合哪种检疫方式：
							  	</th>
								<td width="25%">
									<c:if test="${not empty inspTypes }">
										<c:forEach items="${inspTypes }" var="inspType">
											<input type="radio" name="insp_type" value="${inspType.code }" <c:if test="${model.insp_type eq inspType.code }">checked="checked"</c:if>/>${inspType.name }&nbsp;&nbsp;
										</c:forEach>
									</c:if>
								</td>
							</tr>
							<tr>
								<th width="25%" >
									先期风险评估结果：
							  	</th>
								<td width="25%">
									<c:if test="${not empty levels }">
										<c:forEach items="${levels }" var="level">
											<input type="radio" name="warning_level" value="${level.code }" <c:if test="${level.code eq model.warning_level }">checked="checked"</c:if>/>${level.name }&nbsp;&nbsp;
										</c:forEach>
									</c:if>
								</td>
								<th width="25%" ></th>
								<td width="25%"></td>
							</tr>
							<tr>
								<th width="25%" >
									异常事项列表：
							  	</th>
							  	<td width="75%" colspan="3" >
									<textarea rows="4" style="width:100%;" id="expt_iterm_ta"></textarea>
									<input type="hidden" id="expt_iterm" name="expt_iterm" value="${model.expt_iterm }"/>
								</td>
							</tr>
							<tr>
								<th width="25%" >
									备注：
							  	</th>
							  	<td width="75%" colspan="3" >
									<textarea rows="4" style="width:100%;" id="decl_rmk_ta"></textarea>
									<input type="hidden" id="decl_rmk" name="decl_rmk" value="${model.decl_rmk }"/>
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="100">
									<input class="button" type="button" value="提交" onclick="submitDec()"/> 
									<input onclick="javascript:history.go(-1);"
									class="button" value="返回" type="button" />
								</td>
							</tr>
						</tfoot>
					</table>
				</form>
			</div>
		</div>
	</div>
	<div style="display: none; height : 500px; width : 700px; overflow: scroll; "  id="divContentImg"   >
		<div><img id="imgJPG"  src=""/></div>
		<div id="divContentButton"><input onclick="javascript:jQuery.unblockUI();" class="button" value="关闭" type="button" /></div>
    </div>
</body>
</html>
