using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 領収書生成クラス
    /// </summary>
    public class ReceiptCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002420";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            return messages;
        }

        /// <summary>
        /// 対象データ取得（領収証）
        /// </summary>
        /// <returns>領収証データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                ( 
                    select
                        pb.printdate as printdate
                        , '領収書' as title
                        , to_char(pb.dmddate, 'YYYYMMDD') || '-' || pb.billseq || '-' || pb.branchno as dennhyou_no
                        , pp.perid as perid
                        , nvl(pb.billname, (pe.lastname || pe.firstname)) || ' ' || decode(pb.keishou, null, '様', pb.keishou)
                         as name
                        , to_char(pb.dmddate, 'YYYY/MM/DD') as csldate
                        , '' as dayid
                        , decode( 
                            pb.paymentdate
                            , null
                            , to_char(sysdate, 'YYYY/MM/DD')
                            , to_char(pb.paymentdate, 'YYYY/MM/DD')
                        ) as makeday
                        , hu.userid as userid 
                    from
                        perbill pb
                        , perbill_person pp
                        , person pe
                        , perpayment pay
                        , hainsuser hu 
                    where
                        pb.dmddate = :dmddate
                        and pb.billseq = :billseq
                        and pb.branchno = :branchno
                        and pp.dmddate = pb.dmddate 
                        and pp.billseq = pb.billseq 
                        and pp.branchno = pb.branchno 
                        and pp.perid = pe.perid 
                        and pb.paymentdate = pay.paymentdate 
                        and pb.paymentseq = pay.paymentseq 
                        and pay.upduser = hu.userid 
                        and rownum = 1
                ) 
                union ( 
                    select
                        pb.printdate as printdate
                        , '領収書' as title
                        , to_char(pb.dmddate, 'YYYYMMDD') || '-' || pb.billseq || '-' || pb.branchno as dennhyou_no
                        , con.perid as perid
                        , nvl(pb.billname, (pe.lastname || pe.firstname)) || ' ' || decode(pb.keishou, null, '様', pb.keishou)
                         as name
                        , to_char(rc.csldate, 'YYYY/MM/DD') as csldate
                        , decode(rc.dayid, 2, '', rc.dayid) as dayid
                        , decode( 
                            pb.paymentdate
                            , null
                            , to_char(sysdate, 'YYYY/MM/DD')
                            , to_char(pb.paymentdate, 'YYYY/MM/DD')
                        ) as makeday
                        , hu.userid as userid 
                    from
                        perbill pb
                        , consult con
                        , person pe
                        , receipt rc
                        , perpayment pay
                        , hainsuser hu
                        , ( 
                            select distinct
                                cm.rsvno as rsvno 
                            from
                                perbill_csl cm 
                            where
                                cm.dmddate = :dmddate
                                and cm.billseq = :billseq
                                and cm.branchno = :branchno
                        ) cm 
                    where
                        pb.dmddate = :dmddate 
                        and pb.billseq = :billseq
                        and pb.branchno = :branchno
                        and rc.rsvno = cm.rsvno 
                        and rc.rsvno = con.rsvno 
                        and con.perid = pe.perid 
                        and pb.paymentdate = pay.paymentdate 
                        and pb.paymentseq = pay.paymentseq 
                        and pay.upduser = hu.userid 
                        and rownum = 1
                ) 
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = queryParams["dmddate"],
                billseq = queryParams["billseq"],
                branchno = queryParams["branchno"]
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">領収証データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var titleField = (CnDataField)cnObjects["TITLE"];
            var dennhyou_noField = (CnDataField)cnObjects["DENNHYOU_NO"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var nameField = (CnDataField)cnObjects["NAME"];
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var dayidField = (CnDataField)cnObjects["DAYID"];
            var naiyouListField = (CnListField)cnObjects["NAIYOU"];
            var ryokinnListField = (CnListField)cnObjects["RYOKINN"];
            var zeikinnListField = (CnListField)cnObjects["ZEIKINN"];
            var shyoukeiListField = (CnListField)cnObjects["SHYOUKEI"];
            var goukeiField = (CnDataField)cnObjects["GOUKEI"];
            var makedayField = (CnDataField)cnObjects["MAKEDAY"];
            var useridField = (CnDataField)cnObjects["USERID"];
            var stamplabelText = (CnText)cnObjects["STAMPLABEL"];
            var stampcircleListField = (CnCircle)cnObjects["STAMPCIRCLE"];
            var stampline1ListField = (CnLine)cnObjects["STAMPLINE1"];
            var stampline2ListField = (CnLine)cnObjects["STAMPLINE2"];

            string title = "";
            string dennhyouNo = "";
            string perId = "";
            string name = "";
            string cslDate = "";
            string dayId = "";
            string makeDay = "";
            string userId = "";

            long goukei = 0;
            short currentLine = 0;

            string newKey;
            string oldKey = Util.ConvertToString(data[0].PERID);


            // ページ内の項目に値をセット
            foreach (var header in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                newKey = Util.ConvertToString(header.PERID);

                // 受診者ごとに改ページ
                if (newKey != oldKey)
                {
                    // ヘッダー、フッターの編集
                    titleField.Text = title;
                    dennhyou_noField.Text = dennhyouNo;
                    peridField.Text = perId;
                    nameField.Text = name;
                    csldateField.Text = cslDate;
                    dayidField.Text = dayId;
                    makedayField.Text = makeDay;
                    useridField.Text = userId;
                    goukeiField.Text = string.Format("\\ {0:#,0}", goukei);
                    stamplabelText.Visible = true;
                    stampcircleListField.Visible = true;
                    stampline1ListField.Visible = true;
                    stampline2ListField.Visible = true;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 合計のリセット
                    goukei = 0;

                    // 現在編集行のリセット
                    currentLine = 0;

                    // キーブレイクによる改ページ処理
                    oldKey = newKey;
                }

                // 帳票タイトル
                title = Util.ConvertToString(header.TITLE);
                // 伝票番号
                dennhyouNo = Util.ConvertToString(header.DENNHYOU_NO);
                // 登録番号
                perId = Util.ConvertToString(header.PERID);
                // 氏名
                name = Util.ConvertToString(header.NAME);
                // 受診日
                cslDate = Util.ConvertToString(header.CSLDATE);
                // 当日ID
                dayId = Util.ConvertToString(header.DAYID);
                // 入金日
                makeDay = Util.ConvertToString(header.MAKEDAY);
                // ユーザID
                userId = Util.ConvertToString(header.USERID);

                // 領収印は最初は非表示
                stamplabelText.Visible = false;
                stampcircleListField.Visible = false;
                stampline1ListField.Visible = false;
                stampline2ListField.Visible = false;

                // 明細行データ取得
                foreach (var detail in GetDmdDetail(queryParams["dmddate"], queryParams["billseq"], queryParams["branchno"]))
                {
                    // 改ページ処理
                    if (currentLine >= naiyouListField.ListRows.Length)
                    {
                        // ヘッダーの編集
                        titleField.Text = title;
                        dennhyou_noField.Text = dennhyouNo;
                        peridField.Text = perId;
                        nameField.Text = name;
                        csldateField.Text = cslDate;
                        dayidField.Text = dayId;

                        // ドキュメントの出力
                        PrintOut(cnForm);

                        // 現在編集行のリセット
                        currentLine = 0;
                    }

                    naiyouListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAIYOU);
                    ryokinnListField.ListCell(0, currentLine).Text = string.Format("\\ {0:#,0}", detail.RYOKINN);
                    zeikinnListField.ListCell(0, currentLine).Text = string.Format("\\ {0:#,0}", detail.ZEIKINN);
                    shyoukeiListField.ListCell(0, currentLine).Text = string.Format("\\ {0:#,0}", detail.SHYOUKEI);
                    goukei += detail.SHYOUKEI;

                    currentLine += 1;
                }
            }

            // 終了処理
            if (currentLine > 0 )
            {
                // ヘッダー、フッターの編集
                titleField.Text = title;
                dennhyou_noField.Text = dennhyouNo;
                peridField.Text = perId;
                nameField.Text = name;
                csldateField.Text = cslDate;
                dayidField.Text = dayId;
                makedayField.Text = makeDay;
                useridField.Text = userId;
                goukeiField.Text = string.Format("\\ {0:#,0}", goukei);
                stamplabelText.Visible = true;
                stampcircleListField.Visible = true;
                stampline1ListField.Visible = true;
                stampline2ListField.Visible = true;

                // ドキュメントの出力
                PrintOut(cnForm);

                // 現在編集行のリセット
                currentLine = 0;
            }

        }

        /// <summary>
        /// 明細行データを取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Seq</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetDmdDetail(string dmdDate,string billSeq,string branchNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    max(billlineno) as lineno
                    , linename as naiyou
                    , sum(price + editprice) as ryokinn
                    , sum(taxprice + edittax) as zeikinn
                    , sum(price + editprice + taxprice + edittax) as shyoukei 
                from
                    perbill_c 
                where
                    dmddate = :dmddate
                    and billseq = :billseq
                    and branchno = :branchno
                group by
                    linename 
                order by
                    1
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = dmdDate,
                billseq = billSeq,
                branchno = branchNo
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }
    }
}
