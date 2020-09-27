// @flow

import axios from 'axios';

// Type定義

// 検査分類
export type ItemClass = {
  classcd: string,
  classname: string;
};

// 検査項目
export type Item = {
  itemcd: string,
  suffix: string,
  itemname: string,
  resulttype: string,
  itemtype: string,
  cutargetflg: string,
  classname: string,
};

// 依頼項目
export type RequestItem = {
  itemcd: string,
  classcd: string,
  rslque: string,
  requestname: string,
  requestsname: string,
  progresscd: string,
  entryok: string,
  searchchar: string,
  opeclasscd: string,
  classname: string,
  progressname: string,
  opeclassname: string,
};

const itemService = {
  // 検査分類一覧取得
  getItemClassList: (): Array<ItemClass> => {
    // urlの定義
    const url = '/api/v1/itemclasses';
    // API呼び出し
    return axios
      .get(url, {
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data || []);
  },
  // 検査項目一覧取得
  getItemList: (params: {
    classCd?: string,
  }): Array<Item> => {
    // urlの定義
    const url = '/api/v1/items';
    // API呼び出し
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data || []);
  },
  // 依頼項目一覧取得
  getRequestItemList: (params: {
    classCd?: string,
  }): Array<RequestItem> => {
    // urlの定義
    const url = '/api/v1/requestitems';
    // API呼び出し
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data || []);
  },
};

export default itemService;
