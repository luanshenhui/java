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
    /// 成績表CL：胸部X線チェックリスト生成クラス
    /// </summary>
    public class ReportChestXChecklistCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002250";

        /// <summary>
        /// コースコード
        /// </summary>
        private const string CNST_CSCD01 = "100";
        private const string CNST_CSCD02 = "105";
        private const string CNST_CSCD03 = "110";
        private const string CNST_CSCD04 = "150";
        private const string CNST_CSCD05 = "155";

        /// <summary>
        /// 検査項目コード
        /// </summary>
        private const string CNST_ITEMCD01 = "21030";
        private const string CNST_ITEMCD02 = "21031";
        private const string CNST_ITEMCD03 = "22020";

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
        /// 成績表CL：胸部X線チェックリストデータを読み込む
        /// </summary>
        /// <returns>成績表CL：胸部X線チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    csldate
                    , dayid
                    , shortstc
                    , judrname
                    , judcomment 
                from
                    ( 
                        select
                            kbxview.csldate as csldate
                            , kbxview.dayid as dayid
                            , kbxview.shortstc as shortstc
                            , kbxview.judrname as judrname
                            , decode( 
                                judrname
                                , 'Ａ'
                                , decode( 
                                    result
                                    , '1'
                                    , '正常（判定：Ａ、所見：著変なし）'
                                    , '確認してください（判定：Ａ、所見有り）'
                                ) 
                                , null
                                , decode( 
                                    rslcmtcd2
                                    , null
                                    , decode(result, null, '▲胸部X線検査待ち', '●胸部X線自動判定待ち')
                                    , '×胸部X線キャンセル'
                                ) 
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：Ｂ以下、所見なし）'
                                    , '正常（判定：Ｂ以下、所見有り）'
                                )
                            ) as judcomment 
                        from
                            ( 
                                select
                                    kbxview1.csldate
                                    , kbxview1.dayid
                                    , kbxview1.shortstc
                                    , kbxview1.judrname
                                    , kbxview1.result
                                    , kbxview1.rslcmtcd2
                                    , kbxview2.avgresult
                                    , decode( 
                                        kbxview1.result
                                        , '1'
                                        , decode(kbxview2.avgresult, '1', '1', '2')
                                        , '1'
                                    ) as judcomment 
                                from
                                    ( 
                                        select
                                            v_consult1.csldate as csldate
                                            , v_consult1.dayid as dayid
                                            , v_consult1.rsvno as rsvno
                                            , v_consult2.shortstc as shortstc
                                            , v_consult2.judrname as judrname
                                            , v_consult2.result as result
                                            , v_consult1.rslcmtcd2 as rslcmtcd2 
                                        from
                                            ( 
                                                select distinct
                                                    to_char(consult.csldate, 'YYYYMMDD') as csldate
                                                    , receipt.dayid
                                                    , consult.rsvno
                                                    , rsl.rslcmtcd2 
                                                from
                                                    consult
                                                    , receipt
                                                    , rsl 
                                                where
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                    and consult.cancelflg = :cancelflg  
                                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04, :para_cscd05) 
                                                    and consult.rsvno = receipt.rsvno 
                                                    and consult.rsvno = rsl.rsvno 
                                                    and rsl.itemcd in (:para_itemcd01, :para_itemcd02, :para_itemcd03)
                                            ) v_consult1
                                            left join ( 
                                                select distinct
                                                    csldate
                                                    , dayid
                                                    , rsvno
                                                    , shortstc
                                                    , max(judrname) as judrname
                                                    , max(result) as result 
                                                from
                                                    ( 
                                                        select distinct
                                                            to_char(consult.csldate, 'YYYYMMDD') as csldate
                                                            , receipt.dayid as dayid
                                                            , consult.rsvno as rsvno
                                                            , sentence.shortstc as shortstc
                                                            , jud.judrname as judrname
                                                            , rsl.result as result 
                                                        from
                                                            consult
                                                            , receipt
                                                            , rsl
                                                            , item_c
                                                            , sentence
                                                            , judrsl
                                                            , judclass
                                                            , jud 
                                                        where
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                            and consult.cancelflg = :cancelflg  
                                                            and consult.rsvno = receipt.rsvno 
                                                            and consult.rsvno = rsl.rsvno 
                                                            and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04, :para_cscd05) 
                                                            and receipt.comedate is not null 
                                                            and rsl.itemcd in (:para_itemcd01, :para_itemcd02, :para_itemcd03) 
                                                            and rsl.result is not null 
                                                            and rsl.itemcd = item_c.itemcd 
                                                            and rsl.suffix = item_c.suffix 
                                                            and item_c.itemcd = sentence.itemcd 
                                                            and item_c.itemtype = sentence.itemtype 
                                                            and rsl.result = sentence.stccd 
                                                            and consult.rsvno = judrsl.rsvno 
                                                            and judclass.judclasscd = 6 
                                                            and judrsl.judclasscd = judclass.judclasscd 
                                                            and judrsl.judcd = jud.judcd 
                                                        union 
                                                        select distinct
                                                            to_char(consult.csldate, 'YYYYMMDD') as csldate
                                                            , receipt.dayid as dayid
                                                            , consult.rsvno as rsvno
                                                            , sentence.shortstc as shortstc
                                                            , '' as judrname
                                                            , result as result 
                                                        from
                                                            consult
                                                            , receipt
                                                            , rsl
                                                            , item_c
                                                            , sentence 
                                                        where
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                            and consult.cancelflg = :cancelflg  
                                                            and consult.rsvno = receipt.rsvno 
                                                            and consult.rsvno = rsl.rsvno 
                                                            and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04, :para_cscd05) 
                                                            and receipt.comedate is not null 
                                                            and rsl.itemcd in (:para_itemcd01, :para_itemcd02, :para_itemcd03) 
                                                            and rsl.result is not null 
                                                            and rsl.itemcd = item_c.itemcd 
                                                            and rsl.suffix = item_c.suffix 
                                                            and item_c.itemcd = sentence.itemcd 
                                                            and item_c.itemtype = sentence.itemtype 
                                                            and rsl.result = sentence.stccd
                                                    ) 
                                                group by
                                                    csldate
                                                    , dayid
                                                    , rsvno
                                                    , shortstc
                                            ) v_consult2 on v_consult1.rsvno = v_consult2.rsvno
                                    ) kbxview1
                                    , ( 
                                        select
                                            consult.rsvno as rsvno
                                            , avg(rsl.result) as avgresult 
                                        from
                                            consult
                                            , rsl 
                                        where
                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                            and consult.cancelflg = :cancelflg  
                                            and consult.rsvno = rsl.rsvno 
                                            and rsl.itemcd in (:para_itemcd01, :para_itemcd02, :para_itemcd03) 
                                        group by
                                            consult.rsvno
                                    ) kbxview2 
                                where
                                    kbxview1.rsvno = kbxview2.rsvno
                            ) kbxview 
                        where
                            kbxview.judcomment = '1'
                    ) 
                order by
                    csldate
                    , judcomment
                    , judrname
                    , dayid
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
                para_cscd05 = CNST_CSCD05,

                para_itemcd01 = CNST_ITEMCD01,
                para_itemcd02 = CNST_ITEMCD02,
                para_itemcd03 = CNST_ITEMCD03,

                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">成績表CL：胸部X線チェックリストデータ</param>
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
            var judrnameListField = (CnListField)cnObjects["JUDRNAME"];
            var judcommentListField = (CnListField)cnObjects["JUDCOMMENT"];

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

                //当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);

                string linePos = Convert.ToString(currentLine + 1);
                //所見名
                var resultTextField = (CnTextField)cnObjects["SHORTSTC" + linePos];
                resultTextField.Text = Util.ConvertToString(detail.SHORTSTC);

                //判定値
                judrnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.JUDRNAME);

                //判定内容
                judcommentListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.JUDCOMMENT);

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
