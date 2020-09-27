import { call, takeEvery, put } from 'redux-saga/effects';

import bbsService from '../../services/common/bbsService';

import {
  getAllBbsRequest,
  getAllBbsSuccess,
  getAllBbsFailure,
  deleteBbsRequest,
  deleteBbsSuccess,
  deleteBbsFailure,
  // コメントの登録
  registerBbsRequest,
  registerBbsSuccess,
  registerBbsFailure,
} from '../../modules/common/bbsModule';

// コメント取得Action発生時に起動するメソッド
function* runRequestAllBbs(action) {
  try {
    // 今日のコメント取得処理実行
    const payload = yield call(bbsService.getAllBbs, action.payload);
    // 今日のコメント取得成功Actionを発生させる
    yield put(getAllBbsSuccess(payload));
  } catch (error) {
    // 今日のコメント取得失敗Actionを発生させる
    yield put(getAllBbsFailure(error.response));
  }
}

// コメント情報削除Action発生時に起動するメソッド
function* runDeleteBbs(action) {
  try {
    const { redirect } = action.payload;
    // コメント情報削除処理実行
    yield call(bbsService.deleteBbs, action.payload);
    // コメント情報削除成功Actionを発生させる
    yield put(deleteBbsSuccess());
    // 次のURLへ遷移
    yield call(redirect);
  } catch (error) {
    // コメント情報削除失敗Actionを発生させる
    yield put(deleteBbsFailure(error.response));
  }
}

// コメントの登録Action発生時に起動するメソッド
function* runRegisterBbs(action) {
  try {
    const { redirect } = action.payload;
    // コメントの登録処理実行
    yield call(bbsService.registerBbs, action.payload);
    // コメントの登録成功Actionを発生させる
    yield put(registerBbsSuccess());
    // 次のURLへ遷移
    yield call(redirect);
  } catch (error) {
    // コメントの登録失敗Actionを発生させる
    yield put(registerBbsFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const bbsSagas = [
  takeEvery(getAllBbsRequest.toString(), runRequestAllBbs),
  takeEvery(deleteBbsRequest.toString(), runDeleteBbs),
  takeEvery(registerBbsRequest.toString(), runRegisterBbs),
];

export default bbsSagas;

