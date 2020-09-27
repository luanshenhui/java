import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const { initializeDrlList, getRepListRequest, getRepListSuccess, getRepListFailure } = createActions(

  'INITIALIZE_DRL_LIST',
  'GET_REP_LIST_REQUEST',
  'GET_REP_LIST_SUCCESS',
  'GET_REP_LIST_FAILURE',
);
const getCurDate = () => {
  const insDate = moment().format('YYYY/M/D');
  return insDate;
};
// stateの初期値
const initialState = {

  reportLogList: {
    conditions: {
      printDate: getCurDate(),
      prtStatus: '',
      sortOld: false,
    }, // 検索条件
    totalCount: null,
    data: [],
  },
};

// reducerの作成
export default handleActions({

  [initializeDrlList]: (state) => {
    const { reportLogList } = initialState;
    return { ...state, reportLogList };
  },
  [getRepListRequest]: (state, action) => {
    const { reportLogList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, reportLogList: { ...reportLogList, conditions } };
  },
  [getRepListSuccess]: (state, action) => {
    const { reportLogList } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const totalCount = 1;
    let { data } = action.payload;
    if (!data) {
      data = [];
    }
    return { ...state, reportLogList: { ...reportLogList, data, totalCount } };
  },
  [getRepListFailure]: (state) => ({ ...state }),
}, initialState);

