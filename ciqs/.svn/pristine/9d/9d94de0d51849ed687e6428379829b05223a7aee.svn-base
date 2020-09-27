<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>当场行政处罚决定书</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div {
	font-size: 20px;
	height: 50px;
	text-align: left;
	line-height: 50px;
}

.title_style {
	font-size: 26px;
	text-align: center;
	margin: 0 auto;
}

.underline {
	border-bottom: 1px solid #000;
	height: 49px;
	float: left;
}

.branch_sign {
	border-bottom: 2px solid #000;
	margin-bottom: 30px;
}

.file_sign {
	min-width: 20%;
	float: right;
}

.file_sign div {
	float: left;
}

.basic_title {
	float: left;
	min-with: 10%;
}

.punish_content {
	padding-left: 20px;
	padding-right: 20px;
	word-break: break-all;
	word-wrap: break-word;
	height: initial;
}

.punish_content div {
	border-bottom: 1px solid #000;
	height: 49px;
	width: 50px;
	display: inline;
}
</style>
</head>
<body>
	<div style="width: 1000px; margin: 0 auto;">
		<div class="title_style">
			<span>中华人民共和国 出入境检验检疫局</span>
		</div>
		<div class="title_style">
			<span>当场行政处罚决定书</span>
		</div>
		<div class="file_sign" style="">
			<div>连检罚 [</div>
			<div style="min-width: 100px;">${result.PUNISH_ID }</div>
			<div>]</div>
			<div style="min-width: 25px;"></div>
		</div>
		<!-- 分行符号 -->
		<div class="branch_sign"></div>

		<div style="padding-left: 20px">
			<div class="basic_title">当事人名称（姓名）：</div>
			<div class="underline" style="width: 160px;">${result.PARTY_NAME }</div>
			<div class="basic_title">证件名称及号码：</div>
			<div class="underline" style="width: 404px;">${result.IDENTIFI_STYLE }/${result.IDENTIFI_NUMBER }</div>
		</div>
		<div style="padding-left: 20px">
			<div class="basic_title">地址：</div>
			<div class="underline" style="width: 894px">${result.ADDRESS }</div>
		</div>
		<div style="padding-left: 20px">
			<div class="basic_title">法定代表人：</div>
			<div class="underline" style="width: 350px">${result.LEGAL_REPRESENT }</div>
			<div class="basic_title">联系电话：</div>
			<div class="underline" style="width: 368px">${result.LEGAL_REPRESENT_PHONE }</div>
		</div>
		<div style="padding-left: 20px">
			<div class="basic_title">违法事实：</div>
			<div class="underline" style="width: 850px">${result.ILLEGAL_OBJECT }</div>
		</div>
		<div style="padding-left: 20px">
			<div class="basic_title">违法行为发生地：</div>
			<div class="underline" style="width: 308px;">${result.ILLEGAL_ADDRESS }</div>
			<div class="basic_title">违法行为发生时间：</div>
			<div class="underline" style="width: 278px">${result.ILLEGAL_TIME }</div>
		</div>
		<div style="padding-left: 20px">
			<div class="basic_title">当事人现场代表：</div>
			<div class="underline" style="width: 308px">${result.PARTY_REPRESENT }</div>
			<div class="basic_title">联系电话：</div>
			<div class="underline" style="width: 366px;">${result.PARTY_REPRESENT_PHONE }</div>
		</div>
		<div style="padding-left: 60px">
			<div class="basic_title">经我局调查：</div>
		</div>
		<div style="padding-left: 60px">
			<div class="basic_title">你（单位）：</div>
			<div class="underline" style="width: 406px;">${result.PARTY_ASSIGN }</div>
		</div>
		<div class="punish_content">
			<div style="margin-left: 40px;"></div>
			你（单位）的行为已违反了${result.ILLEGAL_BASIS }根据${result.PUNISH_BASIS }的规定，我局对你（单位）实施下列行政处罚：
			<c:if test="${result.PUNISH_STYLE=='0' }">
				警告
			</c:if>
			<c:if test="${result.PUNISH_STYLE=='1' }">
				处罚
			</c:if>
			<c:if test="${result.PUNISH_STYLE=='0' }">
				<div class="underline" style="width: 890px">${result.WARNNING_CONTENT }</div>
			</c:if>
			<c:if test="${result.PUNISH_STYLE=='1' }">
				<div class="underline" style="width: 890px">${result.PUNISH_MONEY }</div>
			</c:if>
		</div>

		<!--      罚款才有 -->
		<c:if test="${result.PUNISH_STYLE=='1' }">
			<div class="punish_content">
				<div style="margin-left: 80px; display: inline;"></div>
				&nbsp;&nbsp;&nbsp;你（单位）在接到本行政处罚决定书后，应按照以下第
				<div>${result.FORFEIT_PAY_STYLE }</div>
				项规定方式缴纳罚款：
			</div>
			<div class="punish_content">
				<div style="margin-left: 40px; display: inline;"></div>
				1、当场缴纳。你（单位）凭电子凭证到本机关领取罚款收据，并办理结案手续
			</div>
			<div class="punish_content">
				<div style="margin-left: 40px; display: inline;"></div>
				2、自即日起15日内持本决定书和缴款通知书到银行缴纳罚款，银行账号：
				<div>${result.BANK_CARD}</div>
				。逾期不缴纳罚款的，每日按3%加处罚款，机关并将申请法院强制执行。
			</div>
		</c:if>
		<div class="punish_content">
			<div style="margin-left: 40px; display: inline;"></div>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当事人对本处罚决定不服，可自收到本行政处罚决定书之日起60日内向
			<div>${result.RECONSIDER }</div>
			出入境检验检疫局申请行政复议或者在六个月内向人民法院提起行政诉讼。
		</div>
		<div style="padding-left: 20px; margin-top: 100px;">
			<div class="basic_title">当事人或其现场代表：</div>
			<div style="width: 280px; float: left;">
				<img style="width: 50px;"
					src="/ciqs/showVideo?imgPath=${result.CUR_PSN_SIGN }" />
			</div>
			<div class="basic_title">执法人员：</div>
			<div style="width: 370px; float: left;">
				<img style="width: 50px;"
					src="/ciqs/showVideo?imgPath=${result.LAW_EXECUTOR }" />
			</div>
		</div>
		<div style="padding-left: 20px;">
			<div class="basic_title" style="margin-left: 500px;">（ 执法机关盖公章）</div>
		</div>
	</div>
</body>
</html>