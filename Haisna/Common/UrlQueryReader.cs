using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Specialized;


namespace Hainsi.Common
{
	public class UrlQueryReader
	{
		/// <summary>
		/// URLクエリのコレクション
		/// </summary>
		private NameValueCollection UrlQuery { get; }

		/// <summary>
		/// コンストラクタ
		/// </summary>
		/// <param name="urlQuery"></param>
		public UrlQueryReader(IEnumerable<KeyValuePair<string, string>> urlQuery)
		{
			UrlQuery = ParseUrlQuery(urlQuery);
		}

		/// <summary>
		/// URLクエリをNameValueCollectionに変換する
		/// </summary>
		/// <param name="urlQuery">URLクエリ</param>
		/// <returns>NameValueCollectionにしたURLクエリ</returns>
		private NameValueCollection ParseUrlQuery(IEnumerable<KeyValuePair<string, string>> urlQuery)
		{
			var wkUrlQuery = new NameValueCollection();

			foreach (var pair in urlQuery)
			{
				wkUrlQuery.Add(pair.Key, pair.Value);
			}

			return wkUrlQuery;
		}

		/// <summary>
		/// インデクサ
		/// </summary>
		/// <param name="key">URLクエリパラメータ名</param>
		/// <returns>
		/// URLクエリパラメータの値
		/// 複数ある場合は1行目を返す
		/// </returns>
		public string this[string key]
		{
			get
			{
				return GetValue(key);
			}
		}

		/// <summary>
		/// URLクエリパラメータの値を返す
		/// </summary>
		/// <param name="key">URLクエリパラメータ名</param>
		/// <returns>URLクエリパラメータの値</returns>
		private string GetValue(string key)
		{
			string[] wkValues = UrlQuery.GetValues(key);

			// 該当の値がなければnullを返す
			if (wkValues == null || wkValues.Length <= 0)
			{
				return null;
			}

			// 該当の値があれば最初の文字列を返す
			return wkValues.First();
		}

		/// <summary>
		/// URLクエリパラメータの配列を返す
		/// </summary>
		/// <param name="key">URLクエリパラメータ名</param>
		/// <returns>URLクエリパラメータの値の配列</returns>
		public string[] GetValues(string key)
		{
			string[] wkValues = wkValues = UrlQuery.GetValues(key);

			// 値がなければnullを返す
			if (wkValues == null || wkValues.Length <= 0)
			{
				return null;
			}

			// 複製した配列を返す（直接編集できないようにするため）
			return (string[])wkValues.Clone();
		}
	}
}
