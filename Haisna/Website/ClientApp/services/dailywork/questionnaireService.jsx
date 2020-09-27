import axios from 'axios';


const questionnaireService = {
  // OCR内容確認修正日時を取得
  getEditOcrDate: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/orcdate`;
    // OCR内容確認修正日時を取得API呼び出し
    return axios
      .get(url, {
        params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data);
  },
  // 胃内視鏡の依頼があるかチェックする
  checkGF: (params) => {
    const { rsvno } = params;
    const url = `/api/v1/consultations/${rsvno}/gf`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // OCR入力結果を取得
  getOcrNyuryoku: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/ocrresults`;
    // OCR入力結果を取得API呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },
  // OCR入力結果の入力チェック
  checkOcrNyuryoku: (params) => {
    const { rsvno, data } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/validation/ocr`;
    // OCR入力結果の入力チェックAPI呼び出し
    return axios({
      method,
      url,
      data,
    })
      .then((res) => res.data);
  },
  // OCR入力結果を更新する
  updateOcrNyuryoku: (data) => {
    // 個人検査情報登録
    const { rsvno, results } = data;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/ocrresults`;

    return axios({
      method,
      url,
      data: results,
    })
      .then(() => ({
        data,
      }));
  },
};

export default questionnaireService;
