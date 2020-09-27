using Dapper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using static Hainsi.Common.Util;

namespace Hainsi.Entity
{
    /// <summary>
    /// 基準値情報データアクセスオブジェクト
    /// </summary>
    public class StdValueDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public StdValueDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 基準値テーブルレコード再更新
        /// </summary>
        /// <param name="strDate">開始受診日</param>
        /// <param name="endDate">終了受診日</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>
        /// INSERT_NORMAL 正常終了
        /// INSERT_ERROR 異常終了
        /// </returns>
        public Insert UpdateAllStdValue(DateTime strDate, DateTime endDate, string itemCd, string suffix)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", strDate);
            param.Add("enddate", endDate);

            // 検査項目コードが指定されているなら条件に追加する
            if (!String.IsNullOrEmpty(itemCd) && !String.IsNullOrEmpty(suffix))
            {
                param.Add("itemcd", itemCd.Trim());
                param.Add("suffix", suffix.Trim());
            }

            // 基準値の再更新
            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    sql = @"
                              update rsl
                              set
                                result = result
                              where
                                exists (
                                  select
                                    consult.rsvno
                                  from
                                    consult
                                  where
                                    consult.csldate between :strdate and :enddate
                                    and consult.rsvno = rsl.rsvno
                                )
                          ";

                    // 検査項目コードが指定されているなら条件に追加する
                    if (!String.IsNullOrEmpty(itemCd) && !String.IsNullOrEmpty(suffix))
                    {
                        sql += @"
                                 and rsl.itemcd = :itemcd
                                 and rsl.suffix = :suffix
                             ";
                    }
                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
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
        /// 基準値（履歴・親）の一覧を取得する
        /// </summary>
        /// <param name="data">基準値テーブル情報
        /// classCd 検査分類コード
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// </param>
        /// <returns>
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// strDate 使用開始日付
        /// endDate 使用終了日付
        /// csCd 対象コースコード
        /// itemName 検査項目名
        /// csName 対象コース名
        /// stdvaluemngcd 基準値管理コード
        /// </returns>
        public List<dynamic> SelectStdValueList(JToken data)
        {
            string sql; // SQLステートメント

            bool selectItem = false;
            bool selectClass = false;
            var param = new Dictionary<string, object>();

            // 検査分類コードを指定されている場合はフラグON
            if (!String.IsNullOrEmpty(Convert.ToString(data["classcd"])))
            {
                selectClass = true;
                param.Add("classcd", Convert.ToString(data["classcd"]));
            }

            // 検査項目コードとサフィックスを指定されている場合はフラグON
            if (!"".Equals(Convert.ToString(data["itemcd"])) && !"".Equals(Convert.ToString(data["suffix"])))
            {
                selectItem = true;
                param.Add("itemcd", Convert.ToString(data["itemcd"]));
                param.Add("suffix", Convert.ToString(data["suffix"]));
            }

            // 基準値テーブルよりレコードを取得
            sql = @"
                     select
                           stdvalue.stdvaluemngcd
                         , stdvalue.itemcd
                         , stdvalue.suffix
                         , stdvalue.strdate
                         , stdvalue.enddate
                         , stdvalue.cscd
                         , course_p.csname
                         , item_c.itemname
                       from
                           item_p
                         , item_c
                         , course_p
                         , stdvalue
                      where
                           stdvalue.cscd = course_p.cscd(+)
                       and item_c.itemcd = stdvalue.itemcd
                       and item_c.suffix = stdvalue.suffix
                       and item_p.itemcd = stdvalue.itemcd
                  ";

            // 検査分類コードを指定されている場合は検索条件に追加
            if (selectClass)
            {
                sql += @"
                            and item_p.classcd = :classcd
                       ";
            }

            // 検査項目コードとサフィックスを指定されている場合は検索条件に追加
            if (selectItem)
            {
                sql += @"
                            and stdvalue.itemcd = :itemcd
                            and stdvalue.suffix = :suffix
                       ";
            }

            // 読み込み順指定
            sql += @"
                     order by
                             stdvalue.itemcd
                           , stdvalue.suffix
                           , stdvalue.enddate desc
                           , stdvalue.cscd asc
                   ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 基準値詳細の一覧を取得する
        /// </summary>
        /// <param name="data">基準値テーブル情報
        /// stdValueMngCd 基準値管理コード
        /// </param>
        /// <returns>
        /// stdValueCd 基準値コード
        /// gender 性別
        /// strAge 開始年齢
        /// endAge 終了年齢
        /// priorSeq 適用優先順位番号
        /// LowerValue 基準値（以上）
        /// upperValue 基準値（以下）
        /// stdFlg 基準値フラグ
        /// judCd 判定コード
        /// judCmtCd 判定コメントコード
        /// healthPoint ヘルスポイント
        /// sentence 文章（省略可）
        /// </returns>
        public List<dynamic> SelectStdValue_cList(JToken data)
        {
            string sql; // SQLステートメント

            // 対象検査グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(Convert.ToString(data["stdValueMngCd"])))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("stdvaluemngcd", Convert.ToString(data["stdValueMngCd"]));

            // 基準値テーブルよりレコードを取得
            sql = @"
                      select
                             nativestdvalue.stdvaluecd
                           , sentence.shortstc
                           , nativestdvalue.stdvaluemngcd
                           , nativestdvalue.gender
                           , nativestdvalue.strage
                           , nativestdvalue.endage
                           , nativestdvalue.priorseq
                           , nativestdvalue.lowervalue
                           , nativestdvalue.uppervalue
                           , nativestdvalue.stdflg
                           , nativestdvalue.judcd
                           , nativestdvalue.judcmtcd
                           , nativestdvalue.healthpoint
                           , nativestdvalue.judsname
                           , nativestdvalue.judcmtstc
                         from
                           sentence
                           , (
                             select
                               item_c.stcitemcd itemcd
                               , item_c.itemtype itemtype
                               , stdvalue_c.stdvaluecd
                               , stdvalue_c.stdvaluemngcd
                               , stdvalue_c.gender
                               , stdvalue_c.strage
                               , stdvalue_c.endage
                               , stdvalue_c.priorseq
                               , stdvalue_c.lowervalue
                               , stdvalue_c.uppervalue
                               , stdvalue_c.stdflg
                               , stdvalue_c.judcd
                               , stdvalue_c.judcmtcd
                               , stdvalue_c.healthpoint
                               , jud.judsname
                               , judcmtstc.judcmtstc
                             from
                               stdvalue
                               , item_c
                               , judcmtstc
                               , jud
                               , stdvalue_c
                             where
                               stdvalue_c.stdvaluemngcd = :stdvaluemngcd
                               and stdvalue_c.judcd = jud.judcd(+)
                               and stdvalue_c.judcmtcd = judcmtstc.judcmtcd(+)
                               and stdvalue.stdvaluemngcd = stdvalue_c.stdvaluemngcd
                               and stdvalue.itemcd = item_c.itemcd
                               and stdvalue.suffix = item_c.suffix
                           ) nativestdvalue
                         where
                           nativestdvalue.itemcd = sentence.itemcd(+)
                           and nativestdvalue.itemtype = sentence.itemtype(+)
                           and nativestdvalue.lowervalue = sentence.stccd(+)
                         order by
                           nativestdvalue.gender
                           , nativestdvalue.priorseq
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 基準値テーブルレコードを登録する
        /// </summary>
        /// <param name="data">基準値テーブル情報
        /// stdValueMngCd 基準値管理コード
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// strDate 使用開始日付
        /// endDate 使用終了日付
        /// csCd 対象コースコード
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistStdValue(JToken data)
        {
            string sql;     // SQLステートメント
            string mode;    //登録モード("INS":挿入、"UPD":更新)
            string stdValueMngCd = "0";

            Insert ret = Insert.Error;
            int ret2;

            // 基準値管理コードが０なら新しい番号を取得
            if (0 == Convert.ToInt32(data["stdValueMngCd"]))
            {
                mode = "INS";
                sql = @"
                     select
                           nvl(max(stdvaluemngcd) + 1, 1) newno
                       from
                           stdvalue
                      ";

                dynamic current = connection.Query(sql).FirstOrDefault();

                // 基準値管理番号の取得
                stdValueMngCd = Convert.ToString(current.NEWNO);

            }
            else
            {
                mode = "UPD";
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("stdvaluemngcd", stdValueMngCd);
            param.Add("itemcd", Convert.ToString(data["itemCd"]));
            param.Add("suffix", Convert.ToString(data["suffix"]));
            param.Add("strdate", Convert.ToString(data["strDate"]));
            param.Add("enddate", Convert.ToString(data["endDate"]));
            param.Add("cscd", Convert.ToString(data["csCd"]));

            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    // 基準値テーブルレコードの更新
                    if (mode.Equals("UPD"))
                    {
                        sql = @"
                                update stdvalue
                                   set
                                       itemcd = :itemcd
                                     , suffix = :suffix
                                     , strdate = :strdate
                                     , enddate = :enddate
                                     , cscd = :cscd
                                 where
                                       stdvaluemngcd = :stdvaluemngcd
                            ";

                        ret2 = connection.Execute(sql, param);

                        if (ret2 > 0)
                        {
                            ret = Insert.Normal;
                            break;
                        }
                    }

                    // 検索条件を満たす基準値テーブルのレコードを取得
                    sql = @"
                             select
                                    stdvaluemngcd
                               from
                                    stdvalue
                              where
                                    stdvaluemngcd = :stdvaluemngcd
                         ";

                    dynamic current2 = connection.Query(sql, param).FirstOrDefault();

                    // 存在した場合、新規挿入不可
                    if (current2 != null)
                    {
                        ret = Insert.Duplicate;
                        break;
                    }

                    // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                    sql = @"
                                insert
                                  into stdvalue(
                                      stdvaluemngcd
                                    , itemcd
                                    , suffix
                                    , strdate
                                    , enddate
                                    , cscd
                                  )
                                  values (
                                    :stdvaluemngcd
                                    , :itemcd
                                    , :suffix
                                    , :strdate
                                    , :enddate
                                    , :cscd
                                  )
                            ";

                    connection.Execute(sql, param);

                    ret = Insert.Normal;
                    break;
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
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
        /// 基準値テーブル及び基準値詳細テーブルレコードを登録する
        /// </summary>
        /// <param name="data">基準値テーブル情報
        /// stdValueMngCd 基準値管理コード
        /// stdValueCd 基準値コード
        /// gender 性別
        /// strAge 開始年齢
        /// endAge 終了年齢
        /// priorSeq 適用優先順位番号
        /// lowerValue 基準値（以上）
        /// upperValue 基準値（以下）
        /// stdFlg 基準値フラグ
        /// judCd 判定コード
        /// judCmtCd 判定コメントコード
        /// healthPoint ヘルスポイント
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// strDate 使用開始日付
        /// endDate 使用終了日付
        /// csCd 対象コースコード
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistStdValue_All(JToken data)
        {
            Insert ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    // 基準値テーブルの更新
                    ret = RegistStdValue(data);

                    // 異常終了なら処理終了
                    if (Insert.Normal != ret)
                    {
                        break;
                    }

                    // 基準値詳細テーブルの更新
                    ret = RegistStdValue_c(data);

                    // 異常終了なら処理終了
                    if (Insert.Normal != ret)
                    {
                        break;
                    }

                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
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
        /// 基準値テーブルレコードを登録する
        /// </summary>
        /// <param name="data">基準値テーブル情報
        /// stdValueMngCd 基準値管理コード
        /// gender 性別
        /// strAge 開始年齢
        /// endAge 終了年齢
        /// priorSeq 適用優先順位番号
        /// lowerValue 基準値（以上）
        /// upperValue 基準値（以下）
        /// stdFlg 基準値フラグ
        /// judCd 判定コード
        /// judCmtCd 判定コメントコード
        /// healthPoint ヘルスポイント
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistStdValue_c(JToken data)
        {
            string sql; // SQLステートメント
            string sql2; // SQLステートメント

            Insert ret = Insert.Error;
            long newNo = new long();

            // 基準値コード最大値の取得
            sql = @"
                    select
                      nvl(max(stdvaluecd) + 1, 1) newno
                    from
                      stdvalue_c
                ";

            dynamic current = connection.Query(sql).FirstOrDefault();
            newNo = long.Parse(current.NEWNO);


            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("stdvaluemngcd", Convert.ToString(data["stdValueMngcd"]));
            sql2 = @"
                     delete stdvalue_c
                     where
                       stdvaluemngcd = :stdvaluemngcd
                 ";

            // 対象基準値詳細レコードの削除
            connection.Execute(sql2, param);

            // セットデータのチェック
            List<JToken> items = data.ToObject<List<JToken>>();
            if (items.Count > 0)
            {
                // パラメーター値設定
                var paramArray = new List<Dictionary<string, object>>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    // 基準値コード未セット（新規）データの検索
                    if (String.IsNullOrEmpty(rec["stdValueCd"].ToString()) || "0".Equals(rec["stdValueCd"]))
                    {
                        // 現在の基準値番号の最大値をセット（その後インクリメント）
                        param.Add("stdvaluecd", newNo.ToString());
                        newNo = newNo + 1;
                    }
                    else
                    {
                        param.Add("stdvaluecd", Convert.ToString(rec["stdValueCd"]));
                    }

                    // 万が一年齢がセットされていない場合は、勝手にセットする（下）～両方セットされてないならOracleでBOMB
                    if (String.IsNullOrEmpty(rec["strAge"].ToString()) || !String.IsNullOrEmpty(rec["endAge"].ToString()))
                    {
                        param.Add("strage", Convert.ToString(rec["endAge"]));
                    }
                    else
                    {
                        param.Add("strage", Convert.ToString(rec["strAge"]));
                    }

                    // 万が一年齢がセットされていない場合は、勝手にセットする（上）～両方セットされてないならOracleでBOMB
                    if (!String.IsNullOrEmpty(rec["strAge"].ToString()) || String.IsNullOrEmpty(rec["endAge"].ToString()))
                    {
                        param.Add("engage", Convert.ToString(rec["strAge"]));
                    }
                    else
                    {
                        param.Add("engage", Convert.ToString(rec["engAge"]));
                    }

                    // 万が一基準値がセットされていない場合は、勝手にセットする（下）～両方セットされてないならOracleでBOMB
                    if (String.IsNullOrEmpty(rec["lowerValue"].ToString()) || !String.IsNullOrEmpty(rec["upperValue"].ToString()))
                    {
                        param.Add("lowervalue", Convert.ToString(rec["upperValue"]));
                    }
                    else
                    {
                        param.Add("lowervalue", Convert.ToString(rec["lowerValue"]));
                    }

                    // 万が一基準値がセットされていない場合は、勝手にセットする（上）～両方セットされてないならOracleでBOMB
                    if (!String.IsNullOrEmpty(rec["lowerValue"].ToString()) || String.IsNullOrEmpty(rec["upperValue"].ToString()))
                    {
                        param.Add("uppervalue", Convert.ToString(rec["lowerValue"]));
                    }
                    else
                    {
                        param.Add("uppervalue", Convert.ToString(rec["upperValue"]));
                    }

                    param.Add("priorseq", Convert.ToString(rec["priorSeq"]));
                    param.Add("stdflg", Convert.ToString(rec["stdFlg"]));
                    param.Add("judcd", Convert.ToString(rec["judCd"]));
                    param.Add("judcmtcd", Convert.ToString(rec["judcmtCd"]));
                    param.Add("healthpoint", Convert.ToString(rec["healthPoint"]));

                    paramArray.Add(param);
                }

                // 新規挿入
                sql = "";

                sql = @"
                        insert
                        into stdvalue_c(
                          stdvaluecd
                          , stdvaluemngcd
                          , gender
                          , strage
                          , endage
                          , priorseq
                          , lowervalue
                          , uppervalue
                          , stdflg
                          , judcd
                          , judcmtcd
                          , healthpoint
                        )
                        values (
                          :stdvaluecd
                          , :stdvaluemngcd
                          , :gender
                          , :strage
                          , :endage
                          , :priorseq
                          , :lowervalue
                          , :uppervalue
                          , :stdflg
                          , :judcd
                          , :judcmtcd
                          , :healthpoint
                        )
                     ";

                using (var transaction = BeginTransaction())
                {
                    connection.Execute(sql, paramArray);
                    ret = Insert.Normal;

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

            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 検査項目の基準値情報を取得する
        /// </summary>
        /// <param name="data">基準値テーブル情報
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// csCd コースコード
        /// cslDateYear 受診日（年）
        /// cslDateMonth 受診日（月
        /// cslDateDay 受診日（日）
        /// age 年齢
        /// gender 性別
        /// </param>
        /// <param name="historyCount"></param>
        /// <param name="ageFlg"></param>
        /// <param name="genderFlg"></param>
        /// <returns>
        /// historyCount 該当検査項目・コースの基準値履歴レコード件数
        /// ageFlg 該当受診日の基準値履歴の年齢管理有無（0:無,1:有）
        /// genderFlg 該当受診日の基準値履歴の性別管理有無（0:無,1:有）
        /// csCd コースコード（配列）
        /// csName コース名（配列）
        /// gender 性別（配列）名称変換済み
        /// strAge 開始年齢（配列）
        /// endAge 終了年齢（配列）
        /// lowerValue 下限値（配列）
        /// upperValue 上限値（配列）(文章タイプの場合下限・上限値は等しいのでここに所見文章を設定する)
        /// stdFlg 基準値フラグ（配列）
        /// stdFlgColor 基準値フラグ表示色（配列）
        /// judCd 判定コード（配列）
        /// healthPoint ヘルスポイント（配列）
        /// </returns>
        public List<dynamic> SelectItemStdValue(JToken data, ref long historyCount, ref long ageFlg, ref long genderFlg)
        {
            string sql; // SQLステートメント

            long nullFlg = new long(); //コースコードのNullの有無

            DateTime dateTime = new DateTime();

            // 検索条件が設定されていない場合はエラー
            if (String.IsNullOrEmpty(Convert.ToString(data["itemCd"]))
                || String.IsNullOrEmpty(Convert.ToString(data["suffix"])))
            {
                throw new ArgumentException();
            }

            // 日期
            string date = Convert.ToString(data["cslDateYear"]) + "/" + Convert.ToString(data["cslDateMonth"]) + "/" + Convert.ToString(data["cslDateDay"]);
            if (!DateTime.TryParse(date, out dateTime))
            {
                throw new ArgumentException();
            }

            // 年齢
            if (!String.IsNullOrEmpty(Convert.ToString(data["age"])))
            {
                if (!IsNumber(Convert.ToString(data["age"])))
                {
                    throw new ArgumentException();
                }
                else
                {
                    if (Convert.ToInt64(Convert.ToString(data["age"])) < Convert.ToInt64(Age.MinValue)
                        || Convert.ToInt64(Convert.ToString(data["age"])) > Convert.ToInt64(Age.MaxValue))
                    {
                        throw new ArgumentException();
                    }
                }
            }

            // 性別
            if (!String.IsNullOrEmpty(Convert.ToString(data["gender"])))
            {
                if (!IsNumber(Convert.ToString(data["gender"])))
                {
                    throw new ArgumentException();
                }
                else
                {
                    if (Convert.ToInt64(Convert.ToString(data["gender"])) != Convert.ToInt64(Gender.Male)
                        || Convert.ToInt64(Convert.ToString(data["gender"])) != Convert.ToInt64(Gender.Female))
                    {
                        throw new ArgumentException();
                    }
                }
            }

            var param = new Dictionary<string, object>();
            param.Add("itemcd", Convert.ToString(data["itemCd"]));
            param.Add("suffix", Convert.ToString(data["suffix"]));
            param.Add("cscd", Convert.ToString(data["csCd"]));
            param.Add("csldate", date);
            if (!String.IsNullOrEmpty(Convert.ToString(data["age"])))
            {
                param.Add("age", Convert.ToString(data["age"]));
            }
            if (!String.IsNullOrEmpty(Convert.ToString(data["gender"])))
            {
                param.Add("gender", Convert.ToString(data["gender"]));
            }
            param.Add("gender_m", Gender.Male);
            param.Add("gender_f", Gender.Female);

            // コースコード、年齢，性別指定時は履歴数、履歴管理の有無を取得
            if (String.IsNullOrEmpty(Convert.ToString(data["csCd"]))
                && String.IsNullOrEmpty(Convert.ToString(data["age"]))
                && String.IsNullOrEmpty(Convert.ToString(data["gender"])))
            {
                // 該当検査項目・コースの基準値履歴レコード件数を取得
                sql = @"
                        select
                          decode(
                            cs.historycount
                            , 0
                            , nocs.historycount
                            , cs.historycount
                          ) historycount
                          , decode(cs.historycount, 0, '1', '0') nullflg
                        from
                          (
                            select
                              count(*) historycount
                            from
                              stdvalue sv
                            where
                              sv.itemcd = :itemcd
                              and sv.suffix = :suffix
                              and sv.cscd = :cscd
                          ) cs
                          , (
                            select
                              count(*) historycount
                            from
                              stdvalue sv1
                            where
                              sv1.itemcd = :itemcd
                              and sv1.suffix = :suffix
                              and sv1.cscd is null
                          ) nocs
                    ";

                dynamic current1 = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                // (COUNT関数を発行しているので必ず1レコード返ってくる)
                if (current1 != null)
                {
                    // NULLフラグの設定
                    nullFlg = long.Parse(current1.NULLFLG);
                    // 戻り値の設定
                    historyCount = long.Parse(current1.HISTORYCOUNT);
                }

                sql = "";

                // 該当受診日の基準値履歴の年齢管理有無を取得
                sql = @"
                        select
                          count(*) ageflg
                        from
                          stdvalue sv
                          , stdvalue_c vc
                        where
                          sv.itemcd = :itemcd
                          and sv.suffix = :suffix
                    ";

                if (0 == nullFlg)
                {
                    sql += @"
                            and sv.cscd = :cscd
                         ";
                }
                else
                {
                    sql += @"
                            and sv.cscd is null
                         ";
                }

                sql += @"
                        and sv.strdate <= :csldate
                        and sv.enddate >= :csldate
                        and sv.stdvaluemngcd = vc.stdvaluemngcd
                        and not (vc.strage = :age_min and vc.endage = :age_max)
                     ";

                dynamic current2 = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                // (COUNT関数を発行しているので必ず1レコード返ってくる)
                if (null != current2)
                {
                    // 戻り値の設定
                    if (Convert.ToInt32(current2.AGEFLG) == 0)
                    {
                        ageFlg = 0;
                    }
                    else
                    {
                        ageFlg = 1;
                    }
                }

                sql = "";

                // 該当受診日の基準値履歴の性別管理有無を取得
                sql = @"
                        select
                          count(*) genderflg
                        from
                          stdvalue sv
                          , stdvalue_c vc
                        where
                          sv.itemcd = :itemcd
                          and sv.suffix = :suffix
                    ";

                if (0 == nullFlg)
                {
                    // コースコードが指定されている時
                    sql += @"
                           and sv.cscd = :cscd
                         ";
                }
                else
                {
                    // コースコードが指定されていない時
                    sql += @"
                           and sv.cscd is null
                         ";
                }

                sql += @"
                        and sv.strdate <= :csldate
                        and sv.enddate >= :csldate
                        and sv.stdvaluemngcd = vc.stdvaluemngcd
                        and vc.gender = :gender_m
                        and not exists (
                          select
                            vc2.stdvaluecd
                          from
                            stdvalue sv2
                            , stdvalue_c vc2
                          where
                            sv2.itemcd = :itemcd
                            and sv2.suffix = :suffix
                     ";

                if (0 == nullFlg)
                {
                    // コースコードが指定されている時
                    sql += @"
                           and sv2.cscd = :cscd
                         ";
                }
                else
                {
                    // コースコードが指定されていない時
                    sql += @"
                           and sv2.cscd is null
                         ";
                }

                sql += @"
                        and sv2.strdate <= :csldate
                        and sv2.enddate >= :csldate
                        and sv2.stdvaluemngcd = vc2.stdvaluemngcd
                        and vc2.gender = :gender_f
                        and vc2.strage = vc.strage
                        and vc2.endage = vc.endage
                        and nvl(rtrim(vc2.lowervalue), ' ') = nvl(rtrim(vc.lowervalue), ' ')
                        and nvl(rtrim(vc2.uppervalue), ' ') = nvl(rtrim(vc.uppervalue), ' ')
                     ";

                dynamic current3 = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                // (COUNT関数を発行しているので必ず1レコード返ってくる)
                if (null != current3)
                {
                    // 戻り値の設定
                    if (Convert.ToInt32(current2.GENDERFLG) == 0)
                    {
                        genderFlg = 0;
                    }
                    else
                    {
                        genderFlg = 1;
                    }
                }
            }

            // 該当受診日・年齢・性別の基準値情報を取得
            sql = "";
            sql = @"
                    select
                      stdinfo.cscd
                      , stdinfo.csname
                      , stdinfo.gendername
                      , stdinfo.strage
                      , stdinfo.endage
                      , stdinfo.lowervalue
                      , nvl(sentence.shortstc, stdinfo.uppervalue) uppervalue
                      , stdinfo.stdflg
                      , stdinfo.judcd
                      , stdinfo.healthpoint
                    from
                      sentence
                      , (
                        select
                          stdvalue.cscd
                          , course_p.csname
                          , decode(stdvalue_c.gender, '1', '男性', '2', '女性', null) gendername
                          , stdvalue_c.strage
                          , stdvalue_c.endage
                          , stdvalue_c.lowervalue
                          , stdvalue_c.uppervalue
                          , stdvalue_c.stdflg
                          , stdvalue_c.judcd
                          , stdvalue_c.healthpoint
                          , item_c.stcitemcd
                          , item_c.itemtype
                        from
                          item_c
                          , stdvalue
                          , stdvalue_c
                          , course_p
                        where
                          stdvalue.itemcd = :itemcd
                          and stdvalue.suffix = :suffix
                ";

            // コースコード指定時(インデックスの配列要素数は1)
            if (String.IsNullOrEmpty(Convert.ToString(data["csCd"])))
            {

                if (0 == nullFlg)
                {
                    // コースコードが指定されている時
                    sql += @"
                            and stdvalue.cscd = :cscd
                         ";
                }
                else
                {
                    // コースコード指定時(インデックスの配列要素数は1)
                    sql += @"
                            and stdvalue.cscd is null
                        ";
                }
            }

            sql += @"
                    and stdvalue.cscd = course_p.cscd(+)
                    and stdvalue.strdate <= :csldate
                    and stdvalue.enddate >= :csldate
                    and stdvalue.stdvaluemngcd = stdvalue_c.stdvaluemngcd
                 ";

            // 性別指定時
            if (String.IsNullOrEmpty(Convert.ToString(data["gender"])))
            {
                sql += @"
                        and stdvalue_c.gender = :gender
                    ";
            }

            // 年齢指定時
            if (String.IsNullOrEmpty(Convert.ToString(data["age"])))
            {
                sql += @"
                        and stdvalue_c.strage <= :age
                        and stdvalue_c.endage >= :age
                    ";
            }

            sql += @"
                    and stdvalue.itemcd = item_c.itemcd
                    and stdvalue.suffix = item_c.suffix
                    order by
                      stdvalue.cscd
                      , stdvalue_c.gender
                      , stdvalue_c.strage
                      , stdvalue_c.endage
                      , stdvalue_c.priorseq) stdinfo
                    where
                      stdinfo.stcitemcd = sentence.itemcd(+)
                      and stdinfo.itemtype = sentence.itemtype(+)
                      and stdinfo.lowervalue = sentence.stccd(+)
                 ";


            // #ToDo Select後の.Net側での処理をどうするか
            //配列形式で格納する
            //Do Until objOraDyna.EOF
            //objCommon.SelectStdFlgColor RTrim(vntArrStdFlg(lngCount)) & "_COLOR", strStdFlgColor
            //Loop

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 基準値テーブルレコードを削除する
        /// </summary>
        /// <param name="stdValueMngCd">基準値コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteStdValue(string stdValueMngCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("stdvaluemngcd", stdValueMngCd.Trim());

            // 基準値テーブルレコードの削除
            sql = @"
                    delete stdvalue
                    where
                      stdvaluemngcd = :stdvaluemngcd
                ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }
    }
}
