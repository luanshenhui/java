VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "RslOcr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public UniqueKey        As String
Public PerId            As Variant  '個人ＩＤ
Public CslDate          As Variant  '受診日
Public RsvNo            As Variant  '予約番号
Public ItemCd           As Variant  '検査項目コード
Public Suffix           As Variant  'サフィックス
Public ResultType       As Variant  '結果タイプ
Public ItemType         As Variant  '項目タイプ
Public ItemName         As Variant  '検査項目名称
Public Figure1          As Variant  '整数部桁数
Public Figure2          As Variant  '小数部桁数
Public MaxValue         As Variant  '最大値
Public MinValue         As Variant  '最小値
Public Unit             As Variant  '単位
Public RslFlg           As Variant  '検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
Public Result           As Variant  '検査結果
Public StopFlg          As Variant  '検査中止フラグ
Public RslCmtCd1        As Variant  '結果コメント１
Public RslCmtName1      As Variant  '結果コメント名１
Public RslCmtCd2        As Variant  '結果コメント２
Public RslCmtName2      As Variant  '結果コメント名２
Public LstCslDate       As Variant  '前回受診日
Public LstRsvNo         As Variant  '前回予約番号
Public LstRslFlg        As Variant  '前回検査結果存在フラグ(2:個人検査結果に存在する、1:検査結果に存在する、0:検査結果に存在しない）
Public LstStopFlg       As Variant  '前回検査中止フラグ
Public LstResult        As Variant  '前回検査結果
Public LstRslCmtCd1     As Variant  '前回結果コメント１
Public LstRslCmtName1   As Variant  '前回結果コメント名１
Public LstRslCmtCd2     As Variant  '前回結果コメント２
Public LstRslCmtName2   As Variant  '前回結果コメント名２
Public Index            As Variant  'Index

