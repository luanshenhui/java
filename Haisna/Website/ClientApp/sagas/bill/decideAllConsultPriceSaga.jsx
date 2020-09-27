import { call, takeEvery, put } from 'redux-saga/effects';

import decideAllConsultPriceService from '../../services/bill/decideAllConsultPriceService';

import {
  dmdDecideAllPriceRequest,
  dmdDecideAllPriceSuccess,
  dmdDecideAllPriceFailure,
} from '../../modules/bill/decideAllConsultPriceModule';

// 確定ボタン押下時Action発生時に起動するメソッド
function* runRequestdmdDecideAllPrice(action) {
  try {
    let payload;
    if (action.payload.strDate != null && action.payload.endDate != null) {
      // 確定ボタン押下時処理実行
      payload = yield call(decideAllConsultPriceService.decideAllConsultPrice, action.payload);

      const { totalCount } = payload;
      let message;
      if (totalCount >= 0) {
        if (totalCount === 0) {
          message = ['受診金額再作成を実行しましたが対象データがありませんでした。'];
        } else {
          message = [`受診金額再作成が完了しました。件数=${totalCount}件`];
        }
      } else {
        message = ['受診金額再作成に失敗しました。'];
      }

      // 確定ボタン押下時成功Actionを発生させる
      yield put(dmdDecideAllPriceSuccess({ message }));
    } else {
      const message = ['受診日範囲が入力されていません。'];
      yield put(dmdDecideAllPriceFailure({ message }));
    }
  } catch (error) {
    // 確定ボタン押下時失敗Actionを発生させる
    yield put(dmdDecideAllPriceFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const decideAllConsultPriceSagas = [
  takeEvery(dmdDecideAllPriceRequest.toString(), runRequestdmdDecideAllPrice),
];

export default decideAllConsultPriceSagas;
