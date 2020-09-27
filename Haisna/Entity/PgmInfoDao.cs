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
    /// プログラム情報データアクセスオブジェクト
    /// </summary>
    public class PgmInfoDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PgmInfoDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// プログラム情報テーブルレコードを削除する
        /// </summary>
        /// <param name="pgmCd">プログラムコード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeletePgmInfo(string pgmCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("pgmcd", pgmCd.Trim());

            // セット分類テーブルレコードの削除
            sql = @"
                    delete pgminfo
                    where
                      pgmcd = :pgmcd
                ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// プログラム情報テーブルレコードを削除する
        /// </summary>
        /// <param name="usrGrpCd">ユーザーグループコード</param>
        /// <param name="pgmCd">プログラムコード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteGrp_PgmInfo(string usrGrpCd, string pgmCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("usrgrpcd", usrGrpCd.Trim());
            param.Add("pgmcd", pgmCd.Trim());

            // セット分類テーブルレコードの削除
            sql = @"
                    delete grp_pgminfo
                    where
                      usrgrpcd = :usrgrpcd
                      and pgmcd = :pgmcd
                ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 検索条件を満たす依頼項目名の一覧を取得する
        /// </summary>
        /// <param name="selectKey">検索条件キー</param>
        /// <param name="selectMode">検索条件</param>
        /// <returns>
        /// pgmCd プログラムコード
        /// pgmName プログラム名
        /// pgmFileName プログラムファイル名
        /// pgmFilePath プログラムファイル経路
        /// linkImage リンクイメージ
        /// menuGrpCd メニューグループコード
        /// pgmDesc プログラム説明
        /// delFlg 使用可否フラッグ
        /// menuName メニュー名
        /// yudoBunrui 分類
        /// yobi1 予備１
        /// yobi2 予備２
        /// </returns>
        public List<dynamic> SelectPgmInfo(string selectKey, int selectMode)
        {
            string sql; // SQLステートメント
            var param = new Dictionary<string, object>();

            // キー値の設定
            switch (selectMode)
            {
                case 0:
                    param.Add("pgmcode", selectKey);
                    break;
                case 1:
                case 2:
                    param.Add("menugrpcd", selectKey);
                    break;
                default:
                    throw new ArgumentException();
            }

            // 検索条件を満たす依頼項目テーブルのレコードを取得
            sql = @"
                    select
                      pgmcd
                      , pgmname
                      , pgmfilename
                      , pgmfilepath
                      , linkimage
                      , menugrpcd
                      , pgmdesc
                      , delflg
                      , yudobunrui
                      , yobi1
                      , yobi2
                      , free.freefield1 menuname
                    from
                      pgminfo
                      , free
                ";

            switch (selectMode)
            {
                case 0:
                    sql += @"
                            where
                              pgmcd = :pgmcode
                              and free.freeclasscd = 'PGM'
                              and menugrpcd = free.freecd
                         ";
                    break;
                case 1:
                    sql += @"
                            where
                              menugrpcd = :menugrpcd
                              and pgminfo.delflg = 0
                              and free.freeclasscd = 'PGM'
                              and menugrpcd = free.freecd
                         ";
                    break;
                case 2:
                    sql += @"
                            where
                              menugrpcd = :menugrpcd
                              and free.freeclasscd = 'PGM'
                              and menugrpcd = free.freecd
                         ";
                    break;
                default:
                    throw new ArgumentException();
            }

            sql += @"
                    order by
                      pgmcd
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// プログラム情報レコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">コーステーブル情報
        /// pgmCd プログラムコード
        /// pgmName プログラム名
        /// startPgm 起動プログラム
        /// filePath ファイル経路
        /// linkImage リンクイメージ
        /// menuGrpCd メニューグループコード
        /// pgmDesc プログラム説明
        /// delFlag 使用可否フラッグ
        /// yudoBunrui 分類
        /// yobi1 予備１
        /// yobi2 予備２
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistPgmInfo(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("pgmcd", Convert.ToString(data["pgmCd"]));
            param.Add("pgmname", Convert.ToString(data["pgmName"]));
            param.Add("startpgm", Convert.ToString(data["startpgm"]));
            param.Add("filepath", Convert.ToString(data["filePath"]));
            param.Add("linkimage", Convert.ToString(data["linkImage"]));
            param.Add("menugrpcd", Convert.ToString(data["menuGrpCd"]));
            param.Add("pgmdesc", Convert.ToString(data["pgmDesc"]));
            param.Add("delflag", Convert.ToString(data["delFlag"]));
            param.Add("yudobunrui", Convert.ToString(data["yudoBunrui"]));
            param.Add("yobi1", Convert.ToString(data["yobi1"]));
            param.Add("yobi2", Convert.ToString(data["yobi2"]));

            while (true)
            {
                // 文章分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update pgminfo
                            set
                              pgmname = :pgmname
                              , pgmfilename = :startpgm
                              , pgmfilepath = :filepath
                              , linkimage = :linkimage
                              , menugrpcd = :menugrpcd
                              , pgmdesc = :pgmdesc
                              , delflg = :delflag
                              , yudobunrui = :yudobunrui
                              , yobi1 = :yobi1
                              , yobi2 = :yobi2
                            where
                              pgmcd = :pgmcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす文章分類テーブルのレコードを取得
                sql = @"
                        select
                          pgmcd
                        from
                          pgminfo
                        where
                          pgmcd = :pgmcd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into pgminfo(
                          pgmcd
                          , pgmname
                          , pgmfilename
                          , pgmfilepath
                          , linkimage
                          , menugrpcd
                          , pgmdesc
                          , delflg
                          , yudobunrui
                          , yobi1
                          , yobi2
                        )
                        values (
                          :pgmcd
                          , :pgmname
                          , :startpgm
                          , :filepath
                          , :linkimage
                          , :menugrpcd
                          , :pgmdesc
                          , :delflag
                          , :yudobunrui
                          , :yobi1
                          , :yobi2
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
        /// ユーザーグループ別プログラム情報レコードを登録する
        /// </summary>
        /// <param name="data">ユーザーグループ別プログラム情報</param>
        /// usrGrpCd ユーザーグループ
        /// pgmCd プログラムコード
        /// pgmGrant プログラム操作権限
        /// dispSeq 画面標示順序
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistGrp_PgmInfo(JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            using (var transaction = BeginTransaction())
            {

                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("usrgrpcd", Convert.ToString(data["usrGrpCd"]));

                sql = @"
                        delete grp_pgminfo
                        where
                          usrgrpcd = :usrgrpcd
                    ";
                // グループ内プログラム項目レコードの削除
                connection.Execute(sql, param);

                List<JToken> items = data.ToObject<List<JToken>>();

                if (items.Count > 0)
                {
                    // パラメーター値設定
                    var paramArray = new List<dynamic>();
                    foreach (var rec in items)
                    {
                        // キー及び更新値の設定再割り当て
                        param = new Dictionary<string, object>();
                        param.Add("usrgrpcd", Convert.ToString(rec["usrGrpCd"]));
                        param.Add("pgmcd", Convert.ToString(rec["pgmCd"]));
                        param.Add("pgmgrant", Convert.ToString(rec["pgmGrant"]));
                        param.Add("dispseq", Convert.ToString(rec["dispSeq"]));

                        paramArray.Add(param);
                    }

                    // 新規挿入
                    sql = "";

                    sql = @"
                            insert
                            into grp_pgminfo(
                              usrgrpcd
                              , pgmcd
                              , pgmgrant
                              , dispseq
                            )
                            values (
                              :usrgrpcd
                              , :pgmcd
                              , :pgmgrant
                              , :dispseq
                            )
                        ";

                    ret2 = connection.Execute(sql, paramArray);

                    if (ret2 >= 0)
                    {
                        ret = Insert.Normal;
                        transaction.Commit();
                    }
                    else
                    {
                        // 異常終了ならRollBack
                        transaction.Rollback();
                    }
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 検索条件を満たす依頼項目名の一覧を取得する
        /// </summary>
        /// <param name="selectKey">検索条件キー</param>
        /// <param name="selectMode">検索条件</param>
        /// <returns>
        /// usrGrpCd ユーザーグループ
        /// pgmCd プログラムコード
        /// pgmGrant プログラム操作権限フラグ
        /// dispSeq 画面表示順序
        /// delFlg 使用可否フラッグ
        /// pgmName プログラム名称
        /// pgmFileName プログラムファイル名
        /// linkImage リンクイメージ
        /// menuGrpCd メニューグループコード
        /// pgmDesc プログラム説明
        /// menuName メニュー名
        /// grantName プログラム操作権限名
        /// </returns>
        public List<dynamic> SelectGrp_PgmInfoList(string selectKey, int selectMode)
        {
            string sql; // SQLステートメント
            var param = new Dictionary<string, object>();

            if (1 == selectMode)
            {
                param.Add("usrgrpcd", selectKey);
            }
            // 検索条件を満たす依頼項目テーブルのレコードを取得
            sql = @"
                    select
                      b.usrgrpcd
                      , b.pgmcd
                      , b.pgmgrant
                      , b.dispseq
                      , a.delflg
                      , a.pgmname
                      , a.pgmfilename
                      , a.linkimage
                      , a.menugrpcd
                      , a.pgmdesc
                      , c.freefield1 menuname
                      , decode(
                        b.pgmgrant
                        , 1
                        , '参照のみ'
                        , 2
                        , '登録(変更)'
                        , 3
                        , '削除'
                        , 4
                        , 'スーパーユーザ'
                      ) grantname
                    from
                      pgminfo a
                      , grp_pgminfo b
                      , free c
                    where
                      a.pgmcd = b.pgmcd
                      and c.freeclasscd = 'PGM'
                      and a.menugrpcd = c.freecd
                ";

            if (1 == selectMode)
            {
                sql += @"
                        and b.usrgrpcd = :usrgrpcd
                     ";
            }

            sql += @"
                    order by
                      b.usrgrpcd
                      , b.dispseq
                 ";

            return connection.Query(sql, param).ToList();
        }
    }
}
