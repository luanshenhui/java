import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getOcrNyuryokuSpBody2Request,
  getOcrNyuryokuSpBody2ConsultRequest,
  getOcrNyuryokuSpBody2ConsultSuccess,
  getOcrNyuryokuSpBody2ConsultFailure,
  getOcrNyuryokuSpBody2PerResultGrpRequest,
  getOcrNyuryokuSpBody2PerResultGrpSuccess,
  getOcrNyuryokuSpBody2PerResultGrpFailure,
  getOcrNyuryokuSpBody2OcrNyuryokuRequest,
  getOcrNyuryokuSpBody2OcrNyuryokuSuccess,
  getOcrNyuryokuSpBody2OcrNyuryokuFailure,

} = createActions(
  'GET_OCR_NYURYOKU_SP_BODY2_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY2_CONSULT_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY2_CONSULT_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY2_CONSULT_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY2_PER_RESULT_GRP_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY2_PER_RESULT_GRP_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY2_PER_RESULT_GRP_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY2_OCR_NYURYOKU_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY2_OCR_NYURYOKU_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY2_OCR_NYURYOKU_FAILURE',
);

// stateの初期値
const initialState = {
  ocrNyuryokuSpBody2: {
    message: [],
    conditions: {},
    consult: {},
    perResultGrp: [],
    editOcrDate: {},
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
  // 受診情報を取得時の処理
  [getOcrNyuryokuSpBody2ConsultRequest]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, conditions } };
  },
  // 受診情報を取得成功時の処理
  [getOcrNyuryokuSpBody2ConsultSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const consult = action.payload;
    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, consult } };
  },
  // 受診情報を取得失敗時の処理
  [getOcrNyuryokuSpBody2ConsultFailure]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報が存在しません。（予約番号= ${rsvno} )`];
    }

    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, message } };
  },
  // 個人検査結果情報取得時の処理
  [getOcrNyuryokuSpBody2PerResultGrpRequest]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, conditions } };
  },
  // 個人検査結果情報取得成功時の処理
  [getOcrNyuryokuSpBody2PerResultGrpSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { perResultGrp } = action.payload;
    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, perResultGrp } };
  },
  // 個人検査結果情報取得失敗時の処理
  [getOcrNyuryokuSpBody2PerResultGrpFailure]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    const { status, perid } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`個人検査結果情報が存在しません。（個人ID= ${perid} )`];
    }

    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, message } };
  },
  // OCR入力結果を取得時の処理
  [getOcrNyuryokuSpBody2OcrNyuryokuRequest]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, conditions } };
  },
  // OCR入力結果を取得成功時の処理
  [getOcrNyuryokuSpBody2OcrNyuryokuSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const ocrNyuryoku = action.payload;
    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, ocrNyuryoku } };
  },
  // OCR入力結果を取得失敗時の処理
  [getOcrNyuryokuSpBody2OcrNyuryokuFailure]: (state, action) => {
    const { ocrNyuryokuSpBody2 } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`OCR入力結果が取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, ocrNyuryokuSpBody2: { ...ocrNyuryokuSpBody2, message } };
  },
}, initialState);
