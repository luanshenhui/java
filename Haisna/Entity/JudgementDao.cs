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
    /// 判定結果情報データアクセスオブジェクト
    /// </summary>
    public class JudgementDao : AbstractDao
    {
        private const string GDECMT_GRPCD = "X051";         // 生活指導コメント導出用グループコード
        private const string DISEASECMT_GRPCD = "X055";     // 現病歴コメント導出用グループコード

        // メタボリックシンドローム判定コメント特殊処理用
        private const string METACMT_GRPCD = "X068";        // メタボリックシンドロームコメント導出用グループコード

        // 喫煙コメント自動登録処理用グループコード設定
        private const string SMKCMT_GRPCD = "X054";         // 喫煙コメント導出用グループコード

        private const long GDECMT_DISPMODE = 2;             // 総合コメント表示モード（生活指導）
        private const long TOTALCMT_DISPMODE = 1;           // 総合コメント表示モード（総合コメント）
        private const string KNOWLEVEL_ITEMCD = "64670";    // 認識レベル　検査項目コード
        private const string KNOWLEVEL_SUFFIX = "00";     // 認識レベル　サフィックス
        private const long NYUBOU_JUDCLASSCD = 24;          // 乳房　判定分類コード

        // 眼科判定特殊処理用
        private const long GANKA_JUDCLASSCD = 20;           // 眼科・眼圧　判定分類コード
        private const string ATSU_ITEMCD = "11161";         // 眼圧　検査項目コード
        private const string RAGAN_ITEMCD = "11020";        // 裸眼　検査項目コード
        private const string KYOU_ITEMCD = "11022";         // 矯正　検査項目コード

        // 内視鏡判定コメント特殊処理用
        private const string TOP_ITEMCD = "23200";          // 内視鏡上部　検査項目コード
        private const string TOP_SUFFIX = "00";             // 内視鏡上部　サフィックス
        private const string LOWER1_ITEMCD = "23710";       // 内視鏡下部　主治医の指示　検査項目コード
        private const string LOWER1_SUFFIX = "00";          // 内視鏡下部　主治医の指示　サフィックス
        private const string LOWER2_ITEMCD = "23711";       // 内視鏡下部　次回内視鏡健保　検査項目コード
        private const string LOWER2_SUFFIX = "00";        // 内視鏡下部　次回内視鏡健保　サフィックス

        // メタボリックシンドローム判定コメント特殊処理用
        private const string METACMT_CMTCD = "105001";      // メタボリックシンドロームコメントコード
        private const string METACMT_CMTCD2 = "105002";     // メタボリックシンドロームコメントコード２
        private const string GLYCEMIA_ITEMCD = "17520";     // 空腹時血糖　検査項目コード
        private const string GLYCEMIA_SUFFIX = "00";        // 空腹時血糖　サフィックス
        private const string HDL_ITEMCD = "17423";          // HDL　検査項目コード
        private const string HDL_SUFFIX = "00";           // HDL　サフィックス
        private const string TG_ITEMCD = "17420";           // TG　検査項目コード
        private const string TG_SUFFIX = "00";            // TG　サフィックス
        private const string CBP_ITEMCD = "13120";          // 収縮期血圧　検査項目コード
        private const string CBP_SUFFIX = "01";           // 収縮期血圧　サフィックス
        private const string EBP_ITEMCD = "13120";          // 拡張期血圧　検査項目コード
        private const string EBP_SUFFIX = "02";             // 拡張期血圧　サフィックス
        private const string WAIST_ITEMCD = "10041";        // 腹囲　検査項目コード
        private const string WAIST_SUFFIX = "00";           // 腹囲　サフィックス

        // メタボリックシンドローム判定ロジック
        private const string METACMT_NEWCD = "105005";      // メタボリックシンドロームコメントコード（基準に該当）
        private const string METACMT_NEWCD2 = "105004";     // メタボリックシンドロームコメントコード２（予備群に該当）
        private const string METACMT_NEWCD3 = "105003";     // メタボリックシンドロームコメントコード３（該当しない）
        private const string HBA1C_ITEMCD = "17522";        // HbA1c(JDS)　検査項目コード
        private const string HBA1C_SUFFIX = "00";           // HbA1c(JDS)　サフィックス
        private const string HBA1C_NGSP_ITEMCD = "17524";   // HbA1c(NGSP)　検査項目コード
        private const string HBA1C_NGSP_SUFFIX = "00";      // HbA1c(NGSP)　サフィックス

        // 骨密度判定特殊処理用
        private const long KOTSU_JUDCLASSCD = 23;           // 骨密度　判定分類コード
        private const string TSCORE_ITEMCD = "26615";       // Ｔスコア　検査項目コード
        private const string TSCORE_SUFFIX = "00";          // Ｔスコア　サフィックス
        private const string SMOKE_ITEMCD = "63070";        // 喫煙　検査項目コード
        private const string SMOKE_SUFFIX = "00";           // 喫煙　サフィックス
        private const string KOTSU_CMTCD_D1 = "102303";     // 骨密度（D1）コメントコード

        /// <summary>
        /// 判定情報アクセス
        /// </summary>
        readonly JudDao judDao;

        /// <summary>
        /// 定型所見クラス
        /// </summary>
        readonly StdJudDao stdJudDao;

        /// <summary>
        /// ユーザクラス
        /// </summary>
        readonly HainsUserDao hainsUserDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">Oracleコンテキスト</param>
        /// <param name="judDao">判定情報アクセス</param>
        /// <param name="stdJudDao">定型所見クラス</param>
        /// <param name="hainsUserDao">ユーザクラス</param>
        public JudgementDao(IDbConnection connection, JudDao judDao, StdJudDao stdJudDao, HainsUserDao hainsUserDao) : base(connection)
        {
            this.judDao = judDao;
            this.stdJudDao = stdJudDao;
            this.hainsUserDao = hainsUserDao;
        }

        /// <summary>
        /// 判定入力チェック
        /// </summary>
        /// <param name="doctorCd">判定医コード</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="judClassName">判定分類名称</param>
        /// <param name="judCd">判定コード</param>
        /// <param name="stdJudCd">定型所見コード</param>
        /// <param name="freeJudCmt">フリー判定コード</param>
        /// <param name="judDoctorCd">判定医コード</param>
        /// <returns>エラーメッセージ</returns>
        public List<dynamic> CheckValue(string doctorCd, List<string> judClassCd, List<string> judClassName, List<string> judCd, List<string> stdJudCd, List<string> freeJudCmt, List<string> judDoctorCd)
        {

            List<dynamic> messages = new List<dynamic>();   // エラーメッセージの集合

            // 判定分類が配列の場合
            if (judClassCd != null)
            {
                // 判定分類名・判定コード・定型所見コード・フリー判定コメント・判定医コードが配列でない場合は処理終了
                if ((judClassName == null) || (judCd == null) ||
                   (stdJudCd == null) || (freeJudCmt == null) ||
                   (judDoctorCd == null))
                {
                    throw new ArgumentOutOfRangeException();
                }
                // 判定分類名・判定コード・定型所見コード・フリー判定コメント・判定医コードのサイズが一致しない場合は処理終了
                if ((judClassCd.Count != judClassName.Count) ||
                    (judClassCd.Count != judCd.Count) ||
                    (judClassCd.Count != stdJudCd.Count) ||
                    (judClassCd.Count != freeJudCmt.Count) ||
                    (judClassCd.Count != judDoctorCd.Count))
                {
                    throw new ArgumentOutOfRangeException();
                }
            }
            else
            {
                // 判定分類名・判定コード・定型所見コード・フリー判定コメント・判定医コードが配列の場合は処理終了
                if ((judClassName != null) || (judCd != null) ||
                    (stdJudCd != null) || (freeJudCmt != null) ||
                    (judDoctorCd != null))
                {
                    throw new ArgumentException();
                }
            }

            if (!string.IsNullOrEmpty(doctorCd))
            {
                // 判定医コードチェック
                if (hainsUserDao.SelectUserName(doctorCd) == null)
                {
                    messages.Add("登録されていない判定医コードです");
                }
            }

            for (int i = 0; i < judClassCd.Count; i++)
            {
                if (!string.IsNullOrEmpty(judCd[i]))
                {
                    // 判定コードチェック
                    if (judDao.SelectJud(judCd[i]) == null)
                    {
                        messages.Add(judClassName[i] + ":登録されていない判定コードです");
                    }
                }
                if (!string.IsNullOrEmpty(stdJudCd[i]))
                {
                    string[] localStdJudCd = judCd[i].Split(',');
                    for (int j = 0; j < localStdJudCd.Length; j++)
                    {
                        if (string.IsNullOrEmpty(stdJudDao.SelectStdJudNote(judClassCd[i], stdJudCd[j])))
                        {
                            messages.Add(judClassName[i] + ":" + stdJudCd[j] + ":登録されていない定型所見コードです");
                        }
                    }
                }
                // フリー判定コメントチェック
                messages.Add(WebHains.CheckWideValue(judClassName[i] + ":コメント", freeJudCmt[i], Convert.ToInt16(LengthConstants.LENGTH_JUDRSL_FREEJUDCMT)));
                if (!string.IsNullOrEmpty(judDoctorCd[i]))
                {
                    // 判定医コードチェック
                    if (hainsUserDao.SelectUserName(judDoctorCd[i], "1") == null)
                    {
                        messages.Add(judClassName[i] + ":登録されていない判定医コードです");
                    }
                }
            }

            // 戻り値の設定
            return messages;
        }

        /// <summary>
        /// 判定結果テーブルレコードを削除する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteJudRsl(long rsvNo)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の判定情報テーブルレコードを削除
            sql = @"
                    delete judrsl 
                    where
                      rsvno = :rsvno
            ";

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 判定結果をクリアする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// perid 個人ID
        /// cscd コースコード
        /// judclasscd 判定分類コード
        /// </param>
        /// <param name="totalJudgeOnly">True時、総合判定用判定分類の判定結果のみクリア</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteJudRslClear(JToken data, bool totalJudgeOnly)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["perid"]).Trim()))
            {
                param.Add("perid", Convert.ToInt64(data["perid"]));
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["perid"]).Trim()))
            {
                param.Add("judclasscd", Convert.ToInt64(data["judclasscd"]));
            }

            // クリアすべき判定結果情報を検索
            sql = @"
                    delete judrsl 
                    where
                      (rsvno, judclasscd) in ( 
                        select
                          consult.rsvno
                          , curjudrsl.judclasscd 
                        from
                          judclass
                          , judrsl curjudrsl
                          , consult
                          , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                        where
                          receipt.csldate = :csldate 
                          and receipt.rsvno = consult.rsvno
            ";

            // 個人ID指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["perid"]).Trim()))
            {
                sql += @"
                          and consult.perid >= :perid
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                          and consult.cscd = :cscd
                ";
            }

            // 対象受診者の現判定結果情報を取得
            sql += @"
                          and consult.rsvno = curjudrsl.rsvno
            ";

            // 判定分類の総合判定フラグを取得
            sql += @"
                          and curjudrsl.judclasscd = judclass.judclasscd
            ";

            // 総合判定用判定分類は無条件にクリア対象とする
            // フラグ非成立時は判定分類内検査項目が基準値判定情報を所有している場合にクリア対象とする
            if (totalJudgeOnly)
            {
                sql += @"
                          and judclass.alljudflg = 1)
                ";
            }
            else
            {

                if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
                {
                    // 判定分類が指定されている場合
                    sql += @"
                                and ( 
                                        judclass.alljudflg = 1 
                                        or ( 
                                            curjudrsl.judclasscd = :judclasscd 
                                            and exists ( 
                                                            select
                                                            stdvalue.itemcd 
                                                            from
                                                            item_jud
                                                            , stdvalue 
                                                            where
                                                            stdvalue.itemcd = item_jud.itemcd 
                                                            and item_jud.judclasscd = curjudrsl.judclasscd 
                                                            and stdvalue.strdate <= consult.csldate 
                                                            and stdvalue.enddate >= consult.csldate 
                                                            and ( 
                                                                    stdvalue.cscd is null 
                                                                    or stdvalue.cscd = consult.cscd
                                                                )
                                                        )
                                            )
                                    ) 
                            )
                    ";
                }
                else
                {
                    // 判定分類が指定されていない場合
                    sql += @"
                                and ( 
                                      judclass.alljudflg = 1 
                                      or exists ( 
                                                    select
                                                        stdvalue.itemcd 
                                                    from
                                                        item_jud
                                                        , stdvalue 
                                                    where
                                                        stdvalue.itemcd = item_jud.itemcd 
                                                        and item_jud.judclasscd = curjudrsl.judclasscd 
                                                        and stdvalue.strdate <= consult.csldate 
                                                        and stdvalue.enddate >= consult.csldate 
                                                        and ( 
                                                            stdvalue.cscd is null 
                                                            or stdvalue.cscd = consult.cscd
                                                            )
                                                )
                                    )
                                )
                    ";
                }
            }

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 判定結果をクリアする（当日ID指定可）
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// judclasscd 判定分類コード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="totalJudgeOnly">True時、総合判定用判定分類の判定結果のみクリア</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteJudRslClearDayId(JToken data, List<string> arrDayId, bool totalJudgeOnly)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]).Trim());
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                param.Add("judclasscd", Convert.ToInt64(data["judClassCd"]));
            }

            // クリアすべき判定結果情報を検索
            sql = @"
                    delete judrsl 
                    where
                      (rsvno, judclasscd) in ( 
                        select
                          consult.rsvno
                          , curjudrsl.judclasscd 
                        from
                          judclass
                          , judrsl curjudrsl
                          , consult
                          , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                        where
                          receipt.csldate = :csldate 
                          and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                and receipt.dayid >= :strdayid 
                                and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                    ,
                        ";
                    }
                    sql += @"
                                    :dayid" + i;
                }
                sql += @"
                                        ) ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                and consult.cscd = :cscd
                ";
            }

            // 対象受診者の現判定結果情報を取得
            sql += @"
                                and consult.rsvno = curjudrsl.rsvno
            ";

            // 判定分類の総合判定フラグを取得
            sql += @"
                                and curjudrsl.judclasscd = judclass.judclasscd
            ";

            // 総合判定用判定分類は無条件にクリア対象とする
            // フラグ非成立時は判定分類内検査項目が基準値判定情報を所有している場合にクリア対象とする
            if (totalJudgeOnly)
            {
                sql += @"
                                and judclass.alljudflg = 1)
                ";
            }
            else
            {
                if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
                {
                    // 判定分類が指定されている場合
                    sql += @"
                                    and ( 
                                          judclass.alljudflg = 1 
                                          or ( 
                                                curjudrsl.judclasscd = :judclasscd 
                                                and exists ( 
                                                              select
                                                                stdvalue.itemcd 
                                                              from
                                                                item_jud
                                                                , stdvalue 
                                                              where
                                                                stdvalue.itemcd = item_jud.itemcd 
                                                                and item_jud.judclasscd = curjudrsl.judclasscd 
                                                                and stdvalue.strdate <= consult.csldate 
                                                                and stdvalue.enddate >= consult.csldate 
                                                                and ( 
                                                                      stdvalue.cscd is null 
                                                                      or stdvalue.cscd = consult.cscd
                                                                    )
                                                            )
                                              )
                                        ) 
                            )
                    ";
                }
                else
                {
                    // 判定分類が指定されていない場合
                    sql += @"
                                        and ( 
                                              judclass.alljudflg = 1 
                                              or exists ( 
                                                            select
                                                              stdvalue.itemcd 
                                                            from
                                                              item_jud
                                                              , stdvalue 
                                                            where
                                                              stdvalue.itemcd = item_jud.itemcd 
                                                              and item_jud.judclasscd = curjudrsl.judclasscd 
                                                              and stdvalue.strdate <= consult.csldate 
                                                              and stdvalue.enddate >= consult.csldate 
                                                              and ( 
                                                                    stdvalue.cscd is null 
                                                                    or stdvalue.cscd = consult.cscd
                                                                  )
                                                        )
                                            )
                            )
                    ";

                }
            }

            connection.Execute(sql, param);

            // 総合コメントクリア
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE);
            sql = @"
                    delete totaljudcmt 
                    where
                      (rsvno) in (
                                    select
                                      consult.rsvno 
                                    from
                                      consult
                                      , receipta
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                                    where
                                      receipt.csldate = :csldate 
                                      and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                      and receipt.dayid >= :strdayid 
                                      and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                      and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                        ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                      )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                and consult.cscd = :cscd
                ";
            }

            sql += @"
                                and dispmode = :dispmode
            ";

            // 判定分類が指定されている場合、当該判定分類のコメントと良好コメントを削除する
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                sql += @"
                                and ( 
                                      exists ( 
                                                select
                                                  judclasscd 
                                                from
                                                  judcmtstc 
                                                where
                                                  judcmtcd = totaljudcmt.judcmtcd 
                                                  and judclasscd = :judclasscd
                                              ) 
                                      or ( 
                                            judcmtcd = ( 
                                                          select
                                                            free.freefield1 judcmtcd 
                                                          from
                                                            free 
                                                          where
                                                            freecd = 'GOODCMT'
                                                        )
                                          )
                                    ) 

                ";
            }

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 判定結果がNullのものをクリアする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// judclasscd 判定分類コード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="totalJudgeOnly">True時、総合判定用判定分類の判定結果のみクリア</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteNullJudRslClearDayId(JToken data, List<string> arrDayId, bool totalJudgeOnly)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]).Trim());
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                param.Add("judclasscd", Convert.ToInt64(data["judclasscd"]));
            }

            // クリアすべき判定結果情報を検索
            sql = @"
                    delete judrsl 
                    where
                      (rsvno, judclasscd) in ( 
                        select
                          consult.rsvno
                          , curjudrsl.judclasscd 
                        from
                          judclass
                          , judrsl curjudrsl
                          , consult
                          , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                        where
                          receipt.csldate = :csldate 
                          and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                and receipt.dayid >= :strdayid 
                                and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                        ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                and consult.cscd = :cscd
                ";
            }

            // 対象受診者の現判定結果情報を取得
            sql += @"
                                and consult.rsvno = curjudrsl.rsvno
                ";

            // 判定分類の総合判定フラグを取得
            sql += @"
                                and curjudrsl.judclasscd = judclass.judclasscd
            ";

            // 判定結果、更新者がNullのもの
            sql += @"
                                and curjudrsl.judcd is null 
                                and curjudrsl.upduser is null
            ";

            // 総合判定用判定分類は無条件にクリア対象とする
            // フラグ非成立時は判定分類内検査項目が基準値判定情報を所有している場合にクリア対象とする
            if (totalJudgeOnly)
            {
                sql += @"
                                and judclass.alljudflg = 1 )
                ";
            }
            else
            {
                // 判定分類が指定されている場合
                if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
                {
                    // 乳房の場合
                    if (NYUBOU_JUDCLASSCD.ToString().Equals(Util.ConvertToString(data["judclasscd"]).Trim()))
                    {
                        // 乳房判定用のコード取得
                        dynamic current = SelectNyubouCd();
                        param.Add("nyujudclasscd1", Convert.ToInt64(current.JUDCLASSCD1));
                        param.Add("nyujudclasscd2", Convert.ToInt64(current.JUDCLASSCD2));
                        param.Add("nyujudclasscd3", Convert.ToInt64(current.JUDCLASSCD3));
                        param.Add("nyujudclasscd", Convert.ToInt64(NYUBOU_JUDCLASSCD));

                        sql += @"
                                        and ( 
                                              judclass.alljudflg = 1 
                                              or curjudrsl.judclasscd in ( 
                                                                            :judclasscd
                                                                            , :nyujudclasscd1
                                                                            , :nyujudclasscd2
                                                                            , :nyujudclasscd3
                                                                          )
                                            )
                                )
                        ";
                    }
                    else
                    {
                        sql += @"
                                        and ( 
                                              judclass.alljudflg = 1 
                                              or curjudrsl.judclasscd = :judclasscd
                                            ) 
                                )

                        ";
                    }
                }
                else
                {
                    sql += @"
                              )
                    ";
                }
            }

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// 判定結果テーブルレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// rsvno 予約番号
        /// judclasscd 判定分類コード
        /// judcd 判定コード
        /// doctorcd 判定医コード
        /// freejudcmt フリー判定コメント
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertJudRsl(JToken data)
        {
            string sql = "";                        // SQLステートメント

            Insert ret = Insert.Error;

            List<JToken> items = data.ToList<JToken>();

            // キー及び更新値の設定
            var sqlParamArray = new List<Dictionary<string, object>>();
            for (int i = 0; i < items.Count; i++)
            {
                var param = new Dictionary<string, object>();
                param.Add("rsvno", Convert.ToInt64(items[i]["rsvno"]));
                param.Add("judclasscd", Convert.ToInt64(items[i]["judclasscd"]));
                param.Add("judcd", Util.ConvertToString(items[i]["judcd"]));
                param.Add("doctorcd", Util.ConvertToString(items[i]["doctorcd"]));
                param.Add("freejudcmt", Util.ConvertToString(items[i]["freejudcmt"]));

                sqlParamArray.Add(param);
            }

            // 判定結果テーブルレコードの挿入
            sql = @"
                    insert 
                    into judrsl(
                        rsvno
                        ,judclasscd
                        ,judcd
                        ,doctorcd
                        ,freejudcmt) 
                    values ( 
                      :rsvno
                      , :judclasscd
                      , :judcd
                      , :doctorcd
                      , :freejudcmt
                    ) 
            ";

            connection.Execute(sql, sqlParamArray);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 判定所見テーブルレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// rsvno 予約番号
        /// judclasscd 判定分類コード
        /// stdjudcd 定型所見コード
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertJudRsl_C(JToken data)
        {
            string sql = "";            // SQLステートメント

            Insert ret = Insert.Error;

            List<JToken> items = data.ToList<JToken>();

            // キー及び更新値の設定
            var sqlParamArray = new List<Dictionary<string, object>>();
            for (int i = 0; i < items.Count; i++)
            {
                var param = new Dictionary<string, object>();
                param.Add("rsvno", Convert.ToInt64(items[i]["rsvno"]));
                param.Add("judclasscd", Convert.ToInt64(items[i]["judclasscd"]));
                param.Add("stdjudcd", Convert.ToInt64(items[i]["stdjudcd"]));
            }

            // 判定所見テーブルレコードの挿入
            sql = @"
                    insert 
                    into judrsl_c(
                        rsvno
                        , judclasscd
                        , stdjudcd
                    ) 
                    values (
                        :rsvno
                        , :judclasscd
                        , :stdjudcd
                    )
            ";

            connection.Execute(sql, sqlParamArray);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定条件を満たす受診情報のデフォルト判定結果情報を作成する
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// perid 個人ID
        /// cscd コースコード
        /// judclasscd 判定分類コード
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertJudRslDefault(JToken data)
        {
            string sql = "";            // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["perid"]).Trim()))
            {
                param.Add("perid", Convert.ToInt64(data["perid"]));
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                param.Add("judclasscd", Convert.ToInt64(data["judclasscd"]));
            }

            // 判定結果テーブルレコードの挿入
            sql = @"
                    insert 
                    into judrsl(
                        rsvno
                        , judclasscd)
            ";

            // 受診情報より挿入対象となる判定分類を求める
            sql += @"
                    select
                        consult.rsvno
                        , course_jud.judclasscd 
                    from
                        course_jud
                        , consult
                        , receipt 
                    where
                        receipt.csldate = :csldate 
                        and receipt.rsvno = consult.rsvno
            ";

            // 個人ID指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["perid"]).Trim()))
            {
                sql += @"
                        and consult.perid >= :perid
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                        and consult.cscd = :cscd
                ";
            }

            // コースに属する判定分類を求める
            sql += @"
                        and consult.cscd = course_jud.cscd
            ";

            // 判定分類指定時は条件節に追加
            sql += @"
                        and course_jud.judclasscd = :judclasscd
            ";

            // すでにレコードが存在する予約番号、判定分類の組み合わせは除外
            sql += @"
                        and not exists ( 
                          select
                            rsvno 
                          from
                            judrsl 
                          where
                            rsvno = consult.rsvno 
                            and judclasscd = course_jud.judclasscd
                        ) 
            ";

            // 自動展開フラグが立っている、或いは判定分類内の検査項目が健診結果に存在するかを判定
            sql += @"
                        and ( 
                          course_jud.noreason = 1 
                          or exists ( 
                            select
                              rsl.rsvno 
                            from
                              item_jud
                              , rsl 
                            where
                              rsl.rsvno = consult.rsvno 
                              and rsl.itemcd = item_jud.itemcd 
                              and item_jud.judclasscd = course_jud.judclasscd
                          )
                        ) 
            ";

            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定条件を満たす受診情報のデフォルト判定結果情報を作成する（当日ＩＤ指定）
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// judclasscd 判定分類コード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertJudRslDefaultDayId(JToken data, List<string> arrDayId)
        {
            string sql = "";            // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, Convert.ToInt64(arrDayId[i]));
                }
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                param.Add("judclasscd", Convert.ToInt64(data["judclasscd"]));
            }

            // 判定結果テーブルレコードの挿入
            sql = @"
                    insert 
                    into judrsl(
                        rsvno
                        , judclasscd)
            ";

            // 受診情報より挿入対象となる判定分類を求める
            sql += @"
                    select
                      consult.rsvno
                      , course_jud.judclasscd 
                    from
                      course_jud
                      , consult
                      , receipt 
                    where
                      receipt.csldate = :csldate 
                      and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                            and receipt.dayid >= :strdayid 
                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                            and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                    ,
                        ";
                    }
                    sql += @"
                                    :dayid" + i;
                }
                sql += @"
                            )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                        and consult.cscd = :cscd
                ";
            }

            // コースに属する判定分類を求める
            sql += @"
                        and consult.cscd = course_jud.cscd
            ";

            // 乳房判定用のコード取得
            dynamic current = SelectNyubouCd();
            param.Add("nyujudclasscd1", Convert.ToInt64(current.JUDCLASSCD1));
            param.Add("nyujudclasscd2", Convert.ToInt64(current.JUDCLASSCD2));
            param.Add("nyujudclasscd3", Convert.ToInt64(current.JUDCLASSCD3));
            param.Add("nyujudclasscd", Convert.ToInt64(NYUBOU_JUDCLASSCD));

            // 判定分類指定時は条件節に追加
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                if (NYUBOU_JUDCLASSCD.ToString().Equals(Util.ConvertToString(data["judclasscd"]).Trim()))
                {
                    sql += @"
                                and course_jud.judclasscd in ( 
                                  :judclasscd
                                  , :nyujudclasscd1
                                  , :nyujudclasscd2
                                  , :nyujudclasscd3
                                ) 
                    ";
                }
                else
                {
                    sql += @"
                                and course_jud.judclasscd = :judclasscd
                    ";
                }
            }

            // すでにレコードが存在する予約番号、判定分類の組み合わせは除外
            sql += @"
                        and not exists ( 
                          select
                            rsvno 
                          from
                            judrsl 
                          where
                            rsvno = consult.rsvno 
                            and judclasscd = course_jud.judclasscd
                        ) 
            ";

            // 自動展開フラグが立っている、或いは判定分類内の検査項目が健診結果に存在するかを判定
            sql += @"
                        and ( 
                          course_jud.noreason = 1 
                          or exists ( 
                            select
                              rsl.rsvno 
                            from
                              item_jud
                              , rsl 
                            where
                              rsl.rsvno = consult.rsvno 
                              and rsl.itemcd = item_jud.itemcd 
                              and item_jud.judclasscd = course_jud.judclasscd
                        ) 
            ";

            // 乳房は触診、Ｘ線、超音波のいずれかの依頼があれば対象となる
            sql += @"
                        or ( 
                          exists ( 
                            select
                              rsl.rsvno 
                            from
                              item_jud
                              , rsl 
                            where
                              rsl.rsvno = consult.rsvno 
                              and rsl.itemcd = item_jud.itemcd 
                              and item_jud.judclasscd in ( 
                                :nyujudclasscd1
                                , :nyujudclasscd2
                                , :nyujudclasscd3
                              )
                          ) 
                          and course_jud.judclasscd = :nyujudclasscd
                        ) 
            ";

            // 乳房ダミー判定分類は必ず作る
            sql += @"
                        or course_jud.judclasscd = :nyujudclasscd1 
                        or course_jud.judclasscd = :nyujudclasscd2 
                        or course_jud.judclasscd = :nyujudclasscd3)
            ";

            connection.Execute(sql, param);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人ＩＤの判定結果情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="cslDate">指定受診日（以前）</param>
        /// <returns>
        /// rsvno 予約番号
        /// csldate 受診日
        /// csname コース名
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名称
        /// judsname 略称
        /// stdjudnote 定型所見名称
        /// freejudcmt フリー判定コメント
        /// guidancestc 指導内容
        /// judcmtstc 判定コメント
        /// </returns>
        public List<dynamic> SelectHistoryJudRslList(string perId, string cslDate)
        {
            string sql = "";            // SQLステートメント

            // 個人ＩＤ・表示開始受診日が設定されていない場合はエラー
            if (string.IsNullOrEmpty(perId) || string.IsNullOrEmpty(cslDate))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", perId.Trim());
            param.Add("csldate", cslDate.Trim());

            // 検索条件を満たす判定結果のレコードを取得
            sql = @"
                    select
                        jl.rsvno
                        , jl.csldate
                        , jl.csname
                        , jl.judclasscd
                        , jl.judclassname
                        , jl.judsname
                        , jl.stdjudnote
                        , jl.freejudcmt
                        , jl.guidancestc
                        , jl.judcmtstc 
                    from
                        ( 
                        select
                            cn.rsvno
                            , cn.csldate
                            , cn.cscd
                            , cp.csname
                            , jc.judclasscd
                            , jc.judclassname
                            , jd.judsname
                            , sj.stdjudnote
                            , jr.freejudcmt
                            , guidance.guidancestc
                            , judcmtstc.judcmtstc 
                        from
                            consult cn
                            , course_p cp
                            , judrsl jr
                            , judclass jc
                            , jud jd
                            , judrsl_c rc
                            , stdjud sj
                            , guidance
                            , judcmtstc 
                        where
                            cn.perid = :perid 
                            and cn.csldate < :csldate 
                            and cn.rsvno = jr.rsvno 
                            and cn.cscd = cp.cscd 
                            and jr.judclasscd = jc.judclasscd 
                            and jr.judcd = jd.judcd(+) 
                            and jr.rsvno = rc.rsvno(+) 
                            and jr.judclasscd = rc.judclasscd(+) 
                            and rc.judclasscd = sj.judclasscd(+) 
                            and rc.stdjudcd = sj.stdjudcd(+) 
                            and jr.guidancecd = guidance.guidancecd(+) 
                            and jr.judcmtcd = judcmtstc.judcmtcd(+)
                        ) jl 
                    order by
                        jl.csldate desc
                        , jl.judclasscd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 予約番号の判定結果情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名称
        /// judsname 略称
        /// stdjudnote 定型所見名称
        /// freejudcmt フリー判定コメント
        /// </returns>
        public List<dynamic> SelectInquiryJudRslList(string rsvNo)
        {
            string sql = "";            // SQLステートメント

            // 予約番号が設定されていない場合はエラー
            if (string.IsNullOrEmpty(rsvNo))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo.Trim());

            // 検索条件を満たす判定結果のレコードを取得
            sql = @"
                    select
                      jl.judclasscd
                      , jl.judclassname
                      , jl.judsname
                      , jl.stdjudnote
                      , jl.freejudcmt 
                    from
                      ( 
                        select
                          cn.cscd
                          , jc.judclasscd
                          , jc.judclassname
                          , jd.judsname
                          , '' stdjudnote
                          , '' freejudcmt 
                        from
                          consult cn
                          , course_p cp
                          , judrsl jr
                          , judclass jc
                          , jud jd
                          , judrsl_c rc 
                        where
                          cn.rsvno = :rsvno 
                          and cn.rsvno = jr.rsvno 
                          and cn.cscd = cp.cscd 
                          and jr.judclasscd = jc.judclasscd 
                          and jr.judcd = jd.judcd(+) 
                          and jr.rsvno = rc.rsvno(+) 
                          and jr.judclasscd = rc.judclasscd(+)
                      ) jl 
                    order by
                      jl.judclasscd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 予約番号の判定結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="secondFlg">２次健診対象フラグ(RSLSECOND_NONE:２次健診は表示しない;RSLSECOND_ALL :２次健診も表示する)</param>
        /// <returns>
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名称
        /// noreason 自動展開フラグ(0:自動展開しない 1:自動展開する)
        /// judcd 判定コード
        /// befjudsname 前回判定略称
        /// doctorcd 判定医コード
        /// doctorname 判定医名
        /// freejudcmt フリー判定コメント
        /// stdjudcd 定型所見コード
        /// stdjudnot 定型所見名称
        /// judcmtcd 判定コメントコード
        /// judcmtstc 判定コメント
        /// guidancecd 指導内容コード
        /// guidancestc 指導内容
        /// </returns>
        public List<dynamic> SelectJudRslList(string rsvNo, string csCd, string secondFlg)
        {
            string sql = "";                                // SQLステートメント

            List<dynamic> retData = new List<dynamic>();    // 戻り値

            // 予約番号・コースコードが設定されていない場合はエラー
            if (string.IsNullOrEmpty(rsvNo) || string.IsNullOrEmpty(csCd))
            {
                throw new ArgumentException();
            }
            if (!RslSecond.None.ToString().Equals(secondFlg) && !RslSecond.All.ToString().Equals(secondFlg))
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new OracleDynamicParameters();
            param.Add("rsvno", rsvNo.Trim());
            if (RslSecond.None.ToString().Equals(secondFlg))
            {
                param.Add("secondflg", SCourse.First.ToString());
            }
            else
            {
                param.Add("secondflg", SCourse.Second.ToString());
            }

            param.Add("cursor_judrsl", dbType: OracleDbType.RefCursor, direction: ParameterDirection.InputOutput);

            // SQL定義
            sql = @"
                    begin
                      judgementpackage.selectjudrsllist(
                        :rsvno
                        , :secondflg
                        , :cursor_judrsl
                      ); 
                    end; 
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            // 検索レコードが存在する場合
            if (current.Count > 0)
            {
                // 配列形式で格納する
                for (int i = 0; i < current.Count; i++)
                {
                    retData.Add(new
                    {
                        judclasscd = current[i]["judclasscd"],
                        judclassname = current[i]["judclassname"],
                        noreason = current[i]["noreason"],
                        judcd = current[i]["judcd"],
                        befjudsname = current[i]["befjudsname"],
                        doctorcd = current[i]["doctorcd"],
                        doctorname = current[i]["doctorname"],
                        freejudcmt = current[i]["freejudcmt"],
                        stdjudcd = "",
                        stdjudnote = "",
                        judcmtcd = current[i]["judcmtcd"],
                        judcmtstc = current[i]["judcmtstc"],
                        guidancecd = current[i]["guidancecd"],
                        guidancestc = current[i]["guidancestc"],
                    });
                }
            }

            if (retData.Count > 0)
            {
                List<string> stdJudCd = new List<string>();
                List<string> stdJudNot = new List<string>();

                for (int i = 0; i < retData.Count; i++)
                {
                    //キー及び更新値の設定
                    var paramSel = new Dictionary<string, object>();
                    paramSel.Add("rsvno", rsvNo.Trim());
                    paramSel.Add("judclasscd", retData[i]["judclasscd"].Trim());

                    // 検索条件を満たす判定所見のレコードを取得
                    sql = @"
                            select
                              jc.judclasscd
                              , jc.stdjudcd
                              , sj.stdjudnote 
                            from
                              judrsl_c jc
                              , stdjud sj 
                            where
                              jc.rsvno = :rsvno 
                              and jc.judclasscd = :judclasscd 
                              and jc.judclasscd = sj.judclasscd 
                              and jc.stdjudcd = sj.stdjudcd
                    ";
                    List<dynamic> currentSel = connection.Query(sql, param).ToList();

                    // 検索レコードが存在する場合
                    if (currentSel.Count > 0)
                    {
                        for (int j = 0; j < currentSel.Count; j++)
                        {
                            stdJudCd.Add(currentSel[j]["stdjudcd"]);
                            stdJudNot.Add(currentSel[j]["stdjudnote"]);
                        }

                        retData[i]["stdjudcd"] = string.Join(",", stdJudCd);
                        retData[i]["stdjudnote"] = string.Join(",", stdJudNot);
                    }

                }

            }

            // 戻り値の設定
            return retData;
        }

        /// <summary>
        /// 自動判定結果を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="lightestWeight">最も軽い判定の重み</param>
        /// <param name="lightestJudCd">最も軽い判定コード</param>
        /// <param name="reJudge">再判定フラグ</param>
        /// <param name="entryCheck">未入力チェックフラグ</param>
        /// <returns>
        /// rsvno 予約番号
        /// judclasscd 判定分類コード
        /// weight 重み
        /// judcd 判定コード
        /// judcmtstc 判定コメント文章
        /// </returns>
        public List<dynamic> SelectJudRslAutomatically(DateTime cslDate, string perId, string csCd, string judClassCd, long lightestWeight, string lightestJudCd, bool reJudge, bool entryCheck)
        {
            string sql = "";            // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            if (!string.IsNullOrEmpty(Util.ConvertToString(perId).Trim()))
            {
                param.Add("perid", long.Parse(perId));

            }
            param.Add("cscd", csCd.Trim());
            if (!string.IsNullOrEmpty(judClassCd) && !string.IsNullOrEmpty(judClassCd.Trim()))
            {
                param.Add("judclasscd", long.Parse(judClassCd));
            }

            // 検索条件を満たす受診情報から判定分類および基準値判定を検索する
            sql = @"
                    select distinct
                      consult.rsvno
                      , item_jud.judclasscd
                      , jud.weight
                      , stdvalue_c.judcd
                      , judcmtstc.judcmtstc
            ";

            // 取得に要する表の定義
            sql += @"
                    from
                      judcmtstc
                      , jud
                      , stdvalue_c
                      , judclass
                      , course_jud
                      , item_jud
                      , rsl
                      , consult
                      , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                    where
                      receipt.csldate = :csldate 
                      and receipt.rsvno = consult.rsvno
            ";

            // 個人ID指定時は条件節に加える
            if (!string.IsNullOrEmpty(perId) && !string.IsNullOrEmpty(perId.Trim()))
            {
                sql += @"
                            and consult.perid = :perid
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd) && !string.IsNullOrEmpty(csCd.Trim()))
            {
                sql += @"
                          and consult.cscd = :cscd
                ";
            }

            // 結果未入力の検査項目は判定対象としない
            sql += @"
                      and consult.rsvno = rsl.rsvno 
                      and rsl.result is not null
            ";

            // ある判定分類に属する検査項目を対象とする
            sql += @"
                      and rsl.itemcd = item_jud.itemcd
            ";

            // 判定分類指定時は条件節に追加
            if (!string.IsNullOrEmpty(judClassCd) && !string.IsNullOrEmpty(judClassCd.Trim()))
            {
                sql += @"
                         and item_jud.judclasscd = :judclasscd
                ";
            }

            // 検査項目から求まる判定分類が受診コースの判定分類として存在する場合に判定対象とする
            sql += @"
                        and consult.cscd = course_jud.cscd 
                        and item_jud.judclasscd = course_jud.judclasscd
            ";

            // 総合判定用の判定分類はここでは対象としない
            sql += @"
                        and item_jud.judclasscd = judclass.judclasscd 
                        and judclass.alljudflg = 0
            ";

            // コメント表示のみの分類コードは対象外
            // 自動判定対象外のものも通常判定ではないものも対象としない
            sql += @"
                        and judclass.commentonly is null 
                        and judclass.notautoflg is null 
                        and judclass.notnormalflg is null
            ";

            // 再判定でない場合、すでに判定が存在する判定分類は対象としない
            if (!reJudge)
            {
                sql += @"
                            and not exists ( 
                            select
                                curjudrsl.rsvno 
                            from
                                judrsl curjudrsl 
                            where
                                curjudrsl.rsvno = consult.rsvno 
                                and curjudrsl.judclasscd = item_jud.judclasscd 
                                and curjudrsl.judcd is not null
                            ) 
                ";
            }

            // 基準値判定情報をもつ検査項目のみを判定対象とする
            sql += @"
                        and exists ( 
                          select
                            itemcd 
                          from
                            stdvalue 
                          where
                            itemcd = rsl.itemcd 
                            and suffix = rsl.suffix 
                            and strdate <= consult.csldate 
                            and enddate >= consult.csldate 
                            and (cscd is null or cscd = consult.cscd)
                        ) 
            ";

            // 現レコードの判定分類に属する検査項目のうち未入力項目が存在するかをチェック
            if (entryCheck)
            {
                // 本ブロックで指定判定分類に属する検査項目の検査結果レコードを取得
                sql += @"
                            and not exists ( 
                              select
                                entrycheck_rsl.rsvno 
                              from
                                item_p
                                , item_jud entrycheck_item_jud
                                , rsl entrycheck_rsl 
                              where
                                entrycheck_rsl.rsvno = consult.rsvno 
                                and entrycheck_rsl.itemcd = entrycheck_item_jud.itemcd 
                                and entrycheck_item_jud.judclasscd = item_jud.judclasscd 
                                and entrycheck_rsl.itemcd = item_p.itemcd
                ";

                // 「分画項目が１つでも入力されていれば検査完了」の場合、同一依頼項目で入力済みの検査結果が１つも存在しなければ未入力とみなす
                sql += @"
                            and ( 
                              ( 
                                item_p.entryok = 0 
                                and not exists ( 
                                  select
                                    check_rsl.rsvno 
                                  from
                                    rslcmt rslcmt1
                                    , rslcmt rslcmt2
                                    , rsl check_rsl 
                                  where
                                    check_rsl.rsvno = entrycheck_rsl.rsvno 
                                    and check_rsl.itemcd = entrycheck_rsl.itemcd 
                                    and check_rsl.rslcmtcd1 = rslcmt1.rslcmtcd(+) 
                                    and check_rsl.rslcmtcd2 = rslcmt2.rslcmtcd(+) 
                                    and ( 
                                      check_rsl.result is not null 
                                      or rslcmt1.entryok = 1 
                                      or rslcmt2.entryok = 1
                                )
                              )
                            ) 
                ";

                // 「全ての分画項目が入力されれば検査完了」の場合、同一依頼項目で未入力の検査結果が１つでも存在すれば未入力とみなす
                sql += @"
                                or ( 
                                    item_p.entryok = 1 
                                    and exists ( 
                                                select
                                                    check_rsl.rsvno 
                                                from
                                                    rslcmt rslcmt1
                                                    , rslcmt rslcmt2
                                                    , rsl check_rsl 
                                                where
                                                    check_rsl.rsvno = entrycheck_rsl.rsvno 
                                                    and check_rsl.itemcd = entrycheck_rsl.itemcd 
                                                    and check_rsl.rslcmtcd1 = rslcmt1.rslcmtcd(+) 
                                                    and check_rsl.rslcmtcd2 = rslcmt2.rslcmtcd(+) 
                                                    and check_rsl.result is null 
                                                    and nvl(rslcmt1.entryok, 0) = 0 
                                                    and nvl(rslcmt2.entryok, 0) = 0
                                                )
                                )
                            )
                        )
                ";
            }

            // ここまでの条件を満たす検査項目の基準値判定情報から判定コードと重み、及び判定コメントコードを取得する
            sql += @"
                        and rsl.stdvaluecd = stdvalue_c.stdvaluecd(+) 
                        and stdvalue_c.judcd = jud.judcd(+)
            ";

            // 判定コメントコードをもとに対象判定分類の判定コメントを取得する
            sql += @"
                        and stdvalue_c.judcmtcd = judcmtstc.judcmtcd(+)
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定条件を満たす総合コメントを取得する（当日ＩＤ指定）
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// dispmode コメント種別
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// rsvno 予約番号
        /// maxseq SEQ
        /// judcmtcd 判定コメントコード
        /// </returns>
        public List<dynamic> SelectTotalCmtList(JToken data, List<string> arrDayId)
        {
            string sql = "";            // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, Convert.ToInt64(arrDayId[i]));
                }
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            param.Add("dispmode", Convert.ToInt64(data["dispmode"]));

            // 総合コメントクリア
            sql = @"
                    select
                      rsvno
                      , seq
                      , judcmtcd 
                    from
                      totaljudcmt 
                    where
                      (rsvno) in (
                                    select
                                      consult.rsvno
                                    from
                                      consult
                                      , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                                    where
                                      receipt.csldate = :csldate 
                                      and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                      and receipt.dayid >= :strdayid 
                                      and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                      and receipt.dayid in (
                ";

                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                        ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }

                sql += @"
                                      )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                      and consult.cscd = :cscd
                ";
            }

            sql += @"
                                  )
                                      and dispmode = :dispmode
            ";

            sql += @"
                        order by
                          rsvno
                          , seq
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 自動判定結果を取得する（当日ＩＤ指定）
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// judclasscd 判定分類コード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="reJudge">再判定フラグ</param>
        /// <param name="entryCheck">未入力チェックフラグ</param>
        /// <returns>
        /// rsvno 予約番号
        /// judclasscd 判定分類コード
        /// weight 重み
        /// judcd 判定コード
        /// judcmtstc 判定コメント文章
        /// judcmtcd 判定コメントコード
        /// </returns>
        public List<dynamic> SelectJudRslAutomaticallyDayId(JToken data, List<string> arrDayId, bool reJudge, bool entryCheck)
        {
            string sql = "";            // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, Convert.ToInt64(arrDayId[i]));
                }
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());

            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                param.Add("judclasscd", Convert.ToInt64(data["judclasscd"]));
            }

            // 検索条件を満たす受診情報から判定分類および基準値判定を検索する
            sql = @"
                select distinct
                    consult.rsvno
                    , item_jud.judclasscd
                    , nvl(jud.weight, '0') weight
                    , nvl(stdvalue_c.judcd, '0') judcd
                    , judcmtstc.judcmtstc
                    , stdvalue_c.judcmtcd
            ";

            // 取得に要する表の定義
            sql += @"
                    from
                      judcmtstc
                      , jud
                      , stdvalue_c
                      , judclass
                      , course_jud
                      , item_jud
                      , rsl
                      , consult
                      , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                    where
                      receipt.csldate = :csldate 
                      and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                            and receipt.dayid >= :strdayid 
                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                           and receipt.dayid in (
                ";

                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                     ,
                        ";
                    }
                    sql += @"
                                     :dayid" + i;
                }

                sql += @"
                           )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                            and consult.cscd = :cscd
                ";
            }

            // 結果未入力の検査項目は判定対象としない
            sql += @"
                            and consult.rsvno = rsl.rsvno 
                            and rsl.result is not null
            ";

            // ある判定分類に属する検査項目を対象とする
            sql += @"
                            and rsl.itemcd = item_jud.itemcd
            ";

            // 判定分類指定時は条件節に追加
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["judclasscd"]).Trim()))
            {
                if (NYUBOU_JUDCLASSCD.ToString().Equals(Util.ConvertToString(data["judclasscd"])))
                {
                    // 乳房判定用のコード取得
                    dynamic current = SelectNyubouCd();
                    param.Add("nyujudclasscd1", Convert.ToInt64(current.JUDCLASSCD1));
                    param.Add("nyujudclasscd2", Convert.ToInt64(current.JUDCLASSCD2));
                    param.Add("nyujudclasscd3", Convert.ToInt64(current.JUDCLASSCD3));
                    param.Add("nyujudclasscd", Convert.ToInt64(NYUBOU_JUDCLASSCD));
                    // 判定分類指定時は条件節に追加
                    sql += @"
                                and item_jud.judclasscd in ( 
                                  :judclasscd
                                  , :nyujudclasscd1
                                  , :nyujudclasscd2
                                  , :nyujudclasscd3
                                ) 
                    ";
                }
                else
                {
                    sql += @"
                                and item_jud.judclasscd = :judclasscd
                    ";
                }
            }

            // 検査項目から求まる判定分類が受診コースの判定分類として存在する場合に判定対象とする
            sql += @"
                                and consult.cscd = course_jud.cscd 
                                and item_jud.judclasscd = course_jud.judclasscd
            ";

            // 総合判定用の判定分類はここでは対象としない
            sql += @"
                                and item_jud.judclasscd = judclass.judclasscd 
                                and judclass.alljudflg = 0
            ";

            // 自動判定対象外のものも通常判定ではないものも対象としない
            sql += @"
                                and judclass.notautoflg is null 
                                and judclass.notnormalflg is null
            ";

            // 再判定でない場合、すでに判定が存在する判定分類は対象としない
            if (!reJudge)
            {
                sql += @"
                                and not exists ( 
                                  select
                                    curjudrsl.rsvno 
                                  from
                                    judrsl curjudrsl 
                                  where
                                    curjudrsl.rsvno = consult.rsvno 
                                    and curjudrsl.judclasscd = item_jud.judclasscd 
                                    and curjudrsl.judcd is not null
                                ) 
                ";
            }

            // 基準値判定情報をもつ検査項目のみを判定対象とする
            sql += @"
                                and exists ( 
                                  select
                                    itemcd 
                                  from
                                    stdvalue 
                                  where
                                    itemcd = rsl.itemcd 
                                    and suffix = rsl.suffix 
                                    and strdate <= consult.csldate 
                                    and enddate >= consult.csldate 
                                    and (cscd is null or cscd = consult.cscd)
                                ) 
            ";

            // 現レコードの判定分類に属する検査項目のうち未入力項目が存在するかをチェック
            if (entryCheck)
            {
                // 本ブロックで指定判定分類に属する検査項目の検査結果レコードを取得
                sql += @"
                                and not exists ( 
                                  select
                                    entrycheck_rsl.rsvno 
                                  from
                                    item_p
                                    , item_jud entrycheck_item_jud
                                    , rsl entrycheck_rsl 
                                  where
                                    entrycheck_rsl.rsvno = consult.rsvno 
                                    and entrycheck_rsl.itemcd = entrycheck_item_jud.itemcd 
                                    and entrycheck_item_jud.judclasscd = item_jud.judclasscd 
                                    and entrycheck_rsl.itemcd = item_p.itemcd
                ";

                //「分画項目が１つでも入力されていれば検査完了」の場合、同一依頼項目で入力済みの検査結果が１つも存在しなければ未入力とみなす
                sql += @"
                                and ( 
                                  ( 
                                    item_p.entryok = 0 
                                    and not exists ( 
                                      select
                                        check_rsl.rsvno 
                                      from
                                        rslcmt rslcmt1
                                        , rslcmt rslcmt2
                                        , rsl check_rsl 
                                      where
                                        check_rsl.rsvno = entrycheck_rsl.rsvno 
                                        and check_rsl.itemcd = entrycheck_rsl.itemcd 
                                        and check_rsl.rslcmtcd1 = rslcmt1.rslcmtcd(+) 
                                        and check_rsl.rslcmtcd2 = rslcmt2.rslcmtcd(+) 
                                        and ( 
                                          check_rsl.result is not null 
                                          or rslcmt1.entryok = 1 
                                          or rslcmt2.entryok = 1
                                    )
                                  )
                                ) 
                ";

                // 「全ての分画項目が入力されれば検査完了」の場合、同一依頼項目で未入力の検査結果が１つでも存在すれば未入力とみなす
                sql += @"
                                or ( 
                                      item_p.entryok = 1 
                                      and exists ( 
                                                    select
                                                      check_rsl.rsvno 
                                                    from
                                                      rslcmt rslcmt1
                                                      , rslcmt rslcmt2
                                                      , rsl check_rsl 
                                                    where
                                                      check_rsl.rsvno = entrycheck_rsl.rsvno 
                                                      and check_rsl.itemcd = entrycheck_rsl.itemcd 
                                                      and check_rsl.rslcmtcd1 = rslcmt1.rslcmtcd(+) 
                                                      and check_rsl.rslcmtcd2 = rslcmt2.rslcmtcd(+) 
                                                      and check_rsl.result is null 
                                                      and nvl(rslcmt1.entryok, 0) = 0 
                                                      and nvl(rslcmt2.entryok, 0) = 0
                                                  )
                                    )
                                )
                            )
                ";
            }

            // ここまでの条件を満たす検査項目の基準値判定情報から判定コードと重み、及び判定コメントコードを取得する
            sql += @"
                                and rsl.stdvaluecd = stdvalue_c.stdvaluecd(+) 
                                and stdvalue_c.judcd = jud.judcd(+)
            ";

            // 判定コメントコードをもとに対象判定分類の判定コメントを取得する
            sql += @"
                                and stdvalue_c.judcmtcd = judcmtstc.judcmtcd(+)
            ";

            //
            sql += @"
                    order by
                      rsvno
                      , judclasscd
                      , weight
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の判定入力状態を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>判定入力状態</returns>
        public string SelectJudgementStatus(long rsvNo)
        {
            string sql = "";  // SQLステートメント
            string ret = "";  // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の判定入力状態を取得する
            sql = @"
                    select
                      checkresultpackage.checkexistsnojudgement(:rsvno) entriedjudgement 
                    from
                      dual
            ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 存在した場合
            if (current != null)
            {
                ret = current.ENTRIEDJUDGEMENT;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定予約番号の判定入力状態を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>判定入力状態</returns>
        public string SelectJudgementStatusAuto(long rsvNo)
        {
            string sql = "";  // SQLステートメント
            string ret = "";  // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の判定入力状態を取得する
            sql = @"
                    select
                      checkresultpackage.checkexistsnojudgementauto(:rsvno) entriedjudgement 
                    from
                      dual
            ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 存在した場合
            if (current != null)
            {
                ret = Convert.ToString(current.ENTRIEDJUDGEMENT);
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定予約番号の判定入力状態を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>判定入力状態</returns>
        public string SelectJudgementStatusManual(long rsvNo)
        {
            string sql = "";  // SQLステートメント
            string ret = "";  // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定予約番号の判定入力状態を取得する
            sql = @"
                    select
                      checkresultpackage.checkexistsnojudgementmanual(:rsvno) entriedjudgement 
                    from
                      dual
            ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 存在した場合
            if (current != null)
            {
                ret = Convert.ToString(current.ENTRIEDJUDGEMENT);
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 乳房判定用のコードを取得する
        /// </summary>
        /// <returns>
        /// itemcd1 検査項目コード＋サフィックス（触診）
        /// itemcd2 検査項目コード＋サフィックス（Ｘ線）
        /// itemcd3 検査項目コード＋サフィックス（超音波）
        /// judclasscd1 判定分類コード（触診）
        /// judclasscd2 判定分類コード（Ｘ線）
        /// judclasscd3 判定分類コード（超音波）
        /// </returns>
        public dynamic SelectNyubouCd()
        {
            // 指定予約番号の判定入力状態を取得する
            string sql = @"
                            select
                              freefield1 itemcd1
                              , freefield2 itemcd2
                              , freefield3 itemcd3
                              , freefield4 judclasscd1
                              , freefield5 judclasscd2
                              , freefield6 judclasscd3 
                            from
                              free 
                            where
                              freecd = 'NYUBOU'
                ";

            // SQL実行
            return connection.Query(sql).FirstOrDefault();
        }

        /// <summary>
        /// 乳房判定結果を取得する（当日ＩＤ指定）
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="reJudge"></param>
        /// <param name="entryCheck"></param>
        /// <returns>
        /// rsvno 予約番号
        /// judclasscd 判定分類コード
        /// judcd 判定コード
        /// judcmtcd 判定コメントコード
        /// </returns>
        public List<dynamic> SelectNyubouJudRsl(JToken data, List<string> arrDayId, bool reJudge, bool entryCheck)
        {
            string sql = "";                            // SQLステートメント
            List<dynamic> ret = new List<dynamic>();    // 戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            param.Add("judclasscd", NYUBOU_JUDCLASSCD);
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, Convert.ToInt64(arrDayId[i]));
                }
            }
            param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());

            // 検索条件を満たす予約番号を検索する
            sql = @"
                    select
                      consult.rsvno
                      , judrsl.judcd 
                    from
                      consult
                      , course_jud
                      , judrsl
                      , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                    where
                      receipt.csldate = :csldate 
                      and receipt.rsvno = consult.rsvno 
                      and judrsl.rsvno = consult.rsvno 
                      and judrsl.judclasscd = :judclasscd
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                            and receipt.dayid >= :strdayid 
                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                           and receipt.dayid in (
                ";

                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                     ,
                        ";
                    }
                    sql += @"
                                     :dayid" + i;
                }

                sql += @"
                           )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                            and consult.cscd = :cscd
                ";
            }

            // 乳房判定分類が受診コースの判定分類として存在する場合に判定対象とする
            sql += @"
                        and consult.cscd = course_jud.cscd 
                        and course_jud.judclasscd = :judclasscd
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            if (current.Count > 0)
            {
                // 各配列値の更新処理
                for (int i = 0; i < current.Count; i++)
                {
                    dynamic selectNyubouJudCd = SelectNyubouJudCd(current[i]["rsvno"]);

                    // 検索レコードが存在する場合
                    if (selectNyubouJudCd != null &&
                        !string.IsNullOrEmpty(selectNyubouJudCd.JUDCD))
                    {
                        // 再判定ではなく既に判定が入っている場合は上書きしない
                        if (!reJudge && !string.IsNullOrEmpty(current[i]["judcd"]))
                        {
                        }
                        else
                        {
                            // 配列形式で格納する
                            ret.Add(new
                            {
                                rsvno = current[i]["rsvno"],
                                judclasscd = NYUBOU_JUDCLASSCD,
                                judcd = selectNyubouJudCd.JUDCD,
                                judcmtcd = selectNyubouJudCd.JUDCMTCD,
                            });

                        }
                    }
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定予約番号の乳房判定結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// judcd 判定コード
        /// judcmtcd 判定コメントコード
        /// </returns>
        public string SelectNyubouJudCd(long rsvNo)
        {
            string sql = "";  // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // グループ１：乳房触診のみ、グループ２：乳房Ｘ線、グループ３：乳房超音波、グループ４：乳房触診＋乳房Ｘ線　それ以外は通常の乳房判定
            sql = @"
                    select
                      nyuboujudview.judcd
                      , nyuboujudview.judcmtcd 
                    from
                      ( 
                        select
                          case 
                            when nyujud1.itemcount = 1 
                            and nyujud2.itemcount = 0 
                            and nyujud3.itemcount = 0 
                              then 1 
                            when nyujud1.itemcount = 0 
                            and nyujud2.itemcount = 1 
                            and nyujud3.itemcount = 0 
                              then 2 
                            when nyujud1.itemcount = 0 
                            and nyujud2.itemcount = 0 
                            and nyujud3.itemcount = 1 
                              then 3 
                            when nyujud1.itemcount = 1 
                            and nyujud2.itemcount = 1 
                            and nyujud3.itemcount = 0 
                              then 4 
                            when nyujud1.itemcount = 1 
                            and nyujud2.itemcount = 0 
                            and nyujud3.itemcount = 1 
                              then 5 
                            else 0 
                            end grpno
            ";

            // 判定パターンを決める検査項目の有無
            sql += @"
                            from
                              ( 
                                select
                                  count(*) itemcount 
                                from
                                  rsl
                                  , free 
                                where
                                  free.freecd = 'NYUBOU' 
                                  and free.freefield1 = rsl.itemcd || '-' || rsl.suffix 
                                  and rsl.stopflg is null 
                                  and rsl.rsvno = :rsvno
                              ) nyujud1
                              , ( 
                                select
                                  count(*) itemcount 
                                from
                                  rsl
                                  , free 
                                where
                                  free.freecd = 'NYUBOU' 
                                  and free.freefield2 = rsl.itemcd || '-' || rsl.suffix 
                                  and rsl.stopflg is null 
                                  and rsl.rsvno = :rsvno
                              ) nyujud2
                              , ( 
                                select
                                  count(*) itemcount 
                                from
                                  rsl
                                  , free 
                                where
                                  free.freecd = 'NYUBOU' 
                                  and free.freefield3 = rsl.itemcd || '-' || rsl.suffix 
                                  and rsl.stopflg is null 
                                  and rsl.rsvno = :rsvno
                              ) nyujud3
                    ) grpview,
            ";

            // それぞれのパターンの判定結果取得
            sql += @"
                            ( 
                              ( 
                                select
                                  2 grpno
                                  , judcd
                                  , judcmtcd 
                                from
                                  judrsl
                                  , free 
                                where
                                  judrsl.rsvno = :rsvno 
                                  and free.freecd = 'NYUBOU' 
                                  and free.freefield5 = judrsl.judclasscd
                              ) 
                              union ( 
                                select
                                  3 grpno
                                  , judcd
                                  , judcmtcd 
                                from
                                  judrsl
                                  , free 
                                where
                                  judrsl.rsvno = :rsvno 
                                  and free.freecd = 'NYUBOU' 
                                  and free.freefield6 = judrsl.judclasscd
                            )            
            ";

            // 乳房触診と乳房Ｘ線、両方判定が終わっている受診者のみ自動判定処理
            sql += @"
                            union ( 
                              select
                                4 grpno
                                , judcd
                                , judcmtcd 
                              from
                                ( 
                                  select
                                    jud.weight as weight
                                    , judrsl.judcd as judcd
                                    , judrsl.judcmtcd as judcmtcd 
                                  from
                                    judrsl
                                    , free
                                    , jud 
                                  where
                                    judrsl.rsvno = :rsvno 
                                    and free.freecd = 'NYUBOU' 
                                    and judrsl.judclasscd in (free.freefield4, free.freefield5) 
                                    and judrsl.judcd = jud.judcd 
                                  order by
                                    jud.weight desc
                                    , judrsl.judclasscd desc
                                ) judview 
                              where
                                rownum < 2 
                                and ( 
                                  select
                                    count(judrsl.rsvno) 
                                  from
                                    judrsl
                                    , free 
                                  where
                                    judrsl.rsvno = :rsvno 
                                    and free.freecd = 'NYUBOU' 
                                    and judrsl.judclasscd in (free.freefield4, free.freefield5) 
                                    and judrsl.judcd is not null
                                ) = 2
                            )     
            ";

            // 通常の乳房判定をするのでいらない"
            sql += @"
                        ) nyuboujudview 
                    where
                        grpview.grpno = nyuboujudview.grpno
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 眼科判定結果を取得する（当日ＩＤ指定）
        /// 裸眼のみ、眼圧、矯正の無い人をＡ判定にする
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="dayIdFlg">1:ID 範囲指定、2:ID任意指定</param>
        /// <param name="strDayId">検索開始ＩＤ</param>
        /// <param name="endDayId">検索終了ＩＤ</param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="reJudge">再判定フラグ</param>
        /// <returns>
        /// rsvno 予約番号
        /// judcd 判定コード
        /// </returns>
        public List<dynamic> SelectGankaJudRsl(DateTime cslDate, long dayIdFlg, string strDayId, string endDayId, List<string> arrDayId, string csCd, bool reJudge)
        {
            string sql = "";  // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            // 眼科・眼圧判定分類コード
            param.Add("judclasscd", GANKA_JUDCLASSCD);
            // 眼圧依頼コード
            param.Add("itemcd_atsu", ATSU_ITEMCD);
            // 裸眼依頼コード
            param.Add("itemcd_ragan", RAGAN_ITEMCD);
            // 矯正依頼コード
            param.Add("itemcd_kyou", KYOU_ITEMCD);

            // 当日ID範囲指定？
            if (dayIdFlg == 1)
            {
                if (long.Parse(strDayId) <= long.Parse(endDayId))
                {
                    param.Add("strdayid", long.Parse(strDayId));
                    param.Add("enddayid", long.Parse(endDayId));
                }
                else
                {
                    param.Add("strdayid", long.Parse(endDayId));
                    param.Add("enddayid", long.Parse(strDayId));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            param.Add("cscd", csCd.Trim());

            // 検索条件を満たす予約番号を検索する
            sql = @"
                    select
                      consult.rsvno
                      , judrsl.judcd 
                    from
                      consult
                      , course_jud
                      , judrsl
                      , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                    where
                      receipt.csldate = :csldate 
                      and receipt.rsvno = consult.rsvno 
                      and judrsl.rsvno = consult.rsvno 
                      and judrsl.judclasscd = :judclasscd
            ";

            // 当日ID範囲指定時
            if (dayIdFlg == 1)
            {
                sql += @"
                            and receipt.dayid >= :strdayid 
                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                        ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd) &&
                !string.IsNullOrEmpty(csCd.Trim()))
            {
                sql += @"
                            and consult.cscd = :cscd
                ";
            }

            // 眼科判定分類が受診コースの判定分類として存在する場合に判定対象とする
            sql += @"
                        and consult.cscd = course_jud.cscd 
                        and course_jud.judclasscd = :judclasscd
            ";

            // 眼圧の依頼無し
            sql += @"
                        and not exists ( 
                          select
                            rsl.rsvno 
                          from
                            rsl 
                          where
                            rsl.rsvno = consult.rsvno 
                            and rsl.itemcd = :itemcd_atsu
                        ) 
            ";

            // 裸眼結果あり
            sql += @"
                        and exists ( 
                          select
                            rsl.rsvno 
                          from
                            rsl 
                          where
                            rsl.rsvno = consult.rsvno 
                            and rsl.result is not null 
                            and rsl.stopflg is null 
                            and rsl.itemcd = :itemcd_ragan
                        ) 
            ";

            // 矯正無し
            sql += @"
                        and not exists ( 
                          select
                            rsl.rsvno 
                          from
                            rsl 
                          where
                            rsl.rsvno = consult.rsvno 
                            and rsl.result is not null 
                            and rsl.stopflg is null 
                            and rsl.itemcd = :itemcd_kyou
                        ) 
            ";

            // 再判定でない場合、すでに判定コメントが存在する判定分類は対象としない
            if (!reJudge)
            {
                sql += @"
                            and not exists ( 
                              select
                                curjudrsl.rsvno 
                              from
                                judrsl curjudrsl 
                              where
                                curjudrsl.rsvno = consult.rsvno 
                                and curjudrsl.judcd is not null 
                                and curjudrsl.judclasscd = :judclasscd
                            ) 
                ";
            }

            // #ToDo Select後の.Net側での処理をどうするか
            //'配列形式で格納する
            //Do Until objOraDyna.EOF
            //    ReDim Preserve vntArrRsvNo(lngCount)
            //    ReDim Preserve vntArrJudClassCd(lngCount)
            //    ReDim Preserve vntArrJudCd(lngCount)
            //    ReDim Preserve vntArrJudCmtCd(lngCount)
            //    vntArrRsvNo(lngCount) = objRsvNo.Value
            //    vntArrJudClassCd(lngCount) = GANKA_JUDCLASSCD
            //    vntArrJudCd(lngCount) = "A"
            //    vntArrJudCmtCd(lngCount) = ""
            //    lngCount = lngCount + 1
            //    objOraDyna.MoveNext
            //Loop

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 骨密度判定結果を取得する（当日ＩＤ指定）
        /// Ｔスコアの基準値によって判定結果が「B2」になった場合喫煙結果を見て再判定（現在喫煙の場合、「D1」に変更）
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="dayIdFlg">1:ID 範囲指定、2:ID任意指定</param>
        /// <param name="strDayId">検索開始ＩＤ</param>
        /// <param name="endDayId">検索終了ＩＤ</param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="reJudge">再判定フラグ</param>
        /// <returns>
        /// rsvno 予約番号
        /// judcd 判定コード
        /// </returns>
        public List<dynamic> SelectKotsuJudRsl(DateTime cslDate, long dayIdFlg, string strDayId, string endDayId, List<string> arrDayId, string csCd, bool reJudge)
        {
            string sql = "";  // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            // 骨密度判定分類コード
            param.Add("judclasscd", KOTSU_JUDCLASSCD);
            // Ｔスコア検査項目コード
            param.Add("itemcd_tscore", TSCORE_ITEMCD);
            // Ｔスコアサフィックス
            param.Add("SUFFIX_TSCORE", TSCORE_SUFFIX);
            // 喫煙検査項目コード
            param.Add("ITEMCD_SMOKE", SMOKE_ITEMCD);
            // 喫煙サフィックス
            param.Add("SUFFIX_SMOKE", SMOKE_SUFFIX);

            // 当日ID範囲指定？
            if (dayIdFlg == 1)
            {
                if (long.Parse(strDayId) <= long.Parse(endDayId))
                {
                    param.Add("strdayid", long.Parse(strDayId));
                    param.Add("enddayid", long.Parse(endDayId));
                }
                else
                {
                    param.Add("strdayid", long.Parse(endDayId));
                    param.Add("enddayid", long.Parse(strDayId));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            param.Add("cscd", csCd.Trim());

            // 検索条件を満たす予約番号を検索する
            sql = @"
                    select
                      consult.rsvno as rsvno
                      , stdvalue_c.judcd as judcd 
                    from
                      stdvalue_c
                      , rsl
                      , consult
                      , receipt
                      , course_jud
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                    where
                      receipt.csldate = :csldate 
                      and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (dayIdFlg == 1)
            {
                sql += @"
                            and receipt.dayid >= :strdayid 
                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                        ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd) &&
                !string.IsNullOrEmpty(csCd.Trim()))
            {
                sql += @"
                            and consult.cscd = :cscd
                ";
            }

            // 骨密度判定分類が受診コースの判定分類として存在する場合に判定対象とする
            sql += @"
                        and consult.cscd = course_jud.cscd 
                        and course_jud.judclasscd = :judclasscd
            ";

            // 骨密度(Ｔスコア）判定結果が「B2」の場合、判定対象とする
            sql += @"
                        and consult.rsvno = rsl.rsvno 
                        and rsl.result is not null 
                        and rsl.itemcd = :itemcd_tscore 
                        and rsl.suffix = :suffix_tscore 
                        and rsl.stdvaluecd = stdvalue_c.stdvaluecd 
                        and stdvalue_c.judcd = 'B2'
            ";

            // 現在喫煙の受診者のみ対象とする(1：吸っている、2：吸わない、3：過去に吸っていた）
            sql += @"
                        and exists ( 
                          select
                            rsl.rsvno 
                          from
                            rsl currsl 
                          where
                            currsl.rsvno = consult.rsvno 
                            and currsl.result = '1' 
                            and currsl.stopflg is null 
                            and currsl.itemcd = :itemcd_smoke 
                            and currsl.suffix = :suffix_smoke
                        ) 
            ";

            // 再判定でない場合、すでに判定コメントが存在する判定分類は対象としない
            if (!reJudge)
            {
                sql += @"
                            and not exists ( 
                              select
                                curjudrsl.rsvno 
                              from
                                judrsl curjudrsl 
                              where
                                curjudrsl.rsvno = consult.rsvno 
                                and curjudrsl.judcd is not null 
                                and curjudrsl.judclasscd = :judclasscd
                            ) 
                ";
            }

            // #ToDo Select後の.Net側での処理をどうするか
            //'配列形式で格納する
            //Do Until objOraDyna.EOF
            //    ReDim Preserve vntArrRsvNo(lngCount)
            //    ReDim Preserve vntArrJudClassCd(lngCount)
            //    ReDim Preserve vntArrJudCd(lngCount)
            //    ReDim Preserve vntArrJudCmtCd(lngCount)
            //    vntArrRsvNo(lngCount) = objRsvNo.Value
            //    vntArrJudClassCd(lngCount) = KOTSU_JUDCLASSCD
            //    vntArrJudCd(lngCount) = "D1"
            //    vntArrJudCmtCd(lngCount) = KOTSU_CMTCD_D1
            //    lngCount = lngCount + 1
            //    objOraDyna.MoveNext
            //Loop

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 自動総合判定結果を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// rsvno 予約番号
        /// judclasscd 判定分類コード
        /// judcd 判定コード
        /// </returns>
        public List<dynamic> SelectTotalJudRslAutomatically(DateTime cslDate, string perId, string csCd)
        {
            string sql = "";  // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            if (!string.IsNullOrEmpty(perId) &&
                !string.IsNullOrEmpty(perId.Trim()))
            {
                param.Add("perid", perId.Trim());
            }
            param.Add("cscd", csCd.Trim());

            // 現在の判定分類別判定情報から総合判定結果を取得する
            // (先に連結した重み・判定コードを再度分割する)
            sql = @"
                    select
                      finaljudge.rsvno
                      , judrsl.judclasscd
                      , trim(substr(finaljudge.judkey, 3, 2)) judcd 
                    from
                      judclass
                      , judrsl
            ";

            // 重み・判定コードを連結した値が最も大きい(重い)ものを総合判定とする
            sql += @"
                    , ( 
                      select
                        judrsl.rsvno
                        , max(trim(to_char(jud.weight, '00')) || judrsl.judcd) judkey 
                      from
                        jud
                        , judclass
                        , judrsl
                        , consult
                        , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                        where
                          receipt.csldate = :csldate 
                          and receipt.rsvno = consult.rsvno
            ";

            // 個人ID指定時は条件節に加える
            if (!string.IsNullOrEmpty(perId) &&
                !string.IsNullOrEmpty(perId.Trim()))
            {
                sql += @"
                          and consult.perid = :perid
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd) &&
                !string.IsNullOrEmpty(csCd.Trim()))
            {
                sql += @"
                          and consult.cscd = :cscd
                ";
            }

            // 対象受診者の現判定結果情報を取得
            sql += @"
                        and consult.rsvno = judrsl.rsvno
            ";

            // 総合判定用の判定分類はここではグルーピングの対象としない
            sql += @"
                        and judrsl.judclasscd = judclass.judclasscd 
                        and judclass.alljudflg = 0
            ";

            // コメント表示のみの分類コードも対象としない
            sql += @"
                        and judclass.commentonly is null
            ";

            // 重みを取得するため判定テーブル情報を結合する(これにより未判定の判定結果はグルーピング対象とならない)
            sql += @"
                        and judrsl.judcd = jud.judcd
            ";

            // 総合判定用の判定分類をもつ受診情報のみを判定対象とする
            sql += @"
                        and exists ( 
                          select
                            totaljudrsl.rsvno 
                          from
                            judclass
                            , judrsl totaljudrsl 
                          where
                            totaljudrsl.rsvno = judrsl.rsvno 
                            and totaljudrsl.judclasscd = judclass.judclasscd 
                            and judclass.alljudflg = 1
                        )           
            ";

            // 予約番号単位で集計を行い、総合判定を求める
            sql += @"
                            group by
                              judrsl.rsvno
                        ) finaljudge
            ";

            // 総合判定用の判定分類に判定結果を格納するため、結合を行う
            sql += @"
                    where
                      finaljudge.rsvno = judrsl.rsvno 
                      and judrsl.judclasscd = judclass.judclasscd 
                      and judclass.alljudflg = 1
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 判定結果テーブルレコードを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="judCd">判定コード</param>
        /// <param name="updUser">更新者 (配列ではない）</param>
        /// <param name="judCmtCd">判定コメントコード</param>
        /// <param name="updFlg">更新フラグ　(配列ではない）</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool UpdateJudRsl(List<long> rsvNo, List<long> judClassCd, List<string> judCd = null, string updUser = null, List<string> judCmtCd = null, string updFlg = null)
        {
            string sql;         // SQLステートメント
            bool ret = false;   // 関数戻り値
            bool add = false;   // UPDATE文のSET句に何かを追加したか

            // キー及び更新値の設定
            var sqlParamArray = new List<Dictionary<string, object>>();
            for (int i = 0; i < judClassCd.Count; i++)
            {
                var param = new Dictionary<string, object>();
                param.Add("rsvno", rsvNo[i]);
                param.Add("judclasscd", judClassCd[i]);
                if (judCd != null)
                {
                    param.Add("judcd", judCd[i]);
                }
                if (!string.IsNullOrEmpty(updUser))
                {
                    param.Add("upduser", updUser.Trim());
                }
                if (judCmtCd != null)
                {
                    if (!string.IsNullOrEmpty(judCmtCd[i]))
                    {
                        param.Add("judcmtcd", judCmtCd[i]);
                    }
                    else
                    {
                        param.Add("judcmtcd", null);
                    }
                }
                if (!string.IsNullOrEmpty(updFlg))
                {
                    param.Add("updflg", updFlg.Trim());
                }

                sqlParamArray.Add(param);
            }

            // 判定結果テーブルレコードの更新
            sql = @"
                    update judrsl 
                    set
            ";

            // 引数として存在する場合のみSET句に追加
            if (judCd != null)
            {
                sql += @"
                        judcd = :judcd
                ";
                add = true;
            }
            if (!string.IsNullOrEmpty(updUser))
            {
                if (add)
                {
                    sql += @"
                            ,
                    ";
                }
                sql += @"
                            upduser = :upduser
                ";
                add = true;
            }
            if (judCmtCd != null)
            {
                if (add)
                {
                    sql += @"
                            ,
                    ";
                }
                sql += @"
                            judcmtcd = :judcmtcd
                ";
                add = true;
            }
            if (!string.IsNullOrEmpty(updFlg))
            {
                if (add)
                {
                    sql += @"
                            ,
                    ";
                }
                sql += @"
                            updflg = :updflg
                ";
                add = true;
            }

            // 条件節の追加
            sql += @"
                    where
                      rsvno = :rsvno 
                      and judclasscd = :judclasscd
            ";

            // SQL実行
            connection.Execute(sql, sqlParamArray);

            ret = true;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 判定結果テーブルレコードを更新する
        /// （存在すれば更新、なければ挿入）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="judCd">判定コード</param>
        /// <param name="judCmtCd">判定コメントコード</param>
        /// <param name="updUser">更新者</param>
        /// <param name="updFlg">更新フラグ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertJudRslWithUpdate(List<long> rsvNo, List<string> judClassCd, List<string> judCd, List<string> judCmtCd, string updUser = null, string updFlg = null)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            for (int i = 0; i < judClassCd.Count; i++)
            {
                var param = new Dictionary<string, object>();
                param.Add("rsvno", rsvNo[i]);
                param.Add("judclasscd", judClassCd[i]);
                if (judCd != null)
                {
                    param.Add("judcd", judCd[i]);
                }
                if (!string.IsNullOrEmpty(updUser))
                {
                    param.Add("upduser", updUser.Trim());
                }
                if (judCmtCd != null)
                {
                    if (!string.IsNullOrEmpty(judCmtCd[i]))
                    {
                        param.Add("judcmtcd", judCmtCd[i]);
                    }
                    else
                    {
                        param.Add("judcmtcd", null);
                    }
                }
                if (!string.IsNullOrEmpty(updFlg))
                {
                    param.Add("updflg", updFlg.Trim());
                }

                // 検索条件を満たす判定結果テーブルのレコードを取得
                sql = @"
                    select
                      rsvno 
                    from
                      judrsl 
                    where
                      rsvno = :rsvno 
                      and judclasscd = :judclasscd
                ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                if (current == null)
                {
                    sql = @"
                            insert 
                            into judrsl(
                                rsvno
                                , judclasscd
                                , judcd
                                , judcmtcd
                    ";
                    if (!string.IsNullOrEmpty(updUser))
                    {
                        sql += @"
                                , upduser
                        ";
                    }
                    if (!string.IsNullOrEmpty(updFlg))
                    {
                        sql += @"
                                , updflg
                        ";
                    }
                    sql += @"
                                ) 
                                values (
                                    :rsvno
                                    , :judclasscd
                                    , :judcd
                                    , :judcmtcd
                    ";
                    if (!string.IsNullOrEmpty(updUser))
                    {
                        sql += @"
                                , :upduser
                        ";
                    }
                    if (!string.IsNullOrEmpty(updFlg))
                    {
                        sql += @"
                                , :updflg
                        ";
                    }

                    sql += @"
                                )
                    ";

                    connection.Execute(sql, param);
                }
                else
                {
                    sql = @"
                            update judrsl 
                            set
                              judcd = :judcd
                              , judcmtcd = :judcmtcd
                    ";
                    if (!string.IsNullOrEmpty(updUser))
                    {
                        sql += @"
                                , upduser = :upduser
                        ";
                    }
                    if (!string.IsNullOrEmpty(updFlg))
                    {
                        sql += @"
                                , updflg  = :updflg
                        ";
                    }
                    sql += @"
                            where
                              rsvno = :rsvno 
                              and judclasscd = :judclasscd
                    ";

                    connection.Execute(sql, param);
                }

            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 生活指導メッセージをセットする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateLifeGuideMsg(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // 認識レベルのITEMCD，SUFFIX
            param.Add("knowitemcd", KNOWLEVEL_ITEMCD);
            param.Add("knowsuffix", KNOWLEVEL_SUFFIX);
            // 生活指導用のグループコード
            param.Add("gdegrpcd", GDECMT_GRPCD);
            // 総合コメント登録用の表示モード
            param.Add("DISPMODE", GDECMT_DISPMODE);

            // 検索条件にあった受診者の前回の認識レベルと今回の失点から判定コメントコードを取得する
            sql = @"
                    select
                      nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = judcmtview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , judcmtview.rsvno
                      , judcmtview.judcmtcd 
                    from
                      ( 
                        select
                          cmtcdview.rsvno
                          , decode( 
                            levelview.knowlevel
                            , 1
                            , cmtcdview.judcmtcd1
                            , 2
                            , cmtcdview.judcmtcd2
                            , 3
                            , cmtcdview.judcmtcd3
                            , 4
                            , cmtcdview.judcmtcd4
                            , 5
                            , cmtcdview.judcmtcd5
                            , cmtcdview.judcmtcd1
                          ) judcmtcd 
                        from
            ";

            // 直近の認識レベルの取得（０やｎｕｌｌなら認識レベル１とする）
            sql += @"
                            ( 
                              select
                                dateview.perid
                                , decode(rsl.result, 0, 1, null, 1, rsl.result) knowlevel 
                              from
                                rsl
                                , consult
            ";

            // 個人ＩＤごとの認識レベルのある直近の受診日（５年前まで）
            sql += @"
                                , ( 
                                  select
                                    perview.perid
                                    , max(perview.csldate) csldate 
                                  from
                                    ( 
                                      select
                                        peridview.perid
                                        , consult.csldate 
                                      from
                                        consult
                                        , rsl
                                        , ( 
                                          select
                                            consult.perid
                                            , ( 
                                              select
                                                count(*) 
                                              from
                                                totaljudcmt 
                                              where
                                                rsvno = consult.rsvno 
                                                and dispmode = 2 
                                                and rownum = 1
                                            ) cmtcnt 
                                          from
                                            receipt
                                            , consult 
                                          where
                                            receipt.csldate = :csldate 
                                            and receipt.csldate = consult.csldate 
                                            and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                            and receipt.dayid >= :strdayid 
                                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                            and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                                ,
                        ";
                    }
                    sql += @"
                                                :dayid" + i;
                }
                sql += @"
                                           )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                           and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) peridview 
                                where
                                  consult.perid = peridview.perid 
                                  and peridview.cmtcnt = 0 
                                  and consult.csldate < :csldate 
                                  and consult.csldate >= add_months(:csldate, - 60) 
                                  and exists ( 
                                    select
                                      receipt.rsvno 
                                    from
                                      receipt 
                                    where
                                      receipt.rsvno = consult.rsvno
                                  ) 
                              and rsl.rsvno = consult.rsvno 
                              and rsl.itemcd = :knowitemcd 
                              and rsl.suffix = :knowsuffix 
                            order by
                              peridview.perid) perview 
                            group by
                              perview.perid) dateview 
                            where
                              consult.csldate = dateview.csldate 
                              and consult.perid = dateview.perid 
                              and rsl.rsvno = consult.rsvno 
                              and rsl.itemcd = :knowitemcd 
                              and rsl.suffix = :knowsuffix
                        ) levelview 
            ";

            // 検査結果に対応するコメントコード
            sql += @"
                        ,( 
                          select
                            rslview.perid
                            , rslview.rsvno
                            , freefield1 judcmtcd1
                            , freefield2 judcmtcd2
                            , freefield3 judcmtcd3
                            , freefield4 judcmtcd4
                            , freefield5 judcmtcd5 
                          from
                            free
            ";

            // 生活指導メッセージ取得用の検査結果
            sql += @"
                            , ( 
                              select
                                rsl.itemcd
                                , rsl.suffix
                                , rsl.result
                                , rsl.rsvno
                                , rsvnoview.perid 
                              from
                                rsl
                                , grp_i
            ";

            // 指定条件の予約番号とPERID群取得
            sql += @"
                            , ( 
                              select
                                consult.perid
                                , consult.rsvno
                                , ( 
                                  select
                                    count(*) 
                                  from
                                    totaljudcmt 
                                  where
                                    rsvno = consult.rsvno 
                                    and dispmode = 2 
                                    and rownum = 1
                                ) cmtcnt 
                              from
                                receipt
                                , consult 
                              where
                                receipt.csldate = :csldate 
                                and receipt.csldate = consult.csldate 
                                and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                and receipt.dayid >= :strdayid 
                                and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                           ,
                        ";
                    }
                    sql += @"
                                            :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                           and consult.cscd = :cscd
                ";
            }

            sql += @"
                                            ) rsvnoview 
                                        where
                                          rsl.rsvno = rsvnoview.rsvno 
                                          and rsvnoview.cmtcnt = 0 
                                          and grp_i.grpcd = :gdegrpcd 
                                          and grp_i.itemcd = rsl.itemcd 
                                          and grp_i.suffix = rsl.suffix
                                    ) rslview 
                                where
                                  free.freecd = 'GDE' || rslview.itemcd || rslview.suffix || rslview.result
                            ) cmtcdview 
                        where
                          cmtcdview.perid = levelview.perid(+)
                        ) judcmtview
            ";

            //  総合コメントテーブルに登録されていないもの
            sql += @"
                    where
                      not exists ( 
                        select
                          * 
                        from
                          totaljudcmt 
                        where
                          totaljudcmt.rsvno = judcmtview.rsvno 
                          and totaljudcmt.dispmode = :dispmode 
                          and totaljudcmt.judcmtcd = judcmtview.judcmtcd
                      ) 
            ";

            sql += @"
                    order by
                      judcmtview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = InsertTotalJudCmt(current, GDECMT_DISPMODE);
            }
            else
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 喫煙関連メッセージ（総合コメント）をセットする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateSmokeGuideMsg(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // 喫煙コメント導出用のグループコード
            param.Add("smkgrpcd", SMKCMT_GRPCD);
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE);

            // 検索条件にあった受診者の前回の認識レベルと今回の失点から判定コメントコードを取得する
            sql = @"
                    select
                      nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = judcmtview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , judcmtview.rsvno
                      , judcmtview.judcmtcd 
                    from
                      ( 
                        select
                          cmtcdview.rsvno as rsvno
                          , cmtcdview.judcmtcd as judcmtcd 
                        from
            ";

            // 検査結果に対応するコメントコード
            sql += @"
                            ( 
                              select
                                rslview.perid
                                , rslview.rsvno
                                , freefield1 judcmtcd 
                              from
                                free
            ";

            // 生活指導メッセージ取得用の検査結果
            sql += @"
                                , ( 
                                  select
                                    rsl.itemcd
                                    , rsl.suffix
                                    , rsl.result
                                    , rsl.rsvno
                                    , rsvnoview.perid 
                                  from
                                    rsl
                                    , grp_i
            ";

            // 指定条件の予約番号とPERID群取得
            sql += @"
                                    , ( 
                                      select
                                        consult.perid
                                        , consult.rsvno 
                                      from
                                        receipt
                                        , consult 
                                      where
                                        receipt.csldate = :csldate 
                                        and receipt.csldate = consult.csldate 
                                        and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                        and receipt.dayid >= :strdayid 
                                        and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                        and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                            ,
                        ";
                    }
                    sql += @"
                                           :dayid" + i;
                }
                sql += @"
                                        )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                        and consult.cscd = :cscd
                ";
            }

            // 喫煙コメントがセットされていたら、コメントセット対象としない
            sql += @"
                                        ) rsvnoview 
                                    where
                                      rsl.rsvno = rsvnoview.rsvno 
                                      and grp_i.grpcd = :smkgrpcd 
                                      and grp_i.itemcd = rsl.itemcd 
                                      and grp_i.suffix = rsl.suffix) rslview 
                                where
                                  free.freecd = 'SMK' || rslview.itemcd || rslview.suffix || rslview.result
                            ) cmtcdview
                        ) judcmtview
            ";

            // 総合コメントテーブルに登録されていないもの
            sql += @"
                    where
                        not exists ( 
                            select
                                * 
                            from
                                totaljudcmt 
                            where
                                totaljudcmt.rsvno = judcmtview.rsvno 
                                and totaljudcmt.dispmode = :dispmode 
                                and totaljudcmt.judcmtcd = judcmtview.judcmtcd
                        ) 
            ";

            sql += @"
                    order by
                      judcmtview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = InsertTotalJudCmt(current, TOTALCMT_DISPMODE);
            }
            else
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 現病歴コメントをセットする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// discomment 現病歴コメント区分
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateNowDiseaseCmt(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // 総合コメント分類（婦人科関連なのか）
            if (!("TOT").Equals(Util.ConvertToString(data["discomment"]).Trim()))
            {
                param.Add("discomment", Util.ConvertToString(data["discomment"]).Trim());
            }
            // 現病歴コメント用のグループコードド
            param.Add("grpcd", DISEASECMT_GRPCD);
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE);

            // 現病歴に対するコメント取得
            sql = @"
                    select
                      nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = judcmtview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , judcmtview.rsvno
                      , judcmtview.judcmtcd 
                    from
                      ( 
                        select distinct
                          rslview.rsvno
                          , free.freefield1 judcmtcd 
                        from
                          free
            ";

            // 現病歴取得
            sql += @"
                        , ( 
                            select
                            rsl.rsvno
                            , rsl.result
                            , rsl.itemcd
                            , rsl.suffix 
                            from
                            rsl
                            , consult
                            , receipt
                            , grp_i 
                            where
                            receipt.csldate = :csldate 
                            and consult.rsvno = receipt.rsvno 
                            and grp_i.grpcd = :grpcd 
                            and rsl.rsvno = consult.rsvno 
                            and rsl.itemcd = grp_i.itemcd 
                            and rsl.suffix = grp_i.suffix 
                            and rsl.suffix = '01'
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                and receipt.dayid >= :strdayid 
                                and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                        ,
                        ";
                    }
                    sql += @"
                                       :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                        and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) rslview
            ";

            // 治療状態取得 (治療終了は除く）
            sql += @"
                                   , ( 
                                       select
                                         rsl.rsvno
                                         , rsl.result
                                         , rsl.itemcd
                                         , rsl.suffix 
                                       from
                                         rsl
                                         , consult
                                         , receipt
                                         , grp_i 
                                       where
                                         receipt.csldate = :csldate 
                                         and consult.rsvno = receipt.rsvno 
                                         and grp_i.grpcd = :grpcd 
                                         and rsl.rsvno = consult.rsvno 
                                         and rsl.itemcd = grp_i.itemcd 
                                         and rsl.suffix = grp_i.suffix 
                                         and rsl.suffix = '03' 
                                         and rsl.result not in (7, 8, 9, 10
                                     ) 
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                         and receipt.dayid >= :strdayid 
                                         and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                         and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                                ,
                        ";
                    }
                    sql += @"
                                            :dayid" + i;
                }
                sql += @"
                                         )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            if (("TOT").Equals(Util.ConvertToString(data["discomment"]).Trim()))
            {
                sql += @"
                                    ) statview 
                                where
                                  free.freecd = 'DISEASE' || rslview.result 
                                  and rslview.rsvno = statview.rsvno 
                                  and rslview.itemcd = statview.itemcd
                            ) judcmtview
                ";
            }
            else
            {
                sql += @"
                                    ) statview 
                                where
                                  free.freecd = 'DISEASE' || rslview.result 
                                  and free.freeclasscd = :discomment 
                                  and rslview.rsvno = statview.rsvno 
                                  and rslview.itemcd = statview.itemcd
                            ) judcmtview
                ";
            }

            // 総合コメントテーブルに登録されていないもの
            sql += @"
                    where
                      not exists ( 
                            select
                              * 
                            from
                              totaljudcmt 
                            where
                              totaljudcmt.rsvno = judcmtview.rsvno 
                              and totaljudcmt.dispmode = :dispmode 
                              and totaljudcmt.judcmtcd = judcmtview.judcmtcd
                      ) 
                    order by
                      judcmtview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = InsertTotalJudCmt(current, TOTALCMT_DISPMODE);
            }
            else
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// メタボリックシンドローム総合コメント登録処理
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateMetaCmt(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            long check1 = 0;                // 脂質関連チェック
            long check2 = 0;                // 血圧関連チェック
            long check3 = 0;                // 血糖関連チェック
            long count = 0;                 // レコード数

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // メタボリックシンドローム総合コメント用のグループコード
            param.Add("grpcd", METACMT_GRPCD);
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE);
            // メタボリックシンドローム用総合コメントコード
            param.Add("metacmtcd", METACMT_CMTCD);
            param.Add("metacmtcd2", METACMT_CMTCD2);
            // メタボリックシンドローム関連検査項目コード
            param.Add("itemcd_glycemia", GLYCEMIA_ITEMCD);
            param.Add("suffix_glycemia", GLYCEMIA_SUFFIX);
            param.Add("itemcd_hdl", HDL_ITEMCD);
            param.Add("suffix_hdl", HDL_SUFFIX);
            param.Add("itemcd_tg", TG_ITEMCD);
            param.Add("suffix_tg", TG_SUFFIX);
            param.Add("itemcd_cbp", CBP_ITEMCD);
            param.Add("suffix_cbp", CBP_SUFFIX);
            param.Add("itemcd_ebp", EBP_ITEMCD);
            param.Add("suffix_ebp", EBP_SUFFIX);
            param.Add("itemcd_waist", WAIST_ITEMCD);
            param.Add("suffix_waist", WAIST_SUFFIX);

            // メタボリックシンドロームチェック用結果データ取得（検査結果、病歴情報）
            sql = @"
                    select
                      judcmtview.rsvno as rsvno
                      , nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = judcmtview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , judcmtview.judcmtcd as judcmtcd
                      , judcmtview.judcmtcd2 as judcmtcd2
                      , judcmtview.dayid as dayid
                      , judcmtview.perid as perid
                      , judcmtview.gender as gender
                      , judcmtview.glycemiarsl as glycemiarsl
                      , judcmtview.hdlrsl as hdlrsl
                      , judcmtview.tgrsl as tgrsl
                      , judcmtview.cbprsl as cbprsl
                      , judcmtview.ebprsl as ebprsl
                      , judcmtview.waistrsl as waistrsl
                      , judcmtview.ketsuatsu as ketsuatsu
                      , judcmtview.tounyou as tounyou
                      , judcmtview.shisitsu as shisitsu
            ";

            sql += @"
                    from
                      ( 
                        select
                          receipt.rsvno as rsvno
                          , receipt.dayid as dayid
                          , consult.perid as perid
                          , consult.cscd as cscd
                          , person.lastname as lastname
                          , person.firstname as firstname
                          , person.gender as gender
                          , :metacmtcd as judcmtcd
                          , :metacmtcd2 as judcmtcd2
            ";

            // 糖代謝判定用の検査結果を取得する
            // 空腹時血糖値
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_glycemia 
                                    and rsl.suffix = :suffix_glycemia
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_glycemia 
                                    and rsl.suffix = :suffix_glycemia
                                ) 
                                end result 
                            from
                              dual
                          ) glycemiarsl
            ";

            // 脂質代謝判定用の検査結果を取得する
            // HDL
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_hdl 
                                    and rsl.suffix = :suffix_hdl
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_hdl 
                                    and rsl.suffix = :suffix_hdl
                                ) 
                                end result 
                            from
                              dual
                          ) hdlrsl
            ";

            // TG
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_tg 
                                    and rsl.suffix = :suffix_tg
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_tg 
                                    and rsl.suffix = :suffix_tg
                                ) 
                                end result 
                            from
                              dual
                          ) tgrsl
            ";

            // 収縮期血圧結果
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_cbp 
                                    and rsl.suffix = :suffix_cbp
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_cbp 
                                    and rsl.suffix = :suffix_cbp
                                ) 
                                end result 
                            from
                              dual
                          ) cbprsl
            ";

            // 拡張期血圧結果
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_ebp 
                                    and rsl.suffix = :suffix_ebp
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_ebp 
                                    and rsl.suffix = :suffix_ebp
                                ) 
                                end result 
                            from
                              dual
                          ) ebprsl
            ";

            // 腹囲結果、病歴情報
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_waist 
                                    and rsl.suffix = :suffix_waist
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_waist 
                                    and rsl.suffix = :suffix_waist
                                ) 
                                end result 
                            from
                              dual
                          ) waistrsl
                          , decode(lastview.ketsuatsu, null, 0, lastview.ketsuatsu) as ketsuatsu
                          , decode(lastview.tounyou, null, 0, lastview.tounyou) as tounyou
                          , decode(lastview.shisitsu, null, 0, lastview.shisitsu) as shisitsu
            ";

            sql += @"
                        from
                          receipt
                          , consult
                          , person
                          , ( 
                            select
                              final.rsvno as rsvno
                              , sum(final.ketsuatsu) as ketsuatsu
                              , sum(final.tounyou) as tounyou
                              , sum(final.shisitsu) as shisitsu 
                            from
                              ( 
                                select
                                  rslview.rsvno as rsvno
                                  , rslview.result as diseasek
                                  , decode(rslview.result, '19', count(rslview.rsvno), 0) as ketsuatsu
                                  , decode(rslview.result, '48', count(rslview.rsvno), 0) as tounyou
                                  , decode(rslview.result, '47', count(rslview.rsvno), 0) as shisitsu
            ";

            sql += @"
                                from
                                  ( 
                                    select
                                      rsl.rsvno
                                      , free.freefield3 result
                                      , rsl.itemcd
                                      , rsl.suffix 
                                    from
                                      rsl
                                      , consult
                                      , receipt
                                      , grp_i
                                      , free 
                                    where
                                      receipt.csldate = :csldate 
                                      and consult.rsvno = receipt.rsvno 
                                      and grp_i.grpcd = :grpcd 
                                      and rsl.rsvno = consult.rsvno 
                                      and rsl.itemcd = grp_i.itemcd 
                                      and rsl.suffix = grp_i.suffix 
                                      and rsl.suffix = '01' 
                                      and free.freecd = 'METADIS' || rsl.result
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                      and receipt.dayid >= :strdayid 
                                      and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                      and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                            ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                     )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                        and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) rslview
            ";

            sql += @"
                                   , ( 
                                      select
                                        rsl.rsvno
                                        , rsl.result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                      from
                                        rsl
                                        , consult
                                        , receipt
                                        , grp_i
                                        , free 
                                      where
                                        receipt.csldate = :csldate 
                                        and consult.rsvno = receipt.rsvno 
                                        and grp_i.grpcd = :grpcd 
                                        and rsl.rsvno = consult.rsvno 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = '03' 
                                        and free.freecd = 'METASTS' || rsl.result
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                        and receipt.dayid >= :strdayid 
                                        and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                        and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                                ,
                        ";
                    }
                    sql += @"
                                            :dayid" + i;
                }
                sql += @"
                                         )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) statview 
                                where
                                  rslview.rsvno = statview.rsvno 
                                  and rslview.itemcd = statview.itemcd 
                                group by
                                  rslview.rsvno
                                  , rslview.result
                                ) final 
                            group by
                              final.rsvno
                        ) lastview
            ";

            sql += @"
                    where
                        receipt.csldate = :csldate 
                        and receipt.rsvno = consult.rsvno 
                        and receipt.csldate = consult.csldate 
                        and consult.perid = person.perid 
                        and consult.rsvno = lastview.rsvno(+)
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                            and receipt.dayid >= :strdayid 
                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                            and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                           ,
                        ";
                    }
                    sql += @"
                                       :dayid" + i;
                }
                sql += @"
                             )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            sql += @"
                            ) judcmtview 
                    where
                          not exists ( 
                                select
                                  * 
                                from
                                  totaljudcmt 
                                where
                                  totaljudcmt.rsvno = judcmtview.rsvno 
                                  and totaljudcmt.dispmode = :dispmode 
                                  and totaljudcmt.judcmtcd in (judcmtview.judcmtcd, judcmtview.judcmtcd2)
                          ) 
                    order by
                      judcmtview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            List<dynamic> insertData = new List<dynamic>();

            ret = Insert.Normal;

            // 検索レコードが存在する場合
            if (current != null)
            {
                for (int i = 0; i < current.Count; i++)
                {
                    check1 = 0;
                    check2 = 0;
                    check3 = 0;

                    // 腹囲が基準値以上の受診者のみ対象にする（男性：85以上、女性：90以上）
                    if ((Convert.ToInt64(current[i]["gender"]) == 1 &&
                         Convert.ToInt64(current[i]["waistrsl"]) >= 85) ||
                        (Convert.ToInt64(current[i]["gender"]) == 2 &&
                         Convert.ToInt64(current[i]["waistrsl"]) >= 90))
                    {
                        // 「TG：150以上」と「HDL：40未満」いずれか
                        // 或は「高脂血症」で薬剤治療中
                        if (Convert.ToInt64(current[i]["tgrsl"]) >= 150 ||
                            Convert.ToInt64(current[i]["hdlrsl"]) < 40 ||
                            Convert.ToInt64(current[i]["shisitsu"]) > 0)
                        {
                            check1 = 1;
                        }

                        // 「収縮期血圧：130以上」と「拡張期血圧：80以上」いずれか
                        // 或は「高血圧」で薬剤治療中
                        if (Convert.ToInt64(current[i]["cbprsl"]) >= 130 ||
                            Convert.ToInt64(current[i]["ebprsl"]) >= 85 ||
                            Convert.ToInt64(current[i]["ketsuatsu"]) > 0)
                        {
                            check2 = 1;
                        }

                        // 「「FPG：110以上」
                        // 或は「糖尿症」で薬剤治療中
                        if (Convert.ToInt64(current[i]["glycemiarsl"]) >= 110 ||
                            Convert.ToInt64(current[i]["ketsuatsu"]) > 0)
                        {
                            check3 = 1;
                        }

                        // メタボリックシンドローム対象者のみ指定総合コメント登録
                        // 「脂質」、「血圧」、「血糖」中二つ以上異常の場合対象にする
                        if ((check1 + check2 + check3) >= 2)
                        {
                            insertData.Add(current[i]);
                            count++;
                        }
                    }
                }

                if (count > 0)
                {
                    ret = InsertTotalJudCmt(insertData, TOTALCMT_DISPMODE);
                    ret = InsertTotalJudCmt(insertData, TOTALCMT_DISPMODE, true);
                }

            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// メタボリックシンドローム総合コメント登録処理
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateMetaCmt2(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            long check1 = 0;                // 脂質関連チェック
            long check2 = 0;                // 血圧関連チェック
            long check3 = 0;                // 血糖関連チェック
            long count = 0;                 // レコード数

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // メタボリックシンドローム総合コメント用のグループコード
            param.Add("grpcd", METACMT_GRPCD);
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE);
            // メタボリックシンドローム用総合コメントコード
            param.Add("metacmtnewcd", METACMT_NEWCD);
            param.Add("metacmtnewcd2", METACMT_NEWCD2);
            param.Add("metacmtnewcd3", METACMT_NEWCD3);

            // メタボリックシンドローム関連検査項目コード
            param.Add("itemcd_glycemia", GLYCEMIA_ITEMCD);
            param.Add("suffix_glycemia", GLYCEMIA_SUFFIX);
            param.Add("itemcd_hba1c", HBA1C_ITEMCD);
            param.Add("suffix_hba1c", HBA1C_SUFFIX);
            param.Add("itemcd_hdl", HDL_ITEMCD);
            param.Add("suffix_hdl", HDL_SUFFIX);
            param.Add("itemcd_tg", TG_ITEMCD);
            param.Add("suffix_tg", TG_SUFFIX);
            param.Add("itemcd_cbp", CBP_ITEMCD);
            param.Add("suffix_cbp", CBP_SUFFIX);
            param.Add("itemcd_ebp", EBP_ITEMCD);
            param.Add("suffix_ebp", EBP_SUFFIX);
            param.Add("itemcd_waist", WAIST_ITEMCD);
            param.Add("suffix_waist", WAIST_SUFFIX);

            // メタボリックシンドロームチェック用結果データ取得（検査結果、病歴情報）
            sql = @"
                    select
                      judcmtview.rsvno as rsvno
                      , nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = judcmtview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , judcmtview.dayid as dayid
                      , judcmtview.perid as perid
                      , judcmtview.gender as gender
                      , judcmtview.glycemiarsl as glycemiarsl
                      , judcmtview.hba1crsl as hba1crsl
                      , judcmtview.hdlrsl as hdlrsl
                      , judcmtview.tgrsl as tgrsl
                      , judcmtview.cbprsl as cbprsl
                      , judcmtview.ebprsl as ebprsl
                      , judcmtview.waistrsl as waistrsl
                      , judcmtview.ketsuatsu as ketsuatsu
                      , judcmtview.tounyou as tounyou
                      , judcmtview.shisitsu as shisitsu
            ";

            sql += @"
                    from
                      ( 
                        select
                          receipt.rsvno as rsvno
                          , receipt.dayid as dayid
                          , consult.perid as perid
                          , consult.cscd as cscd
                          , person.lastname as lastname
                          , person.firstname as firstname
                          , person.gender as gender
            ";

            // 糖代謝判定用の検査結果を取得する
            // 空腹時血糖値
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_glycemia 
                                    and rsl.suffix = :suffix_glycemia 
                                    and rsl.stopflg is null 
                                    and rsl.result is not null
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_glycemia 
                                    and rsl.suffix = :suffix_glycemia
                                ) 
                                end result 
                            from
                              dual
                          ) glycemiarsl
            ";

            //  HbA1c
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_hba1c 
                                    and rsl.suffix = :suffix_hba1c 
                                    and rsl.stopflg is null 
                                    and rsl.result is not null
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_hba1c 
                                    and rsl.suffix = :suffix_hba1c
                                ) 
                                end result 
                            from
                              dual
                          ) hba1crsl
            ";

            // 脂質代謝判定用の検査結果を取得する
            // HDL
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_hdl 
                                    and rsl.suffix = :suffix_hdl 
                                    and rsl.stopflg is null 
                                    and rsl.result is not null
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_hdl 
                                    and rsl.suffix = :suffix_hdl
                                ) 
                                end result 
                            from
                              dual
                          ) hdlrsl
            ";

            // TG
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_tg 
                                    and rsl.suffix = :suffix_tg 
                                    and rsl.stopflg is null 
                                    and rsl.result is not null
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_tg 
                                    and rsl.suffix = :suffix_tg
                                ) 
                                end result 
                            from
                              dual
                          ) tgrsl
            ";

            // 収縮期血圧結果
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_cbp 
                                    and rsl.suffix = :suffix_cbp 
                                    and rsl.stopflg is null 
                                    and rsl.result is not null
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_cbp 
                                    and rsl.suffix = :suffix_cbp
                                ) 
                                end result 
                            from
                              dual
                          ) cbprsl
            ";

            // 拡張期血圧結果
            sql += @"
                          , ( 
                            select
                              case 
                                when ( 
                                  select
                                    count(*) 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_ebp 
                                    and rsl.suffix = :suffix_ebp 
                                    and rsl.stopflg is null 
                                    and rsl.result is not null
                                ) = 0 
                                  then '' 
                                else ( 
                                  select
                                    rsl.result 
                                  from
                                    rsl 
                                  where
                                    rsl.rsvno = receipt.rsvno 
                                    and rsl.itemcd = :itemcd_ebp 
                                    and rsl.suffix = :suffix_ebp
                                ) 
                                end result 
                            from
                              dual
                          ) ebprsl
            ";

            // 腹囲結果、病歴情報
            sql += @"
                        , ( 
                          select
                            case 
                              when ( 
                                select
                                  count(*) 
                                from
                                  rsl 
                                where
                                  rsl.rsvno = receipt.rsvno 
                                  and rsl.itemcd = :itemcd_waist 
                                  and rsl.suffix = :suffix_waist 
                                  and rsl.stopflg is null 
                                  and rsl.result is not null
                              ) = 0 
                                then '' 
                              else ( 
                                select
                                  rsl.result 
                                from
                                  rsl 
                                where
                                  rsl.rsvno = receipt.rsvno 
                                  and rsl.itemcd = :itemcd_waist 
                                  and rsl.suffix = :suffix_waist
                              ) 
                              end result 
                          from
                            dual
                        ) waistrsl
                        , decode(lastview.ketsuatsu, null, 0, lastview.ketsuatsu) as ketsuatsu
                        , decode(lastview.tounyou, null, 0, lastview.tounyou) as tounyou
                        , decode(lastview.shisitsu, null, 0, lastview.shisitsu) as shisitsu
            ";

            sql += @"
                    from
                        receipt
                        , consult
                        , person
                        , ( 
                        select
                            final.rsvno as rsvno
                            , sum(final.ketsuatsu) as ketsuatsu
                            , sum(final.tounyou) as tounyou
                            , sum(final.shisitsu) as shisitsu 
                        from
                            ( 
                            select
                                rslview.rsvno as rsvno
                                , rslview.result as diseasek
                                , decode(rslview.result, '19', count(rslview.rsvno), 0) as ketsuatsu
                                , decode(rslview.result, '48', count(rslview.rsvno), 0) as tounyou
                                , decode(rslview.result, '47', count(rslview.rsvno), 0) as shisitsu
            ";

            sql += @"
                            from
                              ( 
                                select
                                  rsl.rsvno
                                  , free.freefield3 result
                                  , rsl.itemcd
                                  , rsl.suffix 
                                from
                                  rsl
                                  , consult
                                  , receipt
                                  , grp_i
                                  , free 
                                where
                                  receipt.csldate = :csldate 
                                  and consult.rsvno = receipt.rsvno 
                                  and grp_i.grpcd = :grpcd 
                                  and rsl.rsvno = consult.rsvno 
                                  and rsl.itemcd = grp_i.itemcd 
                                  and rsl.suffix = grp_i.suffix 
                                  and rsl.suffix = '01' 
                                  and free.freecd = 'METADIS' || rsl.result
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                  and receipt.dayid >= :strdayid 
                                  and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                  and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                            ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                  )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                  and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) rslview
            ";

            sql += @"
                                   , ( 
                                      select
                                        rsl.rsvno
                                        , rsl.result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                      from
                                        rsl
                                        , consult
                                        , receipt
                                        , grp_i
                                        , free 
                                      where
                                        receipt.csldate = :csldate 
                                        and consult.rsvno = receipt.rsvno 
                                        and grp_i.grpcd = :grpcd 
                                        and rsl.rsvno = consult.rsvno 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = '03' 
                                        and free.freecd = 'METASTS' || rsl.result
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                        and receipt.dayid >= :strdayid 
                                        and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                        and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                                ,
                        ";
                    }
                    sql += @"
                                            :dayid" + i;
                }
                sql += @"
                                         )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            sql += @"
                                ) statview 
                            where
                              rslview.rsvno = statview.rsvno 
                              and rslview.itemcd = statview.itemcd 
                            group by
                              rslview.rsvno
                              , rslview.result
                            ) final 
                        group by
                          final.rsvno
                    ) lastview
            ";

            sql += @"
                        where
                          receipt.csldate = :csldate 
                          and receipt.rsvno = consult.rsvno 
                          and receipt.csldate = consult.csldate 
                          and consult.perid = person.perid 
                          and consult.rsvno = lastview.rsvno(+)
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                          and receipt.dayid >= :strdayid 
                          and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                          and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                           ,
                        ";
                    }
                    sql += @"
                                       :dayid" + i;
                }
                sql += @"
                           )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            sql += @"
                            ) judcmtview 
                        where
                          not exists ( 
                                select
                                  * 
                                from
                                  totaljudcmt 
                                where
                                  totaljudcmt.rsvno = judcmtview.rsvno 
                                  and totaljudcmt.dispmode = :dispmode 
                                  and totaljudcmt.judcmtcd in (:metacmtnewcd, :metacmtnewcd2, :metacmtnewcd3)
                          ) 
                    order by
                      judcmtview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            List<dynamic> insertData = new List<dynamic>();

            ret = Insert.Normal;

            // 検索レコードが存在する場合
            if (current != null)
            {
                for (int i = 0; i < current.Count; i++)
                {
                    check1 = 0;
                    check2 = 0;
                    check3 = 0;

                    // 欠損値（結果未入力及び検査キャンセル）があった場合、メタボリックシンドロームコメント自動登録しない
                    if (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["waistrsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["tgrsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["hdlrsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["cbprsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["ebprsl"])) &&
                        (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["glycemiarsl"])) ||
                         !string.IsNullOrEmpty(Util.ConvertToString(current[i]["hba1crsl"]))))
                    {
                        // 腹囲が基準値以上の受診者のみ対象にする（男性：85以上、女性：90以上）
                        if ((Convert.ToInt64(current[i]["gender"]) == 1 &&
                            Convert.ToInt64(current[i]["waistrsl"]) >= 85) ||
                           (Convert.ToInt64(current[i]["gender"]) == 2 &&
                            Convert.ToInt64(current[i]["waistrsl"]) >= 90))
                        {
                            // 「TG：150以上」と「HDL：40未満」いずれか
                            // 或は「高脂血症」で薬剤治療中
                            if (Convert.ToInt64(current[i]["tgrsl"]) >= 150 ||
                                Convert.ToInt64(current[i]["hdlrsl"]) < 40 ||
                                Convert.ToInt64(current[i]["shisitsu"]) > 0)
                            {
                                check1 = 1;
                            }

                            // 「収縮期血圧：130以上」と「拡張期血圧：80以上」いずれか
                            // 或は「高血圧」で薬剤治療中
                            if (Convert.ToInt64(current[i]["cbprsl"]) >= 130 ||
                                Convert.ToInt64(current[i]["ebprsl"]) >= 85 ||
                                Convert.ToInt64(current[i]["ketsuatsu"]) > 0)
                            {
                                check2 = 1;
                            }

                            // 「FPG：110以上」と「HbA1c：5.5以上」いずれか
                            // 或は「糖尿症」で薬剤治療中
                            if (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["glycemiarsl"])))
                            {
                                if (Convert.ToDouble(current[i]["glycemiarsl"]) >= 5.5 ||
                                    Convert.ToInt64(current[i]["tounyou"]) > 0)
                                {
                                    check3 = 1;
                                }
                            }
                            else
                            {
                                if (Convert.ToInt64(current[i]["hba1crsl"]) >= 110 ||
                                    Convert.ToInt64(current[i]["tounyou"]) > 0)
                                {
                                    check3 = 1;
                                }
                            }

                            // メタボリックシンドローム対象者のみ指定総合コメント登録
                            // 「脂質」、「血圧」、「血糖」のリスク（失点）によって該当コメントを格納
                            insertData.Add(current[i]);
                            if ((check1 + check2 + check3) >= 2)
                            {
                                insertData[i]["judcmtcd"] = METACMT_NEWCD;
                            }
                            else
                            {
                                if ((check1 + check2 + check3) == 1)
                                {
                                    insertData[i]["judcmtcd"] = METACMT_NEWCD2;
                                }
                                else
                                {
                                    insertData[i]["judcmtcd"] = METACMT_NEWCD3;
                                }
                            }
                            count++;
                        }
                        else
                        {
                            // 腹囲が基準値範囲内の場合(腹囲が登録されていない受診者はコメント登録なし）
                            if (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["waistrsl"])))
                            {
                                insertData.Add(current[i]);
                                insertData[i]["judcmtcd"] = METACMT_NEWCD3;

                                count++;
                            }
                        }

                    }
                }

                if (count > 0)
                {
                    ret = InsertTotalJudCmt(insertData, TOTALCMT_DISPMODE);
                }

            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// メタボリックシンドローム総合コメント登録処理
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateMetaCmt3(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            long check1 = 0;                // 脂質関連チェック
            long check2 = 0;                // 血圧関連チェック
            long check3 = 0;                // 血糖関連チェック
            long count = 0;                 // レコード数

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Util.ConvertToString(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // メタボリックシンドローム総合コメント用のグループコード
            param.Add("grpcd", GLYCEMIA_ITEMCD);
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE);
            // メタボリックシンドローム用総合コメントコード
            param.Add("metacmtnewcd", METACMT_NEWCD);
            param.Add("metacmtnewcd2", METACMT_NEWCD2);
            param.Add("metacmtnewcd3", METACMT_NEWCD3);

            // メタボリックシンドローム関連検査項目コード
            param.Add("itemcd_glycemia", GLYCEMIA_ITEMCD);
            param.Add("suffix_glycemia", GLYCEMIA_SUFFIX);
            param.Add("itemcd_hba1c_ngsp", HBA1C_NGSP_ITEMCD);
            param.Add("suffix_hba1c_ngsp", HBA1C_NGSP_SUFFIX);
            param.Add("itemcd_hdl", HDL_ITEMCD);
            param.Add("suffix_hdl", HDL_SUFFIX);
            param.Add("itemcd_tg", TG_ITEMCD);
            param.Add("suffix_tg", TG_SUFFIX);
            param.Add("itemcd_cbp", CBP_ITEMCD);
            param.Add("suffix_cbp", CBP_SUFFIX);
            param.Add("itemcd_ebp", EBP_ITEMCD);
            param.Add("suffix_ebp", EBP_SUFFIX);
            param.Add("itemcd_waist", WAIST_ITEMCD);
            param.Add("suffix_waist", WAIST_SUFFIX);

            // メタボリックシンドロームチェック用結果データ取得（検査結果、病歴情報）
            sql = @"
                    select
                      judcmtview.rsvno as rsvno
                      , nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = judcmtview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , judcmtview.dayid as dayid
                      , judcmtview.perid as perid
                      , judcmtview.gender as gender
                      , judcmtview.glycemiarsl as glycemiarsl
                      , judcmtview.hba1crsl as hba1crsl
                      , judcmtview.hdlrsl as hdlrsl
                      , judcmtview.tgrsl as tgrsl
                      , judcmtview.cbprsl as cbprsl
                      , judcmtview.ebprsl as ebprsl
                      , judcmtview.waistrsl as waistrsl
                      , judcmtview.ketsuatsu as ketsuatsu
                      , judcmtview.tounyou as tounyou
                      , judcmtview.shisitsu as shisitsu
            ";

            sql += @"
                    from
                      ( 
                        select
                          receipt.rsvno as rsvno
                          , receipt.dayid as dayid
                          , consult.perid as perid
                          , consult.cscd as cscd
                          , person.lastname as lastname
                          , person.firstname as firstname
                          , person.gender as gender
            ";

            // 糖代謝判定用の検査結果を取得する
            // 空腹時血糖値
            sql += @"
                          , ( 
                              select
                                case 
                                  when ( 
                                    select
                                      count(*) 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_glycemia 
                                      and rsl.suffix = :suffix_glycemia 
                                      and rsl.stopflg is null 
                                      and rsl.result is not null
                                  ) = 0 
                                    then '' 
                                  else ( 
                                    select
                                      rsl.result 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_glycemia 
                                      and rsl.suffix = :suffix_glycemia
                                  ) 
                                  end result 
                              from
                                dual
                            ) glycemiarsl
            ";

            // HbA1c
            sql += @"
                        , ( 
                          select
                            case 
                              when ( 
                                select
                                  count(*) 
                                from
                                  rsl 
                                where
                                  rsl.rsvno = receipt.rsvno 
                                  and rsl.itemcd = :itemcd_hba1c_ngsp 
                                  and rsl.suffix = :suffix_hba1c_ngsp 
                                  and rsl.stopflg is null 
                                  and rsl.result is not null
                              ) = 0 
                                then '' 
                              else ( 
                                select
                                  rsl.result 
                                from
                                  rsl 
                                where
                                  rsl.rsvno = receipt.rsvno 
                                  and rsl.itemcd = :itemcd_hba1c_ngsp 
                                  and rsl.suffix = :suffix_hba1c_ngsp
                              ) 
                              end result 
                          from
                            dual
                        ) hba1crsl
            ";

            // 脂質代謝判定用の検査結果を取得する
            // HDL
            sql += @"
                          , ( 
                              select
                                case 
                                  when ( 
                                    select
                                      count(*) 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_hdl 
                                      and rsl.suffix = :suffix_hdl 
                                      and rsl.stopflg is null 
                                      and rsl.result is not null
                                  ) = 0 
                                    then '' 
                                  else ( 
                                    select
                                      rsl.result 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_hdl 
                                      and rsl.suffix = :suffix_hdl
                                  ) 
                                  end result 
                              from
                                dual
                            ) hdlrsl
            ";

            // TG
            sql += @"
                          , ( 
                               select
                                case 
                                  when ( 
                                    select
                                      count(*) 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_tg 
                                      and rsl.suffix = :suffix_tg 
                                      and rsl.stopflg is null 
                                      and rsl.result is not null
                                  ) = 0 
                                    then '' 
                                  else ( 
                                    select
                                      rsl.result 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_tg 
                                      and rsl.suffix = :suffix_tg
                                  ) 
                                  end result 
                              from
                                dual
                            ) tgrsl
            ";

            // 収縮期血圧結果
            sql += @"
                          , ( 
                              select
                                case 
                                  when ( 
                                    select
                                      count(*) 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_cbp 
                                      and rsl.suffix = :suffix_cbp 
                                      and rsl.stopflg is null 
                                      and rsl.result is not null
                                  ) = 0 
                                    then '' 
                                  else ( 
                                    select
                                      rsl.result 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_cbp 
                                      and rsl.suffix = :suffix_cbp
                                  ) 
                                  end result 
                              from
                                dual
                            ) cbprsl
            ";

            // 拡張期血圧結果
            sql += @"
                          , ( 
                              select
                                case 
                                  when ( 
                                    select
                                      count(*) 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_ebp 
                                      and rsl.suffix = :suffix_ebp 
                                      and rsl.stopflg is null 
                                      and rsl.result is not null
                                  ) = 0 
                                    then '' 
                                  else ( 
                                    select
                                      rsl.result 
                                    from
                                      rsl 
                                    where
                                      rsl.rsvno = receipt.rsvno 
                                      and rsl.itemcd = :itemcd_ebp 
                                      and rsl.suffix = :suffix_ebp
                                  ) 
                                  end result 
                              from
                                dual
                            ) ebprsl
            ";

            // 腹囲結果、病歴情報
            sql += @"
                        , ( 
                          select
                            case 
                              when ( 
                                select
                                  count(*) 
                                from
                                  rsl 
                                where
                                  rsl.rsvno = receipt.rsvno 
                                  and rsl.itemcd = :itemcd_waist 
                                  and rsl.suffix = :suffix_waist 
                                  and rsl.stopflg is null 
                                  and rsl.result is not null
                              ) = 0 
                                then '' 
                              else ( 
                                select
                                  rsl.result 
                                from
                                  rsl 
                                where
                                  rsl.rsvno = receipt.rsvno 
                                  and rsl.itemcd = :itemcd_waist 
                                  and rsl.suffix = :suffix_waist
                              ) 
                              end result 
                          from
                            dual
                        ) waistrsl
                        , decode(lastview.ketsuatsu, null, 0, lastview.ketsuatsu) as ketsuatsu
                        , decode(lastview.tounyou, null, 0, lastview.tounyou) as tounyou
                        , decode(lastview.shisitsu, null, 0, lastview.shisitsu) as shisitsu
            ";

            sql += @"
                        from
                          receipt
                          , consult
                          , person
                          , ( 
                            select
                              final.rsvno as rsvno
                              , sum(final.ketsuatsu) as ketsuatsu
                              , sum(final.tounyou) as tounyou
                              , sum(final.shisitsu) as shisitsu 
                            from
                              ( 
                                select
                                  rslview.rsvno as rsvno
                                  , rslview.result as diseasek
                                  , decode(rslview.result, '19', count(rslview.rsvno), 0) as ketsuatsu
                                  , decode(rslview.result, '48', count(rslview.rsvno), 0) as tounyou
                                  , decode(rslview.result, '47', count(rslview.rsvno), 0) as shisitsu
            ";

            sql += @"
                                from
                                  ( 
                                    select
                                      rsl.rsvno
                                      , free.freefield3 result
                                      , rsl.itemcd
                                      , rsl.suffix 
                                    from
                                      rsl
                                      , consult
                                      , receipt
                                      , grp_i
                                      , free 
                                    where
                                      receipt.csldate = :csldate 
                                      and consult.rsvno = receipt.rsvno 
                                      and grp_i.grpcd = :grpcd 
                                      and rsl.rsvno = consult.rsvno 
                                      and rsl.itemcd = grp_i.itemcd 
                                      and rsl.suffix = grp_i.suffix 
                                      and rsl.suffix = '01' 
                                      and free.freecd = 'METADIS' || rsl.result
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                      and receipt.dayid >= :strdayid 
                                      and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                  and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                            ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                  )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                  and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) rslview
            ";

            sql += @"
                                   , ( 
                                      select
                                        rsl.rsvno
                                        , rsl.result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                      from
                                        rsl
                                        , consult
                                        , receipt
                                        , grp_i
                                        , free 
                                      where
                                        receipt.csldate = :csldate 
                                        and consult.rsvno = receipt.rsvno 
                                        and grp_i.grpcd = :grpcd 
                                        and rsl.rsvno = consult.rsvno 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = '03' 
                                        and free.freecd = 'METASTS' || rsl.result
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                        and receipt.dayid >= :strdayid 
                                        and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                        and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                                ,
                        ";
                    }
                    sql += @"
                                            :dayid" + i;
                }
                sql += @"
                                         )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            sql += @"
                                    ) statview 
                                    where
                                      rslview.rsvno = statview.rsvno 
                                      and rslview.itemcd = statview.itemcd 
                                    group by
                                      rslview.rsvno
                                      , rslview.result
                                ) final 
                            group by
                              final.rsvno
                        ) lastview
            ";

            sql += @"
                    where
                        receipt.csldate = :csldate 
                        and receipt.rsvno = consult.rsvno 
                        and receipt.csldate = consult.csldate 
                        and consult.perid = person.perid 
                        and consult.rsvno = lastview.rsvno(+)
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                          and receipt.dayid >= :strdayid 
                          and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                          and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                           ,
                        ";
                    }
                    sql += @"
                                       :dayid" + i;
                }
                sql += @"
                           )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                         and consult.cscd = :cscd
                ";
            }

            sql += @"
                        ) judcmtview 
                    where
                      not exists ( 
                            select
                              * 
                            from
                              totaljudcmt 
                            where
                              totaljudcmt.rsvno = judcmtview.rsvno 
                              and totaljudcmt.dispmode = :dispmode 
                              and totaljudcmt.judcmtcd in (:metacmtnewcd, :metacmtnewcd2, :metacmtnewcd3)
                      ) 
                    order by
                      judcmtview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            List<dynamic> insertData = new List<dynamic>();

            ret = Insert.Normal;

            // 検索レコードが存在する場合
            if (current != null)
            {
                // 配列形式で格納する
                for (int i = 0; i < current.Count; i++)
                {
                    check1 = 0;
                    check2 = 0;
                    check3 = 0;

                    // 欠損値（結果未入力及び検査キャンセル）があった場合、メタボリックシンドロームコメント自動登録しない
                    if (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["waistrsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["tgrsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["hdlrsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["cbprsl"])) &&
                        !string.IsNullOrEmpty(Util.ConvertToString(current[i]["ebprsl"])) &&
                        (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["glycemiarsl"])) ||
                         !string.IsNullOrEmpty(Util.ConvertToString(current[i]["hba1crsl"]))))
                    {
                        // 腹囲が基準値以上の受診者のみ対象にする（男性：85以上、女性：90以上）
                        if ((Convert.ToInt64(current[i]["gender"]) == 1 &&
                            Convert.ToInt64(current[i]["waistrsl"]) >= 85) ||
                           (Convert.ToInt64(current[i]["gender"]) == 2 &&
                            Convert.ToInt64(current[i]["waistrsl"]) >= 90))
                        {
                            // 「TG：150以上」と「HDL：40未満」いずれか
                            // 或は「高脂血症」で薬剤治療中
                            if (Convert.ToInt64(current[i]["tgrsl"]) >= 150 ||
                                Convert.ToInt64(current[i]["hdlrsl"]) < 40 ||
                                Convert.ToInt64(current[i]["shisitsu"]) > 0)
                            {
                                check1 = 1;
                            }

                            // 「収縮期血圧：130以上」と「拡張期血圧：80以上」いずれか
                            // 或は「高血圧」で薬剤治療中
                            if (Convert.ToInt64(current[i]["cbprsl"]) >= 130 ||
                                Convert.ToInt64(current[i]["ebprsl"]) >= 85 ||
                                Convert.ToInt64(current[i]["ketsuatsu"]) > 0)
                            {
                                check2 = 1;
                            }

                            // 「FPG：110以上」FPG値が得られなかった場合「HbA1c：6.0以上」と
                            // 或は「糖尿症」で薬剤治療中
                            if (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["glycemiarsl"])))
                            {
                                if (Convert.ToDouble(current[i]["glycemiarsl"]) >= 110 ||
                                    Convert.ToInt64(current[i]["tounyou"]) > 0)
                                {
                                    check3 = 1;
                                }
                            }
                            else
                            {
                                if (Convert.ToInt64(current[i]["hba1crsl"]) >= 6 ||
                                    Convert.ToInt64(current[i]["tounyou"]) > 0)
                                {
                                    check3 = 1;
                                }
                            }

                            // メタボリックシンドローム対象者のみ指定総合コメント登録
                            // 「脂質」、「血圧」、「血糖」のリスク（失点）によって該当コメントを格納
                            insertData.Add(current[i]);
                            if ((check1 + check2 + check3) >= 2)
                            {
                                insertData[i]["judcmtcd"] = METACMT_NEWCD;
                            }
                            else
                            {
                                if ((check1 + check2 + check3) == 1)
                                {
                                    insertData[i]["judcmtcd"] = METACMT_NEWCD2;
                                }
                                else
                                {
                                    insertData[i]["judcmtcd"] = METACMT_NEWCD3;
                                }
                            }
                            count++;
                        }
                        else
                        {
                            // 腹囲が基準値範囲内の場合(腹囲が登録されていない受診者はコメント登録なし）
                            if (!string.IsNullOrEmpty(Util.ConvertToString(current[i]["waistrsl"])))
                            {
                                insertData.Add(current[i]);
                                insertData[i]["judcmtcd"] = METACMT_NEWCD3;

                                count++;
                            }
                        }

                    }
                }

                if (count > 0)
                {
                    ret = InsertTotalJudCmt(insertData, TOTALCMT_DISPMODE);
                }

            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 内視鏡総合コメントをセットする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateNaishikyouCmt(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // 内視鏡コメント判定用のITEMCD，SUFFIX
            param.Add("itemcd1", TOP_ITEMCD.Trim());
            param.Add("suffix1", TOP_SUFFIX.Trim());
            param.Add("itemcd2", LOWER1_ITEMCD.Trim());
            param.Add("suffix2", LOWER1_SUFFIX.Trim());
            param.Add("itemcd3", LOWER2_ITEMCD.Trim());
            param.Add("suffix3", LOWER2_SUFFIX.Trim());
            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE.ToString().Trim());

            // 検索条件にあった受診者の判定コメントコードを取得する
            sql = @"
                    select
                      nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = rslview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) maxseq
                      , rslview.rsvno
                      , rslview.judcmtcd 
                    from
                      ( 
                        select
                          rsl.rsvno
                          , stdvalue_c.judcmtcd 
                        from
                          stdvalue_c
                          , rsl
                          , consult
                          , receipt
            ";

            // 指定受診日の受付済み受診者を対象とする
            sql += @"
                        where
                          receipt.csldate = :csldate 
                          and receipt.rsvno = consult.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                and receipt.dayid >= :strdayid 
                                and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                            ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                  and consult.cscd = :cscd
                ";
            }

            // 対象の検査結果と判定コメントコードを取得
            sql += @"
                                  and rsl.rsvno = consult.rsvno 
                                  and ( 
                                    (rsl.itemcd = :itemcd1 and rsl.suffix = :suffix1) 
                                    or (rsl.itemcd = :itemcd2 and rsl.suffix = :suffix2) 
                                    or (rsl.itemcd = :itemcd3 and rsl.suffix = :suffix3)
                                  ) 
                                  and rsl.stdvaluecd = stdvalue_c.stdvaluecd
                              ) rslview
            ";

            // 総合コメントテーブルに登録されていないもの
            sql += @"
                    where
                      not exists ( 
                            select
                              * 
                            from
                              totaljudcmt 
                            where
                              totaljudcmt.rsvno = rslview.rsvno 
                              and totaljudcmt.dispmode = :dispmode 
                              and totaljudcmt.judcmtcd = rslview.judcmtcd
                      ) 
            ";



            sql += @"
                    order by
                      rslview.rsvno
            ";

            List<dynamic> current = connection.Query(sql, param).ToList();

            List<dynamic> insertData = new List<dynamic>();

            ret = Insert.Normal;

            // 検索レコードが存在する場合
            if (current != null)
            {
                // 配列形式で格納する
                for (int i = 0; i < current.Count; i++)
                {
                    ret = InsertTotalJudCmt(insertData, TOTALCMT_DISPMODE);
                }

            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コメントのない人に良好コメントをセットする
        /// </summary>
        /// <param name="data">
        /// csldate 受診日
        /// dayidflg 1:ID 範囲指定、2:ID任意指定
        /// strdayid 検索開始ＩＤ
        /// enddayid 検索終了ＩＤ
        /// cscd コースコード
        /// </param>
        /// <param name="arrDayId">検索ＩＤ（配列）</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateGoodCmt(JToken data, List<string> arrDayId)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data["csldate"]));
            // 当日ID範囲指定？
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                if (Convert.ToInt64(data["strdayid"]) <= Convert.ToInt64(data["enddayid"]))
                {
                    param.Add("strdayid", Convert.ToInt64(data["strdayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["enddayid"]));
                }
                else
                {
                    param.Add("strdayid", Convert.ToInt64(data["enddayid"]));
                    param.Add("enddayid", Convert.ToInt64(data["strdayid"]));
                }
            }
            else
            {
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    param.Add("dayid" + i, long.Parse(arrDayId[i]));
                }
            }
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                param.Add("cscd", Util.ConvertToString(data["cscd"]).Trim());
            }

            // 総合コメント登録用の表示モード
            param.Add("dispmode", TOTALCMT_DISPMODE.ToString().Trim());

            // ①受診コース、結果テーブルの要素から、判定すべき分類を抽出
            //※その際、乳房関連のダミー判定分類は、乳房の判定分類になるようCASE文で置き換え
            //②①で抽出した判定分類と実際の判定結果テーブルをJOIN。判定コードがセットされていなければフラグ成立
            //③フラグのカウントをサマリ。判定が全てセットされていると0になるはず。
            // #TODO VB source : vntArrMaxSeq(lngCount) = objMaxSeq + 1
            sql = @"
                    select
                      rslview.rsvno
                      , free.freefield1 judcmtcd
                      , (nvl( 
                        ( 
                          select
                            max(seq) 
                          from
                            totaljudcmt 
                          where
                            totaljudcmt.rsvno = rslview.rsvno 
                            and totaljudcmt.dispmode = :dispmode
                        ) 
                        , 0
                      ) + 1) maxseq 
                      from
                        free
                        , ( 
                          select distinct
                            rsvno 
                          from
                            ( 
                              select
                                rsvno
                                , sum(judcheck) nosetcount 
                              from
                                ( 
                                  select distinct
                                    targetjudclass.rsvno
                                    , nvl2(judrsl.judcd, 0, 1) judcheck 
                                  from
                                    judrsl
                                    , ( 
                                      select distinct
                                        consult.rsvno
                                        , case course_jud.judclasscd 
                                          when 54 then 24 
                                          when 55 then 24 
                                          when 56 then 24 
                                          else course_jud.judclasscd 
                                          end judclasscd
                                        , case course_jud.judclasscd 
                                          when 54 then null 
                                          when 55 then null 
                                          when 56 then null 
                                          else judclass.commentonly 
                                          end commentonly 
                                      from
                                        rsl
                                        , item_jud
                                        , judclass
                                        , course_jud
                                        , consult 
                                      where
                                        consult.rsvno in ( 
                                          select
                                            consult.rsvno 
                                          from
                                            consult
                                            , receipt 
                                          where
                                            receipt.csldate = :csldate 
                                            and consult.rsvno = receipt.rsvno
            ";

            // 当日ID範囲指定時
            if (Convert.ToInt64(data["dayidflg"]) == 1)
            {
                sql += @"
                                            and receipt.dayid >= :strdayid 
                                            and receipt.dayid <= :enddayid
                ";
            }
            else
            {
                sql += @"
                                and receipt.dayid in (
                ";
                for (int i = 0; i < arrDayId.Count; i++)
                {
                    if (i > 0)
                    {
                        sql += @"
                                            ,
                        ";
                    }
                    sql += @"
                                        :dayid" + i;
                }
                sql += @"
                                )
                ";
            }

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(Util.ConvertToString(data["cscd"]).Trim()))
            {
                sql += @"
                                  and consult.cscd = :cscd
                ";
            }

            sql += @"
                                                    ) 
                                                and rsl.rsvno = consult.rsvno 
                                                and course_jud.cscd = consult.cscd 
                                                and course_jud.judclasscd not in ('25') 
                                                and judclass.judclasscd = course_jud.judclasscd 
                                                and item_jud.judclasscd = course_jud.judclasscd 
                                                and rsl.itemcd = item_jud.itemcd 
                                                and rsl.stopflg is null
                                            ) targetjudclass 
                                        where
                                          targetjudclass.rsvno = judrsl.rsvno(+) 
                                          and targetjudclass.judclasscd = judrsl.judclasscd(+) 
                                          and targetjudclass.commentonly is null
                                    ) 
                                group by
                                  rsvno
                            ) 
                        where
                          nosetcount = 0
                    ) rslview 
                where
                  free.freecd = 'GOODCMT' 
                  and not exists ( 
                        select
                          * 
                        from
                          totaljudcmt 
                        where
                          totaljudcmt.rsvno = rslview.rsvno
            ";

            sql += @"
                            and totaljudcmt.judcmtcd not in ( 
                                  select
                                    freefield1 
                                  from
                                    free 
                                  where
                                    freecd like 'METACMT%'
                            ) 
                            and totaljudcmt.dispmode = :dispmode)
            ";

            List<dynamic> insertData = connection.Query(sql, param).ToList();

            // 検索レコードが存在する場合
            if (insertData != null)
            {
                ret = InsertTotalJudCmt(insertData, TOTALCMT_DISPMODE);
            }
            else
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 総合コメントを新規に追加する
        /// </summary>
        /// <param name="data">
        /// rsvno 予約番号
        /// JudCmtCd 判定コメントコード
        /// JudCmtCd2 判定コメントコード2
        /// </param>
        /// <param name="dispMode">表示モード</param>
        /// <param name="judCmtCd2Flg">true：judCmtCd2使用；false：judCmtCd1使用(デフォルト値</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertTotalJudCmt(List<dynamic> data, long dispMode, bool judCmtCd2Flg = false)
        {
            string sql;                     // SQLステートメント
            Insert ret = Insert.Error;      // 関数戻り値

            long bakRsvNo = 0;             //予約番号（退避用）
            long bakDispMode = 0;          //表示分類（退避用）
            long j = 0;                    //ループカウンタ
            long maxSeq = 0;               //Seq最大値

            List<dynamic> items = data.ToList<dynamic>();

            var sqlParamArray = new List<Dictionary<string, object>>();

            // キー及び更新値の設定
            for (int i = 0; i < items.Count; i++)
            {
                var updParam = new Dictionary<string, object>();
                updParam.Add("updrsvno", Util.ConvertToString(items[i]["rsvno"]));
                updParam.Add("upddispmode", dispMode);

                if ((bakRsvNo != Convert.ToInt64(items[i]["rsvno"])) || (bakDispMode != dispMode))
                {

                    j = 1;
                    bakRsvNo = Convert.ToInt64(items[i]["rsvno"]);
                    bakDispMode = dispMode;

                    // キー及び更新値の設定
                    var srcParam = new Dictionary<string, object>();
                    srcParam.Add("srcrsvno", Convert.ToInt64(items[i]["rsvno"]));
                    srcParam.Add("srcdispmode", dispMode);

                    sql = @"
                            select
                                nvl(max(seq), 0) maxseq 
                            from
                                totaljudcmt 
                            where
                                rsvno = :srcrsvno 
                                and dispmode = :srcdispmode
                    ";

                    dynamic current = connection.Query(sql, srcParam).FirstOrDefault();

                    // 検索レコードが存在する場合
                    if (current != null)
                    {
                        maxSeq = Convert.ToInt64(current.MAXSEQ);
                    }
                    else
                    {
                        maxSeq = 0;
                    }
                }
                else
                {
                    j = j + 1;
                }

                updParam.Add("updseq", maxSeq + j);
                if (!judCmtCd2Flg)
                {
                    // judCmtCd2Flg = false場合
                    updParam.Add("updjudcmtcd", Util.ConvertToString(items[i]["judcmtcd"]));
                }
                else
                {
                    // judCmtCd2Flg = true場合
                    updParam.Add("updjudcmtcd", Util.ConvertToString(items[i]["judcmtcd2"]));
                }

                sqlParamArray.Add(updParam);
            }

            //総合コメント更新
            sql = @"
                    insert 
                    into totaljudcmt 
                    values (
                        :updrsvno
                        , :upddispmode
                        , :updseq
                        , :updjudcmtcd
                    )
            ";

            connection.Execute(sql, sqlParamArray);

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

    }
}