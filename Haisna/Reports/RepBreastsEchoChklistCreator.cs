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
    /// 成績表CL：乳房超音波チェックリスト生成クラス
    /// </summary>
    public class RepBreastsEchoChklistCreator : PdfCreator
    {
        
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002300";

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
        /// 成績表CL：乳房超音波チェックリストデータを読み込む
        /// </summary>
        /// <returns>成績表CL：乳房超音波チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    csldate
                    , pername
                    , dayid
                    , judcd
                    , judcd2
                    , kensaname
                    , echocatername
                    , echocatelname
                    , xcatername
                    , xcatelname
                    , comcnt
                    , shortstc
                    , kensacd1
                    , kensacd2
                    , kensacd3
                    , decode( 
                        kensacd2
                        , null
                        , nejudcomment
                        , decode( 
                            judcd
                            , null
                            , judcomment
                            , decode( 
                                judcd2
                                , null
                                , judcomment
                                , decode( 
                                    judcd
                                    , judcd2
                                    , judcomment
                                    , '確認要（判定とレポート判定が違います。）システムに確認してください。'
                                )
                            )
                        )
                    ) as judcomment 
                from
                    ( 
                        select
                            b_o_view1.csldate as csldate
                            , b_o_view1.pername as pername
                            , b_o_view1.dayid as dayid
                            , decode( 
                                b_o_view2.judcd
                                , null
                                , b_o_view3.judcd
                                , b_o_view2.judcd
                            ) as judcd
                            , judcd2
                            , b_o_view3.kensaname || decode( 
                                b_o_view2.kensaname
                                , null
                                , ''
                                , decode( 
                                    b_o_view3.kensaname
                                    , null
                                    , b_o_view2.kensaname
                                    , '、' || b_o_view2.kensaname
                                )
                            ) as kensaname
                            , b_o_view2.catername2 || '　　　　　　　　　 ' || b_o_view2.catername as echocatername
                            , b_o_view2.catelname2 || '　　　　　　　　　 ' || b_o_view2.catelname as echocatelname
                            , b_o_view3.catername2 || '                  ' || b_o_view3.catername as xcatername
                            , b_o_view3.catelname2 || '                  ' || b_o_view3.catelname as xcatelname
                            , b_o_view3.comcnt as comcnt
                            , b_o_view4.shortstc as shortstc
                            , b_o_view4.kensacd as kensacd1
                            , b_o_view3.kensacd as kensacd2
                            , b_o_view2.kensacd as kensacd3
                            , b_o_view2.judcomment as nejudcomment
                            , b_o_view3.judcomment as nmjudcomment
                            , decode( 
                                b_o_view2.judcomment2
                                , 1
                                , decode( 
                                    b_o_view3.judcomment2
                                    , 1
                                    , '正常'
                                    , 2
                                    , '確認要（乳房Ｘ線 : ' || b_o_view3.judcomment || '）'
                                    , 0
                                    , '正常'
                                    , 9
                                    , '▲乳房Ｘ線待ち'
                                    , 8
                                    , '●乳房Ｘ線自動判定待ち'
                                    , 7
                                    , b_o_view2.judcomment2
                                ) 
                                , 2
                                , decode( 
                                    b_o_view3.judcomment2
                                    , 1
                                    , '確認要（乳房超音波 : ' || b_o_view2.judcomment || '）'
                                    , 2
                                    , '確認要（乳房超音波 : ' || b_o_view2.judcomment || '、乳房Ｘ線 : ' || b_o_view3.judcomment || '）'
                                    , 0
                                    , '確認要（乳房超音波 : ' || b_o_view2.judcomment || '、乳房Ｘ線 : ' || b_o_view3.judcomment || '）'
                                    , 9
                                    , '▲乳房Ｘ線待ち'
                                    , 8
                                    , '●乳房Ｘ線自動判定待ち'
                                    , 7
                                    , b_o_view2.judcomment2
                                ) 
                                , 0
                                , decode( 
                                    b_o_view3.judcomment2
                                    , 1
                                    , '正常'
                                    , 2
                                    , '確認要（乳房超音波 : ' || b_o_view2.judcomment || '、乳房Ｘ線 : ' || b_o_view3.judcomment || '）'
                                    , 0
                                    , '確認要（乳房超音波、乳房Ｘ線－判定Ｂ以上・著変無し）'
                                    , 9
                                    , '▲乳房Ｘ線待ち'
                                    , 8
                                    , '●乳房Ｘ線自動判定待ち'
                                    , 7
                                    , b_o_view2.judcomment2
                                ) 
                                , 9
                                , decode( 
                                    b_o_view3.judcomment2
                                    , 1
                                    , '▲乳房超音波待ち'
                                    , 2
                                    , '▲乳房超音波待ち'
                                    , 0
                                    , '▲乳房超音波待ち'
                                    , 9
                                    , '▲乳房超音波待ち、乳房Ｘ線待ち'
                                    , 8
                                    , '▲乳房超音波待ち、乳房Ｘ線自動判定待ち'
                                    , 7
                                    , b_o_view2.judcomment2
                                ) 
                                , 8
                                , decode( 
                                    b_o_view3.judcomment2
                                    , 1
                                    , '●乳房超音波自動判定待ち'
                                    , 2
                                    , '●乳房超音波自動判定待ち'
                                    , 0
                                    , '●乳房超音波自動判定待ち'
                                    , 9
                                    , '▲乳房超音波自動判定待ち、乳房Ｘ線待ち'
                                    , 8
                                    , '●乳房超音波自動判定待ち、乳房Ｘ線自動判定待ち'
                                    , 7
                                    , b_o_view2.judcomment2
                                ) 
                                , 7
                                , decode( 
                                    b_o_view3.judcomment2
                                    , 1
                                    , b_o_view3.judcomment2
                                    , 2
                                    , b_o_view3.judcomment2
                                    , 0
                                    , b_o_view3.judcomment2
                                    , 9
                                    , b_o_view3.judcomment2
                                    , 8
                                    , b_o_view3.judcomment2
                                    , 7
                                    , b_o_view3.judcomment2
                                )
                            ) as judcomment 
                        from
                            ( 
                                select distinct
                                    to_char(consult.csldate, 'YYYYMMDD') as csldate
                                    , receipt.dayid
                                    , person.lastname || ' ' || person.firstname as pername
                                    , consult.rsvno
                                    , rsl.rslcmtcd2 
                                from
                                    consult
                                    , receipt
                                    , person
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in ( 
                                        :para_cscd01
                                        , :para_cscd02
                                        , :para_cscd03
                                        , :para_cscd04
                                        , :para_cscd05
                                    ) 
                                    and consult.perid = person.perid 
                                    and consult.rsvno = receipt.rsvno 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd in ('28820', '28700')
                            ) b_o_view1 
                            left join ( 
                                select
                                    csldate
                                    , rsvno
                                    , dayid
                                    , kensaname
                                    , kensacd
                                    , judcd
                                    , judcd2
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
                                            , decode(comcnt, null, '▲乳房超音波待ち', '●乳房超音波自動判定待ち')
                                            , '×乳房超音波キャンセル'
                                        ) 
                                        , judcomment
                                    ) as judcomment
                                    , decode( 
                                        judcd
                                        , null
                                        , decode(rslcmtcd2, null, decode(comcnt, null, 9, 8), 7)
                                        , judcomment2
                                    ) as judcomment2 
                                from
                                    ( 
                                        select
                                            v_consult1.csldate
                                            , v_consult1.dayid
                                            , '乳房超音波' as kensaname
                                            , decode(v_consult1.rslcmtcd2, null, 3) as kensacd
                                            , v_consult1.rsvno
                                            , v_consult2.judcd
                                            , v_consult2.judcd2
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
                                                            cater1
                                                            , '1'
                                                            , decode( 
                                                                catel1
                                                                , '1'
                                                                , decode( 
                                                                    comrflg
                                                                    , '1'
                                                                    , '確認要（判：' || judcd || '、乳（右）:所見有り）'
                                                                    , decode( 
                                                                        comlflg
                                                                        , '1'
                                                                        , '確認要（判：' || judcd || '、乳（左）:所見有り）'
                                                                        , '正常（判：' || judcd || '、乳（両方）:著変なし- 所見なし）'
                                                                    )
                                                                ) 
                                                                , '確認要(判：' || judcd || '、乳（左）:' || catelname2 || ')'
                                                            ) 
                                                            , decode( 
                                                                catel1
                                                                , '1'
                                                                , '確認要(判：' || judcd || '、乳（右）:' || catername2 || ')'
                                                                , '確認要(判：' || judcd || '、乳（両方）:カテゴリー2以上)'
                                                            )
                                                        ) 
                                                        , decode( 
                                                            cater1
                                                            , '1'
                                                            , decode( 
                                                                catel1
                                                                , '1'
                                                                , '確認要（判：' || judcd || '、乳（両方）:著変なし、乳房触診の結果を確認してください。）'
                                                                , decode( 
                                                                    comlflg
                                                                    , '1'
                                                                    , decode( 
                                                                        comrflg
                                                                        , '1'
                                                                        , '確認要（判：' || judcd || '、乳（右）:著変なし－所見有り）'
                                                                        , '正常（判：' || judcd || '、乳（右）:著変なし－所見なし、乳（左）:カテゴリー2以上－所見有り）'
                                                                    ) 
                                                                    , '確認要（判：' || judcd || '、乳（左）:カテゴリー2以上－所見なし）'
                                                                )
                                                            ) 
                                                            , decode( 
                                                                comrflg
                                                                , '1'
                                                                , decode( 
                                                                    catel1
                                                                    , '1'
                                                                    , decode( 
                                                                        comlflg
                                                                        , '1'
                                                                        , '確認要（判：' || judcd || '、乳（左）:著変なし－所見あり）'
                                                                        , '正常（判：' || judcd || '、乳（右）:カテゴリー2以上－所見有り、乳（左）:著変なし－所見なし）'
                                                                    ) 
                                                                    , decode( 
                                                                        comlflg
                                                                        , '1'
                                                                        , '正常（判：' || judcd || '、乳（右）:カテゴリー2以上－所見有り、乳（左）:カテゴリー2以上－所見有り）'
                                                                        , '確認要（判：' || judcd || '、乳（右）:カテゴリー2以上－所見有り、乳（左）:カテゴリー2以上－所見なし）'
                                                                    )
                                                                ) 
                                                                , '確認要（判：' || judcd || '、乳（右）:カテゴリー2以上－所見なし）'
                                                            )
                                                        )
                                                    )
                                                )
                                            ) as judcomment
                                            , decode( 
                                                catercode
                                                , null
                                                , decode(catelcode, null, 2, 2)
                                                , decode( 
                                                    catelcode
                                                    , null
                                                    , 2
                                                    , decode( 
                                                        judcd
                                                        , 'A'
                                                        , decode( 
                                                            cater1
                                                            , '1'
                                                            , decode( 
                                                                catel1
                                                                , '1'
                                                                , decode(comrflg, '1', 2, decode(comlflg, '1', 2, 1))
                                                                , 2
                                                            ) 
                                                            , decode(catel1, '1', 2, 2)
                                                        ) 
                                                        , decode( 
                                                            cater1
                                                            , '1'
                                                            , decode( 
                                                                catel1
                                                                , '1'
                                                                , 0
                                                                , decode(comlflg, '1', decode(comrflg, '1', 2, 1), 2)
                                                            ) 
                                                            , decode( 
                                                                comrflg
                                                                , '1'
                                                                , decode( 
                                                                    catel1
                                                                    , '1'
                                                                    , decode(comlflg, '1', 2, 1)
                                                                    , decode(comlflg, '1', 1, 2)
                                                                ) 
                                                                , 2
                                                            )
                                                        )
                                                    )
                                                )
                                            ) as judcomment2
                                            , comcnt 
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
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                                    and rsl.itemcd in ('28820', '28700', '30047')
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
                                                            , '1'
                                                            , 'A'
                                                            , '2'
                                                            , 'A'
                                                            , '3'
                                                            , 'B2'
                                                            , '7'
                                                            , 'D1'
                                                            , '4'
                                                            , 'C1'
                                                            , '5'
                                                            , 'C3'
                                                            , '6'
                                                            , 'C6'
                                                            , '8'
                                                            , 'D2'
                                                            , null
                                                        )
                                                    ) as judcd2
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '201'
                                                            , reptstc
                                                            , '200'
                                                            , reptstc
                                                            , '202'
                                                            , reptstc
                                                            , '203'
                                                            , reptstc
                                                            , '204'
                                                            , reptstc
                                                            , '205'
                                                            , reptstc
                                                        )
                                                    ) as catername
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '201'
                                                            , shortstc
                                                            , '200'
                                                            , shortstc
                                                            , '202'
                                                            , shortstc
                                                            , '203'
                                                            , shortstc
                                                            , '204'
                                                            , shortstc
                                                            , '205'
                                                            , shortstc
                                                        )
                                                    ) as catername2
                                                    , max(decode(result, '201', '1', '200', '1')) as cater1
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '202'
                                                            , '1'
                                                            , '203'
                                                            , '1'
                                                            , '204'
                                                            , '1'
                                                            , '205'
                                                            , '1'
                                                        )
                                                    ) as nrjud3
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '201'
                                                            , result
                                                            , '200'
                                                            , result
                                                            , '202'
                                                            , result
                                                            , '203'
                                                            , result
                                                            , '204'
                                                            , result
                                                            , '205'
                                                            , result
                                                        )
                                                    ) as catercode
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '21'
                                                            , '1'
                                                            , '22'
                                                            , '1'
                                                            , '23'
                                                            , '1'
                                                            , '24'
                                                            , '1'
                                                            , '25'
                                                            , '1'
                                                            , '26'
                                                            , '1'
                                                            , '27'
                                                            , '1'
                                                            , '28'
                                                            , '1'
                                                            , '29'
                                                            , '1'
                                                            , '40'
                                                            , '1'
                                                            , '42'
                                                            , '1'
                                                        )
                                                    ) as comrflg
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '301'
                                                            , reptstc
                                                            , '300'
                                                            , reptstc
                                                            , '302'
                                                            , reptstc
                                                            , '303'
                                                            , reptstc
                                                            , '304'
                                                            , reptstc
                                                            , '305'
                                                            , reptstc
                                                        )
                                                    ) as catelname
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '301'
                                                            , shortstc
                                                            , '300'
                                                            , shortstc
                                                            , '302'
                                                            , shortstc
                                                            , '303'
                                                            , shortstc
                                                            , '304'
                                                            , shortstc
                                                            , '305'
                                                            , shortstc
                                                        )
                                                    ) as catelname2
                                                    , max(decode(result, '301', '1', '300', '1')) as catel1
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '302'
                                                            , '1'
                                                            , '303'
                                                            , '1'
                                                            , '304'
                                                            , '1'
                                                            , '305'
                                                            , '1'
                                                        )
                                                    ) as nljud3
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '301'
                                                            , result
                                                            , '300'
                                                            , result
                                                            , '302'
                                                            , result
                                                            , '303'
                                                            , result
                                                            , '304'
                                                            , result
                                                            , '305'
                                                            , result
                                                        )
                                                    ) as catelcode
                                                    , max( 
                                                        decode( 
                                                            result
                                                            , '31'
                                                            , '1'
                                                            , '32'
                                                            , '1'
                                                            , '33'
                                                            , '1'
                                                            , '34'
                                                            , '1'
                                                            , '35'
                                                            , '1'
                                                            , '36'
                                                            , '1'
                                                            , '37'
                                                            , '1'
                                                            , '38'
                                                            , '1'
                                                            , '39'
                                                            , '1'
                                                            , '41'
                                                            , '1'
                                                            , '43'
                                                            , '1'
                                                        )
                                                    ) as comlflg
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
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                                            and rsl.itemcd in ('28820', '28700', '30047') 
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
                                                            , null as judcd
                                                            , rsl.result as result 
                                                        from
                                                            consult
                                                            , receipt
                                                            , rsl
                                                            , item_c
                                                            , sentence 
                                                        where
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                                            and rsl.itemcd in ('28820', '28700', '30047') 
                                                            and rsl.result is not null 
                                                            and rsl.itemcd = item_c.itemcd 
                                                            and rsl.suffix = item_c.suffix 
                                                            and item_c.itemcd = sentence.itemcd 
                                                            and item_c.itemtype = sentence.itemtype 
                                                            and rsl.result = sentence.stccd
                                                    ) 
                                                group by
                                                    csldate
                                                    , rsvno
                                                    , dayid
                                            ) v_consult2 
                                                on v_consult1.rsvno = v_consult2.rsvno
                                    )
                            ) b_o_view2 
                                on b_o_view1.rsvno = b_o_view2.rsvno 
                            left join ( 
                                select
                                    csldate
                                    , dayid
                                    , kensaname
                                    , kensacd
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
                                    , decode( 
                                        judcd
                                        , null
                                        , decode(rslcmtcd2, null, decode(comcnt, null, 9, 8), 7)
                                        , judcomment2
                                    ) as judcomment2
                                    , comcnt 
                                from
                                    ( 
                                        select
                                            v_consult1.csldate
                                            , v_consult1.dayid
                                            , '乳房X線' as kensaname
                                            , decode(v_consult1.rslcmtcd2, null, 2) as kensacd
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
                                            , decode( 
                                                catercode
                                                , null
                                                , decode(catelcode, null, 2, 2)
                                                , decode( 
                                                    catelcode
                                                    , null
                                                    , 2
                                                    , decode( 
                                                        judcd
                                                        , 'A'
                                                        , decode( 
                                                            sign(catercode - 1038)
                                                            , - 1
                                                            , decode(sign(catelcode - 2038), '-1', 1, 2)
                                                            , decode(sign(catelcode - 2038), '-1', 2, 2)
                                                        ) 
                                                        , decode( 
                                                            sign(catercode - 1037)
                                                            , 1
                                                            , decode(sign(catelcode - 2037), '1', 1, 1)
                                                            , decode(sign(catelcode - 2037), '1', 1, 0)
                                                        )
                                                    )
                                                )
                                            ) as judcomment2
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
                                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                                    and rsl.itemcd in ( 
                                                        '27770'
                                                        , '27771'
                                                        , '27772'
                                                        , '27773'
                                                        , '27774'
                                                        , '27775'
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
                                                    , count(result) as comcnt 
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
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                                            , null as judcd
                                                            , rsl.result as result 
                                                        from
                                                            consult
                                                            , receipt
                                                            , rsl
                                                            , item_c
                                                            , sentence 
                                                        where
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                            ) v_consult2 
                                                on v_consult1.rsvno = v_consult2.rsvno
                                    )
                            ) b_o_view3 
                                on b_o_view1.rsvno = b_o_view3.rsvno 
                            left join ( 
                                select distinct
                                    v_consult1.rsvno
                                    , decode( 
                                        v_consult1.rslcmtcd2
                                        , null
                                        , sentence.shortstc
                                        , 'キャンセル'
                                    ) as shortstc
                                    , decode(v_consult1.rslcmtcd2, null, 1) as kensacd 
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
                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:endDate, 'YYYYMMDD') 
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
                                            and rsl.itemcd = '30032' 
                                            and rsl.suffix = '00' 
                                            and rsl.itemcd = item_c.itemcd 
                                            and rsl.suffix = item_c.suffix
                                    ) v_consult1 
                                    left join sentence 
                                        on v_consult1.itemcd = sentence.itemcd 
                                        and v_consult1.result = sentence.stccd 
                                        and v_consult1.itemtype = sentence.itemtype
                            ) b_o_view4 
                                on b_o_view1.rsvno = b_o_view4.rsvno
                    ) 
                order by
                    csldate
                    , kensaname desc
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
        /// <param name="data">成績表CL：乳房超音波チェックリストデータ</param>
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
                //検査名
                var kensanameTextField = (CnTextField)cnObjects["KENSANAME" + linePos];
                kensanameTextField.Text = Util.ConvertToString(detail.KENSANAME);

                //乳房超音波左
                var echocatelnameTextField = (CnTextField)cnObjects["ECHOCATELNAME" + linePos];
                echocatelnameTextField.Text = Util.ConvertToString(detail.ECHOCATELNAME);

                //乳房超音波右
                var echocaternameTextField = (CnTextField)cnObjects["ECHOCATERNAME" + linePos];
                echocaternameTextField.Text = Util.ConvertToString(detail.ECHOCATERNAME);

                //乳房Ｘ線左
                var xcatelnameTextField = (CnTextField)cnObjects["XCATELNAME" + linePos];
                xcatelnameTextField.Text = Util.ConvertToString(detail.XCATELNAME);

                //乳房Ｘ線右
                var xcaternameTextField = (CnTextField)cnObjects["XCATERNAME" + linePos];
                xcaternameTextField.Text = Util.ConvertToString(detail.XCATERNAME);

                //判定内容
                var judcommentTextField = (CnTextField)cnObjects["JUDCOMMENT" + linePos];
                judcommentTextField.Text = Util.ConvertToString(detail.JUDCOMMENT);

                //判定値
                judcdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.JUDCD);

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
