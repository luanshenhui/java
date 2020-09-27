import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';
import * as Constants from '../../constants/common';

// actionの作成
export const {
  getAllCtrMngRequest,
  getAllCtrMngSuccess,
  getAllCtrMngFailure,
  registerCopyRequest,
  registerCopySuccess,
  registerCopyFailure,
  registerReleaseRequest,
  registerReleaseSuccess,
  registerReleaseFailure,
  openSelectCourseGuide,
  closeSelectCourseGuide,
  getCtrPtRequest,
  getCtrPtSuccess,
  getCtrPtFailure,
  getPriceOptAllRequest,
  getPriceOptAllSuccess,
  getPriceOptAllFailure,
  getCtrPtOrgPriceRequest,
  getCtrPtOrgPriceSuccess,
  getCtrPtOrgPriceFailure,
  deleteContractRequest,
  deleteContractSuccess,
  deleteContractFailure,
  openCtrSplitGuide,
  closeCtrSplitGuide,
  openCtrStandardGuide,
  closeCtrStandardGuide,
  getCtrMngRequest,
  getCtrMngSuccess,
  getCtrMngFailure,
  registerSplitRequest,
  registerSplitSuccess,
  registerSplitFailure,
  getSplitDate,
  registerCtrPtRequest,
  registerCtrPtSuccess,
  registerCtrPtFailure,
  checkAgeCalc,
  updatePeriodRequest,
  updatePeriodSuccess,
  updatePeriodFailure,
  checkPeriodSuccess,
  checkPeriodFailure,
  getCtrMngWithPeriodRequest,
  getCtrMngWithPeriodSuccess,
  getCtrMngWithPeriodFailure,
  initializePeriod,
  openPeriodGuide,
  closePeriodGuide,
  openCtrSetGuide,
  closeCtrSetGuide,
  openCtrLimitPriceGuide,
  closeCtrLimitPriceGuide,
  getLimitPriceRequest,
  getLimitPriceSuccess,
  getLimitPriceFailure,
  updateLimitPriceRequest,
  updateLimitPriceSuccess,
  updateLimitPriceFailure,
  deleteLimitPriceRequest,
  deleteLimitPriceSuccess,
  deleteLimitPriceFailure,
  deleteOptionRequest,
  deleteOptionSuccess,
  deleteOptionFailure,
  getRowCountRequest,
  initializeDemand,
  selectedDemandRow,
  deleteDemandOrgGuide,
  openDemandGuide,
  closeDemandGuide,
  insertContractRequest,
  insertContractSuccess,
  insertContractFailure,
  updateContractRequest,
  updateContractSuccess,
  updateContractFailure,
  checkDemandValue,
  openCtrCreateWizardGuide,
  closeCtrCreateWizardGuide,
  getCtrMngReferRequest,
  getCtrMngReferSuccess,
  getCtrMngReferFailure,
  referContractRequest,
  referContractSuccess,
  referContractFailure,
  copyContractRequest,
  copyContractSuccess,
  copyContractFailure,
  getSetGuideRequest,
  getSetGuideSuccess,
  getSetGuideFailure,
  setAddOptionRequest,
  setAddOptionSuccess,
  setAddOptionFailure,
  setDeleteOptionItemRequest,
  setAddOptionItemRequest,
} = createActions(
  // 指定団体の全契約情報取得
  'GET_ALL_CTR_MNG_REQUEST',
  'GET_ALL_CTR_MNG_SUCCESS',
  'GET_ALL_CTR_MNG_FAILURE',
  // コピー処理
  'REGISTER_COPY_REQUEST',
  'REGISTER_COPY_SUCCESS',
  'REGISTER_COPY_FAILURE',
  // 参照解除
  'REGISTER_RELEASE_REQUEST',
  'REGISTER_RELEASE_SUCCESS',
  'REGISTER_RELEASE_FAILURE',
  // 契約コースの選択ガイド
  'OPEN_SELECT_COURSE_GUIDE',
  'CLOSE_SELECT_COURSE_GUIDE',
  // 契約パターン情報取得
  'GET_CTR_PT_REQUEST',
  'GET_CTR_PT_SUCCESS',
  'GET_CTR_PT_FAILURE',
  // オプション検査情報取得
  'GET_PRICE_OPT_ALL_REQUEST',
  'GET_PRICE_OPT_ALL_SUCCESS',
  'GET_PRICE_OPT_ALL_FAILURE',
  // 負担元取得団体略称取得
  'GET_CTR_PT_ORG_PRICE_REQUEST',
  'GET_CTR_PT_ORG_PRICE_SUCCESS',
  'GET_CTR_PT_ORG_PRICE_FAILURE',
  // 指定契約パターンの契約情報削除
  'DELETE_CONTRACT_REQUEST',
  'DELETE_CONTRACT_SUCCESS',
  'DELETE_CONTRACT_FAILURE',
  // 契約期間の分割ガイド
  'OPEN_CTR_SPLIT_GUIDE',
  'CLOSE_CTR_SPLIT_GUIDE',
  // 契約基本情報の設定ガイド
  'OPEN_CTR_STANDARD_GUIDE',
  'CLOSE_CTR_STANDARD_GUIDE',
  // 契約情報の読み込み
  'GET_CTR_MNG_REQUEST',
  'GET_CTR_MNG_SUCCESS',
  'GET_CTR_MNG_FAILURE',
  // 契約期間の更新
  'REGISTER_SPLIT_REQUEST',
  'REGISTER_SPLIT_SUCCESS',
  'REGISTER_SPLIT_FAILURE',
  // 分割日チェック
  'GET_SPLIT_DATE',
  // 契約パターンレコードの更新
  'REGISTER_CTR_PT_REQUEST',
  'REGISTER_CTR_PT_SUCCESS',
  'REGISTER_CTR_PT_FAILURE',
  // 年齢起算日チェック
  'CHECK_AGE_CALC',
  // 契約期間を更新
  'UPDATE_PERIOD_REQUEST',
  'UPDATE_PERIOD_SUCCESS',
  'UPDATE_PERIOD_FAILURE',
  // 契約期間をチェック
  'CHECK_PERIOD_SUCCESS',
  'CHECK_PERIOD_FAILURE',
  // 契約期間付きの契約管理情報を取得
  'GET_CTR_MNG_WITH_PERIOD_REQUEST',
  'GET_CTR_MNG_WITH_PERIOD_SUCCESS',
  'GET_CTR_MNG_WITH_PERIOD_FAILURE',
  // 契約期間初期化
  'INITIALIZE_PERIOD',
  // 契約期間GUIDE
  'OPEN_PERIOD_GUIDE',
  'CLOSE_PERIOD_GUIDE',
  // 検査セットの登録ガイド
  'OPEN_CTR_SET_GUIDE',
  'CLOSE_CTR_SET_GUIDE',
  // 限度額の設定ガイド
  'OPEN_CTR_LIMIT_PRICE_GUIDE',
  'CLOSE_CTR_LIMIT_PRICE_GUIDE',
  // 指定契約パターンの負担元および負担金額情報取得(団体)
  'GET_LIMIT_PRICE_REQUEST',
  'GET_LIMIT_PRICE_SUCCESS',
  'GET_LIMIT_PRICE_FAILURE',
  // 限度額情報の更新
  'UPDATE_LIMIT_PRICE_REQUEST',
  'UPDATE_LIMIT_PRICE_SUCCESS',
  'UPDATE_LIMIT_PRICE_FAILURE',
  // 限度額情報の削除
  'DELETE_LIMIT_PRICE_REQUEST',
  'DELETE_LIMIT_PRICE_SUCCESS',
  'DELETE_LIMIT_PRICE_FAILURE',
  // オプションの削除
  'DELETE_OPTION_REQUEST',
  'DELETE_OPTION_SUCCESS',
  'DELETE_OPTION_FAILURE',
  // 負担元初期の表示行の取得
  'GET_ROW_COUNT_REQUEST',
  // 負担元を初期化
  'INITIALIZE_DEMAND',
  // 負担元の選択行取得
  'SELECTED_DEMAND_ROW',
  // 負担元团体の削除
  'DELETE_DEMAND_ORG_GUIDE',
  // 開く負担元の設定
  'OPEN_DEMAND_GUIDE',
  // 負担元を閉じる
  'CLOSE_DEMAND_GUIDE',
  // 新しい契約情報を作成
  'INSERT_CONTRACT_REQUEST',
  'INSERT_CONTRACT_SUCCESS',
  'INSERT_CONTRACT_FAILURE',
  // 契約情報の更新（負担元情報・負担金額情報）
  'UPDATE_CONTRACT_REQUEST',
  'UPDATE_CONTRACT_SUCCESS',
  'UPDATE_CONTRACT_FAILURE',
  // 負担元の入力チェック
  'CHECK_DEMAND_VALUE',
  // 契約情報新規ウィザード
  'OPEN_CTR_CREATE_WIZARD_GUIDE',
  'CLOSE_CTR_CREATE_WIZARD_GUIDE',
  // 参照先団体の契約情報が参照元団体から参照可能取得
  'GET_CTR_MNG_REFER_REQUEST',
  'GET_CTR_MNG_REFER_SUCCESS',
  'GET_CTR_MNG_REFER_FAILURE',
  // 契約情報の参照処理
  'REFER_CONTRACT_REQUEST',
  'REFER_CONTRACT_SUCCESS',
  'REFER_CONTRACT_FAILURE',
  // 契約情報のコピー処理
  'COPY_CONTRACT_REQUEST',
  'COPY_CONTRACT_SUCCESS',
  'COPY_CONTRACT_FAILURE',
  // 契約情報(検査セットの登録)
  'GET_SET_GUIDE_REQUEST',
  'GET_SET_GUIDE_SUCCESS',
  'GET_SET_GUIDE_FAILURE',
  // 追加オプション書き込み
  'SET_ADD_OPTION_REQUEST',
  'SET_ADD_OPTION_SUCCESS',
  'SET_ADD_OPTION_FAILURE',
  'SET_DELETE_OPTION_ITEM_REQUEST',
  'SET_ADD_OPTION_ITEM_REQUEST',
);

// stateの初期値
const initialState = {
  contractGuideHeader: {
    data: {},
  },
  contractEdit: {
    message: [],
  },
  contractList: {
    message: [],
    // 以下一覧用
    conditions: {
      strDate: null,
      endDate: null,
      orgcd1: '',
      orgcd2: '',
    }, // 検索条件
    data: [],
    headerRefresh: false,
  },
  ctrSelectCourseGuide: {
    data: [],
    visible: false,
  },
  ctrDetailList: {
    message: [],
    item: [],
    data: {},
    sets: {},
    gender: '',
    csCd: '',
    setClassCd: '',
    cslDivCd: '',
    strAge: '',
    endAge: '',
    headerRefresh: false,
    detailRefresh: false,
  },
  ctrSplitPeriodGuide: {
    message: [],
    visible: false,
  },
  ctrStandardGuide: {
    message: [],
    visible: false,
    data: {},
    // 年齢起算方法
    ingagecalc: 0,
    // 年齢起算日（年）
    ingagecalcyear: 0,
    // 年齢起算日（月）
    ingagecalcmonth: 0,
    // 年齢起算日（日）
    ingagecalcday: 0,
  },
  ctrPeriod: {
    message: [],
    dtmArrDate: [],
    ctrPtData: {
      strdate: moment(),
      enddate: moment(Constants.DATERANGE_MAX),
    },
  },
  ctrPeriodGuide: {
    visible: false,
    message: [],
    csCd: null,
    dtmArrDate: [],
    ctrPtData: {
      strdate: new Date(),
      enddate: new Date(Constants.DATERANGE_MAX),
    },
  },
  ctrSetGuide: {
    message: [],
    visible: false,
    mode: '',
    optcd: '',
    optbranchno: '',
    grpData: [],
    itemData: [],
  },
  ctrLimitPriceGuide: {
    message: [],
    // 契約パターン情報
    ctrPtdata: {},
    // 負担元情報
    bdnItems: [],
    // 負担元ドロップダウン
    orgSNameItems: [],
    // 対象負担元
    seqOrg: null,
    // 減算した金額の負担元
    seqBdnOrg: null,
    visible: false,
  },
  ctrDemandGuide: {
    message: [],
    // 以下ガイド用
    visible: false, // 可視状態
    ctrptorgpridedata: [],
    selectedCount: [],
    selectedNowCount: null,
    deleteflg: false,
    selectedContent: [],
    apdiv: [],
    seq: [],
    orgcd1: [],
    orgcd2: [],
    price: [],
    taxflg: [],
    strOptBurden: [],
    strLimitPriceFlg: [],
    rowCount: 10,
  },
  ctrCreateWizard: {
    visible: false,
  },
  ctrBrowseContract: {
    message: [],
    data: [],
  },
};

// reducerの作成
export default handleActions({
  // 指定団体の全契約情報取得開始時の処理
  [getAllCtrMngRequest]: (state, action) => {
    const { contractList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, contractList: { ...contractList, conditions, headerRefresh: false } };
  },
  // 指定団体の全契約情報取得成功時の処理
  [getAllCtrMngSuccess]: (state, action) => {
    const { contractList } = state;
    // 総件数とデータとを更新する
    const { data } = action.payload;
    const message = [];
    return { ...state, contractList: { ...contractList, message, data } };
  },
  // 指定団体の全契約情報取得失敗時の処理
  [getAllCtrMngFailure]: (state, action) => {
    const { contractList } = state;
    const { status } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['検索条件を満たす契約情報は存在しません。'];
    }
    return { ...state, contractList: { ...contractList, message, data: [] } };
  },
  // 契約情報のコピー処理成功時の処理
  [registerCopySuccess]: (state) => {
    const { contractList } = state;
    const message = [];
    return { ...state, contractList: { ...contractList, message, headerRefresh: true } };
  },
  // 契約情報のコピー処理失敗時の処理
  [registerCopyFailure]: (state, action) => {
    const { contractList } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, contractList: { ...contractList, message } };
  },
  // 参照を解除処理成功時の処理
  [registerReleaseSuccess]: (state) => {
    const { contractList } = state;
    const message = [];
    return { ...state, contractList: { ...contractList, message, headerRefresh: true } };
  },
  // 参照を解除処理失敗時の処理
  [registerReleaseFailure]: (state, action) => {
    const { contractList } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, contractList: { ...contractList, message } };
  },
  // 契約コースの選択ガイドを開くアクション時の処理
  [openSelectCourseGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrSelectCourseGuide } = initialState;
    return { ...state, ctrSelectCourseGuide: { ...ctrSelectCourseGuide, visible } };
  },
  // 契約コースの選択ガイドを閉じるアクション時の処理
  [closeSelectCourseGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrSelectCourseGuide } = initialState;
    return { ...state, ctrSelectCourseGuide };
  },
  // 指定契約パターンの契約期間および年齢起算日開始時の処理
  [getCtrPtRequest]: (state, action) => {
    const { ctrDetailList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, ctrDetailList: { ...ctrDetailList, conditions, headerRefresh: false } };
  },
  // 指定契約パターンの契約期間および年齢起算日成功時の処理
  [getCtrPtSuccess]: (state, action) => {
    const { ctrDetailList, ctrStandardGuide, ctrPeriod, ctrPeriodGuide } = state;
    // (これに伴い一覧が再描画される)
    const data = action.payload;
    const ctrPtData = data;
    // 年齢起算日の設定
    let { agecalc } = data;
    let { ingagecalc, ingagecalcyear, ingagecalcmonth, ingagecalcday } = ctrStandardGuide;

    if (agecalc !== null && agecalc.length === 8) {
      ingagecalc = 1;
      ingagecalcyear = agecalc.substr(0, 4);
      ingagecalcmonth = agecalc.substr(4, 2);
      ingagecalcday = agecalc.substr(6, 2);
    } else if (agecalc !== null && agecalc.length === 4) {
      ingagecalc = 1;
      ingagecalcyear = 0;
      ingagecalcmonth = agecalc.substr(0, 2);
      ingagecalcday = agecalc.substr(2, 2);
    } else {
      ingagecalc = 0;
      ingagecalcyear = 0;
      ingagecalcmonth = 0;
      ingagecalcday = 0;
    }
    if (ingagecalcmonth.length === 2) {
      const monthcheck = ingagecalcmonth.substr(0, 1);
      if (monthcheck === '0') {
        ingagecalcmonth = ingagecalcmonth.substr(1, 1);
      }
    }
    if (ingagecalcday.length === 2) {
      const daycheck = ingagecalcday.substr(0, 1);
      if (daycheck === '0') {
        ingagecalcday = ingagecalcday.substr(1, 1);
      }
    }
    agecalc = (ingagecalcyear.toString().padStart(4, '0')) + (ingagecalcmonth.toString().padStart(2, '0')) + (ingagecalcday.toString().padStart(2, '0'));

    return {
      ...state,
      ctrDetailList: { ...ctrDetailList, data },
      ctrStandardGuide: { ...ctrStandardGuide, data: { ...data, agecalc }, ingagecalc, ingagecalcyear, ingagecalcmonth, ingagecalcday },
      ctrPeriod: { ...ctrPeriod, ctrPtData },
      ctrPeriodGuide: { ...ctrPeriodGuide, ctrPtData },
    };
  },
  // 指定契約パターンの契約期間および年齢起算日失敗時の処理
  [getCtrPtFailure]: (state, action) => {
    const { contractDetailEdit, ctrPeriodGuide } = state;
    const { status, data } = action.payload;
    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['契約情報が存在しません。'];
    }
    return { ...state, contractDetailEdit: { ...contractDetailEdit, message }, ctrPeriodGuide: { ...ctrPeriodGuide, message } };
  },
  // 指定契約パターンの負担元および負担金額情報成功時の処理
  [getCtrPtOrgPriceSuccess]: (state, action) => {
    const { ctrDetailList, ctrDemandGuide } = state;
    // (これに伴い一覧が再描画される)
    const data = action.payload;
    const ctrptorgpridedata = data;
    let rowCount = 10;

    if (ctrptorgpridedata.length > rowCount) {
      rowCount = Math.floor((ctrptorgpridedata.length / 5) + 1) * 5;
    }

    return { ...state, ctrDetailList: { ...ctrDetailList, item: data }, ctrDemandGuide: { ...ctrDemandGuide, ctrptorgpridedata, rowCount } };
  },
  // 指定契約パターンにおける指定オプション区分の全負担情報取得成功時の処理
  [getPriceOptAllSuccess]: (state, action) => {
    const { ctrDetailList } = state;
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    let prevOptCd = '';
    let prevOptBranchNo = '';
    let bdnCount = 0;
    let count = 0;
    let editBdnCount = 0;
    let dataCount = 0;
    const optcd = [];
    const optbranchno = [];
    const setcolor = [];
    const optname = [];
    const csldivname = [];
    const gender = [];
    const agename = [];
    const addcondition = [];
    const exceptlimit = [];
    const price = [];
    const tax = [];
    while (dataCount < data.length && data.length > 0) {
      // 直前のレコードとオプションコードまたは枝番が異なる場合
      if ((data[dataCount].optcd !== prevOptCd) || (data[dataCount].optbranchno !== prevOptBranchNo)) {
        optcd[count] = data[dataCount].optcd;
        optbranchno[count] = data[dataCount].optbranchno;
        setcolor[count] = data[dataCount].setcolor;
        optname[count] = data[dataCount].optname;
        csldivname[count] = data[dataCount].csldivname;
        gender[count] = data[dataCount].gender;
        agename[count] = data[dataCount].agename;
        addcondition[count] = data[dataCount].addcondition;
        exceptlimit[count] = data[dataCount].exceptlimit;
        count += 1;
        editBdnCount = 0;
      } else {
        bdnCount += 1;
      }
      if (editBdnCount >= price.length || bdnCount === 0) {
        price[bdnCount] = [];
        tax[bdnCount] = [];
      }
      // 負担情報は毎回編集
      price[editBdnCount][count - 1] = data[dataCount].price;
      tax[editBdnCount][count - 1] = data[dataCount].tax;
      editBdnCount += 1;
      // 直前情報を更新
      prevOptCd = data[dataCount].optcd;
      prevOptBranchNo = data[dataCount].optbranchno;
      dataCount += 1;
    }

    return {
      ...state,
      ctrDetailList: {
        ...ctrDetailList,
        message: [],
        sets: { count, optcd, optbranchno, setcolor, optname, csldivname, gender, agename, addcondition, exceptlimit, price, tax },
        detailRefresh: true,
      },
    };
  },
  // 指定契約パターンにおける指定オプション区分の全負担情報取得失敗時の処理
  [getPriceOptAllFailure]: (state, action) => {
    const { ctrDetailList } = state;
    const { status, data } = action.payload;
    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['検索条件を満たす検査セットは存在しません。'];
    }
    return { ...state, ctrDetailList: { ...ctrDetailList, message, item: [], sets: [] } };
  },
  // 契約情報削除失敗時の処理
  [deleteContractFailure]: (state, action) => {
    const { contractDetailEdit } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, contractDetailEdit: { ...contractDetailEdit, message } };
  },
  // 契約情報取得成功時の処理
  [getCtrMngSuccess]: (state, action) => {
    const { contractGuideHeader } = state;
    const data = action.payload;
    return { ...state, contractGuideHeader: { ...contractGuideHeader, data } };
  },
  // 契約情報取得失敗時の処理
  [getCtrMngFailure]: (state, action) => {
    const { ctrSplitPeriodGuide, ctrStandardGuide } = state;
    const { status } = action.payload;
    let message = [];
    // HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['契約情報が存在しません。'];
    }
    return { ...state, ctrSplitPeriodGuide: { ...ctrSplitPeriodGuide, message }, ctrStandardGuide: { ...ctrStandardGuide, message } };
  },
  // 分割日チェック処理
  [getSplitDate]: (state) => {
    const { ctrSplitPeriodGuide } = state;
    const message = ['分割日を入力して下さい。'];
    return { ...state, ctrSplitPeriodGuide: { ...ctrSplitPeriodGuide, message } };
  },
  // 契約期間の分割成功時の処理
  [registerSplitSuccess]: (state) => {
    const { ctrDetailList } = state;
    const { ctrSplitPeriodGuide } = initialState;
    return {
      ...state, ctrSplitPeriodGuide, ctrDetailList: { ...ctrDetailList, headerRefresh: true } };
  },
  // 契約期間の分割失敗時の処理
  [registerSplitFailure]: (state, action) => {
    const { ctrSplitPeriodGuide } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, ctrSplitPeriodGuide: { ...ctrSplitPeriodGuide, message } };
  },
  // 起算日チェック処理
  [checkAgeCalc]: (state, checkParams) => {
    const { ctrStandardGuide } = state;
    let message = [];
    if (checkParams.payload === 0) {
      message = ['年齢起算日を直接指定する場合は月日を入力して下さい。'];
    }
    if (checkParams.payload === 1) {
      message = ['年齢起算日の入力形式が正しくありません。'];
    }
    return { ...state, ctrStandardGuide: { ...ctrStandardGuide, message } };
  },
  // 契約パターンレコードの更新成功時の処理
  [registerCtrPtSuccess]: (state, action) => {
    const visible = false;
    const { ctrStandardGuide, ctrDetailList } = state;
    const data = action.payload;
    return { ...state, ctrStandardGuide: { ...ctrStandardGuide, data, visible }, ctrDetailList: { ...ctrDetailList, headerRefresh: true } };
  },
  // ガイドを開くアクション時の処理
  [openCtrSplitGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrSplitPeriodGuide } = initialState;
    return { ...state, ctrSplitPeriodGuide: { ...ctrSplitPeriodGuide, visible } };
  },
  // 閉じるアクション時の処理
  [closeCtrSplitGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrSplitPeriodGuide } = initialState;
    return { ...state, ctrSplitPeriodGuide };
  },
  // ガイドを開くアクション時の処理
  [openCtrStandardGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrStandardGuide } = initialState;
    return { ...state, ctrStandardGuide: { ...ctrStandardGuide, visible } };
  },
  // 閉じるアクション時の処理
  [closeCtrStandardGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrStandardGuide } = initialState;
    return { ...state, ctrStandardGuide };
  },
  // 検査セットの登録ガイドを開くアクション時の処理
  [openCtrSetGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { mode, optcd, optbranchno } = action.payload;
    const { ctrSetGuide } = initialState;
    const { ctrDetailList } = state;
    return {
      ...state, ctrSetGuide: { ...ctrSetGuide, visible, mode, optcd, optbranchno }, ctrDetailList: { ...ctrDetailList, detailRefresh: false } };
  },
  // 検査セットの登録閉じるアクション時の処理
  [closeCtrSetGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrSetGuide } = initialState;
    return { ...state, ctrSetGuide };
  },
  // 契約期間登録成功時の処理
  [updatePeriodSuccess]: (state) => {
    const { ctrPeriodGuide, ctrDetailList } = state;
    const visible = false;
    return {
      ...state,
      ctrDetailList: { ...ctrDetailList, headerRefresh: true },
      ctrPeriodGuide: { ...ctrPeriodGuide, visible },
    };
  },
  // 契約期間登録失敗時の処理
  [updatePeriodFailure]: (state, action) => {
    const { ctrPeriod, ctrPeriodGuide } = state;
    const { status, data } = action.payload;
    const message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (message && status === 400) {
      message.push(data);
    }
    return { ...state, ctrPeriod: { ...ctrPeriod, message }, ctrPeriodGuide: { ...ctrPeriodGuide, message } };
  },
  // 契約期間付きの契約管理情報を取得成功時の処理
  [getCtrMngWithPeriodSuccess]: (state, action) => {
    const { ctrPeriod, ctrPeriodGuide } = state;
    // 総件数とデータとを更新する
    const { dtmArrDate } = action.payload;
    return { ...state, ctrPeriod: { ...ctrPeriod, dtmArrDate }, ctrPeriodGuide: { ...ctrPeriodGuide, dtmArrDate, message: [] } };
  },
  // 約期間付きの契約管理情報を取得失敗時の処理
  [getCtrMngWithPeriodFailure]: (state, action) => {
    const { ctrPeriod, ctrPeriodGuide } = state;
    const { status, dtmArrDate } = action.payload;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      return {
        ...state,
        ctrPeriod: { ...ctrPeriod, dtmArrDate: [] },
        ctrPeriodGuide: { ...ctrPeriodGuide, dtmArrDate: [], message: [] },
      };
    }
    return { ...state, ctrPeriod: { ...ctrPeriod, dtmArrDate }, ctrPeriodGuide: { ...ctrPeriodGuide, dtmArrDate } };
  },
  // 契約期間チェック成功時の処理
  [checkPeriodSuccess]: (state) => {
    const { ctrPeriod, ctrPeriodGuide } = state;
    return { ...state, ctrPeriod: { ...ctrPeriod, message: [] }, ctrPeriodGuide: { ...ctrPeriodGuide, message: [] } };
  },
  // 契約期間チェック失敗時の処理
  [checkPeriodFailure]: (state, action) => {
    const { ctrPeriod, ctrPeriodGuide } = state;
    const { status, errors } = action.payload;

    let message = [];
    if (status && status === 404) {
      message = ['すでに登録済みの契約情報と契約期間が重複します。'];
    } else {
      message = errors;
    }
    return { ...state, ctrPeriod: { ...ctrPeriod, message }, ctrPeriodGuide: { ...ctrPeriodGuide, message } };
  },
  // 契約期間の指定画面の初期化
  [initializePeriod]: (state) => {
    const { ctrPeriod, ctrPeriodGuide } = initialState;
    const { ctrPtData } = ctrPeriod;
    const strdate = moment().format('YYYY/MM/DD');
    const enddate = new Date(Constants.DATERANGE_MAX);
    return { ...state, ctrPeriodGuide: { ...ctrPeriodGuide, message: [] }, ctrPeriod: { ...ctrPeriod, ctrPtData: { ...ctrPtData, strdate, enddate } } };
  },
  // ガイドを開くアクション時の処理
  [openPeriodGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrPeriodGuide } = initialState;
    const { csCd } = action.payload;
    return { ...state, ctrPeriodGuide: { ...ctrPeriodGuide, visible, csCd } };
  },
  // ガイドを閉じるアクション時の処理
  [closePeriodGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrPeriodGuide } = initialState;
    return { ...state, ctrPeriodGuide };
  },
  // 限度額の設定ガイドガイドを開くアクション時の処理
  [openCtrLimitPriceGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrLimitPriceGuide } = state;
    return { ...state, ctrLimitPriceGuide: { ...ctrLimitPriceGuide, visible } };
  },
  // 限度額の設定ガイド閉じるアクション時の処理
  [closeCtrLimitPriceGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrLimitPriceGuide } = initialState;
    return { ...state, ctrLimitPriceGuide };
  },
  // 指定契約パターンの負担元および負担金額情報(団体)成功時の処理
  [getLimitPriceSuccess]: (state, action) => {
    const { ctrLimitPriceGuide } = state;
    // (これに伴い一覧が再描画される)
    const { bdn, org, ctrPtdata } = action.payload;
    const orgSNameItems = [];
    let seqOrg;
    let seqBdnOrg;

    // 負担元情報の検索
    bdn.forEach((item) => {
      // 契約団体自身の場合は団体名称を取得
      if (item.apdiv === Constants.APDIV_MYORG) {
        orgSNameItems.push({ value: item.seq.toString(), name: org.orgsname });
      } else {
        orgSNameItems.push({ value: item.seq.toString(), name: item.orgsname });
      }
      // 限度額負担フラグ値の変換
      switch (item.limitpriceflg) {
        case 0:
          seqOrg = item.seq.toString();
          break;
        case 1:
          seqBdnOrg = item.seq.toString();
          break;
        default:
          break;
      }
    });
    return { ...state, ctrLimitPriceGuide: { ...ctrLimitPriceGuide, ctrPtdata, bdnItems: bdn, orgSNameItems, seqOrg, seqBdnOrg } };
  },
  // 指定契約パターンの負担元および負担金額情報(団体)失敗時の処理
  [getLimitPriceFailure]: (state, action) => {
    const { ctrLimitPriceGuide } = state;
    const { ptdata, bdndata } = action.payload;
    let message = [];
    // HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (ptdata === null) {
      message = ['契約情報が存在しません。'];
    } else if (bdndata === null) {
      message = ['契約パターン負担元情報が存在しません。'];
    }
    return { ...state, ctrLimitPriceGuide: { ...ctrLimitPriceGuide, message } };
  },
  // 限度額情報更新成功時の処理
  [updateLimitPriceSuccess]: (state) => {
    const { ctrDetailList } = state;
    const { ctrLimitPriceGuide } = initialState;
    return { ...state, ctrLimitPriceGuide, ctrDetailList: { ...ctrDetailList, headerRefresh: true } };
  },
  // 限度額情報更新失敗時の処理
  [updateLimitPriceFailure]: (state, action) => {
    const { ctrLimitPriceGuide } = state;
    const { data } = action.payload;

    return { ...state, ctrLimitPriceGuide: { ...ctrLimitPriceGuide, message: data } };
  },
  // 限度額情報削除成功時の処理
  [deleteLimitPriceSuccess]: (state) => {
    const { ctrDetailList } = state;
    const { ctrLimitPriceGuide } = initialState;
    return { ...state, ctrLimitPriceGuide, ctrDetailList: { ...ctrDetailList, headerRefresh: true } };
  },
  // 限度額情報削除失敗時の処理
  [deleteLimitPriceFailure]: (state, action) => {
    const { ctrLimitPriceGuide } = state;
    const { data } = action.payload;
    let message = [];
    if (data) {
      message = data;
    }
    return { ...state, ctrLimitPriceGuide: { ...ctrLimitPriceGuide, message } };
  },
  // オプションの削除成功時の処理
  [deleteOptionSuccess]: (state) => {
    const { ctrSetGuide } = initialState;
    const { ctrDetailList } = state;
    return { ...state, ctrSetGuide: { ...ctrSetGuide, visible: false, message: [] }, ctrDetailList: { ...ctrDetailList, detailRefresh: true } };
  },
  // オプションの削除失敗時の処理
  [deleteOptionFailure]: (state, action) => {
    const { ctrSetGuide } = state;
    const { data } = action.payload;
    let message = [];
    if (data) {
      message = data;
    }
    return { ...state, ctrSetGuide: { ...ctrSetGuide, message } };
  },
  // 負担元初期の表示行を取得アクション時の処理
  [getRowCountRequest]: (state, action) => {
    const { ctrDemandGuide } = state;
    const { rowCount } = action.payload;

    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, rowCount } };
  },
  // 負担元を初期化
  [initializeDemand]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrDemandGuide } = state;
    const selectedCount = [];
    const selectedNowCount = null;
    const deleteflg = false;
    const selectedContent = [];
    const apdiv = [];
    const seq = [];
    const orgcd1 = [];
    const orgcd2 = [];
    const price = [];
    const taxflg = [];
    const strOptBurden = [];
    const strLimitPriceFlg = [];
    const rowCount = 10;
    const message = [];
    const ctrptorgpridedata = [];
    return {
      ...state,
      ctrDemandGuide: {
        ...ctrDemandGuide,
        message,
        seq,
        apdiv,
        orgcd1,
        orgcd2,
        selectedCount,
        selectedNowCount,
        deleteflg,
        price,
        taxflg,
        strOptBurden,
        strLimitPriceFlg,
        selectedContent,
        rowCount,
        ctrptorgpridedata,
      },
    };
  },
  // 負担元選択团体の処理
  [selectedDemandRow]: (state, action) => {
    // 可視状態をtrueにする
    const deleteflg = false;
    const { ctrDemandGuide } = state;
    const { selectedCount, selectedNowCount } = action.payload;

    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, selectedCount, selectedNowCount, deleteflg } };
  },
  // 負担元削除团体の処理
  [deleteDemandOrgGuide]: (state, action) => {
    // ガイドのstateを初期状態に戻す
    const deleteflg = true;
    const { ctrDemandGuide } = state;
    const { selectedNowCount } = action.payload;

    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, selectedNowCount, deleteflg } };
  },

  // 負担元ガイドを開くアクション時の処理
  [openDemandGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrDemandGuide } = state;
    const { ctrPtData } = ctrDemandGuide;
    const { strdate, enddate } = action.payload;

    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, visible, ctrPtData: { ...ctrPtData, strdate, enddate } } };
  },
  // 負担元ガイドを閉じるアクション時の処理
  [closeDemandGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrDemandGuide } = initialState;
    return { ...state, ctrDemandGuide };
  },
  // 新しい契約情報を作成成功時の処理
  [insertContractSuccess]: (state) => {
    const { ctrCreateWizard, contractList } = state;
    const visible = false;
    return { ...state, contractList: { ...contractList, headerRefresh: true }, ctrCreateWizard: { ...ctrCreateWizard, visible } };
  },
  // 新しい契約情報を作成失敗時の処理
  [insertContractFailure]: (state, action) => {
    const { ctrDemandGuide } = state;
    const { status, data } = action.payload;
    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }
    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, message } };
  },
  // 契約情報の更新（負担元情報・負担金額情報）成功時の処理
  [updateContractSuccess]: (state) => {
    const { ctrDemandGuide } = state;
    const visible = false;
    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, visible } };
  },
  // 契約情報の更新（負担元情報・負担金額情報）失敗時の処理
  [updateContractFailure]: (state, action) => {
    const { ctrDemandGuide } = state;
    const { status, data } = action.payload;
    let message = data.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の団体情報は存在しませんでした。'];
    }
    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, message } };
  },
  // 負担元入力チェック
  [checkDemandValue]: (state, action) => {
    const { ctrDemandGuide } = state;
    const { message } = action.payload;

    return { ...state, ctrDemandGuide: { ...ctrDemandGuide, message } };
  },
  // 契約情報新規ウィザードを開くアクション時の処理
  [openCtrCreateWizardGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { ctrCreateWizard } = state;
    return { ...state, ctrCreateWizard: { ...ctrCreateWizard, visible } };
  },
  // 契約情報新規ウィザードを閉じるアクション時の処理
  [closeCtrCreateWizardGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrCreateWizard, ctrPeriodGuide } = initialState;
    return { ...state, ctrCreateWizard, ctrPeriodGuide };
  },
  // 参照先団体の契約情報が参照元団体から参照可能情報取得成功時の処理
  [getCtrMngReferSuccess]: (state, action) => {
    const { ctrBrowseContract } = state;
    const { data } = action.payload;
    return { ...state, ctrBrowseContract: { ...ctrBrowseContract, data } };
  },
  // 参照先団体の契約情報が参照元団体から参照可能情報取得失敗時の処理
  [getCtrMngReferFailure]: (state, action) => {
    const { ctrBrowseContract } = state;
    const { status } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = ['参照先団体の契約情報が存在しません。'];
    }
    return { ...state, ctrBrowseContract: { ...ctrBrowseContract, message } };
  },
  // 契約情報の参照失敗時の処理
  [referContractFailure]: (state, action) => {
    const { ctrBrowseContract } = state;
    const { status, data } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 400) {
      message = [data.errors];
    }
    return { ...state, ctrBrowseContract: { ...ctrBrowseContract, message } };
  },
  // 契約情報のコピー失敗時の処理
  [copyContractFailure]: (state, action) => {
    const { ctrBrowseContract } = state;
    const { status, data } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [data.errors];
    }
    return { ...state, ctrBrowseContract: { ...ctrBrowseContract, message } };
  },
  // 検査セットの情報取得成功時の処理
  [getSetGuideSuccess]: (state, action) => {
    const { ctrSetGuide } = state;
    const { grpData, itemData } = action.payload;
    return { ...state, ctrSetGuide: { ...ctrSetGuide, grpData, itemData } };
  },
  // 検査セットの情報取得失敗時の処理
  [getSetGuideFailure]: (state, action) => {
    const { ctrSetGuide } = state;
    const { message } = action.payload;
    if (message) {
      return { ...state, ctrSetGuide: { ...ctrSetGuide, message } };
    }
    return { ...state, ctrSetGuide: { ...ctrSetGuide, message: [] } };
  },
  // 検査セットの登録成功時の処理
  [setAddOptionSuccess]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { ctrSetGuide } = initialState;
    const { ctrDetailList } = state;
    return {
      ...state, ctrSetGuide, ctrDetailList: { ...ctrDetailList, detailRefresh: true } };
  },
  // 検査セットの登録失敗時の処理
  [setAddOptionFailure]: (state, action) => {
    const { ctrSetGuide } = state;
    const { data } = action.payload;
    if (data) {
      return { ...state, ctrSetGuide: { ...ctrSetGuide, message: data } };
    }
    return { ...state, ctrSetGuide: { ...ctrSetGuide, message: [] } };
  },
  // 検査セット検査項目を削除する(固定見出しは非対象)時の処理
  [setDeleteOptionItemRequest]: (state, action) => {
    const { ctrSetGuide } = state;
    const { grpData, itemData } = ctrSetGuide;
    const optionitems = action.payload;
    const wkItemData = itemData.slice();
    const wkGrpData = grpData.slice();
    let grpindex = -1;
    let itemindex = -1;
    if (optionitems) {
      for (let i = 0; i < optionitems.length; i += 1) {
        if (optionitems[i] !== 'G0' && optionitems[i] !== 'I0') {
          grpindex = wkGrpData.findIndex((rec) => (rec.grpcd === optionitems[i]));
          if (grpindex !== undefined && grpindex !== -1) {
            wkGrpData.splice(grpindex, 1);
          }
          itemindex = wkItemData.findIndex((rec) => (rec.itemcd === optionitems[i]));
          if (itemindex !== undefined && itemindex !== -1) {
            wkItemData.splice(itemindex, 1);
          }
        }
      }
    }
    return { ...state, ctrSetGuide: { ...ctrSetGuide, grpData: wkGrpData, itemData: wkItemData } };
  },
  // 検査セット検査項目をADDする(固定見出しは非対象)時の処理
  [setAddOptionItemRequest]: (state, action) => {
    const { ctrSetGuide } = state;
    const { grpData, itemData } = ctrSetGuide;
    const optionitems = action.payload;
    const wkItemData = itemData.slice();
    const wkGrpData = grpData.slice();
    if (optionitems) {
      for (let i = 0; i < optionitems.length; i += 1) {
        if (optionitems[i].tableDiv === 1) {
          const index = wkItemData.findIndex((rec) => (rec.itemcd === optionitems[i].itemCd));
          if (index === undefined || index === -1) {
            wkItemData.push({ itemcd: optionitems[i].itemCd, requestname: optionitems[i].itemName });
          }
        } else if (optionitems[i].tableDiv === 2) {
          const index = wkGrpData.findIndex((rec) => (rec.grpcd === optionitems[i].grpCd));
          if (index === undefined || index === -1) {
            wkGrpData.push({ grpcd: optionitems[i].grpCd, grpname: optionitems[i].itemName });
          }
        }
      }
    }
    return { ...state, ctrSetGuide: { ...ctrSetGuide, grpData: wkGrpData, itemData: wkItemData } };
  },

}, initialState);
