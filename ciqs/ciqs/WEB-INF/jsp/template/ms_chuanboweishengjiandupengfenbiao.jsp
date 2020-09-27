<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>船舶卫生监督评分表</title>
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
</style>
</head>
<body>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<div>
	<div class="chatTitle">船舶卫生监督评分表</div>
	<div class="basicInformation">
		<div>
			<span>船名：</span>${doc.option_1} 
			<span style="margin-left:220px;">船籍：</span>${doc.option_2}
			<span style="margin-left:220px;">IMO号：</span>${doc.option_3}
		</div>
		<div>
			<span>船型：
				<input type="checkbox" <c:if test="${doc.option_4 == '集装箱船'}">checked="checked"</c:if>/>集装箱船/
				<input type="checkbox" <c:if test="${doc.option_4 == '散杂货船'}">checked="checked"</c:if>/>散杂货船/
				<input type="checkbox" <c:if test="${doc.option_4 == '邮轮'}">checked="checked"</c:if>/>邮轮/
				<input type="checkbox" <c:if test="${doc.option_4 == '其他'}">checked="checked"</c:if>/>其他：</span>${doc.option_5}
				
			<span style="margin-left:220px;">港口：</span>${doc.option_6}
		</div>
		<div>
			检查类型：
			<input type="checkbox" <c:if test="${doc.option_7 == '换证检查'}">checked="checked"</c:if>/>换证检查/
			<input type="checkbox" <c:if test="${doc.option_7 == '日常监督'}">checked="checked"</c:if>/>日常监督/
			<input type="checkbox" <c:if test="${doc.option_7 == '专项监督'}">checked="checked"</c:if>/>专项监督
		</div>
		<div>
			<span>检查人：</span>${doc.option_8}<span style="margin-left:320px;">船舶代理：</span>${doc.option_9}
		</div>
		<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
			<tr>
				<td width="80" height="44" align="center" class="tableLine">
					检查项目
				</td>
				<td height="44" align="center" class="tableLine">
					审查内容	
				</td>
				<td height="44" align="center" class="tableLine">
					分值	
				</td>
				<td height="44" align="center" class="tableLine">
					得分	
				</td>
				<td height="44" align="center" class="tableLine">
					不合格项描述
				</td>
			</tr>
			<tr >
				<td  height="44" align="center" class="tableLine" rowspan="4">
					医疗急救体系（20分）
				</td>
				<td width="200" height="44" align="left" class="tableLine">
					1、医疗急救人员得到专业的培训并有能力证书
				</td>
				<td height="44" width="60" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_10}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_11}
				</td>
			</tr>
			<tr >
				<td  width="200" height="44" align="center" class="tableLine"  >
					2、有完整的医疗急救文件和管理制度
				</td>
				<td height="44" width="60" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_12}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_13}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" >
					3、医疗设施符合船舶船员和旅客的需求，并且均处在可用的状态
				</td>
				<td height="44" width="60" align="center" class="tableLine">
					10
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_14}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_15}
				</td>
			</tr> 
			<tr >
				<td  width="200" height="44" align="center" class="tableLine" >
					4、药品管理规范、有序，并有严格的作废流程
				</td>
				<td width="60"  height="44" align="center" class="tableLine">
					4
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_16}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_17}
				</td>
			</tr> 
			<tr >
				<td  height="44" align="center" class="tableLine" rowspan="6">
					水安全体系（25分）
				</td>
				<td height="44" align="center" class="tableLine">
					1、有完整的安全管理文件	
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_18}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_19}
				</td>
			</tr> 
			<tr >
				<td height="44" align="left" class="tableLine">
					2、水质报告、微生物检测记录、化学指数监测等记录书写规范，保存良好
				</td>
				<td height="44" align="center" class="tableLine">
					4
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_20}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_21}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					3、饮用水消毒设施运行正常，并配有有效的报警机制和应急措施
				</td>
				<td height="44" align="center" class="tableLine">
					10
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_22}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_23}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					4、饮用水舱和管网的消毒设备和药品能满足实际要求
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_24}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_25}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					5、饮用水管网处在良好状态，未发现破损、泄露、回流等情况
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_26}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_27}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					6、军团菌的监测合格
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_28}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_29}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" rowspan="6">
					食品安全体系（20分）
				</td>
				<td height="44" align="left" class="tableLine">
					1、有完整的安全管理文件
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_30}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_31}
				</td>
			</tr>
			<tr >
				<td height="44" align="center" class="tableLine">
					2、食品从业人员得到足够的培训并能严格执行相关操作流程
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_32}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_33}
				</td>
			</tr>
			<tr >
				<td height="44" align="center" class="tableLine">
					3、食品从业人员如果患有或疑似患有有碍食品安全的疾病，或出现相关的症状，必须禁止工作
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_34}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_35}
				</td>
			</tr>
			<tr >
				<td height="44" align="center" class="tableLine">
					4、船方有供应商资质验收制度，存放环境能确保食品的质量安全
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_36}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_37}
				</td>
			</tr>
			<tr >
				<td height="44" align="center" class="tableLine">
					5、关于温控的相关设备（包括冰箱、冷库、消毒柜等）运行良好且能得到及时的校正
				</td>
				<td height="44" align="center" class="tableLine">
					8
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_38}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_39}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					6、配有足够的洗手消毒设施
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_40}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_41}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" rowspan="5">
					固液废弃物安全管理体系（15分）
				</td>
				<td height="44" align="left" class="tableLine">
					1、有完整的管理文件
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_42}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_43}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					2、日常记录填写规范，保存良好
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_44}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_45}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					3、有关设施数量能满足垃圾控制的要求
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_46}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_47}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					4、有关固液废物处理/存放设施均能正常运行
				</td>
				<td height="44" align="center" class="tableLine">
					5
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_48}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_49}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					5、医疗废弃物有专门的管理措施
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_50}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_51}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" rowspan="4" >
					媒介控制体系（10分）
				</td>
				<td height="44" align="left" class="tableLine">
					1、有完整的管理文件
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_52}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_53}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					2、船舶各从业人员均接受了媒介控制的培训
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_54}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_55}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					3、船舶媒介密度保持在无害的状态
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_56}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_57}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					4、配有足量的防媒介设备和药品
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_58}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_59}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" rowspan="3">
					其他（10分）
				</td>
				<td height="44" align="left" class="tableLine">
					1、公共场所采光、通风条件良好
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_60}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_61}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					2、公共场所清洁维护制度得到较好的执行
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_62}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_63}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					3、根据IMO指南编写的完善的压舱水管理计划并妥善执行，不存在在港期间排放情况。
				</td>
				<td height="44" align="center" class="tableLine">
					5
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_64}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_65}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" rowspan="3">
					娱乐用水  （邮轮检查部分6分）
				</td>
				<td height="44" align="left" class="tableLine">
					1、娱乐用水具有完整管理计划，并清洁维护得当
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_66}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_67}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					2、娱乐用水余氯含量应介于1-5ppm
				</td>
				<td height="44" align="center" class="tableLine">
					3
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_68}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_69}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					3、娱乐用水管理人员不具备相应卫生学知识和能力
				</td>
				<td height="44" align="center" class="tableLine">
					1
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_70}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_71}
				</td>
			</tr>
			<tr >
				<td width="200" height="44" align="center" class="tableLine" rowspan="2">
					儿童游乐及保育设施（邮轮检查4分）
				</td>
				<td height="44" align="left" class="tableLine">
					1、儿童保育设施区应配有洗手消毒设施
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_72}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_73}
				</td>
			</tr>
			<tr >
				<td height="44" align="left" class="tableLine">
					2、配有传染病症状儿童的书面控制措施管理指南
				</td>
				<td height="44" align="center" class="tableLine">
					2
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_74}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_75}
				</td>
			</tr>
			<tr >
				<td width="80" height="44" align="center" class="tableLine" colspan="2">
					合计
				</td>
				<td height="44" align="center" class="tableLine">
					110
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_76}
				</td>
				<td height="44" align="center" class="tableLine">
					${doc.option_77}
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="5" rowspan="3" >
					 建议  <br/><br/>
					<div>${doc.option_78}</div>
					整改要求<br/><br/>
					<div>${doc.option_79}</div>
				</td>
			</tr>
		</table>
		<div style="border: 1px solid #000;margin-top:0px;width:330px;float:left;">
				陪同检查人员签字：
				<br/>
				<br/>
				<img style="width:50px;height:50px" src="/ciqs/showVideo?imgPath=${doc.option_80}" />
				<br/>
		</div>
		<div style="border: 1px solid #000;margin-top:0px;float:left; width:330px; margin-left:0px;">
				检查日期：
				<br/>
				<br/>
				<span style="width:85px;height:54px;display:inline-block">${doc.option_81}</span>
				<br/>
		</div>
		<div style="border: 1px solid #000;margin-top:0px;width:335px;margin-left:665px;">
				船长签字及船章：
				<br/>
				<br/>
				<img style="width:50px;height:50px" src="/ciqs/showVideo?imgPath=${doc.option_82}" />
				<br/>
		</div>
	</div>
	<input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
    <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();"/>
</div>
</body>
</html>
