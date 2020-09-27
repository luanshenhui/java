// @flow

/**
 * @file 文章アクセス用API定義
 */

import axios from 'axios';

import { type ItemType } from '../../types/type';

// 文章分類
export type SentenceClass = {
  stcclasscd: string,
  stcclassname: string,
};

// 文章
export type Sentence = {
  stccd: string,
  shortstc: string,
};

const itemService = {
  // 文章分類一覧取得
  getSentenceClassList: (params: { itemCd: string, itemType: ItemType }): Array<SentenceClass> => {
    // urlの定義
    const url = '/api/v1/sentenceclasses';
    // API呼び出し
    return axios
      .get(url, {
        params,
        validateStatus: (status) => status < 500,
      })
      .then((res) => res.data || []);
  },
  // 文章一覧取得
  getSentenceList: (params: { itemCd: string, itemType: ItemType, stcClassCd?: string }): Array<Sentence> => {
    // urlの定義
    const url = '/api/v1/sentences';
    // API呼び出し
    return axios
      .get(url, {
        params,
        validateStatus: (status) => status < 500,
      })
      .then((res) => res.data || []);
  },
  getSentence: (params: { itemCd: string, itemType: ItemType, stcCd: string }): Sentence => {
    // urlの定義
    const { itemCd, itemType, stcCd } = params;
    const url = `/api/v1/sentences/${itemCd}/${itemType}/${stcCd}`;
    // API呼び出し
    return axios
      .get(url, {
        validateStatus: (status) => status < 500,
      })
      .then((res) => res.data || []);
  },
  getSentenceWithSuffix: (params: { itemCd: string, suffix: string, itemType: ItemType, stcCd: string }): Sentence => {
    // urlの定義
    const { itemCd, itemType, stcCd, suffix } = params;
    const url = `/api/v1/sentences/${itemCd}/${suffix}/${itemType}/${stcCd}`;
    // API呼び出し
    return axios
      .get(url, {
        validateStatus: (status) => status < 500,
      })
      .then((res) => res.data || []);
  },
};

export default itemService;
