import axios from 'axios';


const judgementControllService = {
  judgeAutomaticallyMain: (conditions) => {
    // urlの定義
    const url = '/api/v1/judgements';
    // 総合コメント取得API呼び出し
    return axios
      .post(url, { ...conditions })
      .then((res) => res.data);
  },

};

export default judgementControllService;
