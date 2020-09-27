import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  getScheduleHRequest,
  getScheduleHSuccess,
  getScheduleHFailure,
  setSelectYearMonth,

  initializeRsvFraList,
  getRsvFraListRequest,
  getRsvFraListSuccess,
  getRsvFraListFailure,
  openRsvFraGuide,
  openRsvFraGuideSuccess,
  openRsvFraGuideFailure,
  openRsvFraInsertGuide,
  insertRsvFraRequest,
  insertRsvFraSuccess,
  insertRsvFraFailure,
  updateRsvFraRequest,
  updateRsvFraSuccess,
  updateRsvFraFailure,
  deleteRsvFraRequest,
  deleteRsvFraSuccess,
  deleteRsvFraFailure,
  rsvFraInputCheck,
  closeRsvFraGuide,

  getCourseListRequest,
  getCourseListSuccess,
  getCourseListFailure,
  getMntCapacityListRequest,
  getMntCapacityListSuccess,
  getMntCapacityListFailure,
  initialMntCapacityListState,
  settingDate,
  initializeMntCapacity,
  initializeMntCapacityBody,
  getMntCapacityRequest,
  getMntCapacitySuccess,
  getMntCapacityFailure,
  updateMntCapacityRequest,
  updateMntCapacitySuccess,
  updateMntCapacityFailure,
  initializeRsvFraCopy,
  checkRsvFraCopyInput,
  checkRsvFraCopyInputSuccess,
  checkRsvFraCopyInputFailure,
  rsvFraCopyBack,
  rsvFraCopyRegister,
  rsvFraCopyRegisterSuccess,
  rsvFraCopyRegisterFailure,
  rsvFraCopyInputCheck,
} = createActions(
  // 取得
  'GET_SCHEDULE_H_REQUEST',
  'GET_SCHEDULE_H_SUCCESS',
  'GET_SCHEDULE_H_FAILURE',
  'SET_SELECT_YEAR_MONTH',
  // 予約枠の検索
  'INITIALIZE_RSV_FRA_LIST',
  'GET_RSV_FRA_LIST_REQUEST',
  'GET_RSV_FRA_LIST_SUCCESS',
  'GET_RSV_FRA_LIST_FAILURE',
  // 予約枠OPEN
  'OPEN_RSV_FRA_GUIDE',
  'OPEN_RSV_FRA_GUIDE_SUCCESS',
  'OPEN_RSV_FRA_GUIDE_FAILURE',
  'OPEN_RSV_FRA_INSERT_GUIDE',
  // 予約枠の登録
  'INSERT_RSV_FRA_REQUEST',
  'INSERT_RSV_FRA_SUCCESS',
  'INSERT_RSV_FRA_FAILURE',
  // 予約枠の修正
  'UPDATE_RSV_FRA_REQUEST',
  'UPDATE_RSV_FRA_SUCCESS',
  'UPDATE_RSV_FRA_FAILURE',
  // 予約枠の削除
  'DELETE_RSV_FRA_REQUEST',
  'DELETE_RSV_FRA_SUCCESS',
  'DELETE_RSV_FRA_FAILURE',
  'RSV_FRA_INPUT_CHECK',
  'CLOSE_RSV_FRA_GUIDE',

  'GET_COURSE_LIST_REQUEST',
  'GET_COURSE_LIST_SUCCESS',
  'GET_COURSE_LIST_FAILURE',
  'GET_MNT_CAPACITY_LIST_REQUEST',
  'GET_MNT_CAPACITY_LIST_SUCCESS',
  'GET_MNT_CAPACITY_LIST_FAILURE',
  'INITIAL_MNT_CAPACITY_LIST_STATE',
  'SETTING_DATE',
  // 休診日設定
  'INITIALIZE_MNT_CAPACITY',
  'INITIALIZE_MNT_CAPACITY_BODY',
  'GET_MNT_CAPACITY_REQUEST',
  'GET_MNT_CAPACITY_SUCCESS',
  'GET_MNT_CAPACITY_FAILURE',
  'UPDATE_MNT_CAPACITY_REQUEST',
  'UPDATE_MNT_CAPACITY_SUCCESS',
  'UPDATE_MNT_CAPACITY_FAILURE',
  // 予約枠コピー
  'INITIALIZE_RSV_FRA_COPY',
  'CHECK_RSV_FRA_COPY_INPUT',
  'CHECK_RSV_FRA_COPY_INPUT_SUCCESS',
  'CHECK_RSV_FRA_COPY_INPUT_FAILURE',
  'RSV_FRA_COPY_BACK',
  'RSV_FRA_COPY_REGISTER',
  'RSV_FRA_COPY_REGISTER_SUCCESS',
  'RSV_FRA_COPY_REGISTER_FAILURE',
  'RSV_FRA_COPY_INPUT_CHECK',

);

// stateの初期値
const initialState = {
  scheduleHList: {
    selectYear: 0,
    selectMonth: 0,
    data: [],
    message: [],
  },
  rsvfraList: {
    message: [],
    // 以下一覧用
    conditions: {
      startcsldate: moment(new Date()).format('YYYY/MM/DD'),
      endcsldate: moment(new Date()).format('YYYY/MM/DD'),
      cscd: '',
      rsvgrpcd: '',
      selected: false,
    }, // 検索条件
    totalCount: null,
    data: [],
    isLoading: false,
  },
  rsvFraEditGuide: {
    mode: 'insert',
    rsvFraData: {},
    visible: false, // ガイドの表示状態
    message: [], // エラー等のメッセージ
  },
  mntCapacityList: {
    conditions: {},
    startDate: moment(new Date()).format('YYYY/MM/DD'),
    gender: '0',
    data: [],
    sex: '',
    lngCourseCount: 0,
    lngRsvGrpCountArray: [],
    lngRsvGrp: [],
    isLoading: false,
    isNotFound: false,
    isRetrieval: false,
    initialDate: moment().format('YYYY/MM/DD'),
  },
  courseList: {
    data: [],
    conditions: {
      100: '1',
    },
  },
  mntCapacityHeadForm: {
    // 以下一覧用
    conditions: {
      year: moment(new Date()).format('YYYY'),
      month: moment(new Date()).format('M'),
      timeFra: '0',
      rsvFraCd: 'ALL',
    },
    showFlag: false,
  },
  mntCapacity: {
    message: [],
    year: moment(new Date()).format('YYYY'),
    month: moment(new Date()).format('M'),
    calendarItem: {},
  },
  rsvFraCopy1: {
    conditions: {
      startcsldate: moment(new Date()).format('YYYY/MM/DD'),
      cscd: '',
      rsvgrpcd: '',
    },
    message: [],
  },
  rsvFraCopy2: {
    conditions: {
      startcsldate: moment(new Date()).format('YYYY/MM/DD'),
      endcsldate: moment(new Date()).format('YYYY/MM/DD'),
      mon: '',
      tue: '',
      wed: '',
      thu: '',
      fri: '',
      sat: '',
      sun: '',
      upd: '',
    },
    message: [],
  },
};

// reducerの作成
export default handleActions({

  // 病院スケジュール一覧取得成功時の処理
  [getScheduleHSuccess]: (state, action) => {
    const { scheduleHList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    return { ...state, scheduleHList: { ...scheduleHList, data } };
  },
  // 病院スケジュール一覧取得失敗時の処理
  [getScheduleHFailure]: (state, action) => {
    const { scheduleHList } = state;
    const { data } = action.payload;
    const message = data.errors;
    return { ...state, scheduleHList: { ...scheduleHList, message } };
  },
  // 基準年月処理
  [setSelectYearMonth]: (state, action) => {
    const { scheduleHList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { selectYear, selectMonth } = action.payload;
    return { ...state, scheduleHList: { ...scheduleHList, selectYear, selectMonth } };
  },
  // 予約枠の検索初期化処理
  [initializeRsvFraList]: (state) => {
    const { rsvfraList } = initialState;
    return { ...state, rsvfraList };
  },
  // 休診日設定の検索初期化処理
  [initializeMntCapacity]: (state) => {
    const { mntCapacityHeadForm } = initialState;
    return { ...state, mntCapacityHeadForm };
  },
  // 休診日設定カレンダーの初期化処理
  [initializeMntCapacityBody]: (state, action) => {
    const { mntCapacity } = initialState;
    const { year, month } = action.payload;
    return { ...state, mntCapacity: { ...mntCapacity, year, month } };
  },
  // 予約枠コピーの検索初期化処理
  [initializeRsvFraCopy]: (state, action) => {
    const { backFlag } = action.payload;
    const { rsvFraCopy1, rsvFraCopy2 } = backFlag === '1' ? state : initialState;
    return { ...state, rsvFraCopy1: { ...rsvFraCopy1, message: [] }, rsvFraCopy2: { ...rsvFraCopy2, message: [] } };
  },
  // 予約枠の検索取得開始時の処理
  [getRsvFraListRequest]: (state, action) => {
    const { rsvfraList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    const isLoading = true;
    return { ...state, rsvfraList: { ...rsvfraList, conditions, isLoading } };
  },
  // スケジュール情報の検索取得開始時の処理
  [getMntCapacityRequest]: (state, action) => {
    const { mntCapacityHeadForm } = state;
    const { conditions } = mntCapacityHeadForm;
    // 検索条件を更新する
    const { year, month } = action.payload;
    return { ...state, mntCapacityHeadForm: { ...mntCapacityHeadForm, conditions: { ...conditions, year, month } } };
  },
  // スケジュール情報の検索取得成功時の処理
  [getMntCapacitySuccess]: (state, action) => {
    const { mntCapacity, mntCapacityHeadForm } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { calendarItem, year, month } = action.payload;
    return {
      ...state, mntCapacity: { ...mntCapacity, calendarItem, year, month, message: [] }, mntCapacityHeadForm: { ...mntCapacityHeadForm, showFlag: true } };
  },
  // 病院スケジュール一覧取得成功時の処理
  [getScheduleHSuccess]: (state, action) => {
    const { mntCapacity } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    return { ...state, mntCapacity: { ...mntCapacity, data } };
  },
  // 病院スケジュール一覧取得失敗時の処理
  [getScheduleHFailure]: (state, action) => {
    const { mntCapacity } = state;
    const { data } = action.payload;
    const message = data.errors;
    return { ...state, mntCapacity: { ...mntCapacity, message } };
  },
  // 予約枠の検索取得成功時の処理
  [getRsvFraListSuccess]: (state, action) => {
    const { rsvfraList } = state;
    // 検索指示状態とする
    const { conditions } = rsvfraList;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    let totalCount = 0;
    if (data && data.length > 0) {
      totalCount = data.length;
    }
    const isLoading = false;
    return { ...state, rsvfraList: { ...rsvfraList, conditions: { ...conditions, selected: true }, totalCount, data: (data === '' ? [] : data), isLoading } };
  },
  // 予約枠の検索取得失敗時の処理
  [getRsvFraListFailure]: (state) => {
    const { rsvfraList } = state;
    const isLoading = false;
    return { ...state, rsvfraList: { ...rsvfraList, isLoading } };
  },
  // 予約枠修正ガイド表示処理(修正モード)
  [openRsvFraGuide]: (state) => {
    // 可視状態にする
    const visible = true;
    // 選択された要素を更新
    const { rsvFraEditGuide } = initialState;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, visible, mode: 'update' } };
  },
  // コース情報取得開始時の処理
  [getCourseListRequest]: (state) => {
    const { courseList } = state;

    return { ...state, courseList };
  },
  // コース情報取得成功のアクション時の処理
  [getCourseListSuccess]: (state, action) => {
    const { courseList } = state;
    const { mntCapacityList } = state;

    const { data, conditions } = action.payload;
    return { ...state, courseList: { ...courseList, data, conditions }, mntCapacityList: { ...mntCapacityList, conditions } };
  },
  // コース情報取得失敗のアクション時の処理
  [getCourseListFailure]: (state) => {
    const { courseList } = state;
    return { ...state, courseList: { ...courseList } };
  },
  // 予約人数情報取得開始時の処理
  [getMntCapacityListRequest]: (state, action) => {
    const { mntCapacityList } = state;
    const { courseList } = state;
    const isLoading = true;
    // 検索条件を更新する
    const { startDate, gender } = action.payload;
    let { conditions } = action.payload;
    if (!conditions) {
      conditions = {};
      const arr = Object.keys(courseList.conditions);
      for (let i = 0; i < arr.length; i += 1) {
        conditions[arr[i]] = '1';
      }
    }
    return { ...state, mntCapacityList: { ...mntCapacityList, startDate, isLoading, conditions, gender }, courseList: { ...courseList, conditions } };
  },
  // 予約人数情報取得成功のアクション時の処理
  [getMntCapacityListSuccess]: (state, action) => {
    const { mntCapacityList } = state;
    const isLoading = false;
    const isNotFound = false;
    const { data, lngCourseCount, lngRsvGrpCountArray, lngRsvGrp, gender } = action.payload;
    return { ...state, mntCapacityList: { ...mntCapacityList, data, lngCourseCount, lngRsvGrpCountArray, lngRsvGrp, isLoading, isNotFound, sex: gender } };
  },
  // 予約人数情報取得失敗のアクション時の処理
  [getMntCapacityListFailure]: (state) => {
    const { mntCapacityList } = state;
    const isLoading = false;
    const isNotFound = true;
    const data = [];
    return { ...state, mntCapacityList: { ...mntCapacityList, isLoading, data, isNotFound } };
  },
  [initialMntCapacityListState]: (state) => {
    const { mntCapacityList, courseList } = initialState;
    return { ...state, mntCapacityList, courseList };
  },
  [settingDate]: (state, action) => {
    const { mntCapacityList } = state;
    const { startDate, isRetrieval } = action.payload;
    if (isRetrieval) {
      return { ...state, mntCapacityList: { ...mntCapacityList, startDate, isRetrieval, initialDate: startDate } };
    }
    return { ...state, mntCapacityList: { ...mntCapacityList, startDate, isRetrieval } };
  },
  // 予約枠修正ガイドをOpen成功時の処理
  [openRsvFraGuideSuccess]: (state, action) => {
    const { rsvFraEditGuide } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { rsvFraData } = action.payload;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, rsvFraData } };
  },
  // 予約枠修正ガイド表示処理(新規モード)
  [openRsvFraInsertGuide]: (state) => {
    // 可視状態にする
    const visible = true;
    // 選択された要素を更新
    const { rsvFraEditGuide } = initialState;
    const { rsvFraData } = rsvFraEditGuide;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, rsvFraData: { ...rsvFraData, csldate: moment(new Date()).format('YYYY/MM/DD') }, visible, mode: 'insert' } };
  },
  // 予約枠を更新成功のアクション時の処理
  [updateRsvFraSuccess]: (state) => {
    // 可視状態をfalseにする
    const visible = false;
    const { rsvFraEditGuide } = initialState;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, visible } };
  },
  // 予約枠を登録成功のアクション時の処理
  [insertRsvFraSuccess]: (state) => {
    // 可視状態をfalseにする
    const visible = false;
    const { rsvFraEditGuide } = initialState;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, visible } };
  },
  // 予約枠を削除成功のアクション時の処理
  [deleteRsvFraSuccess]: (state) => {
    // 可視状態をfalseにする
    const visible = false;
    const { rsvFraEditGuide } = initialState;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, visible } };
  },
  // 予約枠を登録失敗のアクション時の処理
  [insertRsvFraFailure]: (state, action) => {
    const { data } = action.payload;
    const { rsvFraEditGuide } = state;
    let message = '';
    if (data !== '') {
      message = data;
    }
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, message } };
  },
  // 予約枠を更新失敗のアクション時の処理
  [updateRsvFraFailure]: (state, action) => {
    const { data } = action.payload;
    const { rsvFraEditGuide } = state;
    let message = '';
    if (data !== '') {
      message = data;
    }
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, message } };
  },
  // 予約枠を削除失敗のアクション時の処理
  [deleteRsvFraFailure]: (state) => {
    const { rsvFraEditGuide } = state;
    const message = '予約人数管理情報の削除に失敗しました。';
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, message } };
  },
  // 予約枠入力チェック時の処理
  [rsvFraInputCheck]: (state, action) => {
    const { rsvFraEditGuide } = state;
    const message = action.payload;
    return { ...state, rsvFraEditGuide: { ...rsvFraEditGuide, message } };
  },
  // 予約枠登録・修正を閉じるアクション時の処理
  [closeRsvFraGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { rsvFraEditGuide } = initialState;
    return { ...state, rsvFraEditGuide };
  },
  // 休診日設定を更新成功のアクション時の処理
  [updateMntCapacitySuccess]: (state) => {
    const { mntCapacity } = state;
    const message = ['保存が完了しました。'];
    return { ...state, mntCapacity: { ...mntCapacity, message } };
  },
  // 休診日設定を更新失敗のアクション時の処理
  [updateMntCapacityFailure]: (state, action) => {
    const { data } = action.payload;
    const { messages, warnings } = data;
    const { mntCapacity } = state;
    const message = [];
    for (let i = 0; i < messages.length; i += 1) {
      message.push(messages[i]);
    }
    for (let i = 0; i < warnings.length; i += 1) {
      message.push(warnings[i]);
    }
    return { ...state, mntCapacity: { ...mntCapacity, message } };
  },
  // 予約枠コピーのチェックの処理
  [checkRsvFraCopyInput]: (state, action) => {
    const { rsvFraCopy1 } = state;
    const { conditions } = rsvFraCopy1;
    // (これに伴い一覧が再描画される)
    const { startcsldate, cscd, rsvgrpcd } = action.payload;
    return {
      ...state, rsvFraCopy1: { ...rsvFraCopy1, conditions: { ...conditions, startcsldate, cscd, rsvgrpcd }, message: [] } };
  },
  // 予約枠コピーのチェックの処理
  [checkRsvFraCopyInputSuccess]: (state, action) => {
    const { rsvFraCopy1 } = state;
    // (これに伴い一覧が再描画される)
    const { message } = action.payload;
    return { ...state, rsvFraCopy1: { ...rsvFraCopy1, message } };
  },
  // 予約枠コピーのコピー先情報チェックの処理
  [rsvFraCopyInputCheck]: (state, action) => {
    const { rsvFraCopy2 } = state;
    // (これに伴い一覧が再描画される)
    const message = action.payload;
    return { ...state, rsvFraCopy2: { ...rsvFraCopy2, message } };
  },
  // 予約枠をコピーする成功のアクション時の処理
  [rsvFraCopyRegisterSuccess]: (state, action) => {
    const { rsvFraCopy2 } = state;
    const { data } = action.payload;
    let message = '';
    if (data !== '') {
      if (data > 0) {
        message = [`${data}件の予約枠情報が作成／更新されました。`];
      } else {
        message = ['予約枠は作成されませんでした。'];
      }
    }
    return { ...state, rsvFraCopy2: { ...rsvFraCopy2, message } };
  },
  // 予約枠をコピーする失敗のアクション時の処理
  [rsvFraCopyRegisterFailure]: (state) => {
    const { rsvFraCopy2 } = state;
    return { ...state, rsvFraCopy2: { ...rsvFraCopy2 } };
  },
}, initialState);
