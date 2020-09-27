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
    /// 入金ジャーナル生成クラス
    /// </summary>
    public class PaymentJaCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002120";

        /// <summary>
        /// :paymentdate
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["paymentdate"], out DateTime wkDate))
            {
                messages.Add("計上日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 入金ジャーナルデータを読み込む
        /// </summary>
        /// <returns>入金ジャーナルデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , pp.pricetotal
                    , pp.credit
                    , pp.card
                    , pp.jdebit
                    , pp.happy_ticket
                    , pp.cheque
                    , pp.transfer
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , ( 
                        to_char(pp.dmddate, 'YYYYMMDD') || trim(to_char(pp.billseq, '00000')) || trim(to_char(pp.branchno, '0'))
                    ) as pnum 
                from
                    ( 
                        select
                            pp.paymentdate
                            , pp.paymentseq
                            , pp.registerno
                            , pp.upduser
                            , pp.pricetotal
                            , pp.credit
                            , pp.card
                            , pp.jdebit
                            , pp.happy_ticket
                            , pp.cheque
                            , pp.transfer
                            , pb.dmddate
                            , max(pb.billseq) as billseq
                            , pb.branchno
                            , pp.calcdate 
                        from
                            perpayment pp
                            , perbill pb 
                        where
                            pp.calcdate = :paymentdate 
                            and pp.registerno like :outputCls 
                            and pp.paymentdate = pb.paymentdate 
                            and pp.paymentseq = pb.paymentseq 
                        group by
                            pp.paymentdate
                            , pp.paymentseq
                            , pp.registerno
                            , pp.upduser
                            , pp.paymentdate
                            , pp.pricetotal
                            , pp.credit
                            , pp.card
                            , pp.jdebit
                            , pp.happy_ticket
                            , pp.cheque
                            , pp.transfer
                            , pb.dmddate
                            , pb.branchno
                            , pp.calcdate
                    ) pp 
                order by
                    pp.registerno
                    , pp.paymentdate
                 ";

            // パラメータセット
            string outputclsWork = queryParams["outputcls"];

            if (outputclsWork == "0")
            {
                outputclsWork = "";
            }

            var sqlParam = new
            {
                paymentdate = queryParams["paymentdate"],
                outputCls = outputclsWork + "%"

            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">入金ジャーナルデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var prtdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pagenoField = (CnDataField)cnObjects["PAGENO"];
            var pageno2Field = (CnDataField)cnObjects["PAGENO2"];
            var keijodateField = (CnDataField)cnObjects["KEIJODATE"];
            var registernoListField = (CnListField)cnObjects["REGISTERNO"];
            var upduserListField = (CnListField)cnObjects["UPDUSER"];
            var nyukindateListField = (CnListField)cnObjects["NYUKINDATE"];
            var dayidListField = (CnListField)cnObjects["DAYID"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var name_goukeiListField = (CnListField)cnObjects["NAME_GOUKEI"];
            var peridListField = (CnListField)cnObjects["PERID"];
            var pricetotalListField = (CnListField)cnObjects["PRICETOTAL"];
            var azukariListField = (CnListField)cnObjects["AZUKARI"];
            var oturiListField = (CnListField)cnObjects["OTURI"];
            var genkinListField = (CnListField)cnObjects["GENKIN"];
            var chequeListField = (CnListField)cnObjects["CHEQUE"];
            var cardListField = (CnListField)cnObjects["CARD"];
            var jdebitListField = (CnListField)cnObjects["JDEBIT"];
            var happy_ticketListField = (CnListField)cnObjects["HAPPY_TICKET"];
            var transferListField = (CnListField)cnObjects["TRANSFER"];
            var pnumListField = (CnListField)cnObjects["PNUM"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            int outCnt = 0;

            // ページ内の項目に値をセット
            DateTime dt;

            string newKey = "";
            string oldKey = "";

            short currentLine = 0;

            long priceTotal = 0;  //請求額
            long card = 0;  //カード
            long jdebit = 0;  //デビット
            long happy_ticket = 0;  //ハッピー買物券
            long cheque = 0;  //小切手
            long credit = 0;  //現金
            long transfer = 0;  //振込
            long azukari = 0;  //預かり
            long oturi = 0;  //お釣り
            long genkin = 0;  //現金

            long priceTotal2 = 0;  //請求額（合計）
            long card2 = 0;  //カード（合計）
            long jdebit2 = 0;  //デビット（合計）
            long happy_ticket2 = 0;  //ハッピー買物券（合計）
            long cheque2 = 0;  //小切手（合計）
            long credit2 = 0;  //現金（合計）
            long transfer2 = 0;  //振込（合計）
            long azukari2 = 0;  //預かり（合計）
            long oturi2 = 0;  //お釣り（合計）
            long genkin2 = 0;  //現金（合計）

            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                if (string.IsNullOrEmpty(newKey))
                {
                    newKey = Util.ConvertToString(detail.REGISTERNO);
                    oldKey = newKey;
                }

                //端末ID
                newKey = Util.ConvertToString(detail.REGISTERNO);

                // ページ内最大行に達した場合、改ページ
                if (currentLine == registernoListField.ListRows.Length  )
                {
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pagenoField.Text = string.Format("{0:D03}", pageNo);
                    pageno2Field.Text = pageNo.ToString();

                    // 計上日
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                    {
                        keijodateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //現在編集行のリセット
                    currentLine = 0;

                }

                //キーブレイクによる小計行出力処理
                if (newKey != oldKey)
                {
                    name_goukeiListField.ListCell(0, currentLine).Text = "端末計";
                    pricetotalListField.ListCell(0, currentLine).Text = priceTotal2.ToString("#,##0");

                    azukariListField.ListCell(0, currentLine).Text = azukari2.ToString("#,##0");
                    oturiListField.ListCell(0, currentLine).Text = oturi2.ToString("#,##0");
                    genkinListField.ListCell(0, currentLine).Text = genkin2.ToString("#,##0");
                    chequeListField.ListCell(0, currentLine).Text = cheque2.ToString("#,##0");
                    cardListField.ListCell(0, currentLine).Text = card2.ToString("#,##0");
                    jdebitListField.ListCell(0, currentLine).Text = jdebit2.ToString("#,##0");
                    happy_ticketListField.ListCell(0, currentLine).Text = happy_ticket2.ToString("#,##0");
                    transferListField.ListCell(0, currentLine).Text = transfer2.ToString("#,##0");

                    // ページをインクリメント
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pagenoField.Text = string.Format("{0:D03}", pageNo);
                    pageno2Field.Text = pageNo.ToString();

                    // 計上日
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                    {
                        keijodateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //現在編集行のリセット
                    currentLine = 0;

                    //キー設定
                    oldKey = newKey;

                    // 件数をインクリメント
                    outCnt++;

                    priceTotal2 = 0;
                    card2 = 0;
                    jdebit2 = 0;
                    happy_ticket2 = 0;
                    cheque2 = 0;
                    credit2 = 0;
                    transfer2 = 0;
                    azukari2 = 0;
                    oturi2 = 0;
                    genkin2 = 0;
                }

                //金額の格納
                priceTotal =  Convert.ToInt32(detail.PRICETOTAL);
                card = Convert.ToInt32(detail.CARD);
                jdebit = Convert.ToInt32(detail.JDEBIT);
                happy_ticket = Convert.ToInt32(detail.HAPPY_TICKET);
                cheque = Convert.ToInt32(detail.CHEQUE);
                credit = Convert.ToInt32(detail.CREDIT);
                transfer = Convert.ToInt32(detail.TRANSFER);

                azukari = card + jdebit + happy_ticket + cheque + credit + transfer;
                oturi = card + jdebit + happy_ticket + cheque + credit + transfer - priceTotal;
                genkin = credit - (card + jdebit + happy_ticket + cheque + credit + transfer - priceTotal);
                priceTotal2 = priceTotal2 + priceTotal;
                card2 = card2 + card;
                jdebit2 = jdebit2 + jdebit;
                happy_ticket2 = happy_ticket2 + happy_ticket;
                cheque2 = cheque2 + cheque;
                credit2 = credit2 + credit;
                transfer2 = transfer2 + transfer;
                azukari2 = azukari2 + azukari;
                oturi2 = oturi2 + oturi;
                genkin2 = genkin2 + genkin;

                //端末名
                registernoListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.REGISTERNO);

                //オペレータID
                upduserListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.UPDUSER);

                //入金日
                nyukindateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PAYMENTDATE);

                //当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetDayId(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetPerName(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //患者ID
                peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetPerId(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //請求額
                pricetotalListField.ListCell(0, currentLine).Text = priceTotal.ToString("#,##0");

                //預かり
                azukariListField.ListCell(0, currentLine).Text = azukari.ToString("#,##0");

                //お釣り
                oturiListField.ListCell(0, currentLine).Text = oturi.ToString("#,##0");

                //現金
                genkinListField.ListCell(0, currentLine).Text = genkin.ToString("#,##0");

                //小切手
                chequeListField.ListCell(0, currentLine).Text = cheque.ToString("#,##0");

                //カード
                cardListField.ListCell(0, currentLine).Text = card.ToString("#,##0");

                //デビット
                jdebitListField.ListCell(0, currentLine).Text = jdebit.ToString("#,##0");

                //ハッピー買物券
                happy_ticketListField.ListCell(0, currentLine).Text = happy_ticket.ToString("#,##0");

                //振込
                transferListField.ListCell(0, currentLine).Text = transfer.ToString("#,##0");

                //伝票No.
                pnumListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PNUM);

                //現在行をインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

            }

            //終了処理
            if (currentLine > 0)
            {
                //改ページ処理
                // ページ内最大行に達した場合、改ページ
                if (currentLine == registernoListField.ListRows.Length )
                {
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pagenoField.Text = string.Format("{0:D03}", pageNo);
                    pageno2Field.Text = pageNo.ToString();

                    // 計上日
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                    {
                        keijodateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //現在編集行のリセット
                    currentLine = 0;

                }

                pageNo++;

                // 印刷日
                prtdateField.Text = sysdate;

                // ページ番号
                pagenoField.Text = string.Format("{0:D03}", pageNo);
                pageno2Field.Text = pageNo.ToString();

                // 計上日
                if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                {
                    keijodateField.Text = dt.ToString("yyyy/MM/dd");
                }

                name_goukeiListField.ListCell(0, currentLine).Text = "端末計";
                pricetotalListField.ListCell(0, currentLine).Text = priceTotal2.ToString("#,##0");

                azukariListField.ListCell(0, currentLine).Text = azukari2.ToString("#,##0");
                oturiListField.ListCell(0, currentLine).Text = oturi2.ToString("#,##0");
                genkinListField.ListCell(0, currentLine).Text = genkin2.ToString("#,##0");
                chequeListField.ListCell(0, currentLine).Text = cheque2.ToString("#,##0");
                cardListField.ListCell(0, currentLine).Text = card2.ToString("#,##0");
                jdebitListField.ListCell(0, currentLine).Text = jdebit2.ToString("#,##0");
                happy_ticketListField.ListCell(0, currentLine).Text = happy_ticket2.ToString("#,##0");
                transferListField.ListCell(0, currentLine).Text = transfer2.ToString("#,##0");

                //現在行をインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

                // ドキュメントの出力
                PrintOut(cnForm);
                //現在行をインクリメント
                currentLine=0;

            }

        }

        /// <summary>
        /// 当日ID取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetDayId(string dmdDate, string billSeq, string branchNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    c.dayid 
                from
                    consult a
                    , person b
                    , receipt c
                    , org d
                    , perbill_csl pc 
                where
                    pc.dmddate = to_date(:dmddate) 
                    and pc.billseq = :billseq
                    and pc.branchno = :branchno
                    and a.rsvno = pc.rsvno 
                    and a.cancelflg = :cancelflg  
                    and a.perid = b.perid 
                    and a.rsvno = c.rsvno 
                    and a.csldate = c.csldate 
                    and a.orgcd1 = d.orgcd1 
                    and a.orgcd2 = d.orgcd2 
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = dmdDate,
                billseq = billSeq,
                branchno = branchNo,
                cancelflg = ConsultCancel.Used

            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.DAYID));
        }

        /// <summary>
        /// 氏名取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetPerName(string dmdDate, string billSeq, string branchNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    b.lastname || ' ' || b.firstname as name 
                from
                    consult a
                    , person b
                    , receipt c
                    , org d
                    , perbill_csl pc 
                where
                    pc.dmddate = to_date(:dmddate) 
                    and pc.billseq = :billseq
                    and pc.branchno = :branchno
                    and a.rsvno = pc.rsvno 
                    and a.cancelflg = :cancelflg 
                    and a.perid = b.perid 
                    and a.rsvno = c.rsvno 
                    and a.csldate = c.csldate 
                    and a.orgcd1 = d.orgcd1 
                    and a.orgcd2 = d.orgcd2 
                    and rownum = 1 
                union 
                select
                    b.lastname || ' ' || b.firstname as name 
                from
                    consult a
                    , person b
                    , org d
                    , perbill_person pc 
                where
                    pc.dmddate = to_date(:dmddate) 
                    and pc.billseq = :billseq
                    and pc.branchno = :branchno
                    and a.perid = pc.perid 
                    and a.cancelflg = :cancelflg  
                    and pc.perid = b.perid 
                    and a.orgcd1 = d.orgcd1 
                    and a.orgcd2 = d.orgcd2 
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = dmdDate,
                billseq = billSeq,
                branchno = branchNo,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.NAME));
        }

        /// <summary>
        /// 患者ID取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetPerId(string dmdDate, string billSeq, string branchNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    b.perid as perid 
                from
                    consult a
                    , person b
                    , perbill_csl pc 
                where
                    pc.dmddate = to_date(:dmddate) 
                    and pc.billseq = :billseq
                    and pc.branchno = :branchno
                    and a.rsvno = pc.rsvno 
                    and a.cancelflg = :cancelflg  
                    and a.perid = b.perid 
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = dmdDate,
                billseq = billSeq,
                branchno = branchNo,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.PERID));
        }

    }
}
