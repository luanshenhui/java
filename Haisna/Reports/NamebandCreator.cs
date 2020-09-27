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
    /// ネームバンド生成クラス
    /// </summary>
    public class NamebandCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002500";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_NON_CSCD = "NBD%";     //除外コース情報
        
        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //受診日チェック
            if (!DateTime.TryParse(queryParams["startdate"], out DateTime strDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            //当日IDチェック
            string strDayID = queryParams["strDayid"];

            if ( !string.IsNullOrEmpty(strDayID) )
            {
                //当日IDの入力がある場合、数値チェック
                string message = WebHains.CheckNumeric("開始当日ID", strDayID, (int)LengthConstants.LENGTH_RECEIPT_DAYID);
                if( !string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                }
            }

            string endDayID = queryParams["endDayid"];
            if (!string.IsNullOrEmpty(endDayID))
            {
                //当日IDの入力がある場合、数値チェック
                string message = WebHains.CheckNumeric("終了当日ID", endDayID, (int)LengthConstants.LENGTH_RECEIPT_DAYID);
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                }
            }

            return messages;
        }

        /// <summary>
        /// ネームバンドデータを読み込む
        /// </summary>
        /// <returns>ネームバンドデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    receipt.dayid as dayid
                    , consult.csldate as csldate
                    , consult.rsvno as rsvno
                    , to_char(consult.csldate, 'YYYY/MM/DD') as ccsldate
                    , person.romename as ename
                    , person.lastkname || ' ' || person.firstkname as kname
                    , person.lastname || '　' || person.firstname as name
                    , to_char(person.birth, 'YYYY/MM/DD') as birthday
                    , person.gender as gendercd
                    , decode(person.gender, 1, 'M', 2, 'F') as gender
                    , consult.perid as perid 
                from
                    consult
                    , receipt
                    , person 
                where
                    consult.csldate = :startdate 
                    and consult.cancelflg = :cancelflg 
                    and consult.rsvno = receipt.rsvno 
                    and consult.perid = person.perid 
                ";

            //当日IDの指定がある場合
            string strDayId = queryParams["strDayid"];
            string endDayId = queryParams["endDayid"];

            if (! string.IsNullOrEmpty(strDayId))
            {
                if ( string.IsNullOrEmpty(endDayId))
                {
                    //終了指定がない場合は、開始当日IDを設定
                    endDayId = strDayId;
                }
                sql += @"
                    and receipt.dayid between :startdayId and :enddayId 
                ";
            }

            //コースコード指定
            string csCd = queryParams["cscd"].Trim();
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                    and consult.cscd = :cscd 
                ";
            }

            sql += @"
                    and ( 
                        not exists ( 
                            select
                                free.freefield1 
                            from
                                free 
                            where
                                free.freecd like :freecd_non_cs 
                                and free.freefield1 = consult.cscd
                        )
                    ) 
                order by
                    consult.csldate
                    , receipt.dayid
                ";

            // パラメータセット
            var sqlParam = new
            {
                startdate = queryParams["startdate"],
                startdayId = strDayId,
                enddayId = endDayId,
                cscd = csCd,
                cancelflg = ConsultCancel.Used,

                freecd_non_cs = FREECD_NON_CSCD
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }
        
        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ネームバンドデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {

            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            string sysdate = DateTime.Today.ToShortDateString();

            var barcodeField = (CnBarcodeField)cnObjects["BARCODE"];
            var dayidTextField = (CnTextField)cnObjects["DAYID"];
            var peridTextField = (CnTextField)cnObjects["PERID"];
            var nameTextField = (CnTextField)cnObjects["NAME"];
            var birthTextField = (CnTextField)cnObjects["BIRTH"];
            var genderTextField = (CnTextField)cnObjects["GENDER"];

            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach ( var detail in data )
            {

                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //バーコード
                barcodeField.Data = "A"+ Util.ConvertToString(detail.DAYID) + "A";

                //当日ID
                dayidTextField.Text = Util.ConvertToString(detail.DAYID);

                //個人ID
                peridTextField.Text = Util.ConvertToString(detail.PERID);

                //氏名
                nameTextField.Text = Util.ConvertToString(detail.NAME);

                //生年月日
                if (!string.IsNullOrEmpty(Util.ConvertToString(detail.BIRTHDAY)))
                {
                    DateTime.TryParse(detail.BIRTHDAY, out DateTime birth);
                    birthTextField.Text = birth.ToString("yyyy年MM月dd日");
                }

                //性別
                genderTextField.Text = Util.ConvertToString(detail.GENDER);

                //カウントアップ
                pageNo++;

                // ドキュメントの出力
                PrintOut(cnForm);

            }

        }


    }
}
