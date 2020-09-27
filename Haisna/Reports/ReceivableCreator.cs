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
    /// 未収金
    /// </summary>
    public class ReceivableCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002340";


        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["startdate"], out wkDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out wkDate))
            {
                messages.Add("終了日付が正しくありません。");
            }


            return messages;
        }

        /// <summary>
        /// 未収金対象データを読み込む
        /// </summary>
        /// <returns>未収金対象データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    pw.dmddate as dmddate
                    , to_char(pw.csldate, 'MM/DD') || ' ' || pw.dayid || ' ' || p.lastname || ' ' || p.firstname as orgname
                    , pw.total as price 
                from
                    ( 
                        select
                            pb.dmddate
                            , re.csldate
                            , re.dayid
                            , co.perid
                            , sum(price + editprice + taxprice + edittax) total 
                        from
                            consult co
                            , perbill pb
                            , perbill_c pbc
                            , receipt re 
                        where
                            pb.dmddate = pbc.dmddate 
                            and pb.billseq = pbc.billseq 
                            and pb.branchno = pbc.branchno 
                            and pbc.rsvno = co.rsvno 
                            and pb.paymentdate is null 
                            and pb.delflg = :delflg 
                            and pb.dmddate between :startdate and :enddate 
                            and co.rsvno = re.rsvno 
                        group by
                            pb.dmddate
                            , re.csldate
                            , re.dayid
                            , co.perid
                    ) pw
                    , person p 
                where
                    p.perid = pw.perid 
                union 
                select
                    pw.dmddate as dmddate
                    , to_char(pw.csldate, 'MM/DD') || ' ' || pw.dayid || ' ' || p.lastname || ' ' || p.firstname as orgname
                    , pw.total as price 
                from
                    ( 
                        select
                            peb.dmddate
                            , pes.perid
                            , '' as csldate
                            , '' as dayid
                            , sum( 
                                pbc.price + pbc.editprice + pbc.taxprice + pbc.edittax
                            ) as total 
                        from
                            perbill peb
                            , perbill_person pes
                            , perbill_c pbc 
                        where
                            peb.dmddate = pes.dmddate 
                            and peb.billseq = pes.billseq 
                            and peb.branchno = pes.branchno 
                            and pes.dmddate = pbc.dmddate 
                            and pes.billseq = pbc.billseq 
                            and pes.branchno = pbc.branchno 
                            and peb.paymentdate is null 
                            and peb.delflg = :delflg 
                            and peb.dmddate between :startdate and :enddate 
                        group by
                            peb.dmddate
                            , pes.perid
                    ) pw
                    , person p 
                where
                    p.perid = pw.perid

            ";

            //請求日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = dSdate,
                enddate = dEdate,
                delflg = DelFlg.Used,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">未収金対象データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット

            var pageNoField = (CnDataField)cnObjects["PAGE"];
            var dmdDateListField = (CnListField)cnObjects["DMDDATE"];
            var orgNameListField = (CnListField)cnObjects["ORGNAME"];
            var priceListField = (CnListField)cnObjects["PRICE"];

            int rowCount = 0;
            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % dmdDateListField.ListRows.Length);

                // 請求日
                dmdDateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DMDDATE);

                // 団体名
                orgNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);

                // 請求額
                priceListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PRICE);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == dmdDateListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = pageNo.ToString();

                    // ドキュメントの出力
                    PrintOut(cnForm);

                }

                // 行カウントをインクリメント
                rowCount++;

            }
        }

    }
}
