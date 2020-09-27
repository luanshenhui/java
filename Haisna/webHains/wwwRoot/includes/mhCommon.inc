<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　共通(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------


'スタイルシートファイル
Const MH_StyleSheet = "/webhains/contents/css/MentalHealth.css"

'画像パス
Const MH_ImagePath = "/webhains/images/mental/"

'トータル頁数
Const MH_TotalPage = 12

'回答拒否文言
Const MH_RefusalText1 = "原則的に全項目必須入力ですがどうしても入力したくない項目が存在する場合、入力可能な"
Const MH_RefusalText2 = "項目のみ入力した上で、以下のチェックボックスをチェックし、次頁へ進んでください"
Const MH_RefusalText3 = "入力したくない項目が存在します"

'アクション区分
Const MH_Mode_Fast = 0			'初期遷移時
Const MH_Mode_Back = 1			'戻るボタン
Const MH_Mode_Next = 2			'次へボタン
Const MH_Mode_Clear = 3			'クリアボタン
Const MH_Mode_Result = 4		'総合評価ボタン
Const MH_Mode_Comment = 5		'コメントボタン
Const MH_Mode_Regist = 6		'登録ボタン
Const MH_Mode_End = 7			'終了ボタン
Const MH_Mode_Change = 8		'変更ボタン

'-------------------------------------------------------------------------------
'
' 機能　　 : ログインチェック
'
' 引数　　 : 
'
' 戻り値　 : True   正常
' 　　　　 : False  異常
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function LoginCheck()

	LoginCheck = True

	If isEmpty(Session("RsvNo")) Then
		Session("ErrorMsg1") = "画面を表示できませんでした"
		Session("ErrorMsg2") = "再度、ログインを行なってください"
		LoginCheck = False
	End If

End Function
%>
