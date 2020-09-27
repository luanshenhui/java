import axios from 'axios';


const bbsService = {
  getAllBbs: ({ params }) => {
    // コメントを取得
    // urlの定義
    const url = '/api/v1/bbs';
    // 今日のコメントを取得API呼び出し
    return axios
      .get(url, {
        params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は今日のコメントを取得成功アクションを呼び出す
        const { data = [] } = res;
        return { data };
      });
  },
  deleteBbs: ({ params }) => {
    // コメント情報削除
    const { bbskey } = params;

    // urlの定義
    const url = `/api/v1/bbs/${bbskey}`;

    // コメント削除
    return axios
      .delete(url)
      // 次のURLへ遷移
      .then(() => ({}));
  },
  registerBbs: ({ data }) => {
    // コメントの登録
    const url = '/api/v1/bbs';
    return axios({
      method: 'POST',
      url,
      data,
    })
      // 次のURLへ遷移
      .then(() => ({}));
  },
};

export default bbsService;
