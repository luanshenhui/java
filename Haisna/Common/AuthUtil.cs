using Microsoft.VisualBasic;
using System;
using System.Linq;
using System.Text;

namespace Hainsi.Common
{
	public static class AuthUtil
	{
		/// <summary>
		/// パスワードをエンコードする
		/// </summary>
		/// <param name="rowPassword"></param>
		/// <returns></returns>
		public static string EncryptUserPassword(this string rowPassword)
		{
			// パスワードをバイト列に変換する
			byte[] wkPass = Util.ConvertToBytes(rowPassword);

			byte[] byteSecret;
			string wkSecret = "";

			char[,] passtable = TBLIni();

			for (int i = 0; i < wkPass.Length; i++)
			{
				byte wk = wkPass[i];

				// 左の4ビットを取得
				int w1 = wk / 0x10;
				// 右の4ビットを取得
				int w2 = wk % 0x10;

				// パスワード変換テーブルに収まる場合はテーブルの文字を取得
				// 収まらない場合は16進数をそのまま文字列にする
				if (w1 < 12 && w2 < 12)
				{
					wkSecret += passtable[w1, w2];
				}
				else
				{
					wkSecret += wk.ToString("X");
				}
			}

			// SJISのバイト列に変換する
			byteSecret = Util.ConvertToBytes(wkSecret);

			// 32バイトでカットして文字列に変換する
			return Encoding.GetEncoding("shift_jis").GetString(byteSecret.Take(32).ToArray());
		}


		/// <summary>
		/// パスワードテーブルを初期化する
		/// </summary>
		/// <returns>パスワードテーブル</returns>
		private static char[,] TBLIni()
		{
			string wk;
			var tbl = new char[12, 12];

			// パスワード用テーブル作成
			wk = @"GHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";                   // 46 Word
			wk += @"ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｬｭｮｯ";     // 55 Word
			wk += @"!#$%&'()=-^~|\@`[{;+:*]},<.>/?_｡｢｣･ﾞﾟｰ 《》『』";             // 42 Word

			int k = 0;
			for (int i = 0; i < 12; i++)
			{
				for (int j = 0; j < 12; j++)
				{
					tbl[i, j] = wk.ToCharArray()[k];
					k++;
				}
			}

			return tbl;
		}

		public static string SecretCodeMake(string Pass)
		{
			if (string.IsNullOrEmpty(Pass))
			{
				return string.Empty;
			}

			string wk_pass = string.Empty;

			// パスワードを１６進数に変換
			for (int i = 0; i < Pass.Length; i++)
			{
				char w = Pass[i];
				wk_pass = wk_pass + Convert.ToString(Strings.Asc(w), 16);
			}

			// 暗号の作成
			// 作成した暗号をさらにパスワード用のテーブルに照らし合わせて文字を変換
			int w1;
			int w2;

			string wk = wk_pass.ToUpper();
			string wk2 = string.Empty;
			char[,] passtable = TBLIni();

			for (int i = 0; i < wk.Length; i += 2)
			{
				w1 = Convert.ToInt32(wk[i].ToString(), 16);
				w2 = Convert.ToInt32(wk[i + 1].ToString(), 16);

				// １６進数を１０進数に変換してテーブルの範囲内かチェックする
				if ((w1 < 12) && (w2 < 12))
				{
					// 範囲内ならば１文字に変換する
					wk2 = wk2 + passtable[w1, w2];
				}
				else
				{
					// 範囲外はそのまま
					wk2 = wk2 + wk.Substring(i, 2);
				}
			}

			byte[] wk3 = Encoding.GetEncoding("shift_jis").GetBytes(wk2);

			if (wk3.Length > 32)
			{
				return Encoding.Default.GetString(wk3.Take(32).ToArray());
			}

			return wk2;
		}
	}
}
