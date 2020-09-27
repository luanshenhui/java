import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  initializeBbs,
  getAllBbsRequest,
  getAllBbsSuccess,
  getAllBbsFailure,
  deleteBbsRequest,
  deleteBbsSuccess,
  deleteBbsFailure,
  registerBbsRequest,
  registerBbsSuccess,
  registerBbsFailure,
  initializeBbsEdit,
} = createActions(
  // 初期化
  'INITIALIZE_BBS',
  // 取得
  'GET_ALL_BBS_REQUEST',
  'GET_ALL_BBS_SUCCESS',
  'GET_ALL_BBS_FAILURE',
  // 削除
  'DELETE_BBS_REQUEST',
  'DELETE_BBS_SUCCESS',
  'DELETE_BBS_FAILURE',
  // 登録
  'REGISTER_BBS_REQUEST',
  'REGISTER_BBS_SUCCESS',
  'REGISTER_BBS_FAILURE',
  // 初期化
  'INITIALIZE_BBS_EDIT',
);

// stateの初期値
const initialState = {
  bbsList: {
    data: [],
    message: [],
  },
  bbsEdit: {
    message: [],
  },
};

// reducerの作成
export default handleActions({

  // 初期化処理
  [initializeBbs]: (state) => {
    const { bbsList } = initialState;
    return { ...state, bbsList };
  },
  // 取得成功時の処理
  [getAllBbsSuccess]: (state, action) => {
    const { bbsList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    return { ...state, bbsList: { ...bbsList, data } };
  },
  // 登録失敗時の処理
  [registerBbsFailure]: (state, action) => {
    const { bbsEdit } = state;
    const { data } = action.payload;
    const message = data;
    return { ...state, bbsEdit: { ...bbsEdit, message } };
  },
  // 初期化処理
  [initializeBbsEdit]: (state) => {
    const { bbsEdit } = initialState;
    return { ...state, bbsEdit };
  },
}, initialState);
