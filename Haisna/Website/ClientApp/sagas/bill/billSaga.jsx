import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';

import perBillService from '../../services/bill/perBillService';

import {
  openOtherIncomeInfoGuideRequest,
  closeOtherIncomeInfoGuide,
  openGdeOtherIncomeGuideRequest,
  openGdeOtherIncomeGuideSuccess,
  openGdeOtherIncomeGuideFailure,
  checkValueAndInsertPerBillcRequest,
  checkValueAndInsertPerBillcFailure,
  // 請求書番号選択画面
  openOtherIncomeSubGuideRequest,
  openOtherIncomeSubGuideSuccess,
  openOtherIncomeSubGuideFailure,
} from '../../modules/bill/billModule';

// 予約番号から個人請求書管理情報を取得する
function* runRequestopenOtherIncomeSubGuide(action) {
  const { params } = action.payload;
  try {
    // 予約番号から個人請求書管理情報の取得
    const perBill = yield call(perBillService.getPerBill, params);
    yield put(openOtherIncomeSubGuideSuccess(perBill));
  } catch (error) {
    // 予約番号から個人請求書管理情報を取得失敗Actionを発生させる
    yield put(openOtherIncomeSubGuideFailure({ ...error.response, params }));
  }
}

// セット外請求明細情報を取得する
function* runRequestopenGdeOtherIncomeGuide() {
  try {
    // セット外請求明細情報の取得
    const otherlinediv = yield call(perBillService.getOtherLineDiv);
    yield put(openGdeOtherIncomeGuideSuccess(otherlinediv));
  } catch (error) {
    // セット外請求明細情報を取得失敗Actionを発生させる
    yield put(openGdeOtherIncomeGuideFailure(error.response));
  }
}
// セット外請求明細登録・修正初期設定
function* runRequestopenOtherIncomeInfoGuide(action) {
  const { divcd, divname, linename, price, editprice, taxprice, edittax } = action.payload;
  const initialValues = {
    divcd: divcd == null ? '' : divcd,
    dspdivname: divname == null ? '' : divname,
    dsplinename: linename == null ? '' : linename,
    price: price == null ? '0' : price,
    editprice: editprice == null ? '0' : editprice,
    taxprice: taxprice == null ? '0' : taxprice,
    edittax: edittax == null ? '0' : edittax,
  };
  yield put(initialize('otherIncomeInfoGuide', initialValues));
}
// 入力チェックと受診確定金額情報、個人請求明細情報の登録する
function* runRequestcheckValueAndInsertPerBillc(action) {
  try {
    let { dmddate, billseq, branchno } = action.payload.params;
    const { mode, price, editprice, taxprice, edittax, rsvno, dspdivname, divcd, dsplinename, billcount } = action.payload.params;
    const { onSelected } = action.payload;
    let linename = dsplinename;
    if (dspdivname === dsplinename) {
      linename = '';
    }

    if (billcount === 0) {
      dmddate = '';
      billseq = 0;
      branchno = 0;
    }

    // 入力チェックと受診確定金額情報、個人請求明細情報の登録
    yield call(perBillService.checkValueAndInsertPerBillc, {
      dmddate,
      billseq,
      branchno,
      price,
      editprice,
      taxprice,
      edittax,
      linename,
      rsvno,
      otherlinedivcd: divcd,
      linenamedmd: dsplinename,
      billcount,
      mode,
    });

    if (billcount !== 0 && billcount !== 1) {
      // 請求書情報選択画面へ
      yield put(openOtherIncomeSubGuideRequest(action.payload));
    } else if (mode === 'person') {
      // 個人請求書管理個人情報作成
      onSelected({ divcd, linename, dspdivname, price, editprice, taxprice, edittax });
    } else {
      // 自身を閉じる
      yield put(closeOtherIncomeInfoGuide());
    }
  } catch (error) {
    // 入力チェックと受診確定金額情報、個人請求明細情報の登録失敗Actionを発生させる
    yield put(checkValueAndInsertPerBillcFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const billSagas = [
  takeEvery(openOtherIncomeInfoGuideRequest.toString(), runRequestopenOtherIncomeInfoGuide),
  takeEvery(openGdeOtherIncomeGuideRequest.toString(), runRequestopenGdeOtherIncomeGuide),
  takeEvery(checkValueAndInsertPerBillcRequest.toString(), runRequestcheckValueAndInsertPerBillc),
  takeEvery(openOtherIncomeSubGuideRequest.toString(), runRequestopenOtherIncomeSubGuide),
];

export default billSagas;
