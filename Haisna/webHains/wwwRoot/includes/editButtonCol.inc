<%
'========================================
'管理番号：SL-UI-Y0101-002
'修正日  ：2010.06.04
'担当者  ：FJTH)KOMURO
'修正内容：シングル患者選択用アイコン追加
'========================================

'-------------------------------------------------------------------------------
'
' 機能　　 : 保険区分一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName             エレメント名
' 　　　　   (In)     strSelectedIsrDiv   リストにて選択すべき保険区分
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditButtonCol(lngRsvNo, lngCancelFlg, dtmCslDate, strPerId, strDayId, dtmRptDate)

	Dim dtmDate	'日付
	Dim strURL	'ジャンプ先のURL
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADING="1">
		<TR>
<%
			'予約ボタン
%>
			<TD><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= lngRsvNo %>" TARGET="_top"><IMG SRC="/webHains/images/rsv.gif" WIDTH="20" HEIGHT="20" ALT="予約内容を見る"></A></TD>
<%
			Do

				'キャンセル者の場合
				If lngCancelFlg <> CONSULT_USED Then
%>
					<TD NOWRAP><FONT COLOR="red">キャンセルされました。</FONT></TD>
<%
					Exit Do
				End If

				'受付ボタン
%>
				<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:showReceipt('<%= lngRsvNo %>', '<%= Year(dtmRptDate) %>', '<%= Month(dtmRptDate) %>', '<%= Day(dtmRptDate) %>')"><IMG SRC="/webHains/images/receipt.gif" WIDTH="20" HEIGHT="20" ALT="受付する"></A></TD>
<%
				'結果入力ボタン

				'受診日と受付日が異なり、かつ当日IDが存在する場合、受付日ベースで指定する
				If dtmCslDate <> dtmRptDate And strDayId <> "" Then
					dtmDate = dtmRptDate
				Else
					dtmDate = dtmCslDate
				End If

				'結果入力画面のURL編集

' 2003/12/10 暫定で問診画面へ
'				strURL = "/webHains/contents/result/rslMain.asp"
				strURL = "/webHains/contents/monshin/preparationInfo.asp"

				strURL = strURL & "?rsvNo="      & lngRsvNo
'				strURL = strURL & "&cslYear="    & Year(dtmDate)
'				strURL = strURL & "&cslMonth="   & Month(dtmDate)
'				strURL = strURL & "&cslDay="     & Day(dtmDate)
'				strURL = strURL & "&dayId="      & strDayId
'				strURL = strURL & "&noPrevNext=" & "1"
%>
				<TD><A HREF="<%= strURL %>" TARGET="_top"><IMG SRC="/webHains/images/result.gif" WIDTH="20" HEIGHT="20" ALT="結果入力"></A></TD>
<%
				'判定ボタン(当日ID指定時)
				If strDayId <> "" Then

					'判定入力画面のURL編集
'### 2003/11/2 Updated by Ishihara@FSIT 聖路加殿仕様では、面接支援を出力する。
'					strURL = "/webHains/contents/judgement/judMain.asp"
'					strURL = strURL & "?cslYear="    & Year(dtmDate)
'					strURL = strURL & "&cslMonth="   & Month(dtmDate)
'					strURL = strURL & "&cslDay="     & Day(dtmDate)
'					strURL = strURL & "&dayId="      & strDayId
'					strURL = strURL & "&noPrevNext=" & "1"

					strURL = "/webHains/contents/interview/interviewTop.asp"
					strURL = strURL & "?rsvNo="      & lngRsvNo

%>
<!--					<TD><A HREF="<%= strURL %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="面接支援"></A></TD>-->
					<TD><A HREF="#" onclick="javascript:window.open('<%= strURL %>', '', ' ');return false;"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="面接支援"></A></TD>
<%
				Else
%>
					<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
<%
				End If

				'健診歴参照
%>
				<TD><A HREF="/webHains/contents/inquiry/inqMain.asp?PerID=<%= strPerId %>" TARGET="_top"><IMG SRC="/webHains/images/inq.gif" WIDTH="20" HEIGHT="20" ALT="健診歴を参照"></A></TD>
<%
'#### 2010.06.04 SL-UI-Y0101-002 ADD START ####
				'電子チャート起動（モード選択画面）

				If Left(strPerId, 1) <> "@" Then
					'仮患者IDでない場合、アイコン表示

					strURL = ""
					strURL = strURL & "/webHains/contents/sso/HainsEgmainConnect.asp"
					strURL = strURL & "?funccode=FC001"
					strURL = strURL & "&csldate=" & Replace(dtmDate, "/", "")
					strURL = strURL & "&perID=" & strPerId
%>
					<TD><A HREF="javascript:void(window.open('<%= strURL %>', '', 'width=400,height=200'));"><IMG SRC="/webHains/images/hope.gif" WIDTH="20" HEIGHT="20" ALT="電子チャート情報を参照"></A></TD>
<%
				Else
					'仮患者IDの場合、アイコン非表示
%>
					<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
<%
				End If
'#### 2010.06.04 SL-UI-Y0101-002 ADD END ####
				Exit Do
			Loop
%>
		</TR>
	</TABLE>
<%
End Sub
%>
