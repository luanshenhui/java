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
    /// ワークシート前回値参照リスト生成クラス
    /// </summary>
    public class WorkSheetLastCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002180";

        /// <summary>
        /// 汎用分類コード（対象コード）
        /// </summary>
        private const string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用コード（対象コード）
        /// </summary>
        private const string FREECD_LST000110 = "LST000110%";

        /// <summary>
        /// 所見項目取得用
        /// </summary>
        private const string S_GRPCD = "X501";
        private const int S_RESULTTYPE = 4;

        /// <summary>
        /// 結果項目取得用
        /// </summary>
        private const string R_GRPCD = "X501";
        private const int R_RESULTTYPE = 0;

        /// <summary>
        /// TPHA項目コード
        /// </summary>
        private const string TPHA_ITEMCD = "16220";
        private const string TPHA_SUFFIX = "00";

        /// <summary>
        /// PSA項目コード
        /// </summary>
        private const string PSA_ITEMCD = "16324";
        private const string PSA_SUFFIX = "00";

        /// <summary>
        /// HBs抗原項目コード
        /// </summary>
        private const string HBSAG_ITEMCD = "17038";
        private const string HBSAG_SUFFIX = "00";

        /// <summary>
        /// HBs抗体項目コード
        /// </summary>
        private const string HBSAB_ITEMCD = "17040";
        private const string HBSAB_SUFFIX = "00";

        /// <summary>
        /// HCV抗体項目コード
        /// </summary>
        private const string HCVAB_ITEMCD = "17042";
        private const string HCVAB_SUFFIX = "00";

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
        /// ワークシート前回値参照リストデータを読み込む
        /// </summary>
        /// <returns>ワークシート前回値参照リストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        co.perid
                        , co.rsvno
                        , co.csldate
                        , re.dayid
                        , pe.lastkname
                        , pe.firstkname
                        , pe.lastname
                        , pe.firstname
                        , pe.perid
                        , trunc(co.age) as age
                        , pe.gender
                        , ( 
                            select
                                nvl(max(pre_co.csldate), '') 
                            from
                                consult pre_co 
                            where
                                pre_co.perid = co.perid 
                                and pre_co.cancelflg = :cancelflg 
                                and pre_co.csldate < co.csldate
                        ) as pre_csldate
                        , ( 
                            select
                                nvl(max(sub_co.rsvno), '') 
                            from
                                consult sub_co 
                            where
                                sub_co.perid = co.perid 
                                and sub_co.cancelflg = :cancelflg  
                                and sub_co.csldate = ( 
                                    select
                                        nvl(max(tmp_co.csldate), '') 
                                    from
                                        consult tmp_co 
                                    where
                                        tmp_co.perid = co.perid 
                                        and tmp_co.cancelflg = :cancelflg 
                                        and tmp_co.csldate < re.csldate
                                )
                        ) as pre_rsvno
                        , pe.cslcount
                        , ( 
                            select
                                itemname 
                            from
                                item_c 
                            where
                                itemcd = :itemcd1
                                and suffix = :suffix1
                        ) as itemname1
                        , ( 
                            select
                                itemname 
                            from
                                item_c 
                            where
                                itemcd = :itemcd2
                                and suffix = :suffix2
                        ) as itemname2
                        , ( 
                            select
                                itemname 
                            from
                                item_c 
                            where
                                itemcd = :itemcd3
                                and suffix = :suffix3
                        ) as itemname3
                        , ( 
                            select
                                itemname 
                            from
                                item_c 
                            where
                                itemcd = :itemcd4
                                and suffix = :suffix4
                        ) as itemname4
                        , ( 
                            select
                                itemname 
                            from
                                item_c 
                            where
                                itemcd = :itemcd5
                                and suffix = :suffix5
                        ) as itemname5 
                    from
                        consult co
                        , person pe
                        , receipt re
                        , free fr 
                    where
                        co.perid = pe.perid 
                        and co.rsvno = re.rsvno 
                        and co.csldate between :startdate and :enddate
                        and co.cancelflg = :cancelflg 
                        and fr.freecd like :freecd 
                        and fr.freeclasscd = :freeclasscd
                        and fr.freefield1 = co.cscd 
                    order by
                        co.csldate
                        , re.dayid
                ";

            // パラメータセット
            var sqlParam = new
            {
                startdate = queryParams["startdate"],
                enddate = queryParams["enddate"],
                freecd = FREECD_LST000110,
                freeclasscd = FREECLASSCD_LST,
                cancelflg = ConsultCancel.Used,
                itemcd1 = TPHA_ITEMCD,
                suffix1 = TPHA_SUFFIX,
                itemcd2 = HBSAG_ITEMCD,
                suffix2 = HBSAG_SUFFIX,
                itemcd3 = HBSAB_ITEMCD,
                suffix3 = HBSAB_SUFFIX,
                itemcd4 = HCVAB_ITEMCD,
                suffix4 = HCVAB_SUFFIX,
                itemcd5 = PSA_ITEMCD,
                suffix5 = PSA_SUFFIX
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ワークシート前回値参照リストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var printdateField = (CnDataField)cnObjects["PRINTDATE"];
            var dayidListField = (CnListField)cnObjects["DAYID"];
            var knameListField = (CnListField)cnObjects["KNAME"];
            var caternameListField = (CnListField)cnObjects["CATERNAME"];
            var peridListField = (CnListField)cnObjects["PERID"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var zendateListField = (CnListField)cnObjects["ZENDATE"];
            var cslcountListField = (CnListField)cnObjects["CSLCOUNT"];
            var itemname1Field = (CnDataField)cnObjects["ITEMNAME1"];
            var itemname2Field = (CnDataField)cnObjects["ITEMNAME2"];
            var itemname3Field = (CnDataField)cnObjects["ITEMNAME3"];
            var itemname4Field = (CnDataField)cnObjects["ITEMNAME4"];
            var itemname5Field = (CnDataField)cnObjects["ITEMNAME5"];
            var tphaListField = (CnListField)cnObjects["TPHA"];
            var hbs_genListField = (CnListField)cnObjects["HBS_GEN"];
            var hbs_taiListField = (CnListField)cnObjects["HBS_TAI"];
            var hcvListField = (CnListField)cnObjects["HCV"];
            var psaListField = (CnListField)cnObjects["PSA"];
            var pre_tphaListField = (CnListField)cnObjects["PRE_TPHA"];
            var pre_hbs_genListField = (CnListField)cnObjects["PRE_HBS_GEN"];
            var pre_hbs_taiListField = (CnListField)cnObjects["PRE_HBS_TAI"];
            var pre_hcvListField = (CnListField)cnObjects["PRE_HCV"];
            var pre_psaListField = (CnListField)cnObjects["PRE_PSA"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var par_tpha_sListField = (CnListField)cnObjects["PAR_TPHA_S"];
            var par_hbs_gen_sListField = (CnListField)cnObjects["PAR_HBS_GEN_S"];
            var par_hbs_tai_sListField = (CnListField)cnObjects["PAR_HBS_TAI_S"];
            var par_hcv_sListField = (CnListField)cnObjects["PAR_HCV_S"];
            var par_psa_sListField = (CnListField)cnObjects["PAR_PSA_S"];
            var par_tpha_eListField = (CnListField)cnObjects["PAR_TPHA_E"];
            var par_hbs_gen_eListField = (CnListField)cnObjects["PAR_HBS_GEN_E"];
            var par_hbs_tai_eListField = (CnListField)cnObjects["PAR_HBS_TAI_E"];
            var par_hcv_eListField = (CnListField)cnObjects["PAR_HCV_E"];
            var par_psa_eListField = (CnListField)cnObjects["PAR_PSA_E"];


            string itemName1 = "";
            string itemName2 = "";
            string itemName3 = "";
            string itemName4 = "";
            string itemName5 = "";
            string rsvNo = "";
            string preRsvNo = "";

            int pageNo = 0;
            short currentLine = 0;

            string newKey = "";
            string oldKey = "";


            // 印刷日時
            string sysdate = DateTime.Now.ToString("yyyy年MM月dd日");

            // 受診日
            if (DateTime.TryParse(Util.ConvertToString(data[0].CSLDATE), out DateTime dt))
            {
                oldKey = dt.ToString("yyyy/MM/dd");
            }


            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 受診日
                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime t_dt))
                {
                    newKey = t_dt.ToString("yyyy/MM/dd");
                }

                // 検査項目名1～5
                itemName1 = Util.ConvertToString(detail.ITEMNAME1);
                itemName2 = Util.ConvertToString(detail.ITEMNAME2);
                itemName3 = Util.ConvertToString(detail.ITEMNAME3);
                itemName4 = Util.ConvertToString(detail.ITEMNAME4);
                itemName5 = Util.ConvertToString(detail.ITEMNAME5);

                // 日付ごとに改ページ
                if (newKey != oldKey || currentLine >= dayidListField.ListRows.Length)
                {
                    pageNo++;

                    // 現在ページおよび日付の編集
                    pageField.Text = Util.ConvertToString(pageNo);
                    printdateField.Text = sysdate;
                    csldateField.Text = oldKey;
                    // 検査項目名1～5
                    itemname1Field.Text = itemName1;
                    itemname2Field.Text = itemName2;
                    itemname3Field.Text = itemName3;
                    itemname4Field.Text = itemName4;
                    itemname5Field.Text = itemName5;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 現在編集行のリセット
                    currentLine = 0;

                    // キーブレイクによる改ページ処理
                    if (newKey != oldKey)
                    {
                        oldKey = newKey;
                    }
                    
                }

                // 当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);
                // フリガナ
                knameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.LASTKNAME).Trim() + " " + Util.ConvertToString(detail.FIRSTKNAME).Trim();
                // 氏名
                caternameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.LASTNAME).Trim() + "　" + Util.ConvertToString(detail.FIRSTNAME).Trim();
                // 患者ID
                peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PERID);
                // 年齢
                ageListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.AGE);
                // 性別
                genderListField.ListCell(0, currentLine).Text = (Util.ConvertToString(detail.GENDER) == "1") ? "男性" : "女性";
                // 前回受診日
                if (DateTime.TryParse(Util.ConvertToString(detail.PRE_CSLDATE), out DateTime pre_dt))
                {
                    zendateListField.ListCell(0, currentLine).Text = pre_dt.ToString("yyyy/MM/dd");
                }
                // 回数
                cslcountListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSLCOUNT);

                //予約番号
                rsvNo = Util.ConvertToString(detail.RSVNO);
                //予約番号（前回）
                preRsvNo = Util.ConvertToString(detail.PRE_RSVNO);

                //検査結果
                if (!string.IsNullOrEmpty(rsvNo))
                {
                    //TPHA
                    tphaListField.ListCell(0, currentLine).Text = GetDataStc(rsvNo, "1");
                    //HBs抗原
                    hbs_genListField.ListCell(0, currentLine).Text = GetDataStc(rsvNo, "2");
                    //HBs抗体
                    hbs_taiListField.ListCell(0, currentLine).Text = GetDataStc(rsvNo, "3");
                    //HCV
                    hcvListField.ListCell(0, currentLine).Text = GetDataStc(rsvNo, "4");
                    //HCV
                    psaListField.ListCell(0, currentLine).Text = GetDataResult(rsvNo, "5");
                }
                //検査結果（前回）
                if (!string.IsNullOrEmpty(preRsvNo))
                {
                    //TPHA（前）
                    pre_tphaListField.ListCell(0, currentLine).Text = GetDataStc(preRsvNo, "1");
                    //HBs抗原（前）
                    pre_hbs_genListField.ListCell(0, currentLine).Text = GetDataStc(preRsvNo, "2");
                    //HBs抗体（前）
                    pre_hbs_taiListField.ListCell(0, currentLine).Text = GetDataStc(preRsvNo, "3");
                    //HCV（前）
                    pre_hcvListField.ListCell(0, currentLine).Text = GetDataStc(preRsvNo, "4");
                    //HCV（前）
                    pre_psaListField.ListCell(0, currentLine).Text = GetDataResult(preRsvNo, "5");
                }

                //検索項目（前）括弧
                par_tpha_sListField.ListCell(0, currentLine).Text = "(";
                par_hbs_gen_sListField.ListCell(0, currentLine).Text = "(";
                par_hbs_tai_sListField.ListCell(0, currentLine).Text = "(";
                par_hcv_sListField.ListCell(0, currentLine).Text = "(";
                par_psa_sListField.ListCell(0, currentLine).Text = "(";
                par_tpha_eListField.ListCell(0, currentLine).Text = ")";
                par_hbs_gen_eListField.ListCell(0, currentLine).Text = ")";
                par_hbs_tai_eListField.ListCell(0, currentLine).Text = ")";
                par_hcv_eListField.ListCell(0, currentLine).Text = ")";
                par_psa_eListField.ListCell(0, currentLine).Text = ")";


                currentLine++;
                
            }

            // 終了処理
            if (currentLine > 0)
            {
                pageNo++;

                // 現在ページおよび日付の編集
                pageField.Text = Util.ConvertToString(pageNo);
                printdateField.Text = sysdate;
                csldateField.Text = oldKey;
                // 検査項目名1～5
                itemname1Field.Text = itemName1;
                itemname2Field.Text = itemName2;
                itemname3Field.Text = itemName3;
                itemname4Field.Text = itemName4;
                itemname5Field.Text = itemName5;

                // ドキュメントの出力
                PrintOut(cnForm);

                // 現在編集行のリセット
                currentLine = 0;
            }
        }

        /// <summary>
        /// 対象データ取得（TPHA、Hbs抗原、HBs抗体、HCV抗体）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="seq">表示順番</param>
        /// <returns></returns>
        private string GetDataStc(string rsvNo,string p_seq)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        sub_se.longstc 
                    from
                        rsl sub_rs
                        , grp_i sub_gi
                        , item_c sub_ic
                        , sentence sub_se 
                    where
                        sub_rs.rsvno = :rsvno
                        and sub_gi.grpcd = :grpcd 
                        and sub_gi.seq = :seq
                        and sub_rs.itemcd = sub_gi.itemcd 
                        and sub_rs.suffix = sub_gi.suffix 
                        and sub_ic.itemcd = sub_rs.itemcd 
                        and sub_ic.suffix = sub_rs.suffix 
                        and sub_ic.resulttype = :resulttype
                        and sub_se.itemcd = sub_ic.stcitemcd 
                        and sub_se.itemtype = sub_ic.itemtype 
                        and sub_se.stccd = sub_rs.result
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = S_GRPCD,
                seq = p_seq,
                resulttype = S_RESULTTYPE
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault(); ;

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.LONGSTC));
        }

        /// <summary>
        /// 対象データ取得（PSA）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="seq">表示順番</param>
        /// <returns></returns>
        private string GetDataResult(string rsvNo, string p_seq)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        sub_rs.result 
                    from
                        rsl sub_rs
                        , grp_i sub_gi
                        , item_c sub_ic 
                    where
                        sub_rs.rsvno = :rsvno
                        and sub_gi.grpcd = :grpcd 
                        and sub_gi.seq = :seq
                        and sub_rs.itemcd = sub_gi.itemcd 
                        and sub_rs.suffix = sub_gi.suffix 
                        and sub_ic.itemcd = sub_rs.itemcd 
                        and sub_ic.suffix = sub_rs.suffix 
                        and sub_ic.resulttype = :resulttype
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = R_GRPCD,
                seq = p_seq,
                resulttype = R_RESULTTYPE
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault(); ;

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.RESULT));
        }

    }
}
