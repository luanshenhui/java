using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;
using System.Dynamic;
namespace Hainsi.Entity
{
    /// <summary>
    /// 面接支援情報データアクセスオブジェクト
    /// </summary>
    public class InterviewDao : AbstractDao
    {
        const int FOOD_JUDCLASSCD = 51;                   // 食習慣
        const int MENU_JUDCLASSCD = 52;                   // 献立
        const int LIFE_JUDCLASSCD = 50;                   // 生活指導

        const int NYUBOU_JUDCLASSCD = 24;                 // 乳房
        const int NYUSYOKU_JUDCLASSCD = 54;               // 乳房触診
        const int NYUXSEN_JUDCLASSCD = 55;                // 乳房Ｘ線
        const int NYUCHOU_JUDCLASSCD = 56;                // 乳房超音波

        const int SDI_RSLCNT = 33;                        // 多変量解析に必要な検査項目件数
        const string STATISTICS_GRPCD = "X050";           // 多変量解析用検査項目のグループコード

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public InterviewDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定された予約番号の個人ＩＤの受診歴一覧を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="receptOnly">True指定時は受付済み受診情報のみを取得対象とする</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="getRowCount">取得件数(未指定時は全件)</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <param name="dateSort">日付順(0:今回が先頭、1:今回が最後)</param>
        /// <returns>
        /// perid 個人ＩＤ
        /// rsvno 予約番号
        /// csldate 受診日
        /// cscd コースコード
        /// csname コース名
        /// cssname コース略称
        /// </returns>
        public List<dynamic> SelectConsultHistory(int rsvNo, bool receptOnly = false, int lastDspMode = 0, string csGrp = null, int getRowCount = 0, int selectMode = 0, int dateSort = 0)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));
            param.Add("checkdayid", (receptOnly ? 0 : -1));

            // 指定された個人ＩＤの受診歴一覧を取得する
            sql = @"
                    select
                      history.perid
                      , history.rsvno
                      , history.csldate
                      , history.cscd
                      , history.csname
                      , history.cssname
                    from
                      (
                        select
                          consult.perid
                          , consult.rsvno
                          , consult.csldate
                          , consult.cscd
                          , course_p.csname
                          , course_p.cssname
                          , receipt.dayid
                          , nvl(receipt.dayid, 0) checkdayid
                        from
                          receipt
                          , course_p
                          , consult
            ";

            sql += @"
                        where
                          consult.perid = (
                                            select distinct
                                              perid
                                            from
                                              consult
                                            where
                                              rsvno = :rsvno
                                          )
                          and consult.cancelflg = 0
            ";

            switch (lastDspMode)
            {
                case 1:
                    sql += @"
                                    and consult.cscd = :cscd
                    ";
                    break;
                case 2:
                    sql += @"
                                    and consult.cscd in (
                                      select
                                        freefield1 cscd
                                      from
                                        free
                                      where
                                        freecd like :cscd || '%'
                                    )
                    ";
                    break;
                default:
                    break;

            }

            sql += @"
                            and consult.cscd = course_p.cscd
                            and consult.rsvno = receipt.rsvno(+)
                            and consult.csldate = receipt.csldate(+)
                            order by
                              consult.csldate desc
                        ) history
            ";

            // 条件節
            sql += @"
                     where history.csldate
            ";

            // 今回分含む？
            if (selectMode == 0)
            {
                sql += @"
                                            <=
                ";
            }
            else
            {
                sql += @"
                                            <
                ";
            }

            sql += @"
                                                (
                                                  select distinct
                                                    csldate
                                                  from
                                                    consult
                                                  where
                                                    rsvno = :rsvno
                                                )
                     and history.checkdayid > :checkdayid
            ";

            // 今回が最後？
            if (dateSort == 1)
            {
                // 取得件数指定時
                if (getRowCount > 0)
                {
                    sql += @"
                             and rownum <= " + getRowCount
                    ;
                }
            }

            // 受診日の降順、当日ＩＤの降順、コースコードの昇順に取得
            sql += @"
                    order by
                          history.perid
                          , history.csldate " + (dateSort == 0 ? " desc " : "") +
                   @"     , history.dayid desc nulls last
                          , history.cscd
            ";

            if (getRowCount > 0)
            {
                return connection.Query(sql, param).Take(getRowCount).ToList();
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 面接支援画面表示用のオプション検査名を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// optname オプション検査名称
        /// </returns>
        public List<dynamic> SelectInteviewOptItem(int rsvNo)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            sql = @"
                    select distinct
                      finalrsl.seq
                      , finalrsl.optname
                    from
                      (
                        select
                          rsl.itemcd
                          , rsl.suffix
                          , optview.seq
                          , optview.optname
                          , optview.grpcd
                        from
                          rsl
                          , grp_i
                          , (
                            select
                              freecd optcd
                              , freefield1 seq
                              , freefield2 optname
                              , freefield3 grpcd
                            from
                              free
                            where
                              freecd like 'OPT%'
                          ) optview
                        where
                          rsl.rsvno = :rsvno
                          and grp_i.grpcd = optview.grpcd
                          and grp_i.itemcd = rsl.itemcd
                          and grp_i.suffix = rsl.suffix
                          and rsl.stopflg is null
                      ) finalrsl
                    order by
                      finalrsl.seq
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者の検査結果歴を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null；1のとき、コースコード；2のとき、コースグループコード</param>
        /// <param name="getSeqMode">取得順 0:グループ内表示順＋日付　1:日付＋コード＋サフィックス　2:日付＋グループ内表示順</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <param name="allDataMode">全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）</param>
        /// <param name="dateSort">日付順(0:今回が先頭、1:今回が最後)</param>
        /// <param name="rslCmtName1">結果コメント名１</param>
        /// <param name="rslCmtName2">結果コメント名２</param>
        /// <param name="lowerValue">基準値（最低）</param>
        /// <param name="upperValue">基準値（最高）</param>
        /// <returns>
        /// perid 個人ＩＤ
        /// csldate 受診日
        /// hisno 履歴No.
        /// rsvno 予約番号
        /// seq 表示順番
        /// rslflg 検査結果存在フラグ(1:検査結果に存在する、0
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// resulttype 結果タイプ
        /// itemtype 項目タイプ
        /// itemname 検査項目名称
        /// itemqname 問診文章
        /// rslvalue 検査結果(数値タイプ、文章タイプにかかわらずそのまま返す)
        /// stdflg 基準値フラグ
        /// questionrank 問診表示ランク
        /// classname 検査分類名称
        /// result 検査結果(数値タイプはそのまま、文章タイプは文章を返す)
        /// rslcmtcd1 結果コメント１
        /// rslcmtname1 結果コメント名１
        /// rslcmtcd2 結果コメント２
        /// rslcmtname2 結果コメント名２
        /// lowervalue 基準値（最低）
        /// uppervalue 基準値（最高）
        /// datesort 日付順(0:今回が先頭、1:今回が最後)
        /// hideinterview 面接支援非表示フラグ
        /// minvalue 最小値
        /// maxvalue 最大値
        /// unit 単位
        /// cutargetflg CU経年変化表示対象
        /// healthpoint ヘルスポイント
        /// </returns>
        public List<dynamic> SelectHistoryRslList(int rsvNo, string hisCount, string grpCd, int lastDspMode, string csGrp, int getSeqMode,
            int selectMode = 0, int allDataMode = 0, int dateSort = 0, bool? rslCmtName1 = null, bool? rslCmtName2 = null,
            bool? lowerValue = null, bool? upperValue = null)
        {
            string sql = "";                                // SQLステートメント
            string sqlView = "";                            // SQLステートメント

            long localHisCount = 0;                         // 表示歴数
            int count = 0;                                  // レコード数

            bool stdValueFlg = false;                       // 基準値が複数レコードある:True
            List<dynamic> retData = new List<dynamic>();    // 戻り値

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!"*".Equals(hisCount))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                localHisCount = long.Parse(hisCount);
            }
            else
            {
                localHisCount = 0;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (localHisCount > 0)
            {
                param.Add("hiscount", Convert.ToString(localHisCount));
            }
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));
            param.Add("grpcd", (string.IsNullOrEmpty(grpCd) ? "" : grpCd.Trim()));

            sql = @"
                    select
                      finalrsl.perid
                      , finalrsl.csldate
                      , finalrsl.hisno
                      , finalrsl.rsvno
                      , finalrsl.seq
                      , finalrsl.rslflg
                      , finalrsl.itemcd
                      , finalrsl.suffix
                      , finalrsl.resulttype
                      , finalrsl.itemtype
                      , finalrsl.itemname
                      , finalrsl.itemqname
                      , finalrsl.result rslvalue
                      , finalrsl.stdflg
                      , sentence.questionrank
                      , finalrsl.classname
            ";

            // 検査結果のメモタイプ対応
            sql += @"
                      , case
                          when finalrsl.resulttype = 7
                          then (
                          select
                              rslmemostr
                          from
                              rslmemo
                          where
                              rsvno = finalrsl.rsvno
                              and itemcd = finalrsl.itemcd
                              and suffix = finalrsl.suffix
                          )
                          else nvl(sentence.shortstc, finalrsl.result)
                          end result
            ";

            // 基準値要
            if (lowerValue != null || upperValue != null)
            {
                // 基準値の文章タイプ（本来は定性タイプの検査項目）対応
                sql += @"
                          , case
                              when finalrsl.resulttype = 4
                              then (
                              select
                                  shortstc
                              from
                                  sentence
                              where
                                  itemcd = finalrsl.itemcd
                                  and itemtype = finalrsl.itemtype
                                  and stccd = stdvalueview.lowervalue
                              )
                              else stdvalueview.lowervalue
                              end lowervalue
                          , case
                              when finalrsl.resulttype = 4
                              then (
                              select
                                  shortstc
                              from
                                  sentence
                              where
                                  itemcd = finalrsl.itemcd
                                  and itemtype = finalrsl.itemtype
                                  and stccd = stdvalueview.uppervalue
                              )
                              else stdvalueview.uppervalue
                              end uppervalue
                ";
            }
            else
            {
                sql += @"
                          , null lowervalue
                          , null uppervalue
                ";
            }

            sql += @"
                          , finalrsl.rslcmtcd1
            ";

            // 結果コメント要
            if (rslCmtName1 != null)
            {
                sql += @"
                          , (
                                select
                                  rslcmtname
                                from
                                  rslcmt
                                where
                                  rslcmtcd = finalrsl.rslcmtcd1
                            ) rslcmtname1
                ";
            }
            else
            {
                sql += @"
                          , null rslcmtname1
                ";
            }

            sql += @"
                          , finalrsl.rslcmtcd2
            ";

            // 結果コメント要
            if (rslCmtName2 != null)
            {
                sql += @"
                          , (
                                select
                                  rslcmtname
                                from
                                  rslcmt
                                where
                                  rslcmtcd = finalrsl.rslcmtcd2
                            ) rslcmtname2
                ";
            }
            else
            {
                sql += @"
                          , null rslcmtname2
                ";
            }

            sql += @"
                          , finalrsl.minvalue
                          , finalrsl.maxvalue
                          , finalrsl.healthpoint
                          , finalrsl.unit
                          , finalrsl.cutargetflg
                          , finalrsl.hideinterview
                    from
                    sentence
            ";

            // 検査結果View（検査結果が存在しない場合の対応）
            sql += @"
                    , ( 
                        select
                            basersl.hisno
                            , basersl.csldate
                            , basersl.rsvno
                            , basersl.perid
                            , basersl.seq
                            , basersl.itemcd
                            , basersl.suffix
                            , basersl.result
                            , basersl.rslflg
                            , basersl.rslcmtcd1
                            , basersl.rslcmtcd2
                            , stdvalue_c.stdflg
                            , stdvalue_c.healthpoint
                            , itemclass.classname
                            , item_c.resulttype
                            , item_c.itemtype
                            , item_c.itemname
                            , item_c.stcitemcd
                            , item_c.itemqname
                            , item_c.cutargetflg
                            , item_h.minvalue
                            , item_h.maxvalue
                            , item_h.unit
                            , item_c.hideinterview 
                        from
            ";

            // 検査結果に存在しない項目を取得のため、検査項目の空レコードと結合
            sql += @"
                            (
                              select
                                hisno
                                , csldate
                                , rsvno
                                , perid
                                , seq
                                , itemcd
                                , suffix
                                , max(result) result
                                , max(stdvaluecd) stdvaluecd
                                , max(rslcmtcd1) rslcmtcd1
                                , max(rslcmtcd2) rslcmtcd2
                                , max(rslflg) rslflg
                              from
            ";

            // 検査結果に存在するレコード
            sql += @"
                                  (
                                      select
                                      consultview.seq hisno
                                      , consultview.csldate
                                      , consultview.rsvno
                                      , consultview.perid
                                      , grp_i.seq
                                      , rsl.itemcd
                                      , rsl.suffix
                                      , rsl.result
                                      , rsl.stdvaluecd
                                      , rsl.rslcmtcd1
                                      , rsl.rslcmtcd2
                                      , 1 rslflg
                                      from
                                           (
            ";

            // 受診履歴View --------------------Start
            // 'このViewを２回呼び出すため別変数にセットしておく
            sqlView = @"
                        select
                            rownum seq
                            , csldate
                            , rsvno
                            , perid
                        from
                            (
                              select
                                  consult.csldate
                                  , consult.rsvno
                                  , consult.perid
                              from
                                  consult
                              where
                                  consult.perid = (
                                                    select distinct
                                                        perid
                                                    from
                                                        consult
                                                    where
                                                        rsvno = :rsvno
                                                  )
            ";

            // 今回分を含む？
            sqlView += string.Format(@"
                              and consult.csldate  {0} (
                                                         select distinct
                                                           csldate
                                                         from
                                                           consult
                                                         where
                                                           rsvno = :rsvno
                                                        )
                                        ", (selectMode == 0 ? "<=" : "<")
                                );

            // コース指定
            switch (lastDspMode)
            {
                case 1:
                    sqlView += @"
                                    and consult.cscd = :cscd
                    ";
                    break;
                case 2:
                    sqlView += @"
                                    and consult.cscd in (
                                                          select
                                                            freefield1 cscd
                                                          from
                                                            free
                                                          where
                                                            freecd like :cscd || '%'
                                                        )
                    ";
                    break;
            }
            sqlView += @"
                                    and consult.cancelflg = 0
                                    order by
                                      consult.csldate desc)
            ";
            // 受診履歴View --------------------End

            sql = sql + sqlView;    //受診履歴View
            sql += @"
                                                ) consultview
                                                 , rsl
                                                 , grp_i
                                              where
                                                consultview.rsvno = rsl.rsvno
            ";

            if (localHisCount > 0)
            {
                sql += @"
                                                and consultview.seq between 1 and :hiscount
            ";
            }

            sql += @"
                                                and rsl.stopflg is null
                                                and grp_i.grpcd = :grpcd
                                                and grp_i.itemcd = rsl.itemcd
                                                and grp_i.suffix = rsl.suffix
            ";

            // 検査項目が存在しない項目も取得？
            if (allDataMode == 1)
            {
                // 検査結果項目の空レコード
                sql += @"
                                              union all
                                              select
                                                consultview.seq hisno
                                                , consultview.csldate
                                                , consultview.rsvno
                                                , consultview.perid
                                                , grp_i.seq
                                                , grp_i.itemcd
                                                , grp_i.suffix
                                                , null result
                                                , null stdvaluecd
                                                , null rslcmtcd1
                                                , null rslcmtcd2
                                                , 0 rslflg
                                              from
                                                (
                ";

                sql = sql + sqlView;      // 受診履歴View
                sql += @"
                                                 ) consultview
                                                , grp_i
                                              where
                                                grp_i.grpcd = :grpcd
                ";

                if (localHisCount > 0)
                {
                    sql += @"
                                                and consultview.seq between 1 and :hiscount
                            ";
                }

            }

            sql += @"
                                            )
                                      group by
                                         hisno
                                         , csldate
                                         , rsvno
                                         , perid
                                         , seq
                                         , itemcd
                                         , suffix
            ";

            sql += @"
                                     ) basersl
                                       , stdvalue_c
                                       , item_c
                                       , item_h
                                       , item_p
                                       , itemclass
                              where
                                basersl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                                and basersl.itemcd = item_c.itemcd
                                and basersl.suffix = item_c.suffix
                                and basersl.itemcd = item_h.itemcd
                                and basersl.suffix = item_h.suffix
                                and basersl.csldate between item_h.strdate and item_h.enddate
                                and item_c.itemcd = item_p.itemcd
                                and item_p.classcd = itemclass.classcd
                             ) finalrsl
            ";

            // 基準値要
            if (lowerValue != null || upperValue != null)
            {
                // 基準値取得View
                sql += @"
                             , (
                                  select
                                    itemcd
                                    , suffix
                                    , result
                                    , priorseq
                                    , lowervalue
                                    , uppervalue
                                  from
                                    (
                                      select
                                        rsl.itemcd
                                        , rsl.suffix
                                        , rsl.result
                                        , rslstdvalue.csrank
                                        , rslstdvalue.cscd
                                        , rslstdvalue.priorseq
                                        , rslstdvalue.stdflg
                                        , rslstdvalue.lowervalue
                                        , rslstdvalue.uppervalue
                ";

                // 管理コースの所在によっては複数ヒットすることもあるため､重みつけを行う(最も重いものに若い値)
                sql += @"
                                        , rank() over (
                                                        partition by
                                                        rslstdvalue.itemcd
                                                        , rslstdvalue.suffix
                                                        order by
                                                        rslstdvalue.csrank
                                                        , rslstdvalue.cscd
                                          ) stdrank
                ";

                // ビュー"RSLSTDVALUE"は値を直接指定しないとFULL SCANになるのでまず内部ビューで(アスタリスク指定で一寸手抜き)
                // 基準値のない検査結果もあるので(+)指定
                // 標準の基準値のみ取得する(NULL指定することで基準値のない検査項目も対象となる)
                // 最も重い値、即ち若い値で絞り込み
                sql += @"
                                    from
                                      (select * from rslstdvalue where rsvno = :rsvno) rslstdvalue
                                      , rsl
                                    where
                                      rsl.rsvno = :rsvno
                                      and rsl.itemcd = rslstdvalue.itemcd(+)
                                      and rsl.suffix = rslstdvalue.suffix(+)
                                      and rslstdvalue.stdflg = 'S')
                                    where
                                      stdrank = 1) stdvalueview
                ";
            }

            sql += @"
                    where
                        finalrsl.stcitemcd = sentence.itemcd(+)
                        and finalrsl.itemtype = sentence.itemtype(+)
                        and finalrsl.result = sentence.stccd(+)
            ";

            // 基準値要
            if (lowerValue != null || upperValue != null)
            {
                sql += @"
                            and finalrsl.itemcd = stdvalueview.itemcd(+)
                            and finalrsl.suffix = stdvalueview.suffix(+)
                ";
            }

            switch (getSeqMode)
            {
                case 0:
                    sql += @"
                            order by
                              finalrsl.seq
                              , finalrsl.csldate " + (dateSort == 0 ? " desc " : "")
                    ;
                    break;
                case 1:
                    sql += @"
                            order by
                              finalrsl.csldate " + (dateSort == 0 ? " desc " : "") +
                           @" , finalrsl.itemcd
                              , finalrsl.suffix
                    ";
                    break;
                case 2:
                    sql += @"
                            order by
                              finalrsl.csldate " + (dateSort == 0 ? " desc " : "") +
                           @" , finalrsl.seq
                    ";
                    break;
            }

            // 基準値要
            if (lowerValue != null || upperValue != null)
            {
                sql += @"
                            , stdvalueview.priorseq
                ";
            }

            List<dynamic> current = connection.Query(sql, param).ToList();

            // 配列形式で格納する
            count = 0;
            for (int i = 0; i < current.Count; i++)
            {
                stdValueFlg = false;

                // 基準値が複数レコードあるか？
                if (lowerValue != null || upperValue != null)
                {
                    if (count > 0)
                    {

                        if (Util.ConvertToString(retData[count - 1].RSVNO).Equals(Util.ConvertToString(current[i].RSVNO)) &&
                            Util.ConvertToString(retData[count - 1].ITEMCD).Equals(Util.ConvertToString(current[i].ITEMCD)) &&
                            Util.ConvertToString(retData[count - 1].SUFFIX).Equals(Util.ConvertToString(current[i].SUFFIX)))
                        {

                            stdValueFlg = true;
                        }
                    }
                }

                if (stdValueFlg)
                {
                    // 結果タイプが文章のとき特殊処理
                    if ("4".Equals(Util.ConvertToString(retData[count - 1].RESULTTYPE)))
                    {
                        retData[count - 1].UPPERVALUE += "," + Util.ConvertToString(current[i].UPPERVALUE);
                    }
                    else
                    {
                        // 前のレコードの基準値（最大値）のみを書き換える
                        retData[count - 1].UPPERVALUE = Util.ConvertToString(current[i].UPPERVALUE);
                    }
                }
                else
                {
                    retData.Add(current[i]);
                    count++;
                }
            }

            // 戻り値の設定
            return retData;
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者の検査結果歴を取得する（検査項目指定）
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="selectItemCd">検査項目コード（配列）</param>
        /// <param name="selectSuffix">サフィックス（配列）</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="getSeqMode">取得順 0:コード＋サフィックス＋日付　1:日付＋コード＋サフィックス</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <param name="allDataMode">全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）</param>
        /// <param name="lowerValue">基準値（最低）</param>
        /// <param name="upperValue">基準値（最高）</param>
        /// <param name="rslCmtName1">結果コメント名１</param>
        /// <param name="rslCmtName2">結果コメント名２</param>
        /// <param name="dateSort">日付順(0:今回が先頭、1:今回が最後)</param>
        /// <returns>
        /// hisno 履歴No.
        /// perid 個人ＩＤ
        /// csldate 受診日
        /// rsvno 予約番号
        /// itemcd 検査項目コード
        /// suffix サフィックス
        /// resulttype 結果タイプ
        /// itemtype 項目タイプ
        /// classname 検査分類名称
        /// itemname 検査項目名称
        /// rslflg 検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
        /// result 検査結果(数値タイプはそのまま、文章タイプは文章を返す)
        /// rslvalue 検査結果(数値タイプ、文章タイプにかかわらずそのまま返す)
        /// unit 単位
        /// lowervalue 基準値（最低）
        /// uppervalue 基準値（最高）
        /// stdflg 基準値フラグ
        /// cutargetflg CU経年変化表示対象
        /// rslcmtcd1 結果コメント１
        /// rslcmtname1 結果コメント名１
        /// rslcmtcd2 結果コメント２
        /// rslcmtname2 結果コメント名２
        /// datesort 日付順(0:今回が先頭、1:今回が最後)
        /// </returns>
        public List<dynamic> SelectHistoryRslList_Item(int rsvNo, string hisCount, List<string> selectItemCd, List<string> selectSuffix,
            int lastDspMode, string csGrp, int getSeqMode, int selectMode = 0, int allDataMode = 0, bool? lowerValue = null,
            bool? upperValue = null, bool? rslCmtName1 = null, bool? rslCmtName2 = null, int dateSort = 0)
        {
            string sql = "";                                // SQLステートメント
            string sqlView = "";                            // SQLステートメント（検査項目の指定）
            string sqlSelectItem;                           // SQLステートメント（検査項目の指定）

            long localHisCoun = 0;                          // 表示歴数
            int count = 0;                                  // レコード数

            bool stdValueFlg = false;                       // 基準値が複数レコードある:True
            List<dynamic> retData = new List<dynamic>();    // 戻り値

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                localHisCoun = long.Parse(hisCount);
            }
            else
            {
                localHisCoun = 0;
            }

            // 指定された検査項目コードとサフィックスの数が異なる場合はエラー
            if (selectItemCd != null && selectItemCd.Count > 0)
            {
                if (selectSuffix == null || selectSuffix.Count <= 0)
                {
                    throw new ArgumentException();
                }
                if (selectItemCd.Count != selectSuffix.Count)
                {
                    throw new ArgumentException();
                }
                sqlSelectItem = " IN ( ";
                for (int i = 0; i < selectItemCd.Count; i++)
                {
                    sqlSelectItem += (i == 0 ? "" : ",") + "'" + selectItemCd[i] + "-" + selectSuffix[i] + "'";
                }
                sqlSelectItem += " ) ";
            }
            else
            {
                if (selectSuffix != null && selectSuffix.Count > 0)
                {
                    throw new ArgumentException();
                }
                sqlSelectItem = " = '" + selectItemCd + "-" + selectSuffix + "' ";
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (localHisCoun > 0)
            {
                param.Add("hiscount", Convert.ToString(localHisCoun));
            }
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));

            sql = @"
                    select
                      finalrsl.hisno
                      , finalrsl.perid
                      , finalrsl.csldate
                      , finalrsl.rsvno
                      , finalrsl.itemcd
                      , finalrsl.suffix
                      , finalrsl.resulttype
                      , finalrsl.itemtype
                      , finalrsl.classname
                      , finalrsl.itemname
                      , finalrsl.rslflg
                      , finalrsl.result rslvalue
                      , finalrsl.stdflg
            ";

            // 検査結果のメモタイプ対応
            sql += @"
                      , case
                          when finalrsl.resulttype = 7
                          then (
                          select
                              rslmemostr
                          from
                              rslmemo
                          where
                              rsvno = finalrsl.rsvno
                              and itemcd = finalrsl.itemcd
                              and suffix = finalrsl.suffix
                          )
                          else nvl(sentence.shortstc, finalrsl.result)
                          end result
            ";

            // 基準値要
            if ((lowerValue != null) || (upperValue != null))
            {
                sql += @"
                          , getstandardrange(
                                              'l'
                                              , finalrsl.rsvno
                                              , finalrsl.itemcd
                                              , finalrsl.suffix
                                            ) lowervalue
                          , getstandardrange(
                                              'u'
                                              , finalrsl.rsvno
                                              , finalrsl.itemcd
                                              , finalrsl.suffix
                                            ) uppervalue
                ";
            }
            else
            {
                sql += @"
                          , null lowervalue
                          , null uppervalue
                ";
            }

            sql += @"
                          , finalrsl.rslcmtcd1
            ";

            // 結果コメント要
            if (rslCmtName1 != null)
            {
                sql += @"
                          , (
                            select
                              rslcmtname
                            from
                              rslcmt
                            where
                              rslcmtcd = finalrsl.rslcmtcd1
                          ) rslcmtname1
                ";
            }
            else
            {
                sql += @"
                          , null rslcmtname1
                ";
            }

            sql += @"
                          , finalrsl.rslcmtcd2
            ";

            // 結果コメント要
            if (rslCmtName2 != null)
            {
                sql += @"
                          , (
                              select
                                rslcmtname
                              from
                                rslcmt
                              where
                                rslcmtcd = finalrsl.rslcmtcd2
                            ) rslcmtname2
                ";
            }
            else
            {
                sql += @"
                          , null rslcmtname2
                ";
            }

            sql += @"
                          , finalrsl.unit
                          , finalrsl.cutargetflg
                        from
                            sentence
            ";

            // 検査結果View（検査結果が存在しない場合の対応）
            sql += @"
                          , (
                              select
                                basersl.hisno
                                , basersl.perid
                                , basersl.csldate
                                , basersl.rsvno
                                , basersl.itemcd
                                , basersl.suffix
                                , basersl.result
                                , basersl.rslflg
                                , basersl.rslcmtcd1
                                , basersl.rslcmtcd2
                                , stdvalue_c.stdflg
                                , itemclass.classname
                                , item_c.resulttype
                                , item_c.itemtype
                                , item_c.itemname
                                , item_c.stcitemcd
                                , item_c.cutargetflg
                                , item_h.unit
                              from
            ";

            // 検査結果に存在しない項目を取得のため、検査項目の空レコードと結合
            sql += @"
                                    (
                                      select
                                        hisno
                                        , csldate
                                        , rsvno
                                        , perid
                                        , itemcd
                                        , suffix
                                        , max(result) result
                                        , max(stdvaluecd) stdvaluecd
                                        , max(rslcmtcd1) rslcmtcd1
                                        , max(rslcmtcd2) rslcmtcd2
                                        , max(rslflg) rslflg
                                      from
            ";

            // 検査結果に存在するレコード
            sql += @"
                                            (
                                              select
                                                consultview.seq hisno
                                                , consultview.csldate
                                                , consultview.rsvno
                                                , consultview.perid
                                                , rsl.itemcd
                                                , rsl.suffix
                                                , rsl.result
                                                , rsl.stdvaluecd
                                                , rsl.rslcmtcd1
                                                , rsl.rslcmtcd2
                                                , 1 rslflg
                                              from
                                                (
            ";

            // 受診履歴View--------------------Start
            // このViewを２回呼び出すため別変数にセットしておく
            sqlView = @"
                        select
                          rownum seq
                          , csldate
                          , rsvno
                          , perid
                        from
                          (
                            select
                              consult.csldate
                              , consult.rsvno
                              , consult.perid
                            from
                              consult
                            where
                              consult.perid = (
                                                select distinct
                                                    perid
                                                from
                                                    consult
                                                where
                                                    rsvno = :rsvno
                                              )
            ";

            // 今回分を含む？
            sqlView = @"
                              and consult.csldate " + (selectMode == 0 ? " <= " : " < ") +
                      @"                                 select distinct
                                                             csldate
                                                         from
                                                             consult
                                                         where
                                                             rsvno = :rsvno
                                                        )
            ";

            // コース指定
            switch (lastDspMode)
            {
                case 1:
                    sqlView += @"
                              and consult.cscd = :cscd
                    ";
                    break;
                case 2:
                    sqlView += @"
                              and consult.cscd in (
                                select
                                  freefield1 cscd
                                from
                                  free
                                where
                                  freecd like :cscd || '%'
                              )
                    ";
                    break;
            }

            sqlView += @"
                              and consult.cancelflg = 0
                        order by
                        consult.csldate desc)
            ";
            // 受診履歴View --------------------End

            sql = sql + sqlView;        // 受診履歴View
            sql += @"
                                                ) consultview
                                                , rsl
                                              where
                                                consultview.rsvno = rsl.rsvno
            ";

            if (localHisCoun > 0)
            {
                sql += @"
                                              and consultview.seq between 1 and :hiscount
            ";
            }

            sql += @"
                                              and rsl.itemcd || '-' || rsl.suffix " +
                                              sqlSelectItem +
                   @"                         and rsl.stopflg is null
            ";

            // 検査項目が存在しない項目も取得？
            if (allDataMode == 1)
            {
                // 検査結果項目の空レコード
                sql += @"
                                       union all
                                       select
                                         consultview.seq hisno
                                         , consultview.csldate
                                         , consultview.rsvno
                                         , consultview.perid
                                         , item_c.itemcd
                                         , item_c.suffix
                                         , null result
                                         , null stdvaluecd
                                         , null rslcmtcd1
                                         , null rslcmtcd2
                                         , 0 rslflg
                                       from
                                         (
                ";

                sql += sqlView;        // 受診履歴View
                sql += @"
                                         ) consultview
                                         , item_c
                                       where
                                         item_c.itemcd || '-' || item_c.suffix " +
                                         sqlSelectItem
                ;

                if (localHisCoun > 0)
                {
                    sql += @"
                                         and consultview.seq between 1 and :hiscount
                ";
                }
            }

            sql += @"
                                    )
                                    group by
                                      hisno
                                      , perid
                                      , csldate
                                      , rsvno
                                      , itemcd
                                      , suffix
            ";

            sql += @"
                                ) basersl
                                , stdvalue_c
                                , item_c
                                , item_h
                                , item_p
                                , itemclass
                            where
                                basersl.stdvaluecd = stdvalue_c.stdvaluecd(+)
                                and basersl.itemcd = item_c.itemcd
                                and basersl.suffix = item_c.suffix
                                and basersl.itemcd = item_h.itemcd
                                and basersl.suffix = item_h.suffix
                                and basersl.csldate between item_h.strdate and item_h.enddate
                                and item_c.itemcd = item_p.itemcd
                                and item_p.classcd = itemclass.classcd
                        ) finalrsl
            ";

            sql += @"
                    where
                        finalrsl.stcitemcd = sentence.itemcd(+)
                        and finalrsl.itemtype = sentence.itemtype(+)
                        and finalrsl.result = sentence.stccd(+)
            ";

            if (getSeqMode == 0)
            {
                sql += @"
                        order by
                          finalrsl.itemcd
                          , finalrsl.suffix
                          , finalrsl.csldate " + (dateSort == 0 ? " desc " : "")
                ;
            }
            else
            {
                sql += @"
                        order by
                          finalrsl.csldate " + (dateSort == 0 ? " desc " : "") +
                      @"   , finalrsl.itemcd
                          , finalrsl.suffix
                ";
            }

            List<dynamic> current = connection.Query(sql, param).ToList();

            // 配列形式で格納する
            count = 0;
            for (int i = 0; i < current.Count; i++)
            {
                stdValueFlg = false;

                // 基準値が複数レコードあるか？
                if (lowerValue != null || upperValue != null)
                {
                    if (count > 0)
                    {

                        if (Util.ConvertToString(retData[count - 1].RSVNO).Equls(Util.ConvertToString(current[i].RSVNO)) &&
                            Util.ConvertToString(retData[count - 1].ITEMCD).Equls(Util.ConvertToString(current[i].ITEMCD)) &&
                            Util.ConvertToString(retData[count - 1].SUFFIX).Equls(Util.ConvertToString(current[i].SUFFIX)))
                        {

                            stdValueFlg = true;
                        }
                    }
                }

                if (stdValueFlg)
                {
                    // 結果タイプが文章のとき特殊処理
                    if ("4".Equals(Util.ConvertToString(retData[count - 1].RESULTTYPE)))
                    {
                        retData[count - 1].UPPERVALUE += "," + Util.ConvertToString(current[i].UPPERVALUE);
                    }
                    else
                    {
                        // 前のレコードの基準値（最大値）のみを書き換える
                        retData[count - 1].UPPERVALUE = Util.ConvertToString(current[i].UPPERVALUE);
                    }
                }
                else
                {
                    retData.Add(current[i]);
                    count++;
                }
            }

            // 戻り値の設定
            return retData;

        }

        /// <summary>
        /// 指定対象受診者の判定結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="hisCount">受診日</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="getSeqMode">取得順 0:表示順＋日付　1:日付＋表示順</param>
        /// <returns>
        /// perid 個人ＩＤ
        /// csldate 受診日
        /// rsvno 予約番号
        /// seq 表示位置
        /// judclasscd 判定分類コード
        /// judclassname判定分類名称
        /// judcd 判定コード
        /// judsname 判定略称
        /// weight 判定の重み
        /// upduser 更新者
        /// judcmtcd 判定コメントコード
        /// judcmtstc 判定コメント文章
        /// resultdispmode 検査結果表示モード
        /// updflg 更新フラグ
        /// </returns>
        public List<dynamic> SelectJudHistoryRslList(int rsvNo, string hisCount, int lastDspMode, string csGrp, int getSeqMode)
        {
            string sql = "";                                // SQLステートメント
            int count = 0;                                  // レコード数
            int hisCnt = 0;                                 // レコード数
            int historyCount = 0;                           // 表示歴数
            int bakJudClassCd = 0;                          // 判定分類コード（退避用）

            List<dynamic> retData = new List<dynamic>();    // 戻り値

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                historyCount = int.Parse(hisCount);
            }
            else
            {
                historyCount = 0;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (historyCount > 0)
            {
                param.Add("hiscount", Convert.ToString(historyCount));
            }
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));

            // 乳房特殊処理用判定分類コード
            param.Add("nyujudclasscd", NYUBOU_JUDCLASSCD);
            param.Add("syokujudclasscd", NYUSYOKU_JUDCLASSCD);
            param.Add("xsenjudclasscd", NYUSYOKU_JUDCLASSCD);
            param.Add("choujudclasscd", NYUSYOKU_JUDCLASSCD);

            sql = @"
                    select
                      finalrsl.perid
                      , finalrsl.csldate
                      , finalrsl.rsvno
                      , nvl(finalrsl.seq, 1) seq
                      , judclass.judclasscd
                      , judclass.judclassname
                      , judclass.resultdispmode
                      , finalrsl.judcd
                      , jud.judsname
                      , jud.weight
                      , finalrsl.upduser
                      , finalrsl.updflg
                      , finalrsl.judcmtcd
                      , judcmtstc.judcmtstc
            ";

            sql += @"
                    from
                      jud
                      , judcmtstc
                      , judclass
                      , (
                        select
                          judclassview.csldate
                          , judclassview.rsvno
                          , judclassview.perid
                          , judclassview.seq
                          , judclassview.judclasscd
                          , judrsl.judcd
                          , judrsl.upduser
                          , judrsl.updflg
                          , judrsl.judcmtcd
            ";

            // 予約ごとに入力の必要な判定分類を取得
            sql += @"
                    from
                      (
                        select
                          finalconsult.csldate
                          , finalconsult.rsvno
                          , finalconsult.perid
                          , finalconsult.seq
                          , finalconsult.cscd
                          , course_jud.judclasscd
                        from
                          (
                            select
                              consultview.csldate
                              , consultview.rsvno
                              , consultview.perid
                              , consultview.seq
                              , consultview.cscd
                            from
                              (
                                select
                                  rownum seq
                                  , csldate
                                  , rsvno
                                  , perid
                                  , cscd
                                from
                                  (
                                    select
                                      consult.csldate
                                      , consult.rsvno
                                      , consult.perid
                                      , consult.cscd
                                    from
                                      consult
            ";

            sql += @"
                                    where
                                      consult.perid = (
                                                        select distinct
                                                          perid
                                                        from
                                                          consult
                                                        where
                                                          rsvno = :rsvno
                                                      )
            ";

            // コース指定
            switch (lastDspMode)
            {
                case 1:
                    sql += @"
                                      and consult.cscd = :cscd
                    ";
                    break;
                case 2:
                    sql += @"
                                      and consult.cscd in (
                                                            select
                                                              freefield1 cscd
                                                            from
                                                              free
                                                            where
                                                              freecd like :cscd || '%'
                                                          )
                    ";
                    break;
            }

            sql += @"
                                      and consult.csldate <= (
                                                                select distinct
                                                                  csldate
                                                                from
                                                                  consult
                                                                where
                                                                  rsvno = :rsvno
                                                              )
                                      and consult.cancelflg = 0
                                    order by
                                      consult.csldate desc
                                      , consult.cscd desc
                                  )
                              ) consultview
            ";

            // 履歴指定？
            if (historyCount > 0)
            {
                sql += @"
                            where consultview.seq between 1 and :hiscount
                ";
            }

            // 判定の必要な判定分類コードを検索
            // 自動展開フラグが立っている、或いは判定分類内の検査項目が健診結果に存在するかを判定
            // ### 中止フラグ(STOPFLG)がたっていないかも見る
            sql += @"
                          ) finalconsult
                            , course_jud
                        where
                            finalconsult.cscd = course_jud.cscd
                            and (
                                  course_jud.noreason = 1
                                  or exists (
                                                select
                                                  rsl.rsvno
                                                from
                                                  item_jud
                                                  , rsl
                                                where
                                                  rsl.rsvno = finalconsult.rsvno
                                                  and rsl.itemcd = item_jud.itemcd
                                                  and rsl.stopflg is null
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
                                                rsl.rsvno = finalconsult.rsvno
                                                and rsl.itemcd = item_jud.itemcd
                                                and rsl.stopflg is null
                                                and item_jud.judclasscd in (
                                                                              :syokujudclasscd
                                                                              , :xsenjudclasscd
                                                                              , :choujudclasscd
                                                                            )
                                            )
                                    and course_jud.judclasscd = :nyujudclasscd
                                  )
                                  or (
                                        exists (
                                                  select
                                                    judrsl.judclasscd
                                                  from
                                                    judrsl
                                                  where
                                                    judrsl.rsvno = finalconsult.rsvno
                                                    and judrsl.judclasscd = course_jud.judclasscd
                                                    and judrsl.judcd is not null
                                                )
                                      )
                                )
            ";

            // 判定結果が入力されていなくても取得
            sql += @"
                            ) judclassview
                              , judrsl
                        where
                          judclassview.rsvno = judrsl.rsvno(+)
                          and judclassview.judclasscd = judrsl.judclasscd(+)
            ";

            sql += @"
                        ) finalrsl
                    where
                      finalrsl.judcd = jud.judcd(+)
                      and finalrsl.judclasscd(+) = judclass.judclasscd
                      and judclass.commentonly is null
                      and finalrsl.judcmtcd = judcmtstc.judcmtcd(+)
            ";

            if (getSeqMode == 0)
            {
                sql += @"
                        order by
                          finalrsl.csldate desc
                          , judclass.vieworder
                ";
            }
            else
            {
                sql += @"
                        order by
                          judclass.vieworder
                          , finalrsl.csldate desc
            ";
            }

            List<dynamic> current = connection.Query(sql, param).ToList();
            // 検索レコードが存在する場合
            if (current.Count > 0)
            {
                // 配列形式で格納する
                count = 0;
                bakJudClassCd = 0;
                for (int curIdx = 0; curIdx < current.Count;)
                {
                    bakJudClassCd = int.Parse(Util.ConvertToString(current[curIdx].JUDCLASSCD));

                    // 該当履歴番号が無ければ空データを作る
                    for (hisCnt = 1; hisCnt <= historyCount; hisCnt++)
                    {
                        if (curIdx == current.Count)
                        {
                            break;
                        }

                        dynamic newRec = new ExpandoObject();
                        if (bakJudClassCd != int.Parse(Util.ConvertToString(current[curIdx].JUDCLASSCD)))
                        {
                            newRec.RSVNO = "";
                            newRec.SEQ = hisCnt;
                            if (hisCnt == 1)
                            {
                                newRec.JUDCLASSCD = current[curIdx].JUDCLASSCD;
                                newRec.JUDCLASSNAME = current[curIdx].JUDCLASSNAME;
                                newRec.RESULTDISPMODE = current[curIdx].RESULTDISPMODE;
                            }
                            else
                            {
                                newRec.JUDCLASSCD = retData[count - 1].JUDCLASSCD;
                                newRec.JUDCLASSNAME = retData[count - 1].JUDCLASSNAME;
                                newRec.RESULTDISPMODE = retData[count - 1].RESULTDISPMODE;
                            }
                            newRec.JUDCD = "";
                            newRec.JUDSNAME = "";
                            newRec.WEIGHT = "";
                            newRec.UPDUSER = "";
                            newRec.UPDFLG = "";
                            newRec.JUDCMTCD = "";
                            newRec.JUDCMTSTC = "";

                            count += 1;
                        }
                        else
                        {
                            if (long.Parse(Util.ConvertToString(current[curIdx].SEQ)) != hisCnt)
                            {
                                newRec.RSVNO = "";
                                newRec.SEQ = hisCnt;
                                if (hisCnt == 1)
                                {
                                    newRec.JUDCLASSCD = current[curIdx].JUDCLASSCD;
                                    newRec.JUDCLASSNAME = current[curIdx].JUDCLASSNAME;
                                    newRec.RESULTDISPMODE = current[curIdx].RESULTDISPMODE;
                                }
                                else
                                {
                                    newRec.JUDCLASSCD = retData[count - 1].JUDCLASSCD;
                                    newRec.JUDCLASSNAME = retData[count - 1].JUDCLASSNAME;
                                    newRec.RESULTDISPMODE = retData[count - 1].RESULTDISPMODE;
                                }
                                newRec.JUDCD = "";
                                newRec.JUDSNAME = "";
                                newRec.WEIGHT = "";
                                newRec.UPDUSER = "";
                                newRec.UPDFLG = "";
                                newRec.JUDCMTCD = "";
                                newRec.JUDCMTSTC = "";
                            }
                            else
                            {
                                newRec.RSVNO = current[curIdx].RSVNO;
                                newRec.SEQ = current[curIdx].SEQ;
                                newRec.JUDCLASSCD = current[curIdx].JUDCLASSCD;
                                newRec.JUDCLASSNAME = current[curIdx].JUDCLASSNAME;
                                newRec.JUDCD = current[curIdx].JUDCD;
                                newRec.JUDSNAME = current[curIdx].JUDSNAME;
                                newRec.WEIGHT = current[curIdx].WEIGHT;
                                newRec.UPDUSER = current[curIdx].UPDUSER;
                                newRec.UPDFLG = current[curIdx].UPDFLG;
                                newRec.JUDCMTCD = current[curIdx].JUDCMTCD;
                                newRec.JUDCMTSTC = current[curIdx].JUDCMTSTC;
                                newRec.RESULTDISPMODE = current[curIdx].RESULTDISPMODE;

                                curIdx += 1;
                            }
                            count += 1;
                        }
                        retData.Add(newRec);
                    }
                }
            }

            if (hisCnt < historyCount)
            {
                for (int i = hisCnt; i <= historyCount; i++)
                {
                    dynamic newRec = new ExpandoObject();
                    newRec.RSVNO = "";
                    newRec.SEQ = hisCnt;
                    newRec.JUDCLASSCD = retData[count - 1].JUDCLASSCD;
                    newRec.JUDCLASSNAME = retData[count - 1].JUDCLASSNAME;
                    newRec.JUDCD = "";
                    newRec.JUDSNAME = "";
                    newRec.WEIGHT = "";
                    newRec.UPDUSER = "";
                    newRec.UPDFLG = "";
                    newRec.JUDCMTCD = "";
                    newRec.JUDCMTSTC = "";
                    newRec.RESULTDISPMODE = retData[count - 1].RESULTDISPMODE;
                    retData.Add(newRec);

                    count++;
                }
            }

            // 戻り値の設定
            return retData;

        }

        /// <summary>
        /// 指定された予約番号の総合コメントを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類（1:総合コメント、2:生活指導コメント、3:食習慣コメント、4:献立コメント）</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード：0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <param name="selectMode">データ取得モード（0:今回分含む、1:前回分以前）</param>
        /// <returns>
        /// rsvno 予約番号
        /// csldate 受診日
        /// cscd コースコード
        /// csname コース名
        /// judcmtcd 判定コメントコード
        /// judcmtstc 判定コメント文章
        /// judclasscd 判定分類コード
        /// judcd 判定コード
        /// weight 判定重み
        /// </returns>
        public List<dynamic> SelectTotalJudCmt(int rsvNo, int dispMode, string hisCount, int lastDspMode = 0, string csGrp = null, int selectMode = 0)
        {
            string sql = "";                        // SQLステートメント
            long localHistoryCount = 0;             // 表示歴数

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!"*".Equals(hisCount))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                localHistoryCount = long.Parse(hisCount);
            }
            else
            {
                localHistoryCount = 0;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("dispmode", dispMode);
            if (localHistoryCount > 0)
            {
                param.Add("hiscount", Convert.ToString(localHistoryCount));
            }

            // 指定された予約番号の総合コメントを指定表示暦数分取得する
            sql = @"
                    select
                      consultview.rsvno
                      , consultview.csldate
                      , consultview.cscd
                      , course_p.csname
                      , totaljudcmt.seq
                      , totaljudcmt.judcmtcd
                      , judcmtstc.judcmtstc
                      , judcmtstc.judclasscd
                      , judcmtstc.judcd
                      , jud.weight
                    from
                      totaljudcmt
                      , judcmtstc
                      , course_p
                      , jud
                      , (
                        select
                          rownum seq
                          , csldate
                          , rsvno
                          , perid
                          , cscd
                        from
                          (
                            select
                              consult.csldate
                              , consult.rsvno
                              , consult.perid
                              , consult.cscd
                            from
                              consult
            ";

            sql += @"
                            where
                              consult.perid = (
                                                select distinct
                                                  perid
                                                from
                                                  consult
                                                where
                                                  rsvno = :rsvno
                                              )
            ";

            sql += @"
                              and consult.csldate
            ";

            // 今回分含む？
            if (selectMode == 0)
            {
                sql += @"
                                    <=
                ";
            }
            else
            {
                sql += @"
                                    <
                ";

            }

            sql += @"
                                        (
                                          select distinct
                                            csldate
                                          from
                                            consult
                                          where
                                            rsvno = :rsvno
                                        )
            ";

            // コース指定
            switch (lastDspMode)
            {
                case 1:
                    param.Add("cscd", csGrp.Trim());
                    sql += @"
                              and consult.cscd = :cscd
                    ";
                    break;
                case 2:
                    param.Add("cscd", csGrp.Trim());
                    sql += @"
                              and consult.cscd in (
                                                    select
                                                        freefield1 cscd
                                                    from
                                                        free
                                                    where
                                                        freecd like :cscd || '%'
                                                  )
                    ";
                    break;
            }

            sql += @"
                              and consult.cancelflg = 0
                            order by
                              consult.csldate desc
                          )
                        ) consultview
                    where
                      consultview.rsvno = totaljudcmt.rsvno
                      and totaljudcmt.dispmode = :dispmode
            ";

            if (localHistoryCount > 0)
            {
                sql += @"
                         and consultview.seq between 1 and :hiscount
                ";
            }
            sql += @"
                      and totaljudcmt.judcmtcd = judcmtstc.judcmtcd
                      and jud.judcd(+) = judcmtstc.judcd
                      and consultview.cscd(+) = course_p.cscd
                    order by
                      consultview.csldate
                      , consultview.rsvno
                      , totaljudcmt.seq
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();

        }

        /// <summary>
        /// 指定された予約番号の総合コメントを更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類</param>
        /// <param name="seqs">表示順</param>
        /// <param name="judCmtCd">判定コメントコード</param>
        /// <param name="judCmtCdStc">判定コメント</param>
        /// <param name="updUser">更新者</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateTotalJudCmt(int rsvNo, int dispMode, List<string> seqs, List<string> judCmtCd = null, List<string> judCmtCdStc = null, string updUser = null)
        {
            string sql = "";                // SQLステートメント

            Insert ret = Insert.Error;      //  戻り値

            long arraySize = 0;             // 更新レコード配列数
            long logCnt = 0;                // 変更履歴件数
            string rsvDate = "";            // 予約日
            long bakCnt = 0;                // 件数
            long chkFlg = 0;                // チェックフラグ
            long updFlg = 0;                // 更新有無フラグ

            List<JToken> items = new List<JToken>();

            // 配列数
            arraySize = 1;
            if (seqs != null)
            {
                arraySize = seqs.Count;
            }

            // 現状を退避
            List<dynamic> bakResult = SelectTotalJudCmt(rsvNo, dispMode, "1");
            bakCnt = bakResult.Count;

            using (var ts = new TransactionScope())
            {
                try
                {

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("logrsvno", rsvNo);

                    // 予約日取得
                    sql = @"
                            select
                              rsvdate
                            from
                              consult
                            where
                              rsvno = :logrsvno
                    ";
                    dynamic current = connection.Query(sql, param).FirstOrDefault();

                    // 検索レコードが存在する場合
                    if (current != null)
                    {
                        // 予約日
                        rsvDate = Convert.ToString(current.RSVDATE);
                    }
                    else
                    {
                        throw new ArgumentException();
                    }

                    logCnt = 0;
                    // 削除の有無確認
                    for (int i = 0; i < bakCnt; i++)
                    {
                        chkFlg = 0;
                        for (int j = 0; j < arraySize; j++)
                        {
                            string wkJudCmtCd = Convert.ToString(judCmtCd[j]);
                            // 更新後もあり？
                            if (wkJudCmtCd.Equals(Convert.ToString(bakResult[i].JUDCMTCD)))
                            {
                                chkFlg = 1;
                                break;
                            }
                        }

                        // 削除された
                        if (chkFlg == 0)
                        {
                            JObject item = new JObject();
                            item["updclass"] = 3;
                            item["upddiv"] = "D";
                            item["rsvno"] = rsvNo;
                            item["rsvdate"] = rsvDate;
                            // 総合コメント
                            switch (dispMode)
                            {
                                case 1:
                                    item["judclasscd"] = "";
                                    break;
                                case 2:
                                    item["judclasscd"] = LIFE_JUDCLASSCD;
                                    break;
                                case 3:
                                    item["judclasscd"] = FOOD_JUDCLASSCD;
                                    break;
                                case 4:
                                    item["judclasscd"] = MENU_JUDCLASSCD;
                                    break;
                                default:
                                    item["judclasscd"] = "";
                                    break;
                            }
                            item["beforeresult"] = bakResult[i].JUDCMTCD;
                            item["afterresult"] = "";

                            logCnt++;
                            items.Add(item);
                        }

                    }

                    // 追加の有無確認
                    for (int i = 0; i < arraySize; i++)
                    {
                        chkFlg = 0;
                        for (int j = 0; j < bakCnt; j++)
                        {
                            // 表示順が数字で無いものは無視
                            if (!Information.IsNumeric(seqs[i]))
                            {
                                chkFlg = 1;
                                break;
                            }

                            // コメントコードブランクは無視
                            if (long.Parse(seqs[i]) <= 0 || string.IsNullOrEmpty(judCmtCd[i]))
                            {
                                chkFlg = 1;
                                break;
                            }

                            // 修正前もあり？
                            if (judCmtCd[i].Equals(bakResult[j].JUDCMTCD))
                            {
                                chkFlg = 1;
                                break;
                            }
                        }

                        // 追加された
                        if (chkFlg == 0)
                        {
                            JObject item = new JObject();
                            item["updclass"] = 3;
                            item["upddiv"] = "I";
                            item["rsvno"] = rsvNo;
                            item["rsvdate"] = rsvDate;
                            // 総合コメント
                            switch (dispMode)
                            {
                                case 1:
                                    item["judclasscd"] = "";
                                    break;
                                case 2:
                                    item["judclasscd"] = LIFE_JUDCLASSCD;
                                    break;
                                case 3:
                                    item["judclasscd"] = FOOD_JUDCLASSCD;
                                    break;
                                case 4:
                                    item["judclasscd"] = MENU_JUDCLASSCD;
                                    break;
                                default:
                                    item["judclasscd"] = "";
                                    break;
                            }
                            item["beforeresult"] = "";
                            item["afterresult"] = judCmtCdStc[i];

                            logCnt++;
                            items.Add(item);
                        }
                    }

                    // 変更履歴登録あり
                    if (logCnt > 0)
                    {
                        // 総合コメント更新履歴をセットする
                        UpdateLogTotalJudCmt(updUser, items);
                    }

                    // キー及び更新値の設定
                    param.Add("dispmode", dispMode);

                    // 指定された予約番号の総合コメントをすべて削除する
                    sql = @"
                            delete totaljudcmt
                            where
                              totaljudcmt.rsvno = :logrsvno
                              and totaljudcmt.dispmode = :dispmode
                    ";
                    connection.Execute(sql, param);

                    if (arraySize > 0)
                    {
                        updFlg = 0;

                        // キー及び更新値の設定
                        var sqlParamArray = new List<dynamic>();

                        for (int i = 0; i < arraySize; i++)
                        {
                            // 表示順が数字
                            if (Information.IsNumeric(seqs[i]))
                            {
                                if (long.Parse(seqs[i]) > 0 && !string.IsNullOrEmpty(judCmtCd[i]))
                                {
                                    sqlParamArray.Add(new
                                    {
                                        rsvno = rsvNo,
                                        dispmode = dispMode,
                                        seq = seqs[i],
                                        judcmtcd = judCmtCd[i],
                                    });
                                    updFlg = 1;
                                }
                            }

                        }

                        // 更新あり？
                        if (updFlg == 1)
                        {
                            sql = @"
                                    insert
                                    into
                                        totaljudcmt
                                    values (
                                        :rsvno
                                        , :dispmode
                                        , :seq
                                        , :judcmtcd
                                   )
                            ";
                            connection.Execute(sql, sqlParamArray);
                        }
                    }

                    if (!FncSortTotalJudCmt(rsvNo, dispMode))
                    {
                        throw new ArgumentException();
                    }

                    ts.Complete();

                    ret = Insert.Normal;

                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定

                    ret = Insert.Error;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 総合コメント更新履歴をセットする
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="data">
        /// updclass 更新分類
        /// upddiv 処理区分
        /// rsvno 予約番号
        /// rsvdate 予約日
        /// judclasscd 判定分類コード
        /// beforeresult 更新前値
        /// afterresult 更新後値
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateLogTotalJudCmt(string updUser, List<JToken> data = null)
        {
            string sql = "";                // SQLステートメント

            Insert ret = Insert.Error;      //  戻り値

            long arraySize = 0;             // 更新レコード配列数

            if (data != null)
            {
                // 配列数
                List<JToken> items = data.ToList<JToken>();
                arraySize = items.Count;

                if (arraySize > 0)
                {
                    using (var ts = new TransactionScope())
                    {
                        try
                        {
                            for (int i = 0; i < arraySize; i++)
                            {
                                // キー及び更新値の設定
                                var param = new Dictionary<string, object>();
                                param.Add("upduser", updUser.Trim());
                                param.Add("updclass", Convert.ToString(items[i]["updclass"]).Trim());
                                param.Add("upddiv", Convert.ToString(items[i]["upddiv"]).Trim());
                                param.Add("rsvno", Convert.ToString(items[i]["rsvno"]).Trim());
                                param.Add("rsvdate", Convert.ToDateTime(items[i]["rsvdate"]));
                                param.Add("judclasscd", Convert.ToString(items[i]["judclasscd"]).Trim());
                                param.Add("beforeresult", Convert.ToString(items[i]["beforeresult"]).Trim());
                                param.Add("afterresult", Convert.ToString(items[i]["afterresult"]).Trim());

                                // 検査結果更新
                                sql = @"
                                        insert
                                        into updatelog(
                                          upddate
                                          , upduser
                                          , updclass
                                          , upddiv
                                          , rsvno
                                          , rsvdate
                                    ";

                                sql += @"
                                          , judclasscd
                                    ";

                                if (!string.IsNullOrEmpty(Convert.ToString(items[i]["beforeresult"])) &&
                                    !Convert.ToString(items[i]["beforeresult"]).Trim().Equals(""))
                                {
                                    sql += @"
                                              , beforeresult
                                        ";
                                }
                                if (!string.IsNullOrEmpty(Convert.ToString(items[i]["afterresult"])) &&
                                    !Convert.ToString(items[i]["afterresult"]).Trim().Equals(""))
                                {
                                    sql += @"
                                          , afterresult
                                        ";
                                }

                                sql += @"
                                         )
                                    ";

                                sql += @"
                                            values (
                                              sysdate
                                              , :upduser
                                              , :updclass
                                              , :upddiv
                                              , :rsvno
                                              , :rsvdate
                                    ";

                                if (!string.IsNullOrEmpty(Convert.ToString(items[i]["judclasscd"])) &&
                                    !Convert.ToString(items[i]["judclasscd"]).Trim().Equals(""))
                                {
                                    sql += @"
                                                  , :judclasscd
                                        ";
                                }
                                else
                                {
                                    sql += @"
                                                  , null
                                        ";
                                }
                                if (!string.IsNullOrEmpty(Convert.ToString(items[i]["beforeresult"])) &&
                                    !Convert.ToString(items[i]["beforeresult"]).Trim().Equals(""))
                                {
                                    sql += @"
                                                  , :beforeresult
                                        ";
                                }
                                if (!string.IsNullOrEmpty(Convert.ToString(items[i]["afterresult"])) &&
                                    !Convert.ToString(items[i]["afterresult"]).Trim().Equals(""))
                                {
                                    sql += @"
                                                  , :afterresult
                                        ";
                                }

                                sql += @" ) ";

                                connection.Execute(sql, param);

                                ts.Complete();

                                ret = Insert.Normal;
                            }
                        }
                        catch
                        {
                            // エラー発生時はトランザクションをアボートに設定

                            ret = Insert.Error;
                        }
                    }
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定された予約番号と同一のコースを含むコースグループを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// csgrpcd コースグループコード
        /// csgrpname コースグループ名
        /// </returns>
        public List<dynamic> SelectCsGrp(int rsvNo)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 指定された予約番号と同一のコースを含むコースグループを取得する
            sql = @"
                    select
                      cspview.csgrpcd
                      , cspview.csgrpname
                    from
                      free
                      , (
                        select
                          freefield1 csgrpname
                          , freefield2 csgrpcd
                        from
                          free
                        where
                          freecd like 'CSP%'
                      ) cspview
                    where
                      free.freecd like cspview.csgrpcd || '%'
                      and free.freefield1 = (
                                              select
                                                cscd
                                              from
                                                consult
                                              where
                                                rsvno = :rsvno
                                            )
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定検索条件の変更履歴を取得する。
        /// </summary>
        /// <param name="startUpdDate">検索条件：更新日（開始）</param>
        /// <param name="endUpdDate">検索条件：更新日（終了）</param>
        /// <param name="searchUpdUser">検索条件：更新者</param>
        /// <param name="searchUpdClass">検索条件：更新分類（０：すべて）</param>
        /// <param name="orderbyItem">並べ替え項目(0:更新日,1:更新者,2:分類・項目）</param>
        /// <param name="orderbyMode">並べ替え方法(0:昇順,1:降順)</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// upddate 更新日時
        /// upduser 更新者
        /// updusername 更新者氏名
        /// updclass 更新分類
        /// upddiv 処理区分
        /// rsvno 予約番号
        /// rsvdate 予約日
        /// itemcd 更新項目コード
        /// suffix サフィックス
        /// itemname 更新項目名称
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名称
        /// beforeresult 更新前値
        /// afterresult 更新後値
        /// </returns>
        public PartialDataSet SelectUpdateLogList(string startUpdDate, string endUpdDate, string searchUpdUser, string searchUpdClass, int orderbyItem, int orderbyMode, int startPos, int pageMaxLine, string rsvNo = null)
        {
            string sql = "";                // SQLステートメント
            string sql2 = "";               // SQLステートメント
            string sql_count = "";          // SQLステートメント
            string sql_data = "";           // SQLステートメント

            string bakDate = "";            // 日付比較時退避用

            int allCount = 0;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            // 日付未指定の場合、当日日付をセット　（aspの処理とつじつまを合わせるため）
            if (string.IsNullOrEmpty(startUpdDate) || !Information.IsDate(startUpdDate))
            {
                startUpdDate = DateTime.Now.ToString("yyyy/MM/dd");
            }
            if (string.IsNullOrEmpty(endUpdDate) || !Information.IsDate(endUpdDate))
            {
                endUpdDate = DateTime.Now.ToString("yyyy/MM/dd");
            }
            // 更新日　開始終了あり で開始終了逆？
            if (!string.IsNullOrEmpty(startUpdDate) && Information.IsDate(startUpdDate) &&
               !string.IsNullOrEmpty(endUpdDate) && Information.IsDate(endUpdDate))
            {
                if (DateTime.Parse(startUpdDate) > DateTime.Parse(endUpdDate))
                {
                    bakDate = startUpdDate;
                    startUpdDate = endUpdDate;
                    endUpdDate = bakDate;
                }
            }
            // 検索条件に更新日あり？
            if (!string.IsNullOrEmpty(startUpdDate) && Information.IsDate(startUpdDate))
            {
                param.Add("supddate", startUpdDate.Trim());
            }
            if (!string.IsNullOrEmpty(endUpdDate) && Information.IsDate(endUpdDate))
            {
                param.Add("eupddate", DateTime.Parse(endUpdDate.Trim()).AddDays(1));
            }

            // 検索条件に更新者あり？
            if (!string.IsNullOrEmpty(searchUpdUser))
            {
                param.Add("srcupduser", searchUpdUser.Trim());
            }

            // 検索条件に更新分類あり？
            if (string.IsNullOrEmpty(searchUpdClass))
            {
                searchUpdClass = "0";
            }
            param.Add("srcupdclass", searchUpdClass);
            param.Add("startpos", startPos);
            if (pageMaxLine > 0)
            {
                param.Add("endpos", (startPos + pageMaxLine - 1));
            }
            sql_count = " select count(*) as allcount";
            sql_data = @"
                        select
                          logview.upddate
                          , logview.upduser
                          , logview.updusername
                          , logview.updclass
                          , logview.upddiv
                          , logview.rsvno
                          , logview.rsvdate
                          , logview.itemcd
                          , logview.suffix
                          , nvl(
                            logview.itemname
                            , logview.itemcd || logview.suffix
                          ) itemname
                          , logview.judclasscd
                          , nvl(logview.judclassname, logview.judclasscd) judclassname
                          , logview.beforeresult
                          , logview.afterresult
            ";

            sql = @"
                    from
                      (
                        select
                          rownum seq
                          , updatelogview.upddate
                          , updatelogview.upduser
                          , hainsuser.username updusername
                          , updatelogview.updclass
                          , updatelogview.upddiv
                          , updatelogview.rsvno
                          , updatelogview.rsvdate
                          , updatelogview.itemcd
                          , updatelogview.suffix
                          , item_c.itemname
                          , updatelogview.judclasscd
                          , judclass.judclassname
                          , updatelogview.beforeresult
                          , updatelogview.afterresult
            ";

            sql += @"
                        from
                          (
                            select
                              updatelog.upddate
                              , updatelog.upduser
                              , updatelog.updclass
                              , updatelog.upddiv
                              , updatelog.rsvno
                              , updatelog.rsvdate
                              , updatelog.itemcd
                              , updatelog.suffix
                              , updatelog.judclasscd
                              , updatelog.beforeresult
                              , updatelog.afterresult
                            from
                              updatelog
            ";

            // 検索条件に更新日 開始あり？
            sql += @"
                            where
                              updatelog.upddate between :supddate and :eupddate
            ";

            // 検索条件に更新者あり？
            if (!string.IsNullOrEmpty(searchUpdUser))
            {
                sql += @"
                            and updatelog.upduser = :srcupduser
                ";
            }

            // 検索条件に更新分類あり？
            if (!searchUpdClass.Equals("0"))
            {
                sql += @"
                            and updatelog.updclass = :srcupdclass
                ";
            }

            // 検索条件に予約番号あり？
            if (!string.IsNullOrEmpty(rsvNo))
            {
                param.Add("srcrsvno", rsvNo);
                sql += @"
                            and updatelog.rsvno = :srcrsvno
                ";
            }

            // 降順？
            if (orderbyMode == 1)
            {
                sql2 = " desc ";
            }
            else
            {
                sql2 = " asc ";
            }

            // 並び替えの指定
            sql += @"
                    order by
            ";
            switch (orderbyItem)
            {
                case 0:
                    // 更新日
                    sql += " updatelog.upddate " + sql2;
                    break;
                case 1:
                    // 更新者
                    sql += " updatelog.upduser " + sql2;
                    break;
                case 2:
                    // 分類・項目
                    sql += " updatelog.updclass " + sql2 +
                           " ,updatelog.itemcd " + sql2 +
                           " ,updatelog.suffix " + sql2 +
                           " ,updatelog.judclasscd " + sql2;
                    break;
                default:
                    sql += " updatelog.upddate " + sql2;
                    break;
            }

            sql += @"
                        ) updatelogview
                        , item_c
                        , judclass
                        , hainsuser
                    where
                      updatelogview.itemcd = item_c.itemcd(+)
                      and updatelogview.suffix = item_c.suffix(+)
                      and updatelogview.judclasscd = judclass.judclasscd(+)
                      and updatelogview.upduser = hainsuser.userid(+)
                    ) logview
            ";

            // 全件数取得
            sql_count += sql;
            dynamic current = connection.Query(sql_count, param).FirstOrDefault();

            if (current != null)
            {
                allCount = Decimal.ToInt32(current.ALLCOUNT);
            }

            // 取得件数で絞込み
            sql += "  where logview.seq >= :startpos ";
            if (pageMaxLine > 0)
            {
                sql += "    and logview.seq <= :endpos ";
            }

            // データ取得
            sql_data += sql;

           List<dynamic> query = connection.Query(sql_data, param).ToList();


            // 件数取得にて０件の場合は処理を終了する
            if (allCount == 0)
            {
                query = new List<dynamic>();
            }
            
            // 戻り値の設定
            return new PartialDataSet(allCount, query);
        }

        /// <summary>
        /// 指定された予約番号のオーダ番号、送信日を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <returns>
        /// orderno オーダ番号
        /// senddate 送信日
        /// </returns>
        public dynamic SelectOrderNo(int rsvNo, string orderDiv)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("orderdiv", orderDiv);

            // 指定された予約番号と同一のコースを含むコースグループを取得する
            sql = @"
                    select distinct
                      orderno
                      , senddate
                    from
                      ordereddoc
                    where
                      rsvno = :rsvno
                      and orderdiv = :orderdiv
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 健診が終わった後受診者の個人IDを変更した場合、変更前のIDと変更後のIDを取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// peridbefore 変更前個人ID
        /// peridafter 変更後個人ID
        /// </returns>
        public dynamic SelectChangePerId(int rsvNo)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            sql = @"
                    select
                      freefield2 as peridbefore
                      , freefield3 as peridafter
                    from
                      free
                    where
                      freecd like 'chgperid%'
                      and freefield1 = :rsvno
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// eGFR計算結果を履歴として取得
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <returns>
        /// hisno 履歴No.
        /// csldate 来院日
        /// egfr eGFR計算結果
        /// </returns>
        public List<dynamic> SelectEGFRHistory(int rsvNo, string hisCount, string csGrp)
        {
            string sql = "";                // SQLステートメント

            long historyCount;              // 表示歴数

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                historyCount = long.Parse(hisCount);
            }
            else
            {
                historyCount = 0;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (historyCount > 0)
            {
                param.Add("hiscount", Convert.ToString(historyCount));
            }
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));

            sql = @"
                    select
                      finalrsl.hisno hisno
                      , finalrsl.csldate csldate
                      , max(finalrsl.egfr) egfr
                    from
                      (
                        select
                          consultview.seq hisno
                          , consultview.csldate csldate
                          , decode(
                            person.gender
                            , 1
                            , (
                              round(
                                (
                                  (
                                    140 - trunc(
                                      getcslage(
                                        person.birth
                                        , consultview.csldate
                                        , to_char(consultview.csldate, ('yyyymmdd'))
                                      )
                                    )
                                  ) * (
                                    select
                                      to_number(result)
                                    from
                                      rsl
                                    where
                                      rsvno = consultview.rsvno
                                      and itemcd = '10021'
                                      and suffix = '00'
                                  )
                                ) / (to_number(rsl.result) * 72)
                                , 1
                              )
                            )
                            , (
                              round(
                                (
                                  (
                                    (
                                      140 - trunc(
                                        getcslage(
                                          person.birth
                                          , consultview.csldate
                                          , to_char(consultview.csldate, ('yyyymmdd'))
                                        )
                                      )
                                    ) * (
                                      select
                                        to_number(result)
                                      from
                                        rsl
                                      where
                                        rsvno = consultview.rsvno
                                        and itemcd = '10021'
                                        and suffix = '00'
                                    )
                                  ) / (to_number(rsl.result) * 72)
                                ) * 0.85
                                , 1
                              )
                            )
                      ) egfr
            ";

            sql += @"
                    from
                      (
                        select
                          rownum seq
                          , csldate
                          , rsvno
                          , perid
                        from
                          (
                            select
                              consult.csldate
                              , consult.rsvno
                              , consult.perid
                            from
                              consult
                            where
                              consult.perid = (
                                select distinct
                                  perid
                                from
                                  consult
                                where
                                  rsvno = :rsvno
                             )
            ";

            sql += @"
                                and consult.csldate <= (
                                  select distinct
                                    csldate
                                  from
                                    consult
                                  where
                                    rsvno = :rsvno
                                )
                                and consult.cscd in (
                                  select
                                    freefield1 cscd
                                  from
                                    free
                                  where
                                    freecd like :cscd || '%'
                                )
                                and consult.cancelflg = 0
                                order by
                                  consult.csldate desc)) consultview
                                  , person
                                  , rsl
                                where
                                  consultview.rsvno = rsl.rsvno
            ";

            if (historyCount > 0)
            {
                sql += @"
                                and consultview.seq between 1 and :hiscount
                ";
            }

            sql += @"
                                and rsl.stopflg is null
                                and consultview.perid = person.perid
                                and consultview.rsvno = rsl.rsvno
                                and rsl.itemcd = '17221'
                                and rsl.suffix = '00'
            ";

            sql += @"
                        union all
                        select
                          consultview.seq hisno
                          , consultview.csldate csldate
                          , null egfr
                        from
                          (select rownum seq, csldate, rsvno, perid
            ";
            sql = @"
                          from
                            (
                              select
                                consult.csldate
                                , consult.rsvno
                                , consult.perid
                              from
                                consult
                              where
                                consult.perid = (
                                  select distinct
                                    perid
                                  from
                                    consult
                                  where
                                    rsvno = :rsvno
                                )
                                and consult.csldate <= (
                                  select distinct
                                    csldate
                                  from
                                    consult
                                  where
                                    rsvno = :rsvno
                                )
                                and consult.cscd in (
                                  select
                                    freefield1 cscd
                                  from
                                    free
                                  where
                                    freecd like :cscd || '%'
                                )
                                and consult.cancelflg = 0
                              order by
                                consult.csldate desc
                            )
                        ) consultview
            ";

            if (historyCount > 0)
            {
                sql += @"
                            where
                              consultview.seq between 1 and :hiscount
                ";
            }

            sql += @"
                        ) finalrsl
                    group by
                      finalrsl.hisno
                      , finalrsl.csldate
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// eGFR(MDRD)計算結果を履歴として取得
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <returns>
        /// hisno 履歴No.
        /// csldate 来院日
        /// egfr eGFR(MDRD)計算結果
        /// </returns>
        public List<dynamic> SelectMDRDHistory(int rsvNo, string hisCount, string csGrp)
        {
            string sql = "";                // SQLステートメント

            long historyCount;              // 表示歴数

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                historyCount = long.Parse(hisCount);
            }
            else
            {
                historyCount = 0;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (historyCount > 0)
            {
                param.Add("hiscount", Convert.ToString(historyCount));
            }
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));

            sql = @"
                    select
                      finalrsl.hisno hisno
                      , finalrsl.csldate csldate
                      , max(finalrsl.egfr) egfr
                    from
                      (
                        select
                          consultview.seq hisno
                          , consultview.csldate csldate
                          , decode(
                            person.gender
                            , 1
                            , round(
                              (
                                186.3 * power(to_number(rsl.result), - 1.154) * power(
                                  trunc(
                                    getcslage(
                                      person.birth
                                      , consultview.csldate
                                      , to_char(consultview.csldate, ('yyyymmdd'))
                                    )
                                  )
                                  , - 0.203
                                )
                              ) * 0.881
                              , 1
                            )
                            , 2
                            , round(
                              (
                                (
                                  186.3 * power(to_number(rsl.result), - 1.154) * power(
                                    trunc(
                                      getcslage(
                                        person.birth
                                        , consultview.csldate
                                        , to_char(consultview.csldate, ('yyyymmdd'))
                                      )
                                    )
                                    , - 0.203
                                  )
                                ) * 0.881
                              ) * 0.746
                              , 1
                            )
                          ) egfr
            ";

            sql += @"
                        from
                          (
                            select
                              rownum seq
                              , csldate
                              , rsvno
                              , perid
                            from
                              (
                                select
                                  consult.csldate
                                  , consult.rsvno
                                  , consult.perid
                                from
                                  consult
                                where
                                  consult.perid = (
                                    select distinct
                                      perid
                                    from
                                      consult
                                    where
                                      rsvno = :rsvno
                                  )
            ";

            sql += @"
                                and consult.csldate <= (
                                  select distinct
                                    csldate
                                  from
                                    consult
                                  where
                                    rsvno = :rsvno
                                )
                                and consult.cscd in (
                                  select
                                    freefield1 cscd
                                  from
                                    free
                                  where
                                    freecd like :cscd || '%'
                                )
                                and consult.cancelflg = 0
                                order by
                                  consult.csldate desc)) consultview
                                  , person
                                  , rsl
                                where
                                  consultview.rsvno = rsl.rsvno
            ";

            if (historyCount > 0)
            {
                sql += @"
                                and consultview.seq between 1 and :hiscount
                ";
            }

            sql += @"
                                and rsl.stopflg is null
                                and consultview.perid = person.perid
                                and consultview.rsvno = rsl.rsvno
                                and rsl.itemcd = '17221'
                                and rsl.suffix = '00'
            ";

            sql += @"
                            union all
                            select
                              consultview.seq hisno
                              , consultview.csldate csldate
                              , null egfr
                            from
                              (
                                select
                                    rownum seq
                                    , csldate
                                    , rsvno
                                    , perid
            ";
            sql += @"
                                from
                                    (
                                    select
                                        consult.csldate
                                        , consult.rsvno
                                        , consult.perid
                                    from
                                        consult
                                    where
                                        consult.perid = (
                                        select distinct
                                            perid
                                        from
                                            consult
                                        where
                                            rsvno = :rsvno
                                        )
                                        and consult.csldate <= (
                                        select distinct
                                            csldate
                                        from
                                            consult
                                        where
                                            rsvno = :rsvno
                                        )
                                        and consult.cscd in (
                                        select
                                            freefield1 cscd
                                        from
                                            free
                                        where
                                            freecd like :cscd || '%'
                                        )
                                        and consult.cancelflg = 0
                                    order by
                                        consult.csldate desc
                                    )
                                ) consultview
            ";

            if (historyCount > 0)
            {
                sql += @"
                            where
                                consultview.seq between 1 and :hiscount
                ";
            }

            sql += @"
                            ) finalrsl
                        group by
                          finalrsl.hisno
                          , finalrsl.csldate
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// GFR(新しい日本人の推算式)計算結果を履歴として取得
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <param name="hisCount">表示歴数</param>
        /// <param name="csGrp">前回歴表示モード:0のとき、null;1のとき、コースコード;2のとき、コースグループコード</param>
        /// <returns>
        /// hisno 履歴No.
        /// csldate 来院日
        /// egfr GFR計算結果
        /// </returns>
        public List<dynamic> SelectNewGFRHistory(int rsvNo, string hisCount, string csGrp)
        {
            string sql = "";                // SQLステートメント

            long historyCount;              // 表示歴数

            // 表示歴数が「全件」以外で、数値でない場合はエラー
            if (!hisCount.Equals("*"))
            {
                if (!Information.IsNumeric(hisCount))
                {
                    throw new ArgumentException();
                }
                historyCount = long.Parse(hisCount);
            }
            else
            {
                historyCount = 0;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (historyCount > 0)
            {
                param.Add("hiscount", Convert.ToString(historyCount));
            }
            param.Add("cscd", (string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim()));

            sql = @"
                    select
                      finalrsl.hisno hisno
                      , finalrsl.csldate csldate
                      , max(finalrsl.gfr) gfr
                    from
                      (
                        select
                          consultview.seq hisno
                          , consultview.csldate csldate
                          , decode(
                            person.gender
                            , 1
                            , round(
                              (
                                194 * power(to_number(rsl.result), - 1.094) * power(
                                  trunc(
                                    getcslage(
                                      person.birth
                                      , consultview.csldate
                                      , to_char(consultview.csldate, ('yyyymmdd'))
                                    )
                                  )
                                  , - 0.287
                                )
                              )
                              , 1
                            )
                            , 2
                            , round(
                              (
                                (
                                  194 * power(to_number(rsl.result), - 1.094) * power(
                                    trunc(
                                      getcslage(
                                        person.birth
                                        , consultview.csldate
                                        , to_char(consultview.csldate, ('yyyymmdd'))
                                      )
                                    )
                                    , - 0.287
                                  )
                                )
                              ) * 0.739
                              , 1
                            )
                          ) gfr
            ";

            sql += @"
                    from
                      (
                        select
                          rownum seq
                          , csldate
                          , rsvno
                          , perid
                        from
                          (
                            select
                              consult.csldate
                              , consult.rsvno
                              , consult.perid
                            from
                              consult
                            where
                              consult.perid = (
                                select distinct
                                  perid
                                from
                                  consult
                                where
                                  rsvno = :rsvno
                            )
            ";

            sql += @"
                            and consult.csldate <= (
                              select distinct
                                csldate
                              from
                                consult
                              where
                                rsvno = :rsvno
                            )
                            and consult.cscd in (
                              select
                                freefield1 cscd
                              from
                                free
                              where
                                freecd like :cscd || '%'
                            )
                            and consult.cancelflg = 0
                            order by
                              consult.csldate desc)) consultview
                              , person
                              , rsl
                            where
                              consultview.rsvno = rsl.rsvno
            ";

            if (historyCount > 0)
            {
                sql += @"
                              and consultview.seq between 1 and :hiscount
                ";
            }

            sql += @"
                              and rsl.stopflg is null
                              and consultview.perid = person.perid
                              and consultview.rsvno = rsl.rsvno
                              and rsl.itemcd = '17221'
                              and rsl.suffix = '00'
            ";

            sql += @"
                            union all
                            select
                              consultview.seq hisno
                              , consultview.csldate csldate
                              , null gfr
                            from
                              (
                                select
                                    rownum seq
                                    , csldate
                                    , rsvno, perid
            ";

            sql += @"
                                from
                                  (
                                    select
                                      consult.csldate
                                      , consult.rsvno
                                      , consult.perid
                                    from
                                      consult
                                    where
                                      consult.perid = (
                                        select distinct
                                          perid
                                        from
                                          consult
                                        where
                                          rsvno = :rsvno
                                      )
                                      and consult.csldate <= (
                                        select distinct
                                          csldate
                                        from
                                          consult
                                        where
                                          rsvno = :rsvno
                                      )
                                      and consult.cscd in (
                                        select
                                          freefield1 cscd
                                        from
                                          free
                                        where
                                          freecd like :cscd || '%'
                                      )
                                      and consult.cancelflg = 0
                                    order by
                                      consult.csldate desc
                                  )
                              ) consultview
            ";

            if (historyCount > 0)
            {
                sql += @"
                            where consultview.seq between 1 and :hiscount
                ";
            }

            sql += @"
                        ) finalrsl
                    group by
                      finalrsl.hisno
                      , finalrsl.csldate
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定された予約番号の多変量解析を行いＸ座標、Ｙ座標を求める
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="valueX">Ｘ座標</param>
        /// <param name="valueY">Ｙ座標</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool StatisticsCalc(int rsvNo, ref double valueX, ref double valueY)
        {
            string sql = "";                // SQLステートメント
            string sql2 = "";               // SQLステートメント

            double convert;                 // 変換値
            double sdi;                     // SDI値
            double retX = 0;              // Ｘ座標
            double retY = 0;              // Ｙ座標

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("grpcd", STATISTICS_GRPCD);

            // 計算対象となる検査結果の件数取得
            sql = @"
                    select
                      count(*) rslcnt
                    from
                      consult
                      , grp_i
                      , rsl
            ";

            // 検査結果取得条件
            sql2 = @"
                    where
                      consult.rsvno = :rsvno
                      and grp_i.grpcd = :grpcd
                      and rsl.rsvno = consult.rsvno
                      and rsl.itemcd = grp_i.itemcd
                      and rsl.suffix = grp_i.suffix
                      and rsl.result is not null
                      and rsl.stopflg is null
            ";

            sql += sql2;

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 計算に必要な検査項目がそろっていない
            if (current != null)
            {
                if (Convert.ToInt16(current.RSLCNT != SDI_RSLCNT))
                {
                    return false;
                }

            }
            else
            {
                return false;
            }

            // 検査結果毎のSDI算出用基礎データを取得する
            sql = @"
                    select
                        rslview.result
                        , rslview.itemcd
                        , rslview.suffix
                        , free.freefield1 methodno
                        , free.freefield2 average
                        , free.freefield3 deviation
                        , free.freefield4 can1
                        , free.freefield5 can2
                    from
                        free
                        , (
            ";

            // 年齢
            sql += @"
                            (
                                select
                                null itemcd
                                , null suffix
                                , to_char(consult.age) result
                                , person.gender
                                from
                                consult
                                , person
                                where
                                consult.rsvno = :rsvno
                                and consult.perid = person.perid
                            )
                            union
            ";

            // 検査結果取得
            sql += @"
                            (
                              select
                                rsl.itemcd
                                , rsl.suffix
                                , rsl.result
                                , person.gender
                              from
                                rsl
                                , consult
                                , grp_i
                                , person
            ";

            sql += sql2;

            sql += @"
                                and consult.perid = person.perid
                            )
                        ) rslview
                    where
                      free.freecd = 'SDI' || rslview.itemcd || rslview.suffix || rslview.gender
            ";

            List<dynamic> items = connection.Query(sql, param).ToList();

            for (int i = 0; i < items.Count; i++)
            {
                double result = double.Parse(items[i]["result"]);

                // 変換方法
                switch (long.Parse(items[i]["methodno"]))
                {
                    case 0:
                        convert = result;
                        break;
                    case 1:
                        convert = Math.Log(result) / Math.Log(10);
                        break;
                    case 2:
                        convert = result * result;
                        break;
                    case 3:
                        convert = result * result * result;
                        break;
                    case 4:
                        convert = Math.Pow(result, (1 / 2));
                        break;
                    case 5:
                        convert = Math.Pow(result, (1 / 3));
                        break;
                    case 6:
                        convert = Math.Pow(result, (1 / 4));
                        break;
                    default:
                        convert = result;
                        break;
                }

                sdi = (convert - double.Parse(items[i]["average"])) / double.Parse(items[i]["deviation"]);

                retX = retX + (sdi * double.Parse(items[i]["can1"]));
                retY = retY + (sdi * double.Parse(items[i]["can2"]));

            }

            // 戻り値の設定
            valueX = retX;
            valueY = retY;

            return true;
        }

        /// <summary>
        /// 指定検索条件の入院・外来歴を取得する。
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <returns>
        /// kbn 入外区分（1:外来、2:入院）
        /// csldate 来院日
        /// deptname 科名
        /// </returns>
        public List<dynamic> SelectPatientHistory(int rsvNo)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            sql = @"
                    select
                      patientview.kbn
                      , patientview.csldate
                      , patientview.deptname
                    from
                      (
            ";

            // 外来歴
            sql += @"
                        (
                          select
                            1 kbn
                            , outpatient.csldate
                            , nvl(smiledept.deptname, outpatient.deptcd) deptname
                          from
                            outpatient
                            , smiledept
                          where
                            outpatient.perid = (select perid from consult where rsvno = :rsvno)
                            and smiledept.deptcd(+) = outpatient.deptcd
                        )
                        union
            ";

            // 入院歴
            sql += @"
                        (
                          select
                            2 kbn
                            , inpatient.indate csldate
                            , nvl(smiledept.deptname, inpatient.deptcd) deptname
                          from
                            inpatient
                            , smiledept
                          where
                            inpatient.perid = (select perid from consult where rsvno = :rsvno)
                            and smiledept.deptcd(+) = inpatient.deptcd
                        )
                      ) patientview
                ";

            // 新しい順
            sql += @"
                    order by
                      patientview.csldate desc
                ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定検索条件の病歴を取得する。
        /// </summary>
        /// <param name="rsvNo">検索条件：予約番号</param>
        /// <returns>
        /// indate 入院日
        /// disname 病名
        /// </returns>
        public List<dynamic> SelectDiseaseHistory(int rsvNo)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            sql = @"
                    select
                      inpatient.indate
                      , nvl(disease.disname, inpatient.discd) disname
                    from
                      inpatient
                      , disease
                    where
                      inpatient.perid = (select perid from consult where rsvno = :rsvno)
                      and disease.discd(+) = inpatient.discd
                    order by
                      inpatient.indate desc
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 総合判定コメントの並び替え（ＳＥＱ再設定）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool FncSortTotalJudCmt(int rsvNo, int dispMode)
        {
            string sql = "";                // SQLステートメント

            bool ret = false;               // 戻り値

            using (var cmd = new OracleCommand())
            {

                // キー及び更新値の設定
                cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                cmd.Parameters.Add("rsvno", rsvNo);
                cmd.Parameters.Add("dispmode", dispMode);

                // SQL定義
                sql = @"
                    begin
                        :ret := specialjudcalcpackage.sorttotaljudcmt(
                            :rsvno
                            , :dispmode
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