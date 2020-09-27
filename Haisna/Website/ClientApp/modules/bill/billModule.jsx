import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  openOtherIncomeInfoGuideRequest,
  closeOtherIncomeInfoGuide,
  checkValueAndInsertPerBillcRequest,
  checkValueAndInsertPerBillcSuccess,
  checkValueAndInsertPerBillcFailure,
  openGdeOtherIncomeGuideRequest,
  openGdeOtherIncomeGuideSuccess,
  openGdeOtherIncomeGuideFailure,
  closeGdeOtherIncomeGuide,
  // 請求書番号選択画面
  openOtherIncomeSubGuideRequest,
  openOtherIncomeSubGuideSuccess,
  openOtherIncomeSubGuideFailure,
  closeOtherIncomeSubGuide,
  reOtherIncomeInfo,
} = createActions(
  'OPEN_OTHER_INCOME_INFO_GUIDE_REQUEST',
  'CLOSE_OTHER_INCOME_INFO_GUIDE',
  'CHECK_VALUE_AND_INSERT_PER_BILLC_REQUEST',
  'CHECK_VALUE_AND_INSERT_PER_BILLC_SUCCESS',
  'CHECK_VALUE_AND_INSERT_PER_BILLC_FAILURE',
  'OPEN_GDE_OTHER_INCOME_GUIDE_REQUEST',
  'OPEN_GDE_OTHER_INCOME_GUIDE_SUCCESS',
  'OPEN_GDE_OTHER_INCOME_GUIDE_FAILURE',
  'CLOSE_GDE_OTHER_INCOME_GUIDE',
  // 請求書番号選択画面
  'OPEN_OTHER_INCOME_SUB_GUIDE_REQUEST',
  'OPEN_OTHER_INCOME_SUB_GUIDE_SUCCESS',
  'OPEN_OTHER_INCOME_SUB_GUIDE_FAILURE',
  'CLOSE_OTHER_INCOME_SUB_GUIDE',
  'RE_OTHER_INCOME_INFO',
);

// stateの初期値
const initialState = {
  // セット外請求明細登録・修正
  otherIncomeInfoGuide: {
    message: [],
    // 可視状態
    visible: false,
    rsvno: 0,
    billcount: 0,
    dmddate: '',
    billseq: null,
    branchno: null,
  },
  // セット外請求明細の選択
  gdeOtherIncomeGuide: {
    message: [],
    otherlinediv: [],
    // 可視状態
    visible: false,
  },
  // 請求書番号選択
  otherIncomeSubGuide: {
    message: [],
    perBill: [],
    // 可視状態
    visible: false,
  },
};

// reducerの作成
export default handleActions({

  [reOtherIncomeInfo]: (state, action) => {
    const { otherIncomeInfoGuide, otherIncomeSubGuide } = state;
    const { dmddate, billseq, branchno } = action.payload;
    return {
      ...state,
      otherIncomeInfoGuide: { ...otherIncomeInfoGuide, dmddate, billseq, branchno, billcount: 1 },
      otherIncomeSubGuide: { ...otherIncomeSubGuide, visible: false },
    };
  },

  // 開くアクション時の処理
  [openOtherIncomeSubGuideSuccess]: (state, action) => {
    const { otherIncomeSubGuide } = state;
    const perBill = action.payload;
    return { ...state, otherIncomeSubGuide: { ...otherIncomeSubGuide, perBill, visible: true } };
  },
  // 失敗時の処理
  [openOtherIncomeSubGuideFailure]: (state, action) => {
    const { otherIncomeSubGuide } = state;
    const { status, params } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`個人請求書情報が存在しません。（予約番号= ${params.rsvno})`];
    }
    return { ...state, otherIncomeSubGuide: { ...otherIncomeSubGuide, message, visible: true } };
  },
  // 閉じるアクション時の処理
  [closeOtherIncomeSubGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    const { otherIncomeSubGuide } = initialState;
    return { ...state, otherIncomeSubGuide };
  },
  // 閉じるアクション時の処理
  [closeOtherIncomeInfoGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    const { otherIncomeInfoGuide } = initialState;
    return { ...state, otherIncomeInfoGuide };
  },
  // 開くアクション時の処理
  [openOtherIncomeInfoGuideRequest]: (state, action) => {
    const { otherIncomeInfoGuide } = initialState;
    const visible = true;
    const { mode, rsvno, billcount, dmddate, billseq, branchno } = action.payload;
    return { ...state, otherIncomeInfoGuide: { ...otherIncomeInfoGuide, visible, mode, rsvno, billcount, dmddate, billseq, branchno } };
  },
  // 入力チェックと受診確定金額情報、個人請求明細情報の登録失敗時の処理
  [checkValueAndInsertPerBillcFailure]: (state, action) => {
    const { otherIncomeInfoGuide } = state;
    const message = action.payload.data;
    return { ...state, otherIncomeInfoGuide: { ...otherIncomeInfoGuide, message } };
  },
  // 閉じるアクション時の処理
  [closeGdeOtherIncomeGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    const { gdeOtherIncomeGuide } = initialState;
    return { ...state, gdeOtherIncomeGuide };
  },
  // 開くアクション時の処理
  [openGdeOtherIncomeGuideSuccess]: (state, action) => {
    const { gdeOtherIncomeGuide } = state;
    const otherlinediv = action.payload;
    const visible = true;
    return { ...state, gdeOtherIncomeGuide: { ...gdeOtherIncomeGuide, otherlinediv, visible } };
  },
}, initialState);
