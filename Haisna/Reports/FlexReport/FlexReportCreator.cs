using Dapper;
using Hainsi.Model.FlexReportCommon;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    public class FlexReportCreator : PdfCreator
    {

        // 報告区分
        private const int OUTPUT_NORMAL = 0;            // 出力区分「指定なし」
        private const int OUTPUT_REPORTED_ONLY = 1;     // 出力区分「報告済み」
        private const int OUTPUT_YET_REPORTED = 2;      // 出力区分「未報告」

        private const string REPORTCD_PER_CSL_HISTORY = "200004";   // 帳票コード(健康簿)
        private const string FREE_TARGET_CSCD = "LST00300%";        // 今回対象コース
        private const string FREE_TARGET_CSCD_HAI = "LST00303%";    // 肺ドック対象コース
        private const string FREE_TARGET_LASTCSCD = "LST00301%";    // 過去歴対象コース
        private const string TARGET_CSCD_HAI = "150";               // 肺ドックコースコード

        private const string ABNORMAL_MARK_STRING = "*";

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd
        {
            get
            {
                return queryParams["reportcd"];
            }
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            // エラーメッセージの集合
            var messages = new List<string>();
            int? errFlg;
            string[] aryChkString = new string[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ",", "-" };
            string[] aryChkString2 = new string[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };
            // 帳票コード
            string reportCd = string.IsNullOrEmpty(queryParams["reportcd"]) ? "" : queryParams["reportcd"];
            // 当日ID
            string dayId = string.IsNullOrEmpty(queryParams["dayid"]) ? "" : queryParams["dayid"];

            // 受診日チェック
            if (!DateTime.TryParse(queryParams["scsldate"], out DateTime sCslDate))
            {
                messages.Add("開始日付が正しくありません。");
            }
            if (!DateTime.TryParse(queryParams["ecsldate"], out DateTime eCslDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            // 当日IDチェック
            if (!string.IsNullOrEmpty(queryParams["dayid"]))
            {
                errFlg = 0;
                foreach (string val in aryChkString2)
                {
                    if (dayId.Substring(dayId.Length - 1, 1) == val)
                    {
                        errFlg = 1;
                        break;
                    }
                }
                if (errFlg == 0)
                {
                    messages.Add("当日IDの最後の文字が正しくありません。");
                }


                for (int i = 0; i < dayId.Length; i++)
                {
                    errFlg = 0;
                    foreach (string val in aryChkString)
                    {
                        if (dayId.Substring(i, 1) == val)
                        {
                            errFlg = 1;
                            break;
                        }
                    }
                    if (errFlg == 0)
                    {
                        messages.Add("当日IDが正しくありません。");
                        break;
                    }
                }

                // 出力様式のチェック
                if (string.IsNullOrEmpty(queryParams["reportcd"]))
                {
                    messages.Add("出力様式を選択して下さい。");
                }
                // 出力様式のチェック
                if (((reportCd.CompareTo("000305") == 0 || reportCd.CompareTo("000305") == 1)
                    && (reportCd.CompareTo("000308") == 0 || reportCd.CompareTo("000308") == -1))
                    || reportCd.CompareTo("000312") == 0)
                {
                    if (sCslDate < Convert.ToDateTime("2004/04/01"))
                    {
                        messages.Add("開始日が 2004年3月31日 以前です。");
                    }
                }
                // 出力様式のチェック
                if ((reportCd.CompareTo("000301") == 0 || reportCd.CompareTo("000301") == 1)
                    && (reportCd.CompareTo("000304") == 0 || reportCd.CompareTo("000304") == -1))
                {
                    if (sCslDate > Convert.ToDateTime("2004/03/31"))
                    {
                        messages.Add("開始日が 2004年4月1日 以降です。");
                    }
                }
                // 出力様式のチェック
                if (((reportCd.CompareTo("000305") == 0 || reportCd.CompareTo("000305") == 1)
                    && (reportCd.CompareTo("000308") == 0 || reportCd.CompareTo("000308") == -1))
                    || reportCd.CompareTo("000312") == 0)
                {
                    if (sCslDate > Convert.ToDateTime("2007/03/31"))
                    {
                        messages.Add("開始日が 2007年4月1日 以降です。");
                    }
                }
                // 出力様式のチェック
                if ((reportCd.CompareTo("000320") == 0 || reportCd.CompareTo("000320") == 1)
                    && (reportCd.CompareTo("000324") == 0 || reportCd.CompareTo("000324") == -1))
                {
                    if (sCslDate < Convert.ToDateTime("2007/04/01"))
                    {
                        messages.Add("開始日が 2007年4月1日 以前です。");
                    }
                }
                // 出力様式のチェック
                if (((reportCd.CompareTo("000320") == 0 || reportCd.CompareTo("000320") == 1)
                    && (reportCd.CompareTo("000324") == 0 || reportCd.CompareTo("000324") == -1))
                    || reportCd.CompareTo("000311") == 0)
                {
                    if (sCslDate > Convert.ToDateTime("2008/03/31"))
                    {
                        messages.Add("開始日が 2008年4月1日 以降です。");
                    }
                }
                // 出力様式のチェック
                if ((reportCd.CompareTo("000330") == 0 || reportCd.CompareTo("000330") == 1)
                    && (reportCd.CompareTo("000339") == 0 || reportCd.CompareTo("000339") == -1))
                {
                    if (sCslDate < Convert.ToDateTime("2008/04/01"))
                    {
                        messages.Add("開始日が 2008年4月1日 以前です。");
                    }
                }

                // 印刷ページのチェック
                if (reportCd == "000303" || reportCd == "000307" || reportCd == "000324")
                {
                    if (!"1".Equals(queryParams["page1"]) && !"1".Equals(queryParams["page2"]) && !"1".Equals(queryParams["page3"]))
                    {
                        messages.Add("印刷ページを指定してください。");
                    }
                }
                // 印刷ページのチェック
                if (reportCd == "000304" || reportCd == "000308" || reportCd == "000309" || reportCd == "000322")
                {
                    if (!"1".Equals(queryParams["page1"]))
                    {
                        messages.Add("印刷ページを指定してください。");
                    }
                }

                if (dayId == "" && string.IsNullOrEmpty(queryParams["orggrpcd"]) && string.IsNullOrEmpty(queryParams["orgcd11"]))
                {
                    messages.Add("受診日範囲以外の条件を指定してください。");
                }

            }

            return messages;
        }

        /// <summary>
        /// ネームバンドデータを読み込む
        /// </summary>
        /// <returns>ネームバンドデータ</returns>
        protected override List<dynamic> GetData()
        {
            // 当日ID
            string dayId = string.IsNullOrEmpty(queryParams["dayid"]) ? "" : queryParams["dayid"];
            // 当日ＩＤ指定件数
            int dayIdCount = 0;
            // 文字位置
            int strPos = 0;
            // 団体コード件数
            int orgParamCount = 0;
            // 当日ＩＤ配列
            IList<string> arrDayId;
            // 団体コード１配列
            IList<string> arrOrgCd1 = new List<string>();
            // 団体コード２配列
            IList<string> arrOrgCd2 = new List<string>();

            // 複数設定されてある当日ＩＤを分解する
            arrDayId = dayId.Trim().Split(',');
            if (!"".Equals(dayId))
            {
                dayIdCount = arrDayId.Count;
            }

            // 設定されている団体コードパラメータの件数を取得する
            if (!string.IsNullOrEmpty(queryParams["orgcd11"]) || !string.IsNullOrEmpty(queryParams["orgcd12"]))
            {
                arrOrgCd1.Add(queryParams["orgcd11"]);
                arrOrgCd2.Add(queryParams["orgcd12"]);
                orgParamCount++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd21"]) || !string.IsNullOrEmpty(queryParams["orgcd22"]))
            {
                arrOrgCd1.Add(queryParams["orgcd21"]);
                arrOrgCd2.Add(queryParams["orgcd22"]);
                orgParamCount++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd31"]) || !string.IsNullOrEmpty(queryParams["orgcd32"]))
            {
                arrOrgCd1.Add(queryParams["orgcd31"]);
                arrOrgCd2.Add(queryParams["orgcd32"]);
                orgParamCount++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd41"]) || !string.IsNullOrEmpty(queryParams["orgcd42"]))
            {
                arrOrgCd1.Add(queryParams["orgcd41"]);
                arrOrgCd2.Add(queryParams["orgcd42"]);
                orgParamCount++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd51"]) || !string.IsNullOrEmpty(queryParams["orgcd52"]))
            {
                arrOrgCd1.Add(queryParams["orgcd51"]);
                arrOrgCd2.Add(queryParams["orgcd52"]);
                orgParamCount++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd61"]) || !string.IsNullOrEmpty(queryParams["orgcd62"]))
            {
                arrOrgCd1.Add(queryParams["orgcd61"]);
                arrOrgCd2.Add(queryParams["orgcd62"]);
                orgParamCount++;
            }
            if (!string.IsNullOrEmpty(queryParams["orgcd71"]) || !string.IsNullOrEmpty(queryParams["orgcd72"]))
            {
                arrOrgCd1.Add(queryParams["orgcd71"]);
                arrOrgCd2.Add(queryParams["orgcd72"]);
                orgParamCount++;
            }

            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("strcsldate", queryParams["scsldate"]);
            sqlParam.Add("endcsldate", queryParams["ecsldate"]);

            switch (queryParams["reportcd"])
            {
                case "000309":
                    // 肺ドック
                    sqlParam.Add("freecd", FREE_TARGET_CSCD_HAI);
                    break;
                default:
                    // １ドック・企業
                    sqlParam.Add("freecd", FREE_TARGET_CSCD);
                    break;

            }

            sqlParam.Add("orggrpcd", queryParams["orggrpcd"]);
            sqlParam.Add("csldivcd", queryParams["csldivcd"]);
            sqlParam.Add("billprint", queryParams["billprint"]);

            string stmt = "";
            stmt += @"
                        select
                            receipt.rsvno
                ";

            stmt += @"
                        from
                            receipt
                            , consult
                            , free
                ";

            // 開始受診日
            stmt += @"
                        where
                            receipt.csldate >= :strcsldate
                ";
            stmt += @"
                            and receipt.rsvno = consult.rsvno
                ";

            // 終了受診日
            if (DateTime.TryParse(queryParams["ecsldate"], out DateTime eCslDate))
            {
                stmt += @"
                            and receipt.csldate <= :endcsldate
                ";
            }

            // 今回対象コース
            stmt += @"
                            and free.freecd like :freecd
                            and free.freefield1 = consult.cscd
                ";

            // 英語版選択時にのみ有効
            switch (queryParams["reportcd"])
            {
                case "000302":
                    // 成績書６連
                    stmt += @"
                            and consult.reportoureng = 1
                        ";
                    break;
                default:
                    break;

            }

            int i = 0;
            // 当日ＩＤ
            if (dayIdCount > 0)
            {
                stmt += @"
                            and (
                    ";
                while (!(i > (dayIdCount - 1)))
                {
                    if (i >= 1)
                    {
                        stmt += @"
                                    or
                            ";
                    }

                    // 当日ＩＤが範囲で設定されているかチェックする
                    strPos = arrDayId[i].IndexOf('-');
                    if (strPos == -1)
                    {
                        stmt += string.Format(@"
                                   receipt.dayid = {0}
                            ", arrDayId[i]);
                    }
                    else
                    {
                        // 範囲のデータの場合
                        stmt += string.Format(@"
                                    receipt.dayid between {0} and {1}
                            ", arrDayId[i].Substring(0, strPos), arrDayId[i].Substring(strPos + 1));
                    }
                    i++;
                }
                stmt += @"
                            )
                    ";
            }

            // 団体コード
            if (orgParamCount > 0 || !string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                stmt += @"
                            and (
                    ";
                // 団体グループコード
                if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                {
                    stmt += @"
                                (consult.orgcd1, consult.orgcd2) in ( 
                                    select
                                        orggrp_i.orgcd1
                                        , orggrp_i.orgcd2 
                                    from
                                        orggrp_i 
                                    where
                                        orggrp_i.orggrpcd = :orggrpcd
                        ";
                }

                // 団体コード
                if (orgParamCount > 0)
                {
                    i = 0;
                    while (!(i > (orgParamCount - 1)))
                    {
                        if (i >= 1 || !string.IsNullOrEmpty(queryParams["orggrpcd"]))
                        {
                            stmt += @"
                                        or
                                ";
                        }

                        stmt += string.Format(@"
                                    (consult.orgcd1 = {0} and consult.orgcd2 = {1}) 
                            ", arrOrgCd1[i], arrOrgCd2[i]);
                    }
                }
                stmt += @"
                            )
                    ";
            }

            if (!string.IsNullOrEmpty(queryParams["csldivcd"]))
            {
                stmt += @"
                            and consult.csldivcd = :csldivcd
                    ";
            }

            if (!string.IsNullOrEmpty(queryParams["billprint"]))
            {
                stmt += @"
                            and consult.billprint = :billprint
                    ";
            }

            if ("0".Equals(queryParams["sort"]))
            {
                stmt += @"
                            order by
                                receipt.csldate
                                , receipt.dayid
                    ";
            }
            else
            {
                stmt += @"
                            order by
                                consult.orgcd1
                                , consult.orgcd2
                                , receipt.csldate
                                , receipt.dayid
                    ";
            }

            // SQL実行
            return connection.Query(stmt, sqlParam).ToList();


        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ネームバンドデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            // 全受診情報共通の情報となる、検査項目コレクションの取得
            RepItems colItems = SelectItem_C_All();

            // 検査項目コレクションに検査項目履歴情報を追加
            SelectItem_H_All(ref colItems);

            // 検査項目コレクションに基準値情報を追加
            SelectStdValue(ref colItems);

            // フォーム解析
            AnalyzeForm(cnForms);

            // 解析結果より編集対象となる検査項目を収集
            GatherEditItem();

            foreach (dynamic rec in data)
            {
                PrintReport(cnForms, colItems, rec.RSVNO);
            }

        }

        /// <summary>
        /// フォームファイルの解析
        /// </summary>
        /// <param name="colCrForms">フォームコレクション</param>
        private void AnalyzeForm(CnForms cnForms)
        {
            // カラム種別
            int columnType;
            bool hasAdd = false;

            // 初期処理
            PrintCommon.gudtFormColumns.Clear();
            PrintCommon.glngGetHistoryCount = 0;

            // フォームファイル解析
            foreach (CnForm cnForm in cnForms)
            {
                PrintCommon.FORM_COLUMNS formColums = new PrintCommon.FORM_COLUMNS();
                foreach (CnObject cnObject in cnForm.CnObjects)
                {
                    while (true)
                    {
                        // 読み込み受診歴数用の項目に行き着いた場合
                        if ("GETHISTORY".Equals(cnObject.Name))
                        {
                            // 未取得であれば取得
                            if (PrintCommon.glngGetHistoryCount == 0)
                            {
                                if (PrintCommon.IsInteger(((CnText)cnObject).Text))
                                {
                                    PrintCommon.glngGetHistoryCount = Convert.ToInt32(((CnText)cnObject).Text);
                                }
                            }
                            break;
                        }

                        // データフィールド、リストフィールド、テキストフィールドのみを編集対象とする
                        if (!(cnObject.GetType() == typeof(CnDataField)
                            || cnObject.GetType() == typeof(Hos.CnDraw.Object.CnListField)
                            || cnObject.GetType() == typeof(Hos.CnDraw.Object.CnTextField)
                            || cnObject.GetType() == typeof(Hos.CnDraw.Object.CnBarcodeField)))
                        {
                            break;
                        }

                        // 解析を行う
                        columnType = PrintCommon.AnalyzeColumnName(cnObject.Name);
                        if (columnType <= 0)
                        {
                            break;
                        }

                        hasAdd = true;
                        // 編集対象となる項目のみを配列に編集
                        PrintCommon.COLUMN_REC columnRec = new PrintCommon.COLUMN_REC
                        {
                            ColumnName = cnObject.Name,
                            ColumnType = columnType
                        };
                        formColums.Columns.Add(columnRec);

                        break;
                    }
                }

                if (hasAdd)
                {
                    // 編集対象となる項目のみを配列に編集
                    PrintCommon.gudtFormColumns.Add(formColums);
                }

            }
        }

        /// <summary>
        /// 解析結果より編集対象となる検査項目を収集
        /// </summary>
        private void GatherEditItem()
        {
            IList<string> arrGetItemCd = new List<string>();     // オブジェクト名より取得した検査項目コード
            IList<string> arrGetSuffix = new List<string>(); ;   // オブジェクト名より取得したサフィックス
            int getCount;                   // オブジェクト名より取得した検査項目数

            bool blnDuplicated;             // 重複フラグ

            // 初期処理
            PrintCommon.gstrEditItemCd.Clear();
            PrintCommon.gstrEditSuffix.Clear();
            PrintCommon.glngEditCount = 0;

            // 解析結果を検索
            for (int index1 = 0; index1 < PrintCommon.gudtFormColumns.Count; index1++)
            {
                for (int index2 = 0; index2 < PrintCommon.gudtFormColumns[index1].Columns.Count; index2++)
                {
                    while (true)
                    {
                        // 項目タイプが検査結果の場合のみ収集処理を行う
                        if (PrintCommon.gudtFormColumns[index1].Columns[index2].ColumnType == PrintCommon.COLUMN_TYPE_RESULT)
                        {
                            break;
                        }

                        // オブジェクト名から検査項目コードを取得
                        getCount = GetItemCdFromObjectName(PrintCommon.gudtFormColumns[index1].Columns[index2].ColumnName, ref arrGetItemCd, ref arrGetSuffix);
                        if (getCount <= 0)
                        {
                            break;
                        }

                        // 編集対象となる検査項目の収集処理
                        for (int index3 = 0; index3 < getCount; index3++)
                        {
                            // すでに収集済みの検査項目と重複するかを検索
                            blnDuplicated = false;
                            for (int index4 = 0; index4 < PrintCommon.glngEditCount; index4++)
                            {
                                if (arrGetItemCd[index3] == PrintCommon.gstrEditItemCd[index4] || arrGetSuffix[index3] == PrintCommon.gstrEditSuffix[index4])
                                {
                                    blnDuplicated = true;
                                    break;
                                }
                            }

                            // 重複しなければ収集
                            if (!blnDuplicated)
                            {
                                PrintCommon.gstrEditItemCd.Add(arrGetItemCd[index3]);
                                PrintCommon.gstrEditSuffix.Add(arrGetSuffix[index3]);
                                PrintCommon.glngEditCount++;
                            }
                        }

                        break;
                    }
                }
            }

        }

        /// <summary>
        /// 描画オブジェクト名に含まれる検査項目コードの取得
        /// </summary>
        /// <param name="objectName">描画オブジェクト名</param>
        /// <param name="arrItemCd">検査項目コード</param>
        /// <param name="arrSuffix">サフィックス</param>
        /// <returns></returns>
        private int GetItemCdFromObjectName(string objectName, ref IList<string> arrItemCd, ref IList<string> arrSuffix)
        {
            IList<string> token;        // トークン
            IList<string> token2;       // トークン
            int tokenCount = 0;         // トークン数
            bool blnHistoryNo;          // 履歴番号の存在有無
            int count = 0;              // 検査項目数

            // 初期処理
            arrItemCd.Clear();
            arrSuffix.Clear();

            // _でばらす（最初が項目名）
            token = objectName.Split('_');

            // トークン数の取得
            tokenCount = token.Count;

            // 一番最後のトークンは履歴番号か？
            blnHistoryNo = PrintCommon.IsInteger(token[tokenCount - 1]);

            // 今回結果の出力項目のみを対象とするため、履歴番号であれば何もしない
            if (blnHistoryNo)
            {
                return count;
            }

            // トークンの２番目から最後までを検索
            foreach (string val in token)
            {
                // 検査項目コードであれば
                if (PrintCommon.IsItemCd(val))
                {
                    // トークンをハイフンで検査項目コードとサフィックスとに分割
                    token2 = val.Split('-');
                    arrItemCd.Add(token2[0]);
                    arrSuffix.Add(token2[1]);
                    count++;
                }
            }

            // 戻り値の設定
            return count;
        }


        /// <summary>
        /// 報告書出力処理
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="rsvNo">予約番号</param>
        private void PrintReport(CnForms cnForms, RepItems colItems, int rsvNo)
        {
            RepConsult objRepConsult;   // 受診情報クラス
            CnObject cnObject;          // 描画オブジェクト
            IList<string> resultOtherAll = new List<string>();  // その他検査結果(全件指定)のオブジェクト名情報
            IList<string> strItemCd = new List<string>();       // その他検査結果で出力対象となる検査項目コード
            IList<string> strSuffix = new List<string>();       // その他検査結果で出力対象となるサフィックス

            int formIndex;          // フォームオブジェクトのインデックス

            // 受診情報読み込み
            objRepConsult = SelectConsult(rsvNo);
            if (objRepConsult == null)
            {
                return;
            }

            // 受診履歴読み込み
            SelectConsultHistory(ref objRepConsult);

            // 検査結果読み込み
            SelectRsl(ref objRepConsult);

            // 判定結果読み込み
            SelectJudRsl(ref objRepConsult);

            // 個人検査結果読み込み
            SelectPerResult(ref objRepConsult);

            // 既往歴家族歴読み込み
            SelectDisHistory(ref objRepConsult);

            // フォームオブジェクトのインデックス初期化
            formIndex = 0;
            foreach (CnForm cnForm in cnForms)
            {
                // フィールドの初期化
                cnForm.ClearAllFields();

                // TODO フォームファイルのサイズ設定 ???
                // Ret = objCrPrinter.SetFormSize(objCrForm)

                // 描画オブジェクトコレクションの参照設定
                CnObjects cnObjects = cnForm.CnObjects;

                // 編集処理
                for (int i = 0; i < PrintCommon.gudtFormColumns[formIndex].Columns.Count; i++)
                {
                    cnObject = cnObjects[PrintCommon.gudtFormColumns[formIndex].Columns[i].ColumnName];

                    // 解析結果による処理分岐
                    switch (PrintCommon.gudtFormColumns[formIndex].Columns[i].ColumnType)
                    {
                        case PrintCommon.COLUMN_TYPE_HOSPITAL:          // 病院情報
                            EditHospital(cnObject);
                            break;
                        case PrintCommon.COLUMN_TYPE_ITEM:              // 検査項目情報
                            EditItem(cnObject, colItems, objRepConsult);
                            break;
                        case PrintCommon.COLUMN_TYPE_CONSULT:           // 受診情報
                            EditConsult(cnObject, objRepConsult);
                            break;
                        case PrintCommon.COLUMN_TYPE_CONSULTHISTORY:    // 受診履歴
                            EditConsultHistory(cnObject, objRepConsult.Histories);
                            break;
                        case PrintCommon.COLUMN_TYPE_RESULT:            // 検査結果
                            EditResult(cnObject, objRepConsult);
                            break;
                        case PrintCommon.COLUMN_TYPE_JUDGEMENT:         // 判定結果
                            EditJudgementControl(cnObject, objRepConsult);
                            break;
                        case PrintCommon.COLUMN_TYPE_PERRESULT:         // 個人検査結果
                            EditPerResult(cnObject, objRepConsult.PerResults);
                            break;
                        case PrintCommon.COLUMN_TYPE_DISHISTORY:        // 既往歴
                            EditDisHistory(cnObject, objRepConsult.DisHistories);
                            break;
                        case PrintCommon.COLUMN_TYPE_FMLHISTORY:        // 家族歴
                            EditFmlHistory(cnObject, objRepConsult.FmlHistories);
                            break;
                        case PrintCommon.COLUMN_TYPE_RESULTOTHER:       // その他検査結果
                            // TODO 編集対象項目が存在する場合のみ編集
                            break;
                        case PrintCommon.COLUMN_TYPE_RESULTOTHERALL:    // その他検査結果(全件指定)
                            // TODO
                            // その他検査結果はいったん全てのフィールドを検索した後で編集するため、ここではオブジェクト名を退避
                            // (但しリストフィールドであり、且つ編集可能な行数が存在する場合以外は退避しない)
                            break;
                        case PrintCommon.COLUMN_TYPE_PRIRESULT:         // 優先順位順検査結果
                            EditPriResult(cnObject, objRepConsult);
                            break;

                    }
                }

                // オブジェクトのインスタンス作成
                FlexReportEx flexReportEx = new FlexReportEx(this.connection);

                // 帳票出力処理
                flexReportEx.EditItem(colItems, objRepConsult, cnForm);

                // TODO 編集対象項目が存在し、かつ退避中のオブジェクト名が存在する場合はその他検査結果の編集を行う

                // 改ページ処理
                PrintOut(cnForm);

                // オブジェクトの解放
                flexReportEx = null;

            }
        }

        /// <summary>
        /// 病院情報の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        private void EditHospital(CnObject cnObject)
        {
            string sql = "";            //  SQLステートメント

            string hspName = "";        // 病院名
            string hspCenter = "";      // センター名
            string hspZipCd = "";       // 郵便番号
            string hspAddress1 = "";    // 住所１
            string hspAddress2 = "";    // 住所２
            string hspTel = "";         // 電話番号
            string hspFax = "";         // FAX番号
            string hspInLineNo = "";    // 内線

            // TODO 病院情報取得 ini→Free 


            // 項目名ごとの初期分岐
            switch (PrintCommon.ExceptReplicationSign(cnObject.Name))
            {
                case "HSPNAME":
                    ((CnDataField)cnObject).Text = hspName;
                    break;
                case "HSPCENTER":
                    ((CnDataField)cnObject).Text = hspCenter;
                    break;
                case "HSPZIPCD":
                    ((CnDataField)cnObject).Text = hspZipCd;
                    break;
                case "HSPADDRESS1":
                    ((CnDataField)cnObject).Text = hspAddress1;
                    break;
                case "HSPADDRESS2":
                    ((CnDataField)cnObject).Text = hspAddress2;
                    break;
                case "HSPTEL":
                    ((CnDataField)cnObject).Text = hspTel;
                    break;
                case "HSPFAX":
                    ((CnDataField)cnObject).Text = hspFax;
                    break;
                case "HSPINLINENO":
                    ((CnDataField)cnObject).Text = hspInLineNo;
                    break;
            }

        }

        /// <summary>
        /// 検査項目の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditItem(CnObject cnObject, RepItems colItems, RepConsult objRepConsult)
        {
            RepItem item;           // 検査項目クラス
            IList<string> token;    // トークン

            // アンダースコアで項目名を分割
            token = cnObject.Name.Split('_');

            // 検査項目コードでコレクションを検索
            item = colItems.Item(token[1]);
            if (item == null)
            {
                return;
            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "ITEMRNAME":   // 報告書用項目名
                    ((CnDataField)cnObject).Text = item.ItemRName;
                    break;
                case "ITEMENAME":   // 英語項目名
                    ((CnDataField)cnObject).Text = item.ItemEName;
                    break;
                case "ITEMQNAME":   // 問診文章
                    ((CnDataField)cnObject).Text = item.ItemQName;
                    break;
                case "UNIT":        // 検査項目履歴
                    EditItemHistory(cnObject, item, objRepConsult);
                    break;
                case "LOWERVALUE":  // 基準値
                case "UPPERVALUE":  // 基準値
                    EditStdValue(cnObject, item, objRepConsult);
                    break;

            }

        }

        /// <summary>
        /// 検査項目履歴の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colItem">検査項目クラス</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditItemHistory(CnObject cnObject, RepItem colItem, RepConsult objRepConsult)
        {
            RepItemHistories colHistories;  // 検査項目履歴コレクション
            RepItemHistory objHistory;      // 基準値クラス
            IList<string> token;            // トークン

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // 検査項目履歴コレクションの取得
            colHistories = colItem.Histories;
            if (colHistories == null || colHistories.Count == 0)
            {
                return;
            }

            // 検査項目履歴コレクションを受診日で検索
            objHistory = colHistories.Item(objRepConsult.CslDate);
            if (objHistory == null)
            {
                return;
            }

            // オブジェクト名の先頭部による処理分岐
            if ("UNIT".Equals(PrintCommon.ExceptReplicationSign(token[0])))
            {
                ((CnDataField)cnObject).Text = objHistory.Unit;
            }

        }

        /// <summary>
        /// 基準値の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colItem">検査項目クラス</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditStdValue(CnObject cnObject, RepItem colItem, RepConsult objRepConsult)
        {
            RepStdValues colStdValues;      // 基準値コレクション
            RepStdValue objStdValue;        // 基準値クラス
            IList<string> token;            // トークン

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // 基準値コレクションの取得
            colStdValues = colItem.StdValues;
            if (colStdValues == null || colStdValues.Count == 0)
            {
                return;
            }

            // 基準値コレクションの検索
            for (int i = 0; i < colStdValues.Count; i++)
            {
                objStdValue = colStdValues.Item(i);

                while (true)
                {
                    // 受診日が使用日付範囲に含まれない場合は非対象
                    if (!(objStdValue.StrDate <= objRepConsult.CslDate && objStdValue.EndDate >= objRepConsult.CslDate))
                    {
                        break;
                    }

                    // コースが一致しない場合は非対象
                    if (!string.IsNullOrEmpty(objStdValue.CsCd))
                    {
                        if (!objStdValue.CsCd.Equals(objRepConsult.CsCd))
                        {
                            break;
                        }
                    }

                    // 性別が一致しない場合は非対象
                    if (objRepConsult.Gender != objStdValue.Gender)
                    {
                        break;
                    }

                    // 受診時年齢が年齢範囲に含まれない場合は非対象
                    string wkAge = string.Format("{0:000.00}", objRepConsult.Age);
                    if (!(wkAge.CompareTo(objStdValue.StrAge) >= 0 && wkAge.CompareTo(objStdValue.EndAge) <= 0))
                    {
                        break;
                    }

                    // オブジェクト名の先頭部による処理分岐
                    switch (PrintCommon.ExceptReplicationSign(token[0]))
                    {
                        case "LOWERVALUE":   // 基準値(以上)
                            ((CnDataField)cnObject).Text = objStdValue.LowerValue;
                            break;
                        case "UPPERVALUE":   // 基準値(以下)
                            ((CnDataField)cnObject).Text = objStdValue.UpperValue;
                            break;
                    }

                    break;
                }
            }
        }

        /// <summary>
        /// 受診情報の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditConsult(CnObject cnObject, RepConsult objRepConsult)
        {
            // 項目名ごとの初期分岐
            switch (PrintCommon.ExceptReplicationSign(cnObject.Name))
            {
                case "RSVNO":
                    ((CnDataField)cnObject).Text = objRepConsult.RsvNo.ToString();
                    break;
                case "BCDRSVNO":
                    ((CnDataField)cnObject).Text = "A" + objRepConsult.RsvNo.ToString() + "A";
                    break;
                case "CSLDATE":
                case "CSLDATEM":
                    ((CnDataField)cnObject).Text = string.Format("{0:yyyy/M/d}", objRepConsult.CslDate);
                    break;
                case "CSLYEARAD":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.CslYearAd) ?? "";
                    break;
                case "CSLYEARJP":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.CslYearJp) ?? "";
                    break;
                case "CSLYEARGE":
                    ((CnDataField)cnObject).Text = objRepConsult.CslYearGe ?? "";
                    break;
                case "CSLMONTH":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.CslMonth) ?? "";
                    break;
                case "CSLDAY":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.CslDay) ?? "";
                    break;
                case "CNTLNO":
                    ((CnDataField)cnObject).Text = objRepConsult.CntlNo ?? "";
                    break;
                case "DAYID":
                case "DAYIDM":
                    ((CnDataField)cnObject).Text = objRepConsult.DayId ?? "";
                    break;
                case "PERID":
                    ((CnDataField)cnObject).Text = objRepConsult.PerId ?? "";
                    break;
                case "LASTNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.LastName ?? "";
                    break;
                case "FIRSTNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.FirstName ?? "";
                    break;
                case "LASTKNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.LastKName ?? "";
                    break;
                case "FIRSTKNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.FirstKName ?? "";
                    break;
                case "NAME":
                    ((CnDataField)cnObject).Text = objRepConsult.Name ?? "";
                    break;
                case "KNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.KName ?? "";
                    break;
                case "BIRTH":
                    ((CnDataField)cnObject).Text = string.Format("{0:yyyy/M/d}", objRepConsult.Birth);
                    break;
                case "BIRTHYEARAD":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.BirthYearAd) ?? "";
                    break;
                case "BIRTHYEARJP":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.BirthYearJp) ?? "";
                    break;
                case "BIRTHYEARGE":
                    ((CnDataField)cnObject).Text = objRepConsult.BirthYearGe ?? "";
                    break;
                case "BIRTHMONTH":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.BirthMonth) ?? "";
                    break;
                case "BIRTHDAY":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.BirthDay) ?? "";
                    break;
                case "GENDER":
                    ((CnDataField)cnObject).Text = objRepConsult.Gender == 1 ? "男性" : "女性";
                    break;
                case "PREFNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.PrefName ?? "";
                    break;
                case "ZIPCD1":
                    ((CnDataField)cnObject).Text = objRepConsult.ZipCd1 == "" ? "" : objRepConsult.ZipCd1.Substring(0, 3);
                    break;
                case "ZIPCD2":
                    ((CnDataField)cnObject).Text = objRepConsult.ZipCd2 == "" ? "" : objRepConsult.ZipCd2.Substring(objRepConsult.ZipCd2.Length - 4, 4);
                    break;
                case "CITYNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.CityName ?? "";
                    break;
                case "ADDRESS1":
                    ((CnDataField)cnObject).Text = objRepConsult.Address1 ?? "";
                    break;
                case "ADDRESS2":
                    ((CnDataField)cnObject).Text = objRepConsult.Address2 ?? "";
                    break;
                case "ISRNO":
                    ((CnDataField)cnObject).Text = objRepConsult.IsrNo ?? "";
                    break;
                case "ISRSIGN":
                    ((CnDataField)cnObject).Text = objRepConsult.IsrSign ?? "";
                    break;
                case "RESIDENTNO":
                    ((CnDataField)cnObject).Text = objRepConsult.ResidentNo ?? "";
                    break;
                case "UNIONNO":
                    ((CnDataField)cnObject).Text = objRepConsult.UnionNo ?? "";
                    break;
                case "KARTE":
                    ((CnDataField)cnObject).Text = objRepConsult.Karte ?? "";
                    break;
                case "EMPNO":
                    ((CnDataField)cnObject).Text = objRepConsult.EmpNo ?? "";
                    break;
                case "CSCD":
                    ((CnDataField)cnObject).Text = objRepConsult.CsCd ?? "";
                    break;
                case "CSNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.CsName ?? "";
                    break;
                case "ORGCD1":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgCd1 ?? "";
                    break;
                case "ORGCD2":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgCd2 ?? "";
                    break;
                case "ORGKNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgKName ?? "";
                    break;
                case "ORGNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgName ?? "";
                    break;
                case "ORGSNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgSName ?? "";
                    break;
                case "RSVDATE":
                    ((CnDataField)cnObject).Text = string.Format("{0:yyyy/M/d}", objRepConsult.RsvDate);
                    break;
                case "AGE":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.Age) ?? "";
                    break;
                case "AGEMONTH":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.AgeMonth) ?? "";
                    break;
                case "DOCTORNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.DoctorName ?? "";
                    break;
                case "REPORTPRINTDATE":
                    ((CnDataField)cnObject).Text = objRepConsult.ReportPrintDate == null ? "" : string.Format("{0:yyyy/M/d}", objRepConsult.ReportPrintDate);
                    break;
                case "FIRSTRSVNO":
                    ((CnDataField)cnObject).Text = objRepConsult.FirstRsvNo > 0 ? Convert.ToString(objRepConsult.FirstRsvNo) : "";
                    break;
                case "CSLCOUNT":
                    ((CnDataField)cnObject).Text = Convert.ToString(objRepConsult.CslCount) ?? "";
                    break;
                case "ORGBSDNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgBsdName ?? "";
                    break;
                case "ORGBSDKNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgBsdKName ?? "";
                    break;
                case "ORGROOMNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgRoomName ?? "";
                    break;
                case "ORGROOMKNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgRoomKName ?? "";
                    break;
                case "ORGPOSTNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgPostName ?? "";
                    break;
                case "ORGPOSTKNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.OrgPostKName ?? "";
                    break;
                case "JOBNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.JobName ?? "";
                    break;
                case "DUTYNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.DutyName ?? "";
                    break;
                case "QUALIFYNAME":
                    ((CnDataField)cnObject).Text = objRepConsult.QualifyName ?? "";
                    break;

            }
        }

        /// <summary>
        /// 受診履歴の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colHistories">受診履歴コレクション</param>
        private void EditConsultHistory(CnObject cnObject, RepHistories colHistories)
        {
            RepHistory objHistory;  // 受診履歴クラス
            IList<string> token;    // トークン

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // 受診履歴クラスの取得
            objHistory = GetConsultHistory(colHistories, Convert.ToInt32(token[1]));
            if (objHistory == null)
            {
                return;
            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "CSLDATE":   // 受診年月日
                case "CSLDATEM":  // 受診年月日
                    ((CnDataField)cnObject).Text = string.Format("{0:yyyy/M/d}", objHistory.CslDate);
                    break;
                case "CSLYEARAD":
                    ((CnDataField)cnObject).Text = Convert.ToString(objHistory.CslYearAd);
                    break;
                case "CSLYEARJP":
                    ((CnDataField)cnObject).Text = Convert.ToString(objHistory.CslYearJp);
                    break;
                case "CSLYEARGE":
                    ((CnDataField)cnObject).Text = objHistory.CslYearGe;
                    break;
                case "CSLMONTH":
                    ((CnDataField)cnObject).Text = Convert.ToString(objHistory.CslMonth);
                    break;
                case "CSLDAY":
                    ((CnDataField)cnObject).Text = Convert.ToString(objHistory.CslDay);
                    break;
                case "CNTLNO":
                    ((CnDataField)cnObject).Text = Convert.ToString(objHistory.CntlNo);
                    break;
                case "DAYID":
                case "DAYIDM":
                    ((CnDataField)cnObject).Text = Convert.ToString(objHistory.DayId);
                    break;
                case "CSCD":
                    ((CnDataField)cnObject).Text = objHistory.CsCd;
                    break;
                case "CSNAME":
                    ((CnDataField)cnObject).Text = objHistory.CsName ?? "";
                    break;
            }

        }

        /// <summary>
        /// 検査結果の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditResult(CnObject cnObject, RepConsult objRepConsult)
        {
            IList<string> token;    // トークン
            int tokenCount;         // トークン数

            bool blnHistoryNo;      // 履歴番号の存在有無
            int historyNo;          // 履歴番号

            int itemCount;          // 項目名において指定中の検査項目数

            RepHistory objHistory = null;   // 受診履歴クラス
            RepResults colResults = null;   // 検査結果コレクション
            RepResult objResult = null;     // 検査結果クラス

            IList<string> strShortStc = new List<string>();      // 略文章
            IList<string> strLongStc = new List<string>();       // 文章
            IList<string> strEngStc = new List<string>();         // 英語文章
            IList<string> strResult = new List<string>();        // 検査結果
            IList<string> strRslCmtCd1 = new List<string>();     // 結果コメント1
            IList<string> strRslCmtName1 = new List<string>();   // 結果コメント名1
            IList<string> strRslCmtCd2 = new List<string>();     // 結果コメント2
            IList<string> strRslCmtName2 = new List<string>();   // 結果コメント名2
            IList<string> strStdFlg = new List<string>();        // 基準値フラグ
            IList<string> strAbnormalMark = new List<string>();  // 異常値マーク

            int index;          // 配列インデックス
            bool blnResult;     // 結果フラグ


            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // トークン数の取得
            tokenCount = token.Count;

            // 一番最後のトークンは履歴番号か？
            blnHistoryNo = PrintCommon.IsInteger(token[tokenCount - 1]);

            // トークン数から項目名を除外し、更に存在時は履歴番号を除外した残りの数が指定検査項目数となる
            itemCount = tokenCount - 1 - (blnHistoryNo ? 1 : 0);

            while (true)
            {
                // 一番最後のトークンが履歴番号でない場合は今回結果を参照する
                if (!blnHistoryNo)
                {
                    colResults = objRepConsult.Results;
                    break;
                }

                // 以下は一番最後のトークンが履歴番号である場合

                // 受診履歴クラスの取得
                historyNo = Convert.ToInt32(token[tokenCount - 1]);
                objHistory = GetConsultHistory(objRepConsult.Histories, historyNo);
                if (objHistory == null)
                {
                    break;
                }

                // 検査結果コレクションの参照設定
                colResults = objHistory.Results;

                break;
            }

            // 検査結果が存在しない場合は何もしない
            if (colResults == null)
            {
                return;
            }

            // 検査結果が存在しない場合は何もしない
            if (colResults.Count == 0)
            {
                return;
            }

            blnResult = false;

            // 検査項目数分のコレクション検索を行い、配列に追加
            for (int i = 1; i <= itemCount; i++)
            {
                // 検査項目コードでコレクションを検索
                objResult = colResults.Item(token[i]);

                if (objResult != null)
                {
                    // 配列に追加
                    strResult.Add(objResult.Result);
                    strStdFlg.Add(objResult.StdFlg);
                    strShortStc.Add(objResult.ShortStc);
                    strLongStc.Add(objResult.LongStc);
                    strEngStc.Add(objResult.EngStc);
                    strRslCmtCd1.Add(objResult.RslCmtCd1);
                    strRslCmtName1.Add(objResult.RslCmtName1);
                    strRslCmtCd2.Add(objResult.RslCmtCd2);
                    strRslCmtName2.Add(objResult.RslCmtName2);

                    switch (objResult.StdFlg)
                    {
                        case "":
                        case "S":
                        case "X":
                            break;
                        default:
                            strAbnormalMark.Add(ABNORMAL_MARK_STRING);
                            break;
                    }

                    blnResult = true;
                }
            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "RESULT":          // 検査結果
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strResult) : "********";
                    break;
                case "STDVALUECD":      // 基準値コード
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strStdFlg) : "********";
                    break;
                case "SHORTSTC":        // 略文章
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strShortStc) : "＊＊＊＊＊";
                    break;
                case "LONGSTC":         // 文章
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strLongStc) : "＊＊＊＊＊";
                    break;
                case "ENGSTC":          // 英語文章
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strEngStc) : "＊＊＊＊＊";
                    break;
                case "RSLCMTCD1":       // 結果コメント1
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strRslCmtCd1) : "**";
                    break;
                case "RSLCMTNAME1":     // 結果コメント名1
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strRslCmtName1) : "＊＊";
                    break;
                case "RSLCMTCD2":       // 結果コメント2
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strRslCmtCd2) : "**";
                    break;
                case "RSLCMTNAME2":     // 結果コメント名2
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strRslCmtName1) : "＊＊";
                    break;
                case "MULTIRESULT":     // 複数検査結果
                    if (blnResult)
                    {
                        if (itemCount >= 2)
                        {
                            if (int.TryParse(strResult[0], out int wkindex))
                            {
                                index = Convert.ToInt32(strResult[0]);
                                if (index >= 1 && index <= (itemCount - 1))
                                {
                                    ((CnDataField)cnObject).Text = strResult[index];
                                }
                            }
                        }
                    }
                    else
                    {
                        ((CnDataField)cnObject).Text = "********";
                    }
                    break;
                case "ABNORMALMARK":    // 異常値マーク
                    ((CnDataField)cnObject).Text = blnResult ? string.Join(" ", strAbnormalMark) : "";
                    break;
            }

        }

        /// <summary>
        /// 判定結果の編集処理制御
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditJudgementControl(CnObject cnObject, RepConsult objRepConsult)
        {
            IList<string> token;    // トークン

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // トークン数による処理分岐
            switch (token.Count)
            {
                case 2:
                    // 今回判定結果の編集
                    EditJudgement(cnObject, objRepConsult, token[1]);
                    break;
                case 3:
                    // オブジェクト名の先頭部による処理分岐
                    switch (PrintCommon.ExceptReplicationSign(token[0]))
                    {
                        // 定型所見の場合は今回判定結果の定型所見編集
                        case "STDJUDCD":
                        case "STDJUDNOTE":
                            EditJudgement(cnObject, objRepConsult, token[1], null, token[2]);
                            break;
                        // 定型所見以外の場合は指定受診履歴判定結果の編集
                        default:
                            EditJudgement(cnObject, objRepConsult, token[1], token[2]);
                            break;
                    }
                    break;
                case 4:
                    // 指定受診履歴判定結果の定型所見編集
                    EditJudgement(cnObject, objRepConsult, token[1], token[2], token[3]);
                    break;

            }

        }

        /// <summary>
        /// 指定判定分類の判定結果編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="strJudClassCd">判定分類コード</param>
        /// <param name="historyNo">履歴番号</param>
        /// <param name="seq">SEQ</param>
        private void EditJudgement(CnObject cnObject, RepConsult objRepConsult, string strJudClassCd, string historyNo = null, string seq = null)
        {
            RepHistory objHistory = null;              // 受診履歴クラス
            RepJudgements colJudgements = null;        // 判定結果コレクション
            RepJudgement objJudgement = null;          // 判定結果クラス
            RepStdJudgements colStdJudgements = null;  // 定型所見コレクション
            RepStdJudgement objStdJudgement = null;    // 定型所見クラス

            IList<string> token;    // トークン

            string strJudClassName = "";     // 判定分類名称
            string strJudCd = "";            // 判定コード
            string strJudRName = "";         // 報告書用判定名
            string strGovMngJud = "";        // 政府管掌用コード
            string strGovMngJudName = "";    // 政府管掌用名称
            string strDoctorName = "";       // 判定医師名
            string strFreeJudCmt = "";       // フリー判定コメント
            string strStdJudCd = "";         // 定型所見コード
            string strStdJudNote = "";       // 定型所見内容
            string strGuidanceStc = "";      // 指導内容文章

            IList<string> strArrJudClassName = new List<string>();  // 判定分類名称の配列
            IList<string> strArrJudCd = new List<string>();         // 判定コードの配列
            IList<string> strArrJudRName = new List<string>();      // 報告書用判定名の配列
            IList<string> strArrGovMngJud = new List<string>();     // 政府管掌用コードの配列
            IList<string> strArrGovMngJudName = new List<string>(); // 政府管掌用名称の配列
            IList<string> strArrDoctorName = new List<string>();    // 判定医師名の配列
            IList<string> strArrFreeJudCmt = new List<string>();    // フリー判定コメントの配列
            IList<string> strArrStdJudCd = new List<string>();      // 定型所見コードの配列
            IList<string> strArrStdJudNote = new List<string>();    // 定型所見内容の配列
            IList<string> strArrGuidanceStc = new List<string>();   // 指導内容文章の配列

            bool blnJud;    // 判定存在フラグ

            while (true)
            {
                // 履歴番号が指定されていない場合は今回判定結果を参照する
                if (historyNo == null)
                {
                    colJudgements = objRepConsult.Judgements;
                    break;
                }

                // 以下は履歴番号が指定されている場合

                // 受診履歴クラスの取得
                objHistory = GetConsultHistory(objRepConsult.Histories, Convert.ToInt32(historyNo));
                if (objHistory == null)
                {
                    break;
                }

                // 判定結果コレクションの参照設定
                colJudgements = objHistory.Judgements;

                break;
            }

            // 判定結果が存在しない場合は何もしない
            if (colJudgements == null)
            {
                return;
            }

            // 判定結果が存在しない場合は何もしない
            if (colJudgements.Count == 0)
            {
                return;
            }

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            blnJud = true;

            // 全件指定の場合
            if ("ALL".Equals(strJudClassCd.ToUpper()))
            {
                // 判定結果コレクションの内容を配列に変換
                for (int i = 0; i < colJudgements.Count; i++)
                {
                    objJudgement = colJudgements.Item(i);

                    // 定型所見以外の項目の編集
                    strArrJudClassName.Add(objJudgement.JudClassName);
                    strArrJudCd.Add(objJudgement.JudCd);
                    strArrJudRName.Add(objJudgement.JudRName);
                    strArrGovMngJud.Add(objJudgement.GovMngJud);
                    strArrGovMngJudName.Add(objJudgement.GovMngJudName);
                    strArrDoctorName.Add(objJudgement.DoctorName);
                    strArrFreeJudCmt.Add(objJudgement.FreeJudCmt);
                    strArrGuidanceStc.Add(objJudgement.GuidanceStc);
                }

                // 定見所見の編集
                for (int idx = 0; idx < objJudgement.StdJudgements.Count; idx++)
                {
                    objStdJudgement = objJudgement.StdJudgements.Item(idx);
                    strArrStdJudCd.Add(Convert.ToString(objStdJudgement.StdJudCd));
                    strArrStdJudNote.Add(objStdJudgement.StdJudNote);
                }

                // 改行コードをセパレータとして結合
                strJudClassName = string.Join("\\r\\n", strArrJudClassName);
                strJudCd = string.Join("\\r\\n", strArrJudCd);
                strJudRName = string.Join("\\r\\n", strArrJudRName);
                strGovMngJud = string.Join("\\r\\n", strArrGovMngJud);
                strGovMngJudName = string.Join("\\r\\n", strArrGovMngJudName);
                strDoctorName = string.Join("\\r\\n", strArrDoctorName);
                strFreeJudCmt = string.Join("\\r\\n", strArrFreeJudCmt);
                strStdJudCd = string.Join("\\r\\n", strArrStdJudCd);
                strStdJudNote = string.Join("\\r\\n", strArrStdJudNote);
                strGuidanceStc = string.Join("\\r\\n", strArrGuidanceStc);
            }
            else
            {
                // 判定分類直接指定の場合

                // 指定判定分類判定結果の参照設定
                objJudgement = colJudgements.Item(strJudClassCd);
                if (objJudgement == null)
                {
                    blnJud = false;
                }
                else
                {
                    // オブジェクト名の先頭部による処理分岐
                    switch (PrintCommon.ExceptReplicationSign(token[0]))
                    {
                        // 定型所見の場合
                        case "STDJUDCD":
                        case "STDJUDNOTE":
                            // 定型所見コレクションの参照設定
                            colStdJudgements = objJudgement.StdJudgements;
                            if (colStdJudgements == null)
                            {
                                return;
                            }

                            // 定型所見クラスの参照設定
                            objStdJudgement = colStdJudgements.Item(Convert.ToInt32(seq));
                            if (objStdJudgement == null)
                            {
                                return;
                            }

                            // クラスの値をそのまま編集
                            strStdJudCd = Convert.ToString(objStdJudgement.StdJudCd);
                            strStdJudNote = objStdJudgement.StdJudNote;

                            break;

                        // 定型所見以外の場合
                        default:
                            strJudClassName = objJudgement.JudClassName;
                            strJudCd = objJudgement.JudCd;
                            strJudRName = objJudgement.JudRName;
                            strGovMngJud = objJudgement.GovMngJud;
                            strGovMngJudName = objJudgement.GovMngJudName;
                            strDoctorName = objJudgement.DoctorName;
                            strFreeJudCmt = objJudgement.FreeJudCmt;
                            strGuidanceStc = objJudgement.GuidanceStc;

                            break;
                    }
                }

            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "JUDCLASSNAME":    // 判定分類名称
                    ((CnDataField)cnObject).Text = blnJud ? strJudClassName : "＊＊＊＊＊";
                    break;
                case "JUDCD":           // 判定コード
                    ((CnDataField)cnObject).Text = blnJud ? strJudCd : "**";
                    break;
                case "JUDRNAME":        // 報告書用判定名
                    if (blnJud)
                    {
                        ((CnDataField)cnObject).Text = strJudRName;
                    }
                    else
                    {
                        ((CnDataField)cnObject).Text = "＊＊＊＊＊";
                        if (!"0".Equals(token[token.Count - 1]) && token.Count > 2) {
                            ((CnDataField)cnObject).Text = "";
                        }
                    }
                    break;
                case "GOVMNGJUD":       // 政府管掌用コード
                    ((CnDataField)cnObject).Text = blnJud ? strGovMngJud : "＊＊＊＊＊";
                    break;
                case "GOVMNGJUDNAME":   // 政府管掌用名称
                    ((CnDataField)cnObject).Text = blnJud ? strGovMngJudName : "＊＊＊＊＊";
                    break;
                case "DOCTORNAME":      // 判定医師名
                    ((CnDataField)cnObject).Text = blnJud ? strDoctorName : "＊＊＊＊＊";
                    break;
                case "FREEJUDCMT":      // フリー判定コメント
                    ((CnDataField)cnObject).Text = blnJud ? strFreeJudCmt : "＊＊＊＊＊";
                    break;
                case "STDJUDCD":        // 定型所見コード
                    ((CnDataField)cnObject).Text = blnJud ? strStdJudCd : "**";
                    break;
                case "STDJUDNOTE":      // 定型所見内容
                    ((CnDataField)cnObject).Text = blnJud ? strStdJudNote : "＊＊＊＊＊";
                    break;
                case "GUIDANCESTC":     // 指導内容文章
                    ((CnDataField)cnObject).Text = blnJud ? strGuidanceStc : "＊＊＊＊＊";
                    break;

            }

        }

        /// <summary>
        /// 個人検査結果の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colPerResults">個人検査結果コレクション</param>
        private void EditPerResult(CnObject cnObject, RepPerResults colPerResults)
        {
            RepPerResult objPerResult;      // 個人検査結果クラス

            IList<string> token;    // トークン
            IList<string> token2;   // トークン2
            string strItemCd;       // 検査項目コード
            string strSuffix;       // サフィックス

            IList<string> strItemRName = new List<string>();    // 報告書用項目名
            IList<string> strItemEName = new List<string>();    // 英語項目名
            IList<string> strResult = new List<string>();       // 検査結果
            IList<string> strShortStc = new List<string>();     // 略文章
            IList<string> strLongStc = new List<string>();      // 文章
            IList<string> strEngStc = new List<string>();       // 英語文章
            IList<string> strIspDate = new List<string>();      // 検査日
            IList<string> strIspYearAd = new List<string>();    // 検査年（西暦）
            IList<string> strIspYearJp = new List<string>();    // 検査年（和暦）
            IList<string> strIspYearGe = new List<string>();    // 検査年（元号）
            IList<string> strIspMonth = new List<string>();     // 検査月
            IList<string> strIspDay = new List<string>();       // 検査日

            bool blnEdit;   // 編集要否

            // 個人検査結果が存在しない場合は何もしない
            if (colPerResults == null || colPerResults.Count == 0)
            {
                return;
            }

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // 個人検査結果コレクションの内容を配列に変換
            for (int i = 0; i < colPerResults.Count; i++)
            {
                // 個人検査結果クラスの参照設定
                objPerResult = colPerResults.Item(i);

                // 編集要否の判定
                while (true)
                {
                    //全件指定の場合は無条件に編集対象
                    if ("ALL".Equals(token[1]))
                    {
                        blnEdit = true;
                        break;
                    }

                    // 検査項目指定の場合
                    if (PrintCommon.IsItemCd(token[1]))
                    {
                        // トークンをハイフンで更に分割し、検査項目コードとサフィックスを取得
                        token2 = token[1].Split('-');
                        strItemCd = token2[0];
                        strSuffix = token2[1];

                        // 現コレクション要素のそれと一致する場合は編集対象
                        blnEdit = (strItemCd == objPerResult.ItemCd && strSuffix == objPerResult.Suffix);

                        break;
                    }

                    // SEQ指定の場合、SEQ値が現要素のインデックスと一致すれば編集対象
                    blnEdit = (i.ToString().Equals(token[1]));

                    break;
                }

                // 編集対象であれば配列に追加
                if (blnEdit)
                {
                    // 個人検査結果コレクションの内容を配列に変換
                    strItemRName.Add(objPerResult.ItemRName);
                    strItemEName.Add(objPerResult.ItemEName);
                    strResult.Add(objPerResult.Result);
                    strShortStc.Add(objPerResult.ShortStc);
                    strLongStc.Add(objPerResult.LongStc);
                    strEngStc.Add(objPerResult.EngStc);
                    strIspDate.Add(objPerResult.IspDate != null ? string.Format("{0:yyyy/M/d}", objPerResult.IspDate) : "");
                    strIspYearAd.Add(objPerResult.IspYearAd > 0 ? objPerResult.IspYearAd.ToString() : "");
                    strIspYearJp.Add(objPerResult.IspYearJp > 0 ? objPerResult.IspYearJp.ToString() : "");
                    strIspYearGe.Add(objPerResult.IspYearGe);
                    strIspMonth.Add(objPerResult.IspMonth > 0 ? objPerResult.IspMonth.ToString() : "");
                    strIspDay.Add(objPerResult.IspDay > 0 ? objPerResult.IspDay.ToString() : "");
                }
            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "PERITEMRNAME":    // 報告書用項目名
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strItemRName);
                        break;
                case "PERITEMENAME":    // 英語項目名
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strItemEName);
                    break;
                case "PERRESULT":       // 検査結果
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strResult);
                    break;
                case "PERSHORTSTC":     // 略文章
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strShortStc);
                    break;
                case "PERLONGSTC":      // 文章
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strLongStc);
                    break;
                case "PERENGSTC":       // 英語文章
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEngStc);
                    break;
                case "PERISPDATE":      // 検査日
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strIspDate);
                    break;
                case "PERISPYEARAD":    // 検査年（西暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strIspYearAd);
                    break;
                case "PERISPYEARJP":    // 検査年（和暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strIspYearJp);
                    break;
                case "PERISPYEARGE":    // 検査年（元号）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strIspYearGe);
                    break;
                case "PERISPMONTH":     // 検査月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strIspMonth);
                    break;
                case "PERISPDAY":       // 検査日
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strIspDay);
                    break;
            }
        }

        /// <summary>
        /// 既往歴の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colDisHistories">既往歴家族歴コレクション</param>
        private void EditDisHistory(CnObject cnObject, RepDisHistories colDisHistories)
        {
            RepDisHistory objDisHistory = null;     // 既往歴家族歴クラス

            IList<string> token;    // トークン

            IList<string> strDisCd = new List<string>();        // 病名コード
            IList<string> strDisName = new List<string>();      // 病名
            IList<string> strStrDate = new List<string>();      // 発病年月
            IList<string> strStrYearAd = new List<string>();    // 発病年（西暦）
            IList<string> strStrYearJp = new List<string>();    // 発病年（和暦）
            IList<string> strStrYearGe = new List<string>();    // 発病年（元号）
            IList<string> strStrMonth = new List<string>();     // 発病月
            IList<string> strEndDate = new List<string>();      // 治癒年月
            IList<string> strEndYearAd = new List<string>();    // 治癒年（西暦）
            IList<string> strEndYearJp = new List<string>();    // 治癒年（和暦）
            IList<string> strEndYearGe = new List<string>();    // 治癒年（元号）
            IList<string> strEndMonth = new List<string>();     // 治癒月
            IList<string> strCondition = new List<string>();    // 状態
            IList<string> strMedical = new List<string>();      // 医療機関

            bool blnEdit;   // 編集要否

            // 既往歴が存在しない場合は何もしない
            if (colDisHistories == null )
            {
                return;
            }

            // 既往歴が存在しない場合は何もしない
            if (colDisHistories.Count == 0)
            {
                return;
            }

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // 既往歴家族歴コレクションの内容を配列に変換 TODO i=1 ???
            for (int i = 0; i <= colDisHistories.Count; i++)
            {
                // 既往歴家族歴クラスの参照設定
                objDisHistory = colDisHistories.Item(i);

                // 編集要否の判定
                while (true)
                {
                    //全件指定の場合は無条件に編集対象
                    if ("ALL".Equals(token[1]))
                    {
                        blnEdit = true;
                        break;
                    }

                    // SEQ指定の場合、SEQ値が現要素のインデックスと一致すれば編集対象
                    blnEdit = (i.ToString().Equals(token[1]));

                    break;
                }

                // 編集対象であれば配列に追加
                if (blnEdit)
                {
                    // 既往歴家族歴コレクションの内容を配列に変換
                    strDisCd.Add(objDisHistory.DisCd);
                    strDisName.Add(objDisHistory.DisName);
                    strStrDate.Add(objDisHistory.StrDate != null ? string.Format("{0:yyyy/M}", objDisHistory.StrDate) : "");
                    strStrYearAd.Add(objDisHistory.StrYearAd > 0 ? objDisHistory.StrYearAd.ToString() : "");
                    strStrYearJp.Add(objDisHistory.StrYearJp > 0 ? objDisHistory.StrYearJp.ToString() : "");
                    strStrYearGe.Add(objDisHistory.StrYearGe);
                    strStrMonth.Add(objDisHistory.StrMonth > 0 ? objDisHistory.StrMonth.ToString() : "");
                    strEndDate.Add(objDisHistory.EndDate != null ? string.Format("{0:yyyy/M}", objDisHistory.EndDate) : "");
                    strEndYearAd.Add(objDisHistory.EndYearAd > 0 ? objDisHistory.EndYearAd.ToString() : "");
                    strEndYearJp.Add(objDisHistory.EndYearJp > 0 ? objDisHistory.EndYearJp.ToString() : "");
                    strEndYearGe.Add(objDisHistory.EndYearGe);
                    strEndMonth.Add(objDisHistory.EndMonth > 0 ? objDisHistory.EndMonth.ToString() : "");
                    strCondition.Add(SelectConditionName(objDisHistory.Condition ?? ""));
                    strMedical.Add(objDisHistory.Medical);
                }
            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "MYDISCD":      // 病名コード
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n",strDisCd);
                    break;
                case "MYDISNAME":    // 病名
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strDisName);
                    break;
                case "MYSTRDATE":    // 発病年月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrDate);
                    break;
                case "MYSTRYEARAD":  // 発病年（西暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n",strStrYearAd);
                    break;
                case "MYSTRYEARJP":  // 発病年（和暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrYearJp);
                    break;
                case "MYSTRYEARGE":  // 発病年（元号）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrYearGe);
                    break;
                case "MYSTRMONTH":   // 発病月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrMonth);
                    break;
                case "MYENDDATE":    // 治癒年月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndDate);
                    break;
                case "MYENDYEARAD":  // 治癒年（西暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndYearAd);
                    break;
                case "MYENDYEARJP":  // 治癒年（和暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndYearJp);
                    break;
                case "MYENDYEARGE":  // 治癒年（元号）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndYearGe);
                    break;
                case "MYENDMONTH":   // 治癒月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndMonth);
                    break;
                case "MYCONDITION":  // 状態
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strCondition);
                    break;
                case "MYMEDICAL":    // 医療機関
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strMedical);
                    break;
            }

        }

        /// <summary>
        /// 家族歴の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="colDisHistories">既往歴家族歴コレクション</param>
        private void EditFmlHistory(CnObject cnObject, RepDisHistories colDisHistories)
        {
            RepDisHistory objDisHistory = null;     // 家族歴クラス

            IList<string> token;    // トークン

            IList<string> strRelation = new List<string>();     // 続柄
            IList<string> strDisCd = new List<string>();        // 病名コード
            IList<string> strDisName = new List<string>();      // 病名
            IList<string> strStrDate = new List<string>();      // 発病年月
            IList<string> strStrYearAd = new List<string>();    // 発病年（西暦）
            IList<string> strStrYearJp = new List<string>();    // 発病年（和暦）
            IList<string> strStrYearGe = new List<string>();    // 発病年（元号）
            IList<string> strStrMonth = new List<string>();     // 発病月
            IList<string> strEndDate = new List<string>();      // 治癒年月
            IList<string> strEndYearAd = new List<string>();    // 治癒年（西暦）
            IList<string> strEndYearJp = new List<string>();    // 治癒年（和暦）
            IList<string> strEndYearGe = new List<string>();    // 治癒年（元号）
            IList<string> strEndMonth = new List<string>();     // 治癒月
            IList<string> strCondition = new List<string>();    // 状態
            IList<string> strMedical = new List<string>();      // 医療機関

            bool blnEdit;   // 編集要否

            // 家族歴が存在しない場合は何もしない
            if (colDisHistories == null)
            {
                return;
            }

            // 家族歴が存在しない場合は何もしない
            if (colDisHistories.Count == 0)
            {
                return;
            }

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_');

            // 既往歴家族歴コレクションの内容を配列に変換 TODO i=1 ???
            for (int i = 0; i <= colDisHistories.Count; i++)
            {
                // 既往歴家族歴クラスの参照設定
                objDisHistory = colDisHistories.Item(i);

                // 編集要否の判定
                while (true)
                {
                    //全件指定の場合は無条件に編集対象
                    if ("ALL".Equals(token[1]))
                    {
                        blnEdit = true;
                        break;
                    }

                    // SEQ指定の場合、SEQ値が現要素のインデックスと一致すれば編集対象
                    blnEdit = (i.ToString().Equals(token[1]));

                    break;
                }

                // 編集対象であれば配列に追加
                if (blnEdit)
                {
                    // 既往歴家族歴コレクションの内容を配列に変換
                    strRelation.Add(SelectRelationName(Convert.ToString(objDisHistory.Relation)));
                    strDisCd.Add(objDisHistory.DisCd);
                    strDisName.Add(objDisHistory.DisName);
                    strStrDate.Add(objDisHistory.StrDate != null ? string.Format("{0:yyyy/M}", objDisHistory.StrDate) : "");
                    strStrYearAd.Add(objDisHistory.StrYearAd > 0 ? objDisHistory.StrYearAd.ToString() : "");
                    strStrYearJp.Add(objDisHistory.StrYearJp > 0 ? objDisHistory.StrYearJp.ToString() : "");
                    strStrYearGe.Add(objDisHistory.StrYearGe);
                    strStrMonth.Add(objDisHistory.StrMonth > 0 ? objDisHistory.StrMonth.ToString() : "");
                    strEndDate.Add(objDisHistory.EndDate != null ? string.Format("{0:yyyy/M}", objDisHistory.EndDate) : "");
                    strEndYearAd.Add(objDisHistory.EndYearAd > 0 ? objDisHistory.EndYearAd.ToString() : "");
                    strEndYearJp.Add(objDisHistory.EndYearJp > 0 ? objDisHistory.EndYearJp.ToString() : "");
                    strEndYearGe.Add(objDisHistory.EndYearGe);
                    strEndMonth.Add(objDisHistory.EndMonth > 0 ? objDisHistory.EndMonth.ToString() : "");
                    strCondition.Add(SelectConditionName(objDisHistory.Condition ?? ""));
                    strMedical.Add(objDisHistory.Medical);
                }
            }

            // オブジェクト名の先頭部による処理分岐
            switch (PrintCommon.ExceptReplicationSign(token[0]))
            {
                case "MYDISCD":      // 病名コード
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strDisCd);
                    break;
                case "MYDISNAME":    // 病名
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strDisName);
                    break;
                case "MYSTRDATE":    // 発病年月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrDate);
                    break;
                case "MYSTRYEARAD":  // 発病年（西暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrYearAd);
                    break;
                case "MYSTRYEARJP":  // 発病年（和暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrYearJp);
                    break;
                case "MYSTRYEARGE":  // 発病年（元号）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrYearGe);
                    break;
                case "MYSTRMONTH":   // 発病月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strStrMonth);
                    break;
                case "MYENDDATE":    // 治癒年月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndDate);
                    break;
                case "MYENDYEARAD":  // 治癒年（西暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndYearAd);
                    break;
                case "MYENDYEARJP":  // 治癒年（和暦）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndYearJp);
                    break;
                case "MYENDYEARGE":  // 治癒年（元号）
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndYearGe);
                    break;
                case "MYENDMONTH":   // 治癒月
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strEndMonth);
                    break;
                case "MYCONDITION":  // 状態
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strCondition);
                    break;
                case "MYMEDICAL":    // 医療機関
                    ((CnDataField)cnObject).Text = string.Join("\\r\\n", strMedical);
                    break;
            }
        }

        /// <summary>
        /// 優先順位順検査結果の編集
        /// </summary>
        /// <param name="cnObject">描画オブジェクト</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void EditPriResult(CnObject cnObject, RepConsult objRepConsult)
        {
            IList<string> token;    // トークン
            int tokenCount;         // トークン数

            bool blnHistoryNo;      // 履歴番号の存在有無
            int historyNo;          // 履歴番号
            int rsvNo;              // 予約番号

            RepHistory objHistory;  // 受診履歴クラス

            short colIndex;           // 列インデックス
            short rowIndex;           // 行インデックス

            bool blnFind;           // 検索フラグ
            RepResults colResults = null;  // 検査結果コレクション
            RepResult objResult = null;    // 検査結果クラス
            int i;

            // _でばらす（最初が項目名）
            token = cnObject.Name.Split('_').ToList();

            // トークン数の取得
            tokenCount = token.Count;

            // 一番最後のトークンは履歴番号か？
            blnHistoryNo = PrintCommon.IsInteger(token[tokenCount - 1]);

            rsvNo = 0;
            while (true)
            {
                // 一番最後のトークンが履歴番号でない場合は今回健診歴を参照する
                if (!blnHistoryNo)
                {
                    rsvNo = objRepConsult.RsvNo;
                    break;
                }

                // 以下は一番最後のトークンが履歴番号である場合

                // 受診履歴クラスの取得
                historyNo = Convert.ToInt32(token[tokenCount - 1]);

                objHistory = GetConsultHistory(objRepConsult.Histories, historyNo);
                if (objHistory == null)
                {
                    return;
                }

                // 過去歴を参照
                rsvNo = objHistory.RsvNo;
                colResults = objHistory.Results;

                break;
            }

            // 歴が存在しない場合は何もしない
            if (rsvNo == 0)
            {
                return;
            }

            // 結果読み込み
            IList<dynamic> rslPriorityData = SelectRslPriority(rsvNo, token);
            if (rslPriorityData.Count == 0)
            {
                blnFind = false;
                i = 1;
                while (!(i > tokenCount))
                {
                    objResult = colResults.Item(token[i]);
                    if (objResult != null)
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                if (!blnFind)
                {
                    CnListField cnListField = (CnListField)cnObject;
                    // オブジェクト名の先頭部による処理分岐
                    switch (PrintCommon.ExceptReplicationSign(token[0]))
                    {
                        case "PRISHORTSTC":     // 略文章
                            if (cnListField.ListColumns.Length >= 1 && cnListField.ListRows.Length >= 1)
                            {
                                cnListField.ListText(0, 0, "＊＊＊＊＊"); 
                            }
                            break;
                        case "PRILONGSTC":      // 文章
                            if (cnListField.ListColumns.Length >= 1 && cnListField.ListRows.Length >= 1)
                            {
                                cnListField.ListText(0, 0, "＊＊＊＊＊");
                            }
                            break;
                        case "PRIENGSTC":       // 英語文章
                            if (cnListField.ListColumns.Length >= 1 && cnListField.ListRows.Length >= 1)
                            {
                                cnListField.ListText(0, 0, "＊＊＊＊＊");
                            }
                            break;
                    }
                }

            }
            else
            {
                // 結果表示
                rowIndex = 0;
                colIndex = 0;
                CnListField cnListField = (CnListField)cnObject;
                foreach (var rec in rslPriorityData)
                {
                    // 右列、下行の順で表示する
                    if (rowIndex > cnListField.ListRows.Length - 1)
                    {
                        rowIndex = 0;
                        colIndex++;
                    }
                    if (colIndex > cnListField.ListColumns.Length -1)
                    {
                        break;
                    }

                    // オブジェクト名の先頭部による処理分岐
                    switch (PrintCommon.ExceptReplicationSign(token[0]))
                    {
                        case "PRISHORTSTC":     // 略文章
                            cnListField.ListText(colIndex, rowIndex, Convert.ToString(rec.SHORTSTC));
                            break;
                        case "PRILONGSTC":      // 文章
                            cnListField.ListText(colIndex, rowIndex, Convert.ToString(rec.LONGSTC));
                            break;
                        case "PRIENGSTC":       // 英語文章
                            cnListField.ListText(colIndex, rowIndex, Convert.ToString(rec.ENGSTC));
                            break;
                    }

                    rowIndex++;
                }
            }

        }

        /// <summary>
        ///汎用情報(CODE,NAME)取得(Common)
        /// </summary>
        /// <param name="arrCondition">状態</param>
        /// <param name="arrConditionName">状態名称</param>
        /// <returns></returns>
        private int SelectFreeList(ref IList<string> arrCode, ref IList<string> arrName, string freeClassCd)
        {
            string strCode = "";
            string strName = "";
            int i;

            i = 1;
            while (true)
            {
                // TODO  CODE,NAME情報取得 ini→Free 

                // これ以上値が存在しないとき、処理を抜ける
                if (string.IsNullOrEmpty(strCode) && string.IsNullOrEmpty(strName))
                {
                    break;
                }

                // 配列でない場合は新規配列を作成
                arrCode.Add(strCode);
                arrName.Add(strName);

                i++;

                break;
            }

            return arrCode == null ? 0 : arrCode.Count;
        }

        /// <summary>
        /// 状態名称取得(Common)
        /// </summary>
        /// <param name="strCondition">状態</param>
        /// <returns>状態名称</returns>
        private string SelectConditionName(string strCondition)
        {
            IList<string> arrCode = new List<string>();
            IList<string> arrName = new List<string>();
            string strConditionName = "";       // 状態名称

            // 状態情報取得
            SelectFreeList(ref arrCode, ref arrName, "CONDITION");

            // 状態情報が登録されていない場合何もしない
            if (arrCode == null || arrCode.Count == 0)
            {
                return strConditionName;
            }

            // 一致する状態を検索
            for (int i = 0; i < arrCode.Count; i++)
            {
                if (strCondition.Equals(arrCode[i]))
                {
                    // 状態名称を返す
                    strConditionName = arrName[i];
                    break;
                }
            }

            return strConditionName;
        }

        /// <summary>
        /// 続柄名称取得
        /// </summary>
        /// <param name="strRelation">続柄</param>
        /// <returns></returns>
        private string SelectRelationName(string strRelation)
        {
            IList<string> arrCode = new List<string>();
            IList<string> arrName = new List<string>();
            string strRelationName = "";       // 続柄名称

            SelectFreeList(ref arrCode, ref arrName, "RELATION");

            // 状態情報が登録されていない場合何もしない
            if (arrCode == null || arrCode.Count == 0)
            {
                return strRelationName;
            }

            // 一致する状態を検索
            for (int i = 0; i < arrCode.Count; i++)
            {
                if (strRelation.Equals(arrCode[i]))
                {
                    // 続柄名称を返す
                    strRelationName = arrName[i];
                    break;
                }
            }

            return strRelationName;
        }


        /// <summary>
        /// 全検査項目を取得
        /// </summary>
        /// <returns>検査項目コレクションクラス</returns>
        private RepItems SelectItem_C_All()
        {
            string sql;         // SQLステートメント
            RepItems colItems;  // 検査項目コレクション

            // コレクションのインスタンス作成
            colItems = new RepItems();

            // 全検査項目を取得
            sql = @"
                    select
                        itemcd
                        , suffix
                        , resulttype
                        , itemrname
                        , itemename
                        , itemqname
                        , noprintflg 
                    from
                        item_c 
                    order by
                        itemcd
                        , suffix
                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql).ToList();
            foreach (var rec in data)
            {
                colItems.Add(rec.ITEMCD,
                    rec.SUFFIX,
                    rec.RESULTTYPE,
                    rec.ITEMRNAME,
                    rec.ITEMENAME,
                    rec.ITEMQNAME,
                    rec.NOPRINTFLG ?? 0);
            }

            return colItems;
        }

        /// <summary>
        /// 検査項目履歴の取得
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        private void SelectItem_H_All(ref RepItems colItems)
        {
            string sql;     // SQLステートメント

            RepItem reqItem;   // 検査項目クラス
            RepItemHistories colItemHistories;  // 検査項目履歴コレクション

            string prevItemCd = string.Empty;   // 直前レコードの検査項目コード
            string prevSuffix = string.Empty;   // 直前レコードのサフィックス

            // 全検査項目を取得
            sql = @"
                    select
                        itemcd
                        , suffix
                        , itemhno
                        , strdate
                        , enddate
                        , unit 
                    from
                        item_h 
                    order by
                        itemcd
                        , suffix
                        , itemhno
                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql).ToList();

            // 検査項目履歴コレクションの作成
            foreach (var rec in data)
            {
                while (true)
                {
                    if (!prevItemCd.Equals(rec.ITEMCD) || !prevSuffix.Equals(rec.SUFFIX))
                    {
                        // 現レコードの検査項目を退避
                        prevItemCd = rec.ITEMCD;
                        prevSuffix = rec.SUFFIX;

                        // 検査項目クラスの参照設定
                        reqItem = colItems.Item(prevItemCd + "-" + prevSuffix);
                        if (reqItem == null)
                        {
                            break;
                        }

                        // 検査項目履歴コレクションの参照設定
                        colItemHistories = reqItem.Histories;
                        if (colItemHistories == null || colItemHistories.Count == 0)
                        {
                            break;
                        }

                    }
                    break;
                }

            }

        }

        /// <summary>
        /// 基準値の読み込み
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        private void SelectStdValue(ref RepItems colItems)
        {
            string sql;           // SQLステートメント
            RepItem item;      // 検査項目クラス
            RepStdValues colStdValues;     // 基準値コレクション

            string prevItemCd = "";          // 直前レコードの検査項目コード
            string prevSuffix = "";          // 直前レコードのサフィックス

            // 基準値フラグが"S"である全基準値情報を取得
            sql = @"
                    select
                        stdvalue.itemcd
                        , stdvalue.suffix
                        , stdvalue.strdate
                        , stdvalue.enddate
                        , stdvalue.cscd
                        , stdvalue_c.gender
                        , stdvalue_c.strage
                        , stdvalue_c.endage
                        , stdvalue_c.lowervalue
                        , stdvalue_c.uppervalue 
                    from
                        stdvalue_c
                        , stdvalue 
                    where
                        stdvalue.stdvaluemngcd = stdvalue_c.stdvaluemngcd 
                        and stdvalue_c.stdflg = 'S' 
                    order by
                        stdvalue.itemcd
                        , stdvalue.suffix
                        , stdvalue.strdate
                        , stdvalue.enddate
                        , stdvalue.cscd
                        , stdvalue_c.gender
                        , stdvalue_c.strage
                        , stdvalue_c.endage
                        , stdvalue_c.priorseq
                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql).ToList();

            foreach (var rec in data)
            {
                while (true)
                {
                    // 直前のレコードと検査項目が異なる場合
                    if (!prevItemCd.Equals(rec.ITEMCD) || !prevSuffix.Equals(rec.SUFFIX))
                    {
                        // 現レコードの検査項目を退避
                        prevItemCd = rec.ITEMCD;
                        prevSuffix = rec.SUFFIX;

                        // 検査項目クラスの参照設定
                        item = colItems.Item(prevItemCd + "-" + prevSuffix);
                        if (item == null)
                        {
                            break;
                        }

                        // 基準値コレクションの参照設定
                        colStdValues = item.StdValues;
                        if (colStdValues == null)
                        {
                            break;
                        }

                        // コレクションに追加
                        colStdValues.Add(rec.STRDATE,
                            rec.ENDDATE,
                            rec.CSCD,
                            rec.GENDER,
                            rec.STRAGE,
                            rec.ENDAGE,
                            rec.LOWERVALUE,
                            rec.UPPERVALUE);

                        break;
                    }

                }
            }

        }


        /// <summary>
        /// 指定予約番号の受診情報を読み込む
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        private RepConsult SelectConsult(int rsvNo)
        {
            string sql;                 // SQLステートメント
            RepConsult objRepConsult = null;   // 受診情報クラス

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", rsvNo);

            sql = @"
                    select
                        consult.rsvno
                        , consult.csldate
                        , consult.perid
                        , consult.cscd
                        , consult.orgcd1
                        , consult.orgcd2
                        , consult.rsvdate
                        , getcslage( 
                            person.birth
                            , consult.csldate
                            , to_char(consult.csldate, 'YYYYMMDD')
                        ) 　age
                        , consult.reportprintdate
                        , consult.firstrsvno
                        , consult.empno
                        , consult.isrsign
                        , consult.isrno
                        , receipt.cntlno
                        , receipt.dayid
                        , person.lastname
                        , person.firstname
                        , person.lastkname
                        , person.firstkname
                        , person.birth
                        , person.gender
                        , person.vidflg
                        , person.romename
                        , persondetail.residentno
                        , persondetail.unionno
                        , persondetail.karte
                        , peraddr.zipcd
                        , peraddr.cityname
                        , peraddr.address1
                        , peraddr.address2
                        , pref.prefname
                        , course_p.csname
                        , org.orgkname
                        , org.orgname
                        , org.orgsname
                        , orgbsd.orgbsdname
                        , orgbsd.orgbsdkname
                        , orgroom.orgroomname
                        , orgroom.orgroomkname
                        , orgpost.orgpostname
                        , orgpost.orgpostkname
                        , hainsuser.username doctorname
                        , free.freefield1 freename
                        , job.freefield1 jobname
                        , duty.freefield1 dutyname
                        , qualify.freefield1 qualifyname

                ";

            // FROM句の設定
            sql += @"
                    from
                        free
                        , hainsuser
                        , org
                        , course_p
                        , pref
                        , persondetail
                        , person
                        , receipt
                        , consult
                        , orgbsd
                        , orgroom
                        , orgpost
                        , peraddr
                        , free job
                        , free duty
                        , free qualify

                ";

            // WHERE句の設定
            sql += @"
                    where
                        consult.rsvno = :rsvno 
                        and consult.rsvno = receipt.rsvno 
                        and consult.csldate = receipt.csldate 
                        and receipt.comedate is not null 
                        and consult.perid = person.perid 
                        and consult.perid = persondetail.perid(+) 
                        and consult.cscd = course_p.cscd 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2
                        and consult.perid = peraddr.perid(+)
                        and consult.reportaddrdiv = peraddr.addrdiv(+) 
                        and consult.orgcd1 = orgbsd.orgcd1(+) 
                        and consult.orgcd2 = orgbsd.orgcd2(+) 
                        and consult.orgcd1 = orgroom.orgcd1(+) 
                        and consult.orgcd2 = orgroom.orgcd2(+) 
                        and consult.orgcd1 = orgpost.orgcd1(+) 
                        and consult.orgcd2 = orgpost.orgcd2(+)
                        and peraddr.prefcd = pref.prefcd(+)

                ";

            // SQL実行
            dynamic data = connection.Query(sql, sqlParam).ToList();

            // レコードが存在する場合
            if (null != data)
            {
                DateTime? wkReportPrintDate = data.REPORTPRINTDATE != null ? Convert.ToDateTime(data.REPORTPRINTDATE) : null;
                // 受診情報クラスのインスタンス作成
                objRepConsult = new RepConsult
                {
                    RsvNo = rsvNo,
                    CslDate = Convert.ToDateTime(data.CSLDATE),
                    PerId = data.PERID,
                    CsCd = data.CSCD,
                    OrgCd1 = data.ORGCD1,
                    OrgCd2 = data.ORGCD2,
                    RsvDate = Convert.ToDateTime(data.RSVDATE),
                    Age = Convert.ToInt32(data.AGE),
                    AgeMonth = Convert.ToInt32(data.AGE) * 100 % 100,
                    ReportPrintDate = wkReportPrintDate,
                    IsrSign = data.ISRSIGN,
                    IsrNo = data.ISRNO,
                    FirstRsvNo = data.FIRSTRSVNO ?? 0,
                    CntlNo = data.CNTLNO,
                    DayId = data.DAYID,
                    LastName = data.LASTNAME,
                    FirstName = data.FIRSTNAME,
                    LastKName = data.LASTKNAME,
                    FirstKName = data.FIRSTKNAME,
                    Birth = Convert.ToDateTime(data.BIRTH),
                    Gender = Convert.ToInt32(data.GENDER),
                    RomeName = data.ROMENAME,
                    ZipCd1 = data.ZIPCD1,
                    ZipCd2 = data.ZIPCD2,
                    CityName = data.CITYNAME,
                    Address1 = data.ADDRESS1,
                    Address2 = data.ADDRESS2,
                    ResidentNo = data.RESIDENTNO,
                    UnionNo = data.UNIONNO,
                    Karte = data.KARTE,
                    EmpNo = data.EMPNO,
                    PrefName = data.PREFNAME,
                    CsName = data.CSNAME,
                    OrgKName = data.ORGKNAME,
                    OrgName = data.ORGNAME,
                    OrgSName = data.ORGSNAME,
                    DoctorName = data.DOCTORNAME,
                    VidFlg = Convert.ToInt32(data.VIDFLG) ?? 0,
                    OrgBsdKName = data.ORGBSDKNAME,
                    OrgBsdName = data.ORGBSDNAME,
                    OrgRoomKName = data.ORGROOMKNAME,
                    OrgRoomName = data.ORGROOMNAME,
                    OrgPostKName = data.ORGPOSTKNAME,
                    OrgPostName = data.ORGPOSTNAME,
                    JobName = data.JOBNAME,
                    DutyName = data.DUTYNAME,
                    QualifyName = data.QUALIFYNAME
                };
            }

            return objRepConsult ?? new RepConsult();
        }

        /// <summary>
        /// 受診履歴の読み込み
        /// </summary>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void SelectConsultHistory(ref RepConsult objRepConsult)
        {
            string sql;     // SQLステートメント
            RepHistories colHistories = null;       // 受診履歴コレクション
            int lngCslCount = 0;    // 受診回数

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("perid", objRepConsult.PerId);
            sqlParam.Add("csldate", objRepConsult.CslDate);
            sqlParam.Add("freecd", FREE_TARGET_LASTCSCD);
            sqlParam.Add("rsvno", objRepConsult.RsvNo);

            // 今回受診分
            sql = @"
                    select
                        1 as stat
                        , consult.rsvno
                        , consult.csldate
                        , consult.cscd
                        , receipt.cntlno
                        , receipt.dayid
                        , course_p.csname
                        , course_p.secondflg
                        , course_p.regularflg 
                    from
                        course_p
                        , receipt
                        , consult 
                    where
                        consult.rsvno = :rsvno 
                        and consult.rsvno = receipt.rsvno 
                        and consult.csldate = receipt.csldate 
                        and receipt.comedate is not null 
                        and consult.cscd = course_p.cscd
                ";

            sql += @"
                    union
                ";

            // 過去受診分
            sql += @"
                    select
                        2 as stat
                        , consult.rsvno
                        , consult.csldate
                        , consult.cscd
                        , receipt.cntlno
                        , receipt.dayid
                        , course_p.csname
                        , course_p.secondflg
                        , course_p.regularflg 
                    from
                        course_p
                        , receipt
                        , consult
                        , free 
                    where
                        consult.perid = :perid 
                        and consult.csldate <= :csldate 
                        and consult.rsvno <> :rsvno 
                        and consult.rsvno = receipt.rsvno 
                        and consult.csldate = receipt.csldate 
                        and receipt.comedate is not null 
                        and consult.cscd = course_p.cscd 
                        and free.freecd like :freecd 
                        and free.freefield1 = consult.cscd

                ";

            sql += @"
                    order by 1, 3 desc, 4, 5 desc, 6 desc 
                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 受診履歴コレクションの参照設定
            colHistories = objRepConsult.Histories;

            //TODO
            foreach (var rec in data)
            {
                // コレクションに追加
                colHistories.Add(rec.RSVNO, rec.CSLDATE, rec.CNTLNO, rec.DAYID, rec.CSCD, rec.CSNAME);

                // 受診回数をインクリメント
                lngCslCount++;
            }

            // 受診回数を編集
            objRepConsult.CslCount = lngCslCount;
        }

        /// <summary>
        /// 検査結果の読み込み
        /// </summary>
        /// <param name="objRepConsult"></param>
        private void SelectRsl(ref RepConsult objRepConsult)
        {
            string sql;     // SQLステートメント
            RepResults colResults;       // 検査結果コレクション
            string strResult;            // 検査結果
            DateTime? dtmCslDate = null; // 取得対象となる最も若い受診日
            int lngGetCount;             // 取得した歴の数

            // 取得対象となる最も若い受診日を求める
            switch (PrintCommon.glngGetHistoryCount)
            {
                case 0:
                    dtmCslDate = Convert.ToDateTime("1970/1/1");
                    break;
                case 1:
                    dtmCslDate = objRepConsult.CslDate;
                    break;
                default:
                    lngGetCount = 1;
                    for (int i = 0; i < objRepConsult.Histories.Count; i++)
                    {
                        if (lngGetCount == PrintCommon.glngGetHistoryCount)
                        {
                            break;
                        }
                        dtmCslDate = objRepConsult.Histories.Item(i).CslDate;
                        lngGetCount++;
                    }
                    break;
            }

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("perid", objRepConsult.PerId);
            sqlParam.Add("csldate", objRepConsult.CslDate);
            sqlParam.Add("limcsldate", dtmCslDate);
            sqlParam.Add("rsvno", objRepConsult.RsvNo);

            if (TARGET_CSCD_HAI.Equals(objRepConsult.CsCd))
            {
                sqlParam.Add("freecd", FREE_TARGET_CSCD_HAI);
            }
            else
            {
                sqlParam.Add("freecd", FREE_TARGET_LASTCSCD);
            }

            sql = @"
                    select
                        basedresult.rsvno
                        , basedresult.itemcd
                        , basedresult.suffix
                        , basedresult.result
                        , basedresult.rslcmtcd1
                        , basedresult.rslcmtcd2
                        , basedresult.resulttype
                        , rslcmt1.rslcmtname rslcmtname1
                        , rslcmt2.rslcmtname rslcmtname2
                        , sentence.reptstc shortstc
                        , sentence.reptstc longstc
                        , sentence.engstc
                        , stdvalue_c.stdflg
                        , rslmemo.rslmemostr
                ";

            // FROM句の設定
            sql += @"
                    from
                        stdvalue_c
                        , sentence
                        , rslcmt rslcmt1
                        , rslcmt rslcmt2
                        , rslmemo
                        , 
                ";

            // 基本表に検査結果、検査項目情報を結合
            sql += @"
                    ( 
                        select
                            basedconsult.rsvno
                            , rsl.itemcd
                            , rsl.suffix
                            , rsl.result
                            , rsl.rslcmtcd1
                            , rsl.rslcmtcd2
                            , rsl.stdvaluecd
                            , item_c.resulttype
                            , item_c.itemtype
                            , item_c.stcitemcd
                            , basedconsult.perid
                            , basedconsult.stat
                            , basedconsult.csldate
                            , basedconsult.cscd
                            , basedconsult.cntlno
                            , basedconsult.dayid 
                        from
                            item_c
                            , rsl
                            ,
                ";

            sql += @"
                        ( 
                            select
                                2 as stat
                                , consult.rsvno
                                , consult.csldate
                                , consult.cscd
                                , consult.perid
                                , receipt.cntlno
                                , receipt.dayid 
                            from
                                receipt
                                , consult
                                , free 
                            where
                                consult.perid = :perid 
                                and consult.csldate <= :csldate 
                                and consult.csldate >= :limcsldate 
                                and consult.rsvno <> :rsvno
                                and consult.rsvno = receipt.rsvno 
                                and consult.csldate = receipt.csldate 
                                and receipt.comedate is not null 
                                and free.freecd like :freecd 
                                and free.freefield1 = consult.cscd
                ";

            sql += @"
                            union 
                            select
                                1 as stat
                                , consult.rsvno
                                , consult.csldate
                                , consult.cscd
                                , consult.perid
                                , receipt.cntlno
                                , receipt.dayid 
                            from
                                receipt
                                , consult 
                            where
                                consult.rsvno = :rsvno 
                                and consult.rsvno = receipt.rsvno 
                                and consult.csldate = receipt.csldate 
                                and receipt.comedate is not null
                        ) basedconsult 
                ";

            sql += @"
                    where
                        basedconsult.rsvno = rsl.rsvno 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix
                ";

            if ("03008".Equals(objRepConsult.OrgCd1) && "00000".Equals(objRepConsult.OrgCd2))
            {
                sql += @"
                        and rsl.itemcd not in ( select itemcd from item_p where classcd='760' ) 
                    ";
            }

            sql += @"
                    ) basedresult 
                    where
                        basedresult.stcitemcd = sentence.itemcd(+) 
                        and basedresult.itemtype = sentence.itemtype(+) 
                        and basedresult.result = sentence.stccd(+) 
                        and basedresult.rslcmtcd1 = rslcmt1.rslcmtcd(+) 
                        and basedresult.rslcmtcd2 = rslcmt2.rslcmtcd(+) 
                        and basedresult.stdvaluecd = stdvalue_c.stdvaluecd(+) 
                        and basedresult.rsvno = rslmemo.rsvno(+) 
                        and basedresult.itemcd = rslmemo.itemcd(+) 
                        and basedresult.suffix = rslmemo.suffix(+)
                ";

            sql += @"
                    order by
                        basedresult.perid
                        , basedresult.stat
                        , basedresult.csldate desc
                        , basedresult.cscd
                        , basedresult.cntlno desc
                        , basedresult.dayid desc
                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 検査結果コレクションの参照設定
            colResults = objRepConsult.Results;

            // 今回検査結果コレクションの作成
            foreach (var rec in data)
            {
                // 今回検査結果でなくなった場合は処理を抜ける
                if (objRepConsult.RsvNo != rec.RSVNO)
                {
                    break;
                }

                // クリア忘れ防止の為、一応クリアを追加する
                strResult = "";
                // 結果データ変換処理
                switch (Convert.ToInt32(rec.RESULTTYPE))
                {
                    case 6:
                        // 日付
                        if (DateTime.TryParse(rec.RESULT, out DateTime wkDate))
                        {
                            strResult = string.Format("yyyy/m/d", Convert.ToDateTime(rec.RESULT));
                        }
                        else
                        {
                            strResult = rec.RESULT;
                        }
                        break;
                    case 7:
                        // メモ
                        strResult = rec.RSLMEMOSTR;
                        break;
                    case 8:
                        // 符号付き数字
                        strResult = rec.RESULT + rec.RSLCMTCD1;
                        break;
                    default:
                        // その他
                        strResult = rec.RESULT;
                        break;
                }

                // コレクションに追加
                colResults.Add(rec.ITEMCD,
                    rec.SUFFIX,
                    rec.RESULTTYPE == 4 ? rec.SHORTSTC : "",
                    rec.RESULTTYPE == 4 ? rec.LONGSTC : "",
                    rec.RESULTTYPE == 4 ? rec.ENGSTC : "",
                    strResult,
                    rec.RSLCMTCD1,
                    rec.RSLCMTNAME1,
                    rec.RSLCMTCD2,
                    rec.RSLCMTNAME2,
                    rec.STDFLG);
            }

        }

        /// <summary>
        /// 判定結果の読み込み
        /// </summary>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void SelectJudRsl(ref RepConsult objRepConsult)
        {
            string sql;     // SQLステートメント
            RepJudgements colJudgements;        // 判定結果コレクション
            RepHistory objHistory;              // 受診履歴クラス
            string strJudClassCd = "";          // 判定分類コード
            DateTime? dtmCslDate = null;        // 取得対象となる最も若い受診日
            int lngGetCount = 0;                // 取得した歴の数

            // 取得対象となる最も若い受診日を求める
            switch (PrintCommon.glngGetHistoryCount)
            {
                case 0:
                    dtmCslDate = Convert.ToDateTime("1970/1/1");
                    break;
                case 1:
                    dtmCslDate = objRepConsult.CslDate;
                    break;
                default:
                    lngGetCount = 1;
                    for (int i = 0; i < objRepConsult.Histories.Count; i++)
                    {
                        if (lngGetCount == PrintCommon.glngGetHistoryCount)
                        {
                            break;
                        }
                        dtmCslDate = objRepConsult.Histories.Item(i).CslDate;
                        lngGetCount++;
                    }
                    break;
            }

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("perid", objRepConsult.PerId);
            sqlParam.Add("csldate", objRepConsult.CslDate);
            sqlParam.Add("limcsldate", dtmCslDate);
            if (TARGET_CSCD_HAI.Equals(objRepConsult.CsCd))
            {
                sqlParam.Add("freecd", FREE_TARGET_CSCD_HAI);
            }
            else
            {
                sqlParam.Add("freecd", FREE_TARGET_LASTCSCD);
            }
            sqlParam.Add("rsvno", objRepConsult.RsvNo);

            // 今回受診情報を含む、過去の全判定結果を取得
            sql = @"
                    select
                        basedconsult.rsvno
                        , judrsl.judclasscd
                        , judrsl.judcd
                        , judclass.judclassname
                        , jud.judrname
                        , hainsuser.username 
                    from
                        hainsuser
                        , jud
                        , judclass
                        , judrsl
                        , 
                ";

            sql += @"
                        ( 
                            select
                                2 as stat
                                , consult.rsvno
                                , consult.perid
                                , consult.csldate
                                , consult.cscd
                                , receipt.cntlno
                                , receipt.dayid 
                            from
                                receipt
                                , consult
                                , free 
                            where
                                consult.perid = :perid 
                                and consult.csldate <= :csldate 
                                and consult.csldate >= :limcsldate 
                                and consult.rsvno <> :rsvno

                ";

            sql += @"
                                and consult.rsvno = receipt.rsvno 
                                and consult.csldate = receipt.csldate 
                                and receipt.comedate is not null 
                                and free.freecd like :freecd 
                                and free.freefield1 = consult.cscd
                ";

            sql += @"
                            union 
                            select
                                1 as stat
                                , consult.rsvno
                                , consult.perid
                                , consult.csldate
                                , consult.cscd
                                , receipt.cntlno
                                , receipt.dayid 
                            from
                                receipt
                                , consult 
                            where
                                consult.rsvno = :rsvno 
                                and consult.rsvno = receipt.rsvno 
                                and consult.csldate = receipt.csldate 
                                and receipt.comedate is not null
                        ) basedconsult
                ";

            sql += @"
                    where
                        basedconsult.rsvno = judrsl.rsvno(+) 
                        and judrsl.judclasscd = judclass.judclasscd(+) 
                        and judrsl.judcd = jud.judcd(+) 
                        and judrsl.upduser = hainsuser.userid(+)
                ";

            // 03008-00000団体(ウムぎ) 成績書出力の時婦人科データ除外
            if ("03008".Equals(objRepConsult.OrgCd1) && "00000".Equals(objRepConsult.OrgCd2))
            {
                sql += @"
                        and  judclass.judclasscd not in ( 24, 25 ) 
                    ";
            }

            sql += @"
                    order by
                        basedconsult.perid
                        , basedconsult.stat
                        , basedconsult.csldate desc
                        , basedconsult.cscd
                        , basedconsult.cntlno desc
                        , basedconsult.dayid desc

                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 判定結果コレクションの参照設定
            colJudgements = objRepConsult.Judgements;

            // 今回判定結果コレクションの作成
            foreach (var rec in data)
            {
                // 今回判定結果でなくなった場合は処理を抜ける
                if (objRepConsult.RsvNo != rec.RSVNO)
                {
                    break;
                }

                // 判定分類が存在する(即ち今回判定結果が存在する)場合
                if (null != rec.JUDCLASSCD)
                {
                    // 前レコードと判定分類が異なる場合
                    if (strJudClassCd.Equals(rec.JUDCLASSCD))
                    {
                        // コレクションに追加
                        colJudgements.Add(rec.JUDCLASSCD,
                            rec.JUDCLASSNAME,
                            rec.JUDCD,
                            rec.JUDRNAME,
                            "",
                            "",
                            rec.USERNAME,
                            "",
                            "");

                        // 現在の判定分類コードを退避
                        strJudClassCd = rec.JUDCLASSCD;
                    }
                }
            }

            while (true)
            {
                // 今回受診情報のみを取得する場合以下の処理は不要
                if (PrintCommon.glngGetHistoryCount == 1)
                {
                    break;
                }

                // 全ての受診履歴に対する判定結果の編集
                for (int i = 0; i < objRepConsult.Histories.Count; i++)
                {
                    objHistory = objRepConsult.Histories.Item(i);

                    // 判定結果コレクションの参照設定
                    colJudgements = objHistory.Judgements;

                    // 現受診情報の判定結果開始位置を検索
                    int pos = 0;
                    for (pos = 0; pos < data.Count; pos++)
                    {
                        if (objHistory.RsvNo == data[pos].RSVNO)
                        {
                            break;
                        }
                    }

                    // 検索不能時は処理を終了
                    if (pos == data.Count)
                    {
                        break;
                    }

                    // 現受診情報の判定結果編集
                    strJudClassCd = "";
                    for (int nextPos = pos; nextPos < data.Count; nextPos++)
                    {
                        // 現受診情報の判定結果でなくなった場合は処理を抜ける
                        if (objHistory.RsvNo != data[nextPos].RSVNO)
                        {
                            break;
                        }

                        // 判定分類が存在する(即ち現受診情報の判定結果が存在する)場合
                        if (null != data[nextPos].JUDCLASSCD)
                        {
                            // 前レコードと判定分類が異なる場合
                            if (strJudClassCd.Equals(data[nextPos].JUDCLASSCD))
                            {
                                // コレクションに追加
                                colJudgements.Add(data[nextPos].JUDCLASSCD,
                                    data[nextPos].JUDCLASSNAME,
                                    data[nextPos].JUDCD,
                                    data[nextPos].JUDRNAME,
                                    "",
                                    "",
                                    data[nextPos].USERNAME,
                                    "",
                                    "");

                                // 現在の判定分類コードを退避
                                strJudClassCd = data[nextPos].JUDCLASSCD;
                            }
                        }
                    }
                }

                break;
            }
        }

        /// <summary>
        /// 個人検査項目情報を取得する
        /// </summary>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void SelectPerResult(ref RepConsult objRepConsult)
        {
            string sql;     // SQLステートメント
            RepPerResults colPerResults;    // 個人検査結果コレクション

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("perid", objRepConsult.PerId);

            // 指定個人の個人検査情報を取得
            sql = @"
                    select
                        basedresult.itemcd
                        , basedresult.suffix
                        , basedresult.result
                        , basedresult.ispdate
                        , basedresult.itemrname
                        , basedresult.itemename
                        , sentence.reptstc shortstc
                        , sentence.reptstc longstc
                        , sentence.engstc 
                    from
                        sentence
                        , 
                ";

            // 個人検査結果と検査項目情報とを結合
            sql += @"
                        ( 
                            select
                                perresult.itemcd
                                , perresult.suffix
                                , perresult.result
                                , perresult.ispdate
                                , item_c.itemrname
                                , item_c.itemename
                                , item_c.stcitemcd
                                , item_c.itemtype 
                            from
                                item_c
                                , perresult 
                            where
                                perresult.perid = :perid 
                                and perresult.itemcd = item_c.itemcd 
                                and perresult.suffix = item_c.suffix
                        ) basedresult
                ";

            sql += @"
                    where
                        basedresult.stcitemcd = sentence.itemcd(+) 
                        and basedresult.itemtype = sentence.itemtype(+) 
                        and basedresult.result = sentence.stccd(+)

                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();


            // 個人検査結果コレクションの参照設定
            colPerResults = objRepConsult.PerResults;

            // 受診履歴コレクションの作成
            foreach (var rec in data)
            {
                // コレクションに追加
                colPerResults.Add(rec.ItemCd,
                              rec.Suffix,
                              rec.ItemRName,
                              rec.ItemEName,
                              rec.Result,
                              rec.ShortStc,
                              rec.LongStc,
                              rec.EngStc,
                              rec.IspDate == null ? null : Convert.ToDateTime(rec.IspDate));
            }


        }

        /// <summary>
        /// 既往歴家族歴の読み込み
        /// </summary>
        /// <param name="objRepConsult">受診情報クラス</param>
        private void SelectDisHistory(ref RepConsult objRepConsult)
        {
            string sql;     // SQLステートメント
            RepDisHistories colDisHistories;    // 既往歴コレクション
            RepDisHistories colFmlHistories;    // 家族歴コレクション
            RepDisHistories colCollection;      // 追加対象となるコレクション

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("perid", objRepConsult.PerId);

            sql = @"
                    select
                        dishistory.relationcd
                        , dishistory.discd
                        , dishistory.strdate
                        , dishistory.enddate
                        , dishistory.condition
                        , dishistory.medical
                        , disease.disname 
                    from
                        disease
                        , dishistory 
                    where
                        dishistory.perid = :perid 
                        and dishistory.discd = disease.discd 
                    order by
                        dishistory.perid
                        , dishistory.relationcd
                        , dishistory.discd
                        , dishistory.strdate

                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 既往歴家族歴コレクションの参照設定
            colDisHistories = objRepConsult.DisHistories;
            colFmlHistories = objRepConsult.FmlHistories;

            // 既往歴家族歴コレクションの作成
            foreach (var rec in data)
            {
                // 続柄が本人か否かでレコードを振り分け、コレクションに追加
                if (0 == rec.RELATION)
                {
                    colCollection = colDisHistories;
                }
                else
                {
                    colCollection = colFmlHistories;
                }

                // コレクションに追加
                colCollection.Add(rec.RELATION,
                          rec.DISCD,
                          rec.DISNAME,
                          rec.STRDATE,
                          rec.ENDDATE == null ? null : Convert.ToDateTime(rec.ENDDATE),
                          rec.Condition,
                          rec.Medical);
            }
        }

        /// <summary>
        /// 結果読み込み
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="token">トークン</param>
        /// <returns></returns>
        private IList<dynamic> SelectRslPriority(int rsvNo, IList<string> token)
        {
            string sql;         // SQLステートメント
            int count;          // レコード数
            int itemCount;      // 検査項目数
            int charPos;        // 文字位置
            bool blnFind;       // 検索フラグ
            string strShortStc; // 略文章
            string strLongStc;  // 文章
            string strEngStc;   // 英語文章
            int i;

            // 初期処理
            itemCount = token.Count;

            if (itemCount == 0)
            {
                return new List<dynamic>();
            }

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", rsvNo);

            // 文章を取得
            sql = @"
                select
                    sentence.reptstc shortstc
                    , sentence.reptstc longstc
                    , sentence.engstc 
                from
                    rsl
                    , item_c
                    , sentence 
                where
                    rsl.rsvno = :rsvno

            ";

            i = 1;
            while (!(i > itemCount))
            {
                if (i == 1)
                {
                    sql += @"
                            and (
                        ";
                }
                else
                {
                    sql += @"
                            or 
                        ";
                }
                charPos = token[i].Trim().IndexOf('-');
                sql += string.Format(
                    @"
                        (rsl.itemcd = '{0}'
                    ", token[i].Trim().Substring(0, charPos-1)
                    );
                sql += string.Format(
                    @"
                        and rsl.suffix = '{0}' )
                    ", token[i].Trim().Substring(charPos+1)
                    );
                i++;
            }
            sql += @"
                    ) 
                    and rsl.result is not null 
                    and item_c.itemcd = rsl.itemcd 
                    and item_c.suffix = rsl.suffix 
                    and sentence.itemcd = item_c.itemcd 
                    and sentence.itemtype = item_c.itemtype 
                    and sentence.stccd = rsl.result 
                    order by
                        nvl(sentence.printorder, 999999)
                        , rsl.itemcd
                        , rsl.suffix
                ";

            // SQL実行
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();
            IList<dynamic> res = new List<dynamic>();
            
            // 検索レコードが存在する場合
            foreach (var rec in data)
            {
                strShortStc = rec.SHORTSTC;
                strLongStc = rec.LONGSTC;
                strEngStc = rec.ENGSTC;

                // 重複しない文章のみ抽出する
                blnFind = false;
                foreach (var item in res)
                {
                    if (strShortStc.Equals(item.SHORTSTC) 
                        && strLongStc.Equals(item.LONGSTC) 
                        && strEngStc.Equals(item.strEngStc))
                    {
                        blnFind = true;
                        break;
                    }
                }

                if (!blnFind)
                {
                    res.Add(rec);
                }
            }

            return res;
        }

        /// <summary>
        /// 指定履歴番号の受診履歴を取得
        /// </summary>
        /// <param name="colHistories">受診履歴コレクション</param>
        /// <param name="historyNo">履歴番号</param>
        /// <returns></returns>
        private RepHistory GetConsultHistory(RepHistories colHistories, int historyNo)
        {
            // 受診履歴コレクションが存在しない場合は何もしない
            if (colHistories == null || colHistories.Count == 0)
            {
                return null;
            }

            // 受診履歴クラスの参照設定
            return colHistories.Item(historyNo);
        }
    }

}
