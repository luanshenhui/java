/**
 * @file 管理端末用非同期処理定義
 */
import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';

import workStationService from '../../services/preference/workStationService';
import groupService from '../../services/preference/groupService';
import * as workStationModules from '../../modules/preference/workStationModule';

// 管理端末一覧取得Action発生時に起動するメソッド
function* runRequestWorkStationList(action) {
  try {
    // 管理端末一覧取得処理実行
    const payload = yield call(workStationService.getWorkStationList, action.payload);
    // 管理端末一覧取得成功Actionを発生させる
    yield put(workStationModules.getWorkStationListSuccess(payload));
  } catch (error) {
    // 管理端末一覧取得失敗Actionを発生させる
    yield put(workStationModules.getWorkStationListFailure(error.response));
  }
}

// 管理端末情報取得Action発生時に起動するメソッド
function* runRequestWorkStation(action) {
  try {
    const { conditions, formName } = action.payload;
    // 管理端末情報取得処理実行
    const payload = yield call(workStationService.getWorkStation, conditions);
    // フォームに値をセットする
    yield put(initialize(formName, payload));
    // 管理端末情報取得成功Actionを発生させる
    yield put(workStationModules.getWorkStationSuccess(payload));
  } catch (error) {
    // 管理端末情報取得失敗Actionを発生させる
    yield put(workStationModules.getWorkStationFailure(error.response));
  }
}

// 管理端末情報登録Action発生時に起動するメソッド
function* runRegisterWorkStation(action) {
  try {
    // 管理端末情報登録処理実行
    const payload = yield call(workStationService.registerWorkStation, action.payload);
    // リダイレクト処理
    yield call(action.payload.redirect, action.payload.data);
    // 管理端末情報登録成功Actionを発生させる
    yield put(workStationModules.registerWorkStationSuccess(payload));
  } catch (error) {
    // 管理端末情報登録失敗Actionを発生させる
    yield put(workStationModules.registerWorkStationFailure(error.response));
  }
}

// 管理端末情報削除Action発生時に起動するメソッド
function* runDeleteWorkStation(action) {
  try {
    // 管理端末情報削除処理実行
    const payload = yield call(workStationService.deleteWorkStation, action.payload);
    // リダイレクト処理
    yield call(action.payload.redirect);
    // 管理端末情報削除成功Actionを発生させる
    yield put(workStationModules.deleteWorkStationSuccess(payload));
  } catch (error) {
    // 管理端末情報削除失敗Actionを発生させる
    yield put(workStationModules.deleteWorkStationFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const workStationSagas = [
  // 管理端末一覧要求アクション
  takeEvery(workStationModules.getWorkStationListRequest.toString(), runRequestWorkStationList),
  // 管理端末データ要求アクション
  takeEvery(workStationModules.getWorkStationRequest.toString(), runRequestWorkStation),
  // 管理端末データ登録アクション
  takeEvery(workStationModules.registerWorkStationRequest.toString(), runRegisterWorkStation),
  // 管理端末データ削除アクション
  takeEvery(workStationModules.deleteWorkStationRequest.toString(), runDeleteWorkStation),
];

export default workStationSagas;
