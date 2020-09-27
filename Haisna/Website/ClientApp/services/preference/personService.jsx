import axios from 'axios';


const personService = {
  getPersonList: (conditions) => {
    // urlの定義
    const url = '/api/v1/people/';
    // 個人一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は団体一覧取得成功アクションを呼び出す
        const { totalcount = 0, data = [] } = res.data;
        return { totalCount: totalcount, data };
      });
  },

  // 個人情報取得
  getPerson: ({ params }) => {
    const { perid } = params;
    // urlの定義
    const url = `/api/v1/people/${perid}`;
    return axios
      .get(url)
      .then((res) => {
        const { data } = res;
        return data;
      });
  },

  // 個人住所情報取得
  getPersonAddr: ({ params }) => {
    const { perid } = params;

    // urlの定義
    const url = `/api/v1/people/${perid}/addresses`;

    return axios
      .get(url)
      .then((res) => {
        const { data } = res;
        return data;
      });
  },

  // 指定個人IDの個人属性情報を取得します
  getPersonDetail: ({ params }) => {
    const { perid } = params;

    // urlの定義
    const url = `/api/v1/people/${perid}/details`;

    return axios
      .get(url)
      .then((res) => {
        const { data } = res;
        return data;
      });
  },

  // 個人情報登録/更新処理
  registerPerson: ({ params, data }) => {
    const { perid } = params;
    let method = 'PUT';
    if (perid === undefined) {
      method = 'POST';
    }
    // urlの定義
    const url = `/api/v1/people/${(method === 'PUT') ? perid : ''}`;

    // グループ登録/更新
    return axios({
      method,
      url,
      data,
    })
      .then((res) => res.data);
  },

  // 個人情報削除
  deletePerson: ({ params }) => {
    const { perid } = params;
    // urlの定義
    const url = `/api/v1/people/${perid}`;

    // グループ削除
    return axios
      .delete(url)
      .then((res) => res.data);
  },

  // 指定個人IDの個人情報取得（簡易版）
  getPersonInf: ({ params }) => {
    // 個人情報取得
    const { perid } = params;
    const url = `/api/v1/people/${perid}/informations`;
    return axios
      .get(url)
      .then((res) => {
        // 個人情報フォームの初期化アクションに今取得した個人情報を渡す
        const { data } = res;
        return { data };
      });
  },

  // 個人ＩＤより氏名を取得する
  getPersonLukes: ({ params }) => {
    const { perid } = params;
    const url = `/api/v1/people/${perid}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
};

export default personService;
