import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  loadOcrNyuryokuInfo,
  loadOcrNyuryokuSuccess,
  loadOcrNyuryokuFailure,
  loadOcrNyuryokuComHeaderInfo,
  loadOcrNyuryokuComHeaderSuccess,
  loadOcrNyuryokuComHeaderFailure,
  closeOcrNyuryokuSp201210,
  closeOcrNyuryoku,
  initOcrNyuryoku,
  openOcrNyuryouku,
  changeOcrNyuryokuSpErr201210Info,
  changeOcrNyuryokuErrInfo,
  changeOcrNyuryokuSpErrInfo,
  changeOcrNyuryokuSpErr2Info,
  setMonshinChangeOption,
  setNaishikyou,

  getEditOcrDateRequest,
  getEditOcrDateSuccess,
  getEditOcrDateFailure,
  getOcrNyuryokuSpBodyRequest,
  getOcrNyuryokuSpBodyConsultRequest,
  getOcrNyuryokuSpBodyConsultSuccess,
  getOcrNyuryokuSpBodyConsultFailure,
  getOcrNyuryokuSpBodyPerResultGrpRequest,
  getOcrNyuryokuSpBodyPerResultGrpSuccess,
  getOcrNyuryokuSpBodyPerResultGrpFailure,
  getOcrNyuryokuSpBodyOcrNyuryokuRequest,
  getOcrNyuryokuSpBodyOcrNyuryokuSuccess,
  getOcrNyuryokuSpBodyOcrNyuryokuFailure,
  getOcrNyuryokuSpBodyErrInfoSuccess,
} = createActions(
  // OCR内容確認画面を初期化
  'LOAD_OCR_NYURYOKU_INFO',
  'LOAD_OCR_NYURYOKU_SUCCESS',
  'LOAD_OCR_NYURYOKU_FAILURE',
  'CLOSE_OCR_NYURYOKU',
  'CLOSE_OCR_NYURYOKU_SP201210',
  // OCRNYURYOKUCOMHEADER画面を初期化
  'LOAD_OCR_NYURYOKU_COM_HEADER_INFO',
  'LOAD_OCR_NYURYOKU_COM_HEADER_SUCCESS',
  'LOAD_OCR_NYURYOKU_COM_HEADER_FAILURE',
  // 受診検査項目変更画面呼び出し
  'OPEN_MONSHIN_CHANGE_OPTION',
  // 内視鏡チェックリスト入力画面呼び出し
  'OPEN_NAISHIKYOU',
  // OCR入力結果確認画面呼び出し
  'OPEN_OCR_NYURYOUKU',
  // OCRNYURYOKUSPERR201210画面値変更後の処理
  'CHANGE_OCR_NYURYOKU_SP_ERR201210_INFO',
  // OCRNYURYOKUERR画面値変更後の処理
  'CHANGE_OCR_NYURYOKU_ERR_INFO',
  // OCRNYURYOKUSPERR画面値変更後の処理
  'CHANGE_OCR_NYURYOKU_SP_ERR_INFO',
  // OCRNYURYOKUSPERR2画面値変更後の処理
  'CHANGE_OCR_NYURYOKU_SP_ERR2_INFO',
  // OCRNYURYOKU画面ジャンプ
  'SET_MONSHIN_CHANGE_OPTION',
  'SET_NAISHIKYOU',
  'INIT_OCR_NYURYOKU',
  'GET_EDIT_OCR_DATE_REQUEST',
  'GET_EDIT_OCR_DATE_SUCCESS',
  'GET_EDIT_OCR_DATE_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_CONSULT_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_CONSULT_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_CONSULT_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_PER_RESULT_GRP_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_PER_RESULT_GRP_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_PER_RESULT_GRP_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_OCR_NYURYOKU_REQUEST',
  'GET_OCR_NYURYOKU_SP_BODY_OCR_NYURYOKU_SUCCESS',
  'GET_OCR_NYURYOKU_SP_BODY_OCR_NYURYOKU_FAILURE',
  'GET_OCR_NYURYOKU_SP_BODY_ERR_INFO_SUCCESS',
);

// stateの初期値
const initialState = {
  ocrNyuryoku: {
    rsvno: '',
    data: {},
    message: [],
    visible: false,
    pagename: 'info',
    closeflag: 'close',
    saveflag: '',
    editorcdate: {},
    gfchecklist: {},
  },

  ocrNyuryokuComHeader: {
    titlename: '',
    data: {},
    message: [],
    realagetxt: 0,
    optdata: [],
    spcheckdata: 0,
    perrsldata: [],
    editorcdate: {},
    gfchecklist: {},
    consultdata: {},
    rsvno: '',
  },

  ocrNyuryokuSpBody: {
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
    errInfo: {
      errCount: 0,
      errNo: [],
      errState: [],
      errMessage: [],
    },
  },

  ocrNyuryokuSpHeader201210: {
    data: {},
    message: [],
    rsvno: '',
    visible: false,
    editorcdate: {},
    gfchecklist: {},
  },

  ocrNyuryokuSpErr201210: {
    changeflag: 0,
  },

  ocrNyuryokuHeader: {
    data: {},
    message: [],
    rsvno: '',
    visible: false,
    editorcdate: {},
    gfchecklist: {},
  },

  ocrNyuryokuErr: {
    changeflag: 0,
  },

  ocrNyuryokuSpHeader: {
    data: {},
    message: [],
    rsvno: '',
    visible: false,
    editorcdate: {},
    gfchecklist: {},
  },

  ocrNyuryokuSpErr: {
    changeflag: 0,
  },

  ocrNyuryokuSpHeader2: {
    data: {},
    message: [],
    rsvno: '',
    visible: false,
    editorcdate: {},
    gfchecklist: {},
  },

  ocrNyuryokuSpErr2: {
    changeflag: 0,
  },
};

// reducerの作成
export default handleActions({
  // OCR内容確認取得成功時の処理
  [loadOcrNyuryokuSuccess]: (state, action) => {
    const { ocrNyuryoku } = state;
    const { data } = action.payload;
    const visible = true;
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, data, visible } };
  },
  // OCR内容確認取得失敗時の処理
  [loadOcrNyuryokuFailure]: (state, action) => {
    const { ocrNyuryoku } = initialState;
    const { data, status } = action.payload;
    let message = [];
    if (status) {
      if (status === 400 || status === 500) {
        // エラーの場合
        message = [data.errors];
      }
    }
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, data, message } };
  },
  // OCR内容確認を閉じるアクション時の処理
  [closeOcrNyuryoku]: (state) => {
    const { ocrNyuryoku } = state;
    const closeflag = 'close';
    const visible = false;
    const rsvno = '';
    const data = {};
    const message = [];
    const pagename = 'info';
    const editorcdate = {};
    const gfchecklist = {};
    const { saveflag } = ocrNyuryoku;
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, closeflag, visible, rsvno, data, saveflag, message, pagename, editorcdate, gfchecklist } };
  },
  // OCR内容2010を閉じるアクション時の処理
  [closeOcrNyuryokuSp201210]: (state, action) => {
    const message = action;
    const { ocrNyuryoku } = state;
    // 受診検査項目変更画面
    const { changeOption } = state;
    // 内視鏡チェックリスト入力画面
    const { naishikyouCheck } = state;
    // 可視状態false
    const visible = false;
    const pagename = 'info';
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, message, pagename }, changeOption: { ...changeOption, visible }, naishikyouCheck: { ...naishikyouCheck, visible } };
  },
  // OCR内容2010を閉じるアクション時の処理
  [loadOcrNyuryokuComHeaderSuccess]: (state, action) => {
    const { ocrNyuryokuComHeader, ocrNyuryoku } = state;
    const { realagetxt, consultdata, optdata, spcheckdata, perrsldata, editorcdate, gfchecklist } = action.payload;
    let saveflag = '';
    if (ocrNyuryoku !== undefined) {
      // ＯＣＲ結果保存確認
      if (editorcdate !== undefined && (editorcdate.editocrdate === undefined || editorcdate.editocrdate === null)) {
        // ＯＣＲ結果が格納されていません。エラー内容を確認し、保存処理を必ず実行してください。
        saveflag = 'OCR';
      }
      // 内視鏡チェックリストの保存確認
      if (gfchecklist !== undefined && gfchecklist.gfchecklist === '0') {
        // ＧＦコース受診の場合は、内視鏡チェックリストの保存処理を必ず実行してください。
        saveflag = 'GF';
      }
    }
    const closeflag = 'load';
    return {
      ...state,
      ocrNyuryokuComHeader: { ...ocrNyuryokuComHeader, realagetxt, consultdata, optdata, spcheckdata, perrsldata, editorcdate, gfchecklist },
      ocrNyuryoku: { ...ocrNyuryoku, saveflag, closeflag } };
  },
  // OCR内容2010を閉じるアクション時の処理
  [loadOcrNyuryokuComHeaderFailure]: (state, action) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ocrNyuryokuComHeader, ocrNyuryoku } = state;
    const { message, realagetxt, consultdata, optdata, spcheckdata, perrsldata, editorcdate, gfchecklist } = action.payload;
    let saveflag = '';
    if (ocrNyuryoku) {
      // ＯＣＲ結果保存確認
      if (editorcdate && (editorcdate.editocrdate === undefined || editorcdate.editocrdate === null)) {
        // ＯＣＲ結果が格納されていません。エラー内容を確認し、保存処理を必ず実行してください。
        saveflag = 'OCR';
      }
      // 内視鏡チェックリストの保存確認
      if (gfchecklist !== undefined && gfchecklist.gfchecklist === '0') {
        // ＧＦコース受診の場合は、内視鏡チェックリストの保存処理を必ず実行してください。
        saveflag = 'GF';
      }
    }
    const closeflag = 'load';
    return {
      ...state,
      ocrNyuryokuComHeader: { ...ocrNyuryokuComHeader, realagetxt, message, consultdata, optdata, spcheckdata, perrsldata, editorcdate, gfchecklist },
      ocrNyuryoku: { ...ocrNyuryoku, saveflag, closeflag } };
  },
  // OCRNYURYOKUSPERR201210画面値変更後の処理
  [changeOcrNyuryokuSpErr201210Info]: (state, action) => {
    const { outItems } = action.payload;
    const changetype = Number(outItems);
    const { ocrNyuryokuSpErr201210 } = state;
    return { ...state, ocrNyuryokuSpErr201210: { ...ocrNyuryokuSpErr201210, changeflag: changetype } };
  },
  // OCRNYURYOKUERR画面値変更後の処理
  [changeOcrNyuryokuErrInfo]: (state, action) => {
    const { outItems } = action.payload;
    const changetype = Number(outItems);
    const { ocrNyuryokuErr } = state;
    return { ...state, ocrNyuryokuErr: { ...ocrNyuryokuErr, changeflag: changetype } };
  },
  // OCRNYURYOKUSPERR画面値変更後の処理
  [changeOcrNyuryokuSpErrInfo]: (state, action) => {
    const { outItems } = action.payload;
    const changetype = Number(outItems);
    const { ocrNyuryokuSpErr } = state;
    return { ...state, ocrNyuryokuSpErr: { ...ocrNyuryokuSpErr, changeflag: changetype } };
  },
  // OCRNYURYOKUSPERR2画面値変更後の処理
  [changeOcrNyuryokuSpErr2Info]: (state, action) => {
    const changetype = action.payload;
    const { ocrNyuryokuSpErr2 } = state;
    return { ...state, ocrNyuryokuSpErr2: { ...ocrNyuryokuSpErr2, changeflag: changetype } };
  },
  // 受診検査項目変更画面呼び出し
  [setMonshinChangeOption]: (state) => {
    const visible = true;
    const { ocrNyuryoku } = state;
    const pagename = 'changeOption';
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, visible, pagename } };
  },
  // 内視鏡チェックリスト入力画面呼び出し
  [setNaishikyou]: (state) => {
    const visible = true;
    const { ocrNyuryoku } = state;
    const pagename = 'NaishikyouCheck';
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, visible, pagename } };
  },
  // MAIN画面ジャンプ
  [initOcrNyuryoku]: (state) => {
    const visible = true;
    const { ocrNyuryoku } = state;
    const pagename = 'info';
    return { ...state, ocrNyuryoku: { ...ocrNyuryoku, visible, pagename } };
  },

  // 受診情報を取得時の処理
  [getOcrNyuryokuSpBodyConsultRequest]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, conditions } };
  },
  // 受診情報を取得成功時の処理
  [getOcrNyuryokuSpBodyConsultSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const consult = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, consult } };
  },
  // 受診情報を取得失敗時の処理
  [getOcrNyuryokuSpBodyConsultFailure]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報が存在しません。（予約番号= ${rsvno} )`];
    }

    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, message } };
  },
  // 個人検査結果情報取得時の処理
  [getOcrNyuryokuSpBodyPerResultGrpRequest]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, conditions } };
  },
  // 個人検査結果情報取得成功時の処理
  [getOcrNyuryokuSpBodyPerResultGrpSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { perResultGrp } = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, perResultGrp } };
  },
  // 個人検査結果情報取得失敗時の処理
  [getOcrNyuryokuSpBodyPerResultGrpFailure]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    const { status, perid } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`個人検査結果情報が存在しません。（個人ID= ${perid} )`];
    }

    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, message } };
  },
  // OCR入力結果を取得時の処理
  [getOcrNyuryokuSpBodyOcrNyuryokuRequest]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, conditions } };
  },
  // OCR入力結果を取得成功時の処理
  [getOcrNyuryokuSpBodyOcrNyuryokuSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const ocrNyuryoku = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, ocrNyuryoku } };
  },
  // OCR入力結果を取得失敗時の処理
  [getOcrNyuryokuSpBodyOcrNyuryokuFailure]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`OCR入力結果が取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, message } };
  },
  // エラー情報の処理
  [getOcrNyuryokuSpBodyErrInfoSuccess]: (state, action) => {
    const { ocrNyuryokuSpBody } = state;
    const errInfo = action.payload;
    return { ...state, ocrNyuryokuSpBody: { ...ocrNyuryokuSpBody, errInfo } };
  },
}, initialState);
