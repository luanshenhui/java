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
    /// ナースチェックリスト生成クラス
    /// </summary>
    public class NurseCheckCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000410";

        /// <summary>
        /// 汎用分類コード（帳票固有設定用）
        /// </summary>
        string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用コード（ナースチェックリスト出力対象コース）
        /// </summary>
        string FREECD_LST00041 = "LST00041%";

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
        /// ナースチェックリストデータを読み込む
        /// </summary>
        /// <returns>ナースチェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    c.csldate
                    , p.perid
                    , p.lastkname
                    , p.firstkname
                    , p.lastname
                    , p.firstname
                    , p.gender
                    , c.age
                    , p.birth
                    , r.dayid
                    , p.cslcount
                    , getnursechkcsllastdata(c.perid, c.csldate) as lastdata 
                from
                    consult c
                    , person p
                    , receipt r
                    , free f 
                where
                    c.csldate >= :startdate 
                    and c.csldate <= :enddate 
                    and c.cancelflg = :cancelflg 
                    and c.cscd = f.freefield1 
                    and f.freecd like :freecd 
                    and f.freeclasscd = :freeclasscd 
                    and c.perid = p.perid 
                    and c.rsvno = r.rsvno(+) 
                order by
                    c.csldate
                    , r.dayid
                    , c.rsvgrpcd
                    , c.orgcd1
                    , c.orgcd2
                    , c.perid
                ";

            // パラメータセット
            var sqlParam = new
            {
                startdate = queryParams["startdate"],
                enddate = queryParams["enddate"],
                freecd = FREECD_LST00041,
                freeclasscd = FREECLASSCD_LST,
                cancelflg = ConsultCancel.Used,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ナースチェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var pageField = (CnDataField)cnObjects["PAGE"];
            var prtDateField = (CnDataField)cnObjects["PRTDATE"];
            var paraCslDateField = (CnDataField)cnObjects["PARACSLDATE"];
            var perIdListField = (CnListField)cnObjects["PERID"];
            var kNameListField = (CnListField)cnObjects["KNAME"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var birthListField = (CnListField)cnObjects["BIRTH"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var cslCountListField = (CnListField)cnObjects["CSLCOUNT"];
            var lastCslDateListField = (CnListField)cnObjects["CSLDATE2"];
            var lastDayIdListField = (CnListField)cnObjects["DAYID2"];
            var lastEndoscopeListField = (CnListField)cnObjects["ENDOSCOPE"];

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
                if (dataCount > 0 && !pageBreakKeyCslDate.Equals(tmpCslDate))
                {
                    // 改ページキーが異なる場合は改ページを行う
                    isPageBreak = true;

                    // 次回のループで今回のデータの処理を行うため
                    // カウントを１つ戻す
                    dataCount--;
                }
                else
                {
                    // 最初のデータの場合
                    // 改ページキーを退避する
                    if (dataCount == 0)
                    {
                        pageBreakKeyCslDate = tmpCslDate;
                    }

                    // 個人ID
                    perIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.PERID).Trim();

                    // カナ氏名
                    kNameListField.ListCell(0, lineCount).Text = 
                        Microsoft.VisualBasic.Strings.StrConv(Util.ConvertToString(detail.LASTKNAME), Microsoft.VisualBasic.VbStrConv.Narrow) + " " +
                        Microsoft.VisualBasic.Strings.StrConv(Util.ConvertToString(detail.FIRSTKNAME), Microsoft.VisualBasic.VbStrConv.Narrow);

                    // 氏名
                    nameListField.ListCell(0, lineCount).Text =
                        Util.ConvertToString(detail.LASTNAME) + "　" + Util.ConvertToString(detail.FIRSTNAME);

                    // 性別
                    string gender = "";
                    switch (Util.ConvertToString(detail.GENDER).Trim())
                    {
                        case "":
                            gender = "";
                            break;
                        case "1":
                            gender = "男";
                            break;
                        default:
                            gender = "女";
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

                    // 当日ID
                    dayIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.DAYID);

                    // 回数
                    cslCountListField.ListCell(0, lineCount).Text = Util.ConvertToString(detail.CSLCOUNT);

                    // 前回情報取得
                    string[] lastData = Util.ConvertToString(detail.LASTDATA).Split(',');
                    Array.Resize(ref lastData, 4);

                    // 前回受診日
                    lastCslDateListField.ListCell(0, lineCount).Text = Util.ConvertToString(lastData[0]);

                    // 前回当日ID
                    lastDayIdListField.ListCell(0, lineCount).Text = Util.ConvertToString(lastData[1]);

                    // 前回胃内視鏡情報
                    if (Util.ConvertToString(lastData[2]).Trim() != "")
                    {
                        lastEndoscopeListField.ListCell(0, lineCount).Text = Util.ConvertToString(lastData[3]);
                    }

                    // 出力行位置をカウントアップする
                    lineCount++;
                }

                // 下記の何れかの場合に改ページ処理を行う
                // ・改ページキーが異なる場合
                // ・ページの最終行に達した場合
                // ・ループの最後のデータの場合
                if (isPageBreak ||
                    lineCount == (perIdListField.ListRows.Length - 1) ||
                    dataCount == (data.Count - 1))
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = pageNo.ToString("0");

                    // 印刷日
                    prtDateField.Text = sysdate;

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
