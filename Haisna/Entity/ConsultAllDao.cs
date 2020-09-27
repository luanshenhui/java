using Dapper;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 受診情報一括処理用データアクセスオブジェクト
    /// </summary>
    public class ConsultAllDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ConsultAllDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 一括受診日変更
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="userId">ユーザID</param>
        /// <param name="ignoreFlg">予約枠無視フラグ</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約件数</returns>
        public int ChangeDate(string mode, string userId, int ignoreFlg, DateTime cslDate, int[] rsvNo, int?[] rsvGrpCd, out string message)
        {
            // 初期処理
            message = null;

            // バインド変数の設定
            var param = new OracleDynamicParameters();
            param.Add("mode", mode, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("userid", userId, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ignoreflg", ignoreFlg, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldate", cslDate, OracleDbType.Date, ParameterDirection.Input);

            // null許容型配列の型変換
            string[] rsvGrpCdArray = rsvGrpCd.Select((value) => value?.ToString()).ToArray();

            // バインド配列(引数)の設定
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("rsvgrpcd", rsvGrpCdArray, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);

            // バインド変数(戻り値)の設定
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output, size: 1000);

            // 受診情報登録用ストアドパッケージのSQLステートメント作成
            var sql = @"
                begin
                    :ret := consultallpackage.changedate(
                        :mode
                        , :userid
                        , :ignoreflg
                        , :csldate
                        , :rsvno
                        , :rsvgrpcd
                        , :message
                    );
                end;
            ";

            connection.Execute(sql, param);

            // 戻り値の取得
            int ret = param.Get<OracleDecimal>("ret").ToInt32();

            // 戻り値の設定
            if (ret < 0)
            {
                message = param.Get<OracleString>("message").ToString();
            }

            return ret;
        }

        /// <summary>
        /// 予約枠検索からの予約
        /// </summary>
        /// <param name="mode">検索モード</param>
        /// <param name="ignoreFlg">予約枠無視フラグ</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="manCnt">人数</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="romeName">ローマ字名</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="rsvGrpCd">予約群コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="rsvNo">継承すべき受診情報の予約番号</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="strRsvNo">開始予約番号</param>
        /// <param name="endRsvNo">終了予約番号</param>
        /// <param name="message">メッセージ</param>
        /// <returns>予約件数</returns>
        public int ReserveFromFrameReserve(
            string mode,
            string userId,
            int ignoreFlg,
            DateTime cslDate,
            string[] perId,
            int?[] manCnt,
            int?[] gender,
            DateTime?[] birth,
            int?[] age,
            string[] romeName,
            string[] orgCd1,
            string[] orgCd2,
            string[] csCd,
            string[] cslDivCd,
            int?[] rsvGrpCd,
            int[] ctrPtCd,
            int?[] rsvNo,
            string[] optCd,
            string[] optBranchNo,
            out int? strRsvNo,
            out int? endRsvNo,
            out string message
        )
        {
            // 初期処理
            strRsvNo = null;
            endRsvNo = null;
            message = null;

            // バインド変数の設定
            var param = new OracleDynamicParameters();
            param.Add("mode", mode, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("userid", userId, OracleDbType.Varchar2, ParameterDirection.Input);
            param.Add("ignoreflg", ignoreFlg, OracleDbType.Decimal, ParameterDirection.Input);
            param.Add("csldate", cslDate, OracleDbType.Date, ParameterDirection.Input);

            // バインド配列(引数)の設定
            param.Add("perid", perId, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("mancnt", manCnt, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("gender", gender, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("birth", birth, OracleDbType.Date, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("age", age, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("romename", romeName, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("orgcd1", orgCd1, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("orgcd2", orgCd2, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("csldivcd", cslDivCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("cscd", csCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("rsvgrpcd", rsvGrpCd, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("ctrptcd", ctrPtCd, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("rsvno", rsvNo, OracleDbType.Decimal, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optcd", optCd, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);
            param.Add("optbranchno", optBranchNo, OracleDbType.Varchar2, ParameterDirection.Input, collectionType: OracleCollectionType.PLSQLAssociativeArray);

            // バインド変数(戻り値)の設定
            param.Add("strrsvno", dbType: OracleDbType.Decimal, direction: ParameterDirection.Output);
            param.Add("endrsvno", dbType: OracleDbType.Decimal, direction: ParameterDirection.Output);
            param.Add("ret", dbType: OracleDbType.Decimal, direction: ParameterDirection.ReturnValue);
            param.Add("message", dbType: OracleDbType.Varchar2, direction: ParameterDirection.Output);

            // 受診情報登録用ストアドパッケージのSQLステートメント作成
            var sql = @"
                begin
                    :ret := consultallpackage.multireserve(
                        :mode
                        , :userid
                        , :ignoreflg
                        , :csldate
                        , :perid
                        , :mancnt
                        , :gender
                        , :birth
                        , :age
                        , :romename
                        , :orgcd1
                        , :orgcd2
                        , :csldivcd
                        , :cscd
                        , :rsvgrpcd
                        , :ctrptcd
                        , :rsvno
                        , :optcd
                        , :optbranchno
                        , :strrsvno
                        , :endrsvno
                        , :message
                    );
                end;
            ";

            connection.Execute(sql, param);

            // 戻り値の取得
            int ret = param.Get<OracleDecimal>("ret").ToInt32();

            // 戻り値の設定
            if (ret > 0)
            {
                strRsvNo = param.Get<OracleDecimal>("strrsvno").ToInt32();
                endRsvNo = param.Get<OracleDecimal>("endrsvno").ToInt32();
            }
            else
            {
                message = param.Get<OracleString>("message").ToString();
            }

            return ret;
        }
    }
}
