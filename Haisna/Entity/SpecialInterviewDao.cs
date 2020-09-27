using Dapper;
using Hainsi.Common;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Hainsi.Entity.Model.SpecialInterview;

namespace Hainsi.Entity
{
    /// <summary>
    /// 特定保健指導用データアクセスオブジェクト
    /// </summary>
    public class SpecialInterviewDao : AbstractDao
    {
        private const string CTRPT_SETCLASSCD = "660";      // 契約情報の特定健診セット分類コード

        // 桁数
        //private const int LENGTH_TOTALJUDCMT_RSVNO = 9;     // 予約番号
        //private const int LENGTH_TOTALJUDCMT_DISPMODE = 2;  // 表示分類
        //private const int LENGTH_TOTALJUDCMT_SEQ = 3;       // 表示順
        //private const int LENGTH_TOTALJUDCMT_JUDCMTCD = 8;  // 判定コメントコード

        private const int FOOD_JUDCLASSCD = 51;             // 食習慣
        private const int MENU_JUDCLASSCD = 52;             // 献立
        private const int LIFE_JUDCLASSCD = 50;             // 生活指導
        private const int SPECIAL_JUDCLASSCD = 90;          // 特定健診

        private const string SHINTAI_GRPCD = "X076";        // 身体計測
        private const string KETUATU_GRPCD = "X077";        // 血圧
        private const string KETSYUSISITSU_GRPCD = "X078";  // 血中脂質
        private const string KANKINOU_GRPCD = "X079";       // 肝機能
        private const string KETTOU_GRPCD = "X080";         // 唐代謝
        private const string NYOU_GRPCD = "X081";           // 血液一般
        private const string SMOKE_GRPCD = "X082";          // 喫煙

        private const int SDI_RSLCNT = 33;                  // 多変量解析に必要な検査項目件数
        private const string STATISTICS_GRPCD = "X050";     // 多変量解析用検査項目のグループコード

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public SpecialInterviewDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定予約番号の契約情報の中の特定健診セット情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// true   レコードあり
        /// false  レコードなし、または異常終了
        /// </returns>
        public bool SelectSetClassCd(int rsvNo)
        {
            bool ret = false;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("setclasscd", CTRPT_SETCLASSCD);

            // 指定予約番号の契約情報の中の特定健診セット情報を取得する
            string sql = @"
                            select
                              ctrpt_opt.setclasscd
                            from
                              consult
                              , receipt
                              , consult_o
                              , ctrpt_opt
                            where
                              consult.rsvno = :rsvno
                              and consult.rsvno = receipt.rsvno
                              and consult.cancelflg = 0
                              and consult.rsvno = consult_o.rsvno
                              and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                              and consult_o.optcd = ctrpt_opt.optcd
                              and consult_o.optbranchno = ctrpt_opt.optbranchno
                              and ctrpt_opt.setclasscd = :setclasscd
                        ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = true;
            }

            return ret;
        }

        /// <summary>
        /// 指定予約番号の契約情報の中の特定健診セット情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="setClassCd">契約情報内のセット分類コード</param>
        /// <returns>
        /// true   レコードあり
        /// false  レコードなし、または異常終了
        /// </returns>
        public bool CheckSetClassCd(int rsvNo, string setClassCd)
        {
            bool ret = false;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("setclasscd", setClassCd);

            // 指定予約番号の契約情報の中の特定健診セット情報を取得する
            string sql = @"
                            select
                              ctrpt_opt.setclasscd
                            from
                              consult
                              , receipt
                              , consult_o
                              , ctrpt_opt
                            where
                              consult.rsvno = :rsvno
                              and consult.rsvno = receipt.rsvno
                              and consult.cancelflg = 0
                              and consult.rsvno = consult_o.rsvno
                              and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                              and consult_o.optcd = ctrpt_opt.optcd
                              and consult_o.optbranchno = ctrpt_opt.optbranchno
                              and ctrpt_opt.setclasscd = :setclasscd
                        ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = true;
            }

            return ret;
        }

        /// <summary>
        /// 特定保健指導対象者チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 1   正常終了
        /// -1  異常終了
        /// </returns>
        public int CheckSpecialTarget(int rsvNo)
        {
            int ret = -1;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("setclasscd", CTRPT_SETCLASSCD);

            // 指定予約番号の契約情報の中の「特定健診階層化」セットがチェックされ、団体別対象年齢に当てはまる受診者チェック
            string sql = @"
                            select
                              consult.rsvno
                            from
                              consult
                              , receipt
                              , consult_o
                              , ctrpt_opt
                              , free
                            where
                              consult.rsvno = :rsvno
                              and consult.rsvno = receipt.rsvno
                              and consult.cancelflg = 0
                              and consult.rsvno = consult_o.rsvno
                              and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                              and consult_o.optcd = ctrpt_opt.optcd
                              and consult_o.optbranchno = ctrpt_opt.optbranchno
                              and ctrpt_opt.setclasscd = :setclasscd
                              and free.freecd like 'SPC%'
                              and consult.orgcd1 = free.freefield1
                              and consult.orgcd2 = free.freefield2
                              and trunc(consult.age) between to_number(free.freefield3) and to_number(free.freefield4)
                              and consult.csldate between to_date(free.freefield5, 'YYYY/MM/DD') and to_date(free.freefield6, 'YYYY/MM/DD')
                        ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = 1;
            }

            return ret;
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者の検査結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <returns>
        /// grpCd       グループコード
        /// grpName     グループ名称
        /// itemCd      検査項目コード
        /// suffix      サフィックス
        /// itemName    検査項目名称
        /// result      検査結果
        /// grpSeq      表示順番
        /// stopFlg     検査中止フラグ
        /// rslCmtCd1   コメント1
        /// rslCmtCd2   コメント2
        /// hpoint      ヘルスポイント
        /// stdLead     保健指導対象基準値
        /// stdCare     受診勧奨対象基準値
        /// grpCount    グループコード数
        /// count       レコード数
        /// </returns>
        public List<dynamic> SelectSpecialRslView(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 特定面接画面に表示するための検査名や項目名、指定予約番号の結果情報を取得
            string sql = @"
                           select
                             grp.grpcd as grpcd
                             , grp.seq as seq
                             , grp.grpname as grpname
                             , grp.itemcd as itemcd
                             , grp.suffix as suffix
                             , grp.itemname as itemname
                             , decode(result.stopflg, 'S', '***', result.result) as result
                             , result.stopflg as stopflg
                             , result.rslcmtcd1 as rslcmtcd1
                             , result.rslcmtcd2 as rslcmtcd2
                             , nvl(result.hpoint, 0) as hpoint
                             , grp.stdlead as stdlead
                             , grp.stdcare as stdcare
                             , (
                               select
                                 count(grp_i.grpcd)
                               from
                                 grp_i
                               where
                                 grp_i.grpcd = grp.grpcd
                             ) as grpcount
                           from
                             (
                               select
                                 free.freefield2 as grpseq
                                 , grp_i.grpcd as grpcd
                                 , grp_i.seq as seq
                                 , grp_p.grpname as grpname
                                 , grp_i.itemcd as itemcd
                                 , grp_i.suffix as suffix
                                 , item_c.itemname as itemname
                                 , ft_get_sp_standard(:rsvno, grp_i.itemcd, grp_i.suffix, 1) as stdlead
                                 , ft_get_sp_standard(:rsvno, grp_i.itemcd, grp_i.suffix, 2) as stdcare
                               from
                                 grp_i
                                 , grp_p
                                 , item_c
                                 , free 
                               where
                                 free.freecd like 'SPCV%' 
                                 and free.freefield1 = grp_i.grpcd 
                                 and grp_i.itemcd = item_c.itemcd 
                                 and grp_i.suffix = item_c.suffix 
                                 and grp_i.grpcd = grp_p.grpcd
                             ) grp
                             , (
                               select
                                 rslview.rsvno as rsvno
                                 , rslview.itemcd as itemcd
                                 , rslview.suffix as suffix
                                 , decode(
                                   sentence.longstc
                                   , null
                                   , rslview.result
                                   , decode(
                                     rslview.itemcd
                                     , '63070'
                                     , decode(rslview.result, '1', 'あり', 'なし')
                                     , sentence.longstc
                                   )
                                 ) as result
                                 , rslview.stopflg as stopflg
                                 , rslview.rslcmtcd1 as rslcmtcd1
                                 , rslview.rslcmtcd2 as rslcmtcd2
                                 , rslview.hpoint as hpoint
                               from
                                 (
                                   select
                                     rsl.rsvno as rsvno
                                     , rsl.itemcd as itemcd
                                     , rsl.suffix as suffix
                                     , rsl.result as result
                                     , rsl.stopflg as stopflg
                                     , rsl.rslcmtcd1 as rslcmtcd1
                                     , rsl.rslcmtcd2 as rslcmtcd2
                                     , ft_get_sp_healthpoint(rsl.rsvno, rsl.itemcd, rsl.suffix, rsl.result) as hpoint
                                     , item_c.stcitemcd as stcitemcd
                                     , item_c.itemtype as itemtype
                                   from
                                     rsl
                                     , grp_i
                                     , item_c
                                   where
                                     rsl.rsvno = :rsvno
                                     and grp_i.grpcd in ( 
                                        select
                                          freefield1 
                                        from
                                          free 
                                        where
                                          free.freecd like 'SPCV%'
                                     )
                                     and grp_i.itemcd = rsl.itemcd
                                     and grp_i.suffix = rsl.suffix
                                     and rsl.itemcd = item_c.itemcd
                                     and rsl.suffix = item_c.suffix
                                 ) rslview
                                 , sentence
                               where
                                 rslview.stcitemcd = sentence.itemcd(+)
                                 and rslview.itemtype = sentence.itemtype(+)
                                 and rslview.result = sentence.stccd(+)
                             ) result
                           where
                             grp.itemcd = result.itemcd(+)
                             and grp.suffix = result.suffix(+)
                           order by
                             grp.grpseq
                             , grp.grpcd
                             , grp.seq
                       ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 予約番号をもって検査結果を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpcd">検査項目グループコード</param>
        /// <returns>
        /// itemCd      検査項目コード
        /// suffix      サフィックス
        /// itemName    検査項目名称
        /// result      検査結果
        /// longStc     文章
        /// </returns>
        public List<dynamic> SelectSpecialResult(int rsvNo, string grpcd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("grpcd", grpcd);

            string sql = @"
                           select
                             perrsl.itemcd itemcd 　　　
                             , perrsl.suffix suffix 　　　
                             , perrsl.itemname itemname 　　　
                             , perrsl.result result 　　　
                             , sentence.longstc longstc 　　　
                           from
                             (
                               select
                                 item_c.itemcd itemcd
                                 , item_c.suffix suffix
                                 , item_c.stcitemcd stcitemcd
                                 , item_c.itemname itemname
                                 , item_c.itemtype itemtype
                                 , item_c.resulttype resulttype
                                 , rsl.result result
                               from
                                 rsl
                                 , grp_i
                                 , item_c
                               where
                                 rsl.rsvno = :rsvno
                                 and grp_i.grpcd = :grpcd
                                 and rsl.result is not null
                                 and rsl.itemcd = grp_i.itemcd
                                 and rsl.suffix = grp_i.suffix
                                 and rsl.itemcd = item_c.itemcd
                                 and rsl.suffix = item_c.suffix
                             ) perrsl
                             , sentence
                           where
                             perrsl.stcitemcd = sentence.itemcd(+)
                             and perrsl.itemtype = sentence.itemtype(+)
                             and perrsl.result = sentence.stccd(+) 　
                           order by
                             perrsl.itemcd
                             , perrsl.suffix
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定された予約番号の階層化コメントを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類（1:総合コメント、2:生活指導コメント、3:食習慣コメント、4:献立コメント、5：特定健診）</param>
        /// <returns>
        /// judCmtSeq    表示順
        /// judCmtCd     判定コメントコード
        /// judCmtStc    判定コメント文章
        /// judClassCd   判定分類コード
        /// </returns>
        public List<dynamic> SelectSpecialJudCmt(int rsvNo, int dispMode)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("dispmode", dispMode);

            // 指定された予約番号の階層化コメントを取得する
            string sql = @"
                           select
                             totaljudcmt.rsvno as rsvno
                             , totaljudcmt.seq as judcmtseq
                             , totaljudcmt.judcmtcd as judcmtcd
                             , judcmtstc.judcmtstc as judcmtstc
                             , judclass.judclasscd as judclasscd
                           from
                             totaljudcmt
                             , judcmtstc
                             , judclass
                           where
                             totaljudcmt.rsvno = :rsvno
                             and totaljudcmt.dispmode = :dispmode
                             and totaljudcmt.judcmtcd = judcmtstc.judcmtcd
                             and judcmtstc.judclasscd = judclass.judclasscd
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定された予約番号の階層化コメントを更新する
        /// </summary>
        /// <param name="data">
        /// rsvno            予約番号
        /// dispmode         表示分類
        /// judcmtseq        表示順
        /// judcmtcd         判定コメントコード
        /// judcmtcdstc      判定コメント
        /// upduser          更新者
        /// </param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        public bool UpdateSpecialJudCmt(SpecialJudCmtList data)
        {
            IList<int> arrLogUpdClass = new List<int>();            // 更新分類
            IList<string> arrLogUpdDiv = new List<string>();        // 処理区分
            IList<int> arrLogRsvNo = new List<int>();               // 予約番号
            IList<string> arrLogRsvDate = new List<string>();       // 予約日
            IList<string> arrLogJudClassCd = new List<string>();    // 判定分類コード
            IList<string> arrLogBeforeResult = new List<string>();  // 更新前値
            IList<string> arrLogAfterResult = new List<string>();   // 更新後値

            int chkFlg;                                      // チェックフラグ
            int logCnt;                                      // 変更履歴件数
            int updFlg;                                      // 更新有無フラグ
            string rsvDate = "";                             // 予約日



            // 現状を退避
            List<dynamic> bakdata = SelectSpecialJudCmt(Convert.ToInt32(data.Rsvno), Convert.ToInt32(data.Dispmode));

            // 予約日取得
            var param = new Dictionary<string, object>();
            param.Add("logrsvno", Convert.ToInt32(data.Rsvno));
            dynamic current = connection.Query("select rsvdate from consult where rsvno = :logrsvno", param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                // オブジェクトの参照設定
                rsvDate = Convert.ToString(current.RSVDATE);
            }
            else
            {
                throw new ArgumentException();

            }

            SpecialJudCmt[] items = data.SpecialJudCmt;
            // 配列数
            int arraySize = items.Count();

            logCnt = 0;
            // 削除の有無確認
            for (int i = 0; i < bakdata.Count; i++)
            {
                chkFlg = 0;
                for (int j = 0; j < arraySize; j++)
                {
                    // 更新後もあり？
                    if (Convert.ToInt32(bakdata[i].JUDCMTCD) == Convert.ToInt32(items[j].JudCmtCd))
                    {
                        chkFlg = 1;
                        break;
                    }
                }
                // 削除された
                if (chkFlg == 0)
                {
                    arrLogUpdClass.Add(3);
                    arrLogUpdDiv.Add("D");
                    arrLogRsvNo.Add(Convert.ToInt32(data.Rsvno));
                    arrLogRsvDate.Add(Convert.ToString(rsvDate));

                    switch (Convert.ToInt32(data.Dispmode))
                    {
                        // 総合コメント
                        case 1:
                            arrLogJudClassCd.Add("");
                            break;
                        case 2:
                            arrLogJudClassCd.Add(LIFE_JUDCLASSCD.ToString());
                            break;
                        case 3:
                            arrLogJudClassCd.Add(FOOD_JUDCLASSCD.ToString());
                            break;
                        case 4:
                            arrLogJudClassCd.Add(MENU_JUDCLASSCD.ToString());
                            break;
                        case 5:
                            arrLogJudClassCd.Add(SPECIAL_JUDCLASSCD.ToString());
                            break;
                        default:
                            arrLogJudClassCd.Add("");
                            break;
                    }
                    string judcmtstc = Convert.ToString(bakdata[i].JUDCMTSTC);
                    arrLogBeforeResult.Add(judcmtstc);
                    arrLogAfterResult.Add("");
                    logCnt++;
                }
            }

            // 追加の有無確認
            for (int i = 0; i < arraySize; i++)
            {
                chkFlg = 0;
                for (int j = 0; j < bakdata.Count; j++)
                {
                    // 表示順が数字で無いものは無視
                    if (!Util.IsNumber(Convert.ToString(items[i].JudCmtSeq)))
                    {
                        chkFlg = 1;
                        break;
                    }

                    // コメントコードブランクは無視
                    if (Convert.ToInt32(items[i].JudCmtSeq) <= 0 || "".Equals(items[i].JudCmtSeq))
                    {
                        chkFlg = 1;
                        break;
                    }

                    // 修正前もあり？
                    if (Convert.ToInt32(items[i].JudCmtCd) == Convert.ToInt32(bakdata[j].JUDCMTCD))
                    {
                        chkFlg = 1;
                        break;
                    }
                }

                // 追加された
                if (chkFlg == 0)
                {
                    arrLogUpdClass.Add(3);
                    arrLogUpdDiv.Add("I");
                    arrLogRsvNo.Add(Convert.ToInt32(data.Rsvno));
                    arrLogRsvDate.Add(Convert.ToString(rsvDate));


                    switch (Convert.ToInt32(data.Dispmode))
                    {
                        // 総合コメント
                        case 1:
                            arrLogJudClassCd.Add("");
                            break;
                        case 2:
                            arrLogJudClassCd.Add(LIFE_JUDCLASSCD.ToString());
                            break;
                        case 3:
                            arrLogJudClassCd.Add(FOOD_JUDCLASSCD.ToString());
                            break;
                        case 4:
                            arrLogJudClassCd.Add(MENU_JUDCLASSCD.ToString());
                            break;
                        case 5:
                            arrLogJudClassCd.Add(SPECIAL_JUDCLASSCD.ToString());
                            break;
                        default:
                            arrLogJudClassCd.Add("");
                            break;
                    }
                    arrLogBeforeResult.Add("");
                    arrLogAfterResult.Add(Convert.ToString(items[i].JudCmtStc));
                    logCnt++;
                }
            }

            // 変更履歴登録あり
            if (logCnt > 0)
            {
                UpdateLogSpecialJudCmt(Convert.ToString(data.UpdUser), arrLogUpdClass, arrLogUpdDiv, arrLogRsvNo, arrLogRsvDate, arrLogJudClassCd, arrLogBeforeResult, arrLogAfterResult);
            }
            // 変更履歴更新用

            // キー値の設定
            param.Add("rsvno", Convert.ToInt32(data.Rsvno));
            param.Add("dispmode", Convert.ToInt32(data.Dispmode));

            // 指定された予約番号の総合コメントをすべて削除する
            string sql = @"
                           delete totaljudcmt
                           where
                             totaljudcmt.rsvno = :rsvno
                             and totaljudcmt.dispmode = :dispmode
                        ";

            connection.Execute(sql, param);

            if (arraySize > 0)
            {
                updFlg = 0;
                // OraParameterオブジェクトの値設定
                var paramArray = new List<dynamic>();

                for (int i = 0; i < arraySize; i++)
                {
                    // 表示順が数字
                    if (Util.IsNumber(Convert.ToString(items[i].JudCmtSeq)))
                    {
                        if (Convert.ToInt32(items[i].JudCmtSeq) > 0 && !"".Equals(items[i].JudCmtCd))
                        {
                            param = new Dictionary<string, object>();
                            param.Add("rsvno", Convert.ToInt32(data.Rsvno));
                            param.Add("dispmode", Convert.ToInt32(data.Dispmode));
                            param.Add("seq", Convert.ToInt32(items[i].JudCmtSeq));
                            param.Add("judcmtcd", Convert.ToString(items[i].JudCmtCd));
                            paramArray.Add(param);
                            updFlg = 1;
                        }
                    }
                }

                // 更新あり？
                if (updFlg == 1)
                {
                    sql = @"
                            insert
                            into totaljudcmt
                            values (:rsvno, :dispmode, :seq, :judcmtcd)
                         ";
                }

                connection.Execute(sql, paramArray);
            }

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 階層化コメント更新履歴をセットする
        /// </summary>
        /// <param name="upduser">更新者</param>
        /// <param name="arrLogUpdClass">更新分類</param>
        /// <param name="arrLogUpdDiv">処理区分</param>
        /// <param name="arrLogRsvNo">予約番号</param>
        /// <param name="arrLogRsvDate">予約日</param>
        /// <param name="arrLogJudClassCd">判定分類コード</param>
        /// <param name="arrLogBeforeResult">更新前値</param>
        /// <param name="arrLogAfterResult">更新後値</param>
        /// <returns>
        /// true    正常終了
        /// false   異常終了
        /// </returns>
        public bool UpdateLogSpecialJudCmt(string upduser, IList<int> arrLogUpdClass, IList<string> arrLogUpdDiv, IList<int> arrLogRsvNo, IList<string> arrLogRsvDate, IList<string> arrLogJudClassCd, IList<string> arrLogBeforeResult, IList<string> arrLogAfterResult)
        {
            // 配列数
            int arraySize = arrLogRsvNo.Count();

            if (arraySize > 0)
            {
                for (int i= 0; i < arraySize; i++)
                {
                    var param = new Dictionary<string, object>();
                    param.Add("upduser", upduser);
                    param.Add("updclass", arrLogUpdClass[i]);
                    param.Add("upddiv", arrLogUpdDiv[i]);
                    param.Add("rsvno", arrLogRsvNo[i]);
                    param.Add("rsvdate", Convert.ToDateTime(arrLogRsvDate[i]));

                    // 検査結果更新
                    string sql = @"
                                   insert
                                   into updatelog(
                                     upddate
                                     , upduser
                                     , updclass
                                     , upddiv
                                     , rsvno
                                     , rsvdate
                                     , judclasscd
                                ";
                    if (!"".Equals(arrLogBeforeResult[i]))
                    {
                        sql += " , beforeresult ";
                    }

                    if (!"".Equals(arrLogAfterResult[i]))
                    {
                        sql += " , afterresult ";
                    }
                    sql += @"
                            )
                            values (
                              sysdate
                              , :upduser
                              , :updclass
                              , :upddiv
                              , :rsvno
                              , :rsvdate
                          ";

                    if (!"".Equals(arrLogJudClassCd[i]))
                    {
                        param.Add("judclasscd", arrLogJudClassCd[i]);
                        sql += " , :judclasscd ";
                    }
                    else
                    {
                        sql += " , null ";
                    }

                    if (!"".Equals(arrLogBeforeResult[i]))
                    {
                        param.Add("beforeresult", arrLogBeforeResult[i]);
                        sql += " , :beforeresult ";
                    }

                    if (!"".Equals(arrLogAfterResult[i]))
                    {
                        param.Add("afterresult", arrLogAfterResult[i]);
                        sql += " , :afterresult ";
                    }
                    sql += " ) ";

                    connection.Execute(sql, param);
                }
            }

            // 戻り値の設定
            return true;
        }
    }
}