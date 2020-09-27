using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 食品別摂取情報データアクセスオブジェクト
    /// </summary>
    public class NourishmentDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public NourishmentDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 食品群別摂取の一覧を取得する
        /// </summary>
        /// <param name="energy">エネルギー（空白時は全件）</param>
        /// <returns>
        /// energy     エネルギー
        /// foodGrp1   食品群１
        /// foodGrp2   食品群２
        /// foodGrp3   食品群３
        /// foodGrp4   食品群４
        /// foodGrp5   食品群５
        /// foodGrp6   食品群６
        /// foodGrp7   食品群７
        /// </returns>
        public List<dynamic> SelectNutriFoodEnergy(string energy)
        {
            string sql; // SQLステートメント

            var param = new Dictionary<string, object>();

            // キー値の設定
            if (!"".Equals(energy.Trim()) && Util.IsNumber(energy))
            {
                param.Add("energy", energy.Trim());
            }

            // 食品群別摂取テーブルよりレコードを取得
            sql = @"
                    select
                      energy
                      , foodgrp1
                      , foodgrp2
                      , foodgrp3
                      , foodgrp4
                      , foodgrp5
                      , foodgrp6
                      , foodgrp7
                    from
                      nutrifoodenergy
                ";

            if (!"".Equals(energy.Trim()) && Util.IsNumber(energy))
            {
                sql += @"
                        where
                          energy = :energy
                     ";
            }
            else
            {
                sql += @"
                        order by
                          energy
                     ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 食品群別摂取テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">食品群別摂取テーブル情報
        /// energy        エネルギー
        /// foodGrp1      食品群１
        /// foodGrp2      食品群２
        /// foodGrp3      食品群３
        /// foodGrp4      食品群４
        /// foodGrp5      食品群５
        /// foodGrp6      食品群６
        /// foodGrp7      食品群７
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistNutriFoodEnergy(string mode, JToken data)
        {
            string sql;     // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("energy", Convert.ToString(data["energy"]).Trim());
            param.Add("foodgrp1", Convert.ToString(data["foodGrp1"]).Trim());
            param.Add("foodgrp2", Convert.ToString(data["foodGrp2"]).Trim());
            param.Add("foodgrp3", Convert.ToString(data["foodGrp3"]).Trim());
            param.Add("foodgrp4", Convert.ToString(data["foodGrp4"]).Trim());
            param.Add("foodgrp5", Convert.ToString(data["foodGrp5"]).Trim());
            param.Add("foodgrp6", Convert.ToString(data["foodGrp6"]).Trim());
            param.Add("foodgrp7", Convert.ToString(data["foodGrp7"]).Trim());

            while (true)
            {
                // 食品群別摂取テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update nutrifoodenergy
                            set
                              foodgrp1 = :foodgrp1
                              , foodgrp2 = :foodgrp2
                              , foodgrp3 = :foodgrp3
                              , foodgrp4 = :foodgrp4
                              , foodgrp5 = :foodgrp5
                              , foodgrp6 = :foodgrp6
                              , foodgrp7 = :foodgrp7
                            where
                              energy = :energy
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす食品群別摂取テーブルのレコードを取得
                sql = @"
                        select
                          energy
                        from
                          nutrifoodenergy
                        where
                          energy = :energy
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into nutrifoodenergy(
                          energy
                          , foodgrp1
                          , foodgrp2
                          , foodgrp3
                          , foodgrp4
                          , foodgrp5
                          , foodgrp6
                          , foodgrp7
                        )
                        values (
                          :energy
                          , :foodgrp1
                          , :foodgrp2
                          , :foodgrp3
                          , :foodgrp4
                          , :foodgrp5
                          , :foodgrp6
                          , :foodgrp7
                        )
                    ";

                ret2 = connection.Execute(sql, param);

                if (ret2 >= 0)
                {
                    ret = Insert.Normal;
                }

                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 食品群別摂取テーブルレコードを削除する
        /// </summary>
        /// <param name="energy">エネルギー</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeletePubNoteDiv(string energy)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("energy", energy);

            // 食品群別摂取テーブルレコードの削除
            sql = @"
                    delete nutrifoodenergy
                    where
                      energy = :energy
                ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 構成食品テーブルの一覧を取得する
        /// </summary>
        /// <param name="composeFoodCd">構成食品コード（空白時は全件）</param>
        /// <returns>
        /// composeFoodCd     構成食品コード
        /// composeFoodName   構成食品名
        /// foodClassCd       食品分類
        /// </returns>
        public List<dynamic> SelectNutriCompFood(string composeFoodCd)
        {
            string sql; // SQLステートメント

            var param = new Dictionary<string, object>();

            // キー値の設定
            if (!"".Equals(composeFoodCd.Trim()) && Util.IsNumber(composeFoodCd))
            {
                param.Add("composefoodcd", composeFoodCd.Trim());
            }

            // 食品群別摂取テーブルよりレコードを取得
            sql = @"
                    select
                      composefoodcd
                      , composefoodname
                      , foodclasscd
                    from
                      nutricompfood
                ";

            if (!"".Equals(composeFoodCd.Trim()) && Util.IsNumber(composeFoodCd))
            {
                sql += @"
                        where
                          composefoodcd = :composefoodcd
                     ";
            }
            else
            {
                sql += @"
                        order by
                          composefoodcd
                     ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 構成食品テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">構成食品テーブル情報
        /// composeFoodCd        構成食品コード
        /// composeFoodName      構成食品名
        /// foodClassCd          食品分類
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistNutriCompFood(string mode, JToken data)
        {
            string sql;     // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("composefoodcd", Convert.ToString(data["composeFoodCd"]));
            param.Add("composefoodname", Convert.ToString(data["composeFoodName"]));
            param.Add("foodclasscd", Convert.ToString(data["foodClassCd"]));

            while (true)
            {
                // 食品群別摂取テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update nutricompfood
                            set
                              composefoodname = :composefoodname
                              , foodclasscd = :foodclasscd
                            where
                              composefoodcd = :composefoodcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす食品群別摂取テーブルのレコードを取得
                sql = @"
                        select
                          composefoodcd
                        from
                          nutricompfood
                        where
                          composefoodcd = :composefoodcd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into nutricompfood(composefoodcd, composefoodname, foodclasscd)
                        values (:composefoodcd, :composefoodname, :foodclasscd)
                    ";

                ret2 = connection.Execute(sql, param);

                if (ret2 >= 0)
                {
                    ret = Insert.Normal;
                }

                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 構成食品テーブルレコードを削除する
        /// </summary>
        /// <param name="composeFoodCd">構成食品コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteNutriCompFood(string composeFoodCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("composefoodcd", composeFoodCd);

            // 食品群別摂取テーブルレコードの削除
            sql = @"
                    delete nutricompfood
                    where
                      composefoodcd = :composefoodcd
                ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 検索条件を満たす栄養計算目標量テーブルの一覧を取得する
        /// </summary>
        /// <param name="data">栄養計算目標量テーブル情報
        /// gender       性別
        /// lowerAge     年齢以上
        /// upperAge     年齢以下
        /// lowerHeight  身長以上
        /// upperHeight  身長以下
        /// actStrength  生活活動強度
        /// totalEnergy  総エネルギー
        /// </param>
        /// <returns>
        /// gender       性別
        /// lowerAge     年齢以上
        /// upperAge     年齢以下
        /// lowerHeight  身長以上
        /// upperHeight  身長以下
        /// actStrength  生活活動強度
        /// totalEnergy  総エネルギー
        /// protein      たんぱく質
        /// fat          脂質
        /// carbohydrate 炭水化物
        /// calcium      カルシウム
        /// iron         鉄
        /// cholesterol  コレステロール
        /// salt         塩分
        /// </returns>
        public List<dynamic> SelectNutriCompFood(JToken data)
        {
            string sql; // SQLステートメント
            bool existKey; // KEY値指定あり

            // 検索キー指定の有無チェック
            existKey = false;
            if (!"".Equals(Convert.ToString(data["gender"]).Trim())
              && !"".Equals(Convert.ToString(data["lowerAge"]).Trim())
              && !"".Equals(Convert.ToString(data["upperAge"]).Trim())
              && !"".Equals(Convert.ToString(data["lowerHeight"]).Trim())
              && !"".Equals(Convert.ToString(data["upperHeight"]).Trim())
              && !"".Equals(Convert.ToString(data["actStrength"]).Trim())
              && !"".Equals(Convert.ToString(data["totalEnergy"]).Trim()))
            {
                if (Util.IsNumber(Convert.ToString(data["gender"]))
                  && Util.IsNumber(Convert.ToString(data["lowerAge"]))
                  && Util.IsNumber(Convert.ToString(data["upperAge"]))
                  && Util.IsNumber(Convert.ToString(data["lowerHeight"]))
                  && Util.IsNumber(Convert.ToString(data["upperHeight"]))
                  && Util.IsNumber(Convert.ToString(data["actStrength"]))
                  && Util.IsNumber(Convert.ToString(data["totalEnergy"])))
                {
                    existKey = true;
                }
            }

            var param = new Dictionary<string, object>();
            // キー値の設定
            if (existKey)
            {
                param.Add("gender", Convert.ToString(data["gender"]).Trim());
                param.Add("lowerage", Convert.ToString(data["lowerAge"]).Trim());
                param.Add("upperage", Convert.ToString(data["upperAge"]).Trim());
                param.Add("lowerheight", Convert.ToString(data["lowerHeight"]).Trim());
                param.Add("upperheight", Convert.ToString(data["upperHeight"]).Trim());
                param.Add("actstrength", Convert.ToString(data["actStrength"]).Trim());
                param.Add("totalenergy", Convert.ToString(data["totalEnergy"]).Trim());
            }

            // 食品群別摂取テーブルよりレコードを取得
            sql = @"
                    select
                      gender
                      , lowerage
                      , upperage
                      , lowerheight
                      , upperheight
                      , actstrength
                      , totalenergy
                      , protein
                      , fat
                      , carbohydrate
                      , calcium
                      , iron
                      , cholesterol
                      , salt
                    from
                      nutritarget
                ";

            if (existKey)
            {
                sql += @"
                        where
                          gender = :gender lowerage = :lowerage upperage = :upperage lowerheight = :lowerheight upperheight =
                          :upperheight actstrength = :actstrength totalenergy = :totalenergy
                     ";
            }
            else
            {
                sql += @"
                        order by
                          gender
                          , actstrength
                          , lowerage
                          , lowerheight
                          , totalenergy
                     ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす栄養献立リストテーブルの一覧を取得する
        /// </summary>
        /// <param>
        /// itemCd        検査項目コード
        /// suffix        サフィックス
        /// composeFoodCd 構成食品コード
        /// </param>
        /// <returns>
        /// itemCd           検査項目コード
        /// suffix           サフィックス
        /// itemName         項目名
        /// composeFoodCd    構成食品コード
        /// composeFoodName  構成食品名
        /// foodClassCd      食品分類
        /// takeAmount       摂取量
        /// totalEnergy      総エネルギー
        /// protein          蛋白質
        /// fat              脂質
        /// sugar            糖質
        /// calcium          カルシウム
        /// iron             鉄
        /// cholesterol      コレステロール
        /// salt             塩分
        /// lowSaltFlg       減塩フラグ
        /// </returns>
        public List<dynamic> SelectNutriMenuList(string itemCd, string suffix, string composeFoodCd)
        {
            string sql; // SQLステートメント
            bool existKey; // KEY値指定あり

            // 検索キー指定の有無チェック
            existKey = false;
            if (!"".Equals(itemCd)
              && !"".Equals(suffix)
              && !"".Equals(composeFoodCd))
            {
                existKey = true;
            }

            var param = new Dictionary<string, object>();
            // キー値の設定
            if (existKey)
            {
                param.Add("itemcd", itemCd.Trim());
                param.Add("suffix", suffix.Trim());
                param.Add("composfoodcd", composeFoodCd.Trim());
            }

            sql = @"
                    select
                      nutrimenulist.itemcd
                      , nutrimenulist.suffix
                      , item_c.itemname
                      , nutrimenulist.composefoodcd
                      , nutricompfood.composefoodname
                      , nutricompfood.foodclasscd
                      , nutrimenulist.takeamount
                      , nutrimenulist.totalenergy
                      , nutrimenulist.protein
                      , nutrimenulist.fat
                      , nutrimenulist.sugar
                      , nutrimenulist.calcium
                      , nutrimenulist.iron
                      , nutrimenulist.cholesterol
                      , nutrimenulist.salt
                      , nutrimenulist.lowsaltflg
                    from
                      nutricompfood
                      , item_c
                      , nutrimenulist
                    where
                      nutrimenulist.itemcd = item_c.itemcd(+)
                      and nutrimenulist.suffix = item_c.suffix(+)
                      and nutrimenulist.composefoodcd = nutricompfood.composefoodcd(+)
                ";

            if (existKey)
            {
                sql += @"
                        and itemcd = :itemcd suffix = :suffix composefoodcd = :composefoodcd
                     ";
            }
            else
            {
                sql += @"
                        order by
                          nutrimenulist.suffix
                          , nutrimenulist.itemcd
                          , nutrimenulist.suffix
                          , nutrimenulist.composefoodcd
                     ";
            }

            return connection.Query(sql, param).ToList();
        }
    }
}
