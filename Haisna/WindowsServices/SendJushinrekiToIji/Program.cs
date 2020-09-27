using Fujitsu.Hainsi.WindowServices.SendJushinreki;

namespace Fujitsu.Hainsi.WindowServices.SendJushinrekiToIji
{
    public class Program
    {
        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // 連携処理タイプ（医事）
            ProgramBase.ExecType = ProgramBase.ExecTypeConstants.Hope;

            // 処理実行
            ProgramBase.Main(args);
        }
    }
}
