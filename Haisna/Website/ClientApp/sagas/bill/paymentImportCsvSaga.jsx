import { call, takeEvery, put } from 'redux-saga/effects';
import paymentImportCsvService from '../../services/bill/paymentImportCsvService';
import {
  importCsvRequest,
  importCsvSuccess,
  importCsvFailure,
} from '../../modules/bill/paymentImportCsvModule';

// 入金情報の作成処理
function* runRequestImportCsv(action) {
  try {
    // 締め処理実行
    const payload = yield call(paymentImportCsvService.importCsv, action.payload);
    // 締め処理成功Actionを発生させる
    yield put(importCsvSuccess(payload));
  } catch (error) {
    // 締め処理失敗Actionを発生させる
    yield put(importCsvFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const paymentImportCsvSagas = [
  takeEvery(importCsvRequest.toString(), runRequestImportCsv),
];

export default paymentImportCsvSagas;
