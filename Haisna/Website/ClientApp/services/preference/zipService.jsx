import axios from 'axios';

const zipService = {
  getZipList: (conditions) => {
    // 郵便番号一覧取得
    // urlの定義
    const url = '/api/zip/';
    // 郵便番号一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、404は正常と判断するように変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => {
        // 成功時は郵便番号一覧取得成功アクションを呼び出す
        const { totalcount = 0, data = [] } = res.data;
        return { totalCount: totalcount, data };
      });
  },
};

export default zipService;
