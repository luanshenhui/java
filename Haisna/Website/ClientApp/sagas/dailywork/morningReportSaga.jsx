import { call, takeEvery, put } from 'redux-saga/effects';

import morningReportService from '../../services/dailywork/morningReportService';
import consultService from '../../services/reserve/consultService';
import {
  getMorningReportRequest,
  getRsvFraDailySuccess,
  getRsvFraDailyFailure,
  getFriendsDailySuccess,
  getFriendsDailyFailure,
  getSameNameDailySuccess,
  getSameNameDailyFailure,
  getSetCountDailySuccess,
  getSetCountDailyFailure,
  getConsultListSuccess,
  getConsultListFailure,
  getPubNoteDailySuccess,
  getPubNoteDailyFailure,
} from '../../modules/dailywork/morningReportModule';

// 朝レポート照会情報を取得Action発生時に起動するメソッド
function* runRequestMorningReport(action) {
  try {
    let rsvfradailydata = null;
    // 時間帯別受診者情報を取得処理実行
    rsvfradailydata = yield call(morningReportService.getRsvFraDaily, action.payload);
    // 時間帯別受診者情報を取得成功Actionを発生させる
    yield put(getRsvFraDailySuccess({ rsvfradailydata }));
  } catch (error) {
    // 時間帯別受診者情報を取得失敗Actionを発生させる
    yield put(getRsvFraDailyFailure(error.response));
  }

  try {
    let friendsdailydata = null;
    // 同伴者（お連れ様）受診者情報を取得処理実行
    friendsdailydata = yield call(morningReportService.getFriendsDaily, action.payload);
    // 同伴者（お連れ様）受診者情報を取得成功Actionを発生させる
    yield put(getFriendsDailySuccess({ friendsdailydata }));
  } catch (error) {
    // 同伴者（お連れ様）受診者情報を取得失敗Actionを発生させる
    yield put(getFriendsDailyFailure(error.response));
  }

  try {
    let samenamedata = null;
    // 同姓受診者情報を取得処理実行
    samenamedata = yield call(morningReportService.getSameNameDaily, action.payload);
    // 同姓受診者情報を取得成功Actionを発生させる
    yield put(getSameNameDailySuccess({ samenamedata }));
  } catch (error) {
    // 同姓受診者情報を取得失敗Actionを発生させる
    yield put(getSameNameDailyFailure(error.response));
  }

  try {
    let countinfodata = null;
    // セット別受診者情報を取得処理実行
    countinfodata = yield call(morningReportService.getSetCountDaily, action.payload);
    // セット別受診者情報を取得成功Actionを発生させる
    yield put(getSetCountDailySuccess({ countinfodata }));
  } catch (error) {
    // セット別受診者情報を取得失敗Actionを発生させる
    yield put(getSetCountDailyFailure(error.response));
  }

  try {
    const conditions = { ...action.payload, CntlNo: 0 };
    // 受診者一覧取得処理実行
    const payload = yield call(consultService.getConsultList, conditions);
    const { data } = payload;
    const consultdata = data;
    // 受診者一覧取得成功Actionを発生させる
    yield put(getConsultListSuccess({ consultdata }));
  } catch (error) {
    // 受診者一覧取得失敗Actionを発生させる
    yield put(getConsultListFailure(error.response));
  }

  try {
    let pubnotedata = null;
    const conditions = { ...action.payload, pubNoteDivCd: '100', dispKbn: 0 };
    // トラブル情報を取得処理実行
    pubnotedata = yield call(morningReportService.getPubNoteDaily, conditions);
    // トラブル情報を取得成功Actionを発生させる
    yield put(getPubNoteDailySuccess({ pubnotedata }));
  } catch (error) {
    // トラブル情報を取得失敗Actionを発生させる
    yield put(getPubNoteDailyFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const morningReportSagas = [
  takeEvery(getMorningReportRequest.toString(), runRequestMorningReport),
];

export default morningReportSagas;
