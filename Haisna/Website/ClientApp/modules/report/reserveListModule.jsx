import axios from 'axios';
import moment from 'moment';
// reduxエコシステムの1つであるredux-actionsを利用し、コードを簡便化する
import { createActions, handleActions } from 'redux-actions';

const URL_FOR_REPORTING = '/api/report/reservelist';

// actionの作成
export const {
  createReportRequest,
  createReportProgressing,
  createReportSuccess,
  createReportFailure,
  closeAlert,
} = createActions(
  'CREATE_REPORT_REQUEST',
  'CREATE_REPORT_PROGRESSING',
  'CREATE_REPORT_SUCCESS',
  'CREATE_REPORT_FAILURE',
  'CLOSE_ALERT',
);

// stateの初期値
const initialState = {
  conditions: {
    startdate: moment().format('YYYY/MM/DD'),
    enddate: moment().format('YYYY/MM/DD'),
  },
  notification: {
    status: 'warning',
    alertDisplay: 'none',
    message: [],
  },
  progressDisplay: 'none',
};

// reducerの作成
export default handleActions({
  [createReportRequest]: (state, action) => {
    // 要求開始時は検索条件を変更する
    const conditions = action.payload;
    // 進捗を表示
    const progressDisplay = 'inline-block';
    return { ...initialState, conditions, progressDisplay };
  },
  [createReportSuccess]: (state) => {
    // アラートメッセージ、進捗表示を初期化する
    const { notification, progressDisplay } = initialState;
    return { ...state, notification, progressDisplay };
  },
  [createReportFailure]: (state, action) => {
    // 進捗表示を初期化する
    const { progressDisplay } = initialState;
    // アラートメッセージを表示する
    const alertDisplay = 'block';
    // アラートメッセージを変更する
    const notification = { ...initialState.notification, alertDisplay, ...action.payload };
    return { ...state, notification, progressDisplay };
  },
  [closeAlert]: (state) => {
    // アラートメッセージを初期化する
    const { notification } = initialState;
    return { ...state, notification };
  },
}, initialState);

// 監視処理
let checking = null;
let intervalID = null;
const monitor = (url, printSeq) => (dispatch) => {
  // 1秒毎に進捗監視用のAPIを呼ぶ
  intervalID = setInterval(() => {
    // ajax処理中ならば何もしない
    if (checking) {
      return;
    }

    checking = axios.get(url)
      .then((res) => {
        dispatch(createReportProgressing());
        // 正常終了したらPDFを表示
        if (res.data.status === 1) {
          clearInterval(intervalID);
          if (printSeq) {
            open(`/api/Report/${printSeq}`);
            dispatch(createReportSuccess());
          }
        }

        if ((res.data.status === 2) && (res.data.count === 0)) {
          clearInterval(intervalID);
          dispatch(createReportFailure({
            message: '出力処理が完了しました。条件を満たすデータは存在しませんでした。',
          }));
        }

        checking = null;
      })
      .catch((data) => {
        if (data.response) {
          dispatch(createReportFailure({
            message: data.response.data.errors.map((error) => (error.message)),
          }));
        }
      });
  }, 1000);
};

export const createReport = (conditions) => (dispatch) => {
  // パラメーターの定義
  const params = Object.assign({}, conditions);

  // グループ一覧取得開始アクション
  dispatch(createReportRequest(conditions));

  // 出力用APIの呼び出し
  axios.post(URL_FOR_REPORTING, params)
    .then((res) => new Promise((resolve, reject) => {
      if (res.data.printseq === undefined) {
        reject(res.data);
      } else {
        resolve(res);
      }
    }))
    .then((res) => {
      // SEQ値が得られた場合は監視処理を呼び出す
      // dispatch(monitor(res.headers.location, res.data.printseq));
      open(`/api/Report/${res.data.printseq}`);
    })
    .catch((data) => {
      if (data.response) {
        if (data.response.status === 400) {
          dispatch(createReportFailure({
            message: data.response.data.errors.map((error) => (error.message)),
          }));
        }

        if (data.response.status === 401) {
          location.href = '/login';
        }

        // 同期処理を行ってる間の暫定処理
        if (data.response.status === 404) {
          dispatch(createReportFailure({
            message: '条件を満たすデータは存在しませんでした。',
          }));
        }
      }
    });
};
