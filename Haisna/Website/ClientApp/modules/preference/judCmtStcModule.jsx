import { createActions, handleActions } from 'redux-actions';

// action typeの定義
export const OPEN_ADVICE_COMMENT_GUIDE_REQUEST = 'OPEN_ADVICE_COMMENT_GUIDE_REQUEST';
export const OPEN_ADVICE_COMMENT_GUIDE_SUCCESS = 'OPEN_ADVICE_COMMENT_GUIDE_SUCCESS';
export const OPEN_ADVICE_COMMENT_GUIDE_FAILURE = 'OPEN_ADVICE_COMMENT_GUIDE_FAILURE';
export const CLOSE_ADVICE_COMMENT_GUIDE = 'CLOSE_ADVICE_COMMENT_GUIDE';
export const SELECT_ADVICE_COMMENT_GUIDE_ITEM = 'SELECT_ADVICE_COMMENT_GUIDE_ITEM';
export const GET_ADVICE_COMMENT_LIST_REQUEST = 'GET_ADVICE_COMMENT_LIST_REQUEST';
export const GET_ADVICE_COMMENT_LIST_SUCCESS = 'GET_ADVICE_COMMENT_LIST_SUCCESS';
export const GET_ADVICE_COMMENT_LIST_FAILURE = 'GET_ADVICE_COMMENT_LIST_FAILURE';

// actionの作成
export const actions = createActions(
  OPEN_ADVICE_COMMENT_GUIDE_REQUEST,
  OPEN_ADVICE_COMMENT_GUIDE_SUCCESS,
  OPEN_ADVICE_COMMENT_GUIDE_FAILURE,
  CLOSE_ADVICE_COMMENT_GUIDE,
  SELECT_ADVICE_COMMENT_GUIDE_ITEM,
  GET_ADVICE_COMMENT_LIST_REQUEST,
  GET_ADVICE_COMMENT_LIST_SUCCESS,
  GET_ADVICE_COMMENT_LIST_FAILURE,
);

// stateの初期値
const initialState = {
  adviceCommentGuide: {
    open: false,
    listItems: [],
    initialSelected: [],
    judClass: {},
    selected: [],
  },
};

// reducerの作成
export default handleActions({
  OPEN_ADVICE_COMMENT_GUIDE_REQUEST: (state, action) => {
    // 初期選択済み判定コメントコードの取得
    const { initialSelected = [] } = action.payload;
    // 選択済み判定コメントコードの初期値として初期選択判定コメントコードを設定
    const selected = initialSelected.concat();
    const open = true;
    const adviceCommentGuide = { ...initialState.adviceCommentGuide, open, initialSelected, selected };
    return { ...state, adviceCommentGuide };
  },
  OPEN_ADVICE_COMMENT_GUIDE_SUCCESS: (state, action) => {
    // 判定分類及び判定コメント一覧の取得
    const { judClass, judgesComments = [] } = action.payload;
    const adviceCommentGuide = { ...state.adviceCommentGuide, judClass, listItems: judgesComments.data };
    return { ...state, adviceCommentGuide };
  },
  CLOSE_ADVICE_COMMENT_GUIDE: (state) => {
    const open = false;
    const adviceCommentGuide = { ...initialState.adviceCommentGuide, open };
    return { ...state, adviceCommentGuide };
  },
  SELECT_ADVICE_COMMENT_GUIDE_ITEM: (state, action) => {
    // 選択された判定コメントコードを取得
    const { judcmtcd } = action.payload;
    // 初期選択済み、及び選択済み判定コメントコードの取得
    const { initialSelected, selected } = state.adviceCommentGuide;
    // 選択された判定コメントコードが初期選択済み判定コメントコードに含まれている場合は変更不可
    if (initialSelected.indexOf(judcmtcd) !== -1) {
      return state;
    }
    // 含まれていない場合は新しい選択済み判定コメントコードの集合を作成する
    let newSelected = [];
    // 選択判定コメントコードに含まれているかを判定
    const index = selected.indexOf(judcmtcd);
    // 含まれていない場合は追加し、含まれている場合は削除した結果を新しい選択済み判定コメントコードの集合とする
    if (index < 0) {
      newSelected = newSelected.concat(selected, judcmtcd);
    } else {
      newSelected = newSelected.concat(selected);
      newSelected.splice(index, 1);
    }
    const adviceCommentGuide = { ...state.adviceCommentGuide, selected: newSelected };
    return { ...state, adviceCommentGuide };
  },
}, initialState);
