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
    /// 健診スケジュール表生成クラス
    /// </summary>
    public class Schedule_standardCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002385";

        /// <summary>
        /// Ｂホール
        /// </summary>
        private const string B_HOLE = "B";

        /// <summary>
        /// Ｃホール
        /// </summary>
        private const string C_HOLE = "C";

        /// <summary>
        /// コースコード
        /// </summary>
        private const string CSCD_100 = "100";
        private const string CSCD_105 = "105";

        /// <summary>
        /// 予約群コード
        /// </summary>
        private const string RSVGRPCD_50 = "50";
        private const string RSVGRPCD_51 = "51";
        private const string RSVGRPCD_67 = "67";
        private const string RSVGRPCD_190 = "190";
        private const string RSVGRPCD_250 = "250";
        private const string RSVGRPCD_273 = "273";
        private const string RSVGRPCD_274 = "274";

        /// <summary>
        /// 汎用コードキー（検査分類コード取得キー）
        /// </summary>
        private const string FREECD_BUNRUI_KEY = "SCHD";

        /// <summary>
        /// 検査分類分類コード
        /// </summary>
        string BUNRUI_CODE = "100170";

        /// <summary>
        /// 受診対象区分
        /// </summary>
        private const string TAISYO_KBN = "Y";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (string.IsNullOrEmpty(queryParams["rsvno"]))
            {
                messages.Add("予約番号が正しくありません。");
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
                    to_char(consult.csldate, 'yyyy/mm/dd') as csldate
                    , receipt.dayid as dayid
                    , person.lastkname || ' ' || person.firstkname as kname
                    , person.lastname || ' ' || person.firstname as name
                    , consult.perid as perid
                    , person.gender as gender
                    , consult.rsvno as rsvno
                    , consult.rsvgrpcd as rsvgrpcd
                    , consult.cscd as cscd 
                from
                    consult
                    , receipt
                    , person 
                where
                    consult.rsvno = :rsvno
                    and consult.cancelflg = :cancelflg
                    and consult.perid = person.perid 
                    and consult.rsvno = receipt.rsvno 
                    and receipt.comedate is not null
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = queryParams["rsvno"],
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
            var bHoleNoListField = (CnListField)cnObjects["B_ROOM_NO"];
            var bHoleNaListField = (CnListField)cnObjects["B_ROOM_NA"];
            var cHoleNoListField = (CnListField)cnObjects["C_ROOM_NO"];
            var cHoleNaListField = (CnListField)cnObjects["C_ROOM_NA"];
            var msgListField = (CnListField)cnObjects["MSG"];

            List<dynamic> kensaBunrui;
            short lineCount = 0;

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

            // Ｂホール検査分類の取得
            kensaBunrui = GetInspecionClass(queryParams["rsvno"], B_HOLE);

            lineCount = 0;
            foreach (var bunruiDetail in kensaBunrui)
            {
                // オプションコース
                bHoleNoListField.ListCell(0, lineCount).Text = Util.ConvertToString(bunruiDetail.BUNRUI_BANGO);
                bHoleNaListField.ListCell(0, lineCount).Text = Util.ConvertToString(bunruiDetail.BUNRUI_NAME);

                // 出力行位置をカウントアップする
                lineCount++;
            }

            // Ｃホール検査分類の取得
            kensaBunrui = GetInspecionClass(queryParams["rsvno"], C_HOLE);

            lineCount = 0;
            foreach (var bunruiDetail in kensaBunrui)
            {
                // オプションコース
                cHoleNoListField.ListCell(0, lineCount).Text = Util.ConvertToString(bunruiDetail.BUNRUI_BANGO);
                cHoleNaListField.ListCell(0, lineCount).Text = Util.ConvertToString(bunruiDetail.BUNRUI_NAME);

                // 出力行位置をカウントアップする
                lineCount++;
            }

            // メッセージ
            // １日人間ドック、職員定期健康診断（ドック）
            if (Util.ConvertToString(detail.CSCD).Equals(CSCD_100) || Util.ConvertToString(detail.CSCD).Equals(CSCD_105))
            {
                if (Util.ConvertToString(detail.GENDER).Equals("1"))
                {
                    msgListField.ListCell(0, 1).Text = "＊ロッカーキーは検査の都合上右手首にお願い致します。";
                    msgListField.ListCell(0, 2).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                    msgListField.ListCell(0, 3).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
                    msgListField.ListCell(0, 4).Text = "＊人間ドックには複数の健診コースがございます。健診コースごとに検査の項目が異なりますので検査順番が異なります。";
                    msgListField.ListCell(0, 5).Text = "　ご自分の検査順番をご確認ください。";
                    msgListField.ListCell(0, 6).Text = "＊本日の検査結果は検査終了後の医師面接で内科医師より説明させて頂きます。";
                }
                else
                {
                    msgListField.ListCell(0, 0).Text = "＊ロッカーキーは検査の都合上右手首にお願い致します。";
                    msgListField.ListCell(0, 1).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                    msgListField.ListCell(0, 2).Text = "＊婦人科診察の前にお手洗を済ませていただくようお願い致します。";
                    msgListField.ListCell(0, 3).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
                    msgListField.ListCell(0, 4).Text = "＊人間ドックには複数の健診コースがございます。健診コースごとに検査の項目が異なりますので検査順番が異なります。";
                    msgListField.ListCell(0, 5).Text = "　ご自分の検査順番をご確認ください。";
                    msgListField.ListCell(0, 6).Text = "＊本日の検査結果は検査終了後の医師面接で内科医師より説明させて頂きます。";
                }
            }
            // 午前企業
            else if (Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_50))
            {
                if (Util.ConvertToString(detail.GENDER).Equals("1"))
                {
                    msgListField.ListCell(0, 5).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                    msgListField.ListCell(0, 6).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
                }
                else
                {
                    msgListField.ListCell(0, 4).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                    msgListField.ListCell(0, 5).Text = "＊婦人科診察の前にお手洗を済ませていただくようお願い致します。";
                    msgListField.ListCell(0, 6).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
                }
            }
            // 午後企業
            else if (Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_51))
            {
                if (Util.ConvertToString(detail.GENDER).Equals("1"))
                {
                    msgListField.ListCell(0, 3).Text = "本日は上記の順番で検査を回っていただきます。";
                    msgListField.ListCell(0, 4).Text = "最初の検査は身体測定です。";
                    msgListField.ListCell(0, 5).Text = "係の者が番号をお呼びしますので、席でお待ちください。";
                    msgListField.ListCell(0, 6).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願いいたします。";
                }
                else
                {
                    msgListField.ListCell(0, 3).Text = "本日は上記の順番で検査を回っていただきます。";
                    msgListField.ListCell(0, 4).Text = "最初の検査は身体測定です。";
                    msgListField.ListCell(0, 5).Text = "係の者が番号をお呼びしますので、席でお待ちください。";
                    msgListField.ListCell(0, 6).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願いいたします。";
                }
            }
            // 特定保健指導（積極的）
            else if (Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_67))
            {
                msgListField.ListCell(0, 6).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
            }
            // レジデンス
            else if (Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_190))
            {
                msgListField.ListCell(0, 5).Text = "＊ロッカーキーは検査の都合上右手首にお願い致します。";
                msgListField.ListCell(0, 6).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
            }
            // 渡航内科
            else if (Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_250))
            {
                msgListField.ListCell(0, 5).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                msgListField.ListCell(0, 6).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
            }
            // 乳がん検診
            else if (Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_273) || Util.ConvertToString(detail.RSVGRPCD).Equals(RSVGRPCD_274))
            {
                msgListField.ListCell(0, 5).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                msgListField.ListCell(0, 6).Text = "＊婦人科診察の前にお手洗を済ませていただくようお願い致します。";
            }
            // その他は午前企業と同様にメッセージ設定
            else
            {
                if (Util.ConvertToString(detail.GENDER).Equals("1"))
                {
                    msgListField.ListCell(0, 5).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                    msgListField.ListCell(0, 6).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
                }
                else
                {
                    msgListField.ListCell(0, 4).Text = "＊眼圧・眼底検査では、コンタクトレンズをお外しいただくようお願い致します。";
                    msgListField.ListCell(0, 5).Text = "＊婦人科診察の前にお手洗を済ませていただくようお願い致します。";
                    msgListField.ListCell(0, 6).Text = "＊検査の混み具合により、検査の順番を変更する場合がございます。";
                }
            }

            // ドキュメントの出力
            PrintOut(cnForm);
        }

        /// <summary>
        /// 検査分類を取得
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="hole">ホール</param>
        /// <returns></returns>
        private List<dynamic> GetInspecionClass(string rsvno, string hole)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    kenshin_trans.yudo_kensa_bunrui_code as bunrui_code
                    , free.freefield1 as bunrui_bango
                    , free.freefield2 as bunrui_name
                    , free.freefield3 as hole
                    , kenshin_trans.kenshin_seq as kenshin_seq 
                from
                    kenshin_trans
                    , free 
                where
                    kenshin_trans.rsvno = :rsvNo
                    and kenshin_trans.zyushin_taisyo_kubun = :taisyoKbn
                    and :bunruiKey || kenshin_trans.yudo_kensa_bunrui_code = free.freecd 
                    and free.freefield3 = :holeKbn
                union all 
                select
                    lastview.bunrui_code as bunrui_code
                    , decode( 
                        lastview.hole
                        , 'B'
                        , lastview.bunrui_bango_b
                        , 'C'
                        , lastview.bunrui_bango_c
                    ) as bunrui_bango
                    , lastview.bunrui_name as bunrui_name
                    , lastview.hole as hole
                    , lastview.kenshin_seq as kenshin_seq 
                from
                    ( 
                        select
                            kenshin_trans.yudo_kensa_bunrui_code as bunrui_code
                            , free.freefield1 as bunrui_bango_b
                            , free.freefield4 as bunrui_bango_c
                            , free.freefield2 as bunrui_name
                            , nvl( 
                                ( 
                                    select
                                        decode( 
                                            sign( 
                                                nvl(trans.kenshin_seq, 999) - kenshin_trans.kenshin_seq
                                            ) 
                                            , 1
                                            , 'B'
                                            , 'C'
                                        ) 
                                    from
                                        kenshin_trans trans 
                                    where
                                        trans.cslymd = kenshin_trans.cslymd 
                                        and trans.dayid = kenshin_trans.dayid 
                                        and trans.yudo_kensa_bunrui_code = :bunruiCode
                                        and trans.zyushin_taisyo_kubun = :taisyoKbn
                                ) 
                                , 'B'
                            ) as hole
                            , kenshin_trans.kenshin_seq as kenshin_seq 
                        from
                            kenshin_trans
                            , free 
                        where
                            kenshin_trans.rsvno = :rsvNo
                            and kenshin_trans.zyushin_taisyo_kubun = :taisyoKbn
                            and :bunruiKey || kenshin_trans.yudo_kensa_bunrui_code = free.freecd 
                            and free.freefield3 is null
                    ) lastview 
                where
                    lastview.hole = :holeKbn
                order by
                    kenshin_seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvNo = rsvno,
                taisyoKbn = TAISYO_KBN,
                holeKbn = hole,
                bunruiKey = FREECD_BUNRUI_KEY,
                bunruiCode = BUNRUI_CODE
            };

            // 戻り値設定
            return connection.Query(sql, sqlParam).ToList();
        }
    }
}