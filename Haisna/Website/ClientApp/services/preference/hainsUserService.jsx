import axios from 'axios';


const hainsUserService = {
  // ユーザ情報取得
  getHainsUser: (conditions) => {
    const { userid } = conditions;
    // urlの定義
    const url = `/api/v1/users/${userid}`;
    // ユーザ情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => (res.data));
  },
};

export default hainsUserService;
