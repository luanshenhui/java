import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  initializePayCsv,
  importCsvRequest,
  importCsvSuccess,
  importCsvFailure,
} = createActions(
  'INITIALIZE_PAY_CSV',
  'IMPORT_CSV_REQUEST',
  'IMPORT_CSV_SUCCESS',
  'IMPORT_CSV_FAILURE',
);

// stateの初期値
const initialState = {
  // CSV
  dmdPayFromCsv: {
    conditions: {
      startPos: '',
      fileName: '',
      readCount: '',
    },
    data: {},
    message: [],
    err: '',
  },
};

// reducerの作成
export default handleActions({
  // 入金情報の作成の初期化
  [initializePayCsv]: (state) => {
    const { dmdPayFromCsv } = initialState;
    const conditions = {};
    conditions.fileName = '';
    conditions.startPos = '';
    conditions.readCount = '';
    const message = [];
    return { ...state, dmdPayFromCsv: { ...dmdPayFromCsv, message, conditions } };
  },
  // 入金情報の作成成功
  [importCsvSuccess]: (state, action) => {
    const { dmdPayFromCsv } = state;
    const { data } = action.payload;
    const { conditions } = dmdPayFromCsv;
    const err = '';
    if (Object.keys(data).length > 0) {
      conditions.fileName = data.outfilename;
      conditions.readCount = data.readcount;
      conditions.startPos = data.startpos;
    } else {
      conditions.readCount = data.readcount;
      conditions.fileName = data.outfilename;
    }
    const message = [`読み込みレコード数＝${data.readcount}、作成入金情報数＝${data.writecount}`];
    if (data.writecount === '0') {
      message.push('入金情報は作成されませんでした。');
    } else {
      // 引数がQueryStringにて渡されている場合
      message.push(`${data.writecount}件の入金情報が作成されました。`);
    }
    message.push('詳細はシステムログを参照して下さい。');
    return { ...state, dmdPayFromCsv: { ...dmdPayFromCsv, data, message, err, conditions } };
  },
  // 入金情報の作成失敗
  [importCsvFailure]: (state, action) => {
    const { dmdPayFromCsv } = initialState;
    const { data } = action.payload;
    const err = 'err';
    let message;
    if (data.errors !== undefined) {
      message = data.errors;
    } else {
      message = data;
    }
    return { ...state, dmdPayFromCsv: { ...dmdPayFromCsv, message, err } };
  },
}, initialState);
