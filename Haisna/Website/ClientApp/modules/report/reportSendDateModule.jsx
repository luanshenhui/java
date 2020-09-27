import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  getWelComeInfoRequest,
  getWelComeInfoSuccess,
  getWelComeInfoFailure,
  getReportSendDateListRequest,
  getReportSendDateListSuccess,
  getReportSendDateListFailure,
  deleteConsultReptSendRequest,
  deleteConsultReptSendSuccess,
  deleteConsultReptSendFailure,
  setStrMessage,
  initialStateRequest,
  initialReportSendDateList,
} = createActions(
  'GET_WEL_COME_INFO_REQUEST',
  'GET_WEL_COME_INFO_SUCCESS',
  'GET_WEL_COME_INFO_FAILURE',
  'GET_REPORT_SEND_DATE_LIST_REQUEST',
  'GET_REPORT_SEND_DATE_LIST_SUCCESS',
  'GET_REPORT_SEND_DATE_LIST_FAILURE',
  'DELETE_CONSULT_REPT_SEND_REQUEST',
  'DELETE_CONSULT_REPT_SEND_SUCCESS',
  'DELETE_CONSULT_REPT_SEND_FAILURE',
  'SET_STR_MESSAGE',
  'INITIAL_STATE_REQUEST',
  'INITIAL_REPORT_SEND_DATE_LIST',
);

// stateの初期値
const initialState = {
  sendReport: {
    conditions: {
      cslDate: moment().format('YYYY/M/D'),
    },
    strAction: '',
    blnCslInfoFlg: false,
    rsvno: '',
    act: 'save',
    payload1: [],
    payload3: {},
    message: [],
  },
  ReportSendDateList: {
    conditions: {
      strCslDate: moment().format('YYYY/M/D'),
      endCslDate: moment().format('YYYY/M/D'),
      csCd: '',
      orgGrpCd: '',
      sendMode: 0,
      limit: 50,
      startPos: 1,
      orgcd1: '',
      orgcd2: '',
      orgname: '',
      perid: '',
      lastname: '',
      firstname: '',
    },
    totalcount: 0,
    reportitem: [],
    onsearch: false,
    guideRsvno: 0,
    strMessage: '',
    isLoading: false,
  },
};

// reducerの作成
export default handleActions({

  [getWelComeInfoRequest]: (state, action) => {
    const { sendReport } = state;
    const { act, rsvno } = action.payload;
    return { ...state, sendReport: { ...sendReport, rsvno, act } };
  },
  [getWelComeInfoSuccess]: (state, action) => {
    const { sendReport } = state;
    const { strAction, blnCslInfoFlg, payload3, message } = action.payload;
    let { payload1 } = action.payload;
    if (!payload1.length) {
      payload1 = [];
    }
    if (Object.keys(payload3).length !== 0) {
      return { ...state, sendReport: { ...sendReport, message, strAction, blnCslInfoFlg, payload1, payload3 } };
    }
    return { ...state, sendReport: { ...sendReport, message, strAction, blnCslInfoFlg, payload1 } };
  },
  [getWelComeInfoFailure]: (state) => {
    const { sendReport } = state;
    return { ...state, sendReport: { ...sendReport } };
  },
  // 検索条件に従い成績書情報一覧を抽出する
  [getReportSendDateListRequest]: (state, action) => {
    const { ReportSendDateList } = state;
    const conditions = action.payload;
    return { ...state, ReportSendDateList: { ...ReportSendDateList, conditions, isLoading: true } };
  },
  // 検索条件に従い成績書情報一覧を抽出する成功時の処理
  [getReportSendDateListSuccess]: (state, action) => {
    const { ReportSendDateList } = state;
    const { count, reportitem } = action.payload;
    return { ...state, ReportSendDateList: { ...ReportSendDateList, totalcount: count, reportitem, onsearch: true, isLoading: false } };
  },
  // 検索条件に従い成績書情報一覧を抽出する失敗時の処理
  [getReportSendDateListFailure]: (state) => {
    const { ReportSendDateList } = state;
    return { ...state, ReportSendDateList: { ...ReportSendDateList, onsearch: true, isLoading: false } };
  },
  // 保存ボタンクリック
  [deleteConsultReptSendRequest]: (state) => {
    const { ReportSendDateList } = state;
    return { ...state, ReportSendDateList: { ...ReportSendDateList } };
  },
  // 保存ボタンクリック成功時の処理
  [deleteConsultReptSendSuccess]: (state) => {
    const { ReportSendDateList } = state;
    return { ...state, ReportSendDateList: { ...ReportSendDateList } };
  },
  // 保存ボタンクリック失敗時の処理
  [deleteConsultReptSendFailure]: (state) => {
    const { ReportSendDateList } = state;
    return { ...state, ReportSendDateList: { ...ReportSendDateList } };
  },

  // オブジェクトのインスタンス作成
  [setStrMessage]: (state, action) => {
    const { ReportSendDateList } = state;
    const strMessage = action.payload;
    return { ...state, ReportSendDateList: { ...ReportSendDateList, strMessage } };
  },
  [initialStateRequest]: (state) => {
    const { sendReport } = initialState;
    return { ...state, sendReport };
  },
  [initialReportSendDateList]: (state) => {
    const { ReportSendDateList } = initialState;
    return { ...state, ReportSendDateList };
  },
}, initialState);
