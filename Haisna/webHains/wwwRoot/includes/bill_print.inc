<%
'########################################
'管理番号：SL-HS-Y0101-001
'修正日  ：2010.09.09
'担当者  ：FJTH)KOMURO
'修正内容：TXTファイルダウンロード対応
'########################################
Const PRT_TEMPPATH = "/webHains/BillTemp/"			'ＣｏＲｅｐｏｒｔワーク
Const PRT_DATAPATH = "/webHains/Reports/"		'ＣｏＲｅｐｏｒｔフォーム

Const PRT_ANNAI         = "000001"				'健診ご案内
Const PRT_OSHIRASE      = "000002"				'受診お知らせ
Const PRT_QUESTION      = "000003"				'人間ドック問診表
Const PRT_JUSHINLIST    = "000004"				'受診者一覧表
Const PRT_YOTEILIST     = "000005"				'検査予定一覧表
Const PRT_WORKSHEET     = "000006"				'ワークシート
Const PRT_JUSHINHYO     = "000007"				'受診表
Const PRT_ORGLIST       = "000008"				'団体一覧表
Const PRT_REPORT        = "000009"				'健康診断報告書
Const PRT_RENMEIBO      = "000010"				'健康診断連名簿
Const PRT_STAJUDGEMENT  = "000011"				'年齢別総合判定数統計
Const PRT_STAMONTHLIST  = "000012"				'コース別受診者数統計
Const PRT_STAAGELIST    = "000013"				'コース別実施人数統計
Const PRT_STAABNORMAL   = "000014"				'年齢別異常項目数統計
Const PRT_STAJUDSUBJECT = "000015"				'判定分野別件数統計
Const PRT_PERBILL       = "000016"				'個人請求書
Const PRT_ORGBILL       = "000017"				'団体請求書
Const PRT_DMDCHECKLIST  = "000018"				'健診請求チェック表
Const PRT_DMDLIST       = "000019"				'締め日別請求額集計表
Const PRT_ORGDMD        = "000020"				'負担元別請求確認リスト
Const PRT_DMDBALANCE    = "000021"				'請求残高一覧表
Const PRT_DMPER         = "000022"				'DMラベル（受診者）
Const PRT_DMORG         = "000023"				'DMラベル（団体様）
Const PRT_LETTER        = "000026"				'申し込みハガキ
Const PRT_OSHIRASE_DOC  = "000031"				'受診お知らせ(ドック)

Const PRINTMODE_PREVIEW = "0"	'印刷モード(プレビュー)
Const PRINTMODE_DIRECT  = "1"	'印刷モード(直接出力)

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票出力ASP制御処理
'
' 引数　　 : (In)     strMode  印刷モード
'
' 戻り値　 : メッセージ発生時、メッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function PrintControl(strMode)

	'COMオブジェクト
	Dim objPrintCommon	'印刷用共通クラス
	Dim objReportLog	'印刷ログ情報アクセス用

	'作業用変数
	Dim lngPrintSeq		'プリントSEQ
	Dim strFileName		'帳票ドキュメントファイル名
	Dim vntMessage		'エラーメッセージ
	Dim strURL			'URL文字列

	Dim lngPos			'検索用変数
	Dim strExtension	'拡張子

	'固有引数値の取得
	Call GetQueryString()

	'印刷の制御
	Do

		'印刷終了時は何もしない
		'(印刷終了についてはURLのQueryString値によって通知させている)
		If Not IsEmpty(Request("printOut")) Then
			vntMessage = "印刷処理が完了しました。"
			Exit Do
		End If

		'印刷モード未指定時は何もしない
		If strMode = "" Then
			Exit Do
		End If

		'引数値のチェック
		vntMessage = CheckValue()
		If Not IsEmpty(vntMessage) Then
			Exit Do
		End If

		'■本プログラムにおける帳票出力処理について

		'これまでの帳票出力処理はActiveXコントロールでのプレビュー処理、またはAPサーバでの直接出力処理かに応じ、COM+コンポーネント内で処理制御分岐を行っていた。
		'但しこの方式ではコンポーネント内での処理分岐が多岐に渡り、プログラムの可読性やメンテナンスの容易性を失っていた。
		'本プログラムでは、コンポーネント内においては帳票ドキュメントファイルを作成するまでに留め、プレビューか直接出力かはASP側で分岐させるものとする。
		'これにより印刷ログ情報からの再プレビュー、及び再印刷処理も容易となる。

		'帳票ドキュメントファイルの作成
		lngPrintSeq = Print()
		If lngPrintSeq <= 0 Then
			vntMessage = "データはありませんでした。"
			Exit Do
		End If

		'印刷ログ情報のプリントSEQをキーに、帳票ドキュメントファイル名を取得する。
		Set objReportLog = Server.CreateObject("HainsReportLog.ReportLog")
		If Not objReportLog.SelectReportLog2(lngPrintSeq, strFileName) Then
			vntMessage = "データはありませんでした。"
			Exit Do
		End If

'		'印刷モードによる処理分岐
'		Select Case strMode
'
'			'ActiveXコントロールによるプレビューの場合
'			Case PRINTMODE_PREVIEW

				'テーブル構造上、印刷ログ情報が存在するが帳票ドキュメントファイルは存在しないといった場合が考えられるため、一応のトラップを用意する。
				'(実際は帳票ドキュメントファイルが作成できなかった場合にコンポーネントからSEQ値が得られることはないので、本条件を満たすケースは考えにくい。)
				If strFileName = "" Then
					vntMessage = "データはありませんでした。"
					Exit Do
				End If

				lngPos = InStrRev(strFileName, ".")
				If lngPos > 0 Then
					strExtension = UCase(Mid(strFileName, lngPos + 1))
				End If

				'cidファイルの場合は
				If strExtension = "CID" Then

					'得られた帳票ドキュメントファイル名を引数に付加し、プレビュー表示用のASPを呼び出す。
					Response.Redirect "prtPreview.asp?documentFileName=" & strFileName
					Response.End


'##2004.08.27 UPD STR ORB)A.NAGUMO 拡張子xlsもダウンロードさせる
	'			Else
					'それ以外はダウンロードさせる
	'				Response.ContentType = "application/x-download"
	'				Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
	'				Response.AddHeader "Content-Disposition","filename=" & strFileName
	'				Server.Execute PRT_TEMPPATH & strFileName
	'				Response.End

				ElseIf strExtension = "CSV" Then
					'ダウンロードさせる
					Response.ContentType = "application/x-download"
					Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
					Response.AddHeader "Content-Disposition","filename=" & strFileName
					Server.Execute PRT_TEMPPATH & strFileName
					Response.End
					
				ElseIf strExtension = "XLS" Then
					'ダウンロードさせる
					Response.ContentType = "application/octet-stream"
					Response.AddHeader "Content-Disposition","attachment;filename=" & strFileName
					Server.Execute PRT_TEMPPATH & strFileName
					Response.End
'##2004.08.27 UPD END ORB)A.NAGUMO
'##2004.09.07 UPD STR FJTH)C.M
				ElseIf strExtension = "TXT" Then
					'ダウンロードさせる
'#### 2010.09.09 SL-HS-Y0101-001 MOD START ####
'					Response.ContentType = "application/x-download"
'					Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
'					Response.AddHeader "Content-Disposition","filename=" & strFileName
					Response.ContentType = "application/octet-stream"
					Response.AddHeader "Content-Disposition","attachment; filename=" & strFileName
'#### 2010.09.09 SL-HS-Y0101-001 MOD END ####
					Server.Execute PRT_TEMPPATH & strFileName
					Response.End
'##2004.09.07 UPD END FJTH)C.M

				End If

'			'直接印刷の場合
'			Case PRINTMODE_DIRECT
'
'				'ここで、今までの帳票出力では存在しなかった「印刷ログのプリントSEQをキーに帳票の印刷を行う」メソッドを呼び出す。
'				Set objPrintCommon = Server.CreateObject("HainsPrintCommon.PrintCommon")
'				If Not objPrintCommon.PrintFile(lngPrintSeq) Then
'					vntMessage = "印刷処理で異常が発生しました。"
'					Exit Do
'				End If
'
'				'自分自身を印刷終了通知付きでリダイレクトする。
'				'これが無いと自身がリロードされる度に印刷処理が行われてしまうので、その回避策的意味合いを持つ。
'				strURL = Request.ServerVariables("SCRIPT_NAME")
'				strURL = strURL & "?printOut=1"
'				strURL = strURL & "&" & Request.ServerVariables("QUERY_STRING")
'				Response.Redirect strURL
'				Response.End
'
'		End Select

		Exit Do
	Loop

	PrintControl = vntMessage

End Function
%>
