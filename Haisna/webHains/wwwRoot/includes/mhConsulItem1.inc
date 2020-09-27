<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　あなたの基本情報チェック画面表示用(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
'inputType区分定数
Private Const pcRadio = 0
Private Const pcText = 1

'画面表示文言
Private aryQuestion
Private aryAnswer(15,15)

aryQuestion = Array("１．性別を選んでください", _
					"２．あなたの年齢をご記入ください", _
					"３．結婚されていますか", _
					"４．仕事をされていますか" , _
					"５．現在のお仕事は交替性ですか" , _
					"６．今の会社での勤続年数は何年ですか" , _
					"７．あなたの雇用形態は、次のどれにあたりますか" , _
					"８．あなたの会社の従業員数はどれ位ですか" , _
					"９．あなたの勤務先は、次のどれにあたりますか" , _
					"１０．あなたの職種は次のどれにあたりますか" , _
					"１１．あなたの現在の職位は次のどれにあたりますか" , _
					"１２．あなたの直属の部下数は何人ですか" , _
					"１３．１週間の所定労働時間は" , _
					"１４．平均的な１週間の実働時間は" , _
					"１５．１ヵ月平均の残業時間はどのくらいですか" , _
					"１６．過去３ヵ月に、病気で何日休みましたか" )

aryAnswer(0,0)="１）男"
aryAnswer(0,1)="２）女"

aryAnswer(1,0)="歳"

aryAnswer(2,0)="１）既婚"
aryAnswer(2,1)="２）独身"
aryAnswer(2,2)="３）死別"

aryAnswer(3,0)="１）仕事をしている"
aryAnswer(3,1)="２）仕事をしていない"

aryAnswer(4,0)="１．昼間の仕事である"
aryAnswer(4,1)="２．夜勤だけである"
aryAnswer(4,2)="３．昼夜交替勤務である"

aryAnswer(5,0)="年"

aryAnswer(6,0)="１．正職員"
aryAnswer(6,1)="２．嘱託"
aryAnswer(6,2)="３．パート"
aryAnswer(6,3)="４．派遣社員"
aryAnswer(6,4)="５．その他"



aryAnswer(7,0)="１．１００人未満"
aryAnswer(7,1)="２．１００～５００人"
aryAnswer(7,2)="３．５００～１０００人"
aryAnswer(7,3)="４．１０００～５０００人"
aryAnswer(7,4)="５．５０００人以上"

aryAnswer(8,0)="１．製造業"
aryAnswer(8,1)="２．金融業"
aryAnswer(8,2)="３．保険業"
aryAnswer(8,3)="４．流通業"
aryAnswer(8,4)="５．運輸業"
aryAnswer(8,5)="６．国家公務員"
aryAnswer(8,6)="７．地方公務員"
aryAnswer(8,7)="８．医療機関"
aryAnswer(8,8)="９．福祉施設"
aryAnswer(8,9)="１０．農林水産業"
aryAnswer(8,10)="１１．建設業"
aryAnswer(8,11)="１２．マスコミ"
aryAnswer(8,12)="１３．商社"
aryAnswer(8,13)="１４．自営業"
aryAnswer(8,14)="１５．飲食店"
aryAnswer(8,15)="１６．その他"


aryAnswer(9,0)="１．営業"
aryAnswer(9,1)="２．生産"
aryAnswer(9,2)="３．開発・研究"
aryAnswer(9,3)="４．一般管理（総務・経理）"
aryAnswer(9,4)="５．人事・労務"
aryAnswer(9,5)="６．企画・調査"
aryAnswer(9,6)="７．その他"

aryAnswer(10,0)="１．役員"
aryAnswer(10,1)="２．部長クラス"
aryAnswer(10,2)="３．課長クラス"
aryAnswer(10,3)="４．係長クラス"
aryAnswer(10,4)="５．一般"


aryAnswer(11,0)="１．いない"
aryAnswer(11,1)="２．１０人以下"
aryAnswer(11,2)="３．１１～２０人"
aryAnswer(11,3)="４．２１～３０人"
aryAnswer(11,4)="５．３１～４０人"
aryAnswer(11,5)="６．４１～５０人"
aryAnswer(11,6)="７．５１～１００人"
aryAnswer(11,7)="８．１０１人以上"

aryAnswer(12,0)="時間"

aryAnswer(13,0)="時間"

aryAnswer(14,0)="時間"

aryAnswer(15,0)="日"

%>