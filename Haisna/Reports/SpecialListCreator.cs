using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 特定健診受診者リスト生成クラス
    /// </summary>
    public class SpecialListCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002160";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_LSTSPC = "SPC%";

        /// <summary>
        /// 特定保健指導項目コード
        /// </summary>
        private const string ITEMCD = "64074";

        /// <summary>
        /// 特定保健指導項目コードサフィックス
        /// </summary>
        private const string SUFFIX = "00";

        /// <summary>
        /// 契約パターンオプション（特定健診階層化）
        /// </summary>
        private const string CLASSCD = "660";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["senddate"], out wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 特定健診受診者データを読み込む
        /// </summary>
        /// <returns>特定健診受診者データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    to_char(consult.csldate, 'YYYY/MM/DD') as csldate
                    , receipt.dayid as dayid
                    , person.lastname || ' ' || person.firstname as name
                    , person.perid as perid
                    , trunc(consult.age) as age
                    , ( 
                        select
                            decode(count(free.freecd), 0, '', '○') 
                        from
                            free 
                        where
                            free.freecd like :freecd
                            and free.freefield1 = consult.orgcd1 
                            and free.freefield2 = consult.orgcd2 
                            and trunc(consult.age) between to_number(free.freefield3) and to_number(free.freefield4) 
                            and consult.csldate between free.freefield5 and free.freefield6
                    ) as perrsl
                    , fc_get_result(consult.rsvno, :itemcd, :suffix) as guidance
                    , to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') as prttime 
                from
                    consult
                    , receipt
                    , consult_o
                    , ctrpt_opt
                    , person 
                where
                    consult.csldate = to_date(:senddate, 'YYYY/MM/DD') 
                    and consult.cancelflg = 0 
                    and consult.rsvno = receipt.rsvno 
                    and consult.rsvno = consult_o.rsvno 
                    and consult.ctrptcd = consult_o.ctrptcd 
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                    and consult_o.optcd = ctrpt_opt.optcd 
                    and consult_o.optbranchno = ctrpt_opt.optbranchno 
                    and ctrpt_opt.setclasscd = :classcd 
                    and consult.perid = person.perid 
                order by
                    consult.csldate
                    , receipt.dayid
                ";

            // パラメータセット
            var sqlParam = new
            {
                senddate = queryParams["senddate"],
                freecd = FREECD_LSTSPC,
                itemcd = ITEMCD,
                suffix = SUFFIX,
                classcd = CLASSCD
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">特定健診受診者データ</param>
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
            var ageListField = (CnListField)cnObjects["AGE"];
            var perrslListField = (CnListField)cnObjects["PERRSL"];
            var guidanceListField = (CnListField)cnObjects["GUIDANCE"];

            string sysdate = DateTime.Now.ToString();

            short currentLine = 0;
            int pageNo = 0;
            int rowCount = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // No(受診日内連番)
                countListField.ListCell(0, currentLine).Text = Util.ConvertToString(currentLine + 1 + (pageNo * countListField.ListRows.Length));
                //当日ID
                dayidListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.DAYID);
                //氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);
                //個人ID
                peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PERID);
                //年齢
                ageListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.AGE);
                //対象区分
                perrslListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PERRSL);
                //指導区分
                guidanceListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.GUIDANCE);


                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == countListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // 現在ページおよび日付の編集
                    pageField.Text = Util.ConvertToString(pageNo);
                    prttimeField.Text = sysdate;
                    clsdateField.Text = Util.ConvertToString(queryParams["senddate"]).Replace("/","");

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 現在編集行のリセット
                    currentLine = 0;
                }

                currentLine++;

                // 行カウントをインクリメント
                rowCount++;
            }
        }
    }
}
