import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  initializeMngList,
  checkMngData,
  getMngAccuracyRequest,
  getMngAccuracySuccess,
  getMngAccuracyFailure,
} = createActions(
  // 精度管理一覧初期化処理
  'INITIALIZE_MNG_LIST',
  // 入力チェック処理
  'CHECK_MNG_DATA',
  // 成績書情報一覧を抽出
  'GET_MNG_ACCURACY_REQUEST',
  'GET_MNG_ACCURACY_SUCCESS',
  'GET_MNG_ACCURACY_FAILURE',
);

// stateの初期値
const initialState = {
  mngaccuracyInfoList: {
    message: [],
    // 以下一覧用
    conditions: {
      strcsldate: moment(new Date()).format('YYYY/MM/DD'),
      gendermode: 1,
      border: null,
    }, // 検索条件
    mngdata: [],
    searched: false,
  },
};

// reducerの作成
export default handleActions({
  // 精度管理一覧初期化処理
  [initializeMngList]: (state) => {
    const { mngaccuracyInfoList } = initialState;
    return { ...state, mngaccuracyInfoList };
  },
  // 入力チェック処理
  [checkMngData]: (state, action) => {
    const { mngaccuracyInfoList } = state;
    const message = action.payload;
    return { ...state, mngaccuracyInfoList: { ...mngaccuracyInfoList, message } };
  },
  // 検索条件に従い成績書情報一覧を抽出開始時の処理
  [getMngAccuracyRequest]: (state, action) => {
    const { mngaccuracyInfoList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    const mngdata = [];
    return { ...state, mngaccuracyInfoList: { ...mngaccuracyInfoList, conditions, mngdata } };
  },
  // 検索条件に従い成績書情報一覧を抽出成功時の処理
  [getMngAccuracySuccess]: (state, action) => {
    const { mngaccuracyInfoList } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { mngdata, message } = action.payload;
    return { ...state, mngaccuracyInfoList: { ...mngaccuracyInfoList, searched, mngdata, message } };
  },
  // 検索条件に従い成績書情報一覧を抽出失敗時の処理
  [getMngAccuracyFailure]: (state) => {
    const { mngaccuracyInfoList } = state;
    // 検索指示状態とする
    const searched = true;
    // (これに伴い一覧が再描画される)
    const mngdata = [];
    const message = [];
    return { ...state, mngaccuracyInfoList: { ...mngaccuracyInfoList, searched, mngdata, message } };
  },
}, initialState);
