import axios from 'axios';

const demandService = {
  deleteBillDetail: ({ params, redirect }) => {
    // 請求書明細削除
    const { billNo } = params;

    // urlの定義
    const url = `/api/v1/bills/${billNo}/details`;
    const method = 'DELETE';

    // グループ削除
    return axios({
      method,
      url,
      params,
    })
      .then(() => {
        // 次のURLへ遷移
        redirect();
      });
  },
  UpdateBillDetail: (data) => {
    // 請求書明細の更新
    const { BillNo, LineNo } = data;
    const url = `/api/v1/bills/${BillNo}/details/${LineNo}`;
    const method = 'PUT';
    if (data.CslDate != null) {
      const csldate = { StrYear: data.CslDate.substr(0, 4), StrMonth: data.CslDate.substr(5, 2), StrDay: data.CslDate.substr(8, 2) };
      Object.assign(data, csldate);
    }

    return axios({
      method,
      url,
      data,
    });
  },
  InsertBillDetail: (data) => {
    // 請求書明細の登録
    const { BillNo } = data;
    const url = `/api/v1/bills/${BillNo}/details`;
    const method = 'POST';
    if (data.CslDate != null) {
      const csldate = { StrYear: data.CslDate.substr(0, 4), StrMonth: data.CslDate.substr(5, 2), StrDay: data.CslDate.substr(8, 2) };
      Object.assign(data, csldate);
    }

    return axios({
      method,
      url,
      data,
    });
  },
  GetDmdBurdenModifyBillDetail: (conditions) => {
    // 請求書明細取得
    const url = '/api/v1/bills/details';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        const billDetail = res.data;
        return { billDetail };
      });
  },
  getNowTax: (cslDate) => {
    // 請求書基本情報登録
    const url = `/api/v1/bills/${cslDate}`;
    return axios
      .get(url, {
        cslDate,
      })
      .then((res) => {
        const taxRates = res.data;
        return { taxRates };
      });
  },
  insertBill: ({ data, redirect }) => {
    // 請求書基本情報登録
    const url = '/api/v1/bills/bill';
    const method = 'POST';
    return axios({
      method,
      url,
      data,
    })
      .then((res) => {
        // 次のURLへ遷移
        redirect(res.data);
        return res.data;
      });
  },

  getPaymentConsultTotal: ({ params }) => {
    const rsvno = params;
    const url = `/api/v1/consultations/${rsvno}/prices`;
    return axios
      .get(url)
      // 締め管理情報取得する
      .then((res) => res.data);
  },

  getConsultmTotal: ({ params }) => {
    const rsvno = params;
    const url = `/api/v1/consultations/${rsvno}/prices/total`;
    return axios
      .get(url)
      // 個人受診金額小計を取得する
      .then((res) => res.data);
  },

  getPersonalCloseMngInfo: ({ params }) => {
    const { rsvno } = params;
    const url = `/api/v1/consultations/${rsvno}/closings`;
    return axios
      .get(url)
      // 個人毎の締め管理情報を取得する
      .then((res) => res.data);
  },

  // 請求書削除
  deleteAllBill: ({ data }) => {
    const url = '/api/v1/bills';
    const method = 'DELETE';
    return axios({
      method,
      url,
      params: data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((res) => (res.data));
  },
  checkValueDmdPaymentSearch: (data) => {
    const url = '/api/v1/bills/validation';
    // urlの定義
    const method = 'POST';
    return axios({
      method,
      url,
      params: data,
      // axios標準では404エラーも例外として扱われるため、400未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((rec) => (rec));
  },

  getDmdBurdenList: (data) => {
    // urlの定義
    const url = '/api/v1/bills';
    return axios
      .get(url, {
        params: data,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 取得成功アクションを呼び出す
        const { allcount = 0, burdenlist = [] } = res.data;
        return { allCount: allcount, burdenlist };
      });
  },

  getSumDetail: (params) => {
    // 請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
    const lineNo = null;
    const url = `/api/v1/bills/${params}/details/${lineNo}/items/total`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },

  getDmdPaymentBillSum: (billno) => {
    const url = `/api/v1/bills/${billno}/total`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },

  getDmdPaymentPrice: (billno, seq) => {
    const url = `/api/v1/bills/${billno}/payments/${seq}/price`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },

  getPayment: (billno, seq) => {
    const url = `/api/v1/bills/${billno}/payments/${seq}`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },

  delPayment: (params) => {
    const { billno, seq } = params;
    // urlの定義
    const url = `/api/v1/bills/${billno}/payments/${seq}`;
    // グループ削除
    return axios
      .delete(url)
      .then(() => {
      });
  },

  checkValuePayment: (data) => {
    const url = '/api/v1/bills/payments/validation';
    // urlの定義
    const method = 'POST';
    return axios({
      method,
      url,
      params: data,
      // axios標準では404エラーも例外として扱われるため、400未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((rec) => (rec));
  },
  checkPaymentDivValue: (data) => {
    const url = '/api/v1/bills/paymentdivisions/validation';
    // urlの定義
    const method = 'POST';
    return axios({
      method,
      url,
      params: data.params,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((rec) => (rec));
  },

  updatePayment: ({ billno, seq, data }) => {
    const url = `/api/v1/bills/${billno}/payments/${seq}`;
    // urlの定義
    const method = 'PUT';
    return axios({
      method,
      url,
      data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((rec) => (rec));
  },

  insertPayment: ({ billno, data }) => {
    const url = `/api/v1/bills/${billno}/payments`;
    // urlの定義
    const method = 'POST';
    return axios({
      method,
      url,
      data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((rec) => (rec));
  },


  getDmdBurdenDispatch: (conditions) => {
    // 請求書基本情報取得
    const { billNo } = conditions.params;
    const url = `/api/v1/bills/${billNo}/dispatches`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },

  getDmdBurdenBillDetail: (conditions) => {
    // urlの定義
    const { pageSearch, params } = conditions;
    const param = {};
    Object.assign(param, params);
    if (pageSearch) {
      param.page = 1;
    }
    const { billNo } = params;
    const url = `/api/v1/bills/${billNo}/details`;
    // 請求基本書情報検索条件を満たすレコード件数を取得API呼び出し
    return axios
      .get(url, {
        params: param,
      })
      .then((ds) => {
        // 成功時は団体一覧取得成功アクションを呼び出す
        const { totalcount = 0, data = [] } = ds.data;
        return { totalCount: totalcount, data };
      });
  },

  getPaymentAndDispatchCnt: (conditions) => {
    // urlの定義
    const { billNo } = conditions.params;
    const url = `/api/v1/bills/${billNo}/count`;
    // 請求基本書情報入金済み、発送済みチェック取得API呼び出し
    return axios
      .get(url, {
        params: conditions.params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const count = res.data;
        return { count };
      });
  },

  getSumDetailItems: (conditions) => {
    const { billNo, lineNo } = conditions;
    // urlの定義
    const url = `/api/v1/bills/${billNo}/details/${lineNo}/items/total`;
    // 請求基本書情報２次検査の合計金額取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        const record = res.data;
        return { record };
      });
  },

  updateDmdBillComment: ({ params, data }) => {
    // urlの定義
    const obj = {};
    obj.billNo = params;
    const url = `/api/v1/bills/${params}/comment`;
    Object.assign(obj, data);
    const method = 'PUT';
    // 請求コメント取得API呼び出し
    return axios({
      method,
      url,
      data: obj,
      validateStatus: (status) => (status < 400),
    })
      .then(() => { });
  },

  getDmdDetailItmList: (conditions) => {
    // urlの定義
    const urlDetailList = '/api/v1/bills/details/items';
    // 請求書基本情報（２次内訳）取得API呼び出し
    return axios
      .get(urlDetailList, {
        params: conditions.params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((ds) => {
        // 成功時は団体一覧取得成功アクションを呼び出す
        const { totalcount = 0, data = [] } = ds.data;
        return { totalCount: totalcount, data };
      });
  },

  deleteBill: ({ params }) => {
    // 請求書基本情報削除
    const billNo = params;
    // urlの定義
    const url = `/api/v1/bills/${billNo}`;
    // グループ削除
    return axios
      .delete(url)
      .then((rec) => (rec.data));
  },
  checkValueSendCheckDay: (params) => {
    // 請求書発送確認日設定
    const { sendYear, sendMonth, sendDay } = params;
    const url = `api/v1/bills/dispatches/validation/${sendYear}/${sendMonth}/${sendDay}`;
    return axios
      .post(url)
      .then(axios.spread((res1, res2, res3) => {
        const details = res1.data;
        const consultations = res2.data;
        const billNo = res3.data;
        return { details, consultations, billNo };
      }));
  },

  getDispatchSeq: (billNo) => {
    // 発送情報の取得
    const url = `/api/v1/bills/${billNo}/dispatches/max`;
    return axios
      .get(url)
      .then((res) => (res));
  },

  deleteDispatch: ({ params, redirect }) => {
    // 削除処理
    const { billNo, seq } = params;
    const url = `/api/v1/bills/${billNo}${seq}/dispatches`;
    return axios
      .delete(url)
      .then(() => {
        // 次のURLへ遷移
        redirect();
      });
  },

  updateDispatch: ({ params }) => {
    // 更新処理
    const { billNo, seq } = params;
    const url = `/api/v1/bills/${billNo}/dispatches/${seq}`;
    return axios
      .put(url)
      .then((res) => (res));
  },

  insertDispatch: ({ params }) => {
    // 更新処理
    const { billNo } = params;
    const url = `/api/v1/bills/${billNo}/dispatches/`;
    return axios
      .post(url)
      .then((res) => (res));
  },
  getDmdBurdenModifyBillDetail: (billNo, lineNo, startPos, limit) => {
    // 団体情報取得
    const url = '/api/v1/bills/details';
    return axios
      .get(url, {
        params: billNo,
        lineNo,
        startPos,
        limit,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => (res.data));
  },
  registerDmdEditDetailItemLine: ({ data }) => {
    // 請求書明細の更新
    let method = 'PUT';
    if (data.itemno === undefined) {
      // 請求書明細の登録
      method = 'POST';
    }
    const billNo = data.billno;
    const lineNo = data.lineno;
    const itemNo = data.itemno;
    const url = `/api/v1/bills/${billNo}/details/${lineNo}/items/${(method === 'PUT') ? `${itemNo}` : ''}`;
    return axios({
      method,
      url,
      data,
      validateStatus: (status) => (status < 400),
    })
      .then(() => {
      });
  },
  deleteDmdEditDetailItemLine: (params) => {
    const billno = params.billNo;
    const lineno = params.lineNo;
    const itemno = params.itemNo;
    // 請求書明細の登録
    const url = `/api/v1/bills/${billno}/details/${lineno}/items/${itemno}`;
    return axios
      .delete(url)
      .then(() => {
      });
  },
};


export default demandService;
