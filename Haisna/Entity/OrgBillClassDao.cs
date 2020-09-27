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
    /// 団体請求書分類データアクセスオブジェクト
    /// </summary>
    public class OrgBillClassDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public OrgBillClassDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 団体請求書分類テーブルにレコードを追加する
        /// </summary>
        /// <param name="data">団体請求書分類テーブル情報
        /// orgcd1  団体コード１
        /// orgcd2  団体コード２
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert NewInsrtOrgBillClass(JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", Convert.ToString(data["orgcd1"]));
            param.Add("orgcd2", Convert.ToString(data["orgcd2"]));

            // 団体請求書分類テーブルへのレコード追加
            sql = @"
                    insert
                    into orgbillclass(
                        orgcd1
                        , orgcd2
                        , billclasscd
                    )
                        select
                            :orgcd1
                            , :orgcd2
                            , billclasscd
                        from
                            billclass
                        where
                            defcheck = 1
                    )
                    ";

            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 団体管理請求書分類テーブルからレコードを削除する
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert DeleteOrgBillClass(string orgCd1, string orgCd2)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 団体請求書分類テーブルへのレコード削除
            sql = @"
                    delete
                        orgbillclass
                    where
                        orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                ";

            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求書分類テーブルからレコードを取得する
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns>団体請求書分類テーブル
        /// billClassCd 続柄コード
        /// billClassName 続柄名
        /// checkFlg 該当フラグ
        /// </returns>
        public List<dynamic> SelectBillClass(String orgCd1, String orgCd2)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 団体請求書分類テーブル検索
            // #ToDo 「orgcd」＝＝＞ orgcd as checkflg
            sql = @"
                    select
                        billclass.billclasscd
                        , billclass.billclassname
                        , (
                           select
                             orgcd1
                           from
                             orgbillclass
                           where
                             orgbillclass.orgcd1 = :orgcd1
                             and orgbillclass.orgcd2 = :orgcd2
                             and orgbillclass.billclasscd = billclass.billclasscd
                        ) orgcd as checkflg
                    from
                      billclass
                    order by
                      billclass.billclasscd
                ";

            // #ToDo Select後の.Net側での処理をどうするか
            //'配列形式で格納する
            //i = 0
            //lngCount = 0
            //Do Until objOraDyna.EOF

            //    ReDim Preserve vntArrBillClassCd(lngCount)
            //    ReDim Preserve vntArrBillClassName(lngCount)
            //    ReDim Preserve vntArrCheckFlg(lngCount)

            //    vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
            //    vntArrBillClassName(lngCount) = objBillClassName.Value & ""
            //    vntArrCheckFlg(lngCount) = objCheckFlg.Value & ""

            //    'チェックフラグが引数として渡されていれば、該当する請求書分類コードのフラグを立てる
            //    If(Not IsEmpty(vntCheckFlg)) Then
            //        If(UBound(vntCheckFlg) >= i) Then
            //            If(vntCheckFlg(i) = vntArrBillClassCd(lngCount)) Then
            //                vntArrCheckFlg(lngCount) = vntArrBillClassCd(lngCount)
            //                i = i + 1
            //            End If
            //        End If
            //    End If

            //    lngCount = lngCount + 1
            //    objOraDyna.MoveNext
            //Loop

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        ///  団体管理請求書分類テーブルへレコードを追加する
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2"> 団体コード２</param>
        /// <param name="data">請求書分類コード</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertOrgBillClass(String orgCd1, String orgCd2, JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // 請求書分類コードの設定をどうするか
            List<JToken> billclasscdItems = data.ToObject<List<JToken>>();

            // 団体請求書分類テーブル削除
            ret = DeleteOrgBillClass(orgCd1, orgCd2);

            // 異常終了なら処理終了
            if (ret != Insert.Normal)
            {
                // 戻り値の設定
                return ret;
            }

            if (billclasscdItems != null)
            {
                // パラメーター値設定
                var paramArray = new List<Dictionary<string, object>>();
                foreach (var rec in billclasscdItems)
                {
                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("orgcd1", orgCd1);
                    param.Add("orgcd2", orgCd2);
                    param.Add("billclasscd", Convert.ToString(rec["billclasscd"]).Trim());

                    paramArray.Add(param);
                }

                // 団体請求分類テーブルへのレコード追加
                sql = @"
                        insert into orgbillclass (
                                    orgcd1,
                                    orgcd2,
                                    billclasscd
                                ) values (
                                    :orgcd1,
                                    :orgcd2,
                                    :billclasscd
                                )
                    ";
                connection.Execute(sql, paramArray);
            }

            ret = Insert.Normal;


            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 団体請求書分類テーブルからレコードを取得する。
        /// </summary>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>  団体請求書分類テーブル
        /// cscd コースコード
        /// cscdcount コースコードカウント
        /// </returns>
        public List<dynamic> SelectBillClass_c(String[] billClassCd)
        {
            string sql = "";                                // SQLステートメント
            var param = new Dictionary<string, object>();   // キー値の設定

            // キーの設定
            for (int i = 0; i < billClassCd.Length; i++)
            {
                param.Add("billclasscd" + i, billClassCd[i]);
            }

            // 団体請求書分類テーブル検索
            sql = @"
                    select
                      cscd
                      , cscdcount
                    from
                      (
                        select
                          cscd
                          , count(cscd) cscdcount
                        from
                          billclass_c
                        where
                          billclasscd = :billclasscd0
                ";

            for (int i = 1; i < billClassCd.Length; i++)
            {
                sql += " or billclasscd :billclasscd" + i;
            }

            sql = @"
                    group by
                      cscd)
                    where
                      cscdcount > 1
                    order by
                      cscd
                ";

            return connection.Query(sql, param).ToList();
        }
    }
}
