import axios from 'axios';

const resultService = {
  // 予約番号をもって検査結果を取得
  getRsl: (conditions) => {
    const { rsvno, itemcd, suffix } = conditions;
    // urlの定義
    const url = `/api/v1/results/${rsvno}/${itemcd}/${suffix}`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
};

export default resultService;
