using Dapper;
using Hainsi.Common.Constants;
using Hainsi.Common.Table;
using Hainsi.Entity.Model.WorkStation;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 端末情報データアクセスオブジェクト
    /// </summary>
    public class WorkStationDao : AbstractDao
    {
        /// <summary>
        /// グループデータアクセスオブジェクト
        /// </summary>
        readonly GrpDao grpDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="grpDao">グループデータアクセスオブジェクト</param>
        /// <param name="connection">コネクションオブジェクト</param>
        public WorkStationDao(IDbConnection connection, GrpDao grpDao) : base(connection)
        {
            this.grpDao = grpDao;
        }

        /// <summary>
        ///  端末管理テーブルの一覧を取得する
        /// </summary>
        /// <returns>
        /// ipaddress IPアドレス
        /// wkstnname 端末名
        /// grpcd グループコード
        /// grpname グループ名
        /// progresscd 進捗分類コード
        /// progressname 進捗分類名
        /// isprintbutton 印刷ボタン表示
        /// </returns>
        public List<dynamic> SelectWorkStationList()
        {
            string sql = "";        // SQLステートメント

            // 端末管理テーブルよりレコードを取得
            sql = @"
                    select
                      workstation.ipaddress
                      , workstation.wkstnname
                      , workstation.grpcd
                      , grp_p.grpname
                      , workstation.progresscd
                      , progress.progressname
                      , workstation.isprintbutton
                    from
                      progress
                      , grp_p
                      , workstation
                    where
                      workstation.grpcd = grp_p.grpcd(+)
                      and workstation.progresscd = progress.progresscd(+)
                    order by
                      workstation.ipaddress
            ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        ///  端末管理データを取得する
        /// </summary>
        /// <param name="ipAddress">IPアドレス</param>
        /// <returns>
        /// ipaddress IPアドレス
        /// wkstnname 端末名
        /// grpcd グループコード
        /// grpname グループ名
        /// progresscd 進捗分類コード
        /// isprintbutton 印刷ボタン表示
        /// </returns>
        public dynamic SelectWorkStation(string ipAddress)
        {
            string sql = "";        // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (String.IsNullOrEmpty(ipAddress))
            {
                // プロシージャの呼び出し、または引数が不正です。
                throw new ArgumentException();
            }

            //キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ipaddress", ipAddress.Trim());

            // 検索条件を満たす端末管理テーブルのレコードを取得
            sql = @"
                    select
                      workstation.ipaddress
                      , workstation.wkstnname
                      , workstation.grpcd
                      , grp_p.grpname
                      , workstation.progresscd
                      , workstation.isprintbutton
                    from
                      grp_p
                      , workstation
                    where
                      ipaddress = :ipaddress
                      and workstation.grpcd = grp_p.grpcd(+)
                ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 端末管理データを取得する
        /// </summary>
        /// <param name="clsDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="cayId">当日ＩＤ</param>
        /// <param name="ipAddress">IPアドレス（省略可）</param>
        /// <returns>
        /// ipaddress IPアドレス～戻り値
        /// upddate 更新日時～戻り値
        /// </returns>
        public List<dynamic> SelectPassedInfo(DateTime clsDate, int cntlNo, int cayId, string ipAddress = null)
        {
            string sql = "";        // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (cntlNo == 0)
            {
                // プロシージャの呼び出し、または引数が不正です。
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", clsDate);
            param.Add("cntlno", cntlNo);
            param.Add("dayid", cayId);

            // 検索条件を満たす端末通過情報テーブルのレコードを取得
            sql = @"
                    select
                      ipaddress
                      , upddate
                    from
                      passedinfo
                    where
                      csldate = :csldate
                      and cntlno = :cntlno
                      and dayid = :dayid
                ";

            // IPアドレス指定の場合
            if (!string.IsNullOrEmpty(ipAddress))
            {
                param.Add("ipaddress", ipAddress);
                sql = @"
                        and ipaddress = :ipaddress
                    ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 端末管理テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// ipaddress       IPアドレス
        /// wkstnname       端末名
        /// grpcd           グループコード
        /// progresscd      進捗分類コード
        /// isprintbutton   印刷ボタン表示
        /// </param>
        /// <returns>
        /// Insert.Normal   正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error    異常終了
        /// </returns>
        public Insert RegistWorkStation(string mode, RegisterWorkStation data)
        {
            string sql = "";        // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ipaddress", data.IpAddress);
            param.Add("wkstnname", data.WkstnName?.Trim());
            param.Add("grpcd", data.GrpCd?.Trim());
            param.Add("progresscd", data.ProgressCd);
            param.Add("isprintbutton", data.IsPrintButton);

            while (true)
            {
                // 端末管理テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update workstation
                            set
                              wkstnname = :wkstnname
                              , grpcd = :grpcd
                              , progresscd = :progresscd
                              , isprintbutton = :isprintbutton
                            where
                              ipaddress = :ipaddress
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす端末管理テーブルのレコードを取得
                sql = @"
                        select
                          ipaddress
                        from
                          workstation
                        where
                          ipaddress = :ipaddress
                ";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into workstation(
                          ipaddress
                          , wkstnname
                          , grpcd
                          , progresscd
                          , isprintbutton
                        )
                        values (
                          :ipaddress
                          , :wkstnname
                          , :grpcd
                          , :progresscd
                          , :isprintbutton
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
        /// 端末通過情報テーブルを更新する
        /// </summary>
        /// <param name="data">
        /// csldate     受診日
        /// cntlno      管理番号
        /// dayid       当日ＩＤ
        /// ipaddress   IPアドレス
        /// </param>
        /// <returns>
        /// Insert.Normal   正常終了
        /// Insert.NoParent 親キーなしエラー
        /// Insert.Error    異常終了
        /// </returns>
        public Insert UpdatePassedInfo(JToken data)
        {
            string sql = "";        // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToString(data["csldate"]));
            param.Add("cntlno", Convert.ToInt64(data["cntlno"]));
            param.Add("dayid", Convert.ToInt64(data["dayid"]));
            param.Add("ipaddress", Convert.ToString(data["ipaddress"]));

            // 検索条件を満たす端末管理テーブルのレコードを取得
            sql = @"
                    select
                      csldate
                    from
                      passedinfo
                    where
                      csldate = :csldate
                      and cntlno = :cntlno
                      and dayid = :dayid
                      and ipaddress = :ipaddress
            ";
            dynamic current = connection.Query(sql, param).FirstOrDefault();

            if (current != null)
            {
                // 更新モード
                sql = @"
                        update passedinfo
                        set
                          upddate = sysdate
                        where
                          csldate = :csldate
                          and cntlno = :cntlno
                          and dayid = :dayid
                          and ipaddress = :ipaddress
                    ";

                ret2 = connection.Execute(sql, param);

                if (ret2 > 0)
                {
                    ret = Insert.Normal;
                }
            }
            else
            {
                // 新規作成モード

                // 受付済みか確認
                sql = @"
                        select
                          csldate
                        from
                          receipt
                        where
                          csldate = :csldate
                          and cntlno = :cntlno
                          and dayid = :dayid
                ";
                current = connection.Query(sql, param).FirstOrDefault();

                if (current == null)
                {
                    // 存在しないならエラー
                    ret = Insert.NoParent;
                }
                else
                {
                    // 存在するなら受付
                    sql = @"
                            insert
                            into passedinfo(
                                csldate, cntlno
                                , dayid
                                , ipaddress
                            )
                            values (
                                :csldate,
                                :cntlno,
                                :dayid,
                                :ipaddress
                            )
                    ";
                    connection.Execute(sql, param);
                    ret = Insert.Normal;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 端末管理テーブルレコードを削除する
        /// </summary>
        /// <param name="ipAddress">IPアドレス</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteWorkStation(string ipAddress)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ipaddres", ipAddress.Trim());

            // 検索条件を満たす２次請求明細テーブルのレコードを取得
            sql = @"
                    delete workstation
                    where
                      ipaddress = :ipaddres
            ";

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 端末通過情報テーブルレコードを削除する
        /// </summary>
        /// <param name="clsDate">受診日</param>
        /// <param name="cntlNo">管理番号</param>
        /// <param name="dayId">当日ＩＤ</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeletePassedInfo(DateTime clsDate, int cntlNo, int dayId, string ipAddress)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", clsDate);
            param.Add("cntlno", cntlNo);
            param.Add("dayid", dayId);
            param.Add("ipaddres", ipAddress.Trim());

            // 検索条件を満たす２次請求明細テーブルのレコードを取得
            sql = @"
                    delete passedinfo
                    where
                      csldate = :csldate
                      and cntlno = :cntlno
                      and dayid = :dayid
                      and ipaddress = :ipaddress
            ";

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 管理端末情報のバリデーションを行う
        /// </summary>
        /// <param name="data">データ</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateForMntWorkStation(RegisterWorkStation data)
        {
            var messages = new List<string>();

            if (Workstation.Ipaddress.Valid(data.IpAddress?.Trim(), messages))
            {
                var ipAddress = data.IpAddress?.Trim();
                if (ipAddress.Split('.').Length != 4 ||
                    !System.Net.IPAddress.TryParse(ipAddress, out System.Net.IPAddress address))
                {
                    messages.Add(string.Format("指定した{0}は有効なIPアドレスではありません。", Workstation.Ipaddress.ColumnName));
                }
            }
            Workstation.Wkstnname.Valid(data.WkstnName?.Trim(), messages);
            if (Workstation.Grpcd.Valid(data.GrpCd?.Trim(), messages))
            {
                var grpCd = data.GrpCd?.Trim();
                if (!string.IsNullOrEmpty(grpCd) && grpDao.SelectGrp_P(grpCd) == null)
                {
                    messages.Add(string.Format("指定した{0}は存在しません。", Workstation.Grpcd.ColumnName));
                }
            }
            Workstation.Progresscd.Valid(data.ProgressCd?.Trim(), messages);
            Workstation.Isprintbutton.Valid(data.IsPrintButton?.Trim(), messages);

            return messages;
        }
    }
}