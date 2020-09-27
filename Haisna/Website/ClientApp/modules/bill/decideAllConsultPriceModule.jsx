import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  initializeDmdDecideAllPrice,
  dmdDecideAllPriceRequest,
  dmdDecideAllPriceSuccess,
  dmdDecideAllPriceFailure,
} = createActions(
  // 初期化
  'INITIALIZE_DMD_DECIDE_ALL_PRICE',
  // 確定
  'DMD_DECIDE_ALL_PRICE_REQUEST',
  'DMD_DECIDE_ALL_PRICE_SUCCESS',
  'DMD_DECIDE_ALL_PRICE_FAILURE',
);

// stateの初期値
const initialState = {
  dmdDecideAllPrice: {
    conditions: {
      strDate: moment().format('YYYY/MM/DD'),
      endDate: moment().format('YYYY/MM/DD'),
      putLog: null,
      orgCd1: '',
      orgCd2: '',
    }, // 確定条件
    message: [],
  },
};

// reducerの作成
export default handleActions({
  // 画面の初期化
  [initializeDmdDecideAllPrice]: (state) => {
    const { dmdDecideAllPrice } = initialState;
    return { ...state, dmdDecideAllPrice: { ...dmdDecideAllPrice } };
  },
  // 個人受診金額再作成に成功
  [dmdDecideAllPriceSuccess]: (state, action) => {
    const { dmdDecideAllPrice } = state;
    const { message } = action.payload;

    return { ...state, dmdDecideAllPrice: { ...dmdDecideAllPrice, message } };
  },
  // 個人受診金額再作成に失敗
  [dmdDecideAllPriceFailure]: (state, action) => {
    const { dmdDecideAllPrice } = state;
    const { message } = action.payload;
    return { ...state, dmdDecideAllPrice: { ...dmdDecideAllPrice, message } };
  },
}, initialState);
