import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  rslMainLoadRequest,
  rslMainLoadSuccess,
  rslMainShow,
  // 検査結果更新
  initializeResult,
  registerResultRequest,
  registerResultSuccess,
  registerResultFailure,
  registerEntryAutherRequest,
  registerEntryAutherSuccess,
  registerEntryAutherFailure,
  getEntryAutherSelectRadio,

  getProgressListRequest,
  getProgressListSuccess,
  getProgressListFailure,

  getProgressNameRequest,
  getProgressNameSuccess,
  getProgressNameFailure,
  loadingRequest,

  initializeProgressList,
  getUpdateResultAll,
  getUpdateResultAllSuccess,
  getUpdateResultAllFailure,
  getRslAllSetListRequest,
  getReloadResultListRequest,
  getRslAllSetListSuccess,
  getRslAllSetListFailure,
  getCheckResultThenSave,
  getMessageDataSuccess,
  updateResultListSuccess,
  openEntryAutherGuide,
  closeEntryAutherGuide,
  getHainsUserRequest,
  getHainsUserSuccess,
  getHainsUserFailure,
  getSentenceRequest,
  getSentenceSuccess,
  getSentenceFailure,
  rslDailyListLoad,
  rslDailyListLoadFailure,
  rslMainShowRequest,
  rslMenuCheckData,
  showArticleResult,
  updateResultForDetailRequest,
  updateResultForDetailSuccess,
  updateResultForDetailFailure,
  getConsultListRequest,
  getConsultListSuccess,
  getConsultListFailure,
  getCurRsvNoPrevNextRequest,
  getCurRsvNoPrevNextSuccess,
  getCurRsvNoPrevNextFailure,
  getConsultListCheckRequest,
  getConsultListCheckMessage,
  checkCondition,
  getConsultSetList,
  getReloadConsultSetList,
  getConsultSetListSuccess,
  updateRslListSet,
  getRslListSetList,
  getRslListSetListSuccess,
  getRslListSetListFailure,
  getUpdateRslListSetSuccess,
  getConsultSetListFailure,
  getRslAllSetValueFailure,
  getNaishikyouCheckSuccess,
  getNaishikyouCheckFailure,
  updateResultNoCmtRequest,
  updateResultNoCmtSuccess,
  updateResultNoCmtFailure,
  getCheckGFFailure,
  openNaishikyouCheckGuide,
  closeNaishikyouCheckGuide,
  getItemResultsSuccess,
  getResetRstItem,
  getGrpcdResult,
  getGrpcdResultSuccess,
  getGrpcdResultFailure,
  resetAllMessage,
  getDestroySetList,
  closeRslDetailGuide,
} = createActions(
  // 結果入力初期化
  'RSL_MAIN_LOAD_REQUEST',
  'RSL_MAIN_LOAD_SUCCESS',
  // 結果入力表示
  'RSL_MAIN_SHOW',
  // 検査結果更新
  'REGISTER_RESULT_REQUEST',
  'REGISTER_RESULT_SUCCESS',
  'REGISTER_RESULT_FAILURE',
  // 担当者登録
  'REGISTER_ENTRY_AUTHER_REQUEST',
  'REGISTER_ENTRY_AUTHER_SUCCESS',
  'REGISTER_ENTRY_AUTHER_FAILURE',
  'GET_ENTRY_AUTHER_SELECT_RADIO',

  'GET_PROGRESS_LIST_REQUEST',
  'GET_PROGRESS_LIST_SUCCESS',
  'GET_PROGRESS_LIST_FAILURE',

  'GET_PROGRESS_NAME_REQUEST',
  'GET_PROGRESS_NAME_SUCCESS',
  'GET_PROGRESS_NAME_FAILURE',
  'LOADING_REQUEST',

  'INITIALIZE_PROGRESS_LIST',
  'GET_UPDATE_RESULT_ALL',
  'GET_UPDATE_RESULT_ALL_SUCCESS',
  'GET_UPDATE_RESULT_ALL_FAILURE',
  'GET_RSL_ALL_SET_LIST_REQUEST',
  'GET_RELOAD_RESULT_LIST_REQUEST',
  'GET_RSL_ALL_SET_LIST_SUCCESS',
  'GET_RSL_ALL_SET_LIST_FAILUR',
  'GET_CHECK_RESULT_THEN_SAVE',
  'GET_MESSAGE_DATA_SUCCESS',
  'UPDATE_RESULT_LIST_SUCCESS',
  // 担当者分類チェック有無の確認
  'GET_ENTRY_AUTHER_SELECT_RADIO',
  // 担当者登録ガイド
  'OPEN_ENTRY_AUTHER_GUIDE',
  'CLOSE_ENTRY_AUTHER_GUIDE',
  'GET_HAINS_USER_REQUEST',
  'GET_HAINS_USER_SUCCESS',
  'GET_HAINS_USER_FAILURE',
  // 文章参照コード取得
  'GET_SENTENCE_REQUEST',
  'GET_SENTENCE_SUCCESS',
  'GET_SENTENCE_FAILURE',
  // 受診者一覧初期化
  'RSL_DAILY_LIST_LOAD',
  'RSL_DAILY_LIST_LOAD_FAILURE',
  // 結果入力表示
  'RSL_MAIN_SHOW_REQUEST',
  // 結果入力チェック
  'RSL_MENU_CHECK_DATA',
  // 結果入力詳細画面の文章結果を表示
  'SHOW_ARTICLE_RESULT',
  // 検査結果テーブルを更新
  'UPDATE_RESULT_FOR_DETAIL_REQUEST',
  'UPDATE_RESULT_FOR_DETAIL_SUCCESS',
  'UPDATE_RESULT_FOR_DETAIL_FAILURE',
  // 検索条件を満たす受診者の一覧を取得
  'GET_CONSULT_LIST_REQUEST',
  'GET_CONSULT_LIST_SUCCESS',
  'GET_CONSULT_LIST_FAILURE',
  // 検索予約番号の前後の予約番号および当日IDを取得
  'GET_CUR_RSV_NO_PREV_NEXT_REQUEST',
  'GET_CUR_RSV_NO_PREV_NEXT_SUCCESS',
  'GET_CUR_RSV_NO_PREV_NEXT_FAILURE',
  'GET_CONSULT_LIST_CHECK_REQUEST',
  'GET_CONSULT_LIST_CHECK_MESSAGE',
  // 一覧画面との条件差異チェック
  'CHECK_CONDITION',
  'GET_CONSULT_SET_LIST',
  'GET_RELOAD_CONSULT_SET_LIST',
  'GET_CONSULT_SET_LIST_SUCCESS',
  'UPDATE_RSL_LIST_SET',
  'GET_RSL_LIST_SET_LIST',
  'GET_RSL_LIST_SET_LIST_SUCCESS',
  'GET_RSL_LIST_SET_LIST_FAILURE',
  'GET_UPDATE_RSL_LIST_SET_SUCCESS',
  'GET_CONSULT_SET_LIST_FAILURE',
  'GET_RSL_ALL_SET_VALUE_FAILURE',
  // 内視鏡チェックリスト入力初期表示
  'GET_NAISHIKYOU_CHECK_SUCCESS',
  'GET_NAISHIKYOU_CHECK_FAILURE',
  // 検査結果テーブルを更新する(コメント更新なし)
  'UPDATE_RESULT_NO_CMT_REQUEST',
  'UPDATE_RESULT_NO_CMT_SUCCESS',
  'UPDATE_RESULT_NO_CMT_FAILURE',
  // 胃内視鏡の依頼があるかチェックする
  'GET_CHECK_G_F_FAILURE',
  // 内視鏡チェックリスト入力ガイド
  'OPEN_NAISHIKYOU_CHECK_GUIDE',
  'CLOSE_NAISHIKYOU_CHECK_GUIDE',
  'GET_ITEM_RESULTS_SUCCESS',
  'GET_RESET_RST_ITEM',
  'GET_GRPCD_RESULT',
  'GET_GRPCD_RESULT_SUCCESS',
  'GET_GRPCD_RESULT_FAILURE',
  'RESET_ALL_MESSAGE',
  'GET_DESTROY_SET_LIST',
  'CLOSE_RSL_DETAIL_GUIDE',
);

// stateの初期値
const initialState = {
  rslMenu: {
    csldate: null,
    cscd: null,
    sortkey: null,
    dayid: null,
    cntlno: null,
    sortkeyitems: [],
    message: [],
    isLoading: false,
    cntlnoflg: null,
  },
  resultEdit: {
    message: [],
  },

  entryAutherList: {
    message: [],
    visible: false,
    hainsUserData: {},
    flagMen: 0,
    flagJud: 0,
    flagKan: 0,
    flagEif: 0,
    flagShi: 0,
    flagNai: 0,
    flagCheck: 0,
    docindex: '',
    checkValue: [],
  },
  progressList: {
    conditions: {
      getCount: 20,
      cslDate: moment().format('YYYY/M/D'),
      rsvNo: '',
      startPos: 1,
    },
    onsearch: false,
    isLoading: false,
    progressName: [],
    totalcount: 0,
    data: [],
    strRslStatus: [],
    strMessage: '',
    message1: '',
    message2: '',
    lngErrLog1: 0,
    fileName1: '',
    errDate: '',
  },
  rslDailyList: {
    data: null,
    lastInfo: '',
    codename: null,
    mode: null,
    rslListData: null,
    curRsvNoPrevNext: null,
    totalCount: 0,
    conditions: {
      cscd: null,
      sortkey: null,
      dayid: null,
      cntlno: null,
      csldate: null,
      noprevnext: null,
      page: 1,
      limit: 20,
    },
  },

  itemList: {
    resultData: [],
    message: [],
    errorBack: false,
    selectPerson: [],
    saveItemData: [],
    errorMessage: [],
    isLoadTwo: false,
    stepRender: false,
    step1grpcd: 'G010',
  },

  rslMain: {
    isLoading: false,
    dismode: false,
    totalCount: 0,
    conditions: {
      cscd: null,
      sortkey: null,
      dayid: null,
      cntlNo: null,
      csldate: null,
    },
  },

  rslDetail: {
    resultFlg: true,
    headerRefresh: false,
    code: null,
    message: [],
    resulterror: [],
    rslcmterror1: [],
    rslcmterror2: [],
    prevrsvno: null,
    nextrsvno: null,
    workstation: null,
  },
  rslDetailGuide: {
    visible: false,
  },

  // 来院済み受診者
  rslListSet: {
    isLoading: false,
    resultData: [],
    title: [],
    cslDate: null,
    dayIdF: null,
    getCount: null,
    sortKey: null,
    grpcd: null,
    newDate: null,
    count: null,
    listErr: false,
    message: [],
    flagBoo: false,
  },

  // 内視鏡チェックリスト入力
  naishikyouCheckGuide: {
    message: [],
    visible: false, // 可視状態
    rsvno: null, // 予約番号
    consultdata: {}, // 受診情報
    historyrsldata: [], // 受診者の検査結果
    realage: null, // 実年齢
    checkitems: {},
  },
};

// reducerの作成
export default handleActions({
  // 結果入力の初期化
  [rslMainLoadSuccess]: (state, action) => {
    // 可視状態をtrueにする
    const { rslMenu, rslDailyList, rslMain, rslDetail } = initialState;
    const { sortkeyitems, cntlnoflg } = action.payload;
    const csldate = moment().format('YYYY/MM/DD');
    return { ...state, rslDailyList, rslMain, rslDetail, rslMenu: { ...rslMenu, csldate, sortkeyitems, cntlnoflg } };
  },
  // 検査結果の初期化
  [initializeResult]: (state) => {
    const { resultEdit } = initialState;
    return { ...state, resultEdit };
  },
  // 検査結果更新成功時の処理
  [registerResultSuccess]: (state) => {
    const { resultEdit } = state;
    const message = ['保存が完了しました。'];
    return { ...state, resultEdit: { ...resultEdit, message } };
  },
  // 検査結果更新失敗時の処理
  [registerResultFailure]: (state, action) => {
    const { resultEdit } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }

    return { ...state, resultEdit: { ...resultEdit, message } };
  },
  // 内視鏡医フラグ取得成功時の処理
  [getHainsUserSuccess]: (state, action) => {
    const { entryAutherList } = state;
    const hainsUserData = action.payload;
    return { ...state, entryAutherList: { ...entryAutherList, hainsUserData } };
  },
  // 文章参照コード取得成功時の処理
  [getSentenceSuccess]: (state, action) => {
    const { entryAutherList } = state;
    const { flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue, docindex } = action.payload;
    return { ...state, entryAutherList: { ...entryAutherList, flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue, docindex } };
  },
  // 担当者分類チェック有無の確認、チェックされていないとエラーメッセージ表示
  [getEntryAutherSelectRadio]: (state) => {
    const { entryAutherList } = state;
    const message = ['該当する【　担当者区分　】を選択してください。'];
    return { ...state, entryAutherList: { ...entryAutherList, message } };
  },
  // 担当者登録成功時の処理
  [registerEntryAutherSuccess]: (state) => {
    const { entryAutherList } = state;
    const visible = false;
    return { ...state, entryAutherList: { ...entryAutherList, visible } };
  },
  // 担当者登録失敗時の処理
  [registerEntryAutherFailure]: (state, action) => {
    const { entryAutherList } = state;
    const { data } = action.payload;
    let message = '';
    if (data !== '') {
      message = data;
      message.push('担当者の登録ができませんでした。');
    }
    return { ...state, entryAutherList: { ...entryAutherList, message } };
  },
  // 検索条件を満たすレコード件数を取得
  [getProgressListRequest]: (state, action) => {
    const { progressList } = state;
    const conditions = { ...initialState.progressList.conditions, ...action.payload };
    return { ...state, progressList: { ...progressList, isLoading: true, conditions } };
  },
  // 検索条件を満たすレコード件数を取得成功時の処理
  [getProgressListSuccess]: (state, action) => {
    const { progressList } = state;
    const { data, totalcount, strRslStatus, strMessage, message1, message2, lngErrLog1, fileName1, errDate } = action.payload;
    return { ...state, progressList: { ...progressList, data, totalcount, strRslStatus, strMessage, isLoading: false, message1, message2, lngErrLog1, fileName1, errDate, onsearch: true } };
  },
  // 検索条件を満たすレコード件数を取得失敗時の処理
  [getProgressListFailure]: (state) => {
    const { progressList } = state;
    let strMessage = '指定された予約番号の受診情報は存在しません。';
    let onsearch = false;
    if (!progressList.conditions.rsvNo) {
      onsearch = true;
      strMessage = '';
    }
    return { ...state, progressList: { ...progressList, strMessage, onsearch, totalcount: 0, data: [], isLoading: false } };
  },
  // 全ての進捗分類情報を取得
  [getProgressNameRequest]: (state) => {
    const { progressList } = state;
    return { ...state, progressList: { ...progressList } };
  },
  // 全ての進捗分類情報を取得成功時の処理
  [getProgressNameSuccess]: (state, action) => {
    const { progressList } = state;
    const data = action.payload;
    return { ...state, progressList: { ...progressList, progressName: data } };
  },
  // 全ての進捗分類情報を取得成失敗の処理
  [getProgressNameFailure]: (state) => {
    const { progressList } = state;
    const strMessage = '進捗分類情報が存在しません。';
    return { ...state, progressList: { ...progressList, strMessage } };
  },
  [loadingRequest]: (state) => {
    const { progressList } = state;
    return { ...state, progressList: { ...progressList, isLoading: true } };
  },
  [initializeProgressList]: (state) => {
    const { progressList } = initialState;
    return { ...state, progressList };
  },

  // 担当者登録ガイドを開くアクション時の処理
  [openEntryAutherGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { entryAutherList } = initialState;
    return { ...state, entryAutherList: { ...entryAutherList, visible } };
  },
  // 担当者登録ガイドを閉じるアクション時の処理
  [closeEntryAutherGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { entryAutherList } = initialState;
    return { ...state, entryAutherList };
  },

  // 検査結果一括請求する
  [getUpdateResultAll]: (state) => {
    const { itemList } = initialState;
    return { ...state, itemList: { ...itemList, isLoadTwo: true } };
  },

  // 検査結果一括更新成功
  [getUpdateResultAllSuccess]: (state, action) => {
    const { itemList } = initialState;
    const message = ['保存が完了しました。'];
    const selectPerson = action.payload;
    return { ...state, itemList: { ...itemList, message, selectPerson, isLoadTwo: false } };
  },

  // 検査結果一括更新成功
  [getItemResultsSuccess]: (state, action) => {
    const { itemList } = state;
    const message = action.payload;
    return { ...state, itemList: { ...itemList, isLoadTwo: false, message } };
  },

  // 指定対象受診者・検査グループの検査項目を取得成功
  [getRslAllSetListSuccess]: (state, action) => {
    const { itemList } = state;
    const arr = action.payload;
    const saveItemData = {};
    const message = [];
    saveItemData.saveItemData = arr;
    return { ...state, itemList: { ...itemList, message, saveItemData, isLoadTwo: false } };
  },

  // 指定対象受診者・検査グループの検査項目
  [getRslAllSetListRequest]: (state) => {
    const { itemList } = initialState;
    return { ...state, itemList: { ...itemList, isLoadTwo: true } };
  },

  // 指定対象受診者・検査グループの検査項目を取得失败
  [getRslAllSetListFailure]: (state) => {
    const { itemList } = initialState;
    const message = ['保存失败しませんでした。'];
    return { ...state, itemList: { ...itemList, message, isLoadTwo: false } };
  },

  // 検査結果一括更新失败
  [getUpdateResultAllFailure]: (state) => {
    const { itemList } = initialState;
    const errorBack = true;
    return { ...state, itemList: { ...itemList, errorBack, isLoadTwo: false } };
  },
  // 指定対象受診者・検査グループの検査項目を取得成功
  [getMessageDataSuccess]: (state, action) => {
    const { saveItemData, messageData } = action.payload;
    const { itemList } = initialState;
    const message = messageData.messages;
    return { ...state, itemList: { ...itemList, saveItemData: { saveItemData }, message } };
  },
  // 検査結果一括更新成功
  [updateResultListSuccess]: (state) => {
    const { itemList } = state;
    const message = ['保存が完了しました。'];
    return { ...state, itemList: { ...itemList, message } };
  },
  // 結果入力の表示
  [rslDailyListLoad]: (state, action) => {
    const { rslMain, rslDailyList, rslDetail, rslMenu } = state;
    const { conditions } = rslDailyList;
    const { consultList, rslListData, curRsvNoPrevNext, lastInfo, getData, workstation, codename, params } = action.payload;
    const { code } = params;
    const mode = params.dismode;
    let prevrsvno = null;
    let nextrsvno = null;
    let dismode = mode;
    if (mode === undefined) {
      const copydismode = rslMain.dismode;
      dismode = copydismode;
    }
    if (getData !== undefined) {
      ({ prevrsvno } = getData);
      ({ nextrsvno } = getData);
    }

    if (consultList !== undefined && consultList !== '') {
      const { page, limit } = conditions;
      const { csldate, cscd, sortkey, dayid, cntlno } = action.payload.params;
      const { data, totalCount } = consultList;
      return {
        ...state,
        rslMain: {
          ...rslMain,
          isLoading: false,
          conditions: {
            ...conditions,
            csldate,
            cscd,
            sortkey,
            dayid,
            cntlno,
            limit,
            page,
          },
        },
        rslDailyList: {
          ...rslDailyList,
          data,
          totalCount,
          rslListData,
          curRsvNoPrevNext,
          lastInfo,
          codename,
          mode: params.mode,
        },
        rslDetail: {
          ...rslDetail,
          prevrsvno,
          nextrsvno,
          workstation,
          headerRefresh: false,
        },
        rslMenu: {
          ...rslMenu,
          isLoading: false,
          dismode,
        },
      };
    }
    return {
      ...state,
      rslDailyList: {
        ...rslDailyList,
        rslListData,
        curRsvNoPrevNext,
        lastInfo,
        codename,
        mode: params.mode,
      },
      rslDetail: {
        ...rslDetail,
        prevrsvno,
        nextrsvno,
        workstation,
        code,
      },
      rslDetailGuide: {
        visible: true,
      },
      rslMain: {
        ...rslMain,
        isLoading: false,
        dismode,
      },
    };
  },

  // 結果入力チェック
  [rslMenuCheckData]: (state, action) => {
    const { rslMenu } = state;
    const message = action.payload;
    const isLoading = false;
    return {
      ...state, rslMenu: { ...rslMenu, message, isLoading },
    };
  },

  [showArticleResult]: (state) => {
    const { rslDetail } = state;
    const resultFlg = !rslDetail.resultFlg;
    return {
      ...state, rslDetail: { ...rslDetail, resultFlg },
    };
  },

  // 検査結果テーブルを更新成功時の処理
  [updateResultForDetailSuccess]: (state, action) => {
    // 可視状態をtrueにする
    const { rslDetail, rslDailyList } = state;
    const message = ['保存が完了しました。'];
    const { formData } = action.payload;
    const rslListData = { item: formData };

    return {
      ...state,
      rslDetail: { ...rslDetail, message, resulterror: [], rslcmterror1: [], rslcmterror2: [], headerRefresh: true },
      rslDailyList: { ...rslDailyList, rslListData },
    };
  },
  // 検査結果テーブルを更新失敗時の処理
  [updateResultForDetailFailure]: (state, action) => {
    const { rslDetail, rslDailyList } = state;
    const { resulterror, rslcmterror1, rslcmterror2, message } = action.payload.error.response.data;
    const { formData } = action.payload;

    const rslListData = { item: formData };
    return {
      ...state,
      rslDailyList: { ...rslDailyList, rslListData },
      rslDetail: { ...rslDetail, message, resulterror, rslcmterror1, rslcmterror2 },
    };
  },

  // 受診者一覧取得成功時の処理
  [getConsultListSuccess]: (state, action) => {
    const { rslDailyList, rslMain } = state;
    // (これに伴い一覧が再描画される)
    const { data, totalCount, conditions } = action.payload;
    return {
      ...state, rslMain: { ...rslMain, conditions }, rslDailyList: { ...rslDailyList, data, totalCount } };
  },

  [getConsultListCheckMessage]: (state, action) => {
    const { errorMessage } = action.payload;
    const { itemList } = initialState;
    return { ...state, itemList: { ...itemList, errorMessage } };
  },

  // 一覧画面との条件差異チェック
  [checkCondition]: (state, action) => {
    const { rslDetail, rslMain } = state;
    const message = action.payload;
    return { ...state, rslDetail: { ...rslDetail, message }, rslMain: { ...rslMain, isLoading: false } };
  },

  [getCurRsvNoPrevNextSuccess]: (state, action) => {
    const { rslDailyList, rslDetail, rslMain } = state;
    const { rslListData, curRsvNoPrevNext, lastInfo, getData } = action.payload;
    const { code } = action.payload.params;
    let prevrsvno = null;
    let nextrsvno = null;

    if (getData !== undefined) {
      ({ prevrsvno } = getData);
      ({ nextrsvno } = getData);
    }

    return {
      ...state,
      rslDailyList: {
        ...rslDailyList,
        rslListData,
        curRsvNoPrevNext,
        lastInfo,
      },
      rslDetail: {
        ...rslDetail,
        prevrsvno,
        nextrsvno,
        code,
      },
      rslMain: { ...rslMain, isLoading: false },
    };
  },
  // isLoading
  [rslMainShowRequest]: (state) => {
    const { rslMenu, rslMain, rslDailyList } = state;
    const rslListData = { item: [] };
    return {
      ...state, rslMenu: { ...rslMenu, isLoading: true }, rslMain: { ...rslMain, isLoading: true }, rslDailyList: { ...rslDailyList, rslListData } };
  },
  // 結果入力の表示失敗時の処理
  [rslDailyListLoadFailure]: (state) => {
    const { rslMenu } = state;
    const message = ['受診情報が存在しません。'];
    const isLoading = false;
    return { ...state, rslMenu: { ...rslMenu, isLoading, message } };
  },
  // isLoading
  [getCurRsvNoPrevNextRequest]: (state) => {
    const { rslMain } = state;
    return { ...state, rslMain: { ...rslMain, isLoading: true } };
  },

  // ワークシート形式の結果入力
  [getConsultSetList]: (state, action) => {
    const { cslDate, dayIdF, getCount, sortKey, grpcd, isKey, isData } = action.payload;
    const { rslListSet } = state;
    if (isKey && isData) {
      return { ...state, rslListSet: { ...rslListSet, isLoading: true, cslDate, sortKey, grpcd, getCount, dayIdF, page: 0, cruPage: 10 } };
    }
    if (isKey && !isData) {
      return { ...state, rslListSet: { ...rslListSet, isLoading: true, cslDate, sortKey, grpcd, getCount, dayIdF, page: 0, cruPage: 0 } };
    }
    return { ...state, rslListSet: { ...rslListSet, isLoading: true, cslDate, sortKey, grpcd, getCount, dayIdF, page: 1000 } };
  },

  // ワークシート形式の結果入力
  [getReloadConsultSetList]: (state, action) => {
    const { cslDate, dayIdF, getCount, sortKey, grpcd, resultData } = action.payload;
    const { rslListSet } = state;
    return { ...state, rslListSet: { ...rslListSet, isLoading: true, cslDate, sortKey, grpcd, getCount, resultData, dayIdF } };
  },

  // 来院済み受診者成功時の処理
  [getConsultSetListSuccess]: (state, action) => {
    const { rslListSet } = state;
    const { title, cslDate, dayIdF, getCount, sortKey, grpcd, newDate, count, cruPage, page, data, message, flagBoo } = action.payload;
    return {
      ...state,
      rslListSet:
        { ...rslListSet, resultData: data, count, title, cslDate, dayIdF, getCount, sortKey, grpcd, newDate, isLoading: false, listErr: false, message, cruPage, page, flagBoo },
    };
  },
  // 更新来院済み受診者成功時の処理
  [updateRslListSet]: (state, action) => {
    const { rslListSet } = state;
    const { resultData } = action.payload;
    return { ...state, rslListSet: { ...rslListSet, resultData, isLoading: true } };
  },

  // 更新来院済み受診者
  [getRslListSetListSuccess]: (state, action) => {
    const { rslListSet } = initialState;
    const { grpcd } = action.payload;
    return { ...state, rslListSet: { ...rslListSet, grpcd } };
  },

  // エンドip取得に失敗
  [getRslListSetListFailure]: (state) => {
    const { rslListSet } = state;
    const strMessage = 'エンドip取得に失敗';
    return { ...state, rslListSet: { ...rslListSet, message: strMessage } };
  },

  // 来院済み受診者失败時の処理
  [getConsultSetListFailure]: (state, action) => {
    const { rslListSet } = state;
    const { cslDate, dayIdF, getCount, sortKey, grpcd } = action.payload;
    return { ...state, rslListSet: { ...rslListSet, isLoading: false, listErr: true, resultData: [], cslDate, dayIdF, getCount, sortKey, grpcd } };
  },
  // 更新来院済み受診者失败時の処理
  [getUpdateRslListSetSuccess]: (state, action) => {
    const { rslListSet } = state;
    const { title, cslDate, dayIdF, getCount, sortKey, grpcd, newDate, message, count, data } = action.payload;
    const resultData = data.slice();
    return { ...state, rslListSet: { ...rslListSet, resultData, count, title, cslDate, dayIdF, getCount, sortKey, grpcd, newDate, message, isLoading: false, listErr: false } };
  },
  // 検査に失敗する
  [getRslAllSetValueFailure]: (state, action) => {
    const { cslDate, grpcd, dayIdF, message } = action.payload;
    const { rslListSet } = state;
    return { ...state, rslListSet: { ...rslListSet, cslDate, grpcd, dayIdF, message, isLoading: false } };
  },

  // 内視鏡チェックリスト入力ガイド初期表示情報を取得成功時の処理
  [getNaishikyouCheckSuccess]: (state, action) => {
    const { naishikyouCheckGuide } = state;
    // 総件数とデータとを更新する
    const { consultdata, realage, historyrsldata, checkitems, rsvno } = action.payload;
    return { ...state, naishikyouCheckGuide: { ...naishikyouCheckGuide, consultdata, realage, historyrsldata, checkitems, rsvno } };
  },
  // 内視鏡チェックリスト入力ガイド初期表示情報を取得失敗時の処理
  [getNaishikyouCheckFailure]: (state) => {
    const { naishikyouCheckGuide, message } = state;
    return { ...state, naishikyouCheckGuide: { ...naishikyouCheckGuide, message } };
  },
  // 検査結果テーブルを更新(コメント更新なし)保存成功時の処理
  [updateResultNoCmtSuccess]: (state) => {
    const { naishikyouCheckGuide } = state;
    const message = ['保存が完了しました。'];
    return { ...state, naishikyouCheckGuide: { ...naishikyouCheckGuide, message } };
  },
  // 内視鏡チェックリストの状態取得失敗時の処理
  [getCheckGFFailure]: (state, action) => {
    const { naishikyouCheckGuide } = state;
    const { message } = naishikyouCheckGuide;
    const { data } = action.payload;
    const msg = message.slice(0);
    msg.push(data);
    return {
      ...state, naishikyouCheckGuide: { ...naishikyouCheckGuide, message: msg } };
  },
  // 内視鏡チェックリスト入力ガイドを開くアクション時の処理
  [openNaishikyouCheckGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { naishikyouCheckGuide } = initialState;
    return { ...state, naishikyouCheckGuide: { ...naishikyouCheckGuide, visible } };
  },
  // 内視鏡チェックリスト入力ガイドを閉じるアクション時の処理
  [closeNaishikyouCheckGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { naishikyouCheckGuide } = initialState;
    return { ...state, naishikyouCheckGuide };
  },

  // ページの値をポップアップする
  [getResetRstItem]: (state, action) => {
    const { itemList } = state;
    const { itemRestList, num, index, stcCd, shortStc, stepRender } = action.payload;
    const boo = !stepRender;
    if (itemRestList.saveItemData.length > 0) {
      itemRestList.saveItemData[num].infoResult[index].shortstc = shortStc;
      itemRestList.saveItemData[num].infoResult[index].result = stcCd;
    }
    return { ...state, itemList: { ...itemList, saveItemData: itemRestList, stepRender: boo } };
  },

  // エンドip取得に成功
  [getGrpcdResultSuccess]: (state, action) => {
    const { itemList } = state;
    const { grpcd } = action.payload;
    return { ...state, itemList: { ...itemList, step1grpcd: grpcd, message: [] } };
  },

  // エンドip取得に失敗
  [getGrpcdResultFailure]: (state) => {
    const { itemList } = state;
    const strMessage = 'エンドip取得に失敗';
    return { ...state, itemList: { ...itemList, message: strMessage } };
  },

  // クリア可能なエラーヒント
  [resetAllMessage]: (state) => {
    const { itemList } = state;
    return { ...state, itemList: { ...itemList, message: [] } };
  },
  // 部品を廃棄する
  [getDestroySetList]: (state) => {
    const { rslListSet } = initialState;
    return { ...state, rslListSet };
  },
  [closeRslDetailGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { rslDetailGuide } = initialState;
    return { ...state, rslDetailGuide };
  },
}, initialState);
