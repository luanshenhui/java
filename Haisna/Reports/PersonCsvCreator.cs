using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common.Constants;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class PersonCsvCreator : CsvCreator
    {
        /// <summary>
        /// 予約データを読み込み
        /// </summary>
        /// <returns>予約データ</returns>
        protected override List<dynamic> GetData()
        {
            string sql =
                  @"
                    select
                      person.perid               個人ＩＤ
                      , person.vidflg            仮ＩＤフラグ
                      , person.lastname          姓
                      , person.firstname         名
                      , person.lastkname         カナ姓
                      , person.firstkname        カナ名
                      , to_char(person.birth,'yyyy/MM/dd') 生年月日
                      , person.gender            性別
                      , consult.orgcd1           所属団体コード１
                      , consult.orgcd2           所属団体コード２
                      , person.spare1            予備１
                      , person.spare2            予備２
                      , person.upddate           更新日時
                      , person.upduser           更新者
                      , peraddr.tel1             電話番号1
                      , peraddr.tel2             電話番号2
                      , peraddr.extension        内線
                      , peraddr.fax              ＦＡＸ
                      , peraddr.phone            携帯番号
                      , peraddr.email            ""eMail""
                      , peraddr.zipcd            郵便番号
                      , peraddr.prefcd           都道府県コード
                      , peraddr.cityname         市区町村名
                      , peraddr.address1         住所１
                      , peraddr.address2         住所２
                      , persondetail.marriage    婚姻区分
                      , consult.isrsign          健保記号記号
                      , consult.isrno            健保番号
                      , persondetail.residentno  住民番号
                      , persondetail.unionno     組合番号
                      , persondetail.karte       カルテ番号
                      , persondetail.notes       特記事項
                      , persondetail.spare1      予備１
                      , persondetail.spare2      予備２
                      , persondetail.spare3      予備３
                      , persondetail.spare4      予備４
                      , persondetail.spare5      予備5
                    from
                      consult
                      , person
                      , persondetail
                      , peraddr
                    where
                      consult.csldate between :startdate and :enddate ";

            //コースコード
            string csCd = queryParams["csCd"];
            if (!string.IsNullOrEmpty(csCd))
            {
                sql += @"  and consult.cscd = :cscd ";
            }

            //団体コード
            string orgCd1 = queryParams["orgCd1"];
            string orgCd2 = queryParams["orgCd2"];
            if (!string.IsNullOrEmpty(orgCd1) || !string.IsNullOrEmpty(orgCd2))
            {
                sql += @"  and consult.orgcd1 = :orgcd1
                           and consult.orgcd2 = :orgcd2";
            }

            //年齢範囲指定
            // 開始年齢
            double? startAge = ConvertAge(queryParams["startAgeY"], queryParams["startAgeM"]);

            // 終了年齢
            double? endAge = ConvertAge(queryParams["endAgeY"], queryParams["endAgeM"]);

            if (startAge != null || endAge != null)
            {
                if (startAge == null)
                {
                    sql += @"  and consult.age <= :endage ";
                }
                else if (endAge == null)
                {
                    sql += @"  and consult.age >= :startage ";
                }
                else
                {
                    sql += @"  and consult.age between :startage and :endage ";
                }
            }

            //性別
            if (int.TryParse(queryParams["gender"], out int gender)){
                if (gender == (int)Gender.Male || gender == (int)Gender.Female)
                {
                    sql += @"  and person.gender  = :gender ";
                }
            }

            sql +=
                @"    and person.delflg = :delflg and consult.cancelflg = :cancelflg
                      and consult.perid = person.perid(+)
                      and person.perid  = peraddr.perid(+)
                      and person.perid  = persondetail.perid(+)
                    order by person.perid ";

            string startDate = queryParams["startDate"];
            string endDate = queryParams["endDate"];

            var sqlParam = new
            {
                startdate = startDate,
                enddate = endDate,
                cscd = csCd,
                orgcd1 = orgCd1,
                orgcd2 = orgCd2,
                startage = startAge,
                endage = endAge,
                gender = gender,
                delflg = 0,
                cancelflg = 0,
            };

                return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 年齢年と年齢月の文字列から年齢を数値変換する
        /// </summary>
        /// <param name="ageY">年齢年</param>
        /// <param name="ageM">年齢月</param>
        /// <returns>年齢数値</returns>
        private double? ConvertAge(string ageY, string ageM)
        {
            // 年齢年が数値でなければ未入力扱いとする
            if (!int.TryParse(ageY, out int parsedAgeY))
            {
                return null;
            }

            // 年齢月が空白であれば０として扱う
            // 空白でも数値でもなければ年齢は未入力として扱う
            if (!int.TryParse(ageM, out int parsedAgeM))
            {
                if (!string.IsNullOrEmpty(ageM))
                {
                    return null;
                }
                parsedAgeM = 0;
            }

            return parsedAgeY + (parsedAgeM * 0.01);
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            // 開始受診日
            bool isCorrectStartDate = DateTime.TryParseExact(queryParams["startDate"], "yyyy/MM/dd", null, DateTimeStyles.None, out DateTime startDate);
            if (!isCorrectStartDate)
            {
                messages.Add("開始受診日を正しく入力してください。");
            }

            // 終了受診日
            bool isCorrectEndDate = DateTime.TryParseExact(queryParams["endDate"], "yyyy/MM/dd", null, DateTimeStyles.None, out DateTime endDate);
            if (!isCorrectEndDate)
            {
                messages.Add("終了受診日を正しく入力してください。");
            }

            // 年月日の範囲チェック
            if (isCorrectStartDate && isCorrectEndDate && startDate > endDate)
            {
                messages.Add("受診日の期間指定が誤っています。");
            }

            // 開始年齢年
            string strStartAgeY = queryParams["startAgeY"];
            if ( !string.IsNullOrEmpty(strStartAgeY) && !int.TryParse(strStartAgeY, out int startAgeY))
            {
                messages.Add("開始年齢年には数字を入力してください。");
            }

            // 終了年齢年
            string strStartAgeM = queryParams["startAgeM"];
            if (!string.IsNullOrEmpty(strStartAgeM) && !int.TryParse(strStartAgeM, out int startAgeM))
            {
                messages.Add("開始年齢月には数字を入力してください。");
            }

            // 開始年齢を数値化
            double? startAge = ConvertAge(strStartAgeY, strStartAgeM);

            // 終了年齢年
            string strEndAgeY = queryParams["endAgeY"];
            if (!string.IsNullOrEmpty(strEndAgeY) && !int.TryParse(strEndAgeY, out int endAgeY))
            {
                messages.Add("終了年齢年には数字を入力してください。");
            }

            // 終了年齢月
            string strEndAgeM = queryParams["endAgeM"];
            if (!string.IsNullOrEmpty(strEndAgeM) && !int.TryParse(strEndAgeM, out int endAgeM))
            {
                messages.Add("終了年齢月には数字を入力してください。");
            }

            // 終了年齢を数値化
            double? endAge = ConvertAge(strEndAgeY, strEndAgeM);

            // 年齢の範囲チェック
            if (startAge != null && endAge != null && startAge > endAge)
            {
                messages.Add("年齢の範囲指定が誤っています。");
            }

            return messages;
        }
    }
}
