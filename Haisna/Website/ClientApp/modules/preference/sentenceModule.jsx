import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getHainsUserRequest,
  getHainsUserSuccess,
  getHainsUserFailure,
  getSentenceRequest,
  getSentenceSuccess,
  getSentenceFailure,
} = createActions(
  // ユーザ情報取得
  'GET_HAINS_USER_REQUEST',
  'GET_HAINS_USER_SUCCESS',
  'GET_HAINS_USER_FAILURE',
  // 文章参照コード取得
  'GET_SENTENCE_REQUEST',
  'GET_SENTENCE_SUCCESS',
  'GET_SENTENCE_FAILURE',
);

// stateの初期値
const initialState = {
  entryAutherList: {
    message: [],
    visible: true,
    hainsUserData: {},
    flagMen: 0,
    flagJud: 0,
    flagKan: 0,
    flagEif: 0,
    flagShi: 0,
    flagNai: 0,
    flagCheck: 0,
    docindex: '',
    checkValue: [],
  },

};

// reducerの作成
export default handleActions({

  // 内視鏡医フラグ取得成功時の処理
  [getHainsUserSuccess]: (state, action) => {
    const { entryAutherList } = state;
    const hainsUserData = action.payload;
    return { ...state, entryAutherList: { ...entryAutherList, hainsUserData } };
  },
  // 文章参照コード取得成功時の処理
  [getSentenceSuccess]: (state, action) => {
    const { entryAutherList } = state;
    const { flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue } = action.payload;
    return { ...state, entryAutherList: { ...entryAutherList, flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue } };
  },


}, initialState);
