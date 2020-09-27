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
    /// 成績表CL：眼底チェックリスト生成クラス
    /// </summary>
    public class RepRetiphotoChecklistCreator : PdfCreator
    {
        
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002230";

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
        /// 成績表CL：眼底チェックリストデータを読み込む
        /// </summary>
        /// <returns>成績表CL：眼底チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    csldate
                    , pname
                    , dayid
                    , perid
                    , judcd
                    , sentence1
                    , sentence2
                    , sentence3
                    , sentence4
                    , judge
                    , comment1 
                from
                    ( 
                        select
                            to_char(csldate, 'YYYYMMDD') as csldate
                            , pname as pname
                            , dayid as dayid
                            , perid as perid
                            , judcd as judcd
                            , sentence1 as sentence1
                            , sentence2 as sentence2
                            , sentence3 as sentence3
                            , decode( 
                                sentence1
                                , null
                                , ''
                                , '判定不能'
                                , ''
                                , decode( 
                                    comment1
                                    , null
                                    , decode( 
                                        comment2
                                        , null
                                        , decode(comment3, null, '所見なし', '所見有り')
                                        , '所見有り'
                                    ) 
                                    , '所見有り'
                                )
                            ) as sentence4
                            , decode( 
                                result1
                                , '1'
                                , decode( 
                                    judcd
                                    , 'A'
                                    , decode( 
                                        result2
                                        , '10'
                                        , decode( 
                                            result3
                                            , '10'
                                            , decode( 
                                                comment1
                                                , null
                                                , '正常'
                                                , '確認して下さい（' || sentence1 || '：所見有り）'
                                            ) 
                                            , '確認して下さい（' || sentence1 || '：Ｈが' || sentence3 || '）'
                                        ) 
                                        , '確認して下さい（' || sentence1 || '：Ｓが' || sentence2 || '）'
                                    ) 
                                    , decode( 
                                        judcd
                                        , null
                                        , '眼底自動判定待ち'
                                        , '確認して下さい（判定と処置区分が合いません。システムにご連絡ください。）'
                                    )
                                ) 
                                , '2'
                                , decode( 
                                    judcd
                                    , 'B2'
                                    , decode( 
                                        result2
                                        , '10'
                                        , decode( 
                                            result3
                                            , '10'
                                            , decode( 
                                                comment1
                                                , null
                                                , '確認して下さい（' || sentence1 || '：Ｈ、Ｓ無し:所見無し）'
                                                , '正常'
                                            ) 
                                            , '正常'
                                        ) 
                                        , '正常'
                                    ) 
                                    , decode( 
                                        judcd
                                        , null
                                        , '眼底自動判定待ち'
                                        , '確認して下さい（判定と処置区分が合いません。システムにご連絡ください。）'
                                    )
                                ) 
                                , '3'
                                , decode( 
                                    judcd
                                    , 'D1'
                                    , decode( 
                                        comment1
                                        , null
                                        , '確認して下さい（' || sentence1 || '：所見なし）'
                                        , decode( 
                                            result2
                                            , null
                                            , '確認して下さい。（Hの結果なし）'
                                            , decode(result3, null, '確認して下さい。（Sの結果なし）', '正常')
                                        )
                                    ) 
                                    , decode( 
                                        judcd
                                        , null
                                        , '眼底自動判定待ち'
                                        , '確認して下さい（判定と処置区分が合いません。システムにご連絡ください。）'
                                    )
                                ) 
                                , '10020'
                                , '眼底判定不能'
                                , null
                                , decode(stopflg, 'S', '眼底キャンセル', '眼底データ無し')
                                , '確認必要：眼底区分が' || result1 || 'です。'
                            ) as judge
                            , decode( 
                                comment4
                                , null
                                , comment11
                                , '* ' || comment11 || ' 所見が4個以上' || ' *'
                            ) as comment1 
                        from
                            ( 
                                select
                                    csldate
                                    , dayid
                                    , perid
                                    , pname
                                    , max(judcd) as judcd
                                    , max(stopflg) as stopflg
                                    , max(itemname1) as itemname1
                                    , max(result1) as result1
                                    , max(sentence1) as sentence1
                                    , max(itemname2) as itemname2
                                    , max(result2) as result2
                                    , max(sentence2) as sentence2
                                    , max(itemname3) as itemname3
                                    , max(result3) as result3
                                    , max(sentence3) as sentence3
                                    , max(comment1) as comment1
                                    , max(comment2) as comment2
                                    , max(comment3) as comment3
                                    , max(comment4) as comment4
                                    , max(comment5) as comment5
                                    , max(comment6) as comment6
                                    , max(comment7) as comment7
                                    , max(comment8) as comment8
                                    , max(comment9) as comment9
                                    , max(comment10) as comment10
                                    , max(comment11) as comment11 
                                from
                                    ( 
                                        select
                                            v_consult1.csldate
                                            , v_consult1.dayid
                                            , v_consult1.perid
                                            , v_consult1.pname
                                            , v_consult1.itemcd
                                            , v_consult1.stopflg
                                            , v_consult1.judcd
                                            , decode(v_consult1.itemcd, '11530', v_consult1.itemname) as itemname1
                                            , decode(v_consult1.itemcd, '11530', v_consult1.result) as result1
                                            , decode(v_consult1.itemcd, '11530', sentence.shortstc) as sentence1
                                            , decode(v_consult1.itemcd, '11175', v_consult1.itemname) as itemname2
                                            , decode(v_consult1.itemcd, '11175', v_consult1.result) as result2
                                            , decode(v_consult1.itemcd, '11175', sentence.shortstc) as sentence2
                                            , decode(v_consult1.itemcd, '11176', v_consult1.itemname) as itemname3
                                            , decode(v_consult1.itemcd, '11176', v_consult1.result) as result3
                                            , decode(v_consult1.itemcd, '11176', sentence.shortstc) as sentence3
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '01', v_consult1.result)
                                            ) as comment1
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '02', v_consult1.result)
                                            ) as comment2
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '03', v_consult1.result)
                                            ) as comment3
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '04', v_consult1.result)
                                            ) as comment4
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '05', v_consult1.result)
                                            ) as comment5
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '06', v_consult1.result)
                                            ) as comment6
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '07', v_consult1.result)
                                            ) as comment7
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '08', v_consult1.result)
                                            ) as comment8
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '09', v_consult1.result)
                                            ) as comment9
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode(v_consult1.suffix, '10', v_consult1.result)
                                            ) as comment10
                                            , decode( 
                                                v_consult1.itemcd
                                                , '11500'
                                                , decode( 
                                                    v_consult1.result
                                                    , '1015'
                                                    , 'その他（右眼）'
                                                    , '1025'
                                                    , 'その他（左眼）'
                                                    , '1035'
                                                    , 'その他（両眼）'
                                                    , '11005'
                                                    , 'その他'
                                                    , null
                                                )
                                            ) as comment11 
                                        from
                                            ( 
                                                select
                                                    consult.csldate as csldate
                                                    , receipt.dayid as dayid
                                                    , consult.perid as perid
                                                    , person.lastname || ' ' || person.firstname as pname
                                                    , item_c.itemcd as itemcd
                                                    , item_c.itemname as itemname
                                                    , item_c.itemtype as itemtype
                                                    , item_c.suffix as suffix
                                                    , rsl.stopflg as stopflg
                                                    , judrsl.judcd as judcd
                                                    , rsl.result as result 
                                                from
                                                    consult
                                                    , receipt
                                                    , item_c
                                                    , rsl
                                                    , person
                                                    , judrsl 
                                                where
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                    and consult.cancelflg = :cancelflg  
                                                    and item_c.itemcd in ('11530', '11176', '11175', '11500') 
                                                    and consult.rsvno = receipt.rsvno 
                                                    and consult.rsvno = rsl.rsvno 
                                                    and item_c.itemcd = rsl.itemcd 
                                                    and item_c.suffix = rsl.suffix 
                                                    and consult.perid = person.perid 
                                                    and rsl.rsvno = judrsl.rsvno 
                                                    and judrsl.judclasscd = 21 
                                                union 
                                                select
                                                    consult.csldate as csldate
                                                    , receipt.dayid as dayid
                                                    , consult.perid as perid
                                                    , person.lastname || ' ' || person.firstname as pname
                                                    , item_c.itemcd as itemcd
                                                    , item_c.itemname as itemname
                                                    , item_c.itemtype as itemtype
                                                    , item_c.suffix as suffix
                                                    , rsl.stopflg as stopflg
                                                    , '' as judcd
                                                    , rsl.result as result 
                                                from
                                                    consult
                                                    , receipt
                                                    , item_c
                                                    , rsl
                                                    , person 
                                                where
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                    and consult.cancelflg = :cancelflg  
                                                    and item_c.itemcd in ('11530', '11176', '11175', '11500') 
                                                    and consult.rsvno = receipt.rsvno 
                                                    and consult.rsvno = rsl.rsvno 
                                                    and item_c.itemcd = rsl.itemcd 
                                                    and item_c.suffix = rsl.suffix 
                                                    and consult.perid = person.perid
                                            ) v_consult1 
                                            left join sentence 
                                                on v_consult1.itemcd = sentence.itemcd 
                                                and v_consult1.itemtype = sentence.itemtype 
                                                and v_consult1.result = sentence.stccd
                                    ) ganteiview 
                                group by
                                    csldate
                                    , dayid
                                    , perid
                                    , pname
                            ) ganteiview2
                    ) 
                order by
                    csldate
                    , judge
                    , judcd desc
                    , sentence1 desc
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

                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">成績表CL：眼底チェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var printdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pagenoField = (CnDataField)cnObjects["PAGENO"];

            var csldateListField = (CnListField)cnObjects["CSLDATE"];
            var dayidListField = (CnListField)cnObjects["DAYID"];

            var judcdListField = (CnListField)cnObjects["JUDCD"];
            var sentence4ListField = (CnListField)cnObjects["SENTENCE4"];

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

                //個人ＩＤ
                var peridTextField = (CnTextField)cnObjects["PERID" + linePos];
                peridTextField.Text = Util.ConvertToString(detail.PERID);

                //受診者名
                var pnameTextField = (CnTextField)cnObjects["PNAME" + linePos];
                pnameTextField.Text = Util.ConvertToString(detail.PNAME);

                //判定
                judcdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.JUDCD);

                //処置区分
                var sentence1TextField = (CnTextField)cnObjects["SENTENCE1" + linePos];
                sentence1TextField.Text = Util.ConvertToString(detail.SENTENCE1);

                //高血圧性変化
                var sentence2TextField = (CnTextField)cnObjects["SENTENCE2" + linePos];
                sentence2TextField.Text = Util.ConvertToString(detail.SENTENCE2);

                //動脈硬化性変化
                var sentence3TextField = (CnTextField)cnObjects["SENTENCE3" + linePos];
                sentence3TextField.Text = Util.ConvertToString(detail.SENTENCE3);

                //所見有無
                sentence4ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.SENTENCE4);

                //区分
                var judgeTextField = (CnTextField)cnObjects["JUDGE" + linePos];
                judgeTextField.Text = Util.ConvertToString(detail.JUDGE);

                //チェック
                var commentTextField = (CnTextField)cnObjects["COMMENT" + linePos];
                commentTextField.Text = Util.ConvertToString(detail.COMMENT1);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == csldateListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pagenoField.Text = pageNo.ToString();

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
