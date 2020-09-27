import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';

import organizationService from '../../services/preference/organizationService';

import {
  getOrgRequest,
  getOrgSuccess,
  getOrgFailure,
  registerOrgRequest,
  registerOrgSuccess,
  registerOrgFailure,
  deleteOrgRequest,
  deleteOrgSuccess,
  deleteOrgFailure,
  getOrgListRequest,
  getOrgListSuccess,
  getOrgListFailure,
  getOrgGuideListRequest,
  getOrgGuideListSuccess,
  getOrgGuideListFailure,
  getOrgGuideValueRequest,
  getOrgGuideValueSuccess,
  getOrgGuideValueFailure,
  // 成績書オプション管理ガイド用
  getOrgRptSetOptionGuideRequest,
  getOrgRptSetOptionGuideSuccess,
  getOrgRptSetOptionGuideFailure,
  registerOrgRptOptRequest,
  registerOrgRptOptSuccess,
  registerOrgRptOptFailure,
  getOrgHeaderRequest,
  getOrgHeaderSuccess,
  getOrgHeaderFailure,
  // 受診者数取得（団体別）
  getSelDateOrgRequest,
  getSelDateOrgSuccess,
  getSelDateOrgFailure,
} from '../../modules/preference/organizationModule';

// 団体一覧取得Action発生時に起動するメソッド
function* runRequestOrgList(action) {
  try {
    // 団体一覧取得処理実行
    const payload = yield call(organizationService.getOrgList, action.payload);
    // 団体一覧取得成功Actionを発生させる
    yield put(getOrgListSuccess(payload));
  } catch (error) {
    // 団体一覧取得失敗Actionを発生させる
    yield put(getOrgListFailure(error.response));
  }
}

// 団体情報取得Action発生時に起動するメソッド
function* runRequestOrg(action) {
  try {
    const { formName, params } = action.payload;
    // 団体情報取得処理実行
    const payload = yield call(organizationService.getOrg, params);

    // 団体情報をredux-formへセットするActionを発生させる
    yield put(initialize(formName, payload));

    // 団体情報取得成功Actionを発生させる
    yield put(getOrgSuccess(payload));
  } catch (error) {
    // 団体情報取得失敗Actionを発生させる
    yield put(getOrgFailure(error.response));
  }
}

// 団体情報登録Action発生時に起動するメソッド
function* runRegisterOrg(action) {
  try {
    // 団体情報登録処理実行
    yield call(organizationService.registerOrg, action.payload);
    // 団体情報登録成功Actionを発生させる
    yield put(registerOrgSuccess());
  } catch (error) {
    // 団体情報登録失敗Actionを発生させる
    yield put(registerOrgFailure(error.response));
  }
}

// 団体情報削除Action発生時に起動するメソッド
function* runDeleteOrg(action) {
  try {
    // 団体情報削除処理実行
    yield call(organizationService.deleteOrg, action.payload);
    // 団体情報削除成功Actionを発生させる
    yield put(deleteOrgSuccess());
  } catch (error) {
    // 団体情報削除失敗Actionを発生させる
    yield put(deleteOrgFailure(error.response));
  }
}

// 団体ガイド一覧取得Action発生時に起動するメソッド
function* runRequestOrgGuideList(action) {
  try {
    // 団体ガイド一覧取得処理実行
    const payload = yield call(organizationService.getOrgList, action.payload);
    // 団体ガイド一覧取得成功Actionを発生させる
    yield put(getOrgGuideListSuccess(payload));
  } catch (error) {
    // 団体ガイド一覧取得失敗Actionを発生させる
    yield put(getOrgGuideListFailure(error.response));
  }
}

// 団体ガイド行要素取得Action発生時に起動するメソッド
function* runRequestOrgGuideValue(action) {
  try {
    // 団体情報取得処理実行
    const payload = yield call(organizationService.getOrg, action.payload);
    // 団体ガイド行要素取得成功Actionを発生させる
    yield put(getOrgGuideValueSuccess(payload));
  } catch (error) {
    // 団体ガイド行要素取得失敗Actionを発生させる
    yield put(getOrgGuideValueFailure(error.response));
  }
}

// 成績書オプション管理取得Action発生時に起動するメソッド
function* runRequestOrgRptOpt(action) {
  try {
    const { formName } = action.payload;
    // 成績書オプション管理取得処理実行
    const payload = yield call(organizationService.getOrgRptOpt, action.payload);
    // 成績書オプション管理情報をredux-formへセットするActionを発生させる
    const { orgrptoptrptv, orgrptoptrptd } = payload;
    yield put(initialize(formName, { orgrptoptrptv, orgrptoptrptd }));
    // 成績書オプション管理取得成功Actionを発生させる
    yield put(getOrgRptSetOptionGuideSuccess(payload));
  } catch (error) {
    // 成績書オプション管理失敗Actionを発生させる
    yield put(getOrgRptSetOptionGuideFailure(error.response));
  }
}

// 成績書オプション管理情報登録Action発生時に起動するメソッド
function* runRegisterOrgRptOpt(action) {
  try {
    // 成績書オプション管理情報登録処理実行
    yield call(organizationService.registerOrgRptOpt, action.payload);
    // 成績書オプション管理情報登録成功Actionを発生させる
    yield put(registerOrgRptOptSuccess());
  } catch (error) {
    // 成績書オプション管理情報登録失敗Actionを発生させる
    yield put(registerOrgRptOptFailure(error.response));
  }
}

// 団体コードをキーに団体テーブルを読み込むAction発生時に起動するメソッド
function* runRequestOrgHeader(action) {
  try {
    // 団体コードをキーに団体テーブルを読み込む処理実行
    const payload = yield call(organizationService.getOrgHeader, action.payload);
    // 団体コードをキーに団体テーブルを読み込む成功Actionを発生させる
    yield put(getOrgHeaderSuccess(payload));
  } catch (error) {
    // 団体コードをキーに団体テーブルを読み込む失敗Actionを発生させる
    yield put(getOrgHeaderFailure(error.response));
  }
}

// 受診者数取得（団体別）Action発生時に起動するメソッド
function* runRequestSelDateOrg(action) {
  try {
    // 受診者数取得（団体別）処理実行
    const payload = yield call(organizationService.getSelDateOrg, action.payload);
    // 受診者数取得（団体別）成功Actionを発生させる
    yield put(getSelDateOrgSuccess(payload));
  } catch (error) {
    // 受診者数取得（団体別）失敗Actionを発生させる
    yield put(getSelDateOrgFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const organizationSagas = [
  takeEvery(getOrgListRequest.toString(), runRequestOrgList),
  takeEvery(getOrgRequest.toString(), runRequestOrg),
  takeEvery(registerOrgRequest.toString(), runRegisterOrg),
  takeEvery(deleteOrgRequest.toString(), runDeleteOrg),
  takeEvery(getOrgGuideListRequest.toString(), runRequestOrgGuideList),
  takeEvery(getOrgGuideValueRequest.toString(), runRequestOrgGuideValue),
  // 成績書オプション管理
  takeEvery(getOrgRptSetOptionGuideRequest.toString(), runRequestOrgRptOpt),
  takeEvery(registerOrgRptOptRequest.toString(), runRegisterOrgRptOpt),
  takeEvery(getOrgHeaderRequest.toString(), runRequestOrgHeader),
  // 受診者数取得（団体別）
  takeEvery(getSelDateOrgRequest.toString(), runRequestSelDateOrg),
];

export default organizationSagas;
