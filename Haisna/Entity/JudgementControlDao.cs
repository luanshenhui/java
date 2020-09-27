using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 判定結果制御用データアクセスオブジェクト
    /// </summary>
    public class JudgementControlDao : AbstractDao
    {
        private const string AUTOJUDUSER = "AUTOJUD";               // 自動判定ユーザ
        private const long TOTALCMT_DISPMODE = 1;                   // 総合コメント表示モード（総合コメント）
        private const long NYUBOU_JUDCLASSCD = 24;                  // 乳房　判定分類コード

        private const string DIS_COMMENT = "DIS";                   // 汎用マスターコード（婦人科以外現病歴関連総合コメント）
        private const string GYN_COMMENT = "GYN";                   // 汎用マスターコード（婦人科関連現病歴関連総合コメント）
        private const string TOT_COMMENT = "TOT";                   // 汎用マスターコード（すべて現病歴関連総合コメント）

        private const string META_CDATE_20080401 = "2008/04/01";    // メタボリックシンドローム判定ロジック適用基準日
        private const string HBA1C_CDATE_20130401 = "2013/04/01";   // HbA1c判定基準変更（HbA1c(JDS)→HbA1c(NGSP)）基準日
        private const string SMOKE_CDATE = "2008/05/01";            // 喫煙総合コメント自動登録ロジック適用基準日

        // 桁数
        private const int LENGTH_RECEIPT_DAYID = 4;                 // 当日ＩＤ

        private const string FREECD_CHG201210 = "CHG201210";        // 変更日付取得用

        /// <summary>
        /// 汎用情報アクセス
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// 判定情報アクセス
        /// </summary>
        readonly JudgementDao judgementDao;

        /// <summary>
        /// 判定情報アクセス
        /// </summary>
        readonly JudDao judDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="freeDao">汎用情報アクセス</param>
        /// <param name="judgementDao">判定情報アクセス</param>
        /// <param name="judDao">判定情報アクセス</param>
        public JudgementControlDao(IDbConnection connection, FreeDao freeDao, JudgementDao judgementDao, JudDao judDao) : base(connection)
        {
            this.freeDao = freeDao;
            this.judgementDao = judgementDao;
            this.judDao = judDao;
        }

        /// <summary>
        /// 指定された条件の計算処理を起動する
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="calcFlg">配列（Ａ型行動パターン,栄養計算,失点判定,ストレス点数, 自動判定),0:計算非対象;1:計算対象</param>
        /// <param name="dayIdFlg">1:ID 範囲指定、2:ID任意指定</param>
        /// <param name="strDayId">検索開始ＩＤ</param>
        /// <param name="endDayId">検索終了ＩＤ</param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="entryCheck">未入力チェックフラグ(0:未入力チェックしない 1:する)</param>
        /// <param name="reJudge">再判定フラグ(0:再判定しない 1:する)</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool JudgeAutomaticallyMain(string updUser, string ipAddress, string cslDate, List<long> calcFlg, long dayIdFlg, string strDayId, string endDayId, List<string> arrDayId, string csCd, string judClassCd, long entryCheck, long reJudge)
        {
            string sql = "";                    // SQLステートメント
            bool ret = false;                   // 戻り値

            long arraySize = 0;                 // 配列サイズ
            string chgDate = "";                // 切替日
            bool actNutrition = false;          // 栄養指導判定有無
            bool actEatingHabits = false; ;     // 食習慣判定有無

            // 配列数
            if (dayIdFlg == 2)
            {
                arraySize = arrDayId.Count;
            }
            else
            {
                arraySize = 1;
            }

            using (var cmd = new OracleCommand())
            {
                // キー値の設定
                cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                cmd.Parameters.Add("upduser", updUser.Trim());
                cmd.Parameters.Add("ipaddress", ipAddress);
                cmd.Parameters.Add("csldate", cslDate);
                cmd.Parameters.Add("cscd", csCd.Trim());
                cmd.Parameters.Add("dayidflg", dayIdFlg);

                if (Information.IsNumeric(strDayId) && Information.IsNumeric(endDayId))
                {
                    if (long.Parse(strDayId) <= long.Parse(endDayId))
                    {
                        cmd.Parameters.Add("strdayid", long.Parse(strDayId));
                        cmd.Parameters.Add("enddayid", long.Parse(endDayId));
                    }
                    else
                    {
                        cmd.Parameters.Add("strdayid", long.Parse(endDayId));
                        cmd.Parameters.Add("enddayid", long.Parse(strDayId));
                    }
                }
                else
                {
                    cmd.Parameters.Add("strdayid", strDayId);
                    cmd.Parameters.Add("enddayid", endDayId);
                }
                if (dayIdFlg == 2)
                {
                    cmd.Parameters.AddTable("arrdayid", arrDayId.ToArray(), ParameterDirection.Input, OracleDbType.Int32, arrDayId.Count, LENGTH_RECEIPT_DAYID);
                }
                else
                {
                    cmd.Parameters.AddTable("arrdayid", ParameterDirection.Input, OracleDbType.Int32, arrDayId.Count, LENGTH_RECEIPT_DAYID);
                }

                // 切替日の取得
                dynamic current = freeDao.SelectFree(0, FREECD_CHG201210).FirstOrDefault();
                if (current != null)
                {
                    chgDate = current.FREEFIELD1;
                }

                // 切替日以降の受診日であれば食習慣を、さもなくば栄養指導を判定
                if (!string.IsNullOrEmpty(chgDate) &&
                    DateTime.Parse(cslDate) >= DateTime.Parse(chgDate))
                {
                    actEatingHabits = true;
                }
                else
                {
                    actNutrition = true;
                }

                for (int i = 0; i <= 3; i++)
                {
                    if (calcFlg[i] == 1)
                    {
                        switch (i)
                        {   // Ａ型行動パターン
                            case 0:
                                // Ａ型行動パターン計算ストアド呼び出し

                                // SQL定義
                                sql = @"
                                        begin :ret := apatterncalcpackage.apatterncalc( 
                                          :upduser
                                          , :ipaddress
                                          , :csldate
                                          , :cscd
                                          , :dayidflg
                                          , :strdayid
                                          , :enddayid
                                          , :arrdayid
                                        ); 

                                        end; 
                                ";

                                // SQL実行
                                ExecuteNonQuery(cmd, sql);

                                break;

                            // 失点判定
                            case 1:
                                // 失点判定ストアド呼び出し

                                // SQL定義
                                sql = @"
                                        begin :ret := lostpointcalcpackage.lostpointcalc( 
                                          :upduser
                                          , :ipaddress
                                          , :csldate
                                          , :cscd
                                          , :dayidflg
                                          , :strdayid
                                          , :enddayid
                                          , :arrdayid
                                        ); 
                                        end; 
                                ";

                                // SQL実行
                                ExecuteNonQuery(cmd, sql);

                                break;

                            // 栄養計算
                            case 2:
                                // 栄養計算ストアド呼び出し
                                if (actNutrition)
                                {
                                    // SQL定義
                                    sql = @"
                                        begin :ret := nutritioncalcpackage.nutritioncalc( 
                                          :upduser
                                          , :ipaddress
                                          , :csldate
                                          , :cscd
                                          , :dayidflg
                                          , :strdayid
                                          , :enddayid
                                          , :arrdayid
                                        ); 

                                        end; 
                                    ";

                                    // SQL実行
                                    ExecuteNonQuery(cmd, sql);
                                }

                                break;

                            // ストレス点数
                            case 3:
                                // ストレス計算ストアド呼び出し

                                // SQL定義
                                sql = @"
                                        begin :ret := stresscalcpackage.stresscalc( 
                                          :upduser
                                          , :ipaddress
                                          , :csldate
                                          , :cscd
                                          , :dayidflg
                                          , :strdayid
                                          , :enddayid
                                          , :arrdayid
                                        ); 
                                        end; 
                                ";

                                // SQL実行
                                ExecuteNonQuery(cmd, sql);

                                break;
                        }
                    }
                }

                // 自動判定ロジック
                if (calcFlg[6] == 1 && DateTime.Parse(cslDate) >= DateTime.Parse(META_CDATE_20080401))
                {
                    // SQL定義
                    sql = @"
                            begin :ret := specialmetacalcpackage.specialmetacalc( 
                              :upduser
                              , :ipaddress
                              , :csldate
                              , :cscd
                              , :dayidflg
                              , :strdayid
                              , :enddayid
                              , :arrdayid
                            ); 
                            end; 
                    ";

                    // SQL実行
                    ExecuteNonQuery(cmd, sql);
                }

                // 食習慣の自動判定
                if (actEatingHabits && (calcFlg[7] == 1))
                {
                    // SQL定義
                    sql = @"
                            begin :ret := eatinghabitscalcpackage.eatinghabitscalc( 
                              :upduser
                              , :ipaddress
                              , :csldate
                              , :cscd
                              , :dayidflg
                              , :strdayid
                              , :enddayid
                              , :arrdayid
                            ); 
                            end;  
                    ";

                    // SQL実行
                    ExecuteNonQuery(cmd, sql);
                }
            }

            // 自動判定？
            if (calcFlg[4] == 1)
            {
                if (calcFlg[5] == 1)
                {
                    JudgeAutomatically(cslDate, csCd, judClassCd, dayIdFlg, strDayId, endDayId,
                        arrDayId, entryCheck, reJudge, TOT_COMMENT);
                }
                else
                {
                    JudgeAutomatically(cslDate, csCd, judClassCd, dayIdFlg, strDayId, endDayId,
                        arrDayId, entryCheck, reJudge, DIS_COMMENT);
                }
            }
            else
            {
                if (calcFlg[5] == 1)
                {
                    JToken token = new JObject();
                    token["csldate"] = cslDate;
                    token["dayidflg"] = dayIdFlg;
                    token["strdayid"] = strDayId;
                    token["enddayid"] = endDayId;
                    token["cscd"] = csCd;
                    token["discomment"] = GYN_COMMENT;

                    // 現病歴コメント（婦人科関連）コメントセット
                    judgementDao.UpdateNowDiseaseCmt(token, arrDayId);
                }
            }

            if (calcFlg[4] == 1)
            {
                // メタボリックシンドローム関連コメントセット

                JToken token = new JObject();
                token["csldate"] = cslDate;
                token["dayidflg"] = dayIdFlg;
                token["strdayid"] = strDayId;
                token["enddayid"] = endDayId;
                token["cscd"] = csCd;

                if (DateTime.Parse(cslDate) < DateTime.Parse(META_CDATE_20080401))
                {
                    judgementDao.UpdateMetaCmt(token, arrDayId);


                }
                else if (DateTime.Parse(cslDate) < DateTime.Parse(HBA1C_CDATE_20130401))
                {
                    judgementDao.UpdateMetaCmt2(token, arrDayId);
                }
                else
                {
                    judgementDao.UpdateMetaCmt3(token, arrDayId);
                }
            }

            if (!FncSortTotalJudCmtAll(DateTime.Parse(cslDate), csCd, dayIdFlg, strDayId, endDayId, arrDayId))
            {
                throw new ArgumentException();
            }

            ret = true;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 自動判定
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="dayIdFlg">1:ID 範囲指定、2:ID任意指定</param>
        /// <param name="strDayId">検索開始ＩＤ</param>
        /// <param name="endDayId">検索終了ＩＤ</param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="entryCheck">未入力チェックフラグ(0:未入力チェックしない 1:する)</param>
        /// <param name="reJudge">再判定フラグ(0:再判定しない 1:する)</param>
        /// <param name="disCheck">現病歴総合コメント区分("TOT":現病歴総合コメントすべて "DIS":婦人科以外、"GYN"：婦人科のみ)</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool JudgeAutomatically(string cslDate, string csCd, string judClassCd, long dayIdFlg, string strDayId, string endDayId, List<string> arrDayId, long entryCheck, long reJudge, string disCheck)
        {
            string sql = "";                                    // SQLステートメント
            bool ret = false;                                   // 戻り値

            long arraySize = 0;                                 // 配列サイズ
            long count = 0;                                     // レコード数
            bool localEntryCheck = false;                       // 未入力チェックフラグ
            bool localReJudge = false;                          // 再判定フラグ
            bool localTotalJudge = false;                       // 総合判定フラグ
            bool clearTotalJudgeOnly = false;                   // 総合判定のみをクリアするか
            long totalCmtPreCnt = 0;                            // 更新前レコード数

            string curRsvNo = "";                               // 現在の予約番号
            string curJudClassCd = "";                          // 現在の判定分類コード
            string curWeight = null;                              // 現在の重み
            string curJudCd = "";                               // 現在の判定コード
            string curJudCmtCd = "";                            // 現在の判定コメントコード

            List<long> updRsvNo = new List<long>();             // 予約番号
            List<long> updJudClassCd = new List<long>();        // 判定分類コード
            List<string> updJudCd = new List<string>();         // 判定コード
            List<string> updJudCmtCd = new List<string>();      // 判定コメントコード
            long updCount = 0;                                  // 更新レコード数

            List<dynamic> ttlData = new List<dynamic>();        // 更新レコード
            long totalCmtCount = 0;                             // 更新レコード数

            long hitFlg = 0;                                    // 一致チェックフラグ
            string orgMaxSeq = "";                              // 更新前MAXSEQ

            List<string> localArrDayId = new List<string>();    // 当日ＩＤ
            List<dynamic> totalCmtList = new List<dynamic>();

            if (entryCheck == 0)
            {
                localEntryCheck = false;
            }
            else
            {
                localEntryCheck = true;
            }

            if (reJudge == 0)
            {
                localReJudge = false;
            }
            else
            {
                localReJudge = true;
            }

            // 最も軽い判定を取得
            if (judDao.SelectJudLightest() == null)
            {
                throw new Exception("判定コード情報が登録されていません。");
            }

            while (true)
            {
                JToken token = new JObject();
                token["csldate"] = cslDate;
                token["dayidflg"] = dayIdFlg;
                token["strdayid"] = strDayId;
                token["enddayid"] = endDayId;
                token["cscd"] = csCd;
                token["judclasscd"] = judClassCd;

                // 判定情報クリア要否判定
                while (true)
                {

                    // 再判定も行わず、かつ総合判定も行わない場合、クリア処理は不要
                    if (!localReJudge && !localTotalJudge)
                    {
                        token["discomment"] = TOTALCMT_DISPMODE;

                        // 登録されている総合コメントを取得
                        totalCmtList = judgementDao.SelectTotalCmtList(token, arrDayId);
                        totalCmtPreCnt = totalCmtList.Count;
                        break;
                    }

                    // 総合判定のみをクリアするかそれ以外の判定分類の判定もクリアするかを判定

                    // 再判定を行うならばすべてクリア
                    if (localReJudge)
                    {
                        clearTotalJudgeOnly = false;
                    }
                    else
                    {
                        // ここへ到達するパターンは、再判定は行わないが総合判定のみを行う場合、ゆえにフラグ成立
                        clearTotalJudgeOnly = true;
                    }

                    // 判定情報のクリア処理
                    judgementDao.DeleteJudRslClearDayId(token, arrDayId, clearTotalJudgeOnly);

                    totalCmtList = judgementDao.SelectTotalCmtList(token, arrDayId);
                    totalCmtPreCnt = totalCmtList.Count;

                    break;
                }

                // 乳房判定用のコード取得
                dynamic nyubouCd = judgementDao.SelectNyubouCd();

                // デフォルト判定結果情報を作成する
                judgementDao.InsertJudRslDefaultDayId(token, arrDayId);

                // 自動判定結果の読み込み
                List<dynamic> judRslAuto = judgementDao.SelectJudRslAutomaticallyDayId(token, arrDayId, localReJudge, localEntryCheck);
                count = judRslAuto.Count;

                if (count > 0)
                {
                    //初期処理として先頭レコードの予約番号、判定分類コード、重み、判定コードを退避
                    curRsvNo = judRslAuto[0]["rsvno"];
                    curJudClassCd = judRslAuto[0]["judclasscd"];

                    // 判定情報を検索
                    for (int i = 0; i < count; i++)
                    {
                        // 直前レコードと予約番号、判定分類コードのいずれかが異なる場合
                        if (long.Parse(judRslAuto[0]["rsvno"]) != long.Parse(curRsvNo) ||
                            long.Parse(judRslAuto[0]["rsvno"]) != long.Parse(curJudClassCd))
                        {
                            if (!("0").Equals(curJudCd))
                            {
                                // 更新情報への追加
                                updRsvNo.Add(long.Parse(curRsvNo));
                                updJudClassCd.Add(long.Parse(curJudClassCd));
                                updJudCd.Add(curJudCd);
                                updJudCmtCd.Add(curJudCmtCd);
                                updCount++;

                                // 判定コメントコードあり？
                                if (!string.IsNullOrEmpty(curJudCmtCd) &&
                                    (!curJudClassCd.Equals(nyubouCd.JUDCLASSCD1) &&
                                     !curJudClassCd.Equals(nyubouCd.JUDCLASSCD2) &&
                                     !curJudClassCd.Equals(nyubouCd.JUDCLASSCD3)))
                                {
                                    hitFlg = 0;
                                    for (int j = 0; j < totalCmtPreCnt - 1; j++)
                                    {
                                        if (Util.ConvertToString(totalCmtList[j]["rsvno"]).Equals(curRsvNo))
                                        {
                                            // 既に登録されているコメント
                                            if (Util.ConvertToString(totalCmtList[j]["judcmtcd"]).Equals(curJudCmtCd))
                                            {
                                                hitFlg = 1;
                                                break;
                                            }
                                            orgMaxSeq = totalCmtList[j]["seq"];
                                        }
                                    }

                                    if (hitFlg == 0)
                                    {
                                        var ttlItem = new Dictionary<string, object>();
                                        ttlItem.Add("rsvno", curRsvNo);
                                        ttlItem.Add("judcmtcd", curJudCmtCd);
                                        ttlData.Add(ttlItem);
                                        totalCmtCount++;
                                    }
                                }
                            }

                            // 現レコードの予約番号、判定分類コードを退避
                            curRsvNo = judRslAuto[i]["rsvno"];
                            curJudClassCd = judRslAuto[i]["judclasscd"];

                            // 重み、判定コードの内容をクリア
                            curWeight = null;
                            curJudCd = null;
                            curJudCmtCd = null;

                        }

                        // 直前レコードと重み、判定コードのいずれかが異なる場合(判定クリア直後も含む)
                        if (Convert.ToInt32(judRslAuto[i]["weight"]) != Convert.ToInt32(curWeight) ||
                            Convert.ToString(judRslAuto[i]["judcd"]) != Convert.ToString(curJudCd))
                        {
                            // 重み、判定コードの内容を置き換える
                            curWeight = judRslAuto[i]["weight"];
                            curJudCd = judRslAuto[i]["judcd"];
                            curJudCmtCd = judRslAuto[i]["judcmtcd"];

                        }

                    }

                    if (!("0").Equals(curJudCd))
                    {
                        // 全検索終了後、現退避中の内容を更新情報へ追加
                        updRsvNo.Add(long.Parse(curRsvNo));
                        updJudClassCd.Add(long.Parse(curJudClassCd));
                        updJudCd.Add(curJudCd);
                        updJudCmtCd.Add(curJudCmtCd);
                        updCount++;
                    }

                    // 判定コメントコードあり？
                    if (!string.IsNullOrEmpty(curJudCmtCd) &&
                        (!curJudClassCd.Equals(nyubouCd.JUDCLASSCD1) &&
                         !curJudClassCd.Equals(nyubouCd.JUDCLASSCD2) &&
                         !curJudClassCd.Equals(nyubouCd.JUDCLASSCD3)))
                    {
                        hitFlg = 0;
                        for (int j = 0; j < totalCmtPreCnt - 1; j++)
                        {
                            if (Util.ConvertToString(totalCmtList[j]["rsvno"]).Equals(curRsvNo))
                            {
                                // 既に登録されているコメント
                                if (Util.ConvertToString(totalCmtList[j]["judcmtcd"]).Equals(curJudCmtCd))
                                {
                                    hitFlg = 1;
                                    break;
                                }
                                orgMaxSeq = totalCmtList[j]["seq"];
                            }
                        }

                        if (hitFlg == 0)
                        {
                            var ttlItem = new Dictionary<string, object>();
                            ttlItem.Add("rsvno", curRsvNo);
                            ttlItem.Add("judcmtcd", curJudCmtCd);
                            ttlData.Add(ttlItem);
                            totalCmtCount++;
                        }
                    }

                    // 判定結果テーブルレコード更新
                    if (updCount > 0)
                    {
                        judgementDao.UpdateJudRsl(updRsvNo, updJudClassCd, updJudCd, AUTOJUDUSER, updJudCmtCd, "0");
                    }

                    if (totalCmtCount > 0)
                    {
                        judgementDao.InsertTotalJudCmt(ttlData, TOTALCMT_DISPMODE);
                    }

                    // 判定分類指定無し または乳房？
                    if (!string.IsNullOrEmpty(judClassCd) ||
                        NYUBOU_JUDCLASSCD.ToString().Equals(judClassCd))
                    {

                        updCount = 0;
                        totalCmtCount = 0;

                        // 乳房判定呼び出し
                        List<dynamic> nyubouJudRsl = judgementDao.SelectNyubouJudRsl(token, arrDayId, localReJudge, localEntryCheck);
                        count = nyubouJudRsl.Count;

                        // 判定情報を検索
                        for (int i = 0; i < count; i++)
                        {
                            // 更新情報への追加
                            updRsvNo.Add(long.Parse(curRsvNo));
                            updJudClassCd.Add(long.Parse(curJudClassCd));
                            updJudCd.Add(curJudCd);
                            updJudCmtCd.Add(curJudCmtCd);
                            updCount++;

                            // 判定コメントコードあり？
                            if (!string.IsNullOrEmpty(curJudCmtCd))
                            {
                                hitFlg = 0;
                                for (int j = 0; j < totalCmtPreCnt - 1; j++)
                                {
                                    if (Util.ConvertToString(totalCmtList[j]["rsvno"]).Equals(nyubouJudRsl[i]["rsvno"]))
                                    {
                                        // 既に登録されているコメント
                                        if (Util.ConvertToString(totalCmtList[j]["judcmtcd"]).Equals(nyubouJudRsl[i]["judcmtcd"]))
                                        {
                                            hitFlg = 1;
                                            break;
                                        }
                                        orgMaxSeq = totalCmtList[j]["seq"];
                                    }
                                }

                                if (hitFlg == 0)
                                {
                                    var ttlItem = new Dictionary<string, object>();
                                    ttlItem.Add("rsvno", curRsvNo);
                                    ttlItem.Add("judcmtcd", curJudCmtCd);
                                    ttlData.Add(ttlItem);
                                    totalCmtCount++;
                                }
                            }
                        }

                        if (updCount > 0)
                        {
                            // 判定結果セット
                            judgementDao.UpdateJudRsl(updRsvNo, updJudClassCd, updJudCd, AUTOJUDUSER, updJudCmtCd, "0");
                        }

                        if (totalCmtCount > 0)
                        {
                            // 総合コメントセット
                            judgementDao.InsertTotalJudCmt(ttlData, TOTALCMT_DISPMODE);
                        }

                    }

                    using (var cmd = new OracleCommand())
                    {
                        // キー及び更新値の設定
                        cmd.Parameters.Add("ret", 0);
                        cmd.Parameters.Add("csldate", cslDate);
                        cmd.Parameters.Add("cscd", csCd.Trim());
                        cmd.Parameters.Add("judclasscd", dayIdFlg);
                        cmd.Parameters.Add("dayidflg", dayIdFlg);

                        // 当日ID範囲指定？
                        if (Information.IsNumeric(dayIdFlg) && Information.IsNumeric(endDayId))
                        {
                            if (long.Parse(strDayId) <= long.Parse(endDayId))
                            {
                                cmd.Parameters.Add("strdayid", long.Parse(strDayId));
                                cmd.Parameters.Add("enddayid", long.Parse(endDayId));
                            }
                            else
                            {
                                cmd.Parameters.Add("strdayid", long.Parse(endDayId));
                                cmd.Parameters.Add("enddayid", long.Parse(strDayId));
                            }
                        }
                        else
                        {
                            cmd.Parameters.Add("strdayid", strDayId);
                            cmd.Parameters.Add("enddayid", endDayId);
                        }

                        // 配列数
                        if (dayIdFlg == 2)
                        {
                            arraySize = arrDayId.Count;
                        }
                        else
                        {
                            arraySize = 1;
                        }

                        // OraParameterオブジェクトの値設定
                        if (("2").Equals(strDayId))
                        {
                            localArrDayId = arrDayId;
                        }
                        if (dayIdFlg == 2)
                        {
                            cmd.Parameters.AddTable("arrdayid", arrDayId.ToArray(), ParameterDirection.Input, OracleDbType.Int32, arrDayId.Count, LENGTH_RECEIPT_DAYID);
                        }
                        else
                        {
                            cmd.Parameters.AddTable("arrdayid", ParameterDirection.Input, OracleDbType.Int32, arrDayId.Count, LENGTH_RECEIPT_DAYID);
                        }

                        // 未入力チェックしない場合
                        if (!localEntryCheck)
                        {
                            entryCheck = 0;
                        }
                        else
                        {
                            entryCheck = 1;
                        }
                        cmd.Parameters.Add("entrycheck", entryCheck);

                        // 再判定でない場合
                        if (!localReJudge)
                        {
                            reJudge = 0;
                        }
                        else
                        {
                            reJudge = 1;
                        }
                        cmd.Parameters.Add("rejudge", reJudge);

                        // 判定特殊処理呼び出し
                        sql = @"
                                begin :ret := specialjudcalcpackage.specialjudcalc( 
                                  :csldate
                                  , :cscd
                                  , :judclasscd
                                  , :entrycheck
                                  , :rejudge
                                  , :dayidflg
                                  , :strdayid
                                  , :enddayid
                                  , :arrdayid
                                ); 
                                end;
                        ";

                        // SQL実行
                        ExecuteNonQuery(cmd, sql);

                    }

                    // 生活指導コメントをセットする
                    judgementDao.UpdateLifeGuideMsg(token, arrDayId);

                    if (DateTime.Parse(cslDate) >= DateTime.Parse(SMOKE_CDATE))
                    {
                        // 喫煙情報によって総合コメントをセットする
                        judgementDao.UpdateSmokeGuideMsg(token, arrDayId);
                    }

                    // 現病歴コメント（婦人科以外）をセットする
                    token["discomment"] = disCheck;
                    judgementDao.UpdateNowDiseaseCmt(token, arrDayId);

                    // 内視鏡コメントをセットする
                    judgementDao.UpdateNaishikyouCmt(token, arrDayId);

                    // 良好コメントをセットする
                    judgementDao.UpdateGoodCmt(token, arrDayId);

                    // 判定結果の入っていないものクリア
                    judgementDao.DeleteNullJudRslClearDayId(token, arrDayId, clearTotalJudgeOnly);

                    break;
                }
            }

            // 戻り値の設定
            ret = true;

            return ret;

        }

        /// <summary>
        /// 判定結果を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="doctorCd">判定医コード</param>
        /// <param name="userId">ユーザーＩＤ</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="judCd">判定コード</param>
        /// <param name="doctorCds">判定医コード</param>
        /// <param name="freeJudCmt">フリー判定コメント</param>
        /// <param name="stdJudCds">定型所見コード</param>
        /// <param name="judCmtCd">判定コメントコード</param>
        /// <param name="guidanceCd">指導文章コード</param>
        /// <returns>
        /// true 正常終了
        /// flase 異常終了
        /// </returns>
        public bool UpdateJudRsl(string rsvNo, string doctorCd, string userId, List<string> judClassCd, List<string> judCd, List<string> doctorCds, List<string> freeJudCmt, List<string> stdJudCds, List<string> judCmtCd, List<string> guidanceCd)
        {
            string sql = "";                                // SQLステートメント
            bool ret = false;                               // 戻り値

            long arraySize = 0;                             // 更新レコード配列数
            List<long> arrRsvNo = new List<long>();         // 予約番号の配列
            string[] stdJudCd;                              // 編集用定型所見コード

            // オブジェクトのインスタンス作成
            // #ToDo 「ConsultDao未作成」をどうするか
            //Consult consult = new Consult();

            // 判定分類コードが配列の場合
            if (judClassCd != null)
            {
                // 判定コード・判定医コード・フリー判定コメント・定型所見コードが配列でない場合は処理終了
                if (judCd == null ||
                    doctorCds == null ||
                    freeJudCmt == null ||
                    stdJudCds == null ||
                    judCmtCd == null ||
                    guidanceCd == null)
                {

                    throw new ArgumentOutOfRangeException();
                }

                // 判定コード・判定医コード・フリー判定コメント・定型所見コードが一致しない場合は処理終了
                if (judClassCd.Count != judCd.Count ||
                    judClassCd.Count != doctorCds.Count ||
                    judClassCd.Count != freeJudCmt.Count ||
                    judClassCd.Count != stdJudCds.Count ||
                    judClassCd.Count != judCmtCd.Count ||
                    judClassCd.Count != guidanceCd.Count)
                {

                    throw new ArgumentOutOfRangeException();
                }
                else
                {
                    // 判定コード・判定医コード・フリー判定コメント・定型所見コードが配列の場合は処理終了
                    if (judCd != null ||
                        doctorCds != null ||
                        freeJudCmt != null ||
                        stdJudCds != null ||
                        judCmtCd != null ||
                        guidanceCd != null)
                    {
                        {
                            throw new ArgumentException();
                        }
                    }
                }
            }

            // 予約番号を配列化
            for (int i = 0; i < judClassCd.Count; i++)
            {
                arrRsvNo.Add(long.Parse("0" + rsvNo));
            }

            // #ToDo 「ConsultDao未作成」をどうするか
            // 判定医コード更新
            // objConsult.UpdateConsultDoctor strRsvNo, strDoctorCd, strUserId

            // 判定分類コードの配列が存在、かつ１つ目の配列が数値なら判定結果の格納処理を行う
            if (judClassCd.Count > 0 && Information.IsNumeric(judClassCd[0]))
            {
                judgementDao.InsertJudRslWithUpdate(arrRsvNo, judClassCd, judCd, judCmtCd, null, "0");
            }

            // 判定所見情報の編集
            arraySize = 0;
            List<string> judClassCd_c = new List<string>();
            List<string> stdJudCd_c = new List<string>();
            JArray items = new JArray();
            for (int i = 0; i < judClassCd.Count; i++)
            {
                if (!string.IsNullOrEmpty(stdJudCds[i]))
                {
                    stdJudCd = stdJudCds[i].Split(',');
                    for (int j = 0; j < stdJudCd.Length; j++)
                    {
                        JObject item = new JObject();
                        item["rsvno"] = long.Parse("0" + rsvNo);
                        item["judclasscd"] = judClassCd[i];
                        item["stdjudcd"] = stdJudCd[i];
                        items.Add(item);
                        arraySize++;
                    }
                }
            }

            // 判定所見テーブルレコードの挿入
            if (arraySize > 0)
            {
                judgementDao.InsertJudRsl_C(items);
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", long.Parse(rsvNo));

            // 指定予約番号の判定情報テーブルレコードを削除
            sql = @"
                    delete judrsl 
                    where
                      rsvno = :rsvno 
                      and judcd is null 
                      and doctorcd is null 
                      and judcmtcd is null 
                      and guidancecd is null 
                      and freejudcmt is null
                ";

            connection.Execute(sql, param);

            ret = true;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 総合判定コメントの並び替え（ＳＥＱ再設定）
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="dayIdFlg">1:ID 範囲指定、2:ID任意指定</param>
        /// <param name="strDayId">検索開始ＩＤ</param>
        /// <param name="endDayId">検索終了ＩＤ</param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool FncSortTotalJudCmtAll(DateTime cslDate, string csCd, long dayIdFlg, string strDayId, string endDayId, List<string> arrDayId)
        {
            string sql = "";                // SQLステートメント
            bool ret = false;               // 戻り値
            int arraySize = 0;             // 配列数

            using (var cmd = new OracleCommand())
            {

                cmd.Parameters.Add("csldate", cslDate);
                cmd.Parameters.Add("cscd", csCd.Trim());
                cmd.Parameters.Add("dayidflg", dayIdFlg);

                // 当日ID範囲指定？
                if (Information.IsNumeric(strDayId) && Information.IsNumeric(endDayId))
                {
                    if (long.Parse(strDayId) <= long.Parse(endDayId))
                    {
                        cmd.Parameters.Add("strdayid", long.Parse(strDayId));
                        cmd.Parameters.Add("enddayid", long.Parse(endDayId));
                    }
                    else
                    {
                        cmd.Parameters.Add("strdayid", long.Parse(endDayId));
                        cmd.Parameters.Add("enddayid", long.Parse(strDayId));
                    }
                }
                else
                {
                    cmd.Parameters.Add("strdayid", strDayId);
                    cmd.Parameters.Add("enddayid", endDayId);
                }

                // 配列数
                if (dayIdFlg == 2)
                {
                    arraySize = arrDayId.Count;
                }
                else
                {
                    arraySize = 1;
                }

                if (dayIdFlg == 2)
                {
                    cmd.Parameters.AddTable("arrdayid", arrDayId.ToArray(), ParameterDirection.Input, OracleDbType.Int32, arraySize, LENGTH_RECEIPT_DAYID);
                }
                else
                {
                    cmd.Parameters.AddTable("arrdayid", arrDayId.ToArray(), ParameterDirection.Input, OracleDbType.Int32, arraySize, LENGTH_RECEIPT_DAYID);
                }

                cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                sql = @"
                        begin :ret := specialjudcalcpackage.sorttotaljudcmtall( 
                              :csldate
                              , :cscd
                              , :dayidflg
                              , :strdayid
                              , :enddayid
                              , :arrdayid
                        ); 
                        end; 
                ";

                // SQL実行
                ExecuteNonQuery(cmd, sql);

            }

            ret = true;

            // 戻り値の設定
            return ret;
        }

    }

}