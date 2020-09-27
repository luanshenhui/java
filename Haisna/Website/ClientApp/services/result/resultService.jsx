import axios from 'axios';

const resultService = {
  // 予約番号をもって検査結果を取得
  getRsl: (conditions) => {
    const { rsvno, itemcd, suffix } = conditions;
    // urlの定義
    const url = `/api/v1/results/${rsvno}/${itemcd}/${suffix}`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  registerResult: ({ params, data }) => {
    // 検査結果更新
    const { rsvNo } = params;

    let method = 'PUT';
    if (rsvNo === undefined) {
      method = 'POST';
    }

    const url = `/api/v1/results/${(method === 'PUT') ? `${rsvNo}` : ''}`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => {
      });
  },

  // 指定予約番号の検査結果更新
  updateResult: (data) => {
    const { rsvno } = data;
    const { results } = data;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/results/${rsvno}`;
    return axios({
      method,
      url,
      data: results,
    })
      .then(() => ({
        data,
      }));
  },

  // 指定対象受診者の検査結果を取得
  getInquiryResultHistory: (payload) => {
    const params = { ...payload };
    const { perid } = params;
    delete params.perid;
    // url定義
    const url = `/api/v1/people/${perid}/cslresults`;

    return axios
      .get(url, { params })
      .then((res) => res.data);
  },
  
  // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
  // 検査結果一括更新
  updateResultAll: ({ data }) => {
    const method = 'PUT';
    // urlの定義
    const url = '/api/v1/results/bulk';
    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },

  checkRslAllSet1Value: ({ data }) => {
    // urlの定義
    const url = '/api/v1/results/parameters/rslallset1';
    return axios
      .get(url, {
        params: data,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 取得取得成功アクションを呼び出す
        if (res.status === 400) {
          const errorMessage = res.data;
          return { errorMessage };
        }
        return null;
      });
  },

  getRslList: (params) => {
    const { rsvno } = params;
    const method = 'GET';
    // urlの定義
    const url = `/api/v1/results/${rsvno}`;
    return axios({
      method,
      url,
      params,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },
  // 検査結果テーブルを更新
  updateResultForDetail: (params) => {
    const { rsvno, resultDetail } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/results/${rsvno}/detail`;
    return axios({
      method,
      url,
      data: resultDetail,
    })
      .then((res) => (res.data));
  },

  getRslAllSetList: (params) => {
    const { rsvno } = params;
    const method = 'GET';
    // urlの定義
    const url = `/api/v1/results/individuals/${rsvno}`;

    // 検索をAPI呼び出し
    return axios({
      method,
      url,
      params,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },

  checkResult: ({ data }) => {
    const { cslDate, results } = data;
    const method = 'POST';
    // urlの定義
    const url = `/api/v1/results/${cslDate}/validation`;
    // 検索をAPI呼び出し
    return axios({
      method,
      url,
      data: results,
    })
      .then((res) => {
        // 取得取得成功アクションを呼び出す
        const messageData = res.data;
        return { messageData };
      });
  },

  updateResultList: ({ data }) => {
    const method = 'PUT';
    // urlの定義
    const url = '/api/v1/results/list';
    // 来院情報検索をAPI呼び出し
    return axios({
      method,
      url,
      data,
    })
      .then(() => ({}));
  },

  // 検査結果テーブルのコメントと中止フラグを更新する
  updateResultForChangeSet: ({ params, data }) => {
    const rsvno = params;
    const method = 'PUT';
    const url = `/api/v1/results/${rsvno}/commentandstopflag`;
    return axios({
      method,
      url,
      data,
    });
  },

  getRslListSet: (params) => {
    const { grpCd, result } = params;
    const method = 'POST';
    // urlの定義
    const url = `/api/v1/results/${grpCd}/listset`;
    // 検索をAPI呼び出し
    return axios({
      method,
      url,
      data: result,
    })
      .then((res) => {
        // 取得取得成功アクションを呼び出す
        const resultData = res.data;
        return { resultData };
      });
  },
  // 検査結果テーブルを更新する(コメント更新なし)
  updateResultNoCmt: (params) => {
    const { rsvno, resultNoCmt } = params;
    const method = 'PUT';
    const url = `/api/v1/results/${rsvno}/nocomment`;
    return axios({
      method,
      url,
      data: resultNoCmt,
    });
  },
  // 検査結果テーブルを更新する(コメント更新なし)
  updateYudo: (params) => {
    const { rsvno } = params;
    const method = 'PUT';
    const url = `/api/v1/results/${rsvno}/yudo`;
    return axios({
      method,
      url,
    });
  },
};

export default resultService;
