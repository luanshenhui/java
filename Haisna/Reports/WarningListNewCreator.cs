using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hainsi.Common.Constants;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 個人異常値リスト生成クラス
    /// </summary>
    public class WarningListNewCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002200";

        /// <summary>
        /// 汎用分類コード（帳票固有設定用）
        /// </summary>
        private const string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用コード（オプション）
        /// </summary>
        private const string FREECD_LST000190 = "LST000190%";

        /// <summary>
        /// 汎用コード（コース名）
        /// </summary>
        private const string FREECD_LST000022 = "LST000022%";

        /// <summary>
        /// グループコード（コース名）
        /// </summary>
        private const string C_GRPCD = "X502";

        /// <summary>
        /// 明細対象項目
        /// </summary>
        private const string M_STDFLG = "S";
        private const int M_ITEMTYPE = 0;
        private const int M_RESULTTYPE = 4;

        /// <summary>
        /// 面接医項目コード
        /// </summary>
        private const string D_ITEMCD = "30950";
        private const string D_SUFFIX = "00";
        private const int D_ITEMTYPE = 0;

        /// <summary>
        /// 看護師項目コード
        /// </summary>
        private const string N_ITEMCD = "30960";
        private const string N_SUFFIX = "00";
        private const int N_ITEMTYPE = 0;

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["startdate"], out wkDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out wkDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 個人異常値リストデータを読み込む
        /// </summary>
        /// <returns>個人異常値リストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        co.rsvno
                        , co.csldate
                        , pe.perid
                        , pe.lastkname
                        , pe.firstkname
                        , pe.lastname
                        , pe.firstname
                        , ct.csname
                        , re.dayid
                        , pe.cslcount
                        , pe.gender
                        , trunc(co.age, 0) as age
                        , pe.birth
                        , og.orgname
                        , to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') as printtime 
                    from
                        consult co
                        , person pe
                        , receipt re
                        , ctrpt ct
                        , free fr
                        , org og
                        , ( 
                            select distinct
                                rs.rsvno 
                            from
                                consult co
                                , rsl rs
                                , item_c ic
                                , stdvalue_c sc 
                            where
                                co.csldate >= :startdate
                                and co.csldate <= :enddate 
                                and co.rsvno = rs.rsvno 
                                and rs.itemcd = ic.itemcd 
                                and rs.suffix = ic.suffix 
                                and rs.stdvaluecd = sc.stdvaluecd 
                                and sc.stdflg in ('H','L','U','D','@','*','S','X') 
                                and sc.stdflg is not null
                        ) terget 
                    where
                        co.rsvno = terget.rsvno 
                        and co.perid = pe.perid 
                        and co.rsvno = re.rsvno 
                        and co.csldate >= :startdate 
                        and co.csldate <= :enddate
                        and co.ctrptcd = ct.ctrptcd 
                        and co.orgcd1 = og.orgcd1 
                        and co.orgcd2 = og.orgcd2 
                        and co.cancelflg = :cancelflg 
                        and fr.freecd like :freecd
                        and fr.freeclasscd = :freeclasscd 
                        and fr.freefield1 = co.cscd
                ";

            string tStratDate = queryParams["startdate"];
            string tEndDate = queryParams["enddate"];
            string tDayId = queryParams["dayid"];
            if (!string.IsNullOrEmpty(tStratDate) && !string.IsNullOrEmpty(tEndDate) && !string.IsNullOrEmpty(tDayId))
            {
                sql += @"  and re.dayid = :dayid";
            }

            sql += @"  order by re.csldate, re.dayid";

            // パラメータセット
            var sqlParam = new
            {
                startdate = queryParams["startdate"],
                enddate = queryParams["enddate"],
                dayid = queryParams["dayid"],
                freecd = FREECD_LST000190,
                freeclasscd = FREECLASSCD_LST,
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">個人異常値リストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var printdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var csnameField = (CnDataField)cnObjects["CSNAME"];
            var dctorField = (CnDataField)cnObjects["DCTOR"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var dayidField = (CnDataField)cnObjects["DAYID"];
            var cslcountField = (CnDataField)cnObjects["CSLCOUNT"];
            var knameField = (CnDataField)cnObjects["KNAME"];
            var nameField = (CnDataField)cnObjects["NAME"];
            var genderField = (CnDataField)cnObjects["GENDER"];
            var birthField = (CnDataField)cnObjects["BIRTH"];
            var ageField = (CnDataField)cnObjects["AGE"];
            var orgnameField = (CnDataField)cnObjects["ORGNAME"];
            var itemname0Field = (CnDataField)cnObjects["ITEMNAME0"];
            var itemnameListField = (CnListField)cnObjects["ITEMNAME"];
            var valueListField = (CnListField)cnObjects["VALUE"];
            var nodataField = (CnDataField)cnObjects["NODATA"];

            string cslDate = "";
            string sysDate = "";
            string csName = "";
            string dctor = "";
            string perId = "";
            string dayId = "";
            string cslCount = "";
            string kName = "";
            string name = "";
            string gender = "";
            string birth = "";
            string age = "";
            string orgName = "";
            string rsvNo = "";

            int pageNo = 0;
            short currentLine = 0;

            string newKey;
            string oldKey = Util.ConvertToString(data[0].PERID);

            // ページ内の項目に値をセット
            foreach (var header in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 印刷日時
                sysDate = Util.ConvertToString(header.PRINTTIME);
                // 個人ID
                newKey = Util.ConvertToString(header.PERID);

                // 受診者ごとに改ページ
                if (newKey != oldKey)
                {
                    pageNo++;

                    // ヘッダーの編集
                    pageField.Text = Util.ConvertToString(pageNo);
                    csldateField.Text = cslDate;
                    printdateField.Text = sysDate;
                    csnameField.Text = csName;
                    dctorField.Text = dctor;
                    peridField.Text = perId;
                    dayidField.Text = dayId;
                    cslcountField.Text = cslCount;
                    knameField.Text = kName;
                    nameField.Text = name;
                    genderField.Text = gender;
                    birthField.Text = birth;
                    ageField.Text = age;
                    orgnameField.Text = orgName;

                    // ドキュメントの出力
                    PrintOut(cnForm);


                    // 現在編集行のリセット
                    currentLine = 0;

                    // キーブレイクによる改ページ処理
                    oldKey = newKey;
                }

                // 受診日
                if (DateTime.TryParse(Util.ConvertToString(header.CSLDATE), out DateTime dt))
                {
                    cslDate = dt.ToString("yyyy年MM月dd日");
                }
                // 患者ID
                perId = Util.ConvertToString(header.PERID);
                // 受診番号
                dayId = Util.ConvertToString(header.DAYID);
                // 予約番号
                rsvNo = Util.ConvertToString(header.RSVNO);
                // コース名
                csName = Util.ConvertToString(header.CSNAME) + "(" + GetCsName(rsvNo) + ")";
                // 担当
                dctor = GetDoctor(rsvNo);
                string nurse = GetNurse(rsvNo);
                if (!string.IsNullOrEmpty(nurse))
                {
                    dctor = dctor + "/" + nurse;
                }
                // 受診回数
                cslCount = Util.ConvertToString(header.CSLCOUNT);
                // フリガナ
                kName = Util.ConvertToString(header.LASTKNAME).Trim() + " " + Util.ConvertToString(header.FIRSTKNAME).Trim();
                // 氏名
                name = Util.ConvertToString(header.LASTNAME).Trim() + "　" + Util.ConvertToString(header.FIRSTNAME).Trim();
                // 性別
                gender = (Util.ConvertToString(header.GENDER) == "1") ? "男性" : "女性";
                // 生年月日
                if (DateTime.TryParse(Util.ConvertToString(header.BIRTH), out DateTime tempbirth))
                {
                    birth =
                    WebHains.GetShortEraName(tempbirth) + WebHains.EraDateFormat(tempbirth, " yy/MM/dd");
                }
                // 年齢
                age = Util.ConvertToString(header.AGE);
                // 団体名
                orgName = Util.ConvertToString(header.ORGNAME);


                // 明細行データ取得;
                bool detailFlg = false;
                foreach (var detail in GetDetail(rsvNo, Util.ConvertToString(header.GENDER)))
                {
                    // 改ページ処理
                    if (currentLine >= itemnameListField.ListRows.Length)
                    {
                        pageNo++;

                        // ヘッダーの編集
                        pageField.Text = Util.ConvertToString(pageNo);
                        csldateField.Text = cslDate;
                        printdateField.Text = sysDate;
                        csnameField.Text = csName;
                        dctorField.Text = dctor;
                        peridField.Text = perId;
                        dayidField.Text = dayId;
                        cslcountField.Text = cslCount;
                        knameField.Text = kName;
                        nameField.Text = name;
                        genderField.Text = gender;
                        birthField.Text = birth;
                        ageField.Text = age;
                        orgnameField.Text = orgName;

                        // ドキュメントの出力
                        PrintOut(cnForm);

                        // 現在編集行のリセット
                        currentLine = 0;
                    }

                    itemnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ITEMNAME);
                    valueListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.VALUE);

                    currentLine ++;
                    detailFlg = true;
                }

                if (detailFlg == true)
                {
                    itemname0Field.Text = "<<異常値所見データ>>";
                }
                else
                {
                    nodataField.Text = "問い合わせされた資料がありません。";
                    currentLine++;
                }
            }

            // 終了処理
            if (currentLine > 0)
            {
                pageNo++;

                // ヘッダーの編集
                pageField.Text = Util.ConvertToString(pageNo);
                csldateField.Text = cslDate;
                printdateField.Text = sysDate;
                csnameField.Text = csName;
                dctorField.Text = dctor;
                peridField.Text = perId;
                dayidField.Text = dayId;
                cslcountField.Text = cslCount;
                knameField.Text = kName;
                nameField.Text = name;
                genderField.Text = gender;
                birthField.Text = birth;
                ageField.Text = age;
                orgnameField.Text = orgName;

                // ドキュメントの出力
                PrintOut(cnForm);

                // 現在編集行のリセット
                currentLine = 0;
            }
        }

        /// <summary>
        /// 対象データ取得（異常値所見データ明細）
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="p_gender">性別</param>
        /// <returns></returns>
        private dynamic GetDetail(string rsvNo, string p_gender)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        ic.itemname as itemname
                        , ic.itemcd as itemcd
                        , ic.suffix as suffix
                        , se.longstc as value
                        , 1 as sort_key 
                    from
                        rsl rs
                        , item_c ic
                        , stdvalue_c sc
                        , sentence se 
                    where
                        rs.rsvno = :rsvno
                        and rs.itemcd = ic.itemcd 
                        and rs.suffix = ic.suffix 
                        and rs.stdvaluecd = sc.stdvaluecd 
                        and sc.stdflg <> :stdflg 
                        and sc.stdflg is not null 
                        and ic.stcitemcd = se.itemcd 
                        and ic.itemtype = se.itemtype 
                        and rs.result = se.stccd 
                        and rs.itemcd = se.itemcd 
                        and ic.itemtype = :itemtype 
                        and ic.resulttype = :resulttype
                    union 
                    select
                        itemng.itemname as itemname
                        , itemng.itemcd as itemcd
                        , itemng.suffix as suffix
                        , lpad(itemng.result, 15, ' ') || ' (' || lpad(itemok.lowervalue, 15, ' ') || ' - ' || lpad(itemok.uppervalue, 15, ' ')
                         || ')' as value
                        , 2 as sort_key 
                    from
                        ( 
                            select distinct
                                sv.itemcd
                                , sv.suffix
                                , sv.stdvaluemngcd
                                , sc.lowervalue
                                , sc.uppervalue
                                , sv.strdate
                                , sv.enddate 
                            from
                                stdvalue_c sc
                                , stdvalue sv 
                            where
                                sc.stdvaluemngcd = sv.stdvaluemngcd 
                                and sc.stdflg = :stdflg 
                                and sc.gender = :gender
                        ) itemok
                        , ( 
                            select
                                rs.itemcd
                                , rs.suffix
                                , rs.result
                                , ic.itemname
                                , ct.csldate 
                            from
                                rsl rs
                                , item_c ic
                                , stdvalue_c sc
                                , consult ct 
                            where
                                rs.rsvno = :rsvno
                                and rs.rsvno = ct.rsvno 
                                and rs.itemcd = ic.itemcd 
                                and rs.suffix = ic.suffix 
                                and rs.stdvaluecd = sc.stdvaluecd 
                                and sc.stdflg <> :stdflg
                                and sc.stdflg is not null 
                                and ic.itemtype = :itemtype 
                                and ic.resulttype <> :resulttype 
                                and sc.gender = :gender
                        ) itemng 
                    where
                        itemng.itemcd = itemok.itemcd 
                        and itemng.suffix = itemok.suffix 
                        and itemok.strdate <= itemng.csldate 
                        and itemok.enddate >= itemng.csldate 
                    order by
                        sort_key
                        , itemcd
                        , suffix
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                gender = p_gender,
                stdflg = M_STDFLG,
                itemtype = M_ITEMTYPE,
                resulttype = M_RESULTTYPE
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 対象データ取得（コース名）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        private string GetCsName(string rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        fr.freefield3 
                    from
                        consultitemlist v_co
                        , grp_i gi
                        , free fr 
                    where
                        v_co.rsvno = :rsvno
                        and v_co.cancelflg = :cancelflg
                        and gi.grpcd = :grpcd
                        and gi.itemcd = v_co.itemcd 
                        and fr.freecd like :freecd
                        and fr.freefield1 = gi.grpcd 
                        and fr.freefield2 = gi.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                freecd = FREECD_LST000022,
                grpcd = C_GRPCD,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault(); ;

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.FREEFIELD3));
        }

        /// <summary>
        /// 対象データ取得（医師名）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        private string GetDoctor(string rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        se.longstc 
                    from
                        rsl rs
                        , item_c ic
                        , sentence se 
                    where
                        rs.rsvno = :rsvno
                        and rs.itemcd = :itemtype 
                        and rs.suffix = :suffix
                        and rs.itemcd = ic.itemcd 
                        and rs.suffix = ic.suffix 
                        and ic.stcitemcd = se.itemcd 
                        and ic.itemtype = se.itemtype 
                        and rs.result = se.stccd 
                        and rs.itemcd = se.itemcd 
                        and ic.itemtype = :itemtype
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = D_ITEMCD,
                suffix = D_SUFFIX,
                itemtype = D_ITEMTYPE
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault(); ;

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.LONGSTC));
        }

        /// <summary>
        /// 対象データ取得（看護師名）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        private string GetNurse(string rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        se.longstc 
                    from
                        rsl rs
                        , item_c ic
                        , sentence se 
                    where
                        rs.rsvno = :rsvno
                        and rs.itemcd = :itemcd 
                        and rs.suffix = :suffix 
                        and rs.itemcd = ic.itemcd 
                        and rs.suffix = ic.suffix 
                        and ic.stcitemcd = se.itemcd 
                        and ic.itemtype = se.itemtype 
                        and rs.result = se.stccd 
                        and rs.itemcd = se.itemcd 
                        and ic.itemtype = :itemtype
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = N_ITEMCD,
                suffix = N_SUFFIX,
                itemtype = N_ITEMTYPE
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault(); ;

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.LONGSTC));
        }
    }
}
