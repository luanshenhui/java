import { call, takeEvery, put } from 'redux-saga/effects';
import * as constants from '../../constants/common';

import reportSendDateService from '../../services/report/reportSendDateService';

import consultService from '../../services/reserve/consultService';
import {
  getWelComeInfoRequest,
  getWelComeInfoSuccess,
  getWelComeInfoFailure,
  getReportSendDateListRequest,
  getReportSendDateListSuccess,
  getReportSendDateListFailure,
  deleteConsultReptSendRequest,
  deleteConsultReptSendSuccess,
  deleteConsultReptSendFailure,
} from '../../modules/report/reportSendDateModule';

function* runGetWelComeInfoRequest(action) {
  try {
    const message = [];
    let strAction = '';
    let blnCslInfoFlg = false;
    let payload1 = {};
    let payload3 = {};
    if (action.payload.rsvno) {
      let strMessage = '';
      const r = /^\d+$/;
      if (action.payload.rsvno.length > constants.LENGTH_CONSULT_RSVNO || !r.test(action.payload.rsvno)) {
        strMessage = `予約番号は${constants.LENGTH_CONSULT_RSVNO}文字以内の半角数字で入力して下さい。`;
        message.push(strMessage);
        strAction = 'checkerr';
      }
    } else {
      message.push('予約番号を入力して下さい。');
      strAction = 'checkerr';
    }
    // 受診情報の取得
    if (action.payload.act !== '' && strAction !== 'checkerr') {
      try {
        const payload = yield call(consultService.getWelComeInfo, action.payload);
        if (!payload.dayid) {
          message.push(`指定された予約番号の受診情報は未受付です。（予約番号=${action.payload.rsvno})`);
          strAction = 'checkerr';
        } else if (!payload.comedate) {
          message.push(`指定された予約番号の受診情報は未来院です。（予約番号=${action.payload.rsvno})`);
          strAction = 'checkerr';
        }
      } catch (error) {
        message.push(`受診情報が存在しません。（予約番号=${action.payload.rsvno})`);
      }
    }
    // 発送確認（新規）
    if (action.payload.act === 'save' && strAction !== 'checkerr') {
      try {
        // 発送データの存在チェック
        payload1 = yield call(reportSendDateService.getConsultReptSendLast, action.payload);
        strAction = 'choisemode';
        blnCslInfoFlg = true;
      } catch (error) {
        // 成績書発送日更新
        try {
          yield call(reportSendDateService.insert, action.payload);
          strAction = 'saveend';
          blnCslInfoFlg = true;
        } catch (err) {
          strAction = 'saveerr';
        }
      }
    }
    // 発送確認（追加挿入モード）
    if (action.payload.act === 'forceins' && strAction !== 'checkerr') {
      try {
        // 成績書発送日追加
        yield call(reportSendDateService.insert, action.payload);
        strAction = 'saveend';
        blnCslInfoFlg = true;
      } catch (error) {
        strAction = 'saveerr';
      }
    }
    // 発送確認（更新モード）
    if (action.payload.act === 'upd' && strAction !== 'checkerr') {
      try {
        // 成績書発送日更新
        yield call(reportSendDateService.update, action.payload);
        strAction = 'saveend';
        blnCslInfoFlg = true;
      } catch (error) {
        strAction = 'saveerr';
      }
    }
    // 発送確認情報削除
    if (action.payload.act === 'clear' && strAction !== 'checkerr') {
      try {
        yield call(reportSendDateService.deleteConsultReptSendBefore, action.payload);
        strAction = 'clearend';
      } catch (error) {
        strAction = 'clearerr';
      }
      blnCslInfoFlg = true;
    }
    // 受診情報を表示する？
    if (blnCslInfoFlg) {
      try {
        payload3 = yield call(consultService.getConsult, action.payload);
      } catch (error) {
        message.push(`受診情報が存在しません。（予約番号=${action.payload.rsvno})`);
      }
    }
    // 受診者の検査結果を取得成功Actionを発生させる
    yield put(getWelComeInfoSuccess({ message, strAction, blnCslInfoFlg, payload1, payload3 }));
  } catch (error) {
    yield put(getWelComeInfoFailure(error.response));
  }
}

function* runGetReportSendDateListRequest(action) {
  try {
    // 検索条件に従い成績書情報一覧を抽出する
    const payload = yield call(reportSendDateService.getReportSendDateList, action.payload);
    yield put(getReportSendDateListSuccess(payload));
  } catch (error) {
    yield put(getReportSendDateListFailure(error.response));
  }
}

function* runDeleteConsultReptSendRequest(action) {
  try {
    // 保存ボタンクリック
    const payload = yield call(reportSendDateService.deleteConsultReptSend, action.payload);
    yield put(deleteConsultReptSendSuccess(payload));
  } catch (error) {
    yield put(deleteConsultReptSendFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const reportSendDateSagas = [
  takeEvery(getWelComeInfoRequest.toString(), runGetWelComeInfoRequest),
  takeEvery(getReportSendDateListRequest.toString(), runGetReportSendDateListRequest),
  takeEvery(deleteConsultReptSendRequest.toString(), runDeleteConsultReptSendRequest),
];

export default reportSendDateSagas;
