using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MethodBoundaryAspect.Fody.Attributes;

namespace Hainsi.Common
{
	/// <summary>
	/// 例外メッセージの編集を行う
	/// </summary>
	public class LoggingParamAttribute : OnMethodBoundaryAspect
	{
		/// <summary>
		/// 例外フック処理
		/// </summary>
		/// <param name="arg">例外をthrowしたメソッドの情報</param>
		public override void OnException(MethodExecutionArgs arg)
		{
			// 編集フラグ
			string isEdited = "IsEdited";

			// メッセージが編集されていなければ編集する
			if (!arg.Exception.Data.Contains(isEdited))
			{
				Exception ex = ParamLogUtility.EditException(arg);

				// 編集フラグを立てる
				ex.Data.Add(isEdited, true);
			}
		}
	}
}
