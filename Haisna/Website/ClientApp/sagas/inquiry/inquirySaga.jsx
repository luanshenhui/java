import { call, takeEvery, put } from 'redux-saga/effects';

import personService from '../../services/preference/personService';
import consultService from '../../services/reserve/consultService';
import perResultService from '../../services/preference/perResultService';

import * as contants from '../../constants/common';

import {
  getInquiryPersonListRequest,
  getInquiryPersonListSuccess,
  getInquiryPersonListFailure,
  getInquiryHistoryRequest,
  getInquiryHistorySuccess,
  getInquiryHistoryFailure,
  getInqPerInspectionRequest,
  getInqPerInspectionSuccess,
  getInqPerInspectionFailure,
} from '../../modules/inquiry/inquiryModule';

// 個人情報を取得するAction発生時に起動するメソッド
function* runRequestInquiryPersonList(action) {
  let { keyword } = action.payload;
  try {
    const pattern = new RegExp(`^[0-9]{${contants.LENGTH_RECEIPT_DAYID}}$`);
    if (pattern.test(keyword)) {
      // 受診日をシステム日付として指定当日IDの予約番号を取得する
      const consultFromReceipt = yield call(consultService.getConsultFromReceipt, { cslDate: new Date(), cntlNo: 0, dayId: keyword });
      const { perid } = consultFromReceipt;

      // 指定当日IDの個人ＩＤを取得成功Actionを発生させる
      yield put(getInquiryPersonListSuccess({ peceiptPerId: perid }));
    } else {
      keyword = keyword.replace(/\s+/g, ' ');
      // 個人情報を取得処理実行
      const person = yield call(personService.getPersonList, { ...action.payload, keyword });

      // 個人情報を取得成功Actionを発生させる
      yield put(getInquiryPersonListSuccess(person));
    }
  } catch (error) {
    // 個人情報を取得失敗Actionを発生させる
    yield put(getInquiryPersonListFailure(error.response));
  }
}

// 結果参照 対象者を取得取得するAction発生時に起動するメソッド
function* runRequestInquiryHistory(action) {
  try {
    // 個人情報を取得処理実行
    const personInf = yield call(personService.getPersonInf, action.payload);
    // 受診歴一覧を取得処理実行
    const consultHistory = yield call(consultService.getConsultHistory, action.payload);

    // 結果参照 対象者を取得成功Actionを発生させる
    yield put(getInquiryHistorySuccess({ personInf, consultHistory }));
  } catch (error) {
    // 結果参照 対象者を取得失敗Actionを発生させる
    yield put(getInquiryHistoryFailure(error.response));
  }
}

// 個人検査情報を取得取得するAction発生時に起動するメソッド
function* runRequestInqPerInspection(action) {
  const { params } = action.payload;
  try {
    // 受診歴一覧を取得処理実行
    const consultHistoryIns = yield call(consultService.getConsultHistory, { params: { ...params, getRowCount: 2 } });

    // 個人検査結果情報を取得処理実行
    const perResultList = yield call(perResultService.getPerResultList, params);

    // 個人検査情報を取得成功Actionを発生させる
    yield put(getInqPerInspectionSuccess({ consultHistoryIns, perResultList }));
  } catch (error) {
    // 個人検査情報を取得失敗Actionを発生させる
    yield put(getInqPerInspectionFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const inquirySagas = [
  takeEvery(getInquiryPersonListRequest.toString(), runRequestInquiryPersonList),
  takeEvery(getInquiryHistoryRequest.toString(), runRequestInquiryHistory),
  takeEvery(getInqPerInspectionRequest.toString(), runRequestInqPerInspection),
];

export default inquirySagas;
