/**
 * @file 汎用テーブルAPIアクセス処理
 */
import axios from 'axios';

const freeService = {
  // 実年齢の計算
  calcAge: (conditions) => {
    // urlの定義
    const url = '/api/v1/calculate/age';

    // 実年齢の計算API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => ({ realAge: res.data }));
  },

  // 汎用情報一覧取得
  getFree: (conditions) => {
    // urlの定義
    const url = '/api/v1/frees';

    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // 汎用テーブル読み込み
  getFreeByClassCd: (conditions) => {
    // urlの定義
    const url = '/api/v1/frees/classed';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // カード情報の読み込み
  getFreeDate: (conditions) => {
    // urlの定義
    const url = '/api/v1/frees/date';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // FreeCountの取得
  getFreeCount: (freeCd) => {
    const url = '/api/v1/frees/count';
    return axios
      .get(url, {
        params: freeCd,
      })
      .then((res) => (res.data));
  },
  updateFree: (data) => {
    // 汎用情報更新
    const freecd = data.freeCd;
    const url = `/api/v1/frees/${freecd}`;
    const method = 'PUT';
    return axios({
      method,
      url,
      data,
    })
      .then((res) => (res.data));
  },
};

export default freeService;
