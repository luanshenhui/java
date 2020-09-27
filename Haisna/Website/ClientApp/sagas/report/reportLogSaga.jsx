import { call, takeEvery, put } from 'redux-saga/effects';
import reportLogService from '../../services/report/reportLogService';

import {
  getRepListRequest, getRepListSuccess, getRepListFailure,
} from '../../modules/report/reportLogModule';

function* runRequestRepList(action) {
  try {
    // 印刷ログ情報取得処理実行
    const payload = yield call(reportLogService.getReportLog, action.payload);
    // 印刷ログ情報取得成功Actionを発生させる
    yield put(getRepListSuccess(payload));
  } catch (error) {
    // 印刷ログ情報取得失敗Actionを発生させる
    yield put(getRepListFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
const reportLogSagas = [
  takeEvery(getRepListRequest.toString(), runRequestRepList),
];

export default reportLogSagas;
