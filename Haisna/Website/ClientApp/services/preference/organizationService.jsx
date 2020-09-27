import axios from 'axios';


const organizationService = {
  getOrg: (params) => {
    // 団体情報取得
    const { orgcd1, orgcd2 } = params;
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  registerOrg: ({ params, data, redirect }) => {
    // 団体情報登録
    const { orgcd1, orgcd2 } = params;

    let method = 'PUT';
    if (orgcd1 === undefined || orgcd2 === undefined) {
      method = 'POST';
    }

    const url = `/api/v1/organizations/${(method === 'PUT') ? `${data.org.orgcd1}/${data.org.orgcd2}` : ''}`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => {
        // 次のURLへ遷移
        redirect();
      });
  },
  deleteOrg: ({ params, redirect }) => {
    // 団体情報削除
    const { orgcd1, orgcd2 } = params;

    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}`;

    // グループ削除
    return axios
      .delete(url)
      .then(() => {
        // 次のURLへ遷移
        redirect();
      });
  },
  getOrgList: (conditions) => {
    // 団体一覧取得
    // urlの定義
    const url = '/api/v1/organizations/';
    // 団体一覧取得API呼び出し
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

  getOrgRptOpt: ({ orgcd1, orgcd2 }) => {
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/reportoption`;
    // 成績書オプション管理取得API呼び出し
    return axios
      .get(url, {
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成績書オプション管理取得成功アクションを呼び出す
        const { orgrptoptrptv, orgrptoptrptd } = res.data;
        return { orgrptoptrptv, orgrptoptrptd };
      });
  },
  registerOrgRptOpt: ({ orgcd1, orgcd2, data }) => {
    // 成績書オプション管理情報登録
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/reportoption`;

    return axios({
      method: 'PUT',
      url,
      data,
    })
      .then(() => {
      });
  },
  getOrgHeader: (params) => {
    const { orgcd1, orgcd2 } = params;
    // 団体コードをキーに団体テーブルを読み込む
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/header/`;

    return axios
      .get(url)
      .then((res) => (res.data));
  },
  getSelDateOrg: ({ params }) => {
    // 受診者数取得（団体別）
    // urlの定義
    const url = '/api/v1/consultations/organizations';
    // 受診者数取得（団体別）PI呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 受診者数取得（団体別）成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },
};

export default organizationService;
