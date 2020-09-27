import axios from 'axios';


const failSafeService = {
  getFailSafeInfo: ({ inStrDate, inEndDate }) => {
    // 受診情報の読み込み一覧取得
    // urlの定義
    const url = '/api/v1/consultations/failsafe';
    return axios
      .get(url, {
        params: { strCslDate: inStrDate, endCslDate: inEndDate },
      })
      .then((res) => ({ data: res.data }));
  },
};

export default failSafeService;
