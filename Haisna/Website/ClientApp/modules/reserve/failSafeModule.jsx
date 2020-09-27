import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  initializeFailSafe,
  getFailSafeInfoRequest,
  getFailSafeInfoSuccess,
  getFailSafeInfoFailure,
  failSafeConditionCheck,
} = createActions(
  'INITIALIZE_FAIL_SAFE',
  'GET_FAIL_SAFE_INFO_REQUEST',
  'GET_FAIL_SAFE_INFO_SUCCESS',
  'GET_FAIL_SAFE_INFO_FAILURE',
  'FAIL_SAFE_CONDITION_CHECK',
);

// stateの初期値
const initialState = {
  failSafeItem: {
    conditions: {
      startdate: moment(new Date()).format('YYYY/MM/DD'),
      enddate: '',
    },
    message: [],
    totalCount: 0,
    data: [],
    isLoading: false,
  },
};

// reducerの作成
export default handleActions({
  // 受診情報の検索初期化処理
  [initializeFailSafe]: (state) => {
    const { failSafeItem } = initialState;
    return { ...state, failSafeItem };
  },
  // 受診情報の検索初期化処理
  [getFailSafeInfoRequest]: (state, action) => {
    const { failSafeItem } = state;
    const { conditions } = failSafeItem;
    const { startdate, enddate } = action.payload;
    const strDate = (startdate === '' || startdate === null) ? startdate : moment(startdate).format('YYYY/MM/DD');
    const endDate = (enddate === '' || enddate === null) ? enddate : moment(enddate).format('YYYY/MM/DD');
    const isLoading = true;
    return { ...state, failSafeItem: { ...failSafeItem, conditions: { ...conditions, startdate: strDate, enddate: endDate }, isLoading } };
  },
  // 受診情報の取得成功時の処理
  [getFailSafeInfoSuccess]: (state, action) => {
    const { failSafeItem } = state;
    // 検索指示状態とする
    const { conditions } = failSafeItem;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data, inStrDate, inEndDate } = action.payload;
    const failSafeData = data;
    const totalCount = data.length;
    const strDate = inStrDate === '' ? inStrDate : moment(inStrDate).format('YYYY/MM/DD');
    const endDate = inEndDate === '' ? inEndDate : moment(inEndDate).format('YYYY/MM/DD');
    const isLoading = false;
    return { ...state, failSafeItem: { ...failSafeItem, conditions: { ...conditions, startdate: strDate, enddate: endDate }, totalCount, data: failSafeData, message: [], isLoading } };
  },
  //  受診情報の取得成功のアクション時の処理
  [getFailSafeInfoFailure]: (state, action) => {
    const { failSafeItem } = state;
    // 検索指示状態とする
    const { conditions } = failSafeItem;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { inStrDate, inEndDate } = action.payload;
    const strDate = inStrDate === '' ? inStrDate : moment(inStrDate).format('YYYY/MM/DD');
    const endDate = inEndDate === '' ? inEndDate : moment(inEndDate).format('YYYY/MM/DD');
    const message = ['検索条件を満たす受診情報は存在しません。'];
    const isLoading = false;
    return { ...state, failSafeItem: { ...failSafeItem, conditions: { ...conditions, startdate: strDate, enddate: endDate }, message, totalCount: 0, data: [], isLoading } };
  },
  // 受診情報検索条件チェックの処理
  [failSafeConditionCheck]: (state, action) => {
    const { failSafeItem } = state;
    const { conditions } = failSafeItem;
    // (これに伴い一覧が再描画される)
    const { message, inStrDate, inEndDate } = action.payload;
    const strDate = inStrDate === '' ? inStrDate : moment(inStrDate).format('YYYY/MM/DD');
    const endDate = inEndDate === '' ? inEndDate : moment(inEndDate).format('YYYY/MM/DD');
    const isLoading = false;
    return { ...state, failSafeItem: { ...failSafeItem, conditions: { ...conditions, startdate: strDate, enddate: endDate }, message, totalCount: 0, data: [], isLoading } };
  },
}, initialState);
