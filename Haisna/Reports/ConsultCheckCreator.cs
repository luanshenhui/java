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
    /// 受診予定者チェックシート生成クラス
    /// </summary>
    public class ConsultCheckCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000140";

        /// <summary>
        /// 汎用分類コード（帳票固有設定用）
        /// </summary>
        string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用分類コード（受診区分）
        /// </summary>
        string FREECLASSCD_CDV = "CDV";

        /// <summary>
        /// 汎用コード（受診予定者チェックシート出力対象コース）
        /// </summary>
        string FREECD_LST000140 = "LST000140%";

        /// <summary>
        /// 汎用コード（受診予定者チェックシート胃検査区分）
        /// </summary>
        string FREECD_LST000141 = "LST000141%";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["startdate"], out DateTime wkStartDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out DateTime wkEndDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 受診予定者チェックシートデータを読み込む
        /// </summary>
        /// <returns>受診予定者チェックシートデータ</returns>
        protected override List<dynamic> GetData()
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("startdate", queryParams["startdate"]);
            sqlParam.Add("freeclasscdlst", FREECLASSCD_LST);
            sqlParam.Add("freeclasscdcdv", FREECLASSCD_CDV);
            sqlParam.Add("freecdlst000140", FREECD_LST000140);
            sqlParam.Add("freecdlst000141", FREECD_LST000141);
            sqlParam.Add("personorgcd1", WebHains.ORGCD1_PERSON);
            sqlParam.Add("personorgcd2", WebHains.ORGCD2_PERSON);
            sqlParam.Add("cancelflg", ConsultCancel.Used);

            // SQLステートメント定義
            string sql = @"
                    select
                        consult.csldate
                        , person.compperid
                        , consult.perid
                        , receipt.dayid
                        , person.lastkname
                        , person.firstkname
                        , person.romename
                        , person.lastname
                        , person.firstname
                        , person.gender
                        , consult.age
                        , person.birth
                        , ( 
                            select
                                max(c.csldate) as predate 
                            from
                                receipt r
                                , consult c
                                , free f 
                            where
                                r.rsvno = c.rsvno 
                                and c.csldate < :startdate
                                and c.perid = consult.perid 
                                and c.cscd = f.freefield1 
                                and f.freecd like :freecdlst000140 
                                and f.freeclasscd = :freeclasscdlst 
                        ) predate
                        , org.insbring
                        , org.ticket
                        , org.ticketcentercall
                        , consult.collectticket
                        , org.orgname
                        , consult.orgcd1
                        , consult.orgcd2
                        , ctrpt.csname
                        , getstmacdiv(consult.rsvno, :freecdlst000141) stmacdiv
                        , rnk.freefield1 as rank
                        , prc.cprice
                        , prc.ctaxprice
                        , ctrptpn.pubnote as ctrcmt
                        , perptpn.pubnote as percmt 
                    from
                        consult
                        , person
                        , receipt
                        , org
                        , ctrpt
                        , ( 
                            select
                                consult.rsvno
                                , sum(price) + sum(editprice) as cprice
                                , sum(taxprice) + sum(edittax) as ctaxprice 
                            from
                                consult
                                , consult_m 
                            where
                                consult.rsvno = consult_m.rsvno 
                                and consult.csldate >= :startdate 
                                and consult_m.orgcd1 = :personorgcd1 
                                and consult_m.orgcd2 = :personorgcd2 
                ";

            if (!queryParams["enddate"].Equals(""))
            {
                sql += @"
                                and consult.csldate <= :enddate 
                ";
                sqlParam.Add("enddate", queryParams["enddate"]);
            }

            sql += @"
                            group by
                                consult.rsvno
                        ) prc
                        , ( 
                            select
                                free.freecd
                                , free.freefield1 
                            from
                                free 
                            where
                                free.freeclasscd = :freeclasscdcdv 
                        ) rnk
                        , ( 
                            select
                                free.freecd
                                , free.freefield1 
                            from
                                free 
                            where
                                free.freecd like :freecdlst000140 
                                and free.freeclasscd = :freeclasscdlst 
                        ) lst1
                        , ( 
                            select
                                ctrptpubnote.ctrptcd
                                , ctrptpubnote.pubnote 
                            from
                                ctrptpubnote
                                , ( 
                                    select
                                        ctrptpubnote.ctrptcd
                                        , max(ctrptpubnote.seq) as seq 
                                    from
                                        ctrptpubnote 
                                    group by
                                        ctrptpubnote.ctrptcd
                                ) maxctrpub 
                            where
                                ctrptpubnote.seq = maxctrpub.seq 
                                and ctrptpubnote.ctrptcd = maxctrpub.ctrptcd 
                                and ctrptpubnote.delflg is null
                        ) ctrptpn
                        , ( 
                            select
                                perpubnote.perid
                                , perpubnote.pubnote 
                            from
                                perpubnote
                                , ( 
                                    select
                                        perpubnote.perid
                                        , max(perpubnote.seq) as seq 
                                    from
                                        perpubnote 
                                    group by
                                        perpubnote.perid
                                ) maxperpub 
                            where
                                perpubnote.seq = maxperpub.seq 
                                and perpubnote.perid = maxperpub.perid 
                                and perpubnote.delflg is null
                        ) perptpn 
                    where
                        consult.rsvno = receipt.rsvno(+) 
                        and consult.perid = person.perid 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2 
                        and consult.ctrptcd = ctrpt.ctrptcd 
                        and consult.ctrptcd = ctrptpn.ctrptcd(+) 
                        and consult.perid = perptpn.perid(+) 
                        and consult.rsvno = prc.rsvno(+) 
                        and consult.csldivcd = rnk.freecd(+) 
                        and consult.cscd = lst1.freefield1 
                        and consult.csldate >= :startdate 
                ";

            if (!queryParams["enddate"].Equals(""))
            {
                sql += @"
                        and consult.csldate <= :enddate 
                ";
            }

            sql += @"
                        and consult.cancelflg = :cancelflg 
                    order by
                        consult.csldate
                        , consult.rsvgrpcd
                        , receipt.dayid
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">受診予定者チェックシートデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageNoField = (CnDataField)cnObjects["PAGE"];
            var printDateField = (CnDataField)cnObjects["PRTDATE"];
            var paraCslDateField = (CnDataField)cnObjects["PARACSLDATE"];
            var compPersonListField = (CnListField)cnObjects["COMPPERSON"];
            var perIdListField = (CnListField)cnObjects["PERID"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var kNameListField = (CnListField)cnObjects["KNAME"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var birthListField = (CnListField)cnObjects["BIRTH"];
            var cslDateListField = (CnListField)cnObjects["CSLDATE"];
            var insBringListField = (CnListField)cnObjects["INSCHECK"];
            var ticketListField = (CnListField)cnObjects["TICKET"];
            var collectListField = (CnListField)cnObjects["COLLECT"];
            var ticketCenterListField = (CnListField)cnObjects["TICKETCENTER"];
            var orgCdListField = (CnListField)cnObjects["ORGCD"];
            var orgNameListField = (CnListField)cnObjects["ORGNAME"];
            var csNameListField = (CnListField)cnObjects["CSNAME"];
            var cslDivListField = (CnListField)cnObjects["CSLDIV"];
            var priceListField = (CnListField)cnObjects["PRICE"];
            var taxListField = (CnListField)cnObjects["TAX"];
            var pubNoteListField = (CnListField)cnObjects["PUBNOTE"];
            var pubNote2ListField = (CnListField)cnObjects["PUBNOTE2"];

            string sysdate = DateTime.Today.ToString("yyyy/MM/dd");

            int pageNo = 0;
            short lineCount = 0;
            string pageBreakKeyCslDate = "";

            // ページ内の項目に値をセット
            for (int dataCount = 0; dataCount < data.Count; dataCount++)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                var detail = data[dataCount];

                // 改ページキーを取得する
                string tmpCslDate = "";
                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime cslDate))
                {
                    tmpCslDate = cslDate.ToString("yyyy/MM/dd");
                }

                // 改ページの判定を行う
                bool isPageBreak = false;
                if (dataCount > 0 &&
                    !pageBreakKeyCslDate.Equals(tmpCslDate))
                {
                    // 改ページキーが異なる場合は改ページを行う
                    isPageBreak = true;

                    // 次回のループで今回のデータの処理を行うため
                    // カウントを１つ戻す
                    dataCount--;
                } else
                {
                    // 最初のデータの場合
                    // 改ページキーを退避する
                    if (dataCount == 0)
                    {
                        pageBreakKeyCslDate = tmpCslDate;
                    }

                    // 同伴者有無
                    string compPerId = "";
                    if (Util.ConvertToString(detail.COMPPERID).Trim() != "")
                    {
                        compPerId = "★";
                    }
                    compPersonListField.ListCell(0, lineCount).Text = compPerId;

                    // 患者ID
                    perIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.PERID);

                    // 当日ID
                    dayIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.DAYID);

                    // フリガナ
                    kNameListField.ListCell(0, lineCount).Text =
                        Microsoft.VisualBasic.Strings.StrConv(
                            Util.ConvertToString(detail.LASTKNAME).Trim() + " " + Util.ConvertToString(detail.FIRSTKNAME).Trim() +
                            "(" + Util.ConvertToString(detail.ROMENAME).Trim() + ")"
                            , Microsoft.VisualBasic.VbStrConv.Narrow);

                    // 氏名
                    nameListField.ListCell(0, lineCount).Text =
                        Util.ConvertToString(detail.LASTNAME).Trim() + "　" + Util.ConvertToString(detail.FIRSTNAME).Trim();

                    // 性別
                    string gender = "";
                    switch (Util.ConvertToString(detail.GENDER))
                    {
                        case "1":
                            gender = "男性";
                            break;
                        case "2":
                            gender = "女性";
                            break;
                    }
                    genderListField.ListCell(0, lineCount).Text = gender;

                    // 年齢
                    decimal.TryParse(Util.ConvertToString(detail.AGE), out decimal age);
                    ageListField.ListCell(0, lineCount).Text = Math.Round(age, 0).ToString("0");

                    // 生年月日
                    if (DateTime.TryParse(Util.ConvertToString(detail.BIRTH), out DateTime birth))
                    {
                        birthListField.ListCell(0, lineCount).Text =
                            WebHains.GetShortEraName(birth) + WebHains.EraDateFormat(birth, "yy.MM.dd");
                    }

                    // 前回受診日
                    if (DateTime.TryParse(Util.ConvertToString(detail.PREDATE), out DateTime perDate))
                    {
                        cslDateListField.ListCell(0, lineCount).Text = perDate.ToString("yyyy/MM/dd");
                    }

                    // 保険証
                    string insBring = "";
                    switch (Util.ConvertToString(detail.INSBRING))
                    {
                        case "1":
                            insBring = "要";
                            break;
                        default:
                            insBring = "－";
                            break;
                    }
                    insBringListField.ListCell(0, lineCount).Text = insBring;

                    // チケット
                    string ticket = "";
                    switch (Util.ConvertToString(detail.TICKET))
                    {
                        case "0":
                            ticket = "－";
                            break;
                        case "1":
                            ticket = "有";
                            break;
                    }
                    ticketListField.ListCell(0, lineCount).Text = ticket;

                    // 回収
                    string collectTicket = "";
                    switch (Util.ConvertToString(detail.COLLECTTICKET))
                    {
                        case "":
                            collectTicket = "－";
                            break;
                        case "1":
                            collectTicket = "済";
                            break;
                    }
                    collectListField.ListCell(0, lineCount).Text = collectTicket;

                    // 事前回収
                    string ticketCenter = "";
                    switch (Util.ConvertToString(detail.TICKETCENTERCALL))
                    {
                        case "1":
                            ticketCenter = "有";
                            break;
                        default:
                            ticketCenter = "－";
                            break;
                    }
                    ticketCenterListField.ListCell(0, lineCount).Text = ticketCenter;

                    // 団体CD
                    int.TryParse(Util.ConvertToString(detail.ORGCD1), out int orgCd1);
                    int.TryParse(Util.ConvertToString(detail.ORGCD2), out int orgCd2);
                    orgCdListField.ListCell(0, lineCount).Text = orgCd1.ToString("00000") + orgCd2.ToString("00000");

                    // 団体名
                    orgNameListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.ORGNAME).Trim();

                    // コース名（ランク）
                    string csName = Util.ConvertToString(detail.CSNAME).Trim();
                    if (Util.ConvertToString(detail.STMACDIV).Trim() != "")
                    {
                        csName += "(" + Util.ConvertToString(detail.STMACDIV).Trim() + ")";
                    }
                    csNameListField.ListCell(0, lineCount).Text = csName;
                    cslDivListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.RANK).Trim();

                    // 個人負担
                    if (Util.ConvertToString(detail.CPRICE).Trim() != "")
                    {
                        decimal.TryParse(Util.ConvertToString(detail.CPRICE), out decimal price);
                        priceListField.ListCell(0, lineCount).Text = price.ToString("#,##0");
                    }

                    // 消費税
                    if (Util.ConvertToString(detail.CTAXPRICE).Trim() != "")
                    {
                        decimal.TryParse(Util.ConvertToString(detail.CTAXPRICE), out decimal taxPrice);
                        taxListField.ListCell(0, lineCount).Text = taxPrice.ToString("#,##0");
                    }

                    // 契約コメント
                    pubNoteListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.CTRCMT).Trim();

                    // 予約コメント
                    pubNote2ListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.PERCMT).Trim();

                    // 出力行位置をカウントアップする
                    lineCount++;
                }

                // 下記の何れかの場合に改ページ処理を行う
                // ・改ページキーが異なる場合
                // ・ページの最終行に達した場合
                // ・ループの最後のデータの場合
                if (isPageBreak ||
                    lineCount == (compPersonListField.ListRows.Length - 1) ||
                    dataCount == (data.Count - 1))
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = pageNo.ToString("0");

                    // 印刷日
                    printDateField.Text = sysdate;

                    // 受診日
                    paraCslDateField.Text = pageBreakKeyCslDate;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 出力行位置を初期化する
                    lineCount = 0;

                    // 改ページキーを退避する
                    pageBreakKeyCslDate = tmpCslDate;
                }
            }
        }
    }
}
