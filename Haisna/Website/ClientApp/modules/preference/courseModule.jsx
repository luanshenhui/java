import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getSelDateCourseRequest,
  getSelDateCourseSuccess,
  getSelDateCourseFailure,
  getCourseHistoryRequest,
  getCourseHistorySuccess,
  getCourseHistoryFailure,
  getHistoryCountRequest,
  getHistoryCountSuccess,
  getHistoryCountFailure,
} = createActions(
  // 今日の受診者取得（コース別）の一覧を取得
  'GET_SEL_DATE_COURSE_REQUEST',
  'GET_SEL_DATE_COURSE_SUCCESS',
  'GET_SEL_DATE_COURSE_FAILURE',
  // コース履歴の読み込み
  'GET_COURSE_HISTORY_REQUEST',
  'GET_COURSE_HISTORY_SUCCESS',
  'GET_COURSE_HISTORY_FAILURE',
  // 契約適用期間がコース適用期間に含まれるかチェック
  'GET_HISTORY_COUNT_REQUEST',
  'GET_HISTORY_COUNT_SUCCESS',
  'GET_HISTORY_COUNT_FAILURE',
);

// stateの初期値
const initialState = {

  selDateCourse: {
    data: [],
    message: [],
  },
  courseHistory: {
    message: [],
    courseHistoryData: [],
  },
};

// reducerの作成
export default handleActions({
  // 今日の受診者取得（コース別）の一覧取得成功時の処理
  [getSelDateCourseSuccess]: (state, action) => {
    const { selDateCourse } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { data } = action.payload;
    return { ...state, selDateCourse: { ...selDateCourse, data } };
  },
  // 今日の受診者取得（コース別）の一覧取得失敗時の処理
  [getSelDateCourseFailure]: (state, action) => {
    const { selDateCourse } = state;
    const { data } = action.payload;

    const message = data.errors;
    return { ...state, selDateCourse: { ...selDateCourse, message } };
  },
  // 契約適用期間に適用可能なコースカウントを取得成功時の処理
  [getHistoryCountSuccess]: (state, action) => {
    const { courseHistory } = state;
    const { data } = action.payload;
    let message = data.errors;

    if (data.count < 1) {
      message = ['指定された契約期間に適用可能なコース履歴が存在しません。'];
    }
    return { ...state, courseHistory: { ...courseHistory, message } };
  },
  // 契約適用期間に適用可能なコースカウントを取得失敗時の処理
  [getHistoryCountFailure]: (state, action) => {
    const { courseHistory } = state;
    const { data } = action.payload;
    let message = [];
    if (data.count < 1) {
      message = ['指定された契約期間に適用可能なコース履歴が存在しません。'];
    }
    return { ...state, courseHistory: { ...courseHistory, message } };
  },
  // コース履歴の一覧を取得成功時の処理
  [getCourseHistorySuccess]: (state, action) => {
    const { courseHistory } = state;
    // 総件数とデータとを更新する
    const { courseHistoryData } = action.payload;
    return { ...state, courseHistory: { ...courseHistory, courseHistoryData: (courseHistoryData === '' ? [] : courseHistoryData) } };
  },
  // コース履歴の一覧を取得失敗時の処理
  [getCourseHistoryFailure]: (state, action) => {
    const { courseHistory } = state;
    const { status, data } = action.payload;
    let message = data.errors;

    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定のコース履歴は存在しませんでした。'];
    }
    return { ...state, courseHistory: { ...courseHistory, message } };
  },
}, initialState);
