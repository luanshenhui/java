/**
 * @file 管理端末用Action＆Reducer
 */
import { createActions, handleActions } from 'redux-actions';

// 一覧Actionの作成
export const {
  initializeWorkStationList,
  getWorkStationListRequest,
  getWorkStationListSuccess,
  getWorkStationListFailure,
} = createActions(
  // 一覧初期化
  'INITIALIZE_WORK_STATION_LIST',
  // 一覧
  'GET_WORK_STATION_LIST_REQUEST',
  'GET_WORK_STATION_LIST_SUCCESS',
  'GET_WORK_STATION_LIST_FAILURE',
);

// 編集画面Actionの作成
export const {
  initializeWorkStation,
  getWorkStationRequest,
  getWorkStationSuccess,
  getWorkStationFailure,
} = createActions(
  // 編集画面初期化
  'INITIALIZE_WORK_STATION',
  // 編集画面表示
  'GET_WORK_STATION_REQUEST',
  'GET_WORK_STATION_SUCCESS',
  'GET_WORK_STATION_FAILURE',
);

// 登録Actionの作成
export const {
  registerWorkStationRequest,
  registerWorkStationSuccess,
  registerWorkStationFailure,
} = createActions(
  'REGISTER_WORK_STATION_REQUEST',
  'REGISTER_WORK_STATION_SUCCESS',
  'REGISTER_WORK_STATION_FAILURE',
);

// 削除Actionの作成
export const {
  deleteWorkStationRequest,
  deleteWorkStationSuccess,
  deleteWorkStationFailure,
} = createActions(
  'DELETE_WORK_STATION_REQUEST',
  'DELETE_WORK_STATION_SUCCESS',
  'DELETE_WORK_STATION_FAILURE',
);

// stateの初期値
const initialState = {
  // 管理端末一覧のState
  list: {
    // メッセージ
    message: [],
    // 一覧データ
    data: [],
    // 総件数
    totalcount: null,
    // 検索条件
    conditions: {
      page: 1,
      limit: 20,
    },
  },
  // 管理端末メンテナンスのstate
  edit: {
    // メッセージ
    message: [],
  },
};

// reducerの作成
export default handleActions({
  // 管理端末一覧初期化
  [initializeWorkStationList]: (state) => {
    const { list } = initialState;
    return { ...state, list };
  },
  // 管理端末一覧取得
  [getWorkStationListRequest]: (state, action) => {
    const conditions = { ...initialState.list.conditions, ...action.payload };
    return { ...state, list: { ...state.list, conditions } };
  },
  // 管理端末一覧取得成功
  [getWorkStationListSuccess]: (state, action) => {
    const { data, totalcount } = action.payload;
    return { ...state, list: { ...state.list, data, totalcount } };
  },
  // 管理端末情報の初期化
  [initializeWorkStation]: (state) => {
    const { edit } = initialState;
    return { ...state, edit };
  },
  // 管理端末登録処理成功
  [registerWorkStationSuccess]: (state) => {
    const message = ['登録が完了しました。'];
    return { ...state, edit: { ...state.edit, message } };
  },
  // 管理端末登録処理失敗
  [registerWorkStationFailure]: (state, action) => {
    const message = action.payload.data.errors;
    return { ...state, edit: { ...state.edit, message } };
  },
  // 管理端末削除処理成功
  [deleteWorkStationSuccess]: (state) => {
    const message = ['削除が完了しました。'];
    return { ...state, edit: { ...initialState.edit, message } };
  },
  // 管理端末削除処理失敗
  [deleteWorkStationFailure]: (state, action) => {
    const message = action.payload.data.errors;
    return { ...state, edit: { ...state.edit, message } };
  },
}, initialState);
