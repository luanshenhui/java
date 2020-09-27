import { call, takeEvery, put } from 'redux-saga/effects';

import freeService from '../../services/preference/freeService';
import hainsUserService from '../../services/preference/hainsUserService';

import {
  getFreeByClassCdRequest,
  getFreeByClassCdSuccess,
  getFreeByClassCdFailure,
  getFreeRequest,
  getFreeSuccess,
  getFreeFailure,
  getUpdPerAddUpRequest,
  getUpdPerAddUpSuccess,
  getUpdPerAddUpFailure,
  getPerAddUpRequest,
  getPerAddUpSuccess,
  getPerAddUpFailure,
  getHainsUserRequest,
  getHainsUserSuccess,
  getHainsUserFailure,
  getFreeCountRequest,
  getFreeCountSuccess,
  getFreeCountFailure,
} from '../../modules/preference/freeModule';

// 汎用マスタよりデータ取得Action発生時に起動するメソッド
function* runRequestFreeByClassCd(action) {
  try {
    // 汎用マスタよりデータ取得開始時の処理実行
    const payload = yield call(freeService.getFreeByClassCd, action.payload);
    // 汎用マスタより切り替え日取得成功Actionを発生させる
    yield put(getFreeByClassCdSuccess(payload));
  } catch (error) {
    // 汎用マスタよりデータ取得失敗Actionを発生させる
    yield put(getFreeByClassCdFailure(error.response));
  }
}
// 汎用情報一覧取得Action発生時に起動するメソッド
function* runRequestFree(action) {
  try {
    // 汎用情報一覧取得開始時の処理実行
    const payload = yield call(freeService.getFree, action.payload);
    // 汎用情報一覧取得成功Actionを発生させる
    yield put(getFreeSuccess(payload));
  } catch (error) {
    // 汎用情報一覧取得失敗Actionを発生させる
    yield put(getFreeFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
function* runRequestUpdPerAddUp(action) {
  try {
    // 一覧取得処理実行
    if (action.payload.freedate === null) {
      yield put(getUpdPerAddUpFailure(action.payload));
    } else {
      // 一覧取得成功Actionを発生させる
      const payload = yield call(freeService.updateFree, action.payload);
      yield put(getUpdPerAddUpSuccess(payload));
    }
  } catch (error) {
    // 一覧取得失敗Actionを発生させる
    yield put(getUpdPerAddUpFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
function* runRequestPerAddUp(action) {
  try {
    // 一覧取得処理実行
    const payload = yield call(freeService.getFree, action.payload);
    try {
      let userId = '';
      if (payload[0].freefield1 !== '' || null) {
        userId = payload[0].freefield1;
      } else {
        userId = '';
      }
      const payload1 = yield call(hainsUserService.getHainsUser, { userid: userId });
      yield put(getHainsUserSuccess(payload1));
    } catch (error) {
      yield put(getHainsUserFailure(error.response));
    }

    // 一覧取得成功Actionを発生させる
    yield put(getPerAddUpSuccess(payload));
  } catch (error) {
    // 一覧取得失敗Actionを発生させる
    yield put(getPerAddUpFailure(error.response));
  }
}
function* runRequestFreeCount(action) {
  try {
    const data = action.payload;
    // 情報取得処理実行
    const payload = yield call(freeService.getFreeCount, data);
    // 情報取得成功Actionを発生させる
    yield put(getFreeCountSuccess(payload));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getFreeCountFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
const freeSagas = [
  takeEvery(getFreeByClassCdRequest.toString(), runRequestFreeByClassCd),
  takeEvery(getFreeRequest.toString(), runRequestFree),
  takeEvery(getUpdPerAddUpRequest.toString(), runRequestUpdPerAddUp),
  takeEvery(getPerAddUpRequest.toString(), runRequestPerAddUp),
  takeEvery(getHainsUserRequest.toString(), runRequestPerAddUp),
  takeEvery(getFreeCountRequest.toString(), runRequestFreeCount),
];
export default freeSagas;
