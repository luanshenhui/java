namespace Hainsi.Entity.Model.Bbs
{
    /// <summary>
    /// 掲示板データモデル
    /// </summary>
    public class Bbs
    {
		/// <summary>
		/// 表示開始日付
		/// </summary>
		public string StrDate  { get; set; }

		/// <summary>
		/// 表示終了日付
		/// </summary>
		public string EndDate  { get; set; }

		/// <summary>
		/// 投稿者
		/// </summary>
		public string Handle  { get; set; }

		/// <summary>
		/// タイトル
		/// </summary>
		public string Title  { get; set; }

		/// <summary>
		/// メッセージ
		/// </summary>
		public string Message  { get; set; }

		/// <summary>
		/// 投稿ユーザー
		/// </summary>
		public string UpdUser  { get; set; }
			
	}
}