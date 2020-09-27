using Dapper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 帳票管理情報データアクセスオブジェクト
    /// </summary>
    public class ReportDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ReportDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 帳票テーブル情報を取得する
        /// </summary>
        /// <param name="reportFlg">報告書フラグ</param>
        /// <param name="selectViewOrder">true時は表示順に従い取得</param>
        /// <returns>帳票一覧
        /// reportcd 帳票コード
        /// reportname 帳票名
        /// defaultprinter デフォルトプリンタ
        /// reportflg 報告書フラグ
        /// prtmachine 出力先
        /// preview 出力方法
        /// historyprint 過去歴検索方法
        /// karteflg カルテフラグ
        /// vieworder 表示順
        /// </returns>
        public List<dynamic> SelectReportList(int? reportFlg = null, bool selectViewOrder = false)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            if (reportFlg != null)
            {
                param.Add("reportflg", reportFlg);
            }

            // 帳票テーブル情報を取得する
            string sql = @"
                select
                    reportcd
                    , reportname
                    , defaultprinter
                    , reportflg
                    , prtmachine
                    , preview
                    , historyprint
                    , karteflg
                    , vieworder
                from
                    report
            ";

            // 報告書フラグ指定時は条件節に追加
            if (reportFlg != null)
            {
                sql += @"
                where
                    reportflg = :reportflg
                ";
            }

            // 表示順指定時は報告書フラグの降順、表示順の昇順、帳票コードの昇順に取得。さもなくば帳票ファイル名１の昇順に取得。
            if (selectViewOrder)
            {
                sql += @"
                order by
                    reportflg desc
                    , vieworder
                    , reportcd
                ";
            }
            else
            {
                sql += @"
                order by
                    fedfile
                ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 帳票テーブル情報を取得する
        /// </summary>
        /// <param name="karteFlg">カルテフラグ</param>
        /// <returns>帳票一覧
        /// reportcd 帳票コード
        /// reportname 帳票名
        /// defaultprinter デフォルトプリンタ
        /// reportflg 報告書フラグ
        /// prtmachine 出力先
        /// preview 出力方法
        /// historyprint 過去歴検索方法
        /// karteflg カルテフラグ
        /// </returns>
        public List<dynamic> SelectReportList2(int? karteFlg = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            if (karteFlg != null)
            {
                param.Add("karteflg", karteFlg);
            }

            // 帳票テーブル情報を取得する
            string sql = @"
                select
                    reportcd
                    , reportname
                    , defaultprinter
                    , reportflg
                    , prtmachine
                    , preview
                    , historyprint
                    , karteflg
                from
                    report
            ";

            // 報告書フラグ指定時は条件節に追加
            if (karteFlg != null)
            {
                sql += @"
                    where
                        karteflg = :karteflg
                ";
            }

            // 帳票コードの昇順に取得
            sql += @"
                order by
                    reportcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定帳票コードの帳票管理レコードを読み込みます。
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>帳票管理情報
        /// reportname 帳票名
        /// papersize 用紙サイズ
        /// orientation 用紙方向
        /// defaultprinter デフォルトプリンタ
        /// prtmachine 出力先
        /// preview 出力方法
        /// fedfile 帳票ファイル名
        /// fedfile2 帳票ファイル名2
        /// fedfile3 帳票ファイル名3
        /// fedfile4 帳票ファイル名4
        /// fedfile5 帳票ファイル名5
        /// fedfile6 帳票ファイル名6
        /// fedfile7 帳票ファイル名7
        /// reportflg 報告書フラグ
        /// historyprint 過去歴印刷
        /// copycount 部数
        /// karteflg カルテフラグ
        /// fedfile8 帳票ファイル名8
        /// fedfile9 帳票ファイル名9
        /// fedfile10 帳票ファイル名10
        /// vieworder 表示順
        /// </returns>
        public dynamic SelectReport(string reportCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd.Trim());

            // テーブルデータから取得
            string sql = @"
                select
                    reportname
                    , papersize
                    , orientation
                    , defaultprinter
                    , prtmachine
                    , preview
                    , fedfile
                    , fedfile2
                    , fedfile3
                    , fedfile4
                    , fedfile5
                    , fedfile6
                    , fedfile7
                    , reportflg
                    , historyprint
                    , copycount
                    , karteflg
                    , fedfile8
                    , fedfile9
                    , fedfile10
                    , vieworder
                from
                    report
                where
                    reportcd = :reportcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定帳票コードの帳票管理レコードを読み込みます。
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>帳票管理情報
        /// reportname 帳票名
        /// papersize 用紙サイズ
        /// orientation 用紙方向
        /// defaultprinter デフォルトプリンタ
        /// prtmachine 出力先
        /// preview 出力方法
        /// fedfile 帳票ファイル名
        /// fedfile2 帳票ファイル名2
        /// fedfile3 帳票ファイル名3
        /// fedfile4 帳票ファイル名4
        /// fedfile5 帳票ファイル名5
        /// reportflg 報告書フラグ
        /// historyprint 過去歴印刷
        /// copycount 部数
        /// </returns>
        public dynamic SelectReport2(string reportCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd.Trim());

            // 指定帳票コードの帳票情報を取得
            string sql = @"
                select
                    reportname
                    , papersize
                    , orientation
                    , defaultprinter
                    , prtmachine
                    , preview
                    , fedfile
                    , fedfile2
                    , fedfile3
                    , fedfile4
                    , fedfile5
                    , reportflg
                    , historyprint
                    , copycount
                from
                    report
                where
                    reportcd = :reportcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定帳票コードの帳票管理レコードを読み込みます。
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>帳票管理情報
        /// reportname 帳票名
        /// papersize 用紙サイズ
        /// orientation 用紙方向
        /// defaultprinter デフォルトプリンタ
        /// prtmachine 出力先
        /// preview 出力方法
        /// fedfile 帳票ファイル名
        /// fedfile2 帳票ファイル名2
        /// fedfile3 帳票ファイル名3
        /// fedfile4 帳票ファイル名4
        /// fedfile5 帳票ファイル名5
        /// fedfile6 帳票ファイル名6
        /// reportflg 報告書フラグ
        /// historyprint 過去歴印刷
        /// copycount 部数
        /// </returns>
        public dynamic SelectReport3(string reportCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd.Trim());

            // 指定帳票コードの帳票情報を取得
            string sql = @"
                select
                    reportname
                    , papersize
                    , orientation
                    , defaultprinter
                    , prtmachine
                    , preview
                    , fedfile
                    , fedfile2
                    , fedfile3
                    , fedfile4
                    , fedfile5
                    , fedfile6
                    , reportflg
                    , historyprint
                    , copycount
                from
                    report
                where
                    reportcd = :reportcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定帳票コードの帳票管理レコードを読み込みます。
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>帳票管理情報
        /// reportname 帳票名
        /// papersize 用紙サイズ
        /// orientation 用紙方向
        /// defaultprinter デフォルトプリンタ
        /// prtmachine 出力先
        /// preview 出力方法
        /// fedfile 帳票ファイル名
        /// fedfile2 帳票ファイル名2
        /// fedfile3 帳票ファイル名3
        /// fedfile4 帳票ファイル名4
        /// fedfile5 帳票ファイル名5
        /// fedfile6 帳票ファイル名6
        /// fedfile7 帳票ファイル名7
        /// reportflg 報告書フラグ
        /// historyprint 過去歴印刷
        /// copycount 部数
        /// </returns>
        public dynamic SelectReport4(string reportCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd.Trim());

            // 指定帳票コードの帳票情報を取得
            string sql = @"
                select
                    reportname
                    , papersize
                    , orientation
                    , defaultprinter
                    , prtmachine
                    , preview
                    , fedfile
                    , fedfile2
                    , fedfile3
                    , fedfile4
                    , fedfile5
                    , fedfile6
                    , fedfile7
                    , reportflg
                    , historyprint
                    , copycount
                from
                    report
                where
                    reportcd = :reportcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定帳票コードの帳票管理レコードを読み込みます。
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>帳票管理情報
        /// reportname 帳票名
        /// papersize 用紙サイズ
        /// orientation 用紙方向
        /// defaultprinter デフォルトプリンタ
        /// prtmachine 出力先
        /// preview 出力方法
        /// fedfile 帳票ファイル名
        /// fedfile2 帳票ファイル名2
        /// fedfile3 帳票ファイル名3
        /// fedfile4 帳票ファイル名4
        /// fedfile5 帳票ファイル名5
        /// fedfile6 帳票ファイル名6
        /// fedfile7 帳票ファイル名7
        /// reportflg 報告書フラグ
        /// historyprint 過去歴印刷
        /// copycount 部数
        /// karteflg カルテフラグ
        /// fedfile8 帳票ファイル名8
        /// fedfile9 帳票ファイル名9
        /// fedfile10 帳票ファイル名10
        /// </returns>
        public dynamic SelectReport5(string reportCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", reportCd.Trim());

            // 指定帳票コードの帳票情報を取得
            string sql = @"
                select
                    reportname
                    , papersize
                    , orientation
                    , defaultprinter
                    , prtmachine
                    , preview
                    , fedfile
                    , fedfile2
                    , fedfile3
                    , fedfile4
                    , fedfile5
                    , fedfile6
                    , fedfile7
                    , reportflg
                    , historyprint
                    , copycount
                    , fedfile8
                    , fedfile9
                    , fedfile10
                from
                    report
                where
                    reportcd = :reportcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 帳票管理レコードを登録します。
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">帳票管理情報</param>
        /// reportcd 帳票コード
        /// reportname 帳票名
        /// papersize 用紙サイズ
        /// orientation 用紙方向
        /// defaultprinter デフォルトプリンタ
        /// prtmachine 出力先
        /// preview 出力方法
        /// reportflg 報告書フラグ
        /// karteflg カルテフラグ
        /// historyprint 過去歴印刷
        /// copycount 部数
        /// fedfile 帳票ファイル名
        /// fedfile2 帳票ファイル名2
        /// fedfile3 帳票ファイル名3
        /// fedfile4 帳票ファイル名4
        /// fedfile5 帳票ファイル名5
        /// fedfile6 帳票ファイル名6
        /// fedfile7 帳票ファイル名7
        /// fedfile8 帳票ファイル名8
        /// fedfile9 帳票ファイル名9
        /// fedfile10 帳票ファイル名10
        /// vieworder 表示順
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistReport(string mode, JToken data)
        {
            string sql;

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportcd", Convert.ToString(data["reportcd"]));
            param.Add("reportname", Convert.ToString(data["reportname"]));
            param.Add("papersize", Convert.ToString(data["papersize"]));
            param.Add("orientation", Convert.ToString(data["orientation"]));
            param.Add("defaultprinter", Convert.ToString(data["defaultprinter"]));
            param.Add("prtmachine", Convert.ToString(data["prtmachine"]));
            param.Add("preview", Convert.ToString(data["preview"]));
            param.Add("reportflg", Convert.ToString(data["reportflg"]));
            param.Add("karteflg", Convert.ToString(data["karteflg"]));
            param.Add("historyprint", Convert.ToString(data["historyprint"]));
            param.Add("copycount", Convert.ToString(data["copycount"]));
            param.Add("fedfile", Convert.ToString(data["fedfile"]));
            param.Add("fedfile2", Convert.ToString(data["fedfile2"]));
            param.Add("fedfile3", Convert.ToString(data["fedfile3"]));
            param.Add("fedfile4", Convert.ToString(data["fedfile4"]));
            param.Add("fedfile5", Convert.ToString(data["fedfile5"]));
            param.Add("fedfile6", Convert.ToString(data["fedfile6"]));
            param.Add("fedfile7", Convert.ToString(data["fedfile7"]));
            param.Add("fedfile8", Convert.ToString(data["fedfile8"]));
            param.Add("fedfile9", Convert.ToString(data["fedfile9"]));
            param.Add("fedfile10", Convert.ToString(data["fedfile10"]));

            Int32.TryParse(Convert.ToString(data["vieworder"]), out int viewOrder);
            param.Add("vieworder", viewOrder);

            while (true)
            {
                // 帳票テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                        update report
                        set
                            reportcd = :reportcd
                            , reportname = :reportname
                            , papersize = :papersize
                            , orientation = :orientation
                            , defaultprinter = :defaultprinter
                            , prtmachine = :prtmachine
                            , preview = :preview
                            , reportflg = :reportflg
                            , karteflg = :karteflg
                            , historyprint = :historyprint
                            , copycount = :copycount
                            , fedfile = :fedfile
                            , fedfile2 = :fedfile2
                            , fedfile3 = :fedfile3
                            , fedfile4 = :fedfile4
                            , fedfile5 = :fedfile5
                            , fedfile6 = :fedfile6
                            , fedfile7 = :fedfile7
                            , fedfile8 = :fedfile8
                            , fedfile9 = :fedfile9
                            , fedfile10 = :fedfile10
                            , vieworder = :vieworder
                        where
                            reportcd = :reportcd
                    ";

                    int ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす帳票テーブルのレコードを取得
                sql = @"
                    select
                        reportcd
                    from
                        report
                    where
                        reportcd = :reportcd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                    insert
                    into report(
                        reportcd
                        , reportname
                        , papersize
                        , orientation
                        , defaultprinter
                        , prtmachine
                        , preview
                        , reportflg
                        , karteflg
                        , historyprint
                        , copycount
                        , fedfile
                        , fedfile2
                        , fedfile3
                        , fedfile4
                        , fedfile5
                        , fedfile6
                        , fedfile7
                        , fedfile8
                        , fedfile9
                        , fedfile10
                        , vieworder
                    )
                    values (
                        :reportcd
                        , :reportname
                        , :papersize
                        , :orientation
                        , :defaultprinter
                        , :prtmachine
                        , :preview
                        , :reportflg
                        , :karteflg
                        , :historyprint
                        , :copycount
                        , :fedfile
                        , :fedfile2
                        , :fedfile3
                        , :fedfile4
                        , :fedfile5
                        , :fedfile6
                        , :fedfile7
                        , :fedfile8
                        , :fedfile9
                        , :fedfile10
                        , :vieworder
                    )
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定帳票コードの帳票管理レコードを削除します。
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteReport(string reportCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("reportCd", reportCd.Trim());

            // 帳票テーブルレコードの削除
            string sql = @"
                delete report
                where
                    reportcd = :reportcd
            ";

            connection.Execute(sql, param);

            return true;
        }
    }
}