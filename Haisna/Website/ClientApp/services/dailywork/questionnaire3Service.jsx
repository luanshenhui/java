import axios from 'axios';


const questionnaire3Service = {
  // OCR内容確認修正日時を取得
  getEditOcrDate: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/orc3date`;
    // OCR内容確認修正日時を取得API呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },
  // OCR入力結果を取得
  getOcrNyuryoku: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/ocr3results`;
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
    const url = `/api/v1/consultations/${rsvno}/validation3`;
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
    const url = `/api/v1/consultations/${rsvno}/ocr3results`;

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

export default questionnaire3Service;
