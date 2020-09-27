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
    /// 成績表CL：胸部CTチェックリスト生成クラス
    /// </summary>
    public class ReportCTChecklistCreator : PdfCreator
    {
       
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002280";

        /// <summary>
        /// コースコード
        /// </summary>
        private const string CNST_CSCD01 = "100";
        private const string CNST_CSCD02 = "105";
        private const string CNST_CSCD03 = "110";
        private const string CNST_CSCD04 = "150";
        private const string CNST_CSCD05 = "155";

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
        /// 成績表CL：胸部CTチェックリストデータを読み込む
        /// </summary>
        /// <returns>成績表CL：胸部CTチェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    csldate as csldate
                    , dayid as dayid
                    , shortstc as shortstc
                    , judcd as judrname
                    , judcomment as judcomment 
                from
                    ( 
                        select
                            kbxview.csldate as csldate
                            , kbxview.dayid as dayid
                            , kbxview.shortstc as shortstc
                            , kbxview.judcd as judcd
                            , decode( 
                                judcd
                                , 'A'
                                , decode( 
                                    result
                                    , '1'
                                    , decode( 
                                        ctjudcd
                                        , 'A'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    ) 
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                ) 
                                , null
                                , decode( 
                                    rslcmtcd2
                                    , null
                                    , decode(shortstc, null, '▲胸部CT結果待ち', '●胸部CT自動判定待ち')
                                    , '×胸部CTキャンセル'
                                ) 
                                , 'B1'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'B1'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , 'B2'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'B2'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , 'C1'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'C1'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , 'C3'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'C3'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , 'C6'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'C6'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , 'D1'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'D1'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , 'D2'
                                , decode( 
                                    result
                                    , '1'
                                    , '確認してください（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見なし）'
                                    , decode( 
                                        ctjudcd
                                        , 'D2'
                                        , '正常（判定：' || judcd || '、レポート判定：' || ctjudcd || '、所見有り）'
                                        , '確認してください（判定(' || judcd || ')とレポート判定(' || ctjudcd || ')が合いません－システムの方に連絡して下さい。）'
                                    )
                                ) 
                                , '確認してください'
                            ) as judcomment 
                        from
                            ( 
                                select
                                    kbxview1.csldate
                                    , kbxview1.dayid
                                    , kbxview1.shortstc
                                    , kbxview1.judcd
                                    , kbxview1.result
                                    , kbxview1.rslcmtcd2
                                    , kbxview2.avgresult
                                    , decode( 
                                        kbxview1.result
                                        , '1'
                                        , decode(kbxview2.avgresult, '1', '1', '2')
                                        , '1'
                                    ) as judcomment
                                    , decode( 
                                        ctview3.result
                                        , '4001'
                                        , 'A'
                                        , '4002'
                                        , 'B1'
                                        , '4003'
                                        , 'B2'
                                        , '4004'
                                        , 'C1'
                                        , '4005'
                                        , 'C3'
                                        , '4006'
                                        , 'C6'
                                        , '4007'
                                        , 'D1'
                                        , '4008'
                                        , 'D2'
                                    ) as ctjudcd 
                                from
                                    ( 
                                        select
                                            v_consult1.csldate as csldate
                                            , v_consult1.dayid as dayid
                                            , v_consult1.rsvno as rsvno
                                            , v_consult2.shortstc as shortstc
                                            , v_consult2.judcd as judcd
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
                                                    and consult.cscd in ( 
                                                        :para_cscd01
                                                        , :para_cscd02
                                                        , :para_cscd03
                                                        , :para_cscd04
                                                        , :para_cscd05
                                                    ) 
                                                    and consult.rsvno = receipt.rsvno 
                                                    and consult.rsvno = rsl.rsvno 
                                                    and rsl.itemcd in ('21220', '21320', '21420')
                                            ) v_consult1 
                                            left join ( 
                                                select distinct
                                                    csldate
                                                    , dayid
                                                    , rsvno
                                                    , shortstc
                                                    , max(judcd) as judcd
                                                    , max(result) as result 
                                                from
                                                    ( 
                                                        select distinct
                                                            to_char(consult.csldate, 'YYYYMMDD') as csldate
                                                            , receipt.dayid as dayid
                                                            , consult.rsvno as rsvno
                                                            , sentence.shortstc as shortstc
                                                            , jud.judcd as judcd
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
                                                            and consult.cscd in ( 
                                                                :para_cscd01
                                                                , :para_cscd02
                                                                , :para_cscd03
                                                                , :para_cscd04
                                                                , :para_cscd05
                                                            ) 
                                                            and receipt.comedate is not null 
                                                            and rsl.itemcd in ('21220', '21320', '21420') 
                                                            and rsl.result is not null 
                                                            and rsl.itemcd = item_c.itemcd 
                                                            and rsl.suffix = item_c.suffix 
                                                            and item_c.itemcd = sentence.itemcd 
                                                            and item_c.itemtype = sentence.itemtype 
                                                            and rsl.result = sentence.stccd 
                                                            and consult.rsvno = judrsl.rsvno 
                                                            and judclass.judclasscd = 27 
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
                                                            and consult.cscd in ( 
                                                                :para_cscd01
                                                                , :para_cscd02
                                                                , :para_cscd03
                                                                , :para_cscd04
                                                                , :para_cscd05
                                                            ) 
                                                            and receipt.comedate is not null 
                                                            and rsl.itemcd in ('21220', '21320', '21420') 
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
                                            ) v_consult2 
                                                on v_consult1.rsvno = v_consult2.rsvno
                                    ) kbxview1 
                                    left join ( 
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
                                            and rsl.itemcd in ('21220', '21320', '21420') 
                                        group by
                                            consult.rsvno
                                    ) kbxview2 
                                        on kbxview1.rsvno = kbxview2.rsvno 
                                    left join ( 
                                        select
                                            consult.rsvno
                                            , rsl.result 
                                        from
                                            consult
                                            , rsl 
                                        where
                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                            and consult.cancelflg = :cancelflg  
                                            and consult.rsvno = rsl.rsvno 
                                            and rsl.itemcd in ('21440')
                                    ) ctview3 
                                        on kbxview1.rsvno = ctview3.rsvno
                            ) kbxview 
                        where
                            kbxview.judcomment = '1'
                    ) 
                order by
                    csldate
                    , judcomment
                    , judcd
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

                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">成績表CL：胸部CTチェックリストデータ</param>
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
                var judcommentTextField = (CnTextField)cnObjects["JUDCOMMENT" + linePos];
                judcommentTextField.Text = Util.ConvertToString(detail.JUDCOMMENT);

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
