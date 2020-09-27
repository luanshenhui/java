using Dapper;
using Hainsi.Common.Constants;
using Hainsi.Common.Table;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// グループ情報データアクセスオブジェクト
    /// </summary>
    public class GrpDao : AbstractDao
    {
        /// <summary>
        /// 検査項目テーブル以外のサフィックスの値(ダミー)
        /// </summary>
        const string DUMMY_SUFFIX = "";

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public GrpDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 検索条件を満たすグループの一覧を取得する
        /// </summary>
        /// <param name="grpDiv">検索グループ区分</param>
        /// <param name="classCd">検査分類コード（省略可）</param>
        /// <param name="searchChar">ガイド検索用文字列</param>
        /// <param name="noDataFound">true:検査項目なしでも索引する</param>
        /// <param name="omitSystemGrp">true:システムで使用するグループは除外する</param>
        /// <returns>グループ情報</returns>
        public List<dynamic> SelectGrp_IList_GrpDiv(GrpDiv grpDiv, string classCd = null, string searchChar = null, bool noDataFound = false, bool omitSystemGrp = false)
        {
            string sql; // SQLステートメント

            // 検索条件が設定されていない場合は処理を終了する
            switch (grpDiv)
            {
                case GrpDiv.R:
                    break;
                case GrpDiv.I:
                    break;
                default:
                    throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpdiv", (int)grpDiv);

            // 検索条件を満たすグループテーブルのレコードを取得
            sql = @"
                select
                    gp.grpdiv
                    , gp.grpcd
                    , gp.grpname
                    , gp.classcd
                    , it.classname
                    , gp.searchchar
                    , gp.systemgrp
                    , gp.oldsetcd
                from
                    itemclass it
                    , grp_p gp
                where
                    gp.grpdiv = :grpdiv
                    and gp.classcd = it.classcd
            ";

            if (omitSystemGrp)
            {
                sql += @"
                    and gp.systemgrp is null
                ";
            }

            // 検査分類コードが指定されている、かつ空白でない場合
            if (!string.IsNullOrEmpty(classCd))
            {
                param.Add("classcd", classCd.Trim());
                sql += @"
                    and gp.classcd = :classcd
                ";
            }

            // 依頼項目指定、かつアイテムなし検索が指定されていない場合
            if ((grpDiv == GrpDiv.R) && !noDataFound)
            {
                sql += @"
                    and exists (
                        select
                            gr.itemcd
                        from
                            grp_r gr
                        where
                            gr.grpcd = gp.grpcd
                    )
                ";
            }

            // 検査項目指定、かつアイテムなし検索が指定されていない場合
            if ((grpDiv == GrpDiv.I) && !noDataFound)
            {
                sql += @"
                    and exists (
                        select
                            gi.itemcd
                        from
                            grp_i gi
                        where
                            gi.grpcd = gp.grpcd
                    )
                ";
            }

            // ガイド検索用文字列キーの編集
            if (!string.IsNullOrEmpty(searchChar))
            {
                // 全角・半角両方に対応するよう変換
                string searchCharW = Strings.StrConv(searchChar, VbStrConv.Wide);
                string searchCharN = Strings.StrConv(searchChar, VbStrConv.Narrow);

                // キー値の再設定
                param.Add("searchcharw", searchCharW.Trim());
                param.Add("searchcharn", searchCharN.Trim());

                // 検索キー値を編集
                sql += @"
                    and gp.searchchar in (:searchcharw, :searchcharn)
                ";
            }

            sql += @"
                order by
                    gp.grpdiv
                    , gp.grpcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たすグループの基本情報を取得する
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <returns>
        /// グループ情報
        /// grpcd グループコード
        /// grpname グループ名
        /// classcd 検査分類コード
        /// grpdiv グループ区分
        /// searchchar ガイド検索用文字列
        /// systemgrp システム制御グループ
        /// oldsetcd 旧セットコード
        /// </returns>
        public dynamic SelectGrp_P(string grpCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // 検索条件を満たすグループテーブルのレコードを取得
            sql = @"
                select
                    grpcd
                    , grpname
                    , classcd
                    , grpdiv
                    , searchchar
                    , systemgrp
                    , oldsetcd
                from
                    grp_p
                where
                    grpcd = :grpcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たすグループ名の一覧を取得する
        /// </summary>
        /// <param name="grpDiv">グループ区分</param>
        /// <param name="classCd">検査分類コード</param>
        /// <param name="searchCharKey">ガイド検索用文字列</param>
        /// <param name="omitSystemGrp">true:システムで使用するグループは除外する</param>
        /// <returns>グループ情報
        /// grpcd グループコード
        /// suffix サフィックス(ダミー：空白固定)
        /// grpname グループ名
        /// </returns>
        public List<dynamic> SelectGrp_pList(GrpDiv grpDiv, string classCd, string searchCharKey, bool omitSystemGrp = false)
        {
            string sql; // SQLステートメント

            string searchCharW = null;   // 検索文字(全角)
            string searchCharN = null;   // 検索文字(半角)

            // 問診項目表示有無条件が設定されていない場合はエラー
            if (!((grpDiv == GrpDiv.R) || (grpDiv == GrpDiv.I)))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpdiv", grpDiv);
            param.Add("classcd", classCd.Trim());
            param.Add("searchcharw", searchCharW.Trim());
            param.Add("searchcharn", searchCharN.Trim());

            // 検索条件を満たす依頼項目テーブルのレコードを取得
            sql = @"
                select
                    grpcd
                    , null suffix
                    , grpname
                from
                    grp_p
            ";

            // WHERE句の編集
            sql += @"
                where
            ";

            // グループ区分による条件編集
            sql += @"
                    grpdiv = :grpdiv
            ";

            if (omitSystemGrp == true)
            {
                sql += @"
                    and grp_p.systemgrp is null
                ";
            }

            // 検査分類コードキーの編集
            if (!string.IsNullOrEmpty(classCd))
            {
                // 検索キー値を編集
                sql += @"
                    and classcd = :classcd
                ";
            }

            // ガイド検索用文字列キーの編集
            if (!string.IsNullOrEmpty(searchCharKey))
            {
                // 全角・半角両方に対応するよう変換
                searchCharW = Strings.StrConv(searchCharKey, VbStrConv.Wide);
                searchCharN = Strings.StrConv(searchCharKey, VbStrConv.Narrow);

                // キー値の再設定
                param.Add("searchcharw", searchCharW.Trim());
                param.Add("searchcharn", searchCharN.Trim());

                // 検索キー値を編集
                sql += @"
                    and searchchar in (:searchcharw, :searchcharn)
                ";
            }

            sql += @"
                order by grpcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす検査項目名の一覧を取得する
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <returns>検査項目の一覧
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// itemname 検査項目名称
        /// </returns>
        public List<dynamic> SelectGrpItem_cList(string grpCd)
        {
            string sql; // SQLステートメント

            // 対象検査グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // 検索条件を満たす検査項目テーブルのレコードを取得
            sql = @"
                select
                    gi.itemcd
                    , gi.suffix
                    , ic.itemname
                from
                    grp_i gi
                    , item_c ic
                where
                    gi.grpcd = :grpcd
                    and gi.itemcd = ic.itemcd
                    and gi.suffix = ic.suffix
                order by
                    gi.seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// グループ内の全検査項目を取得する（検査項目）
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <returns>
        /// 検査項目の一覧
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// itemname 検査項目名
        /// resulttype 結果タイプ
        /// itemtype 項目タイプ
        /// stcitemcd 文章参照用項目コード
        /// classname 検査分類名称
        /// seq 表示順番
        /// </returns>
        public List<dynamic> SelectGrp_I_ItemList(string grpCd)
        {
            string sql; // SQLステートメント

            // グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // 検索条件を満たす受診歴情報のレコードを取得
            sql = @"
                select
                    gi.itemcd
                    , gi.suffix
                    , ic.itemname
                    , ic.resulttype
                    , ic.itemtype
                    , ic.stcitemcd
                    , cs.classname
                    , gi.seq
                from
                    itemclass cs
                    , grp_p gp
                    , grp_i gi
                    , item_c ic
                    , item_p ip
                where
                    gp.grpcd = :grpcd
                    and gp.grpcd = gi.grpcd
                    and gi.itemcd = ic.itemcd
                    and gi.suffix = ic.suffix
                    and ip.itemcd = ic.itemcd
                    and ip.classcd = cs.classcd
                order by
                    gi.seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// グループ内の全検査項目及び見出しコメントを取得する（検査項目）
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <returns>
        /// 検査項目の一覧
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// itemname 検査項目名
        /// resulttype 結果タイプ
        /// stcitemcd 文章参照用項目コード
        /// itemtype 項目タイプ
        /// classname 検査分類名称
        /// seq 表示順番
        /// rslCaption 見出し
        /// </returns>
        public List<dynamic> SelectGrp_I_ItemList_AddCaption(string grpCd)
        {
            string sql; // SQLステートメント

            // グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // 検索条件を満たす受診歴情報のレコードを取得
            sql = @"
                select
                    grp_i.itemcd
                    , grp_i.suffix
                    , item_c.itemname
                    , item_c.resulttype
                    , item_c.stcitemcd
                    , item_c.itemtype
                    , itemclass.classname
                    , grp_i.seq
                    , grp_i.rslcaption
                from
                    item_c
                    , grp_p
                    , grp_i
                    , item_p
                    , itemclass
                where
                    grp_p.grpcd = :grpcd
                    and grp_i.grpcd = grp_p.grpcd
                    and grp_i.itemcd = item_c.itemcd(+)
                    and grp_i.suffix = item_c.suffix(+)
                    and item_c.itemcd = item_p.itemcd(+)
                    and item_p.classcd = itemclass.classcd(+)
                order by
                    grp_i.seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// グループ内の全検査項目を取得する（依頼項目）
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <returns>依頼項目の一覧
        /// itemcd 検査項目コード
        /// requestname 依頼項目名
        /// classname 検査分類名称
        /// </returns>
        public List<dynamic> SelectGrp_R_ItemList(string grpCd)
        {
            string sql; // SQLステートメント

            // グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // 検索条件を満たす受診歴情報のレコードを取得
            sql = @"
                select
                    grp_r.itemcd
                    , item_p.requestname
                    , itemclass.classname
                from
                    itemclass
                    , item_p
                    , grp_r
                where
                    grp_r.grpcd = :grpcd
                    and grp_r.itemcd = item_p.itemcd
                    and item_p.classcd = itemclass.classcd
                order by
                    grp_r.itemcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// グループ内の全検査項目および初期値を取得する
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <param name="cslDate">受診日</param>
        /// <returns>検査項目情報
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// itemname 検査項目名
        /// resulttype 結果タイプ
        /// itemtype 項目タイプ
        /// defresult 省略時検査結果
        /// stcitemcd 文章参照用項目コード
        /// defshortstc 省略時文章略称
        /// </returns>
        public List<dynamic> SelectGrp_I_ItemDefResultList(string grpCd, DateTime cslDate)
        {
            string sql; // SQLステートメント

            // グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());
            param.Add("csldate", cslDate);

            // 検索条件を満たすレコードを取得
            sql = @"
                select
                    gl.itemcd
                    , gl.suffix
                    , gl.itemname
                    , gl.resulttype
                    , gl.itemtype
                    , gl.defresult
                    , gl.stcitemcd
                    , sc.shortstc
                from
                    (
                        select
                            gi.itemcd
                            , gi.suffix
                            , ic.itemname
                            , ic.resulttype
                            , ic.itemtype
                            , ih.defresult
                            , ic.stcitemcd
                            , gi.seq
                        from
                            grp_p gp
                            , grp_i gi
                            , item_c ic
                            , item_h ih
                        where
                            gp.grpcd = :grpcd
                            and gp.grpcd = gi.grpcd
                            and gi.itemcd = ic.itemcd
                            and gi.suffix = ic.suffix
                            and ic.itemcd = ih.itemcd(+)
                            and ic.suffix = ih.suffix(+)
                            and :csldate between ih.strdate(+) and ih.enddate(+)
                    ) gl
                    , sentence sc
                where
                    gl.stcitemcd = sc.itemcd(+)
                    and gl.itemtype = sc.itemtype(+)
                    and gl.defresult = sc.stccd(+)
                order by
                    gl.seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// グループレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">グループ情報
        ///	grpcd グループコード
        ///	classcd 検査分類コード
        ///	grpname グループ名
        ///	grpdiv グループ区分
        ///	searchchar ガイド検索用文字列
        ///	systemgrp システム制御用グループ
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// seq 表示順番
        /// rslcaption 見出挿入
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistGrp_All(string mode, JToken data)
        {
            Insert ret; // 関数戻り値

            ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    // グループテーブルの更新
                    ret = RegistGrp_p(mode, data);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    // グループ内項目テーブルの更新
                    ret = RegistGrp_Item((GrpDiv)Convert.ToInt32(data["grpdiv"]), Convert.ToString(data["grpcd"]), data["item"]);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    break;
                }

                if (ret == Insert.Normal)
                {
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// グループレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">グループ情報
        ///	grpcd グループコード
        ///	classcd 検査分類コード
        ///	grpname グループ名
        ///	grpdiv グループ区分
        ///	searchchar ガイド検索用文字列
        ///	systemgrp システム制御用グループ
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistGrp_p(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", Convert.ToString(data["grpcd"]));
            param.Add("classcd", Convert.ToString(data["classcd"]));
            param.Add("grpname", Convert.ToString(data["grpname"]));
            param.Add("grpdiv", Convert.ToString(data["grpdiv"]));
            param.Add("searchchar", Convert.ToString(data["searchchar"]));
            param.Add("systemgrp", Convert.ToString(data["systemgrp"]));

            while (true)
            {
                // グループテーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                        update grp_p
                        set
                            classcd = :classcd
                            , grpname = :grpname
                            , grpdiv = :grpdiv
                            , searchchar = :searchchar
                            , systemgrp = :systemgrp
                        where
                            grpcd = :grpcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たすグループテーブルのレコードを取得
                sql = @"
                    select
                        grpcd
                    from
                        grp_p
                    where
                        grpcd = :grpcd
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
                    into grp_p(
                        grpcd
                        , classcd
                        , grpname
                        , grpdiv
                        , searchchar
                        , systemgrp
                    )
                    values (
                        :grpcd
                        , :classcd
                        , :grpname
                        , :grpdiv
                        , :searchchar
                        , :systemgrp
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
        /// グループ内受診項目を登録する
        /// </summary>
        /// <param name="grpDiv">グループ区分</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="data">グループ内検査項目
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// seq 表示順番
        /// rslcaption 見出挿入
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistGrp_Item(GrpDiv grpDiv, string grpCd, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret; // 関数戻り値

            ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // グループ内検査項目レコードの削除
            if (grpDiv == GrpDiv.R)
            {
                // グループ区分が依頼の場合
                sql = @"
                    delete grp_r
                    where
                        grpcd = :grpcd
                ";

                connection.Execute(sql, param);
            }
            else
            {
                // グループ区分が検査の場合
                sql = @"
                    delete grp_i
                    where
                        grpcd = :grpcd
                ";

                connection.Execute(sql, param);
            }

            List<JToken> items = data.ToObject<List<JToken>>();
            if (items.Count > 0)
            {
                // パラメーター値設定
                var paramArray = new List<dynamic>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("grpcd", grpCd);
                    param.Add("itemcd", Convert.ToString(rec["itemcd"]));
                    if (grpDiv == GrpDiv.I)
                    {
                        param.Add("suffix", Convert.ToString(rec["suffix"]));
                        param.Add("seq", Convert.ToString(rec["seq"]));
                        param.Add("rslcaption", Convert.ToString(rec["rslcaption"]));
                    }
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = "";

                if (grpDiv == GrpDiv.R)
                {
                    sql = @"
                        insert
                        into grp_r(grpcd, itemcd)
                        values (:grpcd, :itemcd)
                    ";
                }
                else
                {
                    sql = @"
                        insert
                        into grp_i(grpcd, itemcd, suffix, seq, rslcaption)
                        values (:grpcd, :itemcd, :suffix, :seq, :rslcaption)
                    ";
                }

                connection.Execute(sql, paramArray);

            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// グループテーブルレコードを削除する
        /// </summary>
        /// <param name="grpCd">グループコード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteGrp_p(string grpCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("grpcd", grpCd.Trim());

            // グループテーブルレコードの削除
            sql = @"
                delete grp_p
                where
                    grpcd = :grpcd
            ";

            connection.Execute(sql, param);

            return true;
        }

        #region "新設メソッド"

        //      /// <summary>
        //      /// 編集画面用初期表示
        //      /// </summary>
        //      /// <param name="grpCd"></param>
        //      /// <returns></returns>
        //      /// <remarks>メソッド名は仮置き</remarks>
        //      public dynamic SelectGroupInfo(string grpCd)
        //      {
        //	//戻り値型宣言
        //	var rec = (dynamic) new Dictionary<string, object>();
        //          //レコード取得
        //          rec.grp_p = this.SelectGrp_P(grpCd);
        //          //指定したキーのレコードがなければNULLを返す
        //          if (rec.grp_p == null)
        //          {
        //              return null;
        //          }
        //          //グループ区分により取得項目を変更
        //          if (rec.grp_p.GRPDIV == GrpDiv.I)
        //          {
        //		//検査項目取得
        //		rec.grp_i = this.SelectGrp_I_ItemList_AddCaption(grpCd);
        //          }
        //          else
        //          {
        //		//依頼項目取得
        //		rec.grp_r = this.SelectGrp_R_ItemList(grpCd);
        //          }
        //	//取得したレコードを返す
        //	return rec;
        //      }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> Validate(JToken data)
        {
            var messages = new List<string>();
            if ((data["grpcd"] == null) || (string.IsNullOrEmpty(data["grpcd"].ToString())))
            {
                // グループコード未入力チェック
                messages.Add(string.Format("{0}が入力されていません。", Grp_p.Grpcd.ColumnName));
            }
            else
            {
                // グループコードチェック
                Grp_p.Grpcd.Valid(data["grpcd"], messages);
            }

            // グループ名未入力チェック
            if ((data["grpname"] == null) || (string.IsNullOrEmpty(data["grpname"].ToString())))
            {
                messages.Add(string.Format("{0}が入力されていません。", Grp_p.Grpname.ColumnName));
            }
            else
            {
                //グループ名チェック
                Grp_p.Grpname.Valid(data["grpname"], messages);
            }

            return messages;
        }

        //      /// <summary>
        //      /// グループを登録する
        //      /// </summary>
        //      /// <returns>登録件数</returns>
        //      public int RegisterGrp_p(string mode, JToken data)
        //      {
        //          // システム制御用グループの表記を"1"に統一
        //          if (Convert.ToString(data["systemgrp"]) == "true" || Convert.ToString(data["systemgrp"]) == "1")
        //          {
        //              data["systemgrp"] = "1";
        //          }
        //          else
        //          {
        //              data["systemgrp"] = "";
        //          }
        //	// 登録実行
        //          int count = RegistGrp_All(mode, data);
        //          return count;
        //      }
        ///// <summary>
        ///// 依頼項目のグループ区分コード
        ///// </summary>
        //      private const int GrpDiv.R = 1;
        ///// <summary>
        ///// 検査項目のグループ区分コード
        ///// </summary>
        //      private const int GrpDiv.I = 2;
        //      /// <summary>
        //      /// 検索条件を満たすグループテーブルのレコードを取得
        //      /// </summary>
        //      /// <param name="grpCd">グループコード</param>
        //      /// <returns>グループテーブルのレコード</returns>
        //      public dynamic SelectGrp_P(string grpCd)
        //      {
        //	// SQL定義
        //	// ※列GRPCDは旧ソースのステートメントには含まれていないが、
        //	// 呼び元側ではグループコードが格納された状態で取得したいため、
        //	// ここで列を追加しておく
        //	string sql = @"
        //              select
        //                  grpcd
        //                  , grpname
        //                  , classcd
        //                  , grpdiv
        //                  , searchchar
        //                  , systemgrp
        //                  , oldsetcd
        //              from
        //                  grp_p
        //              where
        //                  grpcd = :grpcd
        //	";
        //	// パラメータセット
        //          var sqlParam = new
        //          {
        //              grpcd = grpCd
        //          };
        //	// SQL実行
        //	return connection.Query(sql, sqlParam).FirstOrDefault();
        //      }
        //      /// <summary>
        //      /// グループ内の全検査項および見出しコメントを取得する（検査項目）
        //      /// </summary>
        //      /// <param name="grpCd">グループコード</param>
        //      /// <returns>グループ内の全検査項目及び見出しコメント</returns>
        //      public List<dynamic> SelectGrp_I_ItemList_AddCaption(string grpCd)
        //      {
        //	// SQL定義
        //	string sql = @"
        //                  select
        //                    grp_i.itemcd
        //                    , grp_i.suffix
        //                    , item_c.itemname
        //                    , item_c.resulttype
        //                    , item_c.stcitemcd
        //                    , item_p.itemcd
        //                    , item_c.itemtype
        //                    , itemclass.classname
        //                    , grp_i.seq
        //                    , grp_i.rslcaption
        //                    , grp_i.itemcd || '-' || grp_i.suffix || ' ' || item_c.itemname || ' ' || itemclass.classname as name
        //                  from
        //                    item_c
        //                    , grp_p
        //                    , grp_i
        //                    , item_p
        //                    , itemclass
        //                  where
        //                    grp_p.grpcd = :grpcd
        //                    and grp_i.grpcd = grp_p.grpcd
        //                    and grp_i.itemcd = item_c.itemcd(+)
        //                    and grp_i.suffix = item_c.suffix(+)
        //                    and item_c.itemcd = item_p.itemcd(+)
        //                    and item_p.classcd = itemclass.classcd(+)
        //                  order by
        //                    grp_i.seq ";
        //	// パラメータセット
        //	var sqlParam = new
        //          {
        //              grpcd = grpCd
        //          };
        //	// SQL実行
        //	return connection.Query(sql, sqlParam).ToList();
        //      }
        //      /// <summary>
        //      /// グループ内の全検査項目を取得する（依頼項目）
        //      /// </summary>
        //      /// <param name="grpCd">グループコード</param>
        //      /// <returns>グループ内の全検査項目</returns>
        //      public List<dynamic> SelectGrp_R_ItemList(string grpCd)
        //      {
        //	// SQL定義
        //          string sql = @"
        //                  select
        //                    grp_r.itemcd
        //                    , item_p.requestname
        //                    , itemclass.classname
        //                  from
        //                    itemclass
        //                    , item_p
        //                    , grp_r
        //                  where
        //                    grp_r.grpcd = :grpcd
        //                    and grp_r.itemcd = item_p.itemcd
        //                    and item_p.classcd = itemclass.classcd
        //                  order by
        //                    grp_r.itemcd ";
        //	// パラメータセット
        //          var sqlParam = new
        //          {
        //              grpcd = grpCd
        //          };
        //	// SQL実行
        //	return connection.Query(sql, sqlParam).ToList();
        //}
        //      /// <summary>
        //      /// コースレコードを登録する
        //      /// </summary>
        //      /// <param name="mode">登録処理モード</param>
        //      /// <param name="data">登録データ</param>
        //      /// <returns>処理データ件数</returns>
        //      private int RegistGrp_All(string mode, JToken data)
        //      {
        //	int count = 0;
        //	using (var transaction = BeginTransaction())
        //	{
        //		// グループテーブルの更新
        //		count = RegistGrp_p(mode, data);
        //		// 更新対象がなければロールバック
        //		if (count == 0)
        //		{
        //			transaction.Rollback();
        //			return count;
        //		}
        //		// グループ内項目テーブルの更新
        //		this.RegistGrp_Item(data);
        //		transaction.Commit();
        //	}
        //	return count;
        //      }
        //      /// <summary>
        //      /// コースレコードを登録する（トランザクション対応）
        //      /// </summary>
        //      /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        //      /// <param name="data">グループ情報</param>
        //      /// <returns></returns>
        //      private int RegistGrp_p(string mode, JToken data)
        //      {
        //	// パラメータセット
        //	var sqlParam = new
        //          {
        //              grpcd = Convert.ToString(data["grpcd"]),
        //              grpname = Convert.ToString(data["grpname"]),
        //              grpdiv = Convert.ToString(data["grpdiv"]),
        //              classcd = Convert.ToString(data["classcd"]),
        //              searchchar = Convert.ToString(data["searchchar"]),
        //              systemgrp = Convert.ToString(data["systemgrp"]),
        //              oldsetcd = Convert.ToString(data["oldsetcd"])
        //          };
        //          string sql;
        //          int count;
        //          // コーステーブルレコードの更新
        //          if (mode == "UPD")
        //          {
        //		// SQL定義
        //              sql = @"
        //                  update grp_p
        //                  set
        //                    classcd = :classcd
        //                    , grpname = :grpname
        //                    , grpdiv = :grpdiv
        //                    , searchchar = :searchchar
        //                    , systemgrp = :systemgrp
        //                    , oldsetcd = :oldsetcd
        //                  where
        //                    grpcd = :grpcd ";
        //		// SQL実行
        //		count = connection.Execute(sql, sqlParam);
        //              if (count > 0)
        //              {
        //                  return count;
        //              }
        //          }
        //          // 検索条件を満たすコーステーブルのレコードを取得
        //          sql = @"
        //              select
        //                grpcd
        //              from
        //                grp_p
        //              where
        //                grpcd = :grpcd ";
        //	// SQL実行
        //	dynamic result = Query(sql, sqlParam).FirstOrDefault();
        //	// 存在した場合、新規挿入不可
        //	if (result != null)
        //	{
        //		return 0;
        //	}
        //          // 新規挿入
        //          sql = @"
        //              insert
        //              into grp_p(
        //                grpcd
        //                , classcd
        //                , grpname
        //                , grpdiv
        //                , searchchar
        //                , systemgrp
        //                , oldsetcd
        //              )
        //              values (
        //                :grpcd
        //                , :classcd
        //                , :grpname
        //                , :grpdiv
        //                , :searchchar
        //                , :systemgrp
        //                , :oldsetcd
        //              ) ";
        //	// SQL実行
        //	count = connection.Execute(sql, sqlParam);
        //	return count;
        //      }

        /// <summary>
        /// グループレコードを取得する
        /// </summary>
        /// <param name="qp">クエリパラメータ</param>
        /// <returns>グループレコード</returns>
        public PartialDataSet SelectGrp_p(NameValueCollection qp)
        {
            string keyword = qp["keyword"];
            string page = qp["page"];
            string limit = qp["limit"];
            var sqlParam = new Dictionary<string, object>();

            // SQL定義
            string sql = @"
                          select
                            grp_p.grpdiv
                            , grp_p.grpcd
                            , grp_p.grpname
                            , grp_p.classcd
                            , itemclass.classname
                            , grp_p.systemgrp
                          from
                            grp_p
                            inner join itemclass
                              on grp_p.classcd = itemclass.classcd
                          where
                            grp_p.grpdiv = 2
            ";

            // キーワードが指定されている場合、グループ名検索条件に含める
            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " and grpname like :keyword ";
                sqlParam.Add("keyword", "%" + keyword + "%");
            }

            sql += " order by grp_p.grpcd ";

            // SQL実行
            return new PartialDataSet(Query(sql, page, limit, sqlParam));
        }

        /// <summary>
        /// 検査項目を抽出する
        /// </summary>
        /// <param name="qp">抽出条件</param>
        /// <returns>検査項目一覧</returns>
        public PartialDataSet SelectItem_C(NameValueCollection qp)
        {
            string page = qp["page"];
            string limit = qp["limit"];
            // SQL定義
            string sql = @"
                          select
                            item_c.itemcd
                            , item_c.suffix
                            , item_c.itemname
                            , item_c.resulttype
                            , item_c.itemtype
                            , item_c.stcitemcd
                            , itemclass.classname
                          from
                            item_c
                            inner join item_p
                              on item_c.itemcd = item_p.itemcd
                            inner join itemclass
                              on item_p.classcd = itemclass.classcd
                          order by
                            item_c.itemcd
                            , item_c.suffix ";
            // SQL実行
            return new PartialDataSet(Query(sql, page, limit));
        }

        ///// <summary>
        ///// 検査分類一覧を取得する
        ///// </summary>
        ///// <returns>検査分類一覧</returns>
        //public List<dynamic> SelectItemClass()
        //{
        //	// SQL定義
        //	string sql = @"
        //                  select
        //                    classcd
        //                    , classname
        //                  from
        //                    itemclass
        //                  order by
        //                    classcd ";
        //	// SQL実行
        //	return connection.Query(sql).ToList();
        //}

        ///// <summary>
        ///// グループ内受診項目を登録する
        ///// </summary>
        ///// <param name="data">グループ情報</param>
        //public void RegistGrp_Item(JToken data)
        //{
        //	// パラメータセット
        //	var sqlParam = new
        //	{
        //		grpcd = Convert.ToString(data["grpcd"]),
        //	};
        //	string sql = null;
        //	// グループ内検査項目レコードの削除
        //	if ( data["grpdiv"].Equals(GrpDiv.R) )
        //	{
        //		// グループ区分が依頼の場合
        //		// SQL定義
        //		sql = @"
        //                  delete grp_r
        //			where grpcd = :grpcd";
        //	}
        //	else
        //	{
        //		// グループ区分が検査の場合
        //		// SQL定義
        //		sql = @"
        //                  delete grp_i
        //			where grpcd = :grpcd";
        //	}
        //	// SQL実行
        //	Execute(sql, sqlParam);
        //	if (data["item"] != null)
        //	{
        //		// パラメータの値設定
        //		var paramArray = new List<object>();
        //		List<JToken> item = data["item"].ToObject<List<JToken>>();
        //		int seq = 0;
        //		foreach (var rec in item)
        //		{
        //			paramArray.Add(new
        //			{
        //				grpcd = Convert.ToString(data["grpcd"]),
        //				itemcd = Convert.ToString(rec["itemcd"]),
        //				suffix = Convert.ToString(rec["suffix"]),
        //				seq = ++seq,
        //				rslcaption = Convert.ToString(rec["rslcaption"]),
        //			});
        //		}
        //		// 項目の新規挿入
        //		if (data["grpdiv"].Equals(GrpDiv.R))
        //		{
        //			// 依頼項目の場合
        //			// SQL定義
        //			sql = @"
        //				insert
        //				into grp_r(grpcd, itemcd)
        //				values (:grpcd, :itemcd)";
        //		}
        //		else
        //		{
        //			// 検査項目の場合
        //			// SQL定義
        //			sql = @"
        //				insert
        //				into grp_i(grpcd, itemcd, suffix, seq, rslcaption)
        //				values (:grpcd, :itemcd, :suffix, :seq, :rslcaption)";
        //		}
        //		// SQL実行
        //		Execute(sql, paramArray);
        //	}
        //}

        #endregion "新設メソッド"
    }
}
