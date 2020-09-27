<?xml version="1.0" encoding="Shift_JIS" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" media-type="text/html" encoding="Shift_JIS" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd"/>

<xsl:template match="CONSULT">
<html>
<head>
<title>予約更新情報</title>
<link rel="stylesheet" type="text/css" href="/webHains/contents/css/default.css" />
</head>
<body bgcolor="#ffffff">

<table border="0" cellpadding="2" cellspacing="1" bgcolor="#999999" width="100%">
	<tr>
		<td height="15" bgcolor="#ffffff"><b><span class="reserve">■</span><font color="#000000">予約更新情報</font></b></td>
	</tr>
</table>

<br/>

<table border="0" cellpadding="1" cellspacing="2">
	<tr>
		<td bgcolor="#eeeeee">処理</td>
		<td><xsl:value-of select="UPDMODENAME" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">予約番号</td>
		<td><xsl:value-of select="RSVNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">キャンセルフラグ</td>
		<td><xsl:value-of select="CANCELFLG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">受診日</td>
		<td><xsl:value-of select="CSLDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">個人ＩＤ</td>
		<td><xsl:value-of select="PERID" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">コースコード</td>
		<td><xsl:value-of select="CSCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">受診時団体コード１</td>
		<td><xsl:value-of select="ORGCD1" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">受診時団体コード２</td>
		<td><xsl:value-of select="ORGCD2" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">予約群コード</td>
		<td><xsl:value-of select="RSVGRPCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">予約日</td>
		<td><xsl:value-of select="RSVDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">受診時年齢</td>
		<td><xsl:value-of select="AGE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">更新日時</td>
		<td><xsl:value-of select="UPDDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">契約パターンコード</td>
		<td><xsl:value-of select="CTRPTCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">受診区分コード</td>
		<td><xsl:value-of select="CSLDIVCD" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">予約状況</td>
		<td><xsl:value-of select="RSVSTATUS" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">保存時印刷</td>
		<td><xsl:value-of select="PRTONSAVE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">更新者</td>
		<td><xsl:value-of select="UPDUSER" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">成績書出力日</td>
		<td><xsl:value-of select="REPORTPRINTDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">成績書発送日</td>
		<td><xsl:value-of select="REPORTSENDDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">１次健診の予約番号</td>
		<td><xsl:value-of select="FIRSTRSVNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">保険証記号</td>
		<td><xsl:value-of select="ISRSIGN" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">保険証番号</td>
		<td><xsl:value-of select="ISRNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">確認はがき宛先</td>
		<td><xsl:value-of select="CARDADDRDIV" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">確認はがき英文出力</td>
		<td><xsl:value-of select="CARDOUTENG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">確認はがき出力日</td>
		<td><xsl:value-of select="CARDPRINTDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">一式書式宛先</td>
		<td><xsl:value-of select="FORMADDRDIV" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">一式書式英文出力</td>
		<td><xsl:value-of select="FORMOUTENG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">一式書式出力日</td>
		<td><xsl:value-of select="FORMPRINTDATE" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">成績書宛先</td>
		<td><xsl:value-of select="REPORTADDRDIV" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">成績書英文出力</td>
		<td><xsl:value-of select="REPORTOURENG" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">利用券回収</td>
		<td><xsl:value-of select="COLLECTTICKET" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">診察券発行</td>
		<td><xsl:value-of select="ISSUECSLTICKET" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">請求書出力</td>
		<td><xsl:value-of select="BILLPRINT" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">保険者番号</td>
		<td><xsl:value-of select="ISRMANNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">社員番号</td>
		<td><xsl:value-of select="EMPNO" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">紹介者</td>
		<td><xsl:value-of select="INTRODUCTOR" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">ボランティア</td>
		<td><xsl:value-of select="VOLUNTEER" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">ボランティア名</td>
		<td><xsl:value-of select="VOLUNTEERNAME" /></td>
	</tr>
	<tr>
		<td bgcolor="#eeeeee">予約確認メール送信先</td>
		<td><xsl:value-of select="SENDMAILDIV" /></td>
	</tr>

	<xsl:for-each select="CSLSET/CSLSET_ROW">

		<tr>
			<td bgcolor="#eeeeee">セットコード</td>
			<td><xsl:value-of select="SETCD" /></td>
		</tr>

	</xsl:for-each>

	<xsl:for-each select="DELITEM/DELITEM_ROW">

		<tr>
			<td bgcolor="#eeeeee">削除依頼項目コード</td>
			<td><xsl:value-of select="ITEMCD" /></td>
		</tr>

	</xsl:for-each>

</table>

</body>
</html>

</xsl:template>

</xsl:stylesheet>