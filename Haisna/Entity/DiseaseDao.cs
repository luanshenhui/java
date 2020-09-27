using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 病名情報データアクセスオブジェクト
    /// </summary>
    public class DiseaseDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public DiseaseDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 病名テーブルレコードを削除する
        /// </summary>
        /// <param name="disCd">病名コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteDisease(string disCd)
        {

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("discd", disCd);

            // 病名テーブルレコードの削除
            string sql = "delete disease where discd = :discd";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 病名テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// disCd       病名コード
        /// disName     病名名
        /// searchChar  ガイド検索用文字列
        /// disDivCd    病類コード
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistDisease(string mode, JToken data)
        {
            string sql;  // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("discd", Convert.ToString(data["discd"]));
            param.Add("disname", Convert.ToString(data["disname"]));
            param.Add("searchchar", Convert.ToString(data["searchchar"]));
            param.Add("disdivcd", Convert.ToString(data["disdivcd"]));

            while (true)
            {
                // 病名テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update disease
                            set
                              disname = :disname
                              , searchchar = :searchchar
                              , disdivcd = :disdivcd
                            where
                              discd = :discd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす病名テーブルのレコードを取得
                sql = @"
                        select
                          disname
                        from
                          disease
                        where
                          discd = :discd
                     ";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                if (current != null)
                {
                    ret = Insert.HistoryDuplicate;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into disease(discd, disname, searchchar, disdivcd)
                        values (:discd, :disname, :searchchar, :disdivcd)
                     ";

                connection.Execute(sql, param);
                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 病名コードに対する病名名を取得する
        /// </summary>
        /// <param name="disCd">病名コード</param>
        /// <returns>
        /// disName        病名名
        /// searchChar     ガイド検索用文字列
        /// disDivCd       病類コード
        /// disDivName     病類名
        /// </returns>
        public dynamic SelectDisease(string disCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("discd", disCd);

            // 検索条件を満たす病名テーブルのレコードを取得
            string sql = @"
                            select
                              disease.disname
                              , disease.searchchar
                              , disease.disdivcd
                              , disdiv.disdivname
                            from
                              disdiv
                              , disease
                            where
                              disease.discd = :discd
                              and disease.disdivcd = disdiv.disdivcd(+)
                        ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 病名の一覧を取得する
        /// </summary>
        /// <returns>
        /// disCd      病名コード
        /// disName    病名名
        /// disDivName 病類名
        /// </returns>
        public List<dynamic> SelectDiseaseItemList()
        {
            // 病名テーブルの全レコードを取得
            string sql = @"
                            select
                              disease.discd
                              , disease.disname
                              , disease.searchchar
                              , disease.disdivcd
                              , disdiv.disdivname
                            from
                              disdiv
                              , disease
                            where
                              disease.disdivcd = disdiv.disdivcd(+)
                            order by
                              disease.discd
                        ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 病類テーブルレコードを削除する
        /// </summary>
        /// <param name="disDivCd">病類コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteDisDiv(string disDivCd)
        {

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("disdivcd", disDivCd);

            // 病類テーブルレコードの削除
            string sql = "delete disdiv where disdivcd = :disdivcd";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 病類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// disDivCd    病類コード
        /// disDivName  病類名
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistDisDiv(string mode, JToken data)
        {
            string sql;  // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("disdivcd", Convert.ToString(data["disdivcd"]));
            param.Add("disdivname", Convert.ToString(data["disdivname"]));

            while (true)
            {
                // 病類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update disdiv
                            set
                              disdivname = :disdivname
                            where
                              disdivcd = :disdivcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす病類テーブルのレコードを取得
                sql = @"
                        select
                          disdivname
                        from
                          disdiv
                        where
                          disdivcd = :disdivcd
                     ";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                if (current != null)
                {
                    ret = Insert.HistoryDuplicate;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into disdiv(disdivcd, disdivname)
                        values (:disdivcd, :disdivname)
                     ";

                connection.Execute(sql, param);
                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 病類コードに対する病類名を取得する
        /// </summary>
        /// <param name="disDivCd">病類コード</param>
        /// <param name="disDivName"></param>
        /// <returns>
        /// true   レコードあり
        /// false  レコードなし、または異常終了
        /// </returns>
        public bool SelectDisDiv(string disDivCd, ref string disDivName)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("disdivcd", disDivCd);

            // 検索条件を満たす病類テーブルのレコードを取得
            string sql = @"
                            select
                              disdivname
                            from
                              disdiv
                            where
                              disdivcd = :disdivcd
                        ";

            dynamic currect = connection.Query(sql, param).ToList();

            if (currect != null)
            {
                // 戻り値の設定
                disDivName = currect.DISDIVNAME;
                return true;
            }

            return false;
        }

        /// <summary>
        /// 病類の一覧を取得する
        /// </summary>
        /// <returns>
        /// disDivCd    病類コード
        /// disDivName  病類名
        /// </returns>
        public List<dynamic> SelectDisDivList()
        {
            // 病類テーブルの全レコードを取得
            string sql = @"
                            select
                              disdivcd
                              , disdivname
                            from
                              disdiv
                            order by
                              disdivcd
                        ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 既往歴家族歴テーブルにレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// perid              個人ＩＤ
        /// relation           続柄
        /// discd              病名コード
        /// strdate            発病年月
        /// enddate            治癒年月
        /// condition          状態
        /// medical            医療機関
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert InsertDisHistory(JToken data)
        {
            Insert ret = Insert.Error;  // 関数戻り値

            try
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("perid", Convert.ToString(data["perid"]));
                param.Add("relation", Convert.ToInt32(data["relation"]));
                param.Add("discd", Convert.ToString(data["discd"]));
                param.Add("strdate", Convert.ToDateTime(data["strdate"]));
                param.Add("enddate", Convert.ToDateTime(data["enddate"]));
                param.Add("condition", Convert.ToInt32(data["condition"]));
                param.Add("medical", Convert.ToString(data["medical"]));

                // 既往歴家族歴テーブルレコードの挿入
                string sql = @"
                               insert
                               into dishistory(
                                 perid
                                 , relation
                                 , discd
                                 , strdate
                                 , enddate
                                 , condition
                                 , medical
                               )
                               values (
                                 :perid
                                 , :relation
                                 , :discd
                                 , :strdate
                                 , :enddate
                                 , :condition
                                 , :medical
                               )
                            ";

                connection.Execute(sql, param);
                ret = Insert.Normal;

            }
            catch (OracleException ex)
            {
                // キー重複、整合性違反時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    ret = Insert.Duplicate;
                    return ret;
                }
                else if (ex.Number == 2291)
                {
                    throw new NotImplementedException();
                }

                ret = Insert.Error;
            }
            return ret;
        }

        /// <summary>
        /// キー情報をもとに既往歴家族歴テーブルを更新する
        /// </summary>
        /// <param name="data">
        /// perid              個人ＩＤ
        /// relation           続柄
        /// discd              病名コード
        /// strdate            発病年月
        /// enddate            治癒年月
        /// condition          状態
        /// medical            医療機関
        /// </param>
        /// <returns>
        /// Update.Normal      正常終了
        /// Update.Notfound    更新レコードなし
        /// Update.Error       異常終了
        /// </returns>
        public Update UpdateDisHistory(JToken data)
        {
            Update ret;  // 関数戻り値
            int ret2;

            try
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("perid", Convert.ToString(data["perid"]));
                param.Add("relation", Convert.ToInt32(data["relation"]));
                param.Add("discd", Convert.ToString(data["discd"]));
                param.Add("strdate", Convert.ToDateTime(data["strdate"]));
                param.Add("enddate", Convert.ToDateTime(data["enddate"]));
                param.Add("condition", Convert.ToInt32(data["condition"]));
                param.Add("medical", Convert.ToString(data["medical"]));

                using (var transaction = BeginTransaction())
                {
                    // 既往歴家族歴テーブルレコードの更新
                    string sql = @"
                                    update dishistory
                                    set
                                      enddate = :enddate
                                      , condition = :condition
                                      , medical = :medical
                                      , upddate = sysdate
                                    where
                                      perid = :perid
                                      and relation = :relation
                                      and discd = :discd
                                      and strdate = :strdate
                                ";

                    ret2 = connection.Execute(sql, param);
                    if (ret2 > 0)
                    {
                        ret = Update.Normal;
                    }
                    else
                    {
                        ret = Update.NotFound;
                    }

                    // トランザクションをコミット
                    transaction.Commit();
                }
            }
            catch (OracleException ex)
            {
                // 整合性違反時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 2291)
                {
                    throw new NotImplementedException();
                }

                ret = Update.Error;
            }
            return ret;
        }

        /// <summary>
        /// 既往歴家族歴各値の妥当性チェックを行う
        /// </summary>
        /// <param name="data">個人情報
        /// perid      個人ＩＤ
        /// relation   続柄
        /// discd      病名コード
        /// stryear    発病年
        /// strmonth   発病月
        /// endyear    治癒年
        /// endmonth   治癒月
        /// condition  状態
        /// medical    医療機関
        /// </param>
        /// <param name="strDate">発病年月</param>
        /// <param name="endDate">治癒年月</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValue(JToken data, out DateTime? strDate, out DateTime? endDate)
        {
            strDate = null;
            endDate = null;

            var messages = new List<string>();

            // 続柄
            if (string.IsNullOrEmpty(Convert.ToString(data["relation"])))
            {
                messages.Add("続柄を入力して下さい。");
            }

            // 病名コード
            // #ToDo 病名コードの判断、relationを使用しますか？
            if ("0".Equals(Convert.ToString(data["relation"])))
            {
                messages.Add(WebHains.CheckAlphabetAndNumeric("既往症", Convert.ToString(data["discd"]), Convert.ToInt32(LengthConstants.LENGTH_DISEASE_DISCD), Check.Necessary));
            }
            else
            {
                messages.Add(WebHains.CheckAlphabetAndNumeric("病名", Convert.ToString(data["discd"]), Convert.ToInt32(LengthConstants.LENGTH_DISEASE_DISCD), Check.Necessary));
            }

            // 発病年月
            messages.Add(WebHains.CheckDate("発病年月", Convert.ToString(data["stryear"]), Convert.ToString(data["strmonth"]), "1", out strDate));

            // 治癒年月
            if (Convert.ToInt32(data["endyear"]) != 0 || Convert.ToInt32(data["endmonth"]) != 0)
            {
                messages.Add(WebHains.CheckDate("治癒年月", Convert.ToString(data["endyear"]), Convert.ToString(data["endmonth"]), "1", out endDate));
            }

            // 戻り値の編集
            return messages;
        }

        /// <summary>
        /// 既往歴家族歴テーブルレコードを削除する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="relation">続柄</param>
        /// <param name="disCd">病名コード</param>
        /// <param name="strDate">発病年月</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteDisHistory(string perId, string relation, string disCd, string strDate)
        {
            // 検索条件が設定されていない場合は処理を終了する
            if (perId.Equals("")
                || !Util.IsNumber(relation)
                || disCd.Equals("")
                || !DateTime.TryParse(strDate, out DateTime tmpDate))
            {
                return false;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);
            param.Add("relation", relation);
            param.Add("discd", disCd);
            param.Add("strdate", strDate);

            // 既往歴家族歴テーブルレコードの削除
            string sql = @"
                            delete dishistory
                            where
                              perid = :perid
                              and relation = :relation
                              and discd = :discd
                              and strdate = :strdate
                        ";

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// キー情報をもとに既往歴家族歴テーブルを読み込む
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="relation">続柄</param>
        /// <param name="disCd">病名コード</param>
        /// <param name="strDate">発病年月</param>
        /// <returns>個人情報
        /// endyear    治癒年
        /// endmonth   治癒月
        /// condition  状態
        /// medical    医療機関
        /// disname    病名
        /// </returns>
        public dynamic SelectDisHistory(string perId, string relation, string disCd, string strDate)
        {
            // 検索条件が設定されていない場合は処理を終了する
            if (perId.Equals("")
                || !Util.IsNumber(relation)
                || disCd.Equals("")
                || !DateTime.TryParse(strDate, out DateTime tmpDate))
            {
                return null;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);
            param.Add("relation", relation);
            param.Add("discd", disCd);
            param.Add("strdate", strDate);

            // 検索条件を満たす既往歴家族歴テーブルのレコードを取得
            string sql = @"
                           select
                             dh.enddate enddate
                             , dh.condition condition
                             , dh.medical medical
                             , d.disname disname
                             , nvl2(dh.enddate, extract(year from dh.enddate), 0) endyear
                             , nvl2(dh.enddate, extract(month from dh.enddate), 0) endmonth
                           from
                             dishistory dh
                             , disease d
                           where
                             dh.perid = :perid
                             and dh.relation = :relation
                             and dh.discd = :discd
                             and dh.strdate = :strdate
                             and dh.discd = d.discd
                        ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 個人ＩＤをもとに個人テーブルを読み込む
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>個人情報
        /// lastname    姓
        /// firstname   名
        /// lastkname   カナ姓
        /// firstkname  カナ名
        /// birth       生年月日
        /// gendername  性別名
        /// </returns>
        public dynamic SelectPerson(string perId)
        {
            // 検索条件が設定されていない場合は処理を終了する
            if (perId.Equals(""))
            {
                return null;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);

            // 検索条件を満たす個人テーブルのレコードを取得
            string sql = @"
                            select
                              lastname
                              , firstname
                              , lastkname
                              , firstkname
                              , birth
                              , decode(gender, '1', '男性', '2', '女性', null) gendername
                            from
                              person
                        ";

            sql += " where perid  = :perid and delflg = '" + DelFlg.Used + "'";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 該当個人の既往歴のレコード件数を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>該当個人の既往歴のレコード件数</returns>
        public int SelectDiseaseListCount(string perId)
        {
            int cnt = 0;

            // 個人ＩＤが設定されていない場合は処理を終了する
            if (!perId.Equals(""))
            {
                // キー値の設定
                var param = new Dictionary<string, object>();
                param.Add("perid", perId);

                // 該当個人の既往歴のレコード件数を取得
                string sql = @"
                                select
                                  count(*) cnt
                                from
                                  dishistory
                                where
                                  perid = :perid
                                  and relation = 0
                            ";

                cnt = connection.Query(sql, param).FirstOrDefault().CNT;
            }

            return cnt;
        }

        /// <summary>
        /// 該当個人の家族歴のレコード件数を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>該当個人の家族歴のレコード件数</returns>
        public int SelectFamilyListCount(string perId)
        {
            int cnt = 0;

            // 個人ＩＤが設定されていない場合は処理を終了する
            if (!perId.Equals(""))
            {
                // キー値の設定
                var param = new Dictionary<string, object>();
                param.Add("perid", perId);

                // 該当個人の家族歴のレコード件数を取得
                string sql = @"
                                select
                                  count(*) cnt
                                from
                                  dishistory
                                where
                                  perid = :perid
                                  and relation != 0
                            ";

                cnt = connection.Query(sql, param).FirstOrDefault().CNT;
            }

            return cnt;
        }

        /// <summary>
        /// 条件を満たす個人の既往歴一覧を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>
        /// strDate            発病年月
        /// disCd              病名コード
        /// disName            病名
        /// medical            医療機関
        /// endDate            治癒年月
        /// condition          状態
        /// </returns>
        public List<dynamic> SelectDiseaseList(string perId)
        {
            // 個人ＩＤが設定されていない場合は処理を終了する
            if (perId.Equals(""))
            {
                return null;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);

            // 条件を満たす既往歴家族歴テーブルのレコードを取得
            string sql = @"
                            select
                                dh.discd discd
                                , dh.strdate strdate
                                , dh.enddate enddate
                                , dh.condition condition
                                , dh.medical medical
                                , d.disname disname
                            from
                                dishistory dh
                                , disease d
                            where
                                dh.perid = :perid
                                and dh.relation = 0
                                and dh.discd = d.discd
                            order by
                                dh.strdate desc
                                , dh.enddate desc
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 条件を満たす個人の家族歴一覧を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>
        /// relation           続柄
        /// disCd              病名コード
        /// disName            病名
        /// strDate            発病年月
        /// endDate            治癒年月
        /// condition          状態
        /// </returns>
        public List<dynamic> SelectFamilyList(string perId)
        {
            // 個人ＩＤが設定されていない場合は処理を終了する
            if (perId.Equals(""))
            {
                return null;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);

            // 条件を満たす既往歴家族歴テーブルのレコードを取得
            string sql = @"
                            select
                                dh.relation relation
                                , dh.discd discd
                                , dh.strdate strdate
                                , dh.enddate enddate
                                , dh.condition condition
                                , d.disname disname
                            from
                                dishistory dh
                                , disease d
                            where
                                dh.perid = :perid
                                and dh.relation != 0
                                and dh.discd = d.discd
                            order by
                                dh.relation
                                , dh.strdate desc
                                , dh.enddate desc
                            ";

            return connection.Query(sql, param).ToList();

        }

        /// <summary>
        /// 検索条件を満たす病名の一覧を取得する
        /// </summary>
        /// <param name="key">検索キーの集合</param>
        /// <param name="disDivCd">病類が指定されている場合は検索検索条件に追加</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>
        /// disCd              病名コード
        /// disName            病名
        /// searchChar         ガイド検索用文字列
        /// disDivCd           病類コード
        /// </returns>
        public List<dynamic> SelectDisList(string[] key, string disDivCd, int startPos, int getCount)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("disdivcd", disDivCd);
            param.Add("startpos", startPos);
            param.Add("endpos", startPos + getCount - 1);

            // 開始位置から取得件数分のレコードを取得
            string sql = @"
                            select
                              discd
                              , disname
                              , searchchar
                              , disdivcd
                            from
                              (
                                select
                                  rownum seq
                                  , discd
                                  , disname
                                  , searchchar
                                  , disdivcd
                                from
                                  disease
                        ";

            // 検索条件(key)が省略されている場合は全件検索とする
            if (key != null)
            {
                // 検索条件の追加
                sql += "          " + CreateConditionForDiseaseList(key);

                // 病類コードが存在する場合は条件節に追加
                if (!disDivCd.Equals(""))
                {
                    sql += " and disdivcd = " + disDivCd + " and disdivcd = :disdivcd";
                }
            }
            else
            {
                if (!disDivCd.Equals(""))
                {
                    sql += " where disdivcd = :disdivcd";
                }
            }

            // 病名の順にソート & 取得開始・終了位置を条件として追加
            sql += " order by discd ) where seq between :startpos and :endpos";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす病名の件数を取得する
        /// </summary>
        /// <param name="key">検索キーの集合</param>
        /// <param name="disDivCd">病類が指定されている場合は検索検索条件に追加</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int SelectDisListCount(string[] key, string disDivCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("disdivcd", disDivCd);

            // 検索条件を満たす個人テーブルのレコードを取得
            string sql = @"
                            select
                              count(*) cnt
                            from
                              disease
                        ";

            if (key != null)
            {
                // 検索条件の追加
                sql += " " + CreateConditionForDiseaseList(key);

                // 病類コードが存在する場合は条件節に追加
                if (!disDivCd.Equals(""))
                {
                    sql += " and disdivcd = :disdivcd";
                }
            }
            else
            {
                // 病類コードが存在する場合は条件節に追加
                if (!disDivCd.Equals(""))
                {
                    sql += " where disdivcd = :disdivcd";
                }
            }

            return connection.Query(sql, param).FirstOrDefault().CNT;
        }

        /// <summary>
        /// 病名テーブル検索用条件節作成
        /// </summary>
        /// <param name="key">検索キーの集合</param>
        /// <returns>個人テーブル検索用の条件節</returns>
        public string CreateConditionForDiseaseList(string[] key)
        {
            bool narrow;        // 検索キーが半角文字のみの場合にTrue
            string paramName;   // パラメータ名

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            // 最初はWHERE句から開始
            string sql = "where ";

            // 検索キー数分の条件節を追加
            for (int i = 0; i <= key.Length; i++)
            {
                // 2番目以降の条件節はANDで連結
                if (i >= 1)
                {
                    sql += " and";
                }

                // 検索キー中の半角カナを全角カナに変換する
                WebHains.StrConvKanaWide(key[i]);

                // 検索キーが半角文字のみかチェック
                if (Util.ConvertToBytes(key[i]).Length == key[i].Length)
                {
                    narrow = true;
                }
                else
                {
                    narrow = false;
                }

                paramName = "keyword" + i.ToString();
                param.Add(paramName, "%" + key[i] + "%");

                if (narrow)
                {
                    sql += "discd like :" + paramName;
                }
                else
                {
                    sql += "disname like :" + paramName;
                }
            }

            return sql;
        }
    }
}
