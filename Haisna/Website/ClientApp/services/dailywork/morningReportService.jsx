import axios from 'axios';


const morningReportService = {
  // 時間帯別受診者情報を取得する
  getRsvFraDaily: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/reservationgroups';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 同伴者（お連れ様）受診者情報を取得する
  getFriendsDaily: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/friends';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 同姓受診者情報を取得する
  getSameNameDaily: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/samesurnames';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // セット別受診者情報を取得する
  getSetCountDaily: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/setgroups';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // トラブル情報を取得する
  getPubNoteDaily: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/pubnotes';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
};

export default morningReportService;
