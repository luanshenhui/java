import { createActions, handleActions } from 'redux-actions';
import Moment from 'moment';

// actionの作成
export const {
  getFreeByClassCdRequest,
  getFreeByClassCdSuccess,
  getFreeByClassCdFailure,
  getFreeRequest,
  getFreeSuccess,
  getFreeFailure,
  initializePerAddUp,
  getUpdPerAddUpRequest,
  getUpdPerAddUpSuccess,
  getUpdPerAddUpFailure,
  getPerAddUpRequest,
  getPerAddUpSuccess,
  getPerAddUpFailure,
  getHainsUserRequest,
  getHainsUserSuccess,
  getHainsUserFailure,
  getFreeCountRequest,
  getFreeCountSuccess,
  getFreeCountFailure,
} = createActions(
  // 汎用マスタよりデータ取得
  'GET_FREE_BY_CLASS_CD_REQUEST',
  'GET_FREE_BY_CLASS_CD_SUCCESS',
  'GET_FREE_BY_CLASS_CD_FAILURE',
  // 汎用情報一覧
  'GET_FREE_REQUEST',
  'GET_FREE_SUCCESS',
  'GET_FREE_FAILURE',
  // 初期化
  'INITIALIZE_PER_ADD_UP',
  // 変更用
  'GET_UPD_PER_ADD_UP_REQUEST',
  'GET_UPD_PER_ADD_UP_SUCCESS',
  'GET_UPD_PER_ADD_UP_FAILURE',
  // 一覧用
  'GET_PER_Add_Up_REQUEST',
  'GET_PER_Add_Up_SUCCESS',
  'GET_PER_Add_Up_FAILURE',
  // HainsUser情報取得
  'GET_HAINS_USER_REQUEST',
  'GET_HAINS_USER_SUCCESS',
  'GET_HAINS_USER_FAILURE',
  // freeCount取得
  'GET_FREE_COUNT_REQUEST',
  'GET_FREE_COUNT_SUCCESS',
  'GET_FREE_COUNT_FAILURE',
);

// stateの初期値
const initialState = {
  freeByClassCd: {
    data: [],
  },
  freeList: {
    mode: '',
    freeCd: '',
    freedata: [],
  },
  perAddUp: {
    conditions: {
      closeDate: Moment().format('YYYY/MM/DD'),
      Upddate: Moment().format('YYYY/MM/DD HH:mm:ss'),
      freeCd: 'DAILYCLS',
    },
    visible: false, // 可視状態
    searched: false,
    data: [],
    message: [],
    dataUser: {},
    dataUp: [],
  },
};

// reducerの作成
export default handleActions({
  // 汎用マスタよりデータ取得成功時の処理
  [getFreeByClassCdSuccess]: (state, action) => {
    const { freeByClassCd } = state;
    const data = action.payload;
    return { ...state, freeByClassCd: { ...freeByClassCd, data } };
  },
  // 汎用情報一覧取得成功時の処理
  [getFreeSuccess]: (state, action) => {
    const { freeList } = state;
    const data = action.payload;
    return { ...state, freeList: { ...freeList, freedata: data } };
  },
  // 一覧初期化処理
  [initializePerAddUp]: (state) => {
    const { perAddUp } = initialState;
    return { ...state, perAddUp };
  },
  // 変更成功時の処理
  [getUpdPerAddUpSuccess]: (state, action) => {
    const { perAddUp } = state;
    // 更新完了時は「更新完了」の通知
    const message = ['日次締め処理を完了しました。'];
    const data = action.payload;
    return { ...state, perAddUp: { ...perAddUp, data, message } };
  },
  [getUpdPerAddUpFailure]: (state, action) => {
    const { perAddUp } = state;
    let message;
    // 入力日付のチェック
    // 更新の正常・異常チェック
    if (action.payload.freedate === null) {
      message = ['締め日の入力形式空ではない。'];
    } else {
      message = ['日次締め処理に失敗しました。'];
    }
    return { ...state, perAddUp: { ...perAddUp, message } };
  },
  // 一覧取得成功時の処理
  [getPerAddUpSuccess]: (state, action) => {
    const { perAddUp } = state;
    // (これに伴い一覧が再描画される)
    const dataUp = action.payload;
    if (dataUp[0].freedate === null) {
      perAddUp.conditions.closeDate = Moment().format('YYYY/MM/DD');
    } else {
      perAddUp.conditions.closeDate = Moment(dataUp[0].freedate).format('YYYY/MM/DD');
    }
    return { ...state, perAddUp: { ...perAddUp, dataUp } };
  },
  // HainsUser情報取得成功時の処理
  [getHainsUserSuccess]: (state, action) => {
    const { perAddUp } = state;
    // (これに伴い一覧が再描画される)
    const dataUser = action.payload;
    return { ...state, perAddUp: { ...perAddUp, dataUser } };
  },
  // FreeCount情報取得成功時の処理
  [getFreeCountSuccess]: (state, action) => {
    const { perAddUp } = state;
    const ret = action.payload;
    let message;
    // レコードが存在しない場合は処理を抜ける
    if (ret === 0) {
      message = ['締め日を格納するレコードが存在しません。マスタメンテナンス画面より「KEY = DAILYCLS」のレコードを作成して下さい。'];
    }
    return { ...state, perAddUp: { ...perAddUp, message } };
  },
}, initialState);
