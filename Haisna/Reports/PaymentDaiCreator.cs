using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 入金台帳生成クラス
    /// </summary>
    public class PaymentDaiCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002130";

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
        /// 入金台帳データを読み込む
        /// </summary>
        /// <returns>入金台帳データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , 1 as sort_kubun
                    , '現金' as pay_kubun
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , ( 
                        pp.pricetotal - ( 
                            pp.happy_ticket + pp.card + pp.jdebit + pp.cheque + pp.transfer
                        )
                    ) as pay_value
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
                            and pp.credit <> 0 
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
                union 
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , 2 as sort_kubun
                    , 'カード' as pay_kubun
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , nvl(pp.card, 0) as pay_value
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
                            and pp.card <> 0 
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
                union 
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , 3 as sort_kubun
                    , 'jデビット' as pay_kubun
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , nvl(pp.jdebit, 0) as pay_value
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
                            and pp.jdebit <> 0 
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
                union 
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , 4 as sort_kubun
                    , 'ハッピー買物券' as pay_kubun
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , nvl(pp.happy_ticket, 0) as pay_value
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
                            and pp.happy_ticket <> 0 
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
                union 
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , 5 as sort_kubun
                    , '小切手' as pay_kubun
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , nvl(pp.cheque, 0) as pay_value
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
                            and pp.cheque <> 0 
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
                union 
                select
                    pp.registerno
                    , pp.upduser
                    , pp.paymentdate
                    , pp.calcdate
                    , 6 as sort_kubun
                    , '振込み' as pay_kubun
                    , nvl(to_char(pp.dmddate, 'YYYYMMDD'), '00000000') as dmddate
                    , nvl(pp.billseq, 0) as billseq
                    , nvl(pp.branchno, 0) as branchno
                    , nvl(pp.transfer, 0) as pay_value
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
                            and pp.transfer <> 0 
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
                    sort_kubun
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
        /// <param name="data">入金台帳データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var prtdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pagenoField = (CnDataField)cnObjects["PAGENO"];
            var keijodateField = (CnDataField)cnObjects["KEIJODATE"];
            var registernoListField = (CnListField)cnObjects["REGISTERNO"];
            var upduserListField = (CnListField)cnObjects["UPDUSER"];
            var nyukindateListField = (CnListField)cnObjects["NYUKINDATE"];
            var csldateListField = (CnListField)cnObjects["CSLDATE"];
            var dayidListField = (CnListField)cnObjects["DAYID"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var peridListField = (CnListField)cnObjects["PERID"];
            var orgsnameListField = (CnListField)cnObjects["ORGSNAME"];
            var pay_kubunListField = (CnListField)cnObjects["PAY_KUBUN"];
            var pay_kubun1ListField = (CnListField)cnObjects["PAY_KUBUN_1"];
            var pay_kubun2ListField = (CnListField)cnObjects["PAY_KUBUN_2"];
            var pay_valueListField = (CnListField)cnObjects["PAY_VALUE"];
            var pnumListField = (CnListField)cnObjects["PNUM"];

            var box01Box = (CnBox)cnObjects["Box01"];
            var box02Box = (CnBox)cnObjects["Box02"];
            var box03Box = (CnBox)cnObjects["Box03"];
            var box04Box = (CnBox)cnObjects["Box04"];
            var box05Box = (CnBox)cnObjects["Box05"];
            var box06Box = (CnBox)cnObjects["Box06"];
            var box07Box = (CnBox)cnObjects["Box07"];
            var box08Box = (CnBox)cnObjects["Box08"];
            var box09Box = (CnBox)cnObjects["Box09"];
            var box10Box = (CnBox)cnObjects["Box10"];
            var box11Box = (CnBox)cnObjects["Box11"];
            var box12Box = (CnBox)cnObjects["Box12"];
            var box13Box = (CnBox)cnObjects["Box13"];
            var box14Box = (CnBox)cnObjects["Box14"];
            var box15Box = (CnBox)cnObjects["Box15"];
            var box16Box = (CnBox)cnObjects["Box16"];
            var box17Box = (CnBox)cnObjects["Box17"];
            var box18Box = (CnBox)cnObjects["Box18"];
            var box19Box = (CnBox)cnObjects["Box19"];
            var box20Box = (CnBox)cnObjects["Box20"];
            var box21Box = (CnBox)cnObjects["Box21"];
            var box22Box = (CnBox)cnObjects["Box22"];
            var box23Box = (CnBox)cnObjects["Box23"];
            var box24Box = (CnBox)cnObjects["Box24"];
            var box25Box = (CnBox)cnObjects["Box25"];
            var box26Box = (CnBox)cnObjects["Box26"];
            var box27Box = (CnBox)cnObjects["Box27"];
            var box28Box = (CnBox)cnObjects["Box28"];
            var box29Box = (CnBox)cnObjects["Box29"];
            var box30Box = (CnBox)cnObjects["Box30"];
            var box31Box = (CnBox)cnObjects["Box31"];
            var box32Box = (CnBox)cnObjects["Box32"];
            var box33Box = (CnBox)cnObjects["Box33"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            int outCnt = 0;

            // ページ内の項目に値をセット
            DateTime dt;

            string newKey = "";
            string oldKey = "";

            short currentLine = 0;

            long shiharaiGaku1 = 0;  //支払額小計
            long shiharaiGaku2 = 0;  //支払額合計

            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                if (string.IsNullOrEmpty(newKey))
                {
                    newKey = Util.ConvertToString(detail.SORT_KUBUN);
                    oldKey = newKey;
                }

                //端末ID
                newKey = Util.ConvertToString(detail.SORT_KUBUN);

                // ページ内最大行に達した場合、改ページ
                if (currentLine == registernoListField.ListRows.Length  )
                {
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pagenoField.Text = string.Format("{0:D03}", pageNo);

                    // 計上日
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                    {
                        keijodateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //フィールドのクリア
                    box01Box.Visible = false;
                    box01Box.Visible = false;
                    box02Box.Visible = false;
                    box03Box.Visible = false;
                    box04Box.Visible = false;
                    box05Box.Visible = false;
                    box06Box.Visible = false;
                    box07Box.Visible = false;
                    box08Box.Visible = false;
                    box09Box.Visible = false;
                    box10Box.Visible = false;
                    box11Box.Visible = false;
                    box12Box.Visible = false;
                    box13Box.Visible = false;
                    box14Box.Visible = false;
                    box15Box.Visible = false;
                    box16Box.Visible = false;
                    box17Box.Visible = false;
                    box18Box.Visible = false;
                    box19Box.Visible = false;
                    box20Box.Visible = false;
                    box21Box.Visible = false;
                    box22Box.Visible = false;
                    box23Box.Visible = false;
                    box24Box.Visible = false;
                    box25Box.Visible = false;
                    box26Box.Visible = false;
                    box27Box.Visible = false;
                    box28Box.Visible = false;
                    box29Box.Visible = false;
                    box30Box.Visible = false;
                    box31Box.Visible = false;
                    box32Box.Visible = false;
                    box33Box.Visible = false;

                    //現在編集行のリセット
                    currentLine = 0;

                }

                //キーブレイクによる小計行出力処理
                if (newKey != oldKey)
                {
                    pay_kubun1ListField.ListCell(0, currentLine).Text = "小計";
                    pay_valueListField.ListCell(0, currentLine).Text = shiharaiGaku1.ToString("#,##0");

                    switch( currentLine)
                    {
                        case 1:
                            box01Box.Visible = true;
                            break;
                        case 2:
                            box01Box.Visible = true;
                            break;
                        case 3:
                            box03Box.Visible = true;
                            break;
                        case 4:
                            box04Box.Visible = true;
                            break;
                        case 5:
                            box05Box.Visible = true;
                            break;
                        case 6:
                            box06Box.Visible = true;
                            break;
                        case 7:
                            box07Box.Visible = true;
                            break;
                        case 8:
                            box08Box.Visible = true;
                            break;
                        case 9:
                            box09Box.Visible = true;
                            break;
                        case 10:
                            box10Box.Visible = true;
                            break;
                        case 11:
                            box11Box.Visible = true;
                            break;
                        case 12:
                            box12Box.Visible = true;
                            break;
                        case 13:
                            box13Box.Visible = true;
                            break;
                        case 14:
                            box14Box.Visible = true;
                            break;
                        case 15:
                            box15Box.Visible = true;
                            break;
                        case 16:
                            box16Box.Visible = true;
                            break;
                        case 17:
                            box17Box.Visible = true;
                            break;
                        case 18:
                            box18Box.Visible = true;
                            break;
                        case 19:
                            box19Box.Visible = true;
                            break;
                        case 20:
                            box20Box.Visible = true;
                            break;
                        case 21:
                            box21Box.Visible = true;
                            break;
                        case 22:
                            box22Box.Visible = true;
                            break;
                        case 23:
                            box23Box.Visible = true;
                            break;
                        case 24:
                            box24Box.Visible = true;
                            break;
                        case 25:
                            box25Box.Visible = true;
                            break;
                        case 26:
                            box26Box.Visible = true;
                            break;
                        case 27:
                            box27Box.Visible = true;
                            break;
                        case 28:
                            box28Box.Visible = true;
                            break;
                        case 29:
                            box29Box.Visible = true;
                            break;
                        case 30:
                            box30Box.Visible = true;
                            break;
                        case 31:
                            box31Box.Visible = true;
                            break;
                        case 32:
                            box32Box.Visible = true;
                            break;
                    }

                    //小計クリア
                    shiharaiGaku1 = 0;

                    //キー設定
                    oldKey = newKey;

                    //現在行をインクリメント
                    currentLine++;

                    // 件数をインクリメント
                    outCnt++;

                    //改ページ処理
                    if (currentLine == registernoListField.ListRows.Length )
                    {
                        pageNo++;

                        // 印刷日
                        prtdateField.Text = sysdate;

                        // ページ番号
                        pagenoField.Text = string.Format("{0:D03}", pageNo);

                        // 計上日
                        if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                        {
                            keijodateField.Text = dt.ToString("yyyy/MM/dd");
                        }

                        // ドキュメントの出力
                        PrintOut(cnForm);

                        //フィールドのクリア
                        box01Box.Visible = false;
                        box01Box.Visible = false;
                        box02Box.Visible = false;
                        box03Box.Visible = false;
                        box04Box.Visible = false;
                        box05Box.Visible = false;
                        box06Box.Visible = false;
                        box07Box.Visible = false;
                        box08Box.Visible = false;
                        box09Box.Visible = false;
                        box10Box.Visible = false;
                        box11Box.Visible = false;
                        box12Box.Visible = false;
                        box13Box.Visible = false;
                        box14Box.Visible = false;
                        box15Box.Visible = false;
                        box16Box.Visible = false;
                        box17Box.Visible = false;
                        box18Box.Visible = false;
                        box19Box.Visible = false;
                        box20Box.Visible = false;
                        box21Box.Visible = false;
                        box22Box.Visible = false;
                        box23Box.Visible = false;
                        box24Box.Visible = false;
                        box25Box.Visible = false;
                        box26Box.Visible = false;
                        box27Box.Visible = false;
                        box28Box.Visible = false;
                        box29Box.Visible = false;
                        box30Box.Visible = false;
                        box31Box.Visible = false;
                        box32Box.Visible = false;
                        box33Box.Visible = false;

                        //現在編集行のリセット
                        currentLine = 0;

                    }


                }

                //金額の格納
                shiharaiGaku1 = shiharaiGaku1 + Convert.ToInt32(detail.PAY_VALUE);
                shiharaiGaku2 = shiharaiGaku2 + Convert.ToInt32(detail.PAY_VALUE);

                //端末名
                registernoListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.REGISTERNO);

                //オペレータID
                upduserListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.UPDUSER);

                //入金日
                nyukindateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PAYMENTDATE);

                //受診日
                csldateListField.ListCell(0, currentLine).Text = Util.ConvertToString( GetCsldate(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetDayId(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetPerName(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //患者ID
                peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetPerId(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //団体名
                orgsnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(GetOrgName(Util.ConvertToString(detail.DMDDATE), Util.ConvertToString(detail.BILLSEQ), Util.ConvertToString(detail.BRANCHNO)));

                //支払方法
                pay_kubunListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PAY_KUBUN);

                //支払額
                decimal.TryParse(Util.ConvertToString(detail.PAY_VALUE), out decimal wkPayValue);
                pay_valueListField.ListCell(0, currentLine).Text = wkPayValue.ToString("#,##0");

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

                    // 計上日
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                    {
                        keijodateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //フィールドのクリア
                    box01Box.Visible = false;
                    box01Box.Visible = false;
                    box02Box.Visible = false;
                    box03Box.Visible = false;
                    box04Box.Visible = false;
                    box05Box.Visible = false;
                    box06Box.Visible = false;
                    box07Box.Visible = false;
                    box08Box.Visible = false;
                    box09Box.Visible = false;
                    box10Box.Visible = false;
                    box11Box.Visible = false;
                    box12Box.Visible = false;
                    box13Box.Visible = false;
                    box14Box.Visible = false;
                    box15Box.Visible = false;
                    box16Box.Visible = false;
                    box17Box.Visible = false;
                    box18Box.Visible = false;
                    box19Box.Visible = false;
                    box20Box.Visible = false;
                    box21Box.Visible = false;
                    box22Box.Visible = false;
                    box23Box.Visible = false;
                    box24Box.Visible = false;
                    box25Box.Visible = false;
                    box26Box.Visible = false;
                    box27Box.Visible = false;
                    box28Box.Visible = false;
                    box29Box.Visible = false;
                    box30Box.Visible = false;
                    box31Box.Visible = false;
                    box32Box.Visible = false;
                    box33Box.Visible = false;

                    //現在編集行のリセット
                    currentLine = 0;

                }

                //小計出力
                pay_kubun1ListField.ListCell(0, currentLine).Text = "小計";
                pay_valueListField.ListCell(0, currentLine).Text = shiharaiGaku1.ToString("#,##0");

                switch (currentLine)
                {
                    case 0:
                        box01Box.Visible = true;
                        break;
                    case 1:
                        box02Box.Visible = true;
                        break;
                    case 2:
                        box03Box.Visible = true;
                        break;
                    case 3:
                        box04Box.Visible = true;
                        break;
                    case 4:
                        box05Box.Visible = true;
                        break;
                    case 5:
                        box06Box.Visible = true;
                        break;
                    case 6:
                        box07Box.Visible = true;
                        break;
                    case 7:
                        box08Box.Visible = true;
                        break;
                    case 8:
                        box09Box.Visible = true;
                        break;
                    case 9:
                        box10Box.Visible = true;
                        break;
                    case 10:
                        box11Box.Visible = true;
                        break;
                    case 11:
                        box12Box.Visible = true;
                        break;
                    case 12:
                        box13Box.Visible = true;
                        break;
                    case 13:
                        box14Box.Visible = true;
                        break;
                    case 14:
                        box15Box.Visible = true;
                        break;
                    case 15:
                        box16Box.Visible = true;
                        break;
                    case 16:
                        box17Box.Visible = true;
                        break;
                    case 17:
                        box18Box.Visible = true;
                        break;
                    case 18:
                        box19Box.Visible = true;
                        break;
                    case 19:
                        box20Box.Visible = true;
                        break;
                    case 20:
                        box21Box.Visible = true;
                        break;
                    case 21:
                        box22Box.Visible = true;
                        break;
                    case 22:
                        box23Box.Visible = true;
                        break;
                    case 23:
                        box24Box.Visible = true;
                        break;
                    case 24:
                        box25Box.Visible = true;
                        break;
                    case 25:
                        box26Box.Visible = true;
                        break;
                    case 26:
                        box27Box.Visible = true;
                        break;
                    case 27:
                        box28Box.Visible = true;
                        break;
                    case 28:
                        box29Box.Visible = true;
                        break;
                    case 29:
                        box30Box.Visible = true;
                        break;
                    case 30:
                        box31Box.Visible = true;
                        break;
                    case 31:
                        box32Box.Visible = true;
                        break;
                    case 32:
                        box33Box.Visible = true;
                        break;
                }

                //小計クリア
                shiharaiGaku1 = 0;

                //キー設定
                oldKey = newKey;

                //現在行をインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

                //改ページ処理
                if (currentLine == registernoListField.ListRows.Length )
                {
                    pageNo++;

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // ページ番号
                    pagenoField.Text = string.Format("{0:D03}", pageNo);

                    // 計上日
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                    {
                        keijodateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //フィールドのクリア
                    box01Box.Visible = false;
                    box01Box.Visible = false;
                    box02Box.Visible = false;
                    box03Box.Visible = false;
                    box04Box.Visible = false;
                    box05Box.Visible = false;
                    box06Box.Visible = false;
                    box07Box.Visible = false;
                    box08Box.Visible = false;
                    box09Box.Visible = false;
                    box10Box.Visible = false;
                    box11Box.Visible = false;
                    box12Box.Visible = false;
                    box13Box.Visible = false;
                    box14Box.Visible = false;
                    box15Box.Visible = false;
                    box16Box.Visible = false;
                    box17Box.Visible = false;
                    box18Box.Visible = false;
                    box19Box.Visible = false;
                    box20Box.Visible = false;
                    box21Box.Visible = false;
                    box22Box.Visible = false;
                    box23Box.Visible = false;
                    box24Box.Visible = false;
                    box25Box.Visible = false;
                    box26Box.Visible = false;
                    box27Box.Visible = false;
                    box28Box.Visible = false;
                    box29Box.Visible = false;
                    box30Box.Visible = false;
                    box31Box.Visible = false;
                    box32Box.Visible = false;
                    box33Box.Visible = false;

                    //現在編集行のリセット
                    currentLine = 0;

                }

                pageNo++;

                // 印刷日
                prtdateField.Text = sysdate;

                // ページ番号
                pagenoField.Text = string.Format("{0:D03}", pageNo);

                // 計上日
                if (DateTime.TryParse(Util.ConvertToString(queryParams["paymentdate"]), out dt))
                {
                    keijodateField.Text = dt.ToString("yyyy/MM/dd");
                }

                //合計出力
                pay_kubun2ListField.ListCell(0, currentLine).Text = "合計";
                pay_valueListField.ListCell(0, currentLine).Text = shiharaiGaku2.ToString("#,##0");

                //現在行をインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

                // ドキュメントの出力
                PrintOut(cnForm);

            }

        }

        /// <summary>
        /// 受診日取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetCsldate(string dmdDate , string billSeq, string branchNo )
        {
            // SQLステートメント定義
            string sql = @"
                select
                    nvl(to_char(a.csldate, 'YYYYMMDD'), '00000000') as csldate 
                from
                    consult a
                    , perbill_csl pc 
                where
                    pc.dmddate = to_date(:dmddate) 
                    and pc.billseq = :billseq
                    and pc.branchno = :branchno
                    and a.rsvno = pc.rsvno 
                    and a.cancelflg = 0 
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                  dmddate = dmdDate
                , billseq = billSeq
                , branchno = branchNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.CSLDATE));
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
                    and a.cancelflg = 0 
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
                dmddate = dmdDate
              , billseq = billSeq
              , branchno = branchNo
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
                    and a.cancelflg = 0 
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
                    and a.cancelflg = 0 
                    and pc.perid = b.perid 
                    and a.orgcd1 = d.orgcd1 
                    and a.orgcd2 = d.orgcd2 
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = dmdDate
              , billseq = billSeq
              , branchno = branchNo
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
                    and a.cancelflg = 0 
                    and a.perid = b.perid 
                    and rownum = 1 
                union 
                select
                    b.perid as perid 
                from
                    person b
                    , perbill_person pc 
                where
                    pc.dmddate = to_date(:dmddate) 
                    and pc.billseq = :billseq
                    and pc.branchno = :branchno
                    and pc.perid = b.perid 
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                dmddate = dmdDate
                ,billseq = billSeq
                ,branchno = branchNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.PERID));
        }

        /// <summary>
        /// 団体名取得
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns></returns>
        private dynamic GetOrgName(string dmdDate, string billSeq, string branchNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    d.orgsname 
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
                    and a.cancelflg = 0 
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
                dmddate = dmdDate
                ,billseq = billSeq
                ,branchno = branchNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.ORGSNAME));
        }
    }
}
