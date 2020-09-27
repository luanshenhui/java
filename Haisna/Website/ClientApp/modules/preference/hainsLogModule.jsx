import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  getHainsListRequest,
  getHainsListSuccess,
  initializeHainsList,
  getHainsListFailure,
} = createActions(
  'GET_HAINS_LIST_REQUEST',
  'GET_HAINS_LIST_SUCCESS',
  'INITIALIZE_HAINS_LIST',
  'GET_HAINS_LIST_FAILURE',
);

const getCurDate = () => {
  const insDate = moment().format('YYYY/M/D');
  return insDate;
};
// stateの初期値
const initialState = {
  hainsLogList: {
    conditions: {
      transactionDiv: '',
      insDate: getCurDate(),
      transactionID: null,
      message: null,
      informationDiv: null,
      orderByOld: null,
      limit: 50,
      startPos: 1,
    }, // 検索条件
    totalCount: null,
    data: [],
    isLoading: false,
    message: null,
  },
};

// reducerの作成
export default handleActions({

  [getHainsListRequest]: (state, action) => {
    const { hainsLogList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, hainsLogList: { ...hainsLogList, conditions, isLoading: true } };
  },
  [getHainsListSuccess]: (state, action) => {
    const { hainsLogList } = state;
    const { conditions } = hainsLogList;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    let totalCount;
    let data;
    if (action.payload) {
      totalCount = action.payload.recordcount;
      data = action.payload.loglist;
    } else {
      totalCount = 0;
      data = [];
    }
    return { ...state, hainsLogList: { ...hainsLogList, data, totalCount, isLoading: false, message: conditions.message } };
  },
  // システムログの表示初期化処理
  [initializeHainsList]: (state) => {
    const { hainsLogList } = initialState;
    return { ...state, hainsLogList };
  },
  [getHainsListFailure]: (state) => {
    const { hainsLogList } = state;
    return { ...state, hainsLogList: { ...hainsLogList, isLoading: false } };
  },
}, initialState);
