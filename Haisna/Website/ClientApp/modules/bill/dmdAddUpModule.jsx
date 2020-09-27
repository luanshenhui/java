import { createActions, handleActions } from 'redux-actions';
import Moment from 'moment';
// actionの作成
export const {
  initializeAddUp,
  dmdAddUpRequest,
  dmdAddUpSuccess,
  dmdAddUpFailure,
  initializeOrgChar,
  dmdAddUpExecuteRequest,
  dmdAddUpExecuteSuccess,
  dmdAddUpExecuteFailure,
} = createActions(
  'INITIALIZE_ADD_UP',
  'DMD_ADD_UP_REQUEST',
  'DMD_ADD_UP_SUCCESS',
  'DMD_ADD_UP_FAILURE',
  'INITIALIZE_ORG_CHAR',
  'DMD_ADD_UP_EXECUTE_REQUEST',
  'DMD_ADD_UP_EXECUTE_SUCCESS',
  'DMD_ADD_UP_EXECUTE_FAILURE',
);

// stateの初期値
const initialState = {
  demandAddUp: {
    message: [],
    err: '',
    data: {},
    conditions: {
      closeDate: Moment().format('YYYY/MM/DD'),
      strDate: Moment().format('YYYY/MM/DD'),
      endDate: Moment().format('YYYY/MM/DD'),
      orgCd1: '',
      orgCd2: '',
      orgname: '',
      orgCd5Char: '',
      checkboxOrgCd5Char: null,
      courseCd: null,
    },
    selectedItem: undefined, // 選択された要素
  },
};
// reducerの作成
export default handleActions({
  // 画面の初期化
  [initializeAddUp]: (state) => {
    const { demandAddUp } = initialState;
    return { ...state, demandAddUp };
  },
  [initializeOrgChar]: (state, action) => {
    const { demandAddUp } = state;
    const conditions = action.payload;
    conditions.orgCd5Char = '';
    conditions.checkboxOrgCd5Char = null;
    return { ...state, demandAddUp: { ...demandAddUp, conditions } };
  },
  [dmdAddUpRequest]: (state, action) => {
    const { demandAddUp } = state;
    const conditions = action.payload.values;
    if (conditions.closeDate === undefined && conditions.strDate === undefined && conditions.strDate === undefined) {
      const myDate = new Date();
      const date = new Date(myDate.getFullYear(), myDate.getMonth(), 0);
      // 締め日のデフォルト値(前月の末日)を設定 ..... updated by C's
      conditions.closeDate = Moment(`${myDate.getFullYear()}/${myDate.getMonth()}/${date.getDate()}`).format('YYYY/MM/DD');
      // 受診日(開始)のデフォルト値(前月の先頭日)を設定
      conditions.strDate = Moment(`${myDate.getFullYear()}/${myDate.getMonth()}/1`).format('YYYY/MM/DD');
      // 受診日(終了)のデフォルト値(前月の末日)を設定
      conditions.endDate = Moment(`${myDate.getFullYear()}/${myDate.getMonth()}/${date.getDate()}`).format('YYYY/MM/DD');
      conditions.orgCd5Char = '';
      conditions.checkboxOrgCd5Char = null;
    }
    return { ...state, demandAddUp: { ...demandAddUp, conditions } };
  },
  // 入力チェック処理成功
  [dmdAddUpSuccess]: (state, action) => {
    const { demandAddUp } = state;
    // (これに伴い一覧が再描画される)
    const data = action.payload;
    const err = demandAddUp.err === 'err' ? 'err' : '';
    return { ...state, demandAddUp: { ...demandAddUp, data, err } };
  },
  // 入力チェック処理失敗
  [dmdAddUpFailure]: (state, action) => {
    const { demandAddUp } = state;
    const { data } = action.payload;
    const message = data;
    const err = 'err';
    return { ...state, demandAddUp: { ...demandAddUp, message, err } };
  },
  // 締め処理成功
  [dmdAddUpExecuteSuccess]: (state, action) => {
    const { demandAddUp } = state;
    const err = '';
    // (これに伴い一覧が再描画される)
    const dataRet = action.payload;
    let message = [];
    if (Number(dataRet) === 0) {
      message = ['請求締め処理を実行しましたが対象データがありませんでした。'];
    } else if (Number(dataRet) > 0) {
      message = ['請求締め処理を完了しました。'];
    }
    return { ...state, demandAddUp: { ...demandAddUp, message, err } };
  },
  [dmdAddUpExecuteFailure]: (state) => {
    const { demandAddUp } = state;
    const err = 'err';
    const message = ['請求締め処理に失敗しました。'];
    return { ...state, demandAddUp: { ...demandAddUp, err, message } };
  },

}, initialState);
