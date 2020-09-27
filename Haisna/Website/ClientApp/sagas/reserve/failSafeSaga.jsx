import moment from 'moment';
import { call, takeEvery, put } from 'redux-saga/effects';
import failSafeService from '../../services/reserve/failSafeService';

import {
  getFailSafeInfoRequest,
  getFailSafeInfoSuccess,
  getFailSafeInfoFailure,
  failSafeConditionCheck,
} from '../../modules/reserve/failSafeModule';

// FailSafeの検索取得Action発生時に起動するメソッド
function* runGetFailSafeInfoRequest(action) {
  const message = [];
  const { startdate, enddate } = action.payload;
  // 開始日未設定、または開始日より終了日が過去であれば
  let inStrDate = moment(startdate).format('YYYY-MM-DD');
  let inEndDate = moment(enddate).format('YYYY-MM-DD');
  let dateDiff = 0;
  let dtmDate = '';
  if (enddate !== null && enddate !== '') {
    dateDiff = moment(inEndDate).diff(moment(inStrDate), 'days');
    if (startdate === null || startdate === '' || dateDiff < 0) {
      dtmDate = inStrDate;
      inStrDate = inEndDate;
      inEndDate = dtmDate;
    }
    if (inStrDate === inEndDate) {
      inEndDate = '';
    }
    if (startdate === null || startdate === '') {
      inEndDate = '';
    }
  } else {
    inEndDate = '';
  }
  try {
    // 受診日のいずれかが指定されていない場合は検索を行わない
    if ((startdate === null || startdate === '') && (enddate === null || enddate === '')) {
      message.push('検索条件を満たす受診情報は存在しません。');
      yield put(failSafeConditionCheck({ message, inStrDate: '', inEndDate: '' }));
      return;
    }
    // 受診日(始)の日付チェック
    const date = moment(new Date()).format('YYYY-MM-DD');
    const dateFalg = moment(inStrDate).isAfter(date);
    if (date !== inStrDate && !dateFalg) {
      message.push('受診日は今日以降を指定して下さい。');
      yield put(failSafeConditionCheck({ message, inStrDate, inEndDate }));
      return;
    }
    // 日付の範囲チェック３１日まで
    if (dateDiff > 30) {
      message.push('日付は１ヶ月以内を指定して下さい！！');
      yield put(failSafeConditionCheck({ message, inStrDate, inEndDate }));
      return;
    }

    // 受診情報の検索取得処理実行
    const payload = yield call(failSafeService.getFailSafeInfo, { inStrDate, inEndDate });
    // 受診情報の検索取得成功Actionを発生させる
    yield put(getFailSafeInfoSuccess({ ...payload, inStrDate, inEndDate }));
  } catch (error) {
    // 受診情報の検索取得失敗Actionを発生させる
    yield put(getFailSafeInfoFailure({ inStrDate, inEndDate }));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
const failSafeSagas = [
  takeEvery(getFailSafeInfoRequest.toString(), runGetFailSafeInfoRequest),

];

export default failSafeSagas;
