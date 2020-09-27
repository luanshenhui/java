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
    /// 成績表CL：乳房X線チェックリスト生成クラス
    /// </summary>
    public class ReportMammoChecklistCreator : PdfCreator
    {
       
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002290";

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
        /// 成績表CL：乳房X線チェックリストデータを読み込む
        /// </summary>
        /// <returns>成績表CL：乳房X線チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    csldate as csldate
                    , dayid as dayid
                    , kensaname
                    , rsvno
                    , judcd as judcd
                    , catercode
                    , catelcode
                    , catername as catername
                    , catelname as catelname
                    , catername2 as catername2
                    , catelname2 as catelname2
                    , judcomment as judcomment
                    , shortstc as shortstc
                    , comcnt as comcnt 
                from
                    ( 
                        select
                            csldate
                            , dayid
                            , kensaname
                            , rsvno
                            , judcd
                            , catercode
                            , catelcode
                            , catername
                            , catelname
                            , catername2
                            , catelname2
                            , decode( 
                                judcd
                                , null
                                , decode( 
                                    rslcmtcd2
                                    , null
                                    , decode(comcnt, null, '▲乳房X線待ち', '●乳房X線自動判定待ち')
                                    , '×乳房X線キャンセル'
                                ) 
                                , judcomment
                            ) as judcomment
                            , shortstc
                            , comcnt 
                        from
                            ( 
                                select
                                    v_consult1.csldate
                                    , v_consult1.dayid
                                    , '乳房X線' as kensaname
                                    , v_consult1.rsvno
                                    , v_consult2.judcd
                                    , v_consult1.rslcmtcd2
                                    , v_consult2.catercode
                                    , v_consult2.catelcode
                                    , v_consult2.catername
                                    , v_consult2.catelname
                                    , v_consult2.catername2
                                    , v_consult2.catelname2
                                    , decode( 
                                        catercode
                                        , null
                                        , decode( 
                                            catelcode
                                            , null
                                            , '確認要（乳（右）：カテゴリー無、乳（左）：カテゴリー無）'
                                            , '確認要（乳（右）：カテゴリー無）'
                                        ) 
                                        , decode( 
                                            catelcode
                                            , null
                                            , '確認要（乳（左）：カテゴリー無）'
                                            , decode( 
                                                judcd
                                                , 'A'
                                                , decode( 
                                                    sign(catercode - 1038)
                                                    , - 1
                                                    , decode( 
                                                        sign(catelcode - 2038)
                                                        , '-1'
                                                        , '正常（判：' || judcd || '、乳（両方）：カテゴリー2以下）'
                                                        , '確認要（判：' || judcd || '、乳（左）：カテゴリー3以上）'
                                                    ) 
                                                    , decode( 
                                                        sign(catelcode - 2038)
                                                        , '-1'
                                                        , '確認要（判：' || judcd || '、乳（右）：カテゴリー3以上）'
                                                        , '確認要（判：' || judcd || '、乳（両方）：カテゴリー3以上）'
                                                    )
                                                ) 
                                                , decode( 
                                                    sign(catercode - 1037)
                                                    , 1
                                                    , decode( 
                                                        sign(catelcode - 2037)
                                                        , '1'
                                                        , '正常（判：' || judcd || '、乳（両方）：カテゴリー3以上）'
                                                        , '正常（判：' || judcd || '、乳（右）：カテゴリー3以上）'
                                                    ) 
                                                    , decode( 
                                                        sign(catelcode - 2037)
                                                        , '1'
                                                        , '正常（判：' || judcd || '、乳（左）：カテゴリー3以上）'
                                                        , '確認要（判：' || judcd || '、乳（両方）：カテゴリー2以下）・乳房触診確認'
                                                    )
                                                )
                                            )
                                        )
                                    ) as judcomment
                                    , v_consult3.shortstc
                                    , v_consult2.comcnt 
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
                                            and rsl.itemcd in ( 
                                                '27770'
                                                , '27771'
                                                , '27772'
                                                , '27773'
                                                , '27774'
                                                , '27775'
                                            ) 
                                            and rsl.rsvno not in ( 
                                                select distinct
                                                    consult.rsvno 
                                                from
                                                    consult
                                                    , rsl 
                                                where
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                    and consult.cancelflg = :cancelflg  
                                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04, :para_cscd05) 
                                                    and consult.rsvno = rsl.rsvno 
                                                    and rsl.itemcd in ('28820', '28700') 
                                                    and rsl.rslcmtcd2 is null
                                            )
                                    ) v_consult1
                                    left join ( 
                                        select distinct
                                            csldate
                                            , dayid
                                            , rsvno
                                            , max(judcd) as judcd
                                            , max( 
                                                decode( 
                                                    result
                                                    , '1036'
                                                    , reptstc
                                                    , '1037'
                                                    , reptstc
                                                    , '1038'
                                                    , reptstc
                                                    , '1039'
                                                    , reptstc
                                                    , '1040'
                                                    , reptstc
                                                    , '1045'
                                                    , reptstc
                                                )
                                            ) as catername
                                            , max( 
                                                decode( 
                                                    result
                                                    , '1036'
                                                    , shortstc
                                                    , '1037'
                                                    , shortstc
                                                    , '1038'
                                                    , shortstc
                                                    , '1039'
                                                    , shortstc
                                                    , '1040'
                                                    , shortstc
                                                    , '1045'
                                                    , shortstc
                                                )
                                            ) as catername2
                                            , max( 
                                                decode( 
                                                    result
                                                    , '1036'
                                                    , result
                                                    , '1037'
                                                    , result
                                                    , '1038'
                                                    , result
                                                    , '1039'
                                                    , result
                                                    , '1040'
                                                    , result
                                                    , '1045'
                                                    , result
                                                )
                                            ) as catercode
                                            , max( 
                                                decode( 
                                                    result
                                                    , '2036'
                                                    , reptstc
                                                    , '2037'
                                                    , reptstc
                                                    , '2038'
                                                    , reptstc
                                                    , '2039'
                                                    , reptstc
                                                    , '2040'
                                                    , reptstc
                                                    , '2045'
                                                    , reptstc
                                                )
                                            ) as catelname
                                            , max( 
                                                decode( 
                                                    result
                                                    , '2036'
                                                    , shortstc
                                                    , '2037'
                                                    , shortstc
                                                    , '2038'
                                                    , shortstc
                                                    , '2039'
                                                    , shortstc
                                                    , '2040'
                                                    , shortstc
                                                    , '2045'
                                                    , shortstc
                                                )
                                            ) as catelname2
                                            , max( 
                                                decode( 
                                                    result
                                                    , '2036'
                                                    , result
                                                    , '2037'
                                                    , result
                                                    , '2038'
                                                    , result
                                                    , '2039'
                                                    , result
                                                    , '2040'
                                                    , result
                                                    , '2045'
                                                    , result
                                                )
                                            ) as catelcode
                                            , count(result) / 2 as comcnt 
                                        from
                                            ( 
                                                select distinct
                                                    to_char(consult.csldate, 'YYYYMMDD') as csldate
                                                    , receipt.dayid as dayid
                                                    , consult.rsvno as rsvno
                                                    , sentence.shortstc as shortstc
                                                    , sentence.reptstc as reptstc
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
                                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04, :para_cscd05) 
                                                    and receipt.comedate is not null 
                                                    and rsl.itemcd in ( 
                                                        '27770'
                                                        , '27771'
                                                        , '27772'
                                                        , '27773'
                                                        , '27774'
                                                        , '27775'
                                                    ) 
                                                    and rsl.result is not null 
                                                    and rsl.itemcd = item_c.itemcd 
                                                    and rsl.suffix = item_c.suffix 
                                                    and item_c.itemcd = sentence.itemcd 
                                                    and item_c.itemtype = sentence.itemtype 
                                                    and rsl.result = sentence.stccd 
                                                    and consult.rsvno = judrsl.rsvno 
                                                    and judclass.judclasscd = 24 
                                                    and judrsl.judclasscd = judclass.judclasscd 
                                                    and judrsl.judcd = jud.judcd 
                                                union 
                                                select distinct
                                                    to_char(consult.csldate, 'YYYYMMDD') as csldate
                                                    , receipt.dayid as dayid
                                                    , consult.rsvno as rsvno
                                                    , sentence.shortstc as shortstc
                                                    , sentence.reptstc as reptstc
                                                    , '' as judcd
                                                    , rsl.result as result 
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
                                                    and rsl.itemcd in ( 
                                                        '27770'
                                                        , '27771'
                                                        , '27772'
                                                        , '27773'
                                                        , '27774'
                                                        , '27775'
                                                    ) 
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
                                    ) v_consult2 on v_consult1.rsvno = v_consult2.rsvno
                                    left join ( 
                                        select distinct
                                            v_consult1.rsvno
                                            , decode( 
                                                v_consult1.rslcmtcd2
                                                , null
                                                , sentence.shortstc
                                                , 'キャンセル'
                                            ) as shortstc 
                                        from
                                            ( 
                                                select
                                                    consult.rsvno
                                                    , item_c.itemtype
                                                    , rsl.result
                                                    , rsl.itemcd
                                                    , rsl.rslcmtcd2 
                                                from
                                                    consult
                                                    , receipt
                                                    , rsl
                                                    , item_c 
                                                where
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                    and consult.cancelflg = :cancelflg  
                                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04, :para_cscd05) 
                                                    and consult.rsvno = receipt.rsvno 
                                                    and consult.rsvno = rsl.rsvno 
                                                    and rsl.itemcd = '30032' 
                                                    and rsl.suffix = '00' 
                                                    and rsl.itemcd = item_c.itemcd 
                                                    and rsl.suffix = item_c.suffix
                                            ) v_consult1
                                              left join sentence on v_consult1.itemcd = sentence.itemcd
                                                                and v_consult1.result = sentence.stccd
                                                                and v_consult1.itemtype = sentence.itemtype
                                    ) v_consult3 on v_consult1.rsvno = v_consult3.rsvno
                            )
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
        /// <param name="data">成績表CL：乳房X線チェックリストデータ</param>
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
            var comcntListField = (CnListField)cnObjects["COMCNT"];
            var shortstcListField = (CnListField)cnObjects["SHORTSTC"];

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
                //乳房Ｘ線左
                var catelnameTextField = (CnTextField)cnObjects["CATELNAME" + linePos];
                catelnameTextField.Text = Util.ConvertToString(detail.CATELNAME);

                //乳房Ｘ線右
                var caternameTextField = (CnTextField)cnObjects["CATERNAME" + linePos];
                caternameTextField.Text = Util.ConvertToString(detail.CATERNAME);

                //カテゴリー左
                var catelname2TextField = (CnTextField)cnObjects["CATELNAME2" + linePos];
                catelname2TextField.Text = Util.ConvertToString(detail.CATELNAME2);

                //カテゴリー右
                var catername2TextField = (CnTextField)cnObjects["CATERNAME2" + linePos];
                catername2TextField.Text = Util.ConvertToString(detail.CATERNAME2);

                //判定値
                judcdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.JUDCD);

                //判定内容
                var judcommentTextField = (CnTextField)cnObjects["JUDCOMMENT" + linePos];
                judcommentTextField.Text = Util.ConvertToString(detail.JUDCOMMENT);

                //所見数
                comcntListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.COMCNT);

                //触診判定
                shortstcListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.SHORTSTC);


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
