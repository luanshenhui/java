using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Bill;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 個人請求情報データアクセスオブジェクト
    /// </summary>
    public class PerBillDao : AbstractDao
    {
        private const string PREFIX_PERID = "ID:";  // 検索時の個人ＩＤ指定

        /// <summary>
        /// 個人情報データアクセスオブジェクト
        /// </summary>
        readonly PersonDao personDao;

        /// <summary>
        /// 請求情報データアクセスオブジェクト
        /// </summary>
        readonly DemandDao demandDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="personDao">個人情報データアクセスオブジェクト</param>
        /// <param name="demandDao">請求情報データアクセスオブジェクト</param>
        public PerBillDao(IDbConnection connection, PersonDao personDao, DemandDao demandDao) : base(connection)
        {
            this.personDao = personDao;
            this.demandDao = demandDao;
        }

        /// <summary>
        /// 半角数字チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合は長さ0の文字列)</returns>
        public string CheckNumeric(string itemName, string expression, long length, Check necessary = Check.None)
        {
            string message = "";  // エラーメッセージ

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression) || expression.Trim().Equals(""))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary == Check.Necessary)
                    {
                        message = itemName + "を入力して下さい。";
                    }
                    break;
                }

                // 桁数チェック
                if (expression.Trim().Length > length)
                {
                    message = itemName + "は" + length.ToString() + "文字以内の半角数字で入力して下さい。";
                    break;
                }

                // 半角数字チェック
                if (!Regex.IsMatch(expression.Trim(), @"^-?[0-9]+$"))
                {
                    message = itemName + "は" + length.ToString() + "文字以内の半角数字で入力して下さい。";
                    break;
                }

                break;
            }

            return message;
        }

        /// <summary>
        /// 入金Ｓｅｑを取得する
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <returns>
        /// 正値   ＳｅｑＮｏ
        /// 負値   異常終了
        /// </returns>
        public int GetPerPaymentSeq(DateTime paymentDate)
        {
            int paymentSeq = -1;  // 入金Ｎｏ
            int currentMaxSeq;    // 現個人ＩＤの最大値
            bool success = false;
            dynamic current = null;

            var param = new Dictionary<string, object>();
            param.Add("srcpaydate", paymentDate);

            while (true)
            {
                string sql = @"
                               select
                                 /*+ INDEX_DESC(PERPAYMENT PERPAYMENT_PKEY) */
                                 paymentseq
                                 , gettoday.today_date
                               from
                                 perpayment
                                 , (select sysdate today_date from dual) gettoday
                               where
                                 rownum = 1
                                 and paymentdate = :srcpaydate for update nowait
                            ";

                // 現SEQの最大値を取得する(他で処理中の場合は最大10回までリトライ)
                for (int i = 1; i <= 10; i++)
                {
                    success = true;

                    // 現入金Ｓｅｑの最大値を取得する
                    current = connection.Query(sql, param).FirstOrDefault();

                    if (success)
                    {
                        break;
                    }

                    // ちょっとだけ待つ
                    Thread.Sleep(1000);

                }

                // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                if (!success)
                {
                    throw new Exception("現在他業務にて入金情報を使用中のため、入金Ｎｏ発番処理は行えませんでした。");
                }

                // レコードが存在しない場合は初期値を発番
                if (current == null)
                {
                    paymentSeq = 1;
                    break;
                }

                // 先頭レコードのＳｅｑ（すなわち現在の最大値）を取得
                currentMaxSeq = current.PAYMENTSEQ;

                // インクリメントしつつ新Ｓｅｑを求める
                paymentSeq = currentMaxSeq + 1;

                break;
            }

            // 戻り値の設定
            return paymentSeq;
        }

        /// <summary>
        /// 請求明細行Noを取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>
        /// 正値   行Ｎｏ
        /// 負値   異常終了
        /// </returns>
        private int GetBillLineNo(DateTime dmdDate, int billSeq, int branchNo)
        {
            int billLineNo;     // 請求明細行Ｎｏ
            int currentMaxSeq;  // 現個人ＩＤの最大値
            bool success = false;
            dynamic current = null;

            var param = new Dictionary<string, object>();
            param.Add("dmddate", dmdDate.ToString("yyyy-MM-dd"));
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            while (true)
            {
                string sql = @"
                               select
                                 /*+ INDEX_DESC(PERBILL_C PERBILL_C_PKEY) */
                                 billlineno
                               from
                                 perbill_c
                               where
                                 rownum = 1
                                 and dmddate = :dmddate
                                 and billseq = :billseq
                                 and branchno = :branchno for update nowait
                            ";

                // 現SEQの最大値を取得する(他で処理中の場合は最大10回までリトライ)
                for (int i = 1; i <= 10; i++)
                {
                    success = true;

                    // 現入金Ｓｅｑの最大値を取得する
                    current = connection.Query(sql, param).FirstOrDefault();

                    if (success)
                    {
                        break;
                    }

                    // ちょっとだけ待つ
                    Thread.Sleep(1000);

                }

                // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                if (!success)
                {
                    throw new Exception("現在他業務にて入金情報を使用中のため、入金Ｎｏ発番処理は行えませんでした。");
                }

                // レコードが存在しない場合は初期値を発番
                if (current == null)
                {
                    billLineNo = 1;
                    break;
                }

                // 先頭レコードのＳｅｑ（すなわち現在の最大値）を取得
                currentMaxSeq = current.BILLLINENO;

                // インクリメントしつつ新Ｓｅｑを求める
                billLineNo = currentMaxSeq + 1;

                break;
            }

            // 戻り値の設定
            return billLineNo;
        }

        /// <summary>
        /// 団体条件節の追加
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        private void AppendCondition_OrgCd(ref Dictionary<string, object> param, ref string condition, string orgCd1, string orgCd2)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 団体コード１条件を追加
            if (!orgCd1.Equals(""))
            {
                sql = " and person.orgcd1 = :orgcd1";
            }

            // 配列に追加
            condition += sql;

            // 団体コード２条件を追加
            if (!orgCd2.Equals(""))
            {
                sql = " and person.orgcd2 = :orgcd2";
            }

            // 配列に追加
            condition += sql;

        }

        /// <summary>
        /// 全角文字条件節の追加
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>検索キーの集合
        /// <param name="length">検索キー集合の長さ</param>
        private void AppendCondition_Wide(ref Dictionary<string, object> param, ref string condition, string buffer, int paramNo, int length)
        {
            string sql = "";    // SQLステートメント
            string paramName2;  // パラメータ名
            string narrow;      // 半角変換後の文字列
            string buffer2;     // 文字列バッファ
            bool wideChar;
            string and = "and";
            if (paramNo == length - 1)
            {
                and = "";
            }

            // 全角文字列が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
            narrow = Strings.StrConv(buffer, VbStrConv.Narrow);
            wideChar = false;
            for (int i = 0; i < narrow.Length; i++)
            {
                if (Strings.Asc(narrow.Substring(i, 1)) < 0)
                {
                    wideChar = true;
                    break;
                }
            }

            // パラメータ追加
            string paramName = "name" + paramNo.ToString();
            param.Add(paramName, buffer + "%");

            while (true)
            {
                // カナ以外の全角文字が含まれる場合
                if (wideChar)
                {
                    sql = " ( person.lastname like :" + paramName + " or person.firstname like :" + paramName + " ) " + and + " ";
                    break;
                }

                // カナ名しか存在しない場合、以下の処理にて文字列置換を行う
                buffer2 = buffer;
                buffer2 = buffer2.Replace("ァ", "ア");
                buffer2 = buffer2.Replace("ィ", "イ");
                buffer2 = buffer2.Replace("ゥ", "ウ");
                buffer2 = buffer2.Replace("ェ", "エ");
                buffer2 = buffer2.Replace("ォ", "オ");
                buffer2 = buffer2.Replace("ッ", "ツ");
                buffer2 = buffer2.Replace("ャ", "ヤ");
                buffer2 = buffer2.Replace("ュ", "ユ");
                buffer2 = buffer2.Replace("ョ", "ヨ");

                // 置換前後で文字列値が異なる場合、双方の値で検索を行う
                if (!buffer2.Equals(buffer))
                {
                    // パラメータ追加
                    paramName2 = "cnvname" + paramNo.ToString();
                    param.Add(paramName2, buffer2 + "%");

                    sql = " ( person.lastkname like :" + paramName + " or person.firstkname like :" + paramName + " or person.lastkname like :" + paramName2 + " or person.firstkname like :" + paramName2 + " ) "+ and +" ";
                    break;
                }

                // 置換前後で文字列値が同一ならば通常の検索を行う
                sql = " ( person.lastkname like :" + paramName + " or person.firstkname like :" + paramName + " ) "+ and +" ";

                break;
            }

            // 配列に追加
            condition += sql;

        }

        /// <summary>
        /// 個人ＩＤ条件節の追加
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="condition">条件節の集合</param>
        /// <param name="buffer">検索キー</param>
        /// <param name="paramNo">パラメータ番号</param>
        /// <param name="length">検索キー集合の長さ</param>
        private void AppendCondition_PerId(ref Dictionary<string, object> param, ref string condition, string buffer, int paramNo, int length)
        {
            string sql;    // SQLステートメント
            string perId;  // 個人ＩＤ
            string and = "and";
            if (paramNo == length - 1)
            {
                and = "";
            }

            // 先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
            if (buffer.Length > 2 && buffer.Substring(0, PREFIX_PERID.Length).ToUpper().Equals(PREFIX_PERID))
            {
                perId = buffer.Substring(PREFIX_PERID.Length, buffer.Length - PREFIX_PERID.Length);
            }
            else
            {
                perId = buffer;
            }

            // パラメータ追加
            string paramName = "perid" + paramNo.ToString();
            param.Add(paramName, "");

            // 文字列の末尾が"*"なら部分検索
            if ("*".Equals(perId.Substring(perId.Length - 1, 1)))
            {
                param[paramName] = perId.Substring(0, perId.Length - 1) + "%";
                sql = " person.perid like :" + paramName + " "+ and +" ";
            }
            else
            {
                param[paramName] = perId;
                sql = " person.perid = :" + paramName+ " "+ and +" ";
            }

            // 配列に追加
            condition += sql;
        }

        /// <summary>
        /// 個人テーブル検索用条件節作成
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="key">検索キーの集合</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="delFlgUseOnly">True指定時は削除フラグが"0"(使用中)のレコードのみ検索</param>
        /// <param name="selectNoOrg">True指定時は団体未設定のレコードも検索</param>
        /// <returns>個人テーブル検索用の条件節</returns>
        private string CreateConditionForPersonList(ref Dictionary<string, object> param, string[] key, string orgCd1, string orgCd2, bool delFlgUseOnly, bool selectNoOrg)
        {
            string condition = "";  // 条件節の集合
            string buffer;          // 文字列バッファ
            string sql = "";        // SQLステートメント

            // 団体コード指定時
            if (!"".Equals(orgCd1) || !"".Equals(orgCd2))
            {
                // 団体コード条件を追加
                AppendCondition_OrgCd(ref param, ref condition, orgCd1, orgCd2);
            }
            // 団体コード未指定時
            else
            {
                // 団体未設定のレコードを検索しない場合は条件を追加
                if (!selectNoOrg)
                {
                    condition += " person.orgcd1 is not null and person.orgcd2 is not null and";
                }
            }

            // 使用中レコードのみ検索する場合は条件を追加
            if (delFlgUseOnly)
            {
                condition += " person.delflg = " + DelFlg.Used + "and ";
            }

            // 引数指定時
            if (key != null)
            {
                // 検索キー数分の条件節を追加
                for (int i = 0; i < key.Length; i++)
                {
                    // アプストロフィはOracleの単一引用符と重複するので予め置換
                    buffer = key[i];

                    // 検索キーのタイプを判別し、条件節に変換して追加
                    // 全角文字が含まれる(半角カナもここに含まれる)
                    if (personDao.IsWide(buffer))
                    {
                        AppendCondition_Wide(ref param, ref condition, buffer, i, key.Length);
                    }
                    // 個人ID
                    else if (personDao.IsPerId(buffer))
                    {
                        AppendCondition_PerId(ref param, ref condition, buffer, i, key.Length);
                    }
                    // 上記以外は個人IDとして検索
                    else
                    {
                        AppendCondition_PerId(ref param, ref condition, buffer, i, key.Length);
                    }
                }
            }

            // すべての条件節をANDで連結
            if (condition != null)
            {
                sql = "where" + condition;
            }
            return sql;

        }

        /// <summary>
        /// 請求日または請求書Ｎｏをキーに個人請求書一覧を検索するＳＱＬを作成する
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="sql">SQLステートメント</param>
        /// <param name="paymentflg">1:未収のみ 0:全て</param>
        /// <param name="delDisp">1:取消伝票除く 0:全て</param>
        /// <param name="startDmdDate">検索条件請求日（開始）</param>
        /// <param name="endDmdDate">検索条件請求日（終了）</param>
        /// <param name="searchDmdDate">検索条件請求日</param>
        /// <param name="searchBillSeq">検索条件請求書Ｓｅｑ</param>
        /// <param name="searchBranchNo">検索条件請求書枝番</param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        private bool SetPerBillViewSql(ref Dictionary<string, object> param, ref string sql, int paymentflg, int delDisp, string startDmdDate, string endDmdDate, string searchDmdDate, string searchBillSeq, string searchBranchNo)
        {
            sql = @"
                    from
                      (
                        select
                          lastview.dmddate
                          , lastview.billseq
                          , lastview.branchno
                          , lastview.rsvno
                          , lastview.cscd
                          , nvl(ctrpt.csname, course_p.csname) csname
                          , course_p.webcolor
                          , lastview.perid
                          , person.lastname
                          , person.firstname
                          , person.lastkname
                          , person.firstkname
                          , getcslage(person.birth) age
                          , person.gender
                          , lastview.percount
                          , org.orgsname
                          , org.orgkname
                          , lastview.price
                          , lastview.tax
                          , (lastview.price + lastview.tax) totalprice
                          , lastview.paymentdate
                          , lastview.paymentseq
                          , lastview.delflg
                        from
                          ctrpt
                          , course_p
                          , org
                          , person
                          , (
                            select
                              dmddate
                              , billseq
                              , branchno
                              , delflg
                              , paymentdate
                              , paymentseq
                              , nvl(baseperbill.perid, consult.perid) perid
                              , baseperbill.rsvno
                              , consult.orgcd1
                              , consult.orgcd2
                              , consult.cscd
                              , consult.ctrptcd
                              , price
                              , tax
                              , decode(cslcount, 0, percount, cslcount) percount
                            from
                              consult
                              , (
                                select
                                  perbill.dmddate
                                  , perbill.billseq
                                  , perbill.branchno
                                  , perbill.delflg
                                  , perbill.paymentdate
                                  , perbill.paymentseq
                                  , (
                                    select
                                      rsvno
                                    from
                                      perbill_csl
                                    where
                                      dmddate = perbill.dmddate
                                      and billseq = perbill.billseq
                                      and branchno = perbill.branchno
                                      and rownum = 1
                                  ) rsvno
                                  , (
                                    select
                                      perid
                                    from
                                      perbill_person
                                    where
                                      dmddate = perbill.dmddate
                                      and billseq = perbill.billseq
                                      and branchno = perbill.branchno
                                      and rownum = 1
                                  ) perid
                                  , (
                                    select
                                      sum(price + editprice)
                                    from
                                      perbill_c
                                    where
                                      dmddate = perbill.dmddate
                                      and billseq = perbill.billseq
                                      and branchno = perbill.branchno
                                  ) price
                                  , (
                                    select
                                      sum(taxprice + edittax)
                                    from
                                      perbill_c
                                    where
                                      dmddate = perbill.dmddate
                                      and billseq = perbill.billseq
                                      and branchno = perbill.branchno
                                  ) tax
                                  , (
                                    select
                                      count(distinct rsvno)
                                    from
                                      perbill_csl
                                    where
                                      dmddate = perbill.dmddate
                                      and billseq = perbill.billseq
                                      and branchno = perbill.branchno
                                  ) cslcount
                                  , (
                                    select
                                      count(distinct perid)
                                    from
                                      perbill_person
                                    where
                                      dmddate = perbill.dmddate
                                      and billseq = perbill.billseq
                                      and branchno = perbill.branchno
                                  ) percount
                                from
                                  perbill
                        ";

            // 請求書Ｎｏ指定
            if (!searchDmdDate.Equals("") && !searchBillSeq.Equals("") && !searchBranchNo.Equals(""))
            {
                param.Add("dmddate", searchDmdDate);
                param.Add("billseq", searchBillSeq);
                param.Add("branchno", searchBranchNo);
                sql += @"
                         where
                           perbill.dmddate = :dmddate
                           and perbill.billseq = :billseq
                           and perbill.branchno = :branchno
                      ";
            }
            else if (!searchDmdDate.Equals("") && !searchBillSeq.Equals(""))
            {
                param.Add("dmddate", searchDmdDate);
                param.Add("billseq", searchBillSeq);
                sql += @"
                         where
                            perbill.dmddate = :dmddate
                           and perbill.billseq = :billseq
                      ";
            }
            else if (!searchDmdDate.Equals("") && !searchBranchNo.Equals(""))
            {
                param.Add("dmddate", searchDmdDate);
                param.Add("branchno", searchBranchNo);
                sql += @"
                         where
                            perbill.dmddate = :dmddate
                           and perbill.branchno = :branchno
                      ";
            }
            else if (!searchDmdDate.Equals(""))
            {
                param.Add("dmddate", searchDmdDate);
                sql += @"
                         where
                            perbill.dmddate = :dmddate
                      ";
            }
            else
            {
                // 請求日範囲指定
                if ((startDmdDate != null && !startDmdDate.Equals("")) && (endDmdDate != null && !endDmdDate.Equals("")))
                {
                    param.Add("sdmddate", startDmdDate);
                    param.Add("edmddate", endDmdDate);
                    sql += "                 where perbill.dmddate between :sdmddate  and :edmddate";
                }
                else
                {
                    // 請求日開始日のみ指定
                    if (startDmdDate != null && !startDmdDate.Equals(""))
                    {
                        param.Add("sdmddate", startDmdDate);
                        sql += "                 where perbill.dmddate >= :sdmddate  ";
                    }
                    else if (endDmdDate != null && !endDmdDate.Equals(""))
                    {
                        param.Add("edmddate", endDmdDate);
                        sql += "                 where perbill.dmddate <= :edmddate  ";
                    }
                }
            }

            // 未収のみ
            if (paymentflg == 1)
            {
                sql += "                   and perbill.paymentdate is null  ";
            }

            // 取消伝票を除く
            if (delDisp == 1)
            {
                sql += "                   and perbill.delflg = 0  ";
            }

            sql += @"
                     ) baseperbill
                     where
                       baseperbill.rsvno = consult.rsvno(+)) lastview
                     where
                       lastview.perid = person.perid(+)
                       and lastview.orgcd1 = org.orgcd1(+)
                       and lastview.orgcd2 = org.orgcd2(+)
                       and lastview.cscd = course_p.cscd(+)
                       and lastview.ctrptcd = ctrpt.ctrptcd(+)) listview
                      ";

            return true;
        }

        /// <summary>
        /// 個人情報をキーに個人請求書一覧を検索するＳＱＬを作成する
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="sql">SQLステートメント</param>
        /// <param name="paymentflg">1:未収のみ 0:全て</param>
        /// <param name="delDisp">1:取消伝票除く 0:全て</param>
        /// <param name="key">検索キー(空白で分割後のキー）</param>
        /// <param name="searchPer">検索条件個人ＩＤ</param>
        /// <param name="startDmdDate">検索条件請求日（開始）</param>
        /// <param name="endDmdDate">検索条件請求日（終了）</param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        private bool SetPersonViewSql(ref Dictionary<string, object> param, ref string sql, int paymentflg, int delDisp, string[] key, string searchPer, string startDmdDate, string endDmdDate)
        {
            string sql2 = "";
            bool delFlgUseOnly;
            bool selectNoOrg;

            sql = @"
                    from
                      (
                        select
                          perbill.dmddate
                          , perbill.billseq
                          , perbill.branchno
                          , lastview.rsvno
                          , lastview.cscd
                          , lastview.csname
                          , lastview.webcolor
                          , lastview.perid
                          , lastview.lastname
                          , lastview.firstname
                          , lastview.lastkname
                          , lastview.firstkname
                          , lastview.age
                          , lastview.gender
                          , (
                            (
                              select
                                count(distinct rsvno)
                              from
                                perbill_csl
                              where
                                dmddate = perbill.dmddate
                                and billseq = perbill.billseq
                                and branchno = perbill.branchno
                            ) + (
                              select
                                count(distinct perid)
                              from
                                perbill_person
                              where
                                dmddate = perbill.dmddate
                                and billseq = perbill.billseq
                                and branchno = perbill.branchno
                            )
                          ) percount
                          , lastview.orgsname
                          , lastview.orgkname
                          , (
                            select
                              sum(price + editprice)
                            from
                              perbill_c
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) price
                          , (
                            select
                              sum(taxprice + edittax)
                            from
                              perbill_c
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) tax
                          , (
                            select
                              sum(price + editprice + taxprice + edittax)
                            from
                              perbill_c
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) totalprice
                          , perbill.paymentdate
                          , perbill.paymentseq
                          , perbill.delflg
                        from
                          perbill
                          , (
                            (
                              select
                                consult.rsvno
                                , consult.orgcd1
                                , consult.orgcd2
                                , org.orgsname
                                , org.orgkname
                                , consult.cscd
                                , nvl(ctrpt.csname, course_p.csname) csname
                                , course_p.webcolor
                                , consult.perid
                                , person.lastname
                                , person.firstname
                                , person.lastkname
                                , person.firstkname
                                , getcslage(person.birth) age
                                , person.gender
                                , perbill_csl.dmddate
                                , perbill_csl.billseq
                                , perbill_csl.branchno
                              from
                                perbill_csl
                                , org
                                , person
                                , ctrpt
                                , course_p
                                , consult
                        ";

            // 請求日範囲指定
            if (!"".Equals(startDmdDate) && !"".Equals(endDmdDate))
            {
                param.Add("sdmddate", startDmdDate);
                param.Add("edmddate", endDmdDate);
                sql += "where consult.csldate between :sdmddate  and :edmddate";
            }
            else
            {
                // 請求日開始日のみ指定
                if (!"".Equals(startDmdDate) && !"".Equals(endDmdDate))
                {
                    param.Add("sdmddate", startDmdDate);
                    sql += "                 where consult.csldate = :sdmddate  ";
                }
            }

            // 検索キー 指定？
            if (key.Length > 0 && !"".Equals(key[0]))
            {
                delFlgUseOnly = false;
                selectNoOrg = true;

                sql2 = CreateConditionForPersonList(ref param, key, "", "", delFlgUseOnly, selectNoOrg);
                sql += " and consult.perid in (select distinct perid from person " + sql2 + " )";
            }
            else
            {
                if (!"".Equals(searchPer))
                {
                    param.Add("perid", searchPer);
                    sql += "             and consult.perid = :perid  ";
                }
            }
            sql += @"
                     and consult.cscd = course_p.cscd
                     and consult.ctrptcd = ctrpt.ctrptcd
                     and consult.perid = person.perid
                     and org.orgcd1 = consult.orgcd1
                     and org.orgcd2 = consult.orgcd2
                     and consult.rsvno = perbill_csl.rsvno)
                     union (
                       select
                         null
                         , null
                         , null
                         , null
                         , null
                         , null
                         , null
                         , null
                         , perbill_person.perid
                         , person.lastname
                         , person.firstname
                         , person.lastkname
                         , person.firstkname
                         , getcslage(person.birth) age
                         , person.gender
                         , perbill_person.dmddate
                         , perbill_person.billseq
                         , perbill_person.branchno
                       from
                         person
                         , perbill
                         , perbill_person
                    ";

            // 検索キー 指定？
            if (key.Length > 0 && !"".Equals(key[0]))
            {
                sql += " where perbill_person.perid in (select distinct perid from person " + sql2 + " )";
            }
            else
            {
                if (!"".Equals(searchPer))
                {
                    sql += "           where perbill_person.perid = :perid  ";
                }
            }

            sql += @"
                     and perbill.dmddate = perbill_person.dmddate
                     and perbill.billseq = perbill_person.billseq
                     and perbill.branchno = perbill_person.branchno
                 ";

            // 請求日範囲指定
            if (!"".Equals(startDmdDate) && !"".Equals(endDmdDate))
            {
                sql += "        and perbill.dmddate between :sdmddate  and :edmddate";
            }
            else
            {
                // 請求日開始日のみ指定
                if (!"".Equals(startDmdDate) && !"".Equals(endDmdDate))
                {
                    sql += "    and perbill.dmddate = :sdmddate  ";
                }
            }

            sql += @"
                     and person.perid = perbill_person.perid)) lastview
                     where
                       lastview.dmddate = perbill.dmddate
                       and lastview.billseq = perbill.billseq
                       and lastview.branchno = perbill.branchno
                    ";

            // 未収のみ
            if (paymentflg == 1)
            {
                sql += "    and perbill.paymentdate is null  ";
            }

            // 取消伝票を除く
            if (delDisp == 1)
            {
                sql += "     and perbill.delflg = 0  ";
            }

            sql += ")listview";

            return true;
        }

        /// <summary>
        /// 団体情報をキーに個人請求書一覧を検索するＳＱＬを作成する
        /// </summary>
        /// <param name="param">OraParametersオブジェクト</param>
        /// <param name="sql">SQLステートメント</param>
        /// <param name="paymentflg">1:未収のみ 0:全て</param>
        /// <param name="delDisp">1:取消伝票除く 0:全て</param>
        /// <param name="searchPerId">検索条件個人ＩＤ</param>
        /// <param name="searchOrg1">検索条件団体コード１</param>
        /// <param name="searchOrg2">検索条件団体コード２</param>
        /// <param name="startDmdDate">検索条件請求日（開始）</param>
        /// <param name="endDmdDate">検索条件請求日（終了）</param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        private bool SetOrgViewSql(ref Dictionary<string, object> param, ref string sql, int paymentflg, int delDisp, string searchPerId, string searchOrg1, string searchOrg2, string startDmdDate, string endDmdDate)
        {
            sql = @"
                    from
                      (
                        select
                          perbill.dmddate
                          , perbill.billseq
                          , perbill.branchno
                          , lastview.rsvno
                          , lastview.cscd
                          , lastview.csname
                          , lastview.webcolor
                          , lastview.perid
                          , lastview.lastname
                          , lastview.firstname
                          , lastview.lastkname
                          , lastview.firstkname
                          , lastview.age
                          , lastview.gender
                          , (
                            select
                              count(distinct rsvno)
                            from
                              perbill_csl
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) percount
                          , lastview.orgsname
                          , lastview.orgkname
                          , (
                            select
                              sum(price + editprice)
                            from
                              perbill_c
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) price
                          , (
                            select
                              sum(taxprice + edittax)
                            from
                              perbill_c
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) tax
                          , (
                            select
                              sum(price + editprice + taxprice + edittax)
                            from
                              perbill_c
                            where
                              dmddate = perbill.dmddate
                              and billseq = perbill.billseq
                              and branchno = perbill.branchno
                          ) totalprice
                          , perbill.paymentdate
                          , perbill.paymentseq
                          , perbill.delflg
                        from
                          perbill
                          , (
                            select
                              consult.rsvno
                              , consult.orgcd1
                              , consult.orgcd2
                              , org.orgsname
                              , org.orgkname
                              , consult.cscd
                              , nvl(ctrpt.csname, course_p.csname) csname
                              , course_p.webcolor
                              , consult.perid
                              , person.lastname
                              , person.firstname
                              , person.lastkname
                              , person.firstkname
                              , getcslage(person.birth) age
                              , person.gender
                              , perbill_csl.dmddate
                              , perbill_csl.billseq
                              , perbill_csl.branchno
                            from
                              perbill_csl
                              , org
                              , person
                              , ctrpt
                              , course_p
                              , consult
                        ";

            // 請求日範囲指定
            if (!"".Equals(startDmdDate) && !"".Equals(endDmdDate))
            {
                param.Add("sdmddate", startDmdDate);
                param.Add("edmddate", endDmdDate);
                sql += "                 where consult.csldate between :sdmddate  and :edmddate";
            }
            else
            {
                // 請求日開始日のみ指定
                if (!"".Equals(startDmdDate) && !"".Equals(endDmdDate))
                {
                    param.Add("sdmddate", startDmdDate);
                    sql += "                 where consult.csldate = :sdmddate  ";
                }
            }

            // 団体コード指定
            if (!"".Equals(searchOrg1) && !"".Equals(searchOrg2))
            {
                param.Add("orgcd1", searchOrg1);
                param.Add("orgcd2", searchOrg2);
                sql += " AND CONSULT.ORGCD1 = :ORGCD1 AND CONSULT.ORGCD2 = :ORGCD2 ";
            }

            // 個人ＩＤ指定
            if (!"".Equals(searchPerId) && searchPerId != null)
            {
                param.Add("perid", searchPerId);
                sql += "             and consult.perid = :perid  ";
            }

            sql += @"
                     and consult.cscd = course_p.cscd
                     and consult.ctrptcd = ctrpt.ctrptcd
                     and consult.perid = person.perid
                     and org.orgcd1 = consult.orgcd1
                     and org.orgcd2 = consult.orgcd2
                     and consult.rsvno = perbill_csl.rsvno) lastview
                     where
                       lastview.dmddate = perbill.dmddate
                       and lastview.billseq = perbill.billseq
                       and lastview.branchno = perbill.branchno
                 ";


            // 未収のみ
            if (paymentflg == 1)
            {
                sql += "                   and perbill.paymentdate is null  ";
            }

            // 取消伝票を除く
            if (delDisp == 1)
            {
                sql += "                   and perbill.delflg = 0  ";
            }

            sql += ")listview";
            return true;
        }

        /// <summary>
        /// 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>
        /// perId       個人ＩＤ
        /// lastName    姓
        /// firstName   名
        /// lastKName   カナ姓
        /// firstKName  カナ名
        /// </returns>
        public List<dynamic> SelectPerBill_person(string dmdDate, int billSeq, int branchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", Convert.ToDateTime(dmdDate));
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            // 検索条件を満たす個人請求書管理情報テーブルのレコードを取得
            string sql = @"
                           select
                             perbill_person.perid
                             , person.lastname
                             , person.firstname
                             , person.lastkname
                             , person.firstkname
                           from
                             perbill_person
                             , person
                           where
                             perbill_person.dmddate = :dmddate
                             and perbill_person.billseq = :billseq
                             and perbill_person.branchno = :branchno
                             and perbill_person.perid = person.perid(+)
                           order by
                             perbill_person.perid
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書Ｎｏから個人請求明細情報を取得する（受診情報に関連付けされない個人情報の取得）
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>
        /// billLineNo  請求明細行No
        /// price       金額
        /// editPrice   調整金額
        /// taxPrice    税額
        /// editTax     調整税額
        /// lineName    明細名称
        /// otherLineDivCd セット外明細コード
        /// otherLineDivName セット外明細名
        /// </returns>
        public List<dynamic> SelectPerBill_Person_c(string dmdDate, int billSeq, int branchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", dmdDate);
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            // 検索条件を満たす個人請求書明細情報テーブルのレコードを取得
            string sql = @"
                           select
                             perbill_c.billlineno
                             , perbill_c.price
                             , perbill_c.editprice
                             , perbill_c.taxprice
                             , perbill_c.edittax
                             , perbill_c.linename
                             , perbill_c.otherlinedivcd
                             , otherlinediv.otherlinedivname
                           from
                             perbill_c
                             , otherlinediv
                           where
                             perbill_c.dmddate = :dmddate
                             and perbill_c.billseq = :billseq
                             and perbill_c.branchno = :branchno
                             and perbill_c.otherlinedivcd = otherlinediv.otherlinedivcd(+)
                           order by
                             perbill_c.dmddate
                             , perbill_c.billseq
                             , perbill_c.branchno
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人入金情報テーブルレコードを削除する
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <param name="paymentSeq">入金Ｓｅｑ</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeletePerPayment(DateTime paymentDate, int paymentSeq)
        {
            bool ret;

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // キー値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("paymentdate", paymentDate);
                    param.Add("paymentseq", paymentSeq);

                    // 請求情報の入金情報クリア
                    string sql = @"
                                   update perbill
                                   set
                                     paymentdate = ''
                                     , paymentseq = ''
                                   where
                                     paymentdate = :paymentdate
                                     and paymentseq = :paymentseq
                                ";

                    connection.Execute(sql, param);

                    // 入金情報削除
                    sql = @"
                            delete perpayment
                            where
                              paymentdate = :paymentdate
                              and paymentseq = :paymentseq
                        ";
                    connection.Execute(sql, param);

                    // 戻り値の設定
                    ret = true;

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // 戻り値の設定
                    ret = false;

                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();
                }
            }

            return ret;
        }

        /// <summary>
        /// 個人入金情報テーブルにレコードを挿入する
        /// </summary>
        /// <param name="mode">1:入金　2:返金</param>
        /// <param name="data">
        /// originaldate   元の入金日（入金の場合"")
        /// originalseq    元の入金Ｓｅｑ（入金の場合"")
        /// dmddate        請求日（配列）
        /// billseq        請求書Ｓｅｑ（配列）
        /// branchno       請求書枝番（配列）
        /// registerno     レジ番号
        /// upduser         ユーザＩＤ
        /// pricetotal     請求金額合計
        /// credit         現金預かり金
        /// happy_ticket   ハッピー買物券
        /// card           カード
        /// cardkind       カード種別
        /// creditslipno   伝票No
        /// jdebit         Ｊデビット
        /// bankcode       金融機関コード
        /// cheque         小切手
        /// </param>
        /// <param name="re_PaymentDate">入金日または返金</param>
        /// <param name="re_PaymentSeq">入金または返金Ｓｅｑ</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> InsertPerPayment(int mode, PerBillIncome data, ref DateTime re_PaymentDate, ref int re_PaymentSeq)
        {
            DateTime paymentDate;  // 入金日
            int paymentSeq;        // 入金Ｓｅｑ
            bool ans;              // 関数戻り値

            // 請求金額合計
            int priceTotal = data.PriceTotal.Equals("") ? 0 : Convert.ToInt32(data.PriceTotal);
            // 現金預かり金
            int credit = data.Credit.Equals("") ? 0 : Convert.ToInt32(data.Credit);
            // ハッピー買物券
            int happy_ticket = data.HappyTicket.Equals("") ? 0 : Convert.ToInt32(data.HappyTicket);
            // カード
            int card = data.Card.Equals("") ? 0 : Convert.ToInt32(data.Card);
            // カード種別
            string cardKind = data.Cardkind ?? "";
            // 伝票No
            int creditslipno = data.Creditslipno.Equals("") ? 0 : Convert.ToInt32(data.Creditslipno);
            // Ｊデビット
            int jdebit = data.Jdebit.Equals("") ? 0 : Convert.ToInt32(data.Jdebit);
            // 金融機関コード
            string bankCode = data.Bankcode ?? "";
            // 小切手
            int cheque = data.Cheque.Equals("") ? 0 : Convert.ToInt32(data.Cheque);
            // 振込み
            int transfer = data.Transfer.Equals("") ? 0 : Convert.ToInt32(data.Transfer);
            // 計上日
            DateTime calcDate = Convert.ToDateTime(data.CalcDate);

            var param = new Dictionary<string, object>();

            var insertPerPayment = new List<string>();

            using (var transaction = BeginTransaction())
            {
                try
                {
                    paymentDate = Convert.ToDateTime(data.PaymentDate);
                    // 入金Ｓｅｑ発番処理
                    paymentSeq = GetPerPaymentSeq(paymentDate);

                    // 入金の場合
                    if (mode == 1)
                    {
                        // キー及び更新値の設定
                        param = new Dictionary<string, object>();
                        param.Add("paymentdate", paymentDate);
                        param.Add("paymentseq", paymentSeq);
                        param.Add("pricetotal", priceTotal);
                        param.Add("credit", credit);
                        param.Add("happy_ticket", happy_ticket);
                        param.Add("card", card);
                        param.Add("cardkind", cardKind);
                        param.Add("creditslipno", creditslipno);
                        param.Add("jdebit", jdebit);
                        param.Add("bankcode", bankCode);
                        param.Add("cheque", cheque);
                        param.Add("transfer", transfer);
                    }

                    // 返金の場合
                    //if (mode == 2)
                    //{
                    //    dynamic dt1 = SelectPerPayment(Convert.ToDateTime(data["originaldate"]), Convert.ToInt32(data["originalseq"]));
                    //
                    //    // キー及び更新値の設定
                    //    param = new Dictionary<string, object>();
                    //    param.Add("paymentdate", paymentDate);
                    //    param.Add("paymentseq", paymentSeq);
                    //    param.Add("pricetotal", -1 * (int)dt1["pricetotal"]);
                    //    param.Add("credit", -1 * (int)dt1["credit"]);
                    //    param.Add("happy_ticket", -1 * (int)dt1["happy_ticket"]);
                    //    param.Add("card", dt1["card"]);
                    //    param.Add("cardkind", dt1["cardKind"]);
                    //    param.Add("creditslipno", dt1["creditslipno"]);
                    //    param.Add("jdebit", -1 * (int)dt1["jdebit"]);
                    //    param.Add("bankcode", dt1["bankcode"]);
                    //    param.Add("cheque", -1 * (int)dt1["cheque"]);
                    //    param.Add("transfer", -1 * (int)dt1["transfer"]);
                    //}

                    param.Add("registerno", Convert.ToInt32(data.Registerno));
                    param.Add("upddate", paymentDate);
                    param.Add("upduser", data.UpdUser);
                    param.Add("calcdate", calcDate);

                    // 入金情報テーブルレコードの挿入
                    string sql = @"
                                   insert
                                   into perpayment(
                                     paymentdate
                                     , paymentseq
                                     , pricetotal
                                     , credit
                                     , happy_ticket
                                     , card
                                     , cardkind
                                     , creditslipno
                                     , jdebit
                                     , bankcode
                                     , cheque
                                     , transfer
                                     , registerno
                                     , upddate
                                     , upduser
                                     , insuser
                                     , calcdate
                                   )
                                   values (
                                     :paymentdate
                                     , :paymentseq
                                     , :pricetotal
                                     , :credit
                                     , :happy_ticket
                                     , :card
                                     , :cardkind
                                     , :creditslipno
                                     , :jdebit
                                     , :bankcode
                                     , :cheque
                                     , :transfer
                                     , :registerno
                                     , sysdate
                                     , :upduser
                                     , :upduser
                                     , :calcdate
                                   )
                                ";

                    connection.Execute(sql, param);

                    // 戻り値の設定
                    re_PaymentDate = paymentDate;
                    re_PaymentSeq = paymentSeq;
                    data.Paymentseq = paymentSeq;

                    // 個人請求管理テーブルレコードの入金日、入金Ｓｅｑセット
                    ans = SetPayment_PerBill(data);

                    // 未使用未入金データの削除
                    ans = Delete_NotUsePerPayment(Convert.ToDateTime(data.PaymentDate));

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                    insertPerPayment.Add("保存が失敗しました。");
                }
            }
            // 戻り値の設定
            return insertPerPayment;
        }

        /// <summary>
        /// 個人請求管理テーブルレコードの入金日、入金Ｓｅｑセットする
        /// </summary>
        /// <param name="data">
        /// paymentdate    入金日または返金
        /// paymentseq     入金または返金Ｓｅｑ
        /// originaldate   元の入金日（入金の場合"")
        /// originalseq    元の入金Ｓｅｑ（入金の場合"")
        /// dmddate        請求日（配列）
        /// billseq        請求書Ｓｅｑ（配列）
        /// branchno       請求書枝番（配列）
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool SetPayment_PerBill(PerBillIncome data)
        {
            // 請求日 配列
            DateTime[] dmdDateArray = data.DmdDateArray;
            // 請求書Ｓｅｑ 配列
            int[] billSeqArray = data.BillSeqArray;
            // 請求書枝番 配列
            int[] branchNoArray = data.BranchNoArray;

            // 削除対象かもしれない入金日(Key) 入金Seq
            List<dynamic> delList = new List<dynamic>();

            // 現在の入金情報キーを退避
            string sql = @"
                            select
                              paymentdate
                              , paymentseq
                            from
                              perbill
                            where
                              perbill.dmddate = :dmddate
                              and perbill.billseq = :billseq
                              and perbill.branchno = :branchno
                              and perbill.paymentdate is not null
                              and perbill.paymentseq is not null
                        ";

            for (int i = 0; i < dmdDateArray.Length; i++)
            {
                // 個人請求管理テーブルレコードの入金日、入金Ｓｅｑセット
                var param = new Dictionary<string, object>();
                param.Add("dmddate", dmdDateArray[i]);
                param.Add("billseq", billSeqArray[i]);
                param.Add("branchno", branchNoArray[i]);

                delList.Add(connection.Query(sql, param).FirstOrDefault());
            }

            sql = @"
                    update perbill
                    set
                      paymentdate = :setpaymentdate
                      , paymentseq = :setpaymentseq
                    where
                      perbill.dmddate = :dmddate
                      and perbill.billseq = :billseq
                      and perbill.branchno = :branchno
                ";

            List<dynamic> sqlParamList = new List<dynamic>();

            for (int i = 0; i < dmdDateArray.Length; i++)
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("setpaymentdate", Convert.ToDateTime(data.PaymentDate));
                param.Add("setpaymentseq", data.Paymentseq);
                param.Add("dmddate", dmdDateArray[i]);
                param.Add("billseq", billSeqArray[i]);
                param.Add("branchno", branchNoArray[i]);

                sqlParamList.Add(param);
            }

            if (sqlParamList.Count() > 0)
            {
                // SQL文の実行
                connection.Execute(sql, sqlParamList);
            }

            // 入金情報削除（請求書伝票で全く使用していないもののみ）
            sql = @"
                    delete perpayment
                    where
                      perpayment.paymentdate = :delpaymentdate
                      and perpayment.paymentseq = :delpaymentseq
                      and 0 = (
                        select
                          count(*)
                        from
                          perbill
                        where
                          perbill.paymentdate = :delpaymentdate
                          and perbill.paymentseq = :delpaymentseq
                      )
                 ";

            sqlParamList = new List<dynamic>();
            for (int i = 0; i < delList.Count(); i++)
            {
                if (delList[i] != null)
                {
                    var param = new Dictionary<string, object>();
                    param.Add("delpaymentdate", Convert.ToDateTime(delList[i].paymentdate));
                    param.Add("delpaymentseq", delList[i].paymentseq);

                    sqlParamList.Add(param);
                }
            }

            if (sqlParamList.Count() > 0)
            {
                // SQL文の実行
                connection.Execute(sql, sqlParamList);
            }

            return true;
        }

        /// <summary>
        /// 個人請求管理テーブルレコードの入金日、入金Ｓｅｑをクリアする
        /// </summary>
        /// <param name="dmdDateArray">請求日（配列）</param>
        /// <param name="billSeqArray">請求書Ｓｅｑ（配列）</param>
        /// <param name="branchNoArray">請求書枝番（配列）</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        private bool ClrPayment_PerBill(DateTime[] dmdDateArray, int[] billSeqArray, int[] branchNoArray)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            
            string sql = @"
                           update perbill
                           set
                             paymentdate = null
                             , paymentseq = null
                           where
                             perbill.dmddate = :dmddate
                             and perbill.billseq = :billseq
                             and perbill.branchno = :branchno
                         ";

            for(int i = 0, len = dmdDateArray.Length; i < len; i++)
            {
                param = new Dictionary<string, object>();
                param.Add("dmddate", dmdDateArray[i]);
                param.Add("billseq", billSeqArray[i]);
                param.Add("branchno", branchNoArray[i]);

                // SQL文の実行
                connection.Execute(sql, param);
            }

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 個人入金情報テーブルの１レコードを更新する
        /// </summary>
        /// <param name="mode">1:入金　2:返金</param>
        /// <param name="data">
        /// keydate        更新前の入金日（キー）
        /// keyseq         更新前の入金Ｓｅｑ（キー）
        /// paymentdate    入金日
        /// dmddate        請求日（配列）
        /// billseq        請求書Ｓｅｑ（配列）
        /// branchno       請求書枝番（配列）
        /// pricetotal     請求金額合計
        /// registerno     レジ番号
        /// upduser        ユーザＩＤ
        /// credit         現金預かり金
        /// happy_ticket   ハッピー買物券
        /// card           カード
        /// cardkind       カード種別
        /// creditslipno   伝票No
        /// jdebit         Ｊデビット
        /// bankcode       金融機関コード
        /// cheque         小切手
        /// </param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> UpdatePerPayment(int mode, PerBillIncome data)
        {
            bool ans;        // 関数戻り値
            int paymentSeq;  // 入金Ｓｅｑ

            var updatePerPayment = new List<string>();

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // 返金？
                    if (mode == 2)
                    {
                        // 返金日がない
                        if (data.PaymentDate.Equals(""))
                        {
                            updatePerPayment.Add("返金日が指定されていません。");
                            return updatePerPayment;
                        }
                    }

                    // 個人請求管理テーブルレコードの入金日、入金Ｓｅｑクリア
                    ans = ClrPayment_PerBill(data.DmdDateArray, data.BillSeqArray, data.BranchNoArray);

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("keydate", Convert.ToDateTime(data.KeyDate));
                    param.Add("keyseq", data.keySeq);
                    param.Add("paymentdate", Convert.ToDateTime(data.PaymentDate));

                    if (!(Convert.ToDateTime(data.PaymentDate) == Convert.ToDateTime(data.KeyDate)))
                    {
                        // 入金Ｓｅｑ発番処理
                        paymentSeq = GetPerPaymentSeq(Convert.ToDateTime(data.PaymentDate));
                    }
                    else
                    {
                        paymentSeq = data.keySeq;
                    }

                    param.Add("paymentseq", paymentSeq);

                    // 入金情報テーブルレコードの更新
                    string sql = @"
                                   update perpayment
                                   set
                                       paymentdate = :paymentdate
                                       , paymentseq = :paymentseq
                                ";

                    param.Add("pricetotal", data.PriceTotal.Equals("") ? 0 : Convert.ToInt32(data.PriceTotal));
                    sql += "    ,pricetotal  = :pricetotal";

                    param.Add("credit", data.Credit.Equals("") ? 0 : Convert.ToInt32(data.Credit));
                    sql += "    ,credit  = :credit        ";

                    param.Add("happy_ticket", data.HappyTicket.Equals("") ? 0 : Convert.ToInt32(data.HappyTicket));
                    sql += "    ,happy_ticket  = :happy_ticket  ";

                    param.Add("card", data.Card.Equals("") ? 0 : Convert.ToInt32(data.Card));
                    sql += "    ,card  = :card  ";

                    param.Add("cardkind", data.Cardkind);
                    sql += "    ,cardkind  = :cardkind  ";

                    param.Add("creditslipno", data.Creditslipno.Equals("") ? 0 : Convert.ToInt32(data.Creditslipno));
                    sql += "    ,creditslipno  = :creditslipno  ";

                    param.Add("jdebit", data.Jdebit.Equals("") ? 0 : Convert.ToInt32(data.Jdebit));
                    sql += "    ,jdebit  = :jdebit  ";

                    param.Add("bankcode", data.Bankcode);
                    sql += "    ,bankcode  = :bankcode  ";

                    param.Add("cheque", data.Cheque.Equals("") ? 0 : Convert.ToInt32(data.Cheque));
                    sql += "    ,cheque  = :cheque  ";

                    param.Add("transfer", data.Transfer.Equals("") ? 0 : Convert.ToInt32(data.Transfer));
                    sql += "    ,transfer  = :transfer  ";

                    param.Add("registerno", data.Registerno.Equals("") ? 1 : Convert.ToInt32(data.Registerno));
                    sql += "    ,registerno  = :registerno  ";

                    param.Add("upduser", data.UpdUser);
                    sql += "    ,upduser  = :upduser  ";

                    sql += "   , upddate = sysdate              ";

                    param.Add("calcdate", Convert.ToDateTime(data.CalcDate));
                    sql += "    ,calcdate  = :calcdate  ";

                    sql += @"
                              where
                              paymentdate = :keydate
                              and paymentseq = :keyseq
                         ";

                    connection.Execute(sql, param);

                    // 個人請求管理テーブルレコードの入金日、入金Ｓｅｑセット
                    ans = SetPayment_PerBill(data);

                    // 未使用未入金データの削除
                    ans = Delete_NotUsePerPayment(Convert.ToDateTime(data.PaymentDate));

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();
                    updatePerPayment.Add("保存が失敗しました。");
                }
            }
            return updatePerPayment;
        }

        /// <summary>
        /// 未使用入金データのクリア
        /// </summary>
        /// <param name="paymentDate">入金日または返金</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        private bool Delete_NotUsePerPayment(DateTime paymentDate)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("paymentdate", paymentDate);

            // 未使用入金情報削除
            string sql = @"
                           delete perpayment
                           where
                             (paymentdate, paymentseq) in (
                               select
                                 b.paymentdate
                                 , b.paymentseq
                               from
                                 perbill a
                                 , perpayment b
                               where
                                 a.paymentdate(+) = b.paymentdate
                                 and a.paymentseq(+) = b.paymentseq
                                 and a.paymentdate is null
                             )
                             and paymentdate = :paymentdate
                        ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 予約番号から個人請求書管理情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// dmdDate     請求日
        /// billSeq     請求書Ｓｅｑ
        /// branchNo    請求書枝番
        /// delflg      取消伝票フラグ
        /// updDate     更新日時
        /// updUser     ユーザＩＤ
        /// userName    ユーザ漢字氏名
        /// billcomment 請求書コメント
        /// paymentDate 入金日
        /// paymentSeq  入金Ｓｅｑ
        /// price       金額（請求書合計）
        /// editPrice   調整金額（請求書合計）
        /// taxPrice    税額（請求書合計）
        /// editTax     調整税額（請求書合計）
        /// subTotal    小計（請求書合計）
        /// taxTotal    税合計（請求書合計）
        /// </returns>
        public List<dynamic> SelectPerBill(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たす個人請求書管理情報テーブルのレコードを取得
            string sql = @"
                           select
                             perbill.dmddate
                             , perbill.billseq
                             , perbill.branchno
                             , perbill.delflg
                             , perbill.upddate
                             , perbill.upduser
                             , perbill.billcomment
                             , perbill.paymentdate
                             , perbill.paymentseq
                             , based_perbill_c.price_all
                             , based_perbill_c.editprice_all
                             , based_perbill_c.taxprice_all
                             , based_perbill_c.edittax_all
                             , hainsuser.username
                           from
                             hainsuser
                             , perbill
                             , (
                               select
                                 perbill_c.dmddate
                                 , perbill_c.billseq
                                 , perbill_c.branchno
                                 , sum(perbill_c.price) price_all
                                 , sum(perbill_c.editprice) editprice_all
                                 , sum(perbill_c.taxprice) taxprice_all
                                 , sum(perbill_c.edittax) edittax_all
                               from
                                 perbill_c
                                 , perbill_csl
                               where
                                 perbill_csl.rsvno = :rsvno
                                 and perbill_c.dmddate = perbill_csl.dmddate
                                 and perbill_c.billseq = perbill_csl.billseq
                                 and perbill_c.branchno = perbill_csl.branchno
                               group by
                                 perbill_c.dmddate
                                 , perbill_c.billseq
                                 , perbill_c.branchno
                             ) based_perbill_c
                           where
                             perbill.dmddate = based_perbill_c.dmddate
                             and perbill.billseq = based_perbill_c.billseq
                             and perbill.branchno = based_perbill_c.branchno
                             and perbill.upduser = hainsuser.userid(+)
                           order by
                             perbill.delflg
                             , perbill.dmddate
                             , perbill.billseq
                             , perbill.branchno
                       ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書Ｎｏから個人請求書管理情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>
        /// delflg      取消伝票フラグ
        /// updDate     更新日時
        /// updUser     ユーザＩＤ
        /// userName    ユーザ漢字氏名
        /// billcomment 請求書コメント
        /// paymentDate 入金日
        /// paymentSeq  入金Ｓｅｑ
        /// price       金額（請求書合計）
        /// editPrice   調整金額（請求書合計）
        /// taxPrice    税額（請求書合計）
        /// editTax     調整税額（請求書合計）
        /// subTotal    小計（請求書合計）
        /// taxTotal    税合計（請求書合計）
        /// printDate   領収書印刷日
        /// billName    請求宛先
        /// keishou     敬称
        /// </returns>
        public List<dynamic> SelectPerBill_BillNo(DateTime dmdDate, int billSeq, int branchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", dmdDate);
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            // 検索条件を満たす個人請求書管理情報テーブルのレコードを取得
            string sql = @"
                           select
                             perbill.delflg
                             , perbill.upddate
                             , perbill.upduser
                             , perbill.billcomment
                             , perbill.paymentdate
                             , perbill.paymentseq
                             , perbill.printdate
                             , perbill.billname
                             , perbill.keishou
                             , based_perbill_c.price_all
                             , based_perbill_c.editprice_all
                             , based_perbill_c.taxprice_all
                             , based_perbill_c.edittax_all
                             , hainsuser.username
                           from
                             hainsuser
                             , perbill
                             , (
                               select
                                 perbill_c.dmddate
                                 , perbill_c.billseq
                                 , perbill_c.branchno
                                 , sum(perbill_c.price) price_all
                                 , sum(perbill_c.editprice) editprice_all
                                 , sum(perbill_c.taxprice) taxprice_all
                                 , sum(perbill_c.edittax) edittax_all
                               from
                                 perbill_c
                               where
                                 perbill_c.dmddate = :dmddate
                                 and perbill_c.billseq = :billseq
                                 and perbill_c.branchno = :branchno
                               group by
                                 perbill_c.dmddate
                                 , perbill_c.billseq
                                 , perbill_c.branchno
                             ) based_perbill_c
                           where
                             perbill.dmddate(+) = based_perbill_c.dmddate
                             and perbill.billseq(+) = based_perbill_c.billseq
                             and perbill.branchno(+) = based_perbill_c.branchno
                             and perbill.upduser = hainsuser.userid(+)
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入金Ｎｏから請求書Ｎｏを取得する
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <param name="paymentSeq">入金Ｓｅｑ</param>
        /// <returns>
        /// dmdDate     請求日
        /// billSeq     請求書Ｓｅｑ
        /// branchNo    請求書枝番
        /// lastName    姓
        /// firstName   名
        /// </returns>
        public List<dynamic> SelectBillNo_Payment(DateTime paymentDate, int paymentSeq)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("paymentdate", paymentDate);
            param.Add("paymentseq", paymentSeq);

            // 検索条件を満たす個人請求書Noを取得
            string sql = @"
                           select distinct
                             dmdview.dmddate
                             , dmdview.billseq
                             , dmdview.branchno
                             , dmdview.lastname
                             , dmdview.firstname
                        ";
            // 受信情報がある場合
            sql += @"
                           from
                             (
                               (
                                 select
                                   perbill.dmddate
                                   , perbill.billseq
                                   , perbill.branchno
                                   , person.lastname
                                   , person.firstname
                                 from
                                   perbill
                                   , perbill_csl
                                   , consult
                                   , person
                                 where
                                   perbill.paymentdate = :paymentdate
                                   and perbill.paymentseq = :paymentseq
                                   and perbill_csl.dmddate = perbill.dmddate
                                   and perbill_csl.billseq = perbill.billseq
                                   and perbill_csl.branchno = perbill.branchno
                                   and consult.rsvno = perbill_csl.rsvno
                                   and person.perid = consult.perid
                               )
                               union
                    ";
            // 受信情報が無い場合
            sql += @"
                               (
                                 select
                                   perbill.dmddate
                                   , perbill.billseq
                                   , perbill.branchno
                                   , person.lastname
                                   , person.firstname
                                 from
                                   perbill
                                   , perbill_person
                                   , person
                                 where
                                   perbill.paymentdate = :paymentdate
                                   and perbill.paymentseq = :paymentseq
                                   and perbill_person.dmddate = perbill.dmddate
                                   and perbill_person.billseq = perbill.billseq
                                   and perbill_person.branchno = perbill.branchno
                                   and person.perid = perbill_person.perid
                               )
                             ) dmdview
                    ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書Ｎｏをキーに請求書の取消を行う
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <param name="userId">更新者ＩＤ</param>
        /// <returns>
        /// True      レコードあり
        /// False     レコードなし、または異常終了
        /// </returns>
        public bool DeletePerBill(DateTime dmdDate, int billSeq, int branchNo, string userId)
        {
            bool ret;
            int par_Ret = 0;

            using (var ts = new TransactionScope())
            {
                try
                {
                    string sql = @"
                                   begin :ret := demandpackage.deleteperbill(:dmddate, :billseq, :branchno, :userid);
                                   end;
                                ";

                    using (var cmd = new OracleCommand())
                    {
                        // キー値の設定
                        cmd.Parameters.Add("ret", par_Ret);
                        cmd.Parameters.Add("dmddate", dmdDate);
                        cmd.Parameters.Add("billseq", billSeq);
                        cmd.Parameters.Add("branchno", branchNo);
                        cmd.Parameters.Add("userid", userId);

                        ExecuteNonQuery(cmd, sql);
                    }
                    // 戻り値の設定
                    ret = true;

                    // トランザクションをコミット
                    ts.Complete();
                }
                catch
                {
                    // 戻り値の設定
                    ret = false;

                }
                return ret;
            }
        }

        /// <summary>
        /// 検索条件に従い個人請求書一覧を抽出する
        /// </summary>
        /// <param name="sortKind">ソート種別</param>
        /// <param name="sortMode">ソートモード</param>
        /// <param name="paymentflg">1:未収のみ 0:全て</param>
        /// <param name="delDisp">1:取消伝票除く 0:全て</param>
        /// <param name="key">検索キー(空白で分割後のキー）</param>
        /// <param name="startDmdDate">検索条件請求日（開始）</param>
        /// <param name="endDmdDate">検索条件請求日（終了）</param>
        /// <param name="searchOrg1">検索条件団体コード１</param>
        /// <param name="searchOrg2">検索条件団体コード２</param>
        /// <param name="searchPer">検索条件個人ＩＤ</param>
        /// <param name="searchDmdDate">検索条件請求日</param>
        /// <param name="searchBillSeq">検索条件請求書Ｓｅｑ</param>
        /// <param name="searchBranchNo">検索条件請求書枝番</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <returns>
        /// dmdDate          請求日
        /// billSeq          請求書Ｓｅｑ
        /// branchNo         請求書枝番
        /// rsvNo            予約番号
        /// csCd             コースコード
        /// csName           コース名
        /// webColor         コース色
        /// perId            個人ＩＤ
        /// lastName         姓
        /// firstName        名
        /// lastKName        カナ姓
        /// firstKName       カナ名
        /// age       　　　　年齢
        /// gender           性別
        /// perCount         受信者数
        /// orgSName         団体略称
        /// orgKName         団体カナ名
        /// price            金額合計
        /// tax              税金合計
        /// totalPrice       請求金額合計
        /// paymentDate      入金日
        /// paymentSeq       入金Ｓｅｑ
        /// delflg           取消伝票フラグ
        /// </returns>
        public PartialDataSet SelectListPerBill(int sortKind, int sortMode, int paymentflg, int delDisp, string[] key, string startDmdDate, string endDmdDate, string searchOrg1, string searchOrg2, string searchPer, string searchDmdDate, string searchBillSeq, string searchBranchNo, int startPos = 1, int pageMaxLine = 0)
        {
            string sql;        // SQLステートメント
            string sql2 = "";  // SQLステートメント
            string sql_count;  // SQLステートメント
            string sql_data;   // SQLステートメント
            bool ans;
            try
            {
                // キー値の設定
                var param = new Dictionary<string, object>();
                if (pageMaxLine > 0)
                {
                    param.Add("endpos", startPos + pageMaxLine);
                }
                if (startPos != 0)
                {
                    startPos = startPos + 1;
                }
                param.Add("startpos", startPos);

                // 検索条件を満たす個人請求書データ件数を取得
                sql_count = "select count(*) cnt ";

                // 検索条件を満たす個人請求書データを取得
                sql_data = @"
                         select
                           finallistview2.dmddate
                           , finallistview2.billseq
                           , finallistview2.branchno
                           , finallistview2.rsvno
                           , finallistview2.cscd
                           , finallistview2.csname
                           , finallistview2.webcolor
                           , finallistview2.perid
                           , finallistview2.lastname
                           , finallistview2.firstname
                           , finallistview2.lastkname
                           , finallistview2.firstkname
                           , finallistview2.age
                           , finallistview2.gender
                           , finallistview2.percount
                           , finallistview2.orgsname
                           , finallistview2.orgkname
                           , finallistview2.price
                           , finallistview2.tax
                           , finallistview2.totalprice
                           , finallistview2.paymentdate
                           , finallistview2.paymentseq
                           , finallistview2.delflg
                           , (
                             select
                               dayid
                             from
                               receipt
                             where
                               receipt.rsvno = finallistview2.rsvno
                           ) dayid
                         from
                           (
                             select
                               rownum seq
                               , finallistview.dmddate
                               , finallistview.billseq
                               , finallistview.branchno
                               , finallistview.rsvno
                               , finallistview.cscd
                               , finallistview.csname
                               , finallistview.webcolor
                               , finallistview.perid
                               , finallistview.lastname
                               , finallistview.firstname
                               , finallistview.lastkname
                               , finallistview.firstkname
                               , finallistview.age
                               , finallistview.gender
                               , finallistview.percount
                               , finallistview.orgsname
                               , finallistview.orgkname
                               , finallistview.price
                               , finallistview.tax
                               , finallistview.totalprice
                               , finallistview.paymentdate
                               , finallistview.paymentseq
                               , finallistview.delflg
                        ";

                sql = @"
                    from
                      (
                        select
                          listview.dmddate
                          , listview.billseq
                          , listview.branchno
                          , listview.rsvno
                          , listview.cscd
                          , listview.csname
                          , listview.webcolor
                          , listview.perid
                          , listview.lastname
                          , listview.firstname
                          , listview.lastkname
                          , listview.firstkname
                          , listview.age
                          , listview.gender
                          , listview.percount
                          , listview.orgsname
                          , listview.orgkname
                          , listview.price
                          , listview.tax
                          , listview.totalprice
                          , listview.paymentdate
                          , listview.paymentseq
                          , listview.delflg
                        ";

                // 検索条件が請求書Ｎｏ？
                if (searchDmdDate != null && searchBillSeq != null
                    && searchBranchNo != null
                    && !searchDmdDate.Equals("") && !searchBillSeq.Equals("") && !searchBranchNo.Equals(""))
                {
                    ans = SetPerBillViewSql(ref param, ref sql2, paymentflg, delDisp, "", "", searchDmdDate, searchBillSeq, searchBranchNo);
                }
                else if (searchDmdDate != null && searchBillSeq != null && !searchDmdDate.Equals("") && !searchBillSeq.Equals(""))
                {
                    ans = SetPerBillViewSql(ref param, ref sql2, paymentflg, delDisp, "", "", searchDmdDate, searchBillSeq, "");
                }
                else if (searchDmdDate != null && searchBranchNo != null && !searchDmdDate.Equals("") && !searchBranchNo.Equals(""))
                {
                    ans = SetPerBillViewSql(ref param, ref sql2, paymentflg, delDisp, "", "", searchDmdDate, "", searchBranchNo);
                }
                else if (searchDmdDate != null && !searchDmdDate.Equals(""))
                {
                    ans = SetPerBillViewSql(ref param, ref sql2, paymentflg, delDisp, "", "", searchDmdDate, "", "");
                }
                else
                {
                    // 検索条件が団体コード？
                    if (searchOrg1 != null && searchOrg2 != null
                        && !searchOrg1.Equals("") && !searchOrg2.Equals(""))
                    {
                        ans = SetOrgViewSql(ref param, ref sql2, paymentflg, delDisp, searchPer, searchOrg1, searchOrg2, startDmdDate, endDmdDate);
                    }
                    else
                    {
                        // 検索条件が検索キー または個人ＩＤ？
                        if (key.Length > 0 && key[0] != null && !"".Equals(key[0])
                            || (searchPer != null && !searchPer.Equals("")))
                        {
                            ans = SetPersonViewSql(ref param, ref sql2, paymentflg, delDisp, key, searchPer, startDmdDate, endDmdDate);
                        }
                        else
                        {
                            // その他
                            ans = SetPerBillViewSql(ref param, ref sql2, paymentflg, delDisp, startDmdDate, endDmdDate, "", "", "");
                        }
                    }
                }

                sql += sql2;

                // ソート
                switch (sortKind)
                {
                    // 請求書No順
                    case 0:
                        switch (sortMode)
                        {
                            case 0:
                                sql += @"
                                     order by
                                       listview.dmddate desc
                                       , listview.billseq asc
                                       , listview.branchno asc
                                       , listview.delflg asc
                                ";
                                break;

                            case 1:
                                sql += @"
                                     order by
                                       listview.dmddate asc
                                       , listview.billseq desc
                                       , listview.branchno desc
                                       , listview.delflg desc
                                ";
                                break;
                        }
                        break;
                }

                sql += " ) finallistview  ";

                // 全件数取得
                sql_count += sql;
                int count = Convert.ToInt32(connection.Query(sql_count, param).FirstOrDefault().CNT);

                sql += " ) finallistview2  ";
                // 取得件数で絞込み
                sql += "  where finallistview2.seq >= :startpos ";
                if (pageMaxLine > 0)
                {
                    sql += "    and finallistview2.seq <= :endpos ";
                }

                // データ取得
                sql_data += sql;
                List<dynamic> query = connection.Query(sql_data, param).ToList();
                // 件数取得にて０件の場合は処理を終了する
                if (count == 0)
                {
                    query = new List<dynamic>();
                }
                return new PartialDataSet(count, query);

            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// 請求書Ｎｏから個人請求明細情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>
        /// billLineNo  請求明細行No
        /// price       金額
        /// editPrice   調整金額
        /// taxPrice    税額
        /// editTax     調整税額
        /// ctrPtCd     契約パターンコード
        /// optCd       オプションコード
        /// optBranchNo オプション枝番
        /// rsvNo       予約番号
        /// priceSeq    受信金額ＳＥＱ
        /// lineName    明細名称
        /// otherLineDivCd セット外明細コード
        /// otherLineDivName セット外明細名
        /// lastName     受診者名　姓
        /// firstName     受診者名　姓
        /// </returns>
        public List<dynamic> SelectPerBill_c(string dmdDate, int billSeq, int branchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", dmdDate);
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            // 検索条件を満たす個人請求書明細情報テーブルのレコードを取得
            string sql = @"
                           select
                             billlineno
                             , price
                             , editprice
                             , taxprice
                             , edittax
                             , ctrptcd
                             , optcd
                             , optbranchno
                             , rsvno
                             , priceseq
                             , linename
                             , otherlinedivcd
                             , lastview.perid
                             , person.lastname
                             , person.firstname
                             , otherlinedivname
                           from
                             person
                             , (
                               select
                                 billlineno
                                 , price
                                 , editprice
                                 , taxprice
                                 , edittax
                                 , ctrptcd
                                 , optcd
                                 , optbranchno
                                 , rsvno
                                 , priceseq
                                 , linename
                                 , otherlinedivcd
                                 , nvl(perid1, perid2) perid
                                 , otherlinedivname
                               from
                                 (
                                   select
                                     perbill_c.billlineno
                                     , perbill_c.price
                                     , perbill_c.editprice
                                     , perbill_c.taxprice
                                     , perbill_c.edittax
                                     , perbill_c.ctrptcd
                                     , perbill_c.optcd
                                     , perbill_c.optbranchno
                                     , perbill_c.rsvno
                                     , perbill_c.priceseq
                                     , perbill_c.linename
                                     , perbill_c.otherlinedivcd
                                     , (
                                       select
                                         consult.perid
                                       from
                                         consult
                                       where
                                         consult.rsvno = perbill_c.rsvno
                                     ) perid1
                                     , (
                                       select
                                         MAX(perbill_person.perid) perid
                                       from
                                         perbill_person
                                       where
                                         perbill_person.dmddate = :dmddate
                                         and perbill_person.billseq = :billseq
                                         and perbill_person.branchno = :branchno
                                     ) perid2
                                     , otherlinediv.otherlinedivname
                                   from
                                     perbill_c
                                     , otherlinediv
                                   where
                                     perbill_c.dmddate = :dmddate
                                     and perbill_c.billseq = :billseq
                                     and perbill_c.branchno = :branchno
                                     and perbill_c.otherlinedivcd = otherlinediv.otherlinedivcd(+)
                                 ) mainview
                             ) lastview
                           where
                             person.perid = lastview.perid
                           order by
                             billlineno
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書Ｎｏから予約番号を取得しそれぞれの受信情報を取得する
        /// </summary>
        /// <param name="dmdDate">請求日</param>
        /// <param name="billSeq">請求書Ｓｅｑ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>
        /// rsvNo       予約番号
        /// cslDate     受診日
        /// perId       個人ＩＤ
        /// lastName    姓
        /// firstName   名
        /// lastKName   カナ姓
        /// firstKName  カナ名
        /// ctrPtCd     契約パターンコード
        /// csName      コース名
        /// </returns>
        public List<dynamic> SelectPerBill_csl(string dmdDate, int billSeq, int branchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", dmdDate);
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            // 検索条件を満たす個人請求書管理情報テーブルのレコードを取得
            string sql = @"
                           select
                             perbill_csl.rsvno
                             , consult.csldate
                             , consult.perid
                             , consult.ctrptcd
                             , person.lastname
                             , person.firstname
                             , person.lastkname
                             , person.firstkname
                             , ctrpt.csname
                           from
                             perbill_csl
                             , consult
                             , person
                             , ctrpt
                           where
                             perbill_csl.dmddate = :dmddate
                             and perbill_csl.billseq = :billseq
                             and perbill_csl.branchno = :branchno
                             and consult.rsvno(+) = perbill_csl.rsvno
                             and person.perid(+) = consult.perid
                             and ctrpt.ctrptcd(+) = consult.ctrptcd
                           order by
                             perbill_csl.rsvno
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 入金Ｎｏから個人入金情報を取得する
        /// </summary>
        /// <param name="paymentDate">入金日</param>
        /// <param name="paymentSeq">入金Ｓｅｑ</param>
        /// <returns>
        /// priceTotal       請求金額合計
        /// credit           現金預かり金
        /// happy_ticket     ハッピー買物券
        /// card             カード
        /// cardKind         カード種別
        /// cardNAME         カード名称
        /// creditslipno     伝票Ｎｏ
        /// jdebit           Ｊデビット
        /// bankCode         金融機関コード
        /// bankName         金融機関名
        /// cheque           小切手
        /// registerno       レジ番号
        /// updDate          更新日付
        /// updUser          ユーザＩＤ
        /// userName         ユーザ漢字氏名
        /// </returns>
        public List<dynamic> SelectPerPayment(DateTime paymentDate, int paymentSeq)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("paymentdate", paymentDate);
            param.Add("paymentseq", paymentSeq);

            // 検索条件を満たす個人請求書管理情報テーブルのレコードを取得
            string sql = @"
                           select
                             perpayment.pricetotal
                             , perpayment.credit
                             , perpayment.happy_ticket
                             , perpayment.card
                             , perpayment.cardkind
                             , perpayment.creditslipno
                             , perpayment.jdebit
                             , perpayment.bankcode
                             , perpayment.cheque
                             , perpayment.registerno
                             , perpayment.upddate
                             , perpayment.upduser
                             , perpayment.transfer
                             , perpayment.calcdate
                             , hainsuser.username
                             , card.cardname
                             , bank.bankname
                           from
                             (
                               select
                                 freecd bankcode
                                 , freefield1 bankname
                               from
                                 free
                             ) bank
                             , (
                               select
                                 freecd cardkind
                                 , freefield1 cardname
                               from
                                 free
                             ) card
                             , perpayment
                             , hainsuser
                           where
                             perpayment.paymentdate = :paymentdate
                             and perpayment.paymentseq = :paymentseq
                             and perpayment.upduser = hainsuser.userid(+)
                             and perpayment.cardkind = card.cardkind(+)
                             and perpayment.bankcode = bank.bankcode(+)
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// セット外請求明細を取得する。
        /// </summary>
        /// <returns>
        /// otherLineDivCd      セット外請求明細コード
        /// otherLineDivName    セット外請求明細名
        /// stdPrice            標準単価
        /// stdTax              標準税額
        /// </returns>
        public List<dynamic> SelectOtherLineDiv()
        {
            // 検索条件を満たす個人入金情報テーブルのレコードを取得
            string sql = @"
                           select
                             otherlinediv.otherlinedivcd
                             , otherlinediv.otherlinedivname
                             , otherlinediv.stdprice
                             , otherlinediv.stdtax
                           from
                             otherlinediv
                           order by
                             otherlinediv.otherlinedivcd
                        ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// セット外請求明細情報を取得する
        /// </summary>
        /// <param name="otherLineDivCd">セット外請求明細コード</param>
        /// <returns>
        /// otherLineDivName   セット外請求明細名称（省略可）
        /// stdPrice           標準単価（省略可）
        /// stdTax             標準税額（省略可）
        /// </returns>
        public List<dynamic> SelectOtherLineDivFromCode(string otherLineDivCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("otherlinedivcd", otherLineDivCd);

            // 検索条件を満たすセット外請求明細テーブルのレコードを取得
            string sql = @"
                           select
                             otherlinedivname
                             , stdprice
                             , stdtax
                           from
                             otherlinediv
                           where
                             otherlinedivcd = :otherlinedivcd
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// セット外請求明細テーブルレコードを削除する
        /// </summary>
        /// <param name="otherLineDivCd">セット外請求明細コード</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteOtherLineDiv(string otherLineDivCd)
        {

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("otherlinedivcd", otherLineDivCd);

            // セット外請求明細テーブルレコードの削除
            string sql = @"
                           delete otherlinediv
                           where
                             otherlinedivcd = :otherlinedivcd
                        ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// セット外請求明細テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// otherLineDivCd      セット外請求明細コード
        /// otherLineDivName    セット外請求明細名称
        /// stdPrice            標準単価
        /// stdTax              標準税額
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert RegistOtherLineDiv(string mode, JToken data)
        {
            string sql;                 // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("otherlinedivcd", Convert.ToString(data["otherlinedivcd"]));
            param.Add("otherlinedivname", Convert.ToString(data["otherlinedivname"]));
            param.Add("stdprice", Convert.ToString(data["stdprice"]));
            param.Add("stdtax", Convert.ToString(data["stdtax"]));

            while (true)
            {
                // セット外請求明細テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update otherlinediv
                            set
                              otherlinedivname = :otherlinedivname
                              , stdprice 　 = :stdprice
                              , stdtax = :stdtax
                            where
                              otherlinedivcd = :otherlinedivcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たすセット外請求明細テーブルのレコードを取得
                sql = "select otherlinedivcd from otherlinediv where otherlinedivcd = :otherlinedivcd";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                if (current != null)
                {
                    ret = Insert.HistoryDuplicate;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into otherlinediv(
                          otherlinedivcd
                          , otherlinedivname
                          , stdprice
                          , stdtax
                        )
                        values (
                          :otherlinedivcd
                          , :otherlinedivname
                          , :stdprice
                          , :stdtax
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
        /// 同伴者（お連れ様）の請求書情報を取得する。
        /// </summary>
        /// <param name="data">
        /// incsldate 受診日
        /// inrsvno   予約番号
        /// </param>
        /// <returns>
        /// dmddate     請求日
        /// billseq     請求書Ｓｅｑ
        /// branchno    請求書枝番
        /// perid       個人ＩＤ
        /// lastname    姓
        /// firstname   名
        /// lastkname   カナ姓
        /// firstkname  カナ名
        /// age         年齢
        /// gender      性別
        /// rsvno       予約番号
        /// </returns>
        public List<dynamic> SelectFriendsPerBill(JToken data)
        {
            string sql = "";
            List<dynamic> list = new List<dynamic>();
            List<dynamic> result = new List<dynamic>();

            DateTime[] incsldate = data["incsldate"].ToObject<List<DateTime>>().ToArray();
            int[] inrsvno = data["inrsvno"].ToObject<List<int>>().ToArray();

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("incsldate", null);
            param.Add("inrsvno", null);

            for (int i = 0; i < incsldate.Length; i++)
            {
                param["incsldate"] = incsldate[i];
                param["inrsvno"] = inrsvno[i];

                // 検索条件を満たすお連れ様の請求書のレコードを取得
                sql = @"
                           select distinct
                             perbill_csl.dmddate
                             , perbill_csl.billseq
                             , perbill_csl.branchno
                             , consult.perid
                             , person.lastname
                             , person.firstname
                             , person.lastkname
                             , person.firstkname
                             , consult.age
                             , person.gender
                             , friendsview.rsvno
                           from
                             person
                             , perbill_csl
                             , perbill
                             , consult
                             , (
                               select
                                 friends.rsvno
                                 , friends.csldate
                               from
                                 friends
                               where
                                 friends.seq = (
                                   select
                                     seq
                                   from
                                     friends
                                   where
                                     csldate = :incsldate
                                     and rsvno = :inrsvno
                                 )
                                 and friends.csldate = :incsldate
                             ) friendsview
                           where
                             friendsview.rsvno = perbill_csl.rsvno
                             and consult.perid = person.perid
                             and perbill_csl.branchno = 0
                             and perbill.dmddate = perbill_csl.dmddate
                             and perbill.billseq = perbill_csl.billseq
                             and perbill.branchno = perbill_csl.branchno
                             and perbill.delflg = 0
                             and perbill.printdate is null
                             and friendsview.csldate = consult.csldate
                             and friendsview.rsvno = consult.rsvno
                        ";

                list = connection.Query(sql, param).ToList();
                result = result.Concat(list).ToList();
            }

            return result;
        }

        /// <summary>
        /// 予約番号をキーに個人受診情報の消費税を一括免除する。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool OmitTaxSet(int rsvNo)
        {
            int count;         // 個人受診金額情報件数
            bool ans;          // 関数復帰値

            // 個人受診金額情報取得
            List<dynamic> mInfo = demandDao.SelectConsult_mInfo(rsvNo);
            count = mInfo.Count;

            // 受診金額情報が存在しない場合
            if (count < 1)
            {
                return false;
            }

            for (int i = 0; i < count; i++)
            {
                // 領収書印刷未
                if (mInfo[i].PRINTDATE == "" || mInfo[i].PRINTDATE == null)
                {
                    // 負担元が個人の場合
                    if (mInfo[i].ORGCD1 == "XXXXX" && mInfo[i].ORGCD2 == "XXXXX")
                    {
                        UpdatePerBill_c token = new UpdatePerBill_c();
                        // 請求日
                        token.DMDDate = Convert.ToString(mInfo[i].DMDDATE);
                        // 請求書Ｓｅｑ
                        token.BillSeq = Convert.ToString(mInfo[i].BILLSEQ) == null ? "0" : Convert.ToString(mInfo[i].BILLSEQ);
                        // 請求書枝番
                        token.BranchNo = Convert.ToString(mInfo[i].BRANCHNO) == null ? "0" : Convert.ToString(mInfo[i].BRANCHNO);
                        // 請求明細行Ｎｏ
                        token.BillLineNo = Convert.ToString(mInfo[i].BILLLINENO) == null ? "0" : Convert.ToString(mInfo[i].BILLLINENO);
                        // 金額
                        token.Price = Convert.ToString(mInfo[i].PRICE);
                        // 調整金額
                        token.EditPrice = Convert.ToString(mInfo[i].EDITPRICE);
                        // 税額
                        token.TaxPrice = Convert.ToString(mInfo[i].TAXPRICE);
                        // 調整税額
                        token.EditTax = Convert.ToString(mInfo[i].EDITTAX);
                        // 明細名称
                        token.LineName = mInfo[i].LINENAME;
                        // 予約番号
                        token.RsvNo = rsvNo.ToString();
                        // 受診金額Ｓｅｑ
                        token.PriceSeq = Convert.ToString(mInfo[i].PRICESEQ);
                        // 消費税免除フラグ
                        token.OmitTaxFlg = "1";

                        // 個人請求詳細情報を更新する
                        ans = UpdatePerBill_c(token);
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// 請求書Ｎｏ，請求明細行Ｎｏをキーに個人請求詳細情報を更新する
        /// </summary>
        /// <param name="data">
        /// dmddate            請求日
        /// billseq            請求書Ｓｅｑ
        /// branchno           請求書枝番
        /// billlineno         請求明細行Ｎｏ
        /// price              金額
        /// editprice          調整金額
        /// taxprice           税額
        /// edittax            調整税額
        /// linename           明細名称
        /// rsvno              予約番号
        /// priceseq           受診金額Ｓｅｑ
        /// omittaxflg         消費税免除フラグ
        /// otherlinedivcd     セット外明細コード（省略可）
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdatePerBill_c(UpdatePerBill_c data)
        {
            string sql;                                     // SQLステートメント
            int rsvNo;                                      // 予約番号
            int priceSeq;                                   // 受信金額ＳＥＱ
            int editTax = Convert.ToInt32(data.EditTax);    // 調整税額

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // 消費税免除の場合
                    if (data.OmitTaxFlg == "1")
                    {
                        editTax = -1 * Convert.ToInt32(data.TaxPrice);
                    }

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    if (data.DMDDate != null)
                    {
                        param.Add("dmddate", Convert.ToDateTime(data.DMDDate));
                        param.Add("billseq", data.BillSeq);
                        param.Add("branchno", data.BranchNo);
                        param.Add("billlineno", data.BillLineNo);
                    }
                    param.Add("price", data.Price);
                    param.Add("editprice", data.EditPrice);
                    param.Add("taxprice", data.TaxPrice);
                    param.Add("edittax", data.EditTax);
                    param.Add("omittaxflg", data.OmitTaxFlg);

                    if (data.LineName != null && !"".Equals(data.LineName))
                    {
                        param.Add("linename", data.LineName);
                    }

                    rsvNo = 0;
                    priceSeq = 0;
                    if (Convert.ToInt32(data.RsvNo) == 0 || Convert.ToInt32(data.PriceSeq) == 0)
                    {
                        // 予約番号、受診金額Ｓｅｑ取得
                        sql = @"
                        select
                          perbill_c.rsvno
                          , perbill_c.priceseq
                        from
                          perbill_c
                        where
                          perbill_c.dmddate = :dmddate
                          and perbill_c.billseq = :billseq
                          and perbill_c.branchno = :branchno
                          and perbill_c.billlineno = :billlineno for update nowait
                      ";

                        dynamic current = connection.Query(sql, param).FirstOrDefault();

                        // レコードが存在する場合
                        if (current != null)
                        {
                            rsvNo = current.RSVNO;
                            priceSeq = current.PRICESEQ;
                        }
                    }
                    else
                    {
                        rsvNo = Convert.ToInt32(data.RsvNo);
                        priceSeq = Convert.ToInt32(data.PriceSeq);
                    }

                    param.Add("rsvno", rsvNo);
                    param.Add("priceseq", priceSeq);

                    if (data.OtherLineDivCd != null)
                    {
                        if (!"".Equals(data.OtherLineDivCd))
                        {
                            param.Add("otherlinedivcd", data.OtherLineDivCd);
                        }
                    }

                    // 請求日あり？
                    if (data.DMDDate != null)
                    {
                        // 個人請求明細情報テーブルレコードの更新
                        sql = @"
                                update perbill_c
                                set
                                  price = :price
                                  , editprice = :editprice
                                  , taxprice = :taxprice
                                  , edittax = :edittax
                            ";

                        if (data.LineName != null && !"".Equals(data.LineName))
                        {
                            sql += ",    linename          = :linename ";
                        }

                        if (Convert.ToInt32(data.RsvNo) > 0)
                        {
                            sql += ",   rsvno          = :rsvno ";
                        }

                        if (Convert.ToInt32(data.PriceSeq) > 0)
                        {
                            sql += ",   priceseq          = :priceseq ";
                        }

                        if (data.OtherLineDivCd != null)
                        {
                            if (!"".Equals(data.OtherLineDivCd))
                            {
                                sql += ",   otherlinedivcd          = :otherlinedivcd ";
                            }
                        }

                        sql += @"
                                 where
                                   perbill_c.dmddate = :dmddate
                                   and perbill_c.billseq = :billseq
                                   and perbill_c.branchno = :branchno
                                   and perbill_c.billlineno = :billlineno
                             ";

                        connection.Execute(sql, param);
                    }

                    // 予約あり？
                    if (rsvNo != 0 && priceSeq != 0)
                    {
                        sql = @"
                                select
                                  linename
                                from
                                  consult_m
                                where
                                  consult_m.rsvno = :rsvno
                                  and consult_m.priceseq = :priceseq for update nowait
                            ";

                        dynamic current = connection.Query(sql, param).FirstOrDefault();

                        // レコードが存在する場合
                        if (current != null)
                        {
                            // 受診金額確定テーブルの明細名称更新
                            sql = @"
                            update consult_m
                            set
                              price = :price
                              , editprice = :editprice
                              , taxprice = :taxprice
                              , edittax = :edittax
                              , omittaxflg = :omittaxflg
                          ";

                            if (!"".Equals(data.LineName) && data.LineName != null)
                            {
                                sql += ",    linename          = :linename ";
                            }

                            if (data.OtherLineDivCd != null)
                            {
                                if (!"".Equals(data.OtherLineDivCd))
                                {
                                    sql += ",   otherlinedivcd          = :otherlinedivcd ";
                                }
                            }

                            sql += @"
                                     where
                                      consult_m.rsvno = :rsvno
                                      and consult_m.priceseq = :priceseq
                                 ";

                            connection.Execute(sql, param);
                        }
                    }

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return false;
                }
            }
            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 請求書統合を行う
        /// </summary>
        /// <param name="data">
        /// dmddate            統合先請求日
        /// billseq            統合先請求書Ｓｅｑ
        /// branchno           統合先請求書枝番
        /// olddmddate         統合元請求日
        /// oldbillseq         統合元請求書Ｓｅｑ
        /// oldbranchno        統合元請求書枝番
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool MergePerBill(MergePerBill data)
        {
            int billLineNo;   // 明細行No
            bool ret = true;  // 戻り値

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // 明細行Ｎｏ発番処理
                    billLineNo = GetBillLineNo(Convert.ToDateTime(data.DmdDate), data.BillSeq, data.branchno);

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("dmddate", Convert.ToDateTime(data.DmdDate));
                    param.Add("billseq", data.BillSeq);
                    param.Add("branchno", data.branchno);
                    param.Add("billlineno", billLineNo);
                    param.Add("olddmddate", Convert.ToDateTime(data.OldDmdDate));
                    param.Add("oldbillseq", data.OldBillSeq);
                    param.Add("oldbranchno", data.Oldbranchno);

                    // 個人請求明細情報テーブルレコードの挿入
                    string sql = @"
                                   insert
                                   into perbill_c(
                                     dmddate
                                     , billseq
                                     , branchno
                                     , billlineno
                                     , price
                                     , editprice
                                     , taxprice
                                     , edittax
                                     , ctrptcd
                                     , optcd
                                     , optbranchno
                                     , linename
                                     , rsvno
                                     , priceseq
                                     , otherlinedivcd
                                   ) (
                                     select
                                       :dmddate
                                       , :billseq
                                       , :branchno
                                       , :billlineno + billlineno - 1
                                       , price
                                       , editprice
                                       , taxprice
                                       , edittax
                                       , ctrptcd
                                       , optcd
                                       , optbranchno
                                       , linename
                                       , rsvno
                                       , priceseq
                                       , otherlinedivcd
                                     from
                                       perbill_c
                                     where
                                       perbill_c.dmddate = :olddmddate
                                       and perbill_c.billseq = :oldbillseq
                                       and perbill_c.branchno = :oldbranchno
                                   )
                                ";

                    connection.Execute(sql, param);

                    // 個人請求書管理受診情報テーブルレコードの挿入
                    sql = @"
                            insert
                            into perbill_csl(dmddate, billseq, branchno, rsvno)(
                              select distinct
                                :dmddate
                                , :billseq
                                , :branchno
                                , rsvno
                              from
                                perbill_c
                              where
                                perbill_c.dmddate = :olddmddate
                                and perbill_c.billseq = :oldbillseq
                                and perbill_c.branchno = :oldbranchno
                            )
                         ";

                    connection.Execute(sql, param);

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();
                    ret = false;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人請求書管理受診情報テーブルにレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// dmddate            請求日
        /// billseq            請求書Ｓｅｑ
        /// branchno           請求書枝番
        /// rsvno              予約番号
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool InsertPerBill_csl(InsertPerBill data)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", Convert.ToDateTime(data.DmdDate));
            param.Add("billseq", data.BillSeq);
            param.Add("branchno", data.BranchNo);
            param.Add("rsvno", data.RsvNo);

            string sql = @"
                           select
                             count(*) percount
                           from
                             perbill_csl
                           where
                             perbill_csl.dmddate = :dmddate
                             and perbill_csl.billseq = :billseq
                             and perbill_csl.branchno = :branchno
                             and perbill_csl.rsvno = :rsvno
                        ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在しない　または　COUNT = 0 の場合
            if (current == null || current.PERCOUNT == 0)
            {
                // 個人請求書管理受診情報テーブルレコードの挿入
                sql = @"
                        insert
                        into perbill_csl(dmddate, billseq, branchno, rsvno)
                        values (:dmddate, :billseq, :branchno, :rsvno)
                    ";

                connection.Execute(sql, param);
            }

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 個人請求書管理個人情報テーブルにレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// dmddate            請求日
        /// billseq            請求書Ｓｅｑ
        /// branchno           請求書枝番
        /// perid              個人ＩＤ
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool InsertPerBill_person(PerBillItem data)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", data.NewDmdDate);
            param.Add("billseq", Convert.ToInt32(data.BillSeq));
            param.Add("branchno", Convert.ToInt32(data.BranchNo));
            param.Add("perid", data.PerId);

            string sql = @"
                           select
                             count(*) percount
                           from
                             perbill_person
                           where
                             perbill_person.dmddate = :dmddate
                             and perbill_person.billseq = :billseq
                             and perbill_person.branchno = :branchno
                             and perbill_person.perid = :perid
                        ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在しない　または　COUNT = 0 の場合
            if (current == null || current.PERCOUNT == 0)
            {
                // 個人請求書管理個人情報テーブルレコードの挿入
                sql = @"
                        insert
                        into perbill_person(dmddate, billseq, branchno, perid)
                        values (:dmddate, :billseq, :branchno, :perid)
                     ";

                connection.Execute(sql, param);
            }

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 個人請求詳細情報テーブルにレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// dmddate            請求日
        /// billseq            請求書Ｓｅｑ
        /// branchno           請求書枝番
        /// price              金額
        /// editprice          調整金額
        /// taxprice           税額
        /// edittax            調整税額
        /// linename           明細名称
        /// rsvno              予約番号
        /// otherlinedivcd     セット外明細コード
        /// priceseq           受診金額Ｓｅｑ（省略時、受診金額確定テーブルにも挿入）
        /// linename_dmd       請求書詳細登録用
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool InsertPerBill_c(InsertPerBill_c data)
        {
            string sql;      // SQLステートメント
            int billLineNo = 0;  // 請求明細行No
            int priceSeq;    // 受信金額ＳＥＱ

            using (var ts = new TransactionScope())
            {
                try
                {
                    // 請求日あり？
                    if (!string.IsNullOrEmpty(data.DMDDate))
                    {
                        // 明細行Ｎｏ発番処理
                        billLineNo = GetBillLineNo(Convert.ToDateTime(data.DMDDate), Convert.ToInt32(data.BillSeq), Convert.ToInt32(data.BranchNo));
                    }

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    if (!string.IsNullOrEmpty(data.DMDDate))
                    {
                        param.Add("dmddate", Convert.ToDateTime(data.DMDDate));
                        param.Add("billseq", Convert.ToInt32(data.BillSeq));
                        param.Add("branchno", Convert.ToInt32(data.BranchNo));
                        param.Add("billlineno", billLineNo);
                    }

                    param.Add("price", Convert.ToInt32(data.Price));
                    param.Add("editprice", Convert.ToInt32(data.EditPrice));
                    param.Add("taxprice", Convert.ToInt32(data.TaxPrice));
                    param.Add("edittax", Convert.ToInt32(data.EditTax));
                    if (!string.IsNullOrEmpty(data.LineName))
                    {
                        param.Add("linename", data.LineName);
                    }

                    param.Add("otherlinedivcd", data.OtherLineDivCd);

                    // 予約番号あり？　受診金額Ｓｅｑ無し？
                    if (Convert.ToInt32(data.RsvNo) != 0 && data.PriceSeq == null)
                    {
                        param.Add("rsvno", Convert.ToInt32(data.RsvNo));

                        sql = @"
                                select
                                  nvl(max(priceseq) + 1, 1) priceseq
                                from
                                  consult_m
                                where
                                  rsvno = :rsvno
                            ";

                        dynamic current = connection.Query(sql, param).FirstOrDefault();

                        // レコードが存在しない場合は初期値を発番
                        if (current == null)
                        {
                            priceSeq = 1;
                        }
                        else
                        {
                            priceSeq = Convert.ToInt32(current.PRICESEQ);
                        }

                        param.Add("priceseq", priceSeq);

                        // 受診金額確定テーブルにレコード挿入
                        sql = @"
                                insert
                                into consult_m(rsvno, priceseq,
                            ";

                        if (!string.IsNullOrEmpty(data.LineName))
                        {
                            sql += "                       linename,      ";
                        }

                        sql += @"
                                 orgcd1
                                 , orgcd2
                                 , price
                                 , editprice
                                 , taxprice
                                 , edittax
                                 , otherlinedivcd
                             ";

                        if (!string.IsNullOrEmpty(data.DMDDate))
                        {
                            sql += @"
                                     , dmddate
                                     , billseq
                                     , branchno
                                     , billlineno
                                 ";
                        }

                        sql += @"
                         )
                         values (:rsvno, :priceseq,
                      ";

                        if (!string.IsNullOrEmpty(data.LineName))
                        {
                            sql += "                      :linename,      ";
                        }

                        sql += @"
                                 'XXXXX'
                                 , 'XXXXX'
                                 , :price
                                 , :editprice
                                 , :taxprice
                                 , :edittax
                                 , :otherlinedivcd
                            ";

                        if (!string.IsNullOrEmpty(data.DMDDate))
                        {
                            sql += @"
                                     , :dmddate
                                     , :billseq
                                     , :branchno
                                     , :billlineno
                                 ";
                        }
                        sql += "    )    ";

                        connection.Execute(sql, param);
                    }
                    else
                    {
                        if (Convert.ToInt32(data.RsvNo) != 0)
                        {
                            param.Add("rsvno", Convert.ToInt32(data.RsvNo));
                            param.Add("priceseq", Convert.ToInt32(data.PriceSeq));
                        }
                    }

                    // 請求日あり？
                    if (!string.IsNullOrEmpty(data.DMDDate))
                    {
                        // 個人請求明細情報テーブルレコードの挿入
                        sql = @"
                                insert
                                into perbill_c(
                                  dmddate
                                  , billseq
                                  , branchno
                                  , billlineno
                                  , price
                                  , editprice
                                  , taxprice
                                  , edittax
                                  ,
                              ";
                        if (data.LineNameDmd != null)
                        {
                            if (!string.IsNullOrEmpty(data.LineNameDmd))
                            {
                                sql += "       linename,   ";
                            }
                        }

                        if (Convert.ToInt32(data.RsvNo) != 0)
                        {
                            sql += " rsvno, priceseq, ";
                        }

                        sql += " otherlinedivcd ";

                        sql += @"
                                 )
                                 values (
                                   :dmddate
                                   , :billseq
                                   , :branchno
                                   , :billlineno
                                   , :price
                                   , :editprice
                                   , :taxprice
                                   , :edittax
                                   ,
                             ";

                        if (data.LineNameDmd != null)
                        {
                            if (!string.IsNullOrEmpty(data.LineNameDmd))
                            {
                                param.Add("linename_dmd", data.LineNameDmd);
                                sql += " :linename_dmd, ";
                            }
                        }

                        if (Convert.ToInt32(data.RsvNo) != 0)
                        {
                            sql += " :rsvno, :priceseq, ";
                        }

                        sql += " :otherlinedivcd ) ";

                        connection.Execute(sql, param);
                    }

                    // トランザクションをコミット
                    ts.Complete();
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定

                    return false;
                }
            }
            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// セット外請求明細の削除を行う
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="priceSeq">受診金額Ｓｅｑ</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeletePerBill_c(int rsvNo, int priceSeq)
        {
            bool ret = true;    // 戻り値

            using (var transaction = BeginTransaction())
            {
                try
                {
                    int perBillDelFlg = 0;

                    // キー値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("rsvno", rsvNo);
                    param.Add("priceseq", priceSeq);

                    string sql = @"
                                   select
                                     dmddate
                                     , billseq
                                     , branchno
                                     , billlineno
                                   from
                                     consult_m
                                   where
                                     rsvno = :rsvno
                                     and priceseq = :priceseq
                                ";

                    dynamic current = connection.Query(sql, param).FirstOrDefault();

                    // レコードが存在する場合
                    if (current != null)
                    {
                        // 個人請求明細情報のキーがある
                        if (current.DMDDATE != null)
                        {
                            // キー値の設定
                            param.Add("dmddate", Convert.ToDateTime(current.DMDDATE));
                            param.Add("billseq", Convert.ToInt32(current.BILLSEQ));
                            param.Add("branchno", Convert.ToInt32(current.BRANCHNO));
                            param.Add("billlineno", Convert.ToInt32(current.BILLLINENO));

                            // 個人請求明細情報削除
                            sql = @"
                                    delete perbill_c
                                    where
                                      dmddate = :dmddate
                                      and billseq = :billseq
                                      and branchno = :branchno
                                      and billlineno = :billlineno
                                ";

                            connection.Execute(sql, param);
                            perBillDelFlg = 1;
                        }
                    }

                    // 受診金額確定削除
                    sql = @"
                            delete consult_m
                            where
                              rsvno = :rsvno
                              and priceseq = :priceseq
                        ";
                    connection.Execute(sql, param);

                    // 個人請求明細の削除を行ったか？
                    if (perBillDelFlg == 1)
                    {
                        sql = @"
                                select
                                  count(*) perbillcnt
                                from
                                  perbill_c
                                where
                                  dmddate = :dmddate
                                  and billseq = :billseq
                                  and branchno = :branchno
                             ";
                        current = connection.Query(sql, param).FirstOrDefault();

                        // 明細が無くなった？
                        if (current.PERBILLCNT == 0)
                        {
                            sql = @"
                                    begin :ret := demandpackage.deleteperbill(:dmddate, :billseq, :branchno, :userid);
                                    end;
                                 ";

                            using (var cmd = new OracleCommand())
                            {
                                cmd.Parameters.Add("ret", 0);
                                cmd.Parameters.Add("userid", "");
                                cmd.Parameters.Add("dmddate", Convert.ToDateTime(current.DMDDATE));
                                cmd.Parameters.Add("billseq", Convert.ToInt32(current.BILLSEQ));
                                cmd.Parameters.Add("branchno", Convert.ToInt32(current.BRANCHNO));

                                ExecuteNonQuery(cmd, sql);
                            }

                        }
                    }

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();
                    ret = false;
                }
            }
            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 受診情報から個人請求書を作成する
        /// </summary>
        /// <param name="data">
        /// selectno           MAX枚数
        /// dmddate            請求日
        /// rsvno              予約番号
        /// page               作成ページ（配列）
        /// allpriceseq        受診金額Ｓｅｑ（配列）
        /// upduser            更新者ＩＤ
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool CreatePerBill_CSL(CreatePerBill data)
        {
            string sql;                            // SQLステートメント
            int billLineNo;                        // 請求明細行No
            List<int> priceSeq = new List<int>();  // 受診金額Ｓｅｑ;
            bool ans;                              // 関数復帰値
            bool ret = true;                       // 戻り値

            using (var transaction = BeginTransaction())
            {
                try
                {
                    for (int j = 0; j < Convert.ToInt32(data.SelectNo); j++)
                    {
                        int cnt = 0;
                        for (int i = 0; i < data.AllPriceSeq.Length; i++)
                        {
                            if (Convert.ToInt32(data.Page[i]) == j + 1)
                            {
                                if (cnt == 0)
                                {
                                    priceSeq = new List<int>();
                                }
                                priceSeq.Add(Convert.ToInt32(data.AllPriceSeq[i]));
                                cnt += 1;
                            }
                        }

                        if (cnt > 0)
                        {
                            // キー及び更新値の設定
                            var param = new Dictionary<string, object>();
                            param.Add("newdmddate", Convert.ToDateTime(data.DmdDate));
                            // 請求書Ｓｅｑ　取得
                            sql = @"
                                    select
                                      nvl(max(billseq) + 1, 1) maxbillseq
                                    from
                                      perbill
                                    where
                                      perbill.dmddate = :newdmddate
                                ";

                            dynamic current = connection.Query(sql, param).FirstOrDefault();

                            // 明細行Ｎｏ発番処理
                            billLineNo = GetBillLineNo(Convert.ToDateTime(data.DmdDate), Convert.ToInt32(current.MAXBILLSEQ), 0);

                            // キー及び更新値の設定
                            param = new Dictionary<string, object>();
                            param.Add("newdmddate", Convert.ToDateTime(data.DmdDate));
                            param.Add("newbillseq", Convert.ToInt32(current.MAXBILLSEQ));
                            param.Add("upduser", data.UpdUser);

                            // 個人請求書管理テーブルレコードの挿入
                            sql = @"
                                    insert
                                    into perbill(
                                      dmddate
                                      , billseq
                                      , branchno
                                      , delflg
                                      , upddate
                                      , upduser
                                    )
                                    values (
                                      :newdmddate
                                      , :newbillseq
                                      , 0
                                      , 0
                                      , sysdate
                                      , :upduser
                                    )
                                ";

                            connection.Execute(sql, param);

                            // 個人請求明細情報テーブルレコードの挿入
                            sql = @"
                                    insert
                                    into perbill_c(
                                      dmddate
                                      , billseq
                                      , branchno
                                      , billlineno
                                      , price
                                      , editprice
                                      , taxprice
                                      , edittax
                                      , linename
                                      , ctrptcd
                                      , optcd
                                      , optbranchno
                                      , rsvno
                                      , priceseq
                                      , otherlinedivcd
                                    )
                                    select
                                      :newdmddate
                                      , :newbillseq
                                      , 0
                                      , :billlineno
                                      , mainview.price
                                      , mainview.editprice
                                      , mainview.taxprice
                                      , mainview.edittax
                                      , case
                                        when mainview.linename is not null
                                          then mainview.linename
                                        when ctrpt_price.billprintname is not null
                                          then ctrpt_price.billprintname
                                        else mainview.optname
                                        end linename
                                      , mainview.ctrptcd
                                      , mainview.optcd
                                      , mainview.optbranchno
                                      , :newrsvno
                                      , :priceseq
                                      , mainview.otherlinedivcd
                                    from
                                      ctrpt_price
                                      , (
                                        select
                                          consult_m.orgcd1
                                          , consult_m.orgcd2
                                          , orgseqview.orgseq
                                          , org.orgname
                                          , consult_m.price
                                          , consult_m.editprice
                                          , consult_m.taxprice
                                          , consult_m.edittax
                                          , (
                                            consult_m.price + consult_m.editprice + consult_m.taxprice + consult_m.edittax
                                          ) linetotal
                                          , consult_m.priceseq
                                          , consult_m.ctrptcd
                                          , consult_m.optcd
                                          , consult_m.optbranchno
                                          , consult_m.otherlinedivcd
                                          , nvl(
                                            ctrpt_opt.optname
                                            , otherlinediv.otherlinedivname
                                          ) optname
                                          , consult_m.linename
                                        from
                                          otherlinediv
                                          , (
                                            select
                                              ctrpt_org.seq orgseq
                                              , nvl(ctrpt_org.orgcd1, consult.orgcd1) orgcd1
                                              , nvl(ctrpt_org.orgcd2, consult.orgcd2) orgcd2
                                            from
                                              ctrpt_org
                                              , consult
                                            where
                                              consult.rsvno = :newrsvno
                                              and ctrpt_org.ctrptcd = consult.ctrptcd
                                          ) orgseqview
                                          , ctrpt_opt
                                          , org
                                          , consult_m
                                        where
                                          consult_m.rsvno = :newrsvno
                                          and consult_m.priceseq = :priceseq
                                          and org.orgcd1 = consult_m.orgcd1
                                          and org.orgcd2 = consult_m.orgcd2
                                          and consult_m.orgcd1 = 'XXXXX'
                                          and consult_m.orgcd2 = 'XXXXX'
                                          and consult_m.ctrptcd = ctrpt_opt.ctrptcd(+)
                                          and consult_m.optcd = ctrpt_opt.optcd(+)
                                          and consult_m.optbranchno = ctrpt_opt.optbranchno(+)
                                          and orgseqview.orgcd1 = consult_m.orgcd1
                                          and orgseqview.orgcd2 = consult_m.orgcd2
                                          and consult_m.otherlinedivcd = otherlinediv.otherlinedivcd(+)
                                      ) mainview
                                    where
                                      mainview.ctrptcd = ctrpt_price.ctrptcd(+)
                                      and mainview.optcd = ctrpt_price.optcd(+)
                                      and mainview.optbranchno = ctrpt_price.optbranchno(+)
                                      and mainview.orgseq = ctrpt_price.seq(+)
                                 ";

                            var sqlParamList = new List<dynamic>();

                            for (int i = 0; i < priceSeq.Count; i++)
                            {
                                // キー及び更新値の設定
                                param = new Dictionary<string, object>();
                                param.Add("newdmddate", Convert.ToDateTime(data.DmdDate));
                                param.Add("newbillseq", Convert.ToInt32(current.MAXBILLSEQ));
                                param.Add("newrsvno", Convert.ToInt32(data.RsvNo));
                                param.Add("billlineno", billLineNo + i);
                                param.Add("priceseq", priceSeq[i]);

                                sqlParamList.Add(param);
                            }

                            if (sqlParamList.Count() > 0)
                            {
                                connection.Execute(sql, sqlParamList);
                            }

                            // 受診情報
                            InsertPerBill token = new InsertPerBill();
                            // 請求日
                            token.DmdDate = data.DmdDate;
                            // 請求書Ｓｅｑ
                            token.BillSeq = Convert.ToInt32(current.MAXBILLSEQ);
                            // 請求書枝番
                            token.BranchNo = 0;
                            // 予約番号
                            token.RsvNo = data.RsvNo;

                            // 個人請求書管理受診情報テーブルにレコード挿入
                            ans = InsertPerBill_csl(token);

                            // 受診金額確定に請求情報更新
                            sql = @"
                                    update consult_m
                                    set
                                      dmddate = :newdmddate
                                      , billseq = :newbillseq
                                      , branchno = 0
                                      , billlineno = :billlineno
                                    where
                                      consult_m.rsvno = :newrsvno
                                      and consult_m.priceseq = :priceseq
                                      and consult_m.orgcd1 = 'XXXXX'
                                      and consult_m.orgcd2 = 'XXXXX'
                                ";

                            sqlParamList = new List<dynamic>();

                            for (int k = 0; k < priceSeq.Count; k++)
                            {
                                // キー及び更新値の設定
                                param = new Dictionary<string, object>();
                                param.Add("newdmddate", Convert.ToDateTime(data.DmdDate));
                                param.Add("newbillseq", Convert.ToInt32(current.MAXBILLSEQ));
                                param.Add("newrsvno", data.RsvNo);
                                param.Add("billlineno", billLineNo + k);
                                param.Add("priceseq", priceSeq[k]);

                                sqlParamList.Add(param);
                            }

                            if (sqlParamList.Count() > 0)
                            {
                                connection.Execute(sql, sqlParamList);
                            }
                        }
                    }

                    // トランザクションをコミット
                    transaction.Commit();
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();
                    ret = false;
                }
            }
            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人請求書の新規作成、および修正をする
        /// </summary>
        /// <param name="mode">モード　insert:新規作成　update:修正</param>
        /// <param name="data">
        /// dmddate            請求日
        /// perid              個人ＩＤ（配列）
        /// price              金額（配列）
        /// editprice          調整金額（配列）
        /// taxprice           税額（配列）
        /// edittax            調整税額（配列）
        /// linename           明細名称（配列）
        /// otherlinedivcd     セット外明細コード（配列）
        /// billcomment        請求書コメント
        /// upduser            更新者ＩＤ
        /// </param>
        /// <param name="re_BillSeq">請求書Ｓｅｑ</param>
        /// <param name="re_BranchNo">請求書枝番</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool CreatePerBill_PERSON(string mode, PerBillPerson data, ref int re_BillSeq, ref int re_BranchNo)
        {
            string sql;    // SQLステートメント
            bool ans;      // 関数復帰値
            int billSeq;   // 請求書Ｓｅｑ
            int branchNo;  // 請求書枝番

            using (var ts = new TransactionScope())
            {
                try
                {
                    // 修正の場合はいったんDELETEしてから、新規作成と同じ処理をする
                    if (mode.Equals("update"))
                    {
                        ans = DeletePerBill(Convert.ToDateTime(data.DMDDate), Convert.ToInt32(data.BillSeq), Convert.ToInt32(data.BranchNo), data.UpdUser);
                    }

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("newdmddate", data.NewDmdDate);
                    param.Add("billcomment", data.BillComment);
                    param.Add("upduser", data.UpdUser);

                    if (mode.Equals("insert"))
                    {
                        // 請求書Ｓｅｑ　取得
                        sql = @"
                                select
                                  nvl(max(billseq) + 1, 1) maxbillseq
                                from
                                  perbill
                                where
                                  perbill.dmddate = :newdmddate
                            ";

                        dynamic current = connection.Query(sql, param).FirstOrDefault();

                        billSeq = Convert.ToInt32(current.MAXBILLSEQ);
                        branchNo = 0;
                    }
                    else
                    {
                        billSeq = Convert.ToInt32(data.BillSeq);
                        branchNo = Convert.ToInt32(data.BranchNo);
                    }

                    param.Add("newbillseq", billSeq);
                    param.Add("newbranchno", branchNo);

                    // 個人請求書管理テーブルレコードの挿入
                    sql = @"
                            insert
                            into perbill(
                              dmddate
                              , billseq
                              , branchno
                              , delflg
                              , upddate
                              , upduser
                              , billcomment
                            )
                            values (
                              :newdmddate
                              , :newbillseq
                              , :newbranchno
                              , 0
                              , sysdate
                              , :upduser
                              , :billcomment
                            )
                        ";

                    connection.Execute(sql, param);

                    List<PerBillItem> items = data.Item;

                    foreach (var rec in items)
                    {
                        if (Regex.IsMatch(rec.Price == null ? "" : rec.Price, @"^-?[1-9]\d*$"))
                        {
                            // 個人請求明細情報テーブルレコードの挿入
                            rec.DMDDate = data.NewDmdDate.ToString();
                            rec.BillSeq = billSeq.ToString();
                            rec.BranchNo = branchNo.ToString();
                            rec.LineNameDmd = rec.LineName;
                            rec.PriceSeq = rec.OtherLineDivCd;
                            ans = InsertPerBill_c(rec);
                        }

                        if (rec.PerId != null && !rec.PerId.Equals(""))
                        {
                            // 個人請求書管理個人情報テーブルにレコード挿入
                            rec.BillSeq = billSeq.ToString();
                            rec.NewDmdDate = data.NewDmdDate;
                            rec.BranchNo = branchNo.ToString();
                            ans = InsertPerBill_person(rec);
                        }
                    }

                    // 戻り値の設定
                    if (mode.Equals("insert"))
                    {
                        re_BillSeq = billSeq;
                        re_BranchNo = 0;
                    }
                    ts.Complete();
                }
                catch
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 請求書Ｎｏをキーに請求書コメントを更新する
        /// </summary>
        /// <param name="data">
        /// dmddate            請求日
        /// billseq            請求書Ｓｅｑ
        /// branchno           請求書枝番
        /// billcomment        請求書コメント
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdatePerBill_coment(PerBillComment data)
        {

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", data.DmdDate);
            param.Add("billseq", data.BillSeq);
            param.Add("branchno", data.BranchNo);
            param.Add("billcomment", data.BillComment);

            // 個人請求管理情報テーブル　請求書コメントの更新
            string sql = @"
                           update perbill
                           set
                             billcomment = :billcomment
                           where
                             perbill.dmddate = :dmddate
                             and perbill.billseq = :billseq
                             and perbill.branchno = :branchno
                        ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 請求書Ｎｏをキーに請求書管理情報を更新する
        /// </summary>
        /// <param name="dmddate">請求日</param>
        /// <param name="billseq">請求書Ｓｅｑ</param>
        /// <param name="branchno">請求書枝番</param>
        /// <param name="billname">請求書宛先</param>
        /// <param name="keishou">敬称</param>
        /// <param name="printdate">領収書印刷日</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdatePerBill(DateTime dmddate, int billseq, int branchno, string billname, string keishou, DateTime? printdate)
        {
            string sql;   // SQLステートメント
            bool updChk;  // 更新有無チェック

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmddate", dmddate);
            param.Add("billseq", billseq);
            param.Add("branchno", branchno);

            if (billname != null)
            {
                param.Add("billname", billname);
            }
            if (keishou != null)
            {
                param.Add("keishou", keishou);
            }
            if (printdate != null)
            {
                param.Add("printdate", printdate);
            }

            updChk = false;
            // 個人請求管理情報テーブル　請求書コメントの更新
            sql = "update perbill                      ";
            if (billname != null)
            {
                sql += " set billname = :billname  ";
                updChk = true;
            }
            if (keishou != null)
            {
                if (updChk)
                {
                    sql += " , keishou = :keishou  ";
                }
                else
                {
                    sql += " set keishou = :keishou ";
                }
                updChk = true;
            }
            if (printdate != null)
            {
                if (updChk)
                {
                    sql += " , printdate = :printdate ";
                }
                else
                {
                    sql += " set printdate = :printdate ";
                }
                updChk = true;
            }

            sql += @"
                     where
                       perbill.dmddate = :dmddate
                       and perbill.billseq = :billseq
                       and perbill.branchno = :branchno
                 ";

            if (updChk)
            {
                try
                {
                    connection.Execute(sql, param);
                }
                catch
                {
                    return false;
                }
            }

            return true;
        }

        #region "新設メソッド"

        /// <summary>
        /// Dataチェック
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> Validate(PerBillIncome data)
        {
            var messagesList = new List<string>();
            string message = "";

            message = WebHains.CheckNumeric("現金", data.Credit.Equals("") ? "0" : data.Credit, 8);
            if(message != null)
            {
                messagesList.Add(message);
            }
            
            message = CheckNumeric("ハッピー買物券", data.HappyTicket.Equals("") ? "0" : data.HappyTicket, 8);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }
            
            message = CheckNumeric("カード", data.Card.Equals("") ? "0" : data.Card, 8);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }
            
            message = CheckNumeric("Ｊデビット", data.Jdebit.Equals("") ? "0" : data.Jdebit, 8);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }
            
            message = CheckNumeric("小切手", data.Cheque.Equals("") ? "0" : data.Cheque, 8);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }
            
            message = CheckNumeric("振込み", data.Transfer.Equals("") ? "0" : data.Transfer, 8);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }
            
            message = CheckNumeric("伝票No.", data.Creditslipno.Equals("") ? "0" : data.Creditslipno, 5);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }

            if (data.PaymentDate == null || data.PaymentDate.Equals(""))
            {
                messagesList.Add("入金日が指定されていません。");
            }

            if (data.MaxDmdDate > Convert.ToDateTime(data.PaymentDate))
            {
                messagesList.Add("入金日は請求日よりも過去の日付に設定することはできません。");
            }

            if (data.CalcDate == null || data.CalcDate.Equals(""))
            {
                messagesList.Add("計上日が入力されていません。");
            }

            if (Convert.ToDateTime(data.PaymentDate) > Convert.ToDateTime(data.CalcDate))
            {
                messagesList.Add("計上日は入金日よりも過去の日付に設定することはできません。");
            }

            int card = 0;
            if (data.Card != null && !data.Card.Equals(""))
            {
                card = Convert.ToInt32(data.Card);
            }
            if(card != 0 && (data.Cardkind == "" || data.Creditslipno == ""))
            {
                messagesList.Add("カード情報が入力されていません。");
            }

            int jdebit = 0;
            if(data.Jdebit != null && !data.Jdebit.Equals(""))
            {
                jdebit = Convert.ToInt32(data.Jdebit);
            }
            if(jdebit != 0 && data.Bankcode == "")
            {
                messagesList.Add("Ｊデビットの金融機関が指定されていません。");
            }
            int changePrice = Convert.ToInt32(data.Credit.Equals("") ? "0" : data.Credit) + Convert.ToInt32(data.HappyTicket.Equals("") ? "0" : data.HappyTicket)
                + Convert.ToInt32(data.Card.Equals("") ? "0" : data.Card) + Convert.ToInt32(data.Jdebit.Equals("") ? "0" : data.Jdebit)
                + Convert.ToInt32(data.Cheque.Equals("") ? "0" : data.Cheque) + Convert.ToInt32(data.Transfer.Equals("") ? "0" : data.Transfer)
                - Convert.ToInt32(data.PriceTotal.Equals("") ? "0" : data.PriceTotal);
            if (changePrice < 0)
            {
                messagesList.Add("入金金額が請求金額に達していないため保存できません。");
            }

            return messagesList;
        }

        /// <summary>
        /// 請求書コメントの妥当性チェックを行う
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateForCreatePerBill(PerBillPerson data)
        {
            var messagesList = new List<string>();
            string message = null;

            // 請求書コメントチェック
            // 文字列長チェック
            if (WebHains.LenB(data.BillComment) > 200)
            {
                message = string.Format("{0}は{1}文字以内の全角文字で入力して下さい。", "請求書コメント", 200 / 2);
            }

            if (message != null)
            {
                messagesList.Add(message);
            }

            // 受診者入力チェック
            int perCount = data.PerCount;
            int i = 0;
            string[] perId = data.PerIdS;
            for (i = 0; i < perCount; i++)
            {
                if(!"".Equals(perId[i]))
                {
                    break;
                }
            }

            if(i >= perCount)
            {
                messagesList.Add("受診者を指定して下さい。");
            }

            // 請求明細入力チェック
            int billCount = data.BillCount;
            string[] otherLineDivCd = data.OtherLineDivCdS;

            for (i = 0; i < billCount; i++)
            {
                if (!"".Equals(otherLineDivCd[i]))
                {
                    break;
                }
            }

            if (i >= billCount)
            {
                messagesList.Add("請求明細を指定して下さい。");
            }

            return messagesList;
        }

        /// <summary>
        /// Dataチェック
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateForEditPerBillLine1(UpdatePerBill_c data)
        {
            var messagesList = new List<string>();
            string message = "";

            // 請求書コメントチェック
            if("".Equals(data.LineNameDmd))
            {
                messagesList.Add("請求詳細名が入力されていません。");
            }

            message = WebHains.CheckWideValue("請求詳細名", data.LineNameDmd, 40, Check.Necessary);
            if (message != null)
            {
                messagesList.Add(message);
            }

            message = CheckNumeric("請求金額", data.Price, 7);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }

            message = CheckNumeric("調整金額", data.EditPrice, 7);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }

            message = CheckNumeric("消費税", data.TaxPrice, 7);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }

            message = CheckNumeric("調整税額", data.EditTax, 7);
            if (!"".Equals(message))
            {
                messagesList.Add(message);
            }

            return messagesList;
        }

        /// <summary>
        /// 請求書コメントの妥当性チェックを行う
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateForPerBillComment(PerBillComment data)
        {
            var messagesList = new List<string>();
            string message = null;

            // 請求書コメントチェック
            // 文字列長チェック
            if (WebHains.LenB(data.BillComment) > 200)
            {
                message = string.Format("{0}は{1}文字以内の全角文字で入力して下さい。", "請求書コメント", 100);
            }
            if (message != null)
            {
                messagesList.Add(message);
            }

            return messagesList;
        }

        /// <summary>
        /// 入力の妥当性チェックを行う
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateForPrtPerBill(PrtPerBill data)
        {
            var messagesList = new List<string>();
            string message = "";

            for (int i = 0, len = data.BillNameArray.Count(); i < len; i++)
            {
                message = WebHains.CheckWideValue("宛名", WebHains.StrConvKanaWide(data.BillNameArray[i]), 100);
                if (!(message == null))
                {
                    messagesList.Add(message);
                }
            }

            return messagesList;
        }


        /// <summary>
        /// 請求書コメントの妥当性チェックを行う
        /// </summary>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> ValidateForOtherIncomeInfo(InsertPerBill_c data)
        {
            string divCd = data.OtherLineDivCd;
            string lineName = data.LineNameDmd;
            string price = data.Price;
            string editPrice = data.EditPrice;
            string taxPrice = data.TaxPrice;
            string editTax = data.EditTax;

            var vntArrMessage = new List<string>();   // エラーメッセージの集合
            string strArrMessage = null;           //エラーメッセージ

            // 請求書コメントチェック
            if (string.IsNullOrEmpty(divCd))
            {
                vntArrMessage.Add("セット外請求明細名【？】を選択して下さい。");
            }

            // 請求詳細名
            strArrMessage = WebHains.CheckWideValue("請求詳細名", lineName.Trim(), 40, Check.Necessary);
            if (strArrMessage != null)
            {
                vntArrMessage.Add(strArrMessage);
            }

            // 請求金額
            strArrMessage = this.CheckNumeric("請求金額", price, 7);
            if (strArrMessage != "")
            {
                vntArrMessage.Add(strArrMessage);
            }

            // 調整金額
            strArrMessage = this.CheckNumeric("調整金額", editPrice, 7);
            if (strArrMessage != "")
            {
                vntArrMessage.Add(strArrMessage);
            }

            // 消費税
            strArrMessage = this.CheckNumeric("消費税", taxPrice, 7);
            if (strArrMessage != "")
            {
                vntArrMessage.Add(strArrMessage);
            }

            // 調整税額
            strArrMessage = this.CheckNumeric("調整税額", editTax, 7);
            if (strArrMessage != "")
            {
                vntArrMessage.Add(strArrMessage);
            }

            // 戻り値の編集
            return vntArrMessage;
        }
        #endregion
    }
}
