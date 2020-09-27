import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  openPersonGuide,
  closePersonGuide,
  getPersonGuideListRequest,
  getPersonGuideListSuccess,
  getPersonGuideListFailure,
  getPersonGuideRequest,
  getPersonGuideSuccess,
  getPersonGuideFailure,
  getPersonListRequest,
  getPersonListSuccess,
  getPersonListFailure,
  getPersonRequest,
  getPersonSuccess,
  getPersonFailure,
  setPersonOrgTargetRequest,
  getFreeRequest,
  getFreeRequestSuccess,
  getFreeRequestFailure,
  initializePerson,
  initializePersonIns,
  initializePersonList,
  registerPersonRequest,
  registerPersonSuccess,
  registerPersonFailure,
  deletePersonRequest,
  deletePersonSuccess,
  deletePersonFailure,
  getPerInspectionRequest,
  getPerInspectionSuccess,
  getPerInspectionFailure,
  getPerInspectionListRequest,
  getPerInspectionListSuccess,
  getPerInspectionListFailure,
  registerPerInspectionRequest,
  registerPerInspectionSuccess,
  registerPerInspectionFailure,
  savePerInspectionIndex,
  refreshPerInspectionSentence,
} = createActions(
  // ガイド用
  'OPEN_PERSON_GUIDE',
  'CLOSE_PERSON_GUIDE',
  'GET_PERSON_GUIDE_LIST_REQUEST',
  'GET_PERSON_GUIDE_LIST_SUCCESS',
  'GET_PERSON_GUIDE_LIST_FAILURE',
  'GET_PERSON_GUIDE_REQUEST',
  'GET_PERSON_GUIDE_SUCCESS',
  'GET_PERSON_GUIDE_FAILURE',
  // 個人一覧取得
  'GET_PERSON_LIST_REQUEST',
  'GET_PERSON_LIST_SUCCESS',
  'GET_PERSON_LIST_FAILURE',
  // 個人情報取得
  'GET_PERSON_REQUEST',
  'GET_PERSON_SUCCESS',
  'GET_PERSON_FAILURE',
  'SET_PERSON_ORG_TARGET_REQUEST',
  // 汎用情報取得
  'GET_FREE_REQUEST',
  'GET_FREE_REQUEST_SUCCESS',
  'GET_FREE_REQUEST_FAILURE',
  // 初期化
  'INITIALIZE_PERSON',
  'INITIALIZE_PERSON_LIST',
  'INITIALIZE_PERSON_INS',
  'OPEN_ORG_GUIDE',
  'CLOSE_ORG_GUIDE',
  // 個人情報登録
  'REGISTER_PERSON_REQUEST',
  'REGISTER_PERSON_SUCCESS',
  'REGISTER_PERSON_FAILURE',
  // 個人情報削除
  'DELETE_PERSON_REQUEST',
  'DELETE_PERSON_SUCCESS',
  'DELETE_PERSON_FAILURE',
  // 指定個人IDの個人情報取得（簡易版）
  'GET_PER_INSPECTION_REQUEST',
  'GET_PER_INSPECTION_SUCCESS',
  'GET_PER_INSPECTION_FAILURE',
  // 個人検査項目情報
  'GET_PER_INSPECTION_LIST_REQUEST',
  'GET_PER_INSPECTION_LIST_SUCCESS',
  'GET_PER_INSPECTION_LIST_FAILURE',
  // 個人検査結果テーブル登録
  'REGISTER_PER_INSPECTION_REQUEST',
  'REGISTER_PER_INSPECTION_SUCCESS',
  'REGISTER_PER_INSPECTION_FAILURE',
  // 個人検査結果ガイドガイド選択されたインデックス
  'SAVE_PER_INSPECTION_INDEX',
  // 個人検査結果文章ガイド情報のセット
  'REFRESH_PER_INSPECTION_SENTENCE',
);

// stateの初期値
const initialState = {
  personList: {
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

  personEdit: {
    message: [],
  },

  personGuide: {
    visible: false, // 可視状態
    conditions: {
      keyword: '',
      page: 1,
      limit: 20,
    }, // 検索条件
    searched: false,
    totalcount: 0,
    data: [],
    selectedItem: undefined, // 選択された要素
    onSelected: undefined, // 選択後の処理
  },

  freeList: {
    freeValues: [],
  },

  // 個人検査情報メンテナンス
  perInspection: {
    message: [],
    personInfo: {},
    perResultList: {
      perresultitem: [],
      allcount: 0,
    },
    selectedItemIndex: 0,
    selectedItemField: '',
    renderFlag: 0,
  },

};

// reducerの作成
export default handleActions({
  // ガイドを開くアクション時の処理
  [openPersonGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { onSelected } = action.payload;
    const { personGuide } = initialState;
    return { ...state, personGuide: { ...personGuide, visible, onSelected } };
  },
  // 個人一覧取得開始時の処理
  [getPersonGuideListRequest]: (state, action) => {
    // 検索条件を更新する
    const { personGuide } = state;
    const conditions = action.payload;
    return { ...state, personGuide: { ...personGuide, conditions } };
  },
  // 個人一覧取得成功時の処理
  [getPersonGuideListSuccess]: (state, action) => {
    const { personGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, personGuide: { ...personGuide, searched, totalcount: totalCount, data } };
  },
  // 個人取得成功時の処理
  [getPersonGuideSuccess]: (state, action) => {
    // 選択された要素を更新
    const { personGuide } = state;
    const selectedItem = action.payload;
    return { ...state, personGuide: { ...personGuide, selectedItem } };
  },
  // 閉じるアクション時の処理
  [closePersonGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { personGuide } = initialState;
    return { ...state, personGuide };
  },

  // 個人メンテナンス画面の初期化
  [initializePerson]: (state) => {
    const { personEdit } = initialState;
    return { ...state, personEdit };
  },

  // 個人検査情報メンテナンス画面の初期化
  [initializePersonIns]: (state) => {
    const { perInspection } = initialState;
    return { ...state, perInspection };
  },

  // 個人情報取得失敗時の処理
  [getPersonFailure]: (state) => {
    const { personEdit } = state;
    return { ...state, personEdit: { ...personEdit, personEdit } };
  },

  // 個人一覧初期化処理
  [initializePersonList]: (state) => {
    const { personList } = initialState;
    return { ...state, personList };
  },

  // 個人一覧取得開始時の処理
  [getPersonListRequest]: (state, action) => {
    const { personList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, personList: { ...personList, conditions } };
  },

  // 個人一覧取得成功時の処理
  [getPersonListSuccess]: (state, action) => {
    const { personList } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, personList: { ...personList, searched, totalCount, data } };
  },

  // 個人情報登録開始時の処理
  [registerPersonRequest]: (state) => {
    const { personEdit } = state;
    const message = [];
    return { ...state, personEdit: { ...personEdit, message } };
  },

  // 個人情報登録成功時の処理
  [registerPersonSuccess]: (state) => {
    const { personEdit } = state;
    const message = ['保存が完了しました。'];
    return { ...state, personEdit: { ...personEdit, message } };
  },

  // 個人情報登録失敗時の処理
  [registerPersonFailure]: (state, action) => {
    const { personEdit } = state;
    const message = action.payload.data;
    return { ...state, personEdit: { ...personEdit, message } };
  },

  // 個人情報削除成功時の処理
  [deletePersonSuccess]: (state) => {
    const { personEdit } = state;
    const message = ['削除が完了しました。'];
    return { ...state, personEdit: { ...personEdit, message } };
  },
  // 個人情報削除失敗時の処理
  [deletePersonFailure]: (state, action) => {
    const { personEdit } = state;
    let message = action.payload.data;
    message = [message];

    return { ...state, personEdit: { ...personEdit, message } };
  },

  // 汎用情報取得成功時の処理
  [getFreeRequestSuccess]: (state, action) => {
    const { freeList } = state;
    const data = action.payload;
    return {
      ...state, freeList: { ...freeList, freeValues: data },
    };
  },


  // 指定個人IDの個人情報取得（簡易版）開始時の処理
  [getPerInspectionRequest]: (state, action) => {
    const { data } = action.payload;
    return { ...state, data };
  },


  // 指定個人IDの個人情報取得（簡易版）成功時の処理
  [getPerInspectionSuccess]: (state, action) => {
    const { perInspection } = state;
    const { data } = action.payload;
    return { ...state, perInspection: { ...perInspection, personInfo: data } };
  },


  // 個人検査項目情報取得成功時の処理
  [getPerInspectionListSuccess]: (state, action) => {
    const { perInspection } = state;
    const { data } = action.payload;
    return { ...state, perInspection: { ...perInspection, perResultList: data } };
  },

  // 個人検査項目情報取得失敗時の処理
  [getPerInspectionListFailure]: (state, action) => {
    const { perInspection } = state;
    const { status } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['個人検査情報は存在しません。'];
    }
    return { ...state, perInspection: { ...perInspection, message } };
  },

  // 個人検査結果テーブル登録成功時の処理
  [registerPerInspectionSuccess]: (state) => {
    const { perInspection } = state;
    const message = ['保存が完了しました。'];
    return { ...state, perInspection: { ...perInspection, message } };
  },

  // 個人検査結果文章ガイド情報選択
  [savePerInspectionIndex]: (state, action) => {
    const { perInspection } = state;
    const { selectedItemIndex, selectedItemField } = action.payload;
    return { ...state, perInspection: { ...perInspection, selectedItemIndex, selectedItemField } };
  },

  // 個人検査結果文章ガイド情報のセット
  [refreshPerInspectionSentence]: (state) => {
    const { perInspection } = state;
    let { renderFlag } = perInspection;
    renderFlag += 1;
    return { ...state, perInspection: { ...perInspection, renderFlag } };
  },
  // 団体ガイドの結果をセットするフィールド名
  [setPersonOrgTargetRequest]: (state, action) => {
    const { personEdit } = state;
    const orgGuideTargets = action.payload;
    return { ...state, personEdit: { ...personEdit, orgGuideTargets } };
  },
}, initialState);

