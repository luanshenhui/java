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
    /// 一年目はがき生成クラス
    /// </summary>
    public class AfterPostcardCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002000";

        /// <summary>
        /// 出力対象コース
        /// </summary>
        private string CS_FREECD = "LST000010%";      // 出力対象コース　汎用コード
        private string CS_FREECLASSCD = "LST";        // 出力対象コース　汎用分類コード

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //受診日チェック
            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["startymd"], out wkDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["endymd"], out wkDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            //予約年月チェック
            if ((string.IsNullOrEmpty(queryParams["start_ym_y"])) || (string.IsNullOrEmpty(queryParams["start_ym_m"])))
            {
                messages.Add("開始予約年月が正しくありません。");
            }
            if ((string.IsNullOrEmpty(queryParams["end_ym_y"])) || (string.IsNullOrEmpty(queryParams["end_ym_m"])))
            {
                messages.Add("終了予約年月が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 一年目はがきデータを読み込む
        /// </summary>
        /// <returns>一年目はがきデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    substr(peraddr.zipcd, 1, 3) as zipcd1
                    , substr(peraddr.zipcd, 4, 7) as zipcd2
                    , peraddr.cityname as address0
                    , peraddr.address1 as address1
                    , peraddr.address2 as address2
                    , person.lastname as lastname
                    , person.firstname as firstname
                    , substr(person.perid, 1, length(person.perid) - 1) || '-' || substr(person.perid, length(person.perid))
                     as perid
                    , consult.csldate as csldate 
                from
                    consult
                    , person
                    , peraddr
                        left join pref on peraddr.prefcd = pref.prefcd
                    , receipt
                    , org
                    , free 
                where
                    consult.perid = person.perid 
                    and person.perid = peraddr.perid 
                    and person.postcardaddr = peraddr.addrdiv 
                    and consult.rsvno = receipt.rsvno 
                    and consult.cancelflg = :cancelflg  
                    and org.orgcd1 = consult.orgcd1 
                    and org.orgcd2 = consult.orgcd2 
                    and nvl(org.noprintletter, 0) <> 1 
                    and free.freecd like :freecd
                    and free.freeclasscd = :freeclasscd
                    and free.freefield1 = consult.cscd 
                    and receipt.comedate is not null 
                    and consult.csldate between :startymd and :endymd 
                    and not exists ( 
                        select
                            cs.perid 
                        from
                            consult cs
                            , free fr 
                        where
                            cs.perid = consult.perid 
                            and fr.freecd like :freecd
                            and fr.freeclasscd = :freeclasscd
                            and fr.freefield1 = cs.cscd 
                            and cs.csldate between to_date(:y_startym, 'YYYY/MM') and last_day(to_date(:y_endym, 'YYYY/MM'))
                    ) 
                ";

            //団体コード
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];
            if (!string.IsNullOrEmpty(orgCd1) || !string.IsNullOrEmpty(orgCd2))
            {
                sql += @"  and consult.orgcd1 = :orgcd1
                           and consult.orgcd2 = :orgcd2";
            }

            sql += @"
                order by
                    1
                    , 2
                    , 3
                    , 4
                ";

            //受診日
            DateTime.TryParse(queryParams["startymd"], out DateTime dSdate);
            DateTime.TryParse(queryParams["endymd"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            //予約年月（日付型にするため、暫定で1日を設定）
            DateTime.TryParse(queryParams["start_ym_y"] + "/" + queryParams["start_ym_m"] + "/01", out DateTime dSdate_y);
            DateTime.TryParse(queryParams["end_ym_y"] + "/" + queryParams["end_ym_m"] + "/01", out DateTime dEdate_y);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate_y > dEdate_y)
            {
                DateTime wkDate = dSdate_y;
                dSdate_y = dEdate_y;
                dEdate_y = wkDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startymd = dSdate,
                endymd = dEdate,
                y_startym = dSdate_y.ToString("yyyy/MM"),
                y_endym = dEdate_y.ToString("yyyy/MM"),

                orgCd1 = queryParams["orgcd1"],
                orgcd2 = queryParams["orgcd2"],
              
                freecd = CS_FREECD,
                freeclasscd = CS_FREECLASSCD,

                cancelflg = ConsultCancel.Used

            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">一年目はがきデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var zipcdField = (CnDataField)cnObjects["ZIPCD"];
            var address1Field = (CnDataField)cnObjects["ADDRESS1"];
            var address2Field = (CnDataField)cnObjects["ADDRESS2"];
            var address3Field = (CnDataField)cnObjects["ADDRESS3"];
            var pernameField = (CnDataField)cnObjects["PERNAME"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var noteTextField = (CnTextField)cnObjects["TXTNOTE"];
            var csldateField = (CnDataField)cnObjects["CSLDATE"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // データフィールド

                string strWorkData = "";

                //郵便番号
                strWorkData = Util.ConvertToString(detail.ZIPCD2);

                if (string.IsNullOrEmpty(strWorkData))
                {
                    zipcdField.Text = "〒" + Util.ConvertToString(detail.ZIPCD1);
                }
                else
                {
                    zipcdField.Text = "〒" + Util.ConvertToString(detail.ZIPCD1)+ "-" + Util.ConvertToString(detail.ZIPCD2);
                }

                //住所
                address1Field.Text = Util.ConvertToString(detail.ADDRESS0);
                address2Field.Text = Util.ConvertToString(detail.ADDRESS1);
                address3Field.Text = Util.ConvertToString(detail.ADDRESS2);

                //氏名
                pernameField.Text = Util.ConvertToString(detail.LASTNAME) + "　" + Util.ConvertToString(detail.FIRSTNAME);

                //患者ＩＤ
                peridField.Text = Util.ConvertToString(detail.PERID);

                //案内文
                strWorkData = queryParams["notes"];
                if (!string.IsNullOrEmpty(strWorkData))
                {
                    noteTextField.Text = strWorkData;
                }

                //受診日
                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime dt))
                {
                    csldateField.Text = dt.ToString("yyyy年M月d日");
                }

                pageNo++;

                // ドキュメントの出力
                PrintOut(cnForm);

            }
        }
         
    }
}
