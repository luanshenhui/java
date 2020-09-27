using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hainsi.Common.Constants;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 女性受診者リスト生成クラス
    /// </summary>
    public class WomanListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002150";

        /// <summary>
        /// 対象コースコード
        /// </summary>
        private const string CSCD1 = "100";
        private const string CSCD2 = "110";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["csldate"], out wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 女性受診者リストデータを読み込む
        /// </summary>
        /// <returns>女性受診者リストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        to_char(consult.csldate, 'YYYY/MM/DD') as csldate
                        , receipt.dayid as dayid
                        , person.lastname || '  ' || person.firstname as name
                        , person.perid as perid
                        , person.cslcount as cslcount
                        , trunc( 
                            getcslage( 
                                person.birth
                                , consult.csldate
                                , to_char(consult.csldate, ('YYYYMMDD'))
                            )
                        ) as age
                        , rsvgrp.rsvgrpname as rsvgrpname 
                    from
                        consult
                        , receipt
                        , person
                        , rsvgrp 
                    where
                        consult.csldate = :csldate
                        and consult.cancelflg = :cancelflg 
                        and consult.cscd in (:cscd1, :cscd2) 
                        and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                        and consult.rsvno = receipt.rsvno 
                        and consult.perid = person.perid 
                        and person.gender = :gender 
                    order by
                        consult.csldate
                        , receipt.dayid
                ";

            // パラメータセット
            var sqlParam = new
            {
                csldate = queryParams["csldate"],
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                cancelflg = ConsultCancel.Used,
                gender = Gender.Female
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">女性受診者リストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var prttimeField = (CnDataField)cnObjects["PRTTIME"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var clsdateField = (CnDataField)cnObjects["CLSDATE"];
            var countListField = (CnListField)cnObjects["COUNT"];
            var dayidListField = (CnListField)cnObjects["DAYID"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var peridListField = (CnListField)cnObjects["PERID"];
            var cslcountListField = (CnListField)cnObjects["CSLCOUNT"];
            var ageListField = (CnListField)cnObjects["AGE"];


            string sysdate = DateTime.Today.ToShortDateString();

            int rowCount = 0;
            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % nameListField.ListRows.Length);

                // No(受診日内連番)
                countListField.ListCell(0, currentLine).Text = Util.ConvertToString(rowCount + 1);
                // 当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);
                // 氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);
                // 個人ID
                peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PERID);
                // 受診回数
                cslcountListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSLCOUNT);
                // 年齢
                ageListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.AGE);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == nameListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = Util.ConvertToString(pageNo);

                    // 印刷日
                    prttimeField.Text = sysdate;

                    // 受診日
                    if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime dt))
                    {
                        clsdateField.Text = dt.ToString("yyyyMMdd");
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
