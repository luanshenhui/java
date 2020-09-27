import axios from 'axios';

const inquiryService = {
  // 予約番号の判定結果情報を取得
  getInquiryJudRslList: (payload) => {
    const { rsvno } = payload;

    // url定義
    const url = `/api/v1/consultations/${rsvno}/inquiries/judgements/results`;
    return axios
      .get(url, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  // 検索条件を満たすグループの一覧を取得
  getInquiryRslList: (payload) => {
    const { rsvno } = payload;

    const params = { ...payload };
    delete params.rsvno;

    // url定義
    const url = `/api/v1/results/${rsvno}/inquiries`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((rec) => rec.data);
  },
};

export default inquiryService;
