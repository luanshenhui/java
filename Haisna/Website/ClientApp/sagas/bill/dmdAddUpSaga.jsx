import { call, takeEvery, put } from 'redux-saga/effects';

import dmdAddUpService from '../../services/bill/dmdAddUpService';
import {
  dmdAddUpRequest,
  dmdAddUpSuccess,
  dmdAddUpFailure,
  initializeOrgChar,
  dmdAddUpExecuteSuccess,
  dmdAddUpExecuteFailure,
} from '../../modules/bill/dmdAddUpModule';

// 入力チェック
function* runRequestDmdAddUp(action) {
  const { values, blur1 } = action.payload;
  let msg = '';
  // 団体コードの先頭５桁が未入力時、チェックがはいっているなら
  if ((!values.orgCd5Char) && values.checkboxOrgCd5Char === '1') {
    // 団体コードの先頭５桁指定チェックをはずす
    msg += '団体コードの先頭５桁の指定は無視されます。\n';
  }
  // 確認ＯＫ時、実行へ
  if (msg !== '') {
    msg += '\n';
  }
  msg += '指定された条件で締め処理を実行します。';
  if (!(values.checkboxOrgCd5Char && values.orgCd5Char)) {
    yield put(initializeOrgChar(values));
    blur1('DmdAddUp', 'orgCd5Char', '');
    // 団体コードの先頭５桁が未入力時、チェックがはいっているなら
    blur1('DmdAddUp', 'checkboxOrgCd5Char', null);
  }
  // eslint-disable-next-line no-alert,no-restricted-globals
  if (!confirm(msg)) {
    return;
  }
  const data = {};
  for (let i = 0; i < 3; i += 1) {
    if (values.closeDate !== null && i === 0) {
      const close = values.closeDate.split('/');
      data.closeYear = close[i];
      data.closeMonth = close[i + 1];
      data.closeDay = close[i + 2];
    }
    if (values.strDate !== null && i === 1) {
      const str = values.strDate.split('/');
      data.strYear = str[i - 1];
      data.strMonth = str[i];
      data.strDay = str[i + 1];
    }
    if (values.endDate !== null && i === 2) {
      const end = values.endDate.split('/');
      data.endYear = end[i - 2];
      data.endMonth = end[i - 1];
      data.endDay = end[i];
    }
  }
  try {
    // 入力チェック処理実行
    const payload = yield call(dmdAddUpService.dmdAddupCheck, { data });
    // 入力チェック成功Actionを発生させる
    yield put(dmdAddUpSuccess(payload));
    // 締め処理起動
    try {
      // 締め処理実行
      const payload1 = yield call(dmdAddUpService.dmdAddupExecute, values);
      // 締め処理成功Actionを発生させる
      yield put(dmdAddUpExecuteSuccess(payload1));
    } catch (error) {
      // 締め処理失敗Actionを発生させる
      yield put(dmdAddUpExecuteFailure(error.response));
    }
  } catch (error) {
    // 入力チェック失敗Actionを発生させる
    yield put(dmdAddUpFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const dmdAddUpSagas = [
  takeEvery(dmdAddUpRequest.toString(), runRequestDmdAddUp),
];

export default dmdAddUpSagas;
