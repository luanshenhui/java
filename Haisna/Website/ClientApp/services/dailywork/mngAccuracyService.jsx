import axios from 'axios';

const mngAccuracyService = {
  // 検索条件に従い成績書情報一覧を抽出
  getMngAccuracy: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/accuracies';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
};

export default mngAccuracyService;
