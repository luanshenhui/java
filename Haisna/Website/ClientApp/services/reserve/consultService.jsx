import axios from 'axios';
import moment from 'moment';

const consultService = {
  getConsultList: (conditions) => {
    // 受診者一覧取得
    // urlの定義
    const url = '/api/v1/consultations/';
    // 受診者一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const { totalcount = 0, data = [] } = res.data;
        return { totalCount: totalcount, data };
      });
  },
  // 受診情報取得
  getConsult: (payload) => {
    // 受診者取得
    const { rsvno } = payload;

    // パラメータ
    const params = { ...payload };
    delete params.rsvno;

    // urlの定義
    const url = `/api/v1/consultations/${rsvno}`;
    // 受診者取得API呼び出し
    return axios
      .get(url, params)
      .then((res) => {
        const data = { rsvno, ...res.data };
        return data;
      });
  },
  getConsultOptions: ({ rsvno }) => {
    // 検査オプション取得
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/options`;
    return axios
      .get(url, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  getConsultDetail: ({ rsvno }) => {
    // 受診付属情報取得
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/detail`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  registerConsult: ({ params, data }) => {
    // 受診情報保存処理
    const { rsvno } = params;
    // メソッド定義
    const method = (rsvno !== undefined) ? 'PUT' : 'POST';
    // URLの定義
    const url = `/api/v1/consultations/${(method === 'PUT') ? rsvno : ''}`;
    return axios({ method, url, data })
      .then((res) => res.data);
  },
  validateDayId: (payload) => {
    // 受付時の当日IDチェック
    const url = '/api/v1/consultations/dayid/validation';
    return axios
      .post(url, payload)
      .then((res) => res.data);
  },
  validateConsult: ({ params, data }) => {
    // 受診情報バリデーション処理
    const { rsvno } = params;
    // メソッド定義
    const method = (rsvno !== undefined) ? 'PUT' : 'POST';
    // URLの定義
    const url = `/api/v1/consultations/${(method === 'PUT') ? `${rsvno}/` : ''}validation`;
    return axios({ method, url, data })
      .then((res) => res.data);
  },
  getPrintStatus: (payload) => {
    // 印刷状況を取得する
    const { rsvno } = payload;

    // URLの定義
    const url = `/api/v1/consultations/${rsvno}/printstatus`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  registerPrintStatus: (payload) => {
    // 印刷状況を登録する
    const { rsvno } = payload;

    const data = { ...payload };
    delete data.rsvno;

    // URLの定義
    const url = `/api/v1/consultations/${rsvno}/printstatus`;
    return axios
      .put(url, data)
      .then((res) => res.data);
  },
  cancelReception: (payload) => {
    // 受付取り消し処理
    const { rsvno } = payload;

    const params = { ...payload };
    delete params.rsvno;

    // URLの定義
    const url = `/api/v1/receptions/${rsvno}`;
    return axios.delete(url, { params })
      .then((res) => res.data);
  },
  registerCancelConsult: ({ params, data }) => {
    // キャンセル処理
    const { rsvno } = params;
    const url = `/api/v1/consultations/${rsvno}/cancel`;
    return axios
      .put(url, data)
      .then((res) => res.data);
  },
  registerConsultItems: (payload) => {
    // 受診状態登録処理
    const { rsvno } = payload;

    const data = { ...payload };
    delete data.rsvno;

    // URLの定義
    const url = `/api/v1/consultations/${rsvno}/items`;
    return axios
      .put(url, data)
      .then((res) => res.data);
  },
  // 指定年月の受診情報、翌月以降で最古の受診情報、前月以前で最新の受診情報を取得
  getResentConsultHistory: (payload) => {
    const { year, month, perid, currsvno } = payload;

    // URL定義
    const url = `/api/v1/people/${perid}/consultations`;
    // 受診情報読み込み
    return axios
      .get(url, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => {
        const { data } = res.data;

        // 初期設定
        const date = moment(`${year}/${month}/1`);
        const firstDayOfNextMonth = date.clone().add(1, 'months');
        const lastDayOfPrevMonth = date.clone().subtract(1, 'days');

        const targets = data && data.filter((rec) => (
          // ドック、定期健診を対象
          // 指定予約番号の受診情報は除外
          (rec.cscd === '100' || rec.cscd === '110') &&
          !(currsvno && rec.rsvno === currsvno)
        ));

        // 翌月以降の受診日
        const largerCsl = targets.filter((rec) => moment(rec.csldate).isAfter(firstDayOfNextMonth, 'day'));
        // 前月以前の受診日
        const smallerCsl = targets.filter((rec) => moment(rec.csldate).isBefore(lastDayOfPrevMonth, 'day'));
        // 指定年月の受診日
        const inRange = targets.filter((rec) => moment(rec.csldate).isBetween(lastDayOfPrevMonth, firstDayOfNextMonth, 'days'));

        const cslDates = [...inRange];

        // 翌月以降最古の情報を先頭に追加
        if (largerCsl.length > 0) {
          cslDates.unshift(largerCsl[largerCsl.length - 1]);
        }

        // 前月以前最新の情報を末尾に追加
        if (smallerCsl.length > 0) {
          cslDates.push(smallerCsl[0]);
        }

        return cslDates;
      });
  },
  // 検索条件を満たす受診者の一覧を取得する(枠予約用)
  getConsultListForFraRsv: (payload) => {
    const params = payload;
    const url = '/api/v1/consultations/range';

    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  // 一括受診日変更
  registerDate: (payload) => {
    const url = '/api/v1/consultations/dates';
    return axios
      .put(url, payload)
      .then((res) => res.data);
  },

  // 一括受付
  runReceiptAll: (data) => {
    const method = 'POST';
    // urlの定義
    const url = '/api/v1/receptions';

    // 一括受付の一覧を取得API呼び出し
    return axios({
      method,
      url,
      data,
    })
      .then((res) => ({
        data: res.data,
      }));
  },
  // 一括で受付を取り消す
  runCancelReceiptAll: (params) => {
    const method = 'DELETE';

    const url = '/api/v1/receptions';

    return axios({
      method,
      url,
      params,
    })
      .then((res) => ({
        data: res.data,
      }));
  },
  // 受診情報検索
  getRslConsult: ({ rsvno }) => {
    const url = `/api/v1/consultations/${rsvno}/basics`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  getDailyList: ({ params }) => {
    // 受診者数取得（団体別）
    // urlの定義
    const url = '/api/v1/search';
    // 受診者数取得（団体別）PI呼び出し
    return axios
      .get(url, {
        params: { ...params, printFields: JSON.stringify(params.printFields) },
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 受診者数取得（団体別）成功アクションを呼び出す
        const { totalcount = 0, data = [] } = res.data;
        return { totalcount, data };
      });
  },

  getPaymentList: (conditions) => {
    const url = '/api/v1/friends';
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  getPayment: ({ params }) => {
    const rsvno = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/basics`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 指定予約番号の受診オプション管理情報を取得する
  getConsultO: (conditions) => {
    const { rsvno } = conditions;

    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/options`;

    // 受診情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 受診オプション管理レコードを更新する
  updateConsultO: (params) => {
    const { rsvno, ctrptcd, ...data } = params;
    const method = 'PUT';

    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/options`;

    // 受診オプション管理レコードの更新API呼び出し
    return axios({
      method,
      url,
      params: { rsvno, ctrptcd },
      data,
    })
      .then(() => {
      });
  },
  // 来院情報の入力チェック
  checkWelComeInfo: (params) => {
    const method = 'PUT';
    // urlの定義
    const url = '/api/v1/consultations/check';

    // 来院情報の入力チェックをAPI呼び出し
    return axios({
      method,
      url,
      params,
    })
      .then((res) => res.data);
  },
  // 来院情報の更新
  updateWelComeInfo: (params) => {
    // 予約番号
    const { rsvno } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/visits`;

    // 来院情報の更新をAPI呼び出し
    return axios({
      method,
      url,
      params,
    })
      .then((res) => res.data);
  },
  // 来院情報検索
  getWelComeInfo: (params) => {
    // 予約番号
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/visits`;

    // 来院情報検索をAPI呼び出し
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 来院処理の入力チェック
  checkRegisterWelComeInfo: (params) => {
    const method = 'PUT';
    // urlの定義
    const url = '/api/v1/consultations/registeredcheck';

    // 来院確認の入力チェックをAPI呼び出し
    return axios({
      method,
      url,
      params,
    })
      .then((res) => (res.data));
  },
  // お連れ様情報を取得
  getFriends: (params) => {
    // urlの定義
    const url = '/api/v1/friends';

    // お連れ様情報を取得をAPI呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },
  // お連れ様情報を更新
  registerFriends: (data) => {
    // urlの定義
    const url = '/api/v1/friends';

    return axios
      .put(url, data)
      .then((res) => res.data);
  },
  // お連れ様情報を削除
  deleteFriends: (params) => {
    // urlの定義
    const url = '/api/v1/friends';

    return axios
      .delete(url, { params })
      .then((res) => res.data);
  },

  // 指定された個人IDの受診歴一覧を取得する
  getConsultHistory(payload) {
    const { perid } = payload;

    const params = { ...payload };
    delete params.perid;

    // URLの定義
    const url = `/api/v1/people/${perid}/consultations`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  // 指定条件を満たす受診情報ログを取得します。
  getConsultLogList: (params) => {
    // urlの定義
    const url = '/api/v1/consultations/logs';

    // 指定条件を満たす受診情報ログを取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },
  // 受付情報をもとに受診情報を読み込む
  getConsultFromReceipt: (params) => {
    const method = 'GET';
    // urlの定義
    const url = '/api/v1/receptions';

    // 受付情報をもとに受診情報をAPI呼び出し
    return axios({
      method,
      url,
      params,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },
  // 検索予約番号の前後の予約番号および当日IDを取得
  getCurRsvNoPrevNext: (params) => {
    const method = 'GET';
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/neighbors`;

    // 検索予約番号の前後の予約番号および当日IDを取得をAPI呼び出し
    return axios({
      method,
      url,
      params,
      validateStatus: (status) => (status < 500),
    })
      .then((res) => (res.data));
  },
  // 検索条件を満たすレコード件数を取得
  getConsultListProgress: (conditions) => {
    // urlの定義
    const url = '/api/v1/consultations/progresses';
    let params = { ...conditions };
    if (!conditions.cslDate) {
      const cslDate = moment().format('YYYY/M/D');
      params = { ...params, cslDate };
    }
    return axios
      .get(url, {
        params: { ...params, cntlNo: 0, getCount: 20 },
      })
      .then((res) => (res.data));
  },
  // 指定予約番号の出力情報を取得
  getConsultPrintStatus: (params) => {
    const { rsvno } = params;
    const method = 'GET';
    // URLの定義
    const url = `/api/v1/consultations/${rsvno}/printstatus`;
    return axios({
      method,
      url,
      params,
    })
      .then((res) => (res.data));
  },
  //  キャンセル受診情報を復元
  restoreConsult: (params) => {
    const { rsvno } = params;
    const method = 'PUT';
    // URLの定義
    const url = `/api/v1/consultations/${rsvno}/restore`;
    return axios({
      method,
      url,
      params,
    })
      .then((res) => (res.data));
  },

};

export default consultService;
