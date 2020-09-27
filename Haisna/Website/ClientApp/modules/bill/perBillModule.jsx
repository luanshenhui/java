import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';
import * as contants from '../../constants/common';

// actionの作成
export const {
  // 受診セット変更
  openPerbillOptionGuideRequest,
  openPerbillOptionGuideSuccess,
  openPerbillOptionGuideFailure,
  updateConsultOptionRequest,
  updateConsultOptionSuccess,
  updateConsultOptionFailure,
  closePerbillOptionGuide,
  // まとめ入金
  openPerbillallincomeGuide,
  closePerbillallincomeGuide,
  getRslConsultPerBillRequest,
  getRslConsultPerBillSuccess,
  getRslConsultPerBillFailure,
  getFriendsPerbillRequest,
  getFriendsPerbillSuccess,
  getFriendsPerbillFailure,
  clearPerBillInfo,
  changeDisplayRow,
  // 請求書情報
  getPerBillInfoRequest,
  getPerBillInfoSuccess,
  getPerBillInfoFailure,
  deletePerBillInfoRequest,
  deletePerBillInfoSuccess,
  deletePerBillInfoFailure,
  // 請求書統合処理
  openMergeGuideRequest,
  openMergeGuideSuccess,
  openMergeGuideFailure,
  closeMergeGuide,
  getPersonLukesRequest,
  getPersonLukesSuccess,
  getPersonLukesFailure,
  registerMergePerbillRequest,
  registerMergePerbillSuccess,
  registerMergePerbillFailure,
  clearMessage,
  // 入金情報
  openPerBillIncomeGuide,
  closePerBillIncomeGuide,
  getCloseDate,
  getPerBillIncomeRequest,
  getPerBillIncomeSuccess,
  getPerBillIncomeFailure,
  registerPerBillIncomeRequest,
  registerPerBillIncomeSuccess,
  registerPerBillIncomeFailure,
  deletePerPaymentRequest,
  deletePerPaymentSuccess,
  deletePerPaymentFailure,
  deletePerPaymentMessage,
  // 領収書・請求書印刷
  getPrtPerBillRequest,
  getPrtPerBillSuccess,
  getPrtPerBillFailure,
  updatePrtPerBillRequest,
  updatePrtPerBillSuccess,
  updatePrtPerBillFailure,
  // 個人請求書の検索
  openGdePerBillGuideRequest,
  openGdePerBillGuideSuccess,
  openGdePerBillGuideFailure,
  closeGdePerBillGuide,
  getListPerBillRequest,
  getListPerBillSuccess,
  getListPerBillFailure,
  selectGdePerBill,
  // 請求明細登録修正
  openEditPerBillGuideRequest,
  openEditPerBillGuideSuccess,
  openEditPerBillGuideFailure,
  closeEditPerBillGuide,
  checkValueAndUpdatePerBillcRequest,
  checkValueAndUpdatePerBillcSuccess,
  checkValueAndUpdatePerBillcFailure,
  deletePerBillcRequest,
  deletePerBillcSuccess,
  deletePerBillcFailure,
  // 請求書コメント
  initializeBillComment,
  openPerBillGuide,
  closePerBillGuide,

  initializePerBill,
  initializeGdePerBillGuide,
  createPerBillPersonRequest,
  createPerBillPersonSuccess,
  createPerBillPersonFailure,
  updatePerBillPersonRequest,
  updatePerBillPersonSuccess,
  updatePerBillPersonFailure,
  getPerBillPersonCRequest,
  getPerBillPersonCSuccess,
  getPerBillPersonCFailure,
  getPerBillPersonRequest,
  getPerBillPersonSuccess,
  getPerBillPersonFailure,
  getPerBillNoRequest,
  getPerBillNoSuccess,
  getPerBillNoFailure,
  getPerBillCslRequest,
  getPerBillCslSuccess,
  getPerBillCslFailure,
  getPerBillCRequest,
  getPerBillCSuccess,
  getPerBillCFailure,
  getPerPaymentRequest,
  getPerPaymentSuccess,
  getPerPaymentFailure,
  deletePerBillRequest,
  deletePerBillSuccess,
  deletePerBillFailure,
  getPerBillListRequest,
  getPerBillListSuccess,
  getPerBillListFailure,
  getGdeGuideListRequest,
  getGdeGuideListSuccess,
  getGdeGuideListFailure,
  getGdeGuideValueRequest,
  getGdeGuideValueSuccess,
  getGdeGuideValueFailure,
  updataPerBillCommentRequest,
  updataPerBillCommentSuccess,
  updataPerBillCommentFailure,
  createPerBillRequest,
  initializePerBillList,
  openMergePerBillGuide,
  openGdePerBillGuide,
  closeMergePerBillGuide,
  initializePerBillSearch,
  perBillPageManagement,
  getUrlValues,
} = createActions(
  // 受診セット変更
  'OPEN_PERBILL_OPTION_GUIDE_REQUEST',
  'OPEN_PERBILL_OPTION_GUIDE_SUCCESS',
  'OPEN_PERBILL_OPTION_GUIDE_FAILURE',
  'UPDATE_CONSULT_OPTION_REQUEST',
  'UPDATE_CONSULT_OPTION_SUCCESS',
  'UPDATE_CONSULT_OPTION_FAILURE',
  'CLOSE_PERBILL_OPTION_GUIDE',
  'OPEN_PERBILLALLINCOME_GUIDE',
  'CLOSE_PERBILLALLINCOME_GUIDE',
  // 受診情報と個人請求書管理情報検索
  'GET_RSL_CONSULT_PER_BILL_REQUEST',
  'GET_RSL_CONSULT_PER_BILL_SUCCESS',
  'GET_RSL_CONSULT_PER_BILL_FAILURE',
  // 同伴者請求書検索
  'GET_FRIENDS_PERBILL_REQUEST',
  'GET_FRIENDS_PERBILL_SUCCESS',
  'GET_FRIENDS_PERBILL_FAILURE',
  // 請求書情報のクリア
  'CLEAR_PER_BILL_INFO',
  // 請求書行の表示しなおし
  'CHANGE_DISPLAY_ROW',
  // 請求書情報
  // 請求書情報を取得
  'GET_PER_BILL_INFO_REQUEST',
  'GET_PER_BILL_INFO_SUCCESS',
  'GET_PER_BILL_INFO_FAILURE',
  // 請求書情報を削除
  'DELETE_PER_BILL_INFO_REQUEST',
  'DELETE_PER_BILL_INFO_SUCCESS',
  'DELETE_PER_BILL_INFO_FAILURE',
  // 請求書統合処理
  'OPEN_MERGE_GUIDE_REQUEST',
  'OPEN_MERGE_GUIDE_SUCCESS',
  'OPEN_MERGE_GUIDE_FAILURE',
  'CLOSE_MERGE_GUIDE',
  'GET_PERSON_LUKES_REQUEST',
  'GET_PERSON_LUKES_SUCCESS',
  'GET_PERSON_LUKES_FAILURE',
  'REGISTER_MERGE_PERBILL_REQUEST',
  'REGISTER_MERGE_PERBILL_SUCCESS',
  'REGISTER_MERGE_PERBILL_FAILURE',
  'CLEAR_MESSAGE',
  // 入金情報
  'OPEN_PER_BILL_INCOME_GUIDE',
  'CLOSE_PER_BILL_INCOME_GUIDE',
  // 締め日の取得
  'GET_CLOSE_DATE_REQUEST',
  'GET_CLOSE_DATE_SUCCESS',
  'GET_CLOSE_DATE_FAILURE',
  'GET_PER_BILL_INCOME_REQUEST',
  'GET_PER_BILL_INCOME_SUCCESS',
  'GET_PER_BILL_INCOME_FAILURE',
  'REGISTER_PER_BILL_INCOME_REQUEST',
  'REGISTER_PER_BILL_INCOME_SUCCESS',
  'REGISTER_PER_BILL_INCOME_FAILURE',
  // 請求書情報を削除
  'DELETE_PER_PAYMENT_REQUEST',
  'DELETE_PER_PAYMENT_SUCCESS',
  'DELETE_PER_PAYMENT_FAILURE',
  'DELETE_PER_PAYMENT_MESSAGE',
  // 領収書・請求書印刷
  'GET_PRT_PER_BILL_REQUEST',
  'GET_PRT_PER_BILL_SUCCESS',
  'GET_PRT_PER_BILL_FAILURE',
  'UPDATE_PRT_PER_BILL_REQUEST',
  'UPDATE_PRT_PER_BILL_SUCCESS',
  'UPDATE_PRT_PER_BILL_FAILURE',
  // 個人請求書の検索
  'OPEN_GDE_PER_BILL_GUIDE_REQUEST',
  'OPEN_GDE_PER_BILL_GUIDE_SUCCESS',
  'OPEN_GDE_PER_BILL_GUIDE_FAILURE',
  'CLOSE_GDE_PER_BILL_GUIDE',
  'GET_LIST_PER_BILL_REQUEST',
  'GET_LIST_PER_BILL_SUCCESS',
  'GET_LIST_PER_BILL_FAILURE',
  'SELECT_GDE_PER_BILL',
  // 請求明細登録修正
  'OPEN_EDIT_PER_BILL_GUIDE_REQUEST',
  'OPEN_EDIT_PER_BILL_GUIDE_SUCCESS',
  'OPEN_EDIT_PER_BILL_GUIDE_FAILURE',
  'CLOSE_EDIT_PER_BILL_GUIDE',
  'CHECK_VALUE_AND_UPDATE_PER_BILLC_REQUEST',
  'CHECK_VALUE_AND_UPDATE_PER_BILLC_SUCCESS',
  'CHECK_VALUE_AND_UPDATE_PER_BILLC_FAILURE',
  'DELETE_PER_BILLC_REQUEST',
  'DELETE_PER_BILLC_SUCCESS',
  'DELETE_PER_BILLC_FAILURE',
  // 請求書コメント
  'INITIALIZE_BILL_COMMENT',
  'OPEN_PER_BILL_GUIDE',
  'CLOSE_PER_BILL_GUIDE',
  // 一覧用
  'INITIALIZE_PER_BILL',
  'INITIALIZE_GDE_PER_BILL_GUIDE',
  'CREATE_PER_BILL_PERSON_REQUEST',
  'CREATE_PER_BILL_PERSON_SUCCESS',
  'CREATE_PER_BILL_PERSON_FAILURE',
  'UPDATE_PER_BILL_PERSON_REQUEST',
  'UPDATE_PER_BILL_PERSON_SUCCESS',
  'UPDATE_PER_BILL_PERSON_FAILURE',
  'GET_PER_BILL_PERSON_REQUEST',
  'GET_PER_BILL_PERSON_SUCCESS',
  'GET_PER_BILL_PERSON_FAILURE',
  'GET_PER_BILL_PERSON_C_REQUEST',
  'GET_PER_BILL_PERSON_C_SUCCESS',
  'GET_PER_BILL_PERSON_C_FAILURE',
  'GET_PER_BILL_NO_REQUEST',
  'GET_PER_BILL_NO_SUCCESS',
  'GET_PER_BILL_NO_FAILURE',
  'DELETE_PER_BILL_REQUEST',
  'DELETE_PER_BILL_SUCCESS',
  'DELETE_PER_BILL_FAILURE',
  'GET_PER_BILL_CSL_REQUEST',
  'GET_PER_BILL_CSL_SUCCESS',
  'GET_PER_BILL_CSL_FAILURE',
  'GET_PER_BILL_C_REQUEST',
  'GET_PER_BILL_C_SUCCESS',
  'GET_PER_BILL_C_FAILURE',
  'GET_PER_PAYMENT_SUCCESS',
  'GET_PER_PAYMENT_FAILURE',
  'GET_PER_PAYMENT_REQUEST',
  'GET_PER_BILL_LIST_REQUEST',
  'GET_PER_BILL_LIST_SUCCESS',
  'GET_PER_BILL_LIST_FAILURE',
  'GET_GDE_GUIDE_LIST_REQUEST',
  'GET_GDE_GUIDE_LIST_SUCCESS',
  'GET_GDE_GUIDE_LIST_FAILURE',
  'GET_GDE_GUIDE_VALUE_REQUEST',
  'GET_GDE_GUIDE_VALUE_SUCCESS',
  'GET_GDE_GUIDE_VALUE_FAILURE',
  'UPDATA_PER_BILL_COMMENT_REQUEST',
  'UPDATA_PER_BILL_COMMENT_SUCCESS',
  'UPDATA_PER_BILL_COMMENT_FAILURE',
  'CREATE_PER_BILL_REQUEST',
  // 一覧初期化
  'INITIALIZE_PER_BILL_LIST',
  'OPEN_MERGE_PER_BILL_GUIDE',
  'CLOSE_MERGE_PER_BILL_GUIDE',
  'OPEN_GDE_PER_BILL_GUIDE',
  'INITIALIZE_PER_BILL_SEARCH',
  'PER_BILL_PAGE_MANAGEMENT',
  'GET_URL_VALUES',
);

// stateの初期値
const initialState = {
  perbillallincome: {
    rsvno: 0,
    message: [],
    // 受診情報
    rslConsultdata: {},
    // 個人請求書管理情報
    perBillList: [],
    // 可視状態
    visible: false,
    refreshFlg: 0,
    // 表示件数
    dispCnt: contants.DEFAULT_ROW,
    // 指定請求書数
    billCnt: 0,
    // 表示用配列
    disPerBillList: [],
    // 行数選択リスト
    dispInfoItems: [],
  },
  // 請求書情報
  perBillInfo: {
    message: [],
    perBillCsl: [],
    perBillC: [],
    perBillBillNo: [],
    perPayment: [],
    error: '',
    urlValues: {},
  },
  // 受診セット変更
  perbilloptionGuide: {
    rsvno: 0,
    ctrptcd: 0,
    message: [],
    // 全オプション
    consultoptionall: [],
    // 可視状態
    visible: false,
  },
  // 請求書統合処理
  mergeGuide: {
    message: [],
    // 以下一覧用
    perBillCsl: [],
    retPerBillList: [],
    perBillBillNo: [],
    disPerBillList: [],
    dmdDate: '',
    requestNo: '',
    priceTotal: '',
    taxTotal: '',
    // 以下ガイド用
    visible: false, // 可視状態
    // 表示件数
    dispCnt: contants.DEFAULT_ROW,
    billSeq: null,
    branchNo: null,
    flg: 0,
  },
  // 入金情報
  perBillIncome: {
    message: [],
    visible: false,
    billNo: [],
    cardKindItems: [],
    bankItems: [],
  },
  // 領収書・請求書印刷表示
  prtPerBill: {
    message: [],
    prtBillItem: [],
  },
  // 請求明細登録修正
  editPerBillGuide: {
    message: [],
    visible: false, // 可視状態
    paymentConsultTotal: [],
    dmddate: null,
    billseq: null,
    branchno: null,
    billlineno: null,
    dspdivname: '',
    rsvno: null,
    priceseq: null,
    omittaxflg: null,
    divcd: null,
    taxprice: null,
    orgcd1: null,
    orgcd2: null,
    paymentdate: null,
    paymentseq: null,
    orgname: '',
    optcd: null,
    optbranchno: null,
    optname: null,
  },
  editPerBillGuide2: {
    visible: false, // 可視状態
  },
  // 個人請求書の検索
  gdePerBillGuide: {
    message: [],
    visible: false,
    conditions: {},
    listPerBill: [],
    requestNo: '',
    startDmdDate: '',
    endDmdDate: '',
    index: null,
  },
  perBillComment: {
    message: [],
  },
  // 個人請求書の検索
  perBillSearch: {
    message: [],
    // 検索条件
    conditions: {
      branchNo: '',
      branchNos: '',
      startDmdDate: moment().format('YYYY/MM/DD'),
      endDmdDate: moment().format('YYYY/MM/DD'),
      paymentflg: null,
      delDisp: '1',
      pageMaxLine: 0,
      page: 1,
      dmdDate: '',
      billSeq: '',
      orgCd1: '',
      orgCd2: '',
      orgname: '',
      perId: '',
      lastName: '',
      firstName: '',
      isLoading: false,
    },
    selectedItem: undefined,
  },
  // 個人請求書の検索一覧
  perBillList: {
    // 以下一覧用
    totalCount: null,
    data: [],
    dataCls: [],
    dataC: [],
    dataPay: [],
    dataNo: [],
    dataPer: [],
    dataPerC: [],
  },
  perBillGuide: {
    message: [],
    conditions: {
      branchNo: '',
      branchNos: '',
      startDmdDate: moment().format('YYYY/MM/DD'),
      endDmdDate: moment().format('YYYY/MM/DD'),
      paymentflg: 0,
      delDisp: 0,
      pageMaxLine: 0,
      page: 1,
      dmdDate: '',
      billSeq: '',
      orgCd1: '',
      orgCd2: '',
      perId: '',
      key: '',
      billcomment: '',
      lngPaymentFlg: 0,
      delflg: 0,
      perCount: new Array(5),
      billCount: new Array(5),
      perCount1: 5,
      perCount2: 10,
      billCount1: 5,
      billCount2: 10,
      strMessage: [],
      perIndex: null,
      billIndex: null,
      paymentDate: null,
      paymentSeq: null,
      addBillLine: null,
      addPerLine: null,
      deletePer: null,
      deleteBill: null,
      selectedItemPer: null,
      selectedItemBill: null,
      delflgItems1: [{ value: 5, name: '5人' }, { value: 10, name: '10人' }],
      delflgItems2: [{ value: 5, name: '5明細' }, { value: 10, name: '10明細' }],
      priceTotal: 0,
      editPriceTotal: 0,
      taxPriceTotal: 0,
      editTaxTotal: 0,
      total: 0,
    }, // 検索条件
    // 以下ガイド用
    visible: false, // 可視状態
    searched: false,
    refresh: 'refresh',
    selectedItem: undefined, // 選択された要素
    data: [],
  },
  mergePerBillGuide: {
    visible: false, // 可視状態
    searched: false,
    selectedItemPer: undefined, // 選択された要素
    selectedItemBill: undefined,
    perCnt: 5,
    billCnt: 5,
  },
};

// reducerの作成
export default handleActions({
  [selectGdePerBill]: (state, action) => {
    const { gdePerBillGuide, mergeGuide } = state;
    const { disPerBillList } = mergeGuide;
    let { flg } = mergeGuide;
    const { gdePerBillList, index } = action.payload;
    disPerBillList[index].perId = gdePerBillList.perId;
    disPerBillList[index].lastname = gdePerBillList.lastName;
    disPerBillList[index].firstname = gdePerBillList.firstName;
    disPerBillList[index].lastkname = gdePerBillList.lastKname;
    disPerBillList[index].firstkname = gdePerBillList.firstKName;
    disPerBillList[index].age = gdePerBillList.age;
    disPerBillList[index].gender = gdePerBillList.gender;
    disPerBillList[index].rsvno = gdePerBillList.rsvNo;
    disPerBillList[index].dmddate = gdePerBillList.dmdDate;
    disPerBillList[index].billseq = gdePerBillList.billSeq;
    disPerBillList[index].branchno = gdePerBillList.branchNo;
    flg += 1;
    return {
      ...state,
      gdePerBillGuide: { ...gdePerBillGuide, visible: false },
      mergeGuide: { ...mergeGuide, disPerBillList, flg },
    };
  },

  [getListPerBillSuccess]: (state, action) => {
    const { gdePerBillGuide } = state;
    const { disListPerBill, startDmdDate, endDmdDate, index } = action.payload;
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide, listPerBill: disListPerBill, startDmdDate, endDmdDate, index } };
  },

  [getListPerBillFailure]: (state, action) => {
    const { gdePerBillGuide } = state;
    const { startDmdDate, endDmdDate } = action.payload;
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide, listPerBill: [], startDmdDate, endDmdDate } };
  },

  [openGdePerBillGuideSuccess]: (state, action) => {
    const { gdePerBillGuide } = state;
    const { disListPerBill, requestNo, startDmdDate, index } = action.payload;
    const visible = true;
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide, listPerBill: disListPerBill, visible, requestNo, startDmdDate, endDmdDate: startDmdDate, index } };
  },

  // 閉じるアクション時の処理
  [closeGdePerBillGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    const { gdePerBillGuide } = initialState;
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide } };
  },

  [checkValueAndUpdatePerBillcSuccess]: (state) => {
    const { editPerBillGuide, editPerBillGuide2 } = initialState;
    const message = ['保存が完了しました。'];
    return { ...state, editPerBillGuide2, editPerBillGuide: { ...editPerBillGuide, message } };
  },

  [checkValueAndUpdatePerBillcFailure]: (state, action) => {
    const { data } = action.payload;
    const { editPerBillGuide } = state;
    return { ...state, editPerBillGuide: { ...editPerBillGuide, message: data } };
  },

  [deletePerBillcSuccess]: (state) => {
    const { editPerBillGuide, editPerBillGuide2 } = initialState;
    const message = ['削除が完了しました。'];
    return { ...state, editPerBillGuide2, editPerBillGuide: { ...editPerBillGuide, message } };
  },

  [deletePerBillcFailure]: (state, action) => {
    const { editPerBillGuide } = state;
    const { data } = action.payload;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    return { ...state, editPerBillGuide: { ...editPerBillGuide, message: data } };
  },

  [openEditPerBillGuideSuccess]: (state, action) => {
    const { editPerBillGuide } = state;
    const { paymentConsultTotal, line, flg, params } = action.payload;
    let Visible1 = false;
    let Visible2 = false;
    if (flg === 1) {
      Visible1 = true;
    } else {
      Visible2 = true;
    }
    return {
      ...state,
      editPerBillGuide: {
        ...editPerBillGuide,
        paymentConsultTotal,
        dmddate: paymentConsultTotal[line].dmddate,
        billseq: paymentConsultTotal[line].billseq == null ? 0 : paymentConsultTotal[line].billseq,
        branchno: paymentConsultTotal[line].branchno == null ? 0 : paymentConsultTotal[line].branchno,
        billlineno: paymentConsultTotal[line].billlineno == null ? 0 : paymentConsultTotal[line].billlineno,
        dspdivname: paymentConsultTotal[line].linename,
        rsvno: params,
        priceseq: paymentConsultTotal[line].priceseq,
        omittaxflg: paymentConsultTotal[line].omittaxflg,
        divcd: paymentConsultTotal[line].otherlinedivcd,
        taxprice: paymentConsultTotal[line].taxprice,
        orgcd1: paymentConsultTotal[line].orgcd1,
        orgcd2: paymentConsultTotal[line].orgcd2,
        paymentdate: paymentConsultTotal[line].paymentdate,
        paymentseq: paymentConsultTotal[line].paymentseq,
        orgname: paymentConsultTotal[line].orgname,
        optcd: paymentConsultTotal[line].optcd,
        optbranchno: paymentConsultTotal[line].optbranchno,
        optname: paymentConsultTotal[line].ctrpt_optname,
        visible: Visible1,
        message: [],
      },
      editPerBillGuide2: { visible: Visible2 },
    };
  },

  [closeEditPerBillGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { editPerBillGuide, editPerBillGuide2 } = initialState;
    return { ...state, editPerBillGuide, editPerBillGuide2 };
  },

  [clearMessage]: (state) => {
    const { mergeGuide } = state;
    return { ...state, mergeGuide: { ...mergeGuide, message: [] } };
  },

  [registerMergePerbillSuccess]: (state) => {
    const { mergeGuide } = initialState;
    return { ...state, mergeGuide: { ...mergeGuide, disPerBillList: [] } };
  },

  [registerMergePerbillFailure]: (state, action) => {
    const { mergeGuide } = state;
    const { message } = action.payload;
    return { ...state, mergeGuide: { ...mergeGuide, message } };
  },

  // 個人情報を取得成功時の処理
  [getPersonLukesSuccess]: (state, action) => {
    const { mergeGuide } = state;
    const { retPerBillList } = action.payload;

    return { ...state, mergeGuide: { ...mergeGuide, retPerBillList } };
  },

  [getPersonLukesFailure]: (state, action) => {
    const { mergeGuide } = state;
    const { status, params } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`個人情報が取得できません。（個人ＩＤ = ${params.perid})`];
    }
    return { ...state, mergeGuide: { ...mergeGuide, message } };
  },

  [openMergeGuideSuccess]: (state, action) => {
    const { mergeGuide } = state;
    const { dispCnt, disPerBillList } = mergeGuide;
    const { params, perBillCsl, perBillBillNo } = action.payload;
    const requestNo = moment(params.dmddate).format('YYYYMMDD') + `0000${params.billseq}`.slice(-5) + params.branchno;
    const priceTotal = perBillBillNo[0].price_all + perBillBillNo[0].editprice_all
      + perBillBillNo[0].taxprice_all + perBillBillNo[0].edittax_all;
    const taxTotal = perBillBillNo[0].taxprice_all + perBillBillNo[0].edittax_all;
    const billSeq = params.billseq;
    const branchNo = params.branchno;

    for (let i = disPerBillList.length; i < dispCnt; i += 1) {
      disPerBillList.push({
        key: i,
        perId: null,
        lastname: null,
        firstname: null,
        lastkname: null,
        firstkname: null,
        age: null,
        gender: null,
        rsvno: null,
        dmddate: null,
        billseq: null,
        branchno: null,
        billno: null,
      });
    }
    return {
      ...state,
      mergeGuide: { ...mergeGuide, perBillCsl, perBillBillNo, visible: true, disPerBillList, dmdDate: params.dmddate, requestNo, priceTotal, taxTotal, billSeq, branchNo },
    };
  },

  [openMergeGuideFailure]: (state, action) => {
    const { mergeGuide } = state;
    const { status, data, params } = action.payload;
    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    const 請求書No = moment(params.dmddate).format('YYYYMMDD') + `0000${params.billseq}`.slice(-5) + params.branchno;
    if (!message && status === 404) {
      message = [`請求書情報が取得できません。（請求書No = ${請求書No})`];
    }
    return { ...state, mergeGuide: { ...mergeGuide, message, visible: true } };
  },

  [closeMergeGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { mergeGuide } = initialState;
    return { ...state, mergeGuide: { ...mergeGuide, disPerBillList: [] } };
  },

  // 閉じるアクション時の処理
  [closePerbillallincomeGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    const { perbillallincome } = initialState;
    return { ...state, perbillallincome: { ...perbillallincome, disPerBillList: [] } };
  },
  // 受診情報と個人請求書管理情報を取得成功時の処理
  [getRslConsultPerBillSuccess]: (state, action) => {
    const { perbillallincome } = state;
    const { dispCnt, disPerBillList } = perbillallincome;
    const { rslConsult, perBill } = action.payload;
    const visible = true;

    let { billCnt } = perbillallincome;

    for (let i = disPerBillList.length; i < dispCnt; i += 1) {
      disPerBillList.push({
        key: i,
        perId: null,
        lastname: null,
        firstname: null,
        lastkname: null,
        firstkname: null,
        age: null,
        gender: null,
        rsvno: null,
        dmddate: null,
        billseq: null,
        branchno: null,
        billno: null,
      });
    }

    billCnt = 0;
    for (let i = 0, j = 0; i < perBill.length; i += 1) {
      if (perBill[i].paymentdate == null && perBill[i].delflg !== 1) {
        disPerBillList[j].perId = rslConsult.perid;
        disPerBillList[j].lastname = rslConsult.lastname;
        disPerBillList[j].firstname = rslConsult.firstname;
        disPerBillList[j].lastkname = rslConsult.lastkname;
        disPerBillList[j].firstkname = rslConsult.firstkname;
        disPerBillList[j].age = parseInt(rslConsult.age, 10);
        disPerBillList[j].gender = rslConsult.gendername;
        disPerBillList[j].rsvno = rslConsult.rsvno;
        disPerBillList[j].dmddate = perBill[i].dmddate;
        disPerBillList[j].billseq = perBill[i].billseq;
        disPerBillList[j].branchno = perBill[i].branchno;
        disPerBillList[j].billno = moment(perBill[i].dmddate).format('YYYYMMDD') + `0000${perBill[i].billseq}`.slice(-5) + perBill[i].branchno;

        j += 1;
        billCnt += 1;
      }
    }

    return { ...state, perbillallincome: { ...perbillallincome, rslConsultdata: rslConsult, perBillList: perBill, disPerBillList, dispCnt, billCnt, visible, refreshFlg: 0 } };
  },
  // 受診情報と個人請求書管理情報を取得失敗時の処理
  [getRslConsultPerBillFailure]: (state, action) => {
    const { perbillallincome } = state;
    const { status, rslConsult, perBill, rsvno } = action.payload;

    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      if (perBill == null) {
        message = [`個人請求管理情報が存在しません。（予約番号= ${rsvno})`];
      }
      if (rslConsult == null) {
        message = [`受診情報が存在しません。（予約番号= ${rsvno})`];
      }
    }
    return { ...state, perbillallincome: { ...perbillallincome, message } };
  },
  // 同伴者（お連れ様）の請求書情報を取得成功時の処理
  [getFriendsPerbillSuccess]: (state, action) => {
    let disPerBillList;
    const { friendsPerBill, formName } = action.payload;
    const { perbillallincome, mergeGuide } = state;
    let { dispCnt, billCnt, refreshFlg } = perbillallincome;

    if (formName === 'mergePerBill1Form') {
      ({ disPerBillList } = mergeGuide);
    } else {
      ({ disPerBillList } = perbillallincome);
    }

    let lngSetFlg = 0;
    for (let i = 0; i < friendsPerBill.length; i += 1) {
      lngSetFlg = 0;
      for (let j = 0; j < billCnt; j += 1) {
        // 既にセットされているか？
        if (disPerBillList[j].dmddate === friendsPerBill[i].dmddate
          && disPerBillList[j].billseq === friendsPerBill[i].billseq
          && disPerBillList[j].branchno === friendsPerBill[i].branchno) {
          lngSetFlg = 1;
          break;
        }
      }

      // セットされていなければ
      if (lngSetFlg === 0) {
        if (dispCnt <= billCnt) {
          dispCnt += contants.INCREASE_COUNT;

          for (let t = disPerBillList.length; t < dispCnt; t += 1) {
            disPerBillList.push({
              key: t,
              perId: null,
              lastname: null,
              firstname: null,
              lastkname: null,
              firstkname: null,
              age: null,
              gender: null,
              rsvno: null,
              dmddate: null,
              billseq: null,
              branchno: null,
              billno: null,
            });
          }
        }
        disPerBillList[billCnt].perId = friendsPerBill[i].perid;
        disPerBillList[billCnt].lastname = friendsPerBill[i].lastname;
        disPerBillList[billCnt].firstname = friendsPerBill[i].firstname;
        disPerBillList[billCnt].lastkname = friendsPerBill[i].lastkname;
        disPerBillList[billCnt].firstkname = friendsPerBill[i].firstkname;
        disPerBillList[billCnt].age = parseInt(friendsPerBill[i].age, 10);
        disPerBillList[billCnt].gender = contants.genderName[friendsPerBill[i].gender - 1];
        disPerBillList[billCnt].rsvno = friendsPerBill[i].rsvno;
        disPerBillList[billCnt].dmddate = friendsPerBill[i].dmddate;
        disPerBillList[billCnt].billseq = friendsPerBill[i].billseq;
        disPerBillList[billCnt].branchno = friendsPerBill[i].branchno;
        disPerBillList[billCnt].billno = moment(friendsPerBill[i].dmddate).format('YYYYMMDD') + `0000${friendsPerBill[i].billseq}`.slice(-5) + friendsPerBill[i].branchno;

        billCnt += 1;
      }
    }

    refreshFlg += 1;
    return {
      ...state,
      perbillallincome: { ...perbillallincome, friendsPerBill, disPerBillList, dispCnt, billCnt, refreshFlg },
      mergeGuide: { ...mergeGuide, disPerBillList },
    };
  },
  // 請求書行の表示しなおし
  [changeDisplayRow]: (state, action) => {
    let disPerBillList;
    const { perbillallincome, mergeGuide } = state;
    const { dispCnt, formName } = action.payload;

    if (formName === 'mergePerBill1Form') {
      ({ disPerBillList } = mergeGuide);
    } else {
      ({ disPerBillList } = perbillallincome);
    }

    for (let i = disPerBillList.length; i < dispCnt; i += 1) {
      disPerBillList.push({
        key: i,
        perId: null,
        lastname: null,
        firstname: null,
        lastkname: null,
        firstkname: null,
        age: null,
        gender: null,
        rsvno: null,
        dmddate: null,
        billseq: null,
        branchno: null,
        billno: null,
      });
    }

    return {
      ...state,
      perbillallincome: { ...perbillallincome, disPerBillList, dispCnt },
      mergeGuide: { ...mergeGuide, disPerBillList, dispCnt },
    };
  },
  // 請求書情報のクリア
  [clearPerBillInfo]: (state, action) => {
    let disPerBillList;
    const { perbillallincome, mergeGuide } = state;
    let { flg } = mergeGuide;
    let { refreshFlg } = perbillallincome;
    const { index, formName } = action.payload;

    if (formName === 'mergePerBill1Form') {
      ({ disPerBillList } = mergeGuide);
    } else {
      ({ disPerBillList } = perbillallincome);
    }

    disPerBillList[index].perId = null;
    disPerBillList[index].lastname = null;
    disPerBillList[index].firstname = null;
    disPerBillList[index].lastkname = null;
    disPerBillList[index].firstkname = null;
    disPerBillList[index].age = null;
    disPerBillList[index].gender = null;
    disPerBillList[index].rsvno = null;
    disPerBillList[index].dmddate = null;
    disPerBillList[index].billseq = null;
    disPerBillList[index].branchno = null;

    refreshFlg += 1;
    flg += 1;
    return {
      ...state,
      perbillallincome: { ...perbillallincome, disPerBillList, refreshFlg },
      mergeGuide: { ...mergeGuide, disPerBillList, flg },
    };
  },
  // 請求書情報を取得成功時の処理
  [getPerBillInfoSuccess]: (state, action) => {
    const { perBillInfo } = state;
    const { perBillCsl, perBillC, perBillBillNo } = action.payload;

    // 個人請求明細情報を編集
    if (perBillC) {
      let strLastName = '';
      let strFirstName = '';

      for (let i = 0; i < perBillC.length; i += 1) {
        if (strLastName === perBillC[i].lastname && strFirstName === perBillC[i].firstname) {
          perBillC[i].lastname = '';
          perBillC[i].firstname = '';
        } else {
          strLastName = perBillC[i].lastname;
          strFirstName = perBillC[i].firstname;
        }
      }
    }

    // 入金情報を取得なし場合
    let { perPayment } = action.payload;
    if (perPayment == null) {
      perPayment = [];
    }

    return { ...state, perBillInfo: { ...perBillInfo, perBillCsl, perBillC, perBillBillNo, perPayment } };
  },
  // 請求書情報を取得を取得失敗時の処理
  [getPerBillInfoFailure]: (state, action) => {
    const { perBillInfo } = state;

    const { status, params, perBillC, perBillBillNo, perPayment } = action.payload;

    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      if (perBillBillNo !== null && perBillBillNo.paymentDate !== null && perPayment == null) {
        message = [`入金情報が取得できません。（入金No  = ${params.paymentdate} ${params.paymentseq})`];
      }
      const 請求書No = moment(params.dmddate).format('YYYYMMDD') + `0000${params.billseq}`.slice(-5) + params.branchno;
      if (perBillC !== null && perBillBillNo == null) {
        message = [`個人請求管理情報が取得できません。（請求書No  = ${請求書No} )`];
      }
      if (perBillC == null) {
        message = [`個人請求明細情報が取得できません。（請求書No  = ${請求書No} )`];
      }
    }
    return { ...state, perBillInfo: { ...perBillInfo, message } };
  },
  // 請求書情報を削除失敗時の処理
  [deletePerBillInfoFailure]: (state) => {
    const { perBillInfo } = state;

    const message = ['請求書の取消しに失敗しました'];

    return { ...state, perBillInfo: { ...perBillInfo, message } };
  },
  // 閉じるアクション時の処理
  [closePerbillOptionGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    const { perbilloptionGuide } = initialState;
    return { ...state, perbilloptionGuide };
  },
  // 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得成功時の処理
  [openPerbillOptionGuideSuccess]: (state, action) => {
    const { perbilloptionGuide } = state;
    const { rsvno, ctrptcd, consultoptionall } = action.payload;
    const visible = true;

    return { ...state, perbilloptionGuide: { ...perbilloptionGuide, rsvno, ctrptcd, consultoptionall, visible } };
  },
  // 入金情報ガイド閉じるアクション時の処理
  [closePerBillIncomeGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { perBillIncome } = initialState;
    return { ...state, perBillIncome };
  },
  // 入金情報を取得成功時の処理
  [getPerBillIncomeSuccess]: (state, action) => {
    const { perBillIncome } = state;

    const visible = true;
    const closed = undefined;
    return { ...state, perBillIncome: { ...perBillIncome, ...action.payload, visible, closed } };
  },
  // 入金情報を取得失敗時の処理
  [getPerBillIncomeFailure]: (state, action) => {
    const { perBillIncome } = state;

    const { data } = action.payload;

    const message = [data];

    return { ...state, perBillIncome: { ...perBillIncome, message } };
  },
  [registerPerBillIncomeSuccess]: (state) => {
    const { perBillIncome } = state;

    const visible = false;
    const message = ['保存が完了しました。'];
    const closed = 'closed';
    return { ...state, perBillIncome: { ...perBillIncome, message, visible, closed } };
  },
  [registerPerBillIncomeFailure]: (state, action) => {
    const { perBillIncome } = state;
    const { data } = action.payload;

    return { ...state, perBillIncome: { ...perBillIncome, message: data } };
  },
  [deletePerPaymentSuccess]: (state) => {
    const { perBillIncome } = initialState;
    const closed = 'deleted';
    const visible = false;
    const message = ['削除が完了しました。'];

    return { ...state, perBillIncome: { ...perBillIncome, message, visible, closed } };
  },
  [deletePerPaymentMessage]: (state) => {
    const { perBillIncome } = state;

    const message = ['取消伝票の入金情報は削除できません'];

    return { ...state, perBillIncome: { ...perBillIncome, message } };
  },
  // 領収書・請求書印刷情報を取得成功時の処理
  [getPrtPerBillSuccess]: (state, action) => {
    const { prtPerBill } = state;

    return { ...state, prtPerBill: { ...prtPerBill, ...action.payload } };
  },
  // 請求書管理情報を更新成功時の処理
  [updatePrtPerBillSuccess]: (state) => {
    const { prtPerBill } = state;

    const message = ['保存が完了しました。'];

    return { ...state, prtPerBill: { ...prtPerBill, message } };
  },
  // 請求書管理情報を更新失敗時の処理
  [updatePrtPerBillFailure]: (state, action) => {
    const { prtPerBill } = state;
    const { data } = action.payload;

    return { ...state, prtPerBill: { ...prtPerBill, message: data } };
  },
  // ガイドを開くアクション時の処理
  [openPerBillGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { perBillGuide } = initialState;
    return { ...state, perBillGuide: { ...perBillGuide, visible } };
  },
  [closePerBillGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { perBillGuide } = initialState;
    return { ...state, perBillGuide };
  },
  [initializeBillComment]: (state) => {
    const { perBillComment } = initialState;
    return { ...state, perBillComment };
  },
  // 請求書情報 画面の初期化
  [initializePerBill]: (state) => {
    const { perBillList, perBillComment, perBillInfo, perBillGuide } = initialState;
    return { ...state, perBillList, perBillComment, perBillInfo, perBillGuide };
  },
  [initializeGdePerBillGuide]: (state) => {
    const { gdePerBillGuide } = initialState;
    return { ...state, gdePerBillGuide };
  },
  // 一覧初期化処理
  [initializePerBillList]: (state) => {
    const { perBillList } = initialState;
    return { ...state, perBillList };
  },
  [initializePerBillSearch]: (state) => {
    const { perBillSearch } = initialState;
    return { ...state, perBillSearch };
  },
  // 一覧取得開始時の処理
  [getPerBillListRequest]: (state, action) => {
    const { perBillSearch } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    if (!(conditions.startDmdDate && conditions.endDmdDate)) {
      conditions.startDmdDate = moment().format('YYYY/MM/DD');
      conditions.endDmdDate = moment().format('YYYY/MM/DD');
      conditions.paymentflg = null;
      conditions.delDisp = '1';
      conditions.pageMaxLine = 0;
      conditions.branchNos = '';
    } else if (!conditions.startDmdDate) {
      conditions.startDmdDate = moment().format('YYYY/MM/DD');
    } else if (!conditions.endDmdDate) {
      conditions.endDmdDate = moment().format('YYYY/MM/DD');
    }
    conditions.isLoading = true;
    // 請求書NOのカット
    let branchnos = '';
    if (conditions.branchNos !== (undefined && '')) {
      branchnos = conditions.branchNos.replace(/\s*/g, '');
    }

    // 全半角転化
    let tmp = '';
    for (let i = 0; i < branchnos.length; i += 1) {
      if (branchnos.charCodeAt(i) > 65248 && branchnos.charCodeAt(i) < 65375) {
        tmp += String.fromCharCode(branchnos.charCodeAt(i) - 65248);
      } else {
        tmp += String.fromCharCode(branchnos.charCodeAt(i));
      }
    }
    branchnos = tmp;

    // 検索条件請求日のカット
    if (branchnos.length >= 8) {
      conditions.dmdDate = branchnos.substring(0, 8);
    } else {
      conditions.dmdDate = '';
      conditions.billSeq = '';
      conditions.branchNo = '';
    }
    // 検索条件請求書Ｓｅｑのカット
    if (branchnos.length >= 13) {
      conditions.billSeq = branchnos.substring(8, 13);
    } else {
      conditions.billSeq = '';
      conditions.branchNo = '';
    }
    // 検索条件請求書枝番のカット
    if (branchnos.length >= 14) {
      conditions.branchNo = branchnos.substring(13, 14);
    } else {
      conditions.branchNo = '';
    }
    if (branchnos.length > 0 && branchnos.length < 8) {
      conditions.dmdDate = branchnos.substring(0, branchnos.length);
    }
    return { ...state, perBillSearch: { ...perBillSearch, conditions } };
  },
  // 個人請求書の一覧取得成功時の処理
  [getPerBillListSuccess]: (state, action) => {
    const { perBillList, perBillSearch } = state;
    const { conditions } = perBillSearch;
    conditions.isLoading = false;
    // 検索指示状態とする
    const searched = true;
    const message = [];
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, perBillList: { ...perBillList, searched, totalCount, data }, perBillSearch: { ...perBillSearch, message, conditions } };
  },
  // 個人請求書の一覧取得失敗時の処理
  [getPerBillListFailure]: (state, action) => {
    const { perBillList } = initialState;
    const { perBillSearch } = state;
    const { conditions } = perBillSearch;
    const totalCount = 0;
    conditions.isLoading = false;
    let message = [];
    const { status, data } = action.payload;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 400) {
      message = data;
    }
    return { ...state, perBillList: { ...perBillList, totalCount }, perBillSearch: { ...perBillSearch, message, conditions } };
  },
  // 請求書の情報削除成功時の処理
  [deletePerBillSuccess]: (state) => {
    const { perBillInfo } = initialState;
    return { ...state, perBillInfo: { ...perBillInfo } };
  },
  // 請求書の情報削除失敗時の処理
  [deletePerBillFailure]: (state) => {
    const { perBillInfo } = initialState;
    const message = ['請求書の取消しに失敗しました'];
    return { ...state, perBillInfo: { ...perBillInfo, message } };
  },
  // 個人請求管理情報得成功時の処理
  [getPerBillNoSuccess]: (state, action) => {
    const { perBillList, perBillGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // (これに伴い一覧が再描画される)
    const dataNo = action.payload;
    dataNo.forEach((value) => {
      perBillGuide.conditions.billcomment = value.billcomment;
    });
    return {
      ...state, perBillList: { ...perBillList, searched, dataNo }, perBillGuide,
    };
  },
  // 個人請求管理情報得失敗時の処理
  [getPerBillNoFailure]: (state) => {
    const { perBillList, perBillInfo, perBillGuide } = state;
    perBillGuide.conditions.billcomment = '';
    // 検索指示状態とする
    let { message } = perBillInfo;
    if (message.length === 0) {
      message = [`個人請求管理情報が取得できません。（請求書No  = 
      ${moment(perBillGuide.conditions.dmdDate).format('YYYYMMDD') + perBillGuide.conditions.billSeq.toString().padStart(5, '0') + perBillGuide.conditions.branchNo})`];
    }
    // (これに伴い一覧が再描画される)
    const dataNo = [];
    return {
      ...state, perBillList: { ...perBillList, dataNo }, perBillInfo: { ...perBillInfo, message },
    };
  },
  // 予約番号を取得情報得成功時の処理
  [getPerBillCslSuccess]: (state, action) => {
    const { perBillList } = state;
    // 検索指示状態とする
    const searched = true;
    // (これに伴い一覧が再描画される)
    const dataCls = action.payload;
    return { ...state, perBillList: { ...perBillList, searched, dataCls } };
  },
  // 予約番号を取得情報得失敗時の処理
  [getPerBillCslFailure]: (state) => {
    const { perBillInfo, perBillGuide } = initialState;
    const message = [`受診情報が取得できません。（請求書No  = 
    ${moment(perBillGuide.conditions.dmdDate).format('YYYYMMDD') + perBillGuide.conditions.billSeq.toString().padStart(5, '0') + perBillGuide.conditions.branchNo})`];
    return { ...state, perBillInfo: { ...perBillInfo, message } };
  },
  // 個人請求明細情報の取得成功時の処理
  [getPerBillCSuccess]: (state, action) => {
    const { perBillList } = state;
    // 検索指示状態とする
    const searched = true;
    // (これに伴い一覧が再描画される)
    const dataC = action.payload;
    return { ...state, perBillList: { ...perBillList, searched, dataC } };
  },
  // 個人請求明細情報の取得失敗時の処理
  [getPerBillCFailure]: (state) => {
    const { perBillList, perBillInfo, perBillGuide } = state;
    let { message } = perBillInfo;
    if (message.length === 0) {
      message = [`個人請求明細情報が取得できません。（請求書No  = 
      ${moment(perBillGuide.conditions.dmdDate).format('YYYYMMDD') + perBillGuide.conditions.billSeq.toString().padStart(5, '0') + perBillGuide.conditions.branchNo})`];
    }
    // (これに伴い一覧が再描画される)
    const dataC = [];
    return {
      ...state, perBillList: { ...perBillList, dataC }, perBillInfo: { ...perBillInfo, message },
    };
  },

  // 入金情報の取得成功時の処理
  [getPerPaymentSuccess]: (state, action) => {
    const { perBillList } = state;
    // (これに伴い一覧が再描画される)
    const dataPay = action.payload;
    return { ...state, perBillList: { ...perBillList, dataPay } };
  },
  // 入金情報の取得失敗時の処理
  [getPerPaymentFailure]: (state) => {
    const { perBillList, perBillInfo, perBillGuide } = state;
    let { message } = perBillInfo;
    if (message.length === 0) {
      message = [`入金情報が取得できません。（入金No  = ${moment(perBillGuide.conditions.paymentDate).format('YYYYMMDD') + perBillGuide.conditions.paymentSeq})`];
    }
    // (これに伴い一覧が再描画される)
    const dataPay = [];
    return {
      ...state, perBillList: { ...perBillList, dataPay }, perBillInfo: { ...perBillInfo, message },
    };
  },
  // 個人請求管理情報の更新成功時の処理
  [updataPerBillCommentSuccess]: (state, action) => {
    const { perBillGuide } = state;
    const { data } = action.payload;
    const conditions = { billcomment: data.billcomment };
    return { ...state, perBillGuide: { ...perBillGuide, conditions } };
  },
  // 個人請求管理情報の更新失敗時の処理
  [updataPerBillCommentFailure]: (state, action) => {
    const { perBillComment } = initialState;
    const { data } = action.payload;
    const message = data;
    return { ...state, perBillComment: { ...perBillComment, message } };
  },
  // ガイドを開くアクション時の処理(請求書統合)
  [openMergePerBillGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { mergePerBillGuide } = initialState;
    return { ...state, mergePerBillGuide: { ...mergePerBillGuide, visible } };
  },
  // ガイドを閉じるアクション時の処理(請求書統合)
  [closeMergePerBillGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { mergePerBillGuide } = initialState;
    return { ...state, mergePerBillGuide };
  },
  // ガイドを開くアクション時の処理(個人請求書の検索)
  [openGdePerBillGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { gdePerBillGuide } = initialState;
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide, visible } };
  },
  // ガイドを閉じるアクション時の処理(個人請求書の検索)
  [closeGdePerBillGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { gdePerBillGuide } = initialState;
    return { ...state, gdePerBillGuide };
  },
  // 個人ガイド選択行要素取得成功時の処理
  [getGdeGuideValueSuccess]: (state, action) => {
    // 選択された要素を更新
    const { gdePerBillGuide } = state;
    const visible = false;
    const selectedItem = action.payload;
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide, selectedItem, visible } };
  },

  // 個人ガイド選択行要素取得成功時の処理
  [getGdeGuideListSuccess]: (state, action) => {
    const { gdePerBillGuide, perBillGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    // 請求書数
    let { totalCount } = action.payload;
    // 同一の請求書No.は表示しない
    data.forEach((value, key) => {
      if (`${moment(value.dmddate).format('YYYYMMDD')}${value.billseq}${value.branchno}` ===
        `${moment(perBillGuide.conditions.dmdDate).format('YYYYMMDD')}${perBillGuide.conditions.billSeq}${perBillGuide.conditions.branchNo}`) {
        // 同じ請求書番号を削除する
        data.splice(key, 1);
        totalCount -= 1;
      }
    });
    return { ...state, gdePerBillGuide: { ...gdePerBillGuide, searched, totalCount, data } };
  },
  // 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得成功時の処理
  [getPerBillPersonSuccess]: (state, action) => {
    const { perBillList } = state;
    // 検索指示状態とする
    const searched = true;
    // (これに伴い一覧が再描画される)
    const dataPer = action.payload;
    return { ...state, perBillList: { ...perBillList, searched, dataPer } };
  },
  // 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得失敗時の処理
  [getPerBillPersonFailure]: (state) => {
    const { perBillList, perBillInfo, perBillGuide } = state;
    const message = [`個人情報が取得できません。（請求書No  = 
    ${moment(perBillGuide.conditions.dmdDate).format('YYYYMMDD') + perBillGuide.conditions.billSeq.toString().padStart(5, '0') + perBillGuide.conditions.branchNo})`];
    // (これに伴い一覧が再描画される)
    const dataPer = [];
    return { ...state, perBillList: { ...perBillList, dataPer }, perBillInfo: { ...perBillInfo, message } };
  },

  // 個人請求明細情報の取得成功時の処理
  [getPerBillPersonCSuccess]: (state, action) => {
    const { perBillList } = state;
    // 検索指示状態とする
    const searched = true;
    // (これに伴い一覧が再描画される)
    const dataPerC = action.payload;
    return { ...state, perBillList: { ...perBillList, searched, dataPerC } };
  },
  // 請求書更新成功時の処理
  [updatePerBillPersonSuccess]: (state) => {
    const { perBillInfo } = initialState;
    const message = ['保存が完了しました。'];
    return { ...state, perBillInfo: { ...perBillInfo, message } };
  },
  // 請求書更新失敗時の処理
  [updatePerBillPersonFailure]: (state, action) => {
    const { perBillInfo } = initialState;
    const { status, data } = action.payload;
    let message = data;
    const error = 'err';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 400) {
      message = ['保存に失敗しました。'];
    }
    if (message.errors !== undefined) {
      message = ['保存に失敗しました。'];
    }
    return { ...state, perBillInfo: { ...perBillInfo, message, error } };
  },
  // 請求書新規作成成功時の処理
  [createPerBillPersonSuccess]: (state) => {
    const { perBillInfo } = initialState;
    const message = ['保存が完了しました。'];
    return { ...state, perBillInfo: { ...perBillInfo, message } };
  },
  // 請求書新規作成敗時の処理
  [createPerBillPersonFailure]: (state, action) => {
    const { perBillInfo } = initialState;
    const { status, data } = action.payload;
    let message = data;
    const error = 'err';
    if (data.errors !== undefined) {
      message = ['保存に失敗しました。'];
    }
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['保存に失敗しました。'];
    }
    return { ...state, perBillInfo: { ...perBillInfo, message, error } };
  },
  // 個人請求書新規作成のページ管理
  [perBillPageManagement]: (state, action) => {
    const { initial, perIndex, billIndex, perValues, billValues, mode, branchno, selectedItemBill, selectedItemPer } = action.payload;
    let [priceTotal, editPriceTotal, taxPriceTotal, editTaxTotal, total] = [0, 0, 0, 0, 0];
    let { dataC, dataPer, dataNo } = state.perBillList;
    const { perBillGuide, perBillList, perBillInfo } = state;
    let { message } = perBillInfo;
    const { conditions } = perBillGuide;
    let { refresh } = perBillGuide;

    refresh = refresh === 'refresh' ? '' : 'refresh';
    // 初期化
    if (initial === 'initial') {
      conditions.perCount1 = 5;
      conditions.perCount2 = conditions.perCount1 + 5;
      conditions.perCount = new Array(5);
      for (let index = 0; index < 5; index += 1) {
        conditions.perCount[index] = new Array(index + 1);
      }
      conditions.billCount1 = 5;
      conditions.billCount2 = conditions.billCount1 + 5;
      conditions.billCount = new Array(5);
      for (let index = 0; index < 5; index += 1) {
        conditions.billCount[index] = new Array(index + 1);
      }
      conditions.deletePer = null;
      conditions.deleteBill = null;
      conditions.addPerLine = null;
      conditions.addBillLine = null;
    }
    // 個人情報クリア
    if (initial === 'deletePer') {
      conditions.perCount.splice(perIndex, 1, new Array(perIndex + 1));
      conditions.deletePer = 'deleted';
    }
    // 明細情報のクリア
    if (initial === 'deleteBill') {
      conditions.billCount.splice(billIndex, 1, new Array(billIndex + 1));
      conditions.deleteBill = 'deleted';
    }
    // 請求書削除処理
    if (initial === 'deletePerBill') {
      conditions.perCount1 = 5;
      conditions.perCount2 = conditions.perCount1 + 5;
      conditions.perCount = new Array(5);
      for (let index = 0; index < 5; index += 1) {
        conditions.perCount[index] = new Array(index + 1);
      }
      conditions.billCount1 = 5;
      conditions.billCount2 = conditions.billCount1 + 5;
      conditions.billCount = new Array(5);
      for (let index = 0; index < 5; index += 1) {
        conditions.billCount[index] = new Array(index + 1);
      }
      dataC = [];
      dataPer = [];
      dataNo = [];
    }
    // 指定可能個人をの表示処理  表示行数の変更
    if (initial === 'addLine') {
      conditions.addPerLine = 'add';
      if (perValues.perCount === undefined) {
        conditions.perCount1 = 5;
      } else {
        conditions.perCount1 = Number(perValues.perCount);
      }
      // 番号表示処理
      conditions.perCount2 = 5 + Number(conditions.perCount1);
      // 行を追加する
      if (perValues.perCount !== undefined && Number(perValues.perCount) !== conditions.perCount1) {
        for (let i = conditions.perCount1; i < Number(perValues.perCount); i += 1) {
          conditions.perCount.push(new Array(Number(i + 1)));
        }
      }
      // 指定可能明細をの表示処理 表示行数の変更
      if (billValues.billCount === undefined) {
        conditions.billCount1 = 5;
      } else {
        conditions.billCount1 = Number(billValues.billCount);
      }
      // 番号表示処理
      conditions.billCount2 = 5 + Number(conditions.billCount1);
      // 行を追加する
      if (billValues.billCount !== undefined && Number(billValues.billCount) !== conditions.billCount1) {
        for (let i = conditions.billCount1; i < Number(billValues.billCount); i += 1) {
          conditions.billCount.push(new Array(Number(i + 1)));
        }
      }
    }
    // 個人ナビゲーション選択
    if (initial === 'selectPerGuide') {
      conditions.addPerLine = 'add';
      conditions.perIndex = perIndex;
    }
    // 明細ナビゲーション選択
    if (initial === 'selectBillGuid') {
      conditions.addBillLine = 'add';
      conditions.billIndex = billIndex;
    }
    // 更新モード
    if (mode === 'update') {
      // 指定可能個人を数量の処理
      if (dataPer.length >= conditions.perCount1) {
        conditions.perCount1 = Math.ceil(Math.round(dataPer.length / 5) === dataPer.length / 5 ? dataPer.length / 5 + 1 : dataPer.length / 5) * 5;
        conditions.perCount2 = conditions.perCount1 + 5;
        for (let i = conditions.perCount.length; i < conditions.perCount1; i += 1) {
          conditions.perCount.push(new Array(Number(i + 1)));
        }
      } else if (conditions.addPerLine !== 'add' && dataPer.length < 1) {
        conditions.perCount1 = 5;
        conditions.perCount2 = conditions.perCount1 + 5;
        conditions.perCount = new Array(5);
        for (let index = 0; index < 5; index += 1) {
          conditions.perCount[index] = new Array(index + 1);
        }
      }
      // 指定可能明細を数量の処理
      if (dataC.length >= conditions.billCount1) {
        conditions.billCount1 = Math.ceil(Math.round(dataC.length / 5) === dataC.length / 5 ? dataC.length / 5 + 1 : dataC.length / 5) * 5;
        conditions.billCount2 = conditions.billCount1 + 5;
        for (let i = conditions.billCount.length; i < conditions.billCount1; i += 1) {
          conditions.billCount.push(new Array(Number(i + 1)));
        }
      } else if (conditions.addBillLine !== 'add' && dataC.length < 1) {
        conditions.billCount1 = 5;
        conditions.billCount2 = conditions.billCount1 + 5;
        conditions.billCount = new Array(5);
        for (let index = 0; index < 5; index += 1) {
          conditions.billCount[index] = new Array(index + 1);
        }
      }
      if (conditions.deletePer !== 'deleted') {
        // 指定可能個人を初期化する
        dataPer.forEach((value, index) => {
          conditions.perCount.splice(index, 1, value);
        });
      }
      if (conditions.deleteBill !== 'deleted') {
        // 指定可能明細を初期化する
        dataC.forEach((value, index) => {
          conditions.billCount.splice(index, 1, value);
        });
      }
    }
    // 明細ナビゲーション選択完了
    if (initial === 'selectedItemBill') {
      conditions.selectedItemBill = selectedItemBill;
      if (conditions.selectedItemBill.divcd) {
        conditions.selectedItemBill.otherlinedivcd = conditions.selectedItemBill.divcd;
      }
    }
    // 個人ナビゲーション選択完了
    if (initial === 'selectedItemPer') {
      conditions.selectedItemPer = selectedItemPer;
    }
    // 指定の個人情報の挿入
    for (let index = 0; index < conditions.perCount1; index += 1) {
      if (conditions.perCount[index] == null || conditions.perCount[index].constructor === Array) {
        if (conditions.selectedItemPer !== null) {
          conditions.perCount.splice(conditions.perIndex, 1, conditions.selectedItemPer);
          conditions.selectedItemPer = null;
        } else {
          conditions.perCount[index] = new Array(index + 1);
        }
      }
    }
    // 指定の可能明細の挿入
    for (let index = 0; index < conditions.billCount1; index += 1) {
      if (conditions.billCount[index] == null || conditions.billCount[index].constructor === Array) {
        if (conditions.selectedItemBill !== null) {
          conditions.billCount.splice(conditions.billIndex, 1, conditions.selectedItemBill);
          conditions.selectedItemBill = null;
        } else {
          conditions.billCount[index] = new Array(index + 1);
        }
      }
    }

    // 個人請求明細の金額計算
    conditions.billCount.forEach((value) => {
      if (value.constructor === Object) {
        priceTotal += Number(value.price);
        editPriceTotal += Number(value.editprice);
        taxPriceTotal += Number(value.taxprice);
        editTaxTotal += Number(value.edittax);
        total = priceTotal + editPriceTotal + taxPriceTotal + editTaxTotal;
      }
    });
    conditions.priceTotal = priceTotal;
    conditions.editPriceTotal = editPriceTotal;
    conditions.taxPriceTotal = taxPriceTotal;
    conditions.editTaxTotal = editTaxTotal;
    conditions.total = total;
    dataNo.forEach((value, index) => {
      if (index === 0) {
        conditions.delflg = value.delflg;
        conditions.paymentSeq = value.paymentseq;
        conditions.paymentDate = value.paymentdate;
        // パラメータ設定
        if (value.paymentdate !== null) {
          conditions.lngPaymentFlg = 1;
          if (branchno === '1') {
            message = ['返金済のため修正できません。'];
          } else {
            message = ['入金済のため修正できません。'];
          }
        } else {
          conditions.lngPaymentFlg = 0;
          for (let i = 0; i < message.length; i += 1) {
            if (message[i] === '返金済のため修正できません。' || message[i] === '入金済のため修正できません。') {
              message[i] = '';
            }
          }
        }
      }
    });
    if (!(mode !== 'update' || conditions.lngPaymentFlg === 0)) {
      conditions.perCount = [];
      conditions.billCount = [];
      // 指定可能個人を初期化する
      dataPer.forEach((value) => {
        conditions.perCount.push(value);
      });
      // 指定可能明細を初期化する
      dataC.forEach((value) => {
        conditions.billCount.push(value);
      });
    }
    if (conditions.sort === 'sort') {
      conditions.sort = '';
      // 重複を排除する
      for (let i = 0; i < conditions.perCount.length; i += 1) {
        for (let k = 0; k < conditions.perCount.length; k += 1) {
          if (i !== k && conditions.perCount[i].perid !== undefined && conditions.perCount[i].perid === conditions.perCount[k].perid) {
            conditions.perCount[k] = new Array(k + 1);
          }
        }
      }
      // 並べ替える
      for (let i = 1; i < conditions.perCount.length; i += 1) {
        for (let k = 0; k < conditions.perCount.length - i; k += 1) {
          if (conditions.perCount[k].constructor !== Object && conditions.perCount[k + 1].constructor === Object) {
            const arr = conditions.perCount[k];
            conditions.perCount[k] = conditions.perCount[k + 1];
            conditions.perCount[k + 1] = arr;
          }
        }
      }
      for (let i = 1; i < conditions.billCount.length; i += 1) {
        for (let k = 0; k < conditions.billCount.length - i; k += 1) {
          if (conditions.billCount[k].constructor !== Object && conditions.billCount[k + 1].constructor === Object) {
            const arr = conditions.billCount[k];
            conditions.billCount[k] = conditions.billCount[k + 1];
            conditions.billCount[k + 1] = arr;
          }
        }
      }
    }
    conditions.delflgItems1 = [
      { value: conditions.perCount1, name: `${conditions.perCount1}人` },
      { value: conditions.perCount2, name: `${conditions.perCount2}人` }];

    conditions.delflgItems2 = [
      { value: conditions.billCount1, name: `${conditions.billCount1}明細` },
      { value: conditions.billCount2, name: `${conditions.billCount2}明細` }];
    return { ...state, perBillGuide: { ...perBillGuide, conditions, refresh }, perBillList: { ...perBillList, dataC, dataPer, dataNo }, perBillInfo: { ...perBillInfo, message } };
  },
  [getUrlValues]: (state, action) => {
    const { perBillInfo } = state;
    const urlValues = action.payload;
    return { ...state, perBillInfo: { ...perBillInfo, urlValues } };
  },

}, initialState);
