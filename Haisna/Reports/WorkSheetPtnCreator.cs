using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// ワークシート個人票チェックリスト生成クラス
    /// </summary>
    public class WorkSheetPtnCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000420";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string CNST_FREECD_STMAC = "LST000421%";          // 胃情報取得　汎用コード
        private const string CNST_FREECD_GRP = "LST000420%";            // グループ情報取得　汎用コード

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private const string CNST_FREECLASSCD_GRP = "LST";              // グループ情報取得　汎用分類コード

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["csldate"], out DateTime wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// ワークシート個人票チェックリストデータを読み込む
        /// </summary>
        /// <returns>ワークシート個人票チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    consult.csldate
                    , receipt.dayid
                    , person.lastkname
                    , person.firstkname
                    , person.lastname
                    , person.firstname
                    , consult.orgcd1
                    , consult.orgcd2
                    , org.orgname
                    , consult.cscd
                    , course_p.csname
                    , getstmacdiv(consult.rsvno, :stmac_freecd) as stmacdiv
                    , person.gender
                    , consult.age
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('010', '012')
                    ) as opt1
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('011', '012')
                    ) as opt2
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd = '076'
                    ) as opt3
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd = '005'
                    ) as opt4
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('007', '008', '116', '117')
                    ) as opt5
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('006', '008', '117', '099')
                    ) as opt6
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('115', '116', '117')
                    ) as opt7
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('082', '087')
                    ) as opt8
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in ('083', '087')
                    ) as opt9
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd = '084'
                    ) as opt10
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd = '085'
                    ) as opt11
                    , ( 
                        select
                            decode(count(*), 0, null, '○') 
                        from
                            ctrpt_opt
                            , consult_o 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd = '088'
                    ) as opt12 
                from
                    consult
                      left join receipt on receipt.rsvno = consult.rsvno 
                    , person
                    , org
                    , course_p
                    , free 
                where
                    consult.csldate = :cslDate
                    and consult.cancelflg = :cancelflg  
                    and consult.cscd = free.freefield1 
                    and free.freecd like :grp_freecd
                    and free.freeclasscd = :grp_freeclasscd
                    and course_p.cscd = consult.cscd 
                    and person.perid = consult.perid 
                    and org.orgcd1 = consult.orgcd1 
                    and org.orgcd2 = consult.orgcd2 
                order by
                    consult.csldate
                    , receipt.dayid
                    , consult.rsvgrpcd
                    , consult.orgcd1
                    , consult.orgcd2
                    , consult.perid

                ";

            // パラメータセット
            var sqlParam = new
            {
                cslDate = queryParams["csldate"],

                stmac_freecd = CNST_FREECD_STMAC,
                grp_freecd = CNST_FREECD_GRP,
                grp_freeclasscd = CNST_FREECLASSCD_GRP,
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ワークシート個人票チェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var paracsldateField = (CnDataField)cnObjects["PARACSLDATE"];
            var prtdateField = (CnDataField)cnObjects["PRTDATE"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var dayidListField = (CnListField)cnObjects["DAYID"];
            var knameListField = (CnListField)cnObjects["KNAME"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var orgcdListField = (CnListField)cnObjects["ORGCD"];
            var orgnameListField = (CnListField)cnObjects["ORGNAME"];
            var csnameListField = (CnListField)cnObjects["CSNAME"];
            var stmacdivListField = (CnListField)cnObjects["STOMACDIV"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var optionListField = (CnListField)cnObjects["OPTION"];
            
            string sysdate = DateTime.Today.ToShortDateString();

            int rowCount = 0;
            int pageNo = 0;

            string newKey = "";
            string oldKey = "";

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % dayidListField.ListRows.Length);

                //当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);

                //カナ氏名
                knameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.LASTKNAME) + " " + Util.ConvertToString(detail.FIRSTKNAME);

                //氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.LASTNAME) + " " + Util.ConvertToString(detail.FIRSTNAME);

                //団体コード
                orgcdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGCD1).Trim() + "-" + Util.ConvertToString(detail.ORGCD2).Trim();

                //団体名
                orgnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME).Trim();

                //コース名
                csnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSNAME).Trim();

                //コース名の（）の名称
                stmacdivListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.STMACDIV);

                //性別
                string workBuff = "";
                switch (Util.ConvertToString(detail.GENDER))
                {
                    case "1":
                        workBuff = "男";
                        break;
                    default:
                        workBuff = "女";
                        break;
                }
                genderListField.ListCell(0, currentLine).Text = workBuff;

                //年齢
                ageListField.ListCell(0, currentLine).Text = Convert.ToString(Convert.ToInt32(detail.AGE));

                //オプション１「乳房X線」或いは「乳房X線＋乳房超音波」
                optionListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.OPT1).Trim();

                //オプション２ 「乳房超音波」或いは「乳房X線＋乳房超音波」
                optionListField.ListCell(1, currentLine).Text = Util.ConvertToString(detail.OPT2).Trim();

                //オプション３　HPV
                optionListField.ListCell(2, currentLine).Text = Util.ConvertToString(detail.OPT3).Trim();

                //オプション４
                optionListField.ListCell(3, currentLine).Text = Util.ConvertToString(detail.OPT4).Trim();

                //オプション５「オプションＣＴ」
                optionListField.ListCell(4, currentLine).Text = Util.ConvertToString(detail.OPT5).Trim();

                //オプション６ 「オプションＣＴ・喀痰」
                optionListField.ListCell(5, currentLine).Text = Util.ConvertToString(detail.OPT6).Trim();

                //オプション７ 「喀痰」
                optionListField.ListCell(6, currentLine).Text = Util.ConvertToString(detail.OPT7).Trim();

                //オプション８ 「動脈硬化」
                optionListField.ListCell(7, currentLine).Text = Util.ConvertToString(detail.OPT8).Trim();

                //オプション９ 「頸動脈超音波」
                optionListField.ListCell(8, currentLine).Text = Util.ConvertToString(detail.OPT9).Trim();

                //オプション１０ 「心不全スクリーニング」
                optionListField.ListCell(9, currentLine).Text = Util.ConvertToString(detail.OPT10).Trim();

                //オプション１１ 「内臓脂肪面積」
                optionListField.ListCell(10, currentLine).Text = Util.ConvertToString(detail.OPT11).Trim();

                //オプション１２ 「婦人科超音波」
                optionListField.ListCell(11, currentLine).Text = Util.ConvertToString(detail.OPT12).Trim();

                // データフィールド
                DateTime dt;
                if (string.IsNullOrEmpty(newKey))
                {
                    if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out dt))
                    {
                        newKey = dt.ToString("yyyy/MM/dd");
                    }
                    oldKey = newKey;
                }

                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out dt))
                {
                    newKey = dt.ToString("yyyy/MM/dd");
                }

                // ページ内最大行に達した場合　または　レコード最大数に達した場合　または　キーが異なった場合
                if (currentLine == dayidListField.ListRows.Length - 1 || rowCount == data.Count - 1 || (newKey != oldKey))
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // 受診日
                    paracsldateField.Text = oldKey;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 現在編集行のリセット
                    currentLine = 0;

                    //キーブレイクによる改ページ処理の場合、キーを上書きする
                    if (newKey != oldKey)
                    {
                        oldKey = newKey;
                    }

                }

                // 行カウントをインクリメント
                rowCount++;

            }

        }

    }
}
