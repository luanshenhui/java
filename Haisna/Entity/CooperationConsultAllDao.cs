using Entity.Helper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;

#pragma warning disable CS1573
#pragma warning disable CS1591

namespace Hainsi.Entity
{
    public class CooperationConsultAllDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public CooperationConsultAllDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定団体・事業部・室部・所属・契約パターン条件を満たす受診情報の一括削除を行う
        /// </summary>
        ///
        /// <param name="data">受診情報
        /// strcsldate         開始受診日
        /// endcsldate         終了受診日
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// orgbsdcd           事業部コード
        /// orgroomcd          室部コード
        /// strorgpostcd       開始所属コード
        /// endorgpostcd       終了所属コード
        /// ctrptcd            契約パターンコード
        /// notfixedonly       受診日未確定分削除指定(1:受診日未確定分のみを削除)
        /// cancelforce        強制削除可否(1:問診が入力されている受診情報は削除しない)
        /// notexistsoptonly   "1":オプション検査が１つも存在しない受診情報のみ削除
        /// </param>
        /// <returns>挿入レコード数</returns>
        public int DeleteConsultAll(JToken data)
        {
            // #ToDo 本メソッド自体未使用である可能性があります。

            string sql = "";  // SQLステートメント

            // 受診情報登録用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.deleteconsultall(
                      :strcsldate
                      , :endcsldate
                      , :orgcd1
                      , :orgcd2
                      , :orgbsdcd
                      , :orgroomcd
                      , :strorgpostcd
                      , :endorgpostcd
                      , :ctrptcd
                      , :notfixedonly
                      , :cancelforce
                      , :notexistsoptonly
                    );
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // キー及び更新値の設定
                // Inputは名前と値のみ
                cmd.Parameters.Add("strcsldate", Convert.ToDateTime(data["strcsldate"]));
                cmd.Parameters.Add("endcsldate", Convert.ToDateTime(data["endcsldate"]));
                cmd.Parameters.Add("orgcd1", Convert.ToString(data["orgcd1"]));
                cmd.Parameters.Add("orgcd2", Convert.ToString(data["orgcd2"]));
                cmd.Parameters.Add("orgbsdcd", Convert.ToString(data["orgbsdcd"]));
                cmd.Parameters.Add("orgroomcd", Convert.ToString(data["orgroomcd"]));
                cmd.Parameters.Add("strorgpostcd", Convert.ToString(data["strorgpostcd"]));
                cmd.Parameters.Add("endorgpostcd", Convert.ToString(data["endorgpostcd"]));
                cmd.Parameters.Add("ctrptcd", Convert.ToInt32(data["ctrptcd"]));
                cmd.Parameters.Add("notfixedonly", Convert.ToInt32(data["notfixedonly"]));
                if (Convert.ToInt32(data["cancelforce"]) != 0)
                {
                    cmd.Parameters.Add("cancelforce", 0);
                }
                else
                {
                    cmd.Parameters.Add("cancelforce", 1);
                }

                cmd.Parameters.Add("notexistsoptonly", Convert.ToInt32(data["notexistsoptonly"]));

                // 戻り値のバインド変数定義
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// 指定個人の受診情報を作成する
        /// </summary>
        /// <param name="data">指定個人の受診情報
        /// upduser            更新者
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// perid              個人ＩＤ
        /// ctrptcd            契約パターンコード
        /// csldate            受診希望日
        /// message1           メッセージ１
        /// message2           メッセージ２
        /// transid            トランザクションＩＤ
        /// transdiv           トランザクション区分
        /// </param>
        /// <returns>
        ///  >0   予約番号
        ///  -1   同一受診日、受診者、コースの受診情報がすでに存在
        ///　-2   契約情報が存在しない
        ///  -3   オプション検査情報が存在しない
        ///  -4   登録しようとしたオプションが削除オプションだった
        ///  -5   枠溢れ
        ///  -6   すでに受付済みである
        ///  -7   すでに使用されている当日IDで発番しようとした
        ///  -8   規定外の当日IDが指定された
        ///  -9   発番可能な最大番号数を超えた
        ///  -10  個人情報が存在しない
        ///  -11  指定個人の団体情報が存在しない
        ///  -12  指定された契約パターンの受診情報がすでに存在
        ///  </returns>
        public int InsertConsultFromPerId(JToken data, ref string message1, ref string message2)
        {
            string sql = "";  // SQLステートメント

            // 受診情報登録用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.insertconsultfromperid(
                      :upduser
                      , :orgcd1
                      , :orgcd2
                      , :perid
                      , :ctrptcd
                      , :csldate
                      , :message1
                      , :message2
                      , :transid
                      , :transdiv
                    );
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // キー及び更新値の設定
                // Inputは名前と値のみ
                cmd.Parameters.Add("upduser", Convert.ToString(data["upduser"]));
                cmd.Parameters.Add("orgcd1", Convert.ToString(data["orgcd1"]));
                cmd.Parameters.Add("orgcd2", Convert.ToString(data["orgcd2"]));
                cmd.Parameters.Add("perid", Convert.ToString(data["perid"]));
                cmd.Parameters.Add("ctrptcd", Convert.ToInt32(data["ctrptcd"]));

                if (data["csldate"] != null)
                {
                    cmd.Parameters.Add("csldate", Convert.ToDateTime(data["csldate"]));
                }
                else
                {
                    cmd.Parameters.Add("csldate", null);
                }

                cmd.Parameters.Add("transid", Convert.ToInt32(data["transid"]));
                cmd.Parameters.Add("transdiv", Convert.ToString(data["transdiv"]));

                //戻り値のバインド変数定義
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);
                OracleParameter message1Para = cmd.Parameters.Add("message1", OracleDbType.Varchar2, ParameterDirection.Output);
                OracleParameter message2Para = cmd.Parameters.Add("message2", OracleDbType.Varchar2, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の取得
                message1 = ((OracleDecimal)message1Para.Value).ToString();
                message2 = ((OracleDecimal)message2Para.Value).ToString();

                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// 指定団体・事業部・室部・所属条件を満たす個人の一括予約を行う
        /// </summary>
        /// <param name="data">
        /// upduser            更新者
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// orgbsdcd           事業部コード
        /// orgroomcd          室部コード
        /// strorgpostcd       開始所属コード
        /// endorgpostcd       終了所属コード
        /// ctrptcd            契約パターンコード
        /// csldate            受診日
        /// opmode             (同一契約パターン未受付受診情報存在時の)処理モード(0:何もしない、1:キャンセル、2:削除)
        /// </param>
        /// <returns>挿入レコード数</returns>
        public int InsertConsultFromPerson(JToken data)
        {
            //// #ToDo 本メソッド自体未使用である可能性があります。

            string sql = "";  // SQLステートメント

            // 受診情報登録用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.insertconsultfromperson(
                        :upduser
                        , :orgcd1
                        , :orgcd2
                        , :orgbsdcd
                        , :orgroomcd
                        , :strorgpostcd
                        , :endorgpostcd
                        , :ctrptcd
                        , :opmode
                        , :csldate
                    );
                    end;
                ";

            // キー及び更新値の設定
            using (var cmd = new OracleCommand())
            {
                // Inputは名前と値のみ
                cmd.Parameters.Add("upduser", Convert.ToString(data["upduser"]));
                cmd.Parameters.Add("orgcd1", Convert.ToString(data["orgcd1"]));
                cmd.Parameters.Add("orgcd2", Convert.ToString(data["orgcd2"]));
                cmd.Parameters.Add("orgbsdcd", Convert.ToString(data["orgbsdcd"]));
                cmd.Parameters.Add("orgroomcd", Convert.ToString(data["orgroomcd"]));
                cmd.Parameters.Add("strorgpostcd", Convert.ToString(data["strorgpostcd"]));
                cmd.Parameters.Add("endorgpostcd", Convert.ToString(data["endorgpostcd"]));
                cmd.Parameters.Add("ctrptcd", Convert.ToInt32(data["ctrptcd"]));
                cmd.Parameters.Add("csldate", Convert.ToDateTime(data["csldate"]));
                cmd.Parameters.Add("opmode", Convert.ToInt32(data["opmode"]));

                // 戻り値のバインド変数定義
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// 指定受診日範囲、コース、団体・事業部・室部・所属条件を満たす個人の一括予約を行う
        /// </summary>
        /// <param name="data">
        /// upduser            更新者
        /// strcsldate         開始受診日
        /// endcsldate         終了受診日
        /// cscd               コースコード
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// orgbsdcd           事業部コード
        /// orgroomcd          室部コード
        /// strorgpostcd       開始所属コード
        /// endorgpostcd       終了所属コード
        /// ctrptcd            契約パターンコード
        /// secstrcsldate      割り当て開始日
        /// secendcsldate      割り当て終了日
        /// </param>
        /// <returns>挿入レコード数</returns>
        public int InsertConsultFromResult(JToken data)
        {
            // #ToDo 本メソッド自体未使用である可能性があります。

            string sql = "";  // SQLステートメント

            // 受診情報登録用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.insertconsultfromresult(
                      :upduser
                      , :strcsldate
                      , :endcsldate
                      , :cscd
                      , :orgcd1
                      , :orgcd2
                      , :orgbsdcd
                      , :orgroomcd
                      , :strorgpostcd
                      , :endorgpostcd
                      , :ctrptcd
                      , :secstrcsldate
                      , :secendcsldate
                    );
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // キー及び更新値の設定
                // Inputは名前と値のみ
                cmd.Parameters.Add("upduser", Convert.ToString(data["upduser"]));
                cmd.Parameters.Add("strcsldate", Convert.ToDateTime(data["strcsldate"]));
                cmd.Parameters.Add("endcsldate", Convert.ToDateTime(data["endcsldate"]));
                cmd.Parameters.Add("orgcd1", Convert.ToString(data["orgcd1"]));
                cmd.Parameters.Add("orgcd2", Convert.ToString(data["orgcd2"]));
                cmd.Parameters.Add("orgbsdcd", Convert.ToString(data["orgbsdcd"]));
                cmd.Parameters.Add("orgroomcd", Convert.ToString(data["orgroomcd"]));
                cmd.Parameters.Add("strorgpostcd", Convert.ToString(data["strorgpostcd"]));
                cmd.Parameters.Add("endorgpostcd", Convert.ToString(data["endorgpostcd"]));
                cmd.Parameters.Add("ctrptcd", Convert.ToInt32(data["ctrptcd"]));
                cmd.Parameters.Add("secstrcsldate", Convert.ToDateTime(data["secstrcsldate"]));
                cmd.Parameters.Add("secendcsldate", Convert.ToDateTime(data["secendcsldate"]));

                // コースコードの編集
                List<string> cscdList = data["cscd"].ToObject<List<JToken>>().Value<List<string>>();

                cmd.Parameters.AddTable("cscd", cscdList.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, cscdList.Count, (int)LengthConstants.LENGTH_COURSE_CSCD);

                // 戻り値のバインド変数定義
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// 指定条件を満たす受診情報のオプション検査を年齢・性別等にて決定する標準オプションに更新する
        /// </summary>
        /// <param name="data">
        /// strcsldate         開始受診日
        /// endcsldate         終了受診日
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// ctrptcd            契約パターンコード
        /// recreateprice      "1"ならば受診金額を再作成
        /// </param>
        /// <returns>更新受診情報数</returns>
        public int UpdateOption(JToken data)
        {
            // #ToDo 本メソッド自体未使用である可能性があります。

            string sql = ""; // SQLステートメント

            // 受診情報登録用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.updateoption(
                      :strcsldate
                      , :endcsldate
                      , :orgcd1
                      , :orgcd2
                      , :ctrptcd
                      , :recreateprice
                    );
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // キー及び更新値の設定
                // Inputは名前と値のみ
                cmd.Parameters.Add("strcsldate", Convert.ToDateTime(data["strcsldate"]));
                cmd.Parameters.Add("endcsldate", Convert.ToDateTime(data["endcsldate"]));
                cmd.Parameters.Add("orgcd1", Convert.ToString(data["orgcd1"]));
                cmd.Parameters.Add("orgcd2", Convert.ToString(data["orgcd2"]));
                cmd.Parameters.Add("ctrptcd", Convert.ToInt32(data["ctrptcd"]));

                if (!string.IsNullOrEmpty(Convert.ToString(data["ctrptcd"])))
                {
                    cmd.Parameters.Add("recreateprice", 1);
                }
                else
                {
                    cmd.Parameters.Add("recreateprice", 0);
                }

                // 戻り値のバインド変数定義
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }
    }
}