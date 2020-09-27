import { createActions, handleActions, combineActions } from 'redux-actions';
import moment from 'moment';

const INCREASE_COUNT = 5;

// actionの作成
export const {
  openConsultListGuide,
  closeConsultListGuide,
  getConsultListGuideRequest,
  getConsultListGuideSuccess,
  getConsultListGuideFailure,
  getConsultGuideRequest,
  getConsultGuideSuccess,
  getConsultGuideFailure,
  initializeConsult,
  setMessages,
  openReserveMainRequest,
  openReserveMainSuccess,
  openReserveMainFailure,
  selectReserveMainPersonRequest,
  selectReserveMainPersonSuccess,
  selectReserveMainPersonFailure,
  getConsultRequest,
  getConsultSuccess,
  getConsultFailure,
  openRptAllEntryGuide,
  closeRptAllEntryGuide,
  initializeRptAllEntryGuide,
  receiptAllRequest,
  receiptAllSuccess,
  receiptAllFailure,
  cancelReceiptAllRequest,
  cancelReceiptAllSuccess,
  cancelReceiptAllFailure,
  receiptCheck,
  calcAgeRequest,
  calcAgeSuccess,
  calcAgeFailure,
  registerConsultRequest,
  registerConsultSuccess,
  registerConsultFailure,
  initDailyListParams,
  setDailyListParams,
  setDailyListMessage,
  getDailyListRequest,
  getDailyListSuccess,
  getDailyListFailure,
  loadPreparationInfoRequest,
  loadPreparationInfoSuccess,
  loadPreparationInfoFailure,
  mergePerResultRequest,
  mergePerResultSuccess,
  mergePerResultFailure,
  deletePerResultRequest,
  deletePerResultSuccess,
  deletePerResultFailure,
  openEditWelComeInfoGuide,
  closeEditWelComeInfoGuide,
  updateWelComeInfoRequest,
  updateWelComeInfoSuccess,
  updateWelComeInfoFailure,
  getWelComeInfoRequest,
  getWelComeInfoSuccess,
  getWelComeInfoFailure,
  registerWelComeInfoRequest,
  registerWelComeInfoFailure,
  openReceiptFrontDoorGuide,
  closeReceiptFrontDoorGuide,
  getConsultListItemRequest,
  getConsultListItemSuccess,
  getConsultListItemFailure,
  getConsultStepList,
  getConsultListCheckFailure,
  loadPeceiptMainInfo,
  loadPeceiptMainSuccess,
  loadPeceiptMainFailure,
  openReceiptMainGuide,
  closeReceiptMainGuide,
  closeWelComeInfoMenuGuide,
  openWelComeInfoMenuGuide,
  loadReceiptFrontDoorInfo,
} = createActions(
  'OPEN_CONSULT_LIST_GUIDE',
  'CLOSE_CONSULT_LIST_GUIDE',
  'GET_CONSULT_LIST_GUIDE_REQUEST',
  'GET_CONSULT_LIST_GUIDE_SUCCESS',
  'GET_CONSULT_LIST_GUIDE_FAILURE',
  'GET_CONSULT_GUIDE_REQUEST',
  'GET_CONSULT_GUIDE_SUCCESS',
  'GET_CONSULT_GUIDE_FAILURE',
  'INITIALIZE_CONSULT',
  'SET_MESSAGES',
  'OPEN_RESERVE_MAIN_REQUEST',
  'OPEN_RESERVE_MAIN_SUCCESS',
  'OPEN_RESERVE_MAIN_FAILURE',
  'SELECT_RESERVE_MAIN_PERSON_REQUEST',
  'SELECT_RESERVE_MAIN_PERSON_SUCCESS',
  'SELECT_RESERVE_MAIN_PERSON_FAILURE',
  'GET_CONSULT_REQUEST',
  'GET_CONSULT_SUCCESS',
  'GET_CONSULT_FAILURE',
  // 一括受付を開くアクション時の処理
  'OPEN_RPT_ALL_ENTRY_GUIDE',
  // 一括受付を閉じるアクション時の処理
  'CLOSE_RPT_ALL_ENTRY_GUIDE',
  // 一括受付の初期化
  'INITIALIZE_RPT_ALL_ENTRY_GUIDE',
  // 一括受付を行う
  'RECEIPT_ALL_REQUEST',
  'RECEIPT_ALL_SUCCESS',
  'RECEIPT_ALL_FAILURE',
  // 一括で受付を取り消す
  'CANCEL_RECEIPT_ALL_REQUEST',
  'CANCEL_RECEIPT_ALL_SUCCESS',
  'CANCEL_RECEIPT_ALL_FAILURE',
  // 一括受付の時間チェック
  'RECEIPT_CHECK',
  'CALC_AGE_REQUEST',
  'CALC_AGE_SUCCESS',
  'CALC_AGE_FAILURE',
  'REGISTER_CONSULT_REQUEST',
  'REGISTER_CONSULT_SUCCESS',
  'REGISTER_CONSULT_FAILURE',
  'INIT_DAILY_LIST_PARAMS',
  'SET_DAILY_LIST_PARAMS',
  'SET_DAILY_LIST_MESSAGE',
  'GET_DAILY_LIST_REQUEST',
  'GET_DAILY_LIST_SUCCESS',
  'GET_DAILY_LIST_FAILURE',
  // 問診入力の初期化
  'LOAD_PREPARATION_INFO_REQUEST',
  'LOAD_PREPARATION_INFO_SUCCESS',
  'LOAD_PREPARATION_INFO_FAILURE',
  // 個人検査結果テーブルを登録または更新
  'MERGE_PER_RESULT_REQUEST',
  'MERGE_PER_RESULT_SUCCESS',
  'MERGE_PER_RESULT_FAILURE',
  // 個人検査結果テーブルを削除
  'DELETE_PER_RESULT_REQUEST',
  'DELETE_PER_RESULT_SUCCESS',
  'DELETE_PER_RESULT_FAILURE',
  // 来院情報設定を開くアクション時の処理
  'OPEN_EDIT_WEL_COME_INFO_GUIDE',
  // 来院情報設定を閉じるアクション時の処理
  'CLOSE_EDIT_WEL_COME_INFO_GUIDE',
  // 来院情報を更新
  'UPDATE_WEL_COME_INFO_REQUEST',
  'UPDATE_WEL_COME_INFO_SUCCESS',
  'UPDATE_WEL_COME_INFO_FAILURE',
  // 来院情報検索
  'GET_WEL_COME_INFO_REQUEST',
  'GET_WEL_COME_INFO_SUCCESS',
  'GET_WEL_COME_INFO_FAILURE',
  // 来院処理を開くアクション時の処理
  'OPEN_RECEIPT_FRONT_DOOR_GUIDE',
  // 来院処理を閉じるアクション時の処理
  'CLOSE_RECEIPT_FRONT_DOOR_GUIDE',
  // 来院情報処理
  'REGISTER_WEL_COME_INFO_REQUEST',
  'REGISTER_WEL_COME_INFO_FAILURE',
  // 検査結果を一括して入力
  'GET_CONSULT_LIST_ITEM_REQUEST',
  'GET_CONSULT_LIST_ITEM_SUCCESS',
  'GET_CONSULT_LIST_ITEM_FAILURE',
  'GET_CONSULT_STEP_LIST',
  'GET_CONSULT_LIST_CHECK_FAILURE',
  // 来院確認を開くアクション時の処理
  'OPEN_RECEIPT_MAIN_GUIDE',
  // 来院確認を閉じるアクション時の処理
  'CLOSE_RECEIPT_MAIN_GUIDE',
  // ガイドを閉じるアクション時の処理
  'OPEN_WEL_COME_INFO_MENU_GUIDE',
  // ガイドを閉じるアクション時の処理
  'CLOSE_WEL_COME_INFO_MENU_GUIDE',
  // 来院確認の初期化
  'LOAD_PECEIPT_MAIN_INFO',
  'LOAD_PECEIPT_MAIN_SUCCESS',
  'LOAD_PECEIPT_MAIN_FAILURE',
  // 来院処理の初期化
  'LOAD_RECEIPT_FRONT_DOOR_INFO',
);

// 受診者ガイド（お連れ様変更ガイドから呼ばれるガイド）
export const {
  openConsultationListGuide,
  closeConsultationListGuide,
  getConsultationListGuideRequest,
  getConsultationListGuideSuccess,
  getConsultationListGuideFailure,
  getConsultationGuideRequest,
  getConsultationGuideSuccess,
  getConsultationGuideFailure,
} = createActions(
  'OPEN_CONSULTATION_LIST_GUIDE',
  'CLOSE_CONSULTATION_LIST_GUIDE',
  'GET_CONSULTATION_LIST_GUIDE_REQUEST',
  'GET_CONSULTATION_LIST_GUIDE_SUCCESS',
  'GET_CONSULTATION_LIST_GUIDE_FAILURE',
  'GET_CONSULTATION_GUIDE_REQUEST',
  'GET_CONSULTATION_GUIDE_SUCCESS',
  'GET_CONSULTATION_GUIDE_FAILURE',
);

// キャンセル理由名取得
export const {
  getCancelReasonNameRequest,
  getCancelReasonNameSuccess,
  getCancelReasonNameFailure,
} = createActions(
  'GET_CANCEL_REASON_NAME_REQUEST',
  'GET_CANCEL_REASON_NAME_SUCCESS',
  'GET_CANCEL_REASON_NAME_FAILURE',
);

// 受付ガイド
export const {
  openEntryFromDetailGuideRequest,
  openEntryFromDetailGuideSuccess,
  openEntryFromDetailGuideFailure,
  closeEntryFromDetailGuide,
  getCourseEntryFromDetailGuideRequest,
  getCourseEntryFromDetailGuideSuccess,
  getCourseEntryFromDetailGuideFailure,
  getPersonEntryFromDetailGuideRequest,
  getPersonEntryFromDetailGuideSuccess,
  getPersonEntryFromDetailGuideFailure,
  validateConsultEntryFromDetailRequest,
  validateConsultEntryFromDetailSuccess,
  validateConsultEntryFromDetailFailure,
} = createActions(
  'OPEN_ENTRY_FROM_DETAIL_GUIDE_REQUEST',
  'OPEN_ENTRY_FROM_DETAIL_GUIDE_SUCCESS',
  'OPEN_ENTRY_FROM_DETAIL_GUIDE_FAILURE',
  'CLOSE_ENTRY_FROM_DETAIL_GUIDE',
  'GET_COURSE_ENTRY_FROM_DETAIL_GUIDE_REQUEST',
  'GET_COURSE_ENTRY_FROM_DETAIL_GUIDE_SUCCESS',
  'GET_COURSE_ENTRY_FROM_DETAIL_GUIDE_FAILURE',
  'GET_PERSON_ENTRY_FROM_DETAIL_GUIDE_REQUEST',
  'GET_PERSON_ENTRY_FROM_DETAIL_GUIDE_SUCCESS',
  'GET_PERSON_ENTRY_FROM_DETAIL_GUIDE_FAILURE',
  'VALIDATE_CONSULT_ENTRY_FROM_DETAIL_REQUEST',
  'VALIDATE_CONSULT_ENTRY_FROM_DETAIL_SUCCESS',
  'VALIDATE_CONSULT_ENTRY_FROM_DETAIL_FAILURE',
);

export const {
  initializeReserveMainCourceItems,
  getReserveMainCourceItemsRequest,
  getReserveMainCourceItemsSuccess,
  getReserveMainCourceItemsFailure,
  initializeReserveMainCslDivItems,
  getReserveMainCslDivItemsRequest,
  getReserveMainCslDivItemsSuccess,
  getReserveMainCslDivItemsFailure,
  initializeReserveMainOptions,
  getReserveMainOptionsRequest,
  getReserveMainOptionsSuccess,
  getReserveMainOptionsFailure,
} = createActions(
  // コースコードドロップダウン
  'INITIALIZE_RESERVE_MAIN_COURCE_ITEMS',
  'GET_RESERVE_MAIN_COURCE_ITEMS_REQUEST',
  'GET_RESERVE_MAIN_COURCE_ITEMS_SUCCESS',
  'GET_RESERVE_MAIN_COURCE_ITEMS_FAILURE',
  // 受診区分ドロップダウン
  'INITIALIZE_RESERVE_MAIN_CSL_DIV_ITEMS',
  'GET_RESERVE_MAIN_CSL_DIV_ITEMS_REQUEST',
  'GET_RESERVE_MAIN_CSL_DIV_ITEMS_SUCCESS',
  'GET_RESERVE_MAIN_CSL_DIV_ITEMS_FAILURE',
  // 検査セット
  'INITIALIZE_RESERVE_MAIN_OPTIONS',
  'GET_RESERVE_MAIN_OPTIONS_REQUEST',
  'GET_RESERVE_MAIN_OPTIONS_SUCCESS',
  'GET_RESERVE_MAIN_OPTIONS_FAILURE',
);

// 受診情報詳細画面予約群
export const {
  initializeReserveMainRsvGrpItems,
  getReserveMainRsvGrpItemsRequest,
  getReserveMainRsvGrpItemsSuccess,
  getReserveMainRsvGrpItemsFailure,
  getReserveMainRsvGrpItemsAllRequest,
  getReserveMainRsvGrpItemsAllSuccess,
  getReserveMainRsvGrpItemsAllFailure,
} = createActions(
  'INITIALIZE_RESERVE_MAIN_RSV_GRP_ITEMS',
  'GET_RESERVE_MAIN_RSV_GRP_ITEMS_REQUEST',
  'GET_RESERVE_MAIN_RSV_GRP_ITEMS_SUCCESS',
  'GET_RESERVE_MAIN_RSV_GRP_ITEMS_FAILURE',
  'GET_RESERVE_MAIN_RSV_GRP_ITEMS_ALL_REQUEST',
  'GET_RESERVE_MAIN_RSV_GRP_ITEMS_ALL_SUCCESS',
  'GET_RESERVE_MAIN_RSV_GRP_ITEMS_ALL_FAILURE',
);

// 印刷状況ガイド
export const {
  openPrintStatusGuide,
  closePrintStatusGuide,
  getPrintStatusRequest,
  getPrintStatusSuccess,
  getPrintStatusFailure,
  registerPrintStatusRequest,
  registerPrintStatusSuccess,
  registerPrintStatusFailure,
  clearCardPrintDatePrintStatusGuide,
  clearFormPrintDatePrintStatusGuide,
} = createActions(
  'OPEN_PRINT_STATUS_GUIDE',
  'CLOSE_PRINT_STATUS_GUIDE',
  'GET_PRINT_STATUS_REQUEST',
  'GET_PRINT_STATUS_SUCCESS',
  'GET_PRINT_STATUS_FAILURE',
  'REGISTER_PRINT_STATUS_REQUEST',
  'REGISTER_PRINT_STATUS_SUCCESS',
  'REGISTER_PRINT_STATUS_FAILURE',
  'CLEAR_CARD_PRINT_DATE_PRINT_STATUS_GUIDE',
  'CLEAR_FORM_PRINT_DATE_PRINT_STATUS_GUIDE',
);
// 受付取り消しガイド
export const {
  openCancelReceptionGuide,
  closeCancelReceptionGuide,
  getConsultCancelReceptionGuideRequest,
  getConsultCancelReceptionGuideSuccess,
  getConsultCancelReceptionGuideFailure,
  executeCancelReceptionGuideRequest,
  executeCancelReceptionGuideSuccess,
  executeCancelReceptionGuideFailure,
} = createActions(
  'OPEN_CANCEL_RECEPTION_GUIDE',
  'CLOSE_CANCEL_RECEPTION_GUIDE',
  'GET_CONSULT_CANCEL_RECEPTION_GUIDE_REQUEST',
  'GET_CONSULT_CANCEL_RECEPTION_GUIDE_SUCCESS',
  'GET_CONSULT_CANCEL_RECEPTION_GUIDE_FAILURE',
  'EXECUTE_CANCEL_RECEPTION_GUIDE_REQUEST',
  'EXECUTE_CANCEL_RECEPTION_GUIDE_SUCCESS',
  'EXECUTE_CANCEL_RECEPTION_GUIDE_FAILURE',
);

// 予約キャンセルガイド
export const {
  openCancelConsultGuide,
  closeCancelConsultGuide,
  getCancelReasonsRequest,
  getCancelReasonsSuccess,
  getCancelReasonsFailure,
  registerCancelConsultRequest,
  registerCancelConsultSuccess,
  registerCancelConsultFailure,
} = createActions(
  'OPEN_CANCEL_CONSULT_GUIDE',
  'CLOSE_CANCEL_CONSULT_GUIDE',
  'GET_CANCEL_REASONS_REQUEST',
  'GET_CANCEL_REASONS_SUCCESS',
  'GET_CANCEL_REASONS_FAILURE',
  'REGISTER_CANCEL_CONSULT_REQUEST',
  'REGISTER_CANCEL_CONSULT_SUCCESS',
  'REGISTER_CANCEL_CONSULT_FAILURE',
);

// セット内項目削除ガイド
export const {
  openConsultDeleteItemGuide,
  closeConsultDeleteItemGuide,
  getContractOptionDeleteItemGuideRequest,
  getContractOptionDeleteItemGuideSuccess,
  getContractOptionDeleteItemGuideFailure,
  getContractOptionItemsDeleteItemGuideRequest,
  getContractOptionItemsDeleteItemGuideSuccess,
  getContractOptionItemsDeleteItemGuideFailure,
  registerContractOptionItemsDeleteItemGuideRequest,
  registerContractOptionItemsDeleteItemGuideSuccess,
  registerContractOptionItemsDeleteItemGuideFailure,
} = createActions(
  'OPEN_CONSULT_DELETE_ITEM_GUIDE',
  'CLOSE_CONSULT_DELETE_ITEM_GUIDE',
  'GET_CONTRACT_OPTION_DELETE_ITEM_GUIDE_REQUEST',
  'GET_CONTRACT_OPTION_DELETE_ITEM_GUIDE_SUCCESS',
  'GET_CONTRACT_OPTION_DELETE_ITEM_GUIDE_FAILURE',
  'GET_CONTRACT_OPTION_ITEMS_DELETE_ITEM_GUIDE_REQUEST',
  'GET_CONTRACT_OPTION_ITEMS_DELETE_ITEM_GUIDE_SUCCESS',
  'GET_CONTRACT_OPTION_ITEMS_DELETE_ITEM_GUIDE_FAILURE',
  'REGISTER_CONTRACT_OPTION_ITEMS_DELETE_ITEM_GUIDE_REQUEST',
  'REGISTER_CONTRACT_OPTION_ITEMS_DELETE_ITEM_GUIDE_SUCCESS',
  'REGISTER_CONTRACT_OPTION_ITEMS_DELETE_ITEM_GUIDE_FAILURE',
);

// カレンダー検索ガイド（予約番号）
export const {
  openRsvCalendarFromRsvNoGuideRequest,
  openRsvCalendarFromRsvNoGuideSuccess,
  openRsvCalendarFromRsvNoGuideFailure,
  closeRsvCalendarFromRsvNoGuide,
  changeDateRsvCalendarFromRsvNoGuideRequest,
  changeDateRsvCalendarFromRsvNoGuideSuccess,
  changeDateRsvCalendarFromRsvNoGuideFailure,
  registerDateRsvCalendarFromRsvNoGuideRequest,
  registerDateRsvCalendarFromRsvNoGuideSuccess,
  registerDateRsvCalendarFromRsvNoGuideFailure,
} = createActions(
  'OPEN_RSV_CALENDAR_FROM_RSV_NO_GUIDE_REQUEST',
  'OPEN_RSV_CALENDAR_FROM_RSV_NO_GUIDE_SUCCESS',
  'OPEN_RSV_CALENDAR_FROM_RSV_NO_GUIDE_FAILURE',
  'CLOSE_RSV_CALENDAR_FROM_RSV_NO_GUIDE',
  'CHANGE_DATE_RSV_CALENDAR_FROM_RSV_NO_GUIDE_REQUEST',
  'CHANGE_DATE_RSV_CALENDAR_FROM_RSV_NO_GUIDE_SUCCESS',
  'CHANGE_DATE_RSV_CALENDAR_FROM_RSV_NO_GUIDE_FAILURE',
  'REGISTER_DATE_RSV_CALENDAR_FROM_RSV_NO_GUIDE_REQUEST',
  'REGISTER_DATE_RSV_CALENDAR_FROM_RSV_NO_GUIDE_SUCCESS',
  'REGISTER_DATE_RSV_CALENDAR_FROM_RSV_NO_GUIDE_FAILURE',
);

// 受診日一括変更(変更完了)ガイド
export const {
  openRsvCslListChangedDateGuideRequest,
  openRsvCslListChangedDateGuideSuccess,
  openRsvCslListChangedDateGuideFailure,
  closeRsvCslListChangedDateGuide,
} = createActions(
  'OPEN_RSV_CSL_LIST_CHANGED_DATE_GUIDE_REQUEST',
  'OPEN_RSV_CSL_LIST_CHANGED_DATE_GUIDE_SUCCESS',
  'OPEN_RSV_CSL_LIST_CHANGED_DATE_GUIDE_FAILURE',
  'CLOSE_RSV_CSL_LIST_CHANGED_DATE_GUIDE',
);

// お連れ様情報登録ガイド
export const {
  openEditFriendsGuideRequest,
  openEditFriendsGuideSuccess,
  openEditFriendsGuideFailure,
  closeEditFriendsGuide,
  registerEditFriendsGuideRequest,
  registerEditFriendsGuideSuccess,
  registerEditFriendsGuideFailure,
  deleteEditFriendsGuideRequest,
  deleteEditFriendsGuideSuccess,
  deleteEditFriendsGuideFailure,
  changeLinesEditFriendsGuide,
} = createActions(
  'OPEN_EDIT_FRIENDS_GUIDE_REQUEST',
  'OPEN_EDIT_FRIENDS_GUIDE_SUCCESS',
  'OPEN_EDIT_FRIENDS_GUIDE_FAILURE',
  'CLOSE_EDIT_FRIENDS_GUIDE',
  'REGISTER_EDIT_FRIENDS_GUIDE_REQUEST',
  'REGISTER_EDIT_FRIENDS_GUIDE_SUCCESS',
  'REGISTER_EDIT_FRIENDS_GUIDE_FAILURE',
  'DELETE_EDIT_FRIENDS_GUIDE_REQUEST',
  'DELETE_EDIT_FRIENDS_GUIDE_SUCCESS',
  'DELETE_EDIT_FRIENDS_GUIDE_FAILURE',
  'CHANGE_LINES_EDIT_FRIENDS_GUIDE',
);

// 変更履歴
export const {
  initializeRsvLogList,
  getConsultLogListRequest,
  getConsultLogListSuccess,
  getConsultLogListFailure,
} = createActions(
  'INITIALIZE_RSV_LOG_LIST',
  'GET_CONSULT_LOG_LIST_REQUEST',
  'GET_CONSULT_LOG_LIST_SUCCESS',
  'GET_CONSULT_LOG_LIST_FAILURE',
);

// 受診日一括変更ガイド
export const {
  openRsvChangeDateAllGuideRequest,
  openRsvChangeDateAllGuideSuccess,
  openRsvChangeDateAllGuideFailure,
  closeRsvChangeDateAllGuide,
} = createActions(
  'OPEN_RSV_CHANGE_DATE_ALL_GUIDE_REQUEST',
  'OPEN_RSV_CHANGE_DATE_ALL_GUIDE_SUCCESS',
  'OPEN_RSV_CHANGE_DATE_ALL_GUIDE_FAILURE',
  'CLOSE_RSV_CHANGE_DATE_ALL_GUIDE',
);

// 受診セット変更ガイド
export const {
  openChangeOptionGuide,
  closeChangeOptionGuide,
  getCtrPtOptFromConsultSuccess,
  getRslCmtListForChangeSetSuccess,
  clearRslCmtInfo,
  updateResultForChangeSetRequest,
  updateResultForChangeSetSuccess,
  updateResultForChangeSetFailure,
} = createActions(
  'OPEN_CHANGE_OPTION_GUIDE',
  'CLOSE_CHANGE_OPTION_GUIDE',
  'GET_CTR_PT_OPT_FROM_CONSULT_SUCCESS',
  'GET_RSL_CMT_LIST_FOR_CHANGE_SET_SUCCESS',
  'CLEAR_RSL_CMT_INFO',
  'UPDATE_RESULT_FOR_CHANGE_SET_REQUEST',
  'UPDATE_RESULT_FOR_CHANGE_SET_SUCCESS',
  'UPDATE_RESULT_FOR_CHANGE_SET_FAILURE',
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
    onSelected: null, // 選択時に実行する処理
  },
  consultationGuide: {
    visible: false, // 可視状態
    conditions: {}, // 検索条件
    searched: false,
    totalcount: 0,
    data: [],
    selectedItem: undefined, // 選択された要素
    onSelected: null, // 選択時に実行する処理
  },
  rptAllEntryGuide: {
    // 以下ガイド用
    visible: false, // 可視状態
    cslDate: null,
    message: [],
    mode: 0,
  },
  edit: {
    formName: null,
    params: {},
    isLoading: false,
    messages: [],
    cancelReasonName: '',
    rsvgrp: {
      items: [],
    },
    course: {
      items: [],
      data: [],
    },
    csldiv: {
      items: [],
      data: [],
    },
    options: null,
  },
  entryFromDetailGuide: {
    visible: false,
    csname: null,
    perid: null,
    lastname: null,
    firstname: null,
    lastkname: null,
    firstkname: null,
    gender: null,
    birth: null,
    onSelected: null,
    messages: [],
  },
  printStatusGuide: {
    visible: false,
    messages: [],
    data: {
      cardprintdate: null,
      formprintdate: null,
    },
  },
  cancelReceptionGuide: {
    visible: false,
    messages: [],
    data: {},
  },
  cancelGuide: {
    reasonItems: [],
    visible: false,
    rsvno: null,
    redirect: null,
  },
  consultItemDeleteGuide: {
    visible: false,
    rsvno: null,
    ctrptcd: null,
    optcd: null,
    optbranchno: null,
    data: {}, // 検査セット情報
    optionItems: [], // 検査セット内の全項目情報が配列で格納される
    // redux-formのinitialValueにセットする
    initialValues: {
      // キーが項目コード、値が1かnullの連想配列
      // 選択されている値が1になる
      items: {},
    },
    messages: [],
  },
  rsvCalendarFromRsvNoGuide: {
    params: {
      mode: null,
      rsvno: [],
      rsvgrpcd: [],
      cslyear: '',
      cslmonth: '',
      onSelected: null,
    },
    consult: {},
    organization: {},
    contract: {},
    options: [],
    messages: [],
    schedule: [],
    recentConsults: [],
    visible: false,
  },
  rsvCslListChangedDateGuide: {
    visible: false,
    params: {},
    data: [],
    messages: [],
  },
  // お連れ様情報変更ガイド
  editFriendsGuide: {
    visible: false,
    params: {},
    data: {
      consult: {},
      person: {},
      friends: [],
      lines: 10,
    },
    lineItems: [],
    messages: [],
  },
  // 受診日一括変更ガイド
  rsvChangeDateAllGuide: {
    visible: false,
    params: {},
    data: {
      consult: {},
      friends: [],
    },
    messages: [],
  },
  consultList: {
    consult: [],
  },
  dailyList: {
    params: {
      key: '',
      strDate: '',
      endDate: '',
      csCd: '',
      prtField: '',
      prtFieldName: '',
      arrPrtField: [],
      orgCd1: '',
      orgCd2: '',
      itemCd: '',
      grpCd: '',
      entry: '',
      sortKey: 0,
      sortType: 0,
      startPos: 0,
      getCount: '',
      print: 0,
      navi: '',
      rsvStat: '',
      rptStat: '',
      cslDivCd: '',
      // 団体略称
      orgSName: '',
      // 依頼項目／グループ名称
      itemName: '',
      isSearching: false,
    },
    message: [],
    searched: false,
    totalcount: 0,
    data: [],
  },

  prepaInfo: {
    message: [],
    consult: null,
    org: null,
    perResult: null,
    allInfo: [],
    edtResult: [],
    stcCount: 0,
    prepaInfoDisease: [],
    prepaInfoCmntHis: [],
    prepaInfoReexamin: [],
    prepaInfoSecond: [],
  },

  editWelComeInfoGuide: {
    // 以下ガイド用
    visible: false, // 可視状態
    message: [],
    mode: 0,
    data: {},
    welcomeflag: 0,
    visitstatus: 0,
    visiterror: false,
  },

  receiptFrontDoorGuide: {
    // 以下ガイド用
    visible: false, // 可視状態
    message: [],
    data: {},
    personInfo: [],
    errstauts: '',
    dayidtxt: '',
    comedatetxt: '',
    csldatetxt: '',
    ocrno: '',
    perid: '',
  },

  receiptMainGuide: {
    // 以下ガイド用
    visible: false, // 可視状態
    message: [],
    data: {},
    rsvno: '',
    dayidtxt: '',
    realagetxt: 0,
  },

  welComeInfoMenuGuide: {
    // 以下ガイド用
    visible: false, // 可視状態
    pagestats: 1, // 来院処理
    guidanceno: '',
    ocrno: '',
    mode: 0,
  },
  // 検査結果を一括して入力
  itemList: {
    data: [],
    message: [],
    modelInfo: [],
    cscd: '',
    cslDate: '',
    grpcd: '',
    dayIdF: '',
    dayIdT: '',
    isLoading: false,
    allResultClear: false,
  },
  // 変更履歴
  rsvLogList: {
    message: [],
    consultLogList: [],
    totalcount: 0,
    conditions: {
      startDate: null,
      endDate: null,
      rsvNo: '',
      orderByItem: '',
      orderByMode: '',
      addUser: '',
      getCount: '',
      startPos: 1,
    },
  },

  // 受診セット変更
  changeOptionGuide: {
    message: [],
    visible: false, // 可視状態
    rsvno: null, // 予約番号
    specialcheck: null, // 特定保険指導対象者チェック
    consultdata: {}, // 受診情報
    optiondata: [], // 受診オプション検査情報
    realage: null, // 実年齢
    optfromconsultdata: [], // 全オプション検査情報
    changesetdata: {}, // 全オプション検査情報
    index: null,
    flg: 0,
  },
};

// reducerの作成
export default handleActions({
  // 変更履歴画面を初期化の処理
  [initializeRsvLogList]: (state) => {
    const { rsvLogList } = initialState;
    return { ...state, rsvLogList };
  },
  // 変更履歴一覧検索を開始時の処理
  [getConsultLogListRequest]: (state, action) => {
    const { rsvLogList } = state;
    // 検索条件を更新する
    const conditions = action.payload;

    return { ...state, rsvLogList: { ...rsvLogList, conditions } };
  },

  // 変更履歴一覧取得成功時の処理
  [getConsultLogListSuccess]: (state, action) => {
    const { rsvLogList } = state;
    const { data, totalcount } = action.payload;
    let message = [];
    if (totalcount === 0) {
      message = ['検索条件を満たす履歴は存在しませんでした。 '];
    }
    return { ...state, rsvLogList: { ...rsvLogList, consultLogList: data, totalcount, message } };
  },

  // 変更履歴一覧取得失敗時の処理
  [getConsultLogListFailure]: (state, action) => {
    const { rsvLogList } = state;
    const { message } = action.payload;
    return { ...state, rsvLogList: { ...rsvLogList, totalcount: 0, message } };
  },

  // 開くアクション時の処理
  [openConsultListGuide]: (state, action) => {
    // 可視状態をtrueにする
    const { guide } = initialState;
    const visible = true;
    const { conditions, onSelected = null } = action.payload;
    return { ...state, guide: { ...guide, visible, conditions, onSelected } };
  },

  // 受診者一覧取得開始時の処理
  [getConsultListGuideRequest]: (state, action) => {
    // 検索条件を更新する
    const { guide } = state;
    const { conditions } = action.payload;
    return { ...state, guide: { ...guide, conditions } };
  },
  // 受診者一覧取得成功時の処理
  [getConsultListGuideSuccess]: (state, action) => {
    const { guide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, guide: { ...guide, searched, totalCount, data } };
  },
  // 受診者取得成功時の処理
  [getConsultGuideSuccess]: (state, action) => {
    // 選択された要素を更新
    const { guide } = state;
    const selectedItem = action.payload;
    return { ...state, guide: { ...guide, selectedItem } };
  },
  // 閉じるアクション時の処理
  [closeConsultListGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { guide } = initialState;
    return { ...state, guide };
  },

  // 受診者ガイドオープン処理
  [openConsultationListGuide]: (state, action) => {
    // 可視状態をtrueにする
    const { consultationGuide } = initialState;
    const visible = true;
    const { conditions, onSelected = null, perid } = action.payload;
    return { ...state, consultationGuide: { ...consultationGuide, visible, conditions, onSelected, perid } };
  },
  // 受診者一覧取得開始時の処理
  [getConsultationListGuideRequest]: (state, action) => {
    // 検索条件を更新する
    const { consultationGuide } = state;
    const conditions = action.payload;
    return { ...state, consultationGuide: { ...consultationGuide, conditions } };
  },
  // 受診者一覧取得成功時の処理
  [getConsultationListGuideSuccess]: (state, action) => {
    const { consultationGuide } = state;
    // 検索指示状態とする
    const searched = true;
    const { totalcount, data } = action.payload;
    return { ...state, consultationGuide: { ...consultationGuide, searched, totalcount, data } };
  },
  // 閉じるアクション時の処理
  [closeConsultationListGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { consultationGuide } = initialState;
    return { ...state, consultationGuide };
  },

  // 受診者情報登録初期化処理
  [initializeConsult]: (state) => {
    const { edit } = initialState;
    return { ...state, edit };
  },
  // 受診者情報詳細画面表示開始時処理
  [openReserveMainRequest]: (state, action) => {
    const { edit } = state;
    const { formName = edit.formName, params = edit.params } = action.payload || {};
    return { ...state, edit: { ...edit, isLoading: true, formName, params } };
  },
  // 受診者情報詳細画面表示成功、失敗時処理
  [combineActions(openReserveMainSuccess, openReserveMainFailure)]: (state) => {
    const { edit } = state;
    return { ...state, edit: { ...edit, isLoading: false } };
  },
  // 受診情報詳細画面受診者選択開始処理
  [selectReserveMainPersonRequest]: (state) => {
    const { edit } = state;
    return { ...state, edit: { ...edit, isLoading: true } };
  },
  // 受診情報詳細画面受診者選択成功処理
  [selectReserveMainPersonSuccess]: (state) => {
    const { edit } = state;
    return { ...state, edit: { ...edit, isLoading: false } };
  },
  // 受診情報詳細画面受診者選択失敗処理
  [selectReserveMainPersonFailure]: (state) => {
    const { edit } = state;
    return { ...state, edit: { ...edit, isLoading: false } };
  },
  // 受診者情報詳細画面コースドロップダウン初期化処理
  [initializeReserveMainCourceItems]: (state) => {
    const { edit } = state;
    const { course } = initialState.edit;
    return { ...state, edit: { ...edit, course } };
  },
  // 受診者情報詳細画面コースドロップダウン取得成功時処理
  [getReserveMainCourceItemsSuccess]: (state, action) => {
    const data = action.payload || [];
    const items = data.map((rec) => ({ name: rec.ctrcsname, value: rec.cscd }));
    const { edit } = state;
    const { course } = edit;
    return { ...state, edit: { ...edit, course: { ...course, items, data } } };
  },
  // 受診者情報詳細画面受診区分ドロップダウン初期化処理
  [initializeReserveMainCslDivItems]: (state) => {
    const { edit } = state;
    const { csldiv } = initialState.edit;
    return { ...state, edit: { ...edit, csldiv } };
  },
  // 受診者情報詳細画面受診区分ドロップダウン取得成功時処理
  [getReserveMainCslDivItemsSuccess]: (state, action) => {
    const data = action.payload || [];
    const items = data.map((rec) => ({ name: rec.csldivname, value: rec.csldivcd }));
    const { edit } = state;
    const { csldiv } = edit;
    return { ...state, edit: { ...edit, csldiv: { ...csldiv, items, data } } };
  },
  // 受診者情報詳細画面検査セット初期化処理
  [initializeReserveMainOptions]: (state) => {
    const { edit } = state;
    const { options } = initialState.edit;
    return { ...state, edit: { ...edit, options } };
  },
  // 受診者情報詳細画面検査セット取得成功時処理
  [getReserveMainOptionsSuccess]: (state, action) => {
    const options = action.payload;
    const { edit } = state;
    return { ...state, edit: { ...edit, options } };
  },
  // 受診者情報詳細画面予約群初期化処理
  [initializeReserveMainRsvGrpItems]: (state) => {
    const { edit } = state;
    const { rsvgrp } = initialState.edit;
    return { ...state, edit: { ...edit, rsvgrp } };
  },
  // 受診者情報詳細画面予約群取得成功時処理
  [combineActions(getReserveMainRsvGrpItemsSuccess, getReserveMainRsvGrpItemsAllSuccess)]: (state, action) => {
    const { payload = [] } = action;
    const { edit } = state;
    const { rsvgrp } = edit;
    const items = payload.map((rec) => ({ name: rec.rsvgrpname, value: rec.rsvgrpcd }));
    return { ...state, edit: { ...edit, rsvgrp: { ...rsvgrp, items } } };
  },
  // 受診者情報メッセージのセット処理
  [setMessages]: (state, action) => {
    const { edit } = state;
    const messages = action.payload;
    return { ...state, edit: { ...edit, messages } };
  },
  // 受診者情報登録開始時の処理
  [registerConsultRequest]: (state) => {
    const { edit } = state;
    const { messages } = initialState.edit;
    return { ...state, edit: { ...edit, messages } };
  },
  // 受診者情報登録成功時の処理
  [combineActions(registerConsultSuccess, registerCancelConsultSuccess)]: (state) => {
    const { edit } = state;
    const messages = ['保存が完了しました。'];
    return { ...state, edit: { ...edit, messages } };
  },
  // 受診者情報登録失敗時の処理
  [combineActions(registerConsultFailure, registerCancelConsultFailure)]: (state, action) => {
    const { edit } = state;
    const { data } = action.payload;
    const messages = data.errors;
    return { ...state, edit: { ...edit, messages } };
  },
  // 受付ガイドオープン開始処理
  [openEntryFromDetailGuideRequest]: (state, action) => {
    const { edit } = state;
    const { messages } = initialState.edit;
    const { entryFromDetailGuide } = state;
    const { onSelected } = action.payload;
    return {
      ...state,
      edit: { ...edit, messages },
      entryFromDetailGuide: { ...entryFromDetailGuide, onSelected },
    };
  },
  // 受付ガイドオープン成功処理
  [openEntryFromDetailGuideSuccess]: (state) => {
    const { entryFromDetailGuide } = state;
    return { ...state, entryFromDetailGuide: { ...entryFromDetailGuide, visible: true } };
  },
  // 受付ガイドオープン失敗処理
  [openEntryFromDetailGuideFailure]: (state, action) => {
    const { edit } = state;
    const { entryFromDetailGuide } = initialState;
    const { data } = action.payload;
    const messages = data.errors;
    return { ...state, entryFromDetailGuide, edit: { ...edit, messages } };
  },
  // 受付ガイドクローズ処理
  [closeEntryFromDetailGuide]: (state) => {
    const { entryFromDetailGuide } = initialState;
    return { ...state, entryFromDetailGuide };
  },
  // 受付ガイドコース情報取得成功時の処理
  [getCourseEntryFromDetailGuideSuccess]: (state, action) => {
    const { entryFromDetailGuide } = state;
    const { csname } = action.payload;
    return { ...state, entryFromDetailGuide: { ...entryFromDetailGuide, csname } };
  },
  // 受付ガイド個人情報取得成功時の処理
  [getPersonEntryFromDetailGuideSuccess]: (state, action) => {
    const { entryFromDetailGuide } = state;
    const { perid, firstname, lastname, firstkname, lastkname, gender, birth } = action.payload;
    return { ...state, entryFromDetailGuide: { ...entryFromDetailGuide, perid, firstname, lastname, firstkname, lastkname, gender, birth } };
  },
  // 当日IDバリデーション処理時
  [validateConsultEntryFromDetailRequest]: (state) => {
    const { entryFromDetailGuide } = state;
    const { messages } = initialState.entryFromDetailGuide;
    return { ...state, entryFromDetailGuide: { ...entryFromDetailGuide, messages } };
  },
  // 当日IDバリデーションエラー時の処理
  [validateConsultEntryFromDetailFailure]: (state, action) => {
    const { entryFromDetailGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, entryFromDetailGuide: { ...entryFromDetailGuide, messages } };
  },
  // 印刷状況ガイドオープン時の処理
  [openPrintStatusGuide]: (state) => {
    const { printStatusGuide } = state;
    return { ...state, printStatusGuide: { ...printStatusGuide, visible: true } };
  },
  // 印刷状況ガイドクローズ時の処理
  [closePrintStatusGuide]: (state) => {
    const { printStatusGuide } = initialState;
    return { ...state, printStatusGuide: { ...printStatusGuide } };
  },
  // 印刷状況取得成功時の処理
  [getPrintStatusSuccess]: (state, action) => {
    const { printStatusGuide } = state;
    return { ...state, printStatusGuide: { ...printStatusGuide, data: action.payload } };
  },
  // 印刷状況取得失敗時の処理
  [getPrintStatusFailure]: (state, action) => {
    const { printStatusGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, printStatusGuide: { ...printStatusGuide, messages } };
  },
  // 印刷状況登録失敗時の処理
  [registerPrintStatusFailure]: (state, action) => {
    const { printStatusGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, printStatusGuide: { ...printStatusGuide, messages } };
  },
  // 確認はがき出力日時クリア処理
  [clearCardPrintDatePrintStatusGuide]: (state) => {
    const { printStatusGuide } = state;
    const { data } = printStatusGuide;
    const { cardprintdate } = initialState.printStatusGuide.data;
    return { ...state, printStatusGuide: { ...printStatusGuide, data: { ...data, cardprintdate } } };
  },
  // 一式書式出力日時クリア処理
  [clearFormPrintDatePrintStatusGuide]: (state) => {
    const { printStatusGuide } = state;
    const { data } = printStatusGuide;
    const { formprintdate } = initialState.printStatusGuide.data;
    return { ...state, printStatusGuide: { ...printStatusGuide, data: { ...data, formprintdate } } };
  },
  // 受付取り消しガイドオープン処理
  [openCancelReceptionGuide]: (state, action) => {
    const { cancelReceptionGuide } = state;
    const { onSelected } = action.payload;
    return { ...state, cancelReceptionGuide: { ...cancelReceptionGuide, onSelected, visible: true } };
  },
  // 受付取り消しガイドクローズ処理
  [closeCancelReceptionGuide]: (state) => {
    const { cancelReceptionGuide } = initialState;
    return { ...state, cancelReceptionGuide: { ...cancelReceptionGuide } };
  },
  // 受付取り消しガイド受診情報取得成功時処理
  [getConsultCancelReceptionGuideSuccess]: (state, action) => {
    const { cancelReceptionGuide } = state;
    return { ...state, cancelReceptionGuide: { ...cancelReceptionGuide, data: action.payload } };
  },
  // 受付取り消し成功時処理
  [executeCancelReceptionGuideFailure]: (state, action) => {
    // 受付取り消しのメッセージはエディット画面に書く
    const { cancelReceptionGuide } = state;
    const messages = action.payload;
    return { ...state, edit: { ...cancelReceptionGuide, messages } };
  },
  // 受付取り消し失敗時処理
  [executeCancelReceptionGuideFailure]: (state, action) => {
    // 受付取り消しのメッセージはエディット画面に書く
    const { cancelReceptionGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, cancelReceptionGuide: { ...cancelReceptionGuide, messages } };
  },
  // 予約キャンセルガイドを開く
  [openCancelConsultGuide]: (state, action) => {
    const { cancelGuide } = state;
    const { rsvno, redirect } = action.payload;
    return { ...state, cancelGuide: { ...cancelGuide, rsvno, redirect, visible: true } };
  },
  // 予約キャンセルガイドを閉じる
  [closeCancelConsultGuide]: (state) => {
    const { cancelGuide } = initialState;
    return { ...state, cancelGuide };
  },
  // キャンセル理由一覧取得成功時処理
  [getCancelReasonsSuccess]: (state, action) => {
    const { cancelGuide } = state;
    const reasonItems = action.payload || initialState.cancelGuide.reasonItems;
    return { ...state, cancelGuide: { ...cancelGuide, reasonItems } };
  },
  // キャンセル理由取得成功時処理
  [getCancelReasonNameSuccess]: (state, action) => {
    const { edit } = state;
    const { freecd, freefield1 } = action.payload;
    const cancelReasonName = freecd ? freefield1 : initialState.edit.cancelReasonName;
    return { ...state, edit: { ...edit, cancelReasonName } };
  },
  // セット内項目削除ガイドオープン処理
  [openConsultDeleteItemGuide]: (state, action) => {
    const { consultItemDeleteGuide } = state;
    const { rsvno, ctrptopt, ctrPtoptbranchno } = action.payload;
    return { ...state, consultItemDeleteGuide: { ...consultItemDeleteGuide, rsvno, ctrptopt, ctrPtoptbranchno, visible: true } };
  },
  // セット内項目削除ガイドクローズ処理
  [closeConsultDeleteItemGuide]: (state) => {
    const { consultItemDeleteGuide } = initialState;
    return { ...state, consultItemDeleteGuide };
  },
  // セット内項目削除ガイド項目情報取得成功時処理
  [getContractOptionDeleteItemGuideSuccess]: (state, action) => {
    const { consultItemDeleteGuide } = state;
    const data = action.payload;
    return { ...state, consultItemDeleteGuide: { ...consultItemDeleteGuide, data } };
  },
  // セット内項目削除ガイド項目情報取得失敗時処理
  [getContractOptionItemsDeleteItemGuideFailure]: (state, action) => {
    const { consultItemDeleteGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, consultItemDeleteGuide: { ...consultItemDeleteGuide, messages } };
  },
  // セット内項目削除ガイド項目一覧取得成功時処理
  [getContractOptionItemsDeleteItemGuideSuccess]: (state, action) => {
    const { consultItemDeleteGuide } = state;
    const { initialValues } = consultItemDeleteGuide;
    const optionItems = action.payload;

    // 検査項目コードをキーとした連想配列に並べ替える
    // 値があれば1そうでなければnullにする
    const items = !optionItems ? {} : optionItems.reduce((accum, rec) => (
      { ...accum, [rec.itemcd]: (rec.consults === 1 ? 1 : null) }
    ), {});

    return {
      ...state,
      consultItemDeleteGuide: {
        ...consultItemDeleteGuide,
        optionItems,
        initialValues: { ...initialValues, items },
      },
    };
  },
  // セット内項目削除ガイド項目一覧取得失敗時処理
  [getContractOptionItemsDeleteItemGuideFailure]: (state, action) => {
    const { consultItemDeleteGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, consultItemDeleteGuide: { ...consultItemDeleteGuide, messages } };
  },
  // セット内項目削除ガイド項目登録失敗時処理
  [registerContractOptionItemsDeleteItemGuideFailure]: (state, action) => {
    const { consultItemDeleteGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, consultItemDeleteGuide: { ...consultItemDeleteGuide, messages } };
  },
  // カレンダー検索ガイド（予約番号）オープン開始処理
  [openRsvCalendarFromRsvNoGuideRequest]: (state, action) => {
    const { rsvCalendarFromRsvNoGuide } = state;
    const { payload = {} } = action;
    const params = {
      mode: payload.mode,
      rsvno: Array.isArray(payload.rsvno) ? payload.rsvno : [payload.rsvno],
      rsvgrpcd: Array.isArray(payload.rsvgrpcd) ? payload.rsvgrpcd : [payload.rsvgrpcd],
      cslyear: payload.cslyear,
      cslmonth: payload.cslmonth,
      onSelected: payload.onSelected,
    };
    return { ...state, rsvCalendarFromRsvNoGuide: { ...rsvCalendarFromRsvNoGuide, params, visible: true } };
  },
  // カレンダー検索ガイド（予約番号）オープン成功処理
  [openRsvCalendarFromRsvNoGuideSuccess]: (state, action) => {
    const { rsvCalendarFromRsvNoGuide } = state;
    // 受診日、休診日、ステータスの配列を配列の連想配列に変換
    let schedule = [];
    if (action.payload.schedule.csldate) {
      schedule = action.payload.schedule.csldate.map((v, i) => ({
        csldate: v,
        holiday: action.payload.schedule.holiday[i],
        status: action.payload.schedule.status[i],
      }));
    }
    return { ...state, rsvCalendarFromRsvNoGuide: { ...rsvCalendarFromRsvNoGuide, ...action.payload, schedule } };
  },
  // カレンダー検索ガイド（予約番号）クローズ処理
  [closeRsvCalendarFromRsvNoGuide]: (state) => {
    const { rsvCalendarFromRsvNoGuide } = initialState;
    return { ...state, rsvCalendarFromRsvNoGuide };
  },
  // カレンダー検索ガイド（予約番号）年月変更開始時処理
  [changeDateRsvCalendarFromRsvNoGuideRequest]: (state, action) => {
    const { rsvCalendarFromRsvNoGuide } = state;
    const { cslyear, cslmonth } = action.payload;
    const params = { ...rsvCalendarFromRsvNoGuide.params, cslyear, cslmonth };
    return { ...state, rsvCalendarFromRsvNoGuide: { ...rsvCalendarFromRsvNoGuide, params } };
  },
  // カレンダー検索ガイド（予約番号）年月変更成功時処理
  [changeDateRsvCalendarFromRsvNoGuideSuccess]: (state, action) => {
    const { rsvCalendarFromRsvNoGuide } = state;
    // 受診日、休診日、ステータスの配列を配列の連想配列に変換
    let schedule = [];
    if (action.payload.csldate) {
      schedule = action.payload.csldate.map((v, i) => ({
        csldate: v,
        holiday: action.payload.holiday[i],
        status: action.payload.status[i],
      }));
    }
    return {
      ...state,
      rsvCalendarFromRsvNoGuide: {
        ...rsvCalendarFromRsvNoGuide,
        schedule,
      },
    };
  },
  // カレンダー検索ガイド（予約番号）受診年月日登録成功時処理
  [registerDateRsvCalendarFromRsvNoGuideSuccess]: (state) => {
    const { rsvCalendarFromRsvNoGuide } = initialState;
    return { ...state, rsvCalendarFromRsvNoGuide };
  },
  // カレンダー検索ガイド（予約番号）受診年月日登録失敗時処理
  [registerDateRsvCalendarFromRsvNoGuideFailure]: (state, action) => {
    const { rsvCalendarFromRsvNoGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, rsvCalendarFromRsvNoGuide: { ...rsvCalendarFromRsvNoGuide, messages } };
  },
  // 受診日一括変更(変更完了)ガイドオープン開始処理
  [openRsvCslListChangedDateGuideRequest]: (state, action) => {
    const { rsvCslListChangedDateGuide } = state;
    const params = action.payload;
    return { ...state, rsvCslListChangedDateGuide: { ...rsvCslListChangedDateGuide, params, visible: true } };
  },
  // 受診日一括変更(変更完了)ガイドオープン成功時処理
  [openRsvCslListChangedDateGuideSuccess]: (state, action) => {
    const { rsvCslListChangedDateGuide } = state;
    const data = action.payload;
    return { ...state, rsvCslListChangedDateGuide: { ...rsvCslListChangedDateGuide, data } };
  },
  // 受診日一括変更(変更完了)ガイドオープン失敗時処理
  [openRsvCslListChangedDateGuideFailure]: (state, action) => {
    const { rsvCslListChangedDateGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, rsvCslListChangedDateGuide: { ...rsvCslListChangedDateGuide, messages } };
  },
  // 受診日一括変更(変更完了)ガイドクローズ処理
  [closeRsvCslListChangedDateGuide]: (state) => {
    const { rsvCslListChangedDateGuide } = initialState;
    return { ...state, rsvCslListChangedDateGuide };
  },

  // お連れ様情報登録ガイドオープン開始処理
  [openEditFriendsGuideRequest]: (state, action) => {
    const { editFriendsGuide } = state;
    const params = action.payload;
    return { ...state, editFriendsGuide: { ...editFriendsGuide, params, visible: true } };
  },
  // お連れ様情報登録ガイドオープン成功処理
  [openEditFriendsGuideSuccess]: (state, action) => {
    const { editFriendsGuide } = state;
    const defaultLines = initialState.editFriendsGuide.data.lines;
    const data = action.payload;

    // 表示行数計算
    const lines = (Array.isArray(data.friends) && data.friends.length > defaultLines && (
      (Math.floor((data.friends.length - defaultLines) / INCREASE_COUNT) + 1) * INCREASE_COUNT + defaultLines
    )) || defaultLines;

    const lineItems = [
      { name: lines.toString(), value: lines },
      { name: (lines + INCREASE_COUNT).toString(), value: lines + INCREASE_COUNT },
    ];

    return { ...state, editFriendsGuide: { ...editFriendsGuide, data: { ...data, lines }, lineItems } };
  },
  // お連れ様情報登録ガイド受診情報登録行数変更処理
  [changeLinesEditFriendsGuide]: (state, action) => {
    const { editFriendsGuide } = state;
    const { data } = editFriendsGuide;
    const lines = action.payload;

    // 表示行数ドロップダウン選択肢作成
    const lineItems = [
      { name: lines.toString(), value: lines },
      { name: (lines + INCREASE_COUNT).toString(), value: lines + INCREASE_COUNT },
    ];

    return { ...state, editFriendsGuide: { ...editFriendsGuide, data: { ...data, lines }, lineItems } };
  },
  // お連れ様情報登録ガイドクローズ処理
  [closeEditFriendsGuide]: (state) => {
    const { editFriendsGuide } = initialState;
    return { ...state, editFriendsGuide };
  },
  // お連れ様情報登録ガイド登録開始時処理
  [registerEditFriendsGuideRequest]: (state) => {
    const { editFriendsGuide } = state;
    const { messages } = initialState.editFriendsGuide;
    return { ...state, editFriendsGuide: { ...editFriendsGuide, messages } };
  },
  // お連れ様情報登録ガイド登録成功時処理
  [registerEditFriendsGuideSuccess]: (state) => {
    const { editFriendsGuide } = state;
    const messages = ['保存が完了しました。'];
    return { ...state, editFriendsGuide: { ...editFriendsGuide, messages } };
  },
  // お連れ様情報登録ガイド登録失敗時処理
  [registerEditFriendsGuideFailure]: (state, action) => {
    const { editFriendsGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, editFriendsGuide: { ...editFriendsGuide, messages } };
  },
  // お連れ様情報登録ガイド削除開始時処理
  [deleteEditFriendsGuideRequest]: (state) => {
    const { editFriendsGuide } = state;
    const { messages } = initialState.editFriendsGuide;
    return { ...state, editFriendsGuide: { ...editFriendsGuide, messages } };
  },
  // お連れ様情報登録ガイド削除成功時処理
  [deleteEditFriendsGuideSuccess]: (state, action) => {
    const { editFriendsGuide } = state;
    const messages = action.payload.messages || ['削除が完了しました。'];
    return { ...state, editFriendsGuide: { ...editFriendsGuide, messages } };
  },
  // お連れ様情報登録ガイド削除失敗時処理
  [deleteEditFriendsGuideFailure]: (state, action) => {
    const { editFriendsGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, editFriendsGuide: { ...editFriendsGuide, messages } };
  },

  // 受診日一括変更ガイドオープン開始処理
  [openRsvChangeDateAllGuideRequest]: (state, action) => {
    const { rsvChangeDateAllGuide } = state;
    const params = action.payload;
    return { ...state, rsvChangeDateAllGuide: { ...rsvChangeDateAllGuide, params, visible: true } };
  },
  // 受診日一括変更ガイドオープン成功処理
  [openRsvChangeDateAllGuideSuccess]: (state, action) => {
    const { rsvChangeDateAllGuide } = state;
    const data = action.payload;
    return { ...state, rsvChangeDateAllGuide: { ...rsvChangeDateAllGuide, data } };
  },
  // 受診日一括変更ガイドオープン失敗処理
  [openRsvChangeDateAllGuideFailure]: (state, action) => {
    const { rsvChangeDateAllGuide } = state;
    const messages = action.payload.data.errors;
    return { ...state, rsvChangeDateAllGuide: { ...rsvChangeDateAllGuide, messages } };
  },
  // 受診日一括変更ガイドクローズ処理
  [closeRsvChangeDateAllGuide]: (state) => {
    const { rsvChangeDateAllGuide } = initialState;
    return { ...state, rsvChangeDateAllGuide };
  },
  // 契約コースの選択ガイドを開くアクション時の処理
  [initializeRptAllEntryGuide]: (state, action) => {
    // 可視状態をtrueにする
    const { rptAllEntryGuide } = state;
    const { cslDate } = action.payload;
    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, cslDate } };
  },
  // 一括受付を開くアクション時の処理
  [openRptAllEntryGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { rptAllEntryGuide } = initialState;
    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, visible } };
  },
  // 一括受付を閉じるアクション時の処理
  [closeRptAllEntryGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { rptAllEntryGuide } = initialState;
    return { ...state, rptAllEntryGuide };
  },

  // 一括受付を行う取得成功時の処理
  [receiptAllSuccess]: (state) => {
    // 可視状態をtrueにする
    const { rptAllEntryGuide } = state;

    const visible = false;

    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, visible } };
  },
  // 一括受付を行う処理失敗時の処理
  [receiptAllFailure]: (state, action) => {
    const { rptAllEntryGuide } = state;
    const { data } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (data !== undefined) {
      message = [data];
    }
    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, message } };
  },
  // 一括で受付を取り消す取得成功時の処理
  [cancelReceiptAllSuccess]: (state) => {
    // 可視状態をtrueにする
    const { rptAllEntryGuide } = state;

    const visible = false;

    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, visible } };
  },
  // 一括で受付を取り消す処理失敗時の処理
  [cancelReceiptAllFailure]: (state, action) => {
    const { rptAllEntryGuide } = state;
    const { status } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['検索条件を満たす契約情報は存在しません。'];
    }
    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, message } };
  },
  // 一括受付の時間チェック
  [receiptCheck]: (state, action) => {
    const { rptAllEntryGuide } = state;
    const message = action.payload;
    return { ...state, rptAllEntryGuide: { ...rptAllEntryGuide, message } };
  },
  // 受診情報を取得時の処理
  [getConsultRequest]: (state, action) => {
    const { consultList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, consultList: { ...consultList, conditions } };
  },
  // 受診情報を取得成功時の処理
  [getConsultSuccess]: (state, action) => {
    const { consultList, changeOptionGuide } = state;
    // 総件数とデータとを更新する
    const { consult, consultdata, realage } = action.payload;
    return { ...state, consultList: { ...consultList, consult }, changeOptionGuide: { ...changeOptionGuide, consultdata, realage } };
  },

  // 受診者一覧引数値設定の処理
  [initDailyListParams]: (state) => {
    const { dailyList } = initialState;
    const { params } = dailyList;
    // (これに伴い一覧が再描画される)
    return {
      ...state, dailyList: { ...dailyList, params },
    };
  },
  // 受診者一覧引数値設定の処理
  [setDailyListParams]: (state, action) => {
    const { dailyList } = state;
    const { params } = dailyList;
    // (これに伴い一覧が再描画される)
    const { newParams } = action.payload;
    return {
      ...state, dailyList: { ...dailyList, params: { ...params, ...newParams } },
    };
  },
  // 受診者一覧メッセージ設定の処理
  [setDailyListMessage]: (state, action) => {
    const { dailyList } = state;
    // (これに伴い一覧が再描画される)
    const { message } = action.payload;
    return {
      ...state, dailyList: { ...dailyList, message },
    };
  },
  // 受診者一覧取得成功時の処理
  [getDailyListSuccess]: (state, action) => {
    const { dailyList } = state;
    const { params } = dailyList;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { message, totalcount, data, prtFieldName, arrPrtField } = action.payload;
    return {
      ...state, dailyList: { ...dailyList, message, searched, totalcount, data, params: { ...params, prtFieldName, arrPrtField } },
    };
  },

  // 問診入力の初期化を取得成功時の処理
  [loadPreparationInfoSuccess]: (state, action) => {
    const { prepaInfo } = state;
    const { consult } = action.payload;
    const { org } = action.payload.org;
    const { perResult } = action.payload;
    const { disease } = action.payload;
    const { cmntHis } = action.payload;

    const arrItemCd = ['80013', '80016', '80015', '80017', '80011', '80012', '80010', '80018', '80021', '80014', '80019', '80020', '80022', '80023'];
    const arrSuffix = ['00', '00', '00', '00', '00', '00', '00', '00', '00', '00', '00', '00', '00', '00'];

    // 文章コード
    let arrStcCd = [];
    // 文章略称
    let arrShortStc = [];
    // 保存用エリアに退避
    const itemCd = [];
    //
    const suffix = [];
    //
    const edtResult = [];
    // 文章数
    let stcCount;

    const allInfo = [];

    // 臨床採血
    const arrStcCd1 = ['2', '3', '4'];
    const arrShortStc1 = ['臨床採血', '採血困難', '採血後気分不快'];
    // 採血側指示
    const arrStcCd2 = ['2', '3', '4'];
    const arrShortStc2 = ['採血右腕', '採血左腕', '採血足'];
    // ＥＤＴＡ
    const arrStcCd3 = ['2', '3'];
    const arrShortStc3 = ['ＥＤＴＡ凝集', 'ＥＤＴＡ凝集即提出'];
    // 感染症
    const arrStcCd4 = ['2', '3', '4', '5', '6', '7'];
    const arrShortStc4 = ['不明', 'ＨＢｓ', 'ＨＣＶ', 'ＶＤＲＬ', 'ＴＰＨＡ', 'ＨＩＶ'];
    // 難聴
    const arrStcCd5 = ['2', '3', '4', '5', '6'];
    const arrShortStc5 = ['左', '右', '両方', 'ろうあ', '補聴器'];
    // 視力
    const arrStcCd6 = ['2', '3', '4', '5', '6', '7', '8', '9'];
    const arrShortStc6 = ['失明左', '失明右', '両失明', '弱視左', '弱視右', '弱視両方', '義眼左', '義眼右'];
    // ペースメーカ
    const arrStcCd7 = ['2'];
    const arrShortStc7 = ['あり'];
    // 義足
    const arrStcCd8 = ['2', '3'];
    const arrShortStc8 = ['義肢装着', '装具装着'];
    // 介護
    const arrStcCd9 = ['2', '3'];
    const arrShortStc9 = ['要・いちご', '車椅子'];
    // アルコール
    const arrStcCd10 = ['2'];
    const arrShortStc10 = ['あり'];
    // 薬アレルギー
    const arrStcCd11 = ['2'];
    const arrShortStc11 = ['あり'];
    // 胃腸手術
    const arrStcCd12 = ['2', '3', '4', '5'];
    const arrShortStc12 = ['胃全摘', '胃亜全摘', 'ストーマ', 'ＧＩ後気分不快'];
    // ボランティア種別
    const arrStcCd13 = ['2', '3', '4'];
    const arrShortStc13 = ['通訳要', '介護用', '通訳＆介護要'];
    // 保健指導
    const arrStcCd14 = ['2'];
    const arrShortStc14 = ['対象'];
    // 個人検査情報
    for (let i = 0; i < perResult.count; i += 1) {
      stcCount = 0;
      const allData = {};
      edtResult.push(perResult.perResultGrp[i].result);
      itemCd.push(perResult.perResultGrp[i].itemcd);
      suffix.push(perResult.perResultGrp[i].suffix);
      switch (perResult.perResultGrp[i].itemcd + perResult.perResultGrp[i].suffix) {
        case arrItemCd[0] + arrSuffix[0]:
          arrStcCd = arrStcCd1;
          arrShortStc = arrShortStc1;
          stcCount = arrStcCd1.length + 1;
          break;
        case arrItemCd[1] + arrSuffix[1]:
          arrStcCd = arrStcCd2;
          arrShortStc = arrShortStc2;
          stcCount = arrStcCd2.length + 1;
          break;
        case arrItemCd[2] + arrSuffix[2]:
          arrStcCd = arrStcCd3;
          arrShortStc = arrShortStc3;
          stcCount = arrStcCd3.length + 1;
          break;
        case arrItemCd[3] + arrSuffix[3]:
          arrStcCd = arrStcCd4;
          arrShortStc = arrShortStc4;
          stcCount = arrStcCd4.length + 1;
          break;
        case arrItemCd[4] + arrSuffix[4]:
          arrStcCd = arrStcCd5;
          arrShortStc = arrShortStc5;
          stcCount = arrStcCd5.length + 1;
          break;
        case arrItemCd[5] + arrSuffix[5]:
          arrStcCd = arrStcCd6;
          arrShortStc = arrShortStc6;
          stcCount = arrStcCd6.length + 1;
          break;
        case arrItemCd[6] + arrSuffix[6]:
          arrStcCd = arrStcCd7;
          arrShortStc = arrShortStc7;
          stcCount = arrStcCd7.length + 1;
          break;
        case arrItemCd[7] + arrSuffix[7]:
          arrStcCd = arrStcCd8;
          arrShortStc = arrShortStc8;
          stcCount = arrStcCd8.length + 1;
          break;
        case arrItemCd[8] + arrSuffix[8]:
          arrStcCd = arrStcCd9;
          arrShortStc = arrShortStc9;
          stcCount = arrStcCd9.length + 1;
          break;
        case arrItemCd[9] + arrSuffix[9]:
          arrStcCd = arrStcCd10;
          arrShortStc = arrShortStc10;
          stcCount = arrStcCd10.length + 1;
          break;
        case arrItemCd[10] + arrSuffix[10]:
          arrStcCd = arrStcCd11;
          arrShortStc = arrShortStc11;
          stcCount = arrStcCd11.length + 1;
          break;
        case arrItemCd[11] + arrSuffix[11]:
          arrStcCd = arrStcCd12;
          arrShortStc = arrShortStc12;
          stcCount = arrStcCd12.length + 1;
          break;
        case arrItemCd[12] + arrSuffix[12]:
          arrStcCd = arrStcCd13;
          arrShortStc = arrShortStc13;
          stcCount = arrStcCd2.length + 1;
          break;
        case arrItemCd[13] + arrSuffix[13]:
          arrStcCd = arrStcCd14;
          arrShortStc = arrShortStc14;
          stcCount = arrStcCd2.length + 1;
          break;
        default:
          i = perResult.count;
          break;
      }

      const item = [];
      for (let z = 0; z < arrStcCd.length; z += 1) {
        const dropdown = {};
        dropdown.value = arrStcCd[z];
        dropdown.name = arrShortStc[z];
        item.push(dropdown);
      }
      allData.item = item;
      allData.result = perResult.perResultGrp[i].result;
      allData.itemname = perResult.perResultGrp[i].itemname;
      allData.names = `edtResult[${i}]`;
      allInfo.push(allData);
    }
    // 病名
    const dspName = [];
    // 罹患年齢
    const dspAge = [];
    // 治癒状態
    const dspStat = [];

    const prepaInfoDisease = [];

    let j = 0;
    // 既往歴情報
    for (let i = 0; i < disease.count; i += 1) {
      dspName.push(null);
      dspAge.push(null);
      dspStat.push(null);
      switch (disease.perResultGrp[i].suffix) {
        case '01':
          if (disease.perResultGrp[i].resulttype === 4) {
            dspName[j] = disease.perResultGrp[i].shortstc;
          } else {
            dspName[j] = disease.perResultGrp[i].result;
          }
          break;
        case '02':
          if (disease.perResultGrp[i].resulttype === 4) {
            dspAge[j] = disease.perResultGrp[i].shortstc;
          } else {
            dspAge[j] = disease.perResultGrp[i].result;
          }
          break;
        case '03':
          if (disease.perResultGrp[i].resulttype === 4) {
            dspStat[j] = disease.perResultGrp[i].shortstc;
          } else {
            dspStat[j] = disease.perResultGrp[i].result;
          }
          j += 1;
          break;
        default:
          i = disease.count;
          break;
      }
    }

    for (let k = 0; k < j; k += 1) {
      const jsonstring = {};
      jsonstring.dspName = dspName[k];
      jsonstring.dspAge = dspAge[k];
      jsonstring.dspStat = dspStat[k];
      jsonstring.key = k;
      prepaInfoDisease.push(jsonstring);
    }

    let bakCslDate = '';
    let bakCsCd = '';
    const prepaInfoCmntHis = [];

    // 前回総合コメント情報
    for (let i = 0; i < cmntHis.length; i += 1) {
      const arrcmntHis = {};
      const arrcsldate = [];
      const arrcscd = [];
      const arrjudcmtstc = [];
      if (bakCslDate !== cmntHis[i].csldate) {
        arrcsldate.push(moment(cmntHis[i].csldate).format('M-D-YYYY'));
        bakCslDate = cmntHis[i].csldate;
      }

      if (bakCsCd !== cmntHis[i].cscd) {
        arrcscd.push(cmntHis[i].csname);
        bakCsCd = cmntHis[i].cscd;
      }
      arrjudcmtstc.push(cmntHis[i].judcmtstc);
      arrcmntHis.csldate = arrcsldate;
      arrcmntHis.cscd = arrcscd;
      arrcmntHis.judcmtstc = arrjudcmtstc;
      prepaInfoCmntHis.push(arrcmntHis);
    }

    const prepaInfoReexamin = [];
    const prepaInfoSecond = [];

    return { ...state, prepaInfo: { ...prepaInfo, consult, org, perResult, prepaInfoReexamin, prepaInfoSecond, prepaInfoDisease, prepaInfoCmntHis, allInfo, edtResult, stcCount } };
  },
  // 問診入力の初期化を取得失敗時の処理
  [loadPreparationInfoFailure]: (state, action) => {
    const { prepaInfo } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // 個人検査結果テーブルを登録または更新を取得成功時の処理
  [mergePerResultSuccess]: (state) => {
    const { prepaInfo } = state;
    const message = ['保存に成功しました。'];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // 個人検査結果テーブルを登録または更新を処理失敗時の処理
  [mergePerResultFailure]: (state) => {
    const { prepaInfo } = state;
    const message = ['保存に失敗しました。'];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // 個人検査結果テーブルを削除を取得成功時の処理
  [deletePerResultSuccess]: (state) => {
    // 可視状態をtrueにする
    const { prepaInfo } = state;
    const message = ['保存に成功しました。'];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // 個人検査結果テーブルを削除を処理失敗時の処理
  [deletePerResultFailure]: (state) => {
    const { prepaInfo } = state;
    const message = ['保存に失敗しました。'];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // 来院情報設定を開くアクション時の処理
  [openEditWelComeInfoGuide]: (state, action) => {
    // 可視状態をtrueにする
    const { editWelComeInfoGuide } = state;
    const { welComeInfoMenuGuide } = state;
    const pagestats = 3;
    const { rsvno, mode } = action.payload;
    return { ...state, editWelComeInfoGuide: { ...editWelComeInfoGuide, rsvno, mode }, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, pagestats, mode } };
  },
  // 来院情報設定を閉じるアクション時の処理
  [closeEditWelComeInfoGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { editWelComeInfoGuide } = initialState;
    const { welComeInfoMenuGuide } = state;
    const pagestats = 2;
    return { ...state, editWelComeInfoGuide, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, pagestats } };
  },
  // 来院情報更新成功時の処理
  [updateWelComeInfoSuccess]: (state) => {
    const { editWelComeInfoGuide } = state;
    const { welComeInfoMenuGuide } = state;
    const visible = false;
    const pagestats = 2;
    return {
      ...state, editWelComeInfoGuide: { ...editWelComeInfoGuide, visible }, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, pagestats, visible: true },
    };
  },
  // 来院情報更新失敗時の処理
  [updateWelComeInfoFailure]: (state, action) => {
    const { editWelComeInfoGuide } = state;
    const { status, data, visitstatus, visiterror } = action.payload;
    let message = [];
    if (status) {
      if (status === 404) {
        // 更新の来院情報が存在しません
        message = ['更新の来院情報が存在しません。'];
      } else if (status === 400 || status === 500) {
        // 更新リクエスト不正
        message = [data.errors];
      }
    }
    return { ...state, editWelComeInfoGuide: { ...editWelComeInfoGuide, message, visitstatus, visiterror } };
  },
  // 来院情報検索成功時の処理
  [getWelComeInfoSuccess]: (state, action) => {
    const { editWelComeInfoGuide } = state;
    const data = action.payload;

    let welcomeflag;
    if (data.comedate != null) {
      welcomeflag = 1;
    } else {
      welcomeflag = 2;
    }
    return { ...state, editWelComeInfoGuide: { ...editWelComeInfoGuide, data, welcomeflag } };
  },
  // 来院情報検索失敗時の処理
  [getWelComeInfoFailure]: (state, action) => {
    const { editWelComeInfoGuide } = state;
    let message = [];
    const { error, rsvno } = action.payload;
    // HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (error.status === 404) {
      message = [`来院情報が存在しません。（予約番号 = ${rsvno})`];
    }
    return { ...state, editWelComeInfoGuide: { ...editWelComeInfoGuide, message } };
  },
  // 来院処理を開くアクション時の処理
  [openReceiptFrontDoorGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { receiptFrontDoorGuide } = state;
    const { ocrno, guidanceno } = action.payload;
    return { ...state, receiptFrontDoorGuide: { ...receiptFrontDoorGuide, visible, ocrno, guidanceno } };
  },
  // 来院処理を閉じるアクション時の処理
  [closeReceiptFrontDoorGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { receiptFrontDoorGuide } = initialState;
    return { ...state, receiptFrontDoorGuide };
  },
  // 来院処理失敗時の処理
  [registerWelComeInfoFailure]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { receiptFrontDoorGuide } = state;
    const { message, errstauts, realagetxt } = action.payload;
    const data = action.payload;

    // 当日ＩＤ
    let dayidtxt = null;
    // 来院情報
    let comedatetxt = null;
    // 受診日
    let csldatetxt = null;
    if (data.getdata != null) {
      if (data.getdata.dayid === null) {
        dayidtxt = '未受付';
      } else {
        dayidtxt = data.getdata.dayid;
        const len = 4 - data.getdata.dayid.toString().length;
        if (len === 1) {
          dayidtxt = `0${dayidtxt}`;
        } else if (len === 2) {
          dayidtxt = `00${dayidtxt}`;
        } else if (len === 3) {
          dayidtxt = `000${dayidtxt}`;
        }
      }

      if (data.getdata.comedate === null) {
        comedatetxt = '未来院';
      } else {
        comedatetxt = '来院済み';
      }

      if (data.getdata.csldate != null) {
        csldatetxt = moment(data.csldate).format('YYYY/MM/DD');
      }
    }

    return { ...state, receiptFrontDoorGuide: { ...receiptFrontDoorGuide, visible, message, errstauts, data: data.getdata, personInfo: data.getdata, dayidtxt, comedatetxt, csldatetxt, realagetxt } };
  },
  // 検索条件を満たす受診者の一覧を取得する
  [getConsultListItemRequest]: (state, action) => {
    const { itemList } = state;
    // 検索条件を更新する
    const modelInfo = action.payload.data;
    return { ...state, itemList: { ...itemList, modelInfo, isLoading: true } };
  },

  [getConsultStepList]: (state) => {
    const { itemList } = initialState;
    const cslDate = '';
    const grpcd = '';
    const dayIdF = '';
    const dayIdT = '';
    const cscd = '';
    return { ...state, itemList: { ...itemList, cslDate, grpcd, cscd, dayIdF, dayIdT } };
  },

  // 検索条件を満たす受診者の一覧を取得成功
  [getConsultListItemSuccess]: (state, action) => {
    const { itemList } = state;
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    if (action.payload.checkParam) {
      const { cscd, cslDate, grpcd, dayIdF, dayIdT } = action.payload.checkParam;
      let { allResultClear } = action.payload.checkParam;
      if (allResultClear && allResultClear === 1) {
        allResultClear = [1];
      } else {
        allResultClear = [null];
      }
      return { ...state, itemList: { ...itemList, modelInfo: data, cscd, cslDate, grpcd, dayIdF, dayIdT, allResultClear, isLoading: false } };
    }
    return { ...state, itemList: { ...itemList, modelInfo: data, isLoading: false } };
  },
  // 検索条件を満たす受診者の一覧を取得失败
  [getConsultListItemFailure]: (state, action) => {
    const { cscd, cslDate, grpcd, dayIdF, dayIdT } = action.payload;
    const { itemList } = state;
    // (これに伴い一覧が再描画される)
    const message = [];
    return { ...state, itemList: { ...itemList, cscd, cslDate, grpcd, dayIdF, dayIdT, message, isLoading: false } };
  },

  // 検索条件を満たす受診者の一覧を校验失败
  [getConsultListCheckFailure]: (state, action) => {
    const { cscd, cslDate, grpcd, dayIdF, dayIdT, message } = action.payload;
    const { itemList } = state;
    return { ...state, itemList: { ...itemList, cscd, cslDate, grpcd, dayIdF, dayIdT, message, isLoading: false } };
  },

  [openReceiptMainGuide]: (state, action) => {
    const visible = true;
    const { welComeInfoMenuGuide } = state;
    const { receiptMainGuide } = state;
    const { rsvno } = action.payload;
    // 来院確認可視
    const pagestats = 2;
    return { ...state, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, pagestats, visible }, receiptMainGuide: { ...receiptMainGuide, rsvno } };
  },
  // 来院処理を閉じるアクション時の処理
  [closeReceiptMainGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { receiptMainGuide } = initialState;
    return { ...state, receiptMainGuide };
  },

  // ガイドを閉じるアクション時の処理
  [closeWelComeInfoMenuGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { welComeInfoMenuGuide } = initialState;
    return { ...state, welComeInfoMenuGuide };
  },

  // ガイドを開くアクション時の処理
  [openWelComeInfoMenuGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { welComeInfoMenuGuide } = state;
    const { ocrno, guidanceno } = action.payload;
    return { ...state, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, visible, ocrno, guidanceno } };
  },
  // 来院確認成功時の処理
  [loadPeceiptMainSuccess]: (state, action) => {
    const { receiptMainGuide } = state;
    const { welComeInfoMenuGuide } = state;
    const { data, realagetxt, message } = action.payload;

    // 当日ＩＤ
    let dayidtxt = null;
    if (data != null) {
      if (data.getwelcomedata != null) {
        if (data.getwelcomedata.dayid === null) {
          dayidtxt = '未受付';
        } else {
          dayidtxt = data.getwelcomedata.dayid;
          const len = 4 - data.getwelcomedata.dayid.toString().length;
          if (len === 1) {
            dayidtxt = `0${dayidtxt}`;
          } else if (len === 2) {
            dayidtxt = `00${dayidtxt}`;
          } else if (len === 3) {
            dayidtxt = `000${dayidtxt}`;
          }
        }
      }
    }
    const pagestats = 2;
    return { ...state, receiptMainGuide: { ...receiptMainGuide, data, dayidtxt, message, realagetxt, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, pagestats } } };
  },
  // 来院確認失敗時の処理
  [loadPeceiptMainFailure]: (state, action) => {
    const { receiptMainGuide } = state;
    const { welComeInfoMenuGuide } = state;
    const { data, message, realagetxt } = action.payload;

    // 当日ＩＤ
    let dayidtxt = null;
    if (data != null) {
      if (data.getwelcomedata != null) {
        if (data.getwelcomedata.dayid === null) {
          dayidtxt = '未受付';
        } else {
          dayidtxt = data.getwelcomedata.dayid;
          const len = 4 - data.getwelcomedata.dayid.toString().length;
          if (len === 1) {
            dayidtxt = `0${dayidtxt}`;
          } else if (len === 2) {
            dayidtxt = `00${dayidtxt}`;
          } else if (len === 3) {
            dayidtxt = `000${dayidtxt}`;
          }
        }
      }
    }
    const pagestats = 2;
    return { ...state, receiptMainGuide: { ...receiptMainGuide, data, message, dayidtxt, realagetxt, welComeInfoMenuGuide: { ...welComeInfoMenuGuide, pagestats } } };
  },
  // 来院処理の初期化
  [loadReceiptFrontDoorInfo]: (state) => {
    const { receiptFrontDoorGuide } = initialState;
    return { ...state, receiptFrontDoorGuide };
  },
  // 指定契約パターンの全オプション検査を取得成功時の処理
  [getCtrPtOptFromConsultSuccess]: (state, action) => {
    const { changeOptionGuide } = state;
    const { optfromconsultdata, optiondata } = action.payload;
    return { ...state, changeOptionGuide: { ...changeOptionGuide, optfromconsultdata, optiondata } };
  },
  // 結果コメント情報を取得成功時の処理
  [getRslCmtListForChangeSetSuccess]: (state, action) => {
    const { changeOptionGuide } = state;
    const { changesetdata, rsvno } = action.payload;
    return { ...state, changeOptionGuide: { ...changeOptionGuide, changesetdata, rsvno } };
  },
  // 結果コメント情報のクリア
  [clearRslCmtInfo]: (state, action) => {
    const { changeOptionGuide } = state;
    const { index } = action.payload;
    const { changesetdata } = changeOptionGuide;
    const { rslcmtname, rslcmtcd } = changesetdata;
    const namedata = rslcmtname.slice(0);
    const cddata = rslcmtcd.slice(0);
    let { flg } = changeOptionGuide;
    namedata[index] = '';
    cddata[index] = '';
    flg += 1;
    return { ...state, changeOptionGuide: { ...changeOptionGuide, flg, changesetdata: { ...changesetdata, rslcmtname: namedata, rslcmtcd: cddata } } };
  },
  // 検査中止情報の更新保存成功時の処理
  [updateResultForChangeSetSuccess]: (state) => {
    const { changeOptionGuide } = state;
    const message = ['保存が完了しました。'];
    return { ...state, changeOptionGuide: { ...changeOptionGuide, message } };
  },
  // 受診セット変更ガイドを開くアクション時の処理
  [openChangeOptionGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { changeOptionGuide } = initialState;
    return { ...state, changeOptionGuide: { ...changeOptionGuide, visible } };
  },
  // 受診セット変更ガイドを閉じるアクション時の処理
  [closeChangeOptionGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { changeOptionGuide } = initialState;
    return { ...state, changeOptionGuide };
  },
}, initialState);
