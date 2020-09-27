using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Contract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 契約情報制御用データアクセスオブジェクト
    /// </summary>
    public class ContractControlDao : AbstractDao
    {
        /// <summary>
        /// 契約情報データアクセスオブジェクト
        /// </summary>
        readonly ContractDao contractDao;

        /// <summary>
        /// コース情報データアクセスオブジェクト
        /// </summary>
        readonly CourseDao courseDao;

        /// <summary>
        /// 汎用情報データアクセスオブジェクト
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// 団体情報データアクセスオブジェクト
        /// </summary>
        readonly OrganizationDao organizationDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="contractDao">契約情報データアクセスオブジェクト</param>
        /// <param name="courseDao">コース情報データアクセスオブジェクト</param>
        /// <param name="freeDao">汎用情報データアクセスオブジェクト</param>
        /// <param name="organizationDao">団体情報データアクセスオブジェクト</param>
        public ContractControlDao(IDbConnection connection, ContractDao contractDao, CourseDao courseDao, FreeDao freeDao, OrganizationDao organizationDao) : base(connection)
        {
            this.contractDao = contractDao;
            this.courseDao = courseDao;
            this.freeDao = freeDao;
            this.organizationDao = organizationDao;
        }

        /// <summary>
        /// 金額情報のチェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="price">金額</param>
        /// <returns>エラーメッセージ</returns>
        string CheckCtrPtPrice(string itemName, string[] price)
        {
            string message = null; // メッセージ

            // 負担金額のチェック
            for (var i = 0; i < price.Length; i++)
            {
                message = WebHains.CheckNumeric(itemName, price[i].Trim(), (int)LengthConstants.LENGTH_CTRPT_PRICE_PRICE);
                if (!string.IsNullOrEmpty(message))
                {
                    break;
                }
            }

            return message;
        }

        /// <summary>
        /// 契約情報のコピー処理
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <returns>
        /// 0:正常終了
        /// 1:契約期間が同一コースの他契約情報と重複
        /// 2:契約団体自身が参照契約情報の負担元として存在
        /// </returns>
        public int Copy(string orgCd1, string orgCd2, string refOrgCd1, string refOrgCd2, int ctrPtCd, DateTime? strDate, DateTime? endDate)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // 参照先団体契約情報の指定契約パターンにおける参照・コピー処理可否を取得する
                List<dynamic> data = contractDao.SelectCtrMngRefer(orgCd1, orgCd2, refOrgCd1, refOrgCd2, ctrPtCd: ctrPtCd);
                if (data.Count <= 0)
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
                    if (contractDao.CheckContractPeriod(orgCd1, orgCd2, data[0].CSCD, 0, strDate, endDate))
                    {
                        ret = 1;
                        break;
                    }

                    // 契約団体が参照先契約団体契約情報の負担元として存在する場合
                    if (Convert.ToString(data[0].EXISTBDN) == "1")
                    {
                        ret = 2;
                        break;
                    }

                    // 次回発番契約パターンコードを取得する
                    int lngNewCtrPtCd = contractDao.IncreaseCtrPtCd();

                    // 契約パターンテーブルの複写
                    contractDao.CopyCtrPt(ctrPtCd, lngNewCtrPtCd, strDate, endDate);

                    // 契約パターンの複写
                    contractDao.Copy(ctrPtCd, lngNewCtrPtCd);

                    // 指定団体、コースの、今発番した契約パターンコードを持つ契約情報を作成する
                    contractDao.InsertCtrMng(orgCd1, orgCd2, data[0].CSCD, "", "", lngNewCtrPtCd);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 参照中契約情報のコピー処理
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// 0:正常終了
        /// 1:契約団体自身が参照契約情報の負担元として存在
        /// </returns>
        public int CopyReferredContract(string orgCd1, string orgCd2, string refOrgCd1, string refOrgCd2, int ctrPtCd)
        {
            int ret = 0; // 関数戻り値

            using (var ts = new TransactionScope())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // 参照先団体契約情報の指定契約パターンにおける参照・コピー処理可否を取得する
                List<dynamic> data = contractDao.SelectCtrMngRefer(orgCd1, orgCd2, refOrgCd1, refOrgCd2, ctrPtCd: ctrPtCd);
                if (data.Count <= 0)
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 契約団体が参照先契約団体契約情報の負担元として存在する場合
                    if (1 == data[0].EXISTBDN)
                    {
                        ret = 1;     // 本メソッドにおいては本状態が発生していると請求周りが機能しなくなるので起こりえないのだが、一応
                        break;
                    }

                    // 次回発番契約パターンコードを取得する
                    int lngNewCtrPtCd = contractDao.IncreaseCtrPtCd();

                    // 契約パターンテーブルの複写
                    contractDao.CopyCtrPt(ctrPtCd, lngNewCtrPtCd);

                    // 契約パターンの複写
                    contractDao.Copy(ctrPtCd, lngNewCtrPtCd);

                    // 指定団体、契約パターンの契約情報を削除する
                    contractDao.DeleteCtrMng(orgCd1, orgCd2, ctrPtCd);

                    // 指定団体、コースの、今発番した契約パターンコードを持つ契約情報を作成する
                    contractDao.InsertCtrMng(orgCd1, orgCd2, data[0].CSCD, "", "", lngNewCtrPtCd);

                    // 現状態で新契約パターンを参照している全契約情報の契約期間内における、全ての受診情報の契約パターン値を付け替える
                    contractDao.UpdateConsultCtrPt(orgCd1, orgCd2, ctrPtCd, lngNewCtrPtCd);

                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    ts.Complete();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約情報の削除処理
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// 0:正常終了
        /// 1:他団体からの被参照契約情報である
        /// 2:契約期間内に受診情報が存在
        /// </returns>
        public int DeleteContract(string orgCd1, string orgCd2, int ctrPtCd)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                while (true)
                {
                    // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                    if (!contractDao.LockCtrPt(ctrPtCd))
                    {
                        break;     // ←すでに存在しないならば処理を終了させる
                    }

                    // 指定団体、コースの契約情報を参照している契約情報が存在するかをチェック
                    if (contractDao.CheckContractReferred(orgCd1, orgCd2, ctrPtCd))
                    {
                        ret = 1;
                        break;
                    }

                    // 契約期間内に受診情報が存在するかをチェック
                    if (contractDao.CheckConsultIntoContract(ctrPtCd) != null)
                    {
                        ret = 2;
                        break;
                    }

                    // 指定団体、契約パターンの契約情報を削除する
                    contractDao.DeleteCtrMng(orgCd1, orgCd2, ctrPtCd);

                    // 契約パターンを削除する
                    contractDao.DeleteCtrPt(ctrPtCd);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// オプションの削除処理
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>
        /// 0:正常終了
        /// 1:受診オプション管理テーブルで参照されているレコードを削除しようとした
        /// 2:追加オプション負担金テーブルで参照されているレコードを削除しようとした
        /// 3:webオプション検査テーブルで参照されているレコードを削除しようとした
        /// </returns>
        public int DeleteOption(string orgCd1, string orgCd2, int ctrPtCd, string optCd, int optBranchNo)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // 指定契約パターン、オプションコードのオプション検査情報を削除する
                ret = contractDao.DeleteCtrPtOpt(ctrPtCd, optCd, optBranchNo);

                // 指定契約パターン、オプションコードのオプショングループ情報を削除する
                if (ret == 0)
                {
                    contractDao.DeleteCtrPtOptGrp(ctrPtCd, optCd);
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 負担情報の抽出
        /// </summary>
        /// <param name="burdens">負担情報</param>
        /// <param name="recreateSeq">再発番フラグ(true指定時はSEQの再発番を行う)</param>
        /// <returns>抽出後の負担情報</returns>
        IList<ContractBurdens> GetCtrPtOrg(IList<ContractBurdens> burdens, bool recreateSeq = false)
        {
            var extractedBurdens = new List<ContractBurdens>();

            for (var i = 0; i < burdens.Count; i++)
            {
                bool allocate = false; // 割り当て対象フラグ

                // 適用元区分による処理振り分け
                switch ((ApDiv)Convert.ToInt32(burdens[i].Apdiv))
                {
                    case ApDiv.Person:
                    case ApDiv.MyOrg:

                        // 個人負担・自社負担の場合
                        // そのまま割り当て対象とする
                        allocate = true;
                        break;

                    default:

                        // 指定団体負担の場合
                        // 団体コードが存在すれば割り当て対象とする
                        allocate = ((burdens[i].OrgCd1 != null) || (burdens[i].OrgCd2 != null));
                        break;
                }

                // 割り当て対象の場合
                if (allocate)
                {

                    ContractBurdens rec = burdens[i];

                    // 再発番フラグ指定時、SEQは 1 から順番に付番(未指定時は引数値をそのまま適用)
                    if (recreateSeq)
                    {
                        rec.Seq = extractedBurdens.Count + 1;
                    }

                    // 作業用のリストに追加する
                    extractedBurdens.Add(rec);
                }
            }

            // 戻り値の設定
            return extractedBurdens;
        }

        /// <summary>
        /// 新しい契約情報を作成する
        /// </summary>
        /// <param name="data">契約情報</param>
        /// <returns>
        /// >0 作成された契約情報の契約パターンコード
        /// 0 契約団体の現契約情報と契約期間が重複
        /// </returns>
        public int InsertContract(Contract data)
        {
            // 更新対象負担情報の抽出
            IList<ContractBurdens> burdens = GetCtrPtOrg(data.Burdens, true);

            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                string orgCd1 = Convert.ToString(data.OrgCd1);
                string orgCd2 = Convert.ToString(data.OrgCd2);
                string csCd = Convert.ToString(data.CsCd);

                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 契約開始年月日の取得
                var dtmStrDate = Convert.ToDateTime(data.StrDate);

                // 契約終了年月日の取得
                var dtmEndDate = Convert.ToDateTime(data.EndDate);

                while (true)
                {
                    // 同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
                    if (contractDao.CheckContractPeriod(orgCd1, orgCd2, csCd, 0, dtmStrDate, dtmEndDate))
                    {
                        ret = 0;
                        break;
                    }

                    // 次に発番する契約パターンコードを取得する
                    int ctrPtCd = contractDao.IncreaseCtrPtCd();

                    // コース名取得
                    string csName = null;
                    if (data.CsName == null)
                    {
                        dynamic course = courseDao.SelectCourse(csCd);
                        if (course != null)
                        {
                            csName = course.CSNAME;
                        }
                    }
                    else
                    {
                        csName = Convert.ToString(data.CsName);
                    }

                    
                    string ageCalc = "";
                    if (data.AgeCalc != null)
                    {
                        ageCalc = Convert.ToString(data.AgeCalc);
                    }
                    int taxFraction = 1;
                    if (data.TaxFraction != null)
                    {
                        taxFraction = Convert.ToInt32(data.TaxFraction);
                    }

                    // 契約パターンテーブル挿入
                    contractDao.InsertCtrPt(ctrPtCd, dtmStrDate, dtmEndDate, ageCalc, taxFraction, csName);

                    // 契約管理テーブル挿入
                    contractDao.InsertCtrMng(orgCd1, orgCd2, csCd, "", "", ctrPtCd);

                    // 年齢区分情報があれば契約パターン年齢区分テーブル挿入
                    if (data.Ages != null)
                    {
                        contractDao.InsertCtrPtAge(ctrPtCd, data.Ages);
                    }

                    // 契約パターン負担元管理テーブル挿入
                    contractDao.InsertCtrPtOrg(ctrPtCd, burdens);

                    // 正常終了した場合は契約パターンコードを返す
                    ret = ctrPtCd;
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret > 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        //
        //  機能　　 : 契約情報の参照
        //
        //  引数　　 : (In)     strOrgCd1     団体コード1
        //  　　　　   (In)     strOrgCd2     団体コード2
        //  　　　　   (In)     strRefOrgCd1  参照先団体コード1
        //  　　　　   (In)     strRefOrgCd2  参照先団体コード2
        //  　　　　   (In)     lngCtrPtCd    契約パターンコード
        //
        //  戻り値　 : 0   正常終了
        //  　　　　   1   参照先団体が契約団体自身の契約を参照している
        //  　　　　   2   参照先団体の契約情報がすでに契約団体自身から参照されている
        //  　　　　   3   契約団体の現契約情報と契約期間が重複
        //  　　　　   4   契約団体自身が参照契約情報の負担元として存在
        //  　　　　   <0  異常終了
        //
        //  備考　　 :
        //
        //
        /// <summary>
        /// 契約情報の参照
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="refOrgCd1">参照先団体コード1</param>
        /// <param name="refOrgCd2">参照先団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// 0: 正常終了
        /// 1: 参照先団体が契約団体自身の契約を参照している
        /// 2: 参照先団体の契約情報がすでに契約団体自身から参照されている
        /// 3: 契約団体の現契約情報と契約期間が重複
        /// 4: 契約団体自身が参照契約情報の負担元として存在
        /// </returns>
        public int Refer(string orgCd1, string orgCd2, string refOrgCd1, string refOrgCd2, int ctrPtCd)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // 参照先団体契約情報の指定契約パターンにおける参照・コピー処理可否を取得する
                List<dynamic> data = contractDao.SelectCtrMngRefer(orgCd1, orgCd2, refOrgCd1, refOrgCd2, ctrPtCd: ctrPtCd);
                if (data.Count <= 0)
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 契約団体自身の契約情報を参照している場合はエラー
                    // (※本フラグ成立時は必ず参照済みフラグ・契約期間重複フラグも成立するため、先にチェックする必要がある)
                    if (data[0].ORGEQUALS > 0)
                    {
                        ret = 1;
                        break;
                    }

                    // すでに契約団体自身から参照されている場合はエラー
                    // (※本フラグ成立時は必ず契約期間重複フラグも成立するため、先にチェックする必要がある)
                    if (data[0].REFERRED > 0)
                    {
                        ret = 2;
                        break;
                    }

                    // 契約期間が重複する場合はエラー
                    if (data[0].OVERLAP > 0)
                    {
                        ret = 3;
                        break;
                    }

                    // 契約団体が参照先契約団体契約情報の負担元として存在する場合
                    if (data[0].EXISTBDN > 0)
                    {
                        ret = 4;
                        break;
                    }

                    // 契約管理テーブルレコードの挿入
                    contractDao.InsertCtrMngRefer(orgCd1, orgCd2, refOrgCd1, refOrgCd2, ctrPtCd);

                    ret = 0;
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約情報の参照解除処理
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// 0: 正常終了
        /// 1: 契約期間内に受診情報が存在
        /// </returns>
        public int Release(string orgCd1, string orgCd2, int ctrPtCd)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                while (true)
                {
                    // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                    if (!contractDao.LockCtrPt(ctrPtCd))
                    {
                        break;     // ←すでに存在しないならば処理を終了させる
                    }

                    // 契約期間内に受診情報が存在するかをチェック
                    if (contractDao.CheckConsultIntoContract(ctrPtCd, orgCd1, orgCd2) != null)
                    {
                        ret = 1;
                        break;
                    }

                    // 指定団体、契約パターンの契約情報を削除する
                    contractDao.DeleteCtrMng(orgCd1, orgCd2, ctrPtCd);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 追加オプションの書き込み処理
        /// </summary>
        /// <param name="mode">処理モード("INS":挿入、"UPD":更新)</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <param name="data">契約オプション情報</param>
        /// <returns>
        /// 0: 正常終了
        /// 1: 負担元情報が変更されている
        /// 2: 調整金額が設定されてある負担元の負担金額をクリアしようとした
        /// 3: 同一オプションコードのオプション検査が存在
        /// </returns>
        public int SetAddOption(string mode, int ctrPtCd, string orgCd1, string orgCd2, string optCd, int optBranchNo, ContractOptions data)
        {
            int ret = 0; // 関数戻り値

            // 処理モードのチェック
            mode = mode.ToUpper();
            if ((mode != "INS") && (mode != "UPD"))
            {
                throw new Exception("処理モードの値が不正です。");
            }

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {                    
                    // 負担元情報のチェック(引数指定された団体とデータベース上のそれが完全一致しているか)
                    if (!contractDao.CheckCtrPtOrg(ctrPtCd, data.Burdens))
                    {
                        ret = 1;
                        break;
                    }

                    // 契約パターンオプション管理テーブルレコードの存在を確認する
                    dynamic ctrptopt = contractDao.SelectCtrPtOpt(ctrPtCd, optCd, optBranchNo);

                    // 各モードごとの処理分岐
                    switch (mode)
                    {
                        case "INS":

                            // 新規モードの場合
                            // レコードが存在していればエラー
                            if (ctrptopt != null)
                            {
                                ret = 3;
                            }

                            break;

                        case "UPD":

                            // 更新モードの場合
                            // レコードの存在有無によるモード変更を行う
                            if (ctrptopt == null)
                            {
                                mode = "INS";
                            }

                            break;
                    }

                    // 契約パターンオプショングループテーブルの更新
                    contractDao.MergeCtrPtOptGrp(ctrPtCd, optCd, data.Option);

                    // 契約パターンオプション管理テーブルの書き込み
                    contractDao.SetCtrPtOpt_Add(mode, ctrPtCd, optCd, optBranchNo, data.Option);

                    // 契約パターンオプション年齢条件テーブル削除
                    contractDao.DeleteCtrPtOptAge(ctrPtCd, optCd, optBranchNo);

                    // 受診対象年齢が存在する場合
                    if (data.OptAges != null && data.OptAges.Length > 0)
                    {
                        // 契約パターンオプション年齢条件テーブル挿入
                        contractDao.InsertCtrPtOptAge(ctrPtCd, optCd, optBranchNo, data.OptAges);
                    }

                    var prices = data.OrgPrices;

                    // 消費税の計算
                    while (true)
                    {
                        // 契約パターンテーブルを読み、契約開始日を取得
                        dynamic ctrpt = contractDao.SelectCtrPt(ctrPtCd);

                        // 汎用テーブルを読み、税率を取得
                        List < dynamic > frees = freeDao.SelectFree(0, "TAX");
                        if (frees == null || frees.Count == 0)
                        {
                            break;
                        }

                        // 汎用日付未設定時は計算しない
                        if (frees[0].FREEDATE == null)
                        {
                            break;
                        }

                        // 汎用日付と契約開始日との関係よりいずれの税率を使用するかを判定
                        DateTime strDate = Convert.ToDateTime(ctrpt.STRDATE);
                        DateTime freeDate = Convert.ToDateTime(frees[0].FREEDATE);
                        string strTaxRate = (strDate >= freeDate ? frees[0].FREEFIELD2 : frees[0].FREEFIELD1);

                        // 設定値が不正ならば計算しない
                        if (!decimal.TryParse(strTaxRate, out decimal taxRate))
                        {
                            break;
                        }

                        // 設定値が不正ならば計算しない
                        if (taxRate < 0)
                        {
                            break;
                        }

                        // 消費税未設定ならば負担金額より消費税を計算する(端数は切り捨て)
                        for (var i = 0; i < prices.Length; i++)
                        {
                            if (string.IsNullOrEmpty(prices[i].Price))
                            {
                                prices[i].Price = "0";
                            }
                            if (string.IsNullOrEmpty(prices[i].Tax) || prices[i].Tax == "0")
                            {
                                int price = Convert.ToInt32(prices[i].Price);
                                prices[i].Tax = Convert.ToString(Math.Truncate(price * Convert.ToDecimal(taxRate)));
                            }
                        }

                        break;
                    }

                    // 契約パターン負担金額管理テーブルの書き込み
                    if (contractDao.SetCtrPtPrice(mode, ctrPtCd, optCd, optBranchNo, prices) != 0)
                    {
                        ret = 2;
                        break;
                    }

                    // 契約パターン内グループテーブル削除
                    contractDao.DeleteCtrPtGrp(ctrPtCd, optCd, optBranchNo);

                    // グループが存在する場合
                    if (data.GroupCds != null && data.GroupCds.Length > 0)
                    {
                        // 契約パターン内グループテーブル挿入
                        contractDao.InsertCtrPtGrp(ctrPtCd, optCd, optBranchNo, data.GroupCds);
                    }

                    // 契約パターン内検査項目テーブル削除
                    contractDao.DeleteCtrPtItem(ctrPtCd, optCd, optBranchNo);

                    // 検査項目が存在する場合
                    if (data.ItemCds != null && data.ItemCds.Length > 0)
                    {
                        // 契約パターン内検査項目テーブル挿入
                        contractDao.InsertCtrPtItem(ctrPtCd, optCd, optBranchNo, data.ItemCds);
                    }

                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約情報の分割
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="splitDate">分割日</param>
        /// <returns>
        /// 0: 正常終了
        /// 1: 契約情報分割不能
        /// 2: 分割日指定に誤り
        /// 3: 分割日以降に受付情報あり
        /// </returns>
        public int Split(string orgCd1, string orgCd2, int ctrPtCd, DateTime splitDate)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 指定団体・契約パターンを参照している全ての団体に対する他トランザクションからの操作を防ぐため、団体テーブルレコードをロックする
                // (最低でも指定団体の契約管理情報のレコードが1つ存在するべきなので、ここではエラーを発生させる)
                if (!contractDao.LockOrgReferringContract(orgCd1, orgCd2, ctrPtCd))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 指定団体・契約パターンの契約情報を参照している全ての契約情報を持つ受診情報テーブルレコードのロック
                // (契約情報より先に受診情報に対してロックを適用する。一般的な受診情報更新処理では受診情報のほうを先にロックしているため。)
                contractDao.LockConsultReferringContract(orgCd1, orgCd2, ctrPtCd);

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 契約管理情報の読み込み
                    dynamic ctrMng = contractDao.SelectCtrMng(orgCd1, orgCd2, ctrPtCd);

                    DateTime strDate = Convert.ToDateTime(ctrMng.STRDATE);
                    DateTime endDate = Convert.ToDateTime(ctrMng.ENDDATE);

                    // 契約開始・終了日が等しい場合は分割できない
                    if (strDate.Equals(endDate))
                    {
                        ret = 1;
                        break;
                    }

                    // 分割日が契約期間に含まれない場合は分割できない
                    if ((splitDate < strDate) || (splitDate >= endDate))
                    {
                        ret = 2;
                        break;
                    }

                    // 以降に受付情報があれば分割不可
                    if (contractDao.CheckConsultIntoContract_Rpt(ctrPtCd, splitDate.AddDays(1), endDate))
                    {
                        ret = 3;
                        break;
                    }

                    // 現契約パターンの契約終了日を分割日で更新する
                    contractDao.UpdateCtrPt_Period(ctrPtCd, strDate, splitDate);

                    // 次回発番契約パターンコードを取得する
                    int newCtrPtCd = contractDao.IncreaseCtrPtCd();

                    // 契約パターンテーブルの複写(契約開始日は分割日の翌日、契約終了日は前契約パターンの契約終了日とする
                    contractDao.CopyCtrPt(ctrPtCd, newCtrPtCd, splitDate.AddDays(1), endDate);

                    // 現契約パターンの内容を新契約パターンの契約情報として複写する
                    contractDao.Copy(ctrPtCd, newCtrPtCd);

                    // 指定団体の現契約パターンを参照している全団体に対し、新契約パターンの参照情報を作成する
                    contractDao.InsertCtrMngAllRefer(orgCd1, orgCd2, ctrPtCd, newCtrPtCd);

                    // 現状態で新契約パターンを参照している全契約情報の契約期間内における、全ての受診情報の契約パターン値を付け替える
                    contractDao.UpdateConsultCtrPt(orgCd1, orgCd2, ctrPtCd, newCtrPtCd);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 年齢起算日・年齢区分を更新する
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="ageCalc">年齢起算日</param>
        /// <param name="ages">年齢区分情報</param>
        public void UpdateAgeDiv(string orgCd1, string orgCd2, int ctrPtCd, string ageCalc, IList<ContractAges> ages)
        {
            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // 契約パターンテーブルの年齢起算日を更新
                contractDao.UpdateCtrPt_AgeCalc(ctrPtCd, ageCalc);

                // 契約パターン年齢区分テーブル削除
                contractDao.DeleteCtrPtAge(ctrPtCd);

                // 年齢区分情報があれば契約パターン年齢区分テーブル挿入
                if (ages != null)
                {
                    contractDao.InsertCtrPtAge(ctrPtCd, ages);
                }

                transaction.Commit();
            }
        }

        /// <summary>
        /// 契約情報の更新（負担元情報・負担金額情報）をする
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">負担情報</param>
        /// <param name="refOrgName">参照団体名称(負担元団体として指定されたが本パターンを参照している団体の名称)</param>
        /// <returns>
        /// 0:正常終了
        /// 1: コース基本項目以外の負担を行う負担元情報を削除しようとした
        /// 2: 追加オプション負担金テーブルで参照されている負担金額を削除しようとした
        /// 3: この契約情報を参照している契約団体が負担元として存在
        /// 4: 受診情報で参照されているレコードを削除しようとした
        /// 5: 限度額負担の設定が行われている負担元を削除しようとした
        /// </returns>
        public int UpdateContract(string orgCd1, string orgCd2, int ctrPtCd, Contract data, out string[] refOrgName)
        {
            int ret = 0; // 関数戻り値
            refOrgName = null;

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // 更新対象負担情報の抽出
                IList<ContractBurdens> extractedBurdens = GetCtrPtOrg(data.Burdens);

                // 現時点におけるデータベース上の追加・削除オプションおよび契約外項目負担情報を取得
                IList<dynamic> currentBurdens = contractDao.SelectCtrPtOrgPrice(ctrPtCd);

                // 負担元情報が存在しない場合はエラーを発生させる
                // (全ての契約情報は少なくとも個人負担用の負担元レコードを1つ所有する。従って本異常時は契約情報自体が存在しないに等しい。)
                if (currentBurdens.Count <= 0)
                {
                    throw new Exception("契約情報が存在しません。");
                }

                // (i:更新情報のインデックス、j:データベース情報のインデックス)
                string mode = null;
                int i = 0;
                int j = 0;

                // 更新情報とデータベース上との負担元情報のマッチングを行う
                while (!((i >= extractedBurdens.Count) && (j >= currentBurdens.Count)))

                {
                    // 処理モードの決定
                    while (true)
                    {
                        // 更新情報が最後まで検索されている場合
                        if (i >= extractedBurdens.Count)
                        {
                            mode = "DEL";
                            break;
                        }

                        // データベース情報が最後まで検索されている場合
                        if (j >= currentBurdens.Count)
                        {
                            mode = "INS";
                            break;
                        }

                        int seq = Convert.ToInt32(extractedBurdens[i].Seq);
                        int curSeq = Convert.ToInt32(currentBurdens[j].SEQ);

                        // 更新情報のSEQ値がデータベース上のそれより大きい場合
                        if (seq > curSeq)
                        {
                            mode = "DEL";
                            break;
                        }

                        // データベース上のSEQ値が更新情報のそれより大きい場合
                        if (seq < curSeq)
                        {
                            mode = "INS";
                            break;
                        }

                        // 上記のいずれの条件にも合致しない場合、即ち双方のSEQ値が等しい場合
                        mode = "UPD";
                        break;
                    }

                    // 処理モードごとの処理
                    switch (mode)
                    {
                        // 更新情報の挿入
                        case "INS":

                            // 契約パターン負担元管理テーブルの挿入
                            contractDao.InsertCtrPtOrg(ctrPtCd, extractedBurdens[i]);

                            // 現存する全てのオプション検査（基本コースを除く）に対し、指定された契約パターン、SEQの負担金額レコードを作成
                            contractDao.InsertCtrPtPrice(ctrPtCd, Convert.ToInt32(extractedBurdens[i].Seq));

                            // 次の更新情報を検索するためにインデックスをインクリメント
                            i = i + 1;

                            break;

                        // 更新情報の更新
                        case "UPD":

                            // 契約パターン負担元管理テーブルの更新
                            contractDao.UpdateCtrPtOrg(ctrPtCd, extractedBurdens[i]);

                            // 次の更新情報およびデータベース情報を検索するためにインデックスをインクリメント
                            i = i + 1;
                            j = j + 1;

                            break;
                        // データベース情報の更新
                        case "DEL":

                            // セットの負担を行う負担元は削除できない
                            if (Convert.ToInt32(currentBurdens[j].OPTBURDEN) != 0)
                            {
                                ret = 1;
                                break;
                            }

                            // 限度額負担の設定が行われている負担元は削除できない
                            if (!string.IsNullOrEmpty(Convert.ToString(currentBurdens[j].LIMITPRICEFLG)))
                            {
                                ret = 5;
                                break;
                            }

                            // 削除対象負担元の子レコードとなるすべての契約パターン負担金額管理レコードを削除
                            contractDao.DeleteCtrPtPrice(ctrPtCd, Convert.ToInt32(currentBurdens[j].SEQ));

                            // 契約パターン負担元管理テーブルの削除
                            switch (contractDao.DeleteCtrPtOrg(ctrPtCd, Convert.ToInt32(currentBurdens[j].SEQ)))
                            {
                                case 0:
                                    break;
                                case 1:
                                    ret = 1; // ←「コース基本項目以外の負担を行う負担元は削除できない」と同義
                                    break;
                                case 2:
                                case 3:
                                case 4:
                                    ret = 4;
                                    break;
                                default:
                                    ret = -1;
                                    break;
                            }

                            // 次のデータベース情報を検索するためにインデックスをインクリメント
                            j = j + 1;
                            break;
                    }
                }

                // ここまで正常の場合
                if (ret == 0)
                {
                    // この状態の負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
                    IList<dynamic> items = contractDao.CheckDemandOrgReferred(orgCd1, orgCd2, ctrPtCd);
                    if (items.Count > 0)
                    {
                        refOrgName = items.Select<dynamic, string>(rec => Convert.ToString(rec.ORGNAME)).ToArray();
                        ret = 3;
                    }
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 限度額情報の更新
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">限度額情報</param>
        /// <returns>
        /// 0: 正常終了
        /// 1: 負担元情報が変更されている
        /// </returns>
        public int UpdateLimitPrice(
            string orgCd1,
            string orgCd2,
            int ctrPtCd,
            Contract data
        )
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 負担元情報のチェック
                    if (!contractDao.CheckCtrPtOrg(ctrPtCd, data.Burdens))
                    {
                        ret = 1;
                        break;
                    }

                    // 契約パターンテーブル更新
                    contractDao.UpdateCtrPt(ctrPtCd, data);

                    // 契約パターン負担元管理テーブル更新
                    contractDao.UpdateCtrPtOrgLimit(ctrPtCd, data.SeqOrg, data.SeqBdnOrg);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約外項目の負担情報更新
        /// </summary>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="burdens">負担元情報</param>
        /// <returns></returns>
        public int UpdateOuterContract(string orgCd1, string orgCd2, int ctrPtCd, IList<ContractBurdens> burdens)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {

                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 負担元情報のチェック
                    if (!contractDao.CheckCtrPtOrg(ctrPtCd, burdens))
                    {
                        ret = 1;
                        break;
                    }

                    // 契約パターン負担元管理テーブル更新
                    contractDao.UpdateCtrPtOrgNoCtr(ctrPtCd, burdens);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約期間の更新
        /// </summary>
        /// <param name="orgCd1"></param>
        /// <param name="orgCd2"></param>
        /// <param name="csCd">コースコード</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="strDate">契約開始日</param>
        /// <param name="endDate">契約終了日</param>
        /// <returns></returns>
        public int UpdatePeriod(string orgCd1, string orgCd2, string csCd, int ctrPtCd, DateTime? strDate, DateTime? endDate)
        {
            int ret = 0; // 関数戻り値

            using (var transaction = BeginTransaction())
            {
                // 同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
                // (基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
                if (!organizationDao.LockOrgRecord(orgCd1, orgCd2))
                {
                    throw new Exception("団体情報が存在しません。");
                }

                // 同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
                if (!contractDao.LockCtrPt(ctrPtCd))
                {
                    throw new Exception("契約情報が存在しません。");
                }

                while (true)
                {
                    // 契約適用期間がコース適用期間に含まれるかチェック
                    if (courseDao.GetHistoryCount(csCd, strDate, endDate) <= 0)
                    {
                        ret = 1;
                        break;
                    }

                    // 同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
                    if (contractDao.CheckContractPeriod(orgCd1, orgCd2, csCd, ctrPtCd, strDate, endDate))
                    {
                        ret = 2;
                        break;
                    }

                    // 契約期間内に受診情報が存在するかをチェック
                    dynamic data = contractDao.CheckConsultIntoContract(ctrPtCd);
                    if (data != null)
                    {
                        // 更新する契約開始日より古い日付の受診情報が存在する、または更新する契約終了日より新しい日付の受診情報が存在する場合はエラー
                        if ((DateTime.Parse(Convert.ToString(data.MINCSLDATE)) < strDate) || (DateTime.Parse(Convert.ToString(data.MAXCSLDATE)) > endDate))
                        {
                            ret = 3;
                            break;
                        }
                    }

                    // 契約パターンテーブル更新
                    contractDao.UpdateCtrPt_Period(ctrPtCd, strDate, endDate);
                    break;
                }

                // エラーの有無によるトランザクション制御
                if (ret == 0)
                {
                    transaction.Commit();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 限度額の設定入力チェック
        /// </summary>
        /// <param name="data">契約パターン限度額情報</param>
        /// <returns></returns>
        public List<String> CheckLimitPriceValue(Contract data)
        {
            var messages = new List<string>();
            string message;

            // すべて未入力ならばチェック不要
            if (string.IsNullOrEmpty(Convert.ToString(data.SeqOrg))
                && string.IsNullOrEmpty(Convert.ToString(data.LimitRate))
                && string.IsNullOrEmpty(Convert.ToString(data.LimitPrice))
                && string.IsNullOrEmpty(Convert.ToString(data.SeqBdnOrg)))
            {
                return messages;
            }
            // 対象負担元のチェック
            if (string.IsNullOrEmpty(Convert.ToString(data.SeqOrg)))
            {
                messages.Add("対象負担元を設定してください。");
            }

            while(true)
            {
                // 限度率チェック
                if (string.IsNullOrEmpty(Convert.ToString(data.LimitRate)))
                {
                    messages.Add("限度率を設定してください。");
                    break;
                }

                // 数値チェック
                message = WebHains.CheckNumeric("限度率", Convert.ToString(data.LimitRate), 3);
                if (message != null)
                {
                    messages.Add(message);
                    break;
                }

                // 限度率は１００％まで
                if (Convert.ToInt32(data.LimitRate) > 100)
                {
                    messages.Add("限度率の値が正しくありません。");
                }
                break;
            }

            // 上限金額チェック
            message = WebHains.CheckNumeric("上限金額", Convert.ToString(data.LimitPrice), 7);
            if (message != null)
            {
                messages.Add(message);
            }

            // 減算した金額の負担元のチェック
            if (string.IsNullOrEmpty(Convert.ToString(data.SeqBdnOrg)))
            {
                messages.Add("減算した金額の負担元を設定してください。");
            }

            // ともに設定されている場合、両方に同じ負担元は設定できない
            if (!string.IsNullOrEmpty(Convert.ToString(data.SeqOrg))
                && !string.IsNullOrEmpty(Convert.ToString(data.SeqBdnOrg))
                && Convert.ToString(data.SeqOrg).Equals(Convert.ToString(data.SeqBdnOrg)))
            {
                messages.Add("対象負担元、減算した金額の負担元に同じ値を設定することはできません。");
            }

            return messages;
        }

        /// <summary>
        /// 検査セットの登録入力チェック
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public IList<string> CheckSetValue(ContractOptions data)
        {
            IList<string> messages = new List<string>();
            string message = "";

            while (true)
            {
                // 半角文字チェック
                message = WebHains.CheckNarrowValue("セットコード", data.Option.OptCd, 4, Check.Necessary);
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                    break;
                }
                // カンマは指定できない
                if (data.Option.OptCd.IndexOf(",")>-1)
                {
                    messages.Add("セットコードにカンマは指定できません。");
                }
                break;
            }
            // オプション枝番チェック
            message = WebHains.CheckNumeric("セット枝番", data.Option.OptBranchNo, 2, Check.Necessary);
            if (!string.IsNullOrEmpty(message))
            {
                messages.Add(message);
            }
            // オプション名チェック
            message = WebHains.CheckWideValue("セット名", data.Option.OptName, 30, Check.Necessary);
            if (!string.IsNullOrEmpty(message))
            {
                messages.Add(message);
            }
            // オプション略称チェック
            message = WebHains.CheckWideValue("セット略称", data.Option.OptSName, 20);
            if (!string.IsNullOrEmpty(message))
            {
                messages.Add(message);
            }

            // 前回値条件チェック
            while (true)
            {
                // 何も入力されていない場合
                if (string.IsNullOrEmpty(string.Concat(data.Option.LastRefMonth , data.Option.LastRefCsCd)))
                {
                    break;
                }
                // 両方とも入力されている場合
                if (!string.IsNullOrEmpty(data.Option.LastRefMonth) && !string.IsNullOrEmpty(data.Option.LastRefCsCd))
                {
                    // 前回値参照用月数チェック
                    message = WebHains.CheckNumeric("月数", data.Option.LastRefMonth, 2);
                    if (!string.IsNullOrEmpty(message))
                    {
                        messages.Add(message);
                        break;
                    }

                    // 正の整数かをチェック
                    if (Convert.ToInt32(data.Option.LastRefMonth) < 1)
                    {
                        messages.Add("月数は１以上の値を設定してください。");
                        break;
                    }
                    break;
                }
                // 上記以外はエラー
                messages.Add("前回値の条件指定が不完全です。");

                break;
            }
            message = "";
            foreach (var price in data.OrgPrices)
            {
                if (!string.IsNullOrEmpty(message))
                {
                    break;
                }
                // 負担金額チェック
                message = WebHains.CheckNumericWithSign("負担金額", price.Price, Convert.ToInt32(LengthConstants.LENGTH_CTRPT_PRICE_PRICE));
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);                    
                }
                // 消費税チェック
                message = WebHains.CheckNumericWithSign("消費税", price.Tax, Convert.ToInt32(LengthConstants.LENGTH_CTRPT_PRICE_PRICE));
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                }
                // 請求書出力名チェック
                message = WebHains.CheckWideValue("請求書・領収書出力名", price.BillPrintName, 30);
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                }
                // 請求書英語出力名チェック
                message = WebHains.CheckNarrowValue("請求書・領収書出力名（英語）", price.BillPrintEName, 30);
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                }
            }

            // チェック結果を返す
            return messages;
        }
    }
}
