using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// フォローアップ情報データアクセスオブジェクト
    /// </summary>
    public class RequestCardDao : AbstractDao
    {

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public RequestCardDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 依頼状履歴情報を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="prtDiv">様式分類</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>依頼状履歴情報情報リスト</returns>
        public List<dynamic> folReqHistory(int rsvNo, int prtDiv, string judClassCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            if (prtDiv != 0)
            {
                param.Add("prtdiv", prtDiv);
            }
            if (!"".Equals(judClassCd) && judClassCd != null)
            {
                param.Add("judclasscd", judClassCd);
            }

            // 検索条件を満たす個人請求書管理情報テーブルのレコードを取得
            string sql = @"
                           select
                             follow_prt_h.rsvno as rsvno
                             , follow_prt_h.judclasscd as judclasscd
                             , judclass.judclassname as judclassname
                             , nvl(follow_info.judcd, '') as judcd
                             , follow_prt_h.filename as filename
                             , follow_prt_h.seq as seq
                             , follow_prt_h.adddate as adddate
                             , ( 
                               select
                                 hainsuser.username 
                               from
                                 hainsuser 
                               where
                                 follow_prt_h.adduser = hainsuser.userid
                             ) as username
                             , follow_prt_h.prtsenddate as reqsenddate
                             , ( 
                               select
                                 hainsuser.username 
                               from
                                 hainsuser 
                               where
                                 follow_prt_h.senduser = hainsuser.userid
                             ) as reqsenduser
                             , follow_prt_h.prtdiv as prtdiv 
                           from
                             follow_prt_h
                             , follow_info
                             , judclass 
                           where
                             follow_prt_h.rsvno = :rsvno
                        ";

            if (!"".Equals(judClassCd) && judClassCd != null)
            {
                sql += " and follow_prt_h.judclasscd = :judclasscd ";
            }
            sql += @"
                     and follow_prt_h.rsvno = follow_info.rsvno(+) 
                     and follow_prt_h.judclasscd = follow_info.judclasscd(+) 
                     and follow_prt_h.judclasscd = judclass.judclasscd 

                  ";
            if (prtDiv != 0)
            {
                sql += " and follow_prt_h.prtdiv = :prtdiv ";
            }
            sql += " order by follow_prt_h.judclasscd, follow_prt_h.seq ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 依頼状
        /// </summary>
        /// <param name="updUser">ユーザID</param>
        /// <param name="userName">ユーザ名</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">検査項目コード</param>
        /// <param name="judClassName"></param>
        /// <param name="prtDiv">様式分類（1:依頼　2:勧奨）</param>
        /// <param name="secEquipName">医療機関名</param>
        /// <param name="secEquipCourse">診療科名</param>
        /// <param name="secDoctor">担当医師</param>
        /// <param name="secEquipAddr">医療機関住所</param>
        /// <param name="secEquipTel">医療機関電話番号</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="age">実年齢</param>
        /// <param name="dayId">当日ID</param>
        /// <param name="name">氏名</param>
        /// <param name="kname">カナ氏名</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="folItem">診断・検査項目</param>
        /// <param name="folNote">所見</param>
        /// <returns></returns>
        public long PrintOut(string updUser,
                             string userName,
                             int rsvNo,
                             int judClassCd,
                             string judClassName,
                             string prtDiv,
                             string secEquipName,
                             string secEquipCourse,
                             string secDoctor,
                             string secEquipAddr,
                             string secEquipTel,
                             string cslDate,
                             string perId,
                             string age,
                             string dayId,
                             string name,
                             string kname,
                             string birth,
                             string gender,
                             string folItem,
                             string folNote)
        {
            string sql;  // SQLステートメント
            string sql2;  // SQLステートメント
            string sql3;  // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("prtdiv", prtDiv);
            param.Add("UPDUSER", rsvNo);
            param.Add("FILENAME", null);
            param.Add("SEQ", 0);
            param.Add("SECEQUIPNAME", secEquipName);
            param.Add("SECEQUIPCOURSE", secEquipCourse);
            param.Add("SECDOCTOR", secDoctor);
            param.Add("SECEQUIPADDR", secEquipAddr);
            param.Add("SECEQUIPTEL", secEquipTel);
            return 0;
        }
    }
}
