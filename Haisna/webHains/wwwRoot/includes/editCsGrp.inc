<%
'-----------------------------------------------------------------------------
'		面接支援　前回歴コンボボックス表示(Ver0.0.1)
'		AUTHER  : Keiko Fujii@ffcs
'-----------------------------------------------------------------------------
'
Dim strSelCsGrp			'コンボボックスで選択されたコースグループ
Dim DispCalledFunction	'表示ボタン押下時に呼び出される関数

Sub EditCsGrpInfo(lngRsvNo)

	Dim lngCsGrpCnt
	Dim vntCsGrpCd
	Dim vntCsGrpName
	Dim i

	'コースグループ取得
	lngCsGrpCnt = objInterview.SelectCsGrp( _
    									lngRsvNo, _
    									vntCsGrpCd, _
    									vntCsGrpName _
										)

	Redim Preserve strArrLastCsGrp(-1)
	Redim Preserve strArrLastCsGrpName(-1)

	For i = 0 To lngCsGrpCnt - 1
		Redim Preserve strArrLastCsGrp(i)
		Redim Preserve strArrLastCsGrpName(i)
		strArrLastCsGrp(i) = vntCsGrpCd(i)
		strArrLastCsGrpName(i) = vntCsGrpName(i)
	Next
	
	Redim Preserve strArrLastCsGrp(UBound(strArrLastCsGrp)+1)
	Redim Preserve strArrLastCsGrpName(UBound(strArrLastCsGrpName)+1)
	strArrLastCsGrp(UBound(strArrLastCsGrp)) = "0"
	strArrLastCsGrpName(UBound(strArrLastCsGrpName)) = "すべてのコース"

	Redim Preserve strArrLastCsGrp(UBound(strArrLastCsGrp)+1)
	Redim Preserve strArrLastCsGrpName(UBound(strArrLastCsGrpName)+1)
	strArrLastCsGrp(UBound(strArrLastCsGrp)) = "1"
	strArrLastCsGrpName(UBound(strArrLastCsGrpName)) = "同一コースのみ"

%>
	<TD NOWRAP>&nbsp;前回値：</TD>
	<TD><%= EditDropDownListFromArray("csgrp", strArrLastCsGrp, strArrLastCsGrpName, strSelCsGrp, NON_SELECTED_DEL) %></TD>
	<TD>を</TD>
<%
	'呼び出される関数が指定されている
	If DispCalledFunction <> "" Then
%>
	<TD><A HREF="JavaScript:<%=DispCalledFunction%>"><IMG SRC="/webHains/images/b_prev.gif" ALT="表示" HEIGHT="28" WIDTH="53"></A></TD>
<%
	Else
%>
	<TD><INPUT TYPE="image" NAME="disp" SRC="/webHains/images/b_prev.gif" ALT="表示" HEIGHT="28" WIDTH="53"></TD>
<%
	End If

'### 2013.01.11 ADD START 配列でない場合は取得に失敗している by ishihara
	'
	If IsArray(vntPerId) = false Then
%>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
<%
		Exit Sub
	End If
'### 2013.01.11 ADD End
	
'#### 2012.06.07 SOAR)竹野内 電子カルテへのリンクボタン設置のため ADD START ####
	'電子チャート起動（モード選択画面）
	Dim strURL	'ジャンプ先のURL
	If Left(vntPerId(0), 1) <> "@" Then
		'仮患者IDでない場合、アイコン表示

		strURL = ""
		strURL = strURL & "/webHains/contents/sso/HainsEgmainConnect.asp"
		strURL = strURL & "?funccode=FC001"
		strURL = strURL & "&csldate=" & Replace(vntCslDate(0), "/", "")
		strURL = strURL & "&perID=" & vntPerId(0)
%>
		<TD><A HREF="javascript:void(window.open('<%= strURL %>', '', 'width=400,height=200'));"><IMG SRC="/webHains/images/hope.gif" WIDTH="20" HEIGHT="20" ALT="電子チャート情報を参照"></A></TD>
<%
	Else
		'仮患者IDの場合、アイコン非表示
%>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
<%
	End If
'#### 2012.06.07 SOAR)竹野内 電子カルテへのリンクボタン設置のため ADD END ####
End Sub
%>
