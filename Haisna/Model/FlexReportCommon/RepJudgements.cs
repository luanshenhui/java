using System.Linq;
using System.Collections.Generic;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepJudgementsモデル
    /// </summary>
    public class RepJudgements
    {
        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";
        /// <summary>
        /// 受診履歴コレクション
        /// </summary>
        private Dictionary<string, RepJudgement> colJudgements = new Dictionary<string, RepJudgement>();

        /// <summary>
        /// 判定情報設定
        /// </summary>
        public RepJudgement Add(
            int judClassCd,
            string judClassName,
            string judCd,
            string judRName,
            string govMngJud,
            string govMngJudName,
            string doctorName,
            string freeJudCnt,
            string guidanceStc)
        {
            // 判定情報クラス
            RepJudgement repJudgement = new RepJudgement
            {
                // コレクションへの追加
                JudClassCd = judClassCd,
                JudClassName = judClassName,
                JudCd = judCd,
                JudRName = judRName,
                GovMngJud = govMngJud,
                GovMngJudName = govMngJudName,
                DoctorName = doctorName,
                FreeJudCmt = freeJudCnt,
                GuidanceStc = guidanceStc,
            };

            // コレクションへの追加
            string key = KEY_PREFIX + judClassCd.ToString();
            this.colJudgements.Add(key, repJudgement);

            return repJudgement;
        }

        /// <summary>
        /// 判定情報戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepJudgement Item(string indexKey)
        {
            if (!this.colJudgements.ContainsKey(KEY_PREFIX + indexKey))
            {
                return null;
            }
            return this.colJudgements[KEY_PREFIX + indexKey];
        }

        /// <summary>
        /// 判定情報戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepJudgement Item(int indexKey)
        {
            try
            {
                string[] keys = colJudgements.Keys.Cast<string>().ToArray();
                return this.colJudgements[keys[indexKey]];
            }
            catch
            {
                return null;
            }

        }

        /// <summary>
        /// 判定情報の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            return this.colJudgements.Remove(indexKey);
        }

        /// <summary>
        /// 判定情報の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colJudgements.Keys.Cast<string>().ToArray();
            return this.colJudgements.Remove(keys[indexKey]);
        }

        /// <summary>
        /// 判定情報件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colJudgements.Count;
            }
        }
    }
}