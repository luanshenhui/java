using Dapper;
using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 送信オーダ文書情報データアクセスオブジェクト
    /// </summary>
    public class OrderedDocDao : AbstractDao
    {
        /// <summary>
        /// 汎用分類コード（オーダ）
        /// </summary>
        string FREECLASSCD_ORD = "ORD";

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public OrderedDocDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 送信オーダ文書情報を取得する
        /// </summary>
        /// <param name="orderNo">オーダ番号</param>
        /// <param name="orderDate">オーダ日付</param>
        /// <returns>送信オーダ文書情報</returns>
        public List<dynamic> SelectByOrderNo(int orderNo, DateTime orderDate)
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>()
            {
                {"orderno", orderNo},
                {"orderdate", orderDate},
                {"freeclasscd", FREECLASSCD_ORD},
            };

            // SQLステートメント定義
            string sql = @"
                    select
                        ordereddoc.rsvno
                        , ordereddoc.orderdiv
                        , ordereddoc.orderdate
                        , ordereddoc.orderno
                        , ordereddoc.receno
                        , ordereddoc.senddiv
                        , ordereddoc.senddate
                        , ordereddoc.ipaddress
                        , ordereddoc.orderdoc
                        , free.freefield1 
                    from
                        ordereddoc
                        , free 
                    where
                        ordereddoc.orderdate = :orderdate 
                        and ordereddoc.orderno = :orderno 
                        and ordereddoc.orderdiv = free.freecd 
                        and free.freeclasscd = :freeclasscd 
                    order by
                        ordereddoc.rsvno asc
                        , ordereddoc.orderdiv asc
                        , ordereddoc.orderdate asc
                        , ordereddoc.orderno asc
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 送信オーダ文書情報の件数を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <returns>件数</returns>
        public int SelectOrderedDocCount(int rsvNo, string orderDiv)
        {
            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvNo},
                {"orderdiv", orderDiv},
                {"senddiv", 1},
            };

            // SQL定義
            string sql = @"
                    select
                        count(*) as cnt 
                    from
                        ordereddoc 
                    where
                        rsvno = :rsvno 
                        and orderdiv = :orderdiv 
                        and senddiv = :senddiv 
                ";

            // SQL実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? 0 : (int)result.CNT;
        }
    }
}
