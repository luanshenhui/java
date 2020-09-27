import axios from 'axios';

const webOrgRsvService = {

  getWebOrgRsv: (params) => {
    // 契約情報の読み込み
    const { webno, csldate } = params;
    const method = 'GET';
    const url = `/api/v1/weborgreserves/${csldate}/${webno}`;
    return axios({
      method,
      url,
      params,
    })
      .then((res) => (res.data));
  },

  regist: (data) => {
    const method = 'POST';
    const url = '/api/v1/weborgreserves';
    return axios({
      method,
      url,
      data,
    })
      .then((res) => (res.data));
  },

  // 指定検索条件のweb予約情報のうち、指定受診年月日、webNoの次レコードを取得
  getWebOrgRsvNext: (params) => {
    // 契約情報の読み込み
    const { webno, csldate } = params;
    const method = 'GET';
    const url = `/api/v1/weborgreserves/${csldate}/${webno}/next`;
    return axios({
      method,
      url,
      params,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },
  // web予約時登録された予約番号で予約情報チェック（受付されてない保留状態の予約情報かをチェック）
  getConsultCheck: (params) => {
    const method = 'POST';
    const url = '/api/v1/weborgreserves/validation';
    return axios({
      method,
      url,
      params,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },

  getWebOrgRsvList: (conditions) => {
    const url = '/api/v1/weborgreserves/';
    // web団体予約情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const { totalcount = 0, data = [] } = res.data;
        return { totalCount: totalcount, data };
      });
  },
};

export default webOrgRsvService;
