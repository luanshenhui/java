import axios from 'axios';


const specialinterviewService = {

  // 特定保健指導対象者チェック
  checkSpecialTarget: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/special`;

    // 特定保健指導対象者チェックAPI呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 指定予約番号の契約情報の中の特定健診セット情報を取得する
  getSetClassCd: (conditions) => {
    const { rsvNo } = conditions;
    // 指定された条件のコメントを取得する
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/special/setclass`;
    // 指定された条件のコメント取得API呼び出し
    return axios

      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => (
        // 成功時は指定された条件のコメント取得成功アクションを呼び出す
        { classCdData: res.data }
      ));
  },

  // 予約番号をキーに指定対象受診者の検査結果を取得する
  getSpecialRslView: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/special/views`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // 指定された予約番号の階層化コメントを取得する
  getSpecialJudCmt: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/special/totalcomments`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // 予約番号をもって検査結果を取得
  getSpecialResult: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/special/results`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 階層化コメント 保存
  updateSpecialJudCmt: ({ data }) => {
    const { rsvno } = data;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/specialJudcomments`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => ({}));
  },
};

export default specialinterviewService;
