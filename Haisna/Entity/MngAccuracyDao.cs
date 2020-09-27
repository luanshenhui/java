using Dapper;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 精度管理用データアクセスオブジェクト
    /// </summary>
    public class MngAccuracyDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public MngAccuracyDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 検索条件を満たすグループの一覧を取得する
        /// </summary>
        /// <param>
        /// cslDate 受診日付
        /// genderMode 表示対象性別：1:男、2:女、3:男女別、4:男女マージ
        /// </param>
        /// <returns>
        /// seq SEQ
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// itemName 検査項目名
        /// gender 性別
        /// resultCount 結果数
        /// val_L
        /// val_S
        /// val_H
        /// percent_L
        /// percent_H
        /// </returns>
        public List<dynamic> SelectMngAccuracy(string cslDate, int genderMode)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            if (!Information.IsDate(cslDate))
            {
                cslDate = DateTime.Now.ToString("yyyy/MM/dd");
            }
            param.Add("csldate", cslDate);
            param.Add("gendermode", genderMode);

            sql = @"
                    select
                      seq
                      , itemcd
                      , suffix
                      , itemname
                      , gender
                      , resultcount
                      , val_l
                      , val_s
                      , val_h
                      , trunc(val_l / resultcount * 100, 1) percent_l
                      , trunc(val_h / resultcount * 100, 1) percent_h
                    from
                      (
                        select
                          seq
                          , itemcd
                          , suffix
                          , itemname
                          , gender
                          , count(*) resultcount
                          , nvl(sum(val_l), 0) val_l
                          , nvl(sum(val_s), 0) val_s
                          , nvl(sum(val_h), 0) val_h
                        from
                          (
                            select
                              seq
                              , itemcd
                              , suffix
                              , itemname
                              , gender
                              , decode(stdflg, 'L', 1, 'D', 1, null) val_l
                              , decode(stdflg, 'S', 1, null) val_s
                              , decode(
                                stdflg
                                , 'U'
                                , 1
                                , 'H'
                                , 1
                                , '@'
                                , 1
                                , 'X'
                                , 1
                                , '*'
                                , 1
                                , null
                              ) val_h
                            from
                              (
                                select distinct
                                  rsl.rsvno
                                  , decode(:gendermode, 4, 3, person.gender) gender
                                  , grpinfo.seq
                                  , rsl.itemcd
                                  , rsl.suffix
                                  , grpinfo.itemname
                                  , gettruestdflg(
                                    rsl.stdvaluecd
                                    , rsl.itemcd
                                    , rsl.suffix
                                    , rsl.result
                                    , person.gender
                                    , consult.age
                                    , consult.csldate
                                    , consult.cscd
                                  ) stdflg
                                from
                                  (
                                    select
                                      grp_i.itemcd
                                      , grp_i.suffix
                                      , item_c.itemtype
                                      , item_c.itemname
                                      , grp_i.seq
                                    from
                                      item_c
                                      , grp_i
                                    where
                                      grp_i.grpcd = 'X070'
                                      and item_c.itemcd = grp_i.itemcd
                                      and item_c.suffix = grp_i.suffix
                                      and item_c.itemtype in (0, 5)
                                  ) grpinfo
                                  , rsl
                                  , person
                                  , receipt
                                  , consult
                                where
                                  consult.csldate = :csldate
                                  and person.perid = consult.perid
                ";
            // 男性のみの場合
            if (1 == genderMode)
            {
                sql += @"
                        and person.gender = 1
                     ";
            }

            // 女性のみの場合
            if (2 == genderMode)
            {
                sql += @"
                        and person.gender = 2
                     ";
            }

            sql += @"
                    and receipt.rsvno = consult.rsvno
                    and receipt.comedate is not null
                    and rsl.rsvno = receipt.rsvno
                    and rsl.itemcd = grpinfo.itemcd
                    and rsl.suffix = grpinfo.suffix
                    and rsl.result is not null))
                    group by
                      seq
                      , itemcd
                      , suffix
                      , itemname
                      , gender)
                 ";

            return connection.Query(sql, param).ToList();
        }

        #region "新設メソッド"
        /// <summary>
        /// バリデーション
        /// </summary>
        /// <param name="border"> 境界</param>
        /// /param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> Validate(string border)
        {
            var messages = new List<string>();

            //グループ開始終了受診日未入力チェック
            if (!string.IsNullOrEmpty(border))
            {
                if (!Information.IsNumeric(border.Trim()))
                {
                    messages.Add("基準外境界比率には正しい数字を入力してください。");
                }
            }
            return messages;
        }
        #endregion "新設メソッド"
    }
}
