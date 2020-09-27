import axios from 'axios';


const pubNoteService = {
  // 指定ユーザに対して権限のあるノート分類の一覧を取得
  getPubNoteDivList: () => {
    // urlの定義
    const url = '/api/v1/users/me/pubnotedivisions';
    // ユーザ情報取得API呼び出し
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  // 指定された条件のコメントを取得
  getPubNote: (conditions) => {
    // urlの定義
    const url = '/api/v1/pubnotes';
    // ユーザ情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => (res.data));
  },
  // ノート分類コードに対するノート分類名を取得
  getPubNoteDiv: (conditions) => {
    // urlの定義
    const url = '/api/v1/users/me/pubnotedivision';
    // ユーザ情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => (res.data));
  },
  registerPubNote: ({ data }) => {
    // 団体情報登録
    const { seq } = data;
    let method = 'PUT';
    if (seq === undefined || seq === 0) {
      method = 'POST';
    }
    const url = `/api/v1/pubnotes/${(method === 'PUT') ? `${seq}` : ''}`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => ({}));
  },
  deletePubNote: (conditions) => {
    // 団体情報登録
    const { seq } = conditions;
    const url = `/api/v1/pubnotes/${seq}`;

    return axios
      .delete(url, {
        params: conditions,
      })
      .then(() => ({}));
  },
};

export default pubNoteService;
