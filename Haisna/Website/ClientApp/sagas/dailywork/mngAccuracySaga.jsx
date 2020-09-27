import { call, takeEvery, put } from 'redux-saga/effects';
import mngAccuracyService from '../../services/dailywork/mngAccuracyService';
import {
  checkMngData,
  getMngAccuracyRequest,
  getMngAccuracySuccess,
  getMngAccuracyFailure,
} from '../../modules/dailywork/mngAccuracyModule';

// 検索条件に従い成績書情報一覧を抽出Action発生時に起動するメソッド
function* runRequestMngAccuracy(action) {
  try {
    const { strcsldate, border } = action.payload;
    let mngdata = null;
    const message = [];
    if (strcsldate === undefined || strcsldate === null) {
      message.push('指定された受診日が正しい日付ではありません。');
    }
    if ((border !== null && border !== '') && !Number(border)) {
      message.push('基準外境界比率には正しい数字を入力してください。');
    }
    if (message.length > 0) {
      yield put(checkMngData(message));
      return;
    }
    // 検索条件に従い成績書情報一覧を抽出処理実行
    mngdata = yield call(mngAccuracyService.getMngAccuracy, action.payload);
    // 検索条件に従い成績書情報一覧を抽出成功Actionを発生させる
    yield put(getMngAccuracySuccess({ mngdata, message }));
  } catch (error) {
    // 検索条件に従い成績書情報一覧を抽出失敗Actionを発生させる
    yield put(getMngAccuracyFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
const mngAccuracySagas = [
  takeEvery(getMngAccuracyRequest.toString(), runRequestMngAccuracy),
];

export default mngAccuracySagas;
