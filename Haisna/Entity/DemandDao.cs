using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Bill;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 請求情報データアクセスオブジェクト
    /// </summary>
    public class DemandDao : AbstractDao
    {
        // 表示順（個人別請求金額修正の受診者一覧）
        private const int DSL_SORT_DEFAULT = 0;  // 基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））

        // 表示順（請求対象受診者一覧）
        private const int DOL_SORT_DEFAULT = 0;  // 基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））

        // 表示順（健診請求チェック表）
        private const int DCL_SORT_DEFAULT = 0;  // デフォルト（受診日，コースコード，受診団体コード，管理番号，当日ＩＤ，予約番号，適用元区分（降順），ＳＥＱ，タイプ，オプションコード，グループコード，検査項目コード）
        private const int DCL_SORT_DAYID = 1;    // 当日ＩＤ順（受診日，管理番号，当日ＩＤ，コースコード，受診団体コード，予約番号，適用元区分（降順），ＳＥＱ，タイプ，オプションコード，グループコード，検査項目コード）

        // 負担元団体名のデフォルト値
        private const string ORGNAME_PERSON = "個人";
        private const string ORGNAME_PERSON2 = "自己負担";

        // オプション名のデフォルト値
        private const string OPTNAME_COURSE = "基本コース";

        // 桁数
        private const int LENGTH_EDITPRICE = 7;          // 調整金額
        private const int LENGTH_EDITTAX = 7;            // 税調整金額
        private const int LENGTH_STADIV = 1;             // 統計区分
        private const int LENGTH_BILLNO = 14;            // 請求書番号
        private const int LENGTH_PAYMENTPRICE = 8;       // 入金額
        private const int LENGTH_DAYCOUNT = 3;           // 日数
        private const int LENGTH_SUBTOTAL = 8;           // 金額
        private const int LENGTH_TAX = 8;                // 消費税
        private const int LENGTH_DISCOUNT = 8;           // 値引き
        private const int LENGTH_TOTAL = 8;              // 合計
        private const int LENGTH_TAXRATES = 5;           // 適用税率
        private const int LENGTH_TAXRATES_DECPOINT = 2;  // 適用税率（小数部）

        // MAXLENGTH追加
        private const int LENGTH_RSVNO = 9;              // 受診番号
        private const int LENGTH_PRICE = 7;              // 金額
        private const int LENGTH_TAXPRICE = 7;           // 税額
        private const int LENGTH_DETAILNAME = 30;        // 明細名
        private const int LENGTH_LASTNAME = 50;          // 姓
        private const int LENGTH_LASTKNAME = 50;         // 名
        private const int LENGTH_FIRSTNAME = 50;         // 姓（カナ）
        private const int LENGTH_FIRSTKNAME = 50;        // 名（カナ）
        private const int LENGTH_PAYNOTE = 400;          // 入金コメント

        /// <summary>
        /// グループデータアクセスオブジェクト
        /// </summary>
        readonly GrpDao grpDao;

        /// <summary>
        /// 検査項目データアクセスオブジェクト
        /// </summary>
        readonly ItemDao itemDao;

        /// <summary>
        /// 団体データアクセスオブジェクト
        /// </summary>
        readonly OrganizationDao organizationDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="grpDao">グループデータアクセスオブジェクト</param>
        /// <param name="itemDao">検査項目データアクセスオブジェクト</param>
        /// <param name="organizationDao">団体データアクセスオブジェクト</param>
        public DemandDao(IDbConnection connection, GrpDao grpDao, ItemDao itemDao, OrganizationDao organizationDao) : base(connection)
        {
            this.grpDao = grpDao;
            this.itemDao = itemDao;
            this.organizationDao = organizationDao;
        }

        /// <summary>
        /// 個人別請求金額修正入力値の妥当性チェックを行う
        /// </summary>
        /// <param name="data">入力値
        /// rsvno        予約番号
        /// ctrptcd      契約パターンコード
        /// taxfraction  税端数区分
        /// nowtax       適用税率
        /// seq          （配列）ＳＥＱ
        /// apdiv        （配列）適用元区分
        /// orgcd1       （配列）団体コード１
        /// orgcd2       （配列）団体コード２
        /// pricetype    （配列）タイプ（0:基本コース, 1:基本コースの削除項目, 2:オプション検査, 3:契約外追加グループ, 4:契約外追加項目）
        /// optcd        （配列）オプションコード
        /// grpcd        （配列）グループコード
        /// itemcd       （配列）検査項目コード
        /// price        （配列）請求金額（"-9999999"～"9999999":金額）
        /// editprice    （配列）調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
        /// edittax      （配列）税調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
        /// taxflg       （配列）消費税負担フラグ（0:負担しない, 1:負担する）
        /// count        レコード件数（配列の要素数）
        /// </param>
        /// <param name="refParam">(Out)戻り値
        /// closeflg     締めフラグ（0:締め処理は行われていない, 1:締め処理が完了している）
        /// orgname      （配列）団体名
        /// orgsname     （配列）団体略称
        /// optname      （配列）オプション名
        /// grpname      （配列）グループ名
        /// requestname  （配列）依頼項目名
        /// tax          （配列）消費税金額（"*-hidden-*":非表示, "-9999999"～"9999999":金額）
        /// </param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValueDmdPerModify(JToken data, ref dynamic refParam)
        {
            var messages = new List<string>();  // エラーメッセージの集合
            string itemName = "";               // 項目名編集用
            string itemName2 = "";              // 項目名編集用
            int i;                              // インデックス

            JToken array = data["array"];

            while (true)
            {
                // 各名称取得処理
                for (i = 0; i <= (Convert.ToInt32(data["count"]) - 1); i++)
                {
                    // 適用元区分が０（個人）の場合
                    if (ApDiv.Person.Equals(array[i]["apdiv"]))
                    {

                        // 負担元団体名のデフォルト値を設定する
                        refParam.orgname[i] = ORGNAME_PERSON;
                        refParam.orgsname[i] = ORGNAME_PERSON;

                        // 適用元区分が０（個人）以外の場合
                    }
                    else
                    {
                        // 団体名・団体略称を取得する
                        refParam.orgname[i] = organizationDao.SelectOrgName(Convert.ToString(array[i]["orgcd1"]), Convert.ToString(array[i]["orgcd2"]))["orgname"];
                        refParam.orgsname[i] = organizationDao.SelectOrgSName(Convert.ToString(array[i]["orgcd1"]), Convert.ToString(array[i]["orgcd2"]))["orgsname"];
                    }

                    // タイプに従って名称を取得する
                    switch (Convert.ToInt32(array[i]["pricetype"]))
                    {
                        case 0:
                            {
                                // （基本コース）の場合
                                // オプション名のデフォルト値を設定する
                                refParam.optname[i] = OPTNAME_COURSE;
                                break;
                            }
                        case 1:
                            {
                                // （基本削除）の場合
                                // オプション名を取得する
                                refParam.optname[i] = GetOptName(Convert.ToInt32(data["ctrptcd"]), Convert.ToInt32(array[i]["optcd"]));

                                break;
                            }
                        case 2:
                            {
                                // （オプション検査）の場合
                                // オプション名を取得する
                                refParam.optname[i] = GetOptName(Convert.ToInt32(data["ctrptcd"]), Convert.ToInt32(array[i]["optcd"]));

                                break;
                            }
                        case 3:
                            {
                                // （契約外追加グループ）の場合
                                // グループ名を取得する
                                refParam.grpname[i] = grpDao.SelectGrp_P(Convert.ToString(array[i]["grpcd"]));

                                break;
                            }
                        case 4:
                            {
                                // （契約外追加項目）の場合
                                // 依頼項目名を取得する
                                refParam.requestname[i] = itemDao.SelectItem_P(Convert.ToString(array[i]["itemcd"]));

                                break;
                            }
                    }
                }

                // 締めフラグを取得する
                refParam.closeflg = GetCloseFlg(Convert.ToInt32(data["rsvno"]), Convert.ToInt32(data["ctrptcd"]));

                // 締め処理が完了している場合
                if (Convert.ToInt32(data["closeflg"]) == 1)
                {
                    messages.Add("このデータは既に締め処理が完了しています。");
                    break;
                }

                // 各値チェック処理
                for (i = 0; i <= (Convert.ToInt32(data["count"]) - 1); i++)
                {
                    // 項目名の編集
                    itemName = "";
                    itemName2 = "";
                    if (ApDiv.Person.Equals(array[i]["apdiv"]))
                    {
                        itemName = itemName + "個人：　";
                    }
                    else
                    {
                        itemName = itemName + Convert.ToString(refParam.orgname[i]) + "：　";
                    }

                    switch (Convert.ToInt32(array[i]["pricetype"]))
                    {
                        case 0:
                            {
                                // （基本コース）の場合
                                itemName2 = "基本コースの　";
                                break;
                            }
                        case 1:
                            {
                                // （基本削除）の場合
                                itemName2 = Convert.ToString(refParam.optname[i]) + "の　";
                                break;
                            }
                        case 2:
                            {
                                // （オプション検査）の場合
                                itemName2 = Convert.ToString(refParam.optname[i]) + "の　";
                                break;
                            }
                        case 3:
                            {
                                // （契約外追加グループ）の場合
                                itemName2 = Convert.ToString(refParam.grpname[i]) + "の　";
                                break;
                            }
                        case 4:
                            {
                                // （契約外追加項目）の場合
                                itemName2 = Convert.ToString(refParam.requestname[i]) + "の　";
                                break;
                            }
                    }

                    // 調整金額のチェック
                    if (!("*-hidden-*").Equals(array[i]["editprice"]))
                    {
                        messages.Add(WebHains.CheckNumericWithSign((itemName + itemName2 + "調整金額　"), Convert.ToString(array[i]["editprice"]), LENGTH_EDITPRICE));
                    }

                    // 税調整金額のチェック
                    if (!("*-hidden-*").Equals(array[i]["edittax"]))
                    {
                        messages.Add(WebHains.CheckNumericWithSign(itemName + "税調整金額　", Convert.ToString(array[i]["edittax"]), LENGTH_EDITTAX));
                    }
                }

                if (messages.Count > 0)
                {
                    break;
                }

                // 消費税再計算処理
                CompTax(data, ref refParam.tax);

                break;
            }

            return messages;
        }

        /// <summary>
        /// オプション名を取得する
        /// </summary>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="optCd">オプションコード</param>
        /// <returns>オプション名</returns>
        private string GetOptName(int ctrPtCd, int optCd)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                ctrptcd2 = ctrPtCd,
                optcd2 = optCd
            };

            // 検索条件を満たす契約パターンオプション管理のレコードを取得
            sql = @"
                    select
                      optname
                    from
                      ctrpt_opt
                    where
                      ctrptcd = :ctrptcd2
                      and optcd = :optcd2
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            return Convert.ToString(current.OPTNAME);
        }

        /// <summary>
        /// 個人請求金額取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="summary">TRUE:合計金額を返す、FALSE:明細で返す</param>
        /// <param name="withOther">TRUE:電話代などの医療費も返す、FALSE:医療費のみ</param>
        /// <returns>個人請求金額
        /// sumdiv    金額合計分類
        /// itemname  適用名称（合計の場合は、合計）
        /// price     金額
        /// tax       税額
        /// </returns>
        public List<dynamic> GetPersonalPrice(int rsvNo, bool summary, bool withOther)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // 受診金額確定テーブル読み込み
            if (summary)
            {
                // 合計金額を取得する場合
                sql = @"
                        select
                          sum((consult_m.price + consult_m.editprice)) price
                          , sum((consult_m.taxprice + consult_m.edittax)) tax
                        from
                          consult_m
                        where
                          consult_m.rsvno = :rsvno
                          and (
                            (
                              consult_m.orgcd1 = 'XXXXX'
                              and consult_m.orgcd2 = 'XXXXX'
                            )
                            or (
                              consult_m.orgcd1 = 'WWWWW'
                              and consult_m.orgcd2 = 'WWWWW'
                            )
                          )
                    ";
            }
            else
            {
                // 明細イメージを取得する場合
                sql = @"
                        select
                          consult_m.itemname
                          , consult_m.sumdiv
                          , (consult_m.price + consult_m.editprice) price
                          , (consult_m.taxprice + consult_m.edittax) tax
                        from
                          consult_m
                        where
                          consult_m.rsvno = :rsvno
                          and (
                            (
                              consult_m.orgcd1 = 'XXXXX'
                              and consult_m.orgcd2 = 'XXXXX'
                            )
                            or (
                              consult_m.orgcd1 = 'WWWWW'
                              and consult_m.orgcd2 = 'WWWWW'
                            )
                          )
                        order by
                          seq
                    ";
            }

            connection.Query(sql, sqlParam).ToList();

            // #ToDo Select後の.Net側での処理をどうするか 。本メソッド自体未使用である可能性があります。
            //'検索レコードが存在する場合
            //If Not objOraDyna.EOF Then


            //    'オブジェクトの参照設定
            //    Set objFields = objOraDyna.Fields
            //    Set objPrice = objFields("PRICE")
            //    Set objTax = objFields("TAX")


            //    '明細イメージを取得する場合の設定
            //    If blnSummary = False Then
            //        Set objSumDiv = objFields("SUMDIV")
            //        Set objItemName = objFields("ITEMNAME")
            //    End If


            //    '配列形式で格納する
            //    lngCount = 0
            //    Do Until objOraDyna.EOF

            //        ReDim Preserve vntArrPrice(lngCount)
            //        ReDim Preserve vntArrTax(lngCount)
            //        vntArrPrice(lngCount) = objPrice.Value
            //        vntArrTax(lngCount) = objTax.Value


            //        '明細イメージを取得する場合の設定
            //        If blnSummary = False Then
            //            ReDim Preserve vntArrSumDiv(lngCount)
            //            ReDim Preserve vntArrItemName(lngCount)
            //            vntArrSumDiv(lngCount) = objSumDiv.Value
            //            vntArrItemName(lngCount) = objItemName.Value
            //        End If


            //        lngCount = lngCount + 1
            //        objOraDyna.MoveNext
            //    Loop


            //End If


            //'一度初期化
            //Set objOraDyna = Nothing
            //Set objFields = Nothing
            //Set objPrice = Nothing
            //Set objTax = Nothing


            // 健診以外の金額も読み込む場合
            //If blnWithOther = True Then
            if (withOther)
            {
                // 財務連携テーブル読み込み（収納区分が健診以外のもの）
                sql = @"
                        select
                          insdiv
                          , sum(price) price
                          , sum(taxprice) tax
                        from
                          consult_zaimu
                        where
                          rsvno = :rsvno
                          and insdiv != 0
                          and inzaimuseq is null
                        group by
                          insdiv
                        order by
                          insdiv
                    ";

                connection.Query(sql, sqlParam).ToList();

                // #ToDo Select後の.Net側での処理をどうするか 。本メソッド自体未使用である可能性があります。
                //    '検索レコードが存在する場合
                //    If Not objOraDyna.EOF Then


                //        'オブジェクトの参照設定
                //        Set objFields = objOraDyna.Fields
                //        Set objPrice = objFields("PRICE")
                //        Set objTax = objFields("TAX")
                //        Set objInsDiv = objFields("INSDIV")


                //        '配列形式で格納する
                //        Do Until objOraDyna.EOF

                //            ReDim Preserve vntArrPrice(lngCount)
                //            ReDim Preserve vntArrTax(lngCount)
                //            vntArrPrice(lngCount) = objPrice.Value
                //            vntArrTax(lngCount) = objTax.Value


                //            '明細イメージを取得する場合の設定
                //            If blnSummary = False Then
                //                ReDim Preserve vntArrSumDiv(lngCount)
                //                ReDim Preserve vntArrItemName(lngCount)
                //                Select Case objInsDiv.Value
                //                    Case "1"
                //                        vntArrItemName(lngCount) = "電話代"


                //                    Case "2"
                //                        vntArrItemName(lngCount) = "文書作成料"


                //                    Case "3"
                //                        vntArrItemName(lngCount) = "その他"


                //                End Select


                //                '医療行為以外の区分は90番台で返す
                //                vntArrSumDiv(lngCount) = "9" & objInsDiv.Value


                //            End If


                //            lngCount = lngCount + 1
                //            objOraDyna.MoveNext
                //        Loop


                //    End If


            }


            //If lngCount > 0 Then

            //    If blnSummary = True Then


            //        'サマリの場合、合計金額を返す
            //        lngTotalPrice = 0
            //        lngTotalTax = 0
            //        For i = 0 To lngCount -1
            //            lngTotalPrice = lngTotalPrice + vntArrPrice(i)
            //            lngTotalTax = lngTotalTax + vntArrTax(i)
            //        Next i


            //        If IsMissing(vntSumDiv) = False Then vntSumDiv = "*"
            //        If IsMissing(vntItemName) = False Then vntItemName = "合計"
            //        If IsMissing(vntPrice) = False Then vntPrice = lngTotalPrice
            //        If IsMissing(vntTax) = False Then vntTax = lngTotalTax


            //    Else


            //        '明細の場合
            //        If IsMissing(vntSumDiv) = False Then vntSumDiv = vntArrSumDiv
            //        If IsMissing(vntItemName) = False Then vntItemName = vntArrItemName
            //        If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
            //        If IsMissing(vntTax) = False Then vntTax = vntArrTax


            //    End If


            //End If


            //'戻り値の設定
            //GetPersonalPrice = lngCount

            // 戻り値の設定
            return null;
        }

        /// <summary>
        /// 指定予約番号の負担金額情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>負担金額情報
        /// orgname      団体名称
        /// courceprice  基本コース負担金額
        /// optionprice  オプション負担金額
        /// noctrprice   契約外項目負担金額
        /// tax          消費税
        /// totalprice   負担金額計
        /// </returns>
        public List<dynamic> GetOrgSummaryPriceFromRsvNo(int rsvNo)
        {
            string sql = "";  // SQLステートメント

            using (var transaction = BeginTransaction())
            {
                // エラーハンドラの設定
                try
                {
                    // キー値の設定
                    var param = new OracleDynamicParameters();
                    param.Add("rsvno", dbType: OracleDbType.Decimal, value: rsvNo, direction: ParameterDirection.Input);
                    param.Add("summaryinfocursor", dbType: OracleDbType.RefCursor, direction: ParameterDirection.InputOutput);

                    // 請求情報ストアドパッケージの関数呼び出し
                    sql = @"
                            begin demandpackage.getorgsummarypricefromrsvno(:rsvno, :summaryinfocursor);
                            end;
                        ";

                    List<dynamic> retList = connection.Query(sql, param).ToList();

                    // キー値の設定
                    var sqlParam = new
                    {
                        rsvno = rsvNo
                    };

                    // 一時表（本当は実表だが・・・）のデータを消す
                    sql = @"
                            delete money_details_temp
                            where
                              rsvno = :rsvno
                        ";

                    connection.Execute(sql, sqlParam);

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    return retList;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    throw;
                }
            }
        }

        /// <summary>
        /// 締めフラグを取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>締めフラグ（0:締め処理は行われていない, 1:締め処理が完了している）</returns>
        private int GetCloseFlg(int rsvNo, int ctrPtCd)
        {
            string sql = "";  // SQLステートメント

            var sqlParam = new
            {
                rsvno5 = rsvNo,
                ctrptcd5 = ctrPtCd

            };

            // 締めフラグを取得
            sql = @"
                    select
                      decode(count(*), 0, 0, 1) closeflg
                    from
                      closemng
                    where
                      closemng.rsvno = :rsvno5
                      and closemng.ctrptcd = :ctrptcd5
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                // 戻り値の設定
                return Convert.ToInt32(current.CLOSEFLG);
            }
            else
            {
                // 戻り値の設定
                return 0;
            }

        }

        /// <summary>
        /// 消費税を再計算する
        /// </summary>
        /// <param name="data">入力値
        /// taxfraction  税端数区分
        /// nowtax       適用税率
        /// seq          （配列）ＳＥＱ
        /// price        （配列）請求金額（"-9999999"～"9999999":金額）
        /// editprice    （配列）調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
        /// taxflg       （配列）消費税負担フラグ（0:負担しない, 1:負担する）
        /// count        レコード件数（配列の要素数）
        /// </param>
        /// <param name="tax">(Out)（配列）消費税金額（"*-hidden-*":非表示, "-9999999"～"9999999":金額）</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool CompTax(JToken data, ref object tax)
        {
            int compTaxType;    // 消費税計算方式（1:１つの負担元が負担, 以外:各負担元が負担）

            int compPrice = 0;  // （計算用）請求金額合計
            double compTax;     // （計算用）消費税金額
            int compDevideTax;  // （計算用）消費税金額

            string seq = "";    // ブレイクキー保存（負担元）
            int taxFlg = 0;     // ブレイクキー保存（消費税負担フラグ）
            int index = 0;      // ブレイクキー保存（消費税格納位置）

            int i;              // インデックス
            JToken array = data["array"];

            // 初期処理
            bool returnFlag = false;

            // 消費税計算方式を求める（消費税負担フラグが１つしか立ってないか、複数立っているか）
            compTaxType = 0;
            for (i = 0; i <= (Convert.ToInt32(data["count"]) - 1); i++)
            {
                // 消費税負担対象数をカウント
                if (!0.Equals(array[i]["taxflg"]))
                {
                    compTaxType++;
                }
            }

            // １つの負担元がすべての消費税を負担する場合
            if (compTaxType == 1)
            {
                // 請求金額の総合計を計算
                compPrice = 0;
                for (i = 0; i <= (Convert.ToInt32(data["count"]) - 1); i++)
                {
                    // 請求金額を加算
                    compPrice += Convert.ToInt32(array[i]["price"]);
                    // 調整金額を加算
                    if (!("*-hidden-*").Equals(Convert.ToString(array[i]["editprice"]).Trim()))
                    {
                        if (Util.IsNumber(Convert.ToString(array[i]["editprice"]).Trim()))
                        {
                            compPrice += Convert.ToInt32(array[i]["editprice"]);
                        }
                    }
                }

                // 消費税金額を計算（端数処理前）
                compTax = compPrice * Convert.ToDouble(data["nowtax"]);

                // 消費税金額を、税金端数区分の内容に従い計算
                compDevideTax = CompDevideTax(Convert.ToString(data["taxfraction"]), compTax);

                // 計算された消費税金額を格納
                for (i = 0; i <= (Convert.ToInt32(data["count"]) - 1); i++)
                {
                    // 消費税負担対象の負担元に格納
                    if (!0.Equals(array[i]["taxflg"]))
                    {
                        ((List<Int32>)tax)[i] = compDevideTax;
                        break;
                    }
                }

                // 各負担元がそれぞれの消費税を負担する場合
            }
            else
            {
                // 負担元ごとに処理する
                seq = "";
                for (i = 0; i <= (Convert.ToInt32(data["count"]) - 1); i++)
                {

                    // 負担元キーブレイク時
                    if (i > 0 && !seq.Equals(array[i]["seq"]))
                    {
                        // 該当負担元が消費税負担対象の場合
                        if (taxFlg != 0)
                        {
                            // 消費税金額を計算（端数処理前）
                            compTax = compPrice * Convert.ToDouble(data["nowtax"]);
                            // 消費税金額を、税金端数区分の内容に従い計算
                            compDevideTax = CompDevideTax(Convert.ToString(data["taxfraction"]), compTax);
                            // 計算された消費税金額を格納
                            ((List<Int32>)tax)[index] = compDevideTax;
                        }
                    }

                    // 負担元キーブレイク時
                    if (i == 0 || !seq.Equals(array[i]["seq"]))
                    {
                        // 計算用領域のクリア
                        compPrice = 0;
                        // 該当負担元の消費税負担フラグと消費税格納位置を保存
                        taxFlg = Convert.ToInt32(array[i]["taxflg"]);
                        index = i;
                    }

                    // 該当負担元が消費税負担対象の場合
                    if (taxFlg != 0)
                    {
                        // 請求金額を加算
                        compPrice += Convert.ToInt32(array[i]["price"]);
                        // 調整金額を加算
                        if (array[i]["editprice"] != null && !("*-hidden-*").Equals(Convert.ToString(array[i]["editprice"]).Trim()))
                        {
                            //if (Information.IsNumeric(Strings.Trim(Convert.ToString(((object[])vntEditPrice)[i]))))
                            if (Util.IsNumber(Convert.ToString(array[i]["editprice"]).Trim()))
                            {
                                compPrice += Convert.ToInt32(array[i]["editprice"]);
                            }
                        }
                    }

                    // ブレイクキー保存（負担元）
                    seq = Convert.ToString(array[i]["seq"]);

                }

                // データが１つ以上ある時
                if (Convert.ToInt32(data["count"]) > 0)
                {
                    // 最後の負担元が消費税負担対象の場合
                    if (taxFlg != 0)
                    {
                        // 消費税金額を計算（端数処理前）
                        compTax = compPrice * Convert.ToDouble(data["nowtax"]);
                        // 消費税金額を、税金端数区分の内容に従い計算
                        compDevideTax = CompDevideTax(Convert.ToString(data["taxfraction"]), compTax);
                        // 計算された消費税金額を格納
                        ((List<Int32>)tax)[index] = compDevideTax;
                    }
                }
            }

            // 戻り値の設定
            returnFlag = true;

            return returnFlag;
        }

        /// <summary>
        /// 検索条件を満たす受診者情報の件数を取得する（受診者の検索（個人別請求金額修正））
        /// </summary>
        /// <param name="strDate">受診日（開始）</param>
        /// <param name="endDate">受診日（終了）</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="perID">個人ＩＤ</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int SelectDmdSearchListCount(string strDate, string endDate, string orgCd1, string orgCd2, string perID, string csCd)
        {
            string sql = "";  // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!(DateTime.TryParse(strDate.Trim(), out DateTime tmpStrDate) && DateTime.TryParse(endDate.Trim(), out DateTime tmpEndDate)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("strdate", strDate.Trim());
            sqlParam.Add("enddate", endDate.Trim());
            sqlParam.Add("orgcd1", orgCd1.Trim());
            sqlParam.Add("orgcd2", orgCd2.Trim());
            sqlParam.Add("perid", perID.Trim());
            sqlParam.Add("cscd", csCd.Trim());
            sqlParam.Add("cancelflg", Convert.ToInt32(ConsultCancel.Used));

            // 検索条件を満たす受診者情報のレコード件数を取得
            sql = @"
                    select
                      count(*) reccount
                    from
                      consult
                    where
                      csldate between :strdate and :enddate
                      and cancelflg = :cancelflg
                ";

            // 条件節を追加
            if (!string.IsNullOrEmpty(orgCd1) || !string.IsNullOrEmpty(orgCd2))
            {
                // 団体指定あり
                sql += @"
                        and orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                    ";
            }

            if (!string.IsNullOrEmpty(perID))
            {
                // 個人ＩＤ指定あり
                sql += @"
                        and perid = :perid
                    ";
            }

            if (!string.IsNullOrEmpty(csCd))
            {
                // コースコード指定あり
                sql += @"
                        and cscd = :cscd
                    ";
            }

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            // (COUNT関数を発行しているので必ず1レコード返ってくる)
            if (current != null)
            {
                // 戻り値の設定
                return Convert.ToInt32(current.RECCOUNT);
            }
            else
            {
                // 戻り値の設定
                return 0;
            }
        }

        /// <summary>
        /// 検索条件を満たす金額情報のCSVファイルを出力する
        /// </summary>
        /// <param name="data">金額情報
        /// filename     ファイル名
        /// strdate      受診日（開始）
        /// enddate      受診日（終了）
        /// cscd         コースコード
        /// orgcd1       団体コード1
        /// orgcd2       団体コード2
        /// selectmode   NULL:全て、1:基本コースのみ、2:オプションのみ
        /// </param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int SelectDmdCsvList(JToken data)
        {
            string sql = "";      // SQLステートメント
            int fileNumber;       // ファイル番号
            int count = 0;        // レコード数
            string endDate = "";  // 受診日（終了）

            // 開始日付が設定されていない場合はエラー
            if (!DateTime.TryParse(Convert.ToString(data["strdate"]).Trim(), out DateTime tmpStrDate))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 終了日付が設定されていない場合は開始日付をセット
            if (data["enddate"] == null)
            {
                endDate = Convert.ToString(data["strdate"]);
            }
            else
            {
                if (!DateTime.TryParse(Convert.ToString(data["enddate"]).Trim(), out DateTime tmpEndDate))
                {
                    throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
                }
                else
                {
                    endDate = Convert.ToString(data["enddate"]);
                }
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("strdate", Convert.ToDateTime(Convert.ToString(data["strdate"]).Trim()));
            sqlParam.Add("enddate", Convert.ToDateTime(endDate.Trim()));

            // 検索条件を満たす金額情報を取得
            sql = @"
                    select
                      consult.csldate
                      , consult.rsvno
                      , consult.cscd
                      , course_p.csname
                      , consult.orgcd1
                      , consult.orgcd2
                      , mainorg.orgname
                      , consult.perid
                      , person.lastname || '　' || person.firstname cslname
                      , consult_m.orgcd1 burdenorgcd1
                      , consult_m.orgcd2 burdenorgcd2
                      , burdenorg.orgname burdenorgname
                      , consult_m.itemname
                      , consult_m.price + consult_m.editprice price
                      , consult_m.taxprice + consult_m.edittax tax
                      , consult.age
                      , person.gender
                      , persondetail.empno
                    from
                      org burdenorg
                      , consult_m
                      , course_p
                      , org mainorg
                      , person
                      , persondetail
                      , consult
                    where
                      consult.csldate between :strdate and :enddate
                      and consult.cancelflg = 0
                      and consult.perid = person.perid
                      and consult.perid = persondetail.perid
                      and consult.orgcd1 = mainorg.orgcd1
                      and consult.orgcd2 = mainorg.orgcd2
                      and consult.cscd = course_p.cscd
                      and consult_m.rsvno = consult.rsvno
                      and consult_m.orgcd1 = burdenorg.orgcd1
                      and consult_m.orgcd2 = burdenorg.orgcd2
                      and (
                        consult_m.price != 0
                        or consult_m.editprice != 0
                        or consult_m.taxprice != 0
                        or consult_m.edittax != 0
                      )
                ";

            // 省略可能なキー値のセット～コースコード
            if (data["cscd"] != null)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(data["cscd"]).Trim()))
                {
                    sqlParam.Add("cscd", Convert.ToString(data["cscd"]).Trim());
                    sql += @"
                            and consult.cscd = :cscd
                        ";
                }
            }

            // 省略可能なキー値のセット～団体コード１
            if (data["orgcd1"] != null)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(data["orgcd1"]).Trim()))
                {
                    sqlParam.Add("orgcd1", Convert.ToString(data["orgcd1"]).Trim());
                    sql += @"
                            and consult.orgcd1 = :orgcd1
                        ";
                }
            }

            // 省略可能なキー値のセット～団体コード２
            if (data["orgcd2"] != null)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(data["orgcd2"]).Trim()))
                {
                    sqlParam.Add("orgcd2", Convert.ToString(data["orgcd2"]).Trim());
                    sql += @"
                            and consult.orgcd2 = :orgcd2
                        ";
                }
            }

            // 省略可能なキー値のセット～抽出モード
            if (data["selectmode"] != null)
            {
                switch (Convert.ToString(data["selectmode"]).Trim())
                {
                    case "1":
                        sql += @"
                                and consult_m.optcd = 0
                            ";
                        break;
                    case "2":
                        sql += @"
                                and consult_m.optcd != 0
                            ";
                        break;
                }
            }

            sql += @"
                    order by
                      consult.csldate
                      , consult.cscd
                      , consult.rsvno
                      , consult_m.seq
                      , consult_m.sumdiv
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // レコードが存在する場合
            if (current != null)
            {

                // #ToDo CSVを作成する方法をどうするか
                //        Set objFields = objOraDyna.Fields
                //        Set objCslDate = objFields("CSLDATE")
                //        Set objRsvNo = objFields("RSVNO")
                //        Set objCsCd = objFields("CSCD")
                //        Set objCsName = objFields("CSNAME")
                //        Set objOrgCd1 = objFields("ORGCD1")
                //        Set objOrgCd2 = objFields("ORGCD2")
                //        Set objOrgName = objFields("ORGNAME")
                //        Set objPerId = objFields("PERID")
                //        Set objCslName = objFields("CSLNAME")
                //        Set objBurdenOrgCd1 = objFields("BURDENORGCD1")
                //        Set objBurdenOrgCd2 = objFields("BURDENORGCD2")
                //        Set objBurdenOrgName = objFields("BURDENORGNAME")
                //        Set objItemName = objFields("ITEMNAME")
                //        Set objPrice = objFields("PRICE")
                //        Set objTax = objFields("TAX")
                //        '## 2002.6.6 ADD ST FAS) C.M
                //        Set objempNo = objFields("EMPNO")
                //        Set objgender = objFields("GENDER")
                //        Set obage = objFields("AGE")
                //        '## 2002.6.6 ADD ED FAS) C.M
                //        'ファイルオープン
                //        lngFileNumber = FreeFile
                //        Open strFileName For Output As #lngFileNumber

                //        'ヘッダー行出力
                //'## 2002.6.6 ADD ST FAS)C.M
                //'        Print #lngFileNumber, "受診日,予約番号,コースコード,コース名,受診団体コード1,受診団体コード2,受診団体名,個人ID,受診者名,負担元団体コード1,負担元団体コード2,負担元名,受診項目名,金額,税額"
                //        Print #lngFileNumber, "受診日,予約番号,コースコード,コース名,受診団体コード1,受診団体コード2,受診団体名,個人ID,従業員ID,性別,受診時年齢,受診者名,負担元団体コード1,負担元団体コード2,負担元名,受診項目名,金額,税額"
                //'## 2002.6.6 ADD ED FAS)C.M


                //        '明細行出力
                //        Do Until objOraDyna.EOF
                //            Write #lngFileNumber, _
                //                  objCslDate.Value & "", _
                //                  objRsvNo.Value & "", _
                //                  objCsCd.Value & "", _
                //                  objCsName.Value & "", _
                //                  objOrgCd1.Value & "", _
                //                  objOrgCd2.Value & "", _
                //                  objOrgName.Value & "", _
                //                  objPerId.Value & "", _
                //                  objempNo.Value & "", _
                //                  IIf(objgender.Value = "1", "男性", "女性") & "", _
                //                  obage.Value & "", _
                //                  objCslName.Value & "", _
                //                  objBurdenOrgCd1.Value & "", _
                //                  objBurdenOrgCd2.Value & "", _
                //                  objBurdenOrgName.Value & "", _
                //                  objItemName.Value & "", _
                //                  objPrice.Value & "", _
                //                  objTax.Value & ""


                //                lngCount = lngCount + 1
                //            objOraDyna.MoveNext
                //        Loop


                //        'ファイルクローズ
                //        Close #lngFileNumber
            }

            return count;
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する（受診者の検索（個人別請求金額修正））
        /// </summary>
        /// <param name="data">
        /// strdate      受診日（開始）
        /// enddate      受診日（終了）
        /// orgcd1       団体コード1
        /// orgcd2       団体コード2
        /// perid        個人ＩＤ
        /// cscd         コースコード
        /// sortkey      ソート順（0:基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ）））
        /// startpos     開始位置
        /// getcount     取得件数
        /// csldate      受診日（"yyyy年m月d日"編集）
        /// dayid        当日ID（"0001"編集）
        /// webcolor     コース名表示色
        /// csname       コース名
        /// lastname     姓
        /// firstname    名
        /// lastkname    カナ姓
        /// firstkname   カナ名
        /// orgname      団体名
        /// orgsname     団体略称
        /// courseprice  基本コース金額（"1,234"編集）
        /// optionprice  オプション金額（"1,234"編集）
        /// otherprice   契約外金額（"1,234"編集）
        /// taxprice     消費税金額（"1,234"編集）
        /// totalprice   合計金額（"1,234"編集）
        /// timefra      時間枠
        /// timefraname  時間枠名称
        /// cntlno       管理番号（"0001"編集）
        /// gendername   性別名称
        /// birth        生年月日（"yyyy/mm/dd"編集）
        /// age          年齢
        /// rsvdate      予約日（"yyyy年m月d日"編集）
        /// rsvno        予約番号
        /// perid        個人ＩＤ
        /// incomeprice  入金済み金額
        /// </param>
        /// <returns>受診者一覧</returns>
        public List<dynamic> SelectDmdSearchList(JToken data)
        {
            string sql = "";            // SQLステートメント
            string sqlIncomeStmt = "";  // SQLステートメント
            string sqlProcedure = "";   // SQLストアド

            // 検索条件が設定されていない場合はエラー
            if (!(DateTime.TryParse(Convert.ToString(data["strdate"]).Trim(), out DateTime tmpStrDate) && (DateTime.TryParse(Convert.ToString(data["enddate"]).Trim(), out DateTime tmpEndDate))))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("strdate", Convert.ToString(data["strdate"]).Trim());
            sqlParam.Add("enddate", Convert.ToString(data["enddate"]).Trim());
            sqlParam.Add("orgcd1", Convert.ToString(data["orgcd1"]).Trim());
            sqlParam.Add("orgcd2", Convert.ToString(data["orgcd2"]).Trim());
            sqlParam.Add("perid", Convert.ToString(data["perid"]).Trim());
            sqlParam.Add("cscd", Convert.ToString(data["cscd"]).Trim());

            // 取得件数が「すべて」以外の場合
            if (Util.IsNumber(Convert.ToString(data["getcount"])))
            {

                sqlParam.Add("seq_f", Convert.ToInt32(data["startpos"]));
                sqlParam.Add("seq_t", (Convert.ToInt32(data["startpos"]) + Convert.ToInt32(data["getcount"])));
            }

            sqlParam.Add("cancelflg", Convert.ToInt32(ConsultCancel.Used));
            sqlParam.Add("rsvno", 0);
            sqlParam.Add("courseprice", 0);
            sqlParam.Add("optionprice", 0);
            sqlParam.Add("otherprice", 0);
            sqlParam.Add("taxprice", 0);
            sqlParam.Add("totalprice", 0);

            // 検索条件を満たす受診者情報のレコードを取得
            sql = @"
                    select
                      csldate
                      , dayid
                      , webcolor
                      , csname
                      , lastname
                      , firstname
                      , lastkname
                      , firstkname
                      , orgname
                      , orgsname
                      , timefra
                      , cntlno
                      , gender
                      , birth
                      , age
                      , rsvdate
                      , rsvno
                      , perid
                ";

            sql += @"
                    from
                      (
                        select
                          rownum seq
                          , csldate
                          , dayid
                          , webcolor
                          , csname
                          , lastname
                          , firstname
                          , lastkname
                          , firstkname
                          , orgname
                          , orgsname
                          , timefra
                          , cntlno
                          , gender
                          , birth
                          , age
                          , rsvdate
                          , rsvno
                          , perid
                        from
                          (
                            select
                              to_char(cs.csldate, 'YYYY/MM/DD') csldate
                              , to_char(rs.dayid, '0999') dayid
                              , cp.webcolor
                              , cp.csname
                              , ps.lastname
                              , ps.firstname
                              , ps.lastkname
                              , ps.firstkname
                              , og.orgname
                              , og.orgsname
                              , cs.timefra
                              , to_char(rs.cntlno, '0999') cntlno
                              , ps.gender
                              , to_char(ps.birth, 'YYYY/MM/DD') birth
                              , cs.age
                              , to_char(cs.rsvdate, 'YYYY/MM/DD') rsvdate
                              , cs.rsvno
                              , cs.perid
                            from
                              consult cs
                              , receipt rs
                              , course_p cp
                              , person ps
                              , org og
                ";

            sql += @"
                    where
                      cs.csldate between :strdate and :enddate
                      and cs.cancelflg = :cancelflg
                      and cs.rsvno = rs.rsvno(+)
                      and cs.csldate = rs.csldate(+)
                      and cs.cscd = cp.cscd(+)
                      and cs.perid = ps.perid(+)
                      and cs.orgcd1 = og.orgcd1(+)
                      and cs.orgcd2 = og.orgcd2(+)
                ";

            // 条件節を追加
            // 団体指定あり
            if (!string.IsNullOrEmpty(Convert.ToString(data["orgcd1"]).Trim()) || string.IsNullOrEmpty(Convert.ToString(data["orgcd2"]).Trim()))
            {
                sql += @"
                        and cs.orgcd1 = :orgcd1
                        and cs.orgcd2 = :orgcd2
                    ";
            }

            // 個人ＩＤ指定あり
            if (!string.IsNullOrEmpty(Convert.ToString(data["perid"]).Trim()))
            {
                sql += @"
                        and cs.perid = :perid
                    ";
            }

            // コースコード指定あり
            if (!string.IsNullOrEmpty(Convert.ToString(data["cscd"]).Trim()))
            {
                sql += @"
                        and cs.cscd = :cscd
                    ";
            }

            // ソート順を追加
            if (DSL_SORT_DEFAULT.Equals(Convert.ToInt32(data["sortkey"])))
            {
                // 基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））
                sql += @"
                        order by
                          cs.csldate
                          , rs.dayid
                          , cs.cscd
                          , og.orgkname
                          , ps.lastkname
                          , ps.firstkname
                    ";
            }

            sql += @"
                    ))
                ";

            // 開始位置から取得件数分を取得するための条件節を追加
            if (Util.IsNumber(Convert.ToString(data["getcount"])))
            {
                // 取得件数が「すべて」以外の場合
                sql += @"
                        where
                          seq between :seq_f and :seq_t
                    ";
            }

            List<dynamic> retList = connection.Query(sql, sqlParam).ToList();

            // 入金情報を取得する場合のSQLBuild
            if (data["incomeprice"] != null)
            {
                sqlIncomeStmt = @"
                                select
                                    consult_zaimu.rsvno incomersvno
                                    , sum(consult_zaimu.price) + sum(consult_zaimu.taxprice) incomeprice
                                from
                                    zaimu zaimu
                                    , consult_zaimu consult_zaimu
                                where
                                    consult_zaimu.rsvno = :rsvno
                                    and consult_zaimu.orgcd1 = 'XXXXX'
                                    and consult_zaimu.orgcd2 = 'XXXXX'
                                    and consult_zaimu.inzaimuseq is null
                                    and zaimu.zaimucd = consult_zaimu.zaimucd
                                    and (zaimu.zaimudiv = '2' or zaimu.zaimudiv = '3')
                                group by
                                    consult_zaimu.rsvno
                                ";
            }

            // 検索レコードが存在する場合
            foreach (var rc in retList)
            {
                // 受診日
                rc.CSLDATE = Convert.ToDateTime(rc.CSLDATE).ToString("yyyy年M月d日");

                // ストアドＣＡＬＬ（予約番号より、基本コース・オプション・契約外・消費税・合計の５つの金額を求める）
                sqlProcedure = @"
                                begin demandpackage.getpricefromrsvno(
                                  :rsvno
                                  , :courseprice
                                  , :optionprice
                                  , :otherprice
                                  , :taxprice
                                  , :totalprice
                                );
                                end;
                            ";

                using (var cmd = new OracleCommand())
                {
                    // キー値の設定
                    // Inputは名前と値のみ
                    cmd.Parameters.Add("rsvno", Convert.ToInt32(rc.RSVNO));

                    // Outputパラメータ
                    OracleParameter courseprice = cmd.Parameters.Add("courseprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter optionprice = cmd.Parameters.Add("optionprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter otherprice = cmd.Parameters.Add("otherprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter taxprice = cmd.Parameters.Add("taxprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter totalprice = cmd.Parameters.Add("totalprice", OracleDbType.Int32, ParameterDirection.Output);

                    ExecuteNonQuery(cmd, sqlProcedure);

                    rc.COURSEPRICE = string.Format("#,###", ((OracleDecimal)courseprice.Value).ToInt32());
                    rc.OPTIONPRICE = string.Format("#,###", ((OracleDecimal)optionprice.Value).ToInt32());
                    rc.OTHERPRICE = string.Format("#,###", ((OracleDecimal)otherprice.Value).ToInt32());
                    rc.TAXPRICE = string.Format("#,###", ((OracleDecimal)taxprice.Value).ToInt32());
                    rc.TOTALPRICE = string.Format("#,###", ((OracleDecimal)totalprice.Value).ToInt32());

                }

                // 時間枠名称
                rc.TIMEFRANAME = WebHains.SelectTimeFraName(Convert.ToInt32(rc.TIMEFRA));

                // 性別名称
                if (Convert.ToString(rc.GENDER) == Gender.Male.ToString())
                {
                    rc.GENDERNAME = "男";
                }
                else if (Convert.ToString(rc.GENDER) == Gender.Female.ToString())
                {
                    rc.GENDERNAME = "女";
                }
                else
                {
                    rc.GENDERNAME = Convert.ToString(rc.GENDER);
                }

                // Format予約日
                rc.FORMATRSVDATE = Convert.ToDateTime(rc.RSVDATE).ToString("yyyy年M月d日");

                // 入金情報を取得する場合
                if (data["incomeprice"] != null)
                {
                    dynamic current = connection.Query(sqlIncomeStmt, sqlParam).FirstOrDefault();

                    // 存在する場合は金額セット
                    if (current != null)
                    {
                        rc.INCOMEPRICE = string.Format("#,###", Convert.ToInt32(current.INCOMEPRICE));
                    }
                    else
                    {
                        rc.INCOMEPRICE = "";
                    }
                }
            }

            // 戻り値の設定
            return retList;
        }

        /// <summary>
        /// 消費税を計算する（１負担元あたりの消費税金額の端数処理）
        /// </summary>
        /// <param name="taxFraction">税端数区分</param>
        /// <param name="devideTax">１負担元あたりの消費税金額（端数処理前）</param>
        /// <returns>１負担元あたりの消費税金額（端数処理後）</returns>
        public int CompDevideTax(string taxFraction, double devideTax)
        {
            int retDevideTax = 0;  // １負担元あたりの消費税金額（端数処理後）

            // １負担元あたりの消費税金額を、税金端数区分の内容に従い計算
            switch (taxFraction)
            {
                case "1":
                    // 10円未満切捨て
                    retDevideTax = Convert.ToInt32(Math.Floor(devideTax / 10) * 10);
                    break;
                case "2":
                    // 10円未満四捨五入
                    if (devideTax >= 0)
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor((devideTax + 5) / 10) * 10);
                    }
                    else
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor((devideTax - 5) / 10) * 10);
                    }
                    break;
                case "3":
                    // 10円未満切上げ
                    if (devideTax >= 0)
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor((devideTax + 9) / 10) * 10);
                    }
                    else
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor((devideTax - 9) / 10) * 10);
                    }
                    break;
                case "4":
                    // 1円未満切捨て
                    retDevideTax = Convert.ToInt32(Math.Floor(devideTax));
                    break;
                case "5":
                    // 1円未満四捨五入
                    if (devideTax >= 0)
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor(devideTax + 0.5));
                    }
                    else
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor(devideTax - 0.5));
                    }
                    break;
                case "6":
                    // 1円未満切上げ
                    if (devideTax >= 0)
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor(devideTax + 0.9));
                    }
                    else
                    {
                        retDevideTax = Convert.ToInt32(Math.Floor(devideTax - 0.9));
                    }
                    break;
                default:
                    // 以外
                    retDevideTax = 0;
                    break;
            }

            // 戻り値の設定
            return retDevideTax;
        }

        /// <summary>
        /// 個人別請求情報を更新する（個人別請求金額修正）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="data">個人別請求情報
        /// seq        （配列）ＳＥＱ
        /// pricetype  （配列）タイプ（0:基本コース, 1:基本コースの削除項目, 2:オプション検査, 3:契約外追加グループ, 4:契約外追加項目）
        /// optcd      （配列）オプションコード
        /// grpcd      （配列）グループコード
        /// itemcd     （配列）検査項目コード
        /// editprice  （配列）調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
        /// edittax    （配列）税調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateDmdPerModify(int rsvNo, int ctrPtCd, JToken data)
        {
            string sql = "";  // SQLステートメント
            List<JToken> items = data.ToObject<List<JToken>>();

            // 検索条件が設定されていない場合はエラー
            if (rsvNo == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 配列を処理する
            foreach (var rec in items)
            {
                // タイプに従って更新を行う
                switch (Convert.ToInt32(rec["pricetype"]))
                {
                    case 0:
                        // （基本コース）の場合
                        // 追加オプション負担金を更新する
                        UpdateOptPrice(rsvNo, ctrPtCd, Convert.ToInt32(rec["seq"]), 0, Convert.ToString(rec["editprice"]), Convert.ToString(rec["edittax"]));

                        break;
                    case 2:
                        // （オプション検査）の場合
                        // 追加オプション負担金を更新する
                        UpdateOptPrice(rsvNo, ctrPtCd, Convert.ToInt32(rec["seq"]), Convert.ToInt32(rec["optcd"]), Convert.ToString(rec["editprice"]), "");

                        break;
                    case 3:
                        // （契約外追加グループ）の場合
                        // 追加グループ負担金を更新する
                        UpdateGrpPrice(rsvNo, ctrPtCd, Convert.ToInt32(rec["seq"]), Convert.ToString(rec["grpcd"]), Convert.ToString(rec["editPrice"]));

                        break;
                    case 4:
                        // （契約外追加項目）の場合
                        // 追加検査項目負担金を更新する
                        UpdateItemPrice(rsvNo, ctrPtCd, Convert.ToInt32(rec["seq"]), Convert.ToString(rec["itemcd"]), Convert.ToString(rec["editprice"]));

                        break;
                }
            }

            // 受診金額確定ストアド呼び出し
            sql = @"
                    begin :ret := demandpackage.decideconsultprice(:rsvno);
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // キー値の設定
                // Inputは名前と値のみ
                cmd.Parameters.Add("rsvno", rsvNo);
                // Outputパラメータ
                cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                ExecuteNonQuery(cmd, sql);
            }

            return true;
        }

        /// <summary>
        /// 追加オプション負担金を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="editPrice">調整金額（"":"0"と同義, "-9999999"～"9999999":金額）</param>
        /// <param name="editTax">税調整金額（"":"0"と同義, "-9999999"～"9999999":金額）</param>
        /// <returns>
        ///  true   正常終了
        ///  false  異常終了
        /// </returns>
        public bool UpdateOptPrice(int rsvNo, int ctrPtCd,
                                    int seq, int optCd,
                                    string editPrice, string editTax)
        {
            string sql = "";  // SQLステートメント

            // 引数が正しく設定されていない場合はエラー
            if (rsvNo == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // キー値の設定
                    var sqlParam = new Dictionary<string, object>();
                    sqlParam.Add("rsvno1", rsvNo);
                    sqlParam.Add("ctrptcd1", ctrPtCd);
                    sqlParam.Add("seq1", seq);
                    sqlParam.Add("optcd1", optCd);

                    // 該当キーの追加オプション負担金を削除
                    sql = @"
                            delete
                            from
                              optprice
                            where
                              rsvno = :rsvno1
                              and ctrptcd = :ctrptcd1
                              and seq = :seq1
                              and optcd = :optcd1
                        ";

                    connection.Execute(sql, sqlParam);

                    // キー値の設定
                    if (Util.IsNumber(editPrice.Trim()))
                    {
                        sqlParam.Add("editprice1", Convert.ToInt32(editPrice.Trim()));
                    }
                    else
                    {
                        sqlParam.Add("editprice1", 0);
                    }

                    if (Util.IsNumber(editTax.Trim()))
                    {
                        sqlParam.Add("edittax1", Convert.ToInt32(editTax.Trim()));
                    }
                    else
                    {
                        sqlParam.Add("edittax1", 0);
                    }

                    // 値が設定されている時のみ、追加オプション負担金を登録
                    if (Convert.ToInt32(sqlParam["editprice1"]) != 0
                        || (Convert.ToInt32(sqlParam["edittax1 "])) != 0)
                    {
                        sql = @"
                                insert
                                into optprice(rsvno, ctrptcd, seq, optcd, editprice, edittax)
                                values (
                                  :rsvno1
                                  , :ctrptcd1
                                  , :seq1
                                  , :optcd1
                                  , :editprice1
                                  , :edittax1
                                )
                            ";

                        connection.Execute(sql, sqlParam);
                    }

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    return true;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return false;
                }
            }
        }

        /// <summary>
        /// 追加グループ負担金を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="grpCd">ＳＥＱ</param>
        /// <param name="editPrice">調整金額（"":"0"と同義, "-9999999"～"9999999":金額）</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateGrpPrice(int rsvNo, int ctrPtCd, int seq, string grpCd, string editPrice)
        {
            string sql = "";  // SQLステートメント

            // 引数が正しく設定されていない場合はエラー
            if (rsvNo == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // キー値の設定
                    var sqlParam = new Dictionary<string, object>();
                    sqlParam.Add("rsvno2", rsvNo);
                    sqlParam.Add("ctrptcd2", ctrPtCd);
                    sqlParam.Add("seq2", seq);
                    sqlParam.Add("grpcd2", grpCd.Trim());

                    // 該当キーの追加グループ負担金を削除
                    sql = @"
                            delete
                            from
                              grpprice
                            where
                              rsvno = :rsvno2
                              and ctrptcd = :ctrptcd2
                              and seq = :seq2
                              and grpcd = :grpcd2
                        ";

                    connection.Execute(sql, sqlParam);

                    // キー値の設定
                    if (Util.IsNumber(editPrice.Trim()))
                    {
                        sqlParam.Add("editprice2", Convert.ToInt32(editPrice.Trim()));
                    }
                    else
                    {
                        sqlParam.Add("editprice2", 0);
                    }

                    // 値が設定されている時のみ、追加グループ負担金を登録
                    if (Convert.ToInt32(sqlParam["editprice2"]) != 0)
                    {
                        sql = @"
                                insert
                                into grpprice(rsvno, ctrptcd, seq, grpcd, editprice)
                                values (:rsvno2, :ctrptcd2, :seq2, :grpcd2, :editprice2)
                            ";

                        connection.Execute(sql, sqlParam);
                    }

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    return true;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return false;
                }
            }
        }

        /// <summary>
        /// 追加検査項目負担金を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">ＳＥＱ</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="editPrice">調整金額（"":"0"と同義, "-9999999"～"9999999":金額）</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateItemPrice(int rsvNo, int ctrPtCd, int seq, string itemCd, string editPrice)
        {
            string sql = "";  // SQLステートメント

            // 引数が正しく設定されていない場合はエラー
            if (rsvNo == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // キー値の設定
                    var sqlParam = new Dictionary<string, object>();
                    sqlParam.Add("rsvno3", rsvNo);
                    sqlParam.Add("ctrptcd3", ctrPtCd);
                    sqlParam.Add("seq3", seq);
                    sqlParam.Add("itemcd3", itemCd.Trim());

                    // 該当キーの追加検査項目負担金を削除
                    sql = @"
                            delete
                            from
                              itemprice
                            where
                              rsvno = :rsvno3
                              and ctrptcd = :ctrptcd3
                              and seq = :seq3
                              and itemcd = :itemcd3
                        ";

                    connection.Execute(sql, sqlParam);

                    // キー値の設定
                    if (Util.IsNumber(editPrice.Trim()))
                    {
                        sqlParam.Add("editprice3", Convert.ToInt32(editPrice.Trim()));
                    }
                    else
                    {
                        sqlParam.Add("editprice3", 0);
                    }

                    // 値が設定されている時のみ、追加検査項目負担金を登録
                    if (Convert.ToInt32(sqlParam["editprice3"]) != 0)
                    {
                        sql = @"
                                insert
                                into itemprice(rsvno, ctrptcd, seq, itemcd, editprice)
                                values (
                                  :rsvno3
                                  , :ctrptcd3
                                  , :seq3
                                  , :itemcd3
                                  , :editprice3
                                )
                            ";

                        connection.Execute(sql, sqlParam);
                    }

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    return true;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return false;
                }
            }
        }

        /// <summary>
        /// 入金情報検索条件の妥当性チェックを行う
        /// </summary>
        /// <param name="strYear">開始締め日(年)</param>
        /// <param name="strMonth">開始締め日(月)</param>
        /// <param name="strDay">開始締め日(日)</param>
        /// <param name="strDate">開始締め日</param>
        /// <param name="endYear">終了締め日(年)</param>
        /// <param name="endMonth">終了締め日(月)</param>
        /// <param name="endDay">終了締め日(日)</param>
        /// <param name="endDate">終了締め日</param>
        /// <param name="billNo">請求書番号</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValueDmdPaymentSearch(int strYear, int strMonth,
                                                        int strDay, ref DateTime strDate,
                                                        int endYear, int endMonth,
                                                        int endDay, ref DateTime endDate, string billNo)
        {
            int checkDay;                         // チェック用日
            DateTime? editStrDate = null;         // 編集用開始日
            DateTime? editEndDate = null;         // 編集用終了日
            DateTime editDate;                    // 編集用締め日
            var arrMessage = new List<string>();  // エラーメッセージの集合

            while (true)
            {
                // 開始終了とも未入力はエラー
                if (strYear == 0 && strMonth == 0 && strDay == 0 && endYear == 0 && endMonth == 0 && endDay == 0)
                {
                    arrMessage.Add("締め日を指定してください。");
                    break;
                }

                // どちらかの日付が空の場合、残る片方の日付で妥当性チェック
                if (strYear == 0 && strMonth == 0 && strDay == 0 && endYear != 0 && endMonth != 0)
                {
                    strYear = endYear;
                    strMonth = endMonth;
                    if (endDay != 0)
                    {
                        strDay = endDay;
                    }
                }

                if (endYear == 0 && endMonth == 0 && endDay == 0 && strYear != 0 && strMonth != 0)
                {
                    endYear = strYear;
                    endMonth = strMonth;
                    if (strDay != 0)
                    {
                        endDay = strDay;
                    }
                }

                // 表示開始年月が入力されている場合
                if (strYear != 0 || strMonth != 0)
                {
                    // 日が未入力の場合、日に１を規定値として設定
                    if (strDay == 0)
                    {
                        checkDay = 1;
                    }
                    else
                    {
                        checkDay = strDay;
                    }
                    // 日付チェック
                    if (WebHains.CheckDate("締め日（自）", Convert.ToString(strYear), Convert.ToString(strMonth), Convert.ToString(checkDay), out editStrDate, Check.Necessary) != null)
                    {
                        arrMessage.Add(WebHains.CheckDate("締め日（自）", Convert.ToString(strYear), Convert.ToString(strMonth), Convert.ToString(checkDay), out editStrDate, Check.Necessary));
                    }

                }

                // 表示終了年月が入力されている場合
                if (endYear != 0 || endMonth != 0)
                {
                    // 日が未入力の場合、日に１を規定値として設定
                    if (endDay == 0)
                    {
                        checkDay = 1;
                    }
                    else
                    {
                        checkDay = endDay;
                    }
                    // 日付チェック
                    if (WebHains.CheckDate("締め日（至）", Convert.ToString(endYear), Convert.ToString(endMonth), Convert.ToString(checkDay), out editEndDate, Check.Necessary) != null)
                    {
                        arrMessage.Add(WebHains.CheckDate("締め日（至）", Convert.ToString(endYear), Convert.ToString(endMonth), Convert.ToString(checkDay), out editEndDate, Check.Necessary));
                    }

                }

                // どちらかの日付が未入力の場合、残る片方の日付をセットする
                if (string.IsNullOrEmpty(Convert.ToString(editStrDate)) && !string.IsNullOrEmpty(Convert.ToString(editEndDate)))
                {
                    strDate = Convert.ToDateTime(editEndDate);
                    endDate = Convert.ToDateTime(editEndDate);
                    break;
                }
                if (string.IsNullOrEmpty(Convert.ToString(editEndDate)) && !string.IsNullOrEmpty(Convert.ToString(editStrDate)))
                {
                    strDate = Convert.ToDateTime(editStrDate);
                    endDate = Convert.ToDateTime(editStrDate);
                    break;
                }

                // 開始・終了日を日付型に変換
                strDate = Convert.ToDateTime(editStrDate);
                endDate = Convert.ToDateTime(editEndDate);

                if (strDate <= endDate)
                {
                    // 終了日が指定されていない場合は末日をセット
                    if (strDay == 0)
                    {
                        strDate = new DateTime(strDate.Year, strDate.Day, 1);
                    }
                    if (endDay == 0)
                    {
                        endDate = endDate.AddMonths(1); // 翌月
                        endDate = endDate.AddDays(-1);  // 翌月の前日＝当月末日
                    }
                }
                else
                {
                    // 開始日が指定されていない場合は末日をセット
                    if (strDay == 0)
                    {
                        strDate = strDate.AddMonths(1); // 翌月
                        strDate = strDate.AddDays(-1);  // 翌月の前日＝当月末日
                    }
                    if (endDay == 0)
                    {
                        if (strDay != 0)
                        {
                            endDate = new DateTime(strDate.Year, strDate.Month, 1);
                            endDate = endDate.AddMonths(1); // 翌月
                            endDate = endDate.AddDays(-1);  // 翌月の前日＝当月末日
                        }
                        else
                        {
                            endDate = new DateTime(endDate.Year, endDate.Month, 1);
                        }
                    }
                }

                // 開始・終了日入れ換え
                if (strDate > endDate)
                {
                    editDate = strDate;
                    strDate = endDate;
                    endDate = editDate;
                }

                break;
            }

            // 請求書番号
            if (!string.IsNullOrEmpty(billNo))
            {
                if (WebHains.CheckNumeric("請求書番号", billNo, LENGTH_BILLNO) != null)
                {
                    arrMessage.Add(WebHains.CheckNumeric("請求書番号", billNo, LENGTH_BILLNO));
                }

            }

            // 戻り値の編集
            return arrMessage;
        }

        /// <summary>
        /// 検索条件を満たす請求書情報の一覧を取得する
        /// </summary>
        /// <param name="mode">取得モード(NULL:通常取得、"CNT":検索条件での請求書数を数える）</param>
        /// <param name="data">検索条件
        /// instrdate       開始締め日
        /// inenddate       終了締め日
        /// inbillno        請求書コード
        /// inburdenorgcd1  負担元団体コード１
        /// inburdenorgcd2  負担元団体コード２
        /// inbillclasscd   請求書分類コード
        /// inisprint       請求書出力状態（1:出力済みのみ、2:未出力のみ）
        /// startpos         SELECT開始位置
        /// getcount         取得件数
        /// </param>
        /// <returns>請求書情報
        /// billno          請求書番号
        /// closedate       締め日
        /// orgcd1          団体コード1
        /// orgcd2          団体コード2
        /// orgname         団体名
        /// billclasscd     請求書分類コード
        /// billclassname   請求書分類名
        /// total           請求額
        /// paymenttotal    入金合計
        /// seq             入金SEQ
        /// paymentdate     入金日
        /// paymentprice    入金額
        /// paymentdiv      入金区分
        /// upduser         更新者
        /// username        更新者名
        /// </returns>
        public List<dynamic> SelectDmdPaymentSearchList(string mode, JToken data)
        {
            string sql = "";                  // SQLステートメント
            bool isCloseDate = false;         // TRUE:締め日範囲が指定されている
            bool isBillNo = false;            // TRUE:請求書番号が指定されている
            bool isBurdenOrgCd = false;       // TRUE:団体が指定されている
            bool isBillClassCd = false;       // TRUE:請求書分類が指定されている
            bool isIsPrint = false;           // TRUE:請求書出力状態が指定されている
            bool isIsNoPrint = false;         // TRUE:請求書未出力状態が指定されている

            // 締め日範囲の妥当性チェック
            if (data["instrdate"] != null && data["inenddate"] != null)
            {
                data["instrdate"] = Convert.ToString(data["instrdate"]).Trim();
                data["inenddate"] = Convert.ToString(data["inenddate"]).Trim();

                if (DateTime.TryParse(Convert.ToString(data["instrdate"]).Trim(), out DateTime tmpStrDate)
                    && DateTime.TryParse(Convert.ToString(data["inenddate"]).Trim(), out DateTime tmpEndDate))
                {
                    isCloseDate = true;
                }
            }

            // 請求書番号の妥当性チェック
            if (data["inbillno"] != null)
            {
                data["inbillno"] = Convert.ToString(data["inbillno"]).Trim();
                if (Util.IsNumber(Convert.ToString(data["inbillno"])))
                {
                    if (Convert.ToInt32(data["inbillno"]) > 0)
                    {
                        isBillNo = true;
                    }
                }
            }

            // 締め日範囲も請求書番号も正しく指定されていない場合はエラー
            if (isCloseDate == false && isBillNo == false)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sqlParam.Add("billno", Convert.ToInt32(data["inbillno"]));
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate && !isBillNo)
            {
                sqlParam.Add("strdate", Convert.ToDateTime(data["instrdate"]));
                sqlParam.Add("enddate", Convert.ToDateTime(data["inenddate"]));
            }

            // 負担元が設定されている
            if (data["inburdenorgcd1"] != null && data["inburdenorgcd2"] != null)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(data["inburdenorgcd1"]).Trim())
                     && !string.IsNullOrEmpty(Convert.ToString(data["inburdenorgcd2"]).Trim()))
                {
                    sqlParam.Add("burdenorgcd1", Convert.ToString(data["inburdenorgcd1"]).Trim());
                    sqlParam.Add("burdenorgcd2", Convert.ToString(data["inburdenorgcd2"]).Trim());
                    isBurdenOrgCd = true;
                }
            }

            // 請求書分類コードが設定されている。
            if (data["inbillclasscd"] != null)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(data["inbillclasscd"]).Trim()))
                {
                    sqlParam.Add("billclasscd", Convert.ToString(data["inbillclasscd"]).Trim());
                    isBillClassCd = true;
                }
            }

            // 請求書出力状態が設定されている。
            if (data["inisprint"] != null)
            {
                if ("1".Equals(Convert.ToString(data["inisprint"]).Trim()))
                {
                    isIsPrint = true;
                }
                if ("2".Equals(Convert.ToString(data["inisprint"]).Trim()))
                {
                    isIsNoPrint = true;
                }
            }

            // 取得件数と開始位置が設定されている場合
            if (Util.IsNumber(Convert.ToString(data["startpos"]))
                && Util.IsNumber(Convert.ToString(data["getcount"])))
            {
                sqlParam.Add("seq_f", Convert.ToInt32(data["startpos"]));
                sqlParam.Add("seq_t", (Convert.ToInt32(data["startpos"]) + Convert.ToInt32(data["getcount"]) - 1));
            }

            // 検索条件を満たす請求入金情報のレコードを取得
            sql = @"
                    select
                      basebill.billno billno
                      , basebill.rowseq rowseq
                      , basebill.closedate closedate
                      , basebill.burdenorgcd1 orgcd1
                      , basebill.burdenorgcd2 orgcd2
                      , basebill.burdenorgname orgname
                      , basebill.billclasscd billclasscd
                      , basebill.billclassname billclassname
                      , payment.seq seq
                      , payment.paymentdate paymentdate
                      , payment.paymentprice paymentprice
                      , payment.paymentdiv paymentdiv
                      , payment.upduser upduser
                      , hainsuser.username username
                      , nvl(billdetailsum.total, 0) total
                      , nvl(paymenttotal.paymenttotalprice, 0) paymenttotal
                      , nvl(billdetailsum.subtotal, 0) subtotal
                      , nvl(billdetailsum.tax, 0) tax
                    from
                      hainsuser
                      , payment
                ";

            // 入金合計金額計算用内部View
            sql += @"
                    ,(
                      select
                        bill.billno
                        , sum(payment.paymentprice) paymenttotalprice
                      from
                        payment
                        , bill
                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          bill.billno = :billno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate && !isBillNo)
            {
                sql += @"
                        where
                          bill.closedate between :strdate and :enddate
                    ";
            }

            // 負担元が設定されている
            if (isBurdenOrgCd)
            {
                sql += @"
                        and bill.orgcd1 = :burdenorgcd1
                        and bill.orgcd2 = :burdenorgcd2
                    ";
            }

            // 請求書分類コードが設定されている。
            if (isBillClassCd)
            {
                sql += @"
                        and bill.billclasscd = :billclasscd
                    ";
            }

            // 請求書出力状態が設定されている。
            if (isIsPrint)
            {
                sql += @"
                        and bill.prtdate is not null
                    ";
            }

            // 請求書未出力状態が設定されている。
            if (isIsNoPrint)
            {
                sql += @"
                        and bill.prtdate is null
                    ";
            }

            //
            sql += @"
                    and bill.billno = payment.billno
                    group by
                      bill.billno) paymenttotal
                ";

            // 小計、税額も計算
            sql += @"
                    ,(
                      select
                        billdetail.billno
                        , sum(billdetail.subtotal) subtotal
                        , sum(billdetail.tax) tax
                        , sum(billdetail.total) total
                      from
                        billdetail
                        , bill
                    ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          bill.billno = :billno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate && !isBillNo)
            {
                sql += @"
                        where
                          bill.closedate between :strdate and :enddate
                    ";
            }

            // 負担元が設定されている
            if (isBurdenOrgCd)
            {
                sql += @"
                        and bill.orgcd1 = :burdenorgcd1
                        and bill.orgcd2 = :burdenorgcd2
                    ";
            }

            // 請求書分類コードが設定されている。
            if (isBillClassCd)
            {
                sql += @"
                        and bill.billclasscd = :billclasscd
                    ";
            }

            // 請求書出力状態が設定されている。
            if (isIsPrint)
            {
                sql += @"
                        and bill.prtdate is not null
                    ";
            }

            // 請求書未出力状態が設定されている。
            if (isIsNoPrint)
            {
                sql += @"
                        and bill.prtdate is null
                    ";
            }

            sql += @"
                    and billdetail.billno = bill.billno
                    group by
                      billdetail.billno) billdetailsum
                ";

            sql += @"
                    , (
                      select
                        rownum rowseq
                        , basebillbeforesort.billno
                        , basebillbeforesort.closedate
                        , basebillbeforesort.burdenorgcd1
                        , basebillbeforesort.burdenorgcd2
                        , basebillbeforesort.burdenorgname
                        , basebillbeforesort.billclasscd
                        , basebillbeforesort.billclassname
                        , basebillbeforesort.method
                        , basebillbeforesort.prtdate
                      from
                ";

            sql += @"
                    (
                      select
                        bill.billno billno
                        , bill.closedate closedate
                        , bill.orgcd1 burdenorgcd1
                        , bill.orgcd2 burdenorgcd2
                        , org.orgsname burdenorgname
                        , bill.billclasscd billclasscd
                        , billclass.billclassname billclassname
                        , bill.method method
                        , bill.prtdate prtdate
                      from
                        billclass
                        , org
                        , bill
                ";
            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          bill.billno = :billno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate && !isBillNo)
            {
                sql += @"
                        where
                          bill.closedate between :strdate and :enddate
                    ";
            }

            // 負担元が設定されている
            if (isBurdenOrgCd)
            {
                sql += @"
                        and bill.orgcd1 = :burdenorgcd1
                        and bill.orgcd2 = :burdenorgcd2
                    ";
            }

            // 請求書分類コードが設定されている。
            if (isBillClassCd)
            {
                sql += @"
                        and bill.billclasscd = :billclasscd
                    ";
            }

            // 請求書出力状態が設定されている。
            if (isIsPrint)
            {
                sql += @"
                        and bill.prtdate is not null
                    ";
            }

            // 請求書未出力状態が設定されている。
            if (isIsNoPrint)
            {
                sql += @"
                        and bill.prtdate is null
                    ";
            }

            sql += @"
                    and org.orgcd1 = bill.orgcd1
                    and org.orgcd2 = bill.orgcd2
                    and billclass.billclasscd = bill.billclasscd
                    order by
                        bill.closedate
                        , bill.orgcd1
                        , bill.orgcd2
                        , bill.billclasscd) basebillbeforesort
                ";


            sql += @"
                    ) basebill
                ";

            sql += @"
                    where
                      basebill.billno = billdetailsum.billno(+)
                      and basebill.billno = payment.billno(+)
                      and payment.upduser = hainsuser.userid(+)
                      and basebill.billno = paymenttotal.billno(+)
                ";

            // 取得件数と開始位置が設定されている場合
            if (data["getcount"] != null)
            {
                if (Util.IsNumber(Convert.ToString(data["getcount"])))
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(data["getcount"]).Trim()))
                    {
                        sql += @"
                                and basebill.rowseq between :seq_f and :seq_t
                            ";
                    }
                }
            }

            // 締め日を先頭に
            sql += @"
                    order by
                      basebill.closedate
                      , basebill.billno
                      , payment.seq
                    ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 検索条件を満たす請求書情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <returns>請求書情報
        /// closedate   締め日
        /// delflg      請求書削除フラグ
        /// orgname     団体名
        /// total       請求額
        /// notpayment  未収金
        /// </returns>
        public dynamic SelectDmdPaymentBillSum(string billNo)
        {
            string sql = "";  // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);

            // 検索条件を満たす受診者情報のレコードを取得
            sql = @"
                    select
                      bill.closedate closedate
                      , bill.billseq billseq
                      , bill.branchno branchno
                      , bill.delflg delflg
                      , org.orgname orgname
                      , org.orgkname orgkname
                      , nvl(totalbase.total, 0) + nvl(totalbase_items.total, 0) total
                      , nvl(paymentbase.paymentprice, 0) paymentprice
                      , nvl(totalbase.total, 0) + nvl(totalbase_items.total, 0) - nvl(paymentbase.paymentprice, 0) notpayment
                ";

            sql += @"
                    from
                      (
                        select
                          closedate
                          , billseq
                          , branchno
                          , sum(price + editprice + taxprice + edittax) total
                        from
                          billdetail
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                        group by
                          closedate
                          , billseq
                          , branchno
                      ) totalbase
                ";

            sql += @"
                    ,(
                      select
                        closedate
                        , billseq
                        , branchno
                        , sum(paymentprice) paymentprice
                      from
                        payment
                      where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                      group by
                        closedate
                        , billseq
                        , branchno
                    ) paymentbase
                    , org
                    , bill
                ";

            sql += @"
                    , (
                      select
                        closedate
                        , billseq
                        , branchno
                        , sum(price + editprice + taxprice + edittax) total
                      from
                        billdetail_items
                      where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                      group by
                        closedate
                        , billseq
                        , branchno
                    ) totalbase_items
                ";

            sql += @"
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and org.orgcd1 = bill.orgcd1
                      and org.orgcd2 = bill.orgcd2
                      and bill.closedate = totalbase.closedate(+)
                      and bill.billseq = totalbase.billseq(+)
                      and bill.branchno = totalbase.branchno(+)
                      and bill.closedate = paymentbase.closedate(+)
                      and bill.billseq = paymentbase.billseq(+)
                      and bill.branchno = paymentbase.branchno(+)
                ";

            sql += @"
                    and bill.closedate = totalbase_items.closedate(+)
                    and bill.billseq = totalbase_items.billseq(+)
                    and bill.branchno = totalbase_items.branchno(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 入金情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">入金Seq</param>
        /// <returns>
        /// paymentprice  入金額
        /// dueprice      未収金
        /// </returns>
        public dynamic GetDmdPaymentPrice(string billNo, int seq)
        {
            string sql = "";  // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 検索条件が設定されていない場合はエラー
            if (billSeq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);

            sql = @"
                    select
                      bill.closedate closedate
                      , bill.billseq billseq
                      , bill.branchno branchno
                      , nvl(payment.paymentprice, 0) paymentprice
                      , nvl(totalbase.total, 0) - nvl(paymentbase.payment, 0) dueprice
                    from
                      (
                        select
                          closedate
                          , billseq
                          , sum(price + editprice + taxprice + edittax) total
                        from
                          billdetail
                        where
                          closedate = :closedate
                          and billseq = :billseq
                        group by
                          closedate
                          , billseq
                      ) totalbase
                      , (
                        select
                          closedate
                          , billseq
                          , sum(paymentprice) payment
                        from
                          payment
                        where
                          closedate = :closedate
                          and billseq = :billseq
                        group by
                          closedate
                          , billseq
                      ) paymentbase
                      , (
                        select
                          closedate
                          , billseq
                          , branchno
                          , seq
                          , paymentprice
                        from
                          payment
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                          and seq = :seq
                      ) payment
                      , bill
                ";

            sql += @"
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and bill.closedate = payment.closedate(+)
                      and bill.billseq = payment.billseq(+)
                      and bill.branchno = payment.branchno(+)
                      and bill.closedate = totalbase.closedate(+)
                      and bill.billseq = totalbase.billseq(+)
                      and bill.closedate = paymentbase.closedate(+)
                      and bill.billseq = paymentbase.billseq(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす請求書情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">SEQ</param>
        /// <returns>請求書情報
        /// paymentdate  入金日
        /// paymentprice 入金額
        /// paymentdiv   入金種別
        /// upduser      更新者
        /// username     更新者名
        /// paynote      入金コメント
        /// cardkind     カード種別
        /// creditslipno 伝票No.
        /// bankcode     金融機関
        /// cardname     カード種別名
        /// bankname     金融機関名
        /// registerno   レジ番号
        /// cash         現金
        /// </returns>
        public dynamic SelectPayment(string billNo, int seq)
        {
            string sql = "";  // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);

            // 検索条件を満たす入金情報のレコードを取得
            sql = @"
                    select
                      pm.paymentdate
                      , pm.paymentprice
                      , pm.paymentdiv
                      , pm.upduser
                      , hu.username
                      , pm.paynote
                      , pm.cardkind
                      , pm.creditslipno
                      , pm.bankcode
                      , pm.registerno
                      , pm.cash
                      , card.cardname
                      , bank.bankname
                    from
                      payment pm
                      , hainsuser hu
                      , (select freecd, freefield1 cardname from free) card
                      , (select freecd, freefield1 bankname from free) bank
                    where
                      pm.closedate = :closedate
                      and pm.billseq = :billseq
                      and pm.branchno = :branchno
                      and pm.seq = :seq
                      and pm.upduser = hu.userid
                      and pm.cardkind = card.freecd(+)
                      and pm.bankcode = bank.freecd(+)
                ";

            // キー値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 発送情報を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">SEQ</param>
        /// <param name="data">発送情報
        /// paymentdate   発送日
        /// maxseq        1:MAX(SEQ)のレコードを更新する
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateDispatch(string billNo, int seq, JToken data)
        {
            string sql = "";   // SQLステートメント
            bool ret = false;  // 関数戻り値

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 検索条件が設定されていない場合はエラー
            if (seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);
            sqlParam.Add("dispatchdate", Convert.ToDateTime(data["dispatchdate"]));
            sqlParam.Add("upduser", Convert.ToString(data["upduser"]));

            // 該当キーの入金情報を更新
            sql = @"
                    update dispatch
                    set
                        dispatchdate = :dispatchdate
                        , upddate = sysdate
                        , upduser = :upduser
                    where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                ";

            if (data["maxseq"] != null)
            {
                sql += @"
                        and seq = (
                            select
                            max(seq)
                            from
                            dispatch
                            where
                            closedate = :closedate
                            and billseq = :billseq
                            and branchno = :branchno
                        )
                    ";
            }
            else
            {
                sql += @"
                        and seq = :seq
                    ";
            }

            connection.Execute(sql, sqlParam);

            // 戻り値の設定
            ret = true;
            return ret;
        }

        /// <summary>
        /// 入金情報検索条件の妥当性チェックを行う
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <param name="seq">入金SEQ</param>
        /// <param name="paymentYear">入金日（年）</param>
        /// <param name="paymentMonth">入金日（月）</param>
        /// <param name="paymentDay">入金日</param>
        /// <param name="refPaymentDate">(Out)</param>
        /// <param name="paymentPrice">入金額</param>
        /// <param name="paymentDiv">入金種別</param>
        /// <param name="payNote">コメント</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValuePayment(DateTime closeDate, int billSeq,
                                        int branchNo, string seq,
                                        int paymentYear, int paymentMonth,
                                        int paymentDay, ref DateTime refPaymentDate,
                                        string paymentPrice, string paymentDiv, string payNote)
        {
            DateTime? paymentDate = null;       // 編集用入金日
            string priceMessage = "";           // 入金額メッセージ
            var messages = new List<string>();  // エラーメッセージの集合

            if (WebHains.CheckDate("入金日", Convert.ToString(paymentYear),
                                            Convert.ToString(paymentMonth), Convert.ToString(paymentDay),
                                            out paymentDate, Check.Necessary) != null)
            {
                // 入金日チェック
                messages.Add(WebHains.CheckDate("入金日", Convert.ToString(paymentYear),
                                                Convert.ToString(paymentMonth), Convert.ToString(paymentDay),
                                                out paymentDate, Check.Necessary));
            }

            if (DateTime.TryParse(Convert.ToString(paymentDate), out DateTime tmpDate))
            {
                // 締め日関連チェック
                if (Convert.ToDateTime(paymentDate) < closeDate)
                {
                    messages.Add("入金日は締め日以降の日付を入力してください");
                }
                refPaymentDate = Convert.ToDateTime(paymentDate);
            }

            // 入金額チェック
            priceMessage = WebHains.CheckNumericWithSign("入金額", Convert.ToString(paymentPrice), LENGTH_PAYMENTPRICE, Check.Necessary);

            if (priceMessage != null)
            {

                messages.Add(priceMessage);

            }

            if (string.IsNullOrEmpty(priceMessage))
            {
                if (CheckValuePaymentPrice(closeDate, billSeq, branchNo, seq, paymentPrice) != null)
                {

                    // 未収金関連チェック
                    messages.Add(CheckValuePaymentPrice(closeDate, billSeq, branchNo, seq, paymentPrice));

                }
            }

            // 入金種別チェック
            if (string.IsNullOrEmpty(paymentDiv))
            {
                messages.Add("入金種別を指定してください");
            }

            // コメントチェック
            if (!string.IsNullOrEmpty(payNote))
            {
                if (WebHains.CheckWideValue("入金コメント", payNote, LENGTH_PAYNOTE) != null)
                {

                    // 未収金関連チェック
                    messages.Add(WebHains.CheckWideValue("入金コメント", payNote, LENGTH_PAYNOTE));

                }
            }

            // 戻り値の編集
            return messages;
        }

        /// <summary>
        /// 入金額の合計が請求額を超えていないかチェックする
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <param name="billSeq">請求書SEQ</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <param name="seq">SEQ</param>
        /// <param name="paymentPrice">(Out)入金額</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        private string CheckValuePaymentPrice(DateTime closeDate, int billSeq,
                                              int branchNo, string seq, string paymentPrice)
        {
            string sql = "";       // SQLステートメント
            string messages = null;  // エラーメッセージの集合

            // 検索条件が設定されていない場合はエラー
            if (billSeq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);

            if (!string.IsNullOrEmpty(seq))
            {
                sqlParam.Add("seq", Convert.ToInt32(seq));
            }

            // 検索条件を満たす入金情報のレコードを取得
            sql = @"
                    select
                      bill.delflg
                      , nvl(totalbase.total, 0) + nvl(totalbase_items.total, 0) - nvl(paymentbase.paymentprice, 0) notpayment
                    from
                      bill
                      , (
                        select
                          closedate
                          , billseq
                          , branchno
                          , sum(price + editprice + taxprice + edittax) total
                        from
                          billdetail
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                        group by
                          closedate
                          , billseq
                          , branchno
                      ) totalbase
                      , (
                        select
                          closedate
                          , billseq
                          , branchno
                          , sum(paymentprice) paymentprice
                        from
                          payment
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                ";

            // 今回修正分の入金情報を除く
            if (!string.IsNullOrEmpty(seq))
            {
                sql += @"
                        and seq != :seq
                    ";
            }

            sql += @"
                    group by
                      closedate
                      , billseq
                      , branchno) paymentbase
                      , (
                        select
                          closedate
                          , billseq
                          , branchno
                          , sum(price + editprice + taxprice + edittax) total
                        from
                          billdetail_items
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                        group by
                          closedate
                          , billseq
                          , branchno
                      ) totalbase_items
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and bill.closedate = totalbase.closedate(+)
                      and bill.billseq = totalbase.billseq(+)
                      and bill.branchno = totalbase.branchno(+)
                      and bill.closedate = paymentbase.closedate(+)
                      and bill.billseq = paymentbase.billseq(+)
                      and bill.branchno = paymentbase.branchno(+)
                      and bill.closedate = totalbase_items.closedate(+)
                      and bill.billseq = totalbase_items.billseq(+)
                      and bill.branchno = totalbase_items.branchno(+)
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                // 入金額のチェック
                // 返金額の場合もある
                if (branchNo != 0 && Convert.ToInt32(current.DELFLG) == 1)
                {
                    // 取消伝票の返金用伝票
                    if ((Convert.ToInt32(paymentPrice) < Convert.ToInt32(current.NOTPAYMENT))
                        || Convert.ToInt32(paymentPrice) >= 0)
                    {
                        messages = "入金額は未収金額以上0円未満を入力してください";
                    }
                }
                else if (Convert.ToInt32(current.DELFLG) != 1)
                {
                    // 通常伝票
                    if ((Convert.ToInt32(paymentPrice) > Convert.ToInt32(current.NOTPAYMENT))
                        || Convert.ToInt32(paymentPrice) <= 0)
                    {
                        messages = "入金額は0円超で未収金額以下を入力してください";
                    }
                }
            }
            else
            {
                messages = "請求書情報が見つかりません。";
            }

            return messages;
        }

        /// <summary>
        /// 発送日設定情報の妥当性チェックを行う
        /// </summary>
        /// <param name="sendYear">発送日(年)</param>
        /// <param name="sendMonth">発送日(月)</param>
        /// <param name="sendDay">発送日(日)</param>
        /// <param name="sendDate">(Out)発送日</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValueSendCheckDay(int sendYear, int sendMonth, int sendDay, ref DateTime? sendDate)
        {
            List<string> messages = new List<string>();  // エラーメッセージの集合

            // 発送日チェック
            messages.Add(WebHains.CheckDate("発送日", Convert.ToString(sendYear), Convert.ToString(sendMonth), Convert.ToString(sendDay), out sendDate, Check.Necessary));

            return messages;
        }

        /// <summary>
        /// 発送情報を削除する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">発送SEQ</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteDispatch(string billNo, int seq)
        {
            string sql = "";   // SQLステートメント
            bool ret = false;  // 関数戻り値

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 検索条件が設定されていない場合はエラー
            if (seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);

            // 該当キーの発送情報を削除
            sql = @"
                    delete
                    from
                        dispatch
                    where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                        and seq = :seq
                ";

            connection.Execute(sql, sqlParam);

            // 戻り値の設定
            ret = true;
            return ret;

        }

        /// <summary>
        /// 入金情報を挿入する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="data">入金情報
        /// paymentdate   入金日
        /// paymentprice  入金額
        /// paymentdiv    入金種別
        /// upduser       更新者
        /// paynote       コメント
        /// cardkind      カード種別
        /// creditslipno  伝票No.
        /// bankcode      金融機関
        /// registerno    レジ番号
        /// cash          現金
        /// </param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        public Insert InsertPayment(string billNo, InsertPayment data)
        {
            string sql = "";   // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            try
            {
                // キー値の設定
                var sqlParam = new Dictionary<string, object>();
                sqlParam.Add("closedate", closeDate);
                sqlParam.Add("billseq", billSeq);
                sqlParam.Add("branchno", branchNo);
                sqlParam.Add("paymentdate", Convert.ToDateTime(data.PaymentDate));
                sqlParam.Add("paymentprice", Convert.ToInt32(data.PaymentPrice));
                sqlParam.Add("paymentdiv", Convert.ToInt32(data.PaymentDiv));
                sqlParam.Add("upduser", Convert.ToString(data.Upduser));
                sqlParam.Add("paynote", Convert.ToString(data.PayNote));
                sqlParam.Add("cardkind", Convert.ToString(data.CardKind));
                sqlParam.Add("creditslipno", Convert.ToString(data.Creditslipno));
                sqlParam.Add("bankcode", Convert.ToString(data.BankCode));
                sqlParam.Add("registerno", Convert.ToString(data.Registerno));
                sqlParam.Add("cash", Convert.ToString(data.Cash));

                // 該当キーの入金情報を挿入
                sql = @"
                        insert
                        into payment(
                            closedate
                            , billseq
                            , branchno
                            , seq
                            , paymentdate
                            , paymentprice
                            , paymentdiv
                            , upduser
                            , paynote
                            , cardkind
                            , creditslipno
                            , bankcode
                            , registerno
                            , cash
                    ";

                sql += @"
                        )
                        values (
                            :closedate
                            , :billseq
                            , :branchno
                            , 1
                            , :paymentdate
                            , :paymentprice
                            , :paymentdiv
                            , :upduser
                            , :paynote
                            , :cardkind
                            , :creditslipno
                            , :bankcode
                            , :registerno
                            , :cash
                        )
                    ";

                connection.Execute(sql, sqlParam);

                // 戻り値の設定
                return Insert.Normal;
            }
            catch (Exception ex)
            {
                // キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex is OracleException && ((OracleException)ex).Number == 1)
                {
                    return Insert.Duplicate;
                }

                return Insert.Error;
            }
        }

        /// <summary>
        /// 検索条件を満たす発送情報を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">SEQ</param>
        /// <returns>入金日</returns>
        public string SelectDispatch(string billNo, int seq)
        {
            string sql = "";  // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 検索条件が設定されていない場合はエラー
            if (seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);

            // 検索条件を満たす入金情報のレコードを取得
            sql = @"
                    select
                      dispatchdate
                    from
                      dispatch
                    where
                      closedate = :closedate
                      and billseq = :billseq
                      and branchno = :branchno
                      and seq = :seq
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                // 戻り値の設定
                return Convert.ToString(current.DISPATCHDATE);
            }
            else
            {
                return "";
            }
        }

        /// <summary>
        /// 入金情報を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="seq">SEQ</param>
        /// <param name="data">入金情報
        /// paymentdate   入金日
        /// paymentprice  入金額
        /// paymentdiv    入金種別
        /// upduser       更新者
        /// paynote       入金コメント
        /// cardkind      カード種別
        /// creditslipno  伝票No.
        /// bankcode      金融機関
        /// registerno   レジ番号
        /// cash         現金
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdatePayment(string billNo, int seq, UpdatePayment data)
        {
            string sql = "";   // SQLステートメント
            bool ret = false;  // 関数戻り値

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 検索条件が設定されていない場合はエラー
            if (seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);
            sqlParam.Add("paymentdate", Convert.ToDateTime(data.PaymentDate));
            sqlParam.Add("paymentprice", Convert.ToInt32(data.PaymentPrice));
            sqlParam.Add("paymentdiv", Convert.ToInt32(data.PaymentDiv));
            sqlParam.Add("upduser", Convert.ToString(data.Upduser));
            sqlParam.Add("paynote", Convert.ToString(data.PayNote));
            sqlParam.Add("cardkind", Convert.ToString(data.CardKind));
            sqlParam.Add("creditslipno", Convert.ToString(data.Creditslipno));
            sqlParam.Add("bankcode", Convert.ToString(data.BankCode));
            sqlParam.Add("registerno", Convert.ToString(data.Registerno));
            sqlParam.Add("cash", Convert.ToString(data.Cash));

            // 該当キーの入金情報を更新
            sql = @"
                    update payment
                    set
                        paymentdate = :paymentdate
                        , paymentprice = :paymentprice
                        , paymentdiv = :paymentdiv
                        , upduser = :upduser
                        , paynote = :paynote
                        , cardkind = :cardkind
                        , creditslipno = :creditslipno
                        , bankcode = :bankcode
                        , registerno = :registerno
                        , cash = :cash
                    where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                        and seq = :seq
                ";

            connection.Execute(sql, sqlParam);

            // 戻り値の設定
            ret = true;
            return ret;
        }

        /// <summary>
        /// 入金情報を削除する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="seq">SEQ</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeletePayment(string billNo, int seq)
        {
            string sql = "";   // SQLステートメント
            bool ret = false;  // 関数戻り値

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 検索条件が設定されていない場合はエラー
            if (seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("seq", seq);

            // 該当キーの入金情報を削除
            sql = @"
                    delete
                    from
                        payment
                    where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                        and seq = :seq
                ";

            connection.Execute(sql, sqlParam);

            // 戻り値の設定
            ret = true;
            return ret;
        }

        /// <summary>
        /// 発送Seqの最大値を取得する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <returns>発送Seqの最大値
        /// seqmax  Max(発送Seq)
        /// delflg  削除フラグ
        /// </returns>
        public dynamic GetDispatchSeqMax(string billNo)
        {
            string sql = "";  // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);

            sql = @"
                    select
                      nvl(max(dispatch.seq), 0) maxseq
                      , bill.delflg
                    from
                      bill
                      , dispatch
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and bill.closedate = dispatch.closedate(+)
                      and bill.billseq = dispatch.billseq(+)
                      and bill.branchno = dispatch.branchno(+)
                    group by
                      bill.closedate
                      , bill.billseq
                      , bill.branchno
                      , bill.delflg
                ";

            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 発送情報を挿入する
        /// </summary>
        /// <param name="billNo">請求書No</param>
        /// <param name="data">発送情報
        /// dispatchdate  入金日
        /// upduser       更新者
        /// </param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        public Insert InsertDispatch(string billNo, JToken data)
        {
            string sql = "";  // SQLステートメント

            // 請求書Noの分解
            if (false == SplitBillNo(billNo, out DateTime? closeDate, out int billSeq, out int branchNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            try
            {
                // キー値の設定
                var sqlParam = new Dictionary<string, object>();
                sqlParam.Add("closedate", closeDate);
                sqlParam.Add("billseq", billSeq);
                sqlParam.Add("branchno", branchNo);
                sqlParam.Add("dispatchdate", Convert.ToDateTime(data["dispatchdate"]));
                sqlParam.Add("upduser", Convert.ToString(data["upduser"]));

                // 該当キーの入金情報を挿入
                sql = @"
                        insert
                        into dispatch(
                            closedate
                            , billseq
                            , branchno
                            , seq
                            , dispatchdate
                            , upddate
                            , upduser
                    ";

                sql += @"
                        )
                        values (
                            :closedate
                            , :billseq
                            , :branchno
                            , (
                            select
                                nvl(max(seq), 0) + 1
                            from
                                dispatch
                            where
                                closedate = :closedate
                                and billseq = :billseq
                                and branchno = :branchno
                            )
                            , :dispatchdate
                            , sysdate
                            , :upduser
                        )
                    ";

                connection.Execute(sql, sqlParam);

                // 戻り値の設定
                return Insert.Normal;
            }
            catch (OracleException ex)
            {
                // キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    return Insert.Duplicate;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 検索条件を満たす請求書情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <returns>請求書情報
        /// closedate      締め日
        /// orgcd1         団体コード１
        /// orgcd2         団体コード２
        /// orgname        団体名
        /// billclasscd    請求書分類コード
        /// billclassname  請求書分類名
        /// method         作成方法
        /// taxrates       適用税率
        /// prtdate        請求書出力日
        /// paymentflg     入金データ存在フラグ(True:あり、False:なし)
        /// orgdiv         団体種別
        /// </returns>
        public bool SelectDmdOrgMasterBurden(string billNo)
        {
            string sql = "";  // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(billNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("billno", billNo);

            // 検索条件を満たす請求情報のレコードを取得
            sql = @"
                    select
                      bill.closedate
                      , bill.orgcd1
                      , bill.orgcd2
                      , org.orgname
                      , bill.billclasscd
                      , billclass.billclassname
                      , bill.method
                      , bill.taxrates
                      , bill.prtdate
                      , paymentinfo.seqcount
                      , org.orgdiv
                    from
                      (
                        select
                          billno
                          , count(seq) seqcount
                        from
                          payment
                        where
                          billno = :billno
                        group by
                          billno
                      ) paymentinfo
                      , billclass
                      , org
                      , bill
                    where
                      bill.billno = :billno
                      and bill.orgcd1 = org.orgcd1
                      and bill.orgcd2 = org.orgcd2
                      and billclass.billclasscd = bill.billclasscd
                      and bill.billno = paymentinfo.billno(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 適用税率を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="nowTax">(Out)適用税率</param>
        /// <param name="errFlg">エラー時の扱い（0:エラーをもう一回引き起こす, 1:エラーメッセージを返す）</param>
        /// <returns>エラー時の扱い＝１の時、エラーメッセージを返す</returns>
        public string GetNowTax(string cslDate, ref double nowTax, int errFlg = 0)
        {
            string sql = "";  // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!DateTime.TryParse(cslDate.Trim(), out DateTime tmpDate))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("csldate", cslDate.Trim());

            // 適用税率を取得
            sql = @"
                    select
                        (
                        case
                            when :csldate < free.freedate
                            then free.freefield1
                            else free.freefield2
                            end
                        ) nowtax
                    from
                        free
                    where
                        free.freecd = 'TAX'
                        and rownum = 1
                ";

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                // 戻り値の設定
                nowTax = Convert.ToDouble(current.NOWTAX);
            }

            return "";
        }

        /// <summary>
        /// 請求書Ｎｏを発番する
        /// </summary>
        /// <param name="billNo">請求書Ｎｏ</param>
        /// <param name="errFlg">エラー時の扱い（0:エラーをもう一回引き起こす, 1:エラーメッセージを返す）</param>
        /// <returns>エラー時の扱い＝１の時、エラーメッセージを返す</returns>
        public string GetBillNo(ref int billNo, int errFlg = 0)
        {
            string sql = "";  // SQLステートメント

            try
            {
                sql = @"
                        select
                          (nvl(max(billno), 0) + 1) maxbillno
                        from
                          bill
                    ";

                // オブジェクトの参照設定
                billNo = Convert.ToInt32(connection.Query(sql).FirstOrDefault().MAXBILLNO);

                return "";
            }
            catch
            {
                // #ToDo エラー発生時を作成する方法をどうするか。本メソッド自体未使用である可能性があります。
                //    If lngErrFlg = 1 Then


                //        'エラーメッセージを返す
                //        GetBillNo = "Demand.GetBillNoにてエラー発生　(" & mobjOraDb.LastServerErr & ")　" & Err.Description


                //'        'エラー発生時はトランザクションをアボートに設定
                //'        mobjContext.SetAbort


                //    Else


                //        'イベントログ書き込み
                //        WriteErrorLog "Demand.GetBillNo"


                //        'エラー発生時はトランザクションをアボートに設定
                //        mobjContext.SetAbort


                //        'エラーをもう一回引き起こす
                //        Err.Raise Err.Number, Err.Source, Err.Description

                //    End If

                return "";
            }
        }

        /// <summary>
        /// 請求書Seqを発番する
        /// </summary>
        /// <param name="closeDate">締め日</param>
        /// <returns>請求書Seq</returns>
        private string GetBillSeq(DateTime closeDate)
        {
            string sql = "";  // SQLステートメント

            // パラメータが指定されていない場合はエラー
            if (string.IsNullOrEmpty(Convert.ToString(closeDate)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate);

            sql = @"
                    select
                      nvl(max(billseq) + 1, 1) as maxbillseq
                    from
                      bill
                    where
                      closedate = :closedate
                ";

            // オブジェクトの参照設定
            return Convert.ToString(connection.Query(sql, sqlParam).FirstOrDefault().MAXBILLSEQ);
        }

        /// <summary>
        /// 検索条件を満たす受診者情報の件数を取得する（請求対象受診者一覧）
        /// </summary>
        /// <param name="billNo">請求書Ｎｏ</param>
        /// <param name="cslOrgCd1">受診団体コード1</param>
        /// <param name="cslOrgCd2">受診団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int SelectDmdOrgListCount(string billNo, string cslOrgCd1, string cslOrgCd2, string csCd)
        {
            string sql = "";  // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (billNo == Convert.ToString(0))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("billno", billNo);
            sqlParam.Add("orgcd1", cslOrgCd1.Trim());
            sqlParam.Add("orgcd2", cslOrgCd2.Trim());
            sqlParam.Add("cscd", csCd.Trim());
            sqlParam.Add("cancelflg", Convert.ToInt32(ConsultCancel.Used));

            // 検索条件を満たす受診者情報のレコード件数を取得
            sql = @"
                    select
                      count(*) reccount
                    from
                      consult
                    where
                      rsvno in (
                        select distinct
                          rsvno
                        from
                          closemng
                        where
                          billno = :billno
                      )
                      and cancelflg = :cancelflg
                ";

            // 条件節を追加
            if (!string.IsNullOrEmpty(cslOrgCd1.Trim()) || !string.IsNullOrEmpty(cslOrgCd2.Trim()))
            {
                // 受診団体指定あり
                sql += @"
                        and orgcd1 = :orgcd1
                        and orgcd2 = :orgcd2
                    ";
            }

            if (!string.IsNullOrEmpty(csCd.Trim()))
            {
                // コースコード指定あり
                sql += @"
                        and cscd = :cscd
                    ";
            }

            dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            // (COUNT関数を発行しているので必ず1レコード返ってくる)
            if (current != null)
            {
                return Convert.ToInt32(current.RECCOUNT);
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する（請求対象受診者一覧）
        /// </summary>
        /// <param name="billNo">請求書Ｎｏ</param>
        /// <param name="cslOrgCd1">受診団体コード1</param>
        /// <param name="cslOrgCd2">受診団体コード2</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="sortKey">ソート順（0:基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ）））</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>受診者の一覧
        /// csldate      受診日（"yyyy年m月d日"編集）
        /// dayid        当日ID（"0001"編集）
        /// webcolor     コース名表示色
        /// csname       コース名
        /// lastname     姓
        /// firstname    名
        /// lastkname    カナ姓
        /// firstkname   カナ名
        /// orgname      団体名
        /// orgsname     団体略称
        /// courseprice  基本コース金額（"1,234"編集）
        /// optionprice  オプション金額（"1,234"編集）
        /// otherprice   契約外金額（"1,234"編集）
        /// taxprice     消費税金額（"1,234"編集）
        /// totalprice   合計金額（"1,234"編集）
        /// timefra      時間枠
        /// timefraname  時間枠名称
        /// cntlno       管理番号（"0001"編集）
        /// gendername   性別名称
        /// birth        生年月日（"yyyy/mm/dd"編集）
        /// age          年齢
        /// rsvdate      予約日（"yyyy年m月d日"編集）
        /// rsvno        予約番号
        /// perid        個人ＩＤ
        /// </returns>
        public List<dynamic> SelectDmdOrgList(string billNo, string cslOrgCd1,
                                    string cslOrgCd2, string csCd,
                                    int sortKey, int startPos, string getCount)
        {
            string sql = "";            // SQLステートメント
            string sqlProcedure = "";   // SQLストアド

            // 検索条件が設定されていない場合はエラー
            if (billNo == Convert.ToString(0))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("billno", billNo);
            sqlParam.Add("orgcd1", cslOrgCd1.Trim());
            sqlParam.Add("orgcd2", cslOrgCd2.Trim());
            sqlParam.Add("cscd", csCd.Trim());

            if (Util.IsNumber(getCount))
            { // 取得件数が「すべて」以外の場合
                sqlParam.Add("seq_f", startPos);
                sqlParam.Add("seq_t", (startPos + Convert.ToInt32(getCount) - 1));
            }

            sqlParam.Add("cancelflg", Convert.ToInt32(ConsultCancel.Used));
            sqlParam.Add("rsvno", 0);
            sqlParam.Add("courseprice", 0);
            sqlParam.Add("optionprice", 0);
            sqlParam.Add("otherprice", 0);
            sqlParam.Add("taxprice", 0);
            sqlParam.Add("totalprice", 0);

            // 検索条件を満たす受診者情報のレコードを取得
            sql = @"
                    select
                      csldate
                      , dayid
                      , webcolor
                      , csname
                      , lastname
                      , firstname
                      , lastkname
                      , firstkname
                      , orgname
                      , orgsname
                      , timefra
                      , cntlno
                      , gender
                      , birth
                      , age
                      , rsvdate
                      , rsvno
                      , perid
                    from
                      (
                        select
                          rownum seq
                          , csldate
                          , dayid
                          , webcolor
                          , csname
                          , lastname
                          , firstname
                          , lastkname
                          , firstkname
                          , orgname
                          , orgsname
                          , timefra
                          , cntlno
                          , gender
                          , birth
                          , age
                          , rsvdate
                          , rsvno
                          , perid
                        from
                          (
                            select
                              to_char(cs.csldate, 'YYYY/MM/DD') csldate
                              , to_char(rs.dayid, '0999') dayid
                              , cp.webcolor
                              , cp.csname
                              , ps.lastname
                              , ps.firstname
                              , ps.lastkname
                              , ps.firstkname
                              , og.orgname
                              , og.orgsname
                              , cs.timefra
                              , to_char(rs.cntlno, '0999') cntlno
                              , ps.gender
                              , to_char(ps.birth, 'YYYY/MM/DD') birth
                              , cs.age
                              , to_char(cs.rsvdate, 'YYYY/MM/DD') rsvdate
                              , cs.rsvno
                              , cs.perid
                            from
                              consult cs
                              , receipt rs
                              , course_p cp
                              , person ps
                              , org og
                ";

            sql += @"
                    where
                      cs.rsvno in (
                        select distinct
                          rsvno
                        from
                          closemng
                        where
                          billno = :billno
                      )
                      and cs.cancelflg = :cancelflg
                      and cs.rsvno = rs.rsvno(+)
                      and cs.csldate = rs.csldate(+)
                      and cs.cscd = cp.cscd(+)
                      and cs.perid = ps.perid(+)
                      and cs.orgcd1 = og.orgcd1(+)
                      and cs.orgcd2 = og.orgcd2(+)
                ";

            // 条件節を追加
            if (!string.IsNullOrEmpty(cslOrgCd1.Trim()) ||
                !string.IsNullOrEmpty(cslOrgCd2.Trim()))
            {
                // 受診団体指定あり
                sql += @"
                        and cs.orgcd1 = :orgcd1
                        and cs.orgcd2 = :orgcd2
                    ";
            }

            if (!string.IsNullOrEmpty(csCd.Trim()))
            {
                // コースコード指定あり
                sql += @"
                        and cs.cscd = :cscd
                    ";
            }

            // ソート順を追加
            if (sortKey == DOL_SORT_DEFAULT)
            {
                // 基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））
                sql += @"
                        order by
                          cs.csldate
                          , rs.dayid
                          , cs.cscd
                          , og.orgkname
                          , ps.lastkname
                          , ps.firstkname
                    ";
            }

            sql += @"
                    ))
                ";

            // 開始位置から取得件数分を取得するための条件節を追加
            if (Util.IsNumber(getCount))
            {
                // 取得件数が「すべて」以外の場合
                sql += @"
                        where
                          seq between :seq_f and :seq_t
                    ";
            }

            // 戻り値の設定
            List<dynamic> retList = connection.Query(sql, sqlParam).ToList();


            foreach (var rc in retList)
            {
                // 受診日
                rc["csldate"] = Convert.ToDateTime(rc["csldate"]).ToString("yyyy年M月d日");

                // ストアドＣＡＬＬ（予約番号より、基本コース・オプション・契約外・消費税・合計の５つの金額を求める）
                sqlProcedure = @"
                                begin demandpackage.getpricefromrsvno(
                                  :rsvno
                                  , :courseprice
                                  , :optionprice
                                  , :otherprice
                                  , :taxprice
                                  , :totalprice
                                );
                                end;
                             ";

                using (var cmd = new OracleCommand())
                {
                    // キー値の設定
                    // Inputは名前と値のみ
                    cmd.Parameters.Add("rsvno", Convert.ToInt32(rc.RSVNO));

                    // Outputパラメータ
                    OracleParameter courseprice = cmd.Parameters.Add("courseprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter optionprice = cmd.Parameters.Add("optionprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter otherprice = cmd.Parameters.Add("otherprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter taxprice = cmd.Parameters.Add("taxprice", OracleDbType.Int32, ParameterDirection.Output);
                    OracleParameter totalprice = cmd.Parameters.Add("totalprice", OracleDbType.Int32, ParameterDirection.Output);

                    ExecuteNonQuery(cmd, sqlProcedure);

                    rc.COURSEPRICE = string.Format("#,###", ((OracleDecimal)courseprice.Value).ToInt32());
                    rc.OPTIONPRICE = string.Format("#,###", ((OracleDecimal)optionprice.Value).ToInt32());
                    rc.OTHERPRICE = string.Format("#,###", ((OracleDecimal)otherprice.Value).ToInt32());
                    rc.TAXPRICE = string.Format("#,###", ((OracleDecimal)taxprice.Value).ToInt32());
                    rc.TOTALPRICE = string.Format("#,###", ((OracleDecimal)totalprice.Value).ToInt32());
                }

                // 時間枠名称
                rc.TIMEFRANAME = WebHains.SelectTimeFraName(Convert.ToInt32(rc.TIMEFRA));

                // 性別名称
                if (Convert.ToString(rc.GENDER) == Gender.Male.ToString())
                {
                    rc.GENDERNAME = "男";
                }
                else if (Convert.ToString(rc.GENDER) == Gender.Female.ToString())
                {
                    rc.GENDERNAME = "女";
                }
                else
                {
                    rc.GENDERNAME = Convert.ToString(rc.GENDER);
                }

                // 予約日
                rc.RSVDATE = Convert.ToDateTime(rc.RSVDATE).ToString("yyyy年M月d日");
            }

            return retList;
        }

        /// <summary>
        /// 請求書基本情報更新時の妥当性チェックを行う
        /// </summary>
        /// <param name="closeYear">締め日（年）</param>
        /// <param name="closeMonth">締め日（月）</param>
        /// <param name="closeDay">締め日（日）</param>
        /// <param name="closeDate">締め日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="taxRates">税率</param>
        /// <param name="prtYear">請求書出力日（年）</param>
        /// <param name="prtMonth">請求書出力日（月）</param>
        /// <param name="prtDay">請求書出力日（日）</param>
        /// <param name="prtDate">請求書出力日</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValueDmdOrgMasterBurden(string closeYear, string closeMonth,
                                                    string closeDay, ref DateTime? closeDate,
                                                    string orgCd1, string orgCd2,
                                                    string taxRates, ref object prtDate)
        {
            var messages = new List<string>();  // エラーメッセージの集合
            DateTime? editPrtDate = null;       // 編集用出力日


            // 締め日チェック
            messages.Add(WebHains.CheckDate("締め日", Convert.ToString(closeYear), Convert.ToString(closeMonth), Convert.ToString(closeDay), out closeDate, Check.Necessary));

            // 請求先団体チェック
            if (string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                messages.Add("請求先団体を指定してください");
            }


            // 請求書出力日チェック
            // messages.Add(WebHains.CheckDate("請求書出力日", Convert.ToString(prtYear), Convert.ToString(prtMonth), Convert.ToString(prtDay), out editPrtDate));

            // 税率チェック
            messages.Add(WebHains.CheckNumericDecimalPoint("税率", taxRates, LENGTH_TAXRATES, LENGTH_TAXRATES_DECPOINT, Check.Necessary));

            // 戻り値の編集
            if (messages.Count == 0)
            {
                prtDate = editPrtDate;
            }

            return messages;
        }

        /// <summary>
        /// 請求書を挿入する
        /// </summary>
        /// <param name="billNo">(Out)請求書番号</param>
        /// <param name="data">挿入データ
        /// closedate  締め日
        /// orgcd1     団体コード１
        /// orgcd2     団体コード２
        /// prtdate    請求書出力日
        /// taxrates   適用税率
        /// secondflg  ２次検査フラグ
        /// </param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        public Insert InsertBill(ref string billNo, InsertBill data)
        {
            string sql = "";      // SQLステートメント
            string billSeq = "";  // 請求書Seq

            if (string.IsNullOrEmpty(Convert.ToString(data.CloseDate))
                        || string.IsNullOrEmpty(Convert.ToString(data.OrgCd1))
                        || string.IsNullOrEmpty(Convert.ToString(data.OrgCd2)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            try
            {
                // 請求書番号取得
                billSeq = GetBillSeq(Convert.ToDateTime(data.CloseDate));

                // キー値の設定
                var sqlParam = new Dictionary<string, object>();
                sqlParam.Add("closedate", Convert.ToString(data.CloseDate).Trim());
                sqlParam.Add("billseq", billSeq);
                sqlParam.Add("orgcd1", Convert.ToString(data.OrgCd1));
                sqlParam.Add("orgcd2", Convert.ToString(data.OrgCd2));
                if(data.PrtDate != null){
                     sqlParam.Add("prtdate", Convert.ToString(data.PrtDate).Trim());
                }else{ 
                    sqlParam.Add("prtdate", data.PrtDate);
                }
                sqlParam.Add("taxrates", Convert.ToString(data.TaxRates).Trim());
                sqlParam.Add("secondflg", (string.IsNullOrEmpty(Convert.ToString(data.SecondFlg)) ? null : Convert.ToString(data.SecondFlg)));

                // 該当キーの請求書を挿入
                sql = @"
                        insert
                        into bill(
                            closedate
                            , billseq
                            , branchno
                            , delflg
                            , orgcd1
                            , orgcd2
                            , method
                            , taxrates
                            , prtdate
                            , secondflg
                    ";

                sql += @"
                        )
                        values (
                            :closedate
                            , :billseq
                            , 0
                            , 0
                            , :orgcd1
                            , :orgcd2
                            , 0
                            , :taxrates
                            , :prtdate
                            , :secondflg
                        )
                    ";

                connection.Execute(sql, sqlParam);

                billNo = Convert.ToDateTime(data.CloseDate).ToString("yyyyMMdd") + billSeq.PadLeft(5, '0') + "0";

                // 戻り値の設定
                return Insert.Normal;
            }
            catch (OracleException ex)
            {
                // キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    return Insert.Duplicate;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="data">請求明細
        /// billno      請求書番号
        /// csldate     受診日
        /// rsvno       予約番号
        /// dayid       当日ID
        /// detailname  名称
        /// perid       個人ID
        /// price       金額
        /// editprice   調整金額
        /// taxprice    税額
        /// edittax     調整税額
        /// </param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        public Insert InsertBillDetail(BillDetail data)
        {
            string sql = "";        // SQLステートメント

            bool perId = false;     // TRUE:個人ID入力

            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(Convert.ToString(data.BillNo)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            try
            {
                if (data.PerId != null)
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(data.PerId)))
                    {
                        perId = true;
                    }
                }

                // 請求書番号の妥当性チェック
                if (data.BillNo != null)
                {
                    data.BillNo = Convert.ToString(data.BillNo).Trim();
                    if (Util.IsNumber(Convert.ToString(data.BillNo)))
                    {
                        if (Convert.ToDouble(data.BillNo) > 0)
                        {
                            if (Convert.ToString(data.BillNo).Length == LENGTH_BILLNO)
                            {
                                // 請求書番号を分解
                                closeDate = Convert.ToString(data.BillNo).Substring(0, 4) + "/" + Convert.ToString(data.BillNo).Substring(4, 2) + "/" + Convert.ToString(data.BillNo).Substring(6, 2);
                                billSeq = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(8, 5));
                                branchNo = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(13, 1));
                            }
                        }
                    }
                }

                // キー値の設定
                var sqlParam = new Dictionary<string, object>();
                sqlParam.Add("csldate", Convert.ToDateTime(data.CslDate));
                sqlParam.Add("rsvno", Convert.ToString(data.RsvNo));
                sqlParam.Add("dayid", Convert.ToString(data.DayId));
                sqlParam.Add("detailname", Convert.ToString(data.DetailName).Trim());
                if (perId == true)
                {
                    sqlParam.Add("perid", Convert.ToString(data.PerId));
                }
                sqlParam.Add("price", Convert.ToString(data.Price));
                sqlParam.Add("editprice", Convert.ToString(data.EditPrice));
                sqlParam.Add("taxprice", Convert.ToString(data.TaxPrice));
                sqlParam.Add("edittax", Convert.ToString(data.EditTax));

                sqlParam.Add("closedate", Convert.ToDateTime(closeDate));
                sqlParam.Add("billseq", billSeq);
                sqlParam.Add("branchno", branchNo);

                // 該当キーの請求書を更新
                if (perId == true)
                {
                    sql = @"
                            insert
                            into billdetail(
                                closedate
                                , billseq
                                , branchno
                                , lineno
                                , detailname
                                , price
                                , editprice
                                , taxprice
                                , edittax
                                , rsvno
                                , perid
                                , lastname
                                , firstname
                                , lastkname
                                , firstkname
                                , csldate
                                , dayid
                                , method
                            )
                        ";

                    sql += @"
                            (
                                select
                                :closedate
                                , :billseq
                                , :branchno
                                , billdetail_view.maxlineno
                                , :detailname
                                , :price
                                , :editprice
                                , :taxprice
                                , :edittax
                                , :rsvno
                                , person.perid
                                , person.lastname
                                , person.firstname
                                , person.lastkname
                                , person.firstkname
                                , :csldate
                                , :dayid
                                , 0
                                from
                                person
                                , (
                                    select
                                    nvl(max(billdetail.lineno), 0) + 1 as maxlineno
                                    from
                                    billdetail
                                    where
                                    billdetail.closedate = :closedate
                                    and billdetail.billseq = :billseq
                                    and billdetail.branchno = :branchno
                                ) billdetail_view
                                where
                                perid = :perid
                            )
                        ";
                }
                else
                {
                    sql = @"
                            insert
                            into billdetail(
                                closedate
                                , billseq
                                , branchno
                                , lineno
                                , detailname
                                , price
                                , editprice
                                , taxprice
                                , edittax
                                , rsvno
                                , csldate
                                , dayid
                                , method
                            ) (
                                select
                                :closedate
                                , :billseq
                                , :branchno
                                , nvl(max(lineno), 0) + 1
                                , :detailname
                                , :price
                                , :editprice
                                , :taxprice
                                , :edittax
                                , :rsvno
                                , :csldate
                                , :dayid
                                , 0
                                from
                                billdetail
                                where
                                closedate = :closedate
                                and billseq = :billseq
                                and branchno = :branchno
                            )
                        ";
                }

                connection.Execute(sql, sqlParam);

                return Insert.Normal;
            }
            catch (OracleException ex)
            {
                // キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    return Insert.Duplicate;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 請求明細内訳を更新する
        /// </summary>
        /// <param name="data">請求明細内訳
        /// billno           請求書番号
        /// lineno           明細No
        /// secondlinedivcd  ２次請求明細コード
        /// price            金額
        /// editprice        調整金額
        /// taxprice         税額
        /// edittax          調整税額
        /// </param>
        /// <returns>
        /// Insert.Normal    正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error     異常終了
        /// </returns>
        public Insert InsertBillDetail_Items(UpdateBillDetailItems data)
        {
            string sql = "";        // SQLステートメント

            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番

            try
            {
                // 検索条件が設定されていない場合はエラー
                if (!Util.IsNumber(Convert.ToString(data.BillNo)))
                {
                    throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
                }

                if (string.IsNullOrEmpty(Convert.ToString(data.LineNo)))
                {
                    throw new ArgumentException();  //「プロシージャの呼び出し、または引数が不正です。」
                }

                // 請求書番号の妥当性チェック
                if (data.BillNo != null)
                {
                    data.BillNo = Convert.ToString(data.BillNo).Trim();
                    if (Util.IsNumber(Convert.ToString(data.BillNo)))
                    {
                        if (Convert.ToDouble(data.BillNo) > 0)
                        {
                            if (Convert.ToString(data.BillNo).Length == LENGTH_BILLNO)
                            {
                                // 請求書番号を分解
                                closeDate = Convert.ToString(data.BillNo).Substring(0, 4) + "/" + Convert.ToString(data.BillNo).Substring(4, 2) + "/" + Convert.ToString(data.BillNo).Substring(6, 2);
                                billSeq = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(8, 5));
                                branchNo = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(13, 1));
                            }
                        }
                    }
                }

                // キー値の設定
                var sqlParam = new Dictionary<string, object>();
                sqlParam.Add("secondlinedivcd", Convert.ToString(data.SecondLineDivCd).Trim());
                sqlParam.Add("price", Convert.ToString(data.Price));
                sqlParam.Add("editprice", Convert.ToString(data.EditPrice));
                sqlParam.Add("taxprice", Convert.ToString(data.TaxPrice));
                sqlParam.Add("edittax", Convert.ToString(data.EditTax));
                sqlParam.Add("closedate", Convert.ToDateTime(closeDate));
                sqlParam.Add("billseq", billSeq);
                sqlParam.Add("branchno", branchNo);
                sqlParam.Add("lineno", Convert.ToString(data.LineNo));

                // 該当キーの請求書を更新
                sql = @"
                        insert
                        into billdetail_items(
                            closedate
                            , billseq
                            , branchno
                            , lineno
                            , itemno
                            , secondlinedivcd
                            , price
                            , editprice
                            , taxprice
                            , edittax
                        ) (
                            select
                            :closedate
                            , :billseq
                            , :branchno
                            , :lineno
                            , nvl(max(itemno), 0) + 1
                            , :secondlinedivcd
                            , :price
                            , :editprice
                            , :taxprice
                            , :edittax
                            from
                            billdetail_items
                            where
                            closedate = :closedate
                            and billseq = :billseq
                            and branchno = :branchno
                            and lineno = :lineno
                        )
                    ";

                connection.Execute(sql, sqlParam);

                return Insert.Normal;
            }
            catch (OracleException ex)
            {
                // キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
                if (ex.Number == 1)
                {
                    return Insert.Duplicate;
                }

                throw ex;
            }
        }

        /// <summary>
        /// 請求書を更新する
        /// </summary>
        /// <param name="data">請求書
        /// billno       請求書番号
        /// method       作成方法
        /// closedate    締め日
        /// orgcd1       団体コード１
        /// orgcd2       団体コード２
        /// billclasscd  請求書分類コード
        /// taxrates     適用税率
        /// prtdate      請求書出力日
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateBill(JToken data)
        {
            string sql = "";   // SQLステートメント
            bool ret = false;  // 関数戻り値

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(Convert.ToString(data["billno"])))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            if (!(Convert.ToInt32(data["method"]).Equals(BillMethod.Man)
                || Convert.ToInt32(data["method"]).Equals(BillMethod.Prg)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("billno", Convert.ToString(data["billno"]));

            if (Convert.ToInt32(data["method"]).Equals(BillMethod.Man))
            {
                // 手入力のときだけ団体を変更可とする
                sqlParam.Add("orgcd1", Convert.ToString(data["orgcd1"]));
                sqlParam.Add("orgcd2", Convert.ToString(data["orgcd2"]));
            }

            sqlParam.Add("billclasscd", Convert.ToString(data["billclasscd"]).Trim());
            sqlParam.Add("closedate", Convert.ToDateTime(data["closedate"]));
            sqlParam.Add("taxrates", Convert.ToString(data["taxrates"]));
            sqlParam.Add("prtdate", Convert.ToString(data["prtdate"]));

            // 該当キーの請求書を更新
            sql = @"
                    update bill
                    set
                        closedate = :closedate
                        , billclasscd = :billclasscd
                ";

            if (Convert.ToInt32(data["method"]).Equals(BillMethod.Man))
            {
                sql += @"
                        , orgcd1 = :orgcd1
                        , orgcd2 = :orgcd2
                    ";
            }

            sql += @"
                    , prtdate = :prtdate
                    , taxrates = :taxrates
                    where
                        billno = :billno
                ";

            connection.Execute(sql, sqlParam);

            // 戻り値の設定
            ret = true;
            return ret;
        }

        /// <summary>
        /// 請求書を削除する
        /// </summary>
        /// <param name="inBillNo">請求書番号</param>
        /// <returns>削除結果</returns>
        public int DeleteBill(string inBillNo)
        {
            string sql = "";        // SQLステートメント

            bool isBillNo = false;
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo;           // 請求書枝番

            // 請求書番号の妥当性チェック
            if (inBillNo != null)
            {
                inBillNo = inBillNo.Trim();

                if (Util.IsNumber(inBillNo))
                {
                    if (Convert.ToDouble(inBillNo) > 0)
                    {
                        if (inBillNo.Length == LENGTH_BILLNO)
                        {
                            // 請求書番号を分解
                            closeDate = inBillNo.Substring(0, 4) + "/" + inBillNo.Substring(4, 2) + "/" + inBillNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(inBillNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(inBillNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (isBillNo == false)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 該当キーの請求書明細を削除
            sql = @"
                    begin delete_bill(:closedate, :billseq, :ret);
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // キー値の設定
                // Inputは名前と値のみ
                cmd.Parameters.Add("closedate", Convert.ToDateTime(closeDate));
                cmd.Parameters.Add("billseq", billSeq);

                // Outputパラメータ
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        public bool DeleteBillDetail(string billNo, string lineNo, string rsvNo, string orgCd1, string orgCd2)
        {
            string sql = "";        // SQLステートメント
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番
            bool ret = false;       // 戻り値
            string billNoStr = Convert.ToString(billNo);

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(billNoStr))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            if (string.IsNullOrEmpty(lineNo) || string.IsNullOrEmpty(orgCd1) || string.IsNullOrEmpty(orgCd2))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNoStr))
            {
                billNoStr = billNoStr.Trim();

                if (Util.IsNumber(billNoStr))
                {
                    if (Convert.ToDouble(billNoStr) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNoStr.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNoStr.Substring(0, 4) + "/" + billNoStr.Substring(4, 2) + "/" + billNoStr.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNoStr.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNoStr.Substring(13, 1));
                        }
                    }
                }
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("closedate", Convert.ToDateTime(closeDate));
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);
            param.Add("lineno", lineNo);
            using (var transaction = BeginTransaction())
            {
                try
                {
                    // 該当キーの請求書明細を削除
                    sql = @"
                            delete
                            from
                                billdetail
                            where
                                closedate = :closedate
                                and billseq = :billseq
                                and branchno = :branchno
                                and lineno = :lineno
                        ";
                    connection.Execute(sql, param);
                    // transaction.Commit();
                    // param = null;

                    if (!string.IsNullOrEmpty(rsvNo))
                    {
                        // キー値の設定
                        param.Add("rsvno", rsvNo);
                        param.Add("orgcd1", orgCd1);
                        param.Add("orgcd2", orgCd2);

                        // 削除した請求書明細と同一の予約番号を持つ明細を削除
                        sql = @"
                                delete
                                from
                                  billdetail
                                where
                                  (closedate, billseq, branchno, rsvno) in (
                                    select
                                      closedate
                                      , billseq
                                      , branchno
                                      , rsvno
                                    from
                                      closemng
                                    where
                                      rsvno = :rsvno
                                      and orgcd1 = :orgcd1
                                      and orgcd2 = :orgcd2
                                  )
                            ";

                        connection.Execute(sql, param);
                        // transaction.Commit();
                        //param = null;

                        // キー値の設定
                        //param.Add("rsvno", rsvNo);
                        //param.Add("orgcd1", orgCd1);
                        //param.Add("orgcd2", orgCd2);

                        // 該当キーの締め管理を削除
                        sql = @"
                                delete
                                from
                                  closemng
                                where
                                  rsvno = :rsvno
                                  and orgcd1 = :orgcd1
                                  and orgcd2 = :orgcd2
                            ";

                        connection.Execute(sql, param);
                        // transaction.Commit();
                    }
                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                }

            }
            // 戻り値の設定
            ret = true;
            return ret;
        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="itemNo">内訳No</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteBillDetail_Items(string billNo, int lineNo, int itemNo)
        {
            string sql = "";        // SQLステートメント
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番
            bool ret = false;       // 戻り値

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(billNo))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNo))
            {
                billNo = billNo.Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                        }
                    }
                }
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("closedate", Convert.ToDateTime(closeDate));
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);
            param.Add("lineno", lineNo);
            param.Add("billno", billNo);
            param.Add("itemno", itemNo);

      // 該当キーの請求書明細を削除
      sql = @"
                    delete
                    from
                        billdetail_items
                    where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                        and lineno = :lineno
                        and itemno = :itemno
                ";

            if (connection.Execute(sql, param) > 0)
            {
                ret = true;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求書一括削除
        /// </summary>
        /// <param name="closeDate">請求締め日</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns>
        /// 削除件数（マイナスはエラー）
        /// </returns>
        public int DeleteAllBill(DateTime closeDate, string orgCd1 = "", string orgCd2 = "")
        {
            using (var transaction = BeginTransaction())
            {
                string sql = @"
                begin
                    delete_bill_fetch(
                        :closedate
                        , :orgcd1
                        , :orgcd2
                        ,:ret
                    );
                end;
            ";

                using (var cmd = new OracleCommand())
                {
                    try
                    {
                        // Inputは名前と値のみ
                        cmd.Parameters.Add("closedate", closeDate);
                        cmd.Parameters.Add("orgcd1", orgCd1);
                        cmd.Parameters.Add("orgcd2", orgCd2);

                        // 戻り値の設定
                        OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                        ExecuteNonQuery(cmd, sql);
                        transaction.Commit();
                        return ((OracleDecimal)ret.Value).ToInt32();
                    }
                    catch
                    {
                        transaction.Rollback();
                        return -1;
                    }
                }
            }
        }

        /// <summary>
        /// 検索条件を満たす請求書団体管理情報を取得する
        /// </summary>
        /// <param name="inBillNo">請求書番号</param>
        /// <param name="seq">SEQ</param>
        /// <returns>
        /// cslorgcd1    受診団体コード１
        /// cslorgcd2    受診団体コード２
        /// cslorgname   受診団体名称
        /// isrsign      健保記号
        /// isrsignname  健保記号からの団体名
        /// </returns>
        public dynamic SelectDmdBurdenModifyBillOrg(int inBillNo, int seq)
        {
            string sql = "";   // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (inBillNo == 0 || seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("billno", Convert.ToString(inBillNo));
            param.Add("seq", Convert.ToString(seq));

            // 検索条件を満たす請求書団体管理情報のレコードを取得
            sql = @"
                    select
                      bill_org.cslorgcd1
                      , bill_org.cslorgcd2
                      , org.orgname
                      , bill_org.isrsign
                      , bill_org.isrsign
                      , (
                        select distinct
                          orgsname
                        from
                          org
                        where
                          org.isrsign = bill_org.isrsign
                          and org.isrgetname = 1
                          and rownum = 1
                      ) isrsignname
                    from
                      org
                      , bill_org
                    where
                      bill_org.billno = :billno
                      and bill_org.seq = :seq
                      and org.orgcd1 = bill_org.cslorgcd1
                      and org.orgcd2 = bill_org.cslorgcd2
                  ";


            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす請求書団体別コース管理情報を取得する
        /// </summary>
        /// <param name="inBillNo">請求書番号</param>
        /// <param name="seq">SEQ</param>
        /// <param name="csSeq">コースSEQ</param>
        /// <returns>
        /// CsCd     コースコード
        /// CsName   コース名称
        /// StrDate  開始受診日
        /// EndDate  終了受診日
        /// cslCnt   受診人数
        /// </returns>
        public dynamic SelectDmdBurdenModifyBillCourse(int inBillNo, int seq, int csSeq)
        {
            string sql = "";   // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (inBillNo == 0 || seq == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("billno", Convert.ToString(inBillNo));
            param.Add("seq", Convert.ToString(seq));
            param.Add("csseq", Convert.ToString(csSeq));

            // 検索条件を満たす請求書団体管理情報のレコードを取得
            sql = @"
                    select
                      bill_course.cscd
                      , course_p.csname
                      , bill_course.strdate
                      , bill_course.enddate
                      , bill_course.cslcnt
                    from
                      course_p
                      , bill_course
                    where
                      bill_course.billno = :billno
                      and bill_course.seq = :seq
                      and bill_course.csseq = :csseq
                      and bill_course.cscd = course_p.cscd(+)
                 ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす入金、発送件数を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <returns>入金、発送件数
        /// paymentcnt   入金件数
        /// dispatchcnt  発送件数
        /// </returns>
        public List<dynamic> SelectPaymentAndDispatchCnt(string billNo)
        {
            string sql = "";        // SQLステートメント
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番
            bool isBillNo = false;  // 請求書番号指定判定

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNo))
            {
                billNo = billNo.Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            sql = @"
                    select
                      payment_view.cnt as payment_cnt
                      , dispatch_view.cnt as dispatch_cnt
                    from
                      (
                        select
                          count(*) as cnt
                        from
                          payment
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                      ) payment_view
                      , (
                        select
                          count(*) as cnt
                        from
                          dispatch
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                      ) dispatch_view
                  ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす請求明細情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>請求明細情報
        /// billno      請求書番号
        /// lineno      明細No
        /// closedate   締め日
        /// billseq     請求書Seq
        /// branchno    請求書枝番
        /// dayid       当日ID
        /// rsvno       予約番号
        /// csldate     受診日
        /// detailname  名称
        /// perid       個人ID
        /// lastname
        /// firstname
        /// lastkname   カナ姓
        /// firstkname  カナ名
        /// price       金額
        /// editprice   調整金額
        /// taxprice    税額
        /// edittax     調整税額
        /// orgname     団体名
        /// orgkname    団体カナ名
        /// method      作成方法
        /// secondflg   ２次検査フラグ
        /// </returns>
        public PartialDataSet SelectDmdBurdenBillDetail(string billNo, string lineNo, int? startPos = null, int? getCount = null)
        {
            string sql = "";       // SQLステートメント
            string sqlCnt = "";    // SQLステートメント count
            string closeDate = ""; // 締め日
            int billSeq = 0;       // 請求書Seq
            int branchNo = 0;      // 請求書枝番
            bool isBillNo = false; // パラメタに請求書番号が指定されている
            bool isLineNo = false; // パラメタに明細NOが指定されている
            int count;

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNo))
            {
                billNo = billNo.Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            // 明細Noが指定されている
            if (!string.IsNullOrEmpty(lineNo))
            {
                if (Util.IsNumber(lineNo))
                {
                    param.Add("lineno", lineNo);
                    isLineNo = true;
                }
            }

            // 取得件数と開始位置が設定されている場合
            if (null != startPos && null != getCount)
            {
                param.Add("seq_t", Convert.ToInt32(startPos) + Convert.ToInt32(getCount));
                if (startPos != 0)
                {
                    startPos = startPos + 1;
                }
                param.Add("seq_f", Convert.ToInt32(startPos));
            }

            // ROWNUMにより範囲指定するため、全体をVIEWにする
            sql = @"
			            select
			              main_view.*
			            from
			        ";

            // 基本部分
            sql += @"
			            (
			              select
			                rownum as rowseq
			                , to_char(billdetail.closedate, 'YYYY/MM/DD') as closedate
			                , billdetail.billseq
			                , billdetail.branchno
			                , to_char(billdetail.closedate, 'YYYYMMDD') || trim(to_char(billdetail.billseq, '00000')) || to_char
			                (billdetail.branchno) as billno
			                , billdetail.lineno
			                , billdetail.dayid
			                , billdetail.rsvno
			                , to_char(billdetail.csldate, 'YYYY/MM/DD') as csldate
			                , billdetail.detailname
			                , billdetail.perid
			                , billdetail.lastname
			                , billdetail.firstname
			                , billdetail.lastkname
			                , billdetail.firstkname
			                , billdetail.price
			                , billdetail.editprice
			                , billdetail.taxprice
			                , billdetail.edittax
			                , org.orgname
			                , org.orgkname
			                , billdetail.method
			                , bill.secondflg
			              from
			                billdetail
			                , org
			                , bill
			        ";

            sqlCnt = @" select count(*) cnt
			          from 
			                billdetail
			                ";
            if (isBillNo)
            {
                sql += @"
				                where
				                  billdetail.closedate = :closedate
				                  and billdetail.billseq = :billseq
				                  and billdetail.branchno = :branchno
				            ";
                sqlCnt += @"
				                where
				                  billdetail.closedate = :closedate
				                  and billdetail.billseq = :billseq
				                  and billdetail.branchno = :branchno
				            ";
            }
            if (isLineNo)
            {
                sql += @"
			                and billdetail.lineno = :lineno
			            ";
            }

            sql += @"
			            and billdetail.closedate = bill.closedate
			            and billdetail.billseq = bill.billseq
			            and billdetail.branchno = bill.branchno
			            and bill.orgcd1 = org.orgcd1
			            and bill.orgcd2 = org.orgcd2
			        ";

            sql += @"
			            ) main_view
			        ";

            // 取得件数と開始位置が設定されている場合
            if (null != startPos && null != getCount)
            {
                sql += @"
				                where
				                    main_view.rowseq between :seq_f and :seq_t
				            ";
            }

            List<dynamic> data = connection.Query(sql, param).ToList();
            dynamic countData = connection.Query(sqlCnt, param).FirstOrDefault();
            count = Convert.ToInt32(countData.CNT);

            // 戻り値の設定
            return new PartialDataSet(count, data);
        }

        /// <summary>
        /// 検索条件を満たす請求明細情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>請求明細情報
        /// billno       請求書番号
        /// lineno       明細No
        /// closedate    締め日
        /// billseq      請求書Seq
        /// branchno     請求書枝番
        /// dayid        当日ID
        /// rsvno        予約番号
        /// csldate      受診日
        /// detailname   名称
        /// perid        個人ID
        /// lastname     姓
        /// firstname    名
        /// lastkname    カナ姓
        /// firstkname   カナ名
        /// price        金額
        /// editprice    調整金額
        /// taxprice     税額
        /// edittax      調整税額
        /// orgcd1       団体コード１
        /// orgcd2       団体コード２
        /// orgname      団体名
        /// orgkname     団体カナ名
        /// method       作成方法
        /// delflg       取消伝票フラグ
        /// secondflg    ２次検査フラグ
        /// </returns>
        public List<dynamic> SelectDmdBurdenModifyBillDetail(string billNo, string lineNo, int? startPos, int? getCount)
        {
            string sql = "";        // SQLステートメント
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番
            bool isBillNo = false;  // パラメタに請求書番号が指定されている
            bool isLineNo = false;  // パラメタに明細NOが指定されている

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNo))
            {
                billNo = billNo.Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            // 明細Noが指定されている
            if (!string.IsNullOrEmpty(lineNo))
            {
                if (Util.IsNumber(lineNo))
                {
                    param.Add("lineno", lineNo);
                    isLineNo = true;
                }
            }

            // 取得件数と開始位置が設定されている場合
            if (null != startPos && null != getCount)
            {
                param.Add("seq_f", Convert.ToInt32(startPos));
                param.Add("seq_t", Convert.ToInt32(startPos) + Convert.ToInt32(getCount) - 1);
            }

            // ROWNUMにより範囲指定するため、全体をVIEWにする
            sql = @"
                    select
                      main_view.*
                    from
                ";

            // 基本部分SELECT句
            sql += @"
                    (
                      select
                        rownum as rowseq
                        , to_char(bill.closedate, 'YYYY/MM/DD') as closedate
                        , bill.billseq
                        , bill.branchno
                        , bill.delflg
                        , bill.secondflg
                        , to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                         as billno
                        , org.orgcd1
                        , org.orgcd2
                        , org.orgname
                        , org.orgkname
                        , billdetail_view.lineno
                        , billdetail_view.rsvno
                        , billdetail_view.dayid
                        , to_char(billdetail_view.csldate, 'YYYY/MM/DD') as csldate
                        , billdetail_view.detailname
                        , billdetail_view.perid
                        , billdetail_view.lastname
                        , billdetail_view.firstname
                        , billdetail_view.lastkname
                        , billdetail_view.firstkname
                        , billdetail_view.price
                        , billdetail_view.editprice
                        , billdetail_view.taxprice
                        , billdetail_view.edittax
                        , billdetail_view.method
                      from
                ";

            // 請求書明細部分SELECT句
            sql += @"
                    (
                      select
                        billdetail.closedate
                        , billdetail.billseq
                        , billdetail.branchno
                        , billdetail.lineno
                        , billdetail.rsvno
                        , billdetail.dayid
                        , billdetail.csldate
                        , billdetail.detailname
                        , billdetail.lastname
                        , billdetail.firstname
                        , billdetail.lastkname
                        , billdetail.firstkname
                        , billdetail.price
                        , billdetail.editprice
                        , billdetail.taxprice
                        , billdetail.edittax
                        , billdetail.perid
                        , billdetail.method
                      from
                        billdetail
                        , consult
                      where
                ";

            // 請求書明細部分WHERE句
            sql += @"
                    billdetail.closedate = :closedate
                    and billdetail.billseq = :billseq
                    and billdetail.branchno = :branchno
                ";

            // 明細No指定
            if (isLineNo)
            {
                sql += @"
                        and billdetail.lineno = :lineno
                    ";
            }
            else
            {
                sql += @"
                        and billdetail.lineno is null
                    ";
            }
            sql += @"
                    and consult.rsvno(+) = billdetail.rsvno) billdetail_view
                    , org
                    , bill
                ";

            // 基本部分WHERE句
            sql += @"
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and billdetail_view.closedate(+) = bill.closedate
                      and billdetail_view.billseq(+) = bill.billseq
                      and billdetail_view.branchno(+) = bill.branchno
                      and bill.orgcd1 = org.orgcd1
                      and bill.orgcd2 = org.orgcd2
                 ";
            sql += @"
                    ) main_view
                ";

            // 取得件数と開始位置が設定されている場合
            if (null != startPos && null != getCount)
            {
                sql += @"
                        where
                            main_view.rowseq between :seq_f and :seq_t
                    ";

            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす請求明細情報を取得する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <param name="itemNo">内訳No</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>請求明細情報
        /// billno               請求書番号
        /// lineno               明細No
        /// closedate            締め日
        /// billseq              請求書Seq
        /// branchno             請求書枝番
        /// dayid                当日ID
        /// rsvno                予約番号
        /// csldate              受診日
        /// detailname           名称
        /// perid                個人ID
        /// lastname             姓
        /// firstname            名
        /// lastkname            カナ姓
        /// firstkname           カナ名
        /// price                金額
        /// editprice            調整金額
        /// taxprice             税額
        /// edittax              調整税額
        /// orgcd1               団体コード１
        /// orgcd2               団体コード２
        /// orgname              団体名
        /// orgkname             団体カナ名
        /// method               作成方法
        /// delflg               取消伝票フラグ
        /// itemno               内訳no
        /// secondlinedivcd      ２次請求明細コード
        /// secondlinedivname    ２次請求明細名
        /// </returns>
        public PartialDataSet SelectDmdDetailItmList(string billNo, string lineNo, string itemNo, int? startPos = null, int? getCount = null)
        {
            string sql = "";        // SQLステートメント
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番
            bool isBillNo = false;  // パラメタに請求書番号が指定されている
            bool isItemNo = false;  // パラメタに内訳NOが指定されている
            int count = 0;
            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNo))
            {
                billNo = billNo.Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            // 明細Noが指定されている
            if (!string.IsNullOrEmpty(lineNo))
            {
                if (Util.IsNumber(lineNo))
                {
                    param.Add("lineno", lineNo);
                }
            }

            // 内訳Noが指定されている
            if (!string.IsNullOrEmpty(itemNo))
            {
                if (Util.IsNumber(itemNo))
                {
                    param.Add("itemno", itemNo);
                    isItemNo = true;
                }
            }

            // 取得件数と開始位置が設定されている場合
            if (null != startPos && null != getCount)
            {
                param.Add("seq_t", Convert.ToInt32(startPos) + Convert.ToInt32(getCount));
                if (startPos != 0)
                {
                    startPos += 1;
                }
                param.Add("seq_f", Convert.ToInt32(startPos));
            }

            // ROWNUMにより範囲指定するため、全体をVIEWにする
            sql = @"
                    select
                      main_view.*
                    from
                ";

            // 基本部分SELECT句
            sql += @"
                    (
                      select
                        rownum as rowseq
                        , to_char(bill.closedate, 'YYYY/MM/DD') as closedate
                        , bill.billseq
                        , bill.branchno
                        , bill.delflg
                        , to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                         as billno
                        , org.orgcd1
                        , org.orgcd2
                        , org.orgname
                        , org.orgkname
                        , billdetail_view.lineno
                        , billdetail_view.rsvno
                        , billdetail_view.dayid
                        , to_char(billdetail_view.csldate, 'YYYY/MM/DD') as csldate
                        , billdetail_view.detailname
                        , billdetail_view.perid
                        , billdetail_view.lastname
                        , billdetail_view.firstname
                        , billdetail_view.lastkname
                        , billdetail_view.firstkname
                        , billdetail_view.method
                        , billdetail_items.itemno
                        , billdetail_items.secondlinedivcd
                        , billdetail_items.price
                        , billdetail_items.editprice
                        , billdetail_items.taxprice
                        , billdetail_items.edittax
                        , secondlinediv.secondlinedivname
                      from
                ";

            // 請求書明細部分SELECT句
            sql += @"
                    (
                      select
                        billdetail.closedate
                        , billdetail.billseq
                        , billdetail.branchno
                        , billdetail.lineno
                        , billdetail.rsvno
                        , billdetail.dayid
                        , billdetail.csldate
                        , billdetail.detailname
                        , billdetail.lastname
                        , billdetail.firstname
                        , billdetail.lastkname
                        , billdetail.firstkname
                        , billdetail.perid
                        , billdetail.method
                      from
                        billdetail
                        , consult
                      where
                ";

            // 請求書明細部分WHERE句
            sql += @"
                    billdetail.closedate = :closedate
                    and billdetail.billseq = :billseq
                    and billdetail.branchno = :branchno
                    
                ";
            if (!string.IsNullOrEmpty(lineNo) && Util.IsNumber(lineNo))
            {
                sql += @"and billdetail.lineno = :lineno";

            }

            sql += @"
                    and consult.rsvno(+) = billdetail.rsvno)  
                    billdetail_view
                    , org
                    , bill
                    , billdetail_items
                    , secondlinediv
                ";

            // 基本部分WHERE句
            sql += @"
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and billdetail_view.closedate(+) = bill.closedate
                      and billdetail_view.billseq(+) = bill.billseq
                      and billdetail_view.branchno(+) = bill.branchno
                      and bill.orgcd1 = org.orgcd1
                      and bill.orgcd2 = org.orgcd2
                      and billdetail_items.closedate = :closedate
                      and billdetail_items.billseq = :billseq
                      and billdetail_items.branchno = :branchno
                      and billdetail_items.secondlinedivcd = secondlinediv.secondlinedivcd
                ";
            if (!string.IsNullOrEmpty(lineNo) && Util.IsNumber(lineNo))
            {
                sql += @"
                      and billdetail_items.lineno = :lineno";
            }
            // 明細No指定
            if (isItemNo)
            {
                sql += @"
                        and billdetail_items.itemno = :itemno
                    ";
            }
            sql += @"
                    ) main_view
                ";
            count = connection.Query(sql, param).ToList().Count;
            // 取得件数と開始位置が設定されている場合
            if (null != startPos && null != getCount)
            {
                sql += @"
                        where
                            main_view.rowseq between :seq_f and :seq_t
                    ";
            }
            List<dynamic> data = connection.Query(sql, param).ToList();

            // 戻り値の設定
            return new PartialDataSet(count, data);
        }

        /// <summary>
        /// 検索条件を満たす請求明細内訳情報を集計する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="lineNo">明細No</param>
        /// <returns>請求明細内訳情報
        /// sumprice       金額合計
        /// sumeditprice   調整金額合計
        /// sumtaxprice    税額合計
        /// sumedittax     調整税額合計
        /// sumpricetotal  総合計
        /// </returns>
        public List<dynamic> SelectSumDetailItems(string billNo, int? lineNo = null)
        {
            string sql = "";        // SQLステートメント
            string closeDate = "";  // 締め日
            int billSeq = 0;        // 請求書Seq
            int branchNo = 0;       // 請求書枝番
            bool isBillNo = false;  // パラメタに請求書番号が指定されている
            bool isLineNo = false;  // パラメタに明細NOが指定されている

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(billNo))
            {
                billNo = billNo.Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(billNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            // 明細Noが指定されている
            if (null != lineNo)
            {
                param.Add("lineno", lineNo);
                isLineNo = true;
            }

            // 基本部分SELECT句
            sql = @"
                    select
                      billdetail_items.closedate
                      , billdetail_items.billseq
                      , billdetail_items.branchno
                      ,
                 ";

            // 明細Noが指定されている
            if (isLineNo)
            {
                sql += @"
                        billdetail_items.lineno
                        ,
                    ";
            }
            sql += @"
                    sum(billdetail_items.price) as sumprice
                    , sum(billdetail_items.editprice) as sumeditprice
                    , sum(billdetail_items.taxprice) as sumtaxprice
                    , sum(billdetail_items.edittax) as sumedittax
                    , sum(
                      billdetail_items.price + billdetail_items.editprice + billdetail_items.taxprice + billdetail_items.edittax
                    ) as sumpricetotal
                    from
                      billdetail_items
                ";

            // 基本部分WHERE句
            sql += @"
                    where
                      billdetail_items.closedate = :closedate
                      and billdetail_items.billseq = :billseq
                      and billdetail_items.branchno = :branchno
                ";

            // 明細No指定
            if (isLineNo)
            {
                sql += @"
                        and billdetail_items.lineno = :lineno
                    ";
            }

            sql += @"
                    group by
                      billdetail_items.closedate
                      , billdetail_items.billseq
                      , billdetail_items.branchno
                ";

            // 明細No指定
            if (isLineNo)
            {
                sql += @"
                        , billdetail_items.lineno
                    ";
            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす発送日の一覧を取得する（請求書基本情報）
        /// </summary>
        /// <param name="inBillNo">請求書コード</param>
        /// <returns>発送日一覧
        /// billno         請求書番号
        /// closedate      締め日
        /// billseq        請求書Seq
        /// branchno       請求書枝番
        /// orgcd1         団体コード１
        /// orgcd2         団体コード２
        /// orgname        団体名
        /// orgkname       団体カナ名
        /// prtdate        請求書出力日
        /// sumpricetotal  合計
        /// sumtaxtotal    税額合計
        /// seq            Seq
        /// dispatchdate   発送日
        /// upduser        更新者ID
        /// username       更新者名
        /// upddate        更新日
        /// delflg         取消伝票フラグ
        /// billcomment    請求書コメント
        /// </returns>
        public List<dynamic> SelectDmdBurdenDispatch(string inBillNo)
        {
            string sql = "";        // SQLステートメント
            bool isBillNo = false;  // TRUE:請求書番号が指定されている
            int billSeq = 0;        // 請求書Seq
            string closeDate = "";  // 締め日
            int branchNo = 0;       // 請求書枝番

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(inBillNo))
            {
                inBillNo = inBillNo.Trim();
                if (Util.IsNumber(inBillNo))
                {
                    if (Convert.ToDouble(inBillNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(inBillNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = inBillNo.Substring(0, 4) + "/" + inBillNo.Substring(4, 2) + "/" + inBillNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(inBillNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(inBillNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            // 団体請求コメントの追加
            // 基本部分
            sql = @"
                    select
                      to_char(bill.closedate, 'YYYY/MM/DD') as closedate
                      , bill.billseq
                      , bill.branchno
                      , to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                       as billno
                      , org.orgcd1
                      , org.orgcd2
                      , org.orgname
                      , org.orgkname
                      , to_char(bill.prtdate, 'YYYY/MM/DD') as prtdate
                      , sum_billdetail.sum_pricetotal
                      , sum_billdetail.sum_taxtotal
                      , dispatch_view.seq
                      , to_char(dispatch_view.dispatchdate, 'YYYY/MM/DD') as dispatchdate
                      , to_char(dispatch_view.upddate, 'YYYY/MM/DD') as upddate
                      , dispatch_view.upduser
                      , dispatch_view.username
                      , bill.delflg
                      , bill.billcomment
                    from
                 ";

            // 請求書明細サマリ部分
            sql += @"
                    (
                      select
                        billdetail.closedate
                        , billdetail.billseq
                        , billdetail.branchno
                        , sum(billdetail.price + billdetail.editprice) as sum_pricetotal
                        , sum(billdetail.taxprice + billdetail.edittax) as sum_taxtotal
                      from
                        billdetail
                ";

            if (isBillNo)
            {
                sql += @"
                        where
                          billdetail.closedate = :closedate
                          and billdetail.billseq = :billseq
                          and billdetail.branchno = :branchno
                    ";
            }
            sql += @"
                    group by
                      billdetail.closedate
                      , billdetail.billseq
                      , billdetail.branchno) sum_billdetail
                      ,
                ";

            // 発送部分
            sql += @"
                    (
                      select
                        dispatch.closedate
                        , dispatch.billseq
                        , dispatch.branchno
                        , dispatch.seq
                        , dispatch.dispatchdate
                        , dispatch.upddate
                        , dispatch.upduser
                        , hainsuser.username
                      from
                        dispatch
                        , hainsuser
                ";

            if (isBillNo)
            {
                sql += @"
                        where
                          dispatch.closedate = :closedate
                          and dispatch.billseq = :billseq
                          and dispatch.branchno = :branchno
                          and dispatch.upduser = hainsuser.userid
                    ";
            }

            sql += @"
                     ) dispatch_view
                     ,
                ";

            sql += @"
                    org
                    , bill
                ";

            // 基本部分WHERE句
            if (isBillNo)
            {
                sql += @"
                        where
                          bill.closedate = :closedate
                          and bill.billseq = :billseq
                          and bill.branchno = :branchno
                    ";
            }

            sql += @"
                    and sum_billdetail.closedate(+) = bill.closedate
                    and sum_billdetail.billseq(+) = bill.billseq
                    and sum_billdetail.branchno(+) = bill.branchno
                    and dispatch_view.closedate(+) = bill.closedate
                    and dispatch_view.billseq(+) = bill.billseq
                    and dispatch_view.branchno(+) = bill.branchno
                    and bill.orgcd1 = org.orgcd1
                    and bill.orgcd2 = org.orgcd2
                ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書基本情報更新時の妥当性チェックを行う
        /// </summary>
        /// <param name="data">
        /// billno 請求書番号
        /// cslorgcd1 団体コード１
        /// cslorgcd1 団体コード２
        /// isrsign 健保記号
        /// cscd コースコード
        /// stryear 開始受診日（年）
        /// strmonth 開始受診日（月）
        /// strday 開始受診日（日）
        /// endyear 終了受診日（年）
        /// endmonth 終了受診日（月）
        /// endday 終了受診日（日）
        /// strdate 開始受診日
        /// dmdlineclasscd 請求明細分類コード
        /// noprint 請求書未出力フラグ
        /// detailname 名称
        /// agediv 年齢区分
        /// existsisr 健保有無区分
        /// price 負担元単価
        /// totalcnt 合計人数
        /// subtotal 金額
        /// tax 消費税
        /// discount 値引き
        /// total 合計
        /// cslcnt 受診人数
        /// </param>
        /// <returns>
        /// エラー値がある場合、エラーメッセージの配列を返す
        /// </returns>
        public List<string> CheckValueDmdBurdenModify(JToken data)
        {
            string checkDate;
            List<string> errMessage = new List<string>();  //エラーメッセージの集合

            while (true)
            {
                // 各値チェック処理
                // 受診団体チェック
                if ("".Equals(Convert.ToString(data["cslorgcd1"])) || "".Equals(Convert.ToString(data["cslorgcd2"])))
                {
                    errMessage.Add("受診団体を指定してください");
                }

                // 開始受診日のチェック
                if (Convert.ToInt32(data["stryear"]) > 0 || Convert.ToInt32(data["strmonth"]) > 0 || Convert.ToInt32(data["strday"]) > 0)
                {
                    checkDate = Convert.ToString(data["stryear"]) + "/" + Convert.ToString(data["strmonth"]) + "/" + Convert.ToString(data["strday"]);
                    if (DateTime.TryParse(checkDate, out DateTime tmpcheckDate))
                    {
                        data["strdate"] = Convert.ToDateTime(checkDate);
                    }
                    else
                    {
                        errMessage.Add("開始受診日の日付設定が誤っています。");
                    }
                }
                else
                {
                    data["strdate"] = "";
                }

                // 終了受診日のチェック
                if (Convert.ToInt32(data["endyear"]) > 0 || Convert.ToInt32(data["endmonth"]) > 0 || Convert.ToInt32(data["endday"]) > 0)
                {
                    checkDate = Convert.ToString(data["endyear"]) + "/" + Convert.ToString(data["endmonth"]) + "/" + Convert.ToString(data["endday"]);
                    if (DateTime.TryParse(checkDate, out DateTime tmpcheckDate))
                    {
                        data["enddate"] = Convert.ToDateTime(checkDate);
                    }
                    else
                    {
                        errMessage.Add("終了受診日の日付設定が誤っています。");
                    }
                }
                else
                {
                    data["enddate"] = "";
                }

                // 開始のみセットなら終了日にも同じものをセットする。
                if (!string.IsNullOrEmpty(Convert.ToString(data["strdate"]))
                    && string.IsNullOrEmpty(Convert.ToString(data["enddate"])))
                {
                    data["enddate"] = data["strdate"];
                }

                // 終了受診日が開始受診日よりも小さいなら逆返し
                if (string.IsNullOrEmpty(Convert.ToString(data["strdate"]))
                    && !string.IsNullOrEmpty(Convert.ToString(data["enddate"])))
                {
                    data["strdate"] = data["enddate"];
                }

                // 開始のみセットなら終了日にも同じものをセットする
                if (!string.IsNullOrEmpty(Convert.ToString(data["strdate"])))
                {
                    if (Convert.ToDateTime(data["enddate"]).CompareTo(Convert.ToDateTime(data["strdate"])) < 0)
                    {
                        checkDate = Convert.ToString(data["enddate"]);
                        data["enddate"] = data["strdate"];
                        data["strdate"] = Convert.ToDateTime(checkDate);
                    }
                }

                // 受診人数の数値チェック
                errMessage.Add(WebHains.CheckNumeric("受診人数", Convert.ToString(data["cslcnt"]), Convert.ToInt16(LengthConstants.LENGTH_BILLDETAIL_TOTALCNT)));

                // チェック対象判定（どれかが入力されている行をチェックする
                int inputCount = 0;
                List<JToken> list = data["detailname"].ToList();

                for (int i = 0; i < list.Count(); i++)
                {
                    if (!"".Equals(Convert.ToString(data[i]["dmdlineclasscd"])) || "1".Equals(Convert.ToString(data[i]["noprint"]))
                        || !"".Equals(Convert.ToString(data[i]["detailname"])) || !"".Equals(Convert.ToString(data[i]["agediv"]))
                        || !"".Equals(Convert.ToString(data[i]["existsisr"])) || !"".Equals(Convert.ToString(data[i]["price"]))
                        || !"".Equals(Convert.ToString(data[i]["totalcnt"])) || !"".Equals(Convert.ToString(data[i]["subtotal"]))
                        || !"".Equals(Convert.ToString(data[i]["tax"])) || !"".Equals(Convert.ToString(data[i]["discount"]))
                        || !"".Equals(Convert.ToString(data[i]["total"])))
                    {
                        inputCount++;

                        // 名称チェック
                        errMessage.Add(WebHains.CheckLength(Convert.ToString(i + 1) + "行目:受診項目明細", Convert.ToString(data[i]["detailname"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_DETAILNAME), Check.Necessary));

                        // 受診人数チェック
                        errMessage.Add(WebHains.CheckNumeric(Convert.ToString(i + 1) + "行目:受診人数", Convert.ToString(data[i]["totalcnt"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_TOTALCNT)));

                        // 単価チェック
                        errMessage.Add(WebHains.CheckNumericSign(Convert.ToString(i + 1) + "行目:単価", Convert.ToString(data[i]["price"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_PRICE)));

                        // 小計チェック
                        errMessage.Add(WebHains.CheckNumericSign(Convert.ToString(i + 1) + "行目:小計", Convert.ToString(data[i]["price"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_SUBTOTAL)));

                        // 消費税チェック
                        errMessage.Add(WebHains.CheckNumericSign(Convert.ToString(i + 1) + "行目:消費税", Convert.ToString(data[i]["price"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_TAX)));

                        // 値引きチェック
                        errMessage.Add(WebHains.CheckNumericSign(Convert.ToString(i + 1) + "行目:値引き", Convert.ToString(data[i]["price"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_DISCOUNT)));

                        // 合計チェック
                        errMessage.Add(WebHains.CheckNumericSign(Convert.ToString(i + 1) + "行目:合計", Convert.ToString(data[i]["price"]), Convert.ToInt32(LengthConstants.LENGTH_BILLDETAIL_TOTAL)));
                    }
                    if (inputCount == 0)
                    {
                        errMessage.Add("明細を１件以上を入力してください");
                    }
                }
                break;
            }

            // 戻り値の設定
            return errMessage;
        }

        /// <summary>
        /// 請求団体管理情報を更新する
        /// </summary>
        /// <param name="data">
        /// billno 請求書番号
        /// seq SEQ(採番)
        /// cslorgcd1 受診団体コード１
        /// cslorgcd2 受診団体コード２
        /// isrsign 健保記号
        /// </param>
        /// <param name="refSeq">(Out)SEQ(採番)</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertBillOrg(JToken data, int refSeq)
        {
            Insert ret = Insert.Error;
            string sql = "";         // SQLステートメント
            bool dataExists = true;  // TRUE：データ存在、FALSE:データなし
            int seq = 0;             // SEQ

            // 検索条件が設定されていない場合はエラー
            if (Convert.ToInt32(data["billno"]) == 0)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            using (var transaction = BeginTransaction())
            {
                try
                {
                    while (true)
                    {
                        // キー値の設定
                        var param = new Dictionary<string, object>();
                        param.Add("billno", Convert.ToInt32(data["billno"]));
                        param.Add("cslorgcd1", Convert.ToString(data["cslorgcd1"]).Trim());
                        param.Add("cslorgcd2", Convert.ToString(data["cslorgcd2"]).Trim());
                        param.Add("isrsign", Convert.ToString(data["isrsign"]).Trim());

                        // 指定された団体コード、健保記号で同一SEQがないか検索する.
                        sql = @"
                                select
                                  seq
                                from
                                  bill_org
                                where
                                  billno = :billno
                                  and cslorgcd1 = :cslorgcd1
                                  and cslorgcd2 = :cslorgcd2
                            ";

                        if ("".Equals(Convert.ToString(data["isrsign"]).Trim()))
                        {
                            sql += @"
                                    and isrsign is null
                                ";
                        }
                        else
                        {
                            sql += @"
                                    and isrsign = :isrsign
                                ";
                        }

                        dynamic current = connection.Query(sql, param).FirstOrDefault();
                        if (current == null)
                        {
                            dataExists = false;

                            // 指定された団体コード、健保記号でSEQが存在しない場合、最大SEQを取得
                            sql = @"
                                    select
                                      nvl(max(seq), 0) + 1 seq
                                    from
                                      bill_org
                                    where
                                      billno = :billno
                                ";
                            current = connection.Query(sql, param).FirstOrDefault();
                        }

                        // 戻り値の設定
                        if (current != null)
                        {
                            seq = Convert.ToInt32(current.SEQ);
                        }

                        // 同一団体、健保記号でデータ存在するならここで処理終了
                        if (dataExists)
                        {
                            ret = Insert.Normal;
                            break;
                        }

                        // 存在しないなら処理するSEQをパラメタセット
                        param.Add("seq", seq);

                        // 請求団体管理を挿入
                        sql = @"
                                insert
                                into bill_org(billno, seq, cslorgcd1, cslorgcd2, isrsign)
                                values (:billno, :seq, :cslorgcd1, :cslorgcd2, :isrsign)
                             ";

                        if (connection.Execute(sql, param) > 0)
                        {
                            ret = Insert.Normal;
                        }

                        break;
                    }

                    // SEQは戻り値として設定
                    refSeq = seq;

                    // トランザクションをコミット
                    transaction.Commit();

                    return ret;
                }
                catch
                {
                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();

                    return ret;
                }
            }
        }

        /// <summary>
        /// 請求明細を更新する
        /// </summary>
        /// <param name="data">
        /// billno 請求書番号
        /// lineno 明細No.
        /// csldate 受診日
        /// detailname 名称
        /// perid 個人ID
        /// rsvno 予約番号
        /// dayid 当日ID
        /// price 金額
        /// editprice 調整金額
        /// edittax 調整税額
        /// taxprice 税額
        /// </param>
        /// <returns>
        /// Update.Normal 正常終了
        /// Update.Error 異常終了
        /// </returns>
        public Update UpdateBillDetail(BillDetail data)
        {
            Update ret = Update.Error;  // 戻り値
            string closeDate = "";      // 締め日
            int billSeq = 0;            //請求書Seq
            int branchNo = 0;           //請求書枝番
            bool perId = false;         // TRUE:個人ID入力
            string sql = "";            // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(Convert.ToString(data.BillNo)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }
            if (data.PerId != null)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(data.PerId)))
                {
                    perId = true;
                }
            }

            // 請求書番号の妥当性チェック
            if (data.BillNo != null)
            {
                data.BillNo = Convert.ToString(data.BillNo).Trim();
                if (Util.IsNumber(Convert.ToString(data.BillNo)))
                {
                    if (Convert.ToDouble(Convert.ToString(data.BillNo)) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(Convert.ToString(data.BillNo).Length))
                        {
                            // 請求書番号を分解
                            closeDate = Convert.ToString(data.BillNo).Substring(0, 4) + "/" + Convert.ToString(data.BillNo).Substring(4, 2) + "/" + Convert.ToString(data.BillNo).Substring(6, 2);
                            billSeq = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(8, 5));
                            branchNo = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(13, 1));
                        }
                    }
                }
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", Convert.ToDateTime(data.CslDate));
            param.Add("detailname", Convert.ToString(data.DetailName).Trim());
            if (perId)
            {
                param.Add("perid", Convert.ToString(data.PerId));
            }
            param.Add("price", Convert.ToInt32(data.Price));
            param.Add("editprice", Convert.ToInt32(data.EditPrice));
            param.Add("taxprice", Convert.ToInt32(data.TaxPrice));
            param.Add("edittax", Convert.ToInt32(data.EditTax));
            param.Add("closedate", Convert.ToDateTime(closeDate));
            param.Add("billseq", Convert.ToInt32(billSeq));
            param.Add("branchno", Convert.ToInt32(branchNo));
            param.Add("lineno", Convert.ToInt32(data.LineNo));
            param.Add("rsvno", Convert.ToString(data.RsvNo));
            param.Add("dayid", Convert.ToString(data.DayId));

            // 該当キーの請求書を更新
            if (perId)
            {
                sql = @"
                        update billdetail
                        set
                          (
                            detailname
                            , price
                            , editprice
                            , taxprice
                            , edittax
                            , csldate
                            , perid
                            , lastname
                            , firstname
                            , lastkname
                            , firstkname
                          ) =
                     ";

                sql += @"
                        (
                          select
                            :detailname
                            , :price
                            , :editprice
                            , :taxprice
                            , :edittax
                            , :csldate
                            , person.perid
                            , person.lastname
                            , person.firstname
                            , person.lastkname
                            , person.firstkname
                          from
                            person
                          where
                            perid = :perid
                        )
                        ,
                    ";

                sql += @"
                        rsvno = case
                          when method = '0'
                            then to_number(:rsvno)
                          when method = '1'
                            then rsvno
                          end
                        , dayid = case
                          when method = '0'
                            then to_number(:dayid)
                          when method = '1'
                            then dayid
                          end
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                          and lineno = :lineno
                    ";
            }
            else
            {
                sql = @"
                        update billdetail
                        set
                          detailname = :detailname
                          , price = :price
                          , editprice = :editprice
                          , taxprice = :taxprice
                          , edittax = :edittax
                          , csldate = :csldate
                          , perid = ''
                          , lastname = ''
                          , firstname = ''
                          , lastkname = ''
                          , firstkname = ''
                          , rsvno = case
                            when method = 0
                              then to_number(:rsvno)
                            when method = 1
                              then rsvno
                            end
                          , dayid = case
                            when method = 0
                              then to_number(:dayid)
                            when method = 1
                              then dayid
                            end
                    ";

                sql += @"
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                          and lineno = :lineno
                    ";
            }

            if (connection.Execute(sql, param) > 0)
            {
                ret = Update.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求明細内訳を更新する
        /// </summary>
        /// <param name="data">
        /// billno 請求書番号
        /// lineno 明細No.
        /// itemno 内訳No.
        /// secondlinedivcd ２次請求明細コード
        /// price 金額
        /// editprice 調整金額
        /// edittax 調整税額
        /// taxprice 税額
        /// </param>
        /// <returns>
        /// Update.Normal 正常終了
        /// Update.Error 異常終了
        /// </returns>
        public Update UpdateBillDetail_Items(UpdateBillDetailItems data)
        {
            Update ret = Update.Error;  // 戻り値
            string closeDate = "";      // 締め日
            int billSeq = 0;            // 請求書Seq
            int branchNo = 0;           // 請求書枝番
            string sql = "";            // SQLステートメント

            // 検索条件が設定されていない場合はエラー
            if (!Util.IsNumber(Convert.ToString(data.BillNo)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }
            if (string.IsNullOrEmpty(Convert.ToString(data.LineNo)) || string.IsNullOrEmpty(Convert.ToString(data.ItemNo)))
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // 請求書番号の妥当性チェック
            if (data.BillNo != null)
            {
                data.BillNo = Convert.ToString(data.BillNo).Trim();
                if (Util.IsNumber(Convert.ToString(data.BillNo)))
                {
                    if (Convert.ToDouble(Convert.ToString(data.BillNo)) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(Convert.ToString(data.BillNo).Length))
                        {
                            // 請求書番号を分解
                            closeDate = Convert.ToString(data.BillNo).Substring(0, 4) + "/" + Convert.ToString(data.BillNo).Substring(4, 2) + "/" + Convert.ToString(data.BillNo).Substring(6, 2);
                            billSeq = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(8, 5));
                            branchNo = Convert.ToInt32(Convert.ToString(data.BillNo).Substring(13, 1));
                        }
                    }
                }
            }
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("secondlinedivcd", Convert.ToString(data.SecondLineDivCd));
            param.Add("price", Convert.ToInt32(data.Price));
            param.Add("editprice", Convert.ToInt32(data.EditPrice));
            param.Add("taxprice", Convert.ToInt32(data.TaxPrice));
            param.Add("edittax", Convert.ToInt32(data.EditTax));
            param.Add("closedate", Convert.ToDateTime(closeDate));
            param.Add("billseq", Convert.ToInt32(billSeq));
            param.Add("branchno", Convert.ToInt32(branchNo));
            param.Add("lineno", Convert.ToInt32(data.LineNo));
            param.Add("itemno", Convert.ToInt32(data.ItemNo));

            // 該当キーの請求書を更新
            sql = @"
                    update billdetail_items
                    set
                      secondlinedivcd = :secondlinedivcd
                      , price = :price
                      , editprice = :editprice
                      , taxprice = :taxprice
                      , edittax = :edittax
                 ";

            sql += @"
                     where
                       closedate = :closedate
                       and billseq = :billseq
                       and branchno = :branchno
                       and lineno = :lineno
                       and itemno = :itemno
                ";

            if (connection.Execute(sql, param) > 0)
            {
                ret = Update.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する(請求書検索)
        /// </summary>
        /// <param name="mode">取得モード(NULL:通常取得、"CNT":検索条件での請求書数を数える）</param>
        /// <param name="rec">受診者一覧
        /// billno           請求書番号
        /// closedate        締め日
        /// billseq          請求書Seq
        /// branchno         請求書枝番
        /// orgcd1           団体コード１
        /// orgcd2           団体コード２
        /// orgname          団体名
        /// orgkname         団体カナ名
        /// method           請求書作成方法
        /// prtdate          請求書出力日
        /// dispatchdate     発送日
        /// paymentdate      入金日
        /// pricetotal       小計
        /// taxtotal         税額
        /// billtotal        請求金額
        /// paymentprice     入金額
        /// sumpaymentprice  入金額合計
        /// upduser          更新者ID（入金）
        /// username         更新者名（入金）
        /// seq              Seq（入金）
        /// delflg           取消伝票フラグ
        /// billcomment      請求書コメント
        /// </param>
        /// <param name="in_StrDate">開始締め日</param>
        /// <param name="in_EndDate">終了締め日</param>
        /// <param name="in_BillNo">請求書コード</param>
        /// <param name="In_OrgCd1">団体コード１</param>
        /// <param name="In_OrgCd2">団体コード２</param>
        /// <param name="in_IsDispatch">請求書発送状態（1:発送済みのみ、2:未発送のみ）</param>
        /// <param name="in_IsPayment">入金状態（1:入金済みのみ、2:未収のみ）</param>
        /// <param name="In_IsCancel">取消伝票表示（1:表示）</param>
        /// <param name="startPos">SELECT開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="sortName">ソート項目名</param>
        /// <param name="sortType">ソート順（1:昇順、2:降順）</param>
        /// <returns>検索条件を満たすレコード件数（モードがCNTの場合、請求書枚数ベース、通常の場合レコード件数ベース）</returns>
        public int SelectDmdBurdenList(string mode,
                                       out List<dynamic> rec,
                                       DateTime? in_StrDate = null,
                                       DateTime? in_EndDate = null,
                                       string in_BillNo = null,
                                       string In_OrgCd1 = null,
                                       string In_OrgCd2 = null,
                                       int? in_IsDispatch = null,
                                       int? in_IsPayment = null,
                                       int? In_IsCancel = null,
                                       int? startPos = null,
                                       int? getCount = null,
                                       int? sortName = null,
                                       int? sortType = null)
        {
            bool isCloseDate = false;
            bool isBillNo = false;
            bool isOrgCd = false;
            bool isDispatch = false;
            bool isNoDispatch = false;
            bool isPayment = false;
            bool isNoPayment = false;
            bool isCancel = false;
            string closeDate = "";         // 締め日
            int billSeq = 0;               // 請求書Seq
            int branchNo = 0;              // 請求書枝番
            string orderPaymentDate = "";  // ソート用の入金日
            string sql = "";               // SQLステートメント
            string descAsc = "";

            if ("CNT".Equals(mode))
            {
                if ("2".Equals(Convert.ToString(sortType)))
                {
                    orderPaymentDate = "1000/01/01";

                }
                else
                {
                    orderPaymentDate = "9999/01/01";
                }
            }

            // 締め日範囲の妥当性チェック
            if (in_StrDate != null && in_EndDate != null)
            {
                isCloseDate = true;
            }

            // 請求書番号の妥当性チェック
            if (in_BillNo != null)
            {
                in_BillNo = in_BillNo.Trim();

                if (Util.IsNumber(in_BillNo))
                {
                    if (Convert.ToDouble(in_BillNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(in_BillNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = in_BillNo.Substring(0, 4) + "/" + in_BillNo.Substring(4, 2) + "/" + in_BillNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(in_BillNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(in_BillNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 締め日範囲も請求書番号も正しく指定されていない場合はエラー
            if (!isCloseDate)
            {
                if (!isBillNo)
                {
                    throw new ArgumentException();  //「プロシージャの呼び出し、または引数が不正です。」
                }
            }

            // キー値の設定
            var param = new Dictionary<string, object>();

            // 請求書番号が指定されている
            if (isBillNo)
            {
                param.Add("closedate", Convert.ToDateTime(closeDate));
                param.Add("billseq", billSeq);
                param.Add("branchno", branchNo);
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    param.Add("strdate", in_StrDate);
                    param.Add("enddate", in_EndDate);
                }
            }

            // 負担元が設定されている
            if (In_OrgCd1 != null && In_OrgCd2 != null)
            {
                if (In_OrgCd1 != "" && In_OrgCd2 != "")
                {
                    param.Add("orgcd1", In_OrgCd1.Trim());
                    param.Add("orgcd2", In_OrgCd2.Trim());
                    isOrgCd = true;
                }
            }

            // 請求書発送状態が設定されている
            if (in_IsDispatch != null)
            {
                if ("1".Equals(Convert.ToString(in_IsDispatch).Trim()))
                {
                    isDispatch = true;
                }
                if ("2".Equals(Convert.ToString(in_IsDispatch).Trim()))
                {
                    isNoDispatch = true;
                }
            }

            // 入金状態が設定されている。
            if (in_IsPayment != null)
            {
                if ("1".Equals(Convert.ToString(in_IsPayment).Trim()))
                {
                    isPayment = true;
                }
                if ("2".Equals(Convert.ToString(in_IsPayment).Trim()))
                {
                    isNoPayment = true;
                }
            }

            // 取消伝票表示
            if (In_IsCancel != null)
            {
                if ("1".Equals(Convert.ToString(In_IsCancel).Trim()))
                {
                    isCancel = true;
                }

            }

            // 取得件数と開始位置が設定されている場合
            if (Util.IsNumber(Convert.ToString(startPos)) && Util.IsNumber(Convert.ToString(getCount)))
            {
                param.Add("seq_f", startPos);
                param.Add("seq_t", (startPos + getCount - 1));
            }

            // Rownumで範囲指定するため、結果セットを丸ごとViewにする
            sql = @"select
                          base_view.*
                        from
                          (select main_view.*, rownum as rowseq from (
                ";

            sql += @"select
                          bill.closedate
                          , bill.billseq
                          , bill.branchno
                          , to_char(bill.closedate, 'YYYYMMDD') || trim(to_char(bill.billseq, '00000')) || to_char(bill.branchno)
                           as billno
                          , payment_view.seq as paymentseq
                          , bill.orgcd1
                          , bill.orgcd2
                          , bill.prtdate
                          , bill.method
                          , org.orgname
                          , org.orgkname
                          , sum_billdetail.pricetotal
                          , sum_billdetail.taxtotal
                          , sum_billdetail.pricetotal + sum_billdetail.taxtotal as billtotal
                          , last_dispatch.dispatchdate
                          , sum_payment.sum_paymentprice
                          , payment_view.seq
                          , payment_view.paymentprice
                          , payment_view.paymentdate
                          , payment_view.upduser
                          , payment_view.username
                ";

            sql += @"
                     , nvl(payment_view.paymentdate, '" + orderPaymentDate + "') as order_paymentdate ";

            sql += @"
                     , bill.delflg
                     , bill.billcomment
                        from
                          bill
                          , org
                          ,
                ";

            // 請求書明細サマリ部分
            sql += @"(
                      select
                        billdetail.closedate
                        , billdetail.billseq
                        , billdetail.branchno
                        , sum(billdetail.price) as price
                        , sum(billdetail.editprice) as editprice
                        , sum(billdetail.price) + sum(billdetail.editprice) as pricetotal
                        , sum(billdetail.taxprice) as taxprice
                        , sum(billdetail.edittax) as edittax
                        , sum(billdetail.taxprice) + sum(billdetail.edittax) as taxtotal
                      from
                        billdetail
                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          billdetail.closedate = :closedate
                          and billdetail.billseq = :billseq
                          and billdetail.branchno = :branchno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    sql += @"
                            where
                              billdetail.closedate between :strdate and :enddate
                        ";
                }
            }

            sql += @"
                    group by
                      billdetail.closedate
                      , billdetail.billseq
                      , billdetail.branchno) sum_billdetail
                      ,
                ";

            // ２次請求書明細サマリ部分
            sql += @"
                    (
                      select
                        billdetail_items.closedate
                        , billdetail_items.billseq
                        , billdetail_items.branchno
                        , sum(billdetail_items.price) as price
                        , sum(billdetail_items.editprice) as editprice
                        , sum(billdetail_items.price) + sum(billdetail_items.editprice) as pricetotal
                        , sum(billdetail_items.taxprice) as taxprice
                        , sum(billdetail_items.edittax) as edittax
                        , sum(billdetail_items.taxprice) + sum(billdetail_items.edittax) as taxtotal
                      from
                        billdetail_items
                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          billdetail_items.closedate = :closedate
                          and billdetail_items.billseq = :billseq
                          and billdetail_items.branchno = :branchno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    sql += @"
                            where
                              billdetail_items.closedate between :strdate and :enddate
                        ";
                }
            }

            sql += @"
                    group by
                      billdetail_items.closedate
                      , billdetail_items.billseq
                      , billdetail_items.branchno) sum_billdetail_items
                      ,
                ";

            // 入金情報サマリ部分
            sql += @"
                    (
                      select
                        payment.closedate
                        , payment.billseq
                        , payment.branchno
                        , sum(payment.paymentprice) as sum_paymentprice
                      from
                        payment

                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          payment.closedate = :closedate
                          and payment.billseq = :billseq
                          and payment.branchno = :branchno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    sql += @"
                            where
                              payment.closedate between :strdate and :enddate
                        ";
                }
            }

            sql += @"
                    group by
                      payment.closedate
                      , payment.billseq
                      , payment.branchno) sum_payment
                      ,
                ";

            // 入金管理部分
            sql += @"
                    (
                      select
                        payment.closedate
                        , payment.billseq
                        , payment.branchno
                        , payment.seq
                        , payment.paymentprice
                        , payment.paymentdate
                        , payment.upduser
                        , hainsuser.username
                      from
                        payment
                        , hainsuser
                      where
                        payment.upduser = hainsuser.userid
                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        and payment.closedate = :closedate
                        and payment.billseq = :billseq
                        and payment.branchno = :branchno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    sql += @"
                            and payment.closedate between :strdate and :enddate
                        ";
                }
            }

            sql += @"
                    ) payment_view
                    ,
                ";

            // 発送日最終レコード取得部分
            sql += @"
                    (
                      select
                        dispatch.closedate
                        , dispatch.billseq
                        , dispatch.branchno
                        , to_char(dispatch.dispatchdate, 'YYYY/MM/DD') as dispatchdate
                      from
                        dispatch
                      where
                        (closedate, billseq, branchno, seq) in (
                          select
                            dispatch.closedate
                            , dispatch.billseq
                            , dispatch.branchno
                            , max(dispatch.seq) as sum_paymentprice
                          from
                            dispatch
                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                        where
                          dispatch.closedate = :closedate
                          and dispatch.billseq = :billseq
                          and dispatch.branchno = :branchno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    sql += @"
                            where
                              dispatch.closedate between :strdate and :enddate
                        ";
                }
            }

            sql += @"
                    group by
                      dispatch.closedate
                      , dispatch.billseq
                      , dispatch.branchno)) last_dispatch
                ";

            // 基本部分WHERE句
            sql += @"
                    where
                      sum_payment.closedate(+) = bill.closedate
                      and sum_payment.billseq(+) = bill.billseq
                      and sum_payment.branchno(+) = bill.branchno
                      and last_dispatch.closedate(+) = bill.closedate
                      and last_dispatch.billseq(+) = bill.billseq
                      and last_dispatch.branchno(+) = bill.branchno
                      and payment_view.closedate(+) = bill.closedate
                      and payment_view.billseq(+) = bill.billseq
                      and payment_view.branchno(+) = bill.branchno
                      and sum_billdetail.closedate(+) = bill.closedate
                      and sum_billdetail.billseq(+) = bill.billseq
                      and sum_billdetail.branchno(+) = bill.branchno
                      and bill.orgcd1 = org.orgcd1
                      and bill.orgcd2 = org.orgcd2
                ";

            // T.YAGUCHI ２次金額追加
            sql += @"
                     and sum_billdetail_items.closedate(+) = bill.closedate
                     and sum_billdetail_items.billseq(+) = bill.billseq
                     and sum_billdetail_items.branchno(+) = bill.branchno
                ";

            // 請求書番号が指定されている
            if (isBillNo)
            {
                sql += @"
                         and bill.closedate = :closedate
                         and bill.billseq = :billseq
                         and bill.branchno = :branchno
                    ";
            }

            // 締め日範囲が設定されている（請求書番号がない場合のみ）
            if (isCloseDate)
            {
                if (!isBillNo)
                {
                    sql += @"
                             and bill.closedate between :strdate and :enddate
                        ";
                }
            }

            // 団体が設定されている
            if (isOrgCd)
            {
                sql += @"
                         and bill.orgcd1 = :orgcd1
                         and bill.orgcd2 = :orgcd2
                    ";
            }

            // 発送済みのみが設定されている
            if (isDispatch)
            {
                sql += @"
                         and last_dispatch.dispatchdate is not null
                    ";
            }

            // 未発送のみが設定されている
            if (isNoDispatch)
            {
                sql += @"
                         and last_dispatch.dispatchdate is null
                    ";
            }

            // 入金済みのみが設定されている
            if (isPayment)
            {
                sql += @"
                        and nvl(
                          sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl(
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                          ) - sum_payment.sum_paymentprice
                          , sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl(
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                          )
                        ) = 0
                    ";
            }

            // 未収のみが設定されている
            if (isNoPayment)
            {
                sql += @"
                        and nvl(
                          sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl(
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                          ) - sum_payment.sum_paymentprice
                          , sum_billdetail.pricetotal + sum_billdetail.taxtotal + nvl(
                            sum_billdetail_items.pricetotal + sum_billdetail_items.taxtotal
                            , 0
                          )
                        ) <> 0
                    ";
            }

            // 取消伝票も表示するが設定されていない
            if (!isCancel)
            {
                sql += @"
                        and bill.delflg = '0'
                    ";
            }

            // 基本部分ORDER BY句
            if (!"CNT".Equals(mode))
            {
                // ご要望によりソート条件追加(--;)
                if ("2".Equals(Convert.ToString(sortType)))
                {
                    descAsc = "desc";
                }
                else
                {
                    descAsc = "asc";
                }

                sql += @"
                     order by
                 ";

                if ("1".Equals(Convert.ToString(sortName)))
                {
                    sql += @"
                         bill.closedate " + descAsc;

                    sql += @"
                        , org.orgkname " + descAsc;
                }
                // ご要望によりソート条件追加(--;)
                else if ("2".Equals(Convert.ToString(sortName)))
                {
                    sql += @"
                         org.orgname
                     ";
                }
                else if ("3".Equals(Convert.ToString(sortName)))
                {
                    // ご要望によりソート条件追加(--;)
                    sql += @"
                         org.orgkname " + descAsc;

                    sql += @"
                          , bill.closedate " + descAsc;
                }
                else if ("4".Equals(Convert.ToString(sortName)))
                {
                    // ご要望によりソート条件追加(--;)
                    sql += @"
                         order_paymentdate " + descAsc;

                    sql += @"
                        , org.orgkname " + descAsc;

                    sql += @"
                        , bill.closedate " + descAsc;
                }
                else
                {
                    sql += @"
                         billno " + descAsc;
                }
            }

            sql += @"
                    ) main_view) base_view
                ";

            // 取得件数と開始位置が設定されている場合
            if (startPos != null && getCount != null)
            {
                if (Util.IsNumber(Convert.ToString(startPos)) && Util.IsNumber(Convert.ToString(getCount))
                    && Convert.ToString(startPos).Trim() != "" && Convert.ToString(getCount).Trim() != "")
                {
                    sql += @"
                            where
                              base_view.rowseq between :seq_f and :seq_t
                        ";
                }
            }

            // 件数取得モード、かつ受診団体指定モードでない場合、請求書の枚数を返す
            if (mode.Equals("CNT"))
            {
                rec = null;
                return connection.Query(sql, param).Count();
            }

            // 戻り値の設定
            rec = connection.Query(sql, param).ToList();
            return rec.Count();
        }

        /// <summary>
        /// 個人受診金額情報の読み込み
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="existsZeroData">1:\0データも取得する。</param>
        /// <param name="sort">ソート順</param>
        /// <returns>個人受診金額情報
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// orgname            団体名
        /// orgdiv             団体種別
        /// cscd               コースコード
        /// csname             コース名
        /// dmdlineclasscd     請求明細分類コード
        /// dmdlineclassname   請求明細分類名
        /// sumdetails         健診基本料集計区分
        /// agediv             年齢区分
        /// price              金額
        /// editprice          調整金額
        /// priceseq           ＳＥＱ
        /// taxprice           税額
        /// edittax            調整税額
        /// </returns>
        public List<dynamic> SelectConsult_mList(int rsvNo, string sort, string existsZeroData)
        {
            string sql = "";  // SQLステートメント
            var param = new Dictionary<string, object>();

            // キー値の設定
            param.Add("rsvno", rsvNo);

            // SORTキーオプションがないなら空白セット
            if (string.IsNullOrEmpty(sort))
            {
                sort = "";
            }

            // 指定された予約番号の受診金額情報を取得
            sql = @"
                    select
                      consult_m.orgcd1
                      , consult_m.orgcd2
                      , org.orgname
                      , org.orgdiv
                      , consult_m.cscd
                      , course_p.csname
                      , consult_m.dmdlineclasscd
                      , dmdlineclass.dmdlineclassname
                      , consult_m.sumdetails
                      , consult_m.agediv
                      , consult_m.price
                      , consult_m.editprice
                      , consult_m.priceseq
                      , consult_m.taxprice
                      , consult_m.edittax
                    from
                      dmdlineclass
                      , course_p
                      , org
                      , consult_m
                    where
                      consult_m.rsvno = :rsvno
                      and org.orgcd1 = consult_m.orgcd1
                      and org.orgcd2 = consult_m.orgcd2
                      and course_p.cscd = consult_m.cscd
                      and dmdlineclass.dmdlineclasscd = consult_m.dmdlineclasscd
                  ";

            // \0データの判断（デフォルトは取得しない）
            if (!"1".Equals(existsZeroData))
            {
                sql += @"
                        and (
                          consult_m.price != 0
                          or consult_m.editprice != 0
                        )
                    ";
            }

            // SORT順指定を設定
            if ("2".Equals(sort))
            {
                // 2の場合、コース、負担元、請求明細分類でSort
                sql += @"
                        order by
                          consult_m.cscd
                          , org.orgdiv desc
                          , consult_m.orgcd1
                          , consult_m.orgcd2
                          , consult_m.dmdlineclasscd
                    ";
            }
            else if ("3".Equals(sort))
            {
                // 3の場合、請求明細分類、負担元、コースでSort
                sql += @"
                        order by
                          consult_m.dmdlineclasscd
                          , org.orgdiv desc
                          , consult_m.orgcd1
                          , consult_m.orgcd2
                          , consult_m.cscd
                    ";
            }
            else
            {
                // 1、もしくは負担元指定の場合、負担元、コース、請求明細分類でSort
                sql += @"
                        order by
                          org.orgdiv desc
                          , consult_m.orgcd1
                          , consult_m.orgcd2
                          , consult_m.cscd
                          , consult_m.dmdlineclasscd
                    ";
            }

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人受診金額情報の読み込み
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>個人受診金額情報
        /// orgcd1             団体コード１
        /// orgcd2             団体コード２
        /// orgseq             契約パターンＳＥＱ
        /// orgname            団体名
        /// price              金額
        /// editprice          調整金額
        /// taxprice           税額
        /// edittax            調整税額
        /// linetotal          金額小計
        /// priceseq           受診金額ＳＥＱ
        /// crtptcd            契約パターンコード
        /// opt                オプション番号
        /// optbranchno        オプション枝番
        /// optname            オプション名称
        /// otherlinedivcd     セット外明細区分
        /// linename           請求明細名称
        /// dmddate            請求日
        /// billseq            請求書Ｓｅｑ
        /// branchno           請求書枝番
        /// billlineno         請求書明細行Ｎｏ
        /// paymentdate        入金日
        /// paymentseq         入金Ｓｅｑ
        /// omittaxflg         消費税免除フラグ
        /// printdate          領収書印刷日
        /// </returns>
        public List<dynamic> SelectConsult_mInfo(int rsvNo)
        {
            string sql = "";  // SQLステートメント
            var param = new Dictionary<string, object>();

            // キー値の設定
            param.Add("rsvno", rsvNo);

            // 指定された予約番号の受診金額情報を取得
            sql = @"
                    select
                      main.orgcd1
                      , main.orgcd2
                      , main.orgseq
                      , main.orgname
                      , main.price
                      , main.editprice
                      , main.taxprice
                      , main.edittax
                      , main.linetotal
                      , main.priceseq
                      , main.ctrptcd
                      , main.optcd
                      , main.optbranchno
                      , main.ctrpt_optname
                      , main.otherlinedivcd
                      , main.linename
                      , main.dmddate
                      , main.billseq
                      , main.branchno
                      , main.billlineno
                      , main.omittaxflg
                      , perbill.paymentdate
                      , perbill.paymentseq
                      , perbill.printdate
                ";

            sql += @"
                    from
                      perbill
                      , (
                        select
                          mainview.orgcd1
                          , mainview.orgcd2
                          , mainview.orgseq
                          , mainview.orgname
                          , mainview.price
                          , mainview.editprice
                          , mainview.taxprice
                          , mainview.edittax
                          , mainview.linetotal
                          , mainview.priceseq
                          , mainview.ctrptcd
                          , mainview.optcd
                          , mainview.optbranchno
                          , mainview.ctrpt_optname
                          , mainview.otherlinedivcd
                          , mainview.dmddate
                          , mainview.billseq
                          , mainview.branchno
                          , mainview.billlineno
                          , mainview.omittaxflg
                          ,
                ";

            sql += @"
                    case
                      when mainview.linename is not null
                        then mainview.linename
                      when ctrpt_price.billprintname is not null
                        then ctrpt_price.billprintname
                      else mainview.optname
                      end linename
                ";

            sql += @"
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
                          , ctrpt_opt.optname ctrpt_optname
                          , consult_m.otherlinedivcd
                          , consult_m.dmddate
                          , consult_m.billseq
                          , consult_m.branchno
                          , consult_m.billlineno
                          , consult_m.omittaxflg
                          , nvl(
                            ctrpt_opt.optname
                            , otherlinediv.otherlinedivname
                          ) optname
                          , consult_m.linename
                ";

            sql += @"
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
                          consult.rsvno = :rsvno
                          and ctrpt_org.ctrptcd = consult.ctrptcd
                      ) orgseqview
                      , ctrpt_opt
                      , org
                      , consult_m
                    where
                      consult_m.rsvno = :rsvno
                      and org.orgcd1 = consult_m.orgcd1
                      and org.orgcd2 = consult_m.orgcd2
                      and consult_m.ctrptcd = ctrpt_opt.ctrptcd(+)
                      and consult_m.optcd = ctrpt_opt.optcd(+)
                      and consult_m.optbranchno = ctrpt_opt.optbranchno(+)
                      and orgseqview.orgcd1 = consult_m.orgcd1
                      and orgseqview.orgcd2 = consult_m.orgcd2
                      and consult_m.otherlinedivcd = otherlinediv.otherlinedivcd(+)) mainview
                ";

            sql += @"
                    where
                      mainview.ctrptcd = ctrpt_price.ctrptcd(+)
                      and mainview.optcd = ctrpt_price.optcd(+)
                      and mainview.optbranchno = ctrpt_price.optbranchno(+)
                      and mainview.orgseq = ctrpt_price.seq(+)
                    order by
                      mainview.orgseq
                      , mainview.priceseq) main
                    where
                      main.dmddate = perbill.dmddate(+)
                      and main.billseq = perbill.billseq(+)
                      and main.branchno = perbill.branchno(+)
                ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人毎の締め処理状態の読み込み
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>個人受診金額小計
        /// orgcd1        団体コード１
        /// orgcd2        団体コード２
        /// subprice      金額小計
        /// subeditprice  調整金額小計
        /// subtaxprice   税額小計
        /// subedittax    調整税額小計
        /// sublinetotal  小計（金額＋調整金額＋税額＋調整税額）
        /// </returns>
        public List<dynamic> SelectConsult_mTotal(int rsvNo)
        {
            string sql = "";  // SQLステートメント
            var param = new Dictionary<string, object>();

            // キー値の設定
            param.Add("rsvno", rsvNo);

            // 指定された予約番号の受診金額小計を取得
            sql = @"
                    select
                      consult_m.orgcd1
                      , consult_m.orgcd2
                      , sum(consult_m.price) subprice
                      , sum(consult_m.editprice) subeditprice
                      , sum(consult_m.taxprice) subtaxprice
                      , sum(consult_m.edittax) subedittax
                      , sum(consult_m.price) + sum(consult_m.editprice) + sum(consult_m.taxprice) + sum(consult_m.edittax) sublinetotal
                    from
                      consult_m
                    where
                      consult_m.rsvno = :rsvno
                    group by
                      consult_m.orgcd1
                      , consult_m.orgcd2
                ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人毎の締め処理状態の読み込み
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>個人毎の締め処理状態
        /// orgcd1     団体コード１
        /// orgcd2     団体コード２
        /// orgname    団体名
        /// closedate  締め日
        /// billseq    SEQ
        /// branchno   枝番
        /// </returns>
        public List<dynamic> SelectPersonalCloseMngInfo(int rsvNo)
        {
            string sql = "";  // SQLステートメント
            var param = new Dictionary<string, object>();

            // キー値の設定
            param.Add("rsvno", rsvNo);

            // 指定された予約番号の締め管理情報を取得（個人負担分は除外）
            sql = @"
                    select
                      baseinfo.orgcd1
                      , baseinfo.orgcd2
                      , org.orgname
                      , closemng.closedate
                      , closemng.billseq
                      , closemng.branchno
                    from
                      org
                      , closemng
                      , (
                        select distinct
                          consult_m.orgcd1
                          , consult_m.orgcd2
                        from
                          consult_m
                        where
                          consult_m.rsvno = :rsvno
                          and consult_m.orgcd1 != 'XXXXX'
                          and consult_m.orgcd2 != 'XXXXX'
                        union
                        select distinct
                          closemng.orgcd1
                          , closemng.orgcd2
                        from
                          closemng
                        where
                          closemng.rsvno = :rsvno
                          and closemng.orgcd1 != 'XXXXX'
                          and closemng.orgcd2 != 'XXXXX'
                      ) baseinfo
                    where
                      :rsvno = closemng.rsvno(+)
                      and baseinfo.orgcd1 = closemng.orgcd1(+)
                      and baseinfo.orgcd2 = closemng.orgcd2(+)
                      and org.orgcd1 = baseinfo.orgcd1
                      and org.orgcd2 = baseinfo.orgcd2
                    order by
                      baseinfo.orgcd1
                      , baseinfo.orgcd2
                ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人受診金額の調整金額を更新する
        /// </summary>
        /// <param name="data">
        /// rsvno 予約番号
        /// priceseq ＳＥＱ
        /// editprice 調整金額
        /// edittax 調整税額
        /// </param>
        /// <returns>
        /// Update.Normal 正常終了
        /// Update.Error 異常終了
        /// </returns>
        private Update RegistConsult_mEditPrice(JToken data)
        {
            Update ret = Update.Error;  // 戻り値
            string sql = "";            // SQLステートメント

            List<JToken> items = data.ToObject<List<JToken>>();

            // パラメーター値設定
            var paramArray = new List<Dictionary<string, object>>();

            foreach (var rec in items)
            {
                var param = new Dictionary<string, object>();
                param.Add("rsvno", Convert.ToString(rec["rsvNo"]));
                param.Add("priceseq", Convert.ToString(rec["priceSeq"]));
                param.Add("editprice", (Convert.ToString(rec["editPrice"]).Trim() == "" ? "0" : Convert.ToString(rec["editPrice"])));
                param.Add("edittax", (Convert.ToString(rec["editTax"]).Trim() == "" ? "0" : Convert.ToString(rec["editTax"])));

                paramArray.Add(param);
            }

            // 更新
            sql = @"
                   update consult_m
                    set
                      editprice = :editprice
                      , edittax = :edittax
                    where
                      rsvno = :rsvno
                      and priceseq = :priceseq
                ";

            if (connection.Execute(sql, paramArray) > 0)
            {
                ret = Update.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 追加検査項目負担金を更新する
        /// </summary>
        /// <param name="inBillNo">請求書番号</param>
        /// <param name="billComment">請求書番号</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool UpdateDmdBill_comment(string inBillNo, string billComment)
        {

            string sql = "";          // SQLステートメント
            string closeDate = "";    // 締め日
            int billSeq = 0;          // 請求書Seq
            int branchNo = 0;         // 請求書枝番
            bool isBillNo = false;    // TRUE:請求書番号が指定されている
            int ret = 0;
            bool updateSucc = false;  //戻り値

            // 請求書番号の妥当性チェック
            if (!string.IsNullOrEmpty(inBillNo))
            {
                inBillNo = inBillNo.Trim();

                if (Util.IsNumber(inBillNo))
                {
                    if (Convert.ToDouble(inBillNo) > 0)
                    {
                        if (LENGTH_BILLNO.Equals(inBillNo.Length))
                        {
                            // 請求書番号を分解
                            closeDate = inBillNo.Substring(0, 4) + "/" + inBillNo.Substring(4, 2) + "/" + inBillNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(inBillNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(inBillNo.Substring(13, 1));
                            if (DateTime.TryParse(closeDate, out DateTime tmpcloseDate))
                            {
                                isBillNo = true;
                            }
                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            // キー及び更新値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("closedate", closeDate.Trim());
            sqlParam.Add("billseq", billSeq);
            sqlParam.Add("branchno", branchNo);
            sqlParam.Add("billcomment", billComment);

            // 請求書テーブル 請求書コメントの更新
            sql = @"
                    update bill
                        set
                        billcomment = :billcomment
                    where
                        bill.closedate = :closedate
                        and bill.billseq = :billseq
                        and bill.branchno = :branchno
                ";

            ret = connection.Execute(sql, sqlParam);

            if (ret > 0)
            {
                updateSucc = true;
            }

            // 戻り値の設定
            return updateSucc;
        }

        #region "新設メソッド"
        /// <summary>
        /// 請求書コメントの妥当性チェックを行う
        /// </summary>
        /// <param name="billComment">請求書番号</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateBillComment(string billComment)
        {
            var messages = new List<string>();

            //グループ未入力チェック
            string message = WebHains.CheckWideValue("請求書コメント", billComment, 100);
            if (message != null)
            {
                messages.Add(message);
            }

            return messages;
        }

        /// <summary>
        /// 種別毎の選択状況チェック
        /// </summary>
        /// <param name="paymentDiv">入金種別</param>
        /// <param name="registerNo">レジ番号</param>
        /// <param name="cash">現金</param>
        /// <param name="paymentPrice">入金額</param>
        /// <param name="cardKind">カード種別</param>
        /// <param name="creditslipNo">伝票No</param>
        /// <param name="bankCode">金融機関コード</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidatePaymentDiv(string paymentDiv, string registerNo, string cash, string paymentPrice, string cardKind, string creditslipNo, string bankCode)
        {
            var messages = new List<string>();

            //入金種別が振込みでもその他でもない場合は、レジ番号必須
            if (!paymentDiv.Equals("3") && !paymentDiv.Equals("7") && string.IsNullOrEmpty(registerNo))
            {
                messages.Add("「振込み」、「その他」以外の入金種別が選択された場合、レジ番号は必須です。");
            }

            //入金種別が現金の場合
            if (paymentDiv.Equals("1"))
            {
                while (true)
                {
                    //金額がセットされていないなら、0セット
                    if (string.IsNullOrEmpty(cash))
                    {
                        cash = "0";
                    }
                    if (WebHains.CheckNumericWithSign("入金額", cash, 8, Check.Necessary)!= null) {
                        //金額の値チェック
                        messages.Add(WebHains.CheckNumericWithSign("入金額", cash, 8, Check.Necessary));
                    }
                   
                    if (Information.IsArray(messages))
                    {
                        break;
                    }
                    //入金額に達していないなら、エラー

                    if (Convert.ToDouble(cash) < Convert.ToDouble(paymentPrice))
                    {
                        messages.Add("入金額が請求額に達していません。");
                    }
                    break;
                }
            }
            else
            {
                //入金種別が現金でないなら、現金フィールドはクリア
                cash = "";
            }

            //振込みなら、レジ番号をクリア
            if (paymentDiv.Equals("3"))
            {
                registerNo = "";
            }

            if (paymentDiv.Equals("5"))
            {
                if (string.IsNullOrEmpty(cardKind))
                {
                    messages.Add("カード種別を選択して下さい。");
                }
                    if (WebHains.CheckNumeric("伝票No.", creditslipNo, 5, Check.Necessary)!= null) {
                        messages.Add(WebHains.CheckNumeric("伝票No.", creditslipNo, 5, Check.Necessary));
                    }
            }

            if (paymentDiv.Equals("6"))
            {
                if (string.IsNullOrEmpty(bankCode))
                {
                    messages.Add("金融機関を選択して下さい。");
                }
            }

            return messages;
        }

        /// <summary>
    /// 請求書コメントチェック
    /// </summary>
    /// <param name="data">２次請求明細コード</param>
    /// <returns>エラーがあればエラーメッセージを返す</returns>
    public List<string> ValidateBillDetailItems(UpdateBillDetailItems data)
    {
      var messages = new List<string>();

      //請求書コメントチェック
      if (string.IsNullOrEmpty(Convert.ToString(data.SecondLineDivCd)))
      {
        messages.Add("請求詳細名が入力されていません。");
      }
      if (WebHains.CheckNumericWithSign("請求金額", Convert.ToString(data.Price), 7) != null)
      {
        messages.Add(WebHains.CheckNumericWithSign("請求金額", Convert.ToString(data.Price), 7));
      }
      if (WebHains.CheckNumericWithSign("調整金額", Convert.ToString(data.EditPrice), 7) != null)
      {
        messages.Add(WebHains.CheckNumericWithSign("調整金額", Convert.ToString(data.EditPrice), 7));
      }
      if (WebHains.CheckNumericWithSign("消費税", Convert.ToString(data.TaxPrice), 7) != null)
      {
        messages.Add(WebHains.CheckNumericWithSign("消費税", Convert.ToString(data.TaxPrice), 7));
      }
      if (WebHains.CheckNumericWithSign("調整税額", Convert.ToString(data.EditTax), 7) != null)
      {
        messages.Add(WebHains.CheckNumericWithSign("調整税額", Convert.ToString(data.EditTax), 7));
      }
      return messages;
    }


        /// <summary>
        /// 請求明細保存処理チェック
        /// </summary>
        /// <param name="data"></param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateBillDetail(BillDetail data)
        {
            var messages = new List<string>();
            string strYear = Convert.ToString(data.StrYear);
            string strMonth = Convert.ToString(data.StrMonth);
            string strDay = Convert.ToString(data.StrDay);
            DateTime? strymd = new DateTime();

            //請求書コメントチェック
            if (string.IsNullOrEmpty(Convert.ToString(data.DetailName)))
            {
                messages.Add("請求詳細名が入力されていません。");
            }

            //未設定時はシステム日付
            if (string.IsNullOrEmpty(Convert.ToString(data.LineNo)))
            {
                if (string.IsNullOrEmpty(Convert.ToString(data.StrYear)))
                {
                    strYear = Convert.ToString(DateTime.Now.Year);
                }
                if (string.IsNullOrEmpty(Convert.ToString(data.StrMonth)))
                {
                    strMonth = Convert.ToString(DateTime.Now.Month);
                }
                if (string.IsNullOrEmpty(Convert.ToString(data.StrDay)))
                {
                    strDay = Convert.ToString(DateTime.Now.Day);
                }
            }
            messages.Add(WebHains.CheckDate("受診日", strYear, strMonth, strDay, out strymd, Check.Necessary));
            messages.Add(WebHains.CheckWideValue("請求詳細名", Convert.ToString(data.DetailName), 30));
            messages.Add(WebHains.CheckNumeric("当日ID", Convert.ToString(data.DayId), 5));
            messages.Add(WebHains.CheckNumeric("予約番号", Convert.ToString(data.RsvNo), 9));
            messages.Add(WebHains.CheckNumericWithSign("請求金額", Convert.ToString(data.Price), 7));
            messages.Add(WebHains.CheckNumericWithSign("調整金額", Convert.ToString(data.EditPrice), 7));
            messages.Add(WebHains.CheckNumericWithSign("消費税", Convert.ToString(data.TaxPrice), 7));
            messages.Add(WebHains.CheckNumericWithSign("調整税額", Convert.ToString(data.EditTax), 7));

            return messages;
        }

        /// <summary>
        /// 請求書番号を分解する
        /// </summary>
        /// <param name="billNo">請求書番号</param>
        /// <param name="closeDate">締め日</param>
        /// <param name="billSeq">請求書Seq</param>
        /// <param name="branchNo">請求書枝番</param>
        /// <returns>True: 請求書番号分解</returns>
        private bool SplitBillNo(string billNo, out DateTime? closeDate, out int billSeq, out int branchNo)
        {
            closeDate = null;   // 締め日
            billSeq = 0;        // 請求書Seq
            branchNo = 0;       // 請求書枝番

            // 請求書番号の妥当性チェック
            if (string.IsNullOrEmpty(billNo))
            {
                return false;  // 「プロシージャの呼び出し、または引数が不正です。」
            }
            else
            {
                if (!Util.IsNumber(billNo))
                {
                    return false;  // 「プロシージャの呼び出し、または引数が不正です。」
                }
                if (!LENGTH_BILLNO.Equals(billNo.Length))
                {
                    return false;  // 「プロシージャの呼び出し、または引数が不正です。」
                }
            }

            // 請求書番号を分解
            int closeYear = Convert.ToInt32("0" + billNo.Substring(0, 4));
            int closeMonth = Convert.ToInt32("0" + billNo.Substring(4, 2));
            int closeDay = Convert.ToInt32("0" + billNo.Substring(6, 2));

            // 請求書Seq
            billSeq = Convert.ToInt32(billNo.Substring(8, 5));

            // 請求書枝番
            branchNo = Convert.ToInt32(billNo.Substring(13, 1));

            // 検索条件が設定されていない場合はエラー
            if (billSeq == 0)
            {
                return false;  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            try
            {
                // 締め日
                closeDate = new DateTime(closeYear, closeMonth, closeDay);
            }
            catch
            {
                return false;  // 「プロシージャの呼び出し、または引数が不正です。」
            }

            return true;
        }
        #endregion "新設メソッド"

    }
}