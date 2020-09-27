using Dapper;
using Hainsi.Common.Constants;
using Hainsi.Common.Table;
using Hainsi.Entity.Model;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 計測器検査結果データアクセスオブジェクト
    /// </summary>
    public class ExternalDeviceResultDao : AbstractDao
    {

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ExternalDeviceResultDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 新規のトランサクションIDを取得する
        /// </summary>
        /// <returns>トランサクションID</returns>
        public dynamic SelectTransactionId()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        externaldevicetransactionid.nextval transid
                    from
                        dual
                    ";

            return connection.Query(sql);
        }

        /// <summary>
        /// 指定の計測器検査結果を取得する
        /// </summary>
        /// <param name="transId">トランザクションID</param>
        /// <returns>計測器検査結果</returns>
        public dynamic SelectExternalDeviceResult(int transId)
        {
            // キー及び更新値の設定
            var sqlParams = new Dictionary<string, object>()
            {
                { "transid", transId }
            };

            // SQLステートメント
            string sql = @"
                    select
                        results
                    from
                        externaldeviceresults
                    where
                        transid = :transid
                    ";

            return connection.Query(sql, sqlParams).FirstOrDefault();
        }

        /// <summary>
        /// 計測器検査結果テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="transId">トランザクションID</param>
        /// <param name="data">
        /// device          計測機器名
        /// rsvno           予約番号
        /// results         計測器検査結果
        /// </param>
        /// <returns>
        /// Insert.Normal   正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error    異常終了
        /// </returns>
        public Insert RegistExternalDeviceResult(string mode, string ipAddress, int transId, InsertExternalDeviceResultModel data)
        {
            string sql = "";        // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("transid", transId);
            param.Add("device", data.Device);
            param.Add("rsvno", data.Rsvno);
            param.Add("ipaddress", ipAddress);
            param.Add("results", data.Results);

            while (true)
            {
                //// 端末管理テーブルレコードの更新
                //if (mode.Equals("UPD"))
                //{
                //    sql = @"
                //            update ExternalDeviceResult
                //            set
                //              wkstnname = :wkstnname
                //              , grpcd = :grpcd
                //              , progresscd = :progresscd
                //              , isprintbutton = :isprintbutton
                //            where
                //              ipaddress = :ipaddress
                //    ";

                //    ret2 = connection.Execute(sql, param);

                //    if (ret2 > 0)
                //    {
                //        ret = Insert.Normal;
                //        break;
                //    }
                //}

                // 検索条件を満たす端末管理テーブルのレコードを取得
                sql = @"
                        select
                          transid
                        from
                          externaldeviceresults 
                        where
                          transid = :transid 
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
                        into externaldeviceresults( 
                          transid
                          , device
                          , rsvno
                          , ipaddress
                          , results
                        ) 
                        values ( 
                          :transid
                          , :device
                          , :rsvno
                          , :ipaddress
                          , :results
                        ) 
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }


    }
}
