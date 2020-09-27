import axios from 'axios';

const dmdAddUpService = {
  // 入力チェック
  dmdAddupCheck: ({ data }) => {
    const url = '/api/v1/bills/close/validation';
    const method = 'POST';
    return axios({
      method,
      url,
      params: data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((res) => (res.data));
  },
  // 締め処理起動
  dmdAddupExecute: (data) => {
    const url = '/api/v1/bills/close';
    const method = 'POST';
    return axios({
      method,
      url,
      params: data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((res) => (res.data));
  },
};

export default dmdAddUpService;
