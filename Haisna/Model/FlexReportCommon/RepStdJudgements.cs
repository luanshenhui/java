using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Model.FlexReportCommon
{
    /// <summary>
    /// RepStdJudgementsモデル
    /// </summary>
    public class RepStdJudgements
    {
        /// <summary>
        /// 定型所見コレクション
        /// </summary>
        private Dictionary<string, RepStdJudgement> colStdJudgements = new Dictionary<string, RepStdJudgement>();

        /// <summary>
        /// キー値の節頭子
        /// </summary>
        private const string KEY_PREFIX = "K";

        /// <summary>
        /// 検査項目の設定
        /// </summary>
        public RepStdJudgement Add(
            int stdJudCd,
            string stdJudNote)
        {
            // 検査項目クラス
            RepStdJudgement repStdJudgement = new RepStdJudgement
            {
                // コレクションへの追加
                StdJudCd = stdJudCd,
                StdJudNote = stdJudNote
            };

            // コレクションへの追加
            string key = KEY_PREFIX + stdJudCd.ToString();
            this.colStdJudgements.Add(key, repStdJudgement);

            return repStdJudgement;
        }

        /// <summary>
        /// 検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepStdJudgement Item(string indexKey)
        {
            if (!this.colStdJudgements.ContainsKey(KEY_PREFIX + indexKey))
            {
                return null;
            }

            return this.colStdJudgements[KEY_PREFIX + indexKey];
        }

        /// <summary>
        /// 検査結果戻る
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public RepStdJudgement Item(int indexKey)
        {
            try
            {
                string[] keys = colStdJudgements.Keys.Cast<string>().ToArray();
                return this.colStdJudgements[keys[indexKey]];
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// 検査結果の削除
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(string indexKey)
        {
            return this.colStdJudgements.Remove(indexKey);
        }

        /// <summary>
        /// 検査結果の削除        
        /// </summary>
        /// <param name="indexKey"></param>
        /// <returns></returns>
        public bool Remove(int indexKey)
        {
            string[] keys = colStdJudgements.Keys.Cast<string>().ToArray();
            return this.colStdJudgements.Remove(keys[indexKey]);
        }

        /// <summary>
        /// 検査結果件数
        /// </summary>
        /// <returns></returns>
        public int Count
        {
            get
            {
                return this.colStdJudgements.Count;
            }
        }
    }
}