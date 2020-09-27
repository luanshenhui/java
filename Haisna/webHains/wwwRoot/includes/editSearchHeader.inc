<%
Sub EditSearchHeader(strOrgCd1, strOrgCd2, strCsCd, strPerId, strBirth, strGender, dtmCslDate, strTimeFra, lngCtrPtCd)

	Dim objCommon		'共通クラス
	Dim objCourse		'コース情報アクセス用
	Dim objFree			'汎用情報アクセス用
	Dim objOrganization	'団体情報アクセス用
	Dim objPerson		'個人情報アクセス用

	Dim strOrgName		'団体名称
	Dim strCsName		'コース名

	Dim strLastName		'姓
	Dim strFirstName	'名
	Dim strLastKName	'カナ姓
	Dim strFirstKName	'カナ名
	Dim strPerBirth		'生年月日
	Dim strPerGender	'性別(コード)
	Dim strGenderName	'性別(名称)
	Dim strAge			'年齢

	Dim dtmStrDate		'契約開始日
	Dim dtmEndDate		'契約開始日
	Dim strAgeCalc		'年齢起算日

	Dim strEditBirth	'編集用の生年月日
	Dim strEditGender	'編集用の性別

	'オブジェクトのインスタンス作成
	Set objCommon       = Server.CreateObject("HainsCommon.Common")
	Set objContract     = Server.CreateObject("HainsContract.Contract")
	Set objCourse       = Server.CreateObject("HainsCourse.Course")
	Set objFree         = Server.CreateObject("HainsFree.Free")
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	Set objPerson       = Server.CreateObject("HainsPerson.Person")

	'個人IDが入力されている場合
	If strPerID <> "" Then

		'個人テーブルを読み、氏名・生年月日・性別を取得(ここで取得した年齢は使用しない)
		objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strPerBirth, strPerGender, strEditGender, strAge

		'戻り値用の性別・生年月日編集
		strGender = strPerGender
		strBirth  = strPerBirth

		'編集用の生年月日編集
		strEditBirth  = strPerBirth

	'個人IDが入力されていない場合
	Else

		'編集用の性別・生年月日編集
		strEditGender = IIf(strGender = "1", "男性", "女性")
		strEditBirth = strBirth

	End If

	'年齢計算に際し、年齢起算日取得
	objContract.SelectCtrPt lngCtrPtCd, dtmStrDate, dtmEndDate, strAgeCalc

	'年齢計算
	strAge = objFree.CalcAge(strEditBirth, dtmCslDate, strAgeCalc)
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" CLASS="parameta">
		<TR>
			<TD NOWRAP ROWSPAN="4" VALIGN="top"><B>指定条件&nbsp;</B></TD>
			<TD>受診団体</TD>
			<TD>：</TD>
<%
			'団体名読み込み
			objOrganization.SelectOrgSName strOrgCd1, strOrgCd2, strOrgName
%>
			<TD NOWRAP><B><FONT COLOR="#ff6600"><%= strOrgName %></FONT></B></TD>
		</TR>
		<TR>
			<TD>コース</TD>
			<TD>：</TD>
<%
			'コース名取得
			objCourse.SelectCourse strCsCd, strCsName
%>
			<TD NOWRAP><B><FONT COLOR="#ff6600"><%= strCsName %></FONT></B></TD>
		</TR>
		<TR>
			<TD NOWRAP>受診者情報</TD>
			<TD>：</TD>
			<TD NOWRAP>
				<B><FONT COLOR="#ff6600">
<%
				'個人ID指定時は氏名を編集
				If strPerID <> "" Then
%>
					<%= strLastName %>　<%= strFirstName %>　
<%
				End If
%>
				<%= strEditGender %>　<%= objCommon.FormatString(strEditBirth, "yyyy年mm月dd日") %>生（<%= strAge %>歳）
				</FONT></B>
			</TD>
		</TR>
		<TR>
			<TD>受診希望日</TD>
			<TD>：</TD>
			<TD NOWRAP><B><FONT COLOR="#ff6600"><%= objCommon.FormatString(dtmCslDate, "yyyy年mm月dd日") %>　<%= objCommon.SelectTimeFraName(strTimeFra) %></FONT></B></TD>
		</TR>
	</TABLE>
<%
End Sub
%>
