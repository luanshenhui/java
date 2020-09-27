import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getOrgRequest,
  getOrgSuccess,
  getOrgFailure,
  initializeOrg,
  registerOrgRequest,
  registerOrgSuccess,
  registerOrgFailure,
  deleteOrgRequest,
  deleteOrgSuccess,
  deleteOrgFailure,
  getOrgListRequest,
  getOrgListSuccess,
  getOrgListFailure,
  initializeOrgList,
  getOrgGuideListRequest,
  getOrgGuideListSuccess,
  getOrgGuideListFailure,
  getOrgGuideValueRequest,
  getOrgGuideValueSuccess,
  getOrgGuideValueFailure,
  openOrgGuide,
  closeOrgGuide,
  // 成績書オプション管理ガイド用
  getOrgRptSetOptionGuideRequest,
  getOrgRptSetOptionGuideSuccess,
  getOrgRptSetOptionGuideFailure,
  registerOrgRptOptRequest,
  registerOrgRptOptSuccess,
  registerOrgRptOptFailure,
  openOrgRptSetOptionGuide,
  closeOrgRptSetOptionGuide,
  setOrgTarget,
  getOrgHeaderRequest,
  getOrgHeaderSuccess,
  getOrgHeaderFailure,
  // 受診者数取得（団体別）
  getSelDateOrgRequest,
  getSelDateOrgSuccess,
  getSelDateOrgFailure,
} = createActions(
  // 取得
  'GET_ORG_REQUEST',
  'GET_ORG_SUCCESS',
  'GET_ORG_FAILURE',
  // 初期化
  'INITIALIZE_ORG',
  // 登録
  'REGISTER_ORG_REQUEST',
  'REGISTER_ORG_SUCCESS',
  'REGISTER_ORG_FAILURE',
  // 削除
  'DELETE_ORG_REQUEST',
  'DELETE_ORG_SUCCESS',
  'DELETE_ORG_FAILURE',
  // 一覧用
  'GET_ORG_LIST_REQUEST',
  'GET_ORG_LIST_SUCCESS',
  'GET_ORG_LIST_FAILURE',
  // 一覧初期化
  'INITIALIZE_ORG_LIST',
  // ガイド用
  'GET_ORG_GUIDE_LIST_REQUEST',
  'GET_ORG_GUIDE_LIST_SUCCESS',
  'GET_ORG_GUIDE_LIST_FAILURE',
  // ガイド用
  'GET_ORG_GUIDE_VALUE_REQUEST',
  'GET_ORG_GUIDE_VALUE_SUCCESS',
  'GET_ORG_GUIDE_VALUE_FAILURE',
  'OPEN_ORG_GUIDE',
  'CLOSE_ORG_GUIDE',
  // 成績書オプション管理ガイド用
  'GET_ORG_RPT_SET_OPTION_GUIDE_REQUEST',
  'GET_ORG_RPT_SET_OPTION_GUIDE_SUCCESS',
  'GET_ORG_RPT_SET_OPTION_GUIDE_FAILURE',
  'REGISTER_ORG_RPT_OPT_REQUEST',
  'REGISTER_ORG_RPT_OPT_SUCCESS',
  'REGISTER_ORG_RPT_OPT_FAILURE',
  'OPEN_ORG_RPT_SET_OPTION_GUIDE',
  'CLOSE_ORG_RPT_SET_OPTION_GUIDE',
  'SET_ORG_TARGET',
  'GET_ORG_HEADER_REQUEST',
  'GET_ORG_HEADER_SUCCESS',
  'GET_ORG_HEADER_FAILURE',
  // 受診者数取得（団体別）
  'GET_SEL_DATE_ORG_REQUEST',
  'GET_SEL_DATE_ORG_SUCCESS',
  'GET_SEL_DATE_ORG_FAILURE',
);

// stateの初期値
const initialState = {
  organizationEdit: {
    org: {},
    message: [],
  },
  organizationList: {
    message: [],
    // 以下一覧用
    conditions: {
      keyword: '',
      page: 1,
      limit: 20,
    }, // 検索条件
    totalCount: null,
    data: [],
  },
  organizationGuide: {
    message: [],
    // 以下一覧用
    conditions: {
      keyword: '',
      page: 1,
      limit: 20,
    }, // 検索条件
    totalCount: 0,
    data: [],
    // 以下ガイド用
    visible: false, // 可視状態
    searched: false,
    selectedItem: undefined, // 選択された要素
  },

  organizationRptOptionGuide: {
    conditions: {}, // 検索条件
    totalCount: 0,
    data: [],
    orgrptoptrptv: [],
    orgrptoptrptd: [],
    selectedItem: undefined, // 選択された要素
    visible: false, // ガイドの表示状態
    targets: {}, // 一覧から選択した値をセットするフィールド名
    messages: [], // エラー等のメッセージ
  },
  organizationHeader: {
    data: {},
  },
  target: 'org',
  // 受診者数取得（団体別）
  selDateOrg: {
    data: [],
    messages: [], // エラー等のメッセージ
  },
};

// reducerの作成
export default handleActions({
  // 団体メンテナンス画面の初期化
  [initializeOrg]: (state) => {
    const { organizationEdit } = initialState;
    return { ...state, organizationEdit };
  },

  // 団体コードをキーに団体テーブルを読み込む成功時の処理
  [getOrgSuccess]: (state, action) => {
    const { organizationEdit } = state;
    // (これに伴い一覧が再描画される)
    const { org } = action.payload;
    return { ...state, organizationEdit: { ...organizationEdit, org } };
  },
  // 団体情報取得失敗時の処理
  [getOrgFailure]: (state, action) => {
    const { organizationEdit } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }
    return { ...state, organizationEdit: { ...organizationEdit, message } };
  },
  // 団体登録成功時の処理
  [registerOrgSuccess]: (state) => {
    const { organizationEdit } = state;
    const message = ['保存が完了しました。'];
    return { ...state, organizationEdit: { ...organizationEdit, message } };
  },
  // 団体情報削除成功時の処理
  [deleteOrgSuccess]: (state) => {
    const { organizationEdit } = initialState;
    const message = ['削除が完了しました。'];
    return { ...state, organizationEdit: { ...organizationEdit, message } };
  },
  // 団体情報削除失敗時の処理
  [deleteOrgFailure]: (state, action) => {
    const { organizationEdit } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }
    return { ...state, organizationEdit: { ...organizationEdit, message } };
  },
  // 団体情報登録失敗時の処理
  [registerOrgFailure]: (state, action) => {
    const { organizationEdit } = state;
    const { status, data } = action.payload;

    let message = data;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }

    return { ...state, organizationEdit: { ...organizationEdit, message } };
  },
  // 団体一覧初期化処理
  [initializeOrgList]: (state) => {
    const { organizationList } = initialState;
    return { ...state, organizationList };
  },
  // 団体一覧取得開始時の処理
  [getOrgListRequest]: (state, action) => {
    const { organizationList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, organizationList: { ...organizationList, conditions } };
  },
  // 団体一覧取得成功時の処理
  [getOrgListSuccess]: (state, action) => {
    const { organizationList } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, organizationList: { ...organizationList, searched, totalCount, data } };
  },
  // 団体ガイド一覧取得開始時の処理
  [getOrgGuideListRequest]: (state, action) => {
    const { organizationGuide } = state;
    // 検索条件を更新する
    const conditions = { ...initialState.organizationGuide.conditions, ...action.payload };
    return { ...state, organizationGuide: { ...organizationGuide, conditions } };
  },
  // 団体ガイド一覧取得成功時の処理
  [getOrgGuideListSuccess]: (state, action) => {
    const { organizationGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, organizationGuide: { ...organizationGuide, searched, totalCount, data } };
  },
  // 団体ガイド選択行要素取得成功時の処理
  [getOrgGuideValueSuccess]: (state, action) => {
    // 選択された要素を更新
    const { organizationGuide } = state;
    const selectedItem = action.payload;
    return { ...state, organizationGuide: { ...organizationGuide, selectedItem } };
  },
  // ガイドを開くアクション時の処理
  [openOrgGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { onSelected } = action.payload;
    const { organizationGuide } = initialState;
    return { ...state, organizationGuide: { ...organizationGuide, visible, onSelected } };
  },
  // ガイドを閉じるアクション時の処理
  [closeOrgGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { organizationGuide } = initialState;
    return { ...state, organizationGuide };
  },

  // 成績書オプション管理取得成功時の処理
  [getOrgRptSetOptionGuideSuccess]: (state, action) => {
    const { organizationRptOptionGuide } = state;
    // メッセージは初期化する
    const { messages } = organizationRptOptionGuide;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { orgrptoptrptv, orgrptoptrptd } = action.payload;
    return { ...state, organizationRptOptionGuide: { ...organizationRptOptionGuide, orgrptoptrptv, orgrptoptrptd, messages } };
  },
  // 成績書オプション管理取得失敗時の処理
  [getOrgRptSetOptionGuideFailure]: (state, action) => {
    const { organizationRptOptionGuide } = state;
    // メッセージ
    const { status, data } = action.payload;
    let messages = data.errors;
    if (!messages && status === 404) {
      messages = ['検索キーに該当するデータはありませんでした。'];
    }
    return { ...state, organizationRptOptionGuide: { ...organizationRptOptionGuide, messages } };
  },
  // 成績書オプション管理ガイド表示処理
  [openOrgRptSetOptionGuide]: (state, action) => {
    // 可視状態にする
    const visible = true;

    // 選択された要素を更新
    const { organizationRptOptionGuide } = state;
    const { conditions } = action.payload;
    return { ...state, organizationRptOptionGuide: { ...organizationRptOptionGuide, visible, conditions } };
  },
  // 成績書オプション管理情報登録成功時の処理
  [registerOrgRptOptSuccess]: (state) => {
    const { organizationRptOptionGuide } = state;
    const message = ['保存が完了しました。'];
    return { ...state, organizationRptOptionGuide: { ...organizationRptOptionGuide, message } };
  },
  // 成績書オプション管理情報登録失敗時の処理
  [registerOrgRptOptFailure]: (state, action) => {
    const { organizationRptOptionGuide } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の成績書オプション管理情報は存在しませんでした。'];
    }

    return { ...state, organizationRptOptionGuide: { ...organizationRptOptionGuide, message } };
  },
  // 成績書オプション管理ガイドを閉じる処理
  // 初期状態に戻すことでガイドを閉じる
  [closeOrgRptSetOptionGuide]: () => (
    initialState
  ),

  // アクション時の処理
  [setOrgTarget]: (state, action) => {
    // 選択された要素を更新
    const target = action.payload;
    return { ...state, target };
  },

  // 団体コードをキーに団体テーブルを読み込む成功時の処理
  [getOrgHeaderSuccess]: (state, action) => {
    const { organizationHeader } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const data = action.payload;
    return { ...state, organizationHeader: { ...organizationHeader, data } };
  },

  // 受診者数取得（団体別）成功時の処理
  [getSelDateOrgSuccess]: (state, action) => {
    const { selDateOrg } = state;
    // メッセージは初期化する
    const { messages } = selDateOrg;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    return { ...state, selDateOrg: { ...selDateOrg, data, messages } };
  },
  // 受診者数取得（団体別）失敗時の処理
  [getSelDateOrgFailure]: (state, action) => {
    const { selDateOrg } = state;
    // メッセージ
    const { data } = action.payload;
    const messages = data.errors;
    return { ...state, selDateOrg: { ...selDateOrg, messages } };
  },
}, initialState);
