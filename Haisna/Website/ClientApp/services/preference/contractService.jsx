import axios from 'axios';


const contractService = {
  // 指定団体の全契約情報取得
  getAllCtrMng: (conditions) => {
    const { orgcd1, orgcd2 } = conditions;
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts`;
    // 指定団体の全契約情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は指定団体の全契約情報取得取得成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },
  // 指定契約パターンの契約期間および年齢起算日を取得
  getCtrPt: (params) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 指定契約パターンの負担元および負担金額情報取得
  getCtrPtOrgPrice: (params) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/price`;
    return axios
      .get(url, { params })
      .then((res) => {
        const { data } = res;
        return data;
      });
  },
  // 指定契約パターンにおける指定オプション区分の全負担情報を取得
  getCtrPtPriceOptAll: (params) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/priceoptions`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 成功時は指定契約パターンにおける指定オプション区分の全負担情報を取得成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },
  // 契約情報の読み込み
  getCtrMng: (params) => {
    const { orgcd1, orgcd2, ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/${ctrptcd}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },

  // 契約期間の分割登録
  registerCtrPt: ({ params, data }) => {
    const method = 'PUT';
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}`;
    return axios({
      method,
      url,
      data,
    })
      .then(() => data);
  },

  // 契約期間付きの契約管理情報を取得する
  getCtrMngWithPeriod: ({ ...params }) => {
    const { orgcd1, orgcd2 } = params;
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/periods`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => ({
        dtmArrDate: res.data,
      }));
  },

  // 指定期間において、指定団体・コースの契約情報が存在するかをチェックする
  checkContractPeriod: ({ data }) => {
    // 適用期間取得
    const { orgcd1, orgcd2 } = data;

    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts/periods/existence`;

    return axios
      .get(url, {
        params: data,
      });
  },

  // 指定契約パターンおよびオプションコードのオプション検査情報取得
  getCtrPtOpt: ({ params }) => {
    const { ctrptcd, optcd, optbranchno } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/options/${optcd}/${optbranchno}`;
    return axios
      .get(url)
      .then((res) => {
        // 成功時は指定契約パターンおよびオプションコードのオプション検査情報得成功アクションを呼び出す
        const { data } = res;
        return data;
      });
  },

  // 指定契約パターン、オプションの受診対象年齢条件
  getCtrPtOptAge: ({ params }) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/age`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 成功時は指定契約パターンの負担元および負担金額情報を取得成功アクションを呼び出す
        const { data } = res;
        return data;
      });
  },

  // 指定契約パターン・オプションにおけるグループ取得
  getCtrPtGrp: ({ params }) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/grp`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 成功時は指定契約パターン・オプションにおけるグループ取得成功アクションを呼び出す
        const { data } = res;
        return data;
      });
  },
  // 指定契約パターン・オプションにおける検査項目取得
  getCtrPtItem: ({ params }) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/item`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 成功時は指定契約パターン・オプションにおける検査項目取得成功アクションを呼び出す
        const { data } = res;
        return data;
      });
  },

  // 参照先団体の契約情報が参照元団体から参照可能を取得
  getCtrMngRefer: (params) => {
    const { reforgcd1, reforgcd2, ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/organizations/${reforgcd1}/${reforgcd2}/contracts/${ctrptcd}/references`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 成功時は指定契約パターンおよびオプションコードのオプション検査情報得成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },

  // 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得する
  getCtrPtOptFromConsult: (params) => {
    const { ctrptcd } = params;
    // urlの定義
    const url = `/api/v1/contracts/${ctrptcd}/options/status`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },

  // 指定の条件に該当する受診区分を取得する
  getContractCslDivList: (payload) => {
    const { orgcd1, orgcd2 } = payload;

    const params = { ...payload };
    delete params.orgcd1;
    delete params.orgcd2;

    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/consultdivisions`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  
  // 指定条件に該当する検査項目の受診状態を取得する
  getContractOptionItems: (payload) => {
    const { rsvno } = payload;

    const params = { ...payload };
    delete params.rsvno;

    const url = `/api/v1/consultations/${rsvno}/items`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  
    // 指定団体、コース、日付において有効な全ての受診区分を取得
  getAllCslDiv: (params) => {
    const { orgcd1, orgcd2 } = params;
    // urlの定義
    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/consultdivisions`;
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },
};

export default contractService;
