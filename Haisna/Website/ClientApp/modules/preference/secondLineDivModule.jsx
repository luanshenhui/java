import axios from 'axios';
import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  openSecondLineDivGuide,
  closeSecondLineDivGuide,
  getSecondLineDivListRequest,
  getSecondLineDivListSuccess,
  getSecondLineDivListFailure,
  getSecondLineDivRequest,
  getSecondLineDivSuccess,
  getSecondLineDivFailure,
} = createActions(
  'OPEN_SECOND_LINE_DIV_GUIDE',
  'CLOSE_SECOND_LINE_DIV_GUIDE',
  'GET_SECOND_LINE_DIV_LIST_REQUEST',
  'GET_SECOND_LINE_DIV_LIST_SUCCESS',
  'GET_SECOND_LINE_DIV_LIST_FAILURE',
  'GET_SECOND_LINE_DIV_REQUEST',
  'GET_SECOND_LINE_DIV_SUCCESS',
  'GET_SECOND_LINE_DIV_FAILURE',
);

// stateの初期値
const initialState = {
  guide: {
    visible: false, // 可視状態
    conditions: {}, // 検索条件
    searched: false,
    totalCount: 0,
    data: [],
    selectedItem: undefined, // 選択された要素
  },
};

// reducerの作成
export default handleActions({
  // 開くアクション時の処理
  [openSecondLineDivGuide]: (state) => {
    // 可視状態をtrueにする
    const { guide } = initialState;
    const visible = true;
    return { ...state, guide: { ...guide, visible } };
  },
  // 2次請求明細一覧取得開始時の処理
  [getSecondLineDivListRequest]: (state, action) => {
    // 検索条件を更新する
    const { guide } = state;
    const { conditions } = action.payload;
    return { ...state, guide: { ...guide, conditions } };
  },
  // 2次請求明細一覧取得成功時の処理
  [getSecondLineDivListSuccess]: (state, action) => {
    const { guide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, guide: { ...guide, searched, totalCount, data } };
  },
  // 2次請求明細取得成功時の処理
  [getSecondLineDivSuccess]: (state, action) => {
    // 選択された要素を更新
    const { guide } = state;
    const { selectedItem } = action.payload;
    return { ...state, guide: { ...guide, selectedItem } };
  },
  // 閉じるアクション時の処理
  [closeSecondLineDivGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { guide } = initialState;
    return { ...state, guide };
  },
}, initialState);

// 以下はredux-thunkを利用した処理

// 2次請求明細一覧取得
export const getSecondLineDivList = (conditions) => (dispatch) => {
  // 検索条件の設定(デフォルト値の補完)
  const params = { page: 1, limit: 20, ...conditions };
  // 2次請求明細一覧取得開始アクション
  dispatch(getSecondLineDivListRequest({ conditions: params }));
  // urlの定義
  const url = '/api/v1/billingitems/';
  // 2次請求明細一覧取得API呼び出し
  axios
    .get(url, {
      params,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 500),
    })
    .then((res) => {
      // 成功時は2次請求明細一覧取得成功アクションを呼び出す
      const totalCount = res.data.totalcount || 0;
      const data = res.data.data || [];
      dispatch(getSecondLineDivListSuccess({ totalCount, data }));
    })
    .catch((error) => {
      // 失敗時は2次請求明細一覧取得失敗アクションを呼び出す
      dispatch(getSecondLineDivListFailure(error.response));
    });
};

// 2次請求明細取得
export const getSecondLineDiv = (secondlinedivcd) => (dispatch) => {
  // 2次請求明細取得開始アクション
  dispatch(getSecondLineDivRequest());
  // urlの定義
  const url = `/api/v1/billingitems/${secondlinedivcd}`;
  // 2次請求明細取得API呼び出し
  axios
    .get(url)
    .then((res) => {
      // 成功時は2次請求明細取得成功アクションを呼び出す
      dispatch(getSecondLineDivSuccess({ selectedItem: res.data }));
    })
    .catch((error) => {
      // 失敗時は2次請求明細取得失敗アクションを呼び出す
      dispatch(getSecondLineDivFailure(error.response));
    });
};
