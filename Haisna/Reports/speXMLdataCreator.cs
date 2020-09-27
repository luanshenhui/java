using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using Microsoft.VisualBasic;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class speXMLdataCreator : SpeXmlCreator
    {

        /// <summary>
        /// 契約オプションコード
        /// </summary>
        private const string OPTCD1 = "1000";
        private const string OPTCD2 = "1001";

        /// <summary>
        /// 対象コース
        /// </summary>
        private const string CSCD1 = "100";
        private const string CSCD2 = "105";
        private const string CSCD3 = "110";

        /// <summary>
        /// 住所区分
        /// </summary>
        private const string ADDRDIV = "1";

        /// <summary>
        /// 汎用マスタ
        /// </summary>
        private const string FREE_XMLXSDPATH = "XMLXSDPATH";
        private const string FREE_XMLSENDORG = "XMLSENDORG";
        private const string FREE_XMLDOCOFORG = "XMLDOCOFORG";
        private const string FREE_XMLTSPORG = "XMLTSPORG";
        private const string FREE_XMLKNDDIV = "XMLKNDDIV";        
        private const string FREE_XMLPGKNDNM = "XMLPGKNDNM";
        private const string FREE_XMLRFCLIMFLG = "XMLRFCLIMFLG";
        private const string FREE_XMLJUDDATE = "XMLJUDDATE";
        private const string FREE_XMLGROUP = "XMLGROUP";
        private const string FREE_XMLINPLIM = "XMLINPLIM";
        private const string FREE_XMLREQUIR = "XMLREQUIR";
        private const string FREE_XMLDISJCMT = "XMLDISJCMT";
        private const string FREE_XMLFIXED = "XMLFIXED";
        private const string FREE_XMLDISEASE = "XMLDISEASE";
        private const string FREE_XMLMEDICINE = "XMLMEDIC";
        private const string FREE_XMLSPESTC = "XMLSPESTC";
        private const string FREE_XMLWEIGHT = "XMLWEIGHTITM";
        private const string FREE_XMLIBUITEM = "XMLIBUITEM";
        private const string FREE_XMLJUDCLSCOND = "XMLCONDI";
        private const string FREE_XMLDTLITM = "XMLDTLITM";
        private const string FREE_XMLCDASEC = "XMLCDASEC";        
        private const string FREE_METADIS = "METADIS";
        private const string FREE_METASTS = "METASTS";
        private const string FREE_METACMT = "METACMT";
        private const string FREE_GYNECLASS = "GYNECLASS";
        private const string FREECLASS_KINDDIV = "KINDDIV";
        private const string FREECLASS_PGKINDNAME = "PGKINDNAME";
        private const string FREECLASS_MTA = "MTA";
        private const string FREECLASS_GYN = "GYN";
        private const string FREECLASS_ANM = "ANM";
        private const string FREECLASS_ECG = "ECG";
        private const string FREECLASS_EGD = "EGD";
        private const string FREECLASS_CRE = "CRE";

        /// <summary>
        /// JLAC10 変換タイプ
        /// </summary>
        private const string CONVTYPE_COEFFICIENT = "0";    // 0…数値・文字列（係数）
        private const string CONVTYPE_REPLACE = "1";        // 1…数値・文字列（置換）
        private const string CONVTYPE_COMPARE = "2";        // 2…数値比較
        private const string CONVTYPE_FIND = "3";           // 3…検索
        private const string CONVTYPE_DATE = "4";           // 4…年月日
        private const string CONVTYPE_CONST = "5";          // 5…固定値
        private const string CONVTYPE_JUDGE = "6";          // 6…判定結果
        private const string CONVTYPE_JUDGECOMMENT = "7";   // 7…判定コメント
        private const string CONVTYPE_DRNAME = "8";         // 8…医師名

        /// <summary>
        /// JLAC10 結果タイプ
        /// </summary>
        private const string RESULTTYPE_NUMBER = "0";       // 数値 数値
        private const string RESULTTYPE_DEFINED_REG = "1";  // 定性（標準）
        private const string RESULTTYPE_DEFINED_EX = "2";   // 定性（拡張）
        private const string RESULTTYPE_FREE = "3";         // フリー 文字列(rsl)
        private const string RESULTTYPE_SENTENCE = "4";     // 文章 文字列(sentence)
        private const string RESULTTYPE_CALC = "5";         // 計算 数値(rsl)
        private const string RESULTTYPE_DATE = "6";         // 日付 日付(rsl)
        private const string RESULTTYPE_MEMO = "7";         // メモ 文字列(rslmemo)
        private const string RESULTTYPE_SIGN = "8";         // 符号つき数値(rsl)

        /// <summary>
        /// JLAC10 変換条件文字
        /// </summary>
        private const string CONDITION_EXISTS = "exists";
        private const string CONDITION_NOTEXISTS = "notexists";
        private const string CONDITION_NULL = "null";

        /// <summary>
        /// JLAC10 変換ルール
        /// </summary>
        private const string CONVRULE_ALL = "*";
        private const string CONVRULE_NULL = "null";
        private const string CONVRULE_ALLNULL = "allnull";

        /// <summary>
        /// XML項目タイプ
        /// </summary>
        private const string XMLTYPE_ST = "ST";
        private const string XMLTYPE_PQ = "PQ";

        /// <summary>
        /// XML結果解釈コード
        /// </summary>
        private const string XMLRSLINTERPRETATION_N = "N";
        private const string XMLRSLINTERPRETATION_L = "L";
        private const string XMLRSLINTERPRETATION_H = "H";

        /// <summary>
        /// 変換後文字列
        /// </summary>
        private const string CONVAFTER_ITEMNAME = "itemname";
        private const string CONVAFTER_SHORTNAME = "shortname";
        private const string CONVAFTER_REPORTNAME = "reportname";
        private const string CONVAFTER_QUESTIONNAME = "questionname";
        private const string CONVAFTER_NULL = "null";

        /// <summary>
        /// 固定文字列
        /// </summary>
        private const string FIXEDTEXT = "FIXEDTEXT";

        /// <summary>
        /// ＸＭＬ名前空間
        /// </summary>
        private const string XML_NAMESPACE = "http://www.w3.org/2001/XMLSchema-instance";

        /// <summary>
        /// JLAC10特殊処理情報
        /// </summary>
        private List<string> Jlac10CdPressure { get; set; }
        private List<bool> ResultPressure { get; set; }
        private List<int> PosItem { get; set; }
        private List<string> XmlResultBloodPressure { get; set; }
        private List<dynamic> NotOutJlac10Cd { get; set; }
        private IDictionary<string, string> RequiredJlac10Cd { get; set; }

        /// <summary>
        /// 結果情報構造体
        /// </summary>
        private struct RESULT_INFO
        {
            public int rsvno;
            public string itemcd;
            public string suffix;
            public string itemname;
            public string itemsname;
            public string itemrname;
            public string itemqname;
            public string rsltype;
            public string csldate;
            public string result;
            public string judrsl;
            public string sentence;
            public string stdflg;
            public string uppervalue;
            public string lowervalue;
        };

        /// <summary>
        /// XML結果情報構造体
        /// </summary>
        private struct XML_RESULT_INFO
        {
            public string result;
            public string unit;
            public string stdflg;
            public string uppervalue;
            public string lowervalue;
            public bool getflg;
        };

        /// <summary>
        /// 血圧特殊処理の添字
        /// </summary>
        private enum BLOOD_PRESSURE
        {
            Shushuku0 = 0,  // 収縮期（その他）
            Shushuku2 = 1,  // 収縮期（２回目）
            Shushuku1 = 2,  // 収縮期（１回目）
            Kakuchou0 = 3,  // 拡張期（その他）
            Kakuchou2 = 4,  // 拡張期（２回目）
            Kakuchou1 = 5,  // 拡張期（１回目）
        }

        /// <summary>
        /// 血圧特殊処理 XML出力項目の添字
        /// </summary>
        private enum XML_BLOOD_PRESSURE
        {
            Shushuku = 0,   // 収縮期血圧
            Kakuchou = 1,   // 拡張期血圧
        }

        /// <summary>
        /// JLAC10エラー区分
        /// </summary>
        private enum ERROR_DIV
        {
            ConvCondition = 0,  // 変換条件不正
            Result = 1,         // 結果不正
            StdValue = 2,       // 基準値不正
            ResultType = 3,     // 結果タイプ不正
            ConvRule = 4,       // 変換ルール不正
        }

        /// <summary>
        /// XMLセクション区分
        /// </summary>
        private enum XMLSEC_DIV
        {
            None = 0,           // セクションを考慮しない
            Specific = 1,       // 特定健診セクション
            Other = 2,          // 任意追加項目セクション
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["strcsldate"], out DateTime tmpStrDate))
            {
                messages.Add("開始受診日の入力形式が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["endcsldate"], out DateTime tmpEndDate))
            {
                messages.Add("終了受診日の入力形式が正しくありません。");
            }

            int strNendo = tmpStrDate.AddMonths(-3).Year;
            int endNendo = tmpEndDate.AddMonths(-3).Year;

            if (strNendo != endNendo)
            {
                messages.Add("年度をまたいでの受診日指定はできません。");
            }

            if (string.IsNullOrEmpty(queryParams["orgcd11"])
                && string.IsNullOrEmpty(queryParams["orgcd21"])
                && string.IsNullOrEmpty(queryParams["orgcd31"])
                && string.IsNullOrEmpty(queryParams["orgcd41"])
                && string.IsNullOrEmpty(queryParams["orgcd51"])
                && string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                messages.Add("団体を選択してください。");
            }

            if (queryParams["orgbill"] == "1"
                && string.IsNullOrEmpty(queryParams["billorgcd1"]))
            {
                messages.Add("請求対象団体を選択してください。");
            }

            if (string.IsNullOrEmpty(queryParams["seq"])
                || !Util.IsNumber(queryParams["seq"]))
            {
                messages.Add("シーケンス番号が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 特定健診ＸＭＬ対象データ読み込み
        /// </summary>
        /// <returns>特定健診ＸＭＬ対象データ</returns>
        protected override List<dynamic> GetData()
        {
            // ログリスト初期化
            logTextInfo = new List<string>();

            // 特殊処理情報取得
            InitJlac10SpecialInfo();

            List<dynamic> data;
            if (queryParams["orgbill"] == "1")
            {
                // 団体請求対象者のみ
                data = SelectAbsenceListFile_Bill();
            }
            else
            {
                data = SelectAbsenceListFile();
            }

            return data;

        }

        /// <summary>
        /// 特定健診ＸＭＬ対象データ取得
        /// </summary>
        /// <returns>対象データ</returns>
        private List<dynamic> SelectAbsenceListFile()
        {

            bool optOrgCd = false;
            if (!string.IsNullOrEmpty(queryParams["orgcd11"]) || !string.IsNullOrEmpty(queryParams["orgcd12"])
                || !string.IsNullOrEmpty(queryParams["orgcd21"]) || !string.IsNullOrEmpty(queryParams["orgcd22"])
                || !string.IsNullOrEmpty(queryParams["orgcd31"]) || !string.IsNullOrEmpty(queryParams["orgcd32"])
                || !string.IsNullOrEmpty(queryParams["orgcd41"]) || !string.IsNullOrEmpty(queryParams["orgcd42"])
                || !string.IsNullOrEmpty(queryParams["orgcd51"]) || !string.IsNullOrEmpty(queryParams["orgcd52"]))
            {
                optOrgCd = true;
            }

            string sql = @"
                    select
                        to_char(consult.csldate, 'YYYYMMDD') csldate
                        , consult.rsvno rsvno
                        , person.perid perid
                        , person.gender gender
                        , to_char(person.birth, 'YYYYMMDD') birth
                        , decode( 
                            length(peraddr.zipcd)
                            , 7
                            , substr(peraddr.zipcd, 1, 3) || '-' || substr(peraddr.zipcd, 4)
                            , peraddr.zipcd
                        ) zipcd
                        , pref.prefname || peraddr.cityname || peraddr.address1 || peraddr.address2 address
                        , consult.isrsign isrsign
                        , nvl(consult.isrmanno, org.spare1) isrorgno
                        , consult.isrno isrno
                        , consult.csldivcd csldivcd
                        , free.freefield1 csldivname
                        , person.lastkname || person.firstkname kname
                        , person.lastname || person.firstname name
                        , person.romename romename
                        , consult.cscd cscd
                        , course_p.csname csname
                        , consult.orgcd1 orgcd1
                        , consult.orgcd2 orgcd2
                        , consult.rsvgrpcd rsvgrpcd
                        , rsvgrp.rsvgrpname rsvgrpname
                        , decode( 
                            ( 
                                select
                                    min(ctrpt_opt.setclasscd) 
                                from
                                    consult_o
                                    , ctrpt_opt 
                                where
                                    consult.rsvno = consult_o.rsvno 
                                    and consult_o.optcd in (:optcd1, :optcd2) 
                                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                                    and consult_o.optcd = ctrpt_opt.optcd 
                                    and consult_o.optbranchno = ctrpt_opt.optbranchno
                            ) 
                            , '001'
                            , '23040'
                            , '035'
                            , '23040'
                            , '002'
                            , '23130'
                            , '003'
                            , '23130'
                            , '00000'
                        ) as setclass
                        , to_char(sysdate, 'YYYYMMDD') as outdate
                        , consult.rfcno rfcno
                    from
                        consult
                        , person
                        , peraddr
                        , receipt
                        , free
                        , course_p
                        , pref
                        , org
                        , rsvgrp 
                    where
                        consult.csldate between :frdate and :todate 
                        and consult.cancelflg = :cancelflg
            ";

            switch (queryParams["coursecd"])
            {
                case CSCD1:
                    sql += @"   and consult.cscd = :cscd1 ";
                    break;

                case CSCD2:
                    sql += @"   and consult.cscd = :cscd2 ";
                    break;

                case CSCD3:
                    sql += @"   and consult.cscd = :cscd3 ";
                    break;

                default:
                    sql += @"   and consult.cscd in (:cscd1, :cscd2, :cscd3) ";
                    break;
            }

            sql += @"
                        and consult.csldivcd = free.freecd 
                        and consult.perid = person.perid 
                        and person.perid = peraddr.perid 
                        and peraddr.prefcd = pref.prefcd(+) 
                        and peraddr.addrdiv = :addrdiv 
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null 
                        and consult.cscd = course_p.cscd 
                        and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2
                ";

            if (optOrgCd || !string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                sql += @"   and ( ";

                // 団体グループコード
                if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                {
                    sql += @"
                            (consult.orgcd1, consult.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                        ";
                }
                // 団体コード
                if (optOrgCd)
                {
                    if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                    {
                        sql += @"   or";
                    }
                    sql += @"
                            consult.orgcd1 || consult.orgcd2 in ( 
                                :orgcd10
                                , :orgcd20
                                , :orgcd30
                                , :orgcd40
                                , :orgcd50
                            ) 
                        ";
                }
                sql += @"   ) ";
            }

            // 受診区分
            if (!string.IsNullOrEmpty(queryParams["csldiv"]))
            {
                sql += @"   and consult.csldivcd = :csldiv ";
            }

            // 請求書出力区分
            if (!string.IsNullOrEmpty(queryParams["billprint"]))
            {
                sql += @"   and consult.billprint = :billprint ";
            }

            sql += @"
                    order by
                        nvl(consult.isrmanno, org.spare1)
                        , consult.orgcd1
                        , consult.orgcd2
                        , consult.csldate
                        , receipt.dayid
                ";

            var sqlParam = new
            {
                frdate = queryParams["strcsldate"],
                todate = queryParams["endcsldate"],
                orgcd10 = queryParams["orgcd11"] + queryParams["orgcd12"],
                orgcd20 = queryParams["orgcd21"] + queryParams["orgcd22"],
                orgcd30 = queryParams["orgcd31"] + queryParams["orgcd32"],
                orgcd40 = queryParams["orgcd41"] + queryParams["orgcd42"],
                orgcd50 = queryParams["orgcd51"] + queryParams["orgcd52"],
                orggrpcd = queryParams["orggrpcd"],
                csldivcd = queryParams["csldivcd"],
                csldiv = queryParams["csldiv"],
                billprint = queryParams["billprint"],
                optcd1 = OPTCD1,
                optcd2 = OPTCD2,
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                cscd3 = CSCD3,
                addrdiv = ADDRDIV,
                cancelflg = ConsultCancel.Used
            };

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 特定健診ＸＭＬ対象データ(団体請求対象者の場合)取得
        /// </summary>
        /// <returns>対象データ</returns>
        private List<dynamic> SelectAbsenceListFile_Bill()
        {
            bool optOrgCd = false;
            if (!string.IsNullOrEmpty(queryParams["orgcd11"]) || !string.IsNullOrEmpty(queryParams["orgcd12"])
                || !string.IsNullOrEmpty(queryParams["orgcd21"]) || !string.IsNullOrEmpty(queryParams["orgcd22"])
                || !string.IsNullOrEmpty(queryParams["orgcd31"]) || !string.IsNullOrEmpty(queryParams["orgcd32"])
                || !string.IsNullOrEmpty(queryParams["orgcd41"]) || !string.IsNullOrEmpty(queryParams["orgcd42"])
                || !string.IsNullOrEmpty(queryParams["orgcd51"]) || !string.IsNullOrEmpty(queryParams["orgcd52"]))
            {
                optOrgCd = true;
            }

            string sql = @"
                    select
                        to_char(consult.csldate, 'YYYYMMDD') csldate
                        , consult.rsvno rsvno
                        , person.perid perid
                        , person.gender gender
                        , to_char(person.birth, 'YYYYMMDD') birth
                        , decode( 
                            length(peraddr.zipcd)
                            , 7
                            , substr(peraddr.zipcd, 1, 3) || '-' || substr(peraddr.zipcd, 4)
                            , peraddr.zipcd
                        ) zipcd
                        , pref.prefname || peraddr.cityname || peraddr.address1 || peraddr.address2 address
                        , consult.isrsign isrsign
                        , nvl(consult.isrmanno, org.spare1) isrorgno
                        , consult.isrno isrno
                        , consult.csldivcd csldivcd
                        , free.freefield1 csldivname
                        , person.lastkname || person.firstkname kname
                        , person.lastname || person.firstname name
                        , person.romename romename
                        , consult.cscd cscd
                        , course_p.csname csname
                        , consult.orgcd1 orgcd1
                        , consult.orgcd2 orgcd2
                        , consult.rsvgrpcd rsvgrpcd
                        , rsvgrp.rsvgrpname rsvgrpname
                        , decode( 
                            ( 
                                select
                                    min(ctrpt_opt.setclasscd) 
                                from
                                    consult_o
                                    , ctrpt_opt 
                                where
                                    consult.rsvno = consult_o.rsvno 
                                    and consult_o.optcd in (:optcd1, :optcd2) 
                                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                                    and consult_o.optcd = ctrpt_opt.optcd 
                                    and consult_o.optbranchno = ctrpt_opt.optbranchno
                            ) 
                            , '001'
                            , '23040'
                            , '035'
                            , '23040'
                            , '002'
                            , '23130'
                            , '003'
                            , '23130'
                            , '00000'
                        ) as setclass
                        , to_char(sysdate, 'YYYYMMDD') as outdate 
                        , consult.rfcno rfcno
                    from
                        consult
                        , person
                        , peraddr
                        , receipt
                        , free
                        , course_p
                        , pref
                        , org
                        , rsvgrp
                        , ( 
                            select
                                consult.rsvno as rsvno 
                            from
                                consult
                                , receipt
                                , consult_m 
                            where
                                consult.csldate between :frdate and :todate 
                                and consult.cancelflg = :cancelflg
                ";
            // 抽出条件によって対象コース変動
            switch (queryParams["coursecd"])
            {
                case CSCD1:
                    sql += @"   and consult.cscd = :cscd1 ";
                    break;

                case CSCD2:
                    sql += @"   and consult.cscd = :cscd2 ";
                    break;

                case CSCD3:
                    sql += @"   and consult.cscd = :cscd3 ";
                    break;

                default:
                    sql += @"   and consult.cscd in (:cscd1, :cscd2, :cscd3) ";
                    break;
            }

            // 抽出条件によって対象団体変動
            if (optOrgCd || !string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                sql += @"   and ( ";

                // 団体グループコード
                if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                {
                    sql += @"
                            (consult.orgcd1, consult.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                        ";
                }
                // 団体コード
                if (optOrgCd)
                {
                    if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                    {
                        sql += @"   or";
                    }
                    sql += @"
                            consult.orgcd1 || consult.orgcd2 in ( 
                                :orgcd10
                                , :orgcd20
                                , :orgcd30
                                , :orgcd40
                                , :orgcd50
                            ) 
                        ";
                }
                sql += @"   ) ";
            }

            sql += @" 
                            and consult.rsvno = receipt.rsvno 
                            and receipt.comedate is not null 
                            and consult.rsvno = consult_m.rsvno 
                            and consult_m.orgcd1 || consult_m.orgcd2 = :billorgcd
                        group by
                            consult.rsvno) lastview 
                    where
                        consult.csldate between :frdate and :todate 
                        and consult.cancelflg = :cancelflg
                ";

            switch (queryParams["coursecd"])
            {
                case CSCD1:
                    sql += @"   and consult.cscd = :cscd1 ";
                    break;

                case CSCD2:
                    sql += @"   and consult.cscd = :cscd2 ";
                    break;

                case CSCD3:
                    sql += @"   and consult.cscd = :cscd3 ";
                    break;

                default:
                    sql += @"   and consult.cscd in (:cscd1, :cscd2, :cscd3) ";
                    break;
            }

            sql += @"
                        and consult.csldivcd = free.freecd 
                        and consult.perid = person.perid 
                        and person.perid = peraddr.perid 
                        and peraddr.prefcd = pref.prefcd(+) 
                        and peraddr.addrdiv = :addrdiv
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null 
                        and consult.cscd = course_p.cscd 
                        and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2
                ";

            if (optOrgCd || !string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                sql += @"   and ( ";

                // 団体グループコード
                if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                {
                    sql += @"
                            (consult.orgcd1, consult.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                        ";
                }
                // 団体コード
                if (optOrgCd)
                {
                    if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
                    {
                        sql += @"   or";
                    }
                    sql += @"
                            consult.orgcd1 || consult.orgcd2 in ( 
                                :orgcd10
                                , :orgcd20
                                , :orgcd30
                                , :orgcd40
                                , :orgcd50
                            ) 
                        ";
                }
                sql += @"   ) ";
            }

            sql += @"   and consult.rsvno = lastview.rsvno ";

            // 受診区分
            if (!string.IsNullOrEmpty(queryParams["csldiv"]))
            {
                sql += @"   and consult.csldivcd = :csldiv ";
            }

            // 請求書出力区分
            if (!string.IsNullOrEmpty(queryParams["billprint"]))
            {
                sql += @"   and consult.billprint = :billprint ";
            }

            sql += @"
                    order by
                        nvl(consult.isrmanno, org.spare1)
                        , consult.orgcd1
                        , consult.orgcd2
                        , consult.csldate
                        , receipt.dayid
                ";

            var sqlParam = new
            {
                frdate = queryParams["strcsldate"],
                todate = queryParams["endcsldate"],
                orgcd10 = queryParams["orgcd11"] + queryParams["orgcd12"],
                orgcd20 = queryParams["orgcd21"] + queryParams["orgcd22"],
                orgcd30 = queryParams["orgcd31"] + queryParams["orgcd32"],
                orgcd40 = queryParams["orgcd41"] + queryParams["orgcd42"],
                orgcd50 = queryParams["orgcd51"] + queryParams["orgcd52"],
                orggrpcd = queryParams["orggrpcd"],
                csldivcd = queryParams["csldivcd"],
                billorgcd = queryParams["billorgcd1"] + queryParams["billorgcd2"],
                csldiv = queryParams["csldiv"],
                billprint = queryParams["billprint"],
                optcd1 = OPTCD1,
                optcd2 = OPTCD2,
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                cscd3 = CSCD3,
                addrdiv = ADDRDIV,
                cancelflg = ConsultCancel.Used
            };

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// XMLデータ作成
        /// </summary>
        /// <param name="document">XMLドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <param name="xmlDivInfo">実施区分・種別情報</param>
        /// <param name="verDiv">JLAC10バージョン識別区分</param>
        /// <returns>ドキュメント作成有無</returns>
        protected override bool CreateXMLData(XmlDocument document, IDictionary<string, object> data, IDictionary<string, object> xmlDivInfo, string verDiv)
        {
            bool retflg = false;

            // JLAC10CONV取得            
            List <dynamic> jlac10Conv = SearchConvInfo(verDiv, "", "");

            if (jlac10Conv.Count == 0)
            {
                return retflg;
            }

            // 非出力JLAC10コード取得            
            NotOutJlac10Cd = SearchNotOutputItemCd17(verDiv);

            // 血圧特殊処理
            ChoiceBloodPressure(jlac10Conv, verDiv, data);

            // XMLヘッダ部作成
            // XML:インストラクション
            XmlProcessingInstruction instruction = document.CreateProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
            document.AppendChild(instruction);

            // XML:ルートノード＆名前空間定義
            XmlElement root = document.CreateElement("ClinicalDocument");
            XmlAttribute xmlAttribute = document.CreateAttribute("xsi", "schemaLocation", XML_NAMESPACE);
            xmlAttribute.Value = "urn:hl7-org:v3 ../XSD/hc08_V08.xsd";
            root.Attributes.Append(xmlAttribute);
            root.SetAttribute("xmlns:xsi", XML_NAMESPACE);
            root.SetAttribute("xmlns", "urn:hl7-org:v3");
            document.AppendChild(root);

            // ↓XML:ヘッダ-健康管理情報
            // XML:CDA管理情報
            XmlElement xmlelement = document.CreateElement("typeId");
            xmlelement.SetAttribute("root", "2.16.840.1.113883.1.3");
            xmlelement.SetAttribute("extension", "POCD_HD000040");
            root.AppendChild(xmlelement);

            xmlelement = document.CreateElement("id");
            xmlelement.SetAttribute("nullFlavor", "NI");
            root.AppendChild(xmlelement);

            // XML:健康管理情報
            // 報告区分
            xmlelement = document.CreateElement("code");
            xmlelement.SetAttribute("code", "10");
            xmlelement.SetAttribute("codeSystem", "1.2.392.200119.6.1001");
            root.AppendChild(xmlelement);

            // ファイル作成日
            xmlelement = document.CreateElement("effectiveTime");
            xmlelement.SetAttribute("value", Util.ConvertToString(data["OUTDATE"]));
            root.AppendChild(xmlelement);

            // 守秘レベル
            xmlelement = document.CreateElement("confidentialityCode");
            xmlelement.SetAttribute("code", "N");
            root.AppendChild(xmlelement);

            // ↓XML:ヘッダ-受診者情報
            root.AppendChild(document.CreateComment("受診者情報"));
            root.AppendChild(CreateXML_DATA_RecordTarget(document, data));

            // ↓XML:ヘッダ-本ファイル作成健診機関情報（送付元）
            root.AppendChild(document.CreateComment("ファイル作成健診機関情報"));
            root.AppendChild(CreateXML_DATA_Author(document, Util.ConvertToString(data["OUTDATE"])));

            // ↓XML:ヘッダ-本ファイル作成管理責任機関情報
            root.AppendChild(document.CreateComment("ファイル作成管理責任機関情報"));
            root.AppendChild(CreateXML_DATA_Custodian(document));

            // ↓XML:ヘッダ-受診券・保険者情報
            string rfcno = Util.ConvertToString(data["RFCNO"]);
            if (!string.IsNullOrEmpty(rfcno))
            {
                root.AppendChild(document.CreateComment("受診券・保険者情報"));
                root.AppendChild(CreateXML_DATA_Participant(document, data));
            }

            // ↓XML:ヘッダ-健診実施情報
            root.AppendChild(document.CreateComment("健診実施情報"));
            root.AppendChild(CreateXML_DATA_DocumentationOf(document, data, xmlDivInfo));

            // ↓XML:ボディー部作成
            string secDiv = Util.ConvertToString(xmlDivInfo["XMLSECDIV"]);
            XMLSEC_DIV xmlSecDiv = XMLSEC_DIV.None;

            if (string.IsNullOrEmpty(secDiv) || secDiv == Util.ConvertToString(XMLSEC_DIV.None))
            {
                // すべての結果を１つのセクションにまとめて出力
                xmlSecDiv = XMLSEC_DIV.None;
            }
            else
            {
                xmlSecDiv = XMLSEC_DIV.Specific;
            }

            root.AppendChild(document.CreateComment("健診情報"));
            root.AppendChild(CreateXML_DATA_Body(document, data, xmlSecDiv, jlac10Conv, verDiv));

            checkXML_DATA(document, data, xmlSecDiv);

            retflg = true;

            return retflg;
        }

        /// <summary>
        /// 受診者情報作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <returns>受診者情報要素</returns>
        private XmlElement CreateXML_DATA_RecordTarget(XmlDocument document, IDictionary<string, object> data)
        {            
            var xmlelement = new XmlElement[4];

            xmlelement[0] = document.CreateElement("recordTarget");
            xmlelement[1] = document.CreateElement("patientRole");

            // 保険者番号
            xmlelement[2] = document.CreateElement("id");

            string isrorgno = Util.ConvertToString(data["ISRORGNO"]);
            isrorgno = isrorgno.Trim().PadLeft(8);

            xmlelement[2].SetAttribute("extension", isrorgno);
            xmlelement[2].SetAttribute("root", "1.2.392.200119.6.101");
            xmlelement[1].AppendChild(xmlelement[2]);

            // 被保険者証等記号
            string isrsign = Util.ConvertToString(data["ISRSIGN"]);

            if (!Util.IsAlphanumeric(isrsign))
            {
                // 英数文字以外が含まれている場合は全角文字に変換する
                isrsign = Strings.StrConv(isrsign, VbStrConv.Wide);
            }

            if (!string.IsNullOrEmpty(isrsign))
            {
                xmlelement[2] = document.CreateElement("id");
                xmlelement[2].SetAttribute("extension", isrsign);
                xmlelement[2].SetAttribute("root", "1.2.392.200119.6.204");
                xmlelement[1].AppendChild(xmlelement[2]);
            }

            // 被保険者証等番号
            string isrno = Util.ConvertToString(data["ISRNO"]);

            if (!Util.IsAlphanumeric(isrno))
            {
                // 英数文字以外が含まれている場合は全角文字に変換する
                isrno = Strings.StrConv(isrno, VbStrConv.Wide);
            }

            isrno = ((string.IsNullOrEmpty(isrno)) ? "0000000000" : isrno);

            xmlelement[2] = document.CreateElement("id");
            xmlelement[2].SetAttribute("extension", isrno);
            xmlelement[2].SetAttribute("root", "1.2.392.200119.6.205");
            xmlelement[1].AppendChild(xmlelement[2]);

            // 住所
            string address = Util.ConvertToString(data["ADDRESS"]);

            // 空白文字を取り除き、全角文字に変換する
            address = address.Replace(" ", "").Replace("　", "");
            address = Strings.StrConv(address, VbStrConv.Wide);

            xmlelement[2] = document.CreateElement("addr");

            // 郵便番号
            xmlelement[3] = document.CreateElement("postalCode");
            xmlelement[3].AppendChild(document.CreateTextNode(Util.ConvertToString(data["ZIPCD"])));
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[2].AppendChild(document.CreateTextNode(address));
            xmlelement[1].AppendChild(xmlelement[2]);

            // 受診者個人情報
            xmlelement[2] = document.CreateElement("patient");

            // 氏名
            string name = Util.ConvertToString(data["KNAME"]);

            // 空白文字を取り除き、全角文字に変換する
            name = name.Replace(" ", "").Replace("　", "");
            name = Strings.StrConv(name, VbStrConv.Wide);

            xmlelement[3] = document.CreateElement("name");
            xmlelement[3].AppendChild(document.CreateTextNode(name));
            xmlelement[2].AppendChild(xmlelement[3]);

            // 性別
            xmlelement[3] = document.CreateElement("administrativeGenderCode");
            xmlelement[3].SetAttribute("code", Util.ConvertToString(data["GENDER"]));
            xmlelement[3].SetAttribute("codeSystem", "1.2.392.200119.6.1104");
            xmlelement[2].AppendChild(xmlelement[3]);

            // 生年月日
            xmlelement[3] = document.CreateElement("birthTime");
            xmlelement[3].SetAttribute("value", Util.ConvertToString(data["BIRTH"]));
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[1].AppendChild(xmlelement[2]);
            xmlelement[0].AppendChild(xmlelement[1]);

            return xmlelement[0];
        }

        /// <summary>
        /// ファイル作成健診機関情報（送付元）作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="outDate">作成日</param>
        /// <returns>ファイル作成健診機関情報要素</returns>
        private XmlElement CreateXML_DATA_Author(XmlDocument document, string outDate)
        {
            var xmlelement = new XmlElement[5];

            xmlelement[0] = document.CreateElement("author");

            // ファイル作成日
            xmlelement[1] = document.CreateElement("time");
            xmlelement[1].SetAttribute("value", outDate);
            xmlelement[0].AppendChild(xmlelement[1]);

            // ファイル作成機関情報
            xmlelement[1] = document.CreateElement("assignedAuthor");
            xmlelement[2] = document.CreateElement("id");
            xmlelement[2].SetAttribute("nullFlavor", "NI");
            xmlelement[1].AppendChild(xmlelement[2]);

            // ファイル作成機関
            IDictionary<string, object> authororginfo = GetOrgInfo(false);

            xmlelement[2] = document.CreateElement("representedOrganization");
            xmlelement[3] = document.CreateElement("id");
            xmlelement[3].SetAttribute("extension", Util.ConvertToString(authororginfo["FREEFIELD1"]));
            xmlelement[3].SetAttribute("root", "1.2.392.200119.6.102");
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[3] = document.CreateElement("name");
            xmlelement[3].AppendChild(document.CreateTextNode(Util.ConvertToString(authororginfo["FREEFIELD2"])));
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[3] = document.CreateElement("telecom");
            xmlelement[3].SetAttribute("value", "tel:" + Util.ConvertToString(authororginfo["FREEFIELD3"]));
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[3] = document.CreateElement("addr");
            xmlelement[4] = document.CreateElement("postalCode");
            xmlelement[4].AppendChild(document.CreateTextNode(Util.ConvertToString(authororginfo["FREEFIELD4"])));
            xmlelement[3].AppendChild(xmlelement[4]);
            xmlelement[3].AppendChild(document.CreateTextNode(Util.ConvertToString(authororginfo["FREEFIELD5"])));
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[1].AppendChild(xmlelement[2]);
            xmlelement[0].AppendChild(xmlelement[1]);

            return xmlelement[0];
        }

        /// <summary>
        /// ファイル作成管理責任機関情報作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <returns>ファイル作成管理責任機関情報要素</returns>
        private XmlElement CreateXML_DATA_Custodian(XmlDocument document)
        {
            var xmlelement = new XmlElement[4];

            xmlelement[0] = document.CreateElement("custodian");
            xmlelement[1] = document.CreateElement("assignedCustodian");
            xmlelement[2] = document.CreateElement("representedCustodianOrganization");
            xmlelement[3] = document.CreateElement("id");
            xmlelement[3].SetAttribute("nullFlavor", "NI");
            xmlelement[2].AppendChild(xmlelement[3]);
            xmlelement[1].AppendChild(xmlelement[2]);
            xmlelement[0].AppendChild(xmlelement[1]);

            return xmlelement[0];
        }

        /// <summary>
        /// 受診券・保険者情報作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <returns>受診券・保険者情報要素</returns>
        private XmlElement CreateXML_DATA_Participant(XmlDocument document, IDictionary<string, object> data)
        {
            var xmlelement = new XmlElement[4];

            xmlelement[0] = document.CreateElement("participant");
            xmlelement[0].SetAttribute("typeCode", "HLD");
            xmlelement[1] = document.CreateElement("functionCode");
            xmlelement[1].SetAttribute("code", "1");
            xmlelement[1].SetAttribute("codeSystem", "1.2.392.200119.6.208");
            xmlelement[0].AppendChild(xmlelement[1]);

            xmlelement[1] = document.CreateElement("time");
            xmlelement[2] = document.CreateElement("high");

            string rfclimdate = GetRfcLinmitDate(Util.ConvertToString(data["CSLDATE"]));
            if (!string.IsNullOrEmpty(rfclimdate))
            {
                xmlelement[2].SetAttribute("value", rfclimdate);
            }
            else
            {
                string logText = Util.ConvertToString(data["RSVNO"]) + ",受診券有効期限が取得できません。";
                logTextInfo.Add(logText);
            }
            xmlelement[1].AppendChild(xmlelement[2]);
            xmlelement[0].AppendChild(xmlelement[1]);

            xmlelement[1] = document.CreateElement("associatedEntity");
            xmlelement[1].SetAttribute("classCode", "IDENT");

            string rfcno = Util.ConvertToString(data["RFCNO"]);
            rfcno = (string.IsNullOrEmpty(rfcno) ? "00000000000" : rfcno);
            xmlelement[2] = document.CreateElement("id");
            xmlelement[2].SetAttribute("extension", rfcno);            

            string isrorgno = Util.ConvertToString(data["ISRORGNO"]);
            isrorgno = isrorgno.Trim().PadLeft(8);
            xmlelement[2].SetAttribute("root", "1.2.392.200119.6.209.1" + isrorgno);
            xmlelement[1].AppendChild(xmlelement[2]);

            xmlelement[2] = document.CreateElement("scopingOrganization");
            xmlelement[3] = document.CreateElement("id");
            xmlelement[3].SetAttribute("extension", isrorgno);
            xmlelement[3].SetAttribute("root", "1.2.392.200119.6.101");
            xmlelement[2].AppendChild(xmlelement[3]);

            xmlelement[1].AppendChild(xmlelement[2]);
            xmlelement[0].AppendChild(xmlelement[1]);

            return xmlelement[0];
        }

        /// <summary>
        /// 健診実施情報作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <param name="xmlDivInfo">実施区分・種別情報</param>
        /// <returns>健診実施情報要素</returns>
        private XmlElement CreateXML_DATA_DocumentationOf(XmlDocument document, IDictionary<string, object> data, IDictionary<string, object> xmlDivInfo)
        {
            var xmlelement = new XmlElement[7];            

            xmlelement[0] = document.CreateElement("documentationOf");
            xmlelement[1] = document.CreateElement("serviceEvent");

            string pgKindcd = Util.ConvertToString(xmlDivInfo["XMLPGCODE"]);
            string pgKindName = Util.ConvertToString(xmlDivInfo["XMLPGCODENM"]);
            xmlelement[2] = document.CreateElement("code");
            xmlelement[2].SetAttribute("code", pgKindcd);
            xmlelement[2].SetAttribute("codeSystem", "1.2.392.200119.6.1002");
            xmlelement[2].SetAttribute("displayName", pgKindName);
            xmlelement[1].AppendChild(xmlelement[2]);

            xmlelement[2] = document.CreateElement("effectiveTime");
            xmlelement[2].SetAttribute("value", Util.ConvertToString(data["CSLDATE"]));
            xmlelement[1].AppendChild(xmlelement[2]);

            xmlelement[2] = document.CreateElement("performer");
            xmlelement[2].SetAttribute("typeCode", "PRF");

            xmlelement[3] = document.CreateElement("assignedEntity");
            xmlelement[4] = document.CreateElement("id");
            xmlelement[4].SetAttribute("nullFlavor", "NI");
            xmlelement[3].AppendChild(xmlelement[4]);

            xmlelement[4] = document.CreateElement("representedOrganization");

            IDictionary<string, object> docofOrgInfo = GetOrgInfo(false);

            string docofOrgNo = (docofOrgInfo == null) ? "" : Util.ConvertToString(docofOrgInfo["FREEFIELD1"]);
            xmlelement[5] = document.CreateElement("id");
            xmlelement[5].SetAttribute("extension", docofOrgNo);
            xmlelement[5].SetAttribute("root", "1.2.392.200119.6.102");
            xmlelement[4].AppendChild(xmlelement[5]);

            string docofOrgName = (docofOrgInfo == null) ? "" : Util.ConvertToString(docofOrgInfo["FREEFIELD2"]);
            xmlelement[5] = document.CreateElement("name");
            xmlelement[5].AppendChild(document.CreateTextNode(docofOrgName));
            xmlelement[4].AppendChild(xmlelement[5]);

            string docofOrgTel = (docofOrgInfo == null) ? "" : Util.ConvertToString(docofOrgInfo["FREEFIELD3"]);
            xmlelement[5] = document.CreateElement("telecom");
            xmlelement[5].SetAttribute("value", "tel:" + docofOrgTel);
            xmlelement[4].AppendChild(xmlelement[5]);

            string docofOrgPost = (docofOrgInfo == null) ? "" : Util.ConvertToString(docofOrgInfo["FREEFIELD4"]);
            string docofOrgAddr = (docofOrgInfo == null) ? "" : Util.ConvertToString(docofOrgInfo["FREEFIELD5"]);
            xmlelement[5] = document.CreateElement("addr");
            xmlelement[6] = document.CreateElement("postalCode");
            xmlelement[6].AppendChild(document.CreateTextNode(docofOrgPost));
            xmlelement[5].AppendChild(xmlelement[6]);
            xmlelement[5].AppendChild(document.CreateTextNode(docofOrgAddr));
            xmlelement[4].AppendChild(xmlelement[5]);

            xmlelement[3].AppendChild(xmlelement[4]);
            xmlelement[2].AppendChild(xmlelement[3]);
            xmlelement[1].AppendChild(xmlelement[2]);
            xmlelement[0].AppendChild(xmlelement[1]);

            return xmlelement[0];
        }

        /// <summary>
        /// ボディ部作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <param name="xmlSecDiv">セクション区分</param>
        /// <param name="jlac10Conv">JLAC10変換情報</param>
        /// <param name="verDiv">バージョン識別区分</param>
        /// <returns>ボディ部要素</returns>
        private XmlElement CreateXML_DATA_Body(XmlDocument document, IDictionary<string, object> data, XMLSEC_DIV xmlSecDiv, List<dynamic> jlac10Conv, string verDiv)
        {
            var xmlelement = new XmlElement[7];

            // セクション部作成
            xmlelement[0] = document.CreateElement("component");
            xmlelement[1] = document.CreateElement("structuredBody");
            xmlelement[2] = document.CreateElement("component");
            xmlelement[3] = document.CreateElement("section");
            xmlelement[4] = document.CreateElement("code");
            xmlelement[4].SetAttribute("code", "01010");
            xmlelement[4].SetAttribute("codeSystem", "1.2.392.200119.6.1010");
            xmlelement[4].SetAttribute("displayName", "検査・問診結果セクション");
            xmlelement[3].AppendChild(xmlelement[4]);

            xmlelement[4] = document.CreateElement("title");
            xmlelement[4].AppendChild(document.CreateTextNode("検査・問診結果セクション"));
            xmlelement[3].AppendChild(xmlelement[4]);

            xmlelement[4] = document.CreateElement("text");
            xmlelement[3].AppendChild(xmlelement[4]);
            xmlelement[2].AppendChild(xmlelement[3]);

            // 検査結果を展開
            bool getDataflg = false;

            getDataflg = CreateXML_DATA_entry(document, xmlelement[3], data, xmlSecDiv, jlac10Conv, verDiv);

            if (getDataflg)
            {
                // 特定健診項目のXML変換ができたときだけ、検査・問診結果セクションをXML出力する
                xmlelement[2].AppendChild(xmlelement[3]);
                xmlelement[1].AppendChild(xmlelement[2]);
            }
            
            if (xmlSecDiv != XMLSEC_DIV.None)
            {
                // セクションを考慮する場合は任意追加項目セクションを出力する
                xmlelement[2] = document.CreateElement("component");
                xmlelement[3] = document.CreateElement("section");
                xmlelement[4] = document.CreateElement("code");
                xmlelement[4].SetAttribute("code", "01990");
                xmlelement[4].SetAttribute("codeSystem", "1.2.392.200119.6.1010");
                xmlelement[4].SetAttribute("displayName", "任意追加項目セクション");
                xmlelement[3].AppendChild(xmlelement[4]);

                xmlelement[4] = document.CreateElement("title");
                xmlelement[4].AppendChild(document.CreateTextNode("任意追加項目セクション"));
                xmlelement[3].AppendChild(xmlelement[4]);

                xmlelement[4] = document.CreateElement("text");
                xmlelement[3].AppendChild(xmlelement[4]);
                xmlelement[2].AppendChild(xmlelement[3]);

                getDataflg = CreateXML_DATA_entry(document, xmlelement[3], data, XMLSEC_DIV.Other, jlac10Conv, verDiv);

                if (getDataflg)
                {
                    // 追加健診項目のXML変換ができたときだけ、任意追加項目セクションをXML出力する
                    xmlelement[2].AppendChild(xmlelement[3]);
                    xmlelement[1].AppendChild(xmlelement[2]);
                }
            }

            xmlelement[0].AppendChild(xmlelement[1]);
            return xmlelement[0];
        }

        /// <summary>
        /// 結果部作成
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="element">エレメント</param>
        /// <param name="data">対象データ</param>
        /// <param name="xmlSecDiv">セクション区分</param>
        /// <param name="jlac10Conv">JLAC10変換情報</param>
        /// <param name="verDiv">バージョン識別区分</param>
        /// <returns>取得有無</returns>
        private bool CreateXML_DATA_entry(XmlDocument document, XmlElement element, IDictionary<string, object> data, XMLSEC_DIV xmlSecDiv, List<dynamic> jlac10Conv, string verDiv)
        {
            // 検査結果を展開
            var xmlelement = new XmlElement[6];
            var xmlelementBattery = new XmlElement[5];
            var xmlBattery = new Dictionary<string, XmlElement>();
            XmlAttribute xmlAttribute = null;

            bool requiredItemflg = false;   // true=検査結果が空で取得できた場合、測定不可能として出力する。false=未実施として出力する。                        
            bool batteryflg = false;
            bool getResult = false;
            string batteryCode = "";

            // JLAC10変換＆XML出力処理
            foreach (IDictionary<string, object> jlac10ConvRec in jlac10Conv)
            {
                // 検査結果が空で取得できた場合、測定不可能として出力するかどうかを設定
                requiredItemflg = false;

                // 汎用マスタに登録されているJLAC10コードならtrueとなり、登録されていなければfalseのまま
                string jlac10Cd = Util.ConvertToString(jlac10ConvRec["JLAC10CD17"]);
                requiredItemflg = RequiredJlac10Cd.ContainsKey(jlac10Cd);

                // JLAC10コードごとに、必要なITEMCDを取得
                string itemcdInfo = Util.ConvertToString(jlac10ConvRec["ITEMCD"]);
                string[] itemcd = itemcdInfo.Split('+');

                if (itemcd.Count() == 0)
                {
                    string logText = jlac10Cd + ",変換シートの設定が誤っています。,対象となる検査項目コードがありません。";
                    logTextInfo.Add(logText);
                    continue;
                }

                bool notOutflg = false;
                foreach (IDictionary<string, object> notOutRec in NotOutJlac10Cd)
                {
                    // 「author要素で表現される項目番号」[JLac10コード(17桁)]に登録されている
                    // JLac10コード(17桁)はXMLに出力しない
                    if (Util.ConvertToString(notOutRec["XMLITEM_AUTHORITEM"]) == jlac10Cd)
                    {
                        notOutflg = true;
                        break;
                    }
                }
                if (notOutflg)
                {
                    continue;
                }

                // JLAC10情報テーブルから基本情報を取得
                // ※検査結果等は後で取得
                string dstOrgNo = Util.ConvertToString(data["ISRORGNO"]);
                IDictionary<string, object> jlac10Info = SearchJLAC10Info(verDiv, jlac10Cd, xmlSecDiv, dstOrgNo);
                if (jlac10Info == null)
                {
                    // 基本情報が存在しない場合は次へ
                    continue;
                }

                // XML出力に使用する結果文字列を取得
                XML_RESULT_INFO xmlResult = convToJLAC10(verDiv, jlac10ConvRec, data);

                if (xmlResult.getflg)
                {
                    // 結果文字列が取得できた
                    getResult = true;

                    // entry・observationエレメント・オープン
                    // この検査項目は一連検査グループ（バッテリ）に属するか？
                    string batterycd = Util.ConvertToString(jlac10Info["XMLITEM_BAT"]);

                    if (!string.IsNullOrEmpty(batterycd))
                    {
                        // 属する（一時的なバッテリ用エレメントに作成、最後にルートに結合）
                        if (!string.IsNullOrEmpty(batteryCode) && batteryCode != batterycd)
                        {
                            // 前回まで別のバッテリーだった…前回のバッテリーは終わりなので結合する
                            element.AppendChild(document.CreateComment("バッテリ：" + batteryCode));
                            element.AppendChild(xmlBattery[batteryCode]);
                        }

                        // 新規バッテリか？
                        bool newBatteryflg = false;

                        // 既存のバッテリがあるか
                        if (!(xmlBattery.Count > 0 && xmlBattery.ContainsKey(batterycd)))
                        {
                            // 既存のバッテリがない
                            xmlBattery.Add(batterycd, xmlelementBattery[0]);
                            newBatteryflg = true;
                        }

                        xmlelementBattery[0] = xmlBattery[batterycd];

                        if (newBatteryflg)
                        {
                            xmlelementBattery[0] = document.CreateElement("entry");
                            xmlelementBattery[1] = document.CreateElement("observation");
                            xmlelementBattery[1].SetAttribute("classCode", "OBS");
                            xmlelementBattery[1].SetAttribute("moodCode", "EVN");

                            xmlelementBattery[2] = document.CreateElement("code");
                            xmlelementBattery[2].SetAttribute("nullFlavor", "NA");
                            xmlelementBattery[1].AppendChild(xmlelementBattery[2]);
                        }

                        xmlelementBattery[2] = document.CreateElement("entryRelationship");
                        xmlelementBattery[2].SetAttribute("typeCode", Util.ConvertToString(jlac10Info["XMLITEM_BATREL"]));
                        xmlelementBattery[1].AppendChild(xmlelementBattery[2]);

                        batteryflg = true;
                        batteryCode = batterycd;
                    }
                    else
                    {
                        // バッテリに属さない
                        if (!string.IsNullOrEmpty(batteryCode))
                        {
                            // 前回までバッテリの処理をしていた…バッテリ終了なので結合する
                            element.AppendChild(document.CreateComment("バッテリ：" + batteryCode));
                            xmlelementBattery[0] = xmlBattery[batteryCode];
                            element.AppendChild(xmlelementBattery[0]);
                        }

                        // 属さない（直接、本来のエレメントへ）
                        xmlelement[0] = document.CreateElement("entry");

                        batteryflg = false;
                        batteryCode = "";
                    }

                    xmlelement[1] = document.CreateElement("observation");
                    xmlelement[1].SetAttribute("classCode", "OBS");
                    xmlelement[1].SetAttribute("moodCode", "EVN");

                    if (string.IsNullOrEmpty(xmlResult.result) && !requiredItemflg)
                    {
                        // 検査未実施
                        xmlelement[1].SetAttribute("negationInd", "true");
                    }
                    else
                    {
                        // 検査実施
                        xmlelement[1].SetAttribute("negationInd", "false");
                    }

                    string itemName = Util.ConvertToString(jlac10Info["XMLITEM_NAME"]);

                    xmlelement[2] = document.CreateElement("code");
                    xmlelement[2].SetAttribute("code", jlac10Cd);
                    xmlelement[2].SetAttribute("displayName", itemName);

                    string itemOid = Util.ConvertToString(jlac10Info["XMLITEM_ITEMOID"]);
                    if (itemOid != "1.2.392.200119.6.1005")
                    {
                        xmlelement[2].SetAttribute("codeSystem", itemOid);
                    }
                    xmlelement[1].AppendChild(xmlelement[2]);

                    string pattern = Util.ConvertToString(jlac10Info["XMLITEM_PATTERN"]);
                    string dataType = Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]);
                    string style = ConvJlac10InfoFormat(Util.ConvertToString(jlac10Info["XMLITEM_FORMAT"]));
                    string unit = Util.ConvertToString(jlac10Info["XMLITEM_UNIT"]);

                    if (!string.IsNullOrEmpty(xmlResult.result))
                    {
                        // 検査値の入力範囲をチェックする
                        string obsInpCode = "";

                        if (pattern == "1")
                        {
                            IDictionary<string, object> valueLim = GetInputLimit(jlac10Cd);

                            if (valueLim.Count > 0)
                            {
                                if (double.TryParse(xmlResult.result, out double rslValue)
                                    && double.TryParse(Util.ConvertToString(valueLim["MINVALUE"]), out double minValue)
                                    && double.TryParse(Util.ConvertToString(valueLim["MAXVALUE"]), out double maxValue))
                                {
                                    // 入力最小値以下か
                                    if (rslValue <= minValue)
                                    {
                                        obsInpCode = "L";
                                    }
                                    // 入力最大値以上か
                                    else if (rslValue >= maxValue)
                                    {
                                        obsInpCode = "H";
                                    }
                                }
                            }
                        }

                        xmlelement[2] = document.CreateElement("value");

                        if (!string.IsNullOrEmpty(dataType))
                        {
                            // 未検査なら出力しない
                            xmlAttribute = document.CreateAttribute("xsi", "type", XML_NAMESPACE);
                            xmlAttribute.Value = dataType;
                            xmlelement[2].Attributes.Append(xmlAttribute);
                        }

                        switch (pattern)
                        {
                            case "1":
                                xmlelement[2].SetAttribute("value", ConvStyleinResult(xmlResult.result, style));
                                if (!string.IsNullOrEmpty(unit))
                                {
                                    xmlelement[2].SetAttribute("unit", unit);
                                }

                                // 測定値が入力範囲外の場合、解釈コードを出力
                                if (!string.IsNullOrEmpty(obsInpCode))
                                {
                                    xmlelement[1].AppendChild(xmlelement[2]);
                                    xmlelement[2] = document.CreateElement("value");
                                    xmlAttribute = document.CreateAttribute("xsi", "type", XML_NAMESPACE);
                                    xmlAttribute.Value = "CD";
                                    xmlelement[2].Attributes.Append(xmlAttribute);
                                    xmlelement[2].SetAttribute("code", obsInpCode);
                                    xmlelement[2].SetAttribute("codeSystem", "2.16.840.1.113883.5.83");
                                    if (obsInpCode == "L")
                                    {
                                        xmlelement[2].SetAttribute("displayName", "以下");
                                    }
                                    else if (obsInpCode == "H")
                                    {
                                        xmlelement[2].SetAttribute("displayName", "以上");
                                    }
                                }
                                break;

                            case "2":
                                if (dataType != XMLTYPE_ST)
                                {
                                    xmlelement[2].SetAttribute("code", xmlResult.result);
                                    string resultOid = Util.ConvertToString(jlac10Info["XMLITEM_CODEOID"]);
                                    if (!string.IsNullOrEmpty(resultOid))
                                    {
                                        xmlelement[2].SetAttribute("codeSystem", resultOid);
                                    }
                                }
                                else
                                {
                                    if (Util.ConvertToString(jlac10Info["XMLITEM_TYPENAME"]) == "年月日")
                                    {
                                        xmlelement[2].AppendChild(document.CreateTextNode(xmlResult.result));
                                    }
                                    else
                                    {
                                        // 全角文字に変換
                                        string tmpResult = Strings.StrConv(xmlResult.result, VbStrConv.Wide);

                                        // 全角文字に変換したので文字列長を調整して出力
                                        if (int.TryParse(style, out int tmpStyle))
                                        {
                                            tmpResult = CutStringByte(xmlResult.result, tmpStyle);
                                        }
                                        xmlelement[2].AppendChild(document.CreateTextNode(tmpResult));
                                    }
                                }
                                break;

                            default:
                                break;
                        }

                        xmlelement[1].AppendChild(xmlelement[2]);
                    }
                    else if (requiredItemflg)
                    {
                        // 検査結果結果が空で、必須項目の場合→測定不可として出力
                        xmlelement[2] = document.CreateElement("value");
                        xmlAttribute = document.CreateAttribute("xsi", "type", XML_NAMESPACE);
                        xmlAttribute.Value = dataType;
                        xmlelement[2].Attributes.Append(xmlAttribute);
                        xmlelement[2].SetAttribute("nullFlavor", "NI");
                        xmlelement[1].AppendChild(xmlelement[2]);
                    }

                    // 結果解釈コード
                    if (!string.IsNullOrEmpty(xmlResult.result))
                    {
                        if (xmlResult.stdflg == XMLRSLINTERPRETATION_N || xmlResult.stdflg == XMLRSLINTERPRETATION_H || xmlResult.stdflg == XMLRSLINTERPRETATION_L)
                        {
                            xmlelement[2] = document.CreateElement("interpretationCode");
                            xmlelement[2].SetAttribute("code", xmlResult.stdflg);
                            xmlelement[1].AppendChild(xmlelement[2]);
                        }
                    }

                    // 検査方法コード
                    if (!string.IsNullOrEmpty(xmlResult.result) || requiredItemflg)
                    {
                        // 未実施時は出力しない。測定不可能時は出力する。
                        string methodcd = Util.ConvertToString(jlac10Info["XMLITEM_METHOD"]);

                        if (!string.IsNullOrEmpty(methodcd))
                        {
                            xmlelement[2] = document.CreateElement("methodCode");
                            xmlelement[2].SetAttribute("code", methodcd);
                            xmlelement[2].SetAttribute("codeSystem", "1.2.392.200119.6.1007");
                            xmlelement[1].AppendChild(xmlelement[2]);
                        }
                    }

                    // 記録者の情報
                    string authorItem = Util.ConvertToString(jlac10Info["XMLITEM_AUTHORITEM"]);

                    if (!string.IsNullOrEmpty(authorItem) && !string.IsNullOrEmpty(xmlResult.result))
                    {
                        // 「結果を記録した者の氏名」を取得
                        List<dynamic> authorInfo = SearchConvInfo(verDiv, "", authorItem);

                        if (authorInfo != null)
                        {
                            // 「結果を記録した者の氏名」を取得
                            XML_RESULT_INFO assignedPerson = convToJLAC10(verDiv, authorInfo[0], data);

                            if (!string.IsNullOrEmpty(assignedPerson.result))
                            {
                                xmlelement[2] = document.CreateElement("author");
                                xmlelement[3] = document.CreateElement("time");
                                xmlelement[3].SetAttribute("nullFlavor", "NI");
                                xmlelement[2].AppendChild(xmlelement[3]);

                                xmlelement[3] = document.CreateElement("assignedAuthor");
                                xmlelement[4] = document.CreateElement("id");
                                xmlelement[4].SetAttribute("nullFlavor", "NI");
                                xmlelement[3].AppendChild(xmlelement[4]);

                                xmlelement[4] = document.CreateElement("assignedPerson");
                                xmlelement[5] = document.CreateElement("name");
                                xmlelement[5].AppendChild(document.CreateTextNode(assignedPerson.result));
                                xmlelement[4].AppendChild(xmlelement[5]);

                                xmlelement[3].AppendChild(xmlelement[4]);
                                xmlelement[2].AppendChild(xmlelement[3]);
                                xmlelement[1].AppendChild(xmlelement[2]);
                            }
                        }
                    }

                    // 基準値情報
                    if (!string.IsNullOrEmpty(xmlResult.result) || requiredItemflg)
                    {
                        // 未実施時は出力しない。測定不可能時は出力する。
                        if (dataType == XMLTYPE_PQ
                            && (!string.IsNullOrEmpty(xmlResult.uppervalue) || !string.IsNullOrEmpty(xmlResult.lowervalue)))
                        {
                            xmlelement[2] = document.CreateElement("referenceRange");
                            xmlelement[3] = document.CreateElement("observationRange");
                            xmlelement[3].SetAttribute("classCode", "OBS");
                            xmlelement[3].SetAttribute("moodCode", "EVN.CRT");

                            xmlelement[4] = document.CreateElement("value");
                            xmlAttribute = document.CreateAttribute("xsi", "type", XML_NAMESPACE);
                            xmlAttribute.Value = "IVL_PQ";
                            xmlelement[4].Attributes.Append(xmlAttribute);

                            xmlelement[5] = document.CreateElement("low");
                            xmlelement[5].SetAttribute("value", xmlResult.lowervalue);
                            if (!string.IsNullOrEmpty(unit))
                            {
                                xmlelement[5].SetAttribute("unit", unit);
                            }
                            xmlelement[4].AppendChild(xmlelement[5]);

                            xmlelement[5] = document.CreateElement("high");
                            xmlelement[5].SetAttribute("value", xmlResult.uppervalue);
                            if (!string.IsNullOrEmpty(unit))
                            {
                                xmlelement[5].SetAttribute("unit", unit);
                            }
                            xmlelement[4].AppendChild(xmlelement[5]);

                            xmlelement[3].AppendChild(xmlelement[4]);
                            xmlelement[2].AppendChild(xmlelement[3]);
                            xmlelement[1].AppendChild(xmlelement[2]);
                        }
                    }

                    // entryエレメント・クローズ                    
                    if (batteryflg)
                    {
                        // バッテリに属す
                        xmlelementBattery[2].AppendChild(document.CreateComment(itemName));
                        xmlelementBattery[2].AppendChild(xmlelement[1]);
                        xmlelementBattery[1].AppendChild(xmlelementBattery[2]);
                        xmlelementBattery[0].AppendChild(xmlelementBattery[1]);
                        xmlBattery[batteryCode] = xmlelementBattery[0];
                    }
                    else
                    {
                        // バッテリに属さない
                        // コメント（検査項目名）
                        xmlelement[0].AppendChild(document.CreateComment(itemName));
                        xmlelement[0].AppendChild(xmlelement[1]);
                        element.AppendChild(xmlelement[0]);
                    }
                }
            }

            // 一連検査項目を出力
            if (!string.IsNullOrEmpty(batteryCode))
            {
                // 終了直前、バッテリの処理をしていた…最後に結合する
                element.AppendChild(document.CreateComment("バッテリ：" + batteryCode));
                element.AppendChild(xmlBattery[batteryCode]);
            }

            return getResult;
        }

        /// <summary>
        /// 検診結果XMLの内容チェック
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="data">対象データ</param>
        /// <param name="xmlSecDiv">セクション区分</param>
        private void checkXML_DATA(XmlDocument document, IDictionary<string, object> data, XMLSEC_DIV xmlSecDiv)
        {
            string result = "";
            string logText = "";

            // 必須項目チェック
            foreach(string jlac10Cd in RequiredJlac10Cd.Keys)
            {
                result = getXMLResultValue(document, jlac10Cd, false);

                switch (jlac10Cd)
                {
                    case "9N056160400000049":
                        // 既往歴
                        string rslKiouDiv = getXMLResultValue(document, "9N056000000000011", false);

                        if (rslKiouDiv == "2" && string.IsNullOrEmpty(result))
                        {
                            // 既往歴有無の結果が "2" かつ具体的な既往歴がない場合、次の項目へ
                            continue;
                        }
                        break;

                    case "9N061160800000049":
                        // 自覚症状
                        string rslJikakuDiv = getXMLResultValue(document, "9N061000000000011", false);

                        if (rslJikakuDiv == "2" && string.IsNullOrEmpty(result))
                        {
                            // 自覚症状有無の結果が "2" かつ自覚症状所見がない場合、次の項目へ
                            continue;
                        }
                        break;

                    case "9N066160800000049":
                        // 他覚症状
                        string rslTakakuDiv = getXMLResultValue(document, "9N066000000000011", false);

                        if (rslTakakuDiv == "2" && string.IsNullOrEmpty(result))
                        {
                            // 他覚症状有無の結果が "2" かつ他覚症状所見がない場合、次の項目へ
                            continue;
                        }
                        break;

                    case "3D010000001926101":
                    case "3D046000001999902":
                    case "3D010129901926101":
                        // 血糖
                        string kuhuku = getXMLResultValue(document, "3D010000001926101", false);
                        string hba1c = getXMLResultValue(document, "3D046000001999902", false);
                        string zuiji = getXMLResultValue(document, "3D010129901926101", false);

                        if (!string.IsNullOrEmpty(kuhuku) || !string.IsNullOrEmpty(hba1c) || !string.IsNullOrEmpty(zuiji))
                        {
                            // 空腹時血糖、ＨｂＡ１ｃ、随時血糖のいずれかが入っている場合、次の項目へ
                            continue;
                        }
                        break;

                    default:
                        break;
                }

                if (string.IsNullOrEmpty(result))
                {
                    // エラー！必須項目欠落
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",必須項目欠落";
                    logText += "," + jlac10Cd;
                    logText += "," + RequiredJlac10Cd[jlac10Cd];
                    logTextInfo.Add(logText);
                }
            }

            if (xmlSecDiv != XMLSEC_DIV.None)
            {
                // 詳細健診項目チェック
                string target = "";
                string reason = "";

                // 貧血検査
                reason = getXMLResultValue(document, "2A020161001930149", false);
                if (string.IsNullOrEmpty(reason))
                {
                    // エラー！実施理由なし
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",貧血の実施理由がありません。";
                    logTextInfo.Add(logText);
                }

                // 心電図
                reason = getXMLResultValue(document, "9A110161000000049", false);
                target = getXMLResultValue(document, "9A110161600000011", false);
                if (string.IsNullOrEmpty(reason) && (target == "1" || target == "2"))
                {
                    // エラー！対象者が'1'または'2'かつ実施理由なし
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",心電図の実施理由がありません。";
                    logTextInfo.Add(logText);
                }

                // 眼底
                reason = getXMLResultValue(document, "9E100161000000049", false);
                target = getXMLResultValue(document, "9E100161600000011", false);
                if (string.IsNullOrEmpty(reason) && (target == "1" || target == "2"))
                {
                    // エラー！対象者が'1'または'2'かつ実施理由なし
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",眼底の実施理由がありません。";
                    logTextInfo.Add(logText);
                }

                // 血清クレアチニン
                reason = getXMLResultValue(document, "3C015161002399949", false);
                target = getXMLResultValue(document, "3C015161602399911", false);
                if (string.IsNullOrEmpty(reason) && (target == "1" || target == "2"))
                {
                    // エラー！対象者が'1'または'2'かつ実施理由なし
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",血清クレアチニンの実施理由がありません。";
                    logTextInfo.Add(logText);
                }
            }

            // 血糖と採血時間（食後）の関連チェック
            result = getXMLResultValue(document, "9N141000000000011", false);
            if (result == "1")
            {
                result = "";
                result += getXMLResultValue(document, "3D010000001926101", false);
                result += getXMLResultValue(document, "3D010000002227101", false);
                result += getXMLResultValue(document, "3D010000001927201", false);
                result += getXMLResultValue(document, "3D010000001999901", false);

                if (string.IsNullOrEmpty(result))
                {
                    // エラー！採血時間が食後10時間未満なのに空腹時血糖の検査値がある
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",採血時間が食後10時間未満ですが空腹時血糖の検査値があります。";
                    logTextInfo.Add(logText);
                }
            }

            // BMIと腹囲の関連チェック
            string resultBMI = getXMLResultValue(document, "9N011000000000001", false);         // BMIの値
            string interpretationBMI = getXMLResultValue(document, "9N011000000000001", true);  // BMIの解釈
            string resultAbdCir = getXMLResultValue(document, "9N016160300000001", false);      // 腹囲（自己申告）
            result = "";
            result += getXMLResultValue(document, "9N021000000000001", false);  // 内臓脂肪面積
            result += getXMLResultValue(document, "9N016160100000001", false);  // 腹囲（実測）
            result += getXMLResultValue(document, "9N016160200000001", false);  // 腹囲（自己判定）

            double rslBMI = 0;
            if (!string.IsNullOrEmpty(resultBMI))
            {
                if (!double.TryParse(resultBMI, out rslBMI))
                {
                    resultBMI = "";
                }
            }

            if (string.IsNullOrEmpty(result) && string.IsNullOrEmpty(resultAbdCir))
            {
                if (string.IsNullOrEmpty(resultBMI)
                    || (interpretationBMI != XMLRSLINTERPRETATION_L && rslBMI >= 20))
                {
                    // BMIの値が20以上で、「Ｌ」でない場合はエラーとする
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",腹囲の検査値（内臓脂肪面積、実測、自己判定、自己申告）のうち、少なくとも１つが必要です。";
                    logTextInfo.Add(logText);
                }
            }
            else if (string.IsNullOrEmpty(result) && !string.IsNullOrEmpty(resultAbdCir))
            {
                if (string.IsNullOrEmpty(resultBMI)
                    || (interpretationBMI != XMLRSLINTERPRETATION_L && rslBMI >= 22))
                {
                    // BMIの値が22未満または「Ｌ」でない場合はエラーとする
                    logText = Util.ConvertToString(data["RSVNO"]);
                    logText += ",腹囲（自己申告）の結果がある場合はBMIの結果が22未満またはLでなければなりません。";
                    logTextInfo.Add(logText);
                }
            }
        }

        /// <summary>
        /// 生成中のXMLから、検査結果を取得
        /// </summary>
        /// <param name="document">ドキュメント</param>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <param name="interpretationflg">結果解釈フラグ</param>
        /// <returns>検査結果</returns>
        private string getXMLResultValue(XmlDocument document, string jlac10Cd, bool interpretationflg)
        {
            XmlNodeList nodeList = document.GetElementsByTagName("code");

            string retResult = "";

            foreach (XmlElement mainElementRec in nodeList)
            {
                string xmlJlac10Cd = mainElementRec.GetAttribute("code");

                if (xmlJlac10Cd == jlac10Cd)
                {
                    // 指定された検査項目の結果値を取得
                    XmlNode node = mainElementRec.ParentNode;
                    foreach (XmlElement elementRec in node.ChildNodes)
                    {
                        if (!interpretationflg)
                        {
                            // 結果値を取得
                            if (elementRec.Name == "value")
                            {
                                // 数値
                                retResult = elementRec.GetAttribute("value");
                                // コード
                                retResult += elementRec.GetAttribute("code");
                                // 文章
                                retResult += elementRec.InnerXml;
                            }
                        }
                        else
                        {
                            // 解釈コードを取得
                            if (elementRec.Name == "interpretationCode")
                            {
                                retResult = elementRec.GetAttribute("code");
                            }
                        }
                    }
                }
            }

            return retResult;
        }

        /// <summary>
        /// XMLインデックスデータ作成
        /// </summary>
        /// <param name="document">XMLドキュメント</param>
        /// <param name="xmlKind">健診種別</param>
        /// <param name="xmlDiv">実施区分</param>
        /// <param name="outDate">出力日</param>
        /// <param name="orgSrc">送付元機関</param>
        /// <param name="dstOrgNo">送付先機関</param>
        /// <param name="fileCnt">ファイル数</param>
        protected override void CreateXML_Index(XmlDocument document, string xmlKind, string xmlDiv, string outDate, string orgSrc, string dstOrgNo, string fileCnt)
        {
            // XMLヘッダ部作成
            // XML:インストラクション
            XmlProcessingInstruction instruction = document.CreateProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
            document.AppendChild(instruction);

            // XML:ルートノード＆名前空間定義
            XmlElement root = document.CreateElement("index");
            root.SetAttribute("xmlns", "http://tokuteikenshin.jp/checkup/2007");
            root.SetAttribute("xmlns:xsi", XML_NAMESPACE);
            XmlAttribute xmlAttribute = document.CreateAttribute("xsi", "schemaLocation", XML_NAMESPACE);
            xmlAttribute.Value = "http://tokuteikenshin.jp/checkup/2007 ./XSD/ix08_V08.xsd";
            root.Attributes.Append(xmlAttribute);
            document.AppendChild(root);

            // XML本体
            var xmlelement = new XmlElement[2];

            xmlelement[0] = document.CreateElement("interactionType");
            xmlelement[0].SetAttribute("code", xmlKind);
            root.AppendChild(xmlelement[0]);

            xmlelement[0] = document.CreateElement("creationTime");
            xmlelement[0].SetAttribute("value", outDate);
            root.AppendChild(xmlelement[0]);

            xmlelement[0] = document.CreateElement("sender");
            xmlelement[1] = document.CreateElement("id");
            xmlelement[1].SetAttribute("root", "1.2.392.200119.6.102");
            if (xmlKind == "1" || xmlKind == "6")
            {
                // 送付元機関が特定健診機関なら10桁
                xmlelement[1].SetAttribute("extension", orgSrc.PadLeft(10, '0'));
            }
            else
            {
                // 送付元機関が代行機関・保険者なら8桁
                xmlelement[1].SetAttribute("extension", orgSrc.PadLeft(8, '0'));
            }
            xmlelement[0].AppendChild(xmlelement[1]);
            root.AppendChild(xmlelement[0]);

            if (xmlKind != "9" && xmlKind != "10")
            {
                xmlelement[0] = document.CreateElement("receiver");
                xmlelement[1] = document.CreateElement("id");

                if (xmlKind == "1")
                {
                    xmlelement[1].SetAttribute("root", "1.2.392.200119.6.103");
                }
                else if (xmlKind == "6")
                {
                    xmlelement[1].SetAttribute("root", "1.2.392.200119.6.101");
                }

                if (xmlKind == "2" || xmlKind == "7")
                {
                    // 送付先機関が特定健診機関なら10桁
                    xmlelement[1].SetAttribute("extension", dstOrgNo.PadLeft(10, '0'));
                }
                else
                {
                    // 送付先機関が代行機関・保険者なら8桁
                    xmlelement[1].SetAttribute("extension", dstOrgNo.PadLeft(8, '0'));
                }
                xmlelement[0].AppendChild(xmlelement[1]);
                root.AppendChild(xmlelement[0]);
            }

            xmlelement[0] = document.CreateElement("serviceEventType");
            xmlelement[0].SetAttribute("code", xmlDiv);
            root.AppendChild(xmlelement[0]);

            xmlelement[0] = document.CreateElement("totalRecordCount");
            xmlelement[0].SetAttribute("value", fileCnt);
            root.AppendChild(xmlelement[0]);
        }

        /// <summary>
        /// XML集計情報データ作成
        /// </summary>
        /// <param name="document">XMLドキュメント</param>
        /// <param name="xmlDiv">実施区分</param>
        /// <param name="patientCnt">受診者数</param>
        /// <param name="totalPayment">窓口支払金額総計</param>
        /// <param name="totalClaim">請求金額総計</param>
        /// <param name="totalOther">他検診負担金額総計</param>
        protected override void CreateXML_Summary(XmlDocument document, string xmlDiv, int patientCnt, int totalPayment, int totalClaim, int totalOther)
        {
            // XMLヘッダ部作成
            // XML:インストラクション
            XmlProcessingInstruction instruction = document.CreateProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
            document.AppendChild(instruction);

            // XML:ルートノード＆名前空間定義
            XmlElement root = document.CreateElement("summary");
            root.SetAttribute("xmlns", "http://tokuteikenshin.jp/checkup/2007");
            root.SetAttribute("xmlns:xsi", XML_NAMESPACE);
            XmlAttribute xmlAttribute = document.CreateAttribute("xsi", "schemaLocation", XML_NAMESPACE);
            xmlAttribute.Value = "http://tokuteikenshin.jp/checkup/2007 ./XSD/su08_V08.xsd";
            root.Attributes.Append(xmlAttribute);
            document.AppendChild(root);

            // XML本体                       
            root.AppendChild(document.CreateComment("実施区分"));
            XmlElement xmlelement = document.CreateElement("serviceEventType");
            xmlelement.SetAttribute("code", xmlDiv);
            root.AppendChild(xmlelement);

            root.AppendChild(document.CreateComment("特定健診受診者／特定保健指導利用者の総数"));
            xmlelement = document.CreateElement("totalSubjectCount");
            xmlelement.SetAttribute("value", Util.ConvertToString(patientCnt));
            root.AppendChild(xmlelement);

            int temptotal = totalPayment + totalClaim;
            root.AppendChild(document.CreateComment("特定健診 単価総計／特定保健指導 算定金額総計"));
            xmlelement = document.CreateElement("totalCostAmount");
            xmlelement.SetAttribute("value", Util.ConvertToString(temptotal));
            xmlelement.SetAttribute("currency", "JPY");
            root.AppendChild(xmlelement);

            root.AppendChild(document.CreateComment("特定健診／特定保健指導の窓口支払の金額総計"));
            xmlelement = document.CreateElement("totalPaymentAmount");
            xmlelement.SetAttribute("value", Util.ConvertToString(totalPayment));
            xmlelement.SetAttribute("currency", "JPY");
            root.AppendChild(xmlelement);

            root.AppendChild(document.CreateComment("他の検診による負担金額の総計"));
            xmlelement = document.CreateElement("totalPaymentByOtherProgram");
            xmlelement.SetAttribute("value", Util.ConvertToString(totalOther));
            xmlelement.SetAttribute("currency", "JPY");
            root.AppendChild(xmlelement);

            root.AppendChild(document.CreateComment("特定健診／特定保健指導の請求金額総計"));
            xmlelement = document.CreateElement("totalClaimAmount");
            xmlelement.SetAttribute("value", Util.ConvertToString(totalClaim));
            xmlelement.SetAttribute("currency", "JPY");
            root.AppendChild(xmlelement);
        }

        /// <summary>
        /// 結果の書式変換
        /// </summary>
        /// <param name="result">検査結果</param>
        /// <param name="style">書式</param>
        /// <returns>変換結果</returns>
        private string ConvStyleinResult(string result, string style)
        {
            string convresult = result;

            if (double.TryParse(result, out double tmpresult))
            {
                // 表現範囲の最大値を設定する
                string max = style.Replace("#","9").Replace("0","9");

                // 表現範囲の最小値を設定する（最大値のマイナスとする）
                string min = "-" + max;
                
                if (double.TryParse(max, out double tmpmax)
                    && double.TryParse(min, out double tmpmin))
                {
                    // 表現範囲の最大値を超えている場合、最大値に置き換える
                    if (tmpresult > tmpmax)
                    {
                        convresult = Util.ConvertToString(tmpmax);
                    }
                    // 表現範囲の最小値を超えている場合、最小値に置き換える
                    if (tmpresult < tmpmin)
                    {
                        convresult = Util.ConvertToString(tmpmin);
                    }
                }
            }

            return convresult;
        }

        /// <summary>
        /// 血圧の特殊処理
        ///     血圧は、1回目・2回目・その他のうち、有効なもの１つのみをXML出力する。
        ///     そのため、不要になる出力項目は g_stNotOutputItemCd17 に登録し、出力されないようにする。
        ///     同時に、出力すべき血圧結果値を記憶しておく。
        /// </summary>
        /// <param name="verDiv">バージョン識別区分</param>
        /// <param name="jlac10conv">JLAC10変換情報</param>
        /// <param name="data">対象データ</param>
        private void ChoiceBloodPressure(List<dynamic> jlac10Conv, string verDiv, IDictionary<string, object> data)
        {
            // 1回目・2回目・その他のうち、有効なもの１つのみをXML出力する
            // 1.JLAC10CONVの情報から、血圧に関係する項目だけ変換を実行してみる
            // 2.取得できた結果により、どの項目を残すかを決定し、出力する値を保存しておく
            // 3.出力不要な項目を g_stNotOutputItemCd17 に追加する

            // 1.血圧項目の変換実行
            var tmpResult = new string[6];

            for (int itemcnt = 0; itemcnt < ResultPressure.Count - 1; ++itemcnt)
            {
                foreach (IDictionary<string, object> jlac10ConvRec in jlac10Conv)
                {
                    int convcnt = 0;

                    if (Util.ConvertToString(jlac10ConvRec["JLAC10CD17"]) == Jlac10CdPressure[itemcnt])
                    {                        
                        XML_RESULT_INFO xmlresult = convToJLAC10(verDiv, jlac10ConvRec, data);
                        ResultPressure[itemcnt] = xmlresult.getflg;

                        // 血圧0なら取得できなかったことにする
                        if (string.IsNullOrEmpty(xmlresult.result))
                        {
                            ResultPressure[itemcnt] = false;
                        }
                        else
                        {
                            tmpResult[itemcnt] = xmlresult.result;
                        }

                        // 項目の位置を記憶
                        PosItem[itemcnt] = convcnt;
                        break;
                    }

                    convcnt += 1;
                }
            }

            // 2.残す項目の決定
            // 収縮期血圧
            if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]
                && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]
                && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)])
            {
                // CASE A（１回目のみ出力）
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] = true;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] = false;
            }
            else if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]
                    && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]
                    && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)])
            {
                // CASE B（１回目・２回目の平均をその他として出力）
                if (double.TryParse(tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)], out double value1)
                    && double.TryParse(tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)], out double value2))
                {
                    double calcvalue = Math.Truncate(((value1 + value2) / 2) + (0.5 * Math.Sign(value1 + value2) / 2));
                    XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)] = Util.ConvertToString(calcvalue);

                    ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] = false;
                    ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] = false;
                    ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] = true;
                }
            }
            else if (!ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]
                    && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]
                    && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)])
            {
                // CASE C（２回目のみ出力）
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] = true;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] = false;
            }
            else if (!ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]
                    && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]
                    && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)])
            {
                // CASE D（その他のみ出力）
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] = true;
            }
            else if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)])
            {
                // CASE E（その他のみ出力）※XML仕様書にはファイル作成側の記述がないが、受理側の仕様に基づいて「その他」のみ残す
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] = true;
            }

            // 拡張期血圧
            if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]
                && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]
                && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)])
            {
                // CASE A（１回目のみ出力）
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Kakuchou)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)] = true;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)] = false;
            }
            else if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]
                    && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]
                    && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)])
            {
                // CASE B（１回目・２回目の平均をその他として出力）
                if (double.TryParse(tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)], out double value1)
                    && double.TryParse(tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)], out double value2))
                {
                    double calcvalue = Math.Truncate(((value1 + value2) / 2) + (0.5 * Math.Sign(value1 + value2) / 2));
                    XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Kakuchou)] = Util.ConvertToString(calcvalue);

                    ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)] = false;
                    ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] = false;
                    ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)] = true;
                }
            }
            else if (!ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]
                    && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]
                    && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)])
            {
                // CASE C（２回目のみ出力）
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Kakuchou)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] = true;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)] = false;
            }
            else if (!ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]
                    && !ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]
                    && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)])
            {
                // CASE D（その他のみ出力）
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Kakuchou)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)] = true;
            }
            else if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)])
            {
                // CASE E（その他のみ出力）※XML仕様書にはファイル作成側の記述がないが、受理側の仕様に基づいて「その他」のみ残す
                XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Kakuchou)] = tmpResult[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)];

                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] = false;
                ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)] = true;
            }

            // 3.出力不要な項目を NotOutJlac10Cd に追加
            // １回目・２回目・その他とあるが、出力するのは１つだけ。出力しない項目はここで登録する。
            // XML出力処理中で、血圧の出力があれば XmlResultBloodPressure を出力する。
            
            var notOutItemList = new List<string>();

            if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)])
            {
                // 収縮期・拡張期ともに１回目のみ有効
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)]);
            }
            else if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)])
            {
                // 収縮期・拡張期ともに２回目のみ有効
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)]);
            }
            else if (ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] && ResultPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)])
            {
                // その他が有効な場合、または１回目・２回目の平均値を出力する場合、または収縮期と拡張期で有効な検査回数が異なる場合
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]);

                // その他を出力する場合、変換テーブルに「血圧（その他）」の項目が必要
                // →なければ、１回目か２回目をその他に強制的に置き換える

                int tmppos = -1;

                // 収縮期：変換テーブルに「その他」がなければ、他の項目を利用して作成
                if (PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)] == -1)
                {
                    tmppos = -1;

                    // 「１回目」「２回目」のうち、手前にある方を選択→位置を記憶
                    if (PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)] > 0)
                    {
                        tmppos = PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)];
                    }
                    if (PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] > 0
                        && PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)] < PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)])
                    {
                        tmppos = PosItem[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)];
                    }

                    // 「２回目」（または「１回目」）を「その他」に置き換える
                    jlac10Conv[tmppos].JLAC10CD17 = Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)];
                }

                // 拡張期：変換テーブルに「その他」がなければ、他の項目を利用して作成
                if (PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)] == -1)
                {
                    tmppos = -1;

                    // 「１回目」「２回目」のうち、手前にある方を選択→位置を記憶
                    if (PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)] > 0)
                    {
                        tmppos = PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)];
                    }
                    if (PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] > 0
                        && PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)] < PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)])
                    {
                        tmppos = PosItem[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)];
                    }

                    // 「２回目」（または「１回目」）を「その他」に置き換える
                    jlac10Conv[tmppos].JLAC10CD17 = Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)];
                }
            }
            else
            {
                // ペアになる測定値がない→出力不可
                // 出力不可項目の配列をさらに拡張
                // すべて出力不可に
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]);
                notOutItemList.Add(Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)]);
            }

            foreach (string notOutItemRec in notOutItemList)
            {
                var notOutItemInfo = new Dictionary<string, object>();

                notOutItemInfo.Add("XMLITEM_AUTHORITEM", notOutItemRec);
                NotOutJlac10Cd.Add(notOutItemInfo);
            }
        }                                

        /// <summary>
        /// JLAC10結果へ変換
        /// </summary>
        /// <param name="verDiv">JLAC10バージョン識別区分</param>
        /// <param name="jlac10conv">JLAC10変換情報</param>
        /// <param name="data">対象データ</param>
        /// <returns>JLAC10結果情報</returns>
        private XML_RESULT_INFO convToJLAC10(string verDiv, IDictionary<string, object> jlac10Conv, IDictionary<string, object> data)
        {            
            var jlac10CdRectumObs = new List<string>();     // 直腸肛門機能（所見）の検査項目JLAC10コード
            jlac10CdRectumObs.Add("9Z770160800000049");     // 直腸肛門機能１項目（所見）
            jlac10CdRectumObs.Add("9Z771160800000049");     // 直腸肛門機能２項目以上（所見）

            var jlac10CdRectumObsExist = new List<string>();    // 直腸肛門機能（所見有無）の検査項目JLAC10コード
            jlac10CdRectumObsExist.Add("9Z770160700000011");    // 直腸肛門機能１項目（所見有無）
            jlac10CdRectumObsExist.Add("9Z771160700000011");    // 直腸肛門機能２項目以上（所見有無）
            jlac10CdRectumObsExist.Add("9A110160700000011");    // 心電図（所見有無）

            const string jlac10CdDoctorJud = "9N511000000000049";       // 医師の診断(判定)の検査項目JLAC10コード
            const string jlac10CdMetaboJud = "9N501000000000011";       // メタボリックシンドローム判定の検査項目JLAC10コード
            const string jlac10CdBldTime = "9N141000000000011";         // 採血時間の検査項目JLAC10コード
            const string jlac10CdChangeWeight = "9N741000000000011";    // ２０歳からの体重変化の検査項目JLAC10コード
            const string jlac10CdAlcAmount = "9N791000000000011";       // 飲酒量の検査項目のJLAC10コード
            const string jlac10CdStools = "1B030000001599811";          // 便潜血の検査項目のJLAC10コード
            const string jlac10CdHujinClass = "7A021165008543311";      // 子宮頸部細胞診(日母分類)の検査項目のJLAC10コード                        

            // JLAC10情報テーブルから基本情報を取得
            string jlac10Cd = Util.ConvertToString(jlac10Conv["JLAC10CD17"]);
            string dstOrgNo = Util.ConvertToString(data["ISRORGNO"]);
            IDictionary<string, object> jlac10Info = SearchJLAC10Info(verDiv, jlac10Cd, XMLSEC_DIV.None, dstOrgNo);

            if (!int.TryParse(Util.ConvertToString(data["RSVNO"]), out int rsvNo))
            {
                rsvNo = 0;
            }

            // マッチする区切り文字を調査(ない場合は=とする)
            string delimiter = "=";
            string jlac10Condition = Util.ConvertToString(jlac10Conv["CONDITION"]);
            if (jlac10Condition.IndexOf("!=") > 0)
            {
                delimiter = "!=";
            }
            string[] delimiterData = { delimiter };
            string[] convCondition = jlac10Condition.Split(delimiterData, StringSplitOptions.RemoveEmptyEntries);

            // 上部消化管Ｘ線、内視鏡判定
            string ibuItem = GetSpProcessDiv(jlac10Cd, FREE_XMLIBUITEM);

            if (!string.IsNullOrEmpty(ibuItem))
            {
                if (ibuItem != Util.ConvertToString(data["SETCLASS"]))
                {
                    return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                }
            }            

            // 変換条件のチェック（検査項目の結果が特定の値かどうか）
            string convType = Util.ConvertToString(jlac10Conv["CONVTYPE"]);
            string result = "";

            var judData = new List<dynamic>();
            var resultData = new List<dynamic>();

            bool errorCondition = false;
            bool existsflg = false;

            if (convCondition.Count() == 2)
            {
                if (!errorCondition)
                {
                    // 指定した検査項目の結果を取得
                    if (convType == CONVTYPE_JUDGE || convType == CONVTYPE_JUDGECOMMENT || convType == CONVTYPE_DRNAME)
                    {
                        judData = GetJudRsl(rsvNo, convCondition[0]);

                        foreach (IDictionary<string, object> judDataRec in judData)
                        {
                            bool breakflg = false;
                            existsflg = true;

                            switch (convType)
                            {
                                case CONVTYPE_JUDGE:
                                    result = Util.ConvertToString(judDataRec["JUDCD"]);
                                    breakflg = true;
                                    break;
                                case CONVTYPE_JUDGECOMMENT:
                                    result += Util.ConvertToString(judDataRec["JUDCMTSTC"]);
                                    break;
                                case CONVTYPE_DRNAME:
                                    result = Util.ConvertToString(judDataRec["DRNAME"]);
                                    breakflg = true;
                                    break;
                                default:
                                    break;
                            }

                            if (breakflg)
                            {
                                break;
                            }
                        }
                    }
                    else
                    {
                        // 検査結果を取得
                        // 特殊条件区分を取得
                        string conditionDiv = GetSpProcessDiv(jlac10Cd, FREE_XMLJUDCLSCOND);

                        if (conditionDiv == "JUDCLASS")
                        {
                            // 判定分類を条件とする
                            judData = GetJudRsl(rsvNo, convCondition[0]);

                            foreach (IDictionary<string, object> judDataRec in judData)
                            {
                                existsflg = true;
                                result = Util.ConvertToString(judDataRec["JUDCD"]);
                                break;
                            }
                        }
                        else
                        {
                            resultData = GetResult(rsvNo, convCondition[0]);

                            if (resultData != null)
                            {
                                existsflg = true;

                                // 一つ目のデータを取得
                                foreach (IDictionary<string, object> resultRec in resultData)
                                {
                                    if (!string.IsNullOrEmpty(Util.ConvertToString(resultRec["RESULT"])))
                                    {
                                        result = Util.ConvertToString(resultRec["RESULT"]);
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    // 変換条件文字列が空文字列の場合、エラー
                    if (string.IsNullOrEmpty(convCondition[1]))
                    {
                        errorCondition = true;
                    }
                    else
                    {
                        // 変換条件の区切り文字により処理を変更
                        switch (delimiter)
                        {
                            case "=":
                                switch (convCondition[1])
                                {
                                    case CONDITION_EXISTS:
                                        // 変換条件文字列が「exists」の場合、テーブルに項目があれば、内容に関係なく変換実行
                                        if (!existsflg)
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                        break;

                                    case CONDITION_NOTEXISTS:
                                        // 変換条件文字列が「notexists」の場合、テーブルに項目がなければ変換実行
                                        if (existsflg)
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                        break;

                                    case CONDITION_NULL:
                                        // 変換条件文字列が「null」の場合、テーブルに項目があり、NULLまたは空文字列のとき変換実行
                                        if (!existsflg)
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                        else if (!string.IsNullOrEmpty(result))
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                        break;

                                    default:
                                        if (existsflg)
                                        {
                                            if (result != convCondition[1])
                                            {
                                                // 変換条件に合わないため、この変換は行わない
                                                return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                            }
                                        }
                                        else
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                        break;
                                }
                                break;

                            case "!=":
                                // 変換条件文字列が「null」の場合、テーブルに項目があり、NULLまたは空文字列でないとき変換実行
                                if (convCondition[1] == CONDITION_NULL)
                                {
                                    if (!existsflg)
                                    {
                                        // 変換条件に合わないため、この変換は行わない
                                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                    }
                                    else if (string.IsNullOrEmpty(result))
                                    {
                                        // 変換条件に合わないため、この変換は行わない
                                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                    }
                                }
                                else
                                {
                                    // 指定値(テーブルに項目があり、NULLまたは空文字ではない)と等しくないとき変換実行
                                    if (existsflg)
                                    {
                                        if (string.IsNullOrEmpty(result))
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                        else if (result == convCondition[1])
                                        {
                                            // 変換条件に合わないため、この変換は行わない
                                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                        }
                                    }
                                    else
                                    {
                                        // 変換条件に合わないため、この変換は行わない
                                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                    }
                                }
                                break;

                            default:
                                break;
                        }
                    }
                }
            }
            else if (!(convCondition.Count() <= 0))
            {
                // 変換条件が１組ではなく、未設定でもない
                errorCondition = true;
            }

            if (errorCondition)
            {
                // 変換条件の設定に誤りがある
                writeJlac10ConvLog(ERROR_DIV.ConvCondition, jlac10Cd, rsvNo);
                return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
            }

            // 変換ルール（置換文字列）を取得して配列に
            string convRule = Util.ConvertToString(jlac10Conv["CONVRULE"]);
            string[] convRules = convRule.Split(',');

            // 検査項目を取得
            string itemcdSuffix = Util.ConvertToString(jlac10Conv["ITEMCD"]);
            string[] itemcdSuffixes = itemcdSuffix.Split('+');
            var itemcdList = new List<string>();

            // グループ項目を取得する
            foreach (var itemcdRec in itemcdSuffixes)
            {
                string item = itemcdRec;

                if (convType != CONVTYPE_JUDGE && convType != CONVTYPE_JUDGECOMMENT && convType != CONVTYPE_DRNAME)
                {
                    if (itemcdRec.Length < 7 && itemcdRec != "null")
                    {
                        var grpItem = new List<dynamic>();
                        if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) == XMLTYPE_ST)
                        {
                            grpItem = GetGrpItem(rsvNo, item, true);
                        }
                        else
                        {
                            grpItem = GetGrpItem(rsvNo, item, false);
                        }

                        foreach (IDictionary<string, object> grpItemRec in grpItem)
                        {
                            itemcdList.Add(Util.ConvertToString(grpItemRec["ITEMCD"]));
                        }
                    }
                    else
                    {
                        itemcdList.Add(item);
                    }
                }
                else
                {
                    itemcdList.Add(item);
                }
            }

            int totalCnt = 0;

            RESULT_INFO resultInfo = InitResultInfo();
            var resultInfoList = new List<RESULT_INFO>();

            foreach (var itemcdRec in itemcdList)
            {
                bool rslExistsflg = false;
                bool spItemRslflg = false;
                bool exitflg = false;

                if (convType == CONVTYPE_JUDGE || convType == CONVTYPE_JUDGECOMMENT || convType == CONVTYPE_DRNAME)
                {
                    judData = GetJudRsl(rsvNo, itemcdRec);

                    foreach (IDictionary<string, object> judDataRec in judData)
                    {
                        bool braekflg = false;
                        existsflg = true;
                        rslExistsflg = true;

                        resultInfo.rsvno = rsvNo;
                        resultInfo.itemcd = itemcdRec;
                        switch (convType)
                        {
                            case CONVTYPE_JUDGE:
                                resultInfo.result = Util.ConvertToString(judDataRec["JUDCD"]);
                                braekflg = true;
                                break;
                            case CONVTYPE_JUDGECOMMENT:
                                resultInfo.result += Util.ConvertToString(judDataRec["JUDCMTSTC"]);
                                resultInfo.judrsl = Util.ConvertToString(judDataRec["JUDCD"]);
                                break;
                            case CONVTYPE_DRNAME:
                                resultInfo.result = Util.ConvertToString(judDataRec["DRNAME"]);
                                resultInfo.result = resultInfo.result.Replace(" ", "").Replace("　", "");
                                braekflg = true;
                                break;
                            default:
                                break;
                        }

                        if (braekflg)
                        {
                            break;
                        }
                    }
                }
                else
                {
                    if ((convType == CONVTYPE_FIND || convType == CONVTYPE_CONST) && itemcdRec == "null")
                    {
                        // 3…検索、5…固定値で検査項目コードに"null"が指定されている場合
                        resultInfo.rsvno = rsvNo;
                        resultInfo.csldate = Util.ConvertToString(data["CSLDATE"]);
                        resultInfo.result = "";
                        resultInfo.itemcd = "";
                        resultInfo.suffix = "";
                        resultInfo.rsltype = RESULTTYPE_NUMBER;

                        rslExistsflg = true;
                    }
                    else if (convType == CONVTYPE_DATE)
                    {
                        // 4…年月日が指定されている場合
                        resultInfo.rsvno = rsvNo;
                        resultInfo.csldate = Util.ConvertToString(data["CSLDATE"]);
                        resultInfo.result = "";
                        resultInfo.itemcd = "";
                        resultInfo.suffix = "";
                        resultInfo.rsltype = RESULTTYPE_DATE;

                        rslExistsflg = true;
                    }
                    else
                    {
                        string spItemResult = "";

                        switch (jlac10Cd)
                        {
                            case jlac10CdDoctorJud:
                                // 医師の診断(判定)取得
                                spItemResult = GetDoctorJud(rsvNo);
                                break;

                            case jlac10CdMetaboJud:
                                // メタボリックシンドローム判定取得
                                spItemResult = GetMetaboJud(rsvNo);
                                break;

                            case jlac10CdBldTime:
                                // 採血時間をグループで判断する
                                spItemResult = Util.ConvertToString(data["RSVGRPCD"]);
                                break;

                            case jlac10CdAlcAmount:
                                // 飲酒量取得
                                spItemResult = GetAlcohol(rsvNo, itemcdSuffixes[0]);
                                break;

                            case jlac10CdStools:
                                // 便潜血取得
                                spItemResult = GetStools(rsvNo, itemcdSuffixes[0]);
                                break;

                            case jlac10CdHujinClass:
                                // 子宮頸部細胞診(日母分類)取得
                                spItemResult = GetHujinClass(rsvNo, itemcdSuffixes[0]);
                                break;

                            default:
                                spItemResult = "";
                                break;
                        }

                        if (!string.IsNullOrEmpty(spItemResult))
                        {
                            spItemRslflg = true;
                        }

                        if (spItemRslflg)
                        {
                            rslExistsflg = true;

                            resultInfo.rsvno = rsvNo;
                            resultInfo.csldate = Util.ConvertToString(data["CSLDATE"]);
                            resultInfo.itemcd = "";
                            resultInfo.suffix = "";
                            resultInfo.result = spItemResult;
                            resultInfo.sentence = spItemResult;
                            resultInfo.rsltype = RESULTTYPE_SENTENCE;

                            exitflg = true;
                        }
                        else
                        {
                            // 検査結果を取得
                            resultData = GetResult(rsvNo, itemcdRec);

                            // 所見特殊取得
                            string speStcItem = GetSpProcessDiv(jlac10Cd, FREE_XMLSPESTC);

                            // 現病歴・既往歴区分取得
                            string diseaseDiv = GetSpProcessDiv(jlac10Cd, FREE_XMLDISEASE);

                            // 服薬区分取得
                            string medicineDiv = GetSpProcessDiv(jlac10Cd, FREE_XMLMEDICINE);

                            if (!string.IsNullOrEmpty(speStcItem))
                            {
                                // 特殊所見
                                resultInfo.rsvno = rsvNo;                                
                                resultInfo.itemcd = "";
                                resultInfo.suffix = "";
                                resultInfo.rsltype = RESULTTYPE_SENTENCE;

                                // 文章取得
                                IDictionary<string, object> stcInfo = GetSentence(resultInfo.rsvno, itemcdRec, resultInfo.rsltype);

                                if (stcInfo != null && stcInfo.Count > 0)
                                {
                                    resultInfo.result = Util.ConvertToString(stcInfo["STCCD"]);
                                    resultInfo.sentence = Util.ConvertToString(stcInfo["REPTSTC"]);
                                }
                                else
                                {
                                    resultInfo.result = "";
                                    resultInfo.sentence = "";
                                }                                 

                                rslExistsflg = true;
                            }
                            else if (!string.IsNullOrEmpty(diseaseDiv))
                            {
                                // 現病歴・既往歴
                                resultInfo.rsvno = rsvNo;
                                resultInfo.csldate = Util.ConvertToString(data["CSLDATE"]);
                                resultInfo.result = GetDisease(rsvNo, itemcdSuffixes[0], diseaseDiv);
                                resultInfo.itemcd = "";
                                resultInfo.suffix = "";
                                resultInfo.rsltype = RESULTTYPE_SENTENCE;

                                rslExistsflg = true;
                                exitflg = true;
                            }
                            else if (!string.IsNullOrEmpty(medicineDiv))
                            {
                                // 服薬歴
                                resultInfo.rsvno = rsvNo;
                                resultInfo.csldate = Util.ConvertToString(data["CSLDATE"]);
                                resultInfo.result = GetMedicine(rsvNo, itemcdSuffixes[0], medicineDiv);
                                resultInfo.itemcd = "";
                                resultInfo.suffix = "";
                                resultInfo.rsltype = RESULTTYPE_SENTENCE;

                                rslExistsflg = true;
                                exitflg = true;
                            }
                            else if (resultData.Count > 0)
                            {
                                rslExistsflg = true;

                                // 一つ目のデータを取得
                                foreach (IDictionary<string, object> resultRec in resultData)
                                {
                                    if (!string.IsNullOrEmpty(Util.ConvertToString(resultRec["RESULT"])))
                                    {
                                        resultInfo.rsvno = rsvNo;
                                        resultInfo.csldate = Util.ConvertToString(data["CSLDATE"]);
                                        resultInfo.itemcd = Util.ConvertToString(resultRec["ITEMCD"]);
                                        resultInfo.suffix = Util.ConvertToString(resultRec["SUFFIX"]);
                                        resultInfo.itemname = Util.ConvertToString(resultRec["ITEMNAME"]);
                                        resultInfo.itemsname = Util.ConvertToString(resultRec["ITEMSNAME"]);
                                        resultInfo.itemrname = Util.ConvertToString(resultRec["ITEMRNAME"]);
                                        resultInfo.itemqname = Util.ConvertToString(resultRec["ITEMQNAME"]);
                                        resultInfo.result = Util.ConvertToString(resultRec["RESULT"]);
                                        resultInfo.rsltype = Util.ConvertToString(resultRec["RESULTTYPE"]);

                                        // 基準値範囲取得
                                        string upperValue = "";
                                        string lowerValue = "";
                                        IDictionary<string, object> stdRange = GetStdRange(rsvNo, resultInfo.itemcd, resultInfo.suffix);

                                        if (stdRange != null)
                                        {
                                            upperValue = Util.ConvertToString(stdRange["UPPERVALUE"]);
                                            lowerValue = Util.ConvertToString(stdRange["LOWERVALUE"]);
                                        }

                                        resultInfo.uppervalue = upperValue;
                                        resultInfo.lowervalue = lowerValue;

                                        if (resultInfo.rsltype == RESULTTYPE_SENTENCE || resultInfo.rsltype == RESULTTYPE_MEMO)
                                        {
                                            // 文章取得
                                            IDictionary<string, object> stcInfo = GetSentence(resultInfo.rsvno, resultInfo.itemcd + resultInfo.suffix, resultInfo.rsltype);

                                            if (stcInfo.Count > 0)
                                            {
                                                resultInfo.sentence = Util.ConvertToString(stcInfo["REPTSTC"]);
                                            }
                                            else
                                            {
                                                resultInfo.sentence = "";
                                            }
                                        }
                                        else
                                        {
                                            resultInfo.sentence = "";
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }

                if (rslExistsflg)
                {
                    // 検査結果がある
                    resultInfoList.Add(resultInfo);

                    totalCnt += 1;

                    if (exitflg)
                    {
                        break;
                    }
                }
            }

            if (totalCnt == 0)
            {
                // 結果がない
                return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
            }

            // 変換テーブル内容に沿って変換実行
            int cntResultNotEmpty = 0;

            string xmlResult = "";
            string tmpXmlResult = "";

            var freeDao = new FreeDao(connection);

            switch (convType)
            {
                case CONVTYPE_COEFFICIENT:
                    // 0…数値・文字列（係数）

                    // 検査結果を取得
                    switch (resultInfoList[0].rsltype)
                    {
                        case RESULTTYPE_NUMBER:
                        case RESULTTYPE_CALC:
                        case RESULTTYPE_SIGN:
                            // 結果タイプ=数値/計算/符号つき数値
                            Single sngvalue;

                            // 変換ルール（係数）を取得
                            if (convRules.Count() == 0)
                            {
                                sngvalue = 1;
                            }
                            else
                            {
                                sngvalue = 1;
                                if (!string.IsNullOrEmpty(convRules[0]))
                                {
                                    if (!Single.TryParse(convRules[0], out sngvalue))
                                    {
                                        sngvalue = 1;
                                    }
                                }
                            }

                            // １番目の項目コードの検査結果が登録されていない場合、
                            // ２番目以降の項目コードの検査結果が登録されていればそれを出力に用いる
                            if (string.IsNullOrEmpty(resultInfoList[0].result))
                            {
                                foreach (var resulInfoRec in resultInfoList)
                                {
                                    if (!string.IsNullOrEmpty(resulInfoRec.result))
                                    {
                                        resultInfoList[0] = resulInfoRec;
                                        break;
                                    }
                                }
                            }

                            // 書式変換
                            if (string.IsNullOrEmpty(resultInfoList[0].result))
                            {
                                xmlResult = "";
                            }
                            else
                            {
                                if (double.TryParse(resultInfoList[0].result, out double numResult))
                                {
                                    // 検査結果が数値
                                    xmlResult = GetXMLResult(jlac10Info, Util.ConvertToString(numResult * sngvalue));
                                }
                                else
                                {
                                    // 検査結果が数値以外
                                    writeJlac10ConvLog(ERROR_DIV.Result, jlac10Cd, rsvNo);
                                    return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                }

                                if (!string.IsNullOrEmpty(resultInfoList[0].uppervalue))
                                {
                                    RESULT_INFO tmpResult = resultInfoList[0];

                                    if (double.TryParse(resultInfoList[0].uppervalue, out double upper))
                                    {
                                        // 基準値（正常値上限）が数値
                                        tmpResult.uppervalue = Util.ConvertToString(upper * sngvalue);
                                    }
                                    else
                                    {
                                        // 基準値（正常値上限）が数値以外
                                        writeJlac10ConvLog(ERROR_DIV.StdValue, jlac10Cd, rsvNo);
                                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                    }

                                    if (double.TryParse(resultInfoList[0].lowervalue, out double lower))
                                    {
                                        // 基準値（正常値下限）が数値
                                        tmpResult.lowervalue = Util.ConvertToString(lower * sngvalue);
                                    }
                                    else
                                    {
                                        // 基準値（正常値下限）が数値以外
                                        writeJlac10ConvLog(ERROR_DIV.StdValue, jlac10Cd, rsvNo);
                                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                                    }

                                    resultInfoList[0] = tmpResult;
                                }
                            }
                            break;

                        case RESULTTYPE_SENTENCE:
                        case RESULTTYPE_DATE:
                        case RESULTTYPE_MEMO:
                            // 結果タイプ=文章/日付/メモ
                            xmlResult = GetXMLResult(jlac10Info, Util.ConvertToString(resultInfoList[0].sentence));
                            break;

                        case RESULTTYPE_DEFINED_REG:
                        case RESULTTYPE_DEFINED_EX:
                        case RESULTTYPE_FREE:
                            // 結果タイプ=定性(標準)/定性(拡張)/フリー
                            xmlResult = GetXMLResult(jlac10Info, Util.ConvertToString(resultInfoList[0].result));
                            break;

                        default:
                            writeJlac10ConvLog(ERROR_DIV.ResultType, jlac10Cd, rsvNo);
                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                    }
                    break;

                case CONVTYPE_REPLACE:
                    // 1…数値・文字列（置換）

                    // 変換を実行
                    // ※変換ルールが、文章コードである場合と文章そのものである場合があるため、
                    // step 1.変換ルールがコードであると想定して、コード置換を試みる
                    // step 2.置換したコードで文章を取得する
                    // step 3.文章を変換ルールに則って置換する
                    // 以上３段階で置換を行う

                    string convResult = "";                    
                    xmlResult = "";
                    tmpXmlResult = "";

                    cntResultNotEmpty = 0;

                    bool convertflg = false;
                    foreach (var resultInfoRec in resultInfoList)
                    {
                        convResult = resultInfoRec.result;

                        // 結果の置換
                        convertflg = false;                        
                        if (resultInfoRec.rsltype != RESULTTYPE_MEMO)
                        {
                            for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                            {
                                // 「*」変換
                                if (convRules[rulePos] == CONVRULE_ALL)
                                {
                                    // 変換ルール「*」
                                    // *があったら変換第1段階終了
                                    break;
                                }

                                // その他の変換
                                if (resultInfoRec.result == convRules[rulePos] 
                                    || (string.IsNullOrEmpty(resultInfoRec.result) && convRules[rulePos] == CONVRULE_NULL))
                                {
                                    convResult = convRules[rulePos + 1];

                                    // 変換済み。今後変換しない
                                    convertflg = true;
                                    break;
                                }
                            }
                        }

                        // 結果タイプが文章型なら、DBから文章を取得してXML出力用の結果とする
                        tmpXmlResult = convResult;

                        if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) == XMLTYPE_ST)
                        {
                            // XML結果タイプが文字列型のときのみ、文章マスタ等から文章を取得
                            if (resultInfoRec.rsltype == RESULTTYPE_SENTENCE || resultInfoRec.rsltype == RESULTTYPE_MEMO)
                            {
                                if (!string.IsNullOrEmpty(resultInfoRec.sentence))
                                {
                                    tmpXmlResult = resultInfoRec.sentence;
                                }
                            }
                        }

                        switch (tmpXmlResult)
                        {
                            case CONVAFTER_ITEMNAME:
                                // 置換後文字列が「itemname」なら、検査項目名を出力する
                                tmpXmlResult = resultInfoRec.itemname;

                                // 変換済み。今後変換しない
                                convertflg = true;
                                break;

                            case CONVAFTER_SHORTNAME:
                                // 置換後文字列が「shortname」なら、検査項目略称名を出力する
                                tmpXmlResult = resultInfoRec.itemsname;

                                // 変換済み。今後変換しない
                                convertflg = true;
                                break;

                            case CONVAFTER_REPORTNAME:
                                // 置換後文字列が「reportname」なら、報告書用項目名を出力する
                                tmpXmlResult = resultInfoRec.itemrname;

                                // 変換済み。今後変換しない
                                convertflg = true;
                                break;

                            case CONVAFTER_QUESTIONNAME:
                                // 置換後文字列が「questionname」なら、問診用項目名を出力する
                                tmpXmlResult = resultInfoRec.itemqname;

                                // 変換済み。今後変換しない
                                convertflg = true;
                                break;

                            case CONVAFTER_NULL:
                                // 置換後文字列が「null」なら、出力しない
                                tmpXmlResult = "";

                                // 変換済み。今後変換しない
                                convertflg = true;
                                break;
                        }

                        if (!convertflg)
                        {
                            // 変換済みでない場合、文章での変換を試みる

                            // 結果文章を置換ルールで置換する
                            for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                            {
                                // 「*」変換
                                if (!string.IsNullOrEmpty(tmpXmlResult) && convRules[rulePos] == CONVRULE_ALL)
                                {
                                    // 変換ルール「*」
                                    if (convRules.Count() - 1 != rulePos && convRules[rulePos + 1] != CONVRULE_ALL)
                                    {
                                        // 「*,ABC」の場合
                                        tmpXmlResult = convRules[rulePos + 1];
                                        break;
                                    }
                                }

                                //その他の変換
                                if (tmpXmlResult == convRules[rulePos]
                                    || (string.IsNullOrEmpty(tmpXmlResult) && convRules[rulePos] == CONVRULE_NULL))
                                {
                                    tmpXmlResult = convRules[rulePos + 1];
                                    break;
                                }
                            }

                            switch (tmpXmlResult)
                            {
                                case CONVAFTER_ITEMNAME:
                                    // 置換後文字列が「itemname」なら、検査項目名を出力する
                                    tmpXmlResult = resultInfoRec.itemname;

                                    // 変換済み。今後変換しない
                                    convertflg = true;
                                    break;

                                case CONVAFTER_SHORTNAME:
                                    // 置換後文字列が「shortname」なら、検査項目略称名を出力する
                                    tmpXmlResult = resultInfoRec.itemsname;

                                    // 変換済み。今後変換しない
                                    convertflg = true;
                                    break;

                                case CONVAFTER_REPORTNAME:
                                    // 置換後文字列が「reportname」なら、報告書用項目名を出力する
                                    tmpXmlResult = resultInfoRec.itemrname;

                                    // 変換済み。今後変換しない
                                    convertflg = true;
                                    break;

                                case CONVAFTER_QUESTIONNAME:
                                    // 置換後文字列が「questionname」なら、問診用項目名を出力する
                                    tmpXmlResult = resultInfoRec.itemqname;

                                    // 変換済み。今後変換しない
                                    convertflg = true;
                                    break;

                                case CONVAFTER_NULL:
                                    // 置換後文字列が「null」なら、出力しない
                                    tmpXmlResult = "";

                                    // 変換済み。今後変換しない
                                    convertflg = true;
                                    break;
                            }

                            // 結果を結合

                            // 「著変なし」と他の所見が混ざっている時、「著変なし」は印字しないように排除
                            if (cntResultNotEmpty > 1)
                            {
                                if (tmpXmlResult.IndexOf("著変なし") >= 0)
                                {
                                    tmpXmlResult = "";
                                }
                            }

                            // 重複しない文章のみ抽出
                            if (xmlResult.IndexOf(tmpXmlResult) >= 0)
                            {
                                tmpXmlResult = "";
                            }

                            if (!string.IsNullOrEmpty(tmpXmlResult))
                            {
                                cntResultNotEmpty += 1;
                                if (RectumResult(jlac10Cd, cntResultNotEmpty, jlac10CdRectumObs, jlac10CdRectumObsExist))
                                {
                                    // 直腸肛門機能１項目の１項目目、
                                    // または２項目の２項目以上、
                                    // または直腸肛門機能でないとき
                                    if (!string.IsNullOrEmpty(xmlResult))
                                    {
                                        if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) == XMLTYPE_ST)
                                        {
                                            xmlResult += "、";
                                        }
                                        else
                                        {
                                            xmlResult += ",";
                                        }
                                    }
                                    xmlResult += tmpXmlResult;
                                }
                            }
                        }
                        else
                        {
                            xmlResult = tmpXmlResult;
                            break;
                        }
                    }

                    // 直腸肛門機能の場合、２項目目の変換結果が空ならXML出力しない
                    if (jlac10Cd == jlac10CdRectumObs[1] && !string.IsNullOrEmpty(xmlResult))
                    {
                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                    }

                    if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) == XMLTYPE_ST)
                    {
                        // 文章の場合は全角にする
                        xmlResult = Strings.StrConv(xmlResult, VbStrConv.Wide);
                    }

                    xmlResult = GetXMLResult(jlac10Info, xmlResult);
                    break;

                case CONVTYPE_COMPARE:
                    // 2…数値比較

                    // 結果の比較
                    Single cmpValue = 0;
                    double value = 0;
                    bool cmpflg = false;
                    string ruleResult = "";

                    if (jlac10Cd == jlac10CdChangeWeight && resultInfoList.Count >= 2)
                    {
                        // 体重変化算出処理
                        freeDao = new FreeDao(connection);
                        dynamic fixedWeightInfo = freeDao.SelectFree(0, FREE_XMLWEIGHT);

                        IDictionary<string, object> fixedWeight = fixedWeightInfo;

                        double weightC = 0;
                        double weightP = 0;

                        string weightCcd = resultInfoList[0].itemcd + resultInfoList[0].suffix;
                        string weightPcd = resultInfoList[1].itemcd + resultInfoList[1].suffix;

                        if (weightCcd == Util.ConvertToString(fixedWeight["FREEFIELD1"]) && weightPcd == Util.ConvertToString(fixedWeight["FREEFIELD2"]))
                        {
                            if (!double.TryParse(resultInfoList[0].result, out weightC)
                                && !double.TryParse(resultInfoList[0].result, out weightP))
                            {
                                // 検査結果が数値ではない
                                writeJlac10ConvLog(ERROR_DIV.Result, jlac10Cd, rsvNo);
                                return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                            }
                        }

                        value = Math.Abs(weightC - weightP);
                    }
                    else
                    {
                        if (!double.TryParse(resultInfoList[0].result, out value))
                        {
                            // 検査結果が数値ではない
                            writeJlac10ConvLog(ERROR_DIV.ResultType, jlac10Cd, rsvNo);
                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                        }
                    }
                                        
                    for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                    {
                        string tmpRule = convRules[rulePos];
                        tmpRule = tmpRule.Replace("<", "");
                        tmpRule = tmpRule.Replace(">", "");
                        tmpRule = tmpRule.Replace("=", "");

                        if (convRules[rulePos] != CONVRULE_ALL && !double.TryParse(tmpRule, out double rule))
                        {
                            // 変換ルールが数値（または*）ではない
                            writeJlac10ConvLog(ERROR_DIV.ConvRule, jlac10Cd, rsvNo);
                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                        }

                        if (convRules[rulePos] == CONVRULE_ALL)
                        {
                            // 「*」変換
                            if (convRules.Count() - 1 != rulePos && convRules[rulePos + 1] != CONVRULE_ALL)
                            {
                                // 変換後文字が*でなければルール指定の文字を出力
                                xmlResult = convRules[rulePos + 1];
                                break;
                            }
                            else
                            {
                                // 「*」のみまたは、変換後文字が*なら結果をそのまま出力
                                xmlResult = resultInfoList[0].result;
                                break;
                            }
                        }

                        if (convRules[rulePos].EndsWith(">=")
                            || convRules[rulePos].EndsWith("=>"))
                        {
                            cmpValue = Convert.ToChar(convRules[rulePos].Substring(2));

                            // 比較
                            if (value >= cmpValue)
                            {
                                // 条件が成り立つ
                                ruleResult = convRules[rulePos + 1];
                                cmpflg = true;
                                break;
                            }
                        }
                        else if (convRules[rulePos].EndsWith(">"))
                        {
                            cmpValue = Convert.ToChar(convRules[rulePos].Substring(1));

                            // 比較
                            if (value > cmpValue)
                            {
                                // 条件が成り立つ
                                ruleResult = convRules[rulePos + 1];
                                cmpflg = true;
                                break;
                            }
                        }
                        else if (convRules[rulePos].EndsWith("<=")
                                || convRules[rulePos].EndsWith("=<"))
                        {
                            cmpValue = Convert.ToChar(convRules[rulePos].Substring(2));

                            // 比較
                            if (value <= cmpValue)
                            {
                                // 条件が成り立つ
                                ruleResult = convRules[rulePos + 1];
                                cmpflg = true;
                                break;
                            }
                        }
                        else if (convRules[rulePos].EndsWith("<"))
                        {
                            cmpValue = Convert.ToChar(convRules[rulePos].Substring(1));

                            // 比較
                            if (value < cmpValue)
                            {
                                // 条件が成り立つ
                                ruleResult = convRules[rulePos + 1];
                                cmpflg = true;
                                break;
                            }
                        }
                        else if (convRules[rulePos].EndsWith("="))
                        {
                            cmpValue = Convert.ToChar(convRules[rulePos].Substring(1));

                            // 比較
                            if (value == cmpValue)
                            {
                                // 条件が成り立つ
                                ruleResult = convRules[rulePos + 1];
                                cmpflg = true;
                                break;
                            }
                        }
                    }

                    if (cmpflg)
                    {
                        xmlResult = GetXMLResult(jlac10Info, ruleResult);
                    }
                    break;

                case CONVTYPE_FIND:
                    // 3…検索

                    bool hitflg = false;
                    bool allNullflg = true;

                    for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                    {
                        cntResultNotEmpty = 0;
                        foreach (var resultInfoRec in resultInfoList)
                        {
                            if (resultInfoRec.rsltype == RESULTTYPE_MEMO)
                            {
                                if (!string.IsNullOrEmpty(resultInfoRec.sentence))
                                {
                                    cntResultNotEmpty += 1;
                                    if (RectumResult(jlac10Cd, cntResultNotEmpty, jlac10CdRectumObs, jlac10CdRectumObsExist))
                                    {
                                        // 有効な検査結果である→すべてnullではない
                                        allNullflg = false;
                                    }
                                }
                            }
                            else if (!string.IsNullOrEmpty(resultInfoRec.result))
                            {
                                // 検査結果がすべてnullだったら検索対象とはならず、後の*変換を行わない
                                cntResultNotEmpty += 1;
                                if (RectumResult(jlac10Cd, cntResultNotEmpty, jlac10CdRectumObs, jlac10CdRectumObsExist))
                                {
                                    // 有効な検査結果である→すべてnullではない
                                    allNullflg = false;
                                }
                            }

                            if (!string.IsNullOrEmpty(resultInfoRec.result) && resultInfoRec.result == convRules[rulePos])
                            {
                                xmlResult = convRules[rulePos + 1];
                                hitflg = true;
                                break;
                            }
                        }

                        if (hitflg)
                        {
                            break;
                        }
                    }

                    // 結果が該当なしの場合、文章を取得して検索
                    if (!hitflg)
                    {
                        // 文章結果を取得
                        for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                        {
                            foreach (var resultInfoRec in resultInfoList)
                            {
                                if (resultInfoRec.rsltype == RESULTTYPE_SENTENCE || resultInfoRec.rsltype == RESULTTYPE_MEMO)
                                {
                                    // 「null」変換
                                    if (convRules[rulePos] == CONVRULE_NULL && string.IsNullOrEmpty(resultInfoRec.sentence))
                                    {
                                        xmlResult = convRules[rulePos + 1];
                                        hitflg = true;
                                        break;
                                    }

                                    if (resultInfoRec.sentence == convRules[rulePos])
                                    {
                                        xmlResult = convRules[rulePos + 1];
                                        hitflg = true;
                                        break;
                                    }
                                }
                            }
                            if (hitflg)
                            {
                                break;
                            }
                        }
                    }

                    // 「null」を検索
                    if (!hitflg)
                    {
                        for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                        {
                            foreach (var resultInfoRec in resultInfoList)
                            {
                                // 「null」変換
                                if (convRules[rulePos] == CONVRULE_NULL && string.IsNullOrEmpty(resultInfoRec.result))
                                {
                                    xmlResult = convRules[rulePos + 1];
                                    hitflg = true;
                                    break;
                                }
                                if (resultInfoRec.result == convRules[rulePos] && string.IsNullOrEmpty(resultInfoRec.result))
                                {
                                    xmlResult = convRules[rulePos + 1];
                                    hitflg = true;
                                    break;
                                }
                            }
                            if (hitflg)
                            {
                                break;
                            }
                        }
                    }

                    if (!hitflg && !allNullflg)
                    {
                        // 該当なし。「＊」変換を行う
                        for (int rulePos = 0; rulePos + 1 < convRules.Count() - 1; rulePos += 2)
                        {
                            if (convRules[rulePos] == CONVRULE_ALL)
                            {
                                xmlResult = convRules[rulePos + 1];
                            }
                        }
                    }

                    if (allNullflg)
                    {
                        // 直腸肛門機能の場合、２項目目の所見が空なら所見有無をXML出力しない
                        if (jlac10Cd == jlac10CdRectumObsExist[1])
                        {
                            return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                        }

                        // 検査結果がすべてnull→「allnull」の指定があれば変換を行う
                        for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                        {
                            if (convRules[rulePos] == CONVRULE_ALLNULL)
                            {
                                xmlResult = convRules[rulePos + 1];
                                break;
                            }
                        }
                    }

                    xmlResult = GetXMLResult(jlac10Info, xmlResult);
                    break;

                case CONVTYPE_DATE:
                    // 4…年月日
                    xmlResult = GetXMLResult(jlac10Info, Util.ConvertToString(resultInfoList[0].csldate));
                    break;

                case CONVTYPE_CONST:
                    // 5…固定値

                    if (convRules.Count() >= 0)
                    {
                        xmlResult = convRules[0];
                        int length = FIXEDTEXT.Length;
                        
                        if (xmlResult.Length >= length && xmlResult.Substring(0, length) == FIXEDTEXT)
                        {
                            freeDao = new FreeDao(connection);
                            IList<dynamic> fixedtext = freeDao.SelectFree(1, FREE_XMLFIXED);

                            foreach (IDictionary<string, object> fixedTextRec in fixedtext)
                            {
                                if (convRules[0] == Util.ConvertToString(fixedTextRec["FREEFEILD1"]))
                                {
                                    // 汎用マスタに固定文字列が設定されている場合は、その文字列を出力する
                                    xmlResult = Util.ConvertToString(fixedTextRec["FREEFEILD2"]);
                                }
                            }
                        }

                        xmlResult = GetXMLResult(jlac10Info, xmlResult);
                    }
                    else
                    {
                        writeJlac10ConvLog(ERROR_DIV.ConvRule, jlac10Cd, rsvNo);
                        return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
                    }
                    break;

                case CONVTYPE_JUDGE:
                case CONVTYPE_DRNAME:
                    tmpXmlResult = "";

                    xmlResult = resultInfoList[0].result;

                    // 結果を置換ルールで置換する
                    for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                    {
                        // 「*」変換
                        if (convRules[rulePos] == CONVRULE_ALL)
                        {
                            // 変換ルール「*」
                            if (convRules.Count() - 1 != rulePos && convRules[rulePos + 1] != CONVRULE_ALL)
                            {
                                // 「*,ABC」の場合
                                xmlResult = convRules[rulePos + 1];
                            }
                        }

                        // 「null」変換
                        if (convRules[rulePos] == CONVRULE_NULL && string.IsNullOrEmpty(xmlResult))
                        {
                            // 「null,ABC」の場合
                            xmlResult = convRules[rulePos + 1];
                            break;
                        }

                        // その他の変換
                        if (xmlResult == convRules[rulePos])
                        {
                            xmlResult = convRules[rulePos + 1];
                            break;
                        }
                    }

                    xmlResult = GetXMLResult(jlac10Info, xmlResult);
                    break;

                case CONVTYPE_JUDGECOMMENT:                
                    tmpXmlResult = "";
                    int loopCnt = 0;

                    freeDao = new FreeDao(connection);
                    IList<dynamic> disableJudCmt = freeDao.SelectFree(1, FREE_XMLDISJCMT);

                    if (convType == CONVTYPE_JUDGECOMMENT)
                    {
                        // 7…判定コメントの場合、項目コードの複数指定が有効
                        loopCnt = resultInfoList.Count() - 1;
                    }
                    for (int cnt = 0; cnt > loopCnt; ++cnt)
                    {
                        // 7…判定コメントの場合、汎用マスタに設定された判定コメント出力対象外判定結果情報と比較
                        bool hitDisableflg = false;
                        xmlResult = "";
                        if (convType == CONVTYPE_JUDGECOMMENT)
                        {
                            foreach (IDictionary<string, object> disableJudCmtRec in disableJudCmt)
                            {
                                if (Util.ConvertToString(disableJudCmtRec["FREEFIELD1"]) == jlac10Cd 
                                    && Util.ConvertToString(disableJudCmtRec["FREEFIELD2"]) == resultInfoList[cnt].result)
                                {
                                    // 一致する場合は出力しない
                                    hitDisableflg = true;
                                    break;
                                }
                            }
                        }

                        if (!hitDisableflg)
                        {
                            xmlResult = resultInfoList[cnt].result;

                            // 判定結果を置換ルールで置換する
                            for (int rulePos = 0; rulePos + 1 < convRules.Count(); rulePos += 2)
                            {
                                // 「*」変換
                                if (convRules[rulePos] == CONVRULE_ALL)
                                {
                                    // 変換ルール「*」
                                    if (convRules.Count() - 1 != rulePos && convRules[rulePos + 1] != CONVRULE_ALL)
                                    {
                                        // 「*,ABC」の場合
                                        xmlResult = convRules[rulePos + 1];
                                    }
                                }

                                // 「null」変換
                                if (convRules[rulePos] == CONVRULE_NULL && string.IsNullOrEmpty(xmlResult))
                                {
                                    // 「null,ABC」の場合
                                    xmlResult = convRules[rulePos + 1];
                                    break;
                                }

                                // その他の変換
                                if (xmlResult == convRules[rulePos])
                                {
                                    xmlResult = convRules[rulePos + 1];
                                    break;
                                }
                            }
                        }

                        // 結果を結合
                        if (!string.IsNullOrEmpty(xmlResult))
                        {
                            if (!string.IsNullOrEmpty(tmpXmlResult))
                            {
                                // 複数結合の場合はカンマを挟む
                                if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) == XMLTYPE_ST)
                                {
                                    xmlResult += "、";
                                }
                                else
                                {
                                    xmlResult += ",";
                                }
                            }
                            tmpXmlResult += xmlResult;
                        }
                    }
                    xmlResult = tmpXmlResult;
                    xmlResult = GetXMLResult(jlac10Info, xmlResult);
                    break;

                default:
                    writeJlac10ConvLog(ERROR_DIV.ResultType, jlac10Cd, rsvNo);
                    return GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);

            }

            XML_RESULT_INFO xmlResultInfo = InitXMLResultInfo();
            resultInfo = resultInfoList[0];

            // 変換結果をXML出力構造体に            
            if (((jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)]
                || jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]
                || jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)])
                && !string.IsNullOrEmpty(XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)]))
                || ((jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou0)]
                || jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou1)]
                || jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Kakuchou2)])
                && !string.IsNullOrEmpty(XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)])))
            {
                // 血圧で、１回目・２回目の平均値を結果として扱う場合

                // 結果値を設定する
                if (jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku0)]
                    || jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku1)]
                    || jlac10Cd == Jlac10CdPressure[Convert.ToInt32(BLOOD_PRESSURE.Shushuku2)])
                {
                    resultInfo.result = XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Shushuku)];
                }
                else
                {
                    resultInfo.result = XmlResultBloodPressure[Convert.ToInt32(XML_BLOOD_PRESSURE.Kakuchou)];
                }

                // 正常範囲の基準値（上限・加減）を取得する
                IDictionary<string, object> stdValueRange = GetStdRange(rsvNo, resultInfo.itemcd, resultInfo.suffix);

                string upperValue = "";
                string lowerValue = "";
                if (stdValueRange != null)
                {
                    upperValue = Util.ConvertToString(stdValueRange["UPPERVALUE"]);
                    lowerValue = Util.ConvertToString(stdValueRange["LOWERVALUE"]);
                }

                resultInfo.uppervalue = upperValue;
                resultInfo.lowervalue = lowerValue;
            }
            else
            {
                // 血圧以外の項目
                resultInfo.result = xmlResult;
            }            

            // 結果解釈コード（H/N/L）を設定する
            if (!string.IsNullOrEmpty(resultInfo.uppervalue) && !string.IsNullOrEmpty(resultInfo.lowervalue))
            {
                double value = 0;
                double upper = 0;
                double lower = 0;

                if (double.TryParse(resultInfo.result, out value)
                    && double.TryParse(resultInfo.uppervalue, out upper)
                    && double.TryParse(resultInfo.lowervalue, out lower))
                {
                    if (value < lower)
                    {
                        resultInfo.stdflg = XMLRSLINTERPRETATION_L;
                    }
                    else if (value > upper)
                    {
                        resultInfo.stdflg = XMLRSLINTERPRETATION_H;
                    }
                    else
                    {
                        resultInfo.stdflg = XMLRSLINTERPRETATION_N;
                    }
                }
            }

            xmlResultInfo.result = resultInfo.result;
            xmlResultInfo.unit = Util.ConvertToString(jlac10Info["XMLITEM_UNIT"]);

            if (totalCnt == 1 || (totalCnt >= 1 && convType == CONVTYPE_COEFFICIENT))
            {
                // 検査項目数が１つなら基準値をセット
                // 0…数値・文字列（係数）の場合は出力される検査結果は１つであるため、複数の検査項目が登録されていても処理を行う
                xmlResultInfo.stdflg = resultInfo.stdflg;

                if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) == XMLTYPE_PQ)
                {
                    // XMLデータタイプが"PQ"の場合のみ、書式を変換して基準値をセット
                    xmlResultInfo.uppervalue = GetXMLResult(jlac10Info, resultInfo.uppervalue);
                    xmlResultInfo.lowervalue = GetXMLResult(jlac10Info, resultInfo.lowervalue);
                }
                else
                {
                    xmlResultInfo.stdflg = "";
                    xmlResultInfo.uppervalue = "";
                    xmlResultInfo.lowervalue = "";
                }
            }
            else
            {
                // 検査項目数が複数なら基準値をセットしない
                xmlResultInfo.stdflg = "";
                xmlResultInfo.uppervalue = "";
                xmlResultInfo.lowervalue = "";
            }

            if (!string.IsNullOrEmpty(xmlResultInfo.result))
            {
                xmlResultInfo = GetResultRequireInfo(xmlResultInfo, jlac10Cd);
            }
            else
            {
                xmlResultInfo = GetResultRequireInfo(InitXMLResultInfo(), jlac10Cd);
            }

            return xmlResultInfo;
        }

        /// <summary>
        /// XML結果取得(未実施不可項目判断)
        /// </summary>
        /// <param name="resultInfo">XML結果情報</param>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <returns>結果情報</returns>
        private XML_RESULT_INFO GetResultRequireInfo(XML_RESULT_INFO resultInfo, string jlac10Cd)
        {
            XML_RESULT_INFO retResultInfo = resultInfo;

            // 未実施不可項目以外で値がない場合、XML出力しない
            bool notOutflg = RequiredJlac10Cd.ContainsKey(jlac10Cd);

            if (!notOutflg && string.IsNullOrEmpty(retResultInfo.result))
            {
                retResultInfo = InitXMLResultInfo();
            }
            else
            {
                retResultInfo.getflg = true;
            }

            return retResultInfo;
        }

        /// <summary>
        /// 未実施不可項目取得
        /// </summary>
        /// <returns>未実施不可項目</returns>
        private Dictionary<string, string> RequiredItem()
        {
            var freeDao = new FreeDao(connection);
            var requiredItrmList = new Dictionary<string, string>();

            // 未実施不可項目情報
            IList<dynamic> requiredItrms = freeDao.SelectFree(1, FREE_XMLREQUIR);

            foreach (IDictionary<string, object> requiredItemRec in requiredItrms)
            {
                requiredItrmList.Add(Util.ConvertToString(requiredItemRec["FREEFIELD1"]),
                                     Util.ConvertToString(requiredItemRec["FREEFIELD2"]));
            }

            return requiredItrmList;
        }

        /// <summary>
        /// JLAC10数値フォーマット変換
        /// </summary>
        /// <param name="defFormat">デフォルトフォーマット</param>
        /// <returns>変換情報</returns>
        private string ConvJlac10InfoFormat(string defFormat)
        {
            string retFormat = "";

            // 数値の書式は、DB上では"NNN.N"となっているので、VB形式に変換
            string numFormat = defFormat.Replace("N", "#");

            int iPos = numFormat.IndexOf(".");
            if (iPos <= 0)
            {
                // 小数点がない
                if (numFormat.EndsWith("#"))
                {
                    // 整数のみで１の位が#なら0に置き換える
                    numFormat = numFormat.Remove(numFormat.Length - 1) + "0";
                }
            }
            else
            {
                // 小数点がある
                // 小数点の直前の#を0に置き換える
                numFormat = numFormat.Replace("#.", "0.");

                // 小数点以降の#を0に置き換える
                numFormat = numFormat.Remove(iPos) + numFormat.Remove(0, iPos).Replace("#", "0");
            }
            retFormat = numFormat;

            return retFormat;
        }

        /// <summary>
        /// XML実施区分・健診種別情報取得
        /// </summary>
        /// <returns>XML実施区分・健診種別情報取得</returns>
        protected override dynamic GetXmlDiv()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        div.freefield1 convpt
                        , div.freefield2 xmldiv
                        , div.freefield3 xmlkind
                        , div.freefield4 xmlpgcode
                        , div.freefield5 xmlsecdiv
                        , pgcode.xmlpgcodenm xmlpgcodenm 
                    from
                        free div 
                        left join ( 
                            select
                                freefield1 xmlpgcode
                                , freefield2 xmlpgcodenm 
                            from
                                free 
                            where
                                freecd like :freecd1 
                                and freeclasscd = :freeclasscd1
                        ) pgcode 
                            on div.freefield4 = pgcode.xmlpgcode 
                    where
                        div.freecd like :freecd2 
                        and div.freeclasscd = :freeclasscd2 
                        and div.freefield1 = :convpt
                ";

            // パラメータセット
            var sqlParam = new
            {                
                freecd1 = FREE_XMLPGKNDNM + @"%",
                freeclasscd1 = FREECLASS_PGKINDNAME,
                freecd2 = FREE_XMLKNDDIV + @"%",
                freeclasscd2 = FREECLASS_KINDDIV,
                convpt = convPtn,
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// JLAC10バージョン識別区分取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>バージョン識別区分</returns>
        protected override string GetJLAC10VerDiv(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        freefield1 verkbn 
                    from
                        ( 
                            select
                                free.freefield1
                                , free.freefield2
                                , free.freefield3
                                , row_number() over ( 
                                    partition by
                                        free.freeclasscd 
                                    order by
                                        free.freedate desc
                                ) rowno 
                            from
                                free
                                , consult 
                            where
                                free.freecd like :freecd 
                                and free.freedate <= consult.csldate 
                                and consult.rsvno = :rsvno
                        ) 
                    where
                        rowno = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                freecd = FREE_XMLJUDDATE + @"%",
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            XSDFolder = GetXSDFolder((result == null) ? "" : (Util.ConvertToString(result.VERKBN)));

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.VERKBN));
        }

        /// <summary>
        /// 機関情報取得
        /// </summary>
        /// <param name="sendOrgflg">送付元機関フラグ</param>
        /// <returns>機関情報番号</returns>
        protected override dynamic GetOrgInfo(bool sendOrgflg)
        {
            dynamic orgInfo = null;

            var freeDao = new FreeDao(connection);
            var orgInfoData = new List<dynamic>();

            if (sendOrgflg)
            {
                // 提出元機関情報
                orgInfoData = freeDao.SelectFree(0, FREE_XMLSENDORG);
            }
            else
            {
                // 実施機関情報
                 orgInfoData = freeDao.SelectFree(0, FREE_XMLDOCOFORG);
            }

            foreach (var orgInfoRec in orgInfoData)
            {
                orgInfo = orgInfoRec;
                break;
            }

            return orgInfo;
        }

        /// <summary>
        /// 受診券有効期限日取得
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <returns>受診券有効期限日</returns>
        private string GetRfcLinmitDate(string cslDate)
        {
            string rfcLimDate = "";
            var freeDao = new FreeDao(connection);

            // 受診券有効期限フラグ取得
            IList<dynamic> rfcLimflg = freeDao.SelectFree(1, FREE_XMLRFCLIMFLG);

            foreach (var rfcLimflgRec in rfcLimflg)
            {
                string rfcflg = Util.ConvertToString(rfcLimflgRec);

                switch (rfcflg.Trim())
                {
                    case "1":
                        // 受診日の年度末日を有効期限とする
                        if (DateTime.TryParse(cslDate, out DateTime tmpDate))
                        {
                            rfcLimDate = tmpDate.AddMonths(-3).AddYears(1).ToString("yyyy");
                            rfcLimDate += "0331";
                        }
                        break;
                    case "2":
                        // 受診日を有効期限とする
                        rfcLimDate = cslDate;
                        break;
                    default:
                        break;
                }
                break;
            }

            return rfcLimDate;
        }

        /// <summary>
        /// 検査値の入力範囲取得
        /// </summary>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <returns>入力範囲取得</returns>
        private dynamic GetInputLimit(string jlac10Cd)
        {
            var inputLimit = new Dictionary<string, object>();
            var freeDao = new FreeDao(connection);

            // 検査値入力範囲情報取得
            IList<dynamic> inputLimitInfo = freeDao.SelectFree(1, FREE_XMLINPLIM);

            foreach (IDictionary<string, object> inputLimitRec in inputLimitInfo)
            {
                if (Util.ConvertToString(inputLimitRec["FREEFIELD1"]) == jlac10Cd)
                {
                    inputLimit.Add("MINVALUE", inputLimitRec["FREEFIELD2"]);
                    inputLimit.Add("MAXVALUE", inputLimitRec["FREEFIELD3"]);
                    break;
                }
            }            

            return inputLimit;
        }

        /// <summary>
        /// XML結果取得
        /// </summary>
        /// <param name="jlac10Info">JLAC10基本情報</param>
        /// <param name="result">検査結果</param>
        /// <returns>XML結果</returns>
        private string GetXMLResult(IDictionary<string, object> jlac10Info, string result)
        {
            string xmlResult = "";
            string resultStyle = ConvJlac10InfoFormat(Util.ConvertToString(jlac10Info["XMLITEM_FORMAT"]));
            
            result = result.Trim();

            if (string.IsNullOrEmpty(result))
            {
                // 結果なし
                return xmlResult;
            }

            if (Util.ConvertToString(jlac10Info["XMLITEM_TYPE"]) != XMLTYPE_ST)
            {
                double numResult = 0;

                // 数値型出力
                if (!double.TryParse(result, out numResult))
                {
                    // 数値型出力項目に、数字以外を出力しようとした
                    return xmlResult;
                }
                else
                {
                    xmlResult = numResult.ToString(resultStyle);

                    if ((!string.IsNullOrEmpty(result)) && (!string.IsNullOrEmpty(resultStyle)))
                    {
                        if ((result + ".0").IndexOf('.') > (resultStyle + ".0").IndexOf('.'))
                        {
                            // 整数部桁数オーバー
                            return xmlResult;
                        }
                    }
                }
            }
            else
            {
                // 文字型出力
                if (!int.TryParse(resultStyle, out int style))
                {
                    // 出力先のデータ最大バイト数が数字ではない
                    return xmlResult;
                }
                else
                {
                    xmlResult = CutStringByte(result, style);
                }
            }

            return xmlResult;
        }

        /// <summary>
        /// 文字列をバイト単位の長さでカット
        /// </summary>
        /// <param name="result">文字列</param>
        /// <param name="byteLength">バイト数</param>
        /// <returns>変換文字列</returns>
        private string CutStringByte(string result, int byteLength)
        {

            byte[] temp = System.Text.Encoding.GetEncoding("Shift_JIS").GetBytes(result);

            int count = 0;
            if (temp.Length > byteLength)
            {
                count = byteLength;
            }
            else
            {
                count = temp.Length;
            }
            string retResult = System.Text.Encoding.GetEncoding("Shift_JIS").GetString(temp, 0, count);

            return retResult;
        }

        /// <summary>
        /// 直腸結果判断
        /// </summary>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <param name="pos">結果位置</param>
        /// <param name="rectumObs">所見データ</param>
        /// <param name="rectumObsExist">所見有無データ</param>
        /// <returns>直腸結果判断</returns>
        private bool RectumResult(string jlac10Cd, int pos, List<string> rectumObs, List<string> rectumObsExist)
        {
            bool retflg = true;

            if ((jlac10Cd == rectumObs[0] || jlac10Cd == rectumObsExist[0])
                && pos >= 2)
            {
                // 直腸肛門機能（１項目）で、２つ目以降の結果であるとき
                retflg = false;
            }
            if ((jlac10Cd == rectumObs[1] || jlac10Cd == rectumObsExist[1])
                && pos == 1)
            {
                // 直腸肛門機能（２項目以上）で、１つ目の結果であるとき
                retflg = false;
            }

            return retflg;
        }

        /// <summary>
        /// 特殊処理区分取得
        /// </summary>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <param name="freeCd">汎用コード</param>
        /// <returns>特殊処理区分</returns>
        private string GetSpProcessDiv(string jlac10Cd, string freeCd)
        {
            string retSpDiv = "";
            var freeDao = new FreeDao(connection);

            // 特殊処理区分情報取得
            IList<dynamic> spDivInfo = freeDao.SelectFree(1, freeCd);

                foreach (IDictionary<string, object> spDivRec in spDivInfo)
                {
                    if (Util.ConvertToString(spDivRec["FREEFIELD1"]) == jlac10Cd)
                    {
                        retSpDiv = Util.ConvertToString(spDivRec["FREEFIELD2"]);
                        break;
                    }
                }

            return retSpDiv;
        }

        /// <summary>
        /// XSDフォルダ取得
        /// </summary>
        /// <param name="verdiv">バージョン識別区分</param>
        /// <returns>XSDフォルダ</returns>
        private string GetXSDFolder(string verdiv)
        {
            var freeDao = new FreeDao(connection);

            // コピー元XSDフォルダ取得
            string xsdFolder = "";
            IList<dynamic> xsdFolderData = freeDao.SelectFree(0, FREE_XMLXSDPATH);

            foreach (var xsdFolderRec in xsdFolderData)
            {
                string path = Util.ConvertToString(xsdFolderRec.FREEFIELD1);
                if (!path.EndsWith(@"\"))
                {
                    // 末尾が\でなければ付ける
                    path += @"\";
                }

                xsdFolder = path + @"XSD_" + verdiv;
                break;
            }

            return xsdFolder;
        }

        /// <summary>
        /// JLAC10変換情報取得
        /// </summary>
        /// <param name="verDiv">バージョン識別区分</param>
        /// <param name="itemCd">項目コード + サフィックス</param>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <returns>JLAC10変換情報</returns>
        private List<dynamic> SearchConvInfo(string verDiv, string itemCd, string jlac10Cd)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        jlac10conv.convpt
                        , jlac10conv.jlac10cd17
                        , jlac10conv.method
                        , jlac10conv.itemcd
                        , jlac10conv.condition
                        , jlac10conv.convtype
                        , jlac10conv.convrule
                        , jlac10conv.note 
                    from
                        jlac10conv
                        , jlac10info
                    where
                        convpt = :convpt 
                ";

            if (!string.IsNullOrEmpty(jlac10Cd))
            {
                sql += @"
                        and jlac10conv.jlac10cd17 = :jlac10cd
                    ";
            }

            if (!string.IsNullOrEmpty(itemCd))
            {
                sql += @"
                        and jlac10conv.itemcd like :itemcd                         
                    ";
            }
            sql += @"
                        and jlac10conv.verkbn = :verdiv 
                        and jlac10conv.verkbn = jlac10conv.verkbn
                        and jlac10conv.jlac10cd17 = jlac10info.xmlitem_17code
                    order by
                        to_number(jlac10info.xmlitem_seqno)
                        , jlac10conv.jlac10cd17
                ";

            // パラメータセット
            var sqlParam = new
            {
                verdiv = verDiv,
                convpt = convPtn,
                itemcd = itemCd,
                jlac10cd = jlac10Cd,
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// JLAC10基本情報取得
        /// </summary>
        /// <param name="verDiv">バージョン識別区分</param>
        /// <param name="jlac10cd">JLAC10コード</param>
        /// <param name="xmlSecDiv">XMLセクション区分</param>
        /// <param name="dstOrgNo">提出先機関番号</param>
        /// <returns>JLAC10基本情報</returns>
        private dynamic SearchJLAC10Info(string verDiv, string jlac10cd, XMLSEC_DIV xmlSecDiv, string dstOrgNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        xmlitem_17code
                        , xmlitem_name
                        , xmlitem_itemoid
                        , xmlitem_type
                        , xmlitem_unit
                        , xmlitem_unitname
                        , xmlitem_codeoid
                        , xmlitem_method
                        , xmlitem_format
                        , xmlitem_pattern
                        , xmlitem_bat
                        , xmlitem_batrel
                        , xmlitem_typename
                        , xmlitem_authoritem
                    from
                        jlac10info 
                    where
                        xmlitem_17code = :itemcd17
                        and verkbn = :verdiv
                ";
            
            if (!string.IsNullOrEmpty(Util.ConvertToString(xmlSecDiv)))
            {
                var freeDao = new FreeDao(connection);

                // 条件コード取得
                IList<dynamic> conditionInfo = freeDao.SelectFree(1, FREE_XMLCDASEC);

                bool firstflg = true;
                switch (xmlSecDiv)
                {
                    case XMLSEC_DIV.Specific:
                        sql += @"and ( ";
                        if (conditionInfo.Count > 0)
                        {
                            string subsql = @"( ";
                            foreach (IDictionary<string, object> conditionRec in conditionInfo)
                            {
                                if (int.TryParse(Util.ConvertToString(conditionRec["FREEFIELD1"]), out int condition))
                                {
                                    if (condition >= 1 && condition <= 12)
                                    {
                                        if (firstflg)
                                        {
                                            subsql += @"( xmlitem_case" + condition.ToString("00") + " <> '0' ) ";
                                        }
                                        else
                                        {
                                            subsql += @" or ( xmlitem_case" + condition.ToString("00") + " <> '0' ) ";
                                        }
                                        firstflg = false;
                                    }
                                }
                            }
                            subsql += @") ";

                            if (!firstflg)
                            {
                                sql += subsql;
                            }
                        }

                        if (firstflg)
                        {
                            sql += "( 1 = 1 ) ";
                        }

                        if (!GetDstOrgNoCheck(dstOrgNo))
                        {
                            sql += @" or xmlitem_17code in ( ";
                        }
                        else
                        {
                            sql += @" or xmlitem_17code not in ( ";
                        }
                        sql += @"
                                select
                                    freefield1 
                                from
                                    free 
                                where
                                    freecd like :freecd 
                                    and freeclasscd in (
                                        :freeclasscd1
                                        , :freeclasscd2
                                        , :freeclasscd3
                                        , :freeclasscd4
                                    )
                                )
                            )
                        ";
                        break;

                    case XMLSEC_DIV.Other:
                        sql += @"and ( ";
                        if (conditionInfo.Count > 0)
                        {
                            string subsql = @"( ";
                            foreach (IDictionary<string, object> conditionRec in conditionInfo)
                            {
                                if (int.TryParse(Util.ConvertToString(conditionRec["FREEFIELD1"]), out int condition))
                                {
                                    if (condition >= 1 && condition <= 12)
                                    {
                                        if (firstflg)
                                        {
                                            subsql += @"( xmlitem_case" + condition.ToString("00") + " = '0' ) ";
                                        }
                                        else
                                        {
                                            subsql += @" and ( xmlitem_case" + condition.ToString("00") + " = '0' ) ";
                                        }
                                        firstflg = false;
                                    }
                                }
                            }
                            subsql += @") ";

                            if (!firstflg)
                            {
                                sql += subsql;
                            }
                        }

                        if (firstflg)
                        {
                            sql += "( 1 = 1 ) ";
                        }

                        if (!GetDstOrgNoCheck(dstOrgNo))
                        {
                            sql += @" and xmlitem_17code not in ( ";
                        }
                        else
                        {
                            sql += @" or xmlitem_17code in ( ";
                        }
                        sql += @"
                                select
                                    freefield1 
                                from
                                    free 
                                where
                                    freecd like :freecd 
                                    and freeclasscd in (
                                        :freeclasscd1
                                        , :freeclasscd2
                                        , :freeclasscd3
                                        , :freeclasscd4
                                    )
                                )
                            )
                        ";
                        break;
                }                
            }

            // パラメータセット
            var sqlParam = new
            {
                verdiv = verDiv,
                itemcd17 = jlac10cd,
                freecd = FREE_XMLDTLITM + @"%",
                freeclasscd1 = FREECLASS_ANM,
                freeclasscd2 = FREECLASS_ECG,
                freeclasscd3 = FREECLASS_EGD,
                freeclasscd4 = FREECLASS_CRE,
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            return (result == null ? null :result);
        }

        /// <summary>
        /// グループ項目取得
        /// </summary>
        /// <param name="予約番号">rsvNo</param>
        /// <param name="グループコード">grpCd</param>
        /// <param name="文章フラグ">stcflg</param>
        /// <returns>グループ項目</returns>
        private List<dynamic> GetGrpItem(int rsvNo, string grpCd, bool stcflg)
        {
            string sql = "";

            // SQLステートメント定義
            if (stcflg)
            {
                sql = @"
                    select
                        grp_i.itemcd || grp_i.suffix itemcd 
                    from
                        rsl
                        , item_c
                        , grp_i
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.stcitemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                        and sentence.reptstc <> ' ' 
                    order by
                        nvl(sentence.printorder, 99999)
                        , grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix
                ";
            }
            else
            {
                sql = @"
                    select
                        grp_i.itemcd || grp_i.suffix itemcd 
                    from
                        rsl
                        , item_c
                        , grp_i
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                    order by
                        grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix
                ";
            }

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = grpCd,
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 出力しないJLAC10コード取得
        /// </summary>
        /// <param name="verDiv"></param>
        /// <returns>非出力JLAC10コード</returns>
        private List<dynamic> SearchNotOutputItemCd17(string verDiv)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        xmlitem_authoritem 
                    from
                        jlac10info 
                    where
                        verkbn = :verdiv
                        and xmlitem_authoritem is not null
                ";
            
            // パラメータセット
            var sqlParam = new
            {
                verdiv = verDiv,
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 判定結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">項目コード</param>
        /// <returns>判定情報データ</returns>
        private List<dynamic> GetJudRsl(int rsvNo ,string itemCd)
        {

            // SQLステートメント定義
            string sql = @"
                select
                    judrsl.judclasscd
                    , judrsl.judcd
                    , judcmtstc.judcmtstc
                    , hainsuser.username drname 
                from
                    judrsl
                    , judcmtstc
                    , hainsuser 
                where
                    judrsl.judclasscd = :judclasscd 
                    and judrsl.rsvno = :rsvno
                    and judrsl.judcd = judcmtstc.judcd(+) 
                    and judrsl.judclasscd = judcmtstc.judclasscd(+) 
                    and judrsl.judcmtcd = judcmtstc.judcmtcd(+) 
                    and judrsl.upduser = hainsuser.userid(+) 
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                judclasscd = itemCd,
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 検査結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">項目コード</param>
        /// <returns>検査結果データ</returns>
        private List<dynamic> GetResult(int rsvNo, string itemCd)
        {

            // SQLステートメント定義
            string sql = @"
                    select
                        perrsl.csldate csldate
                        , perrsl.itemcd itemcd
                        , perrsl.suffix suffix
                        , perrsl.itemname itemname 
                        , perrsl.itemsname itemsname
                        , perrsl.itemrname itemrname 
                        , perrsl.itemqname itemqname
                        , perrsl.itemtype itemtype
                        , perrsl.result result
                        , perrsl.resulttype resulttype
                        , perrsl.rslcmtname rslcmtname
                        , nvl(sentence.longstc, ' ') longstc 
                        , sentence.stccd stccd
                        , perrsl.stdflg stdflg
                        , perrsl.stdvaluecd stdvaluecd                        
                    from
                        ( 
                            select
                                to_char(consult.csldate, 'YYYYMMDD') csldate
                                , item_c.itemcd itemcd
                                , item_c.suffix suffix
                                , item_c.stcitemcd stcitemcd
                                , item_c.itemname itemname 
                                , item_c.itemsname itemsname
                                , item_c.itemrname itemrname 
                                , item_c.itemqname itemqname
                                , item_c.itemtype itemtype
                                , item_c.resulttype resulttype
                                , rsl.result result
                                , rslcmt.rslcmtname rslcmtname 
                                , stdvalue_c.stdflg 
                                , stdvalue_c.stdvaluecd 
                            from
                                rsl
                                , consult
                                , grp_i
                                , item_c
                                , rslcmt
                                , stdvalue_c
                            where                                
                                rsl.rsvno = :rsvno 
                                and grp_i.grpcd in ( 
                                    select
                                        freefield1 
                                    from
                                        free 
                                    where
                                        freecd like :freecd
                                )
                ";
            if (!string.IsNullOrEmpty(itemCd))
            {
                sql += @"       and grp_i.itemcd || grp_i.suffix = :itemcd ";
            }
            sql += @"           and rsl.result is not null 
                                and rsl.rsvno = consult.rsvno
                                and rsl.itemcd = grp_i.itemcd 
                                and rsl.suffix = grp_i.suffix 
                                and rsl.itemcd = item_c.itemcd 
                                and rsl.suffix = item_c.suffix 
                                and rsl.rslcmtcd1 = rslcmt.rslcmtcd(+)
                                and rsl.stdvaluecd = stdvalue_c.stdvaluecd (+) 
                        ) perrsl
                        , sentence 
                    where
                        perrsl.stcitemcd = sentence.itemcd(+) 
                        and perrsl.itemtype = sentence.itemtype(+) 
                        and perrsl.result = sentence.stccd(+) 
                    order by
                        perrsl.itemcd
                        , perrsl.suffix
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = itemCd,
                freecd = FREE_XMLGROUP + @"%",
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 文章取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">項目コード</param>
        /// <param name="resultType">結果タイプ</param>
        /// <returns>文章データ</returns>
        private dynamic GetSentence(int rsvNo, string itemCd, string resultType)
        {
            // SQLステートメント定義
            string sql = "";

            switch (resultType)
            {
                case RESULTTYPE_SENTENCE:
                    sql = @"
                        select
                            sentence.stccd
                            , sentence.reptstc 
                        from
                            rsl
                            , item_c
                            , sentence                            
                        where
                            rsl.rsvno = :rsvno
                            and rsl.itemcd || rsl.suffix = :itemcd
                            and rsl.itemcd = item_c.itemcd
                            and rsl.suffix = item_c.suffix
                            and rsl.result = sentence.stccd
                            and sentence.itemcd = item_c.stcitemcd 
                            and sentence.itemtype = item_c.itemtype                             
                    ";
                    break;

                case RESULTTYPE_MEMO:
                    sql = @"
                        select
                            rsl.result stccd
                            , rslmemostr reptstc 
                        from
                            rsl
                            , rslmemo 
                        where
                            rsl.rsvno = :rsvno 
                            and rsl.itemcd || rsl.suffix = :itemcd 
                            and rsl.itemcd = rslmemo.itemcd
                            and rsl.suffix = rslmemo.suffix
                    ";
                    break;
                default:
                    break;
            }

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,                
                itemcd = itemCd,
            };

            // 戻り値設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 基準値範囲取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>基準値範囲</returns>
        private dynamic GetStdRange(int rsvNo, string itemCd, string suffix)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        ( 
                            select
                                getstandardrange(:divupper, :rsvno, :itemcd, :suffix) as stdval 
                            from
                                dual
                        ) uppervalue
                        , ( 
                            select
                                getstandardrange(:divlower, :rsvno, :itemcd, :suffix) as stdval 
                            from
                                dual
                        ) lowervalue 
                    from
                        dual
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = itemCd,
                suffix = suffix,
                divupper = "U",
                divlower = "L",
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 医師の診断(判定)取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>医師の診断</returns>
        private string GetDoctorJud(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        judrname 
                    from
                        ( 
                            select
                                jud.judrname 
                            from
                                judrsl
                                , jud 
                            where
                                judrsl.rsvno = :rsvno 
                                and judrsl.judcd = jud.judcd 
                            order by
                                jud.weight desc
                        ) maxjud 
                    where
                        rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : Util.ConvertToString(result.JUDRNAME);
        }

        /// <summary>
        /// メタボリックシンドローム判定取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>メタボリックシンドローム判定</returns>
        private string GetMetaboJud(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        totaljudcmt.judcmtcd judcmtcd 
                    from
                        totaljudcmt 
                    where
                        totaljudcmt.rsvno = :rsvno 
                        and totaljudcmt.judcmtcd in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freecd like :freecd 
                                and freeclasscd = :freeclasscd
                        ) 
                        and totaljudcmt.dispmode = :dispmode
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                freecd = FREE_METACMT + @"%",
                freeclasscd = FREECLASS_MTA,
                dispmode = 1,
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : Util.ConvertToString(result.JUDCMTCD);
        }

        /// <summary>
        /// 現病歴・既往歴情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="diseaseDiv">現病歴・既往歴区分</param>
        /// <returns>現病歴・既往歴</returns>
        private string GetDisease(int rsvNo, string grpCd, string diseaseDiv)
        {
            string retDisease = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        rslview.result rsldisease
                        , statview.result rslstatus
                        , rslview.reptstc diseasename 
                    from
                        ( 
                            select
                                rsl.rsvno
                                , rsl.result
                                , rsl.itemcd
                                , rsl.suffix
                                , sentence.reptstc 
                            from
                                rsl
                                , grp_i
                                , item_c
                                , sentence 
                            where
                                rsl.rsvno = :rsvno 
                                and grp_i.grpcd = :disease_grpcd 
                                and rsl.itemcd = grp_i.itemcd 
                                and rsl.suffix = grp_i.suffix 
                                and rsl.suffix = :suffix1 
                                and rsl.itemcd = item_c.itemcd 
                                and rsl.suffix = item_c.suffix 
                                and item_c.stcitemcd = sentence.itemcd 
                                and item_c.itemtype = sentence.itemtype 
                                and rsl.result = sentence.stccd
                        ) rslview
                        , ( 
                            select
                                rsl.rsvno
                                , rsl.result
                                , rsl.itemcd
                                , rsl.suffix 
                            from
                                rsl
                                , grp_i 
                            where
                                rsl.rsvno = :rsvno 
                                and grp_i.grpcd = :disease_grpcd 
                                and rsl.itemcd = grp_i.itemcd 
                                and rsl.suffix = grp_i.suffix 
                                and rsl.suffix = :suffix2
                        ) statview 
                    where
                        rslview.rsvno = statview.rsvno(+) 
                        and rslview.itemcd = statview.itemcd(+)
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                disease_grpcd = grpCd,
                suffix1 = "01",
                suffix2 = "03",
            };

            // SQLステートメント実行
            var diseaseInfo = connection.Query(sql, sqlParam).ToList();

            switch (diseaseDiv.Trim())
            {
                case "B":   // 脳梗塞、クモ膜下出血、脳出血
                    foreach (IDictionary<string, object> diseaseRec in diseaseInfo)
                    {
                        string disease = Util.ConvertToString(diseaseRec["RSLDISEASE"]);

                        if (disease == "2" || disease == "3" || disease == "4")
                        {
                            retDisease = "1";
                        }

                        if (!string.IsNullOrEmpty(retDisease))
                        {
                            break;
                        }
                    }
                    break;

                case "H":   // 狭心症、心筋梗塞
                    foreach (IDictionary<string, object> diseaseRec in diseaseInfo)
                    {
                        string disease = Util.ConvertToString(diseaseRec["RSLDISEASE"]);

                        if (disease == "20" || disease == "21")
                        {
                            retDisease = "1";
                        }

                        if (!string.IsNullOrEmpty(retDisease))
                        {
                            break;
                        }
                    }
                    break;

                case "K":    // 慢性腎不全、人工透析
                    foreach (IDictionary<string, object> diseaseRec in diseaseInfo)
                    {
                        string disease = Util.ConvertToString(diseaseRec["RSLDISEASE"]);
                        string status = Util.ConvertToString(diseaseRec["RSLSTATUS"]);

                        if (disease == "55" || status == "11")
                        {
                            retDisease = "1";
                        }

                        if (!string.IsNullOrEmpty(retDisease))
                        {
                            break;
                        }
                    }
                    break;

                case "A":    // 貧血
                    foreach (IDictionary<string, object> diseaseRec in diseaseInfo)
                    {
                        string disease = Util.ConvertToString(diseaseRec["RSLDISEASE"]);

                        if (disease == "50")
                        {
                            retDisease = "1";
                        }

                        if (!string.IsNullOrEmpty(retDisease))
                        {
                            break;
                        }
                    }
                    break;

                case "T":    // 既往歴
                    foreach (IDictionary<string, object> diseaseRec in diseaseInfo)
                    {
                        string disease = Util.ConvertToString(diseaseRec["RSLDISEASE"]);
                        string status = Util.ConvertToString(diseaseRec["RSLSTATUS"]);

                        if (disease == "2" || disease == "3" || disease == "4"
                            || disease == "20" || disease == "21" || disease == "50"
                            || disease == "55" || status == "11")
                        {
                            retDisease = "1";
                        }

                        if (!string.IsNullOrEmpty(retDisease))
                        {
                            break;
                        }
                    }
                    break;

                case "N":   // 具体的な既往歴
                    foreach (IDictionary<string, object> diseaseRec in diseaseInfo)
                    {
                        string disease = Util.ConvertToString(diseaseRec["RSLDISEASE"]);
                        string status = Util.ConvertToString(diseaseRec["RSLSTATUS"]);
                        string diseaseStc = Util.ConvertToString(diseaseRec["DISEASENAME"]);

                        if (disease == "2" || disease == "3" || disease == "4"
                            || disease == "20" || disease == "21" || disease == "50"
                            || disease == "55" || status == "11")
                        {
                            retDisease += diseaseStc;
                        }
                    }
                    break;
            }

            return retDisease;
        }

        /// <summary>
        /// 薬剤使用情報取得（高血圧、糖尿病、糖尿病）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="medicineDiv">服薬区分</param>
        /// <returns>薬剤使用情報</returns>
        private string GetMedicine(int rsvNo, string grpCd, string medicineDiv)
        {
            string retMedicine = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        sum(final.ketsuatsu) as ketsuatsu
                        , sum(final.tounyou) as tounyou
                        , sum(final.shisitsu) as shisitsu 
                    from
                        ( 
                            select
                                rslview.rsvno as rsvno
                                , decode(rslview.result, '19', count(rslview.rsvno), 0) as ketsuatsu
                                , decode(rslview.result, '48', count(rslview.rsvno), 0) as tounyou
                                , decode(rslview.result, '47', count(rslview.rsvno), 0) as shisitsu 
                            from
                                -- 現病歴
                                ( 
                                    select
                                        rsl.rsvno
                                        , free.freefield3 result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                    from
                                        rsl
                                        , consult
                                        , grp_i
                                        , free 
                                    where
                                        consult.rsvno = :rsvno 
                                        and grp_i.grpcd = :disease_grpcd 
                                        and rsl.rsvno = consult.rsvno 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = :suffix1 
                                        and free.freecd = :freecd1 || rsl.result
                                ) rslview
                                -- 薬剤使用状態-薬剤治療中
                                , (                                     
                                    select
                                        rsl.rsvno
                                        , rsl.result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                    from
                                        rsl
                                        , consult
                                        , grp_i
                                        , free 
                                    where
                                        consult.rsvno = :rsvno 
                                        and grp_i.grpcd = :disease_grpcd 
                                        and rsl.rsvno = consult.rsvno 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = :suffix2 
                                        and free.freecd = :freecd2 || rsl.result
                                ) statview 
                            where
                                rslview.rsvno = statview.rsvno 
                                and rslview.itemcd = statview.itemcd 
                            group by
                                rslview.rsvno
                                , rslview.result
                        ) final 
                    group by
                        final.rsvno
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                disease_grpcd = grpCd,
                freecd1 = FREE_METADIS,
                freecd2 = FREE_METASTS,
                suffix1 = "01",
                suffix2 = "03",
            };

            // SQLステートメント実行
            var medicineInfo = connection.Query(sql, sqlParam).ToList();

            foreach (IDictionary<string, object> medicineRec in medicineInfo)
            {
                switch (medicineDiv.Trim())
                {
                    case "P":   // 「血圧を下げる薬」関連変換
                        if (int.TryParse(Util.ConvertToString(medicineRec["KETSUATSU"]), out int pressure))
                        {
                            if (pressure > 0)
                            {
                                retMedicine = "1";
                            }
                        }
                        break;

                    case "S":   // 「インスリン注射又は血糖を下げる薬」関連変換
                        if (int.TryParse(Util.ConvertToString(medicineRec["TOUNYOU"]), out int sugar))
                        {
                            if (sugar > 0)
                            {
                                retMedicine = "1";
                            }
                        }
                        break;

                    case "F":    // 「コレステロールを下げる薬」関連変換
                        if (int.TryParse(Util.ConvertToString(medicineRec["SHISITSU"]), out int fat))
                        {
                            if (fat > 0)
                            {
                                retMedicine = "1";
                            }
                        }
                        break;
                }

                if (!string.IsNullOrEmpty(retMedicine))
                {
                    break;
                }
            }

            return retMedicine;
        }

        /// <summary>
        /// アルコール換算を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns>アルコール量</returns>
        private string GetAlcohol(int rsvNo, string grpCd)
        {
            string retAlcohol = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        nvl(sum(lastview.alcohol), 0) as sumalcohol 
                    from
                        ( 
                            select
                                decode( 
                                    rsl.itemcd
                                    , '60180'
                                    , to_number(rsl.result) * 1.26
                                    , '60181'
                                    , to_number(rsl.result) * 0.7
                                    , '60182'
                                    , to_number(rsl.result)
                                    , '60183'
                                    , to_number(rsl.result)
                                    , '60184'
                                    , to_number(rsl.result) * 0.5
                                    , '60185'
                                    , to_number(rsl.result) * 0.5
                                    , '60186'
                                    , to_number(rsl.result) * 0.5
                                    , '60187'
                                    , to_number(rsl.result) * 0.5
                                ) as alcohol 
                            from
                                rsl
                                , grp_i 
                            where
                                rsl.rsvno = :rsvno 
                                and grp_i.grpcd = :grpcd 
                                and rsl.itemcd = grp_i.itemcd 
                                and rsl.suffix = grp_i.suffix 
                                and rsl.result is not null
                        ) lastview
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = grpCd,
            };

            // SQLステートメント実行
            var alcoholInfo = connection.Query(sql, sqlParam).ToList();

            foreach (IDictionary<string, object> alcoholRec in alcoholInfo)
            {
                if (float.TryParse(Util.ConvertToString(alcoholRec["SUMALCOHOL"]), out float alcohol))
                {
                    if (alcohol < 1)
                    {
                        retAlcohol = "1";   // １合未満
                    }
                    else if (alcohol < 2)
                    {
                        retAlcohol = "2";   // １～２合未満
                    }
                    else if (alcohol < 3)
                    {
                        retAlcohol = "3";   // ２～３合未満
                    }
                    else
                    {
                        retAlcohol = "4";   // ３合以上
                    }
                }

                if (!string.IsNullOrEmpty(retAlcohol))
                {
                    break;
                }
            }

            return retAlcohol;
        }

        /// <summary>
        /// 便潜血結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns>便潜血結果</returns>
        private string GetStools(int rsvNo, string grpCd)
        {
            string retStools = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        min(lastview.result) as result 
                    from
                        ( 
                            select
                                decode( 
                                    rsl.result
                                    , '1'
                                    , '2'
                                    , '11'
                                    , '1'
                                    , '12'
                                    , '1'
                                    , '2'
                                    , '1'
                                ) as result 
                            from
                                rsl
                                , grp_i 
                            where
                                rsl.rsvno = :rsvno 
                                and grp_i.grpcd = :grpcd 
                                and grp_i.itemcd = rsl.itemcd 
                                and grp_i.suffix = rsl.suffix 
                                and rsl.stopflg is null 
                                and rsl.result is not null 
                            group by
                                rsl.result
                        ) lastview
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = grpCd,
            };

            // SQLステートメント実行
            var stoolsInfo = connection.Query(sql, sqlParam).ToList();

            foreach (IDictionary<string, object> stoolsRec in stoolsInfo)
            {
                if (!string.IsNullOrEmpty(Util.ConvertToString(stoolsRec["RESULT"])))
                {
                    retStools = Util.ConvertToString(stoolsRec["RESULT"]);
                    break;
                }
            }

            return retStools;
        }

        /// <summary>
        /// 子宮頸部細胞診(日母分類)結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns>子宮頸部細胞診(日母分類)結果</returns>
        private string GetHujinClass(int rsvNo, string grpCd)
        {
            string retHujinClass = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        rsl.result as result 
                    from
                        rsl
                        , grp_i 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.result in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freecd like :freecd 
                                and freeclasscd = :freeclasscd
                        ) 
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = grpCd,
                freecd = FREE_GYNECLASS + @"%",
                freeclasscd = FREECLASS_GYN,
            };

            // SQLステートメント実行
            var hujinClassInfo = connection.Query(sql, sqlParam).ToList();

            foreach (IDictionary<string, object> hujinClassRec in hujinClassInfo)
            {
                if (!string.IsNullOrEmpty(Util.ConvertToString(hujinClassRec["RESULT"])))
                {
                    retHujinClass = Util.ConvertToString(hujinClassRec["RESULT"]);
                    break;
                }
            }

            return retHujinClass;
        }

        /// <summary>
        /// 特殊機関情報のチェック
        /// </summary>
        /// <param name="dstOrgNo">提出先機関番号</param>
        /// <returns>存在有無</returns>
        private bool GetDstOrgNoCheck(string dstOrgNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        freefield1 dstorgno
                        , freefield2 dstorgname 
                    from
                        free 
                    where
                        freecd like :freecd 
                        and freefield1 = :dstorg
                ";

            // パラメータセット
            var sqlParam = new
            {
                freecd = FREE_XMLTSPORG + @"%",
                dstorg = dstOrgNo,
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            return (result == null ? false : true);
        }

        /// <summary>
        /// 結果変換エラーログ
        /// </summary>
        /// <param name="logDiv">ログ区分</param>
        /// <param name="jlac10Cd">JLAC10コード</param>
        /// <param name="rsvNo">予約番号</param>
        private void writeJlac10ConvLog(ERROR_DIV logDiv, string jlac10Cd, int rsvNo)
        {
            string logText = "";

            switch (logDiv)
            {
                case ERROR_DIV.ConvCondition:
                    logText += "RSVNO=" + Util.ConvertToString(rsvNo);
                    logText += ",CONVPT=" + convPtn;
                    logText += ",JLAC10CD=" + jlac10Cd;
                    logText += ",変換条件が誤っています。変換テーブル(JLAC10CONV)を確認してください。";
                    break;

                case ERROR_DIV.Result:
                    logText += "RSVNO=" + Util.ConvertToString(rsvNo);
                    logText += ",CONVPT=" + convPtn;
                    logText += ",JLAC10CD=" + jlac10Cd;
                    logText += ",検査結果が異常です。検査結果を確認してください。";
                    break;

                case ERROR_DIV.StdValue:
                    logText += "RSVNO=" + Util.ConvertToString(rsvNo);
                    logText += ",CONVPT=" + convPtn;
                    logText += ",JLAC10CD=" + jlac10Cd;
                    logText += ",基準値が異常です。基準値を確認してください。";
                    break;

                case ERROR_DIV.ResultType:
                    logText += "RSVNO=" + Util.ConvertToString(rsvNo);
                    logText += ",CONVPT=" + convPtn;
                    logText += ",JLAC10CD=" + jlac10Cd;
                    logText += ",結果タイプが不明です。検査項目を確認してください。";
                    break;

                case ERROR_DIV.ConvRule:
                    logText += "RSVNO=" + Util.ConvertToString(rsvNo);
                    logText += ",CONVPT=" + convPtn;
                    logText += ",JLAC10CD=" + jlac10Cd;
                    logText += ",変換ルールが誤っています。変換テーブル(JLAC10CONV)を確認してください。";
                    break;
            }

            logTextInfo.Add(logText);
        }

        /// <summary>
        /// JLAC10特殊処理情報初期化
        /// </summary>
        private void InitJlac10SpecialInfo()
        {
            // 血圧のJLAC10コード(格納順は変更してはいけない)
            Jlac10CdPressure = new List<string>();
            Jlac10CdPressure.Add("9A755000000000001");     // 収縮期血圧(その他) JLAC10コード
            Jlac10CdPressure.Add("9A752000000000001");     // 収縮期血圧(2回目)  JLAC10コード
            Jlac10CdPressure.Add("9A752000000000001");     // 収縮期血圧(1回目)  JLAC10コード
            Jlac10CdPressure.Add("9A765000000000001");     // 拡張期血圧(その他) JLAC10コード
            Jlac10CdPressure.Add("9A762000000000001");     // 拡張期血圧(2回目)  JLAC10コード
            Jlac10CdPressure.Add("9A761000000000001");     // 拡張期血圧(1回目)  JLAC10コード

            ResultPressure = new List<bool>();
            ResultPressure.Add(false);
            ResultPressure.Add(false);
            ResultPressure.Add(false);
            ResultPressure.Add(false);
            ResultPressure.Add(false);
            ResultPressure.Add(false);

            PosItem = new List<int>();
            PosItem.Add(-1);
            PosItem.Add(-1);
            PosItem.Add(-1);
            PosItem.Add(-1);
            PosItem.Add(-1);
            PosItem.Add(-1);

            XmlResultBloodPressure = new List<string>();
            XmlResultBloodPressure.Add("");
            XmlResultBloodPressure.Add("");

            // 未実施不可項目取得
            RequiredJlac10Cd = RequiredItem();
        }

        /// <summary>
        /// 結果構造体初期化
        /// </summary>
        /// <returns>結果構造体初期値</returns>
        private RESULT_INFO InitResultInfo()
        {
            RESULT_INFO resultinfo;

            resultinfo.rsvno = 0;
            resultinfo.itemcd = "";
            resultinfo.suffix = "";
            resultinfo.itemname = "";
            resultinfo.itemsname = "";
            resultinfo.itemrname = "";
            resultinfo.itemqname = "";
            resultinfo.rsltype = "";
            resultinfo.csldate = "";
            resultinfo.result = "";
            resultinfo.judrsl = "";
            resultinfo.sentence = "";
            resultinfo.stdflg = "";
            resultinfo.uppervalue = "";
            resultinfo.lowervalue = "";

            return resultinfo;
        }

        /// <summary>
        /// XML_結果構造体初期化
        /// </summary>
        /// <returns>結果構造体初期値</returns>
        private XML_RESULT_INFO InitXMLResultInfo()
        {
            XML_RESULT_INFO xmlresultinfo;

            xmlresultinfo.result = "";
            xmlresultinfo.unit = "";
            xmlresultinfo.stdflg = "";
            xmlresultinfo.uppervalue = "";
            xmlresultinfo.lowervalue = "";
            xmlresultinfo.getflg = false;

            return xmlresultinfo;
        }
    }
}
