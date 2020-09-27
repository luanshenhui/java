import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  initializeMorningReport,
  checkCslDate,
  getMorningReportRequest,
  getRsvFraDailySuccess,
  getRsvFraDailyFailure,
  getFriendsDailySuccess,
  getFriendsDailyFailure,
  getSameNameDailySuccess,
  getSameNameDailyFailure,
  getSetCountDailySuccess,
  getSetCountDailyFailure,
  getConsultListSuccess,
  getConsultListFailure,
  getPubNoteDailySuccess,
  getPubNoteDailyFailure,
} = createActions(
  // 朝レポート照会一覧初期化処理
  'INITIALIZE_MORNING_REPORT',
  // 受診日チェック処理
  'CHECK_CSL_DATE',
  // 朝レポート照会一覧を抽出
  'GET_MORNING_REPORT_REQUEST',
  // 時間帯別受診者情報
  'GET_RSV_FRA_DAILY_SUCCESS',
  'GET_RSV_FRA_DAILY_FAILURE',
  // 同伴者（お連れ様）受診者情報
  'GET_FRIENDS_DAILY_SUCCESS',
  'GET_FRIENDS_DAILY_FAILURE',
  // 同姓受診者情報
  'GET_SAME_NAME_DAILY_SUCCESS',
  'GET_SAME_NAME_DAILY_FAILURE',
  // セット別受診者情報
  'GET_SET_COUNT_DAILY_SUCCESS',
  'GET_SET_COUNT_DAILY_FAILURE',
  // 受診者一覧
  'GET_CONSULT_LIST_SUCCESS',
  'GET_CONSULT_LIST_FAILURE',
  // トラブル情報
  'GET_PUB_NOTE_DAILY_SUCCESS',
  'GET_PUB_NOTE_DAILY_FAILURE',
);

// stateの初期値
const initialState = {
  morningReport: {
    message: [],
    // 以下一覧用
    conditions: {
      csldate: moment(new Date()).format('YYYY/MM/DD'),
      cscd: null,
      needunreceipt: false,
    }, // 検索条件
    rsvfradailydata: [],
    friendsdailydata: [],
    samenamedata: [],
    countinfodata: [],
    consultdata: [],
    pubnotedata: [],
  },
};

// reducerの作成
export default handleActions({
  // 朝レポート照会一覧初期化処理
  [initializeMorningReport]: (state) => {
    const { morningReport } = initialState;
    return { ...state, morningReport };
  },
  // 受診日チェック処理
  [checkCslDate]: (state) => {
    const { morningReport } = state;
    const message = ['受診日の形式に誤りがあります。'];
    return { ...state, morningReport: { ...morningReport, message } };
  },
  // 朝レポート照会一覧を抽出開始時の処理
  [getMorningReportRequest]: (state, action) => {
    const { morningReport } = initialState;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, morningReport: { ...morningReport, conditions } };
  },
  // 時間帯別受診者情報一覧を抽出成功時の処理
  [getRsvFraDailySuccess]: (state, action) => {
    const { morningReport } = state;
    // (これに伴い一覧が再描画される)
    const { rsvfradailydata } = action.payload;
    return { ...state, morningReport: { ...morningReport, rsvfradailydata } };
  },
  // 同伴者（お連れ様）受診者情報を取得成功時の処理
  [getFriendsDailySuccess]: (state, action) => {
    const { morningReport } = state;
    // (これに伴い一覧が再描画される)
    const { friendsdailydata } = action.payload;
    return { ...state, morningReport: { ...morningReport, friendsdailydata } };
  },
  // 同姓受診者情報を取得成功時の処理
  [getSameNameDailySuccess]: (state, action) => {
    const { morningReport } = state;
    // (これに伴い一覧が再描画される)
    const { samenamedata } = action.payload;
    return { ...state, morningReport: { ...morningReport, samenamedata } };
  },
  // セット別受診者情報を取得成功時の処理
  [getSetCountDailySuccess]: (state, action) => {
    const { morningReport } = state;
    // (これに伴い一覧が再描画される)
    const { countinfodata } = action.payload;
    return { ...state, morningReport: { ...morningReport, countinfodata } };
  },
  // 受診者一覧取得成功時の処理
  [getConsultListSuccess]: (state, action) => {
    const { morningReport } = state;
    // (これに伴い一覧が再描画される)
    const { consultdata } = action.payload;
    return { ...state, morningReport: { ...morningReport, consultdata } };
  },
  // トラブル情報取得成功時の処理
  [getPubNoteDailySuccess]: (state, action) => {
    const { morningReport } = state;
    // (これに伴い一覧が再描画される)
    const { pubnotedata } = action.payload;
    return { ...state, morningReport: { ...morningReport, pubnotedata } };
  },
}, initialState);
