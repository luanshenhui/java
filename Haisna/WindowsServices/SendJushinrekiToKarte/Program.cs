using Fujitsu.Hainsi.WindowServices.SendJushinreki;

namespace Fujitsu.Hainsi.WindowServices.SendJushinrekiToKarte
{
    public class Program
    {
        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // 連携処理タイプ（カルテ）
            ProgramBase.ExecType = ProgramBase.ExecTypeConstants.Smile;

            // 処理実行
            ProgramBase.Main(args);
        }
    }
}
