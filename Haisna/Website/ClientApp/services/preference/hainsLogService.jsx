import axios from 'axios';


const hainsLogService = {
  getHainsLog: (conditions) => {
    // システムログの表示情報取得
    const url = '/api/v1/hainslogs';
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const { data } = res;
        return data;
      });
  },
};

export default hainsLogService;
