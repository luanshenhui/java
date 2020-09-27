import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getEditOcrDateRequest,
  getEditOcrDateSuccess,
  getEditOcrDateFailure,
  getOcrNyuryokuBodyRequest,
  getOcrNyuryokuBodyConsultRequest,
  getOcrNyuryokuBodyConsultSuccess,
  getOcrNyuryokuBodyConsultFailure,
  getOcrNyuryokuBodyPerResultGrpRequest,
  getOcrNyuryokuBodyPerResultGrpSuccess,
  getOcrNyuryokuBodyPerResultGrpFailure,
  getOcrNyuryokuBodyOcrNyuryokuRequest,
  getOcrNyuryokuBodyOcrNyuryokuSuccess,
  getOcrNyuryokuBodyOcrNyuryokuFailure,
} = createActions(
  'GET_EDIT_OCR_DATE_REQUEST',
  'GET_EDIT_OCR_DATE_SUCCESS',
  'GET_EDIT_OCR_DATE_FAILURE',
  'GET_OCR_NYURYOKU_BODY_REQUEST',
  'GET_OCR_NYURYOKU_BODY_CONSULT_REQUEST',
  'GET_OCR_NYURYOKU_BODY_CONSULT_SUCCESS',
  'GET_OCR_NYURYOKU_BODY_CONSULT_FAILURE',
  'GET_OCR_NYURYOKU_BODY_PER_RESULT_GRP_REQUEST',
  'GET_OCR_NYURYOKU_BODY_PER_RESULT_GRP_SUCCESS',
  'GET_OCR_NYURYOKU_BODY_PER_RESULT_GRP_FAILURE',
  'GET_OCR_NYURYOKU_BODY_OCR_NYURYOKU_REQUEST',
  'GET_OCR_NYURYOKU_BODY_OCR_NYURYOKU_SUCCESS',
  'GET_OCR_NYURYOKU_BODY_OCR_NYURYOKU_FAILURE',
);

// stateの初期値
const initialState = {
  prepaInfo: {
    message: [],
    editOcrDate: null,
  },
  ocrNyuryokuBody: {
    message: [],
    conditions: {},
    consult: {},
    perResultGrp: [],
    ocrNyuryoku: {
      ocrresult: [],
      errcount: 0,
      arrerrno: [],
      arrerrstate: [],
      arrerrmsg: [],
    },
  },
};

// reducerの作成
export default handleActions({
  // OCR内容確認修正日時を取得成功時の処理
  [getEditOcrDateSuccess]: (state, action) => {
    const { prepaInfo } = state;
    let { editOcrDate } = prepaInfo;
    if (action.payload !== undefined) {
      editOcrDate = action.payload;
    }
    return { ...state, prepaInfo: { ...prepaInfo, editOcrDate } };
  },
  // OCR内容確認修正日時を取得失敗時の処理
  [getEditOcrDateFailure]: (state, action) => {
    const { prepaInfo } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // 受診情報を取得時の処理
  [getOcrNyuryokuBodyConsultRequest]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, conditions } };
  },
  // 受診情報を取得成功時の処理
  [getOcrNyuryokuBodyConsultSuccess]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const consult = action.payload;
    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, consult } };
  },
  // 受診情報を取得失敗時の処理
  [getOcrNyuryokuBodyConsultFailure]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報が存在しません。（予約番号= ${rsvno} )`];
    }

    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, message } };
  },
  // 個人検査結果情報取得時の処理
  [getOcrNyuryokuBodyPerResultGrpRequest]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, conditions } };
  },
  // 個人検査結果情報取得成功時の処理
  [getOcrNyuryokuBodyPerResultGrpSuccess]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { perResultGrp } = action.payload;
    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, perResultGrp } };
  },
  // 個人検査結果情報取得失敗時の処理
  [getOcrNyuryokuBodyPerResultGrpFailure]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    const { status, perid } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`個人検査結果情報が存在しません。（個人ID= ${perid} )`];
    }

    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, message } };
  },
  // OCR入力結果を取得時の処理
  [getOcrNyuryokuBodyOcrNyuryokuRequest]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, conditions } };
  },
  // OCR入力結果を取得成功時の処理
  [getOcrNyuryokuBodyOcrNyuryokuSuccess]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const ocrNyuryoku = action.payload;
    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, ocrNyuryoku } };
  },
  // OCR入力結果を取得失敗時の処理
  [getOcrNyuryokuBodyOcrNyuryokuFailure]: (state, action) => {
    const { ocrNyuryokuBody } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`OCR入力結果が取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, ocrNyuryokuBody: { ...ocrNyuryokuBody, message } };
  },
}, initialState);
