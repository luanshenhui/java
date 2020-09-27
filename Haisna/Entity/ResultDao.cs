using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Result;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 検査結果情報データアクセスオブジェクト
    /// </summary>
    public class ResultDao : AbstractDao
    {
        private const int LENGTH_RESULTERR = 3;     //検査結果エラー
        private const int LENGTH_RSLCMTERR = 3;     //結果コメントエラー
        private const int LENGTH_RET = 3;           //結果項目エラー
        private const long LENGTH_INSRESULT = 14;   //検査システムでの検査結果
        private const long LENGTH_INSRSLCMTCD = 3;  //検査システムでの結果コメント

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ResultDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 検査結果入力チェック
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="results">ステータス付き検査結果モデルのリスト</param>
        /// <returns>エラーメッセージ</returns>
        public IList<string> CheckResult(DateTime cslDate, ref IList<ResultWithStatus> results)
        {
            if ((results == null) || (results.Count == 0))
            {
                return null;
            }

            using (var cmd = new OracleCommand())
            {
                // キー値及び更新値の設定
                cmd.Parameters.Add("csldate", OracleDbType.Date, cslDate, ParameterDirection.Input);

                int arraySize = results.Count;
                OracleParameter objItemCd = cmd.Parameters.AddTable("itemcd", results.Select(r => r.ItemCd).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                OracleParameter objSuffix = cmd.Parameters.AddTable("suffix", results.Select(r => r.Suffix).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                OracleParameter objResult = cmd.Parameters.AddTable("result", results.Select(r => r.Result).ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 400);
                OracleParameter objShortStc = cmd.Parameters.AddTable("shortstc", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_SENTENCE_SHORTSTC);
                OracleParameter objResultError = cmd.Parameters.AddTable("resulterror", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 3);
                OracleParameter objRslCmtCd1 = cmd.Parameters.AddTable("rslcmtcd1", results.Select(r => r.RslCmtCd1).ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                OracleParameter objRslCmtName1 = cmd.Parameters.AddTable("rslcmtname1", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTNAME);
                OracleParameter objRslCmtError1 = cmd.Parameters.AddTable("rslcmterror1", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 3);
                OracleParameter objRslCmtCd2 = cmd.Parameters.AddTable("rslcmtcd2", results.Select(r => r.RslCmtCd2).ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                OracleParameter objRslCmtName2 = cmd.Parameters.AddTable("rslcmtname2", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTNAME);
                OracleParameter objRslCmtError2 = cmd.Parameters.AddTable("rslcmterror2", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 3);
                OracleParameter objMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);

                OracleParameter objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // SQL定義
                string sql = @"
                    begin
                        :ret := resultpackage.checkresult(
                            :csldate
                            , :itemcd
                            , :suffix
                            , :result
                            , :shortstc
                            , :resulterror
                            , :rslcmtcd1
                            , :rslcmtname1
                            , :rslcmterror1
                            , :rslcmtcd2
                            , :rslcmtname2
                            , :rslcmterror2
                            , :message
                        );
                    end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                var ret = (OracleDecimal)objRet.Value;

                // 戻り値の設定(エラーに関わらず戻す値)
                var result = (OracleString[])objResult.Value;
                var shortStc = (OracleString[])objShortStc.Value;
                var resultError = (OracleString[])objResultError.Value;
                var rslCmtCd1 = (OracleString[])objRslCmtCd1.Value;
                var rslCmtName1 = (OracleString[])objRslCmtName1.Value;
                var rslCmtError1 = (OracleString[])objRslCmtError1.Value;
                var rslCmtCd2 = (OracleString[])objRslCmtCd2.Value;
                var rslCmtName2 = (OracleString[])objRslCmtName2.Value;
                var rslCmtError2 = (OracleString[])objRslCmtError2.Value;

                for (int index = 0; index < results.Count; index++)
                {
                    results[index].Result = (result[index] != null) ? Convert.ToString(result[index]) : null;
                    results[index].ShortStc = (shortStc[index] != null) ? Convert.ToString(shortStc[index]) : null;
                    results[index].ResultError = (resultError[index] != null) ? Convert.ToString(resultError[index]) : null;
                    results[index].RslCmtCd1 = (rslCmtCd1[index] != null) ? Convert.ToString(rslCmtCd1[index]) : null;
                    results[index].RslCmtName1 = (rslCmtName1[index] != null) ? Convert.ToString(rslCmtName1[index]) : null;
                    results[index].RslCmtError1 = (rslCmtError1[index] != null) ? Convert.ToString(rslCmtError1[index]) : null;
                    results[index].RslCmtCd2 = (rslCmtCd2[index] != null) ? Convert.ToString(rslCmtCd2[index]) : null;
                    results[index].RslCmtName2 = (rslCmtName2[index] != null) ? Convert.ToString(rslCmtName2[index]) : null;
                    results[index].RslCmtError2 = (rslCmtError2[index] != null) ? Convert.ToString(rslCmtError2[index]) : null;
                }

                if (ret.Value != 0)
                {
                    return null;
                }

                // チェックエラー時
                return ((OracleString[])objMessage.Value).Select(s => s.Value).ToList();
            }
        }

        /// <summary>
        /// 検査結果入力チェック
        /// </summary>
        /// <param name="year">受診日（年）</param>
        /// <param name="month">受診日（月）</param>
        /// <param name="day">受診日（日）</param>
        /// <param name="dayIdF">(ref)当日ＩＤ（自）</param>
        /// <param name="dayIdT">(ref)当日ＩＤ（至）</param>
        /// <param name="cslDate">(ref)受診日</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckRslAllSet1Value(String year, String month, String day, out DateTime? cslDate, ref String dayIdF, ref String dayIdT)
        {

            int ingdayIdF;      //編集用当日ＩＤ（自）
            int ingdayIdT;      //編集用当日ＩＤ（至）
            List<string> arrMessage = new List<string>(); //エラーメッセージの集合

            //受診日チェック
            string consultationDate = WebHains.CheckDate("受診日", year, month, day, out cslDate, Common.Constants.Check.Necessary);
            string idBegin = WebHains.CheckNumeric("当日ＩＤ（自）", dayIdF, Convert.ToInt16(LengthConstants.LENGTH_RECEIPT_DAYID));
            string idEnd = WebHains.CheckNumeric("当日ＩＤ（至）", dayIdT, Convert.ToInt16(LengthConstants.LENGTH_RECEIPT_DAYID));
            if (null!= consultationDate)
            {
                arrMessage.Add(consultationDate);

            }
            //当日ＩＤチェック
            if (null!= idBegin)
            {
                arrMessage.Add(idBegin);
            }
            if (null != idEnd)
            {
                arrMessage.Add(idEnd);
            }
            //当日ＩＤ範囲チェック
            if (arrMessage.Count == 0)
            {

                if (string.IsNullOrEmpty(dayIdF))
                {
                    ingdayIdF = 0;
                }
                else
                {
                    ingdayIdF = Convert.ToInt32(dayIdF);
                }
                if (string.IsNullOrEmpty(dayIdT))
                {
                    ingdayIdT = 9999;
                }
                else
                {
                    ingdayIdT = Convert.ToInt32(dayIdT);
                }

                //大小範囲チェック
                if (ingdayIdF > ingdayIdT)
                {
                    arrMessage.Add("当日ＩＤの範囲指定に誤りがあります");
                }
                if (dayIdF != "")
                {
                    dayIdF = String.Format("{0:D4}", ingdayIdF);
                }
                if (dayIdT != "")
                {
                    dayIdT = String.Format("{0:D4}", ingdayIdT);
                }
            }

            return arrMessage;

        }

        /// <summary>
        /// 検査結果入力チェック
        /// </summary>
        /// <param name="year">受診日（年）</param>
        /// <param name="month">受診日（月）</param>
        /// <param name="day">受診日（日）</param>
        /// <param name="dayIdF">表示開始当日ＩＤ</param>
        /// <param name="cslDate">(ref)受診日</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<String> CheckRslListSetConditionValue(String year, String month, String day, out DateTime? cslDate, String dayIdF)
        {

            List<String> arrMessage = new List<string>(); //エラーメッセージの集合

            //受診日チェック
            arrMessage.Add(WebHains.CheckDate("受診日", year, month, day, out cslDate, Common.Constants.Check.Necessary));
            //当日ＩＤチェック
            arrMessage.Add(WebHains.CheckNumeric("当日ＩＤ（自）", dayIdF, Convert.ToInt16(LengthConstants.LENGTH_RECEIPT_DAYID)));

            return arrMessage;

        }

        /// <summary>
        /// 検査システムから取得した検査結果のチェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="sepOrderDiv">オーダ分割区分</param>
        /// <param name="insItemCd">検査用検査項目コード</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="itemName">検査項目名</param>
        /// <param name="insResult">検査システムでの検査結果</param>
        /// <param name="result">検査結果</param>
        /// <param name="resultErr">検査結果のエラー状態</param>
        /// <param name="insRslCmtCd1">検査システムでの結果コメント1</param>
        /// <param name="rslCmtCd1">結果コメント1</param>
        /// <param name="rslCmtErr1">結果コメント1のエラー状態</param>
        /// <param name="insRslCmtCd2">検査システムでの結果コメント2</param>
        /// <param name="rslCmtCd2">結果コメント2</param>
        /// <param name="rslCmtErr2">結果コメント2のエラー状態</param>
        /// <param name="ret">検査項目のエラー状態</param>
        public void CheckRslValueOfInspection(
            long rsvNo,
            long sepOrderDiv,
            List<string> insItemCd,
            ref List<string> itemCd,
            ref List<string> suffix,
            ref List<string> itemName,
            List<string> insResult,
            ref List<string> result,
            ref List<string> resultErr,
            List<string> insRslCmtCd1,
            ref List<string> rslCmtCd1,
            ref List<string> rslCmtErr1,
            List<string> insRslCmtCd2,
            ref List<string> rslCmtCd2,
            ref List<string> rslCmtErr2,
            ref List<string> ret
            )
        {
            using (var cmd = new OracleCommand())
            {
                if (insItemCd.Count == 0)
                {
                    return;
                }

                // 配列数の設定
                int arraySize = insItemCd.Count;
                // キー値及び更新値の設定
                cmd.Parameters.Add("rsvno", OracleDbType.Int32, rsvNo, ParameterDirection.Input);
                cmd.Parameters.Add("rows", OracleDbType.Int32, arraySize, ParameterDirection.Input);
                cmd.Parameters.Add("seporderdiv", OracleDbType.Int32, sepOrderDiv, ParameterDirection.Input);

                OracleParameter objInsItemCd = cmd.Parameters.AddTable("insitemcd", insItemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_H_INSITEMCD);
                OracleParameter objItemCd = cmd.Parameters.AddTable("itemcd", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                OracleParameter objSuffix = cmd.Parameters.AddTable("suffix", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                OracleParameter objItemName = cmd.Parameters.AddTable("itemname", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 20);
                OracleParameter objInsResult = cmd.Parameters.AddTable("insresult", insResult.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LENGTH_INSRESULT);
                OracleParameter objResult = cmd.Parameters.AddTable("result", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 400);
                OracleParameter objResultErr = cmd.Parameters.AddTable("resulterr", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, LENGTH_RESULTERR);
                OracleParameter objInsRslCmtCd1 = cmd.Parameters.AddTable("insrslcmtcd1", insRslCmtCd1.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LENGTH_INSRSLCMTCD);
                OracleParameter objRslCmtCd1 = cmd.Parameters.AddTable("rslcmtcd1", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                OracleParameter objRslCmtErr1 = cmd.Parameters.AddTable("rslcmterr1", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, LENGTH_RSLCMTERR);
                OracleParameter objInsRslCmtCd2 = cmd.Parameters.AddTable("insrslcmtcd2", insRslCmtCd2.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LENGTH_INSRSLCMTCD);
                OracleParameter objRslCmtCd2 = cmd.Parameters.AddTable("rslcmtcd2", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                OracleParameter objRslCmtErr2 = cmd.Parameters.AddTable("rslcmterr2", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, LENGTH_RSLCMTERR);
                OracleParameter objRet = cmd.Parameters.AddTable("ret", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, LENGTH_RET);

                // SQL定義
                string sql = @"
                    begin
                        checkresultpackage.checkresult(
                          :rsvno
                        , :seporderdiv
                        , :insitemcd
                        , :itemcd
                        , :suffix
                        , :itemname
                        , :insresult
                        , :result
                        , :resulterr
                        , :insrslcmtcd1
                        , :rslcmtcd1
                        , :rslcmterr1
                        , :insrslcmtcd2
                        , :rslcmtcd2
                        , :rslcmterr2
                        , :ret
                        , :rows
                        );
                   end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定(エラーに関わらず戻す値)
                itemCd = ((OracleString[])objItemCd.Value).Select(s => s.Value).ToList();
                suffix = ((OracleString[])objSuffix.Value).Select(s => s.Value).ToList();
                itemName = ((OracleString[])objItemName.Value).Select(s => s.Value).ToList();
                resultErr = ((OracleString[])objResultErr.Value).Select(s => s.Value).ToList();
                rslCmtCd1 = ((OracleString[])objRslCmtCd1.Value).Select(s => s.Value).ToList();
                rslCmtErr1 = ((OracleString[])objRslCmtErr1.Value).Select(s => s.Value).ToList();
                rslCmtCd2 = ((OracleString[])objRslCmtCd2.Value).Select(s => s.Value).ToList();
                rslCmtErr2 = ((OracleString[])objRslCmtErr2.Value).Select(s => s.Value).ToList();
                ret = ((OracleString[])objRet.Value).Select(s => s.Value).ToList();
            }
        }

        /// <summary>
        /// 検査結果テーブルを更新する(レコードが存在しない場合は挿入)
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="data">
        /// itemCd  検査項目コード
        /// suffix  サフィックス
        /// result  検査結果
        /// </param>
        /// <returns>ログイン成功フラグ</returns>
        public Boolean MergeRsl(long rsvno, JToken data)
        {
            string sql; // SQLステートメント
            bool ret = false;
            using (var transaction = BeginTransaction())
            {
                //検査結果更新用のSQLステートメント作成
                sql = @"
                        merge
                        into rsl
                            using (
                                select
                                :rsvno rsvno
                              , :itemcd itemcd
                              , :suffix suffix
                              , :result result
                            from
                              dual
                          ) basedrsl
                            on (
                              rsl.rsvno = basedrsl.rsvno
                              and rsl.itemcd = basedrsl.itemcd
                              and rsl.suffix = basedrsl.suffix
                            ) when matched then update
                        set
                          rsl.result = basedrsl.result when not matched then
                        insert (rsl.rsvno, rsl.itemcd, rsl.suffix, rsl.result)
                        values (
                          basedrsl.rsvno
                          , basedrsl.itemcd
                          , basedrsl.suffix
                          , basedrsl.result
                        )
                  ";

                // セットデータのチェック
                List<JToken> items = data.ToObject<List<JToken>>();

                //各配列値の更新処理
                foreach (var rec in items)
                {

                    // 配列値の編集
                    var param = new Dictionary<string, object>();
                    param.Add("rsvno", rsvno);
                    param.Add("itemcd", Convert.ToString(rec["itemcd"]));
                    param.Add("suffix", Convert.ToString(rec["suffix"]));
                    param.Add("result", Convert.ToString(rec["result"]));

                    //更新SQL文の実行
                    connection.Execute(sql, param);
                }

                // トランザクションをコミット
                transaction.Commit();
            }
            ret = true;

            return ret;
        }

        /// <summary>
        /// 個人ＩＤの検査項目情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="cslDate">指定受診日（以前）</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public List<dynamic> SelectHistoryAllItemList(string perId, string cslDate)
        {
            // 個人ＩＤ・受診日が設定されていない場合はエラー
            if (String.IsNullOrEmpty(perId) || String.IsNullOrEmpty(cslDate))
            {
                // 「プロシージャの呼び出し、または引数が不正です。」
                throw new ArgumentException();
            }
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId);
            param.Add("csldate", cslDate);
            param.Add("cancelflg", ConsultCancel.Used);

            // 検索条件を満たす受診歴情報のレコードを取得
            sql = @"
                    select
                      r.itemcd
                      , r.suffix
                      , ic.itemname
                    from
                      consult c
                      , rsl r
                      , item_c ic
                    where
                      c.perid = :perid
                      and c.csldate <= :csldate
                      and c.cancelflg = :cancelflg
                      and c.rsvno = r.rsvno
                      and r.itemcd = ic.itemcd
                      and r.suffix = ic.suffix
                    group by
                      r.itemcd
                      , r.suffix
                      , ic.itemname
                  ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人ＩＤ・検査項目と合致する検査結果情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        /// <param name="color">色</param>
        /// <returns>検索条件を満たすレコード</returns>
        public List<dynamic> SelectHistoryItemResultList(object rsvno, object itemCd, object suffix, ref string[] result, ref string[] color)
        {
            //予約番号が配列の場合
            if (rsvno is Array)
            {
                //「プロシージャの呼び出し、または引数が不正です。」
                throw new ArgumentException();
            }

            //検査項目が配列の場合
            if (itemCd is Array)
            {
                if (!(suffix is Array))
                {
                    // 「インデックスが有効範囲にありません。」
                    throw new ArgumentOutOfRangeException();
                }
                string[] iCd1 = itemCd as string[];
                string[] suf1 = suffix as string[];
                //検査項目・サフィックスの配列サイズが一致しない場合は処理終了
                if (iCd1.Count() != suf1.Count())
                {
                    // 「インデックスが有効範囲にありません。」
                    throw new ArgumentOutOfRangeException();
                }
            }
            else
            {
                //サフィックスが配列の場合は処理終了
                if (suffix.GetType() == typeof(List<object>))
                {
                    // 「インデックスが有効範囲にありません。」
                    throw new ArgumentOutOfRangeException();
                }

            }

            string sql; // SQLステートメント

            //キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", Convert.ToString(rsvno).Trim());

            //検索条件を満たすグループテーブルのレコードを取得
            sql = @"
                    select
                      basedrsl.rsvno
                      , basedrsl.itemcd
                      , basedrsl.suffix
                      , basedrsl.result
                      , basedrsl.resulttype
                      , sentence.shortstc
                      , stdvalue_c.stdflg
                    from
                      stdvalue_c
                      , sentence
                      , (
                        select
                          rsl.rsvno
                          , rsl.itemcd
                          , rsl.suffix
                          , rsl.result
                          , rsl.stdvaluecd
                          , item_c.itemtype
                          , item_c.stcitemcd
                          , item_c.resulttype
                        from
                          rsl
                          , item_c
                        where
                          rsl.rsvno = :rsvno
                          and rsl.itemcd = item_c.itemcd
                          and rsl.suffix = item_c.suffix
                      ) basedrsl
                    where
                      basedrsl.stcitemcd = sentence.itemcd(+)
                      and basedrsl.itemtype = sentence.itemtype(+)
                      and basedrsl.result = sentence.stccd(+)
                      and basedrsl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                   ";

            // #ToDo Select後の.Net側での処理をどうするか
            //'配列上の位置を求める
            // For i = 0 To UBound(vntArrItemCd)
            //    If vntArrItemCd(i) = objItemCd.Value And vntArrSuffix(i) = objSuffix.Value Then
            //        If objResultType.Value = RESULTTYPE_SENTENCE And Not IsNull(objShortStc.Value) Then
            //            vntArrResult(i) = objShortStc.Value
            //        Else
            //            vntArrResult(i) = objResult.Value & ""
            //        End If
            //        objCommon.SelectStdFlgColor.objStdFlg.Value & "_COLOR", vntArrColor(i)
            //        lngCount = lngCount + 1
            //        Exit For
            //    End If
            //Next i

            // 配列数
            string[] iCd = itemCd as string[];
            string[] suf = suffix as string[];
            int arraySize = iCd.Count();

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            result = new string[arraySize];
            color = new string[arraySize];
            // 配列上の位置を求める
            for (int i = 0; i < arraySize; i++)
            {
                if (iCd[i].Equals(current.ITEMCD) && suf[i].Equals(current.SUFFIX))
                {
                    if (ResultType.Sentence.Equals(current.RESULTTYPE) && !string.IsNullOrEmpty(current.SHORTSTC))
                    {
                        result[i] = current.SHORTSTC;
                    }
                    else
                    {
                        result[i] = current.RESULT + "";
                    }
                    string coulor = color[i];

                    WebHains.SelectStdFlgColor(current.STDFLG + "_COLOR", ref coulor);
                    break;
                }

            }

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす検査項目の一覧を取得する
        /// </summary>
        /// <param name="mode">入力対象モード</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="code">入力対象コード</param>
        /// <param name="updItemCount">(ref)更新可能項目数</param>
        /// <returns>検索条件を満たすレコード</returns>
        public List<dynamic> SelectRslList(int mode, int rsvNo, string code, ref int updItemCount)
        {
            //全項目指定かコード指定かで振り分け
            if ("all".Equals(code))
            {
                return SelectRslAllList(rsvNo, ref updItemCount);
            }
            //前回予約番号取得
            else
            {
                return SelectRslGrpList(mode, rsvNo, code, ref updItemCount);
            }
        }

        /// <summary>
        /// 指定対象受診者・検査グループの検査項目を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updItemCount">(ref)更新可能項目数</param>
        /// <returns>検索条件を満たすレコード</returns>
        private List<dynamic> SelectRslAllList(long rsvNo, ref int updItemCount)
        {

            //前回値表示条件取得
            long courseFlg = WebHains.SelectRslCourseFlg();
            long secondFlg = WebHains.SelectRslSecondFlg();
            //キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            string sql; // SQLステートメント

            //指定予約番号の全検査結果情報を取得
            sql = @"
                    select
                    1 as consultflg
                    , finalrsl.itemcd
                    , finalrsl.suffix
                    , finalrsl.itemname
                    , finalrsl.result
                    , currentsentence.shortstc
                    , finalrsl.rslcmtcd1
                    , rslcmt1.rslcmtname rslcmtname1
                    , finalrsl.rslcmtcd2
                    , rslcmt2.rslcmtname rslcmtname2
                    , finalrsl.befresult
                    , lastsentence.shortstc befshortstc
                    , finalrsl.resulttype
                    , finalrsl.itemtype
                    , finalrsl.stcitemcd
                    , stdvalue_c.stdflg
                    , finalrsl.lastrsvno
                    , finalrsl.defresult
                    , defsentence.shortstc defshortstc
                    , finalrsl.defrslcmtcd
                    , defrslcmt.rslcmtname defrslcmtname
                    from
                      stdvalue_c
                      , rslcmt rslcmt1
                      , rslcmt rslcmt2
                      , rslcmt defrslcmt
                      , sentence lastsentence
                      , sentence currentsentence
                      , sentence defsentence,
                  ";

            //基本表に前回検査結果、検査項目および履歴情報を結合
            sql += @"
                    (
                      select
                        basedrsl.rsvno
                        , basedrsl.itemcd
                        , basedrsl.suffix
                        , basedrsl.result
                        , basedrsl.rslcmtcd1
                        , basedrsl.rslcmtcd2
                        , basedrsl.stdvaluecd
                        , basedrsl.lastrsvno
                        , item_c.itemname
                        , item_c.resulttype
                        , item_c.itemtype
                        , item_c.stcitemcd
                        , rsl.result befresult
                        , item_h.defresult
                        , item_h.defrslcmtcd
                      from
                        item_h
                        , consult
                        , item_c
                        , rsl
                        ,(
                   ";

            //今回結果と受診日、そして前回予約番号で構成される基本表
            sql += @"
                    select
                    rsl.rsvno
                    , rsl.itemcd
                    , rsl.suffix
                    , rsl.result
                    , rsl.rslcmtcd1
                    , rsl.rslcmtcd2
                    , rsl.stdvaluecd
                    ,(
                ";

            //個人ＩＤ、受診日降順で１件だけ前回受診情報を取得
            sql += @"
                    select
                        /*+ INDEX_DESC(CONSULT CONSULT_INDEX4) */
                        consult.rsvno
                      from
                        course_p
                        , receipt
                        , consult
                        ,
                 ";

            //もともとの受診情報
            sql += @"
                    (select
                        csldate
                        , perid
                        , cscd
                      from
                        consult
                      where
                        rsvno = :rsvno
                    ) currentconsult
                ";

            //過去歴検索のための条件節
            sql += @"
                    where
                      consult.perid = currentconsult.perid
                      and consult.csldate < currentconsult.csldate
                      and consult.rsvno = receipt.rsvno
                      and consult.csldate = receipt.csldate
                      and consult.cscd = course_p.cscd
                ";

            //今回コースと同一コースのみ対象とする条件
            if (RslCourse.Same.Equals(courseFlg))
            {
                sql += "and consult.cscd = currentconsult.cscd";
            }

            //２次検査コースを対象としない条件
            if (RslSecond.None.Equals(secondFlg))
            {
                sql += "and course_p.secondflg = 0";
            }

            sql += @"
                    and rownum = 1) lastrsvno
                        from
                          rsl
                        where
                          rsl.rsvno = :rsvno) basedrsl
                 ";

            //前回検査結果を結合
            sql += @"
                    where basedrsl.lastrsvno = rsl.rsvno(+)
                    and basedrsl.itemcd = rsl.itemcd(+)
                    and basedrsl.suffix = rsl.suffix(+)
                ";

            //検査項目情報を結合
            sql += @"
                    and basedrsl.itemcd = item_c.itemcd
                    and basedrsl.suffix = item_c.suffix
                ";

            //履歴取得に際し、受診日を取得
            sql += "and basedrsl.rsvno = consult.rsvno";

            //履歴は必ずただ１件存在するものと信じ、結合を行う
            sql += @"
                    and basedrsl.itemcd = item_h.itemcd
                    and basedrsl.suffix = item_h.suffix
                    and consult.csldate >= item_h.strdate
                    and consult.csldate <= item_h.enddate) finalrsl
                ";

            //文章、コメントを結合し、検査項目昇順指定
            sql += @"
                    where
                        finalrsl.stcitemcd = currentsentence.itemcd(+)
                        and finalrsl.itemtype = currentsentence.itemtype(+)
                        and finalrsl.result = currentsentence.stccd(+)
                        and finalrsl.stcitemcd = lastsentence.itemcd(+)
                        and finalrsl.itemtype = lastsentence.itemtype(+)
                        and finalrsl.befresult = lastsentence.stccd(+)
                        and finalrsl.stcitemcd = defsentence.itemcd(+)
                        and finalrsl.itemtype = defsentence.itemtype(+)
                        and finalrsl.defresult = defsentence.stccd(+)
                        and finalrsl.rslcmtcd1 = rslcmt1.rslcmtcd(+)
                        and finalrsl.rslcmtcd2 = rslcmt2.rslcmtcd(+)
                        and finalrsl.defrslcmtcd = defrslcmt.rslcmtcd(+)
                        and finalrsl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                        order by
                          finalrsl.itemcd
                          , finalrsl.suffix
                 ";

            List<dynamic> list = new List<dynamic>();
            list = connection.Query(sql, param).ToList();

            if (list != null && list.Count > 0)
            {
                foreach (var rec in list)
                {
                    if (!ResultType.Sentence.Equals((ResultType)rec.RESULTTYPE))
                    {
                        rec.SHORTSTC = "";
                        rec.BEFSHORTSTC = "";
                        rec.DEFSHORTSTC = "";
                    }
                }
            }
            updItemCount = list.Count;
            return list;
        }

        /// <summary>
        /// 指定対象受診者・各種項目の検査結果を取得する
        /// </summary>
        /// <param name="mode">入力対象モード</param>
        /// <param name="rsvNo">入力対象モード</param>
        /// <param name="code">コード(グループ、進捗分類、判定分類)</param>
        /// <param name="updItemCount">(ref)更新可能項目数</param>
        /// <returns>検査項目一覧</returns>
        public List<dynamic> SelectRslGrpList(int mode, int rsvNo, string code, ref int updItemCount)
        {
            //キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("code", code);

            string sql; // SQLステートメント

            //前回値表示条件取得
            long courseFlg = WebHains.SelectRslCourseFlg();
            long secondFlg = WebHains.SelectRslSecondFlg();

            sql = @"
                    select
                      finalrsl.seq
                      , finalrsl.consultflg
                      , finalrsl.itemcd
                      , finalrsl.suffix
                      , finalrsl.itemname
                      , finalrsl.result
                      , currentsentence.shortstc
                      , finalrsl.rslcmtcd1
                      , rslcmt1.rslcmtname rslcmtname1
                      , finalrsl.rslcmtcd2
                      , rslcmt2.rslcmtname rslcmtname2
                      , finalrsl.befresult
                      , befsentence.shortstc befshortstc
                      , finalrsl.resulttype
                      , finalrsl.itemtype
                      , finalrsl.stcitemcd
                      , stdvalue_c.stdflg
                      , finalrsl.defresult
                      , defsentence.shortstc defshortstc
                      , finalrsl.defrslcmtcd
                      , defrslcmt.rslcmtname defrslcmtname
                      , finalrsl.lastrsvno
                    from
                      stdvalue_c
                      , rslcmt rslcmt1
                      , rslcmt rslcmt2
                      , rslcmt defrslcmt
                      , sentence befsentence
                      , sentence currentsentence
                      , sentence defsentence,
                 ";

            //基本表その２に前回検査結果、検査項目履歴情報を結合
            sql += @"
                    (
                      select
                        basedrsl2.result
                        , basedrsl2.rslcmtcd1
                        , basedrsl2.rslcmtcd2
                        , basedrsl2.stdvaluecd
                        , basedrsl2.seq
                        , basedrsl2.itemcd
                        , basedrsl2.suffix
                        , basedrsl2.itemname
                        , basedrsl2.resulttype
                        , basedrsl2.itemtype
                        , basedrsl2.stcitemcd
                        , basedrsl2.consultflg
                        , basedrsl2.lastrsvno
                        , rsl.result befresult
                        , item_h.defresult
                        , item_h.defrslcmtcd
                      from
                        item_h
                        , consult
                        , rsl,
                 ";

            //基本表に項目情報、そして前回予約番号を追加した表を基本表その２とする
            sql += @"
                    (
                      select
                          nvl(basedrsl.rsvno, :rsvno) rsvno
                          , basedrsl.result
                          , basedrsl.rslcmtcd1
                          , basedrsl.rslcmtcd2
                          , basedrsl.stdvaluecd
                          , grpitem.seq
                          , grpitem.itemcd
                          , grpitem.suffix
                          , grpitem.itemname
                          , grpitem.resulttype
                          , grpitem.itemtype
                          , grpitem.stcitemcd
                          ,
                  ";

            //今回の受診項目かを判断するためのDECODE句(問診項目なら無条件受診)
            sql += @"
                    decode(
                      grpitem.rslque
                      , 0
                      , nvl2(basedrsl.itemcd, 1, 2)
                      , 1
                    ) consultflg
                    ,
                ";

            //個人ＩＤ、受診日降順で１件だけ前回受診情報を取得
            sql += @"
                    (
                      select
                          /*+ INDEX_DESC(CONSULT CONSULT_INDEX4) */
                          consult.rsvno
                        from
                          course_p
                          , receipt
                          , consult
                          ,
                 ";

            //もともとの受診情報
            sql += @"
                    (
                      select
                          csldate
                          , perid
                          , cscd
                        from
                          consult
                        where
                          rsvno = :rsvno
                    ) currentconsult
                ";

            //過去歴検索のための条件節
            sql += @"
                      where
                        consult.perid = currentconsult.perid
                        and consult.csldate < currentconsult.csldate
                        and consult.rsvno = receipt.rsvno
                        and consult.csldate = receipt.csldate
                        and consult.cscd = course_p.cscd
                 ";

            //今回コースと同一コースのみ対象とする条件
            if (RslCourse.Same.Equals(courseFlg))
            {
                sql += "and consult.cscd = currentconsult.cscd";
            }

            //２次検査コースを対象としない条件
            if (RslSecond.None.Equals(secondFlg))
            {
                sql += "and course_p.secondflg = 0";
            }

            //過去結果は依頼の有無を見つつさかのぼる
            int judClass = Convert.ToInt16(RslMode.JudClass);
            int progress = Convert.ToInt16(RslMode.Progress);

            if (mode == judClass) {
                //判定分類の場合
                    sql += @"
                            and exists (
                              select
                                rsl.rsvno
                              from
                                item_jud
                                , rsl
                              where
                                rsl.rsvno = consult.rsvno
                                and item_jud.judclasscd = :code
                                and item_jud.itemcd = rsl.itemcd
                            )
                        ";
            } else if(mode == progress) {
                //進捗分類の場合
                sql += @"
                            and exists (
                                select
                                rsl.rsvno
                                from
                                item_p
                                , rsl
                                where
                                rsl.rsvno = consult.rsvno
                                and item_p.progresscd = :code
                                and item_p.itemcd = rsl.itemcd
                            )
                    ";
            } else { 
                //それ以外は検査項目グループ
                sql += @"
                        and exists (
                                select
                                rsl.rsvno
                                from
                                grp_i
                                , rsl
                                where
                                rsl.rsvno = consult.rsvno
                                and grp_i.grpcd = :code
                                and grp_i.itemcd = rsl.itemcd
                                and grp_i.suffix = rsl.suffix
                            )
                    ";
             
            }

            sql += @"and rownum = 1) lastrsvno";

            //今回の全検査結果を基本表とする
            sql += @"
                    from
                      (
                        select
                          rsl.rsvno
                          , rsl.itemcd
                          , rsl.suffix
                          , rsl.result
                          , rsl.rslcmtcd1
                          , rsl.rslcmtcd2
                          , rsl.stdvaluecd
                        from
                          rsl
                        where
                          rsvno = :rsvno
                      ) basedrsl
                      ,
                 ";

            //項目情報を作成する
            if (mode == judClass)
            {
                //判定分類の場合
                sql += @"
                        (
                            select
                            rownum seq
                            , baseditem.itemcd
                            , baseditem.suffix
                            , baseditem.rslque
                            , baseditem.itemname
                            , baseditem.resulttype
                            , baseditem.itemtype
                            , baseditem.stcitemcd
                            from
                            (
                                select
                                item_jud.itemcd
                                , item_c.suffix
                                , item_p.rslque
                                , item_c.itemname
                                , item_c.resulttype
                                , item_c.itemtype
                                , item_c.stcitemcd
                                from
                                item_c
                                , item_p
                                , item_jud
                                where
                                item_jud.judclasscd = :code
                                and item_jud.itemcd = item_p.itemcd
                                and item_jud.itemcd = item_c.itemcd
                                order by
                                item_jud.itemcd
                                , item_c.suffix
                            ) baseditem
                        ) grpitem
                    ";

                
            }
            else if (mode == progress)
            {
                //進捗分類の場合
                sql += @"
                            (
                              select
                                rownum seq
                                , baseditem.itemcd
                                , baseditem.suffix
                                , baseditem.rslque
                                , baseditem.itemname
                                , baseditem.resulttype
                                , baseditem.itemtype
                                , baseditem.stcitemcd
                              from
                                (
                                  select
                                    item_p.itemcd
                                    , item_c.suffix
                                    , item_p.rslque
                                    , item_c.itemname
                                    , item_c.resulttype
                                    , item_c.itemtype
                                    , item_c.stcitemcd
                                  from
                                    item_c
                                    , item_p
                                  where
                                    item_p.progresscd = :code
                                    and item_p.itemcd = item_c.itemcd
                                  order by
                                    item_p.itemcd
                                    , item_c.suffix
                                ) baseditem
                            ) grpitem
                         ";

                
            }
            else
            {
                //それ以外は検査項目グループ
                sql += @"
                            (
                              select
                                grp_i.seq
                                , grp_i.itemcd
                                , grp_i.suffix
                                , item_p.rslque
                                , item_c.itemname
                                , item_c.resulttype
                                , item_c.itemtype
                                , item_c.stcitemcd
                              from
                                item_c
                                , item_p
                                , grp_i
                              where
                                grp_i.grpcd = :code
                                and grp_i.itemcd = item_p.itemcd
                                and grp_i.itemcd = item_c.itemcd
                                and grp_i.suffix = item_c.suffix
                            ) grpitem
                        ";
            }

            //基本表と項目情報とを結合
            sql += @"
                      where
                        grpitem.itemcd = basedrsl.itemcd(+)
                        and grpitem.suffix = basedrsl.suffix(+)) basedrsl2";

            //前回検査結果を結合
            sql += @"
                    where
                      basedrsl2.lastrsvno = rsl.rsvno(+)
                      and basedrsl2.itemcd = rsl.itemcd(+)
                      and basedrsl2.suffix = rsl.suffix(+)
                 ";

            //履歴取得に際し、受診日を取得
            sql += "and basedrsl2.rsvno = consult.rsvno";

            //履歴は必ずただ１件存在するものと信じ、結合を行う
            sql += @"
                    and basedrsl2.itemcd = item_h.itemcd
                    and basedrsl2.suffix = item_h.suffix
                    and consult.csldate >= item_h.strdate
                    and consult.csldate <= item_h.enddate) finalrsl";

            //文章、コメントを結合し、SEQ順指定
            sql += @"
                    where
                      finalrsl.stcitemcd = currentsentence.itemcd(+)
                      and finalrsl.itemtype = currentsentence.itemtype(+)
                      and finalrsl.result = currentsentence.stccd(+)
                      and finalrsl.stcitemcd = befsentence.itemcd(+)
                      and finalrsl.itemtype = befsentence.itemtype(+)
                      and finalrsl.befresult = befsentence.stccd(+)
                      and finalrsl.stcitemcd = defsentence.itemcd(+)
                      and finalrsl.itemtype = defsentence.itemtype(+)
                      and finalrsl.defresult = defsentence.stccd(+)
                      and finalrsl.rslcmtcd1 = rslcmt1.rslcmtcd(+)
                      and finalrsl.rslcmtcd2 = rslcmt2.rslcmtcd(+)
                      and finalrsl.defrslcmtcd = defrslcmt.rslcmtcd(+)
                      and finalrsl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                    order by
                      finalrsl.seq";

            List<dynamic> list = new List<dynamic>();
            list = connection.Query(sql, param).ToList();
            foreach (var rec in list)
            {
                Convert.ToInt32(rec.SEQ);
                if (ConsultItem.T.Equals((ConsultItem)rec.CONSULTFLG))
                {
                    updItemCount += 1;
                }
                if (!ResultType.Sentence.Equals((ResultType)rec.RESULTTYPE))
                {
                    rec.SHORTSTC = "";
                    rec.BEFSHORTSTC = "";
                    rec.DEFSHORTSTC = "";
                }
            }
            return list;
        }

        /// <summary>
        /// 指定個人の指定グループ内検査項目結果を取得
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="allGrpItem">True:全てのグループ内検査項目を対象とする、False:検査項目の設定されていないレコードは非対象</param>
        /// <returns>検査項目一覧</returns>
        public List<dynamic> SelectRslHistory(string perId, string grpCd, bool allGrpItem = true)
        {
            //キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId.Trim());
            param.Add("grpcd", grpCd.Trim());

            string sql; // SQLステートメント

            //指定個人の指定グループ内検査項目結果を取得
            sql = @"
                       select
                          grpitemhistroy.seq
                          , grpitemhistroy.itemcd
                          , grpitemhistroy.suffix
                          , item_c.itemname
                          , grpitemhistroy.csldate
                          , course_p.csname
                          , rsl.result
                          , stdvalue_c.stdflg
                        from
                          stdvalue_c
                          , rsl
                          , course_p
                          , item_c
                 ";

            //指定個人の全受診情報と指定グループ内全検査項目との内部結合を実施した表を基本表とする
            sql += @"
                        ,(
                          select
                            grp_i.seq
                            , grp_i.itemcd
                            , grp_i.suffix
                            , consult.rsvno
                            , consult.csldate
                            , consult.cscd
                          from
                            receipt
                            , consult
                            , grp_i
                          where
                            grp_i.grpcd = :grpcd
                 ";

            // 検査項目の設定されていないレコードを非対象とする場合の条件追加
            if (!allGrpItem)
            {
                sql += @"
                        and grp_i.itemcd is not null
                        and grp_i.suffix is not null
                     ";
            }

            // 指定個人IDの受診情報を取得するための結合
            sql += @"
                    and consult.perid = :perid
                    and consult.cancelflg = '0'
                    and consult.rsvno = receipt.rsvno(+)
                    and consult.csldate = receipt.csldate(+)
                ";

            // ORDER BY句の指定
            sql += @"
                    order by
                      grp_i.seq
                      , grp_i.itemcd
                      , grp_i.suffix
                      , consult.csldate desc
                      , receipt.dayid desc nulls last
                      , consult.cscd) grpitemhistroy
                ";

            // 基本表に各テーブル内容を結合
            sql += @"
                    where
                      grpitemhistroy.itemcd = item_c.itemcd(+)
                      and grpitemhistroy.suffix = item_c.suffix(+)
                      and grpitemhistroy.cscd = course_p.cscd
                      and grpitemhistroy.rsvno = rsl.rsvno(+)
                      and grpitemhistroy.itemcd = rsl.itemcd(+)
                      and grpitemhistroy.suffix = rsl.suffix(+)
                      and rsl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たすグループの一覧を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="rslQue"></param>
        /// <returns>検査項目一覧</returns>
        public List<dynamic> SelectInquiryRslList(string rsvNo, RslQue rslQue)
        {
            // 検索条件が設定されていない場合はエラー
            if (String.IsNullOrEmpty(rsvNo))
            {
                //「プロシージャの呼び出し、または引数が不正です。」
                throw new ArgumentException();
            }

            if (RslQue.R != rslQue && RslQue.Q != rslQue)
            {
                //「プロシージャの呼び出し、または引数が不正です。」
                throw new ArgumentException();
            }

            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo.Trim());
            param.Add("rslque", rslQue.ToString());

            string sql; // SQLステートメント

            //検索条件を満たす検査結果情報のレコードを取得
            sql = @"
                    select
                        masterresult.itemname
                        , masterresult.result
                        , masterresult.resulttype
                        , sentence.shortstc
                        , masterresult.stdflg
                        , itemclass.classcd
                        , masterresult.rslcmtname1
                        , masterresult.rslcmtname2
                        , itemclass.classname
                        , masterresult.itemcd
                        , masterresult.suffix
                        from
                        sentence sentence
                        , itemclass itemclass
                        , (
                            select
                                item_c.itemname
                                , rsl.result
                                , item_c.resulttype
                                , item_c.itemtype
                                , item_c.stcitemcd
                                , stdvalue_c.stdflg
                                , rslcmt1.rslcmtname rslcmtname1
                                , rslcmt2.rslcmtname rslcmtname2
                                , item_p.classcd
                                , item_c.itemcd
                                , item_c.suffix
                            from
                                rsl rsl
                                , item_c item_c
                                , item_p item_p
                                , stdvalue_c stdvalue_c
                                , rslcmt rslcmt1
                                , rslcmt rslcmt2
                            where
                                rsl.rsvno = :rsvno
                                and item_p.rslque = :rslque
                                and rsl.itemcd = item_p.itemcd
                                and rsl.itemcd = item_c.itemcd
                                and rsl.suffix = item_c.suffix
                                and rsl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                                and rsl.rslcmtcd1 = rslcmt1.rslcmtcd(+)
                                and rsl.rslcmtcd2 = rslcmt2.rslcmtcd(+)
                        ) masterresult
                        where
                        masterresult.stcitemcd = sentence.itemcd(+)
                        and masterresult.itemtype = sentence.itemtype(+)
                        and masterresult.result = sentence.stccd(+)
                        and itemclass.classcd = masterresult.classcd
                        order by
                        itemclass.classcd
                        , masterresult.itemcd
                        , masterresult.suffix
                    ";


            // #ToDo Select後の.Net側での処理をどうするか
            //If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
            //    vntArrShortStc(lngCount) = objShortStc.Value & ""
            //Else
            //    vntArrShortStc(lngCount) = ""
            //End If
            //objCommon.SelectStdFlgColor objStdFlg.Value & "_COLOR", vntArrStdFlgColor(lngCount)

            return connection.Query(sql, param).ToList();

        }
        /// <summary>
        /// 指定条件を満たす検査結果レコードの検査結果を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>検査結果</returns>
        public string SelectRsl(long rsvNo, string itemCd, string suffix)
        {
            string sql; // SQLステートメント

            // キー及び設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno2", rsvNo);
            param.Add("itemcd2", itemCd);
            param.Add("suffix2", suffix);

            //指定条件を満たす検査結果レコードの検査結果を取得
            sql = @"
                    select
                        result
                      from
                        rsl
                      where
                        rsvno = :rsvno2
                        and itemcd = :itemcd2
                        and suffix = :suffix2
                  ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在する場合
            if (current != null)
            {
                return current.RESULT;
            }

            return null;

        }

        /// <summary>
        /// 指定対象受診者の受診グループ内検査項目を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns>検査結果情報
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// itemName 検査項目名称
        /// </returns>
        public dynamic SelectInqHistoryItemList(string perId, string hisCount, string grpCd)
        {
            string sql = "";                                // SQLステートメント
            var param = new Dictionary<string, object>();   // キー値の設定
            long localHistoryCount;                         //表示歴数

            // 個人ＩＤが設定されていない場合はエラー
            if (String.IsNullOrEmpty(perId))
            {
                throw new ArgumentException();
            }
            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Util.IsNumber(hisCount))
                {
                    throw new ArgumentException();
                }
                localHistoryCount = long.Parse(hisCount);
            }
            else
            {
                localHistoryCount = 0;
            }

            // キーの設定
            param.Add("perid", perId.Trim());
            param.Add("cancelflg", ConsultCancel.Used.ToString());
            param.Add("grpcd", grpCd);

            // 検索条件を満たす検査結果情報のレコードを取得
            sql = @"
                    select distinct
                      rs.itemcd
                      , rs.suffix
                      , ic.itemname
                    from
                      (
                        select
                          rsvno
                        from
                          (
                            select
                              cn.rsvno
                            from
                              consult cn
                            where
                              cn.perid = :perid
                              and cn.cancelflg = :cancelflg
                            order by
                              cn.csldate
                      )
                ";

            if (localHistoryCount > 0)
            {
                sql += " where rownum between 1 and: hiscount ";
                param.Add("hiscount", Convert.ToString(localHistoryCount));
            }

            sql += @"
                        ) cl
                        , rsl rs
                        , item_c ic
                        where
                            cl.rsvno = rs.rsvno
                            and exists(
                            select
                                gp.itemcd
                            from
                                grp_i gp
                            where
                                gp.grpcd = :grpcd
                                and gp.itemcd = rs.itemcd
                                and gp.suffix = rs.suffix
                            )
                            and rs.itemcd = ic.itemcd
                            and rs.suffix = ic.suffix
                        order by
                            rs.itemcd
                            , rs.suffix
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定対象受診者の検査結果を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns>検査結果情報
        /// rsvNo 予約番号
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// result 検査結果
        /// stdFlg 基準値フラグ
        /// </returns>
        public dynamic SelectInqHistoryRslList(string perId, DateTime cslDate, string hisCount, string grpCd)
        {
            string sql = "";                                // SQLステートメント
            var param = new Dictionary<string, object>();   // キー値の設定
            long localHistoryCount;                         //表示歴数

            // 個人ＩＤが設定されていない場合はエラー
            if (String.IsNullOrEmpty(perId))
            {
                throw new ArgumentException();
            }
            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Util.IsNumber(hisCount))
                {
                    throw new ArgumentException();
                }
                localHistoryCount = long.Parse(hisCount);
            }
            else
            {
                localHistoryCount = 0;
            }

            // キーの設定
            param.Add("perid", perId.Trim());
            param.Add("cancelflg", Convert.ToString(ConsultCancel.Used));
            param.Add("grpcd", grpCd);
            param.Add("csldate", cslDate);

            // 検索条件を満たす検査結果情報のレコードを取得
            sql = @"
                    select
                      finalrsl.rsvno
                      , finalrsl.itemcd
                      , finalrsl.suffix
                      , nvl(sentence.shortstc, finalrsl.result) result
                      , finalrsl.stdflg
                    from
                      sentence
                      , (
                        select
                          cn.csldate
                          , cn.rsvno
                          , rs.itemcd
                          , rs.suffix
                          , rs.result
                          , sc.stdflg
                          , item_c.stcitemcd
                          , item_c.itemtype
                        from
                          (
                            select
                              rownum seq
                              , csldate
                              , rsvno
                            from
                              (
                                select
                                  cn.csldate
                                  , cn.rsvno
                                from
                                  consult cn
                                where
                                  cn.perid = :perid
                                  and cn.csldate <= :csldate
                                  and cn.cancelflg = :cancelflg
                                order by
                                  cn.csldate desc
                              )
                          ) cn
                          , rsl rs
                          , stdvalue_c sc
                          , item_c
                        where
                          cn.rsvno = rs.rsvno
                    ";

            if (localHistoryCount > 0)
            {
                sql += " and cn.seq between 1 and :hiscount ";
                param.Add("hiscount", Convert.ToString(localHistoryCount));
            }

            sql += @"
                        and exists (
                            select
                            gp.itemcd
                            from
                            grp_i gp
                            where
                            gp.grpcd = :grpcd
                            and gp.itemcd = rs.itemcd
                            and gp.suffix = rs.suffix
                        )
                        and rs.stdvaluecd = sc.stdvaluecd(+)
                        and rs.itemcd = item_c.itemcd
                        and rs.suffix = item_c.suffix) finalrsl
                        where
                            finalrsl.stcitemcd = sentence.itemcd(+)
                            and finalrsl.itemtype = sentence.itemtype(+)
                            and finalrsl.result = sentence.stccd(+)
                        order by
                            finalrsl.itemcd
                            , finalrsl.suffix
                            , finalrsl.csldate desc
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定対象受診者・検査グループの検査項目を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループ（検査項目）</param>
        /// <returns>検査結果情報
        /// consultFlg 受診項目フラグ
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// itemName 検査項目名称
        /// result 検査結果
        /// resultType 結果タイプ
        /// itemType 項目タイプ
        /// stcItemCd 文章参照用項目コード
        /// shortStc 文章略称
        /// stdFlg 基準値フラグ
        /// </returns>
        public dynamic SelectRslAllSetList(string rsvNo, string grpCd)
        {
            string sql = "";                                // SQLステートメント
            var param = new Dictionary<string, object>();   // キー値の設定

            // 検索条件が設定されていない場合はエラー
            if (String.IsNullOrEmpty(rsvNo) || String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // キーの設定
            param.Add("rsvno", rsvNo.Trim());
            param.Add("grpcd", grpCd.Trim());
            param.Add("grpdiv", Convert.ToInt32(GrpDiv.I));
            param.Add("rslque_r", Convert.ToInt32(RslQue.R));
            param.Add("rslque_q", Convert.ToInt32(RslQue.Q));
            param.Add("consult_item_t", Convert.ToInt32(ConsultItem.T));
            param.Add("consult_item_f", Convert.ToInt32(ConsultItem.F));

            // 検索条件を満たす検査結果情報のレコードを取得
            sql = @"
                    select
                      rs.consultflg
                      , rs.itemcd
                      , rs.suffix
                      , rs.itemname
                      , rs.result
                      , rs.resulttype
                      , rs.itemtype
                      , rs.stcitemcd
                      , decode(rs.resulttype, " + Convert.ToInt32(ResultType.Sentence) + @", sc.shortstc, null) shortstc
                      , stdvalue_c.stdflg
                    from
                      (
                        select
                          il.seq
                          , il.consultflg
                          , il.itemcd
                          , il.suffix
                          , il.itemname
                          , rl.result
                          , il.resulttype
                          , il.itemtype
                          , il.stcitemcd
                          , rl.stdvaluecd
                ";

            // 検査グループ内の全検査項目で、対象受診者の検査項目を取得する
            sql += @"
                        from
                            (
                                select
                                    :consult_item_t consultflg
                                    , gi.seq
                                    , gi.itemcd
                                    , gi.suffix
                                    , ic.itemname
                                    , ic.resulttype
                                    , ic.itemtype
                                    , ic.stcitemcd
                                from
                                    grp_p gp
                                    , grp_i gi
                                    , item_p ip
                                    , item_c ic
                                    , rsl rs
                                where
                                    gp.grpcd = :grpcd
                                    and gp.grpdiv = :grpdiv
                                    and ip.rslque = :rslque_r
                                    and rs.rsvno = :rsvno
                                    and gp.grpcd = gi.grpcd
                                    and gi.itemcd = ip.itemcd
                                    and gi.itemcd = rs.itemcd
                                    and gi.suffix = rs.suffix
                                    and gi.itemcd = ic.itemcd
                                    and gi.suffix = ic.suffix
                                union
                                select
                                    :consult_item_f consultflg
                                    , gi.seq
                                    , gi.itemcd
                                    , gi.suffix
                                    , ic.itemname
                                    , ic.resulttype
                                    , ic.itemtype
                                    , ic.stcitemcd
                                from
                                    grp_p gp
                                    , grp_i gi
                                    , item_p ip
                                    , item_c ic
                                where
                                    gp.grpcd = :grpcd
                                    and gp.grpdiv = :grpdiv
                                    and ip.rslque = :rslque_r
                                    and gp.grpcd = gi.grpcd
                                    and gi.itemcd = ip.itemcd
                                    and gi.itemcd = ic.itemcd
                                    and gi.suffix = ic.suffix
                                    and not exists (
                                    select
                                        rs.itemcd
                                    from
                                        rsl rs
                                    where
                                        rs.rsvno = :rsvno
                                        and rs.itemcd = ic.itemcd
                                        and rs.suffix = ic.suffix
                                    )
                                union
                ";

            // 検査グループ内の全問診項目を取得する
            sql += @"
                                select
                                  :consult_item_t consultflg
                                  , gi.seq
                                  , gi.itemcd
                                  , gi.suffix
                                  , ic.itemname
                                  , ic.resulttype
                                  , ic.itemtype
                                  , ic.stcitemcd
                                from
                                  grp_p gp
                                  , grp_i gi
                                  , item_p ip
                                  , item_c ic
                                where
                                  gp.grpcd = :grpcd
                                  and gp.grpdiv = :grpdiv
                                  and ip.rslque = :rslque_q
                                  and gp.grpcd = gi.grpcd
                                  and gi.itemcd = ip.itemcd
                                  and gi.itemcd = ic.itemcd
                                  and gi.suffix = ic.suffix
                            ) il,
                 ";

            // 対象受診者の全検査項目を取得する
            sql += @"
                            (
                              select
                                rs.itemcd
                                , rs.suffix
                                , rs.result
                                , rs.stdvaluecd
                              from
                                rsl rs
                              where
                                rs.rsvno = :rsvno
                            ) rl
                        where
                            il.itemcd = rl.itemcd(+)
                            and il.suffix = rl.suffix(+)) rs
                            , sentence sc
                            , stdvalue_c
                    where
                        rs.stcitemcd = sc.itemcd(+)
                        and rs.itemtype = sc.itemtype(+)
                        and rs.result = sc.stccd(+)
                        and rs.stdvaluecd = stdvalue_c.stdvaluecd(+)
                    order by
                        rs.seq
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定対象受診者・検査グループの検査項目を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="lastName">姓</param>
        /// <param name="firstName">名</param>
        /// <param name="grpCd">グループ（検査項目）</param>
        /// <returns>検査グループの検査項目
        /// updItemCount 更新項目件数
        /// rslRsvNo 検査結果・予約番号
        /// rslLastName 検査結果・姓
        /// rslFirstName 検査結果・名
        /// consultFlg 受診項目フラグ
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// itemName 検査項目名称
        /// result 検査結果
        /// resultType 結果タイプ
        /// stdFlg 基準値フラグ
        /// </returns>
        public List<dynamic> SelectRslListSet(List<string> rsvNo, List<string> lastName, List<string> firstName, string grpCd)
        {
            string sql = "";                                // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (rsvNo == null || String.IsNullOrEmpty(grpCd))
            {
                throw new ArgumentException();
            }

            // 予約番号が配列の場合
            if (rsvNo.Count > 0)
            {
                // 姓・名が配列でない場合は処理終了
                if (lastName == null || firstName == null)
                {
                    throw new ArgumentException();
                }

                // 予約番号・姓・名のサイズが一致しない場合は処理終了
                if ((rsvNo.Count != lastName.Count) || (rsvNo.Count != firstName.Count))
                {
                    throw new ArgumentException();
                }
            }

            List<dynamic> query = new List<dynamic>();

            for (int i = 0; i < rsvNo.Count; i++)
            {
                // キー値の設定
                var param = new Dictionary<string, object>();
                param.Add("rsvno", rsvNo[i].Trim());
                param.Add("grpcd", grpCd.Trim());
                param.Add("grpdiv", Convert.ToInt32(GrpDiv.I));
                param.Add("rslque_r", Convert.ToInt32(RslQue.R));
                param.Add("rslque_q", Convert.ToInt32(RslQue.Q));
                param.Add("consult_item_t", Convert.ToInt32(ConsultItem.T));
                param.Add("consult_item_f", Convert.ToInt32(ConsultItem.F));

                // 検索条件を満たす検査結果情報のレコードを取得
                sql = @"
                        select
                          il.consultflg
                          , il.itemcd
                          , il.suffix
                          , il.itemname
                          , rl.result
                          , il.resulttype
                          , rl.stdflg

                    ";

                // 検査グループ内の全検査項目で、対象受診者の検査項目を取得する
                // （受診項目）
                sql += @"
                        from
                          (
                            select
                              :consult_item_t consultflg
                              , gi.seq
                              , gi.itemcd
                              , gi.suffix
                              , ic.itemname
                              , ic.resulttype
                            from
                              grp_p gp
                              , grp_i gi
                              , item_p ip
                              , item_c ic
                              , rsl rs
                            where
                              gp.grpcd = :grpcd
                              and gp.grpdiv = :grpdiv
                              and ip.rslque = :rslque_r
                              and rs.rsvno = :rsvno
                              and gp.grpcd = gi.grpcd
                              and gi.itemcd = ip.itemcd
                              and gi.itemcd = rs.itemcd
                              and gi.suffix = rs.suffix
                              and gi.itemcd = ic.itemcd
                              and gi.suffix = ic.suffix
                            union
                            select
                              :consult_item_f consultflg
                              , gi.seq
                              , gi.itemcd
                              , gi.suffix
                              , ic.itemname
                              , ic.resulttype
                            from
                              grp_p gp
                              , grp_i gi
                              , item_p ip
                              , item_c ic
                            where
                              gp.grpcd = :grpcd
                              and gp.grpdiv = :grpdiv
                              and ip.rslque = :rslque_r
                              and gp.grpcd = gi.grpcd
                              and gi.itemcd = ip.itemcd
                              and gi.itemcd = ic.itemcd
                              and gi.suffix = ic.suffix
                              and not exists (
                                select
                                  rs.itemcd
                                from
                                  rsl rs
                                where
                                  rs.rsvno = :rsvno
                                  and rs.itemcd = ic.itemcd
                                  and rs.suffix = ic.suffix
                                )
                            union
                    ";

                // 検査グループ内の全問診項目を取得する
                sql += @"
                            select
                              :consult_item_t consultflg
                              , gi.seq
                              , gi.itemcd
                              , gi.suffix
                              , ic.itemname
                              , ic.resulttype
                            from
                              grp_p gp
                              , grp_i gi
                              , item_p ip
                              , item_c ic
                            where
                              gp.grpcd = :grpcd
                              and gp.grpdiv = :grpdiv
                              and ip.rslque = :rslque_q
                              and gp.grpcd = gi.grpcd
                              and gi.itemcd = ip.itemcd
                              and gi.itemcd = ic.itemcd
                              and gi.suffix = ic.suffix
                            ) il ,
                     ";

                // 対象受診者の全検査項目を取得する
                sql += @"
                            (
                              select
                                rs.itemcd
                                , rs.suffix
                                , rs.result
                                , stdvalue_c.stdflg
                              from
                                stdvalue_c
                                , rsl rs
                              where
                                rs.rsvno = :rsvno
                                and rs.stdvaluecd = stdvalue_c.stdvaluecd(+)
                            ) rl
                        where
                          il.itemcd = rl.itemcd(+)
                          and il.suffix = rl.suffix(+)
                        order by
                          il.seq
                          , il.itemcd
                          , il.suffix
                     ";

                List<dynamic> resultQuery = connection.Query(sql, param).ToList();

                // 検索レコードが存在する場合
                if (resultQuery != null)
                {
                    foreach (var rec in resultQuery)
                    {
                        query.Add(rec);
                    }
                }
            }

            return query;
        }

        /// <summary>
        /// 結果一括更新
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="allResultClear">全ての結果をクリア</param>
        /// <param name="overWrite">結果を上書き</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        public void UpdateResultAll(string updUser, string ipAddress, string allResultClear, string overWrite,
            List<long> rsvNo, List<string> itemCd, List<string> suffix, List<string> result)
        {
            string sql = "";                                        // SQLステートメント

            bool overWriteFlg = false;                              // 上書きフラグ

            List<string> loaclArrItemCd = new List<string>();       // 検査項目コード
            List<string> loaclArrSuffix = new List<string>();       // サフィックス
            List<string> loaclArrResult = new List<string>();       // 検査結果
            List<long> loaclRsvNo = new List<long>();               // 予約番号
            int updCount = 0;                                       //更新項目数

            // キーの設定
            var param = new Dictionary<string, object>();
            param.Add("ipaddress", ipAddress);
            param.Add("upduser", updUser);

            // 結果クリアを行わない場合
            if (String.IsNullOrEmpty(Util.ConvertToString(allResultClear)))
            {
                // 結果の存在する項目のみを更新対象とする
                for (int i = 0; i < itemCd.Count; i++)
                {
                    if (!string.IsNullOrEmpty(itemCd[i]))
                    {
                        loaclArrItemCd.Add(itemCd[i]);
                        loaclArrSuffix.Add(suffix[i]);
                        loaclArrResult.Add(result[i]);

                        updCount++;
                    }
                }

                // 上書きフラグの設定
                if (!String.IsNullOrEmpty(Util.ConvertToString(overWrite)))
                {
                    overWriteFlg = true;
                }
            }
            else
            {
                // 検査項目コードは引数値をそのまま使用する
                updCount = itemCd.Count;
                loaclArrItemCd = itemCd;
                loaclArrSuffix = suffix;
                // 検査結果は検査項目コードと同一要素数の空の配列を作成する
                loaclArrResult = new List<string>(new string[updCount]);

                // 上書きフラグの設定
                overWriteFlg = true;

            }

            while (true)
            {
                // 更新項目が存在しなければ何もしない
                if (itemCd.Count <= 0)
                {
                    return;
                }

                // キー値及び更新値の設定
                using (var cmd = new OracleCommand())
                {

                    // キー値及び更新値の設定
                    cmd.Parameters.Add("ipaddress", ipAddress.ToString());
                    cmd.Parameters.Add("upduser", updUser.ToString());
                    cmd.Parameters.Add("overwrite", (overWriteFlg ? 1 : 0));
                    OracleParameter objItemCd = cmd.Parameters.AddTable("itemcd", loaclArrItemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, updCount, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                    OracleParameter objSuffix = cmd.Parameters.AddTable("suffix", loaclArrSuffix.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, updCount, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                    OracleParameter objResult = cmd.Parameters.AddTable("result", loaclArrResult.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, updCount, 400);

                    // 更新値の編集
                    for (int i = 0; i < rsvNo.Count; i++)
                    {
                        loaclRsvNo.Add(rsvNo[i]);
                    }
                    // バインド配列の定義
                    cmd.Parameters.AddTable("rsvno", loaclRsvNo.ToArray(), ParameterDirection.Input, OracleDbType.Int32, loaclRsvNo.Count, (int)LengthConstants.LENGTH_CONSULT_RSVNO);

                    // 結果更新用ストアド呼び出し
                    sql = @"
                            begin resultpackage.updateresultall(
                              :rsvno
                              , :ipaddress
                              , :upduser
                              , :itemcd
                              , :suffix
                              , :result
                              , :overwrite
                            );
                            end;
                    ";

                    // SQL実行
                    ExecuteNonQuery(cmd, sql);

                    break;
                }
            }
        }

        /// <summary>
        /// 検査結果テーブルを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">IPアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="results">検査結果のリスト</param>
        /// <param name="messages">メッセージ</param>
        /// <param name="includeStopFlg">真の場合は検査中止フラグを更新に含める</param>
        /// <param name="skipNoRec">真の場合は依頼のない検査項目をスキップ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateResult(int rsvNo, string ipAddress, string updUser, IList<ResultRec> results, ref List<string> messages, bool includeStopFlg = false, bool skipNoRec = false)
        {
            messages = new List<string>();

            if ((results == null) || (results.Count == 0))
            {
                return Insert.Normal;
            }

            string sql = "";    // SQLステートメント

            OracleParameter sqlRet;     // SQL戻り値
            OracleParameter sqlMessage; // SQLメッセージ

            int returnValue = 0;    // ストアドプロシージャの戻り値

            using (var ts = new TransactionScope())
            {
                using (var cmd = new OracleCommand())
                {
                    // キー値及び更新値の設定
                    cmd.Parameters.Add("rsvno", rsvNo);
                    cmd.Parameters.Add("ipaddress", ipAddress);
                    cmd.Parameters.Add("upduser", updUser);

                    int arraySize = results.Count;
                    cmd.Parameters.AddTable("itemcd", results.Select(r => r.ItemCd).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                    cmd.Parameters.AddTable("suffix", results.Select(r => r.Suffix).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                    cmd.Parameters.AddTable("result", results.Select(r => r.Result).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 400);
                    cmd.Parameters.AddTable("rslcmtcd1", results.Select(r => r.RslCmtCd1).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                    cmd.Parameters.AddTable("rslcmtcd2", results.Select(r => r.RslCmtCd2).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                    cmd.Parameters.AddTable("stopflg", results.Select(r => r.StopFlg).ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 1);
                    sqlMessage = cmd.Parameters.AddTable("message", messages.ToArray(), ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);

                    sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                    if (includeStopFlg)
                    {
                        // 検査中止フラグ未指定時は通常の更新ストアドを呼び出す
                        sql = @"
                            begin
                                ret := resultpackage.updateresult(
                                    :rsvno,
                                    :ipaddress,
                                    :upduser,
                                    :itemcd,
                                    :suffix,
                                    :result,
                                    :rslcmtcd1,
                                    :rslcmtcd2,
                                    :message
                                );
                            end;
                        ";
                    }
                    else
                    {
                        // 各項目の更新要否等を設定
                        cmd.Parameters.Add("updresult", 1);
                        cmd.Parameters.Add("updrslcmt1", 1);
                        cmd.Parameters.Add("updrslcmt2", 1);
                        cmd.Parameters.Add("skipnorec", (skipNoRec ? 0 : 1));

                        // 検査中止フラグ付き結果更新ストアド呼び出し
                        sql = @"
                            begin
                                :ret := resultpackage.updateresultforstop(
                                    :rsvno
                                    , :ipaddress
                                    , :upduser
                                    , :itemcd
                                    , :suffix
                                    , :result
                                    , :rslcmtcd1
                                    , :rslcmtcd2
                                    , :stopflg
                                    , :message
                                    , :updresult
                                    , :updrslcmt1
                                    , :updrslcmt2
                                    , :skipnorec
                                );
                            end;
                        ";
                    }

                    // SQL実行
                    ExecuteNonQuery(cmd, sql);

                    // SQL戻り値の取得
                    returnValue = ((OracleDecimal)sqlRet.Value).ToInt32();
                }

                // チェックエラー時
                if (returnValue <= 0)
                {
                    List<string> tmpMeassage = ((OracleString[])sqlMessage.Value).Select(s => s.Value).ToList();

                    // バインド配列内容を検索し、メッセージを取得
                    for (int i = 0; i < tmpMeassage.Count; i++)
                    {
                        // メッセージが格納されていなければここで終了
                        if (string.IsNullOrEmpty(Util.ConvertToString(tmpMeassage[i])))
                        {
                            break;
                        }

                        // 配列形式で格納する
                        messages.Add(tmpMeassage[i]);
                    }

                    return Insert.Error;
                }

                ts.Complete();

                // 戻り値の設定
                return Insert.Normal;
            }
        }

        /// <summary>
        /// 検査結果テーブルを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        /// <param name="shortStc">略文章</param>
        /// <param name="resultError">結果チェックエラーコード</param>
        /// <param name="rslCmtCd1">結果コメント１</param>
        /// <param name="rslCmtName1">結果コメント名１</param>
        /// <param name="rslCmtError1">結果コメント１チェックエラーコード</param>
        /// <param name="rslCmtCd2">結果コメント２</param>
        /// <param name="rslCmtName2">結果コメント名２</param>
        /// <param name="rslCmtError2">結果コメント２チェックエラーコード</param>
        /// <param name="message">メッセージ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateResultForDetail(string rsvNo, string ipAddress, string updUser, ref List<string> itemCd,
            List<string> suffix, ref List<string> result, ref List<string> shortStc, ref List<string> resultError,
            ref List<string> rslCmtCd1, ref List<string> rslCmtName1, ref List<string> rslCmtError1, ref List<string> rslCmtCd2,
            ref List<string> rslCmtName2, ref List<string> rslCmtError2, ref List<string> message)
        {
            string sql = "";                                // SQLステートメント
            Int32 arraySize = 0;                            // 配列の要素数

            OracleParameter sqlResult;                      // 検査結果
            OracleParameter sqlShortStc;                    // 略文章
            OracleParameter sqlResultError;                 // 結果チェックエラーコード
            OracleParameter sqlRslCmtCd1;                   // 結果コメントコード１
            OracleParameter sqlRslCmtName1;                 // 結果コメント名称１
            OracleParameter sqlRslCmtError1;                // 結果コメントチェック１エラーコード
            OracleParameter sqlRslCmtCd2;                   // 結果コメントコード２
            OracleParameter sqlRslCmtName2;                 // 結果コメント名称２
            OracleParameter sqlRslCmtError2;                // 結果コメントチェック２エラーコード
            OracleParameter sqlRet;                         // SQL戻り値
            OracleParameter sqlMessage;                     // SQLメッセージ

            List<string> msg = new List<string>();          // メッセージ

            long ret2 = 0;                                  // 関数戻り値
            Insert ret = Insert.Error;                      // 関数戻り値

            using (var cmd = new OracleCommand())
            {

                // キー値及び更新値の設定
                cmd.Parameters.Add("rsvno", rsvNo);
                cmd.Parameters.Add("ipaddress", ipAddress);
                cmd.Parameters.Add("upduser", updUser);

                arraySize = itemCd.Count;
                cmd.Parameters.AddTable("itemcd", itemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                cmd.Parameters.AddTable("suffix", suffix.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);

                sqlResult = cmd.Parameters.AddTable("result", result.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 400);
                sqlShortStc = cmd.Parameters.AddTable("shortstc", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_SENTENCE_SHORTSTC);
                sqlResultError = cmd.Parameters.AddTable("resulterror", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 3);
                sqlRslCmtCd1 = cmd.Parameters.AddTable("rslcmtcd1", rslCmtCd1.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                sqlRslCmtName1 = cmd.Parameters.AddTable("rslcmtname1", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTNAME);
                sqlRslCmtError1 = cmd.Parameters.AddTable("rslcmterror1", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 3);
                sqlRslCmtCd2 = cmd.Parameters.AddTable("rslcmtcd2", rslCmtCd2.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                sqlRslCmtName2 = cmd.Parameters.AddTable("rslcmtname2", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTNAME);
                sqlRslCmtError2 = cmd.Parameters.AddTable("rslcmterror2", ParameterDirection.Output, OracleDbType.Varchar2, arraySize, 3);
                sqlMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);

                sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // 結果更新用ストアド呼び出し
                sql = @"
                        begin :ret := resultpackage.updateresultfordetail(
                          :rsvno
                          , :ipaddress
                          , :upduser
                          , :itemcd
                          , :suffix
                          , :result
                          , :shortstc
                          , :resulterror
                          , :rslcmtcd1
                          , :rslcmtname1
                          , :rslcmterror1
                          , :rslcmtcd2
                          , :rslcmtname2
                          , :rslcmterror2
                          , :message
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の取得
                ret2 = ((OracleDecimal)sqlRet.Value).ToInt32();

                ret = Insert.Normal;

                // チェックエラー時
                if (ret2 <= 0)
                {
                    if (message != null)
                    {
                        List<string> tmpMeassage = ((OracleString[])sqlMessage.Value).Select(s => s.Value).ToList();
                        // バインド配列内容を検索し、メッセージを取得
                        for (int i = 0; i < tmpMeassage.Count; i++)
                        {
                            // メッセージが格納されていなければここで終了
                            if (string.IsNullOrEmpty(Util.ConvertToString(tmpMeassage[i])))
                            {
                                break;
                            }

                            // 配列形式で格納する
                            msg.Add(tmpMeassage[i]);
                        }

                        // 戻り値の設定(エラー時のメッセージ)
                        message = msg;
                    }

                    ret = Insert.Error;
                }

                // 戻り値の設定(エラーに関わらず戻す値)
                result = ((OracleString[])sqlResult.Value).Select(s => s.IsNull ? "" : s.Value).ToList();

                shortStc = ((OracleString[])sqlShortStc.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                resultError = ((OracleString[])sqlResultError.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                rslCmtCd1 = ((OracleString[])sqlRslCmtCd1.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                rslCmtName1 = ((OracleString[])sqlRslCmtName1.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                rslCmtError1 = ((OracleString[])sqlRslCmtError1.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                rslCmtCd2 = ((OracleString[])sqlRslCmtCd2.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                rslCmtName2 = ((OracleString[])sqlRslCmtName2.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
                rslCmtError2 = ((OracleString[])sqlRslCmtError2.Value).Select(s => s.IsNull ? "" : s.Value).ToList();
            }

            return ret;
        }

        /// <summary>
        /// 検査結果テーブルのコメントと中止フラグを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="rslCmtCd2">結果コメント２</param>
        /// <param name="message">メッセージ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateResultForChangeSet(string rsvNo, string ipAddress, string updUser, List<string> grpCd, List<string> rslCmtCd2, List<string> message)
        {
            string sql = "";                                // SQLステートメント
            Int32 arraySize = 0;                            // 配列の要素数

            OracleParameter sqlMessage;                     // SQLメッセージ
            OracleParameter sqlRet;                         // SQL戻り値

            List<string> msg = new List<string>();          // メッセージ

            long ret2 = 0;                                  // 関数戻り値
            Insert ret = Insert.Error;                      // 関数戻り値

            using (var cmd = new OracleCommand())
            {

                // キー値及び更新値の設定
                cmd.Parameters.Add("rsvno", rsvNo);
                cmd.Parameters.Add("ipaddress", ipAddress);
                cmd.Parameters.Add("upduser", updUser);

                arraySize = grpCd.Count;
                cmd.Parameters.AddTable("grpcd", grpCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_GRP_P_GRPCD);
                cmd.Parameters.AddTable("rslcmtcd2", rslCmtCd2.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                sqlMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);

                sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // 結果更新用ストアド呼び出し
                sql = @"
                        begin :ret := resultpackage.updateresultforchangeset(
                          :rsvno
                          , :ipaddress
                          , :upduser
                          , :grpcd
                          , :rslcmtcd2
                          , :message
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の取得
                ret2 = ((OracleDecimal)sqlRet.Value).ToInt32();

                ret = Insert.Normal;

                // チェックエラー時
                if (ret2 <= 0)
                {
                    if (message != null)
                    {
                        List<string> tmpMeassage = ((OracleString[])sqlMessage.Value).Select(s => s.Value).ToList();
                        // バインド配列内容を検索し、メッセージを取得
                        for (int i = 0; i < tmpMeassage.Count; i++)
                        {
                            // メッセージが格納されていなければここで終了
                            if (string.IsNullOrEmpty(Util.ConvertToString(tmpMeassage[i])))
                            {
                                break;
                            }

                            // 配列形式で格納する
                            msg.Add(tmpMeassage[i]);
                        }

                        // 戻り値の設定(エラー時のメッセージ)
                        message = msg;
                    }

                    ret = Insert.Error;
                }

            }

            return ret;
        }

        /// <summary>
        /// 検査結果テーブルを更新する(一覧入力、例外者入力用)
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public List<string> UpdateResultList(string updUser, string ipAddress, List<string> rsvNo, List<string> itemCd, List<string> suffix, List<string> result)
        {
            List<string> message = null;

            // 直前の予約番号
            long prevRsvNo = 0;
            // １受診情報当たりの更新項目数
            long count = 0;

            using (var transaction = BeginTransaction())
            {
                for (int i = 0; i < rsvNo.Count; i++)
                {
                    // 直前の検査結果情報と予約番号が異なる場合
                    if (prevRsvNo != 0 && long.Parse(Convert.ToString(rsvNo[i])) != prevRsvNo)
                    {
                        // 検査結果レコードの更新
                        if (UpdateResultNoCmt(prevRsvNo, ipAddress, updUser, itemCd, suffix, result, message) == Insert.Error)
                        {
                            break;
                        }
                    }

                    count++;
                    // 現在の予約番号を退避
                    prevRsvNo = long.Parse(Convert.ToString(rsvNo[i]));
                }

                // エラーなく、かつスタックされた更新情報が存在する場合は検査結果レコードを更新する
                if (message == null && count > 0)
                {
                    UpdateResultNoCmt(prevRsvNo, ipAddress, updUser, itemCd, suffix, result, message);
                }


                // メッセージの有無によるトランザクション制御
                if (message == null)
                {
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }

            }

            // 戻り値の設定
            return message;
        }

        /// <summary>
        /// 検査結果テーブルを更新する(コメント更新なし)
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        /// <param name="message">メッセージ</param>
        /// <param name="checkResult">True時は検査結果のチェックを行う</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateResultNoCmt(long rsvNo, string ipAddress, string updUser, List<string> itemCd, List<string> suffix, List<string> result, List<string> message = null, bool checkResult = false)
        {
            string sql = "";                                // SQLステートメント
            Int32 arraySize = 0;                            // 配列の要素数

            OracleParameter sqlRet;                         // SQL戻り値
            OracleParameter sqlMessage;                     // SQLメッセージ

            List<string> msg = new List<string>();          // メッセージ

            long ret2 = 0;                                  // 関数戻り値
            Insert ret = Insert.Error;                      // 関数戻り値

            using (var cmd = new OracleCommand())
            {

                // キー値及び更新値の設定
                cmd.Parameters.Add("rsvno", rsvNo);
                cmd.Parameters.Add("ipaddress", ipAddress);
                cmd.Parameters.Add("upduser", updUser);
                cmd.Parameters.Add("checkresult", (checkResult ? 1 : 0));

                arraySize = itemCd.Count;
                cmd.Parameters.AddTable("itemcd", itemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                cmd.Parameters.AddTable("suffix", suffix.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                cmd.Parameters.AddTable("result", result.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, 400);

                sqlMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);

                sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // 結果更新用ストアド呼び出し
                sql = @"
                        begin :ret := resultpackage.updateresult(
                          :rsvno
                          , :ipaddress
                          , :upduser
                          , :itemcd
                          , :suffix
                          , :result
                          , :message
                          , :checkresult
                        );
                        end;
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の取得
                ret2 = ((OracleDecimal)sqlRet.Value).ToInt32();

                ret = Insert.Normal;

                // チェックエラー時
                if (ret2 <= 0)
                {
                    if (message != null)
                    {
                        List<string> tmpMeassage = ((OracleString[])sqlMessage.Value).Select(s => s.Value).ToList();
                        // バインド配列内容を検索し、メッセージを取得
                        for (int i = 0; i < tmpMeassage.Count; i++)
                        {
                            // メッセージが格納されていなければここで終了
                            if (string.IsNullOrEmpty(Util.ConvertToString(tmpMeassage[i])))
                            {
                                break;
                            }

                            // 配列形式で格納する
                            msg.Add(tmpMeassage[i]);
                        }

                        // 戻り値の設定(エラー時のメッセージ)
                        message = msg;
                    }

                    ret = Insert.Error;
                }

            }

            return ret;
        }

        /// <summary>
        /// 検査結果テーブルを更新する(コメント更新なし)
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="updUser">更新者</param>
        /// <param name="message">メッセージ</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public long UpdateYudo(long rsvNo, string updUser, List<string> message = null)
        {
            string sql = "";                                // SQLステートメント

            long ret = 0;
            OracleParameter sqlRet;
            OracleParameter sqlMessage;

            using (var cmd = new OracleCommand())
            {
                // キー値及び更新値の設定
                cmd.Parameters.Add("rsvno", rsvNo);
                cmd.Parameters.Add("upduser", updUser);

                sqlMessage = cmd.Parameters.Add("message", OracleDbType.Varchar2, ParameterDirection.Output);

                sqlRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                sql = @"
                    begin :ret := orderpackage.updateyudo(:rsvno, :upduser, :message);
                    end;
            ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);
            }

            ret = ((OracleDecimal)sqlRet.Value).ToInt32();

            return ret;
        }

        /// <summary>
        /// 指定された予約番号、検査項目コード、検索対象検査結果に該当する最も大きいサフィックスとその検査結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="results">検索対象検査結果</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        public void SelectSuffixAndResult(int rsvNo, string itemCd, string[] results, ref string suffix, ref string result)
        {
            // パラメータ値の設定
            var param = new Dictionary<string, object>()
            {
                {"rsvno", rsvNo},
                {"itemcd", itemCd},
            };

            // SQL定義
            string sql = @"
                    select
                        count(*) as cnt 
                    from
                        rsl 
                    where
                        rsvno = :rsvno 
                        and rsl.itemcd = :itemcd 
                        and rsl.result is not null
            ";

            // SQL実行
            dynamic rec = connection.Query(sql, param).FirstOrDefault();
            if (rec == null || rec.CNT == 0)
            {
                // 検査結果が登録されているレコードが存在しない場合
                suffix = "00";
                result = "";
                return;
            }

            if (results != null)
            {
                // パラメータ値の設定
                param = new Dictionary<string, object>()
                {
                    {"rsvno", rsvNo},
                    {"itemcd", itemCd},
                };

                // SQL定義
                sql = @"
                        select
                            max(rsl.suffix) suffix
                            , result 
                        from
                            rsl 
                        where
                            rsvno = :rsvno 
                            and rsl.itemcd = :itemcd 
                ";

                sql += @"                            and rsl.result in (";
                for (int i = 0; i < results.Length; i++)
                {
                    if (i > 0)
                    {
                        sql += @",";
                    }
                    sql += @":result" + (i + 1).ToString();
                    param.Add("result" + (i + 1).ToString(), results[i]);
                }
                sql += @")";

                sql += @"
                            and rsl.result is not null
                        group by
                            result
                ";

                // SQL実行
                rec = connection.Query(sql, param).FirstOrDefault();
                if (rec != null)
                {
                    // 検索対象検査結果が登録されているレコードが存在する場合は
                    // 最も大きいサフィックスとその検査結果を返す
                    suffix = rec.SUFFIX;
                    if (int.Parse(suffix) > 20)
                    {
                        suffix = "";
                    }
                    result = rec.RESULT ?? "";
                    return;
                }
            }

            // パラメータ値の設定
            param = new Dictionary<string, object>()
            {
                {"rsvno", rsvNo},
                {"itemcd", itemCd},
            };

            // SQL定義
            sql = @"
                    select
                        max(rsl.suffix) suffix 
                    from
                        rsl 
                    where
                        rsvno = :rsvno 
                        and rsl.itemcd = :itemcd 
                        and rsl.result is not null
            ";

            // SQL実行
            rec = connection.Query(sql, param).FirstOrDefault();

            // 任意の検査結果が登録されている最も大きいサフィックス +2 の値を返す
            suffix = (int.Parse(rec.SUFFIX) + 2).ToString("00");
            if (int.Parse(suffix) > 20)
            {
                suffix = "";
            }
            result = "";
            return;
        }
    }
}
