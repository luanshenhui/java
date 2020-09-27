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
    /// 郵便物受領書（成績書）生成クラス
    /// </summary>
    public class PostReportCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002330";

        /// <summary>
        /// その他コースコード
        /// </summary>
        private const string CSCD_OTHER01 = "100";
        private const string CSCD_OTHER02 = "110";
        private const string CSCD_OTHER03 = "170";
        private const string CSCD_OTHER04 = "150";

        /// <summary>
        /// :paymentdate
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            string wkStaDate = queryParams["startdate"];
            string wkEndDate = queryParams["enddate"];

            DateTime wkDate;
            //終了日が未設定の場合は開始日を設定
            if (!DateTime.TryParse(wkEndDate, out wkDate))
            {
                wkEndDate = wkStaDate;
            }

            //入力チェック
            if (!DateTime.TryParse(wkStaDate, out wkDate))
            {
                messages.Add("開始日が正しくありません。");
            }

            if (!DateTime.TryParse(wkEndDate, out wkDate))
            {
                messages.Add("終了日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 郵便物受領書（成績書）データを読み込む
        /// </summary>
        /// <returns>郵便物受領書（成績書）データ</returns>
        protected override List<dynamic> GetData()
        {

            string sql = @"
                select
                    repsend.rsvno as rsvno
                    , person.lastname || ' ' || person.firstname as name
                    , to_date( 
                        to_char(repsend.reportsenddate, 'YYYY/MM/DD')
                        , 'YYYY/MM/DD'
                    ) as reportsenddate
                    , course_p.csname as csname 
                from
                    consult_repsend repsend
                    , consult
                    , person
                    , course_p 
                where
                    repsend.reportsenddate between to_date(:startdate, 'YYYY/MM/DD') and to_date(:enddate, 'YYYY/MM/DD HH24MISS')
                    and repsend.rsvno = consult.rsvno 
                ";

            //発送者ID入力あり
            if ( queryParams["loginId"].Trim() != "")
            {
                sql += @"
                    and repsend.chargeuser = :loginID 
                ";
            }

            //コース入力あり
            string cscd_p = queryParams["cscd"];
            if (cscd_p.Trim() != "")
            {
                if (cscd_p.Trim() == "999")
                {
                    //その他の場合
                    sql += @"
                    and consult.cscd not in (:other_cscd01, :other_cscd02, :other_cscd03, :other_cscd04) 
                    ";
                }
                else
                {
                    //コース指定
                    sql += @"
                    and consult.cscd = :cscd 
                    ";
                }
            }

            sql += @"
                    and consult.perid = person.perid 
                    and consult.cscd = course_p.cscd 
                order by
                    course_p.csname
                    , repsend.reportsenddate
                ";

            string wkStaDate = queryParams["startdate"];
            string wkEndDate = queryParams["enddate"];

            if (!DateTime.TryParse(wkEndDate, out DateTime wkDate))
            {
                //終了日指定がない場合は開始日を設定
                wkEndDate = wkStaDate;
            }

            // パラメータセット
            var sqlParam = new
            {
                startdate = wkStaDate,
                enddate = wkEndDate + " 235959",
                loginID = queryParams["loginId"],

                cscd = queryParams["cscd"],
                other_cscd01 = CSCD_OTHER01,
                other_cscd02 = CSCD_OTHER02,
                other_cscd03 = CSCD_OTHER03,
                other_cscd04 = CSCD_OTHER04
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">郵便物受領書（成績書）データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var reportsenddateField = (CnDataField)cnObjects["REPORTSENDDATE"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var csnameField = (CnDataField)cnObjects["CSNAME"];
            var noListField = (CnListField)cnObjects["No."];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;
            int outCnt = 0;

            //発送日
            DateTime reportSendDate;
            DateTime.TryParse(Util.ConvertToString(data[0].REPORTSENDDATE), out reportSendDate);

            //コース名
            string csName = Util.ConvertToString(data[0].CSNAME);

            //キー設定
            string newKey = reportSendDate.ToString("yyyy/MM/dd");
            string oldKey = newKey;

            string newKey2 = csName;
            string oldKey2 = newKey2;

            short currentLine = 0;

            long outNo = 0;

            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //発送日
                DateTime.TryParse(Util.ConvertToString(detail.REPORTSENDDATE), out reportSendDate);

                //コース名
                csName = Util.ConvertToString(detail.CSNAME);

                //キー設定
                newKey = reportSendDate.ToString("yyyy/MM/dd");
                newKey2 = csName;

                // ページ内最大行に達した場合、またはキーが異なった場合に改ページ
                if ( (currentLine == noListField.ListRows.Length) || (newKey != oldKey) || (newKey2 != oldKey2) )
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // 発送日
                    reportsenddateField.Text = oldKey;

                    // コース名
                    csnameField.Text = oldKey2;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    //現在編集行のリセット
                    currentLine = 0;

                    //キーブレイクによる改ページ処理
                    if (newKey != oldKey)
                    {
                        oldKey = newKey;
                        outNo = 0;
                    }

                    //キーブレイクによる改ページ処理
                    if (newKey2 != oldKey2)
                    {
                        oldKey2 = newKey2;
                        outNo = 0;
                    }

                }

                //受取人氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);
                //No.
                noListField.ListCell(0, currentLine).Text = (outNo + 1).ToString();

                // 行カウントをインクリメント
                currentLine++;

                // 件数をインクリメント
                outCnt++;

                // 連番をインクリメント
                outNo++;

            }

            //終了処理
            if (outCnt > 0)
            {
                pageNo++;

                // ページ番号
                pageField.Text = pageNo.ToString();

                // 発送日
                reportsenddateField.Text = oldKey;

                // コース名
                csnameField.Text = oldKey2;

                // ドキュメントの出力
                PrintOut(cnForm);

                //現在編集行のリセット
                currentLine = 0;

            }

        }

    }
}
