import { call, takeEvery, put } from 'redux-saga/effects';
import specialInterviewService from '../../services/judgement/specialinterviewService';
import * as constants from '../../constants/common';
import {
  getSpecialRslViewRequest,
  getSpecialRslViewSuccess,
  getSpecialRslViewFailure,
  getSpecialJudCmtRequest,
  getSpecialJudCmtSuccess,
  getSpecialJudCmtFailure,
  getSpecialResultRequest,
  getSpecialResultSuccess,
  getSpecialResultFailure,
  getSubSpecialJudCmtRequest,
  getSubSpecialJudCmtSuccess,
  getSubSpecialJudCmtFailure,
  updateSpecialJudCmtRequest,
  updateSpecialJudCmtSuccess,
  updateSpecialJudCmtFailure,
} from '../../modules/judgement/specialInterviewModule';

// 受診者の検査結果を取得Action発生時に起動するメソッド
function* runRequestSpecialRslView(action) {
  try {
    // 受診者の検査結果を取得処理実行
    const rslviewdata = yield call(specialInterviewService.getSpecialRslView, action.payload);
    const rslviewdataLeft = [];
    const rslviewdataRight = [];
    let strSaveGrp = null;
    let strSaveGrpCd = null;
    for (let i = 0; i < rslviewdata.length; i += 1) {
      if (strSaveGrp !== rslviewdata[i].grpcd) {
        strSaveGrp = rslviewdata[i].grpcd;
      } else {
        rslviewdata[i].grpcount = '';
      }
      if (rslviewdata[i].grpcd === 'X079' || strSaveGrpCd === '1') {
        strSaveGrpCd = '1';
        rslviewdataRight.push(rslviewdata[i]);
      } else {
        rslviewdataLeft.push(rslviewdata[i]);
      }
    }
    // 受診者の検査結果を取得成功Actionを発生させる
    yield put(getSpecialRslViewSuccess({ rslviewdataLeft, rslviewdataRight }));
  } catch (error) {
    // 受診者の検査結果を取得失敗Actionを発生させる
    yield put(getSpecialRslViewFailure(error.response));
  }
}

// 階層化コメントを取得するAction発生時に起動するメソッド
function* runRequestSpecialJudCmt(action) {
  try {
    let judcmtdata = null;
    // 階層化コメントを取得処理実行
    judcmtdata = yield call(specialInterviewService.getSpecialJudCmt, action.payload);
    // 階層化コメントを取得成功Actionを発生させる
    yield put(getSpecialJudCmtSuccess({ judcmtdata }));
  } catch (error) {
    // 階層化コメントを取得失敗Actionを発生させる
    yield put(getSpecialJudCmtFailure(error.response));
  }
}

// 特定健診判定コメントを取得するAction発生時に起動するメソッド
function* runRequestSubSpecialJudCmt(action) {
  try {
    let judcmtdata = null;
    // 階層化コメントを取得処理実行
    judcmtdata = yield call(specialInterviewService.getSpecialJudCmt, action.payload);
    // 階層化コメントを取得成功Actionを発生させる
    yield put(getSubSpecialJudCmtSuccess({ judcmtdata }));
  } catch (error) {
    // 階層化コメントを取得失敗Actionを発生させる
    yield put(getSubSpecialJudCmtFailure(error.response));
  }
}

// 予約番号をもって検査結果を取得Action発生時に起動するメソッド
function* runRequestSpecialResult(action) {
  try {
    // 予約番号をもって検査結果を取得処理実行
    const resultdata = yield call(specialInterviewService.getSpecialResult, action.payload);
    // 予約番号をもって検査結果を取得成功Actionを発生させる
    yield put(getSpecialResultSuccess({ resultdata }));
  } catch (error) {
    // 予約番号をもって検査結果を取得失敗Actionを発生させる
    yield put(getSpecialResultFailure(error.response));
  }
}

// 特定健診コメントを更新するAction発生時に起動するメソッド
function* runUpdateSpecialJudCmt(action) {
  try {
    const { params, data } = action.payload;
    const { judcmtdata } = data;
    const { rsvno } = params;
    if (judcmtdata.length > 0) {
      // 特定健診コメントを更新処理実行
      const payload = yield call(specialInterviewService.updateSpecialJudCmt, {
        data: {
          rsvno,
          dispmode: constants.DISPMODE_SPADVICE,
          specialjudcmt: judcmtdata,
        },
      });
      // 特定健診コメントを更新成功Actionを発生させる
      yield put(updateSpecialJudCmtSuccess(payload));
      // 特定健診コメントを再読み込み
      yield put(getSpecialJudCmtRequest({ ...params, dispmode: constants.DISP_MODE }));
    }
  } catch (error) {
    // 特定健診コメントを更新失敗Actionを発生させる
    yield put(updateSpecialJudCmtFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const specialinterviewSagas = [
  takeEvery(getSpecialRslViewRequest.toString(), runRequestSpecialRslView),
  takeEvery(getSpecialJudCmtRequest.toString(), runRequestSpecialJudCmt),
  takeEvery(getSpecialResultRequest.toString(), runRequestSpecialResult),
  takeEvery(getSubSpecialJudCmtRequest.toString(), runRequestSubSpecialJudCmt),
  takeEvery(updateSpecialJudCmtRequest.toString(), runUpdateSpecialJudCmt),
];

export default specialinterviewSagas;
