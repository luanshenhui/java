import axios from 'axios';


const progressService = {
  getProgress: (progressCd) => {
    const url = `/api/v1/progresses/${progressCd}`;
    return axios
      .get(url, {
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const { data } = res;
        return data;
      });
  },

  // 全ての進捗分類情報を取得する
  getProgressList: () => {
    // urlの定義
    const url = '/api/v1/progresses';
    return axios
      .get(url)
      .then((res) => (res.data));
  },

  // 現受診情報の進捗状況を読み込む
  getProgressRsl: (rsvNo) => {
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/progresses`;
    return axios
      .get(url)
      .then((res) => (res.data));
  },


};

export default progressService;
