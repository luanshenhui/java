import axios from 'axios';


const judgementService = {
  insertJudRslWithUpdate: (data) => {
    const url = '/api/v1/judgements/insertjudrslwithupdate';

    return axios({
      method: 'POST',
      url,
      data,
    })
      .then(() => {
      });
  },

  // 手動判定項目と自動判定項目を分けて表示するため修正
  getJudgementStatusAuto: (rsvNo) => {
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/judgements/status/auto`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },


  getJudgementStatusManual: (rsvNo) => {
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/judgements/status/manual`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },


};

export default judgementService;
