import { call, takeEvery, put } from 'redux-saga/effects';
import hainsLogService from '../../services/preference/hainsLogService';


import {
  getHainsListRequest,
  getHainsListSuccess,
  getHainsListFailure,
} from '../../modules/preference/hainsLogModule';

function* runRequestHainsList(action) {
  try {
    // システムログの表示取得処理実行
    if (action.payload.insDate) {
      const payload = yield call(hainsLogService.getHainsLog, action.payload);
      // システムログの表示取得成功Actionを発生させる
      yield put(getHainsListSuccess(payload));
    }
    yield put(getHainsListFailure());
  } catch (error) {
    // システムログの表示取得失敗Actionを発生させる
    yield put(getHainsListFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
const hainsLogSagas = [
  takeEvery(getHainsListRequest.toString(), runRequestHainsList),
];

export default hainsLogSagas;
