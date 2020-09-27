import axios from 'axios';


const questionnaire1Service = {
  // OCR内容確認修正日時を取得
  getEditOcrDate: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/orcdate1`;
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
    const url = `/api/v1/consultations/${rsvno}/gf1`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // OCR入力結果を取得
  getOcrNyuryoku: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/ocrresults1`;
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
    const url = `/api/v1/consultations/${rsvno}/validation/ocr1`;
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
    const url = `/api/v1/consultations/${rsvno}/ocrresults1`;

    return axios({
      method,
      url,
      data: results,
    })
      .then(() => ({
        data,
      }));
  },
  // 該当受診者の受診日チェック
  checkCslDate: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/ocrnyuryoku1/${rsvno}/csldate1`;
    // 該当受診者の受診日チェックAPI呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
};

export default questionnaire1Service;
