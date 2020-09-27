/**
 * @file 管理端末用非同期処理
 */
import axios from 'axios';

const workStationService = {
  // 管理端末一覧取得
  getWorkStationList: () => {
    const url = '/api/v1/workstations';
    return axios
      .get(
        url,
        {
          // axios標準では404エラーも例外として扱われるため404をエラーから除外する
          validateStatus: (status) => (status === 404 || status < 400),
        },
      )
      .then((res) => res.data);
  },
  // 管理端末情報取得
  getWorkStation: (payload) => {
    const { ipaddress } = payload;
    const url = `/api/v1/workstations/${ipaddress}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 管理端末情報登録処理
  registerWorkStation: (payload) => {
    const { params, data } = payload;
    const { ipaddress } = params;
    // パラメータにIPアドレスがセットされていなければ挿入（POST）、そうでなければ更新（PUT）
    const method = (ipaddress === undefined) ? 'POST' : 'PUT';

    // 登録用URLの定義
    const url = `/api/v1/workstations/${(method === 'PUT') ? `${ipaddress}` : ''}`;

    // 管理端末情報登録API呼び出し
    return axios({
      method,
      url,
      data,
    })
      .then((res) => res.data);
  },
  // 管理端末情報削除処理
  deleteWorkStation: (payload) => {
    const { ipaddress } = payload.params;
    // URL定義
    const url = `/api/v1/workstations/${ipaddress}`;

    // 管理端末情報削除API呼び出し
    return axios
      .delete(url)
      .then((res) => res.data);
  },
  getWorkstation: () => {
    const method = 'GET';
    // urlの定義
    const url = '/api/v1/workstations/me';

    // 来院情報検索をAPI呼び出し
    return axios({
      method,
      url,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },
};

export default workStationService;
