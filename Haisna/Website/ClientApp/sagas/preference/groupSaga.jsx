import { call, takeEvery, put } from 'redux-saga/effects';

import groupService from '../../services/preference/groupService';

import * as groupModules from '../../modules/preference/groupModule';

// グループ一覧取得Action発生時に起動するメソッド
function* runRequestGroupList(action) {
  try {
    // グループ一覧取得処理実行
    const payload = yield call(groupService.getGroupList, action.payload);
    // グループ一覧取得成功Actionを発生させる
    yield put(groupModules.getGroupListSuccess(payload));
  } catch (error) {
    // グループ一覧取得失敗Actionを発生させる
    yield put(groupModules.getGroupListFailure(error.response));
  }
}

// グループ情報取得Action発生時に起動するメソッド
function* runRequestGroup(action) {
  try {
    // グループ情報取得処理実行
    const payload = yield call(groupService.getGroup, action.payload);
    // グループ情報取得成功Actionを発生させる
    yield put(groupModules.getGroupSuccess(payload));
  } catch (error) {
    // グループ情報取得失敗Actionを発生させる
    yield put(groupModules.getGroupFailure(error.response));
  }
}

// グループ情報登録Action発生時に起動するメソッド
function* runRegisterGroup(action) {
  try {
    // グループ情報登録処理実行
    yield call(groupService.registerGroup, action.payload);
    // グループ情報登録成功Actionを発生させる
    yield put(groupModules.registerGroupSuccess());
  } catch (error) {
    // グループ情報登録失敗Actionを発生させる
    yield put(groupModules.registerGroupFailure(error.response));
  }
}

// グループ情報削除Action発生時に起動するメソッド
function* runDeleteGroup(action) {
  try {
    // グループ情報削除処理実行
    yield call(groupService.deleteGroup, action.payload);
    // グループ情報削除成功Actionを発生させる
    yield put(groupModules.deleteGroupSuccess());
  } catch (error) {
    // グループ情報削除失敗Actionを発生させる
    yield put(groupModules.deleteGroupFailure(error.response));
  }
}

// グループガイド一覧取得Action発生時に起動するメソッド
function* runGetGroupGuideList(action) {
  try {
    const params = action.payload;
    const { grpDiv } = params;
    delete params.grpDiv;

    // グループ一覧取得処理実行
    const payload = yield call(groupService.getGroupListByDivision, grpDiv, params);
    // グループ情報取得成功Actionを発生させる
    yield put(groupModules.getGroupGuideListSuccess(payload));
  } catch (error) {
    // グループ情報取得失敗Actionを発生させる
    yield put(groupModules.getGroupGuideListFailure(error.resposne));
  }
}

// グループ情報取得Action発生時に起動するメソッド
function* runRequestParamGroup(action) {
  try {
    const { grpcd, successCallback } = action.payload;
    // グループ情報取得処理実行
    const payload = yield call(groupService.getGroup, grpcd);
    // 取得した値をセットする
    successCallback(payload);
    // グループ情報取得成功Actionを発生させる
    yield put(groupModules.getGroupParamSuccess(payload));
  } catch (error) {
    const { failureCallback } = action.payload;
    // 失敗時の処理
    failureCallback();
    // グループ情報取得失敗Actionを発生させる
    yield put(groupModules.getGroupParamFailure(error.response));
  }
}

// 結果初期値を設定する
function* runItemsandresults(action) {
  try {
    const { render, allResultClear } = action.payload;
    // 結果初期値一覧取得処理実行
    const payload = yield call(groupService.getGrpIItemDefResultList, action.payload);
    payload.render = !render;
    if (allResultClear) {
      payload.allResultClear = allResultClear;
    } else {
      payload.allResultClear = '0';
    }
    // 結果初期値一覧取得成功Actionを発生させる
    yield put(groupModules.getItemsandresultsSuccess(payload));
  } catch (error) {
    // 結果初期値一覧取得失敗Actionを発生させる
    yield put(groupModules.getItemsandresultsFailure(error.response));
  }
}

// 検査項目読み込み
function* runGrpItemList(action) {
  try {
    const { grpcd, allResultClear, render } = action.payload;
    // 検査項目読み込み一覧取得処理実行
    const payload = yield call(groupService.GetGrpIItemList, action.payload);
    payload.grpcd = grpcd;
    payload.render = !render;
    if (allResultClear) {
      payload.allResultClear = allResultClear;
    } else {
      payload.allResultClear = '0';
    }
    // 検査項目読み込み一覧取得成功Actionを発生させる
    yield put(groupModules.getGrpIItemListSuccess(payload));
  } catch (error) {
    // 検査項目読み込み一覧取得失敗Actionを発生させる
    yield put(groupModules.getGrpIItemListFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const groupSagas = [
  takeEvery(groupModules.getGroupListRequest.toString(), runRequestGroupList),
  takeEvery(groupModules.getGroupRequest.toString(), runRequestGroup),
  takeEvery(groupModules.registerGroupRequest.toString(), runRegisterGroup),
  takeEvery(groupModules.deleteGroupRequest.toString(), runDeleteGroup),
  takeEvery(groupModules.getGroupGuideListRequest.toString(), runGetGroupGuideList),
  takeEvery(groupModules.getGroupParamRequest.toString(), runRequestParamGroup),
  takeEvery(groupModules.getItemsandresults.toString(), runItemsandresults),
  takeEvery(groupModules.getGrpItemList.toString(), runGrpItemList),
];

export default groupSagas;
