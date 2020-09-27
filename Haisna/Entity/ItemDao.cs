using Dapper;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 検査項目情報データアクセスオブジェクト
    /// </summary>
    public class ItemDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ItemDao(IDbConnection connection) : base(connection)
        {
        }

        private const string DUMMY_SUFFIX = "";      // 検査項目テーブル以外のサフィックスの値(ダミー)

        /// <summary>
        /// 検査項目＆文章をJOINしたマスタデータ取得（OCRローカルチェック用）
        /// </summary>
        /// <param name="nowDate">取得日（検査履歴取得用）</param>
        /// <returns>
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// resulttype 結果タイプ
        /// itemtype 項目タイプ
        /// itemname 検査項目名
        /// itemsname 検査項目略称
        /// stcitemcd 文章参照用項目コード
        /// stccd 文章コード
        /// shortstc 略文章
        /// longstc 文章
        /// figure1 整数部桁数
        /// figure2 小数部桁数
        /// maxvalue 最大値
        /// minvalue 最小値
        /// </returns>
        public List<dynamic> GetItemMasterForOcr(string nowDate)
        {
            bool dateSelect = false;

            // #ToDo どう書けばいいのか
            //      If IsMissing(dtmNowDate) = False Then
            //          If(Trim(dtmNowDate) <> "") And IsDate(dtmNowDate) Then
            //              objOraParam.Add "NOWDATE", CDate(dtmNowDate), ORAPARM_INPUT, ORATYPE_DATE
            //              blnDateSelect = True
            //          End If
            //      End If

            // パラメータセット
            var sqlParam = new
            {
                nowDate = nowDate
            };

            // SQL定義
            string sql = @"
                        select
                            item_c.itemcd
                            , item_c.suffix
                            , item_c.resulttype
                            , item_c.itemtype
                            , item_c.itemname
                            , item_c.itemsname
                            , item_c.stcitemcd
                            , sentence.stccd
                            , sentence.shortstc
                            , sentence.longstc
                            , item_h.figure1
                            , item_h.figure2
                            , item_h.maxvalue
                            , item_h.minvalue
                        from
                            item_h
                            , sentence
                            , item_c
                        where
                            item_c.stcitemcd = sentence.itemcd(+)
                            and item_c.itemtype = sentence.itemtype(+)
                            and item_h.itemcd = item_c.itemcd
                            and item_h.suffix = item_c.suffix
                    ";

            // 日付を指定されている場合、条件を変更
            if (dateSelect)
            {
                sql += " and :nowdate between item_h.strdate and item_h.enddate ";
            }
            else
            {
                sql += " and sysdate between item_h.strdate and item_h.enddate ";
            }

            sql += @"
                    order by
                        item_c.itemcd
                        , item_c.suffix
                        , sentence.stccd
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 検査分類名称の一覧を取得する
        /// </summary>
        /// <returns>
        /// classcd 検査分類コード
        /// classname 検査分類名称
        /// </returns>
        public List<dynamic> SelectItemClassList()
        {
            // 検査分類テーブルのレコードを取得
            string sql = @"
                    select
                        classcd
                        , classname
                    from
                        itemclass
                    order by
                        classcd
                ";

            // SQL実行
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 検査分類データを取得する
        /// </summary>
        /// <param name="itemClassCd">検査分類コード</param>
        /// <returns>
        /// classname 検査分類名
        /// </returns>
        public dynamic SelectItemClass(string itemClassCd)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemclasscd = itemClassCd
            };

            // SQL定義
            string sql = @"
                    select
                        classname
                    from
                        itemclass
                    where
                        classcd = :itemclasscd
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 検査分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// itemclasscd 検査分類コード
        /// itemclassname 検査分類名
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistItemClass(string mode, JToken data)
        {
            Insert ret = Insert.Error;

            // パラメータセット
            var sqlParam = new
            {
                itemclasscd = Convert.ToString(data["itemclasscd"]),
                itemclassname = Convert.ToString(data["itemclassname"])
            };

            string sql;

            while (true)
            {
                // 検査分類テーブルレコードの更新
                if (mode == "UPD")
                {
                    // SQL設定
                    sql = @"
                        update itemclass
                        set
                            classname = :itemclassname
                        where
                            classcd = :itemclasscd
                    ";

                    // SQL実行
                    int ret2 = connection.Execute(sql, sqlParam);
                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす検査分類テーブルのレコードを取得
                // SQL設定
                sql = @"
                    select
                        classcd
                    from
                        itemclass
                    where
                        classcd = :itemclasscd
                ";

                // SQL実行
                dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

                if (result != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                // SQL設定
                sql = @"
                    insert
                    into itemclass(classcd, classname)
                    values (:itemclasscd, :itemclassname)
                ";

                // SQL実行
                connection.Execute(sql, sqlParam);

                ret = Insert.Normal;

                break;
            }

            return ret;
        }

        /// <summary>
        /// 検査項目履歴データを登録する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="itemCount">検査項目履歴個数</param>
        /// <param name="data">
        /// itemhno 検査項目履歴Ｎｏ
        /// strdate 使用開始日付
        /// enddate 使用終了日付
        /// figure1 整数部桁数
        /// figure2 小数部桁数
        /// maxvalue 最大値
        /// minvalue 最小値
        /// insitemcd 検査用項目コード
        /// unit 単位
        /// defresult 省略時検査結果
        /// defrslcmtcd 省略時結果コメントコード
        /// reqitemcd 検査用依頼項目コード
        /// inssuffix 検査用サフィックス
        /// eunit 英語単位
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistItemHistory(string itemCd, string suffix, int itemCount, List<JToken> data)
        {
            Insert ret = Insert.Error;

            // 主キーが設定されていない場合はエラー
            if (itemCd.Trim() == "" || suffix == "")
            {
                // #ToDo 例外をどう書くのか
                // Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
                // Exit Function
            }

            for (var i = 0; i < itemCount; i++)
            {
                // 検査項目コードのダブリチェック
                if (SelectInsItemInfo(itemCd, suffix, Convert.ToString(data[i]["insitemcd"])) != null)
                {
                    // #ToDo ダブっていたらメソッドを終了するようになっている、Insert.Duplicateを返すので良いか
                    // Exit Function
                    return Insert.Duplicate;
                }
            }

            // #ToDo 共通部に実装を作る必要あり
            //'履歴データの重複チェック
            //Set objCommon = New HainsCommon.Common
            //If objCommon.CheckHistoryDuplicate(intItemCount, vntStrDate, vntEndDate) = False Then
            //    RegistItemHistory = INSERT_HISTORYDUPLICATE
            //    Exit Function
            //End If

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix
            };

            // SQL定義
            string sql = @"
                    delete item_h
                    where
                        itemcd = :itemcd
                        and suffix = :suffix
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            if (itemCount > 0)
            {
                var paramArray = new List<object>();
                for (var i = 0; i < itemCount; i++)
                {
                    paramArray.Add(new
                    {
                        itemcd = itemCd,
                        suffix = suffix,
                        itemhno = data[i]["itemhno"],
                        strdate = data[i]["strdate"],
                        enddate = data[i]["enddate"],
                        figure1 = data[i]["figure1"],
                        figure2 = data[i]["figure2"],
                        maxvalue = data[i]["maxvalue"],
                        minvalue = data[i]["minvalue"],
                        insitemcd = data[i]["insitemcd"],
                        unit = data[i]["unit"],
                        defresult = data[i]["defresult"],
                        defrslcmtcd = data[i]["defrslcmtcd"],
                        reqitemcd = data[i]["reqitemcd"],
                        inssuffix = data[i]["inssuffix"],
                        eunit = data[i]["eunit"]
                    });
                }


                // SQL定義
                sql = @"
                        insert
                        into item_h(
                            itemcd
                            , suffix
                            , itemhno
                            , strdate
                            , enddate
                            , figure1
                            , figure2
                            , maxvalue
                            , minvalue
                            , insitemcd
                            , unit
                            , defresult
                            , defrslcmtcd
                            , reqitemcd
                            , inssuffix
                            , eunit
                        )
                        values (
                            :itemcd
                            , :suffix
                            , :itemhno
                            , :strdate
                            , :enddate
                            , :figure1
                            , :figure2
                            , :maxvalue
                            , :minvalue
                            , :insitemcd
                            , :unit
                            , :defresult
                            , :defrslcmtcd
                            , :reqitemcd
                            , :inssuffix
                            , :eunit
                        )
                    ";

                // SQL実行
                connection.Execute(sql, sqlParam);
            }

            ret = Insert.Normal;

            return ret;
        }

        /// <summary>
        /// 検査項目変換データを登録する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="itemCount">検査項目履歴個数</param>
        /// <param name="data">
        /// itemhno 検査項目履歴Ｎｏ
        /// karteitemcd 電カル用文書種別コード
        /// karteitemattr 電カル用項目属性
        /// kartedoccd 電カル用項目コード
        /// kartetagname 電カル用タグ名称
        /// karteitemname 電カル用項目名
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistKarteItem(string itemCd, string suffix, int itemCount, JToken data)
        {
            if (itemCd == "" || suffix == "")
            {
                // #ToDo 例外をどう書くのか
                // Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
                // Exit Function
            }

            Insert ret = Insert.Error;

            string sql;

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix
            };

            // SQL定義
            sql = @"
                delete karteitem
                where
                    itemcd = :itemcd
                    and suffix = :suffix
                ";

            // 検査項目履歴管理レコードの削除
            // SQL実行
            connection.Execute(sql, sqlParam);

            if (itemCount > 0)
            {
                var sqlParamList = new List<dynamic>();

                for (var i = 0; i < itemCount; i++)
                {
                    // #ToDo dataの値の持ち方はこれでいいのか
                    sqlParamList.Add(new
                    {
                        itemcd = itemCd,
                        suffix = suffix,
                        itemhno = data[i]["itemhno"],
                        karteitemcd = data[i]["karteitemcd"],
                        karteitemname = data[i]["karteitemname"],
                        karteitemattr = data[i]["karteitemattr"],
                        kartedoccd = data[i]["kartedoccd"],
                        kartetagname = data[i]["kartetagname"]
                    });
                }

                // SQL定義
                sql = @"
                    insert
                    into karteitem(
                        itemcd
                        , suffix
                        , itemhno
                        , karteitemcd
                        , karteitemname
                        , karteitemattr
                        , kartedoccd
                        , kartetagname
                    )
                    values (
                        :itemcd
                        , :suffix
                        , :itemhno
                        , :karteitemcd
                        , :karteitemname
                        , :karteitemattr
                        , :kartedoccd
                        , :kartetagname
                    )
                    ";

                // SQL実行
                connection.Execute(sql, sqlParamList);

                ret = Insert.Normal;
            }
            else
            {
                // 更新件数０件も正常終了
                ret = Insert.Normal;
            }

            return ret;
        }

        /// <summary>
        /// 検査用項目コードに対する検査項目名を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="insItemCd">検査用項目コード</param>
        /// <returns>検査用項目コードに対する検査項目名</returns>
        public dynamic SelectInsItemInfo(string itemCd, string suffix, string insItemCd)
        {
            // 検査項目コードが設定されていない場合（空白）正常終了にしちゃいましょう
            if (itemCd.Trim() == "")
            {
                return null;
            }

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix,
                insitemcd = insItemCd,
            };

            // SQL定義
            string sql = @"
                    select
                        item_h.itemcd
                        , item_h.suffix
                        , item_c.itemname
                    from
                        item_c
                        , item_h
                    where
                        item_h.insitemcd = :insitemcd
                        and (
                            (item_h.itemcd != :itemcd)
                            or (item_h.suffix != :suffix)
                        )
                        and item_c.itemcd = item_h.itemcd
                        and item_c.suffix = item_h.suffix
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 検査項目テーブルレコードを削除する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>削除件数</returns>
        public bool DeleteItem_c(string itemCd, string suffix)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix
            };

            // SQL定義
            string sql = @"
                    delete item_c
                    where
                        itemcd = :itemcd
                        and suffix = :suffix
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            return true;
        }

        /// <summary>
        /// 依頼項目テーブルレコードを削除する
        /// </summary>
        /// <param name="itemCd">依頼項目コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteItem_p(string itemCd)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd
            };

            // SQL定義
            string sql = @"
                    delete item_p
                    where
                        itemcd = :itemcd
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            return true;
        }

        /// <summary>
        /// 依頼項目テーブルレコードを削除する
        /// </summary>
        /// <param name="itemCd">依頼項目コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteItem_p_Price(string itemCd)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd
            };

            // SQL定義
            string sql = @"
                    delete item_p_price
                    where
                        itemcd = :itemcd
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            return true;
        }

        /// <summary>
        /// 検査分類テーブルレコードを削除する
        /// </summary>
        /// <param name="itemClassCd">検査分類コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteItemClass(string itemClassCd)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemclasscd = itemClassCd
            };

            // SQL定義
            string sql = @"
                    delete itemclass
                    where
                        classcd = :itemclasscd
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            return true;
        }

        /// <summary>
        /// 検査項目テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// itemcd          検査項目コード
        /// suffix サフィックス
        /// resulttype 結果タイプ
        /// itemtype 項目タイプ
        /// itemname 検査項目名
        /// itemsname 検査項目略称
        /// itemrname 報告書用項目名
        /// searchchar ガイド検索用文字列
        /// stcitemcd 文章参照用項目コード
        /// recentcount 最近使った文章管理数
        /// itemename 英語項目名
        /// itemqname 問診文章
        /// collectcd 採取コード
        /// contractcd 外注先コード
        /// contractitemcd 外注結果コード
        /// olditemcd 単価２
        /// noprintflg 報告書未出力フラグ
        /// cutargetflg cu経年変化表示対象
        /// orderdiv オーダ種別
        /// buicode 部位コード
        /// explanation 項目説明
        /// hideinterview 面接支援非表示フラグ
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistItem_c(string mode, JToken data)
        {

            // パラメータセット
            var sqlParam = new
            {
                itemcd = Convert.ToString(data["itemcd"]),
                suffix = Convert.ToString(data["suffix"]),
                resulttype = Convert.ToString(data["resulttype"]),
                itemtype = Convert.ToString(data["itemtype"]),
                itemname = Convert.ToString(data["itemname"]),
                itemsname = Convert.ToString(data["itemsname"]),
                itemrname = Convert.ToString(data["itemrname"]),
                searchchar = Convert.ToString(data["searchchar"]),
                stcitemcd = Convert.ToString(data["stcitemcd"]),
                recentcount = Convert.ToString(data["recentcount"]),
                itemename = Convert.ToString(data["itemename"]),
                itemqname = Convert.ToString(data["itemqname"]),
                collectcd = Convert.ToString(data["collectcd"]),
                contractcd = Convert.ToString(data["contractcd"]),
                contractitemcd = Convert.ToString(data["contractitemcd"]),
                olditemcd = Convert.ToString(data["olditemcd"]),
                noprintflg = Convert.ToString(data["noprintflg"]),
                materials = Convert.ToString(data["materials"]),
                cutargetflg = Convert.ToString(data["cutargetflg"]),
                orderdiv = Convert.ToString(data["orderdiv"]),
                buicode = Convert.ToString(data["buicode"]),
                explanation = Convert.ToString(data["explanation"]),
                hideinterview = Convert.ToString(data["hideinterview"]),
            };

            string sql;
            Insert ret = Insert.Error;

            using (var tran = BeginTransaction())
            {
                while (true)
                {
                    if (mode == "UPD")
                    {
                        sql = @"
                            update item_c
                            set
                                resulttype = :resulttype
                                , itemtype = :itemtype
                                , itemname = :itemname
                                , itemsname = :itemsname
                                , itemrname = :itemrname
                                , searchchar = :searchchar
                                , stcitemcd = :stcitemcd
                                , recentcount = :recentcount
                                , itemename = :itemename
                                , itemqname = :itemqname
                                , collectcd = :collectcd
                                , contractcd = :contractcd
                                , contractitemcd = :contractitemcd
                                , olditemcd = :olditemcd
                                , noprintflg = :noprintflg
                                , materials = :materials
                                , cutargetflg = :cutargetflg
                                , orderdiv = :orderdiv
                                , buicode = :buicode
                                , explanation = :explanation
                                , hideinterview = :hideinterview
                            where
                                itemcd = :itemcd
                                and suffix = :suffix
                            ";

                        int count = connection.Execute(sql, sqlParam);

                        if (count > 0)
                        {
                            ret = Insert.Normal;
                            break;
                        }
                    }

                    // 検索条件を満たす検査項目テーブルのレコードを取得
                    sql = @"
                        select
                            itemcd
                        from
                            item_c
                        where
                            itemcd = :itemcd
                            and suffix = :suffix
                        ";

                    // SQL実行
                    dynamic rec = connection.Query(sql, sqlParam).FirstOrDefault();

                    if (rec != null)
                    {
                        ret = Insert.Duplicate;
                    }

                    // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                    sql = @"
                        insert
                        into item_c(
                            itemcd
                            , suffix
                            , resulttype
                            , itemtype
                            , itemname
                            , itemsname
                            , itemrname
                            , searchchar
                            , stcitemcd
                            , recentcount
                            , itemename
                            , itemqname
                            , collectcd
                            , contractcd
                            , contractitemcd
                            , olditemcd
                            , noprintflg
                            , materials
                            , cutargetflg
                            , orderdiv
                            , buicode
                            , explanation
                            , hideinterview
                        )
                        values (
                            :itemcd
                            , :suffix
                            , :resulttype
                            , :itemtype
                            , :itemname
                            , :itemsname
                            , :itemrname
                            , :searchchar
                            , :stcitemcd
                            , :recentcount
                            , :itemename
                            , :itemqname
                            , :collectcd
                            , :contractcd
                            , :contractitemcd
                            , :olditemcd
                            , :noprintflg
                            , :materials
                            , :cutargetflg
                            , :orderdiv
                            , :buicode
                            , :explanation
                            , :hideinterview
                        )
                        ";

                    // SQL実行
                    connection.Execute(sql, sqlParam);

                    ret = Insert.Normal;

                    break;
                }

                tran.Commit();
            }

            return ret;
        }

        /// <summary>
        /// 検査項目テーブルレコードを登録する（トランザクション対応）
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="editItemHistory">検査項目履歴管理テーブルの更新有無(FALSEなら更新しない）</param>
        /// <param name="data">登録データ</param>
        /// <returns></returns>
        public void RegistItem_c_All(string mode, bool editItemHistory, JToken data)
        {
            // #ToDo datの構造が1対多になるようで具体的にどういう構造になるのかがよくわからない
            /*
                Public Function RegistItem_c_All(ByVal strMode As String, ByVal strItemCd As String, ByVal strSuffix As String, ByVal intResultType As Integer, _
                                                 ByVal intItemType As Integer, ByVal strItemName As String, _
                                                 ByVal strItemSName As String, ByVal strItemRName As String, _
                                                 ByVal strSearchChar As String, ByVal strStcItemCd As String, _
                                                 ByVal intRecentCount As Integer, ByVal strItemEName As String, _
                                                 ByVal strItemQName As String, ByVal strCollectCd As String, _
                                                 ByVal strContractCd As String, ByVal strContractItemCd As String, _
                                                 ByVal strOldItemCd As String, ByVal strNoPrintFlg As String, _
                                                 ByVal blnEditItemHistory As Boolean, ByVal intItemCount As Integer, _
                                                 ByVal vntItemHNo As Variant, ByVal vntStrDate As Variant, ByVal vntEndDate As Variant, ByVal vntFigure1 As Variant, _
                                                 ByVal vntFigure2 As Variant, ByVal vntMaxValue As Variant, ByVal vntMinValue As Variant, ByVal vntInsItemCd As Variant, _
                                                 ByVal vntUnit As Variant, ByVal vntDefResult As Variant, ByVal vntDefRslCmtCd As Variant, ByVal vntReqItemCd As Variant, _
                                                 ByVal vntMaterials As Variant, _
                                                 ByVal intCuTargetFlg As Integer, ByVal strOrderDiv As String, ByVal strBuiCode As String, ByVal strExplanation As String, _
                                                 ByVal vntInsSuffix As Variant, ByVal vnteUnit As Variant, Optional ByVal vntHideInterview As Variant = "0") As Long

                    'エラーハンドラの設定
                    On Error GoTo ErrorHandle

                    Dim Ret         As Long             '関数戻り値

                    Ret = INSERT_ERROR
                    RegistItem_c_All = INSERT_ERROR

                    Do

                        '検査項目テーブルの更新
                        Ret = RegistItem_c(strMode, _
                                           strItemCd, _
                                           strSuffix, _
                                           intResultType, _
                                           intItemType, _
                                           strItemName, _
                                           strItemSName, _
                                           strItemRName, _
                                           strSearchChar, _
                                           strStcItemCd, _
                                           intRecentCount, _
                                           strItemEName, _
                                           strItemQName, _
                                           strCollectCd, _
                                           strContractCd, _
                                           strContractItemCd, _
                                           strOldItemCd, _
                                           strNoPrintFlg, _
                                           vntMaterials, _
                                           intCuTargetFlg, _
                                           strOrderDiv, _
                                           strBuiCode, _
                                           strExplanation, _
                                           vntHideInterview)

                        '異常終了なら処理終了
                        If Ret <> INSERT_NORMAL Then
                            Exit Do
                        End If

                        If blnEditItemHistory = True Then

                            '検査項目履歴管理テーブルの更新
                            Ret = RegistItemHistory(strItemCd, _
                                                    strSuffix, _
                                                    intItemCount, _
                                                    vntItemHNo, _
                                                    vntStrDate, _
                                                    vntEndDate, _
                                                    vntFigure1, _
                                                    vntFigure2, _
                                                    vntMaxValue, _
                                                    vntMinValue, _
                                                    vntInsItemCd, _
                                                    vntUnit, _
                                                    vntDefResult, _
                                                    vntDefRslCmtCd, _
                                                    vntReqItemCd, _
                                                    vntInsSuffix, _
                                                    vnteUnit)

                            '異常終了なら処理終了
                            If Ret <> INSERT_NORMAL Then
                                Exit Do
                            End If

                        End If

                        Exit Do
                    Loop

                    If Ret = INSERT_NORMAL Then
                        '正常ならCommit これはRootトランザクションなのでCommit
                        mobjContext.SetComplete
                    Else
                        '異常終了ならRollBack
                        mobjContext.SetAbort
                    End If

                    '戻り値の設定
                    RegistItem_c_All = Ret

                    Exit Function

                ErrorHandle:

                    'その他の戻り値設定
                    RegistItem_c_All = INSERT_ERROR

                    'イベントログ書き込み
                    WriteErrorLog "Item.RegistItem_c_All"

                    'エラー発生時はトランザクションをアボートに設定
                    mobjContext.SetAbort

                    'エラーをもう一回引き起こす
                    Err.Raise Err.Number, Err.Source, Err.Description

                End Function
             */

        }

        /// <summary>
        /// 依頼項目テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// </param>
        /// itemcd 検査項目コード
        /// classcd 検査分類コード
        /// rslque 結果問診フラグ
        /// requestname 依頼項目名
        /// requestsname 依頼項目略称
        /// progresscd 進捗分類コード
        /// entryok 未入力チェック
        /// searchchar ガイド検索用文字列
        /// opeclasscd 検査実施日分類コード
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistItem_p(string mode, JToken data)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemcd = Convert.ToString(data["itemcd"]),
                classcd = Convert.ToString(data["classcd"]),
                rslque = Convert.ToString(data["rslque"]),
                requestname = Convert.ToString(data["requestname"]),
                requestsname = Convert.ToString(data["requestsname"]),
                progresscd = Convert.ToString(data["progresscd"]),
                entryok = Convert.ToString(data["entryok"]),
                searchchar = Convert.ToString(data["searchchar"]),
                opeclasscd = Convert.ToString(data["opeclasscd"])
            };

            string sql;
            Insert ret = Insert.Error;

            while (true)
            {
                if (mode == "UPD")
                {
                    sql = @"
                        update item_p
                        set
                            classcd = :classcd
                            , rslque = :rslque
                            , requestname = :requestname
                            , requestsname = :requestsname
                            , progresscd = :progresscd
                            , entryok = :entryok
                            , searchchar = :searchchar
                            , opeclasscd = :opeclasscd
                        where
                            itemcd = :itemcd
                        ";

                    int count = connection.Execute(sql, sqlParam);

                    if (count > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす依頼項目テーブルのレコードを取得
                sql = @"
                    select
                        itemcd
                    from
                        item_p
                    where
                        itemcd = :itemcd
                    ";

                dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

                if (result != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into item_p(
                            itemcd
                            , classcd
                            , rslque
                            , requestname
                            , requestsname
                            , progresscd
                            , entryok
                            , searchchar
                            , opeclasscd
                        )
                        values (
                            :itemcd
                            , :classcd
                            , :rslque
                            , :requestname
                            , :requestsname
                            , :progresscd
                            , :entryok
                            , :searchchar
                            , :opeclasscd
                        )
                    ";

                connection.Execute(sql, sqlParam);

                // #ToDo 違うメソッドに引数を渡す際に新しい構造のデータを作成する方法をどうするか
                /*
        '新規モードが成功したら、そのまま子レコード（検査項目レコード）もぶちこみ（かっくい～）

    '検査項目履歴管理テーブルのデフォルト値セット
    vntArrItemHNo(0) = 0
    vntArrStrDate(0) = CDate(YEARRANGE_MIN & "/01/01")
    vntArrEndDate(0) = CDate(YEARRANGE_MAX & "/12/31")
    vntArrFigure1(0) = 8
    vntArrFigure2(0) = 0
    vntArrMaxValue(0) = ""
    vntArrMinValue(0) = ""
    vntArrInsItemCd(0) = ""
    vntArrUnit(0) = ""
    vntArrDefResult(0) = ""
    vntArrDefRslCmtCd(0) = ""

    vntArrKarteDocCd(0) = ""
    vntArrKarteItemAttr(0) = ""
    vntArrKarteItemcd(0) = ""
    vntArrKarteItemName(0) = ""
    vntArrKarteTagName(0) = ""

    vntItemHNo = vntArrItemHNo
    vntStrDate = vntArrStrDate
    vntEndDate = vntArrEndDate
    vntFigure1 = vntArrFigure1
    vntFigure2 = vntArrFigure2
    vntMaxValue = vntArrMaxValue
    vntMinValue = vntArrMinValue
    vntInsItemCd = vntArrInsItemCd
    vntKarteItemcd = vntArrKarteItemcd
    vntKarteItemName = vntArrKarteItemName
    vntKarteItemAttr = vntArrKarteItemAttr
    vntKarteDocCd = vntArrKarteDocCd
    vntUnit = vntArrUnit
    vntDefResult = vntArrDefResult
    vntDefRslCmtCd = vntArrDefRslCmtCd
    vntArrReqItemCd(0) = ""
    vntArrSepOrderDiv(0) = ""

    intCuTargetFlg = 0
    strOrderDiv = ""
    strBuiCode = ""
    strExplanation = ""
    vntInsSuffix(0) = ""
    vnteUnit(0) = ""
    vntReqItemCd(0) = ""

    '検査項目テーブルの登録
    Ret = RegistItem_c_All(strMode, strItemCd, _
                            "00", RESULTTYPE_NUMERIC, _
                            ITEMTYPE_STANDARD, strRequestName, _
                            strRequestSName, strRequestName, _
                            "*", strItemCd, _
                            0, "", _
                            IIf(intRslQue = RSLQUE_Q, strRequestName, ""), "", _
                            "", "", _
                            "", "", _
                            True, 1, _
                            vntItemHNo, vntStrDate, _
                            vntEndDate, vntFigure1, _
                            vntFigure2, vntMaxValue, _
                            vntMinValue, vntInsItemCd, _
                            vntUnit, vntDefResult, _
                            vntDefRslCmtCd, vntArrReqItemCd, "", _
                            intCuTargetFlg, strOrderDiv, strBuiCode, strExplanation, _
                            vntInsSuffix, vnteUnit)
                    */

                ret = Insert.Normal;
                break;
            }

            return ret;
        }

        /// <summary>
        /// 依頼項目単価テーブルを登録する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemCount">単価設定数</param>
        /// <param name="data">
        /// existsisr 健保有無区分
        /// seq 表示順番
        /// strage 開始年齢
        /// endage 終了年齢
        /// bsdprice 団体負担金額
        /// isrprice 健保負担金額
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistItem_P_Price(string itemCd, int itemCount, JToken data)
        {
            Insert ret = Insert.Error;

            using (var tran = BeginTransaction())
            {
                // パラメータセット
                var sqlParam = new
                {
                    itemcd = itemCd
                };

                // 依頼項目単価レコードの削除
                string sql = @"
                    delete item_p_price
                    where
                        itemcd = :itemcd
                    ";

                // SQL実行
                connection.Execute(sql, sqlParam);

                if (itemCount > 0)
                {
                    // #ToDo 複数データの構造はこれでいいのか
                    var sqlParamList = new List<dynamic>();
                    for (var i = 0; i < itemCount; i++)
                    {
                        sqlParamList.Add(new
                        {
                            itemcd = itemCd,
                            existsisr = data[i]["existsisr"],
                            seq = data[i]["seq"],
                            strage = data[i]["strage"],
                            endage = data[i]["endage"],
                            bsdprice = data[i]["bsdprice"],
                            isrprice = data[i]["isrprice"]
                        });
                    }

                    // SQL定義
                    sql = @"
                        insert
                        into item_p_price(
                            itemcd
                            , existsisr
                            , seq
                            , strage
                            , endage
                            , bsdprice
                            , isrprice
                        )
                        values (
                            :itemcd
                            , :existsisr
                            , :seq
                            , :strage
                            , :endage
                            , :bsdprice
                            , :isrprice
                        )
                        ";

                    // SQL実行
                    connection.Execute(sql, sqlParamList);
                }

                tran.Commit();

                ret = Insert.Normal;
            }

            return ret;
        }

        /// <summary>
        /// 検索条件を満たす検査項目の一覧を取得する
        /// </summary>
        /// <param name="classCd">検査分類コード</param>
        /// <param name="searchChar">ガイド検索用文字列</param>
        /// <param name="questionKey">問診結果表示有無</param>
        /// <param name="resultType">結果タイプ</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        /// <param name="cuTargetFlg">CU経年変化表示対象</param>
        /// <returns>検査項目情報</returns>
        public List<dynamic> SelectItem_cList(
            string classCd,
            string searchChar,
            ItemEnabled questionKey,
            ResultType? resultType = null,
            string searchCode = null,
            string searchString = null,
            int? cuTargetFlg = null
        )
        {
            classCd = classCd?.Trim();
            searchChar = searchChar?.Trim();
            searchCode = searchCode?.Trim();
            searchString = searchString?.Trim();

            // キー値の設定
            var param = new Dictionary<string, object>();

            // SQL定義
            string sql = @"
                    select
                        item_c.itemcd
                        , item_c.suffix
                        , item_c.itemname
                        , item_c.resulttype
                        , item_c.itemtype
                        , item_c.cutargetflg
                        , itemclass.classname
                    from
                        item_p
                        , item_c
                        , itemclass
                    where
                        item_p.itemcd = item_c.itemcd
                        and item_p.classcd = itemclass.classcd
                ";

            // 結果タイプ指定時の検索条件
            if (resultType != null)
            {
                sql += @"
                        and item_c.resulttype = :resulttype
                ";

                param.Add("resulttype", resultType);
            }

            // CU経年変化表示対象指定時の検索条件
            if (cuTargetFlg != null)
            {
                sql += @"
                        and item_c.cutargetflg = :cutargetflg
                ";

                param.Add("cutargetflg", cuTargetFlg);
            }

            // 検査分類コード指定時の検索条件
            if (!string.IsNullOrEmpty(classCd))
            {
                sql += @"
                        and item_p.classcd = :classcd
                ";

                param.Add("classcd", classCd);
            }

            // 問診結果表示有無指定時の検索条件
            if (questionKey.Equals(ItemEnabled.NotDisp))
            {
                sql += @"
                        and item_p.rslque = :rslque
                ";

                param.Add("rslque", RslQue.R);
            }

            // ガイド検索用文字列指定時の検索条件
            if (!string.IsNullOrEmpty(searchChar))
            {
                sql += @"
                    and item_p.searchchar in (:searchcharw, :searchcharn)
                ";

                // 全角・半角両方に対応するよう変換
                param.Add("searchcharw", Strings.StrConv(searchChar, VbStrConv.Wide));
                param.Add("searchcharn", Strings.StrConv(searchChar, VbStrConv.Narrow));
            }

            // 検索用コード指定時の検索条件
            if (!string.IsNullOrEmpty(searchCode))
            {
                sql += @"
                    and item_c.itemcd like :searchcode
                ";

                param.Add("searchcode", $"%{searchCode}%");
            }

            // 検索用文字列指定時の検索条件
            if (!string.IsNullOrEmpty(searchString))
            {
                sql += @"
                    and item_c.itemname like :searchstring
                ";

                param.Add("searchstring", $"%{searchString}%");
            }

            sql += @"
                order by
                    item_c.itemcd
                    , item_c.suffix
                ";

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 依頼項目情報を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <returns>依頼項目情報</returns>
        public dynamic SelectItem_P(string itemCd)
        {
            if (itemCd.Trim() == "")
            {
                // #ToDo 例外をどう書くのか
                // Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
                // Exit Function
            }

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd
            };

            // SQL定義
            string sql = @"
                        select
                            classcd
                            , rslque
                            , requestname
                            , requestsname
                            , progresscd
                            , entryok
                            , searchchar
                            , opeclasscd
                        from
                            item_p
                        where
                            item_p.itemcd = :itemcd

                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 依頼項目単価テーブル取得
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <returns>
        /// existsisr 健保有無区分
        /// seq ｓｅｑ
        /// strage 開始年齢
        /// endage 終了年齢
        /// bsdprice 団体負担金額
        /// isrprice 健保負担金額
        /// </returns>
        public List<dynamic> SelectItem_P_Price(string itemCd)
        {
            // #Todo IsEmptyはstring.IsNullOrEmptyで書くか itemCd == "" で書くのか
            // If IsEmpty(strItemCd) Then
            //     Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            //     Exit Function
            // End If

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd
            };

            // SQL定義
            string sql = @"
                        select
                            itemcd
                            , existsisr
                            , seq
                            , strage
                            , endage
                            , bsdprice
                            , isrprice
                        from
                            item_p_price
                        where
                            itemcd = :itemcd
                        order by
                            existsisr
                            , seq
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 検索条件を満たす依頼項目の一覧を取得する
        /// </summary>
        /// <param name="classCd">検査分類コード</param>
        /// <param name="searchChar">ガイド検索用文字列</param>
        /// <param name="questionKey">問診結果表示有無</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        /// <returns>依頼項目情報</returns>
        public List<dynamic> SelectItem_pList(
            string classCd,
            string searchChar,
            ItemEnabled questionKey,
            string searchCode = null,
            string searchString = null
        )
        {
            classCd = classCd?.Trim();
            searchChar = searchChar?.Trim();
            searchCode = searchCode?.Trim();
            searchString = searchString?.Trim();

            // パラメータセット
            var param = new Dictionary<string, object>();

            // SQL定義
            string sql = @"
                select
                    item_p.itemcd
                    , item_p.classcd
                    , item_p.rslque
                    , item_p.requestname
                    , item_p.requestsname
                    , item_p.progresscd
                    , item_p.entryok
                    , item_p.searchchar
                    , item_p.opeclasscd
                    , itemclass.classname
                    , progress.progressname
                    , opeclass.opeclassname
                from
                    item_p
                    , itemclass
                    , progress
                    , opeclass
                where
                    item_p.classcd = itemclass.classcd
                    and item_p.progresscd = progress.progresscd
                    and item_p.opeclasscd = opeclass.opeclasscd(+)
            ";

            // 検査分類コード指定時の検索条件
            if (!string.IsNullOrEmpty(classCd))
            {
                sql += @"
                    and item_p.classcd = :classcd
                ";

                param.Add("classcd", classCd);
            }

            // ガイド検索用文字列指定時の検索条件
            if (!string.IsNullOrEmpty(searchChar))
            {
                // 全角・半角両方に対応するよう変換
                sql += @"
                    and item_p.searchchar in (:searchcharw, :searchcharn)
                ";

                param.Add("searchcharw", Strings.StrConv(searchChar, VbStrConv.Wide));
                param.Add("searchcharn", Strings.StrConv(searchChar, VbStrConv.Narrow));
            }

            // 問診結果有無指定時の検索条件
            if (questionKey.Equals(ItemEnabled.NotDisp))
            {
                sql += @"
                    and item_p.rslque = :rslque
                ";

                param.Add("rslque", RslQue.R);
            }

            // 検索用コード指定時の検索条件
            if (!string.IsNullOrEmpty(searchCode))
            {
                sql += @"
                    and item_p.itemcd like :searchcode
                ";

                param.Add("searchcode", $"%{searchCode}%");
            }

            // 検索用文字列指定時の検索条件
            if (!string.IsNullOrEmpty(searchString))
            {
                sql += @"
                    and item_p.requestname like :searchstring
                ";

                param.Add("searchstring", $"%{searchString}%");
            }

            sql += @"
                order by
                    item_p.itemcd
            ";

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検査項目の基本情報を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>
        /// itemname 検査項目名
        /// itemename 英語項目名
        /// classname 検査分類名称
        /// rslque 結果問診フラグ
        /// rslquename 結果問診フラグ名称
        /// itemtype 項目タイプ
        /// itemtypename 項目タイプ名称
        /// resulttype 結果タイプ
        /// resulttypename 結果タイプ名称
        /// itemsname 検査項目略称（省略可）
        /// itemrname 報告書表示用項目名（省略可）
        /// searchchar ガイド検索用文字列（省略可）
        /// stcitemcd 文章参照用項目コード（省略可）
        /// stcitemname 文章参照用項目名称（省略可）
        /// recentcount 最近使った文章管理数（省略可）
        /// itemqname 問診文章（省略可）
        /// collectcd 採取コード（省略可）
        /// contractcd 外注先コード（省略可）
        /// contractitemcd 外注結果コード（省略可）
        /// olditemcd 移行時旧検査項目コード（省略可）
        /// requestname 依頼項目名（省略可）
        /// noprintflg 報告書未出力フラグ（省略可）
        /// collecttubecd 採取管コード
        /// materials 材料コード
        /// labelmark マーク
        /// wscd ｗｓコード
        /// loadcd1 負荷コード１
        /// loadcd2 負荷コード２
        /// cutargetflg cu経年変化表示対象
        /// orderdiv オーダ種別
        /// buicode 部位コード
        /// explanation 項目説明
        /// </returns>
        public dynamic SelectItemHeader(String itemCd, string suffix)
        {
            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix
            };

            // SQL定義
            string sql = @"
                        select
                            ic.itemname
                            , ic.itemename
                            , cl.classname
                            , ip.rslque
                            , ic.itemtype
                            , ic.resulttype
                            , ic.itemsname
                            , ic.itemrname
                            , ic.searchchar
                            , ic.stcitemcd
                            , ic.recentcount
                            , ic.itemqname
                            , ic.collectcd
                            , ic.contractcd
                            , ic.contractitemcd
                            , ic.olditemcd
                            , i2.requestname stcitemname
                            , ip.requestname
                            , ic.noprintflg
                            , ic.materials
                            , ic.cutargetflg
                            , ic.orderdiv
                            , ic.buicode
                            , ic.explanation
                            , ic.hideinterview
                        from
                            item_p i2
                            , item_p ip
                            , itemclass cl
                            , item_c ic
                        where
                            ic.itemcd = :itemcd
                            and ic.suffix = :suffix
                            and i2.itemcd = ic.stcitemcd
                            and ic.itemcd = ip.itemcd(+)
                            and ip.classcd = cl.classcd(+)
                    ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 検査項目の履歴情報を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="cslDateYear">受診日（年）</param>
        /// <param name="cslDateMonth">受診日（月）</param>
        /// <param name="cslDateDay">受診日（日）</param>
        /// <returns>
        /// historycount 該当検査項目の履歴管理レコード件数
        /// unit 単位
        /// figure1 整数部桁数
        /// figure2 小数部桁数
        /// maxvalue 最大値
        /// minvalue 最小値
        /// itemhno 検査項目履歴ｎｏ（省略可能）
        /// strdate 使用開始日付（省略可能）
        /// enddate 使用終了日付（省略可能）
        /// insitemcd 検査用項目コード（省略可能）
        /// defresult 省略時検査結果（省略可能）
        /// defrslcmtcd 省略時結果コメントコード（省略可能）
        /// reqitemcd 検査用依頼項目コード
        /// seporderdiv オーダ分割区分
        /// inssuffix 検査用サフィックス
        /// eunit 英語単位
        /// </returns>
        public List<dynamic> SelectItemHistory(
            string itemCd,
            string suffix,
            string cslDateYear,
            string cslDateMonth,
            string cslDateDay
        )
        {
            bool dateSelect = false;
            string date = "";

            // 検索条件が設定されていない場合はエラー
            if (itemCd.Trim() == "" || suffix.Trim() == "")
            {
                // #ToDo 例外をどう書くのか
                //Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
                //Exit Function
            }

            if ((cslDateYear.Trim() != "") || (cslDateMonth.Trim() != "") || (cslDateDay.Trim() != ""))
            {
                date = cslDateYear.Trim() + "/" + cslDateMonth.Trim() + "/" + cslDateDay.Trim();
                if (!DateTime.TryParse(date, out DateTime tmpDate))
                {
                    // #ToDo 例外をどう書くのか
                    //Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
                    //Exit Function
                }
                dateSelect = true;
            }

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix,
                csldate = date
            };

            // SQL定義
            string sql = @"
                        select
                            count(*) historycount
                        from
                            item_h
                        where
                            itemcd = :itemcd
                            and suffix = :suffix
                    ";

            // SQL実行
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            // #ToDo 1つのメソッドで複数のSQLを実行しそれぞれの結果を返している場合はどう書けばいいのか
            // このカウントも戻り値に含みたい
            int count = data.HISTORYCOUNT;

            sql = @"
                    select
                        itemhno
                        , strdate
                        , enddate
                        , figure1
                        , figure2
                        , unit
                        , maxvalue
                        , minvalue
                        , insitemcd
                        , defresult
                        , defrslcmtcd
                        , reqitemcd
                        , inssuffix
                        , eunit
                    from
                        item_h
                    where
                        itemcd = :itemcd
                        and suffix = :suffix
                ";

            // 受診日指定ありの場合のみ、WHERE句条件追加
            if (dateSelect)
            {
                sql += @"
                            and strdate <= :csldate
                            and enddate >= :csldate
                            and rownum = 1
                        order by
                            item_h.itemhno desc
                    ";
            }
            else
            {
                sql += @"
                        order by
                            enddate desc
                    ";
            }

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 検査項目コードに対する検査項目名を取得する
        /// </summary>
        /// <param name="itemCd">検査分類コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>検査項目コードに対する検査項目名</returns>
        public dynamic SelectItemName(string itemCd, string suffix)
        {

            if (itemCd == "" || suffix == "")
            {
                // #ToDo 例外をどう書くのか
                //Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
                //Exit Function
            }

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd,
                suffix = suffix
            };

            // SQL定義
            string sql = @"
                    select
                        itemname
                        , itemqname
                        , resulttype
                        , itemtype
                        , stcitemcd
                    from
                        item_c
                    where
                        itemcd = :itemcd
                        and suffix = :suffix
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす電子カルテ用項目変換テーブルの一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="itemHNo">検査項目履歴Ｎｏ</param>
        /// <returns>
        /// itemhno 検査項目履歴ｎｏ（配列）
        /// kartedoccd 電カル用文書種別コード
        /// karteitemattr 電カル用項目属性
        /// karteitemcd 電カル用項目コード
        /// karteitemname 電カル用項目名
        /// kartetagname 電カル用タグ名称
        /// </returns>
        public List<dynamic> SelectKarteItemList(string itemCd, string suffix, string itemHNo)
        {
            if (itemCd == "" || suffix == "")
            {
                // #ToDo 例外をどう書くのか
                //Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
                //Exit Function
            }

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd.Trim(),
                suffix = suffix.Trim(),
                itemhno = itemHNo.Trim()
            };

            string sql = @"
                        select
                            itemhno
                            , kartedoccd
                            , karteitemattr
                            , karteitemcd
                            , karteitemname
                            , kartetagname
                        from
                            karteitem
                        where
                            itemcd = :itemcd
                            and suffix = :suffix
                    ";

            if (itemHNo.Trim() != "")
            {
                sql += " and itemhno = :itemhno ";
            }

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        #region 新設メソッド

        //   /// <summary>
        //   /// 検査分類一覧を取得する
        //   /// </summary>
        //   /// <returns>検査分類一覧</returns>
        //   public List<dynamic> SelectItemClass()
        //   {
        //       // SQL定義
        //       string sql = @"
        //select
        //	classcd
        //	, classname
        //	, printseq
        //from
        //	itemclass
        //order by
        //	classcd
        //	";

        //       // SQL実行
        //       return connection.Query(sql).ToList();
        //   }

        /// <summary>
        /// 入力値のチェックを行う
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> Validate(JToken data)
        {
            var messages = new List<string>();

            //グループコード
            if (string.IsNullOrEmpty(Convert.ToString(data["grpcd"])))
            {
                messages.Add("グループコードが入力されていません。");
            }
            //グループ名
            if (string.IsNullOrEmpty(Convert.ToString(data["grpname"])))
            {
                messages.Add("グループ名が入力されていません。");
            }

            return messages;
        }

        #endregion

        /// <summary>
        /// 指定された検査用項目コード／サフィックスに該当する検査項目テーブルのレコードを取得する
        /// </summary>
        /// <param name="insItemCd">検査用項目コード</param>
        /// <param name="insSuffix">検査用サフィックス</param>
        /// <param name="baseDate">基準日</param>
        /// <returns>検査項目テーブルのレコード</returns>
        public dynamic SelectItemByInsItemCd(string insItemCd, string insSuffix, DateTime baseDate)
        {
            // パラメータセット
            var sqlParam = new
            {
                insitemcd = insItemCd,
                inssuffix = insSuffix,
                basedate = baseDate,
            };

            // SQL定義
            string sql = @"
                    select
                        item_h.itemcd
                        , item_h.suffix
                        , item_c.resulttype
                        , item_c.itemtype
                        , item_c.itemname
                        , item_c.stcitemcd
                        , item_c.collectcd
                        , item_c.contractcd
                        , item_c.contractitemcd
                        , item_c.orderdiv
                        , item_c.buicode
                        , item_c.materials
                    from
                        item_h
                        , item_c
                    where
                        item_h.strdate <= :basedate
                        and item_h.enddate >= :basedate
                        and item_h.insitemcd = :insitemcd
                        and item_h.inssuffix = :inssuffix
                        and item_h.itemcd = item_c.itemcd
                        and item_h.suffix = item_c.suffix
                    order by
                        item_h.itemhno desc
            ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }
    }
}
