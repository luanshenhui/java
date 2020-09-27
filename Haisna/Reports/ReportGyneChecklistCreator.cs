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
    /// 成績表CL：婦人科コメントチェックリスト生成クラス
    /// </summary>
    public class ReportGyneChecklistCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002220";

        /// <summary>
        /// コースコード
        /// </summary>
        private const string CNST_CSCD01 = "100";
        private const string CNST_CSCD02 = "105";
        private const string CNST_CSCD03 = "110";
        private const string CNST_CSCD04 = "155";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();
            bool errFLG = false;

            DateTime wkStrDate;
            if (!DateTime.TryParse(queryParams["startdate"], out wkStrDate))
            {
                messages.Add("開始日付が正しくありません。");
                errFLG = true;
            }

            DateTime wkEndDate;
            if (!string.IsNullOrEmpty(queryParams["enddate"]))
            {
                if (!DateTime.TryParse(queryParams["enddate"], out wkEndDate))
                {
                    messages.Add("終了日付が正しくありません。");
                    errFLG = true;
                }
            }
            else
            {
                //終了日付が未入力の場合は開始日付を設定
                wkEndDate = wkStrDate;
            }

            if (errFLG != true)
            {
                TimeSpan ts;
                ts = wkEndDate - wkStrDate;

                if (Convert.ToDateTime(wkEndDate).CompareTo(Convert.ToDateTime(wkStrDate)) < 0)
                {
                    messages.Add("日付範囲が正しくありません。");

                }
                else
                { 
                    if(Convert.ToInt32( ts.ToString("dd")) > 13)
                    {
                        messages.Add("日付範囲は2週間です。その以上のデータはシステム管理者にご連絡ください。");

                    }
                }

            }

            return messages;
        }

        /// <summary>
        /// 成績表CL：婦人科コメントチェックリストデータを読み込む
        /// </summary>
        /// <returns>成績表CL：婦人科コメントチェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    l1.csldate as csldate
                    , decode( 
                        l2.judclasscd
                        , 25
                        , '婦人科'
                        , 30
                        , '婦人科診'
                        , 31
                        , '子宮頚部細胞診'
                        , '検査キャンセル'
                    ) as bun
                    , l1.dayid as dayid
                    , l1.persname as persname
                    , l2.judclasscd
                    , decode( 
                        l2.judcd
                        , null
                        , decode(l1.rslcmtcd2, null, '婦人科待ち', '婦人科検査キャンセル')
                        , l2.judcd
                    ) as judcd
                    , l3.judcmtstc as judcmtstc 
                from
                    ( 
                        select
                            to_char(consult.csldate, 'YYYYMMDD') as csldate
                            , receipt.dayid
                            , rsl.rsvno
                            , person.perid
                            , person.lastname || ' ' || person.firstname as persname
                            , rsl.rslcmtcd2 
                        from
                            consult
                            , receipt
                            , person
                            , rsl 
                        where
                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                            and consult.cancelflg = :cancelflg  
                            and consult.rsvno = receipt.rsvno 
                            and consult.perid = person.perid 
                            and consult.rsvno = rsl.rsvno 
                            and rsl.itemcd = '27010' 
                            and rsl.suffix = '00' 
                        order by
                            csldate
                            , dayid
                    ) l1
                    left join ( 
                        select
                            cst.rsvno
                            , cst.csldate
                            , rep.dayid
                            , jr.judclasscd
                            , jr.judcd 
                        from
                            consult cst
                            , receipt rep
                            , judrsl jr 
                        where
                            cst.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                            and cst.rsvno = rep.rsvno 
                            and rep.comedate is not null 
                            and cst.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                            and cst.cancelflg = :cancelflg  
                            and cst.rsvno = jr.rsvno 
                            and jr.judclasscd in (25, 30, 31) 
                        order by
                            csldate
                            , dayid
                    ) l2 on l1.rsvno = l2.rsvno
                    left join ( 
                        select
                            cst.rsvno
                            , cst.csldate
                            , rep.dayid
                            , decode( 
                                jcmt.judclasscd
                                , 25
                                , 30
                                , nvl(jcmt.judclasscd, 30)
                            ) judclasscd
                            , jcmt.judcmtstc 
                        from
                            consult cst
                            , receipt rep
                            , totaljudcmt tjcmt
                            , ( 
                                select
                                    * 
                                from
                                    judcmtstc 
                                where
                                    judcmtstc.judclasscd in (25, 30, 31) 
                                    or judcmtcd = '103101'
                            ) jcmt 
                        where
                            cst.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                            and cst.rsvno = rep.rsvno 
                            and rep.comedate is not null 
                            and cst.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                            and cst.cancelflg = :cancelflg  
                            and cst.rsvno = tjcmt.rsvno 
                            and tjcmt.judcmtcd = jcmt.judcmtcd 
                        order by
                            csldate
                            , dayid
                    ) l3 on l2.rsvno = l3.rsvno
                        and l2.judclasscd = l3.judclasscd
                order by
                    l1.csldate
                    , l2.judclasscd
                    , l2.judcd
                    , l1.dayid
                ";

            // パラメータセット
            DateTime dt;
            var sDate = "";
            var eDate = "";
            if (DateTime.TryParse(Util.ConvertToString(queryParams["startdate"]), out dt))
            {
                sDate = dt.ToString("yyyyMMdd");
            }
            if (!string.IsNullOrEmpty(queryParams["enddate"]))
            {
                if (DateTime.TryParse(Util.ConvertToString(queryParams["enddate"]), out dt))
                {
                    eDate = dt.ToString("yyyyMMdd");
                }
            }
            else
            {
                //終了日付が未入力の場合は開始日付を設定
                eDate = sDate;
            }

            var sqlParam = new
            {
                startDate = sDate,
                endDate = eDate,

                para_cscd01 = CNST_CSCD01,
                para_cscd02 = CNST_CSCD02,
                para_cscd03 = CNST_CSCD03,
                para_cscd04 = CNST_CSCD04,

                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">成績表CL：婦人科コメントチェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var printdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var csldateListField = (CnListField)cnObjects["CSLDATE"];
            var dayidListField = (CnListField)cnObjects["DAYID"];

            string sysdate = DateTime.Today.ToShortDateString();

            int rowCount = 0;
            int pageNo = 0;
                  
            int outCnt = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % csldateListField.ListRows.Length);

                // データフィールド

                //受診日
                csldateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSLDATE);

                string linePos = Convert.ToString(currentLine + 1);
                //判定分類
                var bunTextField = (CnTextField)cnObjects["BUN" + linePos];
                bunTextField.Text = Util.ConvertToString(detail.BUN);

                //受診者名
                var persnameTextField = (CnTextField)cnObjects["PERSNAME" + linePos];
                persnameTextField.Text = Util.ConvertToString(detail.PERSNAME);

                //当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);

                //判定値
                var judcdTextField = (CnTextField)cnObjects["JUDCD" + linePos];
                judcdTextField.Text = Util.ConvertToString(detail.JUDCD);

                //総合コメント
                var judcmtstcTextField = (CnTextField)cnObjects["JUDCMTSTC" + linePos];
                judcmtstcTextField.Text = Util.ConvertToString(detail.JUDCMTSTC);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == csldateListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // 印刷日
                    printdateField.Text = sysdate;

                    // ドキュメントの出力
                    PrintOut(cnForm);
                }

                // 行カウントをインクリメント
                rowCount++;

                // 連番をインクリメント
                outCnt++;
            }
        }
         
    }
}
