// @flow

import axios from 'axios';

// Type定義

// 判定
export type Jud = {
  judcd: string,
  judrname: string,
  weight: string,
  judsname: string,
  webcolor: string,
};

const judService = {
  // 判定一覧取得
  getJudList: () => {
    // urlの定義
    const url = '/api/v1/judcodes';
    // API呼び出し
    return axios
      .get(url, {
        validateStatus: (status) => status < 500,
      })
      .then((res: { data: Array<Jud> }) => res.data || []);
  },
};

export default judService;
