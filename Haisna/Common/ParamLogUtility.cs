using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Diagnostics;
using System.Reflection;
using Newtonsoft.Json;
using MethodBoundaryAspect.Fody.Attributes;

namespace Hainsi.Common
{
	public class ParamLogUtility
	{
		/// <summary>
		/// 拡張メッセージ用キー
		/// </summary>
		public static String ExMessage { get; } = "ExMessage";

		/// <summary>
		/// 出力するログを整形し新たな例外を作成する
		/// </summary>
		/// <param name="ex">例外</param>
		/// <param name="providedParameters">ログに表示するパラメータ</param>
		/// <returns>新たな例外</returns>
		public static Exception EditException(Exception ex, params Expression<Func<object>>[] providedParameters)
		{
			try
			{
				// メソッド情報を取得
				MethodBase currentMethod = new StackTrace().GetFrame(1).GetMethod();
				
				// メソッドの引数情報を格納
				var parameters = new List<Tuple<string, Type, object>>();
				foreach (var aExpression in providedParameters)
				{
					Expression bodyType = aExpression.Body;
					if (bodyType is MemberExpression)
					{
						AddProvidedParamaterDetail(parameters, (MemberExpression)aExpression.Body);
					}
					else if (bodyType is UnaryExpression)
					{
						UnaryExpression unaryExpression = (UnaryExpression)aExpression.Body;
						AddProvidedParamaterDetail(parameters, (MemberExpression)unaryExpression.Operand);
					}
					else
					{
						throw new Exception("Expression type unknown.");
					}
				}

				// 引数をログに整形
				string parameterLog = ProcessLog(parameters);
				
				// メッセージ作成
				AddExMessage(ex, currentMethod, parameters);

				return ex;

			}
			catch (Exception exception)
			{
				throw new Exception("Error in paramater log processing.", exception);
			}
		}

		/// <summary>
		/// 出力するログを整形し例外を作成する
		/// </summary>
		/// <param name="arg">メソッド情報</param>
		/// <returns>例外</returns>
		public static Exception EditException(MethodExecutionArgs arg)
		{
			// 例外
			Exception ex = arg.Exception;

			// メソッド情報を取得
			MethodBase currentMethod = arg.Method;

			// メソッドパラメータ値
			object[] providedParameters = arg.Arguments;

			// メソッドパラメータ情報
			ParameterInfo[] parameterInfos = arg.Method.GetParameters();

			// メソッドの引数情報を格納
			var parameters = new List<Tuple<string, Type, object>>();
			for (var i = 0; i < providedParameters.Length; i++)
			{
				ParameterInfo parameterInfo = parameterInfos[i];
				string name = parameterInfo.Name;
				Type type = parameterInfo.GetType();
				parameters.Add(new Tuple<string, Type, object>(name, type, providedParameters[i]));
			}
			
			// メッセージ作成
			AddExMessage(ex, currentMethod, parameters);
			
			return ex;
		}

		/// <summary>
		/// 拡張ログメッセージを追加する
		/// </summary>
		/// <param name="ex">例外</param>
		/// <param name="method">メソッド情報</param>
		/// <param name="parameters">メソッドパラメータ</param>
		private static void AddExMessage(Exception ex, MethodBase method, List<Tuple<string, Type, object>> parameters)
		{
			// 引数をログに整形
			string parameterLog = ProcessLog(parameters);

			// ログ作成
			string logFormat = "Class = {0}\r\nMethod = {1}\r\n{2}\r\n";
			AppendExMessage(ex, string.Format(logFormat, method.DeclaringType.FullName, method.Name, parameterLog));
		}

		/// <summary>
		/// 拡張ログメッセージを先頭に追加する
		/// </summary>
		/// <param name="ex">例外</param>
		/// <param name="message">メッセージ</param>
		public static void PrependExMessage(Exception ex, string message)
		{
			// 拡張ログメッセージ領域の初期化
			InitExMessage(ex);

			// 拡張ログメッセージを先頭に追加
			((List<string>)ex.Data[ExMessage]).Insert(0, message);
		}

		/// <summary>
		/// 拡張ログメッセージを末尾に追加する
		/// </summary>
		/// <param name="ex">例外</param>
		/// <param name="message">メッセージ</param>
		public static void AppendExMessage(Exception ex, string message)
		{
			// 拡張ログメッセージ領域の初期化
			InitExMessage(ex);

			// 拡張ログメッセージを先頭に追加
			((List<string>)ex.Data[ExMessage]).Add(message);
		}

		/// <summary>
		/// 拡張ログメッセージ領域を確保する
		/// </summary>
		/// <param name="ex">例外</param>
		private static void  InitExMessage(Exception ex)
		{
			// 拡張ログメッセージのリストがなければ作成
			if (!ex.Data.Contains(ExMessage))
			{
				ex.Data.Add(ExMessage, new List<string>());
			}
		}

		/// <summary>
		/// 引数をログに整形する
		/// </summary>
		/// <param name="providedParametars">引数</param>
		/// <returns>ログ</returns>
		private static string ProcessLog(List<Tuple<string, Type, object>> providedParametars)
		{
			string parameterLog = null;

			foreach (var providedParametar in providedParametars)
			{
				string name = providedParametar.Item1;
				string value = JsonConvert.SerializeObject(providedParametar.Item3).Replace(@"\r\n", "\r\n").Replace(@"\t", "\t");

				parameterLog += String.Format("\"{0}\":{1}\r\n", name, value);
			}

			return (parameterLog != null) ? parameterLog.Trim(' ', ',') : string.Empty;
		}

		/// <summary>
		/// 引数情報をリストに格納する
		/// </summary>
		/// <param name="providedParametars">引数情報</param>
		/// <param name="memberExpression"></param>
		private static void AddProvidedParamaterDetail(List<Tuple<string, Type, object>> providedParametars, MemberExpression memberExpression)
		{
			ConstantExpression constantExpression = (ConstantExpression)memberExpression.Expression;
			string name = memberExpression.Member.Name;
			object value = ((FieldInfo)memberExpression.Member).GetValue(constantExpression.Value);
			Type type = value.GetType();
			providedParametars.Add(new Tuple<string, Type, object>(name, type, value));
		}

		/// <summary>
		/// ログメッセージを作成する
		/// </summary>
		/// <param name="ex">例外</param>
		/// <returns>ログメッセージ</returns>
		public static string CreateLogMessage(Exception ex)
		{
			// エラーメッセージ格納用
			var messages = new List<string>();

			// エラーメッセージを格納
			messages.Add(ex.Message);

			// 一番最初に発生した例外を取得する
			while (ex.InnerException != null)
			{
				ex = ex.InnerException;

				// 内部例外のメッセージを格納
				messages.Add(ex.Message);
			}
			
			// ログメッセージを作成する
			string message = string.Join("\r\n", messages);
			if (ex.Data.Contains(ExMessage))
			{
				message += "\r\n\r\n" + string.Join("\r\n", (List<String>)ex.Data[ExMessage]);
			}

			return message;
		}
	}
}
