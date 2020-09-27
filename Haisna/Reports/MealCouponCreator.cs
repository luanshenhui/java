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
    /// 面接案内・お食事引換券生成クラス
    /// </summary>
    public class MealCouponCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002370";

        /// <summary>
        /// 汎用分類コード（帳票固有設定用）
        /// </summary>
        private const string FREECLASSCD_LST = "LST";

        /// <summary>
        /// 汎用コード（面接・食事券）
        /// </summary>
        private const string FREECD_LST000420 = "LST00420%";

        /// <summary>
        /// 誘導検査分類コード
        /// </summary>
        private const string KT1_KENSABUNRUI = "100320";
        private const string KT2_KENSABUNRUI = "100300";
        private const string M1_KENSABUNRUI = "100290";
        private const string M2_KENSABUNRUI = "100293";

        /// <summary>
        /// 食事内容初期値
        /// </summary>
        private const string MEAL_KIND = "A";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParseExact(queryParams["csldate"], "yyyymmdd", null, System.Globalization.DateTimeStyles.None, out DateTime wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            if (!int.TryParse(queryParams["rsvno"], out int wkID))
            {
                messages.Add("予約番号が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 面接案内・お食事引換券データを読み込む
        /// </summary>
        /// <returns>面接案内・お食事引換券データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    to_char(consult.csldate, 'YYYY/MM/DD') as m_csldate
                    , receipt.dayid as m_dayid
                    , person.perid as m_perid
                    , person.lastkname || ' ' || person.firstkname as m_kname
                    , person.lastname || ' ' || person.firstname || '    様' as m_name
                    , person.compperid as m_compperid
                    , person.romename as m_romename
                    , to_char(person.birth, 'YYYY/MM/DD') as m_birthday
                    , trunc( 
                        getcslage( 
                            to_char(person.birth, 'YYYYMMDD')
                            , consult.csldate
                            , to_char(consult.csldate, 'YYYYMMDD')
                        )
                    ) || '歳  ' || '(' || trunc(consult.age) || '歳) ' as m_age
                    , decode(person.gender, 1, '男性', 2, '女性') as m_gender
                    , kt1.zyushin_taisyo_kubun as taisyokubun
                    , decode( 
                        kt1.yoyaku_zikan
                        , null
                        , ''
                        , to_char(kt1.yoyaku_zikan, 'HH24:MI')
                    ) as mensetuzikann
                    , decode( 
                        kt2.yoyaku_zikan
                        , null
                        , ''
                        , to_char(kt2.yoyaku_zikan, 'HH24:MI')
                    ) as syokuzizikan 
                from
                    consult
                    , person
                    , receipt
                    , free
                    , kenshin_trans kt1
                    , kenshin_trans kt2 
                where
                    consult.rsvno = :rsvNo
                    and consult.cancelflg = :cancelflg
                    and consult.perid = person.perid 
                    and consult.rsvno = receipt.rsvno 
                    and consult.rsvno = kt1.rsvno 
                    and kt1.yudo_kensa_bunrui_code = :kt1KensaBunrui 
                    and consult.rsvno = kt2.rsvno(+) 
                    and :kt2KensaBunrui = kt2.yudo_kensa_bunrui_code(+) 
                    and free.freecd like :freecd
                    and free.freeclasscd = :freeclasscd 
                    and free.freefield1 = consult.cscd
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvNo = queryParams["rsvno"],
                freecd = FREECD_LST000420,
                freeclasscd = FREECLASSCD_LST,
                kt1KensaBunrui = KT1_KENSABUNRUI,
                kt2KensaBunrui = KT2_KENSABUNRUI,
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">面接案内・お食事引換券データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var m_dayidField = (CnDataField)cnObjects["M_DAYID"];
            var m_nameField = (CnDataField)cnObjects["M_NAME"];
            var m_romenameField = (CnDataField)cnObjects["M_ROMENAME"];
            var s_dayidField = (CnDataField)cnObjects["S_DAYID"];
            var s_nameField = (CnDataField)cnObjects["S_NAME"];
            var s_romenameField = (CnDataField)cnObjects["S_ROMENAME"];
            var mensetuzikannField = (CnDataField)cnObjects["MENSETUZIKANN"];
            var mm_dayidField = (CnDataField)cnObjects["MM_DAYID"];
            var mm_nameField = (CnDataField)cnObjects["MM_NAME"];
            var mm_romenameField = (CnDataField)cnObjects["MM_ROMENAME"];
            var m_peridField = (CnDataField)cnObjects["M_PERID"];
            var m_birthdayField = (CnDataField)cnObjects["M_BIRTHDAY"];
            var m_ageField = (CnDataField)cnObjects["M_AGE"];
            var mday1Field = (CnDataField)cnObjects["MDAY1"];
            var mday2Field = (CnDataField)cnObjects["MDAY2"];
            var mtime1Field = (CnDataField)cnObjects["MTIME1"];
            var mtime2Field = (CnDataField)cnObjects["MTIME2"];
            var l_choiceText = (CnText)cnObjects["L_CHOICE"];
            var l_mainuText = (CnText)cnObjects["L_MAINU"];
            var l_mainbuText = (CnText)cnObjects["L_MAINBU"];
            var b_sub1Box = (CnBox)cnObjects["B_SUB1"];
            var b_sub2Box = (CnBox)cnObjects["B_SUB2"];
            var b_sub3Box = (CnBox)cnObjects["B_SUB3"];
            var l_sub1Text = (CnText)cnObjects["L_SUB1"];
            var l_sub2Text = (CnText)cnObjects["L_SUB2"];
            var l_subb2Text = (CnText)cnObjects["L_SUBB2"];
            var l_sub3Text = (CnText)cnObjects["L_SUB3"];
            var l_sub1_eText = (CnText)cnObjects["L_SUB1_E"];
            var l_sub2_eText = (CnText)cnObjects["L_SUB2_E"];
            var l_sub3_eText = (CnText)cnObjects["L_SUB3_E"];
            var l_biopsyText = (CnText)cnObjects["L_BIOPSY"];
            var l_bText = (CnText)cnObjects["L_B"];

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 受診番号（面接）
                m_dayidField.Text = Util.ConvertToString(detail.M_DAYID);
                // 氏名（面接）
                m_nameField.Text = Util.ConvertToString(detail.M_NAME);
                // ローマ字氏名（面接）
                m_romenameField.Text = Util.ConvertToString(detail.M_ROMENAME);
                // 個人ID（面接）
                m_peridField.Text = Util.ConvertToString(detail.M_PERID);
                // 生年月日（面接）
                m_birthdayField.Text = Util.ConvertToString(detail.M_BIRTHDAY);
                // 年齢（面接）
                m_ageField.Text = Util.ConvertToString(detail.M_AGE);

                //同伴者の取得（受診番号・氏名・ローマ字氏名）
                var companionData = GetCompanion(queryParams["csldate"], queryParams["rsvno"]);
                if (companionData == null)
                {
                    s_dayidField.Text = string.Empty;
                    s_nameField.Text = string.Empty;
                    s_romenameField.Text = string.Empty;
                }
                else
                {
                    s_dayidField.Text = Util.ConvertToString(companionData.S_DAYID);
                    s_nameField.Text = Util.ConvertToString(companionData.S_NAME);
                    s_romenameField.Text = Util.ConvertToString(companionData.S_ROMENAME);
                }

                // 面接予定時間
                mensetuzikannField.Text = (Util.ConvertToString(detail.TAISYOKUBUN) == "Y") ? Util.ConvertToString(detail.MENSETUZIKANN) : "面接キャンセル";

                // 受診番号－食
                mm_dayidField.Text = Util.ConvertToString(detail.M_DAYID);
                // 氏名－食
                mm_nameField.Text = Util.ConvertToString(detail.M_NAME);
                // ローマ字氏名－食
                mm_romenameField.Text = Util.ConvertToString(detail.M_ROMENAME);
                // 発行日
                mday1Field.Text = Util.ConvertToString(detail.M_CSLDATE);
                mday2Field.Text = Util.ConvertToString(detail.M_CSLDATE);
                // お食事開始可能時間
                mtime1Field.Text = Util.ConvertToString(detail.SYOKUZIZIKAN);
                mtime2Field.Text = Util.ConvertToString(detail.SYOKUZIZIKAN);


                l_choiceText.Visible = false;
                l_mainuText.Visible = false;
                l_mainbuText.Visible = false;
                b_sub3Box.Visible = false;
                l_sub2Text.Visible = false;
                l_subb2Text.Visible = false;
                l_sub3Text.Visible = false;
                l_sub3_eText.Visible = false;
                l_biopsyText.Visible = false;
                l_bText.Visible = false;


                // お食事内容の取得
                // 通常食をデフォルト設定
                string mealKind = MEAL_KIND;
                string mealKindValue = GetMealContents(queryParams["csldate"], queryParams["rsvno"]);

                if (mealKindValue != string.Empty )
                {
                    mealKind = mealKindValue;
                }

                if (mealKind == MEAL_KIND)
                {
                    l_choiceText.Visible = true;
                    l_mainuText.Visible = true;
                    b_sub3Box.Visible = true;
                    l_sub2Text.Visible = true;
                    l_sub3Text.Visible = true;
                    l_sub3_eText.Visible = true;
                }
                else
                {
                    l_mainbuText.Visible = true;
                    l_subb2Text.Visible = true;
                    l_biopsyText.Visible = true;
                    l_bText.Visible = true;
                }

                // ドキュメントの出力
                PrintOut(cnForm);

            }
        }

        /// <summary>
        /// 対象データ取得（同伴者）
        /// </summary>
        /// <param name="csldate">予約番号</param>
        /// <param name="rsvno">受診日</param>
        /// <returns></returns>
        private dynamic GetCompanion(string csldate,string rsvno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    b.dayid as s_dayid
                    , a.lastkname || ' ' || a.firstkname as s_kname
                    , a.lastname || ' ' || a.firstname || '    様' as s_name
                    , a.romename as s_romename
                    , b.rsvno as s_rsvno 
                from
                    person a
                    , kenshin_trans b 
                where
                    a.perid = usp_dohansya_func(:cslDate,:rsvNo ) 
                    and a.perid = b.perid 
                    and b.cslymd = :cslDate
                    and rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                cslDate = csldate,
                rsvNo = rsvno
            };

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();

        }

        /// <summary>
        /// 対象データ取得（お食事内容）
        /// </summary>
        /// <param name="csldate">予約番号</param>
        /// <param name="rsvno">受診日</param>
        /// <returns></returns>
        private string GetMealContents(string csldate, string rsvno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    decode( 
                        nvl(min(gaishutsu_kubun), '')
                        , '1'
                        , 'B'
                        , '3'
                        , 'B'
                        , 'Y'
                        , 'B'
                        , 'A'
                    ) as tuuzyou 
                from
                    kenshin_trans 
                where
                    yudo_kensa_bunrui_code in (:m1kensabunrui, :m2kensabunrui) 
                    and rsvno = :rsvNo
                    and cslymd = :cslDate
                group by
                    rsvno
                ";

            // パラメータセット
            var sqlParam = new
            {
                cslDate = csldate,
                rsvNo = rsvno,
                m1kensabunrui = M1_KENSABUNRUI,
                m2kensabunrui = M2_KENSABUNRUI
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault(); ;

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.TUUZYOU));
        }
    }
}
