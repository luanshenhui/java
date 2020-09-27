<!-- #include virtual = "/webHains/includes/checkAgent.inc" -->
<%
'キャッシュさせない
'Response.Expires = -1
'Response.AddHeader "Pragma", "No-Cache"
'Response.AddHeader "Cache-Control", "No-Cache"

'動作モード(タイムアウト後、再ログインされた際の動作)の定数
Const CHECKSESSION_TOP          = 0	'トップページへ
Const CHECKSESSION_BUSINESS_TOP = 1	'業務トップページへ
Const CHECKSESSION_SELF         = 2	'タイムアウト時点のページを再び呼び出す
Const CHECKSESSION_CLOSE        = 3	'画面を閉じる

'-------------------------------------------------------------------------------
'
' 機能　　 : セッションチェック
'
' 引数　　 : (In)     strTarget   業務コード
' 　　　　   (In)     lngActMode  動作モード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CheckSession(lngBusinessCd, lngActMode)

	Dim objCommon		'共通クラス
	Dim strURL		'ターゲット先のURL
	Dim strTarget		'再ログイン後のターゲット
	Dim lngAuthority	'権限
	Dim strMessage		'メッセージ
	Dim Ret			'関数戻り値


'## 2003.12.17 Add By T.Takagi@FSIT
	'ユーザが引数指定された場合の処理制御
	Call CheckUserOnUrl
'## 2003.12.17 Add End

	'セッション上のユーザIDが存在しない場合
	If Session("USERID") = "" Then

		'ターゲット先URLとしてまずログイン画面を設定
		strURL = Application("LOGINPAGE")

		'ログイン後動作モード毎の処理分岐
		Select Case lngActMode

			'業務トップへ
			Case CHECKSESSION_BUSINESS_TOP

				'再ログイン後のターゲットを求める
				strTarget = GetBusinessTopPage(Request.ServerVariables("SCRIPT_NAME"))

			'自分自身へ
			Case CHECKSESSION_SELF

				'POSTされている場合
				If Request.ServerVariables("REQUEST_METHOD") = "POST" Then

					'完全な自分自身へのリダイレクトは不可能なため、業務トップに変更する
					strTarget = GetBusinessTopPage(Request.ServerVariables("SCRIPT_NAME"))

				'GETされている場合
				Else

					'ターゲット先は自分自身
					strTarget = Request.ServerVariables("SCRIPT_NAME")

					'引数が存在する場合は追加
					If Request.ServerVariables("QUERY_STRING") <> "" then
						strTarget = strTarget & Server.URLEncode("?" & Request.ServerVariables("QUERY_STRING"))
					End If

				End If

			'再ログインせず、自身を閉じる場合
			Case CHECKSESSION_CLOSE
%>
				<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
				<HTML lang="ja">
				<HEAD>
				</HEAD>
				<BODY ONLOAD="javascript:alert('接続がタイムアウトしました。もう１度ログインして下さい。');top.close()">
				</BODY>
				</HTML>
<%
				Response.End
				Exit Sub

			'その他
			Case Else

		End Select

		'再ログイン後のターゲット先が存在する場合は追加
		If strTarget <> "" Then
			strURL = strURL & "?target=" & strTarget
		End If

		'ログイン画面へリダイレクト
%>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<HTML lang="ja">
		<HEAD>
		</HEAD>
		<BODY ONLOAD="javascript:top.location.replace('<%= strURL %>')">
		</BODY>
		</HTML>
<%
		Response.End
		Exit Sub
	End If
	
	'2006年7月4日既存の権限管理を削除、新しい権限管理を適用。
	'業務コードごとにチェックする権限値を設定する
	'Select Case lngBusinessCd

	'	Case BUSINESSCD_MAINTENANCE	'テーブルメンテナンス
	'		lngAuthority = Session("AUTH_TBLMNT")
    
	'	Case BUSINESSCD_RESERVE		'予約
	'		lngAuthority = Session("AUTH_RSV")
    
	'	Case BUSINESSCD_RESULT		'結果入力
	'		lngAuthority = Session("AUTH_RSL")
    
	'	Case BUSINESSCD_JUDGEMENT	'判定入力
	'		lngAuthority = Session("AUTH_JUD")
    
	'	Case BUSINESSCD_PRINT		'印刷・データ抽出
	'		lngAuthority = Session("AUTH_PRN")
    
	'	Case BUSINESSCD_DEMAND		'請求
	'		lngAuthority = Session("AUTH_DMD")
    
	'	Case Else
	'	'### 2005.07.26 Add By 李　：プログラム操作権限チェック --------> START.
	'		Call CheckPgmAuthority
	'	'### 2005.07.26 Add By 李　：プログラム操作権限チェック --------> END.		
	'	
	'		Exit Sub

	'End Select
    '
	''オブジェクトのインスタンス作成
	'Set objCommon = Server.CreateObject("HainsCommon.Common")
    '
	''権限チェック
	'Ret = objCommon.CheckAuthority(lngBusinessCd, Request.ServerVariables("SCRIPT_NAME"), lngAuthority, strMessage)
    '
	''権限がない場合はエラーページへ
	'If Ret = False Then
	'	Err.Raise 1000, , strMessage
	'End If


'### 2005.07.26 Add By 李　：プログラム操作権限チェック --------> START.
	Call CheckPgmAuthority
'### 2005.07.26 Add By 李　：プログラム操作権限チェック --------> END.


End Sub


'-------------------------------------------------------------------------------
' 機能　　 : プログラムの使用権限をチェックする。
' DATE    ： 2005.07.26 Add By 李

'-------------------------------------------------------------------------------
Sub CheckPgmAuthority()
	Dim strMessage		'メッセージ
	Dim Ret			'関数戻り値
	Dim objAuthority
	Dim lngPgmGrant

	strMessage = ""
	Set objAuthority = Server.CreateObject("HainsAuthority.CheckAuthority")
	Ret = objAuthority.GetAuthority(Session("USERID"), Session("USRGRPCD"), Request.ServerVariables("SCRIPT_NAME"), lngPgmGrant, strMessage)

    '### 画面別操作権限取得 ####################################
    '### 1:参照、2:変更・登録、3:削除、4:すべて
    '##########################################################
    Session("PAGEGRANT")	= lngPgmGrant
	
	If Ret = False Then
		Err.Raise 1000, , strMessage
    End If

End Sub



'-------------------------------------------------------------------------------
'
' 機能　　 : 指定URLに対応する業務のトップページを求める
'
' 引数　　 : (In)     strURL  URL
'
' 戻り値　 : 業務トップページ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetBusinessTopPage(strURL)

	Dim strDirectory	'ディレクトリ名
	Dim strTopPage		'トップページ

	'引数未指定時は何もしない
	If strURL = "" Then
		Exit Function
	End If

	'スラッシュを区切り文字としてディレクトリに分割
	strDirectory = Split(strURL, "/")
	If IsEmpty(strDirectory) Then
		Exit Function
	End If

	'１番目の名称はルートになるはずなので、２番目から見ていく

	'コンテンツディレクトリでなければ検索終了
	If UCase(strDirectory(2)) <> UCase("contents") Then
		Exit Function
	End If

	'３番目のディレクトリ名でトップページを振り分ける
	Select Case UCase(strDirectory(3))

		Case UCase("contract"), UCase("maintenance")
			strTopPage = "/webHains/contents/maintenance/mntMenu.asp"

		Case UCase("demand")
			strTopPage = "/webHains/contents/demand/dmdMenu.asp"

		Case UCase("inquiry")
			strTopPage = "/webHains/contents/inquiry/inqwiz.asp"

		Case UCase("download")
			strTopPage = "/webHains/contents/download/datMenu.asp"

		Case UCase("disease"), UCase("judgement")
			strTopPage = "/webHains/contents/judgement/judMenu.asp"

		Case UCase("print")
			strTopPage = "/webHains/contents/print/prtMenu.asp"

		Case UCase("reserve"), UCase("reserveOrg")
			strTopPage = "/webHains/contents/reserve/rsvMenu.asp"

		Case UCase("result"), UCase("resultAllSet"), UCase("resultListSet")
			strTopPage = "/webHains/contents/result/rslMenu.asp"

	End Select

	GetBusinessTopPage = strTopPage

End Function

'## 2003.12.17 Add By T.Takagi@FSIT
'-------------------------------------------------------------------------------
'
' 機能　　 : 引数指定されたユーザのチェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CheckUserOnUrl()

	Const VARIABLENAME_USERID = "HUSR"

	Dim objHainsUser	'ユーザ情報アクセス用

	Dim strUserId		'ユーザＩＤ
	Dim strUserName		'利用者漢字氏名
	Dim lngAuthTblMnt	'テーブルメンテナンス権限
	Dim lngAuthRsv		'予約業務権限
	Dim lngAuthRsl		'結果入力業務権限
	Dim lngAuthJud		'判定入力業務権限
	Dim lngAuthPrn		'印刷、データ抽出業務権限
	Dim lngAuthDmd		'請求業務権限
	Dim lngIgnoreFlg	'予約枠無視フラグ
	Dim strDelFlg		'削除フラグ
	Dim strURL		'URL文字列
	Dim strVarName		'引数名
	Dim strConnectStr	'接続子
	Dim Ret			'関数戻り値

	'## 2005.07.26 ADD By 李
	Dim vntDeptCd
	Dim vntUsrGrpCd
	'## 2005.07.26 ADD End.

	Do

		'引数にて渡されたユーザＩＤを取得
		strUserId = UCase(Request(VARIABLENAME_USERID))

		'引数未指定時は何もしない
		If strUserId = "" Then
			Exit Do
		End If

		'呼び元の縛りを行う場合はここで行う
'		If Request.ServerVariables("HTTP_REFERER") = "" Then
'			Exit Do
'		End If

		'オブジェクトのインスタンス作成
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")

		'ユーザ情報読み込み
		''Ret = objHainsUser.SelectHainsUser(strUserId, strUserName, , , , , , , , lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , , , , , , , , , lngIgnoreFlg, , , , , strDelFlg)
		Ret = objHainsUser.SelectHainsUser(strUserId, strUserName, , , , , , , , lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , , , , , , , , , lngIgnoreFlg, , , , , strDelFlg, , , , , vntDeptCd, vntUsrGrpCd)

		Set objHainsUser = Nothing

		If Ret = False Then
			Err.Raise 1000, , "指定されたユーザは存在しません。"
			Exit Do
		End If

		If strDelFlg <> "" Then
			Err.Raise 1000, , "指定されたユーザは存在しません。"
			Exit Do
		End If

		'Session変数にユーザ情報を格納する
		Session("USERID")      = strUserId
		Session("USERNAME")    = strUserName
		Session("AUTH_TBLMNT") = lngAuthTblMnt
		Session("AUTH_RSV")    = lngAuthRsv
		Session("AUTH_RSL")    = lngAuthRsl
		Session("AUTH_JUD")    = lngAuthJud
		Session("AUTH_PRN")    = lngAuthPrn
		Session("AUTH_DMD")    = lngAuthDmd
		Session("IGNORE")      = lngIgnoreFlg
		'## 2005.07.26 ADD By 李
		Session("DEPTCD")	= vntDeptCd
		Session("USRGRPCD")	= vntUsrGrpCd
		'## 2005.07.26 ADD End


		'URLがGETで渡されている場合、ユーザを取り除く(POSTの場合は引数が見えないのでそのままにする)
		If Request.ServerVariables("REQUEST_METHOD") = "GET" Then

			'ユーザを取り除いたURL文字列を再作成する
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strConnectStr = "?"
			For Each strVarName In Request.QueryString
				If UCase(strVarName) <> VARIABLENAME_USERID Then
					strURL = strURL & strConnectStr & strVarName & "=" & Request.QueryString(strVarName)
					strConnectStr = "&"
				End If
			Next

			'再作成されたURLでリダイレクト
			Response.Redirect strURL
			Response.End

		End If

		Exit Do
	Loop

End Sub
'## 2003.12.17 Add End
%>
