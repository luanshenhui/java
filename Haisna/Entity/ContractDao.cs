using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Contract;
using Microsoft.VisualBasic;
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
    /// 契約情報データアクセスオブジェクト
    /// </summary>
    public class ContractDao : AbstractDao
    {
        // 負担元団体名のデフォルト値
        const string ORGNAME_PERSON = "個人";
        const string ORGNAME_MYORG = "契約団体";

        // オプション名のデフォルト値
        const string OPTNAME_COURSE = "基本コース";
        const string OPTNAME_DELETE = "（削除）";

        // 受診区分コード（指定なし）
        const string CSLDIVCD_NOTHING = "CSLDIV000";

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ContractDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定契約パターンの契約期間に指定団体の受診情報が存在するかをチェックする
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// 契約期間
        /// mincsldate 受診日の最小値
        /// maxcsldate 受診日の最大値
        /// </returns>
        public dynamic CheckConsultIntoContract(int ctrPtCd, string orgCd1 = null, string orgCd2 = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            if (!string.IsNullOrEmpty(orgCd1) && !string.IsNullOrEmpty(orgCd2))
            {
                param.Add("orgcd1", orgCd1.Trim());
                param.Add("orgcd2", orgCd2.Trim());
            }

            // 指定契約パターンの契約期間に受診情報が存在するかをチェックし、存在時は受診日の最小・最大値を取得
            var sql = @"
                select
                    min(consult.csldate) mincsldate
                    , max(consult.csldate) maxcsldate
                from
                    consult
                    , ctrpt
                where
                    ctrpt.ctrptcd = :ctrptcd
            ";

            // 団体指定時は条件節に追加
            if (!string.IsNullOrEmpty(orgCd1) && !string.IsNullOrEmpty(orgCd2))
            {
                sql += @"
                    and consult.orgcd1 = :orgcd1
                    and consult.orgcd2 = :orgcd2
                ";
            }

            sql += @"
                    and ctrpt.strdate <= consult.csldate
                    and ctrpt.enddate >= consult.csldate
                    and ctrpt.ctrptcd = consult.ctrptcd
            ";

            var data = connection.Query(sql, param).FirstOrDefault();

            // 値の有無で戻り値を決定
            return (data.MINCSLDATE != null) ? data : null;
        }

        /// <summary>
        /// 指定期間における、指定契約パターンの受付済み受診情報が存在するかをチェックする
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <returns>
        /// true レコードあり
        /// false レコードなし
        /// </returns>
        public bool CheckConsultIntoContract_Rpt(int ctrPtCd, DateTime strCslDate, DateTime endCslDate)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate);

            // 指定期間における、指定契約パターンの受付済み受診情報が存在するかをチェックする
            var sql = @"
                select
                    consult.rsvno
                from
                    receipt
                    , consult
                where
                    consult.csldate between :strcsldate and :endcsldate
                    and consult.ctrptcd = :ctrptcd
                    and consult.rsvno = receipt.rsvno
                    and consult.csldate = receipt.csldate
                    and rownum = 1
            ";

            var data = connection.Query(sql, param).FirstOrDefault();

            // 値の有無で戻り値を決定
            return (data != null);
        }

        /// <summary>
        /// 指定期間において、指定団体・コースの契約情報が存在するかをチェックする
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <returns>
        /// true レコードあり
        /// false レコードなし
        /// </returns>
        public bool CheckContractPeriod(string orgCd1, string orgCd2, string csCd, int ctrPtCd, DateTime? strDate, DateTime? endDate = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("cscd", csCd.Trim());
            param.Add("ctrptcd", ctrPtCd);
            param.Add("strdate", strDate);
            param.Add("enddate", endDate);

            // 指定期間において、指定団体・コースの契約情報が存在するかをチェックする
            var sql = @"
                select
                    orgcd1
                from
                    ctrmngwithperiod
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                    and cscd = :cscd
                    and enddate >= :strdate
            ";

            // 契約終了日指定時は条件節に含める
            if (endDate != null)
            {
                sql += @"
                    and strdate <= :enddate
                ";
            }

            // 契約パターンコード指定時はチェック条件から除くよう、条件節に含める
            if (ctrPtCd > 0)
            {
                sql += @"
                    and ctrptcd != :ctrptcd
                ";
            }

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // レコードの有無で戻り値を決定
            return (data != null);
        }

        /// <summary>
        /// 指定団体・契約パターンの契約情報が他団体から参照されているかをチェックする
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// true レコードあり
        /// false レコードなし
        /// </returns>
        public bool CheckContractReferred(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);

            // 指定団体・契約パターンの契約情報を参照している他の契約情報が存在するかをチェックする(自団体の契約情報は除く)
            var sql = @"
                select
                    orgcd1
                from
                    ctrmng
                where
                    reforgcd1 = :orgcd1
                    and reforgcd2 = :orgcd2
                    and ctrptcd = :ctrptcd
                    and (orgcd1 != reforgcd1 or orgcd2 != reforgcd2)
            ";

            var data = connection.Query(sql, param).FirstOrDefault();

            // レコードの有無で戻り値を決定
            return (data != null);
        }

        /// <summary>
        /// 負担元情報のチェック
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burdens">負担元情報</param>
        /// <returns>
        /// true 正常終了
        /// false データベース上の負担元情報が引数値と一致しない
        /// </returns>
        public bool CheckCtrPtOrg(int ctrPtCd, IList<ContractBurdens> burdens)
        {
            bool ret = false;

            // 現在の契約パターン負担元管理情報を読む
            IList<dynamic> current = SelectCtrPtOrgPrice(ctrPtCd);

            // 負担元情報が存在しない場合は処理を終了する
            if (current.Count <= 0)
            {
                throw new Exception("契約情報が存在しません。");
            }

            while (true)
            {
                // 双方の負担元数が一致しない場合はエラー
                if (current.Count != burdens.Count)
                {
                    break;
                }

                // 双方の同一インデックスの負担元情報を対比してチェックを行う
                for (var i = 0; i < burdens.Count; i++)
                {
                    // SEQが一致しない場合はエラー
                    if (Convert.ToInt32(current[i].SEQ) != burdens[i].Seq)
                    {
                        break;
                    }

                    // 団体コードが一致しない場合はエラー
                    if ((Convert.ToString(current[i].ORGCD1) != burdens[i].OrgCd1) || (Convert.ToString(current[i].ORGCD2) != burdens[i].OrgCd2))
                    {
                        break;
                    }
                }

                ret = true;
                break;
            }

            return ret;
        }

        //
        //  機能　　 : 指定契約パターンの負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
        //
        //  引数　　 : (In)     orgCd1   団体コード1
        //  　　　　   (In)     orgCd2   団体コード2
        //  　　　　   (In)     ctrPtCd  契約パターンコード
        //  　　　　   (Out)    vntOrgName  団体名称
        //
        //  戻り値　 : True   レコードあり
        //  　　　　   False  レコードなし、または異常終了
        //
        //  備考　　 :
        //

        /// <summary>
        /// 指定契約パターンの負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// 団体名の集合
        /// </returns>
        public List<dynamic> CheckDemandOrgReferred(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);

            // 指定契約パターンの負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
            string sql = @"
                select
                    org.orgname
                from
                    org
                    , ctrpt_org
                where
                    ctrpt_org.ctrptcd = :ctrptcd
                    and (ctrpt_org.orgcd1, ctrpt_org.orgcd2) in (
                        select
                            orgcd1
                            , orgcd2
                        from
                            ctrmng
                        where
                            ctrmng.reforgcd1 = :orgcd1
                            and ctrmng.reforgcd2 = :orgcd2
                            and ctrmng.ctrptcd = ctrpt_org.ctrptcd
                    )
                    and ctrpt_org.orgcd1 = org.orgcd1
                    and ctrpt_org.orgcd2 = org.orgcd2
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターンの契約情報を新契約パターンの契約情報として複写する
        /// </summary>
        /// <param name="curCtrPtCd">契約パターンコード</param>
        /// <param name="newCtrPtCd">新契約パターンコード</param>
        public void Copy(int curCtrPtCd, int newCtrPtCd)
        {
            using (var ts = new TransactionScope())
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("curctrptcd", curCtrPtCd);
                param.Add("newctrptcd", newCtrPtCd);

                // 契約パターン負担元管理テーブルレコードの挿入
                string sql = @"
                    insert
                    into ctrpt_org(
                        ctrptcd
                        , seq
                        , apdiv
                        , orgcd1
                        , orgcd2
                        , noctr
                        , fraction
                        , taxflg
                        , addupflg
                        , limitpriceflg
                    )
                    select
                        :newctrptcd
                        , seq
                        , apdiv
                        , orgcd1
                        , orgcd2
                        , noctr
                        , fraction
                        , taxflg
                        , addupflg
                        , limitpriceflg
                    from
                        ctrpt_org
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約パターンオプショングループテーブルレコードの挿入
                sql = @"
                    insert
                    into ctrpt_optgrp(
                        ctrptcd
                        , optcd
                        , addcondition
                        , hidersvfra
                        , hidersv
                        , hiderpt
                        , hidequestion
                    )
                    select
                        :newctrptcd
                        , optcd
                        , addcondition
                        , hidersvfra
                        , hidersv
                        , hiderpt
                        , hidequestion
                    from
                        ctrpt_optgrp
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約パターンオプション管理テーブルレコードの挿入
                sql = @"
                    insert
                    into ctrpt_opt(
                        ctrptcd
                        , optcd
                        , optbranchno
                        , optname
                        , optsname
                        , optdiv
                        , cscd
                        , setcolor
                        , csldivcd
                        , gender
                        , rsvfracd
                        , setclasscd
                        , lastrefmonth
                        , lastrefcscd
                        , exceptlimit
                    )
                    select
                        :newctrptcd
                        , optcd
                        , optbranchno
                        , optname
                        , optsname
                        , optdiv
                        , cscd
                        , setcolor
                        , csldivcd
                        , gender
                        , rsvfracd
                        , setclasscd
                        , lastrefmonth
                        , lastrefcscd
                        , exceptlimit
                    from
                        ctrpt_opt
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約パターンオプション年齢条件テーブルレコードの挿入
                sql = @"
                    insert
                    into ctrpt_optage(
                        ctrptcd
                        , optcd
                        , optbranchno
                        , seq
                        , strage
                        , endage
                    )
                    select
                        :newctrptcd
                        , optcd
                        , optbranchno
                        , seq
                        , strage
                        , endage
                    from
                        ctrpt_optage
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約パターン負担金額管理テーブルレコードの挿入
                sql = @"
                    insert
                    into ctrpt_price(
                        ctrptcd
                        , optcd
                        , optbranchno
                        , seq
                        , price
                        , orgdiv
                        , tax
                        , billprintname
                        , billprintename
                    )
                    select
                        :newctrptcd
                        , optcd
                        , optbranchno
                        , seq
                        , price
                        , orgdiv
                        , tax
                        , billprintname
                        , billprintename
                    from
                        ctrpt_price
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約パターン内グループテーブルレコードの挿入
                sql = @"
                    insert
                    into ctrpt_grp(ctrptcd, optcd, optbranchno, grpcd)
                    select
                        :newctrptcd
                        , optcd
                        , optbranchno
                        , grpcd
                    from
                        ctrpt_grp
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約パターン内検査項目テーブルレコードの挿入
                sql = @"
                    insert
                    into ctrpt_item(ctrptcd, optcd, optbranchno, itemcd)
                    select
                        :newctrptcd
                        , optcd
                        , optbranchno
                        , itemcd
                    from
                        ctrpt_item
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // 契約ノートテーブルレコードの挿入
                sql = @"
                    insert
                    into ctrptpubnote(
                        ctrptcd
                        , seq
                        , pubnotedivcd
                        , dispkbn
                        , upddate
                        , upduser
                        , boldflg
                        , pubnote
                        , dispcolor
                        , delflg
                    )
                    select
                        :newctrptcd
                        , seq
                        , pubnotedivcd
                        , dispkbn
                        , upddate
                        , upduser
                        , boldflg
                        , pubnote
                        , dispcolor
                        , delflg
                    from
                        ctrptpubnote
                    where
                        ctrptcd = :curctrptcd
                ";

                connection.Execute(sql, param);

                // トランザクションをコミット
                ts.Complete();
            }
        }

        /// <summary>
        /// 契約パターンテーブルレコードを複写する
        /// </summary>
        /// <param name="curCtrPtCd">(現)契約パターンコード</param>
        /// <param name="newCtrPtCd">(新)契約パターンコード</param>
        /// <param name="strDate">契約開始年月日</param>
        /// <param name="endDate">契約終了年月日</param>
        public void CopyCtrPt(int curCtrPtCd, int newCtrPtCd, DateTime? strDate = null, DateTime? endDate = null)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("curctrptcd", curCtrPtCd);
            param.Add("newctrptcd", newCtrPtCd);
            param.Add("strdate", strDate);
            param.Add("enddate", endDate);

            // 契約パターンテーブルレコードの挿入
            var sql = @"
                insert
                into ctrpt(
                    ctrptcd
                    , strdate
                    , enddate
                    , agecalc
                    , taxfraction
                    , csname
                    , csename
                    , cslmethod
                    , limitrate
                    , limittaxflg
                    , limitprice
                )
                select
                    :newctrptcd
            ";

            // 契約開始年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
            if (strDate != null)
            {
                sql += @"
                    , :strdate
                ";
            }
            else
            {
                sql += @"
                    , strdate
                ";
            }

            // 契約終了年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
            if (endDate != null)
            {
                sql += @"
                    , :enddate
                ";
            }
            else
            {
                sql += @"
                    , enddate
                ";
            }

            sql += @"
                    , agecalc
                    , taxfraction
                    , csname
                    , csename
                    , cslmethod
                    , limitrate
                    , limittaxflg
                    , limitprice
                from
                    ctrpt
                where
                    ctrptcd = :curctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約管理テーブルレコードを削除する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        public void DeleteCtrMng(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);

            // 指定団体、パターンの契約管理テーブルレコードを削除
            var sql = @"
                delete ctrmng
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                    and ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンテーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        public void DeleteCtrPt(int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);

            // 契約パターンテーブルレコードを削除
            var sql = @"
                delete ctrpt
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン年齢区分テーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        public void DeleteCtrPtAge(int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);

            // 指定契約パターンの契約パターン年齢区分テーブルレコードを削除
            var sql = @"
                delete ctrpt_age
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン内グループテーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        public void DeleteCtrPtGrp(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 指定契約パターン、オプションの契約パターン内グループテーブルレコードを削除
            var sql = @"
                delete ctrpt_grp
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン内検査項目テーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        public void DeleteCtrPtItem(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 指定契約パターン、オプションの契約パターン内検査項目テーブルレコードを削除
            var sql = @"
                delete ctrpt_item
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンオプション管理テーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// 0:正常終了
        /// 1:受診オプション管理テーブルで参照されているレコードを削除しようとした
        /// 2:追加オプション負担金テーブルで参照されているレコードを削除しようとした
        /// 3:webオプション検査テーブルで参照されているレコードを削除しようとした
        /// </returns>
        public int DeleteCtrPtOpt(int ctrPtCd, string optCd, int optBranchNo)
        {
            int ret = 0; // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 契約パターンオプション管理テーブルレコードの削除
            var sql = @"
                delete ctrpt_opt
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
            ";

            try
            {
                connection.Execute(sql, param);
            }
            catch (OracleException ex)
            {
                if (ex.Number != 2292)
                {
                    throw ex;
                }

                // エラーメッセージに含まれるテーブル名の値ごとに戻り値を設定する
                if (ex.Message.IndexOf("CONSULT_O", StringComparison.Ordinal) >= 0)
                {
                    ret = 1;
                }
                else if (ex.Message.IndexOf("OPTPRICE", StringComparison.Ordinal) >= 0)
                {
                    ret = 2;
                }
                else if (ex.Message.IndexOf("WEB_OPT", StringComparison.Ordinal) >= 0)
                {
                    ret = 3;
                }
                else
                {
                    throw ex;
                }
            }

            return ret;
        }

        /// <summary>
        /// 契約パターンオプション年齢条件テーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        public void DeleteCtrPtOptAge(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 指定契約パターンの契約パターンオプション年齢条件テーブルレコードを削除
            var sql = @"
                delete ctrpt_optage
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンオプショングループテーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        public void DeleteCtrPtOptGrp(int ctrPtCd, string optCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);

            // 契約パターンオプショングループテーブルレコードの削除
            var sql = @"
                delete ctrpt_optgrp
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and not exists (
                        select
                            ctrptcd
                        from
                            ctrpt_opt
                        where
                            ctrptcd = ctrpt_optgrp.ctrptcd
                            and optcd = ctrpt_optgrp.optcd
                    )
            ";

            connection.Execute(sql, param);
        }

        //
        //  機能　　 : 契約パターン負担元管理テーブルレコードを削除する
        //
        //  引数　　 : (In)     ctrPtCd  契約パターンコード
        //  　　　　   (In)     seq      SEQ
        //
        //  戻り値　 : 0   正常終了
        //  　　　　   1   契約パターン負担金額管理テーブルで参照されているレコードを削除しようとした
        //  　　　　   2   追加グループ負担金テーブルで参照されているレコードを削除しようとした
        //  　　　　   3   追加検査項目負担金テーブルで参照されているレコードを削除しようとした
        //  　　　　   4   締め管理テーブルで参照されているレコードを削除しようとした
        //  　　　　   >0  異常終了
        //
        //  備考　　 :
        //
        /// <summary>
        /// 契約パターン負担元管理テーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">SEQ</param>
        /// <returns>
        /// 0:正常終了
        /// 1:契約パターン負担金額管理テーブルで参照されているレコードを削除しようとした
        /// 2:追加グループ負担金テーブルで参照されているレコードを削除しようとした
        /// 3:追加検査項目負担金テーブルで参照されているレコードを削除しようとした
        /// 4:締め管理テーブルで参照されているレコードを削除しようとした
        /// </returns>
        public int DeleteCtrPtOrg(int ctrPtCd, int seq)
        {
            int ret = 0; // 関数戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("seq", seq);

            // 契約パターン負担元管理テーブルレコードの削除
            var sql = @"
                delete ctrpt_org
                where
                    ctrptcd = :ctrptcd
                    and seq = :seq
            ";

            try
            {
                connection.Execute(sql, param);
            }
            catch (OracleException ex)
            {
                if (ex.Number != 2292)
                {
                    throw ex;
                }

                // エラーメッセージに含まれるテーブル名の値ごとに戻り値を設定する
                if (ex.Message.IndexOf("CTRPT_PRICE", StringComparison.Ordinal) >= 0)
                {
                    ret = 1;
                }
                else if (ex.Message.IndexOf("GRPPRICE", StringComparison.Ordinal) >= 0)
                {
                    ret = 2;
                }
                else if (ex.Message.IndexOf("ITEMPRICE", StringComparison.Ordinal) >= 0)
                {
                    ret = 3;
                }
                else if (ex.Message.IndexOf("CLOSEMNG", StringComparison.Ordinal) >= 0)
                {
                    ret = 4;
                }
                else
                {
                    throw ex;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約パターン負担金額テーブルレコードを削除する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">SEQ</param>
        public void DeleteCtrPtPrice(int ctrPtCd, int seq)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("seq", seq);

            // 契約パターン負担金額テーブルレコード削除のSQLステートメント作成
            var sql = @"
                delete ctrpt_price
                where
                    ctrptcd = :ctrptcd
                    and seq = :seq
                    and price = 0
                    and tax = 0
            ";

            // SQL文の実行
            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンコードをインクリメントする
        /// </summary>
        /// <returns>契約パターンコード</returns>
        public int IncreaseCtrPtCd()
        {
            // Oracle Sequenceをインクリメントし、DUAL表を用いて次の契約パターンコードを取得する
            var sql = @"
                select
                    ctrptcd_seq.nextval ctrptcd
                from
                    dual
            ";

            dynamic data = connection.Query(sql).FirstOrDefault();

            return Convert.ToInt32(data.CTRPTCD);
        }

        /// <summary>
        /// 契約管理テーブルレコードを挿入する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        public void InsertCtrMng(string orgCd1, string orgCd2, string csCd, string refOrgCd1, string refOrgCd2, int ctrPtCd)
        {
            // 初期処理
            orgCd1 = orgCd1.Trim();
            orgCd2 = orgCd2.Trim();
            refOrgCd1 = refOrgCd1.Trim();
            refOrgCd2 = refOrgCd2.Trim();

            // web用団体コードの取得
            WebHains.GetOrgCd(OrgCdKey.Web, out string strWebOrgCd1, out string strWebOrgCd2);

            // 団体コードがweb用であるかによる、Web予約適用フラグ値の設定
            int webFlg = (orgCd1.Equals(strWebOrgCd1) && orgCd2.Equals(strWebOrgCd2)) ? 1 : 0;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("cscd", csCd.Trim());
            param.Add("reforgcd1", refOrgCd1.Trim());
            param.Add("reforgcd2", refOrgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);
            param.Add("webflg", webFlg);

            // 契約管理テーブルレコードの挿入
            var sql = @"
                insert
                into ctrmng(
                    orgcd1
                    , orgcd2
                    , cscd
            ";

            // 参照先団体指定時の処理
            if (!string.IsNullOrEmpty(refOrgCd1) || !string.IsNullOrEmpty(refOrgCd2))
            {
                sql += @"
                    , reforgcd1
                    , reforgcd2
                ";
            }

            sql += @"
                    , ctrptcd
                    , webflg
                )
                values (
                    :orgcd1
                    , :orgcd2
                    , :cscd
            ";

            // 参照先団体指定時の処理
            if (!string.IsNullOrEmpty(refOrgCd1) || !string.IsNullOrEmpty(refOrgCd2))
            {
                sql += @"
                    , :reforgcd1
                    , :reforgcd2
                ";
            }

            sql += @"
                    , :ctrptcd
                    , :webflg
                )
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 指定参照団体コード、契約パターンの契約情報を参照している全団体に対し、新契約パターンの参照情報を作成する
        /// </summary>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="curCtrPtCd">契約パターンコード</param>
        /// <param name="newCtrPtCd">新契約パターンコード</param>
        public void InsertCtrMngAllRefer(string refOrgCd1, string refOrgCd2, int curCtrPtCd, int newCtrPtCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("reforgcd1", refOrgCd1.Trim());
            param.Add("reforgcd2", refOrgCd2.Trim());
            param.Add("curctrptcd", curCtrPtCd);
            param.Add("newctrptcd", newCtrPtCd);

            // 指定参照団体コード、契約パターンの契約情報を参照している全団体に対し、新契約パターンの参照情報を作成する
            var sql = @"
                insert
                into ctrmng(
                    orgcd1
                    , orgcd2
                    , cscd
                    , reforgcd1
                    , reforgcd2
                    , ctrptcd
                    , webflg
                    , reportcd
                )
                select
                    orgcd1
                    , orgcd2
                    , cscd
                    , reforgcd1
                    , reforgcd2
                    , :newctrptcd
                    , webflg
                    , reportcd
                from
                    ctrmng
                where
                    reforgcd1 = :reforgcd1
                    and reforgcd2 = :reforgcd2
                    and ctrptcd = :curctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約管理テーブルレコードを挿入する(契約情報の参照)
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        public void InsertCtrMngRefer(string orgCd1, string orgCd2, string refOrgCd1, string refOrgCd2, int ctrPtCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("reforgcd1", refOrgCd1.Trim());
            param.Add("reforgcd2", refOrgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);

            // 契約管理テーブルレコードの挿入
            var sql = @"
                insert
                into ctrmng(
                    orgcd1
                    , orgcd2
                    , cscd
                    , reforgcd1
                    , reforgcd2
                    , ctrptcd
                )
                select
                    :orgcd1
                    , :orgcd2
                    , cscd
                    , reforgcd1
                    , reforgcd2
                    , ctrptcd
                from
                    ctrmng
                where
                    orgcd1 = :reforgcd1
                    and orgcd2 = :reforgcd2
                    and ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンテーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <param name="ageCalc">年齢起算日</param>
        /// <param name="taxFraction">税端数区分</param>
        /// <param name="strCsName">コース名</param>
        public void InsertCtrPt(int ctrPtCd, DateTime strDate, DateTime endDate, string ageCalc, int taxFraction, string strCsName)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("strdate", strDate);
            param.Add("enddate", endDate);
            param.Add("agecalc", ageCalc);
            param.Add("taxfraction", taxFraction);
            param.Add("csname", strCsName);

            // 契約パターンテーブルレコードの挿入
            var sql = @"
                insert
                into ctrpt(
                    ctrptcd
                    , strdate
                    , enddate
                    , agecalc
                    , taxfraction
                    , csname
                )
                values (
                    :ctrptcd
                    , :strdate
                    , :enddate
                    , :agecalc
                    , :taxfraction
                    , :csname
                )
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン年齢区分テーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="ages">年齢区分情報</param>
        public void InsertCtrPtAge(int ctrPtCd, IList<ContractAges> ages)
        {
            // 契約パターン年齢区分テーブルレコードの挿入
            var sql = @"
                insert
                into ctrpt_age(
                    ctrptcd
                    , seq
                    , strage
                    , endage
                    , agediv)
                values (
                    :ctrptcd
                    , :seq
                    , :strage
                    , :endage
                    , :agediv
                )
            ";

            // パラメーター値設定
            var param = new List<Dictionary<string, object>>();
            for (var i = 0; i < ages.Count; i++)
            {
                param.Add(new Dictionary<string, object>()
                {
                    { "ctrptcd", ctrPtCd },
                    { "seq", i + 1 },
                    { "strage", ages[i].StrAge },
                    { "endage", ages[i].EndAge },
                    { "agediv", ages[i].Agediv }
                });
            }

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン内グループテーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="grpCd">グループコード</param>
        public void InsertCtrPtGrp(int ctrPtCd, string optCd, int optBranchNo, string[] grpCd)
        {
            // 契約パターン内グループテーブルレコードの挿入
            var sql = @"
                insert
                into ctrpt_grp(
                    ctrptcd
                    , optcd
                    , optbranchno
                    , grpcd)
                values (
                    :ctrptcd
                    , :optcd
                    , :optbranchno
                    , :grpcd
                )
            ";

            // パラメーター値設定
            var param = new List<Dictionary<string, object>>();
            for (var i = 0; i < grpCd.Length; i++)
            {
                param.Add(new Dictionary<string, object>()
                {
                    { "ctrptcd", ctrPtCd },
                    { "optcd", optCd },
                    { "optbranchno", optBranchNo },
                    { "grpcd", grpCd[i] }
                });
            }

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン内検査項目テーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="itemCd">検査項目コード</param>
        public void InsertCtrPtItem(int ctrPtCd, string optCd, int optBranchNo, string[] itemCd)
        {
            // 契約パターン内検査項目テーブルレコードの挿入
            var sql = @"
                insert
                into ctrpt_item(
                    ctrptcd
                    , optcd
                    , optbranchno
                    , itemcd
                )
                values (
                    :ctrptcd
                    , :optcd
                    , :optbranchno
                    , :itemcd
                )
            ";

            // パラメーター値設定
            var param = new List<Dictionary<string, object>>();
            for (var i = 0; i < itemCd.Length; i++)
            {
                param.Add(new Dictionary<string, object>()
                {
                    { "ctrptcd", ctrPtCd },
                    { "optcd", optCd },
                    { "optbranchno", optBranchNo },
                    { "itemcd", itemCd[i] }
                });
            }

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンオプション年齢条件テーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="optages">年齢区分情報</param>
        public void InsertCtrPtOptAge(int ctrPtCd, string optCd, int optBranchNo, IList<ContractAges> optages)
        {
            // 契約パターンオプション年齢条件テーブルレコードの挿入
            var sql = @"
                insert
                into ctrpt_optage(
                    ctrptcd
                    , optcd
                    , optbranchno
                    , seq
                    , strage
                    , endage
                )
                values (
                    :ctrptcd
                    , :optcd
                    , :optbranchno
                    , :seq
                    , :strage
                    , :endage
                )
            ";

            // パラメーター値設定
            var param = new List<Dictionary<string, object>>();
            for (var i = 0; i < optages.Count; i++)
            {
                param.Add(new Dictionary<string, object>()
                {
                    { "ctrptcd", ctrPtCd },
                    { "optcd", optCd },
                    { "optbranchno", optBranchNo },
                    { "seq", i + 1 },
                    { "strage", optages[i].StrAge==null ? 0 : optages[i].StrAge},
                    { "endage", optages[i].EndAge==null ? 999.99 :  optages[i].EndAge}
                });
            }

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン負担元テーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burden">負担情報</param>
        public void InsertCtrPtOrg(int ctrPtCd, ContractBurdens burden)
        {
            InsertCtrPtOrg(ctrPtCd, new List<ContractBurdens> { burden });
        }

        /// <summary>
        /// 契約パターン負担元テーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burdens">負担情報</param>
        public void InsertCtrPtOrg(int ctrPtCd, IList<ContractBurdens> burdens)
        {
            // 契約パターン負担元テーブルレコード挿入のSQLステートメント作成
            var sql = @"
                insert
                into ctrpt_org(
                    ctrptcd
                    , seq
                    , apdiv
                    , orgcd1
                    , orgcd2
                    , taxflg
                )
                values (
                    :ctrptcd
                    , :seq
                    , :apdiv
                    , :orgcd1
                    , :orgcd2
                    , :taxflg
                )
            ";

            // パラメーター値設定
            var paramArray = new List<Dictionary<string, object>>();
            for (var i = 0; i < burdens.Count; i++)
            {
                var param = new Dictionary<string, object>();
                param.Add("ctrptcd", ctrPtCd);
                param.Add("seq", burdens[i].Seq);
                param.Add("apdiv", burdens[i].Apdiv);
                param.Add("orgcd1", burdens[i].OrgCd1);
                param.Add("orgcd2", burdens[i].OrgCd2);
                param.Add("taxflg", burdens[i].TaxFlg);
                paramArray.Add(param);
            }

            connection.Execute(sql, paramArray);
        }

        /// <summary>
        /// 契約パターン負担金額テーブルレコードを挿入する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">SEQ</param>
        public void InsertCtrPtPrice(int ctrPtCd, int seq)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("seq", seq);

            // 契約パターン負担金額テーブルレコード挿入のSQLステートメント作成
            var sql = @"
                insert
                into ctrpt_price(
                    ctrptcd
                    , seq
                    , optcd
                    , optbranchno
                    , price
                    , tax
                )
                select
                    ctrptcd
                    , :seq
                    , optcd
                    , optbranchno
                    , 0
                    , 0
                from
                    ctrpt_opt
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        //
        //  機能　　 : 契約パターンのレコードロック
        //
        //  引数　　 : (In)     ctrPtCd  契約パターンコード
        //
        //  戻り値　 : True   レコードあり
        //  　　　　   False  レコードなし、または異常終了
        //
        //  備考　　 :
        //
        /// <summary>
        /// 契約パターンのレコードロック
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// true レコードあり
        /// false レコードなし
        /// </returns>
        public bool LockCtrPt(int ctrPtCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);

            // 契約パターンテーブルレコードを更新し、ロックをかける
            var sql = @"
                select
                    ctrptcd
                from
                    ctrpt
                where
                    ctrptcd = :ctrptcd
                for update
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // 戻り値の設定
            return (data != null);
        }

        /// <summary>
        /// 指定団体・契約パターンの契約情報を参照している全ての契約情報を持つ受診情報テーブルレコードのロック
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// true レコードあり
        /// false レコードなし
        /// </returns>
        public bool LockConsultReferringContract(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("ctrptcd", ctrPtCd);

            // 指定団体・契約パターンの契約情報を参照している全ての契約情報を持つ受診情報テーブルレコードのロック
            var sql = @"
                select
                    orgcd1
                from
                    consult
                where
                    (orgcd1, orgcd2, ctrptcd) in (
                        select
                            orgcd1
                            , orgcd2
                            , ctrptcd
                        from
                            ctrmng
                        where
                            reforgcd1 = :orgcd1
                            and reforgcd2 = :orgcd2
                            and ctrptcd = :ctrptcd
                    ) for update
            ";

            List<dynamic> data = connection.Query(sql, param).ToList();

            // レコードの有無で戻り値を決定
            return (data.Count > 0);
        }

        /// <summary>
        /// 指定団体・契約パターンの契約情報を参照している全団体の団体テーブルロック
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// true レコードあり
        /// false レコードなし
        /// </returns>
        public bool LockOrgReferringContract(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);

            // 指定団体・契約パターンの契約情報を参照している全団体の団体テーブルロック
            var sql = @"
                select
                    orgcd1
                from
                    org
                where
                    (orgcd1, orgcd2) in (
                        select
                            orgcd1
                            , orgcd2
                        from
                            ctrmng
                        where
                            reforgcd1 = :orgcd1
                            and reforgcd2 = :orgcd2
                            and ctrptcd = :ctrptcd
                    ) for update
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            // レコードの有無で戻り値を決定
            return (data != null);
        }

        /// <summary>
        /// 契約パターンオプショングループテーブルを更新する(レコードが存在しない場合は挿入)
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optGroups">オプショングループ</param>
        public void MergeCtrPtOptGrp(int ctrPtCd, string optCd, ContractOption optGroups)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("addcondition", optGroups.AddCondition);
            param.Add("hidersvfra", optGroups.HideRsvFra);
            param.Add("hidersv", optGroups.HideRsv);
            param.Add("hiderpt", optGroups.HideRpt);
            param.Add("hidequestion", optGroups.HideQuestion);

            // 契約パターンオプショングループレコードの更新
            var sql = @"
                merge
                into ctrpt_optgrp
                    using (
                        select
                            :ctrptcd ctrptcd
                            , :optcd optcd
                            , :addcondition addcondition
                            , :hidersvfra hidersvfra
                            , :hidersv hidersv
                            , :hiderpt hiderpt
                            , :hidequestion hidequestion
                        from
                            dual
                    ) basedctrpt_optgrp
                        on (
                            ctrpt_optgrp.ctrptcd = basedctrpt_optgrp.ctrptcd
                            and ctrpt_optgrp.optcd = basedctrpt_optgrp.optcd
                        )
            ";

            // 更新部
            sql += @"
                when matched then
                    update
                    set
                        ctrpt_optgrp.addcondition = basedctrpt_optgrp.addcondition
                        , ctrpt_optgrp.hidersvfra = basedctrpt_optgrp.hidersvfra
                        , ctrpt_optgrp.hidersv = basedctrpt_optgrp.hidersv
                        , ctrpt_optgrp.hiderpt = basedctrpt_optgrp.hiderpt
                        , ctrpt_optgrp.hidequestion = basedctrpt_optgrp.hidequestion
            ";

            // 挿入部
            sql += @"
                when not matched then
                    insert (
                        ctrpt_optgrp.ctrptcd
                        , ctrpt_optgrp.optcd
                        , ctrpt_optgrp.addcondition
                        , ctrpt_optgrp.hidersvfra
                        , ctrpt_optgrp.hidersv
                        , ctrpt_optgrp.hiderpt
                        , ctrpt_optgrp.hidequestion
                    )
                    values (
                        basedctrpt_optgrp.ctrptcd
                        , basedctrpt_optgrp.optcd
                        , basedctrpt_optgrp.addcondition
                        , basedctrpt_optgrp.hidersvfra
                        , basedctrpt_optgrp.hidersv
                        , basedctrpt_optgrp.hiderpt
                        , basedctrpt_optgrp.hidequestion
                    )
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 指定団体の全コースの契約情報をコース昇順、契約期間昇順に取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// webcolor webカラー
        /// cscd     コースコード
        /// csname   コース名
        /// strdate  契約開始日
        /// enddate  契約終了日
        /// </returns>
        public List<dynamic> SelectAllCourseCtrMng(string orgCd1, string orgCd2)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());

            // 指定団体の全コースの契約情報をコース昇順、契約期間昇順に取得
            string sql = @"
                select
                    course_p.webcolor
                    , course_p.cscd
                    , course_p.csname
                    , myctrmng.strdate
                    , myctrmng.enddate
                from
                    (
                        select
                            ctrmng.cscd
                            , ctrpt.strdate
                            , ctrpt.enddate
                        from
                            ctrpt
                            , ctrmng
                        where
                            ctrmng.orgcd1 = :orgcd1
                            and ctrmng.orgcd2 = :orgcd2
                            and ctrmng.ctrptcd = ctrpt.ctrptcd
                    ) myctrmng
                    , course_p
                where
                    course_p.cscd = myctrmng.cscd(+)
                order by
                    cscd
                    , strdate
            ";

            return connection.Query(sql, param).ToList();
        }

        //
        //  機能　　 : 指定団体の全契約情報(コース・参照先団体・契約期間)をコース昇順、契約期間降順に取得する
        //
        //  引数　　 : (In)     orgCd1      団体コード1
        //  　　　　   (In)     orgCd2      団体コード2
        //  　　　　   (In)     csCd        コースコード
        //  　　　　   (In)     strDate     開始日付
        //  　　　　   (In)     endDate     終了日付
        //  　　　　   (Out)    vntWebColor    webカラー
        //  　　　　   (Out)    vntCsCd        コースコード
        //  　　　　   (Out)    vntCsName      コース名
        //  　　　　   (Out)    vntCtrCsName   (契約パターン上での)コース名
        //  　　　　   (Out)    vntRefOrgCd1   参照先団体コード1
        //  　　　　   (Out)    vntRefOrgCd2   参照先団体コード2
        //  　　　　   (Out)    vntOrgName     団体名称
        //  　　　　   (Out)    vntCtrPtCd     契約パターンコード
        //  　　　　   (Out)    vntStrDate     契約開始日
        //  　　　　   (Out)    vntEndDate     契約終了日
        //  　　　　   (Out)    vntAgeCalc     年齢起算日
        //  　　　　   (Out)    vntReferred    他団体参照フラグ(他団体から参照されていればTrue)
        //  　　　　   (In)     isFirstCourse True指定時は１次健診コースのみ取得
        //
        //  戻り値　 : >=0  レコード件数
        //  　　　　   <0   異常終了
        //
        //  備考　　 :
        //
        /// <summary>
        /// 指定団体の全契約情報(コース・参照先団体・契約期間)をコース昇順、契約期間降順に取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <param name="isFirstCourse">true指定時は１次健診コースのみ取得</param>
        /// <returns>
        /// webcolor  webカラー
        /// cscd      コースコード
        /// csname    コース名
        /// ctrcsname (契約パターン上での)コース名
        /// reforgcd1 参照先団体コード1
        /// reforgcd2 参照先団体コード2
        /// orgname   団体名称
        /// ctrptcd   契約パターンコード
        /// strdate   契約開始日
        /// enddate   契約終了日
        /// agecalc   年齢起算日
        /// referred  他団体参照フラグ
        /// </returns>
        public List<dynamic> SelectAllCtrMng(string orgCd1, string orgCd2, string csCd, DateTime? strDate = null, DateTime? endDate = null, bool isFirstCourse = false)
        {
            DateTime? wkStrDate; // 契約開始日
            DateTime? wkEndDate; // 契約終了日

            // 契約期間の設定
            if ((strDate != null) && (endDate != null) && (strDate > endDate))
            {
                wkStrDate = endDate;
                wkEndDate = strDate;
            }
            else
            {
                wkStrDate = strDate;
                wkEndDate = endDate;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd))
            {
                param.Add("cscd", csCd.Trim());
            }
            param.Add("strdate", wkStrDate);
            param.Add("enddate", wkEndDate);

            // 指定団体の全契約情報(コース・参照先団体・契約期間・他団体からの参照状態)を取得
            var sql = @"
                select
                    course_p.webcolor
                    , ctrmng.cscd
                    , course_p.csname
                    , ctrmng.reforgcd1
                    , ctrmng.reforgcd2
                    , org.orgname
                    , ctrmng.ctrptcd
                    , ctrpt.strdate
                    , ctrpt.enddate
                    , ctrpt.agecalc
                    , referred.refctrptcd
                    , ctrpt.csname ctrcsname
            ";

            // 自団体の契約パターンを参照している契約団体の有無を取得する副問い合わせ(自団体の契約情報は除く)
            sql += @"
                from
                    (
                        select distinct
                            ctrptcd refctrptcd
                        from
                            ctrmng
                        where
                            reforgcd1 = :orgcd1
                            and reforgcd2 = :orgcd2
                            and (orgcd1 != reforgcd1 or orgcd2 != reforgcd2)
                    ) referred
            ";

            // 契約管理情報に対し、契約パターン・団体・コース情報を結合
            sql += @"
                    , ctrpt
                    , org
                    , course_p
                    , ctrmng
                where
                    ctrmng.orgcd1 = :orgcd1
                    and ctrmng.orgcd2 = :orgcd2
            ";

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                    and ctrmng.cscd = :cscd
                ";
            }

            // コース、契約パターン、団体を結合
            sql += @"
                    and ctrmng.cscd = course_p.cscd
                    and ctrmng.reforgcd1 = org.orgcd1
                    and ctrmng.reforgcd2 = org.orgcd2
                    and ctrmng.ctrptcd = ctrpt.ctrptcd
            ";

            // 開始日付指定時は条件節に加える
            if (wkStrDate != null)
            {
                sql += @"
                    and ctrpt.enddate >= :strdate
                ";
            }

            // 終了日付指定時は条件節に加える
            if (wkEndDate != null)
            {
                sql += @"
                    and ctrpt.strdate <= :enddate
                ";
            }

            // 自団体の契約パターンを参照している契約団体が存在すればそれを結合(実際は契約パターンコードで結合)
            sql += @"
                    and ctrmng.ctrptcd = referred.refctrptcd(+)
            ";

            // １次健診のみ指定時は条件節に加える
            if (isFirstCourse)
            {
                sql += @"
                    and course_p.secondflg = 0
                ";
            }

            // コース昇順、契約期間降順に取得する
            sql += @"
                order by
                    ctrmng.cscd
                    , ctrpt.strdate desc
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定団体、コース、日付において有効な全ての受診区分を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="strDate">開始日付</param>
        /// <param name="endDate">終了日付</param>
        /// <returns>
        /// csldivcd   受診区分コード
        /// csldivname 受診区分名
        /// </returns>
        public List<dynamic> SelectAllCslDiv(string orgCd1, string orgCd2, string csCd, DateTime? strDate = null, DateTime? endDate = null)
        {
            DateTime? wkStrDate; // 契約開始日
            DateTime? wkEndDate; // 契約終了日

            // 契約期間の設定
            if ((strDate != null) && (endDate != null) && (strDate > endDate))
            {
                wkStrDate = endDate;
                wkEndDate = strDate;
            }
            else
            {
                wkStrDate = strDate;
                wkEndDate = endDate;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("cscd", csCd);
            param.Add("strdate", wkStrDate ?? new DateTime(1970, 1, 1));
            param.Add("enddate", wkEndDate ?? new DateTime(2200, 12, 31));
            param.Add("csldivcd", CSLDIVCD_NOTHING);

            // 指定団体、コース、日付において有効な全ての受診区分を取得する
            var sql = @"
                select
                    allcsldiv.csldivcd
                    , csldiv.csldivname
                from
                    csldiv
                    , (
                        select
                            ctrpt_opt.csldivcd
                        from
                            ctrpt_opt
                            , ctrpt
                            , ctrmng
                        where
                            ctrmng.orgcd1 = :orgcd1
                            and ctrmng.orgcd2 = :orgcd2
                            and ctrmng.cscd = nvl(:cscd, ctrmng.cscd)
                            and ctrmng.ctrptcd = ctrpt.ctrptcd
                            and ctrpt.enddate >= :strdate
                            and ctrpt.strdate <= :enddate
                            and ctrmng.ctrptcd = ctrpt_opt.ctrptcd
                        union
                        select
                            :csldivcd csldivcd
                        from
                            dual
                    ) allcsldiv
                where
                    allcsldiv.csldivcd = csldiv.csldivcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定団体・コース・契約パターンにおける契約管理情報を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// 契約管理情報
        /// orgname     漢字名称
        /// cscd        コースコード
        /// csname      コース名
        /// strdate     契約開始日
        /// enddate     契約終了日
        /// agecalc     年齢起算日
        /// taxfraction 税端数区分
        /// reportcd    帳票コード
        /// reforgcd1   参照先団体コード1
        /// reforgcd2   参照先団体コード2
        /// </returns>
        public dynamic SelectCtrMng(string orgCd1, string orgCd2, int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("ctrptcd", ctrPtCd);

            // 検索条件を満たす契約管理テーブルのレコードを取得
            string sql = @"
                select
                    org.orgname
                    , ctrmng.cscd
                    , course_p.csname
                    , ctrpt.strdate
                    , ctrpt.enddate
                    , ctrpt.agecalc
                    , ctrpt.taxfraction
                    , ctrmng.reportcd
                    , ctrmng.reforgcd1
                    , ctrmng.reforgcd2
                from
                    course_p
                    , org
                    , ctrpt
                    , ctrmng
                where
                    ctrmng.orgcd1 = :orgcd1
                    and ctrmng.orgcd2 = :orgcd2
                    and ctrmng.ctrptcd = :ctrptcd
                    and ctrmng.ctrptcd = ctrpt.ctrptcd
                    and ctrmng.orgcd1 = org.orgcd1
                    and ctrmng.orgcd2 = org.orgcd2
                    and ctrmng.cscd = course_p.cscd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定団体の契約管理情報にて管理する全てのコースを取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>
        /// cscd   コースコード
        /// csname コース名
        /// </returns>
        public List<dynamic> SelectCtrMngCourse(string orgCd1, string orgCd2)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());

            // 指定団体の契約管理情報にて管理する全てのコースを取得する
            var sql = @"
                select distinct
                    ctrmng.cscd
                    , course_p.csname
                from
                    course_p
                    , ctrmng
                where
                    ctrmng.orgcd1 = :orgcd1
                    and ctrmng.orgcd2 = :orgcd2
                    and ctrmng.cscd = course_p.cscd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 参照先団体の契約情報が参照元団体から参照可能かをチェックし、その状態を返す
        /// </summary>
        /// <param name="orgCd1">参照元団体コード1</param>
        /// <param name="orgCd2">参照元団体コード2</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// cscd      コースコード
        /// ctrptcd   契約パターンコード
        /// strdate   契約開始日
        /// enddate   契約終了日
        /// orgequals 参照先団体一致フラグ
        /// referred  参照済みフラグ
        /// overlap   契約期間重複フラグ
        /// existbdn  負担元存在フラグ
        /// </returns>
        public List<dynamic> SelectCtrMngRefer(string orgCd1, string orgCd2, string refOrgCd1, string refOrgCd2, string csCd = null, int? ctrPtCd = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("reforgcd1", refOrgCd1.Trim());
            param.Add("reforgcd2", refOrgCd2.Trim());
            if (!string.IsNullOrEmpty(csCd))
            {
                param.Add("cscd", csCd.Trim());
            }
            if (ctrPtCd != null)
            {
                param.Add("ctrptcd", ctrPtCd);
            }

            // 参照先団体の契約情報が参照元団体から参照可能かをチェック
            var sql = @"
                select
                    ctrmng_and_org.cscd
                    , ctrmng_and_org.ctrptcd
                    , ctrmng_and_org.strdate
                    , ctrmng_and_org.enddate
            ";

            // 参照先団体の参照先が参照元団体と等しいかチェック
            sql += @"
                    , case
                        when ctrmng_and_org.refreforgcd1 = ctrmng_and_org.orgcd1
                        and ctrmng_and_org.refreforgcd2 = ctrmng_and_org.orgcd2
                            then 1
                        else 0
                        end orgequals
            ";

            // 同一コース内において参照先団体の契約期間と期間が重複する参照元団体の契約情報数をカウント
            sql += @"
                    , (
                        select
                            decode(count(*), 0, 0, 1)
                        from
                            ctrpt
                            , ctrmng
                        where
                            ctrmng.orgcd1 = ctrmng_and_org.orgcd1
                            and ctrmng.orgcd2 = ctrmng_and_org.orgcd2
                            and ctrmng.cscd = ctrmng_and_org.cscd
                            and ctrmng.ctrptcd = ctrpt.ctrptcd
                            and ctrpt.enddate >= ctrmng_and_org.strdate
                            and ctrpt.strdate <= ctrmng_and_org.enddate
                    ) overlap
            ";

            // 参照先団体の契約情報の負担元として参照先団体が存在するかをチェック
            sql += @"
                , nvl2(ctrpt_org.ctrptcd, 1, 0) existbdn
            ";

            // 同一契約パターンの契約情報がすでに参照元団体の契約情報として存在するかをチェック
            sql += @"
                , nvl2(ctrmng.ctrptcd, 1, 0) referred
            ";

            // 参照先団体の全契約情報を基本表とする
            sql += @"
                from
                    ctrmng
                    , ctrpt_org
                    , (
                        select
                            ctrmng.orgcd1 reforgcd1
                            , ctrmng.orgcd2 reforgcd2
                            , ctrmng.cscd
                            , ctrmng.reforgcd1 refreforgcd1
                            , ctrmng.reforgcd2 refreforgcd2
                            , ctrmng.ctrptcd
                            , ctrpt.strdate
                            , ctrpt.enddate
                            , :orgcd1 orgcd1
                            , :orgcd2 orgcd2
                        from
                            ctrpt
                            , ctrmng
                        where
                            ctrmng.orgcd1 = :reforgcd1
                            and ctrmng.orgcd2 = :reforgcd2
                            and ctrmng.ctrptcd = ctrpt.ctrptcd
                    ) ctrmng_and_org
            ";

            // 参照先団体の契約情報の負担元として参照先団体が存在するかをチェックするため、負担元管理情報との外部結合を行う
            sql += @"
                where
                    ctrmng_and_org.ctrptcd = ctrpt_org.ctrptcd(+)
                    and ctrmng_and_org.orgcd1 = ctrpt_org.orgcd1(+)
                    and ctrmng_and_org.orgcd2 = ctrpt_org.orgcd2(+)
            ";

            // 同一契約パターンの契約情報がすでに参照元団体の契約情報として存在するかをチェックするため、契約管理情報との外部結合を行う
            sql += @"
                and ctrmng_and_org.orgcd1 = ctrmng.orgcd1(+)
                and ctrmng_and_org.orgcd2 = ctrmng.orgcd2(+)
                and ctrmng_and_org.ctrptcd = ctrmng.ctrptcd(+)
            ";

            // コース指定時は条件節に追加する
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                    and ctrmng_and_org.cscd = :cscd
                ";
            }

            // 契約パターン指定時は条件節に追加する
            if (ctrPtCd != null)
            {
                sql += @"
                    and ctrmng_and_org.ctrptcd = :ctrptcd
                ";
            }

            // コース、契約開始日の昇順に取得する
            sql += @"
                order by
                    cscd
                    , strdate
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 契約期間付きの契約管理情報を取得する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// ctrptcd 契約パターンコード
        /// strdate 契約開始日
        /// enddate 契約終了日
        /// </returns>
        public List<dynamic> SelectCtrMngWithPeriod(string orgCd1, string orgCd2, string csCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("cscd", csCd.Trim());

            // 契約期間付きの契約管理情報を取得
            var sql = @"
                select
                    ctrptcd
                    , strdate
                    , enddate
                from
                    ctrmngwithperiod
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                    and cscd = :cscd
                order by
                    strdate
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターンの契約期間および年齢起算日を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// strdate     契約開始日
        /// enddate     契約終了日
        /// taxfraction 税端数区分
        /// agecalc     年齢起算日
        /// csname      コース名
        /// csename     英語コース名
        /// cslmethod   予約方法
        /// limitrate   限度率
        /// limittaxflg 限度額消費税フラグ
        /// limitprice  上限金額
        /// </returns>
        public dynamic SelectCtrPt(int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);

            // 検索条件を満たす契約パターンテーブルのレコードを取得
            var sql = @"
                select
                    strdate
                    , enddate
                    , agecalc
                    , taxfraction
                    , csname
                    , csename
                    , cslmethod
                    , limitrate
                    , limittaxflg
                    , limitprice
                from
                    ctrpt
                where
                    ctrptcd = :ctrptcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 受診日、コース、団体の条件に合致する契約パターンを取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <returns>契約パターンコード</returns>
        public int SelectCtrPtFromConsult(DateTime cslDate, string csCd, string orgCd1, string orgCd2)
        {
            string sql = @"
                begin
                    :ctrptcd := getctrptcdfromconsult(
                        :csldate
                        , :cscd
                        , :orgcd1
                        , :orgcd2
                    );
                end;
            ";

            using (var cmd = new OracleCommand())
            {
                // Inputは名前と値のみ
                cmd.Parameters.Add("csldate", cslDate);
                cmd.Parameters.Add("cscd", csCd);
                cmd.Parameters.Add("orgcd1", orgCd1);
                cmd.Parameters.Add("orgcd2", orgCd2);

                // OutputはOracleDbTypeとParameterDirectionの指定が必要
                OracleParameter ctrptcd = cmd.Parameters.Add("ctrptcd", OracleDbType.Int32, ParameterDirection.Output);

                ExecuteNonQuery(cmd, sql);

                return ((OracleDecimal)ctrptcd.Value).ToInt32();
            }
        }

        /// <summary>
        /// 指定契約パターンにおける年齢区分を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// strage 開始年齢
        /// endage 終了年齢
        /// agediv 年齢区分
        /// </returns>
        public List<dynamic> SelectCtrPtAge(int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);

            // 検索条件を満たす契約パターン年齢区分テーブルのレコードを取得
            var sql = @"
                select
                    strage
                    , endage
                    , agediv
                from
                    ctrpt_age
                where
                    ctrptcd = :ctrptcd
                order by
                    ctrptcd
                    , seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターン・オプションにおけるグループを取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// grpcd   グループコード
        /// grpname グループ名
        /// </returns>
        public List<dynamic> SelectCtrPtGrp(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 検索条件を満たす契約パターン内グループテーブルのレコードを取得
            var sql = @"
                select
                    ctrpt_grp.grpcd
                    , grp_p.grpname
                from
                    grp_p
                    , ctrpt_grp
                where
                    ctrpt_grp.ctrptcd = :ctrptcd
                    and ctrpt_grp.optcd = :optcd
                    and ctrpt_grp.optbranchno = :optbranchno
                    and ctrpt_grp.grpcd = grp_p.grpcd
                order by
                    ctrpt_grp.ctrptcd
                    , ctrpt_grp.optcd
                    , ctrpt_grp.optbranchno
                    , ctrpt_grp.grpcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターン・オプションにおける検査項目を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// itemcd      検査項目コード
        /// requestname 依頼項目名
        /// </returns>
        public List<dynamic> SelectCtrPtItem(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 検索条件を満たす契約パターン内検査項目テーブルのレコードを取得
            var sql = @"
                select
                    ctrpt_item.itemcd
                    , item_p.requestname
                from
                    item_p
                    , ctrpt_item
                where
                    ctrpt_item.ctrptcd = :ctrptcd
                    and ctrpt_item.optcd = :optcd
                    and ctrpt_item.optbranchno = :optbranchno
                    and ctrpt_item.itemcd = item_p.itemcd
                order by
                    ctrpt_item.ctrptcd
                    , ctrpt_item.optcd
                    , ctrpt_item.optbranchno
                    , ctrpt_item.itemcd
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターンおよびオプションコードのオプション検査情報を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// optname      オプション名
        /// optsname     オプション略称
        /// cscd         コースコード
        /// setclasscd   セット分類コード
        /// csldivcd     受診区分コード
        /// gender       受診可能性別
        /// lastrefmonth 前回値参照用月数
        /// lastrefcscd  前回値参照用コースコード
        /// exceptlimit  限度額設定除外
        /// addcondition 追加条件
        /// hidersvfra   予約枠画面非表示
        /// hidersv      予約画面非表示
        /// hiderpt      受付画面非表示
        /// hidequestion 問診画面非表示
        /// rsvfracd     予約枠コード
        /// setcolor     セットカラー
        /// </returns>
        public dynamic SelectCtrPtOpt(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 検索条件を満たす契約パターンオプション管理テーブルのレコードを取得
            var sql = @"
                select
                    ctrpt_opt.optname
                    , ctrpt_opt.optsname
                    , ctrpt_opt.cscd
                    , ctrpt_opt.setclasscd
                    , ctrpt_opt.csldivcd
                    , ctrpt_opt.gender
                    , ctrpt_opt.lastrefmonth
                    , ctrpt_opt.lastrefcscd
                    , ctrpt_opt.exceptlimit
                    , ctrpt_optgrp.addcondition
                    , ctrpt_optgrp.hidersvfra
                    , ctrpt_optgrp.hidersv
                    , ctrpt_optgrp.hiderpt
                    , ctrpt_optgrp.hidequestion
                    , ctrpt_opt.rsvfracd
                    , ctrpt_opt.setcolor
                from
                    ctrpt_optgrp
                    , ctrpt_opt
                where
                    ctrpt_opt.ctrptcd = :ctrptcd
                    and ctrpt_opt.optcd = :optcd
                    and ctrpt_opt.optbranchno = :optbranchno
                    and ctrpt_opt.ctrptcd = ctrpt_optgrp.ctrptcd
                    and ctrpt_opt.optcd = ctrpt_optgrp.optcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定契約パターン、オプションの受診対象年齢条件を読み込む
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// strage 受診対象開始年齢
        /// endage 受診対象終了年齢
        /// </returns>
        public List<dynamic> SelectCtrPtOptAge(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 検索条件を満たす契約パターンオプション年齢条件テーブルのレコードを取得
            var sql = @"
                select
                    strage
                    , endage
                from
                    ctrpt_optage
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
                order by
                    ctrptcd
                    , optcd
                    , seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターン・オプションにおける検査項目の説明情報を取得
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// itemcd      検査項目コード
        /// suffix      サフィックス
        /// itemname    検査項目名
        /// explanation 項目説明
        /// </returns>
        public List<dynamic> SelectCtrPtOptExplanation(int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);

            // 検索条件を満たすレコードを取得
            var sql = @"
                select
                    item_c.itemcd
                    , item_c.suffix
                    , item_c.itemname
                    , item_c.explanation
                from
                    item_c
                    , (
                        select
                            grp_r.itemcd
                        from
                            grp_r
                            , ctrpt_grp
                        where
                            ctrpt_grp.ctrptcd = :ctrptcd
                            and ctrpt_grp.optcd = :optcd
                            and ctrpt_grp.optbranchno = :optbranchno
                            and ctrpt_grp.grpcd = grp_r.grpcd
                        union
                        select
                            itemcd
                        from
                            ctrpt_item
                        where
                            ctrptcd = :ctrptcd
                            and optcd = :optcd
                            and optbranchno = :optbranchno
                    ) ctrptallitem
                where
                    ctrptallitem.itemcd = item_c.itemcd
                    and item_c.explanation is not null
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="perId">個人ID</param>
        /// <param name="gender">性別</param>
        /// <param name="birth">生年月日</param>
        /// <param name="age">受診時年齢</param>
        /// <param name="exceptNoMatch">性別、受診区分、年齢条件に合致しないセットを取得対象とするか</param>
        /// <param name="includeTax">金額に消費税を含むか</param>
        /// <param name="mode">
        /// 0:個人ID指定時、引数指定された性別・生年月日・年齢を無視し、個人情報から取得
        /// 個人ID未指定ならば引数指定された性別・生年月日・年齢を使用
        /// 1:個人IDの指定に関わらず、引数指定された性別・生年月日・年齢を使用
        /// </param>
        /// <returns>
        /// optcd        オプションコード
        /// optbranchno  オプション枝番
        /// optname      オプション名
        /// optsname     オプション略称
        /// setcolor     セットカラー
        /// setclasscd   セット分類コード
        /// consults     受診要否("1":受診する)
        /// webcolor     webカラー
        /// cssname      コース略称
        /// branchcount  オプション枝番数
        /// addcondition 追加条件
        /// hidersvfra   予約枠画面非表示
        /// hidersv      予約画面非表示
        /// hiderpt      受付画面非表示
        /// hidequestion 問診画面非表示
        /// price        総金額
        /// perprice     個人負担金額
        /// lastrefcscd  前回値参照用コースコード
        /// existsprice  負担情報の有無("1":あり)
        /// </returns>
        public List<dynamic> SelectCtrPtOptFromConsult(
            DateTime cslDate,
            string cslDivCd,
            int ctrPtCd,
            string perId = null,
            int? gender = null,
            DateTime? birth = null,
            string age = null,
            bool exceptNoMatch = false,
            bool includeTax = false,
            int mode = 0
        )
        {
            // キー値の設定
            var param = new OracleDynamicParameters();
            param.Add("csldate", dbType: OracleDbType.Date, value: cslDate, direction: ParameterDirection.Input);
            param.Add("csldivcd", dbType: OracleDbType.Varchar2, value: cslDivCd, direction: ParameterDirection.Input);
            param.Add("ctrptcd", dbType: OracleDbType.Decimal, value: ctrPtCd, direction: ParameterDirection.Input);
            param.Add("perid", dbType: OracleDbType.Varchar2, value: perId, direction: ParameterDirection.Input);
            param.Add("gender", dbType: OracleDbType.Decimal, value: gender, direction: ParameterDirection.Input);
            param.Add("birth", dbType: OracleDbType.Date, value: birth, direction: ParameterDirection.Input);
            param.Add("age", dbType: OracleDbType.Decimal, value: age, direction: ParameterDirection.Input);
            param.Add("exceptnomatch", dbType: OracleDbType.Decimal, value: exceptNoMatch ? 1 : 0, direction: ParameterDirection.Input);
            param.Add("includetax", dbType: OracleDbType.Decimal, value: includeTax ? 1 : 0, direction: ParameterDirection.Input);
            param.Add("mode", dbType: OracleDbType.Decimal, value: mode, direction: ParameterDirection.Input);

            param.Add("ctrptoptinfo", dbType: OracleDbType.RefCursor, direction: ParameterDirection.InputOutput);

            // 受診情報ストアドパッケージの関数呼び出し
            string sql = @"
                begin
                    consultpackagelukes.selectctrptoptfromconsult(
                        :csldate
                        , :csldivcd
                        , :ctrptcd
                        , :perid
                        , :gender
                        , :birth
                        , :age
                        , :exceptnomatch
                        , :includetax
                        , :ctrptoptinfo
                        , :mode
                    );
                end;
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の受診情報に対し、指定契約パターン・オプションにおける検査項目の受診状態を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// itemcd      検査項目コード
        /// requestname 依頼項目名
        /// consults    受診状態("1":受診、"0":未受診)
        /// </returns>
        public List<dynamic> SelectCtrPtOptItem(int rsvNo, int ctrPtCd, string optCd, int optBranchNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("RSVNO", rsvNo);
            param.Add("CTRPTCD", ctrPtCd);
            param.Add("OPTCD", optCd);
            param.Add("OPTBRANCHNO", optBranchNo);

            // 検索条件を満たすレコードを取得
            var sql = @"
                select
                    ctrptallitem.itemcd
                    , item_p.requestname
                    , nvl2(delitem.itemcd, 0, 1) consults
            ";

            // 受診時追加検査項目テーブルから削除項目を取得
            sql += @"
                from
                    (
                        select
                            itemcd
                        from
                            consult_i
                        where
                            rsvno = :rsvno
                            and editflg = 2
                    ) delitem
                    , item_p
            ";

            // 指定契約パターン、オプションコード、枝番の受診項目を依頼項目レベルまで展開して取得
            sql += @"
                    , (
                        select
                            grp_r.itemcd
                        from
                            grp_r
                            , ctrpt_grp
                        where
                            ctrpt_grp.ctrptcd = :ctrptcd
                            and ctrpt_grp.optcd = :optcd
                            and ctrpt_grp.optbranchno = :optbranchno
                            and ctrpt_grp.grpcd = grp_r.grpcd
                        union
                        select
                            itemcd
                        from
                            ctrpt_item
                        where
                            ctrptcd = :ctrptcd
                            and optcd = :optcd
                            and optbranchno = :optbranchno
                    ) ctrptallitem
                where
                    ctrptallitem.itemcd = item_p.itemcd
            ";

            // 削除項目情報と結合し、受診状態を判別
            sql += @"
                    and ctrptallitem.itemcd = delitem.itemcd(+)
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターンの全オプション検査を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// optcd       オプションコード
        /// optbranchno オプション枝番
        /// optname     オプション名
        /// optsname    オプション略称
        /// setclasscd  セット分類コード
        /// </returns>
        public List<dynamic> SelectCtrPtOptList(int ctrPtCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);

            // 指定契約パターンの全オプション検査を取得する
            var sql = @"
                select
                    optcd
                    , optbranchno
                    , optname
                    , optsname
                    , setclasscd
                from
                    ctrpt_opt
                where
                    ctrptcd = :ctrptcd
                order by
                    ctrptcd
                    , optcd
                    , optbranchno
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターンの負担元および負担金額情報を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// seq            SEQ
        /// apdiv          適用元区分
        /// orgcd1         団体コード１
        /// orgcd2         団体コード２
        /// orgname        団体名称
        /// orgsname       団体略称
        /// price          指定オプションコードの負担金額
        /// tax            指定オプションコードの消費税
        /// billprintname  請求書出力名
        /// billprintename 請求書英語出力名
        /// taxflg         消費税負担フラグ
        /// noctr          契約外項目負担フラグ
        /// fraction       契約外項目端数負担フラグ
        /// optburden      オプション負担対象フラグ
        /// orgdiv         (団体テーブル上の)団体種別
        /// ctrorgdiv      (契約パターン負担金額管理テーブル上の)団体種別
        /// limitpriceflg  限度額負担フラグ
        /// </returns>
        public IList<dynamic> SelectCtrPtOrgPrice(int ctrPtCd, string optCd = null, int? optBranchNo = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("apdiv_person", ApDiv.Person);
            param.Add("apdiv_myorg", ApDiv.MyOrg);
            param.Add("orgname_person", ORGNAME_PERSON);
            param.Add("orgname_myorg", ORGNAME_MYORG);

            // オプションコード指定時はキー値として設定する
            if (!string.IsNullOrEmpty(optCd))
            {
                param.Add("optcd", optCd);
                param.Add("optbranchno", optBranchNo);
            }
            else
            {
                param.Add("optcd", null);
                param.Add("optbranchno", null);
            }

            // 負担元および負担金額情報の取得
            var sql = @"
                select
                    ctrpt_org.seq
                    , ctrpt_org.apdiv
                    , ctrpt_org.orgcd1
                    , ctrpt_org.orgcd2
                    , decode(
                        ctrpt_org.apdiv
                        , :apdiv_person
                        , :orgname_person
                        , :apdiv_myorg
                        , :orgname_myorg
                        , org.orgname
                    ) orgname
                    , decode(
                        ctrpt_org.apdiv
                        , :apdiv_person
                        , :orgname_person
                        , :apdiv_myorg
                        , :orgname_myorg
                        , org.orgsname
                    ) orgsname
            ";

            sql += @"
                    , nvl(ctrpt_price.price, 0) price
                    , ctrpt_price.tax
                    , ctrpt_price.billprintname
                    , ctrpt_price.billprintename
                    , ctrpt_org.taxflg
                    , ctrpt_org.noctr
                    , ctrpt_org.fraction
                    , ctrpt_org.limitpriceflg
            ";

            sql += @"
                    , ctrpt_org.addupflg
                    , ctrpt_price.orgdiv ctrorgdiv
            ";

            // オプションの負担対象有無
            sql += @"
                    , (
                        select
                            decode(count(*), 0, 0, 1)
                        from
                            ctrpt_opt
                            , ctrpt_price
                        where
                            ctrpt_price.ctrptcd = ctrpt_org.ctrptcd
                            and ctrpt_price.seq = ctrpt_org.seq
                            and ctrpt_price.price + ctrpt_price.tax != 0
                            and ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd
                            and ctrpt_price.optcd = ctrpt_opt.optcd
                    ) optburden
            ";

            // 団体の結合
            sql += @"
                from
                    ctrpt_price
                    , org
                    , ctrpt_org
                where
                    ctrpt_org.ctrptcd = :ctrptcd
                    and ctrpt_org.orgcd1 = org.orgcd1(+)
                    and ctrpt_org.orgcd2 = org.orgcd2(+)
            ";

            // オプション検査の負担金額情報を結合
            sql += @"
                    and ctrpt_org.ctrptcd = ctrpt_price.ctrptcd(+)
                    and ctrpt_org.seq = ctrpt_price.seq(+)
                    and :optcd = ctrpt_price.optcd(+)
                    and :optbranchno = ctrpt_price.optbranchno(+)
            ";

            // SEQ順に取得
            sql += @"
                order by
                    ctrpt_org.ctrptcd
                    , ctrpt_org.seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定契約パターンにおける指定オプション区分の全負担情報を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="setClassCd">セット分類コード</param>
        /// <param name="cslDivCd">受診区分コード</param>
        /// <param name="gender">受診可能性別</param>
        /// <param name="strAge">受診開始年齢</param>
        /// <param name="endAge">受診終了年齢</param>
        /// <returns>
        /// optcd        オプションコード
        /// optbranchno  オプション枝番
        /// webcolor     webカラー
        /// csname       コース名
        /// optname      オプション名
        /// setcolor     セットカラー
        /// agename      年齢条件
        /// addcondition 追加条件
        /// csldivname   受診区分
        /// gender       受診可能性別
        /// setclassname セット分類名
        /// seq          SEQ
        /// price        負担金額
        /// orgdiv       団体種別
        /// tax          消費税
        /// </returns>
        public List<dynamic> SelectCtrPtPriceOptAll(int ctrPtCd, string csCd, string setClassCd, string cslDivCd, Gender gender, decimal? strAge = null, decimal? endAge = null)
        {
            // 年齢条件の取得
            decimal? wkStrAge;
            decimal? wkEndAge;
            if ((strAge != null) && (endAge != null) && (strAge > endAge))
            {
                wkStrAge = endAge;
                wkEndAge = strAge;
            }
            else
            {
                wkStrAge = strAge ?? ((decimal?)Age.MinValue);
                wkEndAge = endAge ?? ((decimal?)Age.MaxValue);
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("cscd", csCd);
            param.Add("setclasscd", setClassCd);
            param.Add("csldivcd", cslDivCd);
            param.Add("gender", gender);
            param.Add("strage", wkStrAge);
            param.Add("endage", wkEndAge);

            // 指定オプション区分の全オプション検査とその負担金額情報の取得
            var sql = @"
                select
                    optinfo.optcd
                    , optinfo.optbranchno
                    , optinfo.webcolor
                    , optinfo.csname
                    , optinfo.optname
                    , optinfo.setcolor
                    , optinfo.agename
                    , optinfo.addcondition
                    , optinfo.csldivname
                    , optinfo.gender
                    , optinfo.setclassname
                    , optinfo.seq
                    , nvl(ctrpt_price.price, 0) price
                    , ctrpt_price.orgdiv
                    , nvl(ctrpt_price.tax, 0) tax
                from
                    ctrpt_price
            ";

            sql += @"
                    , (
                        select
                            ctrpt_opt.ctrptcd
                            , ctrpt_opt.optcd
                            , ctrpt_opt.optbranchno
                            , ctrpt_opt.optname
                            , ctrpt_opt.setcolor
                            , ctrpt_opt.cscd
                            , ctrpt_opt.csldivcd
                            , ctrpt_opt.gender
                            , ctrpt_opt.setclasscd
                            , ctrpt_optgrp.addcondition
                            , course_p.csname
                            , course_p.maincscd
                            , course_p.webcolor
                            , csldiv.csldivname
                            , setclass.setclassname
                            , ctrpt_org.seq
            ";

            sql += @"
                            , getagename(
                                ctrpt_opt.ctrptcd
                                , ctrpt_opt.optcd
                                , ctrpt_opt.optbranchno
                            ) agename
            ";

            sql += @"
                        from
                            ctrpt_org
                            , setclass
                            , csldiv
                            , course_p
                            , ctrpt_optgrp
                            , ctrpt_opt
                        where
                            ctrpt_opt.ctrptcd = :ctrptcd
                            and ctrpt_opt.ctrptcd = ctrpt_optgrp.ctrptcd
                            and ctrpt_opt.optcd = ctrpt_optgrp.optcd
                            and ctrpt_opt.cscd = course_p.cscd
                            and ctrpt_opt.csldivcd = csldiv.csldivcd(+)
                            and ctrpt_opt.setclasscd = setclass.setclasscd(+)
                            and ctrpt_opt.ctrptcd = ctrpt_org.ctrptcd
            ";

            // コースコード指定時は条件節に加える
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"
                            and ctrpt_opt.cscd = :cscd
                ";
            }

            // セット分類指定時は条件節に加える
            if (!string.IsNullOrEmpty(setClassCd))
            {
                sql += @"
                            and ctrpt_opt.setclasscd = :setclasscd
                ";
            }

            // 受診区分指定時は条件節に加える
            if (!string.IsNullOrEmpty(cslDivCd))
            {
                sql += @"
                            and ctrpt_opt.csldivcd = :csldivcd
                ";
            }

            // 性別指定時は条件節に加える
            if (gender != Gender.Both)
            {
                sql += @"
                            and ctrpt_opt.gender = :gender
                ";
            }

            sql += @"
                            and (
                                exists (
                                    select
                                        ctrptcd
                                    from
                                        ctrpt_optage
                                    where
                                        ctrptcd = ctrpt_opt.ctrptcd
                                        and optcd = ctrpt_opt.optcd
                                        and optbranchno = ctrpt_opt.optbranchno
                                        and strage <= :endage
                                        and endage >= :strage
                                )
                                or not exists (
                                    select
                                        ctrptcd
                                    from
                                        ctrpt_optage
                                    where
                                        ctrptcd = ctrpt_opt.ctrptcd
                                        and optcd = ctrpt_opt.optcd
                                        and optbranchno = ctrpt_opt.optbranchno
                                )
                            )
            ";

            sql += @"
                    ) optinfo
                where
                    optinfo.ctrptcd = ctrpt_price.ctrptcd(+)
                    and optinfo.optcd = ctrpt_price.optcd(+)
                    and optinfo.optbranchno = ctrpt_price.optbranchno(+)
                    and optinfo.seq = ctrpt_price.seq(+)
                order by
                    optinfo.optcd
                    , optinfo.optbranchno
                    , optinfo.seq
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 追加オプション用契約パターンオプション管理テーブルレコードの書き込み処理
        /// </summary>
        /// <param name="mode">処理モード("INS":挿入、"UPD":更新)</param>
        /// <param name="ctrPtCd"></param>
        /// <param name="optCd"></param>
        /// <param name="optBranchNo"></param>
        /// <param name="option">契約パターンオプション</param>
        public void SetCtrPtOpt_Add(string mode, int ctrPtCd, string optCd, int optBranchNo, ContractOption option)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>
            {
                { "ctrptcd", ctrPtCd },
                { "optcd", optCd },
                { "optbranchno", optBranchNo },
                { "optname", "" },
                { "optsname", "" },
                { "cscd", option.CsCd },
                { "setcolor", option.SetColor },
                { "setclasscd", option.SetClassCd },
                { "rsvfracd", option.RsvFraCd },
                { "csldivcd", option.CslDivCd },
                { "gender", option.Gender },
                { "lastrefmonth", option.LastRefMonth },
                { "lastrefcscd", option.LastRefCsCd },
                { "exceptlimit", option.ExceptLimit },
            };
            param["optname"] = Strings.StrConv(Convert.ToString(option.OptName), VbStrConv.Wide);
            if(Strings.StrConv(Convert.ToString(option.OptSName), VbStrConv.Wide).Length > 10)
            {
                param["optsname"] = Strings.StrConv(Convert.ToString(option.OptSName), VbStrConv.Wide).Substring(0, 10);
            } else
            {
                param["optsname"] = Strings.StrConv(Convert.ToString(option.OptSName), VbStrConv.Wide);
            }

            string sql = null;

            // 処理モードごとの処理
            switch (mode)
            {
                case "INS":

                    // 契約パターンオプション管理テーブルレコードの挿入
                    sql = @"
                        insert
                        into ctrpt_opt(
                            ctrptcd
                            , optcd
                            , optbranchno
                            , optname
                            , optsname
                            , cscd
                            , setcolor
                            , setclasscd
                            , rsvfracd
                            , csldivcd
                            , gender
                            , lastrefmonth
                            , lastrefcscd
                            , exceptlimit
                        )
                    ";

                    sql += @"
                        values (
                            :ctrptcd
                            , :optcd
                            , :optbranchno
                            , :optname
                            , :optsname
                            , :cscd
                            , :setcolor
                            , :setclasscd
                            , :rsvfracd
                            , :csldivcd
                            , :gender
                            , :lastrefmonth
                            , :lastrefcscd
                            , :exceptlimit
                        )
                    ";

                    break;

                case "UPD":

                    // 契約パターンオプション管理テーブルレコードの更新
                    sql = @"
                        update ctrpt_opt
                        set
                            optname = :optname
                            , optsname = :optsname
                            , cscd = :cscd
                            , setcolor = :setcolor
                            , setclasscd = :setclasscd
                            , rsvfracd = :rsvfracd
                            , csldivcd = :csldivcd
                            , gender = :gender
                            , lastrefmonth = :lastrefmonth
                            , lastrefcscd = :lastrefcscd
                            , exceptlimit = :exceptlimit
                        where
                            ctrptcd = :ctrptcd
                            and optcd = :optcd
                            and optbranchno = :optbranchno
                    ";

                    break;
            }

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン負担金額管理テーブルレコードの書き込み処理
        /// </summary>
        /// <param name="mode">処理モード("INS":挿入、"UPD":更新、"DEL":削除)</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="prices">契約パターン負担金額情報</param>
        /// <returns>
        /// 0:正常終了
        /// 1:追加オプション負担金テーブルで参照されているレコードを削除しようとした
        /// </returns>
        public int SetCtrPtPrice(string mode, int ctrPtCd, string optCd, int optBranchNo, IList<ContractPrice> prices)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("optcd", optCd);
            param.Add("optbranchno", optBranchNo);
            param.Add("seq", 0);
            param.Add("price", 0);
            param.Add("orgdiv", 0);
            param.Add("tax", 0);
            param.Add("billprintname", "");
            param.Add("billprintename", "");

            // 契約パターン負担金額管理テーブル挿入用のSQLステートメント作成
            string insertSql = @"
                insert
                into ctrpt_price(
                    ctrptcd
                    , seq
                    , optcd
                    , optbranchno
                    , price
                    , orgdiv
                    , tax
                    , billprintname
                    , billprintename
                )
                values (
                    :ctrptcd
                    , :seq
                    , :optcd
                    , :optbranchno
                    , :price
                    , :orgdiv
                    , :tax
                    , :billprintname
                    , :billprintename
                )
            ";

            // 契約パターン負担金額管理テーブル更新用のSQLステートメント作成
            string updateSql = @"
                update ctrpt_price
                set
                    price = :price
                    , orgdiv = :orgdiv
                    , tax = :tax
                    , billprintname = :billprintname
                    , billprintename = :billprintename
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
                    and seq = :seq
            ";

            //    // 契約パターン負担金額管理テーブル削除用のSQLステートメント作成
            string deleteSql = @"
                delete ctrpt_price
                where
                    ctrptcd = :ctrptcd
                    and optcd = :optcd
                    and optbranchno = :optbranchno
                    and seq = :seq
            ";

            try
            {
                // 各配列値の挿入処理
                for (var i = 0; i < prices.Count; i++)
                {
                    param["seq"] = prices[i].Seq;
                    param["price"] = string.IsNullOrEmpty(prices[i].Price) ? "0" : prices[i].Price;
                    param["orgdiv"] = prices[i].OrgDiv;
                    param["tax"] = string.IsNullOrEmpty(prices[i].Tax) ? "0" : prices[i].Tax;
                    param["billprintname"] = Strings.StrConv(prices[i].BillPrintName, VbStrConv.Wide);
                    param["billprintename"] = prices[i].BillPrintEName;

                    // 動作モードごとの処理
                    switch (mode)
                    {
                        case "INS":

                            // 挿入処理の場合
                            connection.Execute(insertSql, param);

                            break;

                        case "UPD":

                            // 更新処理の場合
                            int recordCount = connection.Execute(updateSql, param);

                            // 更新レコード件数が増加していない(即ち更新されていない)場合は挿入処理を行う
                            if (recordCount == 0)
                            {
                                connection.Execute(insertSql, param);
                            }

                            break;

                        case "DEL":

                            // 削除処理の場合
                            connection.Execute(deleteSql, param);

                            break;
                    }
                }
            }
            catch (OracleException ex)
            {
                // 子レコード存在による削除エラー時は、戻り値を設定して正常終了させる
                if (ex.Number == 2292)
                {
                    return 1;
                }

                throw ex;
            }

            // 戻り値の設定
            return 0;
        }

        /// <summary>
        /// 受診情報の契約パターンコード付け替え
        /// </summary>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="curCtrPtCd">(現)契約パターンコード</param>
        /// <param name="newCtrPtCd">(新)契約パターンコード</param>
        public void UpdateConsultCtrPt(string refOrgCd1, string refOrgCd2, int curCtrPtCd, int newCtrPtCd)
        {
            // パラメーターの設定
            var param = new OracleDynamicParameters();
            param.Add("reforgcd1", dbType: OracleDbType.Varchar2, value: refOrgCd1.Trim(), direction: ParameterDirection.Input);
            param.Add("reforgcd2", dbType: OracleDbType.Varchar2, value: refOrgCd2.Trim(), direction: ParameterDirection.Input);
            param.Add("curctrptcd", dbType: OracleDbType.Decimal, value: curCtrPtCd, direction: ParameterDirection.Input);
            param.Add("newctrptcd", dbType: OracleDbType.Decimal, value: newCtrPtCd, direction: ParameterDirection.Input);

            var sql = @"
                begin
                    contractpackage.updateconsultctrpt(
                        :reforgcd1
                        , :reforgcd2
                        , :curctrptcd
                        , :newctrptcd
                    );
                end;
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約管理テーブルレコードの帳票コードを更新する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="reportCd">帳票コード</param>
        public void UpdateCtrMng(string orgCd1, string orgCd2, int ctrPtCd, string reportCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("ctrptcd", ctrPtCd);
            param.Add("reportcd", reportCd);

            // 契約管理テーブルレコードの更新
            var sql = @"
                update ctrmng
                set
                    reportcd = :reportcd
                where
                    orgcd1 = :orgcd1
                    and orgcd2 = :orgcd2
                    and ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンテーブルレコードを更新する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="ctrpt">契約パターン情報</param>
        public void UpdateCtrPt(int ctrPtCd, ContractPattern ctrpt)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("strdate", ctrpt.StrDate);
            param.Add("enddate", ctrpt.EndDate);
            param.Add("taxfraction", ctrpt.TaxFraction);
            param.Add("agecalc", ctrpt.AgeCalc);
            param.Add("csname", ctrpt.CsName);
            param.Add("csename", ctrpt.CsEName);
            param.Add("cslmethod", ctrpt.CslMethod);
            param.Add("limitrate", ctrpt.LimitRate);
            param.Add("limittaxflg", ctrpt.LimitTaxFlg);
            param.Add("limitprice", ctrpt.LimitPrice);

            // 契約パターンテーブルレコードの更新
            var sql = @"
                update ctrpt
                set
                    strdate = " + (ctrpt.StrDate !=null ? ":" : "") + @"strdate
                    , enddate = " + (ctrpt.EndDate !=null ? ":" : "") + @"enddate
                    , taxfraction = " + (ctrpt.TaxFraction != null ? ":" : "") + @"taxfraction
                    , agecalc = " + (ctrpt.AgeCalc != null ? ":" : "") + @"agecalc
                    , csname = " + (ctrpt.CsName != null ? ":" : "") + @"csname
                    , csename = " + (ctrpt.CsEName !=null ? ":" : "") + @"csename
                    , cslmethod = " + (ctrpt.CslMethod != null ? ":" : "") + @"cslmethod
                    , limitrate = " + (ctrpt.LimitRate !=null ? ":" : "") + @"limitrate
                    , limittaxflg = " + (ctrpt.LimitTaxFlg != null ? ":" : "") + @"limittaxflg
                    , limitprice = " + (ctrpt.LimitPrice != null ? ":" : "") + @"limitprice
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンテーブルレコードの年齢起算日を更新する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="ageCalc">年齢起算日</param>
        public void UpdateCtrPt_AgeCalc(int ctrPtCd, string ageCalc)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("agecalc", ageCalc);

            // 契約パターンテーブルレコードの更新
            var sql = @"
                update ctrpt
                set
                    agecalc = :agecalc
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンテーブルレコードの税端数区分を更新する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="taxFraction">税端数区分</param>
        public void UpdateCtrPt_Fraction(int ctrPtCd, int taxFraction)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("taxfraction", taxFraction);

            // 契約パターンテーブルレコードの更新
            var sql = @"
                update ctrpt
                set
                    taxfraction = :taxfraction
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターンテーブルレコードの契約期間を更新する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        public void UpdateCtrPt_Period(int ctrPtCd, DateTime? strDate, DateTime? endDate)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("strdate", strDate);
            param.Add("enddate", endDate);

            // 契約パターンテーブルレコードの更新
            var sql = @"
                update ctrpt
                set
            ";

            // 契約開始年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
            if (strDate != null)
            {
                sql += @"
                    strdate = :strdate
                ";
            }
            else
            {
                sql += @"
                    strdate = strdate
                ";
            }

            // 契約終了年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
            if (endDate != null)
            {
                sql += @"
                    , enddate = :enddate
                ";
            }
            else
            {
                sql += @"
                    , enddate = enddate
                ";
            }

            sql += @"
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン負担元管理テーブルにおける団体コードの更新
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burden">負担情報</param>
        public void UpdateCtrPtOrg(int ctrPtCd, ContractBurdens burden)
        {
            UpdateCtrPtOrg(ctrPtCd, new List<ContractBurdens> { burden });
        }

        /// <summary>
        /// 契約パターン負担元管理テーブルにおける団体コードの更新
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burdens">負担情報</param>
        public void UpdateCtrPtOrg(int ctrPtCd, IList<ContractBurdens> burdens)
        {
            // 契約パターン負担元管理テーブルレコード更新のSQLステートメント作成
            var sql = @"
                update ctrpt_org
                set
                    orgcd1 = :orgcd1
                    , orgcd2 = :orgcd2
                    , taxflg = :taxflg
                where
                    ctrptcd = :ctrptcd
                    and seq = :seq
            ";
            
            // パラメーター値設定
            var paramArray = new List<Dictionary<string, object>>();
            for (var i = 0; i < burdens.Count; i++)
            {
                var param = new Dictionary<string, object>();
                param.Add("orgcd1", burdens[i].OrgCd1);
                param.Add("orgcd2", burdens[i].OrgCd2);
                param.Add("taxflg", burdens[i].TaxFlg);
                param.Add("ctrptcd", ctrPtCd);
                param.Add("seq", burdens[i].Seq);
                paramArray.Add(param);
            }

            connection.Execute(sql, paramArray);
        }

        /// <summary>
        /// 契約パターン負担元管理テーブルにおける限度額情報の更新
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seqOrg">対象負担元SEQ</param>
        /// <param name="seqBdnOrg">減算した金額の負担元SEQ</param>
        public void UpdateCtrPtOrgLimit(int ctrPtCd, int? seqOrg, int? seqBdnOrg)
        {
            // キー及び配列パラメータの追加
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", ctrPtCd);
            param.Add("seqorg", seqOrg);
            param.Add("seqbdnorg", seqBdnOrg);

            // 契約パターン負担元管理テーブル更新
            var sql = @"
                update ctrpt_org
                set
                    limitpriceflg = decode(seq, :seqorg, 0, :seqbdnorg, 1, '')
                where
                    ctrptcd = :ctrptcd
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// 契約パターン負担元管理テーブルにおける契約外負担情報の更新
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burdens">負担情報</param>
        public void UpdateCtrPtOrgNoCtr(int ctrPtCd, IList<ContractBurdens> burdens)
        {
            // 契約パターン負担元管理テーブル更新
            var sql = @"
                update ctrpt_org
                set
                    noctr = :noctr
                    , fraction = :fraction
                where
                    ctrptcd = :ctrptcd
                    and seq = :seq
            ";

            // パラメーター値設定
            var paramArray = new List<Dictionary<string, object>>();
            for (var i = 0; i < burdens.Count; i++)
            {
                var param = new Dictionary<string, object>
                {
                    { "ctrptcd", ctrPtCd },
                    { "noctr", burdens[i].Noctr },
                    { "fraction", burdens[i].Fraction },
                    { "seq", burdens[i].Seq },
                };
                paramArray.Add(param);
            }

            connection.Execute(sql, paramArray);
        }
    }
}
