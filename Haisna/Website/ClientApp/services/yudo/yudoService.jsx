/**
 * @file 誘導APIアクセス処理
 */
import axios from 'axios';

const yudoService = {
  // 診察状態取得
  getConsultationMonitorStatus: () => {
    // urlの定義
    const url = '/api/v1/yudo/consultation/monitor/status';
    // 診察状態取得API呼び出し
    return axios
      .get(url, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data || []);
  },
};

export default yudoService;
