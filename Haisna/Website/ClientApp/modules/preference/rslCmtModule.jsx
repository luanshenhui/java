import axios from 'axios';
import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const { openRslCmtGuide, closeRslCmtGuide, getRslCmtListRequest, getRslCmtListSuccess, getRslCmtListFailure, getRslCmtRequest, getRslCmtSuccess, getRslCmtFailure } = createActions(
  'OPEN_RSL_CMT_GUIDE',
  'CLOSE_RSL_CMT_GUIDE',
  'GET_RSL_CMT_LIST_REQUEST',
  'GET_RSL_CMT_LIST_SUCCESS',
  'GET_RSL_CMT_LIST_FAILURE',
  'GET_RSL_CMT_REQUEST',
  'GET_RSL_CMT_SUCCESS',
  'GET_RSL_CMT_FAILURE',
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
    rslCmtGuideTargets: null, // 選択された要素
  },
};

// reducerの作成
export default handleActions({
  // 開くアクション時の処理
  [openRslCmtGuide]: (state, action) => {
    // 可視状態をtrueにする
    const { guide } = initialState;
    const visible = true;
    const { rslCmtGuideTargets } = action.payload;
    return { ...state, guide: { ...guide, visible, rslCmtGuideTargets } };
  },
  // 結果コメント一覧取得開始時の処理
  [getRslCmtListRequest]: (state, action) => {
    // 検索条件を更新する
    const { guide } = state;
    const { conditions } = action.payload;
    return { ...state, guide: { ...guide, conditions } };
  },
  // 結果コメント一覧取得成功時の処理
  [getRslCmtListSuccess]: (state, action) => {
    const { guide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, guide: { ...guide, searched, totalCount, data } };
  },
  // 結果コメント取得成功時の処理
  [getRslCmtSuccess]: (state, action) => {
    // 選択された要素を更新
    const { guide } = state;
    const { selectedItem } = action.payload;
    return { ...state, guide: { ...guide, selectedItem } };
  },
  // 閉じるアクション時の処理
  [closeRslCmtGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { guide } = initialState;
    return { ...state, guide };
  },
}, initialState);

// 以下はredux-thunkを利用した処理
const mockAdapterOfGetRslCmtList = () => (
  new Promise((resolve) => {
    const status = 200;
    const data = {
      totalcount: 1000,
      data: [
        { rslcmtcd: '11', rslcmtname: '異常値' },
        { rslcmtcd: '12', rslcmtname: '検コメ' },
        { rslcmtcd: '90', rslcmtname: '取消' },
        { rslcmtcd: '<', rslcmtname: '＜' },
        { rslcmtcd: '<<', rslcmtname: '＜' },
        { rslcmtcd: '=<', rslcmtname: '＝＜' },
        { rslcmtcd: '=>', rslcmtname: '＝＞' },
        { rslcmtcd: '>', rslcmtname: '＞' },
        { rslcmtcd: '>>', rslcmtname: '＞' },
        { rslcmtcd: 'B1', rslcmtname: '高値希' },
        { rslcmtcd: 'B2', rslcmtname: '不足希' },
        { rslcmtcd: 'B3', rslcmtname: '希釈' },
        { rslcmtcd: 'B4', rslcmtname: '希釈' },
        { rslcmtcd: 'B5', rslcmtname: '濃縮' },
        { rslcmtcd: 'C2', rslcmtname: '再検不' },
        { rslcmtcd: 'C3', rslcmtname: '弱反応' },
        { rslcmtcd: 'C4', rslcmtname: '非特異' },
        { rslcmtcd: 'C5', rslcmtname: '抗補体' },
        { rslcmtcd: 'C6', rslcmtname: '薬影響' },
        { rslcmtcd: 'C7', rslcmtname: '報告参' },
      ],
    };
    resolve({ status, data });
  })
);

const mockAdapterOfGetRslCmt = () => (
  new Promise((resolve) => {
    const status = 200;
    const data = {
      rslcmtcd: '90',
      rslcmtname: '取消',
    };
    resolve({ status, data });
  })
);

// 結果コメント一覧取得
export const getRslCmtList = (conditions) => (dispatch) => {
  // 検索条件の設定(デフォルト値の補完)
  const params = { page: 1, limit: 20, ...conditions };
  // 結果コメント一覧取得開始アクション
  dispatch(getRslCmtListRequest({ conditions: params }));
  // urlの定義
  const url = '/api/v1/resultcomments';
  // 結果コメント一覧取得API呼び出し
  axios
    .get(url, {
      params,
      adapter: mockAdapterOfGetRslCmtList,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 500),
    })
    .then((res) => {
      // 成功時はユーザ一覧取得成功アクションを呼び出す
      const totalCount = res.data.totalcount || 0;
      const data = res.data.data || [];
      dispatch(getRslCmtListSuccess({ totalCount, data }));
    })
    .catch((error) => {
      // 失敗時は結果コメント一覧取得失敗アクションを呼び出す
      dispatch(getRslCmtListFailure(error.response));
    });
};

// 結果コメント取得
export const getRslCmt = (rslcmtcd) => (dispatch) => {
  // 結果コメント取得開始アクション
  dispatch(getRslCmtRequest());
  // urlの定義
  const url = `/api/v1/resultcomments/${rslcmtcd}`;
  // 結果コメント取得API呼び出し
  axios
    .get(url, { adapter: mockAdapterOfGetRslCmt })
    .then((res) => {
      // 成功時は結果コメント取得成功アクションを呼び出す
      const selectedItem = res.data;
      dispatch(getRslCmtSuccess({ selectedItem }));
    })
    .catch((error) => {
      // 失敗時は結果コメント取得失敗アクションを呼び出す
      dispatch(getRslCmtFailure(error.response));
    });
};
