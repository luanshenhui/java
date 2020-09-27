using Dapper;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// オーダ送信ジャーナル用データアクセスオブジェクト
    /// </summary>
    public class OrderJnlDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public OrderJnlDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// オーダ送信ジャーナルレコードを挿入する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="odrDiv">オーダ区分</param>
        /// <param name="tskDiv">処理区分</param>
        /// <param name="sendDiv">送信区分</param>
        /// <returns>
        /// 1: 正常終了
        /// 0: 同一処理日時・予約番号・オーダ区分のジャーナル情報が存在
        /// </returns>
        public int InsertOrderJnl(int rsvNo, int odrDiv, int tskDiv, int sendDiv)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("odrdiv", odrDiv);
            param.Add("tskdiv", tskDiv);
            param.Add("senddiv", sendDiv);

            // オーダ送信ジャーナルレコード挿入用のSQLステートメント作成
            var sql = @"
                insert
                into order_jnl(
                    tskdate
                    , rsvno
                    , odrdiv
                    , tskdiv
                    , senddiv
                )
                values (
                    sysdate
                    , :rsvno
                    , :odrdiv
                    , :tskdiv
                    , :senddiv
                )
            ";

            try
            {
                connection.Execute(sql, param);
            }
            catch (OracleException ex)
            {
                // キー重複時
                if (ex.Number == 1)
                {
                    return 0;
                }

                throw ex;
            }

            // 戻り値の設定
            return 1;
        }

        /// <summary>
        /// 受診歴送信ジャーナルレコードを挿入する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="sendDiv">送信区分</param>
        /// <param name="tskDiv">処理区分</param>
        /// <param name="comeDate">来院日時</param>
        /// <returns>
        /// 1: 正常終了
        /// 0: 同一処理日時・予約番号のジャーナル情報が存在
        /// </returns>
        public int InsertConsultJnl(int rsvNo, int sendDiv, int tskDiv, DateTime comeDate)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("senddiv", sendDiv);
            param.Add("tskdiv", tskDiv);
            param.Add("comedate", comeDate);

            // 受診歴送信ジャーナルレコード挿入用のSQLステートメント作成
            var sql = @"
                insert
                into consult_jnl(
                    tskdate
                    , rsvno
                    , senddiv
                    , tskdiv
                    , comedate
                )
                values (
                    sysdate
                    , :rsvno
                    , :senddiv
                    , :tskdiv
                    , :comedate
                )
            ";

            try
            {
                connection.Execute(sql, param);
            }
            catch (OracleException ex)
            {
                // キー重複時
                if (ex.Number == 1)
                {
                    return 0;
                }

                throw ex;
            }

            // 戻り値の設定
            return 1;
        }

        /// <summary>
        /// 来院制御を行う
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="tskDiv">処理区分(1:来院、2:来院解除)</param>
        /// <param name="comeDate">来院日時</param>
        /// <param name="message">(誘導から得られる)メッセージ</param>
        /// <param name="force">来院強制取消フラグ(フラグ成立時は誘導をキャンセルしない)</param>
        /// <returns>
        /// 1: 正常終了
        /// 0: 異常終了
        /// -1: 誘導キャンセルエラー
        /// </returns>
        public int VisitControl(int rsvNo, int tskDiv, DateTime comeDate, out string message, string force = null)
        {
            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("tskdiv", tskDiv, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("comedate", comeDate, OracleDbType.Date, ParameterDirection.Input);
            param.Add("cancelforce", force, OracleDbType.Varchar2, ParameterDirection.Input);

            // 戻り値のバインド変数定義
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output);

            // ストアドパッケージの関数呼び出し
            var sql = @"
                begin
                    :ret := orderpackage.visitcontrol(
                        :rsvno
                        , :tskdiv
                        , :comedate
                        , :message
                        , :cancelforce
                    );
                end;
            ";

            // PL/SQL文の実行
            connection.Execute(sql, param);

            // 戻り値の取得
            message = param.Get<OracleString>("message").ToString();

            // TODO トランザクション制御
            //If Ret > 0 Then
            //    mobjContext.SetComplete
            //Else
            //    mobjContext.SetAbort
            //End If

            // 戻り値の設定
            return param.Get<OracleDecimal>("ret").ToInt32();
        }
    }
}
