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
    /// 新患登録リスト生成クラス
    /// </summary>
    public class PatientListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002070";

        /// <summary>
        /// 汎用分類コード（国籍）
        /// </summary>
        string FREECLASSCD_NAT = "NAT";

        /// <summary>
        /// 個人ID（仮ID検索条件）
        /// </summary>
        string PERID_VID = "@%";

        /// <summary>
        /// 予約状況（確定）
        /// </summary>
        int RSVSTATUS_FIX = 0;

        /// <summary>
        /// 個人住所情報.住所区分（自宅）
        /// </summary>
        int PERADDR_ADDRDIV = 1;

        /// <summary>
        /// 団体住所情報.住所区分（住所１）
        /// </summary>
        int ORGADDR_ADDRDIV = 1;

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!queryParams["startdate"].Equals("") &&
                !DateTime.TryParse(queryParams["startdate"], out DateTime wkStartDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!queryParams["enddate"].Equals("") &&
                !DateTime.TryParse(queryParams["enddate"], out DateTime wkEndDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            if (queryParams["startdate"].Equals("") && queryParams["perid"].Equals(""))
            {
                messages.Add("受診日、個人IDのいずれかを入力してください。");
            }

            return messages;
        }

        /// <summary>
        /// 新患登録リストデータを読み込む
        /// </summary>
        /// <returns>新患登録リストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("freeclasscdnat", FREECLASSCD_NAT);
            sqlParam.Add("peridvid", PERID_VID);
            sqlParam.Add("cancelflg", ConsultCancel.Used);
            sqlParam.Add("rsvstatusfix", RSVSTATUS_FIX);
            sqlParam.Add("peraddrdiv", PERADDR_ADDRDIV);
            sqlParam.Add("orgaddrdiv", ORGADDR_ADDRDIV);

            // SQLステートメント定義
            string sql = @"
                    select
                        co.csldate
                        , pe.lastname
                        , pe.firstname
                        , pe.romename
                        , pe.lastkname
                        , pe.firstkname
                        , pe.birth
                        , pe.gender
                        , fr.freefield1 as nation
                        , decode( 
                            nvl(pea.prefcd, 0)
                            , 0
                            , pea.cityname
                            , pea.prefname || pea.cityname
                        ) as cityname
                        , pea.address1 as address
                        , pea.address2 as addressdetail
                        , decode( 
                            pea.zipcd
                            , null
                            , ''
                            , '〒' || substr(pea.zipcd, 1, 3) || '-' || substr(pea.zipcd, 4, 7)
                        ) as zipcd
                        , pea.tel1 as per_tel
                        , ( 
                            select
                                og.orgname 
                            from
                                org og 
                            where
                                og.orgcd1 = oga.orgcd1 
                                and og.orgcd2 = oga.orgcd2
                        ) as orgname
                        , oga.directtel
                        , oga.tel as org_tel 
                    from
                        consult co
                        , person pe
                        , orgaddr oga
                        , free fr
                        , ( 
                            select
                                peraddr.*
                                , nvl(pref.prefname, '') prefname 
                            from
                                peraddr
                                , pref
                                , consult 
                            where
                                consult.perid like :peridvid 
                                and consult.rsvstatus = :rsvstatusfix 
                ";

            if (!queryParams["startdate"].Equals(""))
            {
                sql += @"
                                and consult.csldate >= :startdate 
                ";
                sqlParam.Add("startdate", queryParams["startdate"]);
            }
            if (!queryParams["enddate"].Equals(""))
            {
                sql += @"
                                and consult.csldate <= :enddate 
                ";
                sqlParam.Add("enddate", queryParams["enddate"]);
            }

            sql += @"
                                and consult.cancelflg = :cancelflg 
                                and consult.perid = peraddr.perid 
                                and peraddr.prefcd = pref.prefcd(+) 
                                and peraddr.addrdiv = :peraddrdiv 
                        ) pea 
                    where
                        co.perid = pe.perid 
                        and pe.perid = pea.perid(+) 
                        and co.orgcd1 = oga.orgcd1 
                        and co.orgcd2 = oga.orgcd2 
                        and co.cancelflg = :cancelflg 
                        and pe.nationcd = fr.freecd(+) 
                        and fr.freeclasscd(+) = :freeclasscdnat 
                        and oga.addrdiv = :orgaddrdiv 
                        and co.perid like :peridvid 
                        and co.rsvstatus = :rsvstatusfix 
                ";

            if (!queryParams["startdate"].Equals(""))
            {
                sql += @"
                        and co.csldate >= :startdate 
                ";
            }
            if (!queryParams["enddate"].Equals(""))
            {
                sql += @"
                        and co.csldate <= :enddate 
                ";
            }
            if (!queryParams["perid"].Equals(""))
            {
                sql += @"
                        and pe.perid = :perId 
                ";
                sqlParam.Add("perId", queryParams["perid"]);
            }

            sql += @"
                    order by
                        csldate
                        , rsvno
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">新患登録リストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageNoField = (CnDataField)cnObjects["PAGENO"];
            var printDateField = (CnDataField)cnObjects["PRINTDATE"];
            var cslDateListField = (CnListField)cnObjects["CSLDATE"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var romeNameListField = (CnListField)cnObjects["ROMENAME"];
            var kNameListField = (CnListField)cnObjects["KNAME"];
            var birthListField = (CnListField)cnObjects["BIRTH"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var nationListField = (CnListField)cnObjects["NATION"];
            var zipCdListField = (CnListField)cnObjects["ZIPCD"];
            var cityNameListField = (CnListField)cnObjects["CITYNAME"];
            var addressListField = (CnListField)cnObjects["ADDRESS"];
            var perTelListField = (CnListField)cnObjects["PER_TEL"];
            var orgNameListField = (CnListField)cnObjects["ORGNAME"];
            var directTelListField = (CnListField)cnObjects["DIRECTTEL"];
            var orgTelListField = (CnListField)cnObjects["ORG_TEL"];

            string sysdate = DateTime.Today.ToString("yyyy年MM月dd日");

            int rowCount = 0;
            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % cslDateListField.ListRows.Length);

                // 受診予定日
                cslDateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSLDATE);
                // 氏名（漢字）
                nameListField.ListCell(0, currentLine).Text =
                    Util.ConvertToString(detail.LASTNAME) + " " + Util.ConvertToString(detail.FIRSTNAME);
                // 氏名（ローマ字）
                romeNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ROMENAME);
                // 氏名（カナ）
                kNameListField.ListCell(0, currentLine).Text =
                    Util.ConvertToString(detail.LASTKNAME) + " " + Util.ConvertToString(detail.FIRSTKNAME);
                // 生年月日
                if (DateTime.TryParse(Util.ConvertToString(detail.BIRTH), out DateTime birth))
                {
                    birthListField.ListCell(0, currentLine).Text = WebHains.EraDateFormat(birth, "gg yy/MM/dd");
                }
                // 性別
                genderListField.ListCell(0, currentLine).Text = (Util.ConvertToString(detail.GENDER) == "1") ? "男性" : "女性";
                // 国籍
                nationListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NATION);
                // 郵便番号
                zipCdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ZIPCD);
                // 市区町村
                cityNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CITYNAME);
                // 住所
                addressListField.ListCell(0, currentLine).Text =
                    Util.ConvertToString(detail.ADDRESS) + " " + Util.ConvertToString(detail.ADDRESSDETAIL);
                // 電話番号
                perTelListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PER_TEL);
                // 団体名
                orgNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);
                // 勤務先電話番号（直通）
                directTelListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DIRECTTEL);
                // 勤務先電話番号（代表）
                orgTelListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORG_TEL);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == cslDateListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = pageNo.ToString("0");

                    // 印刷日
                    printDateField.Text = sysdate;

                    // ドキュメントの出力
                    PrintOut(cnForm);
                }

                // 行カウントをインクリメント
                rowCount++;
            }
        }
    }
}
