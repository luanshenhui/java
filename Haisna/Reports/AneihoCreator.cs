using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 労働基準監督署統計生成クラス
    /// </summary>
    public class AneihoCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000700";

        /// <summary>
        /// 労基署用　グループコード
        /// </summary>
        private const string GRPCD_CHORYOKU_4000 = "X671";  //労基署　聴力４０００
        private const string GRPCD_CHORYOKU_1000 = "X672";  //労基署　聴力１０００
        private const string GRPCD_KAKUTAN = "X673";        //労基署　喀痰
        private const string GRPCD_TOU = "X674";            //労基署　尿糖
        private const string GRPCD_TANPAKU = "X675";        //労基署　尿蛋白

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_JUD = "LST000700"; //有所見・医師の指示判定
        
        /// <summary>
        /// パラメタ上限数
        /// </summary>
        private const int MAX_COUNT_ORG = 10;       //団体コード指定数
        private const int MAX_COUNT_CSCD = 10;      //コースコード指定数

        /// <summary>
        /// デフォルト　コースコード（コース指定がなかった場合のコースコード）
        /// </summary>
        private const string DEF_CSCD1 = "100";
        private const string DEF_CSCD2 = "105";
        private const string DEF_CSCD3 = "110";

        /// <summary>
        /// パラメタ情報
        /// </summary>
        private List<string> orgcd_list = new List<string>();   //団体情報
        private List<string> cscd_list = new List<string>();    //コース情報

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //入力チェック
            string wkStaDate = queryParams["startdate"];
            string wkEndDate = queryParams["enddate"];
            if (!DateTime.TryParse(wkStaDate, out DateTime wkDate))
            {
                messages.Add("開始日が正しくありません。");
            }

            if (!DateTime.TryParse(wkEndDate, out wkDate))
            {
                messages.Add("終了日が正しくありません。");
            }

            //団体コード１が未設定の場合にエラー
            string orgcd1 = queryParams["orgcd11"] + queryParams["orgcd21"];
            string orgcd_s1 = queryParams["orgcd_s1"];
            if ( (string.IsNullOrEmpty(orgcd1)) && (string.IsNullOrEmpty(orgcd_s1)))
            {
                //以外はエラー
                messages.Add("団体コードが未設定です。");
            }
            
            return messages;

        }

        /// <summary>
        /// 労働基準監督署統計データを読み込む
        /// </summary>
        /// <returns>労働基準監督署統計データ</returns>
        protected override List<dynamic> GetData()
        {

            //## ヘッダ部取得
            //## 【仕様】method:0 最初に指定された団体の住所を編集する
            //## 【仕様】method:1 最小の団体コードの団体の住所を編集する

            //団体パラメタ
            if (queryParams["method"] == "0")
            {
                //団体コード１・２の場合
                for (int i = 1; i <= MAX_COUNT_ORG; i++)
                {
                    string para_name1 = "orgcd1" + i.ToString();
                    string para_name2 = "orgcd2" + i.ToString();

                    if ((!string.IsNullOrEmpty(queryParams[para_name1])) || (!string.IsNullOrEmpty(queryParams[para_name2])))
                    {
                        //団体指定がある場合、値を退避
                        orgcd_list.Add(queryParams[para_name1].Trim() + queryParams[para_name2].Trim());
                    }
                }
            }
            else
            {
                //団体コード１の場合
                for (int i = 1; i <= MAX_COUNT_ORG; i++)
                {
                    string para_name1 = "orgcd_s" + i.ToString();

                    if (!string.IsNullOrEmpty(queryParams[para_name1]))
                    {
                        //団体指定がある場合、値を退避
                        orgcd_list.Add(queryParams[para_name1].Trim());
                    }
                }
            }

            //コースパラメタ
            for (int i = 1; i <= MAX_COUNT_CSCD; i++)
            {
                string para_name = "cscd" + i.ToString();

                if (!string.IsNullOrEmpty(queryParams[para_name]))
                {
                    //コース指定がある場合、値を退避
                    cscd_list.Add(queryParams[para_name].Trim());
                }
            }

            // SQLステートメント定義
            string sql = @"
                select
                    * 
                from
                    ( 
                        select
                            consult.orgcd1
                            , consult.orgcd2
                            , consult.rsvno
                            , orgaddr.orgname
                            , orgaddr.zipcd
                            , pref.prefname
                            , orgaddr.cityname
                            , orgaddr.address1
                            , orgaddr.address2
                            , orgaddr.tel 
                        from
                            consult
                            , receipt
                            , org
                            , orgaddr
                            , pref 
                        where
                            consult.csldate between :startdate and :enddate
                            and consult.rsvno = receipt.rsvno 
                            and receipt.comedate is not null 
                ";

            if ( cscd_list.Count > 0 )
            {
                //コース指定がある場合、指定されたコースコードを抽出
                sql += @"
                            and consult.cscd in ('" + String.Join("','", cscd_list) + "')";
            }
            else
            {
                //コース指定がない場合は1日人間ドック、職員定期健康診断（ドック）、企業健診のみカウント
                sql += @"
                            and consult.cscd in (:def_cscd1, :def_cscd2, :def_cscd3) 
                ";
            }

            if (queryParams["method"] == "0")
            {
                //団体コード１・２の場合、最初に指定された団体の住所を編集する
                sql += @"
                            and consult.orgcd1 || consult.orgcd2 = '" + orgcd_list[0] + "'";
            }
            else
            {
                //指定された団体コードを抽出
                sql += @"
                            and consult.orgcd1 in ('" + String.Join("','", orgcd_list) + "')";
            }

            sql += @"
                            and consult.orgcd1 = org.orgcd1 
                            and consult.orgcd2 = org.orgcd2 
                            and org.orgcd1 = orgaddr.orgcd1(+) 
                            and org.orgcd2 = orgaddr.orgcd2(+) 
                            and orgaddr.addrdiv = :addrdiv 
                            and orgaddr.prefcd = pref.prefcd(+) 
                        order by
                            consult.orgcd1
                            , consult.orgcd2
                    ) mainview 
                where
                    rownum = 1
                ";

            //受診日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = dSdate,
                enddate = dEdate,
                def_cscd1 = DEF_CSCD1,
                def_cscd2 = DEF_CSCD2,
                def_cscd3 = DEF_CSCD3,

                addrdiv = "1"
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">労働基準監督署統計データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {

            // フォームのオブジェクト取得
            CnForm cnForm = cnForms[0];
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            string sysdate = DateTime.Today.ToShortDateString();

            //編集処理開始
            var nendoField = (CnDataField)cnObjects["txtNENDO"];
            var monthField = (CnDataField)cnObjects["txtMONTH"];
            var csldateField = (CnDataField)cnObjects["txtCSLDATE"];
            var orgnmField = (CnDataField)cnObjects["txtORGNM"];
            var orgnm2Field = (CnDataField)cnObjects["txtORGNM2"];
            var zipnoField = (CnDataField)cnObjects["txtZIPNO"];
            var addr1Field = (CnDataField)cnObjects["txtADDR1"];
            var addr2Field = (CnDataField)cnObjects["txtADDR2"];
            var addr3Field = (CnDataField)cnObjects["txtADDR3"];
            var telnoField = (CnDataField)cnObjects["txtTELNO"];
            var cslcntField = (CnDataField)cnObjects["txtCSLCNT"];
            var jyusinListField = (CnListField)cnObjects["lstJYUSIN"];
            var syokenListField = (CnListField)cnObjects["lstSYOKEN"];
            var syoken2Field = (CnDataField)cnObjects["txtSYOKEN"];
            var drsijiField = (CnDataField)cnObjects["txtDrSIJI"];

            //対象　基本情報データ
            var kihon = data[0];

            //対象年
            DateTime startDate = DateTime.Parse(queryParams["startdate"]);
            DateTime endDate = DateTime.Parse(queryParams["enddate"]);

            // 開始日より終了日が過去であれば値を交換
            if (startDate > endDate)
            {
                DateTime wkDate = startDate;
                startDate = endDate;
                endDate = wkDate;
            }

            nendoField.Text = startDate.ToString("yyyy") + "年";

            //対象期間
            monthField.Text = startDate.ToString("MM") + " 月 ～ " + endDate.ToString("MM") + " 月";

            //健診年月日
            string csldate = GetConsultDate();

            if (!string.IsNullOrEmpty(csldate))
            {
                csldateField.Text = DateTime.Parse(csldate).ToString("yyyy/MM/dd");
            }

            //事業場名称
            string orgname = Util.ConvertToString(kihon.ORGNAME);
            if (orgname.Length > 16)
            {
                orgnmField.Text = orgname.Substring(0, 16);
                orgnm2Field.Text = orgname.Substring(16);
            }
            else
            {
                orgnmField.Text = orgname;
                orgnm2Field.Text = "";
            }

            //郵便番号
            string zipcd = Util.ConvertToString(kihon.ZIPCD);
            if (zipcd.Length > 3)
            {
                zipnoField.Text = zipcd.Substring(0, 3) + "-" + zipcd.Substring(3);
            }
            else
            {
                zipnoField.Text = zipcd;
            }

            //住所
            addr1Field.Text = Util.ConvertToString(kihon.PREFNAME) + Util.ConvertToString(kihon.CITYNAME) + Util.ConvertToString(kihon.ADDRESS1) + " ";
            addr2Field.Text = Util.ConvertToString(kihon.ADDRESS2) + " ";

            //電話番号
            telnoField.Text = Util.ConvertToString(kihon.TEL) + " ";

            //受診労働者数
            cslcntField.Text = GetConsultNum().ToString();

            //汎用マスタ取得（有所見・医師指示情報）
            var freeDao = new FreeDao(connection);
            IList<dynamic> freeJudData = freeDao.SelectFree(1, FREECD_JUD);

            string jud_C = "";
            string jud_D = "";
            if (freeJudData.Count > 0)
            {
                jud_C = freeJudData[0].FREEFIELD1;
                jud_D = freeJudData[0].FREEFIELD2;
            }

            //実施人数・有所見者数の取得
            var numData = GetNumberData();

            //集計処理
            decimal[,] cnt1_zisshi = new decimal[2, 7];     //実施者数カウント
            decimal[,] cnt2_shoken = new decimal[2, 7];     //有所見者数カウント
            decimal cnt3_shoken_d = 0; //有所見人数カウント（実人数）
            decimal cnt4_shiji = 0;    //医師指示人数カウント

            int outCnt = 0;

            foreach ( var detail in numData )
            {
                bool syoken_Flg = false;    //所見有無フラグ

                //01 聴力4000（実施者）
                if (detail.S聴40001 == "S" && detail.S聴40002 == "S")
                {
                }
                else
                {
                    if (!string.IsNullOrEmpty(detail.聴40001) || !string.IsNullOrEmpty(detail.聴40002))
                    {
                        cnt1_zisshi[0, 0]++;
                    }
                }

                //01 聴力4000（有所見者）
                if ((string.IsNullOrEmpty(detail.S聴40001) == true && detail.聴40001 == "3")
                    || (string.IsNullOrEmpty(detail.S聴40002) == true && detail.聴40002 == "3"))
                {
                    cnt2_shoken[0, 0]++;
                    syoken_Flg = true;
                }

                //03 胸部（実施者）
                if (!string.IsNullOrEmpty(detail.胸部))
                {

                    cnt1_zisshi[0, 2]++;
                }

                //03 胸部（有所見者）
                if (GetStr(detail.胸部, 1, 1) == jud_C
                    || GetStr(detail.胸部, 1, 1) == jud_D)
                {
                    cnt2_shoken[0, 2]++;
                    syoken_Flg = true;
                }

                //04 喀痰（実施者）
                if (detail.S喀痰1 == "S")
                {
                }
                else
                {
                    if (!string.IsNullOrEmpty(detail.喀痰1))
                    {
                        cnt1_zisshi[0, 3]++;
                    }
                }

                //04 喀痰（有所見者）
                if ((string.IsNullOrEmpty(detail.S喀痰1) == true
                    && (detail.喀痰1 == "1002" || detail.喀痰1 == "1003"
                    || detail.喀痰1 == "1004" || detail.喀痰1 == "1005" || detail.喀痰1 == "1006")) 
                     ||(string.IsNullOrEmpty(detail.S喀痰2) == true
                        && (detail.喀痰2 == "1002" || detail.喀痰2 == "1003"
                        || detail.喀痰2 == "1004" || detail.喀痰2 == "1005" || detail.喀痰2 == "1006")) 
                     || (string.IsNullOrEmpty(detail.S喀痰3) == true
                        && (detail.喀痰3 == "1002" || detail.喀痰3 == "1003"
                        || detail.喀痰3 == "1004" || detail.喀痰3 == "1005" || detail.喀痰3 == "1006")))
                {
                    cnt2_shoken[0, 3]++;
                    syoken_Flg = true;
                }

                //05 血圧（実施者）
                if (!string.IsNullOrEmpty(detail.血圧))
                {
                    cnt1_zisshi[0, 4]++;
                }

                //05 血圧（有所見者）
                if (GetStr(detail.血圧, 1, 1) == jud_C
                    || GetStr(detail.血圧, 1, 1) == jud_D)
                {
                    cnt2_shoken[0, 4]++;
                    syoken_Flg = true;
                }

                //06 貧血（実施者）
                if (!string.IsNullOrEmpty(detail.貧血))
                {
                    cnt1_zisshi[0, 5]++;
                }

                //06 貧血（有所見者）
                if (GetStr(detail.貧血, 1, 1) == jud_C
                    || GetStr(detail.貧血, 1, 1) == jud_D)
                {
                    cnt2_shoken[0, 5]++;
                    syoken_Flg = true;
                }

                //07 肝機能（実施者）
                if (!string.IsNullOrEmpty(detail.肝臓))
                {
                    cnt1_zisshi[0, 6]++;
                }

                //07 肝機能（有所見者）
                if (GetStr(detail.肝臓, 1, 1) == jud_C
                    || GetStr(detail.肝臓, 1, 1) == jud_D)
                {
                    cnt2_shoken[0, 6]++;
                    syoken_Flg = true;
                }

                //08 血中脂質（実施者）
                if (!string.IsNullOrEmpty(detail.脂質))
                {
                    cnt1_zisshi[1, 0]++;
                }

                //08 血中脂質（有所見者）
                if (GetStr(detail.脂質, 1, 1) == jud_C
                    || GetStr(detail.脂質, 1, 1) == jud_D)
                {
                    cnt2_shoken[1, 0]++;
                    syoken_Flg = true;
                }

                //09 血糖（実施者）
                if (!string.IsNullOrEmpty(detail.糖))
                {
                    cnt1_zisshi[1, 1]++;
                }

                //09 血糖（有所見者）
                if (GetStr(detail.糖, 1, 1) == jud_C
                    || GetStr(detail.糖, 1, 1) == jud_D)
                {
                    cnt2_shoken[1, 1]++;
                    syoken_Flg = true;
                }

                //10 聴力1000（実施者）
                if (detail.S聴10001 == "S" && detail.S聴10002 == "S")
                {
                }
                else
                {
                    if (!string.IsNullOrEmpty(detail.聴10001) || !string.IsNullOrEmpty(detail.聴10002))
                    {
                        cnt1_zisshi[1, 2]++;
                    }
                }

                //10 聴力1000（有所見者）
                if ((string.IsNullOrEmpty(detail.S聴10001) == true && detail.聴10001 == "3")
                    || (string.IsNullOrEmpty(detail.S聴10002) == true && detail.聴10002 == "3"))
                {
                    cnt2_shoken[1, 2]++;
                    syoken_Flg = true;
                }

                //11 尿糖（実施者）
                if (detail.S尿糖 == "S")
                {
                }
                else
                {
                    if (!string.IsNullOrEmpty(detail.尿糖))
                    {
                        cnt1_zisshi[1, 3]++;
                    }
                }

                //11 尿糖（有所見者）
                decimal.TryParse(detail.尿糖, out decimal rsl_tou);
                if ((string.IsNullOrEmpty(detail.S尿糖) == true && rsl_tou >= 2 && rsl_tou <= 10))
                {
                    cnt2_shoken[1, 3]++;
                    syoken_Flg = true;
                }

                //12 尿蛋白（実施者）
                if (detail.S尿蛋白 == "S")
                {
                }
                else
                {
                    if (!string.IsNullOrEmpty(detail.尿蛋白))
                    {
                        cnt1_zisshi[1, 4]++;
                    }
                }

                //12 尿蛋白（有所見者）
                decimal.TryParse(detail.尿蛋白, out decimal rsl_tanpaku);
                if ((string.IsNullOrEmpty(detail.S尿蛋白) == true && rsl_tanpaku >= 3 && rsl_tanpaku <= 9))
                {
                    cnt2_shoken[1, 4]++;
                    syoken_Flg = true;
                }

                //13 心電図（実施者）
                if (!string.IsNullOrEmpty(detail.心電図))
                {
                    cnt1_zisshi[1, 5]++;
                }

                //13 心電図（有所見者）
                if (GetStr(detail.心電図, 1, 1) == jud_C || GetStr(detail.心電図, 1, 1) == jud_D)
                {
                    cnt2_shoken[1, 5]++;
                    syoken_Flg = true;
                }

                //所見のあった者の人数
                if (syoken_Flg == true)
                {
                    cnt3_shoken_d++;
                }

                //医師の指示人数
                if (GetStr(detail.聴力, 1, 1) == jud_D
                    || GetStr(detail.胸部, 1, 1) == jud_D
                    || GetStr(detail.血圧, 1, 1) == jud_D
                    || GetStr(detail.貧血, 1, 1) == jud_D
                    || GetStr(detail.肝臓, 1, 1) == jud_D
                    || GetStr(detail.脂質, 1, 1) == jud_D
                    || GetStr(detail.糖, 1, 1) == jud_D
                    || GetStr(detail.尿, 1, 1) == jud_D
                    || GetStr(detail.心電図, 1, 1) == jud_D)
                {
                    cnt4_shiji++;
                }

                //データ件数インクリメント
                outCnt++;

            }

            //編集処理
            for (int i = 0; i <= 1; i++)
            {
                for (int j = 0; j <= 6; j++)
                {
                    jyusinListField.ListCell((short)i, (short)j).Text = cnt1_zisshi[i, j].ToString();
                    syokenListField.ListCell((short)i, (short)j).Text = cnt2_shoken[i, j].ToString();
                }
            }

            syoken2Field.Text = cnt3_shoken_d.ToString();
            drsijiField.Text = cnt4_shiji.ToString();

            //## 聴力検査（その他）は未実施のため空白
            jyusinListField.ListCell(0, 1).Text = "";
            syokenListField.ListCell(0, 1).Text = "";

            jyusinListField.ListCell(1, 6).Text = "";
            syokenListField.ListCell(1, 6).Text = "";

            // ドキュメントの出力
            PrintOut(cnForm);

        }

        /// <summary>
        ///  健診年月日（範囲内の最小）取得
        /// </summary>
        /// <returns>取得データ</returns>
        private string GetConsultDate()
        {

            // SQLステートメント定義
            string sql = @"
                select
                    max(consult.csldate) csldate 
                from
                    consult
                    , receipt 
                where
                    consult.csldate between :startdate and :enddate 
                    and consult.rsvno = receipt.rsvno 
                    and receipt.comedate is not null
                ";

            if (cscd_list.Count > 0)
            {
                //コース指定がある場合、指定されたコースコードを抽出
                sql += @"
                            and consult.cscd in ('" + String.Join("','", cscd_list) + "')";
            }
            else
            {
                //コース指定がない場合は1日人間ドック、職員定期健康診断（ドック）、企業健診のみカウント
                sql += @"
                            and consult.cscd in (:def_cscd1, :def_cscd2, :def_cscd3) 
                ";
            }

            if (queryParams["method"] == "0")
            {
                //団体コード１・２の場合
                sql += @"
                            and consult.orgcd1 || consult.orgcd2 in ('" + String.Join("','", orgcd_list) + "')";
            }
            else
            {
                //団体コード１の場合
                sql += @"
                            and consult.orgcd1 in ('" + String.Join("','", orgcd_list) + "')";
            }

            //受診日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = dSdate,
                enddate = dEdate,
                def_cscd1 = DEF_CSCD1,
                def_cscd2 = DEF_CSCD2,
                def_cscd3 = DEF_CSCD3
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : Util.ConvertToString(result.CSLDATE);
        }

        /// <summary>
        /// 受診労働者情報取得
        /// </summary>
        /// <returns>取得データ</returns>
        private decimal GetConsultNum()
        {

            // SQLステートメント定義
            string sql = @"
                select
                    count(*) cnt 
                from
                    consult
                    , receipt 
                where
                    consult.csldate between :startdate and :enddate 
                    and consult.rsvno = receipt.rsvno 
                    and receipt.comedate is not null 
                ";

            if (cscd_list.Count > 0)
            {
                //コース指定がある場合、指定されたコースコードを抽出
                sql += @"
                            and consult.cscd in ('" + String.Join("','", cscd_list) + "')";
            }
            else
            {
                //コース指定がない場合は1日人間ドック、職員定期健康診断（ドック）、企業健診のみカウント
                sql += @"
                            and consult.cscd in (:def_cscd1, :def_cscd2, :def_cscd3) 
                ";
            }

            if (queryParams["method"] == "0")
            {
                //団体コード１・２の場合
                sql += @"
                            and consult.orgcd1 || consult.orgcd2 in ('" + String.Join("','", orgcd_list) + "')";
            }
            else
            {
                //団体コード１の場合
                sql += @"
                            and consult.orgcd1 in ('" + String.Join("','", orgcd_list) + "')";
            }

            //受診日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = dSdate,
                enddate = dEdate,
                def_cscd1 = DEF_CSCD1,
                def_cscd2 = DEF_CSCD2,
                def_cscd3 = DEF_CSCD3
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? 0 : Convert.ToDecimal(result.CNT);
        }

        /// <summary>
        /// 実施人数・有所見者数取得
        /// </summary>
        /// <returns>取得データ</returns>
        private dynamic GetNumberData()
        {

            // SQLステートメント定義
            string sql = @"
                select
                    consult.rsvno
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X671' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 聴40001
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X671' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S聴40001
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X671' 
                                    and seq = 2
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 聴40002
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X671' 
                                    and seq = 2
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S聴40002
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X672' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 聴10001
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X672' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S聴10001
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X672' 
                                    and seq = 2
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 聴10002
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X672' 
                                    and seq = 2
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S聴10002
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X673' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 喀痰1
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X673' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S喀痰1
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X673' 
                                    and seq = 2
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 喀痰2
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X673' 
                                    and seq = 2
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S喀痰2
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X673' 
                                    and seq = 3
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 喀痰3
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X673' 
                                    and seq = 3
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S喀痰3
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X674' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 尿糖
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X674' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S尿糖
                    , ( 
                        select
                            nvl(result, '未入力') 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X675' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) 尿蛋白
                    , ( 
                        select
                            stopflg 
                        from
                            rsl 
                        where
                            itemcd || suffix = ( 
                                select
                                    itemcd || suffix 
                                from
                                    grp_i 
                                where
                                    grpcd = 'X675' 
                                    and seq = 1
                            ) 
                            and rsl.rsvno = consult.rsvno
                    ) S尿蛋白
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 6 
                            and judrsl.rsvno = consult.rsvno
                    ) 胸部
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 3 
                            and judrsl.rsvno = consult.rsvno
                    ) 血圧
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 10 
                            and judrsl.rsvno = consult.rsvno
                    ) 貧血
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 14 
                            and judrsl.rsvno = consult.rsvno
                    ) 肝臓
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 12 
                            and judrsl.rsvno = consult.rsvno
                    ) 脂質
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 11 
                            and judrsl.rsvno = consult.rsvno
                    ) 糖
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 4 
                            and judrsl.rsvno = consult.rsvno
                    ) 心電図
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 22 
                            and judrsl.rsvno = consult.rsvno
                    ) 聴力
                    , ( 
                        select
                            nvl(judcd, '未入力') 
                        from
                            judrsl 
                        where
                            judclasscd = 19 
                            and judrsl.rsvno = consult.rsvno
                    ) 尿 
                from
                    consult
                    , receipt 
                where
                    consult.csldate between :startdate and :enddate 
                    and consult.rsvno = receipt.rsvno 
                    and receipt.comedate is not null
                ";

            if (cscd_list.Count > 0)
            {
                //コース指定がある場合、指定されたコースコードを抽出
                sql += @"
                            and consult.cscd in ('" + String.Join("','", cscd_list) + "')";
            }
            else
            {
                //コース指定がない場合は1日人間ドック、職員定期健康診断（ドック）、企業健診のみカウント
                sql += @"
                            and consult.cscd in (:def_cscd1, :def_cscd2, :def_cscd3) 
                ";
            }

            if (queryParams["method"] == "0")
            {
                //団体コード１・２の場合
                sql += @"
                            and consult.orgcd1 || consult.orgcd2 in ('" + String.Join("','", orgcd_list) + "')";
            }
            else
            {
                //団体コード１の場合
                sql += @"
                            and consult.orgcd1 in ('" + String.Join("','", orgcd_list) + "')";
            }

            //受診日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = dSdate,
                enddate = dEdate,
                def_cscd1 = DEF_CSCD1,
                def_cscd2 = DEF_CSCD2,
                def_cscd3 = DEF_CSCD3,

                grpcd_cho4000 = GRPCD_CHORYOKU_4000,
                grpcd_cho1000 = GRPCD_CHORYOKU_1000,
                grpcd_kakutan = GRPCD_KAKUTAN,
                grpcd_tou = GRPCD_TOU,
                grpcd_tanpaku = GRPCD_TANPAKU
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 指定桁の文字列取得
        /// </summary>
        /// <returns>取得データ</returns>
        private string GetStr(string rsl, int startpos, int keta)
        {
            string ret = Util.ConvertToString(rsl);

            if (ret.Length < (startpos + keta) - 1 )
            {
                //桁不足の場合は空を返す
                ret = "";
            }
            else
            {
                ret = ret.Substring(startpos - 1, keta);
            }

            return ret;

        }

    }
}
