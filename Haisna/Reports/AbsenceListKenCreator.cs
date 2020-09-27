using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using System;
using System.Collections.Generic;
using System.Linq;
using Hainsi.Entity;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceListKenCreator : CsvCreator
    {

        /// <summary>
        /// ファイル名
        /// </summary>
        private const string FILENAME_DEF = "KENSIN";

        /// <summary>
        /// パラメタ
        /// </summary>
        private const int MAX_COUNT_ORG = 5;    //団体コード最大設定数

        /// <summary>
        /// コースコード（未指定時）
        /// </summary>
        private const string CSCD_DEF1 = "100";
        private const string CSCD_DEF2 = "110";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_SETTING = "A-KENSHIN";     //設定情報
        
        /// <summary>
        /// 団体健診金額CSV出力情報を読み込み
        /// </summary>
        /// <returns>団体健診金額CSV出力情報</returns>
        protected override List<dynamic> GetData()
        {

            string sql =
                  @"
                select
                    to_char(consult.csldate, 'YYYYMMDD') as csldate
                    , consult.rsvno as rsvno
                    , consult.isrsign as isrsign
                    , consult.isrno as isrno
                    , person.perid as perid
                    , to_char(person.birth, 'YYYYMMDD') as birth 
                from
                    consult
                    , receipt
                    , person 
                where
                    consult.csldate between :startdate and :enddate 
                    and consult.cancelflg = :cancelflg 
                    and consult.rsvno = receipt.rsvno 
                    and receipt.comedate is not null 
                    and consult.perid = person.perid 
            ";

            //団体パラメタ
            List<string> orgcd_list = new List<string>();   //団体情報
            for (int i = 1; i <= MAX_COUNT_ORG; i++)
            {
                string para_name1 = "orgcd1" + i.ToString();
                string para_name2 = "orgcd2" + i.ToString();

                //団体コード
                string orgcdWk = "";
                if ((!string.IsNullOrEmpty(queryParams[para_name1])) || (!string.IsNullOrEmpty(queryParams[para_name2])))
                {
                    //団体指定がある場合、値を退避
                    orgcdWk = queryParams[para_name1].Trim() + queryParams[para_name2].Trim();
                    //団体指定がある場合、団体コード１＋２値を退避
                    orgcd_list.Add(orgcdWk);
                }

            }

            //団体グループ指定
            string orgGrpcd = queryParams["orggrpcd"];

            if ( ( orgcd_list.Count > 0 ) || (! string.IsNullOrEmpty(orgGrpcd)))
            {
                sql += @"
                    and ( 
                ";

                //団体グループ指定
                if (!string.IsNullOrEmpty(orgGrpcd))
                {
                    sql += @"
                        (consult.orgcd1, consult.orgcd2) in ( 
                            select
                                orggrp_i.orgcd1
                                , orggrp_i.orgcd2 
                            from
                                orggrp_i 
                            where
                                orggrp_i.orggrpcd = :orggrpcd
                        ) 
                    ";

                }

                //団体コード指定
                if (orgcd_list.Count > 0)
                {
                    //団体グループがある場合はorで連結
                    if (!string.IsNullOrEmpty(orgGrpcd))
                    {
                        sql += @"
                                or  
                        ";
                    }
                    sql += @"
                        ( consult.orgcd1 || consult.orgcd2 in ( '" + String.Join("','", orgcd_list) + "') )";
                }

                sql += @"
                    ) 
                ";
            }

            //コース指定
            string csCd = queryParams["cscd"];

            if (!string.IsNullOrEmpty(csCd))
            {
                //コース指定あり
                sql += @"
                    and consult.cscd = :cscd 
                ";
            }
            else
            {
                //コース指定なし
                sql += @"
                    and consult.cscd in (:cscd_def1, :cscd_def2) 
                ";

            }

            sql += @"
                order by
                        consult.csldate
                        , consult.rsvno
            ";

            //受診日
            DateTime.TryParse(queryParams["startdate"], out DateTime dSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dEdate);

            // 開始日より終了日が過去であれば値を交換
            if (dSdate > dEdate)
            {
                DateTime wkDate = dSdate;
                dSdate = dEdate;
                dEdate = wkDate;
            }

            var sqlParam = new
            {
                startdate = dSdate,
                enddate = dEdate,
                cscd = csCd,
                orggrpcd = orgGrpcd,
                cscd_def1 = CSCD_DEF1,
                cscd_def2 = CSCD_DEF2,

                cancelflg = ConsultCancel.Used
            };

            List<dynamic> dataList = connection.Query(sql, sqlParam).ToList();

            //編集処理
            List<dynamic> outPutData = new List<object>();
            EditData(dataList, out outPutData);

            return outPutData;

        }

        /// <summary>
        /// データ編集
        /// </summary>
        /// <param name="dataList">取得データ</param>
        /// <param name="outPutData">編集後データ</param>
        /// <returns>true：成功　false：失敗</returns>
        private bool EditData( List<dynamic> dataList, out List<dynamic> outPutData )
        {
            bool ret = false;

            //## 出力ファイル名称編集 ##
            FileName = FILENAME_DEF + ".csv";

            //編集データ初期化
            outPutData = new List<object>();
            
            //編集情報取得
            var freeDao = new FreeDao(connection);
            IList<dynamic> settingData = freeDao.SelectFree(1, FREECD_SETTING);

            //出力対象者情報を最初から繰り返して読み込む
            int dataCnt = 0;
            foreach (var dataItem in dataList)
            {
                //受診金額情報取得
                var billDatas = GetBillData(dataItem.RSVNO);

                //レコード情報
                Dictionary<string, object> rec = new Dictionary<string, object>();

                //汎用マスタの情報に合わせて編集処理
                foreach (var setting in settingData)
                {
                    //汎用マスタの設定取得
                    string setDType = Util.ConvertToString(setting.FREEFIELD1); //データタイプ
                    string setLink = Util.ConvertToString(setting.FREEFIELD2);  //区分
                    string setItemCode = Util.ConvertToString(setting.FREEFIELD3);  //項目コード
                    string setItemName = Util.ConvertToString(setting.FREEFIELD4);  //項目名
                    string setFixedRsl = Util.ConvertToString(setting.FREEFIELD5);  //固定結果
                    int.TryParse(Util.ConvertToString(setting.FREEFIELD6), out int setSize);    //サイズ

                    //変換結果
                    string sResult = "";

                    //設定情報に従って結果編集
                    switch (setDType.Trim())
                    {
                        case "BAS":    //## データベースからの直接取得情報
                            IDictionary<string, object> itemDatas = dataList[dataCnt];
                            foreach (KeyValuePair<string, object> item in itemDatas)
                            {
                                //DBのフィールド名と値を取得
                                string dbFiledName = item.Key;  //フィールド名
                                string dbValue = Util.ConvertToString(item.Value);    //値

                                if ((dbFiledName == setItemCode.Trim()) && (dbValue != ""))
                                {
                                    //## 文章の中に含まれている空白を削除、最大サイズチェック
                                    sResult = CheckSize(CheckSpace(dbValue.Trim()), setSize);
                                    break;
                                }
                            }
                            break;

                        case "TOT":
                            //利用金額取得
                            var amount = GetAmount(dataItem.RSVNO);

                            decimal.TryParse(Util.ConvertToString(amount.TOTALPRICE), out decimal totalPrice);
                            sResult = CheckSize(totalPrice.ToString(), setSize);

                            break;

                        case "PAY":
                            //自己負担額
                            foreach (var bill in billDatas)
                            {
                                if ( Util.ConvertToString(bill.ORGCD).Trim() == setItemCode.Trim())
                                {
                                    //金額
                                    decimal.TryParse(Util.ConvertToString(bill.PRICE), out decimal price);

                                    switch (setLink.Trim())
                                    {
                                        case "X": case "Y":
                                            sResult = CheckSize(price.ToString(), setSize);
                                            break;
                                    }

                                }

                            }
                            break;

                        case "FIX":  //固定情報
                            sResult = CheckSize(CheckSpace(setFixedRsl.Trim()), setSize);

                            break;
                    }

                    //カラム名をキーにして結果追加
                    rec.Add(setItemName, sResult.Trim());
                }

                //データ追加
                outPutData.Add(rec);

                dataCnt++;
            }

            ret = true;

            //戻り値設定
            return ret;

        }

        /// <summary>
        /// 受診金額取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得データ</returns>
        private dynamic GetBillData(int rsvNo)
        {
            // SQLステートメント定義

            //#### 受診金額を個人負担額（'XXXXX'）と団体負担金額（'YYYYY'）に分けて取得
            string sql = @"
                select
                    'XXXXX' as orgcd
                    , nvl( 
                        ( 
                            select
                                sum(price + editprice + taxprice + edittax) as price 
                            from
                                consult_m 
                            where
                                consult_m.rsvno = :rsvno 
                                and consult_m.orgcd1 = :person_orgcd1
                        ) 
                        , 0
                    ) price 
                from
                    dual 
                union 
                select
                    'YYYYY' as orgcd
                    , nvl( 
                        ( 
                            select
                                sum(price + editprice + taxprice + edittax) as price 
                            from
                                consult_m 
                            where
                                consult_m.rsvno = :rsvno 
                                and consult_m.orgcd1 <> :person_orgcd1
                        ) 
                        , 0
                    ) price 
                from
                    dual
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                person_orgcd1 = WebHains.ORGCD1_PERSON
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 利用金額取得
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <returns></returns>
        private dynamic GetAmount(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    sum(price + taxprice + editprice + edittax) totalprice 
                from
                    ( 
                        select
                            consult_m.rsvno as rsvno
                            , consult_m.priceseq as priceseq
                            , consult_m.orgcd1 as orgcd1
                            , consult_m.orgcd2 as orgcd2
                            , consult_m.price as price
                            , consult_m.editprice as editprice
                            , consult_m.taxprice as taxprice
                            , consult_m.edittax as edittax 
                        from
                            consult_m 
                        where
                            consult_m.rsvno = :rsvno
                    ) perprice
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 空白削除
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>削除後文字列</returns>
        private string CheckSpace(string value)
        {
            string ret = Util.ConvertToString(value);

            //空白削除
            ret = ret.Replace(" ", "").Replace("　", "");

            return ret;
        }

        /// <summary>
        /// 文字列のサイズ（Byte）計算
        /// </summary>
        /// <param name="value">文字列</param>
        /// <param name="size">サイズ</param>
        /// <returns>編集後文字列</returns>
        private string CheckSize(string value, int size)
        {
            string ret = "";

            if (string.IsNullOrEmpty(value))
            {
                return "";
            }

            for (int i = 1; i <= value.Length; i++)
            {

                int nextByte = WebHains.LenB(value.Trim().Substring(i - 1, 1));

                if ((WebHains.LenB(ret) + nextByte) <= size)
                {
                    ret += value.Trim().Substring(i - 1, 1);
                }
                else
                {
                    break;
                }

            }

            return ret;
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //入力チェック
            if (!DateTime.TryParse(queryParams["startdate"], out DateTime wkDateStr))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out DateTime wkDateEnd))
            {
                messages.Add("終了日付が正しくありません。");
            }

            //団体指定チェック
            bool findFlg = false;
            for (int i = 1; i <= MAX_COUNT_ORG; i++)
            {
                string para_name1 = "orgcd1" + i.ToString();
                string para_name2 = "orgcd2" + i.ToString();

                //団体コードの入力確認
                if ((!string.IsNullOrEmpty(queryParams[para_name1])) || (!string.IsNullOrEmpty(queryParams[para_name2])))
                {
                    //団体指定がある場合、処理を抜ける
                    findFlg = true;
                    break;
                }
            }

            if (findFlg == false && (string.IsNullOrEmpty(queryParams["orggrpcd"])))
            {
                //団体コード、および団体グループ指定がない場合、エラー
                messages.Add("団体を選択してください。");
            }

            return messages;
        }
    }
}
