import { call, takeEvery, put } from 'redux-saga/effects';

import zipService from '../../services/preference/zipService';

import {
  getZipListRequest,
  getZipListSuccess,
  getZipListFailure,
} from '../../modules/preference/zipModule';

// 郵便番号一覧取得Action発生時に起動するメソッド
function* runRequestZipList(action) {
  try {
    // 郵便番号一覧取得処理実行
    const payload = yield call(zipService.getZipList, action.payload);
    // 郵便番号一覧取得成功Actionを発生させる
    yield put(getZipListSuccess(payload));
  } catch (error) {
    // 郵便番号一覧取得失敗Actionを発生させる
    yield put(getZipListFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const zipSagas = [
  takeEvery(getZipListRequest.toString(), runRequestZipList),
];

export default zipSagas;
