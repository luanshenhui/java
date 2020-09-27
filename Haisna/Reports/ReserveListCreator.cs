using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 予約者一覧生成クラス
    /// </summary>
    public class ReserveListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002080";

        /// <summary>
        /// 汎用分類コード（帳票固有設定用）
        /// </summary>
        string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用コード（予約者一覧表出力対象コース）
        /// </summary>
        string FREECD_LST000100 = "LST000100%";

        /// <summary>
        /// 汎用コード（胃検査区分）
        /// </summary>
        string FREECD_LST000022 = "LST000022%";

        /// <summary>
        /// グループコード（胃Ｘ線・内視鏡）
        /// </summary>
        string GRPCD_X502 = "X502";

        /// <summary>
        /// 個人住所情報.住所区分（自宅）
        /// </summary>
        int PERADDR_ADDRDIV = 1;

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
        /// 予約者一覧データを読み込む
        /// </summary>
        /// <returns>予約者一覧データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    consult.csldate as csldate
                    , person.perid as bperid
                    , person.lastkname || ' ' || person.firstkname as kname
                    , person.lastname || ' ' || person.firstname as name
                    , person.firstkname as firstkname
                    , person.cslcount as cslcount
                    , person.gender as gender
                    , trunc(consult.age, 0) as age
                    , consult.issuecslticket as issuecslticket
                    , person.birth
                    , (
                    select
                        org.orgname
                    from
                        org
                    where
                        org.orgcd1 = consult.orgcd1
                        and org.orgcd2 = consult.orgcd2
                    ) as orgname
                    , ctrpt.csname as csname
                    , consult.orgcd1 || ' ' || consult.orgcd2 as orgcd1orgcd2
                    , trim(person.compperid) as compperid
                    , receipt.dayid as dayid
                    , (
                    select
                        peraddr.tel1
                    from
                        peraddr
                    where
                        peraddr.perid(+) = person.perid
                        and peraddr.addrdiv = :peraddrdiv 
                    ) as telephone
                    , consult.rsvno as rsvno
                from
                    consult
                    , person
                    , receipt
                    , free
                    , ctrpt
                where
                    consult.perid = person.perid
                    and consult.rsvno = receipt.rsvno(+)
                    and consult.ctrptcd = ctrpt.ctrptcd
                    and free.freecd like :freecd
                    and free.freeclasscd = :freeclasscd
                    and free.freefield1 = consult.cscd
                    and consult.csldate between :startdate and :enddate
                    and consult.cancelflg = :cancelflg
                order by
                    kname
                    , telephone
                ";

            // パラメータセット
            var sqlParam = new
            {
                startdate = queryParams["startdate"],
                enddate = queryParams["enddate"],
                freecd = FREECD_LST000100,
                freeclasscd = FREECLASSCD_LST,
                cancelflg = ConsultCancel.Used,
                peraddrdiv = PERADDR_ADDRDIV,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">予約者一覧データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageNoField = (CnDataField)cnObjects["PAGENO"];
            var printDateField = (CnDataField)cnObjects["PRINTDATE"];
            var cslDateField = (CnDataField)cnObjects["CSLDATE"];
            var compPerIdListField = (CnListField)cnObjects["COMPPERID"];
            var bPerIdListField = (CnListField)cnObjects["B_PERID"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var kNameListField = (CnListField)cnObjects["KNAME"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var cslCountListField = (CnListField)cnObjects["CSLCOUNT"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var telephoneListField = (CnListField)cnObjects["TELEPHONE"];
            var issueCslTicketListField = (CnListField)cnObjects["ISSUECSLTICKET"];
            var birthListField = (CnListField)cnObjects["BIRTH"];
            var orgCd1OrgCd2ListField = (CnListField)cnObjects["ORGCD1ORGCD2"];
            var orgNameListField = (CnListField)cnObjects["ORGNAME"];

            var csNameTextFieldList = new List<CnTextField>();
            for (int i = 1; i <= nameListField.ListRows.Length; i++)
            {
                csNameTextFieldList.Add((CnTextField)cnObjects[string.Format("CSNAME{0}", i)]);
            }

            string sysdate = DateTime.Today.ToString("yyyy/MM/dd");

            int rowCount = 0;
            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % nameListField.ListRows.Length);

                // 同伴者
                compPerIdListField.ListCell(0, currentLine).Text = (Util.ConvertToString(detail.COMPPERID) != "") ? "★" : "";
                // 患者ID
                bPerIdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BPERID);
                // ID
                dayIdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);
                // カナ氏名
                kNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.KNAME);
                // 氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);
                // 回数
                cslCountListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSLCOUNT);
                // 性別
                genderListField.ListCell(0, currentLine).Text = (Util.ConvertToString(detail.GENDER) == "1") ? "男性" : "女性";
                // 年齢
                ageListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.AGE);
                // 電話番号
                telephoneListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.TELEPHONE);
                // 診察券
                string issueCslTicket = "";
                switch (Util.ConvertToString(detail.ISSUECSLTICKET))
                {
                    case "3":
                        issueCslTicket = "再発行";
                        break;
                    case "1":
                        issueCslTicket = "新規";
                        break;
                }
                issueCslTicketListField.ListCell(0, currentLine).Text = issueCslTicket;
                // 生年月日
                var birth = DateTime.Parse(Convert.ToString(detail.BIRTH));
                string shortEraName = WebHains.GetShortEraName(birth);
                int eraYear = WebHains.JapaneseCalendar.GetYear(birth);
                birthListField.ListCell(0, currentLine).Text = string.Format("{0}{1:D2}/{2:MM/dd}", shortEraName, eraYear, birth);
                // 団体コード
                orgCd1OrgCd2ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGCD1ORGCD2);
                // 団体名
                orgNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);
                // コース名
                csNameTextFieldList[currentLine].Text =
                    Util.ConvertToString(detail.CSNAME).Trim() +
                    "(" + GetStomachInspecion(Util.ConvertToString(detail.RSVNO)).Trim() + ")";

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == nameListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = string.Format("{0:D03}", pageNo);

                    // 印刷日
                    printDateField.Text = sysdate;

                    // 受診日
                    if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime dt))
                    {
                        cslDateField.Text = dt.ToString("yy年MM月dd日");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);
                }

                // 行カウントをインクリメント
                rowCount++;
            }
        }

        /// <summary>
        /// 胃検査区分を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <returns></returns>
        private dynamic GetStomachInspecion(string rsvno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    free.freefield3 as freefield3
                from
                    consultitemlist
                    , grp_i
                    , free
                where
                    consultitemlist.rsvno = :rsvNo
                    and consultitemlist.cancelflg = :cancelflg 
                    and grp_i.grpcd = :grpcd 
                    and grp_i.itemcd = consultitemlist.itemcd
                    and free.freecd like :freecd 
                    and free.freefield1 = grp_i.grpcd
                    and free.freefield2 = grp_i.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvNo = rsvno,
                grpcd = GRPCD_X502,
                freecd = FREECD_LST000022,
                cancelflg = ConsultCancel.Used,
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.FREEFIELD3));
        }
    }
}
