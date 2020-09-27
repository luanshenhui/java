import axios from 'axios';
import moment from 'moment';


const reportSendDateService = {
  getConsultReptSendLast: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/senthistories/last`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url)
      .then((res) => res.data);
  },

  insert: (params) => {
    const { rsvno } = params;
    let { cslDate } = params;
    if (cslDate === '') {
      cslDate = moment().format('YYYY/MM/DD');
    }
    const data = { lngRsvNo: rsvno, SendDate: cslDate, USERID: '' };
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .post(url, {
        ...data,
      })
      .then((res) => res.data);
  },

  update: (params) => {
    const { rsvno } = params;
    let { cslDate } = params;
    if (cslDate === '') {
      cslDate = moment().format('YYYY/MM/DD');
    }
    // urlの定義
    const data = { lngRsvNo: rsvno, SendDate: cslDate, USERID: '' };
    const url = `/api/v1/consultations/${rsvno}/senthistories`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .put(url, {
        ...data,
      })
      .then((res) => res.data);
  },

  deleteConsultReptSendBefore: (params) => {
    const { rsvno } = params;
    const method = 'DELETE';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/senthistories/before`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios({
      method,
      url,
    })
      .then((res) => res.data);
  },
  getReportSendDateList: (params) => {
    // urlの定義
    const url = '/api/v1/consultations/senthistories';
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },

  deleteConsultReptSend: (params) => {
    // urlの定義
    const url = '/api/v1/consultations/senthistories/sel';
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .delete(url, {
        params,
      })
      .then((res) => res.data);
  },

};

export default reportSendDateService;
