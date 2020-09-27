using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 結果コメント情報データアクセスオブジェクト
    /// </summary>
    public class RslCmtDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public RslCmtDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        ///  結果コメントの一覧を取得する
        /// </summary>
        /// <returns>
        /// rslCmtCd 結果コメントコード
        /// rslCmtName 結果コメント名
        /// entryOk 入力完了フラグ（省略可）
        /// </returns>
        public List<dynamic> SelectRslCmtList()
        {
            string sql = "";    // SQLステートメント

            // 結果コメントテーブルよりレコードを取得
            sql = @"
                    select
                      rslcmtcd
                      , rslcmtname
                      , entryok
                    from
                      rslcmt
                    order by
                      rslcmtcd
            ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 結果コメントデータを取得する
        /// </summary>
        /// <param name="rslCmtCd">結果コメントコード</param>
        /// <returns>
        /// rslCmtName 結果コメント名
        /// entryOk 入力完了フラグ
        /// </returns>
        public dynamic SelectRslCmt(String rslCmtCd)
        {
            string sql = "";    // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rslcmtcd", rslCmtCd.Trim());

            // 検索条件を満たす結果コメントテーブルのレコードを取得
            sql = @"
                    select
                      rslcmtname
                      , entryok
                    from
                      rslcmt
                    where
                      rslcmtcd = :rslcmtcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定予約番号における指定汎用コード内グループの結果コメントを取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="freeCd">汎用コード</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="grpName">グループ名</param>
        /// <param name="consults">受診フラグ(値があれば依頼あり)</param>
        /// <param name="rslCmtCd">結果コメントコード</param>
        /// <param name="rslCmtName">結果コメント名</param>
        /// <returns>レコード件数</returns>
        public long SelectRslCmtListForChangeSet(long rsvNo, String freeCd, ref List<string> grpCd, ref List<string> grpName, ref List<string> consults, ref List<string> rslCmtCd, ref List<string> rslCmtName)
        {
            string sql = "";                                    // SQLステートメント
            long ret = 0;                                       // 戻り値

            string prevGrpCd = "";                              // 現レコードのグループコード
            string[] editGrpCd = null;                          // 編集済み結果コメントコードの配列
            bool editFlg = false;                               // 編集済みフラグ

            Int32 count = 0;                                    // レコード数

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("freecd", freeCd+"%");

            // 検索条件を満たす結果コメントテーブルのレコードを取得
            sql = @"
                    select
                      grp_p.grpcd
                      , grp_p.grpname
                      , rsl.itemcd
                      , rsl.suffix
                      , rsl.rslcmtcd2
                      , rslcmt.rslcmtname
                    from
                      rslcmt
                      , rsl
                      , grp_r
                      , grp_p
                      , (
                        select distinct
                          freefield1 grpcd
                        from
                          free
                        where
                          freecd like :freecd
                          and freefield1 is not null
                      ) chgsetgrp
                    where
                      chgsetgrp.grpcd = grp_p.grpcd
                      and grp_p.grpcd = grp_r.grpcd(+)
                      and :rsvno = rsl.rsvno(+)
                      and grp_r.itemcd = rsl.itemcd(+)
                      and rsl.rslcmtcd2 = rslcmt.rslcmtcd(+)
                    order by
                      grp_p.grpcd
                      , grp_r.itemcd
                      , rsl.suffix
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            //
            // 検索レコードが存在する場合
            if (current.Count > 0)
            {


                // 配列形式で格納する
                for (int i = 0; i < current.Count; i++)
                {
                    // 直前レコードとグループが異なった時点で空の配列を作成
                    if (!Util.ConvertToString(current[i].GRPCD).Equals(prevGrpCd))
                    {
                        grpCd.Add("");
                        grpName.Add("");
                        rslCmtCd.Add("");
                        rslCmtName.Add("");
                        consults.Add("");
                        count++;
                    }

                    // グループコード、名称は常に編集
                    grpCd[count - 1] = Util.ConvertToString(current[i].GRPCD);
                    grpName[count - 1] = Util.ConvertToString(current[i].GRPNAME);

                    // 検査結果テーブルの検査項目コードが１つでもあれば受診対象とする
                    if (!string.IsNullOrEmpty(Util.ConvertToString(current[i].ITEMCD)))
                    {
                        consults[count - 1] = "1";
                    }

                    // 結果コメントコードが存在する場合はその内容をスタックする
                    if (!string.IsNullOrEmpty(Util.ConvertToString(current[i].RSLCMTCD2)))
                    {
                        // すでに何らかが編集されている場合
                        if (!string.IsNullOrEmpty(Util.ConvertToString(rslCmtCd[count - 1])))
                        {
                            // 編集済み結果コメントコードを配列化する
                            editGrpCd = Util.ConvertToString(rslCmtCd[count - 1]).Split((char)1);

                            // 今から編集するコードがすでに存在するかをチェック
                            editFlg = false;
                            for (int j = 0; j < editGrpCd.Length; j++)
                            {
                                if (editGrpCd[j].Equals(Util.ConvertToString(current[i].RSLCMTCD2)))
                                {
                                    editFlg = true;
                                    break;
                                }
                            }

                            // 未編集であれば追加
                            if (!editFlg)
                            {
                                rslCmtCd[count - 1] = rslCmtCd[count - 1] + (char)1 + Util.ConvertToString(current[i].RSLCMTCD2);
                                rslCmtName[count - 1] = rslCmtName[count - 1] + (char)1 + Util.ConvertToString(current[i].RSLCMTNAME);
                            }

                        }
                        // 初めて追加する場合はそのまま編集
                        else
                        {
                            rslCmtCd[count - 1] = Util.ConvertToString(current[i].RSLCMTCD2);
                            rslCmtName[count - 1] = Util.ConvertToString(current[i].RSLCMTNAME);
                        }

                    }

                    // 現レコードのグループコードを退避
                    prevGrpCd = Util.ConvertToString(current[i].GRPCD);
                }

                ret = grpCd.Count;
            }


            return ret;
        }

        /// <summary>
        /// 結果コメントテーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// rslcmtcd 結果コメントコード
        /// rslcmtname 結果コメント名
        /// entryok 入力完了フラグ
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistRslCmt(String mode, JToken data)
        {
            string sql = "";    // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rslcmtcd", Convert.ToString(data["rslcmtcd"]).Trim());
            param.Add("rslcmtname", Convert.ToString(data["rslcmtname"]).Trim());
            param.Add("entryok", Convert.ToString(data["entryok"]).Trim());

            while (true)
            {
                // 結果コメントテーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update rslcmt
                            set
                              rslcmtname = :rslcmtname
                              , entryok = :entryok
                            where
                              rslcmtcd = :rslcmtcd
                        ";
                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす結果コメントテーブルのレコードを取得
                sql = @"
                        select
                          rslcmtcd
                        from
                          rslcmt
                        where
                          rslcmtcd = :rslcmtcd
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
                        into rslcmt(
                            rslcmtcd
                            , rslcmtname
                            , entryok
                        )
                        values (
                            :rslcmtcd
                            , :rslcmtname
                            , :entryok
                        )
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 結果コメントテーブルレコードを削除する
        /// </summary>
        /// <param name="rslCmtCd">結果コメントコード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteRslCmt(String rslCmtCd)
        {
            string sql = "";    // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rslcmtcd", rslCmtCd);

            // 団体請求書分類テーブルへのレコード削除
            sql = @"
                    delete rslcmt
                    where
                      rslcmtcd = :rslcmtcd
                ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }
    }
}
