using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Common.Table
{
    /// <summary>
    /// DBのカラムを定義する
    /// </summary>
    public class ColumnDefinition
    {
        /// <summary>
        /// 名前
        /// </summary>
        public string ColumnName { get; }
        /// <summary>
        /// 長さ（数値の場合整数桁数）
        /// </summary>
        public int ColumnFigure1 { get; }
        /// <summary>
        /// 数値の小数桁数
        /// </summary>
        public int ColumnFigure2 { get; }
        /// <summary>
        /// 必須項目
        /// </summary>
        public bool IsRequired { get; }
        /// <summary>
        /// 型
        /// </summary>
        public string ColumnType { get; }
        /// <summary>
        /// 文字列ルール
        /// </summary>
        private WordRuleModel WordRule {get;}

		/// <summary>
		/// コンストラクタ
		/// </summary>
        /// <param name="column">カラム名</param>
		/// <param name="figure1">整数部長さ</param>
		/// <param name="type">型</param>
		/// <param name="name">名前</param>
		/// <param name="figure2">小数部長さ</param>
        /// <param name="isRequired">必須か否か</param>
		public ColumnDefinition(string column, int figure1, string type, string name = "", int figure2 = 0, bool isRequired = false)
		{
			ColumnFigure1 = figure1;
			ColumnFigure2 = figure2;
			ColumnType = type;
			ColumnName = name;
            IsRequired = isRequired;
            WordRule = WordRules.GetRule(column);
		}

		/// <summary>
		/// バリデーション
		/// </summary>
		/// <param name="value">値</param>
		/// <param name="messages">エラーメッセージ格納用リスト</param>
		/// <param name="name">表示名</param>
		/// <returns></returns>
		public bool Valid(object value, IList<string> messages, string name = null)
		{
            // 必須チェック
            if ( !ValidRequired(value, messages, name))
            {
                return false;
            }

			// 型チェック
			if ( !ValidType(value, messages, name))
			{
				return false;
			}

			// 長さチェック
			return ValidLength(value, messages, name);
		}

        /// <summary>
        /// 必須の場合値がセットされているかどうかをチェックする
        /// </summary>
        /// <param name="value">値</param>
		/// <param name="messages">エラーメッセージ格納用リスト</param>
		/// <param name="name">表示名</param>
        /// <returns></returns>
        public bool ValidRequired(object value, IList<string> messages, string name = null)
        {
            // 名前の指定がなければカラムの日本語名を割り当てる
            if (name == null)
            {
                name = ColumnName;
            }

            // 必須チェック
            if(IsRequired && (value == null || string.IsNullOrEmpty(Convert.ToString(value))))
            {
                messages.Add(string.Format("{0}に値を入力してください。", name));
                return false;
            }

            return true;
        }

		/// <summary>
		/// 長さが正しいかをチェックする
		/// </summary>
		/// <param name="value">値</param>
		/// <param name="messages">エラーメッセージ格納用リスト</param>
		/// <param name="name">表示名</param>
		/// <returns></returns>
		public bool ValidLength(object value, IList<string> messages, string name = null)
		{
			// 名前の指定がなければカラムの日本語名を割り当てる
			if (name == null)
			{
				name = ColumnName;
			}

			// 数値の場合
			if (IsNumericType() && double.TryParse(Util.ConvertToString(value), out var num))
			{
				// 整数部チェック
				bool isValidIntegerPart = Math.Abs(num) < Math.Pow(10, ColumnFigure1);

				// 小数部チェック
				bool isValidDecimalPart = Math.Round(num, ColumnFigure2) == num;

				// 桁数が正しくなければメッセージをセット
				if (!(isValidIntegerPart && isValidDecimalPart))
				{
					// 小数部桁数0の場合のメッセージをセット
					string message = string.Format("{0}は{1}桁以内の整数を入力してください", name, ColumnFigure1);

					// 小数部桁数がセットされていればメッセージを変更する
					if (ColumnFigure2 > 0)
					{
						message = string.Format("{0}は整数部{1}桁以内、小数部{2}桁以内で入力してください", name, ColumnFigure1, ColumnFigure2);
					}

					// エラーメッセージをセット
					messages.Add(message);
					return false;
				}

				return true;
			}

			// バイト列に変換する
			byte[] bytes = Util.ConvertToBytes(value);

			if (bytes.Length > ColumnFigure1 || !WordRule.Rule(Util.ConvertToString(value)))
			{
				// 指定の文字数より多い、または文字列のルールに合わない場合はエラーメッセージをセット
				messages.Add(string.Format(WordRule.Message, name, ColumnFigure1));
				return false;
			}

			return true;
		}

		/// <summary>
		/// 値が型として正しいかどうかをチェックする(JToken用)
		/// </summary>
		/// <param name="value">値</param>
		/// <param name="messages">エラーメッセージ格納用リスト</param>
		/// <param name="name">表示名</param>
		/// <returns>値を変換できる場合True、できない場合False</returns>
		public bool ValidType(object value, IList<string> messages, string name = null)
		{
			// 空白は許容する
			if (Convert.ToString(value) == "")
			{
				return true;
			}

			// 名前の指定がなければカラムの名前を割り当てる
			if (name == null)
			{
				name = ColumnName;
			}

			var jvalue = value as JToken;
			// JTokenの場合
			if (jvalue != null)
			{
				try
				{
					// JTokenから型指定の変換ができればTrue
					jvalue.ToObject(GetValueType());
					return true;
				}
				catch (FormatException)
				{
					// 指定の型に変換できなければエラーメッセージを追加してFalseをかえす
					messages.Add(string.Format(GetTypeErrorMessage(GetValueType()), name));
					return false;
				}
			}
			
			// JTokenでない場合
			try
			{
				// 指定の型に変換ができればTrue
				Convert.ChangeType(value, GetValueType());
				return true;
			}
			catch (InvalidCastException)
			{
				// 指定の型に変換できなければエラーメッセージを追加してFalseをかえす
				messages.Add(string.Format(GetTypeErrorMessage(GetValueType()), name));
				return false;
			}
		}

		/// <summary>
		/// セットされたDBの型をもとに.netの型へ変換する
		/// </summary>
		/// <returns>.netの型</returns>
		public Type GetValueType()
		{
			// DB型に合わせて.netの型を返す
			switch (ColumnType)
			{
				case "LONG":
					return typeof(string);
				case "NUMBER":
					return typeof(double);
				case "CHAR":
					return typeof(string);
				case "CLOB":
					return typeof(string);
				case "DATE":
					return typeof(DateTime);
				case "VARCHAR2":
					return typeof(string);
				case "BLOB":
					return typeof(object);
				default:
					throw new Exception(string.Format("DBのカラム型{0}は対応していません。", ColumnType));
			}
	}

		/// <summary>
		/// カラムの型が数値型かどうかをチェックする
		/// </summary>
		/// <returns>数値型の場合True 違う場合False</returns>
		private bool IsNumericType()
		{
			switch (ColumnType)
			{
				case "NUMBER":
					return true;
			}
			
			return false;
		}

		/// <summary>
		/// .netの型によってエラーメッセージを返す
		/// </summary>
		/// <param name="type">.netの型</param>
		/// <returns>エラーメッセージ</returns>
		private string GetTypeErrorMessage(Type type)
		{
			// 文字列の場合のエラーメッセージを返す
			if (type == typeof(string))
			{
				return "{0}は文字列を入力してください";
			}

			// 整数値の場合のエラーメッセージを返す
			if (type == typeof(long))
			{
				return "{0}は整数を入力してください";
			}

			// 日時型のエラーメッセージを返す
			if (type == typeof(DateTime))
			{
				return "{0}は日付を入力してください";
			}

			// 小数値のエラーメッセージを返す
			if (type == typeof(double))
			{
				return "{0}は数値を入力してください";
			}

			// 上記以外の場合のエラーメッセージを返す
			return "{0}の入力形式が正しくありません";
		}
	}
}
