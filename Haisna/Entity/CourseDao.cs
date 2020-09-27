using Dapper;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// コース情報データアクセスオブジェクト
    /// </summary>
    public class CourseDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public CourseDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// コースレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// cscd        コースコード
        /// csname      コース名
        /// cssname     コース略称
        /// csdiv       コース区分
        /// maincscd    メインコースコード
        /// webcolor    webカラー
        /// regularflg  定健フラグ
        /// secondflg   登録モード２次健診フラグ
        /// stay        登録モード受診時泊数
        /// stadiv      統計区分
        /// reportcd    統計区分
        /// </param>
        /// <returns>
        ///	Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistCourse_p(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;  // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", Convert.ToString(data["cscd"]));
            param.Add("csname", Convert.ToString(data["csname"]));
            param.Add("cssname", Convert.ToString(data["cssname"]));
            param.Add("csdiv", Convert.ToString(data["csdiv"]));
            param.Add("maincscd", Convert.ToString(data["maincscd"]));
            param.Add("webcolor", Convert.ToString(data["webcolor"]));
            param.Add("regularflg", Convert.ToString(data["regularflg"]));
            param.Add("secondflg", Convert.ToString(data["secondflg"]));
            param.Add("stay", Convert.ToString(data["stay"]));
            param.Add("stadiv", Convert.ToString(data["stadiv"]));
            param.Add("reportcd", Convert.ToString(data["reportcd"]));

            while (true)
            {
                // コーステーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update course_p
                            set
                              csname = :csname
                              , stadiv = :stadiv
                              , webcolor = :webcolor
                              , secondflg = :secondflg
                              , stay = :stay
                              , reportcd = :reportcd
                              , cssname = :cssname
                              , csdiv = :csdiv
                              , maincscd = :maincscd
                              , regularflg = :regularflg
                            where
                              cscd = :cscd
                           ";

                    int ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たすコーステーブルのレコードを取得
                sql = @"
                        select
                          cscd
                        from
                          course_p
                        where
                          cscd = :cscd
                       ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into course_p(
                          cscd
                          , csname
                          , stadiv
                          , webcolor
                          , secondflg
                          , stay
                          , cssname
                          , csdiv
                          , maincscd
                          , regularflg
                          , reportcd
                        )
                        values (
                          :cscd
                          , :csname
                          , :stadiv
                          , :webcolor
                          , :secondflg
                          , :stay
                          , :cssname
                          , :csdiv
                          , :maincscd
                          , :regularflg
                          , :reportcd
                        )
                      ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コースレコードを登録する（トランザクション対応）
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// --- 基本コース系
        /// cscd              コースコード
        /// csname            コース名
        /// stadiv            統計区分
        /// dayiddiv          当日ＩＤ発番区分
        /// webcolor          WEBカラー
        /// secondflg         ２次健診フラグ
        /// stay              受診時泊数
        /// govmng            政府管掌フラグ
        /// govmng12div       政府管掌一次二次区分
        /// govmngdiv         政府管掌健診区分
        /// govmngshaho       政府管掌社保区分
        /// --- コース内項目、グループ系
        /// edititem          コース内項目の更新有無（FALSEなら更新しない）
        /// cshno             コース履歴Ｎｏ
        /// itemcount         依頼項目数
        /// itemcd            依頼項目コード
        /// grpcount          グループ項目数
        /// grpcd             グループコード
        /// --- コース内判定系
        /// editjud           判定分類の更新有無（FALSEな
        /// itemcount         判定分類個数
        /// judclasscd        判定分類コード
        /// noreason          無条件展開フラグ
        /// seq               表示順番
        /// --- 検査項目実施日関連
        /// editcourseope     検査項目実施日の更新有無（FA
        /// opecount          項目実施日個数
        /// opeclasscd        項目実施日コード
        /// monmng            月曜受診時検査日
        /// tuemng            火曜受診時検査日
        /// wedmng            水曜受診時検査日
        /// thumng            木曜受診時検査日
        /// frimng            金曜受診時検査日
        /// satmng            土曜受診時検査日
        /// sunmng            日曜受診時検査日
        /// --- 財務連携データ関連
        /// zai_per_misyu     個人～未収
        /// zai_per_nyu       個人～当日入金
        /// zai_per_kakomi    個人～過去未収
        /// zai_per_kanmi     個人～還付未払
        /// zai_per_kantou    個人～還付当日払
        /// zai_per_kango     個人～還付後日払
        /// zai_org_misyu     団体～未収
        /// zai_org_nyu       団体～当日入金
        /// zai_org_kakomi    団体～過去未収
        /// zai_org_kanmi     団体～還付未払
        /// zai_org_kantou    団体～還付当日払
        /// zai_org_kango     団体～還付後日払
        /// --- 東急殿追加データ関連
        /// cssname           コース略称
        /// csdiv             コース区分
        /// maincscd          メインコースコード
        /// roundflg          まるめフラグ
        /// regularflg        定健フラグ
        /// starttime         開始時間
        /// endtime           終了時間
        /// kartereportcd     カルテ用帳票コード
        /// noprintmonoprice  請求単価未出力フラグ
        /// </param>
        /// <returns>
        ///	Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistCourse_All(string mode, JToken data)
        {
            Insert ret; // 関数戻り値

            ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    // グループテーブルの更新
                    ret = RegistCourse_p(mode, data);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    if (Convert.ToString(data["edititem"]) == "1")
                    {
                        // コース内項目の更新
                        ret = RegistCourse_Item(data);

                        // 異常終了なら処理終了
                        if (ret != Insert.Normal)
                        {
                            break;
                        }
                    }

                    if (Convert.ToString(data["editjud"]) == "1")
                    {
                        // コース内判定分類の更新
                        ret = RegistCourse_Jud(data);

                        // 異常終了なら処理終了
                        if (ret != Insert.Normal)
                        {
                            break;
                        }
                    }

                    if (Convert.ToString(data["editcourseope"]) == "1")
                    {
                        // コース内判定分類の更新
                        ret = RegistCourse_Ope(data);

                        // 異常終了なら処理終了
                        if (ret != Insert.Normal)
                        {
                            break;
                        }
                    }
                    ret = Insert.Normal;
                    break;
                }

                // 異常終了ならRollBack
                if (ret != Insert.Normal)
                {
                    transaction.Rollback();
                }
                else
                {
                    // トランザクションをコミット
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コース履歴レコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// cscd     コースコード
        /// cshno    コース履歴No
        /// strdate  使用開始日付
        /// enddate  使用終了日付
        /// price    コース基本料金
        /// </param>
        /// <param name="csHNo">新規時には発番したものをセット</param>
        /// <returns>
        ///	Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistCourse_h(string mode, JToken data, ref int csHNo)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", Convert.ToString(data["cscd"]));
            param.Add("strdate", Convert.ToDateTime(data["strdate"]));
            param.Add("enddate", Convert.ToDateTime(data["enddate"]));
            param.Add("price", Convert.ToString(data["price"]));

            // 履歴データの重複チェック
            if (mode.Equals("INS"))
            {
                sql = @"
                        select
                          cscd
                        from
                          course_h
                        where
                          cscd = :cscd
                          and (
                            :strdate between strdate and enddate
                            or :enddate between strdate and enddate
                          )
                    ";
            }
            else
            {
                // 履歴番号のバインド変数
                param.Add("cshno", Convert.ToInt32(data["cshno"]));

                sql = @"
                        select
                          cscd
                        from
                          course_h
                        where
                          cscd = :cscd
                          and cshno != :cshno
                          and (
                            :strdate between strdate and enddate
                            or :enddate between strdate and enddate
                          )
                    ";
            }

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 存在した場合、新規挿入不可
            if (current != null)
            {
                return Insert.HistoryDuplicate;
            }

            if (mode.Equals("UPD"))
            {
                // コース履歴管理テーブルレコードの更新
                sql = @"
                        update course_h
                        set
                          cscd = :cscd
                          , cshno = :cshno
                          , strdate = :strdate
                          , enddate = :enddate
                          , price = :price
                        where
                          cscd = :cscd
                          and cshno = :cshno
                    ";
                ret2 = connection.Execute(sql, param);

                if (ret2 > 0)
                {
                    ret = Insert.Normal;
                }
            }
            else
            {
                // 検索条件を満たすコーステーブルのレコードを取得
                sql = @"
                        select
                          nvl(max(cshno), 0) + 1 newseq
                        from
                          course_h
                        where
                          cscd = :cscd
                    ";

                // オブジェクトの参照設定（絶対に１件は返ってくる）
                int newSeq = connection.Query(sql, param).FirstOrDefault().NEWSEQ;

                // 最新履歴番号が100以内なら
                if (newSeq < 100)
                {
                    // 履歴番号のバインド変数
                    var param2 = new Dictionary<string, object>();
                    param2.Add("cshno", Convert.ToInt32(data["cshno"]));

                    // 新規挿入
                    sql = @"
                            insert
                            into course_h(cscd, cshno, strdate, enddate, price)
                            values (:cscd, :cshno, :strdate, :enddate, :price)
                        ";
                    connection.Execute(sql, param);

                    // 発番した履歴番号を引数にセット
                    csHNo = newSeq;

                    ret = Insert.Normal;
                }
                else
                {
                    // 履歴番号が最大数に達したらエラー（現時点では暫定的に、INSERT_DUPLICATEをセット）
                    ret = Insert.Duplicate;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コース内受診項目を登録する
        /// </summary>
        /// <param name="data">
        /// cscd       コースコード
        /// cshno      コース履歴Ｎｏ
        /// itemcount  依頼項目数
        /// itemcd     依頼項目コード
        /// grpcount   グループ項目数
        /// grpcd      グループコード
        /// </param>
        /// <returns>
        ///	Insert.Normal  正常終了
        ///	Insert.Error   異常終了
        /// </returns>
        public Insert RegistCourse_Item(JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", Convert.ToString(data["cscd"]));
            param.Add("cshno", Convert.ToInt32(data["cshno"]));

            // コース内グループ及び、コース内検査項目レコードの削除
            sql = @"
                    delete course_i
                    where
                      cscd = :cscd
                      and cshno = :cshno
                ";
            connection.Execute(sql, param);

            sql = @"
                    delete course_g
                    where
                      cscd = :cscd
                      and cshno = :cshno
                ";
            connection.Execute(sql, param);

            // コース内検査項目レコードが存在するなら
            List<JToken> items = data.ToObject<List<JToken>>();
            if (items.Count > 0)
            {
                // OraParameterオブジェクトの値設定
                var paramArray = new List<Dictionary<string, object>>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("cscd", Convert.ToString(rec["cscd"]));
                    param.Add("chno", Convert.ToInt32(rec["chno"]));
                    param.Add("itemcd", Convert.ToString(rec["itemcd"]));
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = @"
                        insert
                        into course_i(cscd, cshno, itemcd)
                        values (:cscd, :cshno, :itemcd)
                      ";
                connection.Execute(sql, paramArray);
            }

            //コース内グループレコードが存在するなら
            if (Convert.ToInt32(data["grpcount"]) > 0)
            {
                // OraParameterオブジェクトの値設定
                var paramArray = new List<Dictionary<string, object>>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("cscd", Convert.ToString(rec["cscd"]));
                    param.Add("chno", Convert.ToInt32(rec["chno"]));
                    param.Add("gprcd", Convert.ToString(rec["gprcd"]));
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = @"
                        insert
                        into course_g(cscd, cshno, grpcd)
                        values (:cscd, :cshno, :grpcd)
                      ";
                connection.Execute(sql, paramArray);
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コーステーブルレコードを削除する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        public bool DeleteCourse_p(String csCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd.Trim());

            // グループテーブルレコードの削除
            sql = @"
                    delete course_p
                    where
                      cscd = :cscd
                   ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// コース履歴管理テーブルレコードを削除する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="csHNo">コース履歴No</param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        public bool DeleteCourse_h(string csCd, int csHNo)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd.Trim());
            param.Add("cshno", csHNo);

            // グループテーブルレコードの削除
            sql = @"
                    delete course_h
                    where
                      cscd = :cscd
                      and cshno = :cshno
                ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// キーの大小比較
        /// </summary>
        /// <param name="key1">キー1</param>
        /// <param name="key2">キー2</param>
        /// <returns>
        /// 1   キー1 ＞ キー2
        /// 0   キー1 ＝ キー2
        /// -1  キー1 ＜ キー2
        /// </returns>
        private int CompareKey(Array key1, Array key2)
        {
            int ret = 0;  // 文字列比較関数の戻り値

            for (int i = 0; i < Information.UBound(key1); i++)
            {
                // 文字列比較
                ret = String.Compare(Convert.ToString(key1.GetValue(i)), Convert.ToString(key2.GetValue(i)));

                // 差異がある場合は比較を終了
                if (ret != 0)
                {
                    break;
                }
            }

            // 文字列比較の戻り値を編集
            return ret;
        }

        /// <summary>
        /// 指定コースにおいて指定期間を適用期間として含む履歴数を検索
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日</param>
        /// <param name="endDate">終了日</param>
        /// <returns>レコード件数</returns>
        public int GetHistoryCount(string csCd, DateTime? strDate, DateTime? endDate)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd.Trim());
            param.Add("strdate", strDate);
            param.Add("enddate", endDate);

            // 検索条件が適用期間として含まれるコース履歴管理テーブルのレコード数をカウント
            sql = @"
                    select
                      count(*) cnt
                    from
                      course_h
                    where
                      cscd = :cscd
                      and enddate >= :strdate
                ";

            if (endDate != null)
            {
                sql += " and strdate <= :enddate ";
            }

            return Convert.ToInt32(connection.Query(sql, param).FirstOrDefault().CNT);

        }

        /// <summary>
        /// コースコードに対するコース名を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// csname      コース名
        /// stadiv      統計区分
        /// webcolor    webカラー
        /// secondflg   登録モード２次健診フラグ
        /// stay        登録モード受診時泊数
        /// cssname     コース略称
        /// csdiv       コース区分
        /// maincscd    メインコースコード
        /// regularflg  定健フラグ
        /// </returns>
        public dynamic SelectCourse(string csCd)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", csCd.Trim());

            sql = @"
                    select
                      csname
                      , stadiv
                      , webcolor
                      , secondflg
                      , stay
                      , cssname
                      , csdiv
                      , maincscd
                      , regularflg
                    from
                      course_p
                    where
                      cscd = :cscd
                ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定契約情報におけるコース各履歴ごとの受診グループを取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// grpcd   グループコード
        /// grpname グループ名
        /// strdate 開始日
        /// enddate 終了日
        /// </returns>
        public List<dynamic> SelectCourseGroupIntoContract(string orgCd1, string orgCd2, int ctrPtCd)
        {
            string sql; // SQLステートメント
            List<dynamic> data = null;

            // キー値の設定
            var sqlParam = new
            {
                orgcd1 = orgCd1,
                orgcd2 = orgCd2,
                ctrptcd = ctrPtCd
            };

            // 指定契約情報において受診対象となるグループを取得
            sql = @"
                    select
                      course_g.grpcd
                      , grp_p.grpname
                      , course_h.strdate
                      , course_h.enddate
                    from
                      grp_p
                      , course_g
                      , course_h
                      , ctrmngwithperiod
                    where
                      ctrmngwithperiod.orgcd1 = :orgcd1
                      and ctrmngwithperiod.orgcd2 = :orgcd2
                      and ctrmngwithperiod.ctrptcd = :ctrptcd
                      and ctrmngwithperiod.cscd = course_h.cscd
                      and course_h.enddate >= ctrmngwithperiod.strdate
                      and course_h.strdate <= ctrmngwithperiod.enddate
                      and course_h.cscd = course_g.cscd
                      and course_h.cshno = course_g.cshno
                ";

            // 基本コース削除項目は除く
            sql += @"
                    and course_g.grpcd not in (
                    select
                    grpcd
                    from
                    ctrpt_grp
                    where
                    ctrptcd = ctrmngwithperiod.ctrptcd
                    and optcd =
                )
                and course_g.grpcd = grp_p.grpcd
                order by
                    grpcd
                    , strdate
                ";
            data = connection.Query(sql, sqlParam).ToList();

            //#ToDo Select後の.Net側での処理をどうするか
            //    '直前レコードと項目が異なる場合
            //    If strPrevGrpCd<> "" Then

            //       If strGrpCd<> strPrevGrpCd Then


            //            '適用期間・グループコード・グループ名を配列形式で格納する
            //            ReDim Preserve vntArrHistory(lngCount)
            //            ReDim Preserve vntArrHistoryCount(lngCount)
            //            ReDim Preserve vntArrGrpCd(lngCount)
            //            ReDim Preserve vntArrGrpName(lngCount)
            //            vntArrHistory(lngCount) = strHistory
            //            vntArrHistoryCount(lngCount) = lngHistoryCount
            //            vntArrGrpCd(lngCount) = strPrevGrpCd
            //            vntArrGrpName(lngCount) = strPrevGrpName
            //            lngCount = lngCount + 1


            //            '適用期間をクリア
            //            strHistory = ""
            //            lngHistoryCount = 0


            //        End If


            //    End If


            //    '適用開始・終了日を連結し、適用期間として編集
            //    strHistory = strHistory & IIf(strHistory <> "", ",", "") & objStrDate.Value & "," & objEndDate.Value
            //    lngHistoryCount = lngHistoryCount + 1


            //    '直前レコードの値を現内容で更新する
            //    strPrevGrpCd = strGrpCd
            //    strPrevGrpName = strGrpName


            //    objOraDyna.MoveNext

            //Loop

            //'適用期間文字列が残っている場合は配列に追加する
            //If strHistory<> "" Then
            //   ReDim Preserve vntArrHistory(lngCount)
            //    ReDim Preserve vntArrHistoryCount(lngCount)
            //    ReDim Preserve vntArrGrpCd(lngCount)
            //    ReDim Preserve vntArrGrpName(lngCount)
            //    vntArrHistory(lngCount) = strHistory
            //    vntArrHistoryCount(lngCount) = lngHistoryCount
            //    vntArrGrpCd(lngCount) = strPrevGrpCd
            //    vntArrGrpName(lngCount) = strPrevGrpName
            //    lngCount = lngCount + 1
            //End If

            //'適用期間、項目区分、項目コード順にソート
            //ReDim Preserve vntArrItemDiv(lngCount - 1)  '←引数合わせのためだけに作成
            //SortHistory vntArrHistory, vntArrItemDiv, vntArrGrpCd, vntArrGrpName, 0, UBound(vntArrHistory)
            return data;
        }

        /// <summary>
        /// コースの履歴を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日</param>
        /// <param name="endDate">終了日</param>
        /// <returns>
        /// strDate  使用開始日付
        /// endDate  使用終了日付
        /// price    コース基本料金
        /// tax      消費税
        /// csHNo    コース履歴番号
        /// </returns>
        public List<dynamic> SelectCourseHistory(string csCd, DateTime? strDate, DateTime? endDate)
        {
            // キー値の設定
            var sqlParam = new
            {
                cscd = csCd,
                strdate = strDate,
                enddate = endDate
            };

            // 指定期間のコース履歴より負担金額、消費税を取得
            // (1) 適用開始を境に適用する税率を切り替える
            // (2) 小数点第１位で切り上げするため、0.9を加算して切り捨て処理を行う
            string sql = @"
                           select
                              cshno
                              , strdate
                              , enddate
                              , price
                              , trunc(price * nvl(rate, 0) + 0.9, 0) tax
                            from
                              (
                                select
                                  course_h.cshno
                                  , course_h.strdate
                                  , course_h.enddate
                                  , course_h.price
                                  , case
                                    when course_h.strdate < free.freedate
                                      then free.freefield1
                                    else free.freefield2
                                    end rate
                                from
                                  free
                                  , course_h
                                where
                                  course_h.cscd = :cscd
                        ";

            // 指定コースより、指定期間に対象となる全ての履歴(期間指定がなければ全履歴)を取得
            if (strDate != null)
            {
                sql += " and course_h.enddate >= :strdate ";
            }

            if (endDate != null)
            {
                sql += " and course_h.strdate <= :enddate ";
            }

            // 消費税率を取得するため、汎用テーブルの消費税率情報を内部結合する
            sql += @"
                    and free.freecd       = 'TAX' ";

            // 適用開始日の昇順に取得
            sql += @"
                    )
                    order by
                      strdate
                ";

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 指定期間におけるコース各検査分類ごとの受診項目を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日</param>
        /// <param name="endDate">終了日</param>
        /// <param name="cdHNo">コース履歴番号（省略可能）</param>
        /// <returns>
        /// className  検査分類名称
        /// itemDiv    項目区分
        /// itemCd     項目コード
        /// itemName   名称
        /// </returns>
        public List<dynamic> SelectCourseItemOrderByClass(string csCd, DateTime strDate, DateTime? endDate, int cdHNo = -1)
        {
            // キー値の設定
            var sqlParam = new
            {
                cscd = csCd,
                strdate = strDate,
                enddate = endDate,
                cshno = cdHNo
            };

            // 指定コース・適用期間に受診対象となるグループ・依頼項目を取得
            string sql = @"
                           select
                            itemclass.classcd
                            , itemclass.classname
                            , itemview.itemdiv
                            , itemview.itemcd
                            , itemview.itemname
                           from
                            itemclass
                            ,
                        ";

            // 指定コース・適用期間に受診対象となるグループを取得
            sql += @"
                     (
                      select
                        grp_p.classcd
                        , 'G' itemdiv
                        , course_g.grpcd itemcd
                        , grp_p.grpname itemname
                      from
                        grp_p
                        , course_g
                        , course_h
                      where
                        course_h.cscd = :cscd
                        and course_h.enddate >= :strdate

                  ";

            // 終了日指定時は条件追加
            if (endDate != null)
            {
                sql += " and course_h.strdate <= :enddate ";
            }

            // 履歴番号直指定の場合は、条件追加
            if (cdHNo > -1)
            {
                sql += " and course_h.cshno <= :cshno ";
            }

            // 名称取得のために依頼項目テーブルを結合
            sql += @"
                     and course_h.cscd = course_i.cscd
                     and course_h.cshno = course_i.cshno
                     and course_i.itemcd = item_p.itemcd) itemview
                  ";

            // 検査分類テーブルを結合
            sql += " where itemview.classcd = itemclass.classcd ";

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 指定期間におけるコース各履歴ごとの受診項目を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日</param>
        /// <param name="endDate">終了日</param>
        /// <returns>
        /// itemdiv     項目区分
        /// itemcd      項目コード
        /// strdate     適用開始日
        /// enddate     適用終了日
        /// </returns>
        public dynamic SelectCourseItemOrderByHistory(string csCd, DateTime strDate, DateTime endDate)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                cscd = csCd,
                strdate = strDate,
                enddate = endDate
            };

            //指定契約情報において受診対象となるグループを取得
            sql = @"
                    select
                      'G' itemdiv
                      , course_g.grpcd itemcd
                      , grp_p.grpname itemname
                      , course_h.strdate
                      , course_h.enddate
                    from
                      grp_p
                      , course_g
                      , course_h
                    where
                      course_h.cscd = :cscd
                      and course_h.enddate >= :strdate
                ";

            if (endDate != null)
            {
                sql += " and course_h.strdate <= :enddate ";
            }

            sql += @"
                    and course_h.cscd = course_g.cscd
                    and course_h.cshno = course_g.cshno
                    and course_g.grpcd = grp_p.grpcd
                    union
                    select
                      'I' itemdiv
                      , course_i.itemcd itemcd
                      , item_p.requestname itemname
                      , course_h.strdate
                      , course_h.enddate
                    from
                      item_p
                      , course_i
                      , course_h
                    where
                      course_h.cscd = :cscd
                      and course_h.enddate >= :strdate
                ";

            if (endDate != null)
            {
                sql += " and course_h.strdate <= :enddate ";
            }

            sql += @"
                    and course_h.cscd = course_i.cscd
                    and course_h.cshno = course_i.cshno
                    and course_i.itemcd = item_p.itemcd
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            //#ToDo Select後の.Net側での処理をどうするか
            //    '直前レコードと項目が異なる場合
            //    If strPrevItemDiv<> "" Then
            //       If strItemDiv<> strPrevItemDiv Or strItemCd<> strPrevItemCd Then


            //            '適用期間・項目区分・コード・名称を配列形式で格納する
            //            ReDim Preserve vntArrHistory(lngCount)
            //            ReDim Preserve vntArrItemDiv(lngCount)
            //            ReDim Preserve vntArrItemCd(lngCount)
            //            ReDim Preserve vntArrItemName(lngCount)
            //            vntArrHistory(lngCount) = strHistory
            //            vntArrItemDiv(lngCount) = strPrevItemDiv
            //            vntArrItemCd(lngCount) = strPrevItemCd
            //            vntArrItemName(lngCount) = strPrevItemName
            //            lngCount = lngCount + 1


            //            '適用期間文字列をクリア
            //            strHistory = ""


            //        End If
            //    End If


            //    '適用開始・終了日を連結し、適用期間として編集
            //    strHistory = strHistory & IIf(strHistory <> "", ",", "") & objStrDate.Value & "," & objEndDate.Value


            //    '直前レコードの値を現内容で更新する
            //    strPrevItemDiv = strItemDiv
            //    strPrevItemCd = strItemCd
            //    strPrevItemName = strItemName


            //    objOraDyna.MoveNext

            //Loop


            //'適用期間文字列が残っている場合は配列に追加する
            //If strHistory<> "" Then
            //   ReDim Preserve vntArrHistory(lngCount)
            //    ReDim Preserve vntArrItemDiv(lngCount)
            //    ReDim Preserve vntArrItemCd(lngCount)
            //    ReDim Preserve vntArrItemName(lngCount)
            //    vntArrHistory(lngCount) = strHistory
            //    vntArrItemDiv(lngCount) = strPrevItemDiv
            //    vntArrItemCd(lngCount) = strPrevItemCd
            //    vntArrItemName(lngCount) = strPrevItemName
            //    lngCount = lngCount + 1
            //End If


            //'適用期間、項目区分、項目コード順にソート
            //SortHistory vntArrHistory, vntArrItemDiv, vntArrItemCd, vntArrItemName, 0, UBound(vntArrHistory)
            return data;

        }

        /// <summary>
        /// コースの一覧を取得する
        /// </summary>
        /// <param name="mode">取得モード（0:すべて、1:メインコース（契約可能なもの）のみ、2:サブコースのみ、3:メインコース（全て））</param>
        /// <returns>
        /// csCd       コースコード
        /// csName     コース名
        /// secondFlg  ２次健診フラグ
        /// </returns>
        public List<dynamic> SelectCourseList(int mode)
        {
            // キー値の設定
            var sqlParam = new
            {
                mode = mode
            };

            // コーステーブル読み込み
            string sql = @"
                        select
                          course_p.cscd
                          , course_p.csname
                          , course_p.secondflg
                          , course_p.maincscd maincscd
                          , maincourse.csname maincsname
                          , course_p.csdiv
                          , course_p.regularflg
                        from
                          course_p maincourse
                          , course_p
                        where
                          maincourse.cscd = course_p.maincscd
                      ";

            // メインコース（契約可能なもの）のみ取得する場合の条件を追加
            if (mode == 1)
            {
                sql += " and course_p.csdiv in (0, 1) ";
            }

            // サブコースのみ取得する場合の条件を追加
            if (mode == 2)
            {
                sql += " and course_p.csdiv in (0, 3) ";
            }

            // メインコース（全て）を取得する場合の条件を追加
            if (mode == 3)
            {
                sql += " and course_p.csdiv != 3 ";
            }
            sql += " order by course_p.cscd ";

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// コース判定分類の一覧を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// judClassCd     判定分類コード
        /// judClassName   判定分類名
        /// noReason       無条件展開フラグ
        /// seq            表示順番
        /// </returns>
        public List<dynamic> SelectCourse_JudList(string csCd)
        {
            // キー値の設定
            var sqlParam = new
            {
                cscd = csCd
            };

            //コース項目実施日テーブルのレコードを取得
            string sql = @"
                            select
                              opeclass.opeclasscd
                              , opeclass.opeclassname
                              , course_ope.monmng
                              , course_ope.tuemng
                              , course_ope.wedmng
                              , course_ope.thumng
                              , course_ope.frimng
                              , course_ope.satmng
                              , course_ope.sunmng
                            from
                              (
                                select
                                  opeclass.opeclasscd
                                  , opeclass.opeclassname
                                from
                                  opeclass
                              ) opeclass
                              , course_ope
                            where
                              opeclass.opeclasscd = course_ope.opeclasscd(+)
                              and :cscd = course_ope.cscd(+)
                       ";

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// コース項目実施日の一覧を取得する
        /// </summary>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// opeClassCd     検査実施日分類コード
        /// opeClassName   検査実施日分類名
        /// monMng         月曜受診時検査日
        /// tueMng         火曜受診時検査日
        /// wedMng         水曜受診時検査日
        /// thuMng         木曜受診時検査日
        /// friMng         金曜受診時検査日
        /// satMng         土曜受診時検査日
        /// sunMng         日曜受診時検査日
        /// </returns>
        public List<dynamic> SelectCourse_OpeList(string csCd)
        {
            // キー値の設定
            var sqlParam = new
            {
                cscd = csCd
            };

            string sql = @"
                            select
                              opeclass.opeclasscd
                              , opeclass.opeclassname
                              , course_ope.monmng
                              , course_ope.tuemng
                              , course_ope.wedmng
                              , course_ope.thumng
                              , course_ope.frimng
                              , course_ope.satmng
                              , course_ope.sunmng
                            from
                              (
                                select
                                  opeclass.opeclasscd
                                  , opeclass.opeclassname
                                from
                                  opeclass
                              ) opeclass
                              , course_ope
                            where
                              opeclass.opeclasscd = course_ope.opeclasscd(+)
                              and :cscd = course_ope.cscd(+)
                        ";

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// コース判定分類を登録する
        /// </summary>
        /// <param name="data">
        /// cscd        コースコード
        /// itemcount   判定分類個数
        /// judclasscd  判定分類コード
        /// noreason    無条件展開フラグ
        /// seq         表示順番
        /// </param>
        /// <returns>
        ///	Insert.Normal  正常終了
        ///	Insert.Error   異常終了
        /// </returns>
        public Insert RegistCourse_Jud(JToken data)
        {
            string sql; // SQLステートメント

            Insert ret; // 関数戻り値

            ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", Convert.ToString(data["cscd"]));

            // コース判定分類レコードの削除
            sql = @"
                    delete grp_r
                    where
                      grpcd = :grpcd
                ";

            connection.Execute(sql, param);

            List<JToken> items = data.ToObject<List<JToken>>();
            if (items.Count > 0)
            {
                // OraParameterオブジェクトの値設定
                var paramArray = new List<Dictionary<string, object>>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("cscd", Convert.ToString(data["cscd"]));
                    param.Add("judclasscd", Convert.ToString(rec["judclasscd"]));
                    param.Add("noreason", Convert.ToString(rec["noreason"]));
                    param.Add("seq", Convert.ToString(rec["seq"]));
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = "";
                sql = @"
                        insert
                        into course_jud(cscd, judclasscd, noreason, seq)
                        values (:cscd, :judclasscd, :noreason, :seq)
                    ";

                connection.Execute(sql, paramArray);
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コース項目実施日を登録する
        /// </summary>
        /// <param name="data">
        /// cscd        コースコード
        /// itemcount   項目実施日個数
        /// opeclasscd  項目実施日コード
        /// monmng      月曜受診時検査日
        /// tuemng      火曜受診時検査日
        /// wedmng      水曜受診時検査日
        /// thumng      木曜受診時検査日
        /// frimng      金曜受診時検査日
        /// satmng      土曜受診時検査日
        /// sunmng      日曜受診時検査日
        /// </param>
        /// <returns>
        ///	Insert.Normal  正常終了
        ///	Insert.Error   異常終了
        /// </returns>
        public Insert RegistCourse_Ope(JToken data)
        {
            string sql; // SQLステートメント

            Insert ret; // 関数戻り値

            ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("cscd", Convert.ToString(data["cscd"]));

            // コース判定分類レコードの削除
            sql = @"
                    delete course_ope
                    where
                      cscd = :cscd
                ";

            connection.Execute(sql, param);

            List<JToken> items = data.ToObject<List<JToken>>();
            if (items.Count > 0)
            {
                // キー及び更新値の設定再割り当て
                var paramArray = new List<Dictionary<string, object>>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("cscd", Convert.ToString(data["cscd"]));
                    param.Add("opeclasscd", Convert.ToString(rec["opeclasscd"]));
                    param.Add("monmng", Convert.ToString(rec["monmng"]));
                    param.Add("tuemng", Convert.ToString(rec["tuemng"]));
                    param.Add("wedmng", Convert.ToString(rec["wedmng"]));
                    param.Add("thumng", Convert.ToString(rec["thumng"]));
                    param.Add("frimng", Convert.ToString(rec["frimng"]));
                    param.Add("satmng", Convert.ToString(rec["satmng"]));
                    param.Add("sunmng", Convert.ToString(rec["sunmng"]));
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = "";
                sql = @"
                        insert
                        into course_ope(
                          cscd
                          , opeclasscd
                          , monmng
                          , tuemng
                          , wedmng
                          , thumng
                          , frimng
                          , satmng
                          , sunmng
                        )
                        values (
                          :cscd
                          , :opeclasscd
                          , :monmng
                          , :tuemng
                          , :wedmng
                          , :thumng
                          , :frimng
                          , :satmng
                          , :sunmng
                        )
                    ";

                connection.Execute(sql, paramArray);
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コース各履歴ごとの受診項目情報をソートする
        /// </summary>
        /// <param name="history">適用期間</param>
        /// <param name="itemDiv">項目区分</param>
        /// <param name="itemCd">項目コード</param>
        /// <param name="itemName">名称</param>
        /// <param name="startIndex">ソート開始位置</param>
        /// <param name="endIndex">ソート終端位置</param>
        private void SortHistory(ref List<string> history, ref List<string> itemDiv, ref List<string> itemCd, ref List<string> itemName, int startIndex, int endIndex)
        {
            int middleIndex;    // 中間位置のインデックス
            string[] middleKey; // 中間位置のキー情報
            string[] key;       // 現在検索位置のキー情報
            int startPos;       // 前方検索の現在位置
            int endPos;         // 後方検索の現在位置

            // 開始・終了インデックスからの中間位置を求める
            middleIndex = (startIndex + endIndex) / 2;

            // インデックスの初期設定
            startPos = startIndex;
            endPos = endIndex;

            // 中間位置のキー情報配列を作成
            middleKey = new string[3] { history[middleIndex], itemDiv[middleIndex], itemCd[middleIndex] };

            while (true)
            {
                // 前方から中間位置のキー情報以上の値を検索し、そのインデックスを取得
                while (true)
                {
                    key = new string[3] { history[startPos], itemDiv[startPos], itemCd[startPos] };

                    if (CompareKey(key, middleKey) >= 0)
                    {
                        break;
                    }

                    startPos = startPos + 1;
                }

                // 後方から中間位置のキー情報以下の値を検索し、そのインデックスを取得
                while (true)
                {
                    key = new string[3] { history[endPos], itemDiv[endPos], itemCd[endPos] };

                    if (CompareKey(key, middleKey) >= 0)
                    {
                        break;
                    }

                    endPos = endPos + 1;
                }

                // 前方検索と後方検索が交差すれば検索終了
                if (startPos >= endPos)
                {
                    break;
                }

                // 前方検索位置と後方検索位置との値を交換
                string strHistory = history[startPos];
                string endHistory = history[endPos];
                string strItemDiv = itemDiv[startPos];
                string endItemDiv = itemDiv[endPos];
                string strItemCd = itemCd[startPos];
                string endItemCd = itemCd[endPos];
                string strItemName = itemName[startPos];
                string endItemName = itemName[endPos];

                Swap(ref strHistory, ref endHistory);
                Swap(ref strItemDiv, ref endItemDiv);
                Swap(ref strItemCd, ref endItemCd);
                Swap(ref strItemName, ref endItemName);

                startPos = startPos + 1;
                endPos = endPos - 1;
            }

            // 前方検索部分のみでソート
            if (startIndex < startPos - 1)
            {
                SortHistory(ref history, ref itemDiv, ref itemCd, ref itemName, startIndex, startPos - 1);
            }

            // 後方検索部分のみでソート
            if (endIndex > endPos + 1)
            {
                SortHistory(ref history, ref itemDiv, ref itemCd, ref itemName, endPos + 1, endIndex);
            }
        }

        /// <summary>
        /// 値の交換
        /// </summary>
        /// <param name="value1">値1</param>
        /// <param name="value2">値2</param>
        private void Swap(ref string value1, ref string value2)
        {
            string value;   // 退避域

            value = value1;
            value1 = value2;
            value2 = value;
        }

        /// <summary>
        /// 受診者数取得（コース別）
        /// </summary>
        /// <param name="selDate">対象日付</param>
        /// <returns>
        /// csCode             コースコード
        /// csName             コース名
        /// webColor           Webカラー
        /// csSu               人数
        /// </returns>
        public List<dynamic> SelectSelDateCourse(string selDate)
        {
            // キー値の設定
            var sqlParam = new
            {
                seldate = selDate
            };

            // コース項目実施日テーブルのレコードを取得
            string sql = @"
                            select
                              consult.cscd
                              , course_p.csname
                              , webcolor
                              , count(consult.perid) as cssu
                            from
                              course_p
                              , consult
                            where
                              course_p.cscd = consult.cscd
                              and consult.cancelflg = '0'
                              and consult.csldate = :seldate
                            group by
                              consult.cscd
                              , webcolor
                              , course_p.csname
                       ";
            return connection.Query(sql, sqlParam).ToList();
        }
    }
}
