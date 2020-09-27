import axios from 'axios';
import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getAllItemClassesRequest,
  getAllItemClassesSuccess,
  getAllItemClassesFailure,
} = createActions(
  // 全検査分類取得
  'GET_ALL_ITEM_CLASSES_REQUEST',
  'GET_ALL_ITEM_CLASSES_SUCCESS',
  'GET_ALL_ITEM_CLASSES_FAILURE',
);

const initialState = {
  guide: {
    data: [],
  },
};

export default handleActions({
  [getAllItemClassesSuccess]: (state, action) => {
    const { guide } = state;
    return { ...state, guide: { ...guide, data: action.payload } };
  },
}, initialState);

// 全検査分類の取得
export const getAllItemClasses = () => (dispatch) => {
  // urlの定義
  const url = '/api/itemclass/';

  // 全検査分類取得
  axios
    .get(url)
    .then((res) => {
      // 成功時は全検査分類取得成功アクションを呼び出す
      dispatch(getAllItemClassesSuccess(res.data.data));
    });
};
