using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// ログ情報データアクセスオブジェクト
    /// </summary>
    public class HainsLogDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public HainsLogDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// Hainsログデータを取得する
        /// </summary>
        /// <param name="mode">処理モード(CNT:件数カウント,SRC:検索)</param>
        /// <param name="startPos">SELECT開始位置</param>
        /// <param name="limit">取得件数</param>
        /// <param name="in_TransactionDiv">表示処理区分</param>
        /// <param name="in_InformationDiv">表示情報区分</param>
        /// <param name="in_TransactionID">処理ID</param>
        /// <param name="in_Message">検索文字列</param>
        /// <param name="orderByOld">1:古いものから順に表示</param>
        /// <param name="in_InsDate">処理日時</param>
        /// <returns>
        /// transactionID       処理ID
        /// insDate             処理日時
        /// transactionDiv      処理区分
        /// transactionDiv      処理名称
        /// informationDiv      情報区分
        /// statementNo         処理行
        /// lineNo              対象処理行
        /// message1            メッセージ１
        /// message2            メッセージ２
        /// </returns>
        public List<dynamic> SelectHainsLog(string mode, int? startPos = null, int? limit = null, string in_TransactionDiv = null, string in_InformationDiv = null, string in_TransactionID = null, string in_Message = null, string orderByOld = null, DateTime? in_InsDate = null)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 取得件数と開始位置が設定されている場合
            if (startPos != null && limit != null)
            {
                param.Add("seq_f", startPos);
                param.Add("seq_t", startPos + limit - 1);
            }

            // 表示順序制御用文字列
            string orderby = "desc";
            if (orderByOld != null)
            {
                if (orderByOld.Equals("1"))
                {
                    orderby = "asc";
                }
            }

            string whereOrAnd = " where";

            // 検索条件を満たすHainsログテーブルのレコードを取得
            // SQL文BUILD

            if (mode.Equals("CNT"))
            {
                sql = @"
                        select
                          count(lastview.transactionid) recordcount
                     ";
            }
            else
            {
                sql += @"
                         select
                           lastview.transactionid
                           , lastview.insdate
                           , lastview.transactiondiv
                           , lastview.transactionname
                           , lastview.informationdiv
                           , lastview.statementno
                           , lastview.lineno
                           , lastview.message1
                           , lastview.message2
                     ";
            }

            sql += @"
                    from
                      (
                        select
                          seqview.transactionid
                          , seqview.insdate
                          , seqview.transactiondiv
                          , seqview.transactionname
                          , seqview.informationdiv
                          , seqview.statementno
                          , seqview.lineno
                          , seqview.message1
                          , seqview.message2
                          , seqview.rowseq
                        from
                          (
                            select
                              basicview.transactionid
                              , basicview.insdate
                              , basicview.transactiondiv
                              , basicview.transactionname
                              , basicview.informationdiv
                              , basicview.statementno
                              , basicview.lineno
                              , basicview.message1
                              , basicview.message2
                              , rownum rowseq
                            from
                              (
                   ";

            // 処理トランザクション指定の場合
            sql += @"
                    select
                      hainslog.transactionid
                      , hainslog.insdate
                      , hainslog.transactiondiv
                      , free.freename transactionname
                      , hainslog.informationdiv
                      , hainslog.statementno
                      , hainslog.lineno
                      , hainslog.message1
                      , hainslog.message2
                  ";

            // ORDERVIEW（最新順）の組み立て
            sql += @"
                    from
                      free
                      , hainslog
                      , (
                        select
                          transactionid
                          , rownum orderno
                        from
                          (
                            select
                              transactionid
                              , max(insdate) maxinsdate
                            from
                              hainslog
                  ";

            // 処理トランザクション指定の場合
            if (in_TransactionDiv != null)
            {
                if (!in_TransactionDiv.Equals(""))
                {
                    param.Add("transactiondiv", in_TransactionDiv);
                    sql += whereOrAnd + " hainslog.transactiondiv = :transactiondiv ";
                    whereOrAnd = " and ";
                }
            }

            // 処理日付指定の場合
            if (in_InsDate != null)
            {
                param.Add("insdate", in_InsDate);
                sql += whereOrAnd + " to_date(hainslog.insdate) = :insdate ";
                whereOrAnd = " and ";
            }

            // 実行状態指定の場合
            if (in_InformationDiv != null)
            {
                if (!in_InformationDiv.Equals(""))
                {
                    param.Add("informationdiv", in_InformationDiv);
                    sql += whereOrAnd + " hainslog.informationdiv = :informationdiv ";
                    whereOrAnd = " and ";
                }
            }

            // 処理ID指定の場合
            if (in_TransactionID != null)
            {
                if (!in_TransactionID.Equals("") && Util.IsNumber(in_TransactionID))
                {
                    param.Add("transactionid", in_TransactionID);
                    sql += whereOrAnd + " hainslog.transactionid = :transactionid ";
                    whereOrAnd = " and ";
                }
            }

            sql += " group by transactionid order by maxinsdate " + orderby + " ) baseorder) orderview ";
            sql += @"
                    where
                      hainslog.transactiondiv = free.freecd(+)
                      and hainslog.transactionid = orderview.transactionid
                  ";

            // 処理トランザクション指定の場合
            if (in_TransactionDiv != null)
            {
                if (!in_TransactionDiv.Equals(""))
                {
                    sql += " and hainslog.transactiondiv = :transactiondiv ";
                }
            }

            // 処理日付指定の場合
            if (in_InsDate != null)
            {
                sql += " and to_date(hainslog.insdate) = :insdate ";
            }

            // 実行状態指定の場合
            if (in_InformationDiv != null)
            {
                if (!in_InformationDiv.Equals(""))
                {
                    sql += " and hainslog.informationdiv = :informationdiv ";
                }
            }

            // 処理ID指定の場合
            if (in_TransactionID != null)
            {
                if (!in_TransactionID.Equals("") && Util.IsNumber(in_TransactionID))
                {
                    sql += " and hainslog.transactionid = :transactionid ";
                }
            }

            // メッセージ指定の場合
            if (in_Message != null)
            {
                if (!in_Message.Equals(""))
                {
                    sql += " and (( hainslog.message1 like '%" + in_Message + "%') or ";
                    sql += " ( hainslog.message2 like '%" + in_Message + "%'))";
                }
            }

            // ORDER BY 指定
            sql += " order by orderview.orderno asc, hainslog.statementno asc ) basicview ) seqview ";

            // 取得件数と開始位置が設定されている場合
            if (!mode.Equals("CNT"))
            {
                if (startPos != null && limit != null)
                {
                    sql += " where seqview.rowseq between :seq_f and :seq_t ";
                }
            }

            sql += " ) lastview ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 引数値の配列変換
        /// </summary>
        /// <param name="value">非変換値</param>
        /// <returns>変換後の値</returns>
        private string[] ConvArray(string[] value)
        {
            string[] convValue;  // 変換後の値

            while (true)
            {
                // 未設定時は要素数１の空の配列を作成する
                if (value != null)
                {
                    convValue = new string[] { };
                    break;
                }

                // 配列形式でない場合は要素数１で要素値が引数値に等しい配列を作成する
                if (!(value is Array))
                {
                    convValue = new string[] { value.ToString() };
                    break;
                }

                // さもなくば変換は不要
                convValue = value;
                break;
            }

            // 戻り値の設定
            return convValue;
        }

        /// <summary>
        /// トランザクションＩＤをインクリメントする
        /// </summary>
        /// <returns>
        /// 正の値    トランザクションＩＤ
        /// 上記以外  異常終了
        /// </returns>
        public int IncreaseTransactionId()
        {
            int transactionId = 0;

            // Oracle Sequenceをインクリメントし、DUAL表を用いて次のトランザクションＩＤを取得する
            string sql = "select hainslog_seq.nextval transactionid from dual";

            dynamic current = connection.Query(sql).FirstOrDefault();

            while (true)
            {
                // レコードが存在しない場合は処理終了
                if (current == null)
                {
                    break;
                }

                // トランザクションＩＤがNULL値の場合は処理終了
                if (current.TRANSACTIONID == null)
                {
                    break;
                }

                // トランザクションＩＤの取得
                transactionId = Convert.ToInt32(current.TRANSACTIONID);

                break;
            }

            // 戻り値の設定
            return transactionId;
        }


        /// <summary>
        /// ログテーブルレコードを挿入する
        /// </summary>
        /// <param name="transactionId">トランザクションID</param>
        /// <param name="transactionDiv">処理区分</param>
        /// <param name="informationDiv">対象処理行</param>
        /// <param name="lineNo"></param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        /// Insert.Normal     正常終了
        /// Insert.Error      異常終了
        public Insert PutHainsLog(int transactionId, string transactionDiv, string informationDiv = "", string lineNo = "", List<string> message1 = null, List<string> message2 = null)
        {
            try
            {
                using (var transaction = BeginTransaction())
                {
                    // ログレコード挿入用のSQLステートメント作成
                    string sql = @"
                                   insert
                                   into hainslog(
                                     transactionid
                                     , insdate
                                     , transactiondiv
                                     , informationdiv
                                     , statementno
                                     , lineno
                                     , message1
                                     , message2
                                   )
                                   values (
                                     :transactionid
                                     , sysdate
                                     , :transactiondiv
                                     , :informationdiv
                                     , hainslog_statementno_seq.nextval
                                     , :lineno
                                     , :message1
                                     , :message2
                                   )
                               ";

                    var sqlParamList = new List<dynamic>();
                    for (int i = 0; i <= message1.Count(); i++)
                    {
                        // キー及び更新値の設定
                        var param = new Dictionary<string, object>();
                        param.Add("transactionid", transactionId);
                        param.Add("transactiondiv", transactionDiv);
                        param.Add("informationdiv", informationDiv);
                        param.Add("lineno", lineNo);
                        param.Add("message1", message1[i]);
                        param.Add("message2", message2[i]);
                        sqlParamList.Add(param);
                    }

                    connection.Execute(sql, sqlParamList);

                    // トランザクションをコミット
                    transaction.Commit();

                    return Insert.Normal;
                }
            }
            catch
            {
                return Insert.Error;
            }
        }
    }
}