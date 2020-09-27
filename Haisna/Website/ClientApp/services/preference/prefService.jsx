import axios from 'axios';


const prefService = {
  // 都道府県コードに対する都道府県名を取得する
  getPref: (params) => {
    const { prefcd } = params;
    const url = `/api/v1/prefectures/${prefcd}`;
    return axios
      .get(url, {
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data);
  },
};

export default prefService;
