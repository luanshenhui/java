// @flow

import axios from 'axios';

// Type定義

// グループ
export type Group = {
  grpdiv: string,
  grpcd: string,
  grpname: string,
  classcd: string,
  classname: string,
  searchchar: string,
  systemgrp: string,
  oldsetcd: string,
};

const groupService = {
  // 検索条件を満たすグループの一覧を取得
  getGrpIListGrpDiv: (params) => {
    const { grpdiv } = params;
    // urlの定義
    const url = `/api/v1/groupdivisions/${grpdiv}/groups`;
    // グループ取得
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // グループ一覧取得
  getGroupList: (conditions: Object) => {
    // urlの定義
    const url = '/api/v1/groups/';
    // パラメーターの定義
    const [page, limit] = [1, 20];
    const params = { page, limit, ...conditions };
    // グループ一覧取得
    return axios
      .get(url, {
        params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const totalCount = res.data.totalcount || 0;
        const data = res.data.data || [];
        return { totalCount, data };
      });
  },
  // グループ取得
  getGroup: (grpcd: string) => {
    // urlの定義
    const url = `/api/v1/groups/${grpcd}`;
    // グループ取得
    return axios
      .get(url)
      .then((res) => (
        res.data
      ));
  },
  // グループの登録
  registerGroup: ({ grpcd, group }: Object) => {
    // request methodの定義
    const method = (grpcd !== undefined) ? 'PUT' : 'POST';
    // urlの定義
    const url = `/api/v1/groups/${(method === 'PUT') ? group.grpcd : ''}`;
    // グループ登録
    return axios({ method, url, data: group });
  },
  // 指定グループコードのグループ削除
  deleteGroup: (grpcd: string) => {
    // urlの定義
    const url = `/api/v1/groups/${grpcd}`;
    // グループ削除
    return axios.delete(url);
  },
  // eslint-disable-next-line
  getGroupByDivision: (grpDiv: string) => {
    // 検査結果グループレコードを得る
    return axios
      .get('/api/group/result')
      .then((res) => {
        const payload = res.data.map((rec) => ({
          value: rec.grpcd,
          name: rec.grpname,
        }));
        return { payload };
      })
      .catch((error) => {
        const { status, data } = error.response;
        return { error: { status, data } };
      });
  },
  // 指定グループ区分のグループ一覧取得
  getGroupListByDivision: (
    grpDiv: 1 | 2,
    params: {
      classCd: string,
      noDataFound: 0 | 1,
    },
  ): Array<Group> => {
    // urlの定義
    const url = `/api/v1/groupdivisions/${grpDiv}/groups`;
    // API呼び出し
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data || []);
  },
  // 指定グループの検査項目を取得
  getGroupItems: (payload: { grpcd: string }) => {
    const { grpcd } = payload;

    // urlの定義
    const url = `/api/v1/groups/${grpcd}/items`;
    // API呼び出し
    return axios
      .get(url)
      .then((res) => res.data);
  },

  getGrpIItemDefResultList: (conditions) => {
    const { grpcd } = conditions;
    // urlの定義
    const url = `/api/v1/groups/${grpcd}/itemsandresults`;

    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は面接支援一覧取得成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },

  GetGrpIItemList: (conditions) => {
    const { grpcd } = conditions;
    // urlの定義
    const url = `/api/v1/groups/${grpcd}/items`;

    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は面接支援一覧取得成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },
};

export default groupService;
