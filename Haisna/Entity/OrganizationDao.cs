using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Common.Table;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 団体情報データアクセスオブジェクト
    /// </summary>
    public class OrganizationDao : AbstractDao
    {
        /// <summary>
        /// 汎用コード(団体名称ハイライト表示条件)
        /// </summary>
        const string CON_FREECD = "HLORG01";

        /// <summary>
        /// 汎用分類コード(成績書オプション管理コード)
        /// </summary>
        const string FREECLASSCD_REP = "REP";

        /// <summary>
        /// 汎用データアクセスオブジェクト
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// 都道府県データアクセスオブジェクト
        /// </summary>
        readonly PrefDao prefDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="freeDao">汎用データアクセスオブジェクト</param>
        /// <param name="prefDao">都道府県データアクセスオブジェクト</param>
        public OrganizationDao(IDbConnection connection, FreeDao freeDao, PrefDao prefDao) : base(connection)
        {
            this.freeDao = freeDao;
            this.prefDao = prefDao;
        }

        /// <summary>
        /// 団体テーブル検索用条件節作成
        /// </summary>
        /// <param name="param">SQLパラメータ</param>
        /// <param name="keys">検索キーの集合</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="delFlgs">削除フラグ</param>
        /// <returns>団体テーブル検索用の条件節</returns>
        /// <remarks>
        /// 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
        /// 検索キーに半角カナ文字が存在する場合は全角変換が行われる
        /// </remarks>
        string CreateConditionForOrgList(ref Dictionary<string, object> param, string[] keys, string csCd, string[] delFlgs)
        {
            var condition = new List<string>(); // 条件節の集合

            // 検索キー数分の条件節を追加
            if (keys != null)
            {
                int seq = 0;
                foreach (var key in keys)
                {
                    seq++;

                    // 検索キー中の半角カナを全角カナに変換する
                    string buffer = Util.StrConvKanaWide(key);

                    // 検索キーが半角文字のみかチェック
                    bool isNarrow = Util.IsHalfword(buffer);

                    // パラメータ追加
                    string paramName = "name" + seq.ToString();

                    if (isNarrow)
                    {
                        // パラメータ追加
                        param.Add(paramName, buffer + "%");
                        condition.Add("(org.orgcd1 like :" + paramName + " or org.orgcd2 like :" + paramName + ") ");
                    }
                    else
                    {
                        // パラメータ追加
                        param.Add(paramName, "%" + buffer + "%");
                        condition.Add("(org.orgname like :" + paramName + " or org.orgkname like :" + paramName + ") ");
                    }
                }
            }

            // コースコード指定時は、そのコースの契約情報を持つ団体のみを検索対象とする
            if (!string.IsNullOrEmpty(csCd))
            {
                param.Add("cscd", csCd);
                condition.Add(@"
                    exists (
                        select
                            orgcd1
                        from
                            ctrmng
                        where
                            orgcd1 = org.orgcd1
                            and orgcd2 = org.orgcd2
                            and cscd = :cscd
                    )
                ");
            }

            // 削除フラグの指定
            if (delFlgs != null && delFlgs.Length > 0)
            {
                int seq = 0;
                var columns = new List<string>(); // 列値の集合
                foreach (var delFlg in delFlgs)
                {
                    string paramName = "delflg" + (++seq).ToString();
                    param.Add(paramName, delFlg);
                    columns.Add(":" + paramName);
                }

                condition.Add("org.delflg in (" + string.Join(",", columns) + ")");
            }

            // すべての条件節をANDで連結
            return condition.Count > 0 ? string.Join(" and ", condition) : null;
        }

        /// <summary>
        /// 団体テーブルレコードを削除する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// 1   正常終了
        /// 0   参照整合性制約のために削除不可
        /// </returns>
        public int DeleteOrg(string orgCd1, string orgCd2)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();

            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            try
            {
                // 所属テーブルレコードの削除
                var sql = @"
                    delete orgpost
                    where
                        orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                ";

                connection.Execute(sql, param);

                // 室部テーブルレコードの削除
                sql = @"
                    delete orgroom
                    where
                        orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                ";

                connection.Execute(sql, param);

                // 事業部テーブルレコードの削除
                sql = @"
                    delete orgbsd
                    where
                        orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                ";

                connection.Execute(sql, param);

                // 団体テーブルレコードの削除
                sql = @"
                    delete org
                    where
                        orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                ";

                connection.Execute(sql, param);

                return 1;
            }
            catch (OracleException ex)
            {
                // 子レコード存在時は戻り値を設定して正常終了させる
                if (ex.Number == 2292)
                {
                    return 0;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 指定団体の団体テーブルレコードにレコードロックを適用する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// True   正常終了
        /// False  レコードなし、または異常終了
        /// </returns>
        public bool LockOrgRecord(string orgCd1, string orgCd2)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体テーブルのレコードを取得
            var sql = @"
                select
                    orgcd1
                from
                    org
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                for update
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // 戻り値の設定
            return data != null;
        }

        /// <summary>
        /// 団体コード、住所区分をキーに団体住所情報テーブルを読み込む
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="addrDiv">住所区分</param>
        /// <returns>
        /// zipcd 郵便番号
        /// prefcd 都道府県コード
        /// cityname 市区町村名
        /// address1 住所１
        /// address2 住所２
        /// directtel 電話番号１
        /// tel 電話番号２
        /// extension 内線１
        /// fax FAX
        /// email E-MAIL
        /// url URL
        /// </returns>
        public dynamic SelectOrgAddr(string orgCd1, string orgCd2, int addrDiv)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("addrdiv", addrDiv);

            // 検索条件を満たす個人住所情報テーブルのレコードを取得
            var sql = @"
                select
                    zipcd
                    , prefcd
                    , cityname
                    , address1
                    , address2
                    , directtel
                    , tel
                    , extension
                    , fax
                    , email
                    , url
                from
                    orgaddr
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                    and addrdiv = :addrdiv
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 団体コードをキーに団体住所情報テーブルを読み込む
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// zipcd        郵便番号
        /// prefcd       都道府県コード
        /// cityname     市区町村名
        /// address1     住所１
        /// address2     住所２
        /// directtel    電話番号１
        /// tel          電話番号２
        /// extension    内線１
        /// fax          FAX
        /// email        E-MAIL
        /// url          URL
        /// chargename   担当者
        /// chargekname  担当者カナ名
        /// chargeemail  担当者E-MAIL
        /// chargepost   担当部署
        /// orgname      漢字名称
        /// </returns>
        public IList<dynamic> SelectOrgAddrList(string orgCd1, string orgCd2)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体住所情報テーブルのレコードを取得
            var sql = @"
                select
                    addrdiv
                    , zipcd
                    , prefcd
                    , cityname
                    , address1
                    , address2
                    , directtel
                    , tel
                    , extension
                    , fax
                    , email
                    , url
                    , chargename
                    , chargekname
                    , chargeemail
                    , chargepost
                    , orgname
                from
                    orgaddr
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 健保記号からの団体検索
        /// </summary>
        /// <param name="isrSign">健保記号</param>
        /// <param name="orgCd1">団体コード1(本引数に設定された団体は検索対象としない)</param>
        /// <param name="orgCd2">団体コード2(本引数に設定された団体は検索対象としない)</param>
        /// <returns>
        /// orgcd1 団体コード1
        /// orgcd2 団体コード2
        /// orgsname 団体略称
        /// </returns>
        public dynamic SelectOrgFromIsr(string isrSign, string orgCd1 = null, string orgCd2 = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("isrsign", isrSign);
            if (!string.IsNullOrEmpty(orgCd1) && !string.IsNullOrEmpty(orgCd2))
            {
                param.Add("orgcd1", orgCd1);
                param.Add("orgcd2", orgCd2);
            }

            // 検索条件を満たす団体テーブルのレコードを取得
            var sql = @"
                select
                    orgcd1
                    , orgcd2
                    , orgsname
                from
                    org
                where
                    isrsign = :isrsign
                    and isrgetname is not null
            ";

            // 指定された団体は除く
            if (!string.IsNullOrEmpty(orgCd1) && !string.IsNullOrEmpty(orgCd2))
            {
                sql += @"
                    and (orgcd1 != :orgcd1 or orgcd2 != :orgcd2)
                ";
            }

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 団体コードをキーに団体テーブルを読み込む
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// orgkname     カナ名称
        /// orgname      漢字名称
        /// zipcd        郵便番号1
        /// prefname     都道府県名
        /// cityname     市区町村名
        /// address1     住所1
        /// address2     住所2
        /// tel          電話番号代表－市外局番
        /// chargename   担当者氏名
        /// chargepost   担当者部署名
        /// highlight    団体名称ハイライト表示区分
        /// </returns>
        public dynamic SelectOrgHeader(string orgCd1, string orgCd2)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();

            // 検索条件が設定されていない場合はエラー
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体テーブルのレコードを取得
            var sql = @"
                select
                    org.orgkname
                    , org.orgname
                    , org.spare3
                    , orgaddr.zipcd
                    , pref.prefname
                    , orgaddr.cityname
                    , orgaddr.address1
                    , orgaddr.address2
                    , orgaddr.tel
                    , orgaddr.chargename
                    , orgaddr.chargepost
                from
                    pref
                    , orgaddr
                    , org
                where
                    org.orgcd1 = :orgcd1
                    and org.orgcd2 = :orgcd2
                    and org.orgcd1 = orgaddr.orgcd1(+)
                    and org.orgcd2 = orgaddr.orgcd2(+)
                    and 1 = orgaddr.addrdiv(+)
                    and orgaddr.prefcd = pref.prefcd(+)
            ";

            var org = (IDictionary<string, object>)connection.Query(sql, param).FirstOrDefault();
            if (org == null)
            {
                return null;
            }

            // 汎用項目３(SPARE3)に登録されているデータが「10桁」で日付タイプの場合団体名称ハイライト表示
            int highLight = 0;
            dynamic free = SelectFree(CON_FREECD);
            if (free != null)
            {
                string spare3 = Convert.ToString(org["SPARE3"]).Trim();
                switch (free.FREEFIELD2)
                {
                    case "DATE":
                        // 日付形式
                        if (int.TryParse(Convert.ToString(free.FREEFIELD1).Trim(), out int wkFreeField1))
                        {
                            if ((spare3.Length == wkFreeField1) && DateTime.TryParse(spare3, out DateTime wkDate))
                            {
                                highLight = 1;
                            }
                        }
                        else
                        {
                            if (DateTime.TryParse(spare3, out DateTime wkDate))
                            {
                                highLight = 1;
                            }
                        }
                        break;

                    case "FIX":

                        string freeField3 = Convert.ToString(free.FREEFIELD3).Trim();
                        if (!string.IsNullOrEmpty(freeField3) && (spare3.Equals(freeField3)))
                        {
                            highLight = 1;
                        }
                        break;

                    default:
                        break;
                }
            }

            org.Add("highlight", highLight);

            return org;
        }

        /// <summary>
        /// 団体コードをキーに団体テーブルを読み、名称を取得
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// orgname 漢字名称
        /// </returns>
        public dynamic SelectOrgName(string orgCd1, string orgCd2)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();

            // 検索条件が設定されていない場合はエラー
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体テーブルのレコードを取得
            var sql = @"
                select
                    orgname
                from
                    org
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 団体コードをキーに団体テーブルを読み、略称を取得
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// orgsname 略称
        /// </returns>
        public dynamic SelectOrgSName(string orgCd1, string orgCd2)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();

            // 検索条件が設定されていない場合はエラー
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体テーブルのレコードを取得
            var sql = @"
                select
                    orgsname
                from
                    org
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす団体の一覧を取得する
        /// </summary>
        /// <param name="keys">検索キーの集合</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="delFlgs">削除フラグ</param>
        /// <param name="addrDiv">住所区分</param>
        /// <returns>
        /// orgcd1    団体コード1
        /// orgcd2    団体コード2
        /// orgname   漢字名称
        /// orgsname  略称
        /// orgkname  カナ名称
        /// orgdiv    団体種別
        /// isrsign   健保記号
        /// notes     特記事項
        /// prefname  都道府県名
        /// cityname  市区町村名
        /// address1  住所１
        /// </returns>
        public PartialDataSet SelectOrgList(string[] keys, int startPos, int getCount, string csCd = null, string[] delFlgs = null, int? addrDiv = 1)
        {
            var sql = ""; // SQL
            IEnumerable<dynamic> query = null;
            int count = 0;

            // 条件節の作成
            var param = new Dictionary<string, object>();
            string condition = CreateConditionForOrgList(ref param, keys, csCd, delFlgs);

            // 件数取得と実データ取得という２回分のSQL発行
            for (var phase = 0; phase <= 1; phase++)
            {
                switch (phase)
                {
                    case 0:

                        // 件数取得の場合
                        sql = @"
                            select
                                count(*) cnt
                            from
                                org
                            ";

                        if (!string.IsNullOrEmpty(condition))
                        {
                            sql += @"
                            where " + condition;
                        }

                        dynamic countData = connection.Query(sql, param).FirstOrDefault();
                        count = Convert.ToInt32(countData.CNT);

                        break;

                    case 1:

                        // 実データ取得の場合
                        // パラメータ追加
                        param.Add("startpos", startPos + 1);
                        param.Add("endpos", startPos + getCount);
                        param.Add("addrdiv", addrDiv);

                        sql = @"
                            select
                                orgcd1
                                , orgcd2
                                , orgname
                                , orgsname
                                , orgkname
                                , notes
                                , prefname
                                , cityname
                                , address1
                            from
                                (
                                    select
                                        rownum seq
                                        , orgcd1
                                        , orgcd2
                                        , orgname
                                        , orgsname
                                        , orgkname
                                        , notes
                                        , prefname
                                        , cityname
                                        , address1
                                    from
                                        (
                                            select
                                                org.orgcd1
                                                , org.orgcd2
                                                , org.orgname
                                                , org.orgsname
                                                , org.orgkname
                                                , org.notes
                                                , pref.prefname
                                                , orgaddr.cityname
                                                , orgaddr.address1
                                            from
                                                pref
                                                , orgaddr
                                                , org
                                            where
                                                1 = 1
                            ";

                        // 検索条件を編集
                        if (!string.IsNullOrEmpty(condition))
                        {
                            sql += @"
                                                and " + condition;
                        }

                        // その他結合条件を編集
                        sql += @"
                                                and org.orgcd1 = orgaddr.orgcd1(+)
                                                and org.orgcd2 = orgaddr.orgcd2(+)
                                                and :addrdiv = orgaddr.addrdiv(+)
                                                and orgaddr.prefcd = pref.prefcd(+)
                        ";

                        if (keys != null && keys.Length > 0)
                        {
                            sql += @"
                                            order by
                                                org.orgkname
                                                , org.orgcd1
                                                , org.orgcd2
                            ";
                        }
                        else
                        {
                            sql += @"
                                            order by
                                                org.orgcd1
                                                , org.orgcd2
                            ";
                        }

                        sql += @"
                                        )
                        ";

                        // 検索結果にROWNUM、即ちSEQ番号を付加し、この値と開始位置、取得件数による絞り込みを行う
                        sql += @"
                                )
                            where
                                seq between :startpos and :endpos
                        ";

                        query = connection.Query(sql, param).ToList();
                        break;
                }

                // 件数取得にて０件の場合は処理を終了する
                if (phase == 0 && count == 0)
                {
                    query = new List<dynamic>();
                    break;
                }
            }

            return new PartialDataSet(count, query);
        }

        /// <summary>
        /// 団体一覧の読み込み
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="zipCd1">郵便番号1</param>
        /// <param name="zipCd2">郵便番号2</param>
        /// <returns>
        /// orgcd1      団体コード1
        /// orgcd2      団体コード2
        /// orgname     団体漢字名称
        /// orgkname    団体カナ名称
        /// zipcd1      郵便番号1
        /// zipcd2      郵便番号2
        /// cityname    市区町村名
        /// address1    住所1
        /// address2    住所2
        /// tel1        電話番号－市外局番
        /// tel2        電話番号－局番
        /// tel3        電話番号－番号
        /// chargename  担当者
        /// chargepost  担当部署
        /// prefname    都道府県名
        /// </returns>
        public IList<dynamic> SelectOrgListForPrint(string orgCd1 = null, string orgCd2 = null, string zipCd1 = null, string zipCd2 = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("zipcd1", zipCd1);
            param.Add("zipcd2", zipCd2);

            // 指定条件を満たす団体テーブルレコードを取得
            var sql = @"
                select
                    org.orgcd1
                    , org.orgcd2
                    , org.orgname
                    , org.orgkname
                    , org.zipcd1
                    , org.zipcd2
                    , org.cityname
                    , org.address1
                    , org.address2
                    , org.tel1
                    , org.tel2
                    , org.tel3
                    , pref.prefname
                from
                    org
                    , pref
                where
                    1 = 1
            ";

            if (!string.IsNullOrEmpty(orgCd1))
            {
                sql += @"
                    and org.orgcd1 = :orgcd1
                ";
            }

            if (!string.IsNullOrEmpty(orgCd2))
            {
                sql += @"
                    and org.orgcd2 = :orgcd2
                ";
            }

            if (!string.IsNullOrEmpty(zipCd1))
            {
                sql += @"
                    and org.zipcd1 = :zipcd1
                ";
            }

            if (!string.IsNullOrEmpty(zipCd2))
            {
                sql += @"
                    and org.zipcd2 = :zipcd2
                ";
            }

            sql += @"
                    and org.prefcd = pref.prefcd(+)
                order by
                    org.orgcd1
                    , org.orgcd2
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 受診者数取得（団体別）
        /// </summary>
        /// <param name="cslDate">対象日付</param>
        /// <returns>
        /// orgcd1 団体コード１
        /// orgcd2 団体コード２
        /// orgname 団体名
        /// orgsu 人数
        /// </returns>
        public IList<dynamic> SelectSelDateOrg(DateTime cslDate)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("seldate", cslDate);
            param.Add("cancelflg", ConsultCancel.Used);

            // BBSテーブルから取得
            var sql = @"
                select
                    consult.orgcd1
                    , consult.orgcd2
                    , org.orgname
                    , count(consult.perid) as orgsu
                from
                    org
                    , consult
                where
                    org.orgcd1 = consult.orgcd1
                    and org.orgcd2 = consult.orgcd2
                    and consult.cancelflg = :cancelflg
                    and consult.csldate = :seldate
                group by
                    consult.orgcd1
                    , consult.orgcd2
                    , org.orgname
            ";

            return connection.Query(sql, param).ToList();
        }

        string ReplaceKanaString(string stream)
        {
            string buffer; // 文字列バッファ

            buffer = stream;
            buffer = buffer.Replace("ァ", "ア");
            buffer = buffer.Replace("ィ", "イ");
            buffer = buffer.Replace("ゥ", "ウ");
            buffer = buffer.Replace("ェ", "エ");
            buffer = buffer.Replace("ォ", "オ");
            buffer = buffer.Replace("ッ", "ツ");
            buffer = buffer.Replace("ャ", "ヤ");
            buffer = buffer.Replace("ュ", "ユ");
            buffer = buffer.Replace("ョ", "ヨ");

            return buffer;
        }

        // 団体テーブルに存在しないprefcd列をアクセスするSQLが発行されているため不要。コメントアウト。
        ///// <summary>
        ///// 団体コードをキーに団体テーブルを読み込む
        ///// </summary>
        ///// <param name="orgCd1">団体コード1</param>
        ///// <param name="orgCd2">団体コード2</param>
        ///// <returns>
        ///// orgkname     カナ名称
        ///// orgname      漢字名称
        ///// orgbillname  請求書用名称
        ///// orgsname     略称
        ///// orgdiv       団体種別
        ///// zipcd1       郵便番号1
        ///// zipcd2       郵便番号2
        ///// prefcd       都道府県コード
        ///// prefname     都道府県名
        ///// cityname     市区町村名
        ///// address1     住所1
        ///// address2     住所2
        ///// tel1         電話番号代表－市外局番
        ///// tel2         電話番号代表－局番
        ///// tel3         電話番号代表－番号
        ///// directtel1   電話番号直通－市外局番
        ///// directtel2   電話番号直通－局番
        ///// directtel3   電話番号直通－番号
        ///// extension    内線
        ///// fax1         FAX－市外局番
        ///// fax2         FAX－局番
        ///// fax3         FAX－番号
        ///// chargename   担当者氏名
        ///// chargekname  担当者カナ名
        ///// chargeemail  担当者e-mailアドレス
        ///// chargepost   担当者部署名
        ///// isrno        保険者番号
        ///// isrsign      健保記号(記号)
        ///// isrmark      健保記号(符号)
        ///// heisrno      健保番号
        ///// isrdiv       保険区分
        ///// bank         銀行名
        ///// branch       支店名
        ///// accountkind  口座種別
        ///// accountno    口座番号
        ///// notes        特記事項
        ///// spare1       予備1
        ///// spare2       予備2
        ///// spare3       予備3
        ///// upddate      更新日時
        ///// upduser      更新者
        ///// username     更新者名
        ///// roundnotaxflg  まるめ金消費税非計算フラグ
        ///// </returns>
        //public dynamic SelectOrg(string orgCd1, string orgCd2)
        //{
        //    // キー値の設定
        //    var sqlPram = new
        //    {
        //        orgcd1 = orgCd1,
        //        orgcd2 = orgCd2
        //    };

        //    // 検索条件を満たす団体テーブルのレコードを取得
        //    var sql = @"
        //            select
        //                org.orgkname
        //                , org.orgname
        //                , org.orgbillname
        //                , org.orgsname
        //                , org.orgdiv
        //                , org.zipcd1
        //                , org.zipcd2
        //                , org.prefcd
        //                , pref.prefname
        //                , org.cityname
        //                , org.address1
        //                , org.address2
        //                , org.tel1
        //                , org.tel2
        //                , org.tel3
        //                , org.directtel1
        //                , org.directtel2
        //                , org.directtel3
        //                , org.extension
        //                , org.fax1
        //                , org.fax2
        //                , org.fax3
        //                , org.govmngcd
        //                , org.isrno
        //                , org.isrsign
        //                , org.isrmark
        //                , org.heisrno
        //                , org.isrdiv
        //                , org.bank
        //                , org.branch
        //                , org.accountkind
        //                , org.accountno
        //                , org.notes
        //                , org.spare1
        //                , org.spare2
        //                , org.spare3
        //                , org.upddate
        //                , org.upduser
        //                , hainsuser.username
        //                , org.roundnotaxflg
        //                , org.isrgetname
        //            from
        //                hainsuser
        //                , pref
        //                , org
        //            where
        //                org.orgcd1 = :orgcd1
        //                and org.orgcd2 = :orgcd2
        //                and org.prefcd = pref.prefcd(+)
        //                and org.upduser = hainsuser.userid(+)
        //                and org.delflg = " + Convert.ToString((int)DelFlg.Used);

        //    return Query(sql, sqlPram).FirstOrDefault();
        //}

        /// <summary>
        /// 団体コードをキーに団体テーブルを読み込む（聖路加バージョン）
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// delflg       使用状態
        /// orgkname     カナ名称
        /// orgname      漢字名称
        /// orgename     漢字名称（英語）
        /// orgsname     略称
        /// orgdivcd     団体種別
        /// orgbillname  請求書用名称
        /// chargename   担当者氏名
        /// chargekname  担当者カナ名
        /// chargeemail  担当者e-mailアドレス
        /// chargepost   担当者部署名
        /// bank         銀行名
        /// branch       支店名
        /// accountkind  口座種別
        /// accountno    口座番号
        /// numemp       社員数
        /// avgage       平均年齢
        /// dm           DM
        /// sendmethod   送付方法
        /// postcard     確認はがき
        /// packagesend  一括送付案内
        /// ticket       利用券
        /// inscheck     保険証予約時確認
        /// insbring     保険証当日持参
        /// insreport    保険証成績所出力
        /// billaddress   請求書適用住所
        /// billcsldiv   請求書本人家族区分
        /// billins      請求書保険証情報出力
        /// billempno    請求書社員番号出力
        /// billreport   請求書成績書添付
        /// sendcomment  送付案内コメント
        /// sendecomment 英語送付案内コメント
        /// spare1       予備1
        /// spare2       予備2
        /// spare3       予備3
        /// notes        特記事項
        /// dmdcomment   請求関連コメント
        /// upddate      更新日時
        /// upduser      更新者
        /// username     更新者名
        /// noprintletter１年目はがき非出力フラグ
        /// visitdate    定期訪問予定日
        /// presents     年始・中元・歳暮
        /// ticketdiv           利用券区分
        /// ticketaddbill       利用券請求書添付
        /// ticketcentercall    利用券センターより連絡
        /// ticketpercall       利用券本人より連絡
        /// ctrptdate           契約日付
        /// reptcsldiv   成績書本人家族区分出力
        /// billspecial  請求書特定健診レポート出力
        /// billage      請求書年齢出力
        /// highlight    団体名称ハイライト表示区分
        /// </returns>
        public dynamic SelectOrg_Lukes(string orgCd1, string orgCd2)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体テーブルのレコードを取得
            var sql = @"
                select
                    org.orgcd1
                    , org.orgcd2
                    , org.delflg
                    , org.orgkname
                    , org.orgname
                    , org.orgename
                    , org.orgsname
                    , org.orgdivcd
                    , org.orgbillname
                    , org.bank
                    , org.branch
                    , org.accountkind
                    , org.accountno
                    , org.numemp
                    , org.avgage
                    , org.directmail
                    , org.sendmethod
                    , org.postcard
                    , org.packagesend
                    , org.ticket
                    , org.inscheck
                    , org.insbring
                    , org.insreport
                    , org.billaddress
                    , org.billcsldiv
                    , org.billins
                    , org.billempno
                    , org.billreport
                    , org.billfd
                    , org.sendcomment
                    , org.sendecomment
                    , org.spare1
                    , org.spare2
                    , org.spare3
                    , org.notes
                    , org.dmdcomment
                    , to_char(org.upddate, 'YYYY/MM/DD HH24:MI:SS') upddate
                    , org.upduser
                    , hainsuser.username
                    , org.noprintletter
                    , org.visitdate
                    , org.presents
                    , org.ticketdiv
                    , org.ticketaddbill
                    , org.ticketcentercall
                    , org.ticketpercall
                    , to_char(org.ctrptdate, 'YYYY/MM/DD') ctrptdate
                    , org.reptcsldiv
                    , org.billspecial
                    , org.billage
                from
                    hainsuser
                    , org
                where
                    org.orgcd1 = :orgcd1
                    and org.orgcd2 = :orgcd2
                    and org.upduser = hainsuser.userid(+)
            ";

            var org = (IDictionary<string, object>)connection.Query(sql, param).FirstOrDefault();

            // 該当データがなければこれ以降の処理は行わない
            if (org == null)
            {
                return org;
            }

            int highLight = 0;
            dynamic free = SelectFree(CON_FREECD);
            if (free != null)
            {
                string spare3 = Convert.ToString(org["SPARE3"]).Trim();
                switch (free.FREEFIELD2)
                {
                    case "DATE":
                        // 日付形式
                        if (int.TryParse(Convert.ToString(free.FREEFIELD1).Trim(), out int wkFreeField1))
                        {
                            if ((spare3.Length == wkFreeField1) && DateTime.TryParse(spare3, out DateTime wkDate))
                            {
                                highLight = 1;
                            }
                        }
                        else
                        {
                            if (DateTime.TryParse(spare3, out DateTime wkDate))
                            {
                                highLight = 1;
                            }
                        }
                        break;

                    case "FIX":

                        string freeField3 = Convert.ToString(free.FREEFIELD3).Trim();
                        if (!string.IsNullOrEmpty(freeField3) && (spare3.Equals(freeField3)))
                        {
                            highLight = 1;
                        }
                        break;

                    default:
                        break;
                }
            }

            org.Add("highlight", highLight);

            return org;
        }

        /// <summary>
        /// 汎用コードで汎用テーブルを読み込む
        /// </summary>
        /// <param name="freeCd">汎用コード</param>
        /// <returns>
        /// freefield1 汎用フィールド１
        /// freefield2 汎用フィールド２
        /// freefield3 汎用フィールド３
        /// </returns>
        /// <remarks>団体名称ハイライト表示有無チェックの為</remarks>
        dynamic SelectFree(string freeCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("freecd", freeCd);

            // 指定オプション検査項目を取得
            var sql = @"
                select
                    freefield1
                    , freefield2
                    , freefield3
                from
                    free
                where
                    freecd = :freecd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 団体テーブルレコードを挿入する
        /// </summary>
        /// <param name="data">
        /// orgcd1       団体コード1
        /// orgcd2       団体コード2
        /// delflg       使用状態
        /// orgkname     カナ名称
        /// orgname      漢字名称
        /// orgename     漢字名称（英語）
        /// orgsname     略称
        /// orgdivcd     団体種別
        /// orgbillname  請求書用名称
        /// bank         銀行名
        /// branch       支店名
        /// accountkind  口座種別
        /// accountno    口座番号
        /// numemp       社員数
        /// avgage       平均年齢
        /// dm           DM
        /// sendmethod   送付方法
        /// postcard     確認はがき
        /// packagesend  一括送付案内
        /// ticket       利用券
        /// inscheck     保険証予約時確認
        /// insbring     保険証当日持参
        /// insreport    保険証成績所出力
        /// billaddress   請求書適用住所
        /// billcsldiv   請求書本人家族区分
        /// billins      請求書保険証情報出力
        /// billempno    請求書社員番号出力
        /// billreport   請求書成績書添付
        /// sendcomment  送付案内コメント
        /// sendecomment 英語送付案内コメント
        /// spare1       予備1
        /// spare2       予備2
        /// spare3       予備3
        /// notes        特記事項
        /// dmdcomment   請求関連コメント
        /// upduser      更新者
        /// noprintletter1年目はがき非出力フラグ
        /// visitdate    定期訪問予定日
        /// presents     年始・中元・歳暮
        /// ticketdiv           利用券区分
        /// ticketaddbill       利用券請求書添付
        /// ticketcentercall    利用券センターより連絡
        /// ticketpercall       利用券本人より連絡
        /// ctrptdate           契約日付
        /// reptcsldiv  成績書本人家族区分出力
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert InsertOrg(JToken data)
        {
            try
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("orgcd1", Convert.ToString(data["orgcd1"]).Trim());
                param.Add("orgcd2", Convert.ToString(data["orgcd2"]).Trim());
                param.Add("delflg", Convert.ToString(data["delflg"]).Trim());
                param.Add("orgkname", Convert.ToString(data["orgkname"]).Trim());
                param.Add("orgname", Convert.ToString(data["orgname"]).Trim());
                param.Add("orgename", Convert.ToString(data["orgename"]).Trim());
                param.Add("orgsname", Convert.ToString(data["orgsname"]).Trim());
                param.Add("orgdivcd", Convert.ToString(data["orgdivcd"]).Trim());
                param.Add("orgbillname", Convert.ToString(data["orgbillname"]).Trim());
                param.Add("bank", Strings.StrConv(Convert.ToString(data["bank"]).Trim(), VbStrConv.Wide));
                param.Add("branch", Strings.StrConv(Convert.ToString(data["branch"]).Trim(), VbStrConv.Wide));
                param.Add("accountkind", Convert.ToString(data["accountkind"]).Trim());
                param.Add("accountno", Convert.ToString(data["accountno"]).Trim());
                param.Add("numemp", Convert.ToString(data["numemp"]).Trim());
                param.Add("avgage", Convert.ToString(data["avgage"]).Trim());
                param.Add("directmail", Convert.ToString(data["directmail"]).Trim());
                param.Add("sendmethod", Convert.ToString(data["sendmethod"]).Trim());
                param.Add("postcard", Convert.ToString(data["postcard"]).Trim());
                param.Add("packagesend", Convert.ToString(data["packagesend"]).Trim());
                param.Add("ticket", Convert.ToString(data["ticket"]).Trim());
                param.Add("inscheck", Convert.ToString(data["inscheck"]).Trim());
                param.Add("insbring", Convert.ToString(data["insbring"]).Trim());
                param.Add("insreport", Convert.ToString(data["insreport"]).Trim());
                param.Add("billaddress", Convert.ToString(data["billaddress"]).Trim());
                param.Add("billcsldiv", Convert.ToString(data["billcsldiv"]).Trim());
                param.Add("billins", Convert.ToString(data["billins"]).Trim());
                param.Add("billempno", Convert.ToString(data["billempno"]).Trim());
                param.Add("billreport", Convert.ToString(data["billreport"]).Trim());
                param.Add("billfd", Convert.ToString(data["billfd"]).Trim());
                param.Add("sendcomment", Strings.StrConv(Convert.ToString(data["sendcomment"]).Trim(), VbStrConv.Wide));
                param.Add("sendecomment", Strings.StrConv(Convert.ToString(data["sendecomment"]).Trim(), VbStrConv.Wide));
                param.Add("spare1", Convert.ToString(data["spare1"]).Trim());
                param.Add("spare2", Convert.ToString(data["spare2"]).Trim());
                param.Add("spare3", Convert.ToString(data["spare3"]).Trim());
                param.Add("notes", Strings.StrConv(Convert.ToString(data["notes"]).Trim(), VbStrConv.Wide));
                param.Add("dmdcomment", Strings.StrConv(Convert.ToString(data["dmdcomment"]).Trim(), VbStrConv.Wide));
                param.Add("upduser", Convert.ToString(data["upduser"]).Trim());
                param.Add("noprintletter", Convert.ToString(data["noprintletter"]).Trim());
                param.Add("visitdate", Convert.ToString(data["visitdate"]).Trim());
                param.Add("presents", Convert.ToString(data["presents"]).Trim());
                param.Add("ticketdiv", Convert.ToString(data["ticketdiv"]).Trim());
                param.Add("ticketaddbill", Convert.ToString(data["ticketaddbill"]).Trim());
                param.Add("ticketcentercall", Convert.ToString(data["ticketcentercall"]).Trim());
                param.Add("ticketpercall", Convert.ToString(data["ticketpercall"]).Trim());

                if (Convert.ToString(data["ctrptdate"]) != "")
                {
                    param.Add("ctrptdate", Convert.ToString(data["ctrptdate"]).Trim());
                }
                else
                {
                    param.Add("ctrptdate", "");
                }

                param.Add("reptcsldiv", Convert.ToString(data["reptcsldiv"]).Trim());
                param.Add("billspecial", Convert.ToString(data["billspecial"]).Trim());
                param.Add("billage", Convert.ToString(data["billage"]).Trim());

                // 団体レコードの挿入
                var sql = @"
                    insert
                    into org(
                        orgcd1
                        , orgcd2
                        , delflg
                        , orgkname
                        , orgname
                        , orgename
                        , orgsname
                        , orgdivcd
                        , orgbillname
                        , bank
                        , branch
                        , accountkind
                        , accountno
                        , numemp
                        , avgage
                        , visitdate
                        , presents
                        , directmail
                        , sendmethod
                        , postcard
                        , packagesend
                        , ticket
                        , noprintletter
                        , inscheck
                        , insbring
                        , insreport
                        , billaddress
                        , billcsldiv
                        , billins
                        , billempno
                        , billreport
                        , billfd
                        , sendcomment
                        , sendecomment
                        , spare1
                        , spare2
                        , spare3
                        , notes
                        , dmdcomment
                        , upduser
                        , ticketdiv
                        , ticketaddbill
                        , ticketcentercall
                        , ticketpercall
                        , ctrptdate
                        , reptcsldiv
                        , billspecial
                        , billage
                    )
                    values (
                        :orgcd1
                        , :orgcd2
                        , :delflg
                        , :orgkname
                        , :orgname
                        , :orgename
                        , :orgsname
                        , :orgdivcd
                        , :orgbillname
                        , :bank
                        , :branch
                        , :accountkind
                        , :accountno
                        , :numemp
                        , :avgage
                        , :visitdate
                        , :presents
                        , :directmail
                        , :sendmethod
                        , :postcard
                        , :packagesend
                        , :ticket
                        , :noprintletter
                        , :inscheck
                        , :insbring
                        , :insreport
                        , :billaddress
                        , :billcsldiv
                        , :billins
                        , :billempno
                        , :billreport
                        , :billfd
                        , :sendcomment
                        , :sendecomment
                        , :spare1
                        , :spare2
                        , :spare3
                        , :notes
                        , :dmdcomment
                        , :upduser
                        , :ticketdiv
                        , :ticketaddbill
                        , :ticketcentercall
                        , :ticketpercall
                        , :ctrptdate
                        , :reptcsldiv
                        , :billspecial
                        , :billage
                    )
                    ";

                connection.Execute(sql, param);

                return Common.Constants.Insert.Normal;
            }
            catch (OracleException ex)
            {
                // キー重複時は戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    return Common.Constants.Insert.Duplicate;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 団体コードをキーに団体住所情報テーブルを挿入する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="data">
        /// zipcd        郵便番号
        /// prefcd       都道府県コード
        /// cityname     市区町村名
        /// address1     住所１
        /// address2     住所２
        /// directtel    電話番号１
        /// tel          電話番号２
        /// extension    内線１
        /// fax          FAX
        /// email        E-Mail
        /// url          URL
        /// chargename   担当者
        /// chargekname  担当者カナ名
        /// chargeemail  担当者E-Mail
        /// chargepost   担当部署
        /// orgname      漢字名称
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert InsertOrgAddr(string orgCd1, string orgCd2, JToken data)
        {
            // キー及び更新値の設定
            var param = new List<dynamic>();
            for (int i = 0; i <= 2; i++)
            {
                param.Add(new
                {
                    orgcd1 = orgCd1,
                    orgcd2 = orgCd2,
                    addrdiv = (i + 1).ToString(),
                    zipcd = Convert.ToString(data[i]["zipcd"]).Trim(),
                    prefcd = Convert.ToString(data[i]["prefcd"]).Trim(),
                    cityname = Convert.ToString(data[i]["cityname"]).Trim(),
                    address1 = Convert.ToString(data[i]["address1"]).Trim(),
                    address2 = Convert.ToString(data[i]["address2"]).Trim(),
                    directtel = Convert.ToString(data[i]["directtel"]).Trim(),
                    extension = Convert.ToString(data[i]["extension"]).Trim(),
                    tel = Convert.ToString(data[i]["tel"]).Trim(),
                    fax = Convert.ToString(data[i]["fax"]).Trim(),
                    email = Convert.ToString(data[i]["email"]).Trim(),
                    url = Convert.ToString(data[i]["url"]).Trim(),
                    chargename = Convert.ToString(data[i]["chargename"]).Trim(),
                    chargekname = Convert.ToString(data[i]["chargekname"]).Trim(),
                    chargeemail = Convert.ToString(data[i]["chargeemail"]).Trim(),
                    chargepost = Convert.ToString(data[i]["chargepost"]).Trim(),
                    orgname = Convert.ToString(data[i]["orgname"]).Trim()
                });
            }

            try
            {
                var sql = @"
                insert
                into orgaddr(
                    orgcd1
                    , orgcd2
                    , addrdiv
                    , zipcd
                    , prefcd
                    , cityname
                    , address1
                    , address2
                    , directtel
                    , tel
                    , extension
                    , fax
                    , email
                    , url
                    , chargename
                    , chargekname
                    , chargeemail
                    , chargepost
                    , orgname
                )
                values (
                    :orgcd1
                    , :orgcd2
                    , :addrdiv
                    , :zipcd
                    , :prefcd
                    , :cityname
                    , :address1
                    , :address2
                    , :directtel
                    , :tel
                    , :extension
                    , :fax
                    , :email
                    , :url
                    , :chargename
                    , :chargekname
                    , :chargeemail
                    , :chargepost
                    , :orgname
                )
                ";

                connection.Execute(sql, param);

                return Common.Constants.Insert.Normal;
            }
            catch (OracleException ex)
            {
                // キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    return Common.Constants.Insert.Duplicate;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 団体コードをキーに団体テーブルを更新する ### 聖路加用 ###
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="data">
        /// orgcd1       団体コード1
        /// orgcd2       団体コード2
        /// delflg       使用状態
        /// orgkname     カナ名称
        /// orgname      漢字名称
        /// orgename     漢字名称（英語）
        /// orgsname     略称
        /// orgdivcd     団体種別
        /// orgbillname  請求書用名称
        /// bank         銀行名
        /// branch       支店名
        /// accountkind  口座種別
        /// accountno    口座番号
        /// numemp       社員数
        /// avgage       平均年齢
        /// dm           DM
        /// sendmethod   送付方法
        /// postcard     確認はがき
        /// packagesend  一括送付案内
        /// ticket       利用券
        /// inscheck     保険証予約時確認
        /// insbring     保険証当日持参
        /// insreport    保険証成績所出力
        /// billaddress   請求書適用住所
        /// billcsldiv   請求書本人家族区分
        /// billins      請求書保険証情報出力
        /// billempno    請求書社員番号出力
        /// billreport   請求書成績書添付
        /// sendcomment  送付案内コメント
        /// sendecomment 英語送付案内コメント
        /// spare1       予備1
        /// spare2       予備2
        /// spare3       予備3
        /// notes        特記事項
        /// dmdcomment   請求関連コメント
        /// upduser      更新者
        /// noprintletter1年目はがき非出力フラグ
        /// visitdate    定期訪問予定日
        /// presents     年始・中元・歳暮
        /// ticketdiv           利用券区分
        /// ticketaddbill       利用券請求書添付
        /// ticketcentercall    利用券センターより連絡
        /// ticketpercall       利用券本人より連絡
        /// ctrptdate           契約日付
        /// reptcsldiv  成績書本人家族区分出力
        /// </param>
        public void UpdateOrg(string orgCd1, string orgCd2, JToken data)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", Convert.ToString(data["orgcd1"]).Trim());
            param.Add("orgcd2", Convert.ToString(data["orgcd2"]).Trim());
            param.Add("delflg", Convert.ToString(data["delflg"]).Trim());
            param.Add("orgkname", Strings.StrConv(Convert.ToString(data["orgkname"]).Trim(), VbStrConv.Wide));
            param.Add("orgname", Convert.ToString(data["orgname"]).Trim());
            param.Add("orgename", Convert.ToString(data["orgename"]).Trim());
            param.Add("orgsname", Convert.ToString(data["orgsname"]).Trim());
            param.Add("orgdivcd", Convert.ToString(data["orgdivcd"]).Trim());
            param.Add("orgbillname", Convert.ToString(data["orgbillname"]).Trim());
            param.Add("bank", Strings.StrConv(Convert.ToString(data["bank"]).Trim(), VbStrConv.Wide));
            param.Add("branch", Strings.StrConv(Convert.ToString(data["branch"]).Trim(), VbStrConv.Wide));
            param.Add("accountkind", Convert.ToString(data["accountkind"]).Trim());
            param.Add("accountno", Convert.ToString(data["accountno"]).Trim());
            param.Add("numemp", Convert.ToString(data["numemp"]).Trim());
            param.Add("avgage", Convert.ToString(data["avgage"]).Trim());
            param.Add("directmail", Convert.ToString(data["directmail"]).Trim());
            param.Add("sendmethod", Convert.ToString(data["sendmethod"]).Trim());
            param.Add("postcard", Convert.ToString(data["postcard"]).Trim());
            param.Add("packagesend", Convert.ToString(data["packagesend"]).Trim());
            param.Add("ticket", Convert.ToString(data["ticket"]).Trim());
            param.Add("inscheck", Convert.ToString(data["inscheck"]).Trim());
            param.Add("insbring", Convert.ToString(data["insbring"]).Trim());
            param.Add("insreport", Convert.ToString(data["insreport"]).Trim());
            param.Add("billaddress", Convert.ToString(data["billaddress"]).Trim());
            param.Add("billcsldiv", Convert.ToString(data["billcsldiv"]).Trim());
            param.Add("billins", Convert.ToString(data["billins"]).Trim());
            param.Add("billempno", Convert.ToString(data["billempno"]).Trim());
            param.Add("billreport", Convert.ToString(data["billreport"]).Trim());
            param.Add("billfd", Convert.ToString(data["billfd"]).Trim());
            param.Add("sendcomment", Strings.StrConv(Convert.ToString(data["sendcomment"]).Trim(), VbStrConv.Wide));
            param.Add("sendecomment", Convert.ToString(data["sendecomment"]).Trim());
            param.Add("spare1", Convert.ToString(data["spare1"]).Trim());
            param.Add("spare2", Convert.ToString(data["spare2"]).Trim());
            param.Add("spare3", Convert.ToString(data["spare3"]).Trim());
            param.Add("notes", Strings.StrConv(Convert.ToString(data["notes"]).Trim(), VbStrConv.Wide));
            param.Add("dmdcomment", Strings.StrConv(Convert.ToString(data["dmdcomment"]).Trim(), VbStrConv.Wide));
            param.Add("upduser", Convert.ToString(data["upduser"]).Trim());
            param.Add("noprintletter", Convert.ToString(data["noprintletter"]).Trim());
            param.Add("visitdate", Convert.ToString(data["visitdate"]).Trim());
            param.Add("presents", Convert.ToString(data["presents"]).Trim());
            param.Add("ticketdiv", Convert.ToString(data["ticketdiv"]).Trim());
            param.Add("ticketaddbill", Convert.ToString(data["ticketaddbill"]).Trim());
            param.Add("ticketcentercall", Convert.ToString(data["ticketcentercall"]).Trim());
            param.Add("ticketpercall", Convert.ToString(data["ticketpercall"]).Trim());

            if (Convert.ToString(data["ctrptdate"]) != "")
            {
                param.Add("ctrptdate", Convert.ToString(data["ctrptdate"]).Trim());
            }
            else
            {
                param.Add("ctrptdate", "");
            }

            param.Add("reptcsldiv", Convert.ToString(data["reptcsldiv"]).Trim());
            param.Add("billspecial", Convert.ToString(data["billspecial"]).Trim());
            param.Add("billage", Convert.ToString(data["billage"]).Trim());

            // 団体テーブルレコードの更新
            var sql = @"
                update org
                set
                    delflg = :delflg
                    , orgkname = :orgkname
                    , orgname = :orgname
                    , orgename = :orgename
                    , orgsname = :orgsname
                    , orgdivcd = :orgdivcd
                    , orgbillname = :orgbillname
                    , bank = :bank
                    , branch = :branch
                    , accountkind = :accountkind
                    , accountno = :accountno
                    , numemp = :numemp
                    , avgage = :avgage
                    , visitdate = :visitdate
                    , presents = :presents
                    , directmail = :directmail
                    , sendmethod = :sendmethod
                    , postcard = :postcard
                    , packagesend = :packagesend
                    , ticket = :ticket
                    , noprintletter = :noprintletter
                    , inscheck = :inscheck
                    , insbring = :insbring
                    , insreport = :insreport
                    , billaddress = :billaddress
                    , billcsldiv = :billcsldiv
                    , billins = :billins
                    , billempno = :billempno
                    , billreport = :billreport
                    , billfd = :billfd
                    , sendcomment = :sendcomment
                    , sendecomment = :sendecomment
                    , spare1 = :spare1
                    , spare2 = :spare2
                    , spare3 = :spare3
                    , notes = :notes
                    , dmdcomment = :dmdcomment
                    , upddate = sysdate
                    , upduser = :upduser
                    , ticketdiv = :ticketdiv
                    , ticketaddbill = :ticketaddbill
                    , ticketcentercall = :ticketcentercall
                    , ticketpercall = :ticketpercall
                    , ctrptdate = :ctrptdate
                    , reptcsldiv = :reptcsldiv
                    , billspecial = :billspecial
                    , billage = :billage
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 団体コードをキーに団体住所情報テーブルを更新する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="data">
        /// zipcd        郵便番号
        /// prefcd       都道府県コード
        /// cityname     市区町村名
        /// address1     住所１
        /// address2     住所２
        /// directtel    電話番号１
        /// tel          電話番号２
        /// extension    内線１
        /// fax          FAX
        /// email        E-Mail
        /// url          URL
        /// chargename   担当者
        /// chargekname  担当者カナ名
        /// chargeemail  担当者E-Mail
        /// chargepost   担当部署
        /// orgname      漢字名称
        /// </param>
        public void UpdateOrgAddr(string orgCd1, string orgCd2, JToken data)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 検索条件を満たす団体住所情報テーブルのレコードを先に削除
            var sql = @"
                delete
                from
                    orgaddr
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
            ";

            connection.Execute(sql, param);

            // キー及び更新値の設定
            var sqlParamList = new List<dynamic>();

            for (int i = 0; i <= 2; i++)
            {
                sqlParamList.Add(
                    new
                    {
                        orgcd1 = orgCd1,
                        orgcd2 = orgCd2,
                        addrdiv = (i + 1).ToString(),
                        zipcd = Convert.ToString(data[i]["zipcd"]).Trim(),
                        prefcd = Convert.ToString(data[i]["prefcd"]).Trim(),
                        cityname = Convert.ToString(data[i]["cityname"]).Trim(),
                        address1 = Convert.ToString(data[i]["address1"]).Trim(),
                        address2 = Convert.ToString(data[i]["address2"]).Trim(),
                        directtel = Convert.ToString(data[i]["directtel"]).Trim(),
                        extension = Convert.ToString(data[i]["extension"]).Trim(),
                        tel = Convert.ToString(data[i]["tel"]).Trim(),
                        fax = Convert.ToString(data[i]["fax"]).Trim(),
                        email = Convert.ToString(data[i]["email"]).Trim(),
                        url = Convert.ToString(data[i]["url"]).Trim(),
                        chargename = Convert.ToString(data[i]["chargename"]).Trim(),
                        chargekname = Convert.ToString(data[i]["chargekname"]).Trim(),
                        chargeemail = Convert.ToString(data[i]["chargeemail"]).Trim(),
                        chargepost = Convert.ToString(data[i]["chargepost"]).Trim(),
                        orgname = Convert.ToString(data[i]["orgname"]).Trim()
                    });
            }

            // 団体住所情報テーブルレコードの更新
            // 各配列値の挿入処理
            sql = @"
                    insert
                    into orgaddr(
                        orgcd1
                        , orgcd2
                        , addrdiv
                        , zipcd
                        , prefcd
                        , cityname
                        , address1
                        , address2
                        , directtel
                        , tel
                        , extension
                        , fax
                        , email
                        , url
                        , chargename
                        , chargekname
                        , chargeemail
                        , chargepost
                        , orgname
                    )
                    values (
                        :orgcd1
                        , :orgcd2
                        , :addrdiv
                        , :zipcd
                        , :prefcd
                        , :cityname
                        , :address1
                        , :address2
                        , :directtel
                        , :tel
                        , :extension
                        , :fax
                        , :email
                        , :url
                        , :chargename
                        , :chargekname
                        , :chargeemail
                        , :chargepost
                        , :orgname
                    )
                    ";

            connection.Execute(sql, sqlParamList);
        }

        /// <summary>
        /// 指定団体に対し、成績書オプション管理状況を取得
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="freeCd"></param>
        /// <returns>
        /// rptoptcd オプション管理コード
        /// rptoptname オプション管理名称
        /// value_s 選択状態("1":選択、"0":未選択)
        /// </returns>
        public IList<dynamic> SelectRptOpt(string orgCd1, string orgCd2, string freeCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("freecd", freeCd);
            param.Add("freeclasscd", FREECLASSCD_REP);

            // 検索条件を満たすレコードを取得
            var sql = @"
                select
                    freeopt.rptoptcd as rptoptcd
                    , freeopt.rptoptname as rptoptname
                    , nvl2(rptopt.rptoptcd, '1', '0') as value_s
                from
                    (
                        select
                            rptoptcd
                        from
                            orgrptopt
                        where
                            orgcd1 = :orgcd1
                            and orgcd2 = :orgcd2
                    ) rptopt
                    , (
                        select
                            freecd as rptoptcd
                            , freefield1 as rptoptname
                        from
                            free
                        where
                            freecd like :freecd
                            and freeclasscd = :freeclasscd
                    ) freeopt
                where
                    freeopt.rptoptcd = rptopt.rptoptcd(+)
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定団体に対し、成績書オプション管理状況更新
        /// </summary>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="updUser"></param>
        /// <param name="data">
        /// rptoptcd オプション管理コード
        /// values 選択状態("1":選択、"0":未選択)
        /// </param>
        public void UpdateRptOpt(string orgCd1, string orgCd2, string updUser, JToken data)
        {
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();
            updUser = updUser.Trim();

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);

            // 指定期間、時間枠の予約枠レコードを削除
            var sql = @"
                delete orgrptopt
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
            ";

            connection.Execute(sql, param);

            // 該当日・該当時間枠・該当予約枠の予約スケジューリングを挿入するSQLステートメント編集
            sql = @"
                insert
                into orgrptopt(
                    orgcd1
                    , orgcd2
                    , rptoptcd
                    , delflg
                    , judclasscd
                    , upduser
                )
                values (
                    :orgcd1
                    , :orgcd2
                    , :rptoptcd
                    , (
                        select
                            freefield2
                        from
                            free
                        where
                            freecd = :rptoptcd
                            and freeclasscd = :freeclasscd
                    )
                    , (
                        select
                            freefield3
                        from
                            free
                        where
                            freecd = :rptoptcd
                            and freeclasscd = :freeclasscd
                    )
                    , :upduser
                )
                ";

            var sqlParamList = new List<dynamic>();

            for (int i = 0; i < data.Count(); i++)
            {
                if (Convert.ToString(data[i]["value_s"]).Equals("1"))
                {
                    sqlParamList.Add(new
                    {
                        orgcd1 = orgCd1,
                        orgcd2 = orgCd2,
                        upduser = updUser,
                        freeclasscd = FREECLASSCD_REP,
                        rptoptcd = Convert.ToString(data[i]["rptoptcd"])
                    });
                }
            }

            if (sqlParamList.Count() > 0)
            {
                connection.Execute(sql, sqlParamList);
            }
        }

        /// <summary>
        /// 編集したレコード件数
        /// </summary>
        /// <param name="fileName">CSVファイル名(物理パス)</param>
        /// <returns>編集したレコード件数</returns>
        /// <remarks>都道府県名、保険区分、口座種別は漢字名称に変換する</remarks>
        public int EditCSVDatOrg(string fileName)
        {
            string ret = "";

            // SQL定義
            var sql = @"
                    select
                        orgcd1 団体コード１
                        , orgcd2 団体コード２
                        , delflg 削除フラグ
                        , upddate 更新日
                        , upduser 更新者
                        , orgkname カナ名称
                        , orgname 漢字名称
                        , orgbillname 請求書用名称
                        , orgsname 略称
                        , orgdiv 団体種別
                        , zipcd1 郵便番号１
                        , zipcd2 郵便番号２
                        , prefcd 都道府県コード
                        , cityname 市区町村名
                        , address1 住所１
                        , address2 住所２
                        , tel1 電話番号市外局番
                        , tel2 電話番号局番
                        , tel3 電話番号番号
                        , directtel1 直通電話市外局番
                        , directtel2 直通電話局番
                        , directtel3 直通電話番号
                        , extension 内線
                        , fax1 ＦＡＸ市外局番
                        , fax2 ＦＡＸ局番
                        , fax3 ＦＡＸ番号
                        , govmngcd 政府管掌コード
                        , isrsign 健保記号
                        , isrgetname 健保名称索引対象
                        , isrdiv 保険区分
                        , bank 銀行名
                        , branch 支店名
                        , accountkind 口座種別
                        , accountno 口座番号
                        , replace (
                            replace (
                                replace (notes, ',', '，')
                                , chr(13) || chr(10)
                                , ''
                            )
                            , chr(13)
                            , ''
                        ) 特記事項
                        , spare1 予備１
                        , spare2 予備２
                        , spare3 予備３
                        , roundnotaxflg まるめ金消費税非計算フラグ
                    from
                        org
                    order by
                        orgcd1
                        , orgcd2
                    ";

            var data = connection.Query(sql).ToList();

            // #ToDo CSVを作成する方法をどうするか
            //'ダイナセットからCSVファイルを作成
            //Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
            //Ret = objCreateCsv.CreateCsvFileFromDynaset(objOraDyna, strFileName)

            if (ret != "")
            {
                return 1;
            }

            return 0;
        }

        #region 新設メソッド

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <param name="data">登録値</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public IList<string> Validate(JToken data)
        {
            var messages = new List<string>();

            var datalist = data.ToObject<Dictionary<string, JToken>>();

            if (!datalist.ContainsKey("org"))
            {
                messages.Add("団体情報がありません。");
            }

            if (!datalist.ContainsKey("orgaddr"))
            {
                messages.Add("団体住所情報がありません。");
            }

            if (messages.Count > 0)
            {
                return messages;
            }

            var org = datalist["org"];
            var orgAddrList = datalist["orgaddr"].ToObject<List<JToken>>();

            Org.Orgcd1.Valid(Convert.ToString(org["orgcd1"]).Trim(), messages);
            Org.Orgcd2.Valid(Convert.ToString(org["orgcd2"]).Trim(), messages);
            Org.Delflg.Valid(Convert.ToString(org["delflg"]).Trim(), messages, "使用状態");
            Org.Orgkname.Valid(Convert.ToString(org["orgkname"]).Trim(), messages);
            Org.Orgname.Valid(Convert.ToString(org["orgname"]).Trim(), messages);
            Org.Orgename.Valid(Convert.ToString(org["orgename"]).Trim(), messages);
            Org.Orgsname.Valid(Convert.ToString(org["orgsname"]).Trim(), messages);
            if (Org.Orgdivcd.Valid(Convert.ToString(org["orgdivcd"]).Trim(), messages))
            {
                var orgdivcd = Convert.ToString(Convert.ToString(org["orgdivcd"]).Trim());
                if (!string.IsNullOrEmpty(orgdivcd) && freeDao.SelectFree(0, orgdivcd) == null)
                {
                    messages.Add(string.Format("指定した{0}は存在しません。", Org.Orgdivcd.ColumnName));
                }
            }
            Org.Orgbillname.Valid(Convert.ToString(org["orgbillname"]).Trim(), messages);
            Org.Bank.Valid(Convert.ToString(org["bank"]).Trim(), messages);
            Org.Branch.Valid(Convert.ToString(org["branch"]).Trim(), messages);
            Org.Accountkind.Valid(Convert.ToString(org["accountkind"]).Trim(), messages);
            Org.Accountno.Valid(Convert.ToString(org["accountno"]).Trim(), messages);
            Org.Numemp.Valid(Convert.ToString(org["numemp"]).Trim(), messages);
            Org.Avgage.Valid(Convert.ToString(org["avgage"]).Trim(), messages);
            Org.Visitdate.Valid(Convert.ToString(org["visitdate"]).Trim(), messages);
            Org.Presents.Valid(Convert.ToString(org["presents"]).Trim(), messages);
            Org.Presents.Valid(Convert.ToString(org["presents"]).Trim(), messages);
            Org.Directmail.Valid(Convert.ToString(org["directmail"]).Trim(), messages);
            Org.Sendmethod.Valid(Convert.ToString(org["sendmethod"]).Trim(), messages);
            Org.Packagesend.Valid(Convert.ToString(org["packagesend"]).Trim(), messages);
            Org.Ticket.Valid(Convert.ToString(org["ticket"]).Trim(), messages);
            Org.Ticketdiv.Valid(Convert.ToString(org["ticketdiv"]).Trim(), messages);
            Org.Ticketaddbill.Valid(Convert.ToString(org["ticketaddbill"]).Trim(), messages);
            Org.Ticketcentercall.Valid(Convert.ToString(org["ticketcentercall"]).Trim(), messages);
            Org.Ticketpercall.Valid(Convert.ToString(org["ticketpercall"]).Trim(), messages);
            Org.Ctrptdate.Valid(Convert.ToString(org["ctrptdate"]).Trim(), messages);
            Org.Noprintletter.Valid(Convert.ToString(org["noprintletter"]).Trim(), messages);
            Org.Inscheck.Valid(Convert.ToString(org["inscheck"]).Trim(), messages);
            Org.Insbring.Valid(Convert.ToString(org["insbring"]).Trim(), messages);
            Org.Insreport.Valid(Convert.ToString(org["insreport"]).Trim(), messages);
            Org.Billaddress.Valid(Convert.ToString(org["billaddress"]).Trim(), messages);
            Org.Billcsldiv.Valid(Convert.ToString(org["billcsldiv"]).Trim(), messages);
            Org.Billins.Valid(Convert.ToString(org["billins"]).Trim(), messages);
            Org.Billempno.Valid(Convert.ToString(org["billempno"]).Trim(), messages);
            Org.Billage.Valid(Convert.ToString(org["billage"]).Trim(), messages);
            Org.Billreport.Valid(Convert.ToString(org["billreport"]).Trim(), messages);
            Org.Billspecial.Valid(Convert.ToString(org["billspecial"]).Trim(), messages);
            Org.Billfd.Valid(Convert.ToString(org["billfd"]).Trim(), messages);
            Org.Reptcsldiv.Valid(Convert.ToString(org["reptcsldiv"]).Trim(), messages);
            Org.Sendcomment.Valid(Convert.ToString(org["sendcomment"]).Trim(), messages);
            Org.Sendecomment.Valid(Convert.ToString(org["sendecomment"]).Trim(), messages);
            Org.Spare1.Valid(Convert.ToString(org["spare1"]).Trim(), messages);
            Org.Spare2.Valid(Convert.ToString(org["spare2"]).Trim(), messages);
            Org.Spare3.Valid(Convert.ToString(org["spare3"]).Trim(), messages);
            Org.Dmdcomment.Valid(Convert.ToString(org["dmdcomment"]).Trim(), messages);

            foreach (JToken orgAddr in orgAddrList)
            {
                // エラーチェックする匿名メソッド
                Func<ColumnDefinition, string, string, bool> valid = (ColumnDefinition definition, string elm, string name) =>
                {
                    // 表示名が指定されていない場合はカラム名を表示する
                    name = name ?? definition.ColumnName;

                    return definition.Valid(
                        Convert.ToString(orgAddr[elm]).Trim(),
                        messages,
                        string.Format("（住所{0}）{1}", Convert.ToString(orgAddr["addrdiv"]).Trim(),
                        name));
                };

                valid(Orgaddr.Addrdiv, "addrdiv", null);
                valid(Orgaddr.Orgname, "orgname", "宛先会社名");
                valid(Orgaddr.Zipcd, "zipcd", null);
                if (valid(Orgaddr.Prefcd, "prefcd", "都道府県"))
                {
                    var prefcd = Convert.ToString(orgAddr["prefcd"]).Trim();
                    if (!string.IsNullOrEmpty(prefcd) && prefDao.SelectPref(prefcd) == null)
                    {
                        messages.Add(string.Format("（住所{0}）指定した{1}は存在しません。", Convert.ToString(orgAddr["addrdiv"]).Trim(), "都道府県"));
                    }
                }
                valid(Orgaddr.Cityname, "cityname", null);
                valid(Orgaddr.Address1, "address1", null);
                valid(Orgaddr.Address2, "address2", null);
                valid(Orgaddr.Directtel, "directtel", null);
                valid(Orgaddr.Tel, "tel", null);
                valid(Orgaddr.Extension, "extension", null);
                valid(Orgaddr.Fax, "fax", null);
                valid(Orgaddr.Email, "email", null);
                valid(Orgaddr.Url, "url", null);
                valid(Orgaddr.Chargepost, "chargepost", null);
                valid(Orgaddr.Chargename, "chargename", null);
                valid(Orgaddr.Chargekname, "chargekname", null);
                valid(Orgaddr.Chargeemail, "chargeemail", null);
            }


            return messages;
        }

        /// <summary>
        /// 団体情報を新規追加する
        /// </summary>
        /// <param name="data">登録データ</param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        /// </returns>
        public Insert Create(JToken data)
        {
            var datalist = data.ToObject<Dictionary<string, JToken>>();
            // 団体情報
            JToken org = datalist["org"];
            // 団体住所情報
            JToken orgAddr = datalist["orgaddr"];

            // トランザクション開始
            using (var transaction = BeginTransaction())
            {
                string orgCd1 = Convert.ToString(org["orgcd1"]).Trim();
                string orgCd2 = Convert.ToString(org["orgcd2"]).Trim();

                // 既に登録されている場合
                if (SelectOrgName(orgCd1, orgCd2) != null)
                {
                    return Insert.Duplicate;
                }

                // 団体情報登録
                InsertOrg(org);

                // 団体住所情報登録
                InsertOrgAddr(orgCd1, orgCd2, orgAddr);

                // コミット
                transaction.Commit();

                return Insert.Normal;
            }
        }

        /// <summary>
        /// 団体情報を更新する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="data">登録データ</param>
        /// <returns>
        ///	Update.Normal 正常終了
        ///	Update.NotFound 同一キーのレコード不在
        /// </returns>
        public Update Update(string orgCd1, string orgCd2, JToken data)
        {
            var datalist = data.ToObject<Dictionary<string, JToken>>();
            // 団体情報
            JToken org = datalist["org"];
            // 団体住所情報
            JToken orgAddr = datalist["orgaddr"];

            // トランザクション開始
            using (var transaction = BeginTransaction())
            {
                // 同一キーのデータが存在しない場合
                if (SelectOrgName(orgCd1, orgCd2) == null)
                {
                    return Common.Constants.Update.NotFound;
                }

                // 団体情報更新
                UpdateOrg(orgCd1, orgCd2, org);

                // 団体住所情報更新
                UpdateOrgAddr(orgCd1, orgCd2, orgAddr);

                // コミット
                transaction.Commit();

                return Common.Constants.Update.Normal;
            }
        }
        #endregion
    }
}
