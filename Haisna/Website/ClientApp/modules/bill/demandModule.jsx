import { createActions, handleActions } from 'redux-actions';
import Moment from 'moment';
// actionの作成
export const {
  // 請求明細登録・修正
  deleteBillLineRequest,
  deleteBillLineSuccess,
  deleteBillLineFailure,
  saveBillDetailRequest,
  saveBillDetailSuccess,
  saveBillDetailFailure,
  openDmdEditBillLineRequest,
  openDmdEditBillLineSuccess,
  openDmdEditBillLineFailure,
  closeDmdEditBillLine,
  // 請求書基本情報登録
  getNowTaxRequest,
  getNowTaxFailure,
  dmdOrgMasterBurdenRequest,
  dmdOrgMasterBurdenSuccess,
  dmdOrgMasterBurdenFailure,
  getNowTaxSuccess,
  openDmdOrgMasterBurden,
  closeDmdOrgMasterBurden,
  // 個人受診金額情報
  getPaymentRequest,
  getPaymentSuccess,
  getPaymentFailure,
  getPersonalCloseMngInfoFailure,
  registerPerbillRequest,
  registerPerbillSuccess,
  registerPerbillFailure,
  registerDelDspRequest,
  registerDelDspSuccess,
  registerDelDspFailure,
  openCreatePerBillGuideRequest,
  openCreatePerBillGuideSuccess,
  openCreatePerBillGuideFailure,
  closeCreatePerBillGuide,
  changeFlg,
  chgCheckvalue,
  // 請求書削除
  initializeDelAllBill,
  deleteAllBillRequest,
  deleteAllBillSuccess,
  deleteAllBillFailure,
  //
  initializeDmdBurdenList,
  //
  getDmdBurdenListRequest,
  getDmdBurdenListSuccess,
  getDmdBurdenListFailure,
  //
  getDmdPaymentBillSumRequest,
  getDmdPaymentBillSumSuccess,
  getDmdPaymentBillSumFailure,
  // ２次検査の合計金額追加追加
  getSumDetailItemsRequest,
  getSumDetailItemsSuccess,
  getSumDetailItemsFailure,
  //
  getDmdPaymentPriceRequest,
  getDmdPaymentPriceSuccess,
  getDmdPaymentPriceFailure,
  //
  getDmdPaymentRequest,
  getDmdPaymentSuccess,
  getDmdPaymentFailure,
  //
  registerPaymentRequest,
  registerPaymentSuccess,
  registerPaymentFailure,
  updatePaymentSuccess,
  updatePaymentFailure,
  //
  deletePaymentRequest,
  deletePaymentSuccess,
  deletePaymentFailure,
  //
  openDmdPaymentGuide,
  closeDmdPaymentGuide,
  loadDmdPaymentGuideData,
  loadDmdPaymentData,
  initializePayment,
  getPaymentErrorMessage,
  getDmdBurdenListMessage,
  //
  getSumRecordFailure,
  getDmdBurdenFailure,
  getDmdListRequest,
  getDmdListSuccess,
  getDmdListFailure,
  getDmdDetailItm,
  getDmdCountFailure,
  getDmdRecordSuccess,
  getDmdRecordFailure,
  getDmdCommentRequest,
  getDmdCommentSuccess,
  getDmdCommentFailure,
  getDmdDetailListRequest,
  getDmdDetailListSuccess,
  getDmdDetailListFailure,
  deleteDmdRequest,
  deleteDmdSuccess,
  deleteDmdFailure,
  openDmdCommentGuide,
  closeDmdCommentGuide,
  openDmdBurdenModifyGuide,
  closeDmdBurdenModifyGuide,
  getOpenDmdBurdenModifyGuideSuccess,
  getOpenDmdBurdenModifyGuideFailure,
  openDmdDetailItmListGuide,
  closeDmdDetailItmListGuide,
  //
  initializDemandList,
  getDispatchSeqRequest,
  getDispatchSeqSuccess,
  getDispatchSeqFailure,
  deleteDispatchRequest,
  deleteDispatchSuccess,
  deleteDispatchFailure,
  updateDispatchRequest,
  updateDispatchSuccess,
  updateDispatchFailure,
  insertDispatchRequest,
  insertDispatchSuccess,
  insertDispatchFailure,
  checkValueSendCheckDayRequest,
  checkValueSendCheckDaySuccess,
  checkValueSendCheckDayFailure,
  getDmdEditDetailItemLineRequest,
  getDmdEditDetailItemLineSuccess,
  getDmdEditDetailItemLineFailure,
  registerDmdEditDetailItemLineRequest,
  registerDmdEditDetailItemLineSuccess,
  registerDmdEditDetailItemLineFailure,
  deleteDmdEditDetailItemLineRequest,
  deleteDmdEditDetailItemLineSuccess,
  deleteDmdEditDetailItemLineFailure,
  openDmdEditDetailItemLine,
  closeDmdEditDetailItemLine,
  selectSecGuide,
  deleteSelectSec,

} = createActions(
  // 請求明細登録・修正
  'DELETE_BILL_LINE_REQUEST',
  'DELETE_BILL_LINE_SUCCESS',
  'DELETE_BILL_LINE_FAILURE',
  'SAVE_BILL_DETAIL_REQUEST',
  'SAVE_BILL_DETAIL_SUCCESS',
  'SAVE_BILL_DETAIL_FAILURE',
  'OPEN_DMD_EDIT_BILL_LINE_REQUEST',
  'OPEN_DMD_EDIT_BILL_LINE_SUCCESS',
  'OPEN_DMD_EDIT_BILL_LINE_FAILURE',
  'CLOSE_DMD_EDIT_BILL_LINE',
  // 請求書基本情報登録
  'GET_NOW_TAX_REQUEST',
  'GET_NOW_TAX_FAILURE',
  'DMD_ORG_MASTER_BURDEN_REQUEST',
  'DMD_ORG_MASTER_BURDEN_SUCCESS',
  'DMD_ORG_MASTER_BURDEN_FAILURE',
  'GET_NOW_TAX_SUCCESS',
  'OPEN_DMD_ORG_MASTER_BURDEN',
  'CLOSE_DMD_ORG_MASTER_BURDEN',
  // 個人受診金額情報
  'GET_PAYMENT_REQUEST',
  'GET_PAYMENT_SUCCESS',
  'GET_PAYMENT_FAILURE',
  'GET_PERSONAL_CLOSE_MNG_INFO_FAILURE',
  'REGISTER_PERBILL_REQUEST',
  'REGISTER_PERBILL_SUCCESS',
  'REGISTER_PERBILL_FAILURE',
  'REGISTER_DEL_DSP_REQUEST',
  'REGISTER_DEL_DSP_SUCCESS',
  'REGISTER_DEL_DSP_FAILURE',
  'OPEN_CREATE_PER_BILL_GUIDE_REQUEST',
  'OPEN_CREATE_PER_BILL_GUIDE_SUCCESS',
  'OPEN_CREATE_PER_BILL_GUIDE_FAILURE',
  'CLOSE_CREATE_PER_BILL_GUIDE',
  'CHANGE_FLG',
  'CHG_CHECKVALUE',
  // 初期化
  'INITIALIZE_DEL_ALL_BILL',
  'DELETE_ALL_BILL_REQUEST',
  'DELETE_ALL_BILL_SUCCESS',
  'DELETE_ALL_BILL_FAILURE',
  'INITIALIZE_DMD_BURDEN_LIST',
  // 一覧用
  'GET_DMD_BURDEN_LIST_REQUEST',
  'GET_DMD_BURDEN_LIST_SUCCESS',
  'GET_DMD_BURDEN_LIST_FAILURE',
  //
  'GET_DMD_PAYMENT_BILL_SUM_REQUEST',
  'GET_DMD_PAYMENT_BILL_SUM_SUCCESS',
  'GET_DMD_PAYMENY_BILL_SUM_FAILURE',
  // ２次検査の合計金額追加追加
  'GET_SUM_DETAIL_ITEMS_REQUEST',
  'GET_SUM_DETAIL_ITEMS_SUCCESS',
  'GET_SUM_DETAIL_ITEMS_FAILURE',
  //
  'GET_DMD_PAYMENT_PRICE_REQUEST',
  'GET_DMD_PAYMENT_PRICE_SUCCESS',
  'GET_DMD_PAYMENT_PRICE_FAILURE',
  //
  'GET_DMD_PAYMENT_REQUEST',
  'GET_DMD_PAYMENT_SUCCESS',
  'GET_DMD_PAYMENT_FAILURE',
  // 入金処理更新
  'REGISTER_PAYMENT_REQUEST',
  'REGISTER_PAYMENT_SUCCESS',
  'REGISTER_PAYMENT_FAILURE',
  'UPDATE_PAYMENT_SUCCESS',
  'UPDATE_PAYMENT_FAILURE',
  // 入金処理削除
  'DELETE_PAYMENT_REQUEST',
  'DELETE_PAYMENT_SUCCESS',
  'DELETE_PAYMENT_FAILURE',
  // 入金処理
  'OPEN_DMD_PAYMENT_GUIDE',
  'CLOSE_DMD_PAYMENT_GUIDE',
  'LOAD_DMD_PAYMENT_GUIDE_DATA',
  'LOAD_DMD_PAYMENT_DATA',
  'INITIALIZE_PAYMENT',
  'GET_PAYMENT_ERROR_MESSAGE',
  'GET_DMD_BURDEN_LIST_MESSAGE',

  // 取得
  'GET_SUM_RECORD_FAILURE',
  'GET_DMD_BURDEN_FAILURE',
  'GET_DMD_LIST_REQUEST',
  'GET_DMD_LIST_SUCCESS',
  'GET_DMD_LIST_FAILURE',
  'GET_DMD_DETAIL_ITM',
  'GET_DMD_COUNT_FAILURE',
  'GET_DMD_RECORD_SUCCESS',
  'GET_DMD_RECORD_FAILURE',
  'GET_DMD_COMMENT_REQUEST',
  'GET_DMD_COMMENT_SUCCESS',
  'GET_DMD_COMMENT_FAILURE',
  'GET_DMD_DETAIL_LIST_REQUEST',
  'GET_DMD_DETAIL_LIST_SUCCESS',
  'GET_DMD_DETAIL_LIST_FAILURE',
  'DELETE_DMD_REQUEST',
  'DELETE_DMD_SUCCESS',
  'DELETE_DMD_FAILURE',
  // 請求書コメント
  'OPEN_DMD_COMMENT_GUIDE',
  'CLOSE_DMD_COMMENT_GUIDE',
  // 請求書基本情報
  'OPEN_DMD_BURDEN_MODIFY_GUIDE',
  'CLOSE_DMD_BURDEN_MODIFY_GUIDE',
  'GET_OPEN_DMD_BURDEN_MODIFY_GUIDE_SUCCESS',
  'GET_OPEN_DMD_BURDEN_MODIFY_GUIDE_FAILURE',
  // 請求書基本情報（２次内訳）
  'OPEN_DMD_DETAIL_ITM_LIST_GUIDE',
  'CLOSE_DMD_DETAIL_ITM_LIST_GUIDE',
  'INITIALIZ_DEMAND_LIST',
  'GET_DISPATCH_SEQ_REQUEST',
  'GET_DISPATCH_SEQ_SUCCESS',
  'GET_DISPATCH_SEQ_FAILURE',
  'Delete_DISPATCH_REQUEST',
  'Delete_DISPATCH_SUCCESS',
  'Delete_DISPATCH_FAILURE',
  'UPDATE_DISPATCH_REQUEST',
  'UPDATE_DISPATCH_SUCCESS',
  'UPDATE_DISPATCH_FAILURE',
  'INSERT_DISPATCH_REQUEST',
  'INSERT_DISPATCH_SUCCESS',
  'INSERT_DISPATCH_FAILURE',
  'CHECK_VALUE_SEND_CHECK_DAY_REQUEST',
  'CHECK_VALUE_SEND_CHECK_DAY_SUCCESS',
  'CHECK_VALUE_SEND_CHECK_DAY_FAILURE',
  // ２次内訳一覧用
  'GET_DMD_EDIT_DETAIL_ITEM_LINE_REQUEST',
  'GET_DMD_EDIT_DETAIL_ITEM_LINE_SUCCESS',
  'GET_DMD_EDIT_DETAIL_ITEM_LINE_FAILURE',
  // ２次内訳登録・修正
  'REGISTER_DMD_EDIT_DETAIL_ITEM_LINE_REQUEST',
  'REGISTER_DMD_EDIT_DETAIL_ITEM_LINE_SUCCESS',
  'REGISTER_DMD_EDIT_DETAIL_ITEM_LINE_FAILURE',
  // ２次内訳削除
  'DELETE_DMD_EDIT_DETAIL_ITEM_LINE_REQUEST',
  'DELETE_DMD_EDIT_DETAIL_ITEM_LINE_SUCCESS',
  'DELETE_DMD_EDIT_DETAIL_ITEM_LINE_FAILURE',
  'OPEN_DMD_EDIT_DETAIL_ITEM_LINE',
  'CLOSE_DMD_EDIT_DETAIL_ITEM_LINE',
  'SELECT_SEC_GUIDE',
  'DELETE_SELECT_SEC',
);

// stateの初期値
const initialState = {
  dmdEditBillLine: {
    conditions: {
      CslDate: Moment().format('YYYY/MM/DD'),
      Price: 0,
      EditPrice: 0,
      TaxPrice: 0,
      EditTax: 0,
    },
    sumPrice: {},
    strNoEditFlg: 0,
    strLineNo: '',
    count: [
      {
        dispatch_cnt: '',
        payment_cnt: '',
      },
    ],
    record: [],
    message: [],
    billDetail: [
      {
        csldate: '',
        orgname: '',
      },
    ],
    params: {
      BillNo: '',
      LineNo: '',
    },
    visible: false, // 可視状態
  },
  payment: {
    message: [],
    data: {
      paymentInfo: {},
      paymentList: [],
      paymentConsultInfo: [],
      paymentConsultTotal: [],
      consultmTotal: [],
      perCloseMngInfo: [],
    },
    delDsp: 0,
  },

  perBillGuide: {
    message: [],
    // 以下一覧用
    data: {
      payment: {},
      consultmInfo: [],
    },
    // 以下ガイド用
    visible: false, // 可視状態
    flg: 0,
  },
  // --
  demandDelete: {
    message: [],
    err: '',
    conditions: {
      closeDate: Moment().format('YYYY/MM/DD'),
      orgCd1: '',
      orgCd2: '',
      orgname: '',
    },
  },
  dmdBurdenList: {
    message: [],
    conditions: {
      strDate: Moment().format('YYYY/MM/DD'),
      endDate: Moment().format('YYYY/MM/DD'),
      billNo: '',
      orgCd1: '',
      orgCd2: '',
      isDispatch: 0,
      isPayment: 0,
      isCancel: null,
      startPos: 1,
      getCount: 10,
      page: 1,
      sortName: null,
      sortType: null,
      orgname: '',
    },
    allCount: null,
    burdenlist: [],
    isLoading: false,
  },
  dmdPaymentGuide: {
    message: [],
    data: {},
    dataDPP: {},
    dataPay: {},
    dataDPBS: { lngDelFlg: 0 },
    rec: {
      flgNoInput: 0,
      lngPaymentYear: 0,
      lngPaymentMonth: 0,
      lngPaymentDay: 0,
    },
    re: {
      lngCloseYear: 0,
      lngCloseMonth: 0,
      lngCloseDay: 0,
      lngBillSeq: 0,
      lngBranchNo: 0,
      lngDelFlg: 0,
    },
    dataDetail: [],
    visible: false, // 可視状態
    strDispCharge: null,
  },
  dmdOrgMasterBurden: {
    messages: [],
    visible: false, // 可視状態
    billNo: '',
    conditions: {
      closeDate: Moment().format('YYYY/MM/DD'),
      prtDate: Moment().format('YYYY/MM/DD'),
      orgCd1: '',
      orgCd2: '',
      taxRates: 0.00,
      secondFlg: 0,
    },
  },
  dmdBurdenModify: {
    billNo: '',
    visible: false, // 可視状態
    lngCount: [
      {
        delflg: 0,
      },
    ],
    dispTaxTotal: 0,
    billTotal: 0,
    sumRecord: [],
    totalCount: 0,
    billComment: '',
    message: [],
    data: [
      {
        delflg: 0,
      },
    ],
    details: [],
    count: [],
    record: [],
    Total: {},
    detail: [],
    conditions: {
      page: 1,
      limit: 10,
    },
    act: '',
  },

  dmdGuide: {
    message: [],
    // 以下一覧用
    conditions: {
      keyword: '',
      page: 1,
      limit: 20,
    }, // 検索条件
    data: [],
    // 以下ガイド用
    visible: false, // 可視状態
    searched: false,
    selectedItem: undefined, // 選択された要素
    billNo: '',
  },
  dmdDetailItm: {
    dispPriceTotals: 0,
    dispBillTotals: 0,
    billTotal: 0,
    detailList: [],
    data: [],
    dispTaxTotal: 0,
    message: [],
    record: [],
    lngCount: [],
    totalCount: 0,
    conditions: {
      page: 1,
      limit: 10,
    },
  },
  // 請求書基本情報
  dmdBurdenModifyGuide: {
    visible: false, // 可視状態
    searched: false,
    selectedItem: undefined, // 選択された要素
  },
  // 請求書基本情報（２次内訳）
  dmdDetailItmListGuide: {
    visible: false, // 可視状態
    searched: false,
    selectedItem: undefined, // 選択された要素
  },
  demandList: {
    conditions: {
      sendTime: Moment().format('YYYY/MM/DD'),
    },
    billNo: [{
      orgName: '',
    }],
  },

  demandDetailList: {
    message: [],
    // 以下一覧用
    conditions: {
      closeDate: Moment().format('YYYY/MM/DD'),
      limit: 0,
      page: 1,
    }, // 検索条件
    data: [],
  },
  dmdEditDetailItemLine: {
    conditions: {
      orgName: '',
      cslDate: Moment().format('YYYY年MM月DD日'),
      startpos: 1,
      getCount: 10,
      price: 0,
      taxPrice: 0,
      selectedItem: null,
    },
    datax: {
      LineNo: '',
    },
    datay: {},
    dataCount: [
      {
        method: 0,
      },
    ],
    deleted: '',
    message: [],
    isErr: '',
    visible: false,
  },
};

// reducerの作成
export default handleActions({
  // 請求書明細削除失敗時の処理
  [deleteBillLineFailure]: (state, action) => {
    const { dmdEditBillLine } = state;
    const { status, data } = action.payload;

    let message = data;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['請求明細の削除に失敗しました。'];
    }
    return { ...state, dmdEditBillLine: { ...dmdEditBillLine, message } };
  },
  // 登録・修正に成功
  [saveBillDetailSuccess]: (state) => {
    const { dmdEditBillLine } = state;
    const message = ['保存が完了しました。'];
    const visible = false;
    return { ...state, dmdEditBillLine: { ...dmdEditBillLine, message, visible } };
  },
  // 登録・修正失敗時の処理
  [saveBillDetailFailure]: (state, action) => {
    const { dmdEditBillLine } = state;
    const { data } = action.payload;
    let message;
    if (data == null) {
      message = ['請求明細の更新に失敗しました。'];
    } else {
      message = data;
    }

    return { ...state, dmdEditBillLine: { ...dmdEditBillLine, message } };
  },
  // 請求明細登録・修正取得成功時の処理
  [openDmdEditBillLineSuccess]: (state, action) => {
    const { dmdEditBillLine } = state;
    // 請求書明細
    const billDetail = action.payload.payload;
    // 入金済み、発送済みチェック
    const { count } = action.payload.payloadCount;
    // ２次検査合計金額の追加
    const { record } = action.payload.payloadRecord;

    const { strNoEditFlg, message, sumPrice } = action.payload;
    return { ...state, dmdEditBillLine: { ...dmdEditBillLine, billDetail, count, record, strNoEditFlg, message, sumPrice } };
  },
  // ガイドを開くアクション時の処理
  [openDmdEditBillLineRequest]: (state, action) => {
    const { dmdEditBillLine } = initialState;
    const { BillNo, LineNo } = action.payload;
    const params = { BillNo, LineNo };

    // 可視状態をtrueにする
    const visible = true;
    const message = [];
    let strLineNo;
    if (LineNo !== null) {
      strLineNo = LineNo;
    }

    return { ...state, dmdEditBillLine: { ...dmdEditBillLine, visible, params, message, strLineNo } };
  },
  [closeDmdEditBillLine]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { dmdEditBillLine } = initialState;

    return { ...state, dmdEditBillLine: { ...dmdEditBillLine } };
  },
  // 請求書基本情報登録成功時の処理
  [dmdOrgMasterBurdenSuccess]: (state, action) => {
    const { dmdOrgMasterBurden } = state;
    const billNo = action.payload;
    const visible = false;
    const messages = ['保存が完了しました。'];
    return { ...state, dmdOrgMasterBurden: { ...dmdOrgMasterBurden, messages, visible, billNo } };
  },
  // 請求書基本情報登録失敗時の処理
  [dmdOrgMasterBurdenFailure]: (state, action) => {
    const { dmdOrgMasterBurden } = state;
    const { data } = action.payload;
    const messages = data;
    return { ...state, dmdOrgMasterBurden: { ...dmdOrgMasterBurden, messages } };
  },
  [closeDmdOrgMasterBurden]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { dmdOrgMasterBurden } = initialState;
    return { ...state, dmdOrgMasterBurden };
  },
  // ガイドを開くアクション時の処理
  [openDmdOrgMasterBurden]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { dmdOrgMasterBurden } = initialState;
    return { ...state, dmdOrgMasterBurden: { ...dmdOrgMasterBurden, visible } };
  },
  // 適用税率取得成功時の処理
  [getNowTaxSuccess]: (state, action) => {
    const { dmdOrgMasterBurden } = initialState;
    const { conditions } = dmdOrgMasterBurden;
    const visible = true;
    const { taxRates } = action.payload;
    return { ...state, dmdOrgMasterBurden: { ...dmdOrgMasterBurden, visible, conditions: { ...conditions, taxRates } } };
  },

  [getPaymentSuccess]: (state, action) => {
    const { payment } = state;
    const data = action.payload;
    return { ...state, payment: { ...payment, data } };
  },

  [getPaymentFailure]: (state, action) => {
    const { payment } = state;
    const { status } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['受診情報が存在しません。'];
    }
    return { ...state, payment: { ...payment, message } };
  },

  [registerPerbillSuccess]: (state) => {
    const { perBillGuide } = state;
    return { ...state, perBillGuide: { ...perBillGuide, visible: false, flg: 0, message: [] } };
  },

  [registerPerbillFailure]: (state, action) => {
    const { perBillGuide } = state;
    const { message } = action.payload;
    return { ...state, perBillGuide: { ...perBillGuide, message } };
  },

  [registerDelDspSuccess]: (state, action) => {
    const { payment } = state;
    const { formValues } = action.payload;
    return { ...state, payment: { ...payment, delDsp: formValues.delDsp } };
  },

  [openCreatePerBillGuideSuccess]: (state, action) => {
    const { perBillGuide } = state;
    const data = action.payload;
    return { ...state, perBillGuide: { ...perBillGuide, data, visible: true } };
  },

  [openCreatePerBillGuideFailure]: (state, action) => {
    const { perBillGuide } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['受診情報が存在しません。'];
    }
    return { ...state, perBillGuide: { ...perBillGuide, message } };
  },

  [closeCreatePerBillGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { perBillGuide } = initialState;
    return { ...state, perBillGuide };
  },

  [changeFlg]: (state) => {
    // 可視状態をtrueにする
    const flg = 1;
    const { perBillGuide } = state;
    return { ...state, perBillGuide: { ...perBillGuide, flg } };
  },
  [chgCheckvalue]: (state, action) => {
    // 可視状態をtrueにする
    const { payment } = state;
    const { value } = action.payload;
    return { ...state, payment: { ...payment, delDsp: value } };
  },
  // 請求書削除画面の初期化
  [initializeDelAllBill]: (state) => {
    const { demandDelete } = initialState;
    return { ...state, demandDelete };
  },
  [deleteAllBillRequest]: (state, action) => {
    const { demandDelete } = state;
    const conditions = action.payload.data;
    if (conditions.closeDate === undefined) {
      conditions.closeDate = Moment().format('YYYY/MM/DD');
    }
    return { ...state, demandDelete: { ...demandDelete, conditions } };
  },
  // 請求書削除成功
  [deleteAllBillSuccess]: (state, action) => {
    const { demandDelete } = state;
    const deleteCount = action.payload;
    const message = [`${deleteCount}件の請求書を削除しました。`];
    return { ...state, demandDelete: { ...demandDelete, message, err: '' } };
  },
  // 請求書削除失敗
  [deleteAllBillFailure]: (state, action) => {
    const { demandDelete } = state;
    const { errorMessage } = action.payload;
    let message = [];
    let err = '';
    if (errorMessage === undefined) {
      const deleteCount = Number(action.payload.data);
      if (deleteCount === 0) {
        message = ['0件の請求書を削除しました。'];
        err = '';
      } else if (deleteCount < 0) {
        message = ['請求書削除処理に失敗しました。'];
        err = '';
      }
    } else {
      message = errorMessage;
      err = 'err';
    }
    return { ...state, demandDelete: { ...demandDelete, message, err } };
  },
  // 一覧初期化処理
  [initializeDmdBurdenList]: (state) => {
    const { dmdBurdenList } = initialState;
    return { ...state, dmdBurdenList };
  },
  // 一覧取得開始時の処理
  [getDmdBurdenListRequest]: (state, action) => {
    const { dmdBurdenList } = state;
    // 検索条件を更新する
    const isLoading = true;
    const conditions = action.payload;
    if (conditions.strDate === undefined) {
      conditions.strDate = Moment().format('YYYY/MM/DD');
      conditions.endDate = Moment().format('YYYY/MM/DD');
      conditions.billNo = '';
      conditions.orgCd1 = '';
      conditions.orgCd2 = '';
      conditions.isDispatch = 0;
      conditions.isPayment = 0;
      conditions.isCancel = null;
      conditions.startPos = 1;
      conditions.getCount = 10;
      conditions.page = 1;
      conditions.sortName = null;
      conditions.sortType = null;
    }

    if (conditions.strDate === '' && conditions.endDate !== '') {
      conditions.strDate = conditions.endDate;
    }
    if (conditions.strDate !== '' && conditions.endDate === '') {
      conditions.endDate = conditions.strDate;
    }

    conditions.startPos = ((conditions.page - 1) * conditions.getCount) + 1;
    return { ...state, dmdBurdenList: { ...dmdBurdenList, conditions, isLoading } };
  },
  // 一覧取得成功時の処理
  [getDmdBurdenListSuccess]: (state, action) => {
    const { dmdBurdenList } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const isLoading = false;
    const message = [];
    const { allCount, burdenlist } = action.payload;
    return { ...state, dmdBurdenList: { ...dmdBurdenList, searched, allCount, burdenlist, message, isLoading } };
  },

  // 失敗時の処理
  [getDmdBurdenListMessage]: (state, action) => {
    const { dmdBurdenList } = state;
    const { Message } = action.payload;
    const message = Message;
    const burdenlist = [];
    const allCount = null;
    const isLoading = false;
    return { ...state, dmdBurdenList: { ...dmdBurdenList, message, burdenlist, allCount, isLoading } };
  },
  // ガイドを開くアクション時の処理
  [openDmdPaymentGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { dmdPaymentGuide } = state;
    const data = action.payload;
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, visible, data } };
  },
  // ガイドを閉じるアクション時の処理
  [closeDmdPaymentGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { dmdPaymentGuide } = initialState;
    return { ...state, dmdPaymentGuide };
  },
  //
  [loadDmdPaymentGuideData]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const rec = action.payload;
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, rec } };
  },
  //
  [loadDmdPaymentData]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const re = action.payload;
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, re } };
  },
  // 個人請求明細情報取得成功時の処理
  [getDmdPaymentBillSumSuccess]: (state, action) => {
    const { dmdPaymentGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const dataDPBS = action.payload;
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, searched, dataDPBS } };
  },
  // 個人請求明細情報が存在しない場合失敗時の処理
  [getDmdPaymentBillSumFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, dataDPBS } = action.payload;
    let message = dataDPBS.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['請求書情報の取得に失敗しました。'];
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message, dataDPBS } };
  },
  // 個人請求明細情報取得成功時の処理
  [getSumDetailItemsSuccess]: (state, action) => {
    const { dmdPaymentGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const dataDetail = action.payload;
    // (これに伴い一覧が再描画される)
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, searched, dataDetail } };
  },
  // 個人請求明細情報が存在しない場合失敗時の処理
  [getSumDetailItemsFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, dataDetail } = action.payload;
    let message = dataDetail.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['請求書情報の取得に失敗しました。'];
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message, dataDetail } };
  },
  // 個人請求明細情報取得成功時の処理
  [getDmdPaymentPriceSuccess]: (state, action) => {
    const { dmdPaymentGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const dataDPP = action.payload;
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, searched, dataDPP } };
  },
  // 個人請求明細情報が存在しない場合失敗時の処理
  [getDmdPaymentPriceFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, dataDPP } = action.payload;
    let message = dataDPP.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['請求書情報の取得に失敗しました。'];
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message, dataDPP } };
  },
  // 個人請求明細情報取得成功時の処理
  [getDmdPaymentSuccess]: (state, action) => {
    const { dmdPaymentGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const dataPay = action.payload;
    let strDispCharge = null;
    if (dataPay.paymentdiv === 1) {
      strDispCharge = Number(dataPay.cash) - Number(dataPay.paymentprice);
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, searched, dataPay, strDispCharge } };
  },
  // 個人請求明細情報が存在しない場合失敗時の処理
  [getDmdPaymentFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, dataPay } = action.payload;
    let message = dataPay.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message, dataPay } };
  },
  // 入金処理更新成功時の処理
  [registerPaymentRequest]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { data } = action.payload;
    let strDispCharge = null;
    if (Number(data.paymentdiv) === 1) {
      strDispCharge = Number(data.cash) - Number(data.paymentprice);
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, strDispCharge } };
  },
  // 入金処理更新失敗時の処理
  [registerPaymentSuccess]: (state) => {
    const { dmdPaymentGuide } = state;
    const message = [];
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },

  // 入金処理更新失敗時の処理
  [registerPaymentFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['入金情報は更新できませんでした'];
    }

    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },
  // 入金処理更新成功時の処理
  [updatePaymentSuccess]: (state) => {
    const { dmdPaymentGuide } = state;
    const message = [];
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },

  // 入金処理更新失敗時の処理
  [updatePaymentFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, data } = action.payload;
    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 400) {
      message = ['入金情報がすでに存在します。'];
    }

    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },
  // 入金処理エラーメッセージを取得
  [getPaymentErrorMessage]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { data } = action.payload;
    const message = data;
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },
  // 入金情報削除成功時の処理
  [deletePaymentSuccess]: (state) => {
    const { dmdPaymentGuide } = initialState;
    const message = ['削除が完了しました。'];
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },
  // 入金情報削除失敗時の処理
  [deletePaymentFailure]: (state, action) => {
    const { dmdPaymentGuide } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['入金情報は削除できませんでした'];
    }
    return { ...state, dmdPaymentGuide: { ...dmdPaymentGuide, message } };
  },
  // 初期化処理
  [initializePayment]: (state) => {
    const { dmdPaymentGuide } = initialState;
    return { ...state, dmdPaymentGuide };
  },

  // 請求書基本情報検索条件を満たすレコード件数を取得成功時の処理
  [getDmdListSuccess]: (state, action) => {
    const { dmdBurdenModify } = state;
    const { data, totalCount, billTotal, dispTaxTotal } = action.payload;
    const details = data;
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, details, data, totalCount, billTotal, dispTaxTotal } };
  },
  [getDmdDetailItm]: (state, action) => {
    const { dmdBurdenModify } = state;
    const { data, allCount } = action.payload;
    const detail = data;
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, detail, allCount } };
  },

  // 請求書基本情報２次検査の合計金額取得成功時の処理
  [getDmdRecordSuccess]: (state, action) => {
    const { dmdBurdenModify } = state;
    let { record } = action.payload;
    if (record) {
      record = [];
    }
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, record, Total: action.payload.Total },
    };
  },
  // 請求書基本情報２次検査の合計金額失败時の処理
  [getDmdRecordFailure]: (state, action) => {
    const { dmdBurdenModify } = state;
    return {
      ...state, dmdBurdenModify: { ...dmdBurdenModify, Total: action.payload.Total },
    };
  },
  // 請求書基本情報（２次内訳）取得成功時の処理
  [getDmdDetailListSuccess]: (state, action) => {
    const { dmdDetailItm } = state;
    const { data, totalCount } = action.payload;
    const detailList = data;
    return { ...state, dmdDetailItm: { ...dmdDetailItm, detailList, totalCount } };
  },
  // 請求書基本情報削除成功時の処理
  [deleteDmdSuccess]: (state, action) => {
    const { dmdBurdenModify } = state;
    const { message, act } = action.payload;
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, message, act } };
  },
  // 請求書基本情報削除失敗時の処理
  [deleteDmdFailure]: (state, action) => {
    const { dmdBurdenModify } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['請求書削除処理に失敗しました'];
    }
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, message } };
  },
  [openDmdCommentGuide]: (state, action) => {
    const { dmdGuide } = initialState;
    // 可視状態をtrueにする
    const visible = true;
    const { params } = action.payload;
    return { ...state, dmdGuide: { ...dmdGuide, visible, billNo: params } };
  },
  // ガイドを閉じるアクション時の処理
  [closeDmdCommentGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { dmdGuide } = initialState;
    return { ...state, dmdGuide };
  },
  // 請求コメント取得成功時の処理
  [getDmdCommentSuccess]: (state, action) => {
    const { dmdBurdenModify } = state;
    const billComment = action.payload[0].billcomment;
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, billComment } };
  },
  // 請求コメント失敗時の処理
  [getDmdCommentFailure]: (state, action) => {
    const { dmdBurdenModify } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['請求書コメント失敗しました。'];
    }
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, message } };
  },
  // 請求書基本情報
  [openDmdBurdenModifyGuide]: (state, action) => {
    const { dmdBurdenModify } = initialState;
    const { billNo, params } = action.payload;
    // 可視状態をtrueにする
    const visible = true;
    const act = '';
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, visible, billNo, act, params } };
  },
  // 請求書基本情報
  [getOpenDmdBurdenModifyGuideSuccess]: (state, action) => {
    const { dmdBurdenModify } = state;
    const {
      billTotal,
      data,
      dispTaxTotal,
      message,
      payloadDmdCount,
      totalCount,
      lngCount,
    } = action.payload;
    const { count } = payloadDmdCount;
    const billComment = lngCount[0].billcomment;
    return { ...state, dmdBurdenModify: { ...dmdBurdenModify, data, count, totalCount, message, billTotal, dispTaxTotal, lngCount, billComment } };
  },
  // ガイドを閉じるアクション時の処理
  [closeDmdBurdenModifyGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { dmdBurdenModify, dmdDetailItm } = initialState;
    return { ...state, dmdBurdenModify, dmdDetailItm };
  },
  // 請求書基本情報（２次内訳）
  [openDmdDetailItmListGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { dmdDetailItmListGuide } = initialState;
    const { billNo, params } = action.payload;
    return { ...state, dmdDetailItmListGuide: { ...dmdDetailItmListGuide, visible, billNo, params, lineNo: params.lineNo } };
  },
  // ガイドを閉じるアクション時の処理
  [closeDmdDetailItmListGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { dmdDetailItmListGuide, dmdDetailItm } = initialState;
    return { ...state, dmdDetailItmListGuide, dmdDetailItm };
  },
  // 請求書発送確認日設定初期化処理
  [initializDemandList]: (state) => {
    const { demandList } = initialState;
    return { ...state, demandList };
  },
  // 削除成功時の処理
  [deleteDispatchSuccess]: (state) => {
    const { demandList } = initialState;
    const message = ['削除が完了しました。'];
    return { ...state, demandList: { ...demandList, message } };
  },
  // 削除失敗時の処理
  [deleteDispatchFailure]: (state, action) => {
    const { demandList } = state;
    const { status, data } = action.payload;

    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }
    return { ...state, demandList: { ...demandList, message } };
  },
  [checkValueSendCheckDaySuccess]: (state, action) => {
    const { demandList } = state;
    const conditions = action.payload;
    const { billNo } = action.payload;
    if (billNo !== null) {
      conditions.closeYear = billNo.substr(0, 4);
      conditions.closeMoth = billNo.substr(4, 2);
      conditions.closeDay = billNo.substr(6, 2);
      conditions.billSeq = billNo.substr(8, 5);
      conditions.branchNo = billNo.substr(13, 1);
      conditions.closeDate = `${conditions.closeYear}/${conditions.closeMoth}/${conditions.closeDay}`;
    }
    return { ...state, demandList: { ...demandList, billNo } };
  },
  // 一覧取得成功時の処理
  [getDmdEditDetailItemLineSuccess]: (state, action) => {
    const { dmdEditDetailItemLine } = state;
    // (これに伴い一覧が再描画される)\
    const dataCount = action.payload;
    let isErr;
    let message;
    const branchNo = dataCount[0].branchno;
    if (branchNo === 1) {
      isErr = 'err';
      message = ['取消済みのため、変更できません'];
    }
    if (state.dmdBurdenModify.count[0].dispatch_cnt > 0 || state.dmdBurdenModify.count[0].payment_cnt > 0) {
      message = ['発送済みまたは入金済みのため、変更できません'];
      isErr = 'err';
    }
    if (dataCount[0].lineno !== '' && null) {
      dmdEditDetailItemLine.conditions.cslDate = Moment(dataCount.csldate).format('YYYY年MM月DD日');
    }
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, dataCount, message, isErr } };
  },
  [getDmdEditDetailItemLineFailure]: (state) => {
    const { dmdEditDetailItemLine } = state;
    // 請求書明細内訳が存在しない場合
    const message = ['該当する請求書が存在しません'];
    const isErr = 'err';
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, message, isErr } };
  },

  [registerDmdEditDetailItemLineSuccess]: (state) => {
    const { dmdDetailItm } = state;
    const detailList = ['aa'];
    const { dmdEditDetailItemLine } = initialState;
    return { ...state, dmdDetailItm: { ...dmdDetailItm, detailList }, dmdEditDetailItemLine: { ...dmdEditDetailItemLine } };
  },
  // ２次内訳情報削除成功時の処理
  [deleteDmdEditDetailItemLineSuccess]: (state) => {
    const { dmdDetailItm } = state;
    const detailList = [];
    const { dmdEditDetailItemLine } = initialState;
    return { ...state, dmdDetailItm: { ...dmdDetailItm, detailList }, dmdEditDetailItemLine: { ...dmdEditDetailItemLine } };
  },
  // 削除に失敗した場合時の処理
  [deleteDmdEditDetailItemLineFailure]: (state) => {
    const { dmdEditDetailItemLine } = state;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    const message = ['請求明細内訳の削除に失敗しました。'];
    const isErr = 'err';
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, message, isErr } };
  },
  // 保存に失敗した場合時の処理
  [registerDmdEditDetailItemLineFailure]: (state, action) => {
    const { dmdEditDetailItemLine } = state;
    let message;
    let isErr;
    if (action.payload.data !== undefined) {
      message = action.payload.data;
    } else {
      message = ['請求明細内訳の更新に失敗しました。'];
      isErr = 'err';
    }
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, message, isErr } };
  },
  [openDmdEditDetailItemLine]: (state, action) => {
    const { dmdEditDetailItemLine } = initialState;
    if (dmdEditDetailItemLine.conditions.selectedItem !== null) {
      dmdEditDetailItemLine.conditions.selectedItem = null;
    }
    const datax = action.payload;
    const datay = {};
    Object.assign(datay, datax);
    const visible = true;
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, datax, datay, visible } };
  },
  [closeDmdEditDetailItemLine]: (state) => {
    const { dmdEditDetailItemLine } = initialState;
    if (dmdEditDetailItemLine.conditions.secondlinedivcd !== undefined) {
      dmdEditDetailItemLine.conditions.selectedItem = null;
    }
    return { ...state, dmdEditDetailItemLine };
  },
  [selectSecGuide]: (state, action) => {
    const { selectedItem } = action.payload;
    const { dmdEditDetailItemLine } = state;
    const { conditions } = dmdEditDetailItemLine;
    conditions.selectedItem = selectedItem.selectedItem;
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, conditions } };
  },
  [deleteSelectSec]: (state) => {
    const { dmdEditDetailItemLine } = state;
    const { conditions, datax, datay } = dmdEditDetailItemLine;
    if (conditions.selectedItem !== null) {
      conditions.selectedItem = null;
    }
    if (datax.secondlinedivname !== undefined) {
      datay.secondlinedivname = null;
      datay.secondlinedivcd = null;
    }
    return { ...state, dmdEditDetailItemLine: { ...dmdEditDetailItemLine, conditions, datax, datay } };
  },
}, initialState);
