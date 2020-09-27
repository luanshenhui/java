import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  initializeWebOrgRsv,
  getWebOrgRequest,
  getWebOrgSuccess,
  getWebOrgFailure,
  openWebOrgRsvMainGuide,
  closeWebOrgRsvMainGuide,

} = createActions(
    // 取得
    'GET_WEB_ORG_REQUEST',  
    'GET_WEB_ORG_SUCCESS',  
    'GET_WEB_ORG_FAILURE',  
    // 初期化
    'INITIALIZE_WEB_ORG_RSV',
    'OPEN_WEB_ORG_RSV_MAIN_GUIDE',
    'CLOSE_WEB_ORG_RSV_MAIN_GUIDE',
  );

// stateの初期値
const initialState = {
  webOrgRsvList: {
    message: [],
    webno: '',
    regflg: '',
    csldate: '',    
    visible: false, // 可視状態
    
  },
};

// reducerの作成
export default handleActions({

  // 団体メンテナンス画面の初期化
  [initializeWebOrgRsv]: (state) => {
    const { webOrgRsvList } = initialState;
    return { ...state, webOrgRsvList };
  },

  // ガイドを開くアクション時の処理
  [openWebOrgRsvMainGuide]: (state, action) => {   
    // 可視状態をtrueにする
    const visible = true;
    const { webOrgRsvList } = initialState;
    return { ...state, webOrgRsvList: { ...webOrgRsvList, visible} };
  },
  // 閉じるアクション時の処理
  [closeWebOrgRsvMainGuide]: () => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const visible = false;
    return { ...initialState, visible };
  },

  // 契約情報取得失敗時の処理
  [getWebOrgFailure]: (state, action) => {
    //const { ctrsplitperiod } = state;
    const { status, data } = action.payload;
    let message = data;
    // HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['契約情報が存在しません。'];
    }
    return { ...state, webOrgRsvList: { ...webOrgRsvList } };
  },
}, initialState);
