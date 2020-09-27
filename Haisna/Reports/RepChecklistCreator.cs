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
    /// 成績表CL：総合判定連絡票作成用生成クラス
    /// </summary>
    public class RepChecklistCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002210";

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
        /// 成績表CL：総合判定連絡票作成用データを読み込む
        /// </summary>
        /// <returns>成績表CL：総合判定連絡票作成用データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    to_char(v_checklist.csldate, 'YYYYMMDD') as csldate
                    , v_checklist.dayid as dayid
                    , v_checklist.itemname as itemname
                    , v_checklist.result as result
                    , v_checklist.seq as seq
                    , v_checklist.biko as biko 
                from
                    ( 
                        select
                            consult.csldate as csldate
                            , receipt.dayid as dayid_num
                            , '★ ' || to_char(receipt.dayid) as dayid
                            , '' as result
                            , '1. 生検待ち' as itemname
                            , '1' as seq
                            , '' as biko 
                        from
                            consult
                            , receipt
                            , rsl 
                        where
                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                            and consult.cancelflg = :cancelflg  
                            and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                            and consult.rsvno = receipt.rsvno 
                            and consult.rsvno = rsl.rsvno 
                            and rsl.itemcd in ('23240', '23250', '23260') 
                            and rsl.result = '2' 
                        group by
                            consult.csldate
                            , receipt.dayid 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , decode( 
                                lastview.after_date
                                , null
                                , to_char(lastview.dayid)
                                , decode( 
                                    sign((lastview.after_date - lastview.csldate) - 8)
                                    , - 1
                                    , '★ ' || to_char(lastview.dayid)
                                    , to_char(lastview.dayid)
                                )
                            ) as dayid
                            , '後日検査日：' || decode( 
                                lastview.after_date
                                , null
                                , '予約なし'
                                , to_char(lastview.after_date, 'YYYY/MM/DD')
                            ) as result
                            , '2. 後日ＧＦ' as itemname
                            , '2' as seq
                            , '' as biko 
                        from
                            ( 
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , ( 
                                        select
                                            min(cst.csldate) 
                                        from
                                            consult cst 
                                        where
                                            cst.csldate >= consult.csldate 
                                            and cst.perid = consult.perid 
                                            and cst.cscd = '130' 
                                            and cst.cancelflg = :cancelflg 
                                    ) as after_date 
                                from
                                    consult
                                    , receipt
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd = '23160'
                            ) lastview 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , decode( 
                                lastview.after_date
                                , null
                                , to_char(lastview.dayid)
                                , decode( 
                                    sign((lastview.after_date - lastview.csldate) - 8)
                                    , - 1
                                    , '★ ' || to_char(lastview.dayid)
                                    , to_char(lastview.dayid)
                                )
                            ) as dayid
                            , '後日検査日：' || decode( 
                                lastview.after_date
                                , null
                                , '予約なし'
                                , to_char(lastview.after_date, 'YYYY/MM/DD')
                            ) as result
                            , '3. オプションＣＦ' as itemname
                            , '3' as seq
                            , '' as biko 
                        from
                            ( 
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , ( 
                                        select
                                            min(cst.csldate) 
                                        from
                                            consult cst 
                                        where
                                            cst.csldate >= consult.csldate 
                                            and cst.perid = consult.perid 
                                            and cst.cscd = '120' 
                                            and cst.cancelflg = :cancelflg 
                                    ) as after_date 
                                from
                                    consult
                                    , receipt
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd = '23712'
                            ) lastview 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , decode( 
                                lastview.after_date
                                , null
                                , to_char(lastview.dayid)
                                , decode( 
                                    sign((lastview.after_date - lastview.csldate) - 8)
                                    , - 1
                                    , '★ ' || to_char(lastview.dayid)
                                    , to_char(lastview.dayid)
                                )
                            ) as dayid
                            , '後日検査日：' || decode( 
                                lastview.after_date
                                , null
                                , '予約なし'
                                , to_char(lastview.after_date, 'YYYY/MM/DD')
                            ) as result
                            , '4. オプション３Ｄ－ＣＴ' as itemname
                            , '4' as seq
                            , '' as biko 
                        from
                            ( 
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , ( 
                                        select
                                            min(cst.csldate) 
                                        from
                                            consult cst 
                                        where
                                            cst.csldate >= consult.csldate 
                                            and cst.perid = consult.perid 
                                            and cst.cscd = '125' 
                                            and cst.cancelflg = :cancelflg 
                                    ) as after_date 
                                from
                                    consult
                                    , receipt
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd = '23982'
                            ) lastview 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , decode( 
                                lastview.after_date
                                , null
                                , to_char(lastview.dayid)
                                , decode( 
                                    sign((lastview.after_date - lastview.csldate) - 8)
                                    , - 1
                                    , '★ ' || to_char(lastview.dayid)
                                    , to_char(lastview.dayid)
                                )
                            ) as dayid
                            , '後日検査日：' || decode( 
                                lastview.after_date
                                , null
                                , '予約なし'
                                , to_char(lastview.after_date, 'YYYY/MM/DD')
                            ) as result
                            , '5. 後日ＣＴ' as itemname
                            , '5' as seq
                            , '' as biko 
                        from
                            ( 
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , ( 
                                        select
                                            min(cst.csldate) 
                                        from
                                            consult cst 
                                        where
                                            cst.csldate >= consult.csldate 
                                            and cst.perid = consult.perid 
                                            and cst.cscd = '135' 
                                            and cst.cancelflg = :cancelflg 
                                    ) as after_date 
                                from
                                    consult
                                    , receipt
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd = '21460'
                            ) lastview 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , decode( 
                                lastview.result
                                , 'false'
                                , '★ ' || to_char(lastview.dayid)
                                , to_char(lastview.dayid)
                            ) as dayid
                            , decode( 
                                lastview.result
                                , 'false'
                                , '異常（後日か未登録か確認してください。病理検査結果：' || lastview.memo || '）'
                                , 'hains(' || lastview.result || ')' || ' 病理検査結果(' || lastview.memo || ')'
                            ) as result
                            , lastview.itemname as itemname
                            , lastview.seq as seq
                            , ( 
                                select
                                    max(cslpubnote.pubnote) 
                                from
                                    cslpubnote 
                                where
                                    cslpubnote.rsvno = lastview.rsvno 
                                    and cslpubnote.pubnotedivcd = '100' 
                                    and cslpubnote.pubnote like '%後日喀痰%'
                            ) as biko 
                        from
                            ( 
                                select
                                    csldate
                                    , dayid
                                    , rsvno
                                    , max(result) as result
                                    , max(itemname) as itemname
                                    , max(seq) as seq
                                    , max(biko) as biko
                                    , max(memo) as memo 
                                from
                                    ( 
                                        select
                                            csldate
                                            , dayid
                                            , rsvno
                                            , result
                                            , itemname
                                            , seq
                                            , max(biko) as biko
                                            , '' as memo 
                                        from
                                            ( 
                                                select
                                                    csldate
                                                    , dayid
                                                    , rsvno
                                                    , decode( 
                                                        sentence.shortstc
                                                        , null
                                                        , 'false'
                                                        , sentence.shortstc
                                                    ) as result
                                                    , '6. 喀痰実施予定者' as itemname
                                                    , '6' as seq
                                                    , pubnote as biko 
                                                from
                                                    ( 
                                                        select
                                                            consult.csldate as csldate
                                                            , receipt.dayid as dayid
                                                            , consult.rsvno as rsvno
                                                            , max(rsl.result) as result
                                                            , rsl.itemcd as itemcd
                                                            , item_c.itemtype as itemtype
                                                            , '' as pubnote 
                                                        from
                                                            consult
                                                            , receipt
                                                            , rsl
                                                            , item_c 
                                                        where
                                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                                            and consult.cancelflg = :cancelflg  
                                                            and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                                            and consult.rsvno = receipt.rsvno 
                                                            and receipt.comedate is not null 
                                                            and consult.rsvno = rsl.rsvno 
                                                            and rsl.itemcd = '21140' 
                                                            and rsl.itemcd = item_c.itemcd 
                                                            and rsl.suffix = item_c.suffix 
                                                        group by
                                                            consult.csldate
                                                            , receipt.dayid
                                                            , consult.rsvno
                                                            , rsl.itemcd
                                                            , item_c.itemtype
                                                    ) v_consult
                                                    left join sentence on 
                                                        v_consult.itemcd = sentence.itemcd
                                                    and v_consult.itemtype = sentence.itemtype
                                                    and v_consult.result = sentence.stccd
                                            ) 
                                        group by
                                            csldate
                                            , dayid
                                            , rsvno
                                            , result
                                            , itemname
                                            , seq 
                                        union 
                                        select
                                            consult.csldate as csldate
                                            , receipt.dayid as dayid
                                            , consult.rsvno as rsvno
                                            , '' as itemcd
                                            , '' as resultname
                                            , '' as seq
                                            , '' as biko
                                            , trim( 
                                                replace ( 
                                                    replace ( 
                                                        replace (rslmemostr, chr(13) || chr(10), '')
                                                        , chr(13)
                                                        , ''
                                                    ) 
                                                    , chr(10)
                                                    , ''
                                                )
                                            ) as memo 
                                        from
                                            consult
                                            , receipt
                                            , rsl
                                            , rslmemo 
                                        where
                                            consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                            and consult.cancelflg = :cancelflg  
                                            and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                            and consult.rsvno = receipt.rsvno 
                                            and consult.rsvno = rsl.rsvno 
                                            and rsl.itemcd = '46310' 
                                            and rsl.rsvno = rslmemo.rsvno 
                                            and rsl.itemcd = rslmemo.itemcd 
                                            and rsl.suffix = rslmemo.suffix
                                    ) 
                                group by
                                    csldate
                                    , dayid
                                    , rsvno
                            ) lastview 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , '★ ' || to_char(lastview.dayid) as dayid
                            , '異常（後日か未登録か確認してください。）' as result
                            , '7. 便結果（未登録）' as itemname
                            , '7' as seq
                            , ( 
                                select
                                    max(cslpubnote.pubnote) 
                                from
                                    cslpubnote 
                                where
                                    cslpubnote.rsvno = lastview.rsvno 
                                    and cslpubnote.pubnotedivcd = '100' 
                                    and cslpubnote.pubnote like '%後日便%'
                            ) as biko 
                        from
                            ( 
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , consult.rsvno as rsvno
                                    , decode( 
                                        rsl.result
                                        , null
                                        , decode( 
                                            rsl.rslcmtcd2
                                            , null
                                            , rsl.rslcmtcd1
                                            , rsl.rslcmtcd2
                                        ) 
                                        , rsl.result
                                    ) as result 
                                from
                                    consult
                                    , receipt
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and receipt.comedate is not null 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd in ('14322', '14325')
                            ) lastview 
                        where
                            lastview.result is null 
                        group by
                            lastview.csldate
                            , lastview.dayid
                            , lastview.rsvno 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , to_char(lastview.dayid) as dayid
                            , max(lastview.rslcrp) || max(lastview.rslrf) || '再検査（GA)チェック' as result
                            , '8. 血清再検査（GA)' as itemname
                            , '8' as seq
                            , '' as biko 
                        from
                            ( 
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , decode(rsl.itemcd, '16325', 'RF ', '') as rslrf
                                    , decode(rsl.itemcd, '16124', 'CRP ', '') as rslcrp 
                                from
                                    consult
                                    , receipt
                                    , rsl 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and receipt.comedate is not null 
                                    and consult.rsvno = rsl.rsvno 
                                    and rsl.itemcd in ('16124', '16325') 
                                    and rsl.suffix = '00' 
                                    and stopflg is null 
                                    and rsl.result is not null 
                                    and rslcmtcd1 = 'GA'
                            ) lastview 
                        group by
                            lastview.csldate
                            , lastview.dayid 
                        union 
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid_num
                            , to_char(lastview.dayid) as dayid
                            , lastview.result as result
                            , '総合コメントチェック' as itemname
                            , '9' as seq
                            , '' as biko 
                        from
                            ( 
                                select
                                    consult.csldate
                                    , receipt.dayid
                                    , ( 
                                        select
                                            decode(count(consult.rsvno), 0, '総合コメント無し', '') 
                                        from
                                            totaljudcmt 
                                        where
                                            totaljudcmt.rsvno = consult.rsvno 
                                            and totaljudcmt.dispmode = 1 
                                            and totaljudcmt.judcmtcd not in ( 
                                                select
                                                    freefield1 
                                                from
                                                    free 
                                                where
                                                    freecd like 'METACMT%'
                                            ) 
                                            and totaljudcmt.judcmtcd is not null
                                    ) as result 
                                from
                                    consult
                                    , receipt 
                                where
                                    consult.csldate between to_date(:startdate, 'YYYYMMDD') and to_date(:enddate, 'YYYYMMDD') 
                                    and consult.cancelflg = :cancelflg  
                                    and consult.cscd in (:para_cscd01, :para_cscd02, :para_cscd03, :para_cscd04) 
                                    and consult.rsvno = receipt.rsvno 
                                    and receipt.comedate is not null 
                                order by
                                    consult.csldate
                                    , receipt.dayid
                            ) lastview 
                        where
                            lastview.result is not null
                    ) v_checklist 
                order by
                    csldate
                    , seq
                    , dayid_num
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
        /// <param name="data">成績表CL：総合判定連絡票作成用データ</param>
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
            var itemnameListField = (CnListField)cnObjects["ITEMNAME"];
            var bikoListField = (CnListField)cnObjects["BIKO"];

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

                //チェック項目
                itemnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ITEMNAME);

                string linePos = Convert.ToString(currentLine + 1);
                //内容
                var resultTextField = (CnTextField)cnObjects["RESULT" + linePos];
                resultTextField.Text = Util.ConvertToString(detail.RESULT);

                //備考
                bikoListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BIKO);

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
