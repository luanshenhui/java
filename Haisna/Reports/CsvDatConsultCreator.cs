using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class CsvDatConsultCreator : CsvCreator
    {

        // 汎用データ抽出検査項目指定モード
        const string CASE_NOTSELECT = "notselect";  // 検査結果を抽出しない
        const string CASE_ALLSELECT = "allselect";  // すべての検査結果を抽出する
        const string CASE_SELECT = "select";        // 抽出する項目を指定する

        // 汎用データ抽出指定条件記号
        const string OPTION_EQ = "1";   // ｢と同じ｣
        const string OPTION_GE = "2";   // ｢以上｣
        const string OPTION_LE = "3";   // ｢以下｣

        // チェックボックスのチェック時の値
        const string CHK_ON = "1";

        // 総合判定の1件あたりの項目数
        const int JUDCLASSROW = 3;

        private string sAge = "";
        private string eAge = "";
        private string[] rslCondition = { };
        private int?[] weightFrom = { };
        private int?[] weightTo = { };
        private string[] judCondition = { };
        private Gender gender;
        private int judOperation;
        private int judAll;
        private int?[] judClassCd;
        private string[] judMarkFrom;
        private string[] judMarkTo;
        private string[] itemCd;
        private string[] suffix;
        private string[] rslValueFrom;
        private string[] rslMarkFrom;
        private string[] rslValueTo;
        private string[] rslMarkTo;
        private string[] selItemCd;
        private string[] selSuffix;
        private string pOutItem;
        private string chkOption;

        /// <summary>
        /// 判定分類情報データアクセスオブジェクト
        /// </summary>
        //readonly JudClassDao judClassDao;

        /// <summary>
        /// 出力対象項目情報クラス
        /// </summary>
        public class DispItem
        {
            public string itemCd { get; set; }
            public string itemName { get; set; }
        }

        /// <summary>
        /// 条件項目情報クラス
        /// </summary>
        public class ConItem
        {
            public string itemCd { get; set; }
            public string itemName { get; set; }
        }

        /// <summary>
        /// 結果、判定抽出データを読み込み
        /// </summary>
        /// <returns>結果、判定抽出データ</returns>
        protected override List<dynamic> GetData()
        {

            //パラメータ設定
            string csCd = queryParams["cscd"];
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strdate", queryParams["startdate"]);
            param.Add("enddate", queryParams["enddate"]);
            param.Add("cscd", csCd.Trim());
            param.Add("orgcd1", orgCd1.Trim());
            param.Add("orgcd2", orgCd2.Trim());
            param.Add("strage", sAge);
            param.Add("endage", eAge);
            param.Add("cancelflg", ConsultCancel.Used);
            param.Add("gender", gender);
            param.Add("delflg", DelFlg.Used);

            // SQL文の編集
            var sql = @"
                select
                    consult.rsvno
                from
                    person
                    , consult
            ";

            sql += @"
                where
                    consult.csldate >= :strdate
                    and consult.csldate <= :enddate
            ";

            // コースコード指定時
            if (!string.IsNullOrEmpty(csCd.Trim()))
            {
                sql += @"
                    and consult.cscd = :cscd
                ";
            }

            // 団体コード指定時
            if (!string.IsNullOrEmpty(orgCd1.Trim()) || !string.IsNullOrEmpty(orgCd2.Trim()))
            {
                sql += @"
                    and consult.orgcd1 = :orgcd1
                    and consult.orgcd2 = :orgcd2
                ";
            }

            // 受診時年齢（範囲）
            sql += @"
                    and consult.age >= :strage
                    and consult.age <= :endage
            ";

            // キャンセルフラグ(「使用中」)
            sql += @"
                    and consult.cancelflg = :cancelflg
            ";

            // 受診情報と個人情報との結合
            sql += @"
                    and consult.perid = person.perid
            ";

            // 性別指定時
            if (gender != Gender.Both)
            {
                sql += @"
                    and person.gender = :gender
                ";
            }

            // 削除フラグ(「使用中」)
            sql += @"
                    and person.delflg = :delflg
            ";

            string operation; // 演算子
            bool hasCondition = false; // 演算子指定有無
            bool addFlg = false; // 追加フラグ

            // 総合判定条件での絞込み
            for (var i = 0; i < judCondition.Length; i++)
            {
                // 絞込条件が設定されているとき
                if (!string.IsNullOrEmpty(judCondition[i]))
                {
                    // 初めて条件を追加する場合
                    if (!hasCondition)
                    {
                        sql += "   and ( ";
                        hasCondition = true;
                    }

                    // ２つ目以降の条件に対しては演算子を指定
                    operation = "";
                    if (addFlg)
                    {
                        operation = (judOperation == 0) ? "and" : "or";
                    }

                    string paramJudClassCd = "jusclasscd" + i.ToString();
                    param.Add(paramJudClassCd, judClassCd[i]);

                    // 条件文の追加
                    sql += operation + @"
                        exists (
                            select
                                judrsl.rsvno
                            from
                                jud
                                , judrsl
                            where
                                judrsl.rsvno = consult.rsvno
                                and judrsl.judclasscd = :" + paramJudClassCd + @"
                                and judrsl.judcd = jud.judcd
                    ";

                    string paramWeightFrom = "weightfrom" + i.ToString();
                    string paramWeightTo = "weightto" + i.ToString();

                    // 判定結果の範囲指定
                    if ((weightFrom[i] != null) && (weightTo[i] != null))
                    {
                        // FROM側、TO側ともに指定されているとき
                        sql += " and jud.weight between :" + paramWeightFrom + " and :" + paramWeightTo;
                        param.Add(paramWeightFrom, weightFrom[i]);
                        param.Add(paramWeightTo, weightTo[i]);

                    }
                    else if (weightFrom[i] != null)
                    {
                        // FROM側にのみ指定されているとき
                        param.Add(paramWeightFrom, weightFrom[i]);
                        switch (judMarkFrom[i])
                        {
                            case OPTION_EQ:
                                sql += " and jud.weight  = :" + paramWeightFrom;
                                break;

                            case OPTION_GE:
                                sql += " and jud.weight >= :" + paramWeightFrom;
                                break;

                            case OPTION_LE:
                                sql += " and jud.weight <= :" + paramWeightFrom;
                                break;
                        }
                    }
                    else
                    {
                        // TO側にのみ指定されているとき
                        param.Add(paramWeightTo, weightTo[i]);
                        switch (judMarkTo[i])
                        {
                            case OPTION_EQ:
                                sql += " and jud.weight  = :" + paramWeightTo;
                                break;

                            case OPTION_GE:
                                sql += " and jud.weight >= :" + paramWeightTo;
                                break;

                            case OPTION_LE:
                                sql += " and jud.weight <= :" + paramWeightTo;
                                break;

                        }
                    }

                    sql += " ) ";

                    addFlg = true;
                }
            }

            if (hasCondition)
            {
                sql += " ) ";
            }

            // 検査結果条件での絞込み
            for (var i = 0; i < rslCondition.Length; i++)
            {
                // 絞込条件が設定されているとき
                if (!string.IsNullOrEmpty(rslCondition[i]))
                {
                    string paramItemCd = "itemcd" + i.ToString();
                    string paramSuffix = "suffix" + i.ToString();
                    param.Add(paramItemCd, itemCd[i]);
                    param.Add(paramSuffix, suffix[i]);

                    // 条件文の追加
                    sql += @"
                        and exists (
                            select
                                rsl.rsvno
                            from
                                rsl
                            where
                                rsl.rsvno = consult.rsvno
                                and rsl.itemcd = :" + paramItemCd + @"
                                and rsl.suffix = :" + paramSuffix + @"
                        )
                    ";
                }
            }

            // ORDER BY句の指定
            sql += @"
                order by
                    consult.csldate
                    , consult.cscd
                    , consult.orgcd1
                    , consult.orgcd2
                    , consult.perid
            ";

            return CreateCsvFile(connection.Query(sql, param).ToList());
        }


        private List<dynamic> CreateCsvFile(List<dynamic> data)
        {
            bool cslPerFlg; // 受診歴情報および個人情報の抽出対象有無フラグ
            int rslCount; // 検査結果で2次抽出した検査結果レコード件数
            int rsvNoCount; // 抽出対象となるRsvNoの件数
            int judRslMax; // 抽出されたRsvNoに対する総合判定の最大件数
            int rslMax; // 抽出されたRsvNoに対する検査結果の最大件数
            string lineRsl; // 検査項目部の出力文字列
            string headerName = "header";
            string line; // 出力文字列(1行)
            string lineCslPer = null; // 受診歴情報、個人情報部の出力文字列
            string lineJudRsl = null; // 総合判定部の出力文字列

            var judClassDao = new JudClassDao(connection);
            var consultDao = new ConsultDao(connection, null, null, null, null, null, null);
            var returnData = new List<dynamic>();

            var resultData = new List<dynamic>(); // 検査結果データ
            var tempData = new List<string>();

            // 該当データが無かったとき処理終了
            if (data.Count == 0)
            {
                return returnData;
            }

            // 初期処理
            judRslMax = 0;
            rslMax = 0;

            // 受診歴情報と個人情報が指定されているとき、抽出対象有無フラグの設定
            if (Util.ConvertToString(queryParams["csldate"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["course"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["age"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["jud"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["perid"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["name"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["birth"]).Equals(CHK_ON) ||
               Util.ConvertToString(queryParams["chkgender"]).Equals(CHK_ON))
            {
                cslPerFlg = true;
            }
            else
            {
                cslPerFlg = false;
            }

            if (pOutItem.Equals(CASE_ALLSELECT))
            {
                // グループ９９９の検査項目を取得し、検査項目配列に設定
                consultDao.SelectAllRslItem(out selItemCd, out selSuffix);
                // 検査項目指定に置き換える
                pOutItem = CASE_SELECT;
            }

            // 検査結果条件による抽出予約番号の絞込み、および検査結果データ行の編集
            rsvNoCount = 0;
            var rsvNo2 = new List<int>(); // 検査結果条件で絞り込まれた抽出対象となるRsvNoの配列


            // 検査結果条件による抽出予約番号の絞込み、および検査結果データ行の編集
            foreach (IDictionary<string, object> rec in data)
            {
                IList<string> results = consultDao.SelectDatRsl(
                                int.Parse(Util.ConvertToString(rec["RSVNO"])),
                                pOutItem,
                                chkOption,
                                itemCd,
                                suffix,
                                rslValueFrom,
                                rslMarkFrom,
                                rslValueTo,
                                rslMarkTo,
                                rslCondition,
                                selItemCd,
                                selSuffix,
                                out bool rsvNoSkipFlg,
                                out rslCount
                            );

                // 検査結果の抽出条件に合致しなければ該当予約番号の以降の処理をスキップ
                if (rsvNoSkipFlg)
                {
                    continue;
                }

                //// 行データ
                //var mainDic = new Dictionary<string, object>();

                // RsvNoの格納
                rsvNo2.Add(int.Parse(Util.ConvertToString(rec["RSVNO"])));
                rsvNoCount = rsvNoCount + 1;

                // 検査結果が抽出対象となっているとき抽出データの編集処理
                if (!pOutItem.Equals(CASE_NOTSELECT))
                {
                    // 検査結果抽出データが存在するとき出力文字列を編集、無ければ空文字行をセット
                    if (results != null && results.Count > 0)
                    {
                        lineRsl = string.Join(",", results);
                    }
                    else
                    {
                        lineRsl = "";
                    }

                    // 作業ファイルに出力
                    tempData.Add(lineRsl);

                    // 抽出データ件数の最大値チェック・更新
                    if (rslCount > rslMax)
                    {
                        rslMax = rslCount;
                    }
                }
            }

            // 該当データが無かったとき処理終了
            if (rsvNo2.Count == 0)
            {
                return returnData;
            }

            // 総合判定が抽出データとして指定されているとき
            if (Util.ConvertToString(queryParams["jud"]).Equals(CHK_ON))
            {
                // 総合判定件数の最大値を取得
                IList<dynamic> judClasses = judClassDao.SelectJudClassList();
                judRslMax = judClasses.Count;
            }

            // 見出し行の編集、およびファイル出力
            string headerline = "";

            // 受診歴情報および個人情報部
            if (cslPerFlg)
            {
                if (Util.ConvertToString(queryParams["csldate"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "受診日";
                }
                if (Util.ConvertToString(queryParams["course"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "コースコード";
                }
                if (Util.ConvertToString(queryParams["age"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "受診時年齢";
                }
                if (Util.ConvertToString(queryParams["perid"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "個人ＩＤ";
                }
                if (Util.ConvertToString(queryParams["name"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "姓,名";
                }
                if (Util.ConvertToString(queryParams["birth"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "生年月日";
                }
                if (Util.ConvertToString(queryParams["chkgender"]).Equals(CHK_ON))
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + "性別";
                }
            }

            // 総合判定部
            if (judRslMax > 0)
            {
                // 総合判定部の最大件数分見出し作成
                for (var i = 1; i <= judRslMax; i++)
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") +
                        "判定分類名称(" + i.ToString() + "),判定コード(" + i.ToString() + "),略称(" + i.ToString() + ")";
                }
            }

            // 検査結果項目部
            if (rslMax > 0)
            {
                // 検査結果項目部の見出し取得（検査項目名)
                IList<string> headers = consultDao.SelectHeadRsl(selItemCd, selSuffix);

                // 検査結果項目部の最大件数分見出し作成
                for (var i = 0; i < headers.Count; i++)
                {
                    headerline = headerline + (string.IsNullOrEmpty(headerline) ? "" : ",") + headers[i];
                    // 結果コメント抽出指定があれば見出し追加
                    if (chkOption.Equals(CHK_ON))
                    {
                        headerline = headerline +
                            ",結果コメント1(" + i.ToString() + "),結果コメント名1(" + i.ToString() + ")," +
                            "結果コメント2(" + i.ToString() + "),結果コメント名2(" + i.ToString() + ")," +
                            "正常値フラグ(" + i.ToString() + ")";
                    }
                }
            }

            // データ１行をファイルに出力
            var headerDic = new Dictionary<string, object>();
            headerDic.Add(headerName, headerline);
            returnData.Add(headerDic);

            for (var i = 0; i < rsvNo2.Count; i++)
            {
                // 受診歴情報と個人情報が指定されているとき、受診歴情報と個人情報の抽出
                if (cslPerFlg)
                {
                    IList<string> cslPer = consultDao.SelectDatCslPer(
                        rsvNo2[i],
                        queryParams["csldate"],
                        queryParams["course"],
                        "",
                        queryParams["age"],
                        "",
                        queryParams["perid"],
                        queryParams["name"],
                        queryParams["birth"],
                        queryParams["chkgender"]
                    );

                    // 出力文字列の編集
                    lineCslPer = string.Join(",", cslPer);
                }

                // 総合判定が抽出指定されているとき
                if (Util.ConvertToString(queryParams["jud"]).Equals(CHK_ON) && (judRslMax > 0))
                {
                    // 総合判定情報の抽出
                    string[] judResults = consultDao.SelectDatJudRsl(
                        rsvNo2[i],
                        judAll,
                        judCondition,
                        judClassCd,
                        weightFrom,
                        judMarkFrom,
                        weightTo,
                        judMarkTo
                    );

                    string[] wkJudRsl;

                    // 最大件数に配列をそろえる
                    if ((judResults == null) || (judResults.Length == 0))
                    {
                        wkJudRsl = new string[judRslMax * JUDCLASSROW];
                    }
                    else
                    {
                        wkJudRsl = judResults;
                        Array.Resize(ref wkJudRsl, judRslMax * JUDCLASSROW);
                    }

                    // 出力文字列の編集
                    lineJudRsl = string.Join(",", wkJudRsl);
                }

                // 出力データの編集
                line = "";
                // 受診歴情報および個人情報
                if (cslPerFlg)
                {
                    line = line + (string.IsNullOrEmpty(line) ? "" : ",") + lineCslPer;
                }
                // 総合判定
                if (Util.ConvertToString(queryParams["jud"]).Equals(CHK_ON) && (judRslMax > 0))
                {
                    line = line + (string.IsNullOrEmpty(line) ? "" : ",") + lineJudRsl;
                }
                // 検査結果情報
                if (!pOutItem.Equals(CASE_NOTSELECT))
                {
                    // 作業ファイルから１行読み出し、検査結果情報が存在すればデータ追加
                    string buffer = tempData[i];
                    if (!string.IsNullOrEmpty(buffer))
                    {
                        line = line + (string.IsNullOrEmpty(line) ? "" : ",") + buffer;
                    }
                }

                // データ１行をファイルに出力
                var tempDic = new Dictionary<string, object>();
                tempDic.Add(headerName, line);
                returnData.Add(tempDic);

            }

            return returnData;

        }


        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();
            var consultDao = new ConsultDao(connection, null, new JudClassDao(connection), new JudDao(connection), null, null, null);
            // var consultDao = new ConsultDao(connection, new CourseDao(connection), new JudClassDao(connection), new JudDao(connection), new OrderJnlDao(connection), null, ResultDao(connection));
            // 検索対象クエリパラメータの取得
            string pCslDate = queryParams["csldate"];
            string pCourse = queryParams["course"];
            string pAge = queryParams["age"];
            string pJud = queryParams["jud"];
            string pPerId = queryParams["perid"];
            string pName = queryParams["name"];
            string pBirth = queryParams["birth"];
            string pGender = queryParams["chkgender"];
            
            switch (queryParams["optresult"])
            {
                case "1":
                    pOutItem = CASE_NOTSELECT;
                    break;
                case "2":
                    pOutItem = CASE_ALLSELECT;
                    break;
                case "3":
                    pOutItem = CASE_SELECT;
                    break;
                default:
                    pOutItem = CASE_NOTSELECT;
                    break;
            }
            // 抽出対象検査項目配列の作成     
            var workItemList = new List<string>();
            var workSuffixList = new List<string>();
            var dispItemList = JsonConvert.DeserializeObject<List<DispItem>>(queryParams["dispItem"]);
            foreach (var dispItemRec in dispItemList)
            {
                if (!string.IsNullOrEmpty(dispItemRec.itemCd))
                {
                    string[] workList = dispItemRec.itemCd.Split('|');
                    string workItemCd = "";
                    string workSuffix = "";
                    switch (workList.Length)
                    {
                        case 2:
                            workItemCd = workList[0].Trim();
                            workSuffix = workList[1].Trim();
                            break;

                        default:
                            break;
                    }

                    workItemList.Add(workItemCd);
                    workSuffixList.Add(workSuffix);
                }
                else
                {
                    workItemList.Add("");
                    workSuffixList.Add("");
                }
            }

            selItemCd = workItemList.ToArray();
            selSuffix = workSuffixList.ToArray();

            string orgCd = "";
            string cOrgBsdCd = "";
            string cOrgRoomCd = "";
            string cOrgPostCd = "";
            string empNo = "";
            string pOrgCd = "";
            string pOrgBsdCd = "";
            string pOrgRoomCd = "";
            string pOrgPostCd = "";
            string overTime = "";
            chkOption = queryParams["cmtflg"];

            // 抽出対象クエリパラメータの取得
            DateTime tmpDate;
            if (!DateTime.TryParse(queryParams["startdate"], out tmpDate))
            {
                messages.Add("開始受診日の入力形式が正しくありません。");
            }
            DateTime? startDate = tmpDate;
            string sYear = tmpDate.Year.ToString();
            string sMonth = tmpDate.Month.ToString();
            string sDay = tmpDate.Day.ToString();
            if (!DateTime.TryParse(queryParams["enddate"], out tmpDate))
            {
                messages.Add("終了受診日の入力形式が正しくありません。");
            }
            DateTime? endDate = tmpDate;
            string eYear = tmpDate.Year.ToString();
            string eMonth = tmpDate.Month.ToString();
            string eDay = tmpDate.Day.ToString();

            string csCd = queryParams["cscd"];
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];
            string sAgeY = queryParams["startagey"];
            string sAgeM = queryParams["startagem"];
            string eAgeY = queryParams["endagey"];
            string eAgeM = queryParams["endagem"];
            
            switch (queryParams["gender"])
            {
                case "0":
                    gender = Gender.Both;
                    break;
                case "1":
                    gender = Gender.Male;
                    break;
                case "2":
                    gender = Gender.Female;
                    break;
                default:
                    gender = Gender.Both;
                    break;
            }
            
            var workConItemList = new List<string>();
            var workConSuffixList = new List<string>();
            var workConValueFrom = new List<string>();
            var workConValueTo = new List<string>();
            var workConMarkFrom = new List<string>();
            var workConMarkTo = new List<string>();
            var workJudClass = new List<int?>();
            var workJudValueFrom = new List<string>();
            var workJudValueTo = new List<string>();
            var workJudMarkFrom = new List<string>();
            var workJudMarkTo = new List<string>();

            // 抽出対象検査項目配列の作成     
            var conItemList = JsonConvert.DeserializeObject<List<DispItem>>(queryParams["conItem"]);
            foreach (var conItemRec in conItemList)
            {
                if (!string.IsNullOrEmpty(conItemRec.itemCd))
                {
                    string[] workList = conItemRec.itemCd.Split('|');
                    string workItemCd = "";
                    string workSuffix = "";
                    switch (workList.Length)
                    {
                        case 2:
                            workItemCd = workList[0].Trim();
                            workSuffix = workList[1].Trim();
                            break;

                        default:
                            break;
                    }

                    workConItemList.Add(workItemCd);
                    workConSuffixList.Add(workSuffix);

                }
                else
                {
                    workConItemList.Add("");
                    workConSuffixList.Add("");
                }
            }

            for (int i = 0; i < 50; i++)
            {

                // 条件
                if (!string.IsNullOrEmpty(queryParams["convalue1_" + i.ToString()]))
                {
                    workConValueFrom.Add(queryParams["convalue1_" + i.ToString()]);
                }
                else
                {
                    workConValueFrom.Add("");
                }

                if (!string.IsNullOrEmpty(queryParams["consuffix1_" + i.ToString()]))
                {
                    workConMarkFrom.Add(queryParams["consuffix1_" + i.ToString()]);
                }
                else
                {
                    workConMarkFrom.Add("");
                }

                if (!string.IsNullOrEmpty(queryParams["convalue2_" + i.ToString()]))
                {
                    workConValueTo.Add(queryParams["convalue2_" + i.ToString()]);
                }
                else
                {
                    workConValueTo.Add("");
                }

                if (!string.IsNullOrEmpty(queryParams["consuffix2_" + i.ToString()]))
                {
                    workConMarkTo.Add(queryParams["consuffix2_" + i.ToString()]);
                }
                else
                {
                    workConMarkTo.Add("");
                }

                // 総合判定条件
                if (!string.IsNullOrEmpty(queryParams["judclass_" + i.ToString()]))
                {
                    workJudClass.Add(int.Parse(queryParams["judclass_" + i.ToString()]));
                }
                else
                {
                    workJudClass.Add(null);
                }

                if (!string.IsNullOrEmpty(queryParams["judvalue1_" + i.ToString()]))
                {
                    workJudValueFrom.Add(queryParams["judvalue1_" + i.ToString()]);
                }
                else
                {
                    workJudValueFrom.Add("");
                }

                if (!string.IsNullOrEmpty(queryParams["judsuffix1_" + i.ToString()]))
                {
                    workJudMarkFrom.Add(queryParams["judsuffix1_" + i.ToString()]);
                }
                else
                {
                    workJudMarkFrom.Add("");
                }

                if (!string.IsNullOrEmpty(queryParams["judvalue2_" + i.ToString()]))
                {
                    workJudValueTo.Add(queryParams["judvalue2_" + i.ToString()]);
                }
                else
                {
                    workJudValueTo.Add("");
                }

                if (!string.IsNullOrEmpty(queryParams["judsuffix2_" + i.ToString()]))
                {
                    workJudMarkTo.Add(queryParams["judsuffix2_" + i.ToString()]);
                }
                else
                {
                    workJudMarkTo.Add("");
                }

            }
            itemCd = workConItemList.ToArray();
            suffix = workConSuffixList.ToArray();
            rslValueFrom = workConValueFrom.ToArray();
            rslMarkFrom = workConMarkFrom.ToArray();
            rslValueTo = workConValueTo.ToArray();
            rslMarkTo = workConMarkTo.ToArray();

            judClassCd = workJudClass.ToArray();
            string[] judValueFrom = workJudValueFrom.ToArray();
            string[] judValueTo = workJudValueTo.ToArray();
            judMarkFrom = workJudMarkFrom.ToArray();
            judMarkTo = workJudMarkTo.ToArray();

            judAll = int.Parse(queryParams["judall"]);
            judOperation = int.Parse(queryParams["judoperation"]);

            var message1 = consultDao.CheckValueDatSelect(pCslDate, pCourse, orgCd, pAge, pJud, pPerId, pName, pBirth, pGender, pOutItem, ref selItemCd, cOrgBsdCd, cOrgRoomCd, cOrgPostCd, empNo, pOrgCd, pOrgBsdCd, pOrgRoomCd, pOrgPostCd, overTime);
            var message2 = consultDao.CheckValueDatConsult(sYear, sMonth, sDay, eYear, eMonth, eDay, sAgeY, sAgeM, eAgeY, eAgeM, itemCd, suffix, rslValueFrom, rslMarkFrom, rslValueTo, rslMarkTo, judClassCd, judValueFrom, judMarkFrom, judValueTo, judMarkTo,out startDate,out endDate,ref sAge,ref eAge,out rslCondition,out weightFrom,out weightTo,out judCondition);

            if (message1 != null && message1.Count > 0)
            {
                messages.AddRange(message1);
            }
            if (message2 != null && message2.Count > 0)
            {
                messages.AddRange(message2);
            }

            return messages;
        }
    }
}
