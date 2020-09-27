using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Drawing;

namespace Hainsi.Reports
{
    /// <summary>
    /// 健診スケジュール表生成クラス
    /// </summary>
    public class Schedule_menPMCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002380";

        /// <summary>
        /// 検査分類分類コード
        /// </summary>
        string BUNRUI_CODE1 = "100050";
        string BUNRUI_CODE2 = "100070";
        string BUNRUI_CODE3 = "100060";
        string BUNRUI_CODE4 = "100080";
        string BUNRUI_CODE5 = "100090";
        string BUNRUI_CODE6 = "100110";
        string BUNRUI_CODE7 = "100120";
        string BUNRUI_CODE8 = "100130";
        string BUNRUI_CODE9 = "100140";
        string BUNRUI_CODE10 = "100150";
        string BUNRUI_CODE11 = "100220";
        string BUNRUI_CODE12 = "100180";
        string BUNRUI_CODE13 = "100190";
        string BUNRUI_CODE14 = "100200";
        string BUNRUI_CODE15 = "100230";
        string BUNRUI_CODE16 = "100240";
        string BUNRUI_CODE17 = "100250";
        string BUNRUI_CODE18 = "100285";
        string BUNRUI_CODE19 = "100260";
        string BUNRUI_CODE20 = "100270";
        string BUNRUI_CODE21 = "100100";
        string BUNRUI_CODE22 = "100210";
        string BUNRUI_CODE23 = "100380";
        string BUNRUI_CODE24 = "100390";
        string BUNRUI_CODE25 = "100400";

        /// <summary>
        /// 受診対象区分
        /// </summary>
        string TAISYO_KBN = "Y";

        /// <summary>
        /// 対象外部屋番号マーク
        /// </summary>
        string NOT_ROOMNO_MARK = "×";

        /// <summary>
        /// 対象外部屋名称色
        /// </summary>
        Color NOT_ROOMNAME_COLOR = Color.FromArgb(204, 204, 204);

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (string.IsNullOrEmpty(queryParams["perid"]))
            {
                messages.Add("個人ＩＤが正しくありません。");
            }

            if (string.IsNullOrEmpty(queryParams["rsvno"]))
            {
                messages.Add("予約番号が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["cslymd"], out DateTime wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 健診スケジュール表データを読み込む
        /// </summary>
        /// <returns>健診スケジュール表データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    c.dayid as dayid
                    , b.lastkname || ' ' || b.firstkname as kname
                    , b.lastname || ' ' || b.firstname as name
                    , to_char(c.csldate, 'yyyy/mm/dd') as csldate
                    , b.perid as perid
                    , a.rsvno as rsvno 
                from
                    consult a 
                    inner join person b 
                        on a.perid = b.perid 
                    inner join receipt c 
                        on a.rsvno = c.rsvno 
                        and a.csldate = c.csldate 
                where
                    b.perid = :perid
                    and a.rsvno = :rsvno
                    and a.csldate = :cslymd
                    and a.cancelflg = :cancelflg
                order by
                    c.dayid
                    , c.cntlno
                ";

            // パラメータセット
            var sqlParam = new
            {
                perid = queryParams["perid"],
                rsvno = queryParams["rsvno"],
                cslymd = queryParams["cslymd"],
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">健診スケジュール表データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var dayIdField = (CnDataField)cnObjects["DAYID"];
            var nameField = (CnDataField)cnObjects["NAME"];
            var cslDateField = (CnDataField)cnObjects["CSLDATE"];
            var perIdField = (CnDataField)cnObjects["PERID"];

            var bRoomNoField = new List<CnDataField>();
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO1"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO2"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO3"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO4"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO5"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO6"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO7"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO8"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO9"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO10"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO11"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO12"]);
            bRoomNoField.Add((CnDataField)cnObjects["BROOMNO13"]);

            var bRoomField = new List<CnDataField>();
            bRoomField.Add((CnDataField)cnObjects["BROOM1"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM2"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM3"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM4"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM5"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM6"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM7"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM8"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM9"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM10"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM11"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM12"]);
            bRoomField.Add((CnDataField)cnObjects["BROOM13"]);

            var cRoomNoField = new List<CnDataField>();
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO1"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO2"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO3"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO4"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO5"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO6"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO7"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO8"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO9"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO10"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO11"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO12"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO13"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO14"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO15"]);
            cRoomNoField.Add((CnDataField)cnObjects["CROOMNO16"]);

            var cRoomField = new List<CnDataField>();
            cRoomField.Add((CnDataField)cnObjects["CROOM1"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM2"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM3"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM4"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM5"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM6"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM7"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM8"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM9"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM10"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM11"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM12"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM13"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM14"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM15"]);
            cRoomField.Add((CnDataField)cnObjects["CROOM16"]);

            var msgListField = (CnListField)cnObjects["MSG"];

            // ページ内の項目に値をセット
            var detail = data[0];

            // キャンセルされた場合キャンセル用の例外をThrowする
            CheckCanceled();

            // 当日ＩＤ
            dayIdField.Text = Util.ConvertToString(detail.DAYID);

            // 氏名
            nameField.Text = Util.ConvertToString(detail.NAME);

            // 受診日
            if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime cslDate))
            {
                cslDateField.Text = cslDate.ToString("yyyy/MM/dd");
            }

            // 個人ＩＤ
            perIdField.Text = Util.ConvertToString(detail.PERID);

            // 検査分類の取得

            // パラメータ受診日編集
            string paramCslYmd = "";

            if (DateTime.TryParse(Util.ConvertToString(queryParams["cslymd"]), out DateTime cslYmd))
            {
                paramCslYmd = cslYmd.ToString("yyyyMMdd");
            }

            dynamic kensaBunrui = GetInspecionClass(queryParams["perid"], queryParams["rsvno"], paramCslYmd);

            // Ｂ部屋名称
            bRoomField[0].Text = "身体測定";
            bRoomField[1].Text = "血圧";
            bRoomField[2].Text = "採血";
            bRoomField[3].Text = "胸部Ｘ線";
            bRoomField[4].Text = "心電図";

            // Ｂ部屋番号・Ｂ部屋名称色            
            if (Util.ConvertToString(kensaBunrui.SHINTAI).Equals("1"))
            {
                bRoomNoField[0].Text = "１";
            }
            else
            {
                bRoomNoField[0].Text = NOT_ROOMNO_MARK;
                bRoomField[0].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.GETU).Equals("1"))
            {
                bRoomNoField[1].Text = "２";
            }
            else
            {
                bRoomNoField[1].Text = NOT_ROOMNO_MARK;
                bRoomField[1].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.SAGETU).Equals("1"))
            {
                bRoomNoField[2].Text = "３";
            }
            else
            {
                bRoomNoField[2].Text = NOT_ROOMNO_MARK;
                bRoomField[2].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.HUKUX).Equals("1"))
            {
                bRoomNoField[3].Text = "５";
            }
            else
            {
                bRoomNoField[3].Text = NOT_ROOMNO_MARK;
                bRoomField[3].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.SHINDENZU).Equals("1"))
            {
                bRoomNoField[4].Text = "９";
            }
            else
            {
                bRoomNoField[4].Text = NOT_ROOMNO_MARK;
                bRoomField[4].TextColor = NOT_ROOMNAME_COLOR;
            }

            // Ｃ部屋名称
            cRoomField[0].Text = "聴力";
            cRoomField[1].Text = "視力";
            cRoomField[2].Text = "眼圧・眼底";
            cRoomField[3].Text = "聴診/触診";
            cRoomField[4].Text = "メンタルチェック";
            cRoomField[5].Text = "Ｃホール２カウンター";

            // Ｃ部屋番号・Ｃ部屋名称色
            if (Util.ConvertToString(kensaBunrui.TYORYOKU).Equals("1"))
            {
                cRoomNoField[0].Text = "１６";
            }
            else
            {
                cRoomNoField[0].Text = NOT_ROOMNO_MARK;
                cRoomField[0].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.SIRYOKU).Equals("1"))
            {
                cRoomNoField[1].Text = "０";
            }
            else
            {
                cRoomNoField[1].Text = NOT_ROOMNO_MARK;
                cRoomField[1].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.GANATU).Equals("1"))
            {
                cRoomNoField[2].Text = "１９";
            }
            else
            {
                cRoomNoField[2].Text = NOT_ROOMNO_MARK;
                cRoomField[2].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.SHINSATU).Equals("1"))
            {
                cRoomNoField[3].Text = "２０";
            }
            else
            {
                cRoomNoField[3].Text = NOT_ROOMNO_MARK;
                cRoomField[3].TextColor = NOT_ROOMNAME_COLOR;
            }

            if (Util.ConvertToString(kensaBunrui.MENTARU).Equals("1"))
            {
                cRoomNoField[4].Text = "１８";
            }
            else
            {
                cRoomNoField[4].Text = NOT_ROOMNO_MARK;
                cRoomField[4].TextColor = NOT_ROOMNAME_COLOR;
            }

            // メッセージ
            msgListField.ListCell(0, 0).Text = "本日は上記の順番で検査を回っていただきます。";
            msgListField.ListCell(0, 1).Text = "最初の検査は身体測定です。";
            msgListField.ListCell(0, 2).Text = "係の者が番号をお呼びしますので、席でお待ちください。";
            msgListField.ListCell(0, 3).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願いいたします。";

            // ドキュメントの出力
            PrintOut(cnForm);
        }

        /// <summary>
        /// 検査分類を取得
        /// </summary>
        /// <param name="perid">個人ＩＤ</param>
        /// <param name="rsvno">予約番号</param>
        /// <param name="clsymd">受診日</param>
        /// <returns></returns>
        private dynamic GetInspecionClass(string perid, string rsvno, string cslymd)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    count(decode(yudo_kensa_bunrui_code, :bunruiCode1, 1)) as ori
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode2, 1)) as shintai
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode3, 1)) as getu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode4, 1)) as sagetu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode5, 1)) as hukuecho
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode6, 1)) as hukux
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode7, 1)) as hukuct
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode8, 1)) as shindenzu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode9, 1)) as gotu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode10, 1)) as hai
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode11, 1)) as shinsatu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode12, 1)) as siryoku
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode13, 1)) as ganatu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode14, 1)) as tyoryoku
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode15, 1)) as mentaru
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode16, 1)) as icheck
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode17, 1)) as ix
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode18, 1)) as naisi
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode19, 1)) as hujinshinsatu
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode20, 1)) as yuboux
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode21, 1)) as yubouecho
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode22, 1)) as syokusin
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode23, 1)) as shibou
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode24, 1)) as keidou
                    , count(decode(yudo_kensa_bunrui_code, :bunruiCode25, 1)) as cavi 
                from
                    kenshin_trans 
                where
                    perid = :perId 
                    and rsvno = :rsvNo 
                    and cslymd = :cslYmd 
                    and zyushin_taisyo_kubun = :taisyoKbn
                ";

            // パラメータセット
            var sqlParam = new
            {
                bunruiCode1 = BUNRUI_CODE1,
                bunruiCode2 = BUNRUI_CODE2,
                bunruiCode3 = BUNRUI_CODE3,
                bunruiCode4 = BUNRUI_CODE4,
                bunruiCode5 = BUNRUI_CODE5,
                bunruiCode6 = BUNRUI_CODE6,
                bunruiCode7 = BUNRUI_CODE7,
                bunruiCode8 = BUNRUI_CODE8,
                bunruiCode9 = BUNRUI_CODE9,
                bunruiCode10 = BUNRUI_CODE10,
                bunruiCode11 = BUNRUI_CODE11,
                bunruiCode12 = BUNRUI_CODE12,
                bunruiCode13 = BUNRUI_CODE13,
                bunruiCode14 = BUNRUI_CODE14,
                bunruiCode15 = BUNRUI_CODE15,
                bunruiCode16 = BUNRUI_CODE16,
                bunruiCode17 = BUNRUI_CODE17,
                bunruiCode18 = BUNRUI_CODE18,
                bunruiCode19 = BUNRUI_CODE19,
                bunruiCode20 = BUNRUI_CODE20,
                bunruiCode21 = BUNRUI_CODE21,
                bunruiCode22 = BUNRUI_CODE22,
                bunruiCode23 = BUNRUI_CODE23,
                bunruiCode24 = BUNRUI_CODE24,
                bunruiCode25 = BUNRUI_CODE25,
                perId = perid,
                rsvNo = rsvno,
                cslYmd = cslymd,
                taisyoKbn = TAISYO_KBN
            };

            // 戻り値設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }
    }
}