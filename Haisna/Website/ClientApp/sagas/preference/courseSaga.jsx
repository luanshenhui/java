import { call, takeEvery, put } from 'redux-saga/effects';

import courseService from '../../services/preference/courseService';

import {
  getSelDateCourseRequest,
  getSelDateCourseSuccess,
  getSelDateCourseFailure,
  getCourseHistoryRequest,
  getCourseHistorySuccess,
  getCourseHistoryFailure,
  getHistoryCountRequest,
  getHistoryCountSuccess,
  getHistoryCountFailure,

} from '../../modules/preference/courseModule';

// 今日の受診者取得（コース別）の一覧取得Action発生時に起動するメソッド
function* runRequestSelDateCourse(action) {
  try {
    // 今日の受診者取得（コース別）の一覧取得処理実行
    const payload = yield call(courseService.getSelDateCourse, action.payload);
    // 今日の受診者取得（コース別）の一覧取得成功Actionを発生させる
    yield put(getSelDateCourseSuccess(payload));
  } catch (error) {
    // 今日の受診者取得（コース別）の一覧取得失敗Actionを発生させる
    yield put(getSelDateCourseFailure(error.response));
  }
}

// コース履歴の一覧を取得
function* runGetCourseHistory(action) {
  try {
    // コース履歴の一覧を取得処理実行
    const payload = yield call(courseService.getCourseHistory, action.payload);
    yield put(getCourseHistorySuccess(payload));
  } catch (error) {
    // 適用期間取得失敗Actionを発生させる
    yield put(getCourseHistoryFailure(error.response));
  }
}

// 契約適用期間に適用可能なコースカウントを取得
function* runGetHistoryCount(action) {
  try {
    // 契約適用期間に適用可能なコースカウントを取得処理実行
    const payload = yield call(courseService.getHistoryCount, action.payload);
    yield put(getHistoryCountSuccess(payload));
  } catch (error) {
    yield put(getHistoryCountFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const courseSagas = [
  takeEvery(getSelDateCourseRequest.toString(), runRequestSelDateCourse),
  takeEvery(getCourseHistoryRequest.toString(), runGetCourseHistory),
  takeEvery(getHistoryCountRequest.toString(), runGetHistoryCount),
];

export default courseSagas;
