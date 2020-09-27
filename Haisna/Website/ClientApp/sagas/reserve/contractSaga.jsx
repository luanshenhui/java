import { call, takeEvery, put } from 'redux-saga/effects';

import contractService from '../../services/reserve/contractService';

import {
  getContractCourceItemsRequest,
  getContractCourceItemsSuccess,
  getContractCourceItemsFailure,
  getContractCslDivItemsRequest,
  getContractCslDivItemsSuccess,
  getContractCslDivItemsFailure,
  getContractOptionsRequest,
  getContractOptionsSuccess,
  getContractOptionsFailure,
} from '../../modules/reserve/contractModule';

// コースの選択肢取得Action発生時に起動するメソッド
function* runRequestContractCourceItems(action) {
  try {
    // コース一覧取得処理実行
    const payload = yield call(contractService.getContractCourseList, action.payload);
    // コースの選択肢取得処理成功Actionを発生させる
    yield put(getContractCourceItemsSuccess(payload));
  } catch (error) {
    // コースの選択肢取得処理失敗Actionを発生させる
    yield put(getContractCourceItemsFailure(error.response));
  }
}

// 受診区分の選択肢取得Action発生に起動するメソッド
function* runRequestContractCslDivItems(action) {
  try {
    // 受診区分一覧取得処理実行
    const payload = yield call(contractService.getContractCslDivList, action.payload);
    // 受診区分の選択肢取得処理成功Actionを発生させる
    yield put(getContractCslDivItemsSuccess(payload));
  } catch (error) {
    // 受診区分の選択肢取得処理失敗Actionを発生させる
    yield put(getContractCslDivItemsFailure(error.response));
  }
}

// 検査セット取得Action発生時に起動するメソッド
function* runRequestContractOptions(action) {
  try {
    // 検査セット取得処理実行
    const payload = yield call(contractService.getContractOptionsStatus, action.payload);
    // 検査セット取得処理成功Actionを発生させる
    yield put(getContractOptionsSuccess(payload));
  } catch (error) {
    // 検査セット取得処理失敗Actionを発生させる
    yield put(getContractOptionsFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const contractSagas = [
  takeEvery(getContractCourceItemsRequest.toString(), runRequestContractCourceItems),
  takeEvery(getContractCslDivItemsRequest.toString(), runRequestContractCslDivItems),
  takeEvery(getContractOptionsRequest.toString(), runRequestContractOptions),
];

export default contractSagas;
