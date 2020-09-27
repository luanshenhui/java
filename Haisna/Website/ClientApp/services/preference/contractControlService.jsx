import axios from 'axios';
import * as Contants from '../../constants/common';

const contractControlService = {
  // 参照中契約情報のコピー処理
  registerCopy: ({ data }) => {
    const method = 'POST';
    const url = '/api/v1/contracts/copy';
    return axios({
      method,
      url,
      data,
    })
      .then(() => {
      });
  },
  // 契約情報の参照を解除する
  deleteRelease: ({ data }) => {
    const { orgcd1, orgcd2, ctrptcd } = data;
    const method = 'DELETE';
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}`;
    return axios({
      method,
      url,
      data,
    })
      .then(() => {
      });
  },

  // 契約情報の削除処理
  deleteContract: ({ data, redirect }) => {
    const { orgcd1, orgcd2, ctrptcd } = data;
    const method = 'DELETE';
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}/contract`;

    // グループ削除
    return axios({
      method,
      url,
      data,
    })
      .then(() => {
        redirect();
      });
  },

  // 契約期間の分割登録
  registerSplit: ({ params, data }) => {
    const { orgcd1, orgcd2, ctrptcd } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}/split/`;
    return axios({
      method,
      url,
      data,
    });
  },

  // 契約期間を更新する
  updatePeriod: ({ params, data }) => {
    const { orgcd1, orgcd2, ctrptcd } = params;
    const method = 'PUT';
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}/periods`;

    return axios({
      method,
      url,
      data,
    })
      .then((res) => ({
        data: res.data,
      }));
  },

  // 限度額情報の更新
  updateLimitPrice: ({ params, data }) => {
    const method = 'PUT';
    const { orgcd1, orgcd2, ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}/price`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },
  // 限度額情報の更新
  checkLimitPrice: ({ data }) => {
    const method = 'POST';
    // urlの定義
    const url = '/api/v1/contracts/price/validation';
    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },
  // オプションの削除処理
  deleteOption: (params) => {
    const { orgcd1, orgcd2, ctrptcd, optcd, optbranchno } = params;
    const method = 'DELETE';
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}/${optcd}/${optbranchno}/option`;

    // グループ削除
    return axios({
      method,
      url,
    })
      .then(() => ({}));
  },
  // 新しい契約情報を作成
  insertContract: ({ data }) => {
    const method = 'POST';

    const url = '/api/v1/contracts';
    return axios({
      method,
      url,
      data,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => ({
        data: res.data,
      }));
  },

  // 契約情報の更新
  updateContract: ({ data }) => {
    const method = 'PUT';

    const url = `/api/v1/organizations/${data.orgcd1}/${data.orgcd2}/contracts/${data.ctrPtCd}`;
    return axios({
      method,
      url,
      data,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => ({
        data: res.data,
      }));
  },

  // 契約情報の参照処理
  refer: (data) => {
    const { reforgcd1, reforgcd2, ctrptcd } = data;
    const method = 'POST';
    // urlの定義
    const url = `/api/v1/organizations/${reforgcd1}/${reforgcd2}/contracts/${ctrptcd}/references`;
    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },

  // 契約情報のコピー処理
  copy: (data) => {
    const { reforgcd1, reforgcd2, ctrptcd } = data;
    const method = 'POST';
    // urlの定義
    const url = `/api/v1/organizations/${reforgcd1}/${reforgcd2}/contracts/${ctrptcd}/copy`;
    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },
  // 追加オプションの書き込み処理
  setAddOption: ({ params, data }) => {
    const { optcd, optbranchno, ctrptcd, orgcd1, orgcd2, mode } = params;

    let method = 'PUT';
    if (mode === Contants.MODE_INSERT || mode === Contants.MODE_COPY) {
      method = 'POST';
    }
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}/options/${(method === 'PUT') ? `${optcd}/${optbranchno}` : ''}`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => ({}));
  },
};

export default contractControlService;
