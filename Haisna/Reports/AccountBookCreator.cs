using ClosedXML.Excel;
using Dapper;
using Hainsi.ReportCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AccountBookCreator : ExcelCreator
    {
        /// <summary>
        /// テンプレートファイル名
        /// </summary>
        protected override string TemplateFileName { get; } = "Template.xlsx";

        /// <summary>
        /// 支払いタイプ
        /// </summary>
        private class PriceDetail
        {
            /// <summary>
            /// 現金
            /// </summary>
            public decimal Credit { get; set; } = 0;
            /// <summary>
            /// 小切手
            /// </summary>
            public decimal Cheque { get; set; } = 0;
            /// <summary>
            /// カード
            /// </summary>
            public decimal Card { get; set; } = 0;
            /// <summary>
            /// Jデビット
            /// </summary>
            public decimal Jdebit { get; set; } = 0;
            /// <summary>
            /// フレンズ
            /// </summary>
            public decimal Friends { get; set; } = 0;
            /// <summary>
            /// 振込
            /// </summary>
            public decimal Transfer { get; set; } = 0;
            /// <summary>
            /// 福利厚生
            /// </summary>
            public decimal Fukuri { get; set; } = 0;
            /// <summary>
            /// その他
            /// </summary>
            public decimal Etc { get; set; } = 0;
        }

        /// <summary>
        /// カード別金額
        /// </summary>
        private class CardDetail
        {
            /// <summary>
            /// DC
            /// </summary>
            public decimal Dc { get; set; } = 0;
            /// <summary>
            /// Master(DC)
            /// </summary>
            public decimal MasterDc { get; set; } = 0;
            /// <summary>
            /// VISA(DC)
            /// </summary>
            public decimal Visa { get; set; } = 0;
            /// <summary>
            /// JCB
            /// </summary>
            public decimal Jcb { get; set; } = 0;
            /// <summary>
            /// Amex(JCB)
            /// </summary>
            public decimal Amex { get; set; } = 0;
            /// <summary>
            /// ビザカード
            /// </summary>
            public decimal VisaCard { get; set; } = 0;
            /// <summary>
            /// Diners
            /// </summary>
            public decimal Diners { get; set; } = 0;
            /// <summary>
            /// UC
            /// </summary>
            public decimal Uc { get; set; } = 0;
            /// <summary>
            /// Master(UC)
            /// </summary>
            public decimal MasterUc { get; set; } = 0;
            /// <summary>
            /// クレディセゾン
            /// </summary>
            public decimal Saison { get; set; } = 0;
            /// <summary>
            /// UFJ
            /// </summary>
            public decimal Ufj { get; set; } = 0;
            /// <summary>
            /// Millon(MC)
            /// </summary>
            public decimal Million { get; set; } = 0;
        }

        private class ExeclData
        {
            public string Yobo { get; set; }
            public string Hoken { get; set; }
            public DateTime PaymentDate { get; set; }
            public decimal KazeiDan { get; set; }
            public decimal KazeiPer { get; set; }
            public decimal KazeiPer2 { get; set; }
            public decimal KazeiPerGenmen1 { get; set; }
            /// <summary>
            /// 予防医療センター取消伝票データ
            /// </summary>
            public List<dynamic> Del { get; set; }
            public decimal HikazeiPer { get; set; }
            public decimal HikazeiPer2 { get; set; }
            public decimal HikazeiPerGenmen1 { get; set; }
            /// <summary>
            /// 団体入金データ
            /// </summary>
            public PriceDetail Dan { get; set; }
            /// <summary>
            /// 団体カード入金データ
            /// </summary>
            public CardDetail DanCard { get; set; }
            public dynamic Per { get; set; }
            public decimal Genmen { get; set; }
            public dynamic Per3 { get; set; }
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["accountdate"], out wkDate))
            {
                messages.Add("会計日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 会計台帳用データを読み込む
        /// </summary>
        /// <returns>会計台帳用データ</returns>
        protected override List<dynamic> GetData()
        {
            DateTime date = DateTime.Parse(queryParams["accountdate"]);

            // ファイル名所定の文字列を日付に置換
            FileName = FileName.Replace("{date}", date.ToString("yyyyMMdd"));

            var excelData = new ExeclData
            {
                Yobo = queryParams["yobo"],
                Hoken = queryParams["hoken"],
                PaymentDate = date,
                KazeiDan = CalcYoboKazeiDan(date),
                KazeiPer = CalcYoboKazeiPer(date),
                KazeiPer2 = CalcYoboKazeiPer2(date),
                KazeiPerGenmen1 = CalcYoboKazeiPerGenmen1(date),
                Del = SelectDel(date),
                HikazeiPer = CalcYoboHiKazeiPer(date),
                HikazeiPer2 = CalcYoboHiKazeiPer2(date),
                HikazeiPerGenmen1 = CalcYoboHiKazeiPerGenmen1(date),
                Dan = CalcDan(date),
                DanCard = CalcDanCard(date),
                Per = SelectPer(date),
                Genmen = calcPer2(date),
                Per3 = SelectPer3(date)
            };

            // 入力値を保存
            UpdateAccountBookData(queryParams["yobo"], queryParams["hoken"]);

            return new List<dynamic>() { excelData };
        }

        /// <summary>
        /// Excelに各値をセットする
        /// </summary>
        /// <param name="workbook">Excelファイル</param>
        /// <param name="data">会計台帳用データ</param>
        protected override void SetFieldValue(XLWorkbook workbook, List<dynamic> data)
        {
            ExeclData rec = data[0];

            IXLWorksheet accountSheet = workbook.Worksheet(1);

            // つり銭準備金【ドック】
            accountSheet.Cell(19, 18).Value = rec.Yobo;
            // つり銭準備金【クリニック】
            accountSheet.Cell(19, 26).Value = rec.Hoken;
            // 台帳作成日（システム日付）
            accountSheet.Cell(3, 29).Value = rec.PaymentDate;
            // 自費【課税】（税込）【ドック】
            accountSheet.Cell(11, 18).Value = rec.KazeiDan + rec.KazeiPer + rec.KazeiPer2 + rec.KazeiPerGenmen1;
            // 自費【非課税】（税込）【ドック】
            accountSheet.Cell(12, 18).Value = rec.HikazeiPer + rec.HikazeiPer2 + rec.HikazeiPerGenmen1;
            // 現金売上【ドック】
            accountSheet.Cell(18, 18).Value = rec.Dan.Credit + (rec.Per3 == null ? 0 : rec.Per3.PRICETOTAL);
            // 小切手【ドック】
            accountSheet.Cell(23, 18).Value = rec.Dan.Cheque + (rec.Per == null ? 0 : rec.Per.CHEQUE);
            // クレジットカード【ドック】
            accountSheet.Cell(21, 18).Value = rec.Dan.Card + (rec.Per == null ? 0 : rec.Per.CARD);
            // デビットカード【ドック】
            accountSheet.Cell(22, 18).Value = rec.Dan.Jdebit + (rec.Per == null ? 0 : rec.Per.JDEBIT);
            // 買物券【ドック】
            accountSheet.Cell(24, 18).Value = (rec.Per == null ? 0 : rec.Per.HAPPY_TICKET);
            // 福利厚生【ドック】
            accountSheet.Cell(28, 18).Value = rec.Dan.Fukuri;
            // 診療費減免【ドック】
            accountSheet.Cell(29, 18).Value = rec.Genmen;

            if (rec.Del != null && rec.Del.Count > 0)
            {
                IXLWorksheet delSheet = workbook.Worksheet(2);

                for (int i = 0; i < rec.Del.Count; i++)
                {
                    int rowNum = i + 2;
                    delSheet.Cell(rowNum, 1).Value = rec.Del[i].CALCDATE;
                    delSheet.Cell(rowNum, 2).Value = rec.Del[i].DMDDATE;
                    delSheet.Cell(rowNum, 3).Value = rec.Del[i].BILLSEQ;
                    delSheet.Cell(rowNum, 4).Value = rec.Del[i].BRANCHNO;
                    delSheet.Cell(rowNum, 5).Value = rec.Del[i].PRICE;
                    delSheet.Cell(rowNum, 6).Value = rec.Del[i].EDITPRICE;
                    delSheet.Cell(rowNum, 7).Value = rec.Del[i].TAXPRICE;
                    delSheet.Cell(rowNum, 8).Value = rec.Del[i].EDITTAX;

                    if (rec.Del[i].CREDIT != 0) {
                        delSheet.Cell(rowNum, 9).Value = "○";
                    }
                    if (rec.Del[i].HAPPY != 0)
                    {
                        delSheet.Cell(rowNum, 10).Value = "○";
                    }
                    if (rec.Del[i].CARD != 0)
                    {
                        delSheet.Cell(rowNum, 11).Value = "○";
                    }
                    if (rec.Del[i].JDEBIT != 0)
                    {
                        delSheet.Cell(rowNum, 12).Value = "○";
                    }
                    if (rec.Del[i].CHEQUE != 0)
                    {
                        delSheet.Cell(rowNum, 13).Value = "○";
                    }
                    if (rec.Del[i].TRANSFER != 0)
                    {
                        delSheet.Cell(rowNum, 14).Value = "○";
                    }
                }
            }
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の個人入金を計算
        /// </summary>
        /// <param name="calcDate">会計日</param>
        /// <returns>計算結果</returns>
        private decimal CalcYoboKazeiPer(DateTime calcDate)
        {
            dynamic data = SelectYoboKazeiPer(calcDate);

            if (data == null)
            {
                return 0;
            }

            return data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">会計日</param>
        /// <returns>データセット</returns>
        private dynamic SelectYoboKazeiPer(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                    select
                        perpayment.calcdate
                        , sum(perbill_c.price) as price
                        , sum(perbill_c.editprice) as editprice
                        , sum(perbill_c.taxprice) as taxprice
                        , sum(perbill_c.edittax) as edittax 
                    from
                        perbill
                        , consult_m
                        , perbill_c
                        , perpayment 
                    where
                        perpayment.calcdate = :calcdate 
                        and perbill.paymentdate = perpayment.paymentdate 
                        and perbill.paymentseq = perpayment.paymentseq 
                        and perbill.dmddate = perbill_c.dmddate 
                        and perbill.billseq = perbill_c.billseq 
                        and perbill.branchno = perbill_c.branchno 
                        and perbill_c.rsvno = consult_m.rsvno 
                        and perbill_c.priceseq = consult_m.priceseq 
                        and consult_m.omittaxflg = '0' 
                        and perbill.delflg = '0' 
                    group by
                        perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の個人入金額計算
        /// </summary>
        /// <param name="calcDate">会計日</param>
        /// <returns>計算結果</returns>
        private decimal CalcYoboKazeiPer2(DateTime calcDate)
        {
            dynamic data = SelectYoboKazeiPer2(calcDate);

            if (data == null)
            {
                return 0;
            }

            return data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">会計日</param>
        /// <returns>データセット</returns>
        private dynamic SelectYoboKazeiPer2(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , sum(perbill_c.price) as price
                            , sum(perbill_c.editprice) as editprice
                            , sum(perbill_c.taxprice) as taxprice
                            , sum(perbill_c.edittax) as edittax 
                        from
                            perbill
                            , perbill_person
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_person.dmddate 
                            and perbill.billseq = perbill_person.billseq 
                            and perbill.branchno = perbill_person.branchno 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill.branchno = perbill_c.branchno 
                            and ((perbill_c.taxprice + perbill_c.edittax) <> '0') 
                        group by
                            perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の個人入金額計算
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private decimal CalcYoboKazeiPerGenmen1(DateTime calcDate)
        {
            dynamic data = SelectYoboKazeiPerGenmen1(calcDate);

            if (data == null)
            {
                return 0;
            }

            return (data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX) * -1;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectYoboKazeiPerGenmen1(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , sum(consult_m.price) as price
                            , sum(consult_m.editprice) as editprice
                            , sum(consult_m.taxprice) as taxprice
                            , sum(consult_m.edittax) as edittax 
                        from
                            perbill
                            , consult_m
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill_c.otherlinedivcd = '9900' 
                            and perbill_c.rsvno = consult_m.rsvno 
                            and perbill_c.priceseq = consult_m.priceseq 
                            and consult_m.omittaxflg = '0' 
                        group by
                            perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター個人取消し伝票情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private List<dynamic> SelectDel(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , perpayment.credit as credit
                            , perpayment.happy_ticket as happy
                            , perpayment.card as card
                            , perpayment.jdebit as jdebit
                            , perpayment.cheque as cheque
                            , perpayment.transfer as transfer
                            , perbill.dmddate
                            , perbill.billseq
                            , perbill.branchno
                            , perbill_c.price as price
                            , perbill_c.editprice as editprice
                            , perbill_c.taxprice as taxprice
                            , perbill_c.edittax as edittax 
                        from
                            perbill
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill.branchno = perbill_c.branchno 
                            and perbill.delflg = 1
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の団体入金額を計算する
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns></returns>
        private decimal CalcYoboKazeiDan(DateTime paymentDate)
        {
            List<dynamic> list = SelectYoboKazeiDan(paymentDate);

            DateTime? currentCloseDate = null;
            int? currentBillSeq = null;
            int? currentBranchNo = null;

            int price = 0;

            // コントロールブレイクで入金額を計算する
            foreach (var rec in list)
            {
                if (currentCloseDate != rec.CLOSEDATE ||
                    currentBillSeq != rec.BILLSEQ ||
                    currentBranchNo != rec.BRANCHNO)
                {
                    price += rec.PAYMENTPRICE;

                    currentCloseDate = rec.CLOSEDATE;
                    currentBillSeq = rec.BILLSEQ;
                    currentBranchNo = rec.BRANCHNO;
                }
            }

            return price;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[課税]の団体入金情報をDBから取得
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns>データセット</returns>
        private List<dynamic> SelectYoboKazeiDan(DateTime paymentDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "paymentdate", paymentDate }
            };

            // SQLステートメント設定
            string sql = @"
                    select
                        payment.paymentdate
                        , payment.closedate
                        , payment.billseq
                        , payment.branchno
                        , payment.paymentprice 
                    from
                        payment
                        , billdetail
                        , billdetail_items 
                    where
                        payment.paymentdate = :paymentdate 
                        and payment.closedate = billdetail.closedate 
                        and payment.billseq = billdetail.billseq 
                        and payment.branchno = billdetail.branchno 
                        and billdetail.closedate = billdetail_items.closedate(+) 
                        and billdetail.billseq = billdetail_items.billseq(+) 
                        and billdetail.branchno = billdetail_items.branchno(+) 
                        and billdetail.lineno = billdetail_items.lineno(+) 
                    order by
                        payment.paymentdate
                        , payment.closedate
                        , payment.billseq
                        , payment.branchno
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の個人入金額計算
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private decimal CalcYoboHiKazeiPer(DateTime calcDate)
        {
            dynamic data = SelectYoboHiKazeiPer(calcDate);

            if (data == null)
            {
                return 0;
            }

            return data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectYoboHiKazeiPer(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , sum(perbill_c.price) as price
                            , sum(perbill_c.editprice) as editprice
                            , sum(perbill_c.taxprice) as taxprice
                            , sum(perbill_c.edittax) as edittax 
                        from
                            perbill
                            , consult_m
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill.branchno = perbill_c.branchno 
                            and perbill_c.rsvno = consult_m.rsvno 
                            and perbill_c.priceseq = consult_m.priceseq 
                            and consult_m.omittaxflg = '1' 
                            and perbill.delflg = '0' 
                        group by
                            perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の個人入金額計算
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private decimal CalcYoboHiKazeiPer2(DateTime calcDate)
        {
            dynamic data = SelectYoboHiKazeiPer2(calcDate);

            if (data == null)
            {
                return 0;
            }

            return data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectYoboHiKazeiPer2(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , sum(perbill_c.price) as price
                            , sum(perbill_c.editprice) as editprice
                            , sum(perbill_c.taxprice) as taxprice
                            , sum(perbill_c.edittax) as edittax 
                        from
                            perbill
                            , perbill_person
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_person.dmddate 
                            and perbill.billseq = perbill_person.billseq 
                            and perbill.branchno = perbill_person.branchno 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill.branchno = perbill_c.branchno 
                            and ((perbill_c.taxprice + perbill_c.edittax) = '0') 
                        group by
                            perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の個人入金額計算
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private decimal CalcYoboHiKazeiPerGenmen1(DateTime calcDate)
        {
            dynamic data = SelectYoboHiKazeiPerGenmen1(calcDate);

            if (data == null)
            {
                return 0;
            }

            return (data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX) * -1;
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectYoboHiKazeiPerGenmen1(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , sum(consult_m.price) as price
                            , sum(consult_m.editprice) as editprice
                            , sum(consult_m.taxprice) as taxprice
                            , sum(consult_m.edittax) as edittax 
                        from
                            perbill
                            , consult_m
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill_c.otherlinedivcd = '9900' 
                            and perbill_c.rsvno = consult_m.rsvno 
                            and perbill_c.priceseq = consult_m.priceseq 
                            and consult_m.omittaxflg = '1' 
                        group by
                            perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する予防医療センター[非課税]の団体入金情報をDBから取得
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns>データセット</returns>
        private List<dynamic> SelectYoboHiKazeiDan(DateTime paymentDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "paymentdate", paymentDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            payment.paymentdate
                            , payment.closedate
                            , payment.billseq
                            , payment.branchno
                            , payment.paymentprice 
                        from
                            payment
                            , bill
                            , billdetail
                            , billdetail_items 
                        where
                            payment.paymentdate = :paymentdate 
                            and payment.closedate = bill.closedate 
                            and payment.billseq = bill.billseq 
                            and payment.branchno = bill.branchno 
                            and payment.closedate = billdetail.closedate 
                            and payment.billseq = billdetail.billseq 
                            and payment.branchno = billdetail.branchno 
                            and billdetail.closedate = billdetail_items.closedate(+) 
                            and billdetail.billseq = billdetail_items.billseq(+) 
                            and billdetail.branchno = billdetail_items.branchno(+) 
                            and billdetail.lineno = billdetail_items.lineno(+) 
                            and ( 
                                ( 
                                    bill.secondflg is null 
                                    and (billdetail.taxprice + billdetail.edittax) = '0'
                                ) 
                                or ( 
                                    bill.secondflg = '1' 
                                    and ( 
                                        billdetail_items.taxprice + billdetail_items.edittax
                                    ) = '0'
                                )
                            ) 
                        order by
                            payment.paymentdate
                            , payment.closedate
                            , paymentt.billseq
                            , payment.branchno
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 入金日に該当する団体入金額を計算
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns>計算結果</returns>
        private PriceDetail CalcDan(DateTime paymentDate)
        {
            List<dynamic> list = SelectDan(paymentDate);

            var result = new PriceDetail();

            foreach (var rec in list)
            {
                switch ((int)rec.PAYMENTDIV) {
                    case 1:
                    case 7: // 現金、現金書留
                        result.Credit += rec.PAYMENTPRICE;
                        break;
                    case 2: // 小切手
                        result.Cheque += rec.PAYMENTPRICE;
                        break;
                    case 3: // 振込み
                        result.Transfer += rec.PAYMENTPRICE;
                        break;
                    case 4: // 福利厚生
                        result.Fukuri += rec.PAYMENTPRICE;
                        break;
                    case 5: // カード
                        result.Card += rec.PAYMENTPRICE;
                        break;
                    case 6: // Jデビット
                        result.Jdebit += rec.PAYMENTPRICE;
                        break;
                    case 8: // フレンズ
                        result.Friends += rec.PAYMENTPRICE;
                        break;
                    case 9: // その他
                        result.Etc += rec.PAYMENTPRICE;
                        break;
                }
            }

            return result;
        }

        /// <summary>
        /// 入金日に該当する団体入金情報をDBから取得
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns>データセット</returns>
        private List<dynamic> SelectDan(DateTime paymentDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "paymentdate", paymentDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            paymentdiv
                            , sum(paymentprice) as paymentprice 
                        from
                            payment 
                        where
                            paymentdate = :paymentdate 
                        group by
                            paymentdiv
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 入金日に該当する団体入金額を計算
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns>計算結果</returns>
        private CardDetail CalcDanCard(DateTime paymentDate)
        {
            List<dynamic> list = SelectDanCard(paymentDate);

            var result = new CardDetail();

            foreach (var rec in list)
            {
                switch (rec.FREEFIELD3)
                {
                    case "1": // DC
                        result.Dc += rec.PAYMENTPRICE;
                        break;
                    case "2": // Master(DC)
                        result.MasterDc += rec.PAYMENTPRICE;
                        break;
                    case "3": // VISA(DC)
                        result.Visa += rec.PAYMENTPRICE;
                        break;
                    case "4": // JCB
                        result.Jcb += rec.PAYMENTPRICE;
                        break;
                    case "5": // Amex(JCB)
                        result.Amex += rec.PAYMENTPRICE;
                        break;
                    case "6": // ビザカード
                        result.VisaCard += rec.PAYMENTPRICE;
                        break;
                    case "7": // Diners
                        result.Diners += rec.PAYMENTPRICE;
                        break;
                    case "8": // UC
                        result.Uc += rec.PAYMENTPRICE;
                        break;
                    case "9": // Master(UC)
                        result.MasterUc += rec.PAYMENTPRICE;
                        break;
                    case "10": // クレディセゾン
                        result.Saison += rec.PAYMENTPRICE;
                        break;
                    case "11": // UFJ
                        result.Ufj += rec.PAYMENTPRICE;
                        break;
                    case "12": // Millon(MC)
                        result.Million += rec.PAYMENTPRICE;
                        break;
                }
            }

            return result;
        }

        /// <summary>
        /// 入金日に該当する団体入金情報をDBから取得
        /// </summary>
        /// <param name="paymentDate">計上日</param>
        /// <returns>データセット</returns>
        private List<dynamic> SelectDanCard(DateTime paymentDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "paymentdate", paymentDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            payment.cardkind
                            , sum(payment.paymentprice) as paymentprice
                            , free.freefield3 
                        from
                            payment
                            , free 
                        where
                            payment.paymentdate = :paymentdate 
                            and ( 
                                free.freecd like 'CARD%' 
                                and (free.freefield2 = payment.cardkind)
                            ) 
                        group by
                            payment.cardkind
                            , free.freefield3
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 入金日に該当する個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectPer(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            calcdate
                            , sum(cheque) as cheque
                            , sum(card) as card
                            , sum(jdebit) as jdebit
                            , sum(happy_ticket) as happy_ticket
                            , sum(transfer) as transfer 
                        from
                            perpayment 
                        where
                            calcdate = :calcdate 
                        group by
                            calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する個人入金額計算
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>計算結果</returns>
        private decimal calcPer2(DateTime calcDate)
        {
            dynamic data = SelectPer2(calcDate);

            if (data == null)
            {
                return 0;
            }

            return (data.PRICE + data.EDITPRICE + data.TAXPRICE + data.EDITTAX) * -1;
        }

        /// <summary>
        /// 入金日に該当する個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectPer2(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.calcdate
                            , sum(perbill_c.price) as price
                            , sum(perbill_c.editprice) as editprice
                            , sum(perbill_c.taxprice) as taxprice
                            , sum(perbill_c.edittax) as edittax 
                        from
                            perbill
                            , perbill_c
                            , perpayment 
                        where
                            perpayment.calcdate = :calcdate 
                            and perbill.paymentdate = perpayment.paymentdate 
                            and perbill.paymentseq = perpayment.paymentseq 
                            and perbill.dmddate = perbill_c.dmddate 
                            and perbill.billseq = perbill_c.billseq 
                            and perbill.branchno = perbill_c.branchno 
                            and perbill_c.otherlinedivcd = '9900' 
                        group by
                            perpayment.calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する個人入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private dynamic SelectPer3(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            calcdate
                            , sum( 
                                pricetotal - happy_ticket - card - jdebit - cheque - transfer
                            ) as pricetotal 
                        from
                            perpayment 
                        where
                            calcdate = :calcdate 
                            and credit <> '0' 
                        group by
                            calcdate
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金日に該当する個人のカード別入金情報をDBから取得
        /// </summary>
        /// <param name="calcDate">計上日</param>
        /// <returns>データセット</returns>
        private List<dynamic> SelectPerCard(DateTime calcDate)
        {
            // キー値設定
            var sqlParam = new Dictionary<string, object>()
            {
                { "calcdate", calcDate }
            };

            // SQLステートメント設定
            string sql = @"
                        select
                            perpayment.cardkind
                            , sum(perpayment.card) as card
                            , free.freefield3 
                        from
                            perpayment
                            , free 
                        where
                            perpayment.calcdate = :calcdate 
                            and ( 
                                free.freecd like 'CARD%' 
                                and (free.freefield2 = perpayment.cardkind)
                            ) 
                        group by
                            perpayment.cardkind
                            , free.freefield3
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 入力値を保存する
        /// </summary>
        /// <param name="yobo">おつり銭（予防医療センター）</param>
        /// <param name="hoken">おつり銭（保険診察）</param>
        private void UpdateAccountBookData(string yobo, string hoken)
        {
            // ステートメント定義
            string sql = @"
                    update free
                    set
                        freefield1 = :freefield1
                        , freefield2 = :freefield2
                    where
                        freecd = 'KAIKEIDAICHO'
                    ";

            // パラメータ定義
            var sqlParams = new Dictionary<string, object>()
            {
                { "freefield1", yobo },
                { "freefield2", hoken }
            };

            connection.Execute(sql, sqlParams);
        }
    }
}
