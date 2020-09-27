import axios from 'axios';


const decideAllConsultPriceService = {
  decideAllConsultPrice: (conditions) => {
    // 指定予約番号の負担金額情報を取得する
    // urlの定義
    const url = '/api/v1/consultations/prices';
    const method = 'PUT';
    return axios({
      method,
      url,
      params: conditions,
    })
      .then((res) => {
        const totalCount = res.data;
        return { totalCount };
      });
  },
};

export default decideAllConsultPriceService;
