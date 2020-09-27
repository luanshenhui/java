<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'	   ＣＵ経年変化～表示検査項目選択 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
'========================================
'管理番号：SL-SN-Y0101-305
'修正日  ：2011.07.01
'担当者  ：ORB)YAGUCHI
'修正内容：頸動脈超音波、動脈硬化、内臓脂肪面積、心不全スクリーニングの追加
'========================================
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objItem				'項目ガイドアクセス用COMオブジェクト

'パラメータ
Dim strAction			'処理状態(セット選択時:"select")
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

Dim strArrItemCd		'項目コード
Dim strArrSuffix		'サフィックス
Dim strArrItemName		'項目名称
Dim lngArrCUTargetFlg	'CU経年変化表示対象
Dim lngCount			'レコード件数
Dim strHtml				'HTML文字列
Dim strChk				'選択フラグ
Dim i, j				'インデックス

'セット選択用
Dim lngSetNo			'選択セットNo
Dim strArrChkItemCd		'検査項目コード（選択中）
Dim strArrChkSuffix		'サフィックス（選択中）
Dim lngSelCnt			'選択済み数
Dim strArrSelItem		'選択済み検査項目

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objItem = Server.CreateObject("HainsItem.Item")

'引数値の取得
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
lngSetNo			= Request("setno")
strArrChkItemCd		= IIf(Request("itemcd")="",Array(),ConvIStringToArray(Request("itemcd")))
strArrChkSuffix		= IIf(Request("suffix")="",Array(),ConvIStringToArray(Request("suffix")))

Do
	lngSelCnt = -1

	'セット選択
'	If strAction = "select" Then

		'セット選択情報の設定
		Call SelectSetInfo( lngSetNo )

		'選択中の検査項目を検索
		For i=0 To UBound(strArrChkItemCd)
			If strArrChkItemCd(i) <> "" And strArrChkSuffix(i) <> "" Then
				lngSelCnt = lngSelCnt + 1
				Redim Preserve strArrSelItem(lngSelCnt) 
				strArrSelItem(lngSelCnt) = strArrChkItemCd(i) & "-" & strArrChkSuffix(i)
			End If
		Next

		strAction = ""
'	End If

	lngArrCUTargetFlg = 1
	'検索条件を満たす検査項目名の一覧を取得する
	lngCount = objItem.SelectItem_cList( _
						"", _
						"", _
						1, _
						strArrItemCd, _
						strArrSuffix, _
						strArrItemName, _
						, , , , , _
						lngArrCUTargetFlg _
						)
	If lngCount < 0 Then
		Err.Raise 1000, , "文章の一覧が取得できません。（検査項目コード = " & strItemCd & ",項目タイプ = " & lngItemType & ")"
	End If


Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ＣＵ経年変化～表示検査項目選択</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//セット選択
function selectSet(SetNo) {
	var i;								// インデックス

	if( document.entryForm.CUSelectItems == null ) {
		return;
	}

	// 選択中の検査項目のみ残す
	if ( document.entryForm.CUSelectItems.length != null ) {
		for( i=0; i<document.entryForm.CUSelectItems.length; i++ ) {
			if( !document.entryForm.CUSelectItems[i].checked ) {
				document.entryForm.itemcd[i].value = '';
				document.entryForm.suffix[i].value = '';
			}
		}
	} else {
		if( !document.entryForm.CUSelectItems.checked ) {
			document.entryForm.itemcd.value = '';
			document.entryForm.suffix.value = '';
		}
	}

	// モードを指定してsubmit
	document.entryForm.act.value = 'select';
	document.entryForm.setno.value = SetNo;
	document.entryForm.submit();

}
//選択終了
function callCUMainGraph() {
	var url;							// URL文字列
	var i;								// インデックス
	var SelectItemcd;					// 選択された検査項目コード
	var SelectSuffix;					// 選択されたサフィックス
	var SelectCnt;						// 選択数

	if( document.entryForm.CUSelectItems == null ) {
		return;
	}

	SelectCnt = 0;
	SelectItemcd = '';
	SelectSuffix = '';
	if ( document.entryForm.CUSelectItems.length != null ) {
		for( i=0; i<document.entryForm.CUSelectItems.length; i++ ) {
			if( document.entryForm.CUSelectItems[i].checked ) {
				if( SelectCnt > 0 ) {
					SelectItemcd = SelectItemcd + ','
					SelectSuffix = SelectSuffix + ','
				}
				SelectItemcd = SelectItemcd + document.entryForm.itemcd[i].value;
				SelectSuffix = SelectSuffix + document.entryForm.suffix[i].value;
				SelectCnt++;
			}
		}
	} else {
		if( document.entryForm.CUSelectItems.checked ) {
			if( SelectCnt > 0 ) {
				SelectItemcd = SelectItemcd + ','
				SelectSuffix = SelectSuffix + ','
			}
			SelectItemcd = SelectItemcd + document.entryForm.itemcd.value;
			SelectSuffix = SelectSuffix + document.entryForm.suffix.value;
			SelectCnt++;
		}
	}

	if( SelectCnt == 0 ) {
		alert("表示検査項目を最低１件は選択してください");
		return;
	}

	if( SelectCnt > 20 ) {
		alert("表示検査項目の最大選択数は２０件です");
		return;
	}

	url = '/WebHains/contents/interview/CUMainGraphMain.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';
	url = url + '&itemcd=' + SelectItemcd;
	url = url + '&suffix=' + SelectSuffix;

	location.href(url);

}
//クリア
function clearCUSelectItems() {
	var i;								// インデックス

	if( document.entryForm.CUSelectItems == null ) {
		return;
	}

	if ( document.entryForm.CUSelectItems.length != null ) {
		for( i=0; i<document.entryForm.CUSelectItems.length; i++ ) {
			document.entryForm.CUSelectItems[i].checked = false
		}
	} else {
		document.entryForm.CUSelectItems.checked = false
	}
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="setno"     VALUE="<%= lngSetNo %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">ＣＵ経年変化～表示検査項目選択</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<!-- 検査項目セット表示 -->
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
			<TD>
				<TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
					<TR>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(1)">体格</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(2)">血圧</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(3)">肺機能</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(4)">血液</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(5)">糖代謝</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(6)">脂質代謝</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(7)">甲状腺</A></TD>
					</TR>
					<TR>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(8)">尿酸</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(9)">肝機能</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(10)">腎機能</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(11)">電解質</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(12)">血清</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(13)">前立腺</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(14)">骨密度</A></TD>
					</TR>
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####%>
					<TR>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(18)">内臓脂肪面積</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(19)">心不全スクリーニング</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(16)">頸動脈超音波</A></TD>
						<TD ALIGN="center" NOWRAP WIDTH="80"><A HREF="JavaScript:selectSet(17)">動脈硬化</A></TD>
					</TR>
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####%>
				</TABLE>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD HEIGHT="25"></TD>
		</TR>
		<!-- 検査項目一覧表示 -->
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
	strHtml = ""
	For i=0 To lngCount-1
		'１列目
		If ((i+1) Mod 4) = 1 Then
			strHtml = "					<TR>"
		End If

		strHtml = strHtml & vbLf & "						<TD NOWRAP WIDTH=""170"">"
		strChk = ""
		For j=0 To lngSelCnt
			If strArrItemCd(i) & "-" & strArrSuffix(i) = strArrSelItem(j) Then
				strChk = " CHECKED"
				Exit For
			End If
		Next
		strHtml = strHtml & vbLf & "							<INPUT TYPE=""checkbox"" NAME=""CUSelectItems""" & strChk & ">" & strArrItemName(i)
		strHtml = strHtml & vbLf & "							<INPUT TYPE=""hidden"" NAME=""itemcd"" VALUE=""" & strArrItemCd(i) & """>"
		strHtml = strHtml & vbLf & "							<INPUT TYPE=""hidden"" NAME=""suffix"" VALUE=""" & strArrSuffix(i) & """>"
		strHtml = strHtml & vbLf & "						</TD>"

		'４列目
		If ((i+1) Mod 4) = 0 Then
			strHtml = strHtml & vbLf & "					</TR>" & vbLf
%>
					<%=strHtml%>
<%
			strHtml = ""
		End If
	Next
	If strHtml <> "" Then
		strHtml = strHtml & vbLf & "					</TR>"
%>
					<%=strHtml%>
<%
	End If
%>
				</TABLE>
			</TD>
			<TD NOWRAP VALIGN="top">
				<TABLE WIDTH="64" BORDER="0" CELLSPACING="3" CELLPADDING="3">
					<TR>
						<TD NOWRAP ALIGN="center" BGCOLOR="#eeeeee"><A HREF="JavaScript:callCUMainGraph()">選択終了</A></TD>
					</TR>
					<TR>
						<TD NOWRAP ALIGN="center" BGCOLOR="#eeeeee"><A HREF="JavaScript:clearCUSelectItems()">クリア</A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>

<%
'セット選択情報
Sub SelectSetInfo(SetNo)

	Select Case SetNo
	Case 1	'体格
		strArrSelItem = Array( "10041-00", _
							   "10024-00", _
							   "10033-00" _
							)

	Case 2	'血圧
		strArrSelItem = Array( "13120-01", _
							   "13120-02" _
							)

	Case 3	'肺機能
		strArrSelItem = Array( "13022-00", _
							   "13024-00" _
							)

	Case 4	'血液
		strArrSelItem = Array( "15020-00", _
							   "15021-00", _
							   "15022-00", _
							   "15023-00", _
							   "15027-00" _
							)

	Case 5	'糖代謝
		strArrSelItem = Array( "17520-00", _
							   "17522-00" _
							)

	Case 6	'脂質代謝
		strArrSelItem = Array( "17421-00", _
							   "17422-00", _
							   "17423-00", _
							   "17420-00" _
							)

	Case 7	'甲状腺
		strArrSelItem = Array( "18425-00", _
							   "18426-00" _
							)

	Case 8	'尿酸
		strArrSelItem = Array( "17320-00" _
							)

	Case 9	'肝機能
		strArrSelItem = Array( "17025-00", _
							   "17027-00", _
							   "17028-00", _
							   "17029-00", _
							   "17031-00", _
							   "17030-00", _
							   "17020-00", _
							   "17021-00", _
							   "17022-00" _
							)

	Case 10	'腎機能
		strArrSelItem = Array( "17220-00", _
							   "17221-00" _
							)

	Case 11	'電解質
		strArrSelItem = Array( "17820-00", _
							   "17821-00", _
							   "17822-00", _
							   "17823-00", _
							   "17824-00" _
							)

	Case 12	'血清
		strArrSelItem = Array( "16124-00", _
							   "16325-00" _
							)

	Case 13	'前立腺
		strArrSelItem = Array( "16324-00" _
							)

	Case 14	'骨密度
		strArrSelItem = Array( "26611-00", _
							   "26614-00", _
							   "26615-00" _
							)

'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####
	Case 16	'頸動脈超音波
		strArrSelItem = Array( "22520-00", "22521-00", "22522-00", _
					"22528-00", "22529-00", "22530-00", _
					"22536-00", "22537-00", "22538-00", _
					"22539-00", "22545-00", "22546-00", _
					"22547-00", "22620-00", "22621-00", _
					"22622-00", "22628-00", "22629-00", _
					"22630-00", "22636-00", "22637-00", _
					"22638-00", "22639-00", "22645-00", _
					"22646-00", "22647-00" _
							)

	Case 17	'動脈硬化
		strArrSelItem = Array( "22710-01", "22710-02", "22720-01", _
					"22720-02", "22730-01", "22730-02", _
					"22731-01", "22731-02", "22740-01", _
					"22740-02", "22741-01", "22741-02" _
							)

	Case 18	'内臓脂肪面積
		strArrSelItem = Array( "24910-00", _
							   "24911-00", _
							   "24912-00", _
							   "24913-00", _
							   "24914-00", _
							   "24915-00" _
							)

	Case 19	'心不全スクリーニング
		strArrSelItem = Array( "43470-00" _
							)

'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####

	Case Else
		strArrSelItem = Array( )

	End Select

	'選択済み数
	lngSelCnt = Ubound(strArrSelItem)

End Sub
%>
