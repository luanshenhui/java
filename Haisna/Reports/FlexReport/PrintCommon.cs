using System;
using System.Collections.Generic;
using Hainsi.Common;

namespace Hainsi.Reports
{
    public static class PrintCommon
    {
        // 描画オブジェクトの編集タイプ
        public const int COLUMN_TYPE_ERROR = 0;
        public const int COLUMN_TYPE_HOSPITAL = 1;
        public const int COLUMN_TYPE_ITEM = 2;
        public const int COLUMN_TYPE_CONSULT = 3;
        public const int COLUMN_TYPE_CONSULTHISTORY = 4;
        public const int COLUMN_TYPE_RESULT = 5;
        public const int COLUMN_TYPE_JUDGEMENT = 6;
        public const int COLUMN_TYPE_PERRESULT = 7;
        public const int COLUMN_TYPE_DISHISTORY = 8;
        public const int COLUMN_TYPE_FMLHISTORY = 9;
        public const int COLUMN_TYPE_RESULTOTHER = 10;
        public const int COLUMN_TYPE_RESULTOTHERALL = 11;
        public const int COLUMN_TYPE_PRIRESULT = 12;

        /// <summary>
        /// 出力項目情報
        /// </summary>
        public class COLUMN_REC
        {
            public string ColumnName { get; set; }
            public int ColumnType { get; set; }
        }

        /// <summary>
        /// フォーム単位の出力項目情報
        /// </summary>
        public class FORM_COLUMNS
        {
            public IList<COLUMN_REC> Columns = new List<COLUMN_REC>();
        }

        /// <summary>
        /// 全出力フォームの出力項目情報
        /// </summary>
        public static IList<FORM_COLUMNS> gudtFormColumns = new List<FORM_COLUMNS>();

        /// <summary>
        /// 全フォームを通じて編集対象となる検査項目コード
        /// </summary>
        public static IList<string> gstrEditItemCd = new List<string>();

        /// <summary>
        /// 全フォームを通じて編集対象となるサフィックス
        /// </summary>
        public static IList<string> gstrEditSuffix = new List<string>();

        /// <summary>
        /// 全フォームを通じて編集対象となる検査項目の数
        /// </summary>
        public static int glngEditCount;

        /// <summary>
        /// 読み込み受診歴数(今回分含む。０の場合は全受診歴)
        /// </summary>
        public static int glngGetHistoryCount;

        /// <summary>
        /// 描画オブジェクト名の解析
        /// </summary>
        /// <param name="columnName">描画オブジェクト名</param>
        /// <returns>描画オブジェクトの編集タイプ</returns>
        public static int AnalyzeColumnName(string columnName)
        {
            IList<string> token = new List<string>();   // トークン
            int ret = 0;                                // 関数戻り値

            while (true)
            {
                // 引数未指定時は解析不能
                if (string.IsNullOrEmpty(columnName))
                {
                    ret = COLUMN_TYPE_ERROR;
                    break;
                }

                // アンダースコアでカラム名を分割（最初が項目名）
                token = columnName.Split('_');

                // トークンが単数の場合
                if (token.Count == 0)
                {
                    // 病院情報の項目であるかを検索
                    if (IsHospital(token[0]))
                    {
                        ret = COLUMN_TYPE_HOSPITAL;
                    }

                    // 受診情報の項目であるかを検索
                    if (IsConsult(token[0]))
                    {
                        ret = COLUMN_TYPE_CONSULT;
                    }

                    // いずれにもヒットしなかった場合は解析不能とする
                    ret = COLUMN_TYPE_ERROR;
                    break;
                }

                // 以下はトークンが複数の場合
                // 検査結果の項目であるかを検索
                if (IsResult(token))
                {
                    ret = COLUMN_TYPE_RESULT;
                    break;
                }

                // 検査項目情報の項目であるかを検索
                if (IsItem(token))
                {
                    ret = COLUMN_TYPE_ITEM;
                    break;
                }

                // 受診履歴の項目であるかを検索
                if (IsConsultHistory(token))
                {
                    ret = COLUMN_TYPE_CONSULTHISTORY;
                    break;
                }

                // 判定結果の項目であるかを検索
                if (IsJudgement(token))
                {
                    ret = COLUMN_TYPE_JUDGEMENT;
                    break;
                }

                // 個人検査結果の項目であるかを検索
                if (IsPerResult(token))
                {
                    ret = COLUMN_TYPE_PERRESULT;
                    break;
                }

                // 既往歴の項目であるかを検索
                if (IsDisHistory(token))
                {
                    ret = COLUMN_TYPE_DISHISTORY;
                    break;
                }

                // 家族歴の項目であるかを検索
                if (IsFmlHistory(token))
                {
                    ret = COLUMN_TYPE_FMLHISTORY;
                    break;
                }

                // その他検査結果の項目であるかを検索
                if (IsResultOther(token))
                {
                    ret = COLUMN_TYPE_RESULTOTHER;
                    break;
                }

                // その他検査結果(全件指定)の項目であるかを検索
                if (IsResultOtherAll(token))
                {
                    ret = COLUMN_TYPE_RESULTOTHERALL;
                    break;
                }

                // 優先順位順検査結果の項目であるかを検索
                if (IsPriResult(token))
                {
                    ret = COLUMN_TYPE_PRIRESULT;
                    break;
                }

                // いずれにもヒットしなかった場合は解析不能とする
                ret = COLUMN_TYPE_ERROR;
                break;
            }

            return ret;

        }

        /// <summary>
        /// 病院情報の項目であるかを検索
        /// </summary>
        /// <param name="columnName">描画オブジェクト名</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsHospital(string columnName)
        {
            bool ret = true;

            // 病院情報の項目であるかを検索
            switch (ExceptReplicationSign(columnName))
            {
                case "HSPNAME":
                case "HSPCENTER":
                case "HSPZIPCD":
                case "HSPADDRESS1":
                case "HSPADDRESS2":
                case "HSPTEL":
                case "HSPFAX":
                case "HSPINLINENO":
                    break;
                default:
                    ret = false;
                    break;
            }

            return ret;
        }

        /// <summary>
        /// 受診情報の項目であるかを検索
        /// </summary>
        /// <param name="columnName">描画オブジェクト名</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsConsult(string columnName)
        {
            bool ret = true;

            // 受診情報の項目であるかを検索
            switch (ExceptReplicationSign(columnName))
            {
                case "RSVNO":
                case "BCDRSVNO":
                case "CSLDATE":
                case "CSLDATEM":
                case "CSLYEARAD":
                case "CSLYEARJP":
                case "CSLYEARGE":
                case "CSLMONTH":
                case "CSLDAY":
                case "CNTLNO":
                case "DAYID":
                case "DAYIDM":
                case "PERID":
                case "LASTNAME":
                case "FIRSTNAME":
                case "LASTKNAME":
                case "FIRSTKNAME":
                case "NAME":
                case "KNAME":
                case "BIRTH":
                case "BIRTHYEARAD":
                case "BIRTHYEARJP":
                case "BIRTHYEARGE":
                case "BIRTHMONTH":
                case "BIRTHDAY":
                case "GENDER":
                case "PREFNAME":
                case "ZIPCD1":
                case "ZIPCD2":
                case "CITYNAME":
                case "ADDRESS1":
                case "ADDRESS2":
                case "ISRNO":
                case "ISRSIGN":
                case "ISRMARK":
                case "HEISRNO":
                case "ISRDIV":
                case "RESIDENTNO":
                case "UNIONNO":
                case "KARTE":
                case "EMPNO":
                case "CSCD":
                case "CSNAME":
                case "ORGCD1":
                case "ORGCD2":
                case "ORGKNAME":
                case "ORGNAME":
                case "ORGSNAME":
                case "TIMEFRA":
                case "RSVDATE":
                case "AGE":
                case "AGEMONTH":
                case "DOCTORCD":
                case "DOCTORNAME":
                case "FREEDIV":
                case "REPORTPRINTDATE":
                case "REPORTVERSION":
                case "RECOGNO":
                case "GOVNO":
                case "FIRSTRSVNO":
                case "GOVMNG":
                case "GOVMNG12DIV":
                case "GOVMNGDIV":
                case "GOVMNGSHAHO":
                case "CSLCOUNT":
                case "ORGBSDCD":
                case "ORGBSDNAME":
                case "ORGBSDKNAME":
                case "ORGROOMCD":
                case "ORGROOMNAME":
                case "ORGROOMKNAME":
                case "ORGPOSTCD":
                case "ORGPOSTNAME":
                case "ORGPOSTKNAME":
                case "JOBCD":
                case "JOBNAME":
                case "DUTYCD":
                case "DUTYNAME":
                case "QUALIFYCD":
                case "QUALIFYNAME":
                case "HONGENDIV":
                case "NIGHTDUTYFLG":
                case "HIREDATE":
                    break;
                default:
                    ret = false;
                    break;
            }

            return ret;

        }

        /// <summary>
        /// 検査結果の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsResult(IList<string> token)
        {
            int tokenCount;     // トークン数
            bool blnHistoryNo;     // 履歴番号の存在有無
            int itemCount;      // 項目名において指定中の検査項目数
            bool ret;           // 関数戻り値

            // 初期処理
            ret = false;

            // トークン数の取得
            tokenCount = token.Count;

            // 一番最後のトークンは履歴番号か？
            blnHistoryNo = IsInteger(token[tokenCount - 1]);

            // トークン数から項目名を除外し、更に存在時は履歴番号を除外した残りの数が指定検査項目数となる
            itemCount = tokenCount - 1 - (blnHistoryNo ? 1 : 0);

            while (true)
            {
                // 検査項目数が０以下ならば検査結果ではない
                if (itemCount <= 0)
                {
                    return ret;
                }

                // １番目のトークンによる処理分岐
                switch (ExceptReplicationSign(token[0]))
                {
                    case "RESULT":
                    case "SHORTSTC":
                    case "LONGSTC":
                    case "ENGSTC":
                        // 検査結果、略文章、文章、英語文章
                        break;
                    case "RSLCMTCD1":
                    case "RSLCMTNAME1":
                    case "RSLCMTCD2":
                    case "RSLCMTNAME2":
                    case "STDVALUECD":
                    case "ABNORMALMARK":
                        // 結果コメント1、結果コメント名1、結果コメント2、結果コメント名2、基準値コード、異常値マーク
                        if (itemCount != 1)
                        {
                            return ret;
                        }
                        break;
                    case "MULTIRESULT":
                        // 複数検査結果
                        if (itemCount == 1)
                        {
                            return ret;
                        }

                        // ２番目のトークンが"OTHER"の場合はその他検査結果
                        if (token[1].ToUpper() == "OTHER")
                        {
                            return ret;
                        }
                        break;
                    default:
                        return ret;
                }

                // トークンの２番目から指定検査項目数分のトークンに対し、検査項目コードとして認識可能かをチェック
                for (int k = 0; k <= itemCount; k++)
                {
                    if (!IsItemCd(token[k]))
                    {
                        return ret;
                    }
                }

                ret = true;
                break;
            }

            return ret;

        }

        /// <summary>
        /// 検査項目コードであるかを検索
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        public static bool IsItemCd(string itemCd)
        {
            IList<string> token = new List<string>();   // トークン
            bool ret = false;                           // 関数戻り値

            while (true)
            {
                // 引数未指定時は何もしない
                if (string.IsNullOrEmpty(itemCd))
                {
                    break;
                }

                // ハイフンでカラム名を分割（１番目が項目コード、２番目がサフィックス）
                token = itemCd.Split('-');

                // トークン数が２個でなければ検査項目コードではない
                if (token.Count != 2)
                {
                    break;
                }

                // いずれかが存在しない場合は検査項目コードではない
                if (string.IsNullOrEmpty(token[0]) || string.IsNullOrEmpty(token[1]))
                {
                    break;
                }

                // 項目コード長チェック
                if (token[0].Length > 6)
                {
                    break;
                }

                // サフィックス長チェック
                if (token[1].Length > 2)
                {
                    break;
                }

                ret = true;
                break;
            }

            return ret;

        }

        /// <summary>
        /// 検査項目情報の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsItem(IList<string> token)
        {
            bool ret = false;       // 関数戻り値

            while (true)
            {
                // 検査項目情報は「項目名称」＋「検査項目コード」であるため、トークン数が２以外なら履歴ではない
                if (token.Count != 2)
                {
                    return ret;
                }

                // ２番目のトークンが検査項目コードとして認識できなければ履歴ではない
                if (!IsItemCd(token[1]))
                {
                    return ret;
                }

                // 検査項目情報の項目であるかを検索
                switch (ExceptReplicationSign(token[0]))
                {
                    case "ITEMRNAME":
                    case "ITEMENAME":
                    case "ITEMQNAME":
                    case "UNIT":
                    case "LOWERVALUE":
                    case "UPPERVALUE":
                        break;
                    default:
                        return ret;
                }

                ret = true;
                break;
            }

            return ret;
        }

        /// <summary>
        /// 受診履歴の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsConsultHistory(IList<string> token)
        {
            string buffer = string.Empty;   // 文字列バッファ
            bool ret = false;

            while (true)
            {
                // 受診履歴は「項目名称」＋「履歴番号」であるため、トークン数が２以外なら履歴ではない
                if (token.Count != 2)
                {
                    return ret;
                }

                // ２番目のトークンが履歴番号として認識できなければ履歴ではない
                if (!IsInteger(token[1]))
                {
                    return ret;
                }

                // 受診履歴の項目であるかを検索
                switch (ExceptReplicationSign(token[0]))
                {
                    case "CSLDATE":
                    case "CSLDATEM":
                    case "CSLYEARAD":
                    case "CSLYEARJP":
                    case "CSLYEARGE":
                    case "CSLMONTH":
                    case "CSLDAY":
                    case "CNTLNO":
                    case "DAYID":
                    case "DAYIDM":
                    case "CSCD":
                    case "CSNAME":
                        break;
                    default:
                        return ret;
                }

                ret = true;
                break;
            }

            return ret;
        }

        /// <summary>
        /// 判定結果の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsJudgement(IList<string> token)
        {
            int tokenCount;     // トークン数
            bool ret = true;   // 関数戻り値

            // トークン数の取得
            tokenCount = token.Count;

            while (true)
            {
                // １番目のトークンによる処理分岐
                switch (ExceptReplicationSign(token[0]))
                {
                    case "JUDCLASSNAME":
                    case "JUDCD":
                    case "JUDRNAME":
                    case "GOVMNGJUD":
                    case "GOVMNGJUDNAME":
                    case "DOCTORNAME":
                    case "FREEJUDCMT":
                    case "STDJUDCD":
                    case "STDJUDNOTE":
                    case "GUIDANCESTC":
                        break;
                    default:
                        return ret = false;
                }

                // トークン数による処理分岐
                switch (tokenCount)
                {
                    case 2:
                        // トークン数が２個であれば判定結果である
                        return ret;
                    case 3:
                        // ３番目のトークンが数値として認識できれば判定結果である
                        // (３番目のトークンは、定型所見の場合は履歴番号または今回定型所見のSEQ、それ以外の場合は履歴番号である)
                        if (IsInteger(token[2]))
                        {
                            return ret;
                        }
                        break;
                    case 4:
                        // トークン数が４個の場合
                        switch ((token[0]).ToUpper())
                        {
                            case "STDJUDCD":
                            case "STDJUDNOTE":
                                break;
                            default:
                                return ret = false;
                        }

                        // 但し全判定分類指定の場合は４番目のトークン(SEQ)を指定することはないため、判定結果でないとみなす
                        if ("ALL".Equals(token[1].ToUpper()))
                        {
                            return ret = false;
                        }

                        // ３番目、４番目のトークンがともに数値として認識できれば判定結果である
                        if (IsInteger(token[2]) && IsInteger(token[3]))
                        {
                            return ret = false;
                        }

                        break;
                    default:
                        return ret;
                }

                ret = true;
                break;
            }

            return ret;
        }

        /// <summary>
        /// 個人検査結果の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsPerResult(IList<string> token)
        {
            bool ret = true;

            while (true)
            {
                // 個人検査結果は「項目名称」＋(「検査項目コード」または「SEQ」または「"ALL"」)であるため、
                // トークン数が２以外なら個人検査結果ではない
                if (token.Count != 2)
                {
                    ret = false;
                    break;
                }

                // ２番目のトークンが"ALL"でない場合
                if (!"ALL".Equals(token[1].ToUpper()))
                {
                    // 検査項目コードともSEQとも認識できなければ個人検査結果ではない
                    if (!IsItemCd(token[1]) && !IsInteger(token[1]))
                    {
                        ret = false;
                        break;
                    }
                }

                // 個人検査結果の項目であるかを検索
                switch (ExceptReplicationSign(token[0]))
                {
                    case "PERITEMRNAME":
                    case "PERITEMENAME":
                    case "PERRESULT":
                    case "PERSHORTSTC":
                    case "PERLONGSTC":
                    case "PERENGSTC":
                    case "PERISPDATE":
                    case "PERISPYEARAD":
                    case "PERISPYEARJP":
                    case "PERISPYEARGE":
                    case "PERISPMONTH":
                    case "PERISPDAY":
                        break;
                    default:
                        ret = false;
                        break;
                }

                break;
            }

            return ret;
        }

        /// <summary>
        /// 既往歴の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsDisHistory(IList<string> token)
        {
            bool ret = true;

            while (true)
            {
                // 既往歴は「項目名称」＋(「SEQ」または「"ALL"」)であるため、
                // トークン数が２以外なら個人検査結果ではない
                if (token.Count != 2)
                {
                    ret = false;
                    break;
                }

                // ２番目のトークンが"ALL"でない場合
                if (!"ALL".Equals(token[1].ToUpper()))
                {
                    // 検査項目コードともSEQとも認識できなければ個人検査結果ではない
                    if (!IsInteger(token[1]))
                    {
                        ret = false;
                        break;
                    }
                }

                // 既往歴の項目であるかを検索
                switch (ExceptReplicationSign(token[0]))
                {
                    case "MYDISCD":
                    case "MYDISNAME":
                    case "MYSTRDATE":
                    case "MYSTRYEARAD":
                    case "MYSTRYEARJP":
                    case "MYSTRYEARGE":
                    case "MYSTRMONTH":
                    case "MYENDDATE":
                    case "MYENDYEARAD":
                    case "MYENDYEARJP":
                    case "MYENDYEARGE":
                    case "MYENDMONTH":
                    case "MYCONDITION":
                    case "MYMEDICAL":
                        break;
                    default:
                        ret = false;
                        break;
                }

                break;
            }

            return ret;
        }

        /// <summary>
        /// 家族歴の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)'</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsFmlHistory(IList<string> token)
        {
            bool ret = true;

            while (true)
            {
                // 家族歴は「項目名称」＋(「SEQ」または「"ALL"」)であるため、
                // トークン数が２以外なら個人検査結果ではない
                if (token.Count != 2)
                {
                    ret = false;
                    break;
                }

                // ２番目のトークンが"ALL"でない場合
                if (!"ALL".Equals(token[1].ToUpper()))
                {
                    // 検査項目コードともSEQとも認識できなければ個人検査結果ではない
                    if (!IsInteger(token[1]))
                    {
                        ret = false;
                        break;
                    }
                }

                // 家族歴の項目であるかを検索
                switch (ExceptReplicationSign(token[0]))
                {
                    case "FMLRELATION":
                    case "FMLDISCD":
                    case "FMLDISNAME":
                    case "FMLSTRDATE":
                    case "FMLSTRYEARAD":
                    case "FMLSTRYEARJP":
                    case "FMLSTRYEARGE":
                    case "FMLSTRMONTH":
                    case "FMLENDDATE":
                    case "FMLENDYEARAD":
                    case "FMLENDYEARJP":
                    case "FMLENDYEARGE":
                    case "FMLENDMONTH":
                    case "FMLCONDITION":
                    case "FMLMEDICAL":
                        break;
                    default:
                        ret = false;
                        break;
                }

                break;
            }

            return ret;
        }

        /// <summary>
        /// その他検査結果の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsResultOther(IList<string> token)
        {
            int tokenCount = 0;     // トークン数
            bool ret = true;        // 関数戻り値

            // トークン数の取得
            tokenCount = token.Count;

            while (true)
            {
                // その他検査結果は「項目名称」＋「OTHER」＋「SEQ」あるいは「項目名称」＋「OTHER」＋「履歴番号」＋「SEQ」であるため、
                // トークン数が3、4以外ならその他検査結果ではない
                if (!(tokenCount == 3 || tokenCount == 4))
                {
                    ret = false;
                    break;
                }

                // １番目のトークンによる処理分岐
                switch (ExceptReplicationSign(token[0]))
                {
                    case "ITEMRNAME":
                    case "ITEMENAME":
                    case "ITEMQNAME":
                    case "RESULT":
                    case "SHORTSTC":
                    case "LONGSTC":
                    case "ENGSTC":
                    case "RSLCMTCD1":
                    case "RSLCMTNAME1":
                    case "RSLCMTCD2":
                    case "RSLCMTNAME2":
                    case "STDVALUECD":
                    case "MULTIRESULT":
                        break;
                    default:
                        return false;
                }

                // ２番目のトークンが"OTHER"でなければその他検査結果ではない
                if (!"OTHER".Equals(token[1].ToUpper()))
                {
                    ret = false;
                    break;
                }

                // ３番目のトークンが数値として認識できなければその他検査結果ではない
                if (!IsInteger(token[2]))
                {
                    ret = false;
                    break;
                }

                // トークン数が４個の場合
                if (tokenCount == 4)
                {
                    // 数値として認識できなければその他検査結果ではない
                    if (!IsInteger(token[3]))
                    {
                        ret = false;
                        break;
                    }
                }

                break;
            }

            return ret;

        }

        /// <summary>
        /// その他検査結果(全件指定)の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsResultOtherAll(IList<string> token)
        {
            int tokenCount = 0;     // トークン数
            bool ret = false;        // 関数戻り値

            // トークン数の取得
            tokenCount = token.Count;

            while (true)
            {
                // その他検査結果(全件指定)は「項目名称」＋「OTHER」＋「ALL」あるいは「項目名称」＋「OTHER」＋「履歴番号」＋「ALL」であるため、
                // トークン数が3、4以外ならその他検査結果ではない
                if (!(tokenCount == 3 || tokenCount == 4))
                {
                    ret = false;
                    break;
                }

                // １番目のトークンによる処理分岐
                switch (ExceptReplicationSign(token[0]))
                {
                    case "ITEMRNAME":
                    case "ITEMENAME":
                    case "ITEMQNAME":
                    case "RESULT":
                    case "SHORTSTC":
                    case "LONGSTC":
                    case "ENGSTC":
                    case "RSLCMTCD1":
                    case "RSLCMTNAME1":
                    case "RSLCMTCD2":
                    case "RSLCMTNAME2":
                    case "STDVALUECD":
                    case "MULTIRESULT":
                        break;
                    default:
                        return ret;
                }

                // ２番目のトークンが"OTHER"でなければその他検査結果ではない
                if (!"OTHER".Equals(token[1].ToUpper()))
                {
                    ret = false;
                    break;
                }

                switch (tokenCount)
                {
                    case 3:
                        // 全件指定でなければその他検査結果(全件指定)ではない
                        if (!"ALL".Equals(token[2].ToUpper()))
                        {
                            return ret;
                        }
                        break;

                    case 4:
                        // ３番目のトークンが数値として認識できなければその他検査結果(全件指定)ではない
                        if (!IsInteger(token[2]))
                        {
                            return ret;
                        }

                        // ４番目のトークンが全件指定でなければその他検査結果(全件指定)ではない
                        if (!"ALL".Equals(token[3].ToUpper()))
                        {
                            return ret;
                        }
                        break;
                }

                ret = true;
                break;
            }

            return ret;
        }

        /// <summary>
        /// 優先順位順検査結果の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン(項目名をアンダースコアで分割した配列)</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        private static bool IsPriResult(IList<string> token)
        {
            int tokenCount = 0;     // トークン数
            bool blnHistoryNo;      // 履歴番号の存在有無
            bool ret = false;       // 関数戻り値
            int itemCount = 0;      // 項目名において指定中の検査項目数

            // トークン数の取得
            tokenCount = token.Count;

            // 一番最後のトークンは履歴番号か？
            blnHistoryNo = IsInteger(token[token.Count - 1]);

            // トークン数から項目名を除外し、更に存在時は履歴番号を除外した残りの数が指定検査項目数となる
            itemCount = tokenCount - 1 - (blnHistoryNo ? 1 : 0);

            while (true)
            {
                // 検査項目数が０以下ならば検査結果ではない
                if (0 >= itemCount)
                {
                    break;
                }

                // １番目のトークンによる処理分岐
                switch (ExceptReplicationSign(token[0]))
                {
                    case "PRISHORTSTC":
                    case "PRILONGSTC":
                    case "PRIENGSTC":
                        break;
                    default:
                        return ret;
                }

                // トークンの２番目から指定検査項目数分のトークンに対し、検査項目コードとして認識可能かをチェック
                for (int i = 1; i<= itemCount; i++)
                {
                    if (!IsItemCd(token[i]))
                    {
                        break;
                    }
                }

                ret = true;
                break;

            }

            return ret;

        }


        /// <summary>
        /// 文字列後部の＃を除外
        /// </summary>
        /// <param name="epression">描画オブジェクト名</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        public static string ExceptReplicationSign(string epression)
        {
            string buffer = string.Empty;  // 文字列バッファ

            buffer = epression == null ? "" : epression.Trim();
            if (string.IsNullOrEmpty(buffer))
            {
                return buffer;
            }

            while (buffer.Substring(buffer.Length - 1, 1) == "#")
            {
                buffer = buffer.Substring(buffer.Length - 1);
            }

            return buffer;
        }

        /// <summary>
        /// 正の整数であるかを検索
        /// </summary>
        /// <param name="expression">文字列式</param>
        /// <returns>
        /// True   はい
        /// False  いいえ
        /// </returns>
        public static bool IsInteger(string expression)
        {
            bool ret = false;       // 関数戻り値

            while (true)
            {
                // 引数未指定時は何もしない
                if (string.IsNullOrEmpty(expression))
                {
                    break;
                }

                // 文字列を１文字ずつチェック
                for (int i = 0; i < expression.Length; i++)
                {
                    if ("0123456789".IndexOf(expression.Substring(i, 1)) < 0)
                    {
                        break;
                    }
                }

                // ゼロは許さない
                if (Convert.ToInt32(expression) == 0)
                {
                    break;
                }

                ret = true;
                break;
            }

            return ret;
        }

        /// <summary>
        /// 引数値（エラーコード）に相当する、CoReportsドキュメント生成時の日本語エラーメッセージを取得
        /// </summary>
        /// <param name="crDrawErr">エラーコード</param>
        /// <returns>日本語エラーメッセージ</returns>
        public static string GetErrorMessage(int crDrawErr)
        {
            string message = "error : " + crDrawErr.ToString();
            // TODO
            return message;

        }

    }
}
