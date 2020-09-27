/**
 * @file 誘導Saga
 */
import { call, takeEvery, put, select } from 'redux-saga/effects';

import * as yudoModule from '../../modules/yudo/yudoModule';
import yudoService from '../../services/yudo/yudoService';

// 診察状態取得Action発生時の処理
function* runGetYudoConsultationMonitorStatus() {
  try {
    // 診察状態取得処理
    const payload = yield call(yudoService.getConsultationMonitorStatus);
    // 診察状態取得成功Actionを発生させる
    yield put(yudoModule.getYudoConsultationMonitorStatusSuccess(payload));
  } catch (error) {
    // 診察状態取得失敗Actionを発生させる
    yield put(yudoModule.getYudoConsultationMonitorStatusFailure(error.response));
  }
}

// 診察状態取得成功時Action
function* runGetYudoConsultationMonitorStatusSucceeded() {
  const { sound, doRinging } = yield select((state) => state.app.yudo.yudo.consultationMonitorStatus);
  // フラグが立っていればサウンドを鳴らす
  if (doRinging) {
    sound.play();
    // フラグをfalseにする
    yield put(yudoModule.stopRingingYudoConsultationMonitorStatus());
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const yudoSagas = [
  takeEvery(yudoModule.getYudoConsultationMonitorStatusRequest.toString(), runGetYudoConsultationMonitorStatus),
  takeEvery(yudoModule.getYudoConsultationMonitorStatusSuccess.toString(), runGetYudoConsultationMonitorStatusSucceeded),
];

export default yudoSagas;
