import axios from 'axios';
import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  openUserGuide,
  closeUserGuide,
  getUserListRequest,
  getUserListSuccess,
  getUserListFailure,
  getUserRequest,
  getUserSuccess,
  getUserFailure,
} = createActions(
  'OPEN_USER_GUIDE',
  'CLOSE_USER_GUIDE',
  'GET_USER_LIST_REQUEST',
  'GET_USER_LIST_SUCCESS',
  'GET_USER_LIST_FAILURE',
  'GET_USER_REQUEST',
  'GET_USER_SUCCESS',
  'GET_USER_FAILURE',
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
  [openUserGuide]: (state) => {
    // 可視状態をtrueにする
    const { guide } = initialState;
    const visible = true;
    return { ...state, guide: { ...guide, visible } };
  },
  // ユーザ一覧取得開始時の処理
  [getUserListRequest]: (state, action) => {
    // 検索条件を更新する
    const { guide } = state;
    const { conditions } = action.payload;
    return { ...state, guide: { ...guide, conditions } };
  },
  // ユーザ一覧取得成功時の処理
  [getUserListSuccess]: (state, action) => {
    const { guide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, guide: { ...guide, searched, totalCount, data } };
  },
  // ユーザ取得成功時の処理
  [getUserSuccess]: (state, action) => {
    // 選択された要素を更新
    const { guide } = state;
    const { selectedItem } = action.payload;
    return { ...state, guide: { ...guide, selectedItem } };
  },
  // 閉じるアクション時の処理
  [closeUserGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { guide } = initialState;
    return { ...state, guide };
  },
}, initialState);

// 以下はredux-thunkを利用した処理

const mockAdapterOfGetUserList = () => (
  new Promise((resolve) => {
    const status = 200;
    const data = {
      totalcount: 1000,
      data: [
        { userid: '000001', username: '富士通　テスト０１' },
        { userid: '000002', username: '富士通　テスト０２' },
        { userid: '000003', username: '富士通　テスト０３' },
        { userid: '000004', username: '富士通　テスト０４' },
        { userid: '000005', username: '富士通　テスト０５' },
        { userid: '000006', username: '富士通　テスト０６' },
        { userid: '000007', username: '富士通　テスト０７' },
        { userid: '000008', username: '富士通　テスト０８' },
        { userid: '000009', username: '富士通　テスト０９' },
        { userid: '000010', username: '富士通　テスト１０' },
        { userid: '000011', username: '富士通　テスト１１' },
        { userid: '000012', username: '富士通　テスト１２' },
        { userid: '000013', username: '富士通　テスト１３' },
        { userid: '000014', username: '富士通　テスト１４' },
        { userid: '000015', username: '富士通　テスト１５' },
        { userid: '000016', username: '富士通　テスト１６' },
        { userid: '000017', username: '富士通　テスト１７' },
        { userid: '000018', username: '富士通　テスト１８' },
        { userid: '000019', username: '富士通　テスト１９' },
        { userid: '000020', username: '富士通　テスト１０' },
      ],
    };
    resolve({ status, data });
  })
);

const mockAdapterOfGetUser = () => (
  new Promise((resolve) => {
    const status = 200;
    const data = {
      userid: '000001',
      username: '富士通　テスト０１',
    };
    resolve({ status, data });
  })
);

// ユーザ一覧取得
export const getUserList = (conditions) => (dispatch) => {
  // 検索条件の設定(デフォルト値の補完)
  const params = { page: 1, limit: 20, ...conditions };
  // ユーザ一覧取得開始アクション
  dispatch(getUserListRequest({ conditions: params }));
  // urlの定義
  const url = '/api/v1/users';
  // ユーザ一覧取得API呼び出し
  axios
    .get(url, {
      params,
      adapter: mockAdapterOfGetUserList,
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
      validateStatus: (status) => (status < 500),
    })
    .then((res) => {
      // 成功時はユーザ一覧取得成功アクションを呼び出す
      const totalCount = res.data.totalcount || 0;
      const data = res.data.data || [];
      dispatch(getUserListSuccess({ totalCount, data }));
    })
    .catch((error) => {
      // 失敗時はユーザ一覧取得失敗アクションを呼び出す
      dispatch(getUserListFailure(error.response));
    });
};

// ユーザ取得
export const getUser = (userid) => (dispatch) => {
  // ユーザ取得開始アクション
  dispatch(getUserRequest());
  // urlの定義
  const url = `/api/v1/users/${userid}`;
  // ユーザ取得API呼び出し
  axios
    .get(url, { adapter: mockAdapterOfGetUser })
    .then((res) => {
      // 成功時はユーザ取得成功アクションを呼び出す
      const selectedItem = res.data;
      dispatch(getUserSuccess({ selectedItem }));
    })
    .catch((error) => {
      // 失敗時はユーザ取得失敗アクションを呼び出す
      dispatch(getUserFailure(error.response));
    });
};
