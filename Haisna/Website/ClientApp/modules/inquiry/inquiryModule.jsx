/**
 * @file 結果参照のActionとReducer
 */
import { createActions, handleActions } from 'redux-actions';

// actionの作成
// 結果参照
export const {
  initializeInquiryMain,
  getInquiryHistoryRequest,
  getInquiryHistorySuccess,
  getInquiryHistoryFailure,
} = createActions(
  'INITIALIZE_INQUIRY_MAIN',
  'GET_INQUIRY_HISTORY_REQUEST',
  'GET_INQUIRY_HISTORY_SUCCESS',
  'GET_INQUIRY_HISTORY_FAILURE',
);

// 結果参照レポート
export const {
  getInquiryDetailReportRequest,
  getInquiryDetailReportSuccess,
  getInquiryDetailReportFailure,
} = createActions(
  'GET_INQUIRY_DETAIL_REPORT_REQUEST',
  'GET_INQUIRY_DETAIL_REPORT_SUCCESS',
  'GET_INQUIRY_DETAIL_REPORT_FAILURE',
);

// 経年変化
export const {
  showInquiryDetailRslHistoryRequest,
  showInquiryDetailRslHistorySuccess,
  showInquiryDetailRslHistoryFailure,
  getInquiryDetailRslHistoryResultsRequest,
  getInquiryDetailRslHistoryResultsSuccess,
  getInquiryDetailRslHistoryResultsFailure,
  initializeDataDetailRslHistory,
} = createActions(
  'SHOW_INQUIRY_DETAIL_RSL_HISTORY_REQUEST',
  'SHOW_INQUIRY_DETAIL_RSL_HISTORY_SUCCESS',
  'SHOW_INQUIRY_DETAIL_RSL_HISTORY_FAILURE',
  'GET_INQUIRY_DETAIL_RSL_HISTORY_RESULTS_REQUEST',
  'GET_INQUIRY_DETAIL_RSL_HISTORY_RESULTS_SUCCESS',
  'GET_INQUIRY_DETAIL_RSL_HISTORY_RESULTS_FAILURE',
  'INITIALIZE_DATA_DETAIL_RSL_HISTORY',
);

// 個人検索
export const {
  initializeInquiryPersonList,
  getInquiryPersonListRequest,
  getInquiryPersonListSuccess,
  getInquiryPersonListFailure,
  // 個人検査情報
  getInqPerInspectionRequest,
  getInqPerInspectionSuccess,
  getInqPerInspectionFailure,
} = createActions(
  // 結果参照
  // 結果参照 対象者
  'INITIALIZE_INQUIRY_PERSON_LIST',
  'GET_INQUIRY_PERSON_LIST_REQUEST',
  'GET_INQUIRY_PERSON_LIST_SUCCESS',
  'GET_INQUIRY_PERSON_LIST_FAILURE',
  // 個人検査情報
  'GET_INQ_PER_INSPECTION_REQUEST',
  'GET_INQ_PER_INSPECTION_SUCCESS',
  'GET_INQ_PER_INSPECTION_FAILURE',
);

// stateの初期値
const initialState = {
  inquiryMain: {
    history: {
      person: {},
      consults: {},
      perResults: [],
    },
    detail: {
      report: {
        visible: false,
        consult: {},
        judgements: [],
        resultsR: [],
        resultsQ: [],
      },
      rslHistory: {
        visible: false,
        conditions: {
          perid: null,
        },
        grpItems: [],
        countItems: [],
        messages: [],
        data: {
          consults: [],
          results: [],
          items: [],
        },
      },
    },
  },
  // 個人検索
  inqPersonList: {
    message: [],
    // 検索条件
    conditions: {
      keyword: '',
      page: 1,
      limit: 20,
    },
    totalCount: null,
    data: [],
    peceiptPerId: '',
  },
  inqMain: {
    personInf: {},
    consultHistory: [],
    consultHistoryCnt: 0,
    consultHistoryIns: [],
    perResultList: [],
  },
};

// reducerの作成
export default handleActions({
  // 結果参照の初期化
  [initializeInquiryMain]: (state) => {
    const { inquiryMain } = initialState;
    return { ...state, inquiryMain };
  },
  // 結果履歴取得成功時処理
  [getInquiryHistorySuccess]: (state, action) => {
    const { inquiryMain } = state;
    return {
      ...state,
      inquiryMain: {
        ...inquiryMain,
        history: {
          ...action.payload,
        },
      },
    };
  },
  // 結果参照レポート取得成功時処理
  [getInquiryDetailReportSuccess]: (state, action) => {
    const { inquiryMain } = state;
    const { detail } = initialState.inquiryMain;
    return {
      ...state,
      inquiryMain: {
        ...inquiryMain,
        detail: {
          ...detail,
          report: {
            ...action.payload,
            visible: true,
          },
        },
      },
    };
  },
  // 結果参照経年変化表示開始時処理
  [showInquiryDetailRslHistoryRequest]: (state, action) => {
    const { inquiryMain } = state;
    const { detail } = initialState.inquiryMain;
    const conditions = { perid: action.payload.perid };
    const rslHistory = { ...detail.rslHistory, visible: true, conditions };
    return {
      ...state,
      inquiryMain: {
        ...inquiryMain,
        detail: {
          ...detail,
          rslHistory,
        },
      },
    };
  },
  // 結果参照経年変化表示成功時処理
  [showInquiryDetailRslHistorySuccess]: (state, action) => {
    const { inquiryMain } = state;
    const { detail } = inquiryMain;

    // 検査項目グループドロップダウンの選択肢
    const grpItems = Array.isArray(action.payload) ?
      action.payload.map((rec) => ({ name: rec.grpname, value: rec.grpcd })) : [];

    const rslHistory = { ...detail.rslHistory, grpItems };
    return { ...state, inquiryMain: { ...inquiryMain, detail: { ...detail, rslHistory } } };
  },
  // 結果参照経年変化検査結果履歴取得開始時処理
  [getInquiryDetailRslHistoryResultsRequest]: (state, action) => {
    const { inquiryMain } = state;
    const { detail } = inquiryMain;
    const rslHistory = { ...detail.rslHistory, conditions: action.payload, messages: [] };
    return { ...state, inquiryMain: { ...inquiryMain, detail: { ...detail, rslHistory } } };
  },
  // 結果参照経年変化検査結果履歴取得成功時処理
  [getInquiryDetailRslHistoryResultsSuccess]: (state, action) => {
    const { inquiryMain } = state;
    const { detail } = inquiryMain;
    const rslHistory = { ...detail.rslHistory, data: action.payload };
    return { ...state, inquiryMain: { ...inquiryMain, detail: { ...detail, rslHistory } } };
  },
  // 結果参照経年変化検査結果履歴取得失敗時処理
  [getInquiryDetailRslHistoryResultsFailure]: (state, action) => {
    const { inquiryMain } = state;
    const { detail } = inquiryMain;
    const { data } = initialState.inquiryMain.detail.rslHistory;
    const messages = action.payload.data.errors;
    const rslHistory = { ...detail.rslHistory, data, messages };
    return { ...state, inquiryMain: { ...inquiryMain, detail: { ...detail, rslHistory } } };
  },
  // 結果参照経年変化データ初期化処理
  [initializeDataDetailRslHistory]: (state) => {
    const { inquiryMain } = state;
    const { detail } = inquiryMain;
    const { data, messages } = initialState.inquiryMain.detail.rslHistory;
    const rslHistory = { ...detail.rslHistory, data, messages };
    return { ...state, inquiryMain: { ...inquiryMain, detail: { ...detail, rslHistory } } };
  },

  // 個人一覧初期化処理
  [initializeInquiryPersonList]: (state) => {
    const { inqPersonList } = initialState;
    return { ...state, inqPersonList };
  },

  // 個人一覧取得開始時の処理
  [getInquiryPersonListRequest]: (state, action) => {
    const { inqPersonList } = state;
    // 検索条件を更新する
    const conditions = action.payload;

    return { ...state, inqPersonList: { ...inqPersonList, conditions } };
  },

  // 個人一覧取得成功時の処理
  [getInquiryPersonListSuccess]: (state, action) => {
    const { inqPersonList } = state;

    // 総件数とデータとを更新する
    const { totalCount, data, peceiptPerId } = action.payload;

    const message = [];
    if (typeof (totalCount) === 'undefined' && typeof (peceiptPerId) === 'undefined') {
      message.push('指定された当日IDの受診情報は存在しません。');
    }
    if (totalCount === 0) {
      message.push('検索条件を満たす個人情報は存在しません。');
      message.push('キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。');
    }

    return { ...state, inqPersonList: { ...inqPersonList, totalCount, data, peceiptPerId, message } };
  },

  // 結果参照 対象者を取得成功時の処理
  [getInquiryHistorySuccess]: (state, action) => {
    const { inqMain } = state;

    const { personInf, consultHistory } = action.payload;

    let { totalcount } = consultHistory;
    if (totalcount == null) {
      totalcount = 0;
    }

    return { ...state, inqMain: { ...inqMain, personInf: personInf.data, consultHistory: consultHistory.data, consultHistoryCnt: totalcount } };
  },

  // 結果参照 対象者を取得失敗時の処理
  [getInquiryHistoryFailure]: (state, action) => {
    const { inqMain } = state;

    const { personInf, consultHistory } = action.payload;

    let { totalcount } = consultHistory;
    if (totalcount == null) {
      totalcount = 0;
    }

    return { ...state, inqMain: { ...inqMain, personInf: personInf.data, consultHistory: consultHistory.data, consultHistoryCnt: totalcount } };
  },

  // 個人検査情報を取得成功時の処理
  [getInqPerInspectionSuccess]: (state, action) => {
    const { inqMain } = state;

    const { consultHistoryIns, perResultList } = action.payload;
    const { perResultGrp } = perResultList;

    // 個人検査結果 表示用
    const perResultListDisply = [];
    let result = '';
    for (let i = 0, len = perResultGrp.length; i < len; i += 1) {
      if (perResultGrp[i].result !== null) {
        if (perResultGrp[i].shortstc !== null) {
          result = perResultGrp[i].shortstc;
        } else {
          result = perResultGrp[i].result !== null ? perResultGrp[i].result : null;
        }
        perResultListDisply.push({ key: `${perResultGrp[i].itemcd}${perResultGrp[i].suffix}`, itemname: perResultGrp[i].itemname, result, ispdate: perResultGrp[i].ispdate });
      }
    }

    return { ...state, inqMain: { ...inqMain, perResultList: perResultListDisply, consultHistoryIns: consultHistoryIns.data } };
  },
}, initialState);
