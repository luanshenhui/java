import axios from 'axios';

const perBillService = {
  // 予約番号から個人請求書管理情報を取得する
  getPerBill: ({ rsvno }) => {
    const url = `/api/v1/consultations/${rsvno}/perbills`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 同伴者請求書を取得する
  getFriendsPerBill: ({ csldate, rsvno }) => {
    const method = 'POST';

    const params = { incsldate: csldate, inrsvno: rsvno };

    const url = '/api/v1/perbills/friends';
    return axios({
      method,
      url,
      data: params,
    })
      .then((res) => res.data);
  },

  // 請求書情報 START
  // 請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
  getPerBillCsl: ({ params }) => {
    const { dmddate, billseq, branchno } = params;

    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/consultations`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  // 個人請求明細情報の取得
  getPerBillC: ({ params }) => {
    const { dmddate, billseq, branchno } = params;

    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/details`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  // 個人請求管理情報の取得
  getPerBillBillNo: ({ params }) => {
    const { dmddate, billseq, branchno } = params;

    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },

  // 入金情報の取得
  getPerPayment: ({ params }) => {
    const { paymentdate, paymentseq } = params;

    const url = `/api/v1/perpayments/${paymentdate}/${paymentseq}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },

  // 請求書の取り消し
  deletePerBill: ({ params, redirect }) => {
    const { dmddate, billseq, branchno } = params;

    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}`;

    // グループ削除
    return axios
      .delete(url)
      .then(() => {
        // 次のURLへ遷移
        redirect();
      });
  },
  // 請求書情報 END

  getPaymentConsultInfo: ({ params }) => {
    const rsvno = params;
    const url = `/api/v1/consultations/${rsvno}/perbills`;
    return axios
      .get(url)
      // 予約番号から個人請求書管理情報を取得する
      .then((res) => res.data);
  },

  registerDelDsp: ({ params }) => {
    // 消費税免除処理
    const { rsvno } = params;
    const method = 'PUT';
    const url = `/api/v1/consultaions/${rsvno}/tax/exempt`;
    return axios({
      method,
      url,
    });
  },

  registerPerbill: (params) => {
    // person情報登録
    const method = 'POST';
    const url = '/api/v1/perbills/csl';
    return axios({
      method,
      url,
      data: params,
    });
  },

  registerMergePerbill: (params) => {
    // person情報登録
    const method = 'POST';
    const url = '/api/v1/perbills/merge';
    return axios({
      method,
      url,
      data: params,
    });
  },

  // セット外請求明細情報の取得
  getOtherLineDiv: () => {
    const url = '/api/v1/otherlineitems';
    return axios
      .get(url)
      .then((res) => res.data);
  },

  // 入力チェックと受診確定金額情報、個人請求明細情報の登録
  checkValueAndInsertPerBillc: (params) => {
    const method = 'POST';
    const url = '/api/v1/perbills/details';
    return axios({
      method,
      url,
      data: params,
    });
  },
  // 個人入金情報を登録
  registerPerBillIncome: ({ mode, data }) => {
    const method = 'POST';
    const url = '/api/v1/perpayments';

    return axios({
      method,
      url,
      params: { mode },
      data,
    });
  },
  // 個人入金情報を更新
  updatePerBillIncome: ({ mode, data }) => {
    const method = 'PUT';
    const url = '/api/v1/perpayments';

    return axios({
      method,
      url,
      params: { mode },
      data,
    });
  },
  getBillNoPayment: ({ params }) => {
    const { paymentdate, paymentseq } = params;

    const url = `/api/v1/perbills/${paymentdate}/${paymentseq}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
  getName: ({ params }) => {
    const { dmddate, billseq, branchno } = params;

    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/name`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 個人入金情報テーブルレコードを削除する
  deletePerPayment: ({ params }) => {
    const { paymentSeq } = params;
    const url = `/api/v1/perbills/${paymentSeq}/perpayments`;

    return axios
      .delete(url, { params });
  },
  // 請求書管理情報を更新する
  updatePerBill: (data) => {
    const method = 'PUT';
    const url = '/api/v1/perbills/fields';

    return axios({
      method,
      url,
      data,
    });
  },

  // 入力チェックと受診確定金額情報、個人請求明細情報の登録
  checkValueAndUpdatePerBillc: (params) => {
    const { dmddate, billseq, branchno } = params;
    const method = 'PUT';
    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/detail`;
    return axios({
      method,
      url,
      data: params,
    });
  },

  // セット外請求明細の削除を行う
  deletePerBillc: ({ params }) => {
    const { rsvno, priceseq } = params;
    const url = `/api/v1/perbills/${rsvno}/${priceseq}/detail`;
    // グループ削除
    return axios
      .delete(url);
  },

  // 検索条件に従い個人請求書一覧を抽出する
  getListPerBill: ({ params }) => {
    const url = '/api/v1/perbills';
    return axios({
      url,
      params,
      validateStatus: (status) => (status < 400),
    })
      .then((ds) => {
        // 成功時は団体一覧取得成功アクションを呼び出す  致电成功采取行动以成功获取组列表
        const { totalcount = 0, data = [] } = ds.data;
        return { totalCount: totalcount, data };
      });
  },
  // 請求書コメント
  updataPerBillComment: ({ data }) => {
    const { dmddate, billseq, branchno } = data;
    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/commnet`;
    const method = 'PUT';
    return axios({
      method,
      url,
      data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then(() => {
      });
  },
  // --
  getPerList: (conditions) => {
    // 一覧取得  获取组列表
    // urlの定義  url 的定义
    const url = '/api/v1/perbills/';
    // 団体一覧取得API呼び出し  组列表获取API调用
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 400),
      })
      .then((ds) => {
        // 成功時は団体一覧取得成功アクションを呼び出す  致电成功采取行动以成功获取组列表
        const { totalcount = 0, data = [] } = ds.data;
        return { totalCount: totalcount, data };
      });
  },
  getPerBillNo: (params) => {
    // 団体情報取得
    const { dmddate, billseq, branchno } = params;
    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  // 個人ガイド選択行要素取得
  getPerBillPerson: ({ params }) => {
    const { dmddate, billseq, branchno } = params;
    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/people`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  // 個人請求明細情報の取得
  getPerBillPersonC: ({ params }) => {
    const { dmddate, billseq, branchno } = params;
    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}/people/details`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  // 請求書修正処理
  getUpdatePerBillPerson: ({ data }) => {
    const { dmddate, billseq, branchno } = data;
    const url = `/api/v1/perbills/${dmddate}/${billseq}/${branchno}`;
    const method = 'PUT';
    return axios({
      method,
      url,
      data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then(() => { });
  },
  // 請求書新規作成
  getCreatePerBillPerson: ({ data }) => {
    const url = '/api/v1/perbills/';
    const method = 'POST';
    return axios({
      method,
      url,
      data,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 400),
    })
      .then((res) => (res.data));
  },
};

export default perBillService;
