import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getOcrNyuryokuSpBody201210Request,
  getOcrNyuryokuSpBody201210ConsultRequest,
  getOcrNyuryokuSpBody201210ConsultSuccess,
  getOcrNyuryokuSpBody201210ConsultFailure,
  getOcrNyuryokuSpBody201210PerResultGrpRequest,
  getOcrNyuryokuSpBody201210PerResultGrpSuccess,
  getOcrNyuryokuSpBody201210PerResultGrpFailure,
  getOcrNyuryokuSpBody201210EditOcrDateRequest,
  getOcrNyuryokuSpBody201210EditOcrDateSuccess,
  getOcrNyuryokuSpBody201210EditOcrDateFailure,
  getOcrNyuryokuSpBody201210OcrNyuryokuRequest,
  getOcrNyuryokuSpBody201210OcrNyuryokuSuccess,
  getOcrNyuryokuSpBody201210OcrNyuryokuFailure,
} = createActions(
  'GET_OCR_NYURYOKU_SP_BODY_201210_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_201210_CONSULT_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_201210_CONSULT_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_201210_CONSULT_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_201210_PER_RESULT_GRP_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_201210_PER_RESULT_GRP_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_201210_PER_RESULT_GRP_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_201210_EDIT_OCR_DATE_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_201210_EDIT_OCR_DATE_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_201210_EDIT_OCR_DATE_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_201210_OCR_NYURYOKU_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_201210_OCR_NYURYOKU_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_201210_OCR_NYURYOKU_FAILURE',
);

// stateの初期値
const initialState = {
  ocrNyuryokuSpBody201210: {
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
  [getOcrNyuryokuSpBody201210ConsultRequest]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, conditions } };
  },
  // 受診情報を取得成功時の処理
  [getOcrNyuryokuSpBody201210ConsultSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const consult = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, consult } };
  },
  // 受診情報を取得失敗時の処理
  [getOcrNyuryokuSpBody201210ConsultFailure]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報が存在しません。（予約番号= ${rsvno} )`];
    }

    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, message } };
  },
  // 個人検査結果情報取得時の処理
  [getOcrNyuryokuSpBody201210PerResultGrpRequest]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, conditions } };
  },
  // 個人検査結果情報取得成功時の処理
  [getOcrNyuryokuSpBody201210PerResultGrpSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { perResultGrp } = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, perResultGrp } };
  },
  // 個人検査結果情報取得失敗時の処理
  [getOcrNyuryokuSpBody201210PerResultGrpFailure]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    const { status, perid } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`個人検査結果情報が存在しません。（個人ID= ${perid} )`];
    }

    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, message } };
  },
  // OCR内容確認修正日時取得時の処理
  [getOcrNyuryokuSpBody201210EditOcrDateRequest]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, conditions } };
  },
  // OCR内容確認修正日時取得成功時の処理
  [getOcrNyuryokuSpBody201210EditOcrDateSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const editOcrDate = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, editOcrDate } };
  },
  // OCR内容確認修正日時取得失敗時の処理
  [getOcrNyuryokuSpBody201210EditOcrDateFailure]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`OCR内容確認修正日時が取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, message } };
  },
  // OCR入力結果を取得時の処理
  [getOcrNyuryokuSpBody201210OcrNyuryokuRequest]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, conditions } };
  },
  // OCR入力結果を取得成功時の処理
  [getOcrNyuryokuSpBody201210OcrNyuryokuSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const ocrNyuryoku = action.payload;
    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, ocrNyuryoku } };
  },
  // OCR入力結果を取得失敗時の処理
  [getOcrNyuryokuSpBody201210OcrNyuryokuFailure]: (state, action) => {
    const { ocrNyuryokuSpBody201210 } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`OCR入力結果が取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, ocrNyuryokuSpBody201210: { ...ocrNyuryokuSpBody201210, message } };
  },
}, initialState);
