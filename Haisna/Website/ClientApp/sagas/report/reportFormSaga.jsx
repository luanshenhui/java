/**
 * @file 印刷フォーム関連Saga
 */
import { call, takeEvery, put } from 'redux-saga/effects';

import * as reportFormModule from '../../modules/report/reportFormModule';
import freeService from '../../services/preference/freeService';

// 会計台帳初期値読み込み処理
function* runGetAccountBookData(action) {
  try {
    const { callback } = action.payload;
    // 初期値読み込み処理
    const payload = yield call(freeService.getFree, { mode: 0, freecd: 'KAIKEIDAICHO' });
    // コールバック
    if (payload && payload[0]) {
      callback(payload[0]);
    }
    // 会計台帳初期値読み込み成功Actionを発生させる
    yield put(reportFormModule.getAccountBookDataSuccess(payload));
  } catch (error) {
    // 会計台帳初期値読み込み失敗Actionを発生させる
    yield put(reportFormModule.getAccountBookDataFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const reportFormSagas = [
  takeEvery(reportFormModule.getAccountBookDataRequest.toString(), runGetAccountBookData),
];

export default reportFormSagas;
