import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getZipListRequest,
  getZipListSuccess,
  getZipListFailure,
  getZip,
  openZipGuide,
  closeZipGuide,
} = createActions(
  'GET_ZIP_LIST_REQUEST',
  'GET_ZIP_LIST_SUCCESS',
  'GET_ZIP_LIST_FAILURE',
  'GET_ZIP',
  'OPEN_ZIP_GUIDE',
  'CLOSE_ZIP_GUIDE',
);

// stateの初期値
const initialState = {
  conditions: {}, // 検索条件
  searched: false, // 検索済状態
  totalCount: 0,
  data: [],
  selectedItem: undefined, // 選択された要素
  visible: false, // ガイドの表示状態
  targets: {}, // 一覧から選択した値をセットするフィールド名
  messages: [], // エラー等のメッセージ
};

// reducerの作成
export default handleActions({
  // 郵便番号一覧取得開始時の処理
  [getZipListRequest]: (state, action) => {
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, conditions };
  },
  // 郵便番号一覧取得成功時の処理
  [getZipListSuccess]: (state, action) => {
    // 検索指示済状態とする
    const searched = true;
    // メッセージは初期化する
    const { messages } = initialState;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, searched, totalCount, data, messages };
  },
  // 郵便番号一覧取得失敗時の処理
  [getZipListFailure]: (state, action) => {
    // メッセージ
    const { status, data } = action.payload;
    let messages = data.errors;
    if (!messages && status === 404) {
      messages = ['検索キーに該当するデータはありませんでした。'];
    }
    return { ...state, messages };
  },
  // 郵便番号取得成功時の処理
  [getZip]: (state, action) => {
    // 選択された要素を更新
    const { selectedItem } = action.payload;
    return { ...state, selectedItem };
  },
  // 郵便番号ガイド表示処理
  [openZipGuide]: (state, action) => {
    // 可視状態にする
    const visible = true;

    const { targets, conditions } = action.payload;
    return { ...state, visible, targets, conditions };
  },
  // 郵便番号ガイドを閉じる処理
  // 初期状態に戻すことでガイドを閉じる
  [closeZipGuide]: () => (
    initialState
  ),
}, initialState);

