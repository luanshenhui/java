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
    /// フォローアップ対象者リスト
    /// </summary>
    public class FollowListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002170";

        /// <summary>
        /// 対象コースコード（100:一日人間ドック、110:企業健診）
        /// </summary>
        private const string TARGET_CSCD1 = "100";
        private const string TARGET_CSCD2 = "110";

        /// <summary>
        /// 汎用コード（フォローアップ判定分類）
        /// </summary>
        private const string FREECD_FOLJUDCL = "FOLJUDCL%";

                /// <summary>
        /// 汎用コード（フォローアップ　対象判定）
        /// </summary>
        private const string FREECD_FOLJUD = "FOLJUD00%";


        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["ssenddate"], out wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// フォローアップ対象者リストデータを読み込む
        /// </summary>
        /// <returns>フォローアップ対象者リストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
				select to_char(consult.csldate,'YYYY/MM/DD')    as csldate 
				      ,receipt.dayid           as dayid 
				      ,person.lastname || ' ' || person.firstname  as name 
				      ,judrsl.judclasscd       as judclasscd 
				      ,judclass.judclassname   as judclassname 
				  from consult 
				      ,receipt 
				      ,person 
				      ,judrsl 
				      ,judclass 
				 where consult.csldate = :ssenddate 
				   and consult.cancelflg = :cancelflg
				   and consult.cscd     in (:cscd1,:cscd2) 
				   and consult.perid    = person.perid 
				   and consult.rsvno    = receipt.rsvno 
				   and receipt.comedate is not null 
				   and consult.rsvno    = judrsl.rsvno 
				   and judrsl.judclasscd in (select free.freefield1 
				                               from free 
				                              where free.freecd like :freecd_foljudcl) 
				   and judrsl.judcd      in (select free1.freefield1 judcd 
				                               from free 
				                                   ,free free1 
				                              where free.freecd like :freecd_foljudcl 
				                                and free.freefield1 = judrsl.judclasscd 
				                                and free.freeclasscd = free1.freeclasscd 
				                                and free1.freecd like :freecd_foljud) 
				   and judrsl.judclasscd    = judclass.judclasscd 
				 order by consult.csldate 
				        , receipt.dayid 
				        , judrsl.judclasscd

                ";

            // パラメータセット
            var sqlParam = new
            {
                ssenddate = queryParams["ssenddate"],
                cscd1=TARGET_CSCD1,
                cscd2=TARGET_CSCD2,
                freecd_foljudcl = FREECD_FOLJUDCL,
                freecd_foljud=FREECD_FOLJUD,
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">フォローアップ対象者リストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット

            var printDateField = (CnDataField)cnObjects["PRINTDATE"];
            var pageNoField = (CnDataField)cnObjects["PAGE"];
            var cslDateField = (CnDataField)cnObjects["CLSDATE"];
            var dayIdListField = (CnListField)cnObjects["DAYID"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var judClassNameListField = (CnListField)cnObjects["JUDCLASSNAME"];

            string sysdate = DateTime.Today.ToShortDateString();

            int rowCount = 0;
            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % dayIdListField.ListRows.Length);

                // 当日ＩＤ
                dayIdListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);

                // 氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);

                // 検査項目
                judClassNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.JUDCLASSNAME);

                //Console.WriteLine(WebHains.ORGCD1_PERSON);


                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == nameListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageNoField.Text = Util.ConvertToString(pageNo);

                    // 印刷日
                    printDateField.Text = sysdate;

                    // 受診日
                    if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime dt))
                    {
                        cslDateField.Text = dt.ToString("yyyy/MM/dd");
                    }

                    // ドキュメントの出力
                    PrintOut(cnForm);
                }

                // 行カウントをインクリメント
                rowCount++;
            }
        }

    }
}
