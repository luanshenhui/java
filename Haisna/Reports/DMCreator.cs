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
    /// 団体宛ダイレクトメール生成クラス
    /// </summary>
    public class DMCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000510";

        /// <summary>
        /// ラベル上限数
        /// </summary>
        private const int MAX_ITEM_COUNT = 12;       //１ページラベル数

        /// <summary>
        /// パラメタ上限数
        /// </summary>
        private const int MAX_COUNT_ORG = 12;       //団体コード指定数
        private const int MAX_COUNT_CSCD = 10;      //コースコード指定数

        /// <summary>
        /// 団体種別
        /// </summary>
        private const string ORGDIV_1 = "ORGDIV00";
        private const string ORGDIV_2 = "ORGDIV01";
        private const string ORGDIV_3 = "ORGDIV02";
        private const string ORGDIV_4 = "ORGDIV03";

        /// <summary>
        /// 定義体フィールド名
        /// </summary>
        private const string REP_REPZIP = "zip";
        private const string REP_REPADDA = "adresa";
        private const string REP_REPADDA2 = "adresb";
        private const string REP_REPADDB = "adb";
        private const string REP_REPORGNAME = "orgname";
        private const string REP_REPORGPOST = "orgpost";
        private const string REP_REPNAME = "name";
        private const string REP_REPON = "on";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //印刷開始位置チェック
            string msg = WebHains.CheckNumeric("印刷開始位置", queryParams["pos"], MAX_ITEM_COUNT);
            if (! string.IsNullOrEmpty(msg))
            {
                messages.Add(msg);
            }

            return messages;
        }

        /// <summary>
        /// 団体宛ダイレクトメールデータを読み込む
        /// </summary>
        /// <returns>団体宛ダイレクトメールデータ</returns>
        protected override List<dynamic> GetData()
        {

            // パラメタ取得

            //団体パラメタ
            List<string> orgcd_list = new List<string>();

            for (int i = 1; i <= MAX_COUNT_ORG; i++)
            {
                string para_name1 = "orgcd1" + i.ToString();
                string para_name2 = "orgcd2" + i.ToString();

                if ( (!string.IsNullOrEmpty(queryParams[para_name1])) || (!string.IsNullOrEmpty(queryParams[para_name2])) )
                {
                    //団体指定がある場合、値を退避
                    orgcd_list.Add(queryParams[para_name1].Trim() + queryParams[para_name2].Trim());
                }
            }

            //コースパラメタ
            List<string> cscd_list = new List<string>();

            for (int i = 1; i <= MAX_COUNT_CSCD; i++)
            {
                string para_name = "cscd" + i.ToString();

                if (!string.IsNullOrEmpty(queryParams[para_name]))
                {
                    //コース指定がある場合、値を退避
                    cscd_list.Add(queryParams[para_name].Trim());
                }
            }


            // SQLステートメント定義
            string sql = @"
                select
                    orgaddr.zipcd
                    , pref.prefname
                    , orgaddr.cityname
                    , orgaddr.address1
                    , orgaddr.address2
                    , orgaddr.orgname
                    , orgaddr.chargepost
                    , orgaddr.chargename 
                ";

            //コース指定がある場合
            if (cscd_list.Count > 0)
            {
                sql += @"
                        from
                            org
                            , orgaddr
                            , pref
                            , ctrmng
                            , ctrpt 
                    ";
            }
            else
            {
                sql += @"
                        from
                            org
                            , orgaddr
                            , pref 
                    ";
            }
            
            //宛先
            switch(queryParams["orgAddr"].Trim())
            {
                case "4":
                    sql += @"
                        where
                            orgaddr.addrdiv = org.directmail 
                    ";
                    break;

                case "0":
                    sql += @"
                        where
                            orgaddr.addrdiv = org.billaddress 
                    ";
                    break;

                default:
                    sql += @"
                        where
                            orgaddr.addrdiv(+) = :addr 
                    ";
                    break;
            }

            sql += @"
                    and orgaddr.orgcd1(+) = org.orgcd1 
                    and orgaddr.orgcd2(+) = org.orgcd2 
                ";

            //団体種別
            string orgDiv = "";
            switch (queryParams["orgDiv"].Trim())
            {
                case "0" :
                    break;
                case "1":
                    orgDiv = ORGDIV_1;
                    break;
                case "2":
                    orgDiv = ORGDIV_2;
                    break;
                case "3":
                    orgDiv = ORGDIV_3;
                    break;
                case "4":
                    orgDiv = ORGDIV_4;
                    break;
            }
            if (!string.IsNullOrEmpty(orgDiv))
            {
                sql += @"
                        and org.orgdivcd = :div 
                    ";
            }

            //年始・中元・歳暮
            if (queryParams["present"] == "1")
            {
                sql += @"
                        and org.presents = '1' 
                    ";
            }

            //団体指定
            if (queryParams["orgSel"] == "2")
            {

                if (orgcd_list.Count > 0)
                {
                    //団体指定が１件以上ある場合、連結してSQL追加
                    sql += @"
                        and org.orgcd1 || org.orgcd2 in ( '" + String.Join("','", orgcd_list) + "')";
                }
                else
                {
                    //団体指定が０件の場合、使用団体のみ指定
                    sql += @"
                            and org.delflg = '0' 
                        ";
                }

            }
            else
            {
                // 団体：全ての場合
                sql += @"
                        and org.delflg in ('0', '2') 
                    ";
            }

            sql += @"
                    and orgaddr.prefcd = pref.prefcd(+) 
                ";
            
            //コース指定
            if ( cscd_list.Count > 0)
            {
                //コース指定が１件以上ある場合、連結してSQL追加
                sql += @"
                        and ctrmng.cscd in ( '" + String.Join("','", cscd_list) + "')";

                sql += @"
                        and ctrmng.orgcd1 = org.orgcd1 
                        and ctrmng.orgcd2 = org.orgcd2 
                        and ctrmng.ctrptcd = ctrpt.ctrptcd 
                        and ctrpt.strdate < :startDate 
                        and ctrpt.enddate > :endDate 
                    ";
            }

            //ソート
            if (queryParams["sort"] == "1")
            {
                sql += @"
                        --団体コード順
                        order by
                            org.orgcd1
                            , org.orgcd2 
                    ";
            }
            else
            {
                sql += @"
                        --団体カナ順
                        order by
                            org.orgkname
                    ";
            }

            // パラメータセット
            var sqlParam = new
            {
                addr = queryParams["orgAddr"],
                div = orgDiv,
                startDate = DateTime.Today.ToString("yyyy/MM/dd"),
                endDate = DateTime.Today.ToString("yyyy/MM/dd")
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">団体宛ダイレクトメールデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // パラメタ取得
            int outCnt = 0;

            int start_pos = Convert.ToInt32(queryParams["pos"]);
            int busu_max = Convert.ToInt32( queryParams["busu"]);

            int pos = start_pos;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 指定部数分繰り返す
                for (int busu = 1; busu <= busu_max; busu++)
                {
                    // ページ内最大個数に達した場合、改ページ
                    if (pos > MAX_ITEM_COUNT)
                    {
                        // ドキュメントの出力
                        PrintOut(cnForm);

                        // 出力位置の初期化
                        pos = 1;

                    }

                    var zip_dataField = (CnDataField)cnObjects[REP_REPZIP + pos.ToString()];
                    var adresa_dataField = (CnDataField)cnObjects[REP_REPADDA+ pos.ToString()];
                    var adresb_dataField = (CnDataField)cnObjects[REP_REPADDA2 + pos.ToString()];
                    var adb_dataField = (CnDataField)cnObjects[REP_REPADDB + pos.ToString()];
                    var orgname_dataField = (CnDataField)cnObjects[REP_REPORGNAME + pos.ToString()];
                    var orgpost_dataField = (CnDataField)cnObjects[REP_REPORGPOST + pos.ToString()];
                    var name_dataField = (CnDataField)cnObjects[REP_REPNAME + pos.ToString()];
                    var on_dataField = (CnDataField)cnObjects[REP_REPON + pos.ToString()];

                    //郵便番号
                    string work = "";
                    string add = "";
                    string add2 = "";

                    work = Util.ConvertToString(detail.ZIPCD).Trim();
                    if ( work != "")
                    {
                        if (work.Length > 3)
                        {
                            add = "〒" + work.Substring(0,3);
                            add2 = "-" + work.Substring(3);
                        }
                        else
                        {
                            add = "〒" + work;
                            add2 = "";
                        }
                    }
                    else
                    {
                        add = "〒";
                        add2 = "";
                    }
                    zip_dataField.Text = add + add2;

                    //住所
                    work = "";
                    add = "";
                    add2 = "";
                    work = Util.ConvertToString(detail.PREFNAME).Trim() + Util.ConvertToString(detail.CITYNAME).Trim() + Util.ConvertToString(detail.ADDRESS1).Trim();

                    int mojicnt = work.Length;
                    int maxcnt = 0;
                    for ( int cnt = 1; cnt <= mojicnt; cnt++)
                    {
                        //1文字取得
                        int bytecnt = WebHains.LenB(work.Substring(cnt - 1 , 1));

                        //バイト数加算
                        maxcnt += bytecnt;

                        if ( maxcnt > 45)
                        {
                            //45バイト目以降の文字列は2個目に設定
                            add2 = work.Substring(cnt - 1);
                            break;
                        }
                        else
                        {
                            add += work.Substring(cnt - 1, 1);
                        }
                    }
                    adresa_dataField.Text = add;
                    adresb_dataField.Text = add2;

                    //住所2
                    adb_dataField.Text = Util.ConvertToString(detail.ADDRESS2).Trim();

                    //団体名
                    work = "";
                    add = "";
                    add2 = "";
                    work = Util.ConvertToString(detail.ORGNAME).Trim();

                    mojicnt = work.Length;
                    maxcnt = 0;
                    for (int cnt = 1; cnt <= mojicnt; cnt++)
                    {
                        //1文字取得
                        int bytecnt = WebHains.LenB(work.Substring(cnt - 1, 1));

                        //バイト数加算
                        maxcnt += bytecnt;

                        if (maxcnt > 45)
                        {
                            //45バイト目以降の文字列は2個目に設定
                            add2 = work.Substring(cnt - 1);
                            break;
                        }
                        else
                        {
                            add += work.Substring(cnt - 1, 1);
                        }
                    }
                    orgname_dataField.Text = add;
                    on_dataField.Text = add2;

                    //部署
                    orgpost_dataField.Text = Util.ConvertToString(detail.CHARGEPOST).Trim();

                    //担当者
                    name_dataField.Text = Util.ConvertToString(detail.CHARGENAME).Trim() +"　様";

                    // カウントをインクリメント
                    pos++;

                }

                // 連番をインクリメント
                outCnt++;

            }

            //終了処理
            if ( outCnt > 0 )
            {
                // ドキュメントの出力
                PrintOut(cnForm);
            }

        }
         
    }
}
