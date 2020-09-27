import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import Moment from 'moment';
import consultService from '../../services/reserve/consultService';
import perBillService from '../../services/bill/perBillService';
import demandService from '../../services/bill/demandService';
import * as contants from '../../constants/common';

import {
  deleteBillLineRequest,
  deleteBillLineSuccess,
  deleteBillLineFailure,
  saveBillDetailRequest,
  saveBillDetailSuccess,
  saveBillDetailFailure,
  openDmdEditBillLineRequest,
  openDmdEditBillLineSuccess,
  openDmdEditBillLineFailure,
  getNowTaxSuccess,
  getNowTaxRequest,
  getNowTaxFailure,
  dmdOrgMasterBurdenRequest,
  dmdOrgMasterBurdenSuccess,
  dmdOrgMasterBurdenFailure,
  getPaymentRequest,
  getPaymentSuccess,
  getPaymentFailure,
  getPersonalCloseMngInfoFailure,
  registerPerbillRequest,
  registerPerbillSuccess,
  registerPerbillFailure,
  registerDelDspRequest,
  registerDelDspSuccess,
  registerDelDspFailure,
  openCreatePerBillGuideRequest,
  openCreatePerBillGuideSuccess,
  openCreatePerBillGuideFailure,
  // 請求書削除
  deleteAllBillRequest,
  deleteAllBillSuccess,
  deleteAllBillFailure,
  //
  getDmdBurdenListRequest,
  getDmdBurdenListSuccess,
  getDmdBurdenListFailure,
  // ２次検査の合計金額追加追加
  getSumDetailItemsSuccess,
  //
  getDmdPaymentBillSumSuccess,
  getDmdPaymentBillSumFailure,
  //
  getDmdPaymentPriceSuccess,
  getDmdPaymentPriceFailure,
  //
  getDmdPaymentSuccess,
  getDmdPaymentFailure,
  //
  registerPaymentRequest,
  registerPaymentSuccess,
  registerPaymentFailure,
  updatePaymentSuccess,
  updatePaymentFailure,
  //
  deletePaymentRequest,
  deletePaymentSuccess,
  deletePaymentFailure,
  //
  openDmdPaymentGuide,
  closeDmdPaymentGuide,
  loadDmdPaymentGuideData,
  loadDmdPaymentData,
  getPaymentErrorMessage,
  getDmdBurdenListMessage,
  //
  getDmdBurdenFailure,
  getDmdListRequest,
  getDmdListSuccess,
  getDmdListFailure,
  getDmdDetailItm,
  getDmdCountFailure,
  getDmdRecordSuccess,
  getDmdRecordFailure,
  getDmdCommentRequest,
  getDmdCommentSuccess,
  getDmdCommentFailure,
  getDmdDetailListRequest,
  getDmdDetailListSuccess,
  getDmdDetailListFailure,
  getSumRecordFailure,
  deleteDmdRequest,
  deleteDmdSuccess,
  deleteDmdFailure,
  openDmdDetailItmListGuide,
  openDmdBurdenModifyGuide,
  getOpenDmdBurdenModifyGuideSuccess,
  getOpenDmdBurdenModifyGuideFailure,
  closeDmdCommentGuide,
  //
  getDispatchSeqRequest,
  getDispatchSeqSuccess,
  getDispatchSeqFailure,
  deleteDispatchRequest,
  deleteDispatchSuccess,
  deleteDispatchFailure,
  updateDispatchRequest,
  updateDispatchSuccess,
  updateDispatchFailure,
  insertDispatchRequest,
  insertDispatchSuccess,
  insertDispatchFailure,
  checkValueSendCheckDayRequest,
  checkValueSendCheckDaySuccess,
  checkValueSendCheckDayFailure,
  getDmdEditDetailItemLineRequest,
  getDmdEditDetailItemLineSuccess,
  getDmdEditDetailItemLineFailure,
  registerDmdEditDetailItemLineRequest,
  registerDmdEditDetailItemLineSuccess,
  registerDmdEditDetailItemLineFailure,
  deleteDmdEditDetailItemLineRequest,
  deleteDmdEditDetailItemLineSuccess,
  deleteDmdEditDetailItemLineFailure,
} from '../../modules/bill/demandModule';

function* runRequestPayment(action) {
  let paymentInfo = {};
  let paymentList = [];
  let paymentConsultInfo = [];
  let paymentConsultTotal = [];
  let consultmTotal = [];
  let perCloseMngInfo = [];
  try {
    // 検索条件を満たす受診者の個人情報を取得処理実行
    paymentInfo = yield call(consultService.getPayment, action.payload);
    // 同伴者請求書取得処理実行
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPaymentFailure(error.response));
    return;
  }
  try {
    // 同伴者請求書取得処理実行
    paymentList = yield call(consultService.getPaymentList, paymentInfo);
  } catch (error) {
    yield put(getPaymentFailure);
  }
  try {
    // 予約番号から個人請求書管理情報を取得処理実行
    paymentConsultInfo = yield call(perBillService.getPaymentConsultInfo, action.payload);
  } catch (error) {
    yield put(getPaymentFailure);
  }
  try {
    // 締め管理情報取得処理実行
    paymentConsultTotal = yield call(demandService.getPaymentConsultTotal, action.payload);
  } catch (error) {
    yield put(getPaymentFailure);
  }
  try {
    // 個人受診金額小計を取得処理実行
    consultmTotal = yield call(demandService.getConsultmTotal, action.payload);
  } catch (error) {
    yield put(getPaymentFailure);
  }
  try {
    // 個人毎の締め管理情報を取得
    perCloseMngInfo = yield call(demandService.getPersonalCloseMngInfo, action.payload);
  } catch (error) {
    yield put(getPersonalCloseMngInfoFailure);
  }
  // 情報取得成功Actionを発生させる
  yield put(getPaymentSuccess({ paymentInfo, paymentList, paymentConsultInfo, paymentConsultTotal, consultmTotal, perCloseMngInfo }));
}

function* runRegisterDelDsp(action) {
  const { formValues } = action.payload;
  const params = action.payload.params.rsvno;
  try {
    const payload = yield call(perBillService.registerDelDsp, action.payload);

    yield put(registerDelDspSuccess({ payload, formValues }));
    yield put(getPaymentRequest({ params }));
  } catch (error) {
    yield put(registerDelDspFailure(error.response));
  }
}

// personbill
function* runRegisterPerbill(action) {
  try {
    let message = [];
    const { formValues, items, params } = action.payload;

    if (formValues.dropdownitem > 1) {
      let createCnt = 0;
      for (let i = 0; i < items.length; i += 1) {
        if (formValues[`piece${i + 1}`] === '0') {
          formValues[`piece${i + 1}`] = '0';
        } else if (formValues[`piece${i + 1}`] !== '0') {
          createCnt += 1;
        }
      }
      if (createCnt === 0) {
        message = ['請求書Noを選択して下さい。'];
      }
      if (message.length > 0) {
        yield put(registerPerbillFailure({ message }));
        return;
      }
    }

    const SelectNo = items.length;
    const Page = [];
    const AllPriceSeq = [];
    for (let j = 0; j < items.length; j += 1) {
      if (formValues.dropdownitem === '1') {
        Page[j] = 1;
      } else {
        Page[j] = formValues[`piece${j + 1}`];
      }
      AllPriceSeq[j] = items[j].priceseq;
    }
    const DmdDate = formValues.cslDate;
    const RsvNo = params;

    const data = { SelectNo, DmdDate, RsvNo, Page, AllPriceSeq };
    // 受診情報から個人請求書を作成する
    const payload = yield call(perBillService.registerPerbill, data);
    yield put(getPaymentRequest({ params }));

    yield put(registerPerbillSuccess(payload));
  } catch (error) {
    const message = ['請求書の作成に失敗しました。'];
    yield put(registerPerbillFailure({ message }));
  }
}

function* runOpenCreatePerBillGuide(action) {
  try {
    // 検索条件を満たす受診者の個人情報を取得処理実行

    const payment = yield call(consultService.getPayment, action.payload);
    // 締め管理情報取得処理実行
    const paymentConsultTotal = yield call(demandService.getPaymentConsultTotal, action.payload);
    const formValue = { dropdownitem: '1', cslDate: payment.csldate };
    const consultmInfo = [];
    for (let j = 0; j < paymentConsultTotal.length; j += 1) {
      if (paymentConsultTotal[j].orgcd1 === contants.ORGCD1_PERSON && paymentConsultTotal[j].orgcd2 === contants.ORGCD1_PERSON) {
        consultmInfo[j] = paymentConsultTotal[j];
        formValue[`piece${j + 1}`] = '0';
      }
    }
    // 情報取得成功Actionを発生させる
    yield put(openCreatePerBillGuideSuccess({ payment, consultmInfo }));

    yield put(initialize('createPerBillForm', formValue));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(openCreatePerBillGuideFailure(error.response));
  }
}
// 一覧取得Action発生時に起動するメソッド
function* runRequestDmdBurdenList(action) {
  // '未収額
  let strDispNoPaymentPrice;
  // '請求金額
  let strDispBillTotal;
  let strdispnopaymentprice;
  // '請求金額
  let strdispbilltotal;
  // '消費税
  let strDispTaxTotal;
  let strdisptaxtotal;
  // '小計
  let strDispPriceTotal;
  let strdisppricetotal;
  let payload = {};
  let strYear = 0;
  let strMonth = 0;
  let strDay = 0;
  let endYear = 0;
  let endMonth = 0;
  let endDay = 0;
  let strArrMessage;
  const Message = [];
  const LENGTH_BILLNO = 14;
  const data = action.payload;
  let StrDate;
  let EndDate;
  let newDate = null;
  // 日付の書式
  const { billNo } = data;
  let tmp = '';
  let strCloseDate;
  const parsingFormat = ['YYYY/MM/DD', 'YYYY/M/D', 'YY/M/D', 'M/D', 'YYYYMMDD', 'YYMMDD', 'MMDD', 'D'];
  try {
    if (data.strDate !== null && data.endDate !== null) {
      const sDate = Moment(data.strDate).format('YYYYMMDD');
      strYear = Number(sDate.substr(0, 4));
      strMonth = Number(sDate.substr(4, 2));
      strDay = Number(sDate.substr(6, 2));
      const eDate = Moment(data.endDate).format('YYYYMMDD');
      endYear = Number(eDate.substr(0, 4));
      endMonth = Number(eDate.substr(4, 2));
      endDay = Number(eDate.substr(6, 2));
    }
    const params = { strYear, strMonth, strDay, endYear, endMonth, endDay, billNo };
    yield call(demandService.checkValueDmdPaymentSearch, params);
    if (billNo !== null && billNo !== '') {
      if (billNo.length === LENGTH_BILLNO) {
        strCloseDate = `${billNo.substr(0, 4)}/${billNo.substr(4, 2)}/${billNo.substr(6, 2)}`;
        // 書式に従って日付を取得
        newDate = Moment(strCloseDate, parsingFormat, true);
        if (!newDate.isValid()) {
          strArrMessage = ['請求書番号の日付入力形式が正しくありません。'];
          Message.push(strArrMessage);
          yield put(getDmdBurdenListMessage({ Message }));
          return;
        }
      }
    }
    try {
      if (data.strDate > data.endDate) {
        const date = data.strDate;
        StrDate = data.endDate;
        EndDate = date;
      } else {
        StrDate = data.strDate;
        EndDate = data.endDate;
      }
      // 取得処理実行
      payload = yield call(demandService.getDmdBurdenList, { ...data, strDate: StrDate, endDate: EndDate });
      for (let i = 0; i < payload.burdenlist.length; i += 1) {
        // '未収額
        if ((payload.burdenlist[i].billtotal) !== null) {
          if ((payload.burdenlist[i].sum_paymentprice) !== null) {
            strDispNoPaymentPrice = (payload.burdenlist[i].billtotal - payload.burdenlist[i].sum_paymentprice);
          } else {
            strDispNoPaymentPrice = payload.burdenlist[i].billtotal;
          }
        } else if ((payload.burdenlist[i].billtotal) === null) {
          if (payload.burdenlist[i].sum_paymentprice !== null) {
            strDispNoPaymentPrice = (payload.burdenlist[i].sum_paymentprice * -1);
          } else {
            strDispNoPaymentPrice = null;
          }
        }
        // '請求金額
        if (payload.burdenlist[i].billtotal !== null) {
          strDispBillTotal = payload.burdenlist[i].billtotal;
        } else {
          strDispBillTotal = null;
        }
        // '税額
        if (payload.burdenlist[i].taxtotal !== null) {
          strDispTaxTotal = payload.burdenlist[i].taxtotal;
        } else {
          strDispTaxTotal = null;
        }
        // '小計
        if (payload.burdenlist[i].pricetotal !== null) {
          strDispPriceTotal = payload.burdenlist[i].pricetotal;
        } else {
          strDispPriceTotal = null;
        }

        try {
          const payload1 = yield call(demandService.getSumDetail, payload.burdenlist[i].billno);

          strdispnopaymentprice = Number(strDispNoPaymentPrice) + payload1[0].sumpricetotal;
          strdispbilltotal = Number(strDispBillTotal) + payload1[0].sumpricetotal;
          strdisptaxtotal = Number(strDispTaxTotal) + payload1[0].sumtaxprice + payload1[0].sumedittax;
          strdisppricetotal = Number(strDispPriceTotal) + payload1[0].sumprice + payload1[0].sumeditprice;
          Object.assign(payload.burdenlist[i], payload1[0], { strdispnopaymentprice }, { strdispbilltotal }, { strdisptaxtotal }, { strdisppricetotal });
          // 取得成功Actionを発生させる
        } catch (error) {
          // 取得失敗Actionを発生させる
          strdispnopaymentprice = strDispNoPaymentPrice;
          strdispbilltotal = strDispBillTotal;
          strdisptaxtotal = strDispTaxTotal;
          strdisppricetotal = strDispPriceTotal;
          Object.assign(payload.burdenlist[i], [], { strdispnopaymentprice }, { strdispbilltotal }, { strdisptaxtotal }, { strdisppricetotal });
        }
      }
      //  取得成功Actionを発生させる
      yield put(getDmdBurdenListSuccess(payload));
    } catch (error) {
      // 取得失敗Actionを発生させる
      yield put(getDmdBurdenListFailure(error.response));
    }
  } catch (error) {
    const errorMessage = error.response.data;
    Message.push(errorMessage);
    if (billNo !== null && billNo !== '') {
      if (billNo.length === LENGTH_BILLNO) {
        if (billNo.match(/[\uff00-\uffff]/g)) {
          // 数字の全角を半角に回す
          for (let i = 0; i < billNo.length; i += 1) {
            if (billNo.charCodeAt(i) > 65248 && billNo.charCodeAt(i) < 65375) {
              tmp += String.fromCharCode(billNo.charCodeAt(i) - 65248);
            } else {
              tmp += String.fromCharCode(billNo.charCodeAt(i));
            }
          }
          strCloseDate = `${tmp.substr(0, 4)}/${tmp.substr(4, 2)}/${tmp.substr(6, 2)}`;
        } else {
          strCloseDate = `${billNo.substr(0, 4)}/${billNo.substr(4, 2)}/${billNo.substr(6, 2)}`;
        }
        // 書式に従って日付を取得
        newDate = Moment(strCloseDate, parsingFormat, true);
        if (!newDate.isValid()) {
          strArrMessage = ['請求書番号の日付入力形式が正しくありません。'];
          Message.push(strArrMessage);
        }
      }
    }
    yield put(getDmdBurdenListMessage({ Message }));
  }
}
//
function* runRequestOpenDmdPaymentGuide(action) {
  const { billno, seq, formname, Cookie } = action.payload;
  const Message = {};
  let lngSeq = null;
  let strDispPayment = null;
  const guideData = {};
  const Data = {};
  let payloadPayment = {};
  let payloadPrice = {};
  let lngPaymentYear = 0;
  let lngPaymentMonth = 0;
  let lngPaymentDay = 0;
  let lngDelFlg = 0;
  let lngBranchNo = 0;
  let lngCloseYear;
  let lngCloseMonth;
  let lngCloseDay;
  let lngBillSeq;
  let flgNoInput = 0;
  let strDuePrice;
  let strPaymentPrice;
  let strPaymentDate;
  let strPaymentDiv;
  // Request から請求書キー
  if (billno.length !== 14) {
    const strArrMessage = ['請求書番号が不正です'];
    yield put(getPaymentErrorMessage({ ...Message, strArrMessage }));
    return;
  } else if (billno.length !== 14) {
    const strArrMessage = ['請求書番号が不正です'];
    yield put(getPaymentErrorMessage({ ...Message, strArrMessage }));
    return;
  }
  lngCloseYear = Number(`0${billno.substr(0, 4)}`);
  lngCloseMonth = Number(`0${billno.substr(4, 2)}`);
  lngCloseDay = Number(`0${billno.substr(6, 2)}`);
  lngBillSeq = Number(`0${billno.substr(8, 5)}`);
  lngBranchNo = Number(`0${billno.substr(13, 1)}`);
  try {
    // 請求情報取得(外部結合で取得している)
    const payload = yield call(demandService.getDmdPaymentBillSum, billno);
    lngDelFlg = payload.delflg;
    const Date = Moment(payload.closedate).format('YYYYMMDD');
    lngCloseYear = Date.substr(0, 4);
    lngCloseMonth = Date.substr(4, 2);
    lngCloseDay = Date.substr(6, 2);
    lngBillSeq = payload.billseq;
    lngBranchNo = payload.branchno;
    yield put(loadDmdPaymentData({ ...Data, lngCloseYear, lngCloseMonth, lngCloseDay, lngBillSeq, lngBranchNo }));
    yield put(getDmdPaymentBillSumSuccess({ ...payload, lngDelFlg }));
    // ## 2004.06.01 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
    const item = [`${billno.substr(0, 13)}0`, `${billno.substr(0, 13)}1`];
    const data = [];
    for (let i = 0; i < 2; i += 1) {
      const params = item[i];
      try {
        const payload1 = yield call(demandService.getSumDetail, params);
        data.push(payload1[0]);
      } catch (error) {
        data.push({});
      }
    }
    yield put(getSumDetailItemsSuccess(data));
    // 入金Seq（新規の場合は0）
    if (seq !== null) {
      lngSeq = Number(`0${seq}`);
    } else {
      lngSeq = 0;
    }
    try {
      // 入金額は入力できないのでこちらで与える
      // すでに入金レコードがある場合はそのレコードの値、
      // そうでない場合は、未収額合計を設定
      payloadPrice = yield call(demandService.getDmdPaymentPrice, billno, seq);
      strDuePrice = payloadPrice.dueprice;
      strPaymentPrice = payloadPrice.paymentprice;
      if (lngSeq === 0) {
        // ## 2004.06.01 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
        if (Object.keys(data[0]).length > 0) {
          strDuePrice = payloadPrice.dueprice + data[0].sumpricetotal;
        }
        if (Object.keys(data[1]).length > 0) {
          strDuePrice = payloadPrice.dueprice + data[1].sumpricetotal;
        }
        strPaymentPrice = strDuePrice;
      }
      // 修正時は入金情報取得
      if (seq !== null) {
        payloadPayment = yield call(demandService.getPayment, billno, seq);
        if (payloadPayment.cash === null) {
          payloadPayment.cash = 0;
        }
        const PaymentDate = Moment(payloadPayment.paymentdate).format('YYYYMMDD');
        lngPaymentYear = PaymentDate.substr(0, 4);
        lngPaymentMonth = PaymentDate.substr(4, 2);
        lngPaymentDay = PaymentDate.substr(6, 2);
        strDispPayment = payloadPayment.paymentprice;
        strPaymentDate = payloadPayment.paymentdate;
        strPaymentPrice = payloadPayment.paymentprice;
        strPaymentDiv = payloadPayment.paymentdiv;
        Object.assign(payloadPayment, { strDispPayment }, { strPaymentPrice }, { strPaymentDate }, { strPaymentDiv });
      } else if (seq === null) {
        // 登録時
        if (strDuePrice === 0) {
          // '入金の必要がない場合は、表示しない
          strPaymentPrice = 0;
          const paymentprice = strPaymentPrice;
          strDispPayment = '';
          flgNoInput = 1;
          Object.assign(payloadPayment, { strDispPayment }, { paymentprice }, { strPaymentPrice });
        } else {
          strDispPayment = strPaymentPrice;
          const paymentprice = strPaymentPrice;
          // '2004.01.28 追加
          const paymentdiv = '3';
          strPaymentDiv = paymentdiv;
          flgNoInput = 0;
          const paymentdate = Moment().format('YYYY/MM/DD');
          Object.assign(payloadPayment, { paymentdiv }, { paymentprice }, { paymentdate }, { strDispPayment }, { strPaymentPrice }, { strPaymentDiv });
        }
      }
      if (!((lngBranchNo === 0 && lngDelFlg === 1) || flgNoInput === 1)) {
        // cookie値の取得
        const searchStr = 'billregino=';
        const strCookie = Cookie;
        if (strCookie.length > 0) {
          const startPos = strCookie.indexOf(searchStr) + searchStr.length;
          const regino = strCookie.substring(startPos, startPos + 1);
          if (regino !== '') {
            if (seq === null) {
              const registerno = regino;
              Object.assign(payloadPayment, { registerno });
            }
          }
        }
      }
      yield put(initialize(formname, payloadPayment));
      yield put(getDmdPaymentSuccess(payloadPayment));
      yield put(loadDmdPaymentGuideData({ ...guideData, flgNoInput, lngPaymentDay, lngPaymentMonth, lngPaymentYear }));
      yield put(getDmdPaymentPriceSuccess(payloadPrice));
    } catch (error) {
      if (!((lngBranchNo === 0 && lngDelFlg === 1) || flgNoInput === 1)) {
        // cookie値の取得
        const searchStr = 'billregino=';
        const strCookie = Cookie;
        if (strCookie.length > 0) {
          const startPos = strCookie.indexOf(searchStr) + searchStr.length;
          const regino = strCookie.substring(startPos, startPos + 1);
          if (regino !== '') {
            if (seq === null) {
              const registerno = regino;
              Object.assign(payloadPayment, { registerno });
            }
          }
        }
      }
      yield put(initialize(formname, payloadPayment));
      yield put(getDmdPaymentPriceFailure(error.response));
      yield put(getDmdPaymentFailure(error.response));
      yield put(loadDmdPaymentGuideData({ ...guideData, flgNoInput, lngPaymentDay, lngPaymentMonth, lngPaymentYear }));
      return;
    }
  } catch (error) {
    if (!((lngBranchNo === 0 && lngDelFlg === 1) || flgNoInput === 1)) {
      // cookie値の取得
      const searchStr = 'billregino=';
      const strCookie = Cookie;
      if (strCookie.length > 0) {
        const startPos = strCookie.indexOf(searchStr) + searchStr.length;
        const regino = strCookie.substring(startPos, startPos + 1);
        if (regino !== '') {
          if (seq === null) {
            const registerno = regino;
            Object.assign(payloadPayment, { registerno });
          }
        }
      }
    }
    yield put(initialize(formname, payloadPayment));
    yield put(getDmdPaymentSuccess(payloadPayment));
    yield put(loadDmdPaymentData({ ...Data, lngCloseYear, lngCloseMonth, lngCloseDay, lngBillSeq, lngBranchNo }));
    yield put(loadDmdPaymentGuideData({ ...guideData, flgNoInput, lngPaymentDay, lngPaymentMonth, lngPaymentYear }));
    yield put(getDmdPaymentBillSumFailure(error.response));
  }
}
function* runRegisterPayment(action) {
  let strSeq = '';
  let lngSeq = 0;
  let strCash;
  let strRegisterNo;
  const { params, checkPaymentData, data, conditions, formname } = action.payload;
  const PaymentDiv = params.paymentDiv;
  const lngBranchNo = params.branchNo;
  const lngDelFlg = params.lngdelflg;
  // 取消伝票は参照のみでデータ修正できません
  if (checkPaymentData.seq !== null) {
    strSeq = String(checkPaymentData.seq);
  }
  if (params.seq !== null) {
    lngSeq = Number(`0${params.seq}`);
  }
  const Message = '取消伝票の入金追加・変更・削除はできません。';
  if (lngBranchNo === 0 && lngDelFlg === 1) {
    yield put(getPaymentErrorMessage({ Message }));
    return;
  }
  // 'mode未確定は無視
  try {
    if (params.paymentDiv === 1) {
      if (params.cash === null) {
        strCash = 0;
      } else {
        strCash = params.cash;
      }
    } else {
      strCash = null;
    }
    if (params.paymentDiv === 3) {
      strRegisterNo = null;
    } else {
      strRegisterNo = data.registerno;
    }
    yield call(demandService.checkPaymentDivValue, { params });
    try {
      yield call(demandService.checkValuePayment, { ...checkPaymentData, seq: strSeq });
      if (params.seq !== null) {
        try {
          const payload1 = yield call(demandService.updatePayment, { billno: params.billno, seq: lngSeq, data: { ...data, registerno: strRegisterNo, cash: strCash } });
          yield put(updatePaymentSuccess(payload1));
          // DB更新成功の場合は前画面に戻る
          yield put(closeDmdPaymentGuide());
          yield put(getDmdBurdenListRequest(conditions));
        } catch (error) {
          yield put(updatePaymentFailure(error.response));
          return;
        }
      } else {
        try {
          const payload2 = yield call(demandService.insertPayment, { billno: params.billno, data: { ...data, registerno: strRegisterNo, cash: strCash } });
          yield put(registerPaymentSuccess(payload2));
          // 削除OK
          yield put(closeDmdPaymentGuide());
          yield put(getDmdBurdenListRequest(conditions));
        } catch (error) {
          yield put(registerPaymentFailure(error.response));
          return;
        }
      }
      // 成功Actionを発生させる
    } catch (error) {
      yield put(initialize(formname, { ...data, registerno: strRegisterNo, cash: strCash, strPaymentDiv: PaymentDiv }));
      yield put(getPaymentErrorMessage(error.response));
    }
  } catch (error) {
    yield put(initialize(formname, { ...data, registerno: strRegisterNo, cash: strCash, strPaymentDiv: PaymentDiv }));
    yield put(getPaymentErrorMessage(error.response));
  }
}
// 削除処理Action発生時に起動するメソッド
function* runDeletePayment(action) {
  const { billno, seq, conditions } = action.payload;
  try {
    // 削除処理実行
    yield call(demandService.delPayment, { billno, seq });
    // 削除成功Actionを発生させる
    yield put(deletePaymentSuccess());
    yield put(closeDmdPaymentGuide());
    yield put(getDmdBurdenListRequest(conditions));
  } catch (error) {
    // 削除失敗Actionを発生させる
    yield put(deletePaymentFailure(error.response));
  }
}
// 請求書削除
function* runRequestDeleteAllBill(action) {
  // eslint-disable-next-line no-alert,no-restricted-globals
  if (!confirm('指定された条件で請求書を削除します。よろしいですか？')) {
    return;
  }
  if (/^(\d{4})\/(\d{1,2})\/(\d{1,2})$/.test(action.payload.data.closeDate)) {
    try {
      // 締め処理実行
      const payload = yield call(demandService.deleteAllBill, action.payload);
      // 締め処理成功Actionを発生させる
      yield put(deleteAllBillSuccess(payload));
    } catch (error) {
      // 締め処理失敗Actionを発生させる
      yield put(deleteAllBillFailure(error.response));
    }
  } else {
    // 締め処理失敗Actionを発生させる
    yield put(deleteAllBillFailure({ errorMessage: ['締め日の入力形式が正しくありません。'] }));
  }
}

function* runOrgMasterBurden(action) {
  try {
    // 請求書基本情報登録処理実行
    const payload = yield call(demandService.insertBill, action.payload);
    // 請求書基本情報登録成功Actionを発生させる
    yield put(dmdOrgMasterBurdenSuccess(payload));
  } catch (error) {
    // 請求書基本情報登録失敗Actionを発生させる
    yield put(dmdOrgMasterBurdenFailure(error.response));
  }
}

// 請求書基本情報（２次内訳）
function* runOpenDmdDetailItmGuide(action) {
  let payload;
  let payloadDmdRecord;
  let payloadDmdDetailList;
  // 表示用に編集(請求金額)
  let dispBillTotal = 0;
  let dispTaxTotal = 0;
  let dispPriceTotal = 0;
  let billTotal = 0;
  const dispBillTotals = [];
  const dispPriceTotals = [];
  const { lngCount } = action.payload.params;
  try {
    // 請求書基本情報検索条件を満たすレコード件数を取得取得処理実行
    payload = yield call(demandService.getDmdBurdenBillDetail, action.payload);
    try {
      // 請求書基本情報（２次内訳）取得処理実行
      payloadDmdDetailList = yield call(demandService.getDmdDetailItmList, action.payload);
      try {
        // 請求書基本情報２次検査の合計金額取得処理実行
        payloadDmdRecord = yield call(demandService.getSumDetailItems, action.payload.params);
        if (lngCount[0].sum_pricetotal !== '') {
          billTotal = lngCount[0].sum_pricetotal;
          if (lngCount[0].sum_taxtotal !== '') {
            billTotal += lngCount[0].sum_taxtotal;
            dispTaxTotal = lngCount[0].sum_taxtotal;
          }
        }
        // ２次検査合計金額の追加
        if (payloadDmdRecord.record.length > 0) {
          billTotal += payloadDmdRecord.record[0].sumpricetotal;
          dispTaxTotal += payloadDmdRecord.record[0].sumtaxprice + payloadDmdRecord.record[0].sumedittax;
        }
        // 表示用に編集(小計/合計)
        for (let i = 0; i < payloadDmdDetailList.data.length; i += 1) {
          if (payloadDmdDetailList.data[i].price !== '') {
            if (payloadDmdDetailList.data[i].editprice !== '') {
              dispPriceTotal = payloadDmdDetailList.data[i].price + payloadDmdDetailList.data[i].editprice;
            } else {
              dispPriceTotal = payloadDmdDetailList.data[i].price;
            }
          } else {
            dispPriceTotal = 0;
          }
          if (payloadDmdDetailList.data[i].taxprice !== '') {
            if (payloadDmdDetailList.data[i].edittax !== '') {
              dispBillTotal = dispPriceTotal + payloadDmdDetailList.data[i].taxprice + payloadDmdDetailList.data[i].edittax;
            } else {
              dispBillTotal = dispPriceTotal + payloadDmdDetailList.data[i].taxprice;
            }
          } else {
            dispBillTotal = dispPriceTotal;
          }
          dispBillTotals[i] = dispBillTotal;
          dispPriceTotals[i] = dispPriceTotal;
        }
        yield put(getDmdRecordSuccess({ Total: { dispTaxTotal, billTotal, dispBillTotals, dispPriceTotals }, ...payloadDmdRecord }));
      } catch (error) {
        // 請求書基本情報２次検査の合計金額取得失敗Actionを発生させる
        yield put(getDmdRecordFailure({ Total: { dispTaxTotal: 0, billTotal: 0, dispBillTotals: 0, dispPriceTotals: 0 } }));
      }
      yield put(getDmdDetailListSuccess(payloadDmdDetailList));
    } catch (error) {
      // 請求書基本情報（２次内訳）取得失敗Actionを発生させる
      yield put(getDmdDetailListFailure(error.response));
    }
    yield put(getDmdDetailItm(payload));
  } catch (error) {
    // 請求書基本情報検索条件を満たすレコード件数を取得取得失敗Actionを発生させる
    yield put(getDmdListFailure(error.response));
  }
}

// 請求コメント取得Action発生時に起動するメソッド
function* runRequestDmdComment(action) {
  const billno = action.payload.params;
  try {
    // 請求コメント取得処理実行
    yield call(demandService.updateDmdBillComment, action.payload);
    // 請求書基本情報取得処理実行
    const payload = yield call(demandService.getDmdBurdenDispatch, { params: { billNo: billno } });
    yield put(closeDmdCommentGuide());
    // 請求コメント取得成功Actionを発生させる
    yield put(getDmdCommentSuccess(payload));
  } catch (error) {
    // 請求コメント取得失敗Actionを発生させる
    yield put(getDmdCommentFailure(error.response));
  }
}

// 請求書基本情報（２次内訳）取得Action発生時に起動するメソッド
function* runRequestDmdDetailList(action) {
  try {
    // 請求書基本情報（２次内訳）取得処理実行
    const payload = yield call(demandService.getDmdDetailItmList, action.payload);
    // 請求書基本情報（２次内訳）取得成功Actionを発生させる
    yield put(getDmdDetailListSuccess(payload));
  } catch (error) {
    // 請求書基本情報（２次内訳）取得失敗Actionを発生させる
    yield put(getDmdDetailListFailure(error.response));
  }
}

// 請求基本書情報削除Action発生時に起動するメソッド
function* runDeleteDmd(action) {
  try {
    // 請求基本書情報削除処理実行
    const payload = yield call(demandService.deleteBill, action.payload);
    // 請求基本書情報削除成功Actionを発生させる
    yield put(deleteDmdSuccess({ act: action.payload.act, message: payload }));
  } catch (error) {
    // 請求基本書情報削除失敗Actionを発生させる
    yield put(deleteDmdFailure(error.response));
  }
}
// 請求基本書情報検索条件を満たすレコード件数を取得取得Action発生時に起動するメソッド
function* runRequestDmdList(action) {
  let payloadDmdList;
  let dispBillTotal = 0;
  let payloadDmdRecord = null;
  let dispPriceTotal = 0;
  const sumRecord = [];
  let payload;
  let dispTaxTotal = 0;
  let billTotal = 0;
  let strWCslDate;
  let strWDayId;
  let strWRsvNo;
  let strWPerId;
  const conditions = { params: action.payload.params };
  try {
    try {
      // 請求書基本情報検索条件を満たすレコード件数を取得取得処理実行
      payloadDmdList = yield call(demandService.getDmdBurdenBillDetail, conditions);
    } catch (error) {
      // 請求書基本情報検索条件を満たすレコード件数を取得取得失敗Actionを発生させる
      yield put(getDmdListFailure(error.response));
      payloadDmdList = error.response.data;
    }
    try {
      // 請求書基本情報取得処理実行
      payload = yield call(demandService.getDmdBurdenDispatch, conditions);
    } catch (error) {
      // 請求書基本情報取得失敗Actionを発生させる
      yield put(getDmdBurdenFailure(error.response));
    }
    if (payload[0].sum_pricetotal !== '') {
      billTotal = payload[0].sum_pricetotal;
      if (payload[0].sum_taxtotal !== '') {
        billTotal += payload[0].sum_taxtotal;
        dispTaxTotal = payload[0].sum_taxtotal;
      }
    }

    try {
      // 請求書基本情報２次検査の合計金額取得処理実行
      payloadDmdRecord = yield call(demandService.getSumDetailItems, action.payload.params);
    } catch (error) {
      // 請求書基本情報２次検査の合計金額取得失敗Actionを発生させる
      yield put(getDmdRecordFailure({ Total: { dispTaxTotal: 0, billTotal: 0, dispBillTotals: 0, dispPriceTotals: 0 } }));
    }

    if (payloadDmdRecord != null) {
      const { record } = payloadDmdRecord;
      if (payloadDmdRecord && record.length > 0) {
        billTotal += record[0].sumpricetotal;
        dispTaxTotal += record[0].sumtaxprice + record[0].sumedittax;
      }
    }
    const { totalCount, data } = payloadDmdList;
    try {
      for (let i = 0; i < data.length; i += 1) {
        // ２次検査の合計金額追加追加取得処理実行
        const sum = yield call(demandService.getSumDetailItems, { billNo: data[i].billno, lineNo: data[i].lineno });
        sumRecord.push(sum.record[0]);
      }
    } catch (error) {
      // ２次検査の合計金額追加追加取得失敗Actionを発生させる
      yield put(getSumRecordFailure(error.response));
    }
    for (let i = 0; i < data.length; i += 1) {
      if (data[i].price !== '') {
        if (data[i].editprice !== '') {
          dispPriceTotal = data[i].price + data[i].editprice;
        } else {
          dispPriceTotal = data[i].price;
        }
      } else {
        dispPriceTotal = 0;
      }
      if (data[i].taxprice !== '') {
        if (data[i].edittax !== '') {
          dispBillTotal = dispPriceTotal + data[i].taxprice + data[i].edittax;
        } else {
          dispBillTotal = dispPriceTotal + data[i].taxprice;
        }
      } else {
        dispBillTotal = dispPriceTotal;
      }
      if (payloadDmdRecord != null) {
        const { record } = payloadDmdRecord;
        // ２次検査合計金額の追加
        if (record.length > 0 && i < sumRecord.length) {
          dispPriceTotal += sumRecord[i].sumprice + data[i].editprice;
          dispBillTotal += sumRecord[i].sumpricetotal;
        }
      }
      data[i].dispPriceTotal = dispPriceTotal;
      data[i].dispBillTotal = dispBillTotal;

      if (strWCslDate === data[i].csldate && strWDayId === data[i].dayid && strWRsvNo === data[i].rsvno && strWPerId === data[i].perid) {
        data[i].csldate = null;
        data[i].dayid = null;
        data[i].rsvno = null;
        data[i].perid = null;
        data[i].firstkname = null;
        data[i].firstname = null;
        data[i].lastkname = null;
        data[i].lastname = null;
      } else {
        strWCslDate = data[i].csldate;
        strWDayId = data[i].dayid;
        strWRsvNo = data[i].rsvno;
        strWPerId = data[i].perid;
      }
    }
    const dataPayload = { totalCount, data, billTotal, dispTaxTotal };
    // 請求書基本情報検索条件を満たすレコード件数を取得取得成功Actionを発生させる
    yield put(getDmdListSuccess(dataPayload));
  } catch (error) {
    // 請求書基本情報検索条件を満たすレコード件数を取得取得失敗Actionを発生させる
    yield put(getDmdListFailure(error.response));
  }
}

// 請求基本書基本情報Action発生時に起動するメソッド
function* runOpenDmdBurdenModifyGuide(action) {
  try {
    let payload;
    let payloadDmdList;
    let payloadDmdCount;
    let payloadDmdRecord = null;
    let dispBillTotal = 0;
    let dispPriceTotal = 0;
    let dispTaxTotal = 0;
    let billTotal = 0;
    let message = [];
    let strWCslDate;
    let strWDayId;
    let strWRsvNo;
    let strWPerId;
    const sumRecord = [];
    const { billNo, limit, page, lineNo, details } = action.payload;
    const conditions = { params: { billNo, limit, page, lineNo, details } };
    try {
      // 請求書基本情報取得処理実行
      payload = yield call(demandService.getDmdBurdenDispatch, conditions);
    } catch (error) {
      // 請求書基本情報取得失敗Actionを発生させる
      yield put(getDmdBurdenFailure(error.response));
    }
    const lngCount = payload;
    if (lngCount === 0) {
      message = ['該当する請求書がありません'];
    }
    if (lngCount[0].sum_pricetotal !== '') {
      billTotal = lngCount[0].sum_pricetotal;
      if (lngCount[0].sum_taxtotal !== '') {
        billTotal += lngCount[0].sum_taxtotal;
        dispTaxTotal = lngCount[0].sum_taxtotal;
      }
    }
    try {
      // 請求書基本情報検索条件を満たすレコード件数を取得取得処理実行
      payloadDmdList = yield call(demandService.getDmdBurdenBillDetail, conditions);
    } catch (error) {
      // 請求書基本情報検索条件を満たすレコード件数を取得取得失敗Actionを発生させる
      yield put(getDmdListFailure(error.response));
      payloadDmdList = error.response.data;
    }

    try {
      // 請求書基本情報２次検査の合計金額取得処理実行
      payloadDmdRecord = yield call(demandService.getSumDetailItems, action.payload);
    } catch (error) {
      // 請求書基本情報２次検査の合計金額取得失敗Actionを発生させる
      yield put(getDmdRecordFailure({ Total: { dispTaxTotal: 0, billTotal: 0, dispBillTotals: 0, dispPriceTotals: 0 } }));
    }

    if (payloadDmdRecord != null) {
      const { record } = payloadDmdRecord;
      if (payloadDmdRecord && record.length > 0) {
        billTotal += record[0].sumpricetotal;
        dispTaxTotal += record[0].sumtaxprice + record[0].sumedittax;
      }
    }


    try {
      // 請求書基本情報入金済み、発送済みチェック取得処理実行
      payloadDmdCount = yield call(demandService.getPaymentAndDispatchCnt, conditions);
    } catch (error) {
      // 請求書基本情報入金済み、発送済みチェック取得失敗Actionを発生させる
      yield put(getDmdCountFailure(error.response));
    }
    const { totalCount, data } = payloadDmdList;
    try {
      for (let i = 0; i < data.length; i += 1) {
        // ２次検査の合計金額追加追加取得処理実行
        const sum = yield call(demandService.getSumDetailItems, { billNo: data[i].billno, lineNo: data[i].lineno });
        sumRecord.push(sum.record[0]);
      }
    } catch (error) {
      // ２次検査の合計金額追加追加取得失敗Actionを発生させる
      yield put(getSumRecordFailure(error.response));
    }
    for (let i = 0; i < data.length; i += 1) {
      if (data[i].price !== '') {
        if (data[i].editprice !== '') {
          dispPriceTotal = data[i].price + data[i].editprice;
        } else {
          dispPriceTotal = data[i].price;
        }
      } else {
        dispPriceTotal = 0;
      }
      if (data[i].taxprice !== '') {
        if (data[i].edittax !== '') {
          dispBillTotal = dispPriceTotal + data[i].taxprice + data[i].edittax;
        } else {
          dispBillTotal = dispPriceTotal + data[i].taxprice;
        }
      } else {
        dispBillTotal = dispPriceTotal;
      }

      if (payloadDmdRecord != null) {
        const { record } = payloadDmdRecord;
        // ２次検査合計金額の追加
        if (record.length > 0 && i < sumRecord.length) {
          dispPriceTotal += sumRecord[i].sumprice + data[i].editprice;
          dispBillTotal += sumRecord[i].sumpricetotal;
        }
      }

      data[i].dispPriceTotal = dispPriceTotal;
      data[i].dispBillTotal = dispBillTotal;

      if (strWCslDate === data[i].csldate && strWDayId === data[i].dayid && strWRsvNo === data[i].rsvno && strWPerId === data[i].perid) {
        data[i].csldate = null;
        data[i].dayid = null;
        data[i].rsvno = null;
        data[i].perid = null;
        data[i].firstkname = null;
        data[i].firstname = null;
        data[i].lastkname = null;
        data[i].lastname = null;
      } else {
        strWCslDate = data[i].csldate;
        strWDayId = data[i].dayid;
        strWRsvNo = data[i].rsvno;
        strWPerId = data[i].perid;
      }
    }
    const dataPayload = { totalCount, data, payloadDmdCount, lngCount, message, billTotal, dispTaxTotal };
    // 請求基本書情報削除成功Actionを発生させる
    yield put(getOpenDmdBurdenModifyGuideSuccess(dataPayload));
  } catch (error) {
    // 請求基本書情報削除失敗Actionを発生させる
    yield put(getOpenDmdBurdenModifyGuideFailure(error.response));
  }
}
function* runRequestDemandList(action) {
  try {
    const { formName, params } = action.payload;
    // 請求書発送確認日設定取得処理実行
    const payload = yield call(demandService.checkValueSendCheckDay, params);

    // 請求書発送確認日設定をredux-formへセットするActionを発生させる
    yield put(initialize(formName, payload));

    // 請求書発送確認日設定取得成功Actionを発生させる
    yield put(checkValueSendCheckDaySuccess(payload));
  } catch (error) {
    // 請求書発送確認日設定取得失敗Actionを発生させる
    yield put(checkValueSendCheckDayFailure(error.response));
  }
}

function* runRequestGetDispatchSeq(action) {
  try {
    // const { formName, params } = action.payload;
    // 発送情報の取得取得処理実行
    const payload = yield call(demandService.getDispatchSeq, action.payload);

    // 発送情報の取得をredux-formへセットするActionを発生させる
    // yield put(initialize(formName, payload));

    // 発送情報の取得取得成功Actionを発生させる
    yield put(getDispatchSeqSuccess(payload));
  } catch (error) {
    // 発送情報の取得取得失敗Actionを発生させる
    yield put(getDispatchSeqFailure(error.response));
  }
}

function* runRequestDeleteDispatch(action) {
  try {
    // const { formName, params } = action.payload;
    // 削除処理取得処理実行
    const payload = yield call(demandService.deleteDispatch, action.payload);

    // 削除処理をredux-formへセットするActionを発生させる
    // yield put(initialize(formName, payload));

    // 削除処理取得成功Actionを発生させる
    yield put(deleteDispatchSuccess(payload));
  } catch (error) {
    // 削除処理取得失敗Actionを発生させる
    yield put(deleteDispatchFailure(error.response));
  }
}

function* runRequestUpdateDispatch(action) {
  try {
    // const { formName, params } = action.payload;
    // 更新処理取得処理実行
    const payload = yield call(demandService.updateDispatch, action.payload);

    // 更新処理をredux-formへセットするActionを発生させる
    // yield put(initialize(formName, payload));

    // 更新処理取得成功Actionを発生させる
    yield put(updateDispatchSuccess(payload));
  } catch (error) {
    // 更新処理取得失敗Actionを発生させる
    yield put(updateDispatchFailure(error.response));
  }
}

function* runRequestInsertDispatch(action) {
  try {
    // const { formName, params } = action.payload;
    // 更新処理取得処理実行
    const payload = yield call(demandService.updateDispatch, action.payload);

    // 更新処理をredux-formへセットするActionを発生させる
    // yield put(initialize(formName, payload));

    // 更新処理取得成功Actionを発生させる
    yield put(insertDispatchSuccess(payload));
  } catch (error) {
    // 更新処理取得失敗Actionを発生させる
    yield put(insertDispatchFailure(error.response));
  }
}

function* runRequestGetNowTax() {
  try {
    const date = Moment().format('YYYY-MM-DD');
    // 適用税率取得処理実行
    const payload = yield call(demandService.getNowTax, date);

    // 適用税率取得成功Actionを発生させる
    yield put(getNowTaxSuccess(payload));
  } catch (error) {
    // 更新処理取得失敗Actionを発生させる
    yield put(getNowTaxFailure(error.response));
  }
}

function* runRequestDmdEditDetailItemLine(action) {
  try {
    // 一覧取得処理実行
    const payload = yield call(demandService.getDmdBurdenModifyBillDetail, action.payload);
    // 一覧取得成功Actionを発生させる
    yield put(getDmdEditDetailItemLineSuccess(payload));
  } catch (error) {
    // 一覧取得失敗Actionを発生させる
    yield put(getDmdEditDetailItemLineFailure(error.response));
  }
}

// ２次内訳情報登録Action発生時に起動するメソッド
function* runRegisterDmdEditDetailItemLine(action) {
  try {
    yield call(demandService.registerDmdEditDetailItemLine, action.payload);
    // ２次内訳情報登録成功Actionを発生させる
    yield put(registerDmdEditDetailItemLineSuccess());
  } catch (error) {
    // ２次内訳情報登録失敗Actionを発生させる
    yield put(registerDmdEditDetailItemLineFailure(error.response));
  }
}

// ２次内訳情報削除Action発生時に起動するメソッド
function* runDeleteDmdEditDetailItemLine(action) {
  try {
    // ２次内訳情報削除処理実行
    yield call(demandService.deleteDmdEditDetailItemLine, action.payload);
    // ２次内訳情報削除成功Actionを発生させる
    yield put(deleteDmdEditDetailItemLineSuccess());
  } catch (error) {
    // ２次内訳情報削除失敗Actionを発生させる
    yield put(deleteDmdEditDetailItemLineFailure(error.response));
  }
}

function* runRequestOpenDmdEditBillLine(action) {
  try {
    const { BillNo, LineNo } = action.payload;
    const conditions = { params: { billNo: BillNo } };
    const sumConditions = { billNo: BillNo, lineNo: null };
    let payloadRecord = [];
    let strNoEditFlg = 0;
    let message = [];
    let lngSumPrice = 0;
    let lngSumEditPrice = 0;
    let lngSumTaxPrice = 0;
    let lngSumEditTax = 0;
    // 請求書明細取得処理実行
    const payload = yield call(demandService.getDmdBurdenModifyBillDetail, action.payload);
    if (LineNo != null) {
      try {
        // ２次検査合計金額の追加取得処理実行
        payloadRecord = yield call(demandService.getSumDetailItems, sumConditions);
        const { record } = payloadRecord;
        if (record.length > 0) {
          if (record[0].sumprice !== '' && record[0].sumprice != null) {
            lngSumPrice = record[0].sumprice;
          }
          if (record[0].sumeditprice !== '' && record[0].sumeditprice != null) {
            lngSumEditPrice = record[0].sumeditprice;
          }
          if (record[0].sumtaxprice !== '' && record[0].sumtaxprice != null) {
            lngSumTaxPrice = record[0].sumtaxprice;
          }
          if (record[0].sumedittax !== '' && record[0].sumedittax != null) {
            lngSumEditTax = record[0].sumedittax;
          }
        }
      } catch (error) {
        // ２次検査の合計金額追加追加取得失敗Actionを発生させる
        yield put(getSumRecordFailure(error.response));
      }
    }

    // 入金済み、発送済みチェック処理実行
    const payloadCount = yield call(demandService.getPaymentAndDispatchCnt, conditions);

    const { count } = payloadCount;
    const billDetail = payload;
    if (count[0].dispatch_cnt > 0 || count[0].payment_cnt > 0) {
      strNoEditFlg = 1;
      message = ['発送済みまたは入金済みのため、変更できません'];
    }
    if (billDetail[0].branchno === 1) {
      strNoEditFlg = 1;
      message = ['取消済みのため、変更できません'];
    }

    const sumPrice = { lngSumPrice, lngSumEditPrice, lngSumTaxPrice, lngSumEditTax };
    // 処理取得成功Actionを発生させる
    yield put(openDmdEditBillLineSuccess({ payload, payloadRecord, payloadCount, strNoEditFlg, message, sumPrice }));
  } catch (error) {
    // 処理取得失敗Actionを発生させる
    yield put(openDmdEditBillLineFailure(error.response));
  }
}

function* runRequestSaveBillDetail(action) {
  try {
    // 登録・修正処理実行
    const { params, strlineNo } = action.payload;

    if (params.CslDate == null || params.CslDate === '') {
      params.CslDate = Moment().format('YYYY/MM/DD');
    }

    if (params.Price == null || params.Price === '') {
      params.Price = 0;
    }

    if (params.EditPrice == null || params.EditPrice === '') {
      params.EditPrice = 0;
    }

    if (params.TaxPrice == null || params.TaxPrice === '') {
      params.TaxPrice = 0;
    }

    if (params.EditTax == null || params.EditTax === '') {
      params.EditTax = 0;
    }

    let payload;
    if (strlineNo == null || strlineNo === '') {
      payload = yield call(demandService.InsertBillDetail, params);
    } else {
      payload = yield call(demandService.UpdateBillDetail, params);
    }
    // 登録・修正成功Actionを発生させる
    yield put(saveBillDetailSuccess(payload));
  } catch (error) {
    // 登録・修正失敗Actionを発生させる
    yield put(saveBillDetailFailure(error.response));
  }
}

// 請求書明細削除Action発生時に起動するメソッド
function* runRequestDeleteBillLine(action) {
  try {
    // 請求書明細削除処理実行
    yield call(demandService.deleteBillDetail, action.payload);
    // 請求書明細削除成功Actionを発生させる
    yield put(deleteBillLineSuccess());
  } catch (error) {
    // 請求書明細削除失敗Actionを発生させる
    yield put(deleteBillLineFailure(error.response));
  }
}

const demandSagas = [
  takeEvery(getPaymentRequest.toString(), runRequestPayment),
  takeEvery(registerPerbillRequest.toString(), runRegisterPerbill),
  takeEvery(registerDelDspRequest.toString(), runRegisterDelDsp),
  takeEvery(openCreatePerBillGuideRequest.toString(), runOpenCreatePerBillGuide),
  takeEvery(getDmdBurdenListRequest.toString(), runRequestDmdBurdenList),
  takeEvery(openDmdPaymentGuide.toString(), runRequestOpenDmdPaymentGuide),
  takeEvery(registerPaymentRequest.toString(), runRegisterPayment),
  takeEvery(deletePaymentRequest.toString(), runDeletePayment),
  takeEvery(deleteAllBillRequest.toString(), runRequestDeleteAllBill),
  takeEvery(dmdOrgMasterBurdenRequest.toString(), runOrgMasterBurden),
  takeEvery(getDmdCommentRequest.toString(), runRequestDmdComment),
  takeEvery(getDmdDetailListRequest.toString(), runRequestDmdDetailList),
  takeEvery(deleteDmdRequest.toString(), runDeleteDmd),
  takeEvery(openDmdDetailItmListGuide.toString(), runOpenDmdDetailItmGuide),
  takeEvery(getDmdListRequest.toString(), runRequestDmdList),
  takeEvery(openDmdBurdenModifyGuide.toString(), runOpenDmdBurdenModifyGuide),
  takeEvery(checkValueSendCheckDayRequest.toString(), runRequestDemandList),
  takeEvery(getDispatchSeqRequest.toString(), runRequestGetDispatchSeq),
  takeEvery(deleteDispatchRequest.toString(), runRequestDeleteDispatch),
  takeEvery(updateDispatchRequest.toString(), runRequestUpdateDispatch),
  takeEvery(insertDispatchRequest.toString(), runRequestInsertDispatch),
  takeEvery(getNowTaxRequest.toString(), runRequestGetNowTax),
  takeEvery(getDmdEditDetailItemLineRequest.toString(), runRequestDmdEditDetailItemLine),
  takeEvery(registerDmdEditDetailItemLineRequest.toString(), runRegisterDmdEditDetailItemLine),
  takeEvery(deleteDmdEditDetailItemLineRequest.toString(), runDeleteDmdEditDetailItemLine),
  takeEvery(openDmdEditBillLineRequest.toString(), runRequestOpenDmdEditBillLine),
  takeEvery(saveBillDetailRequest.toString(), runRequestSaveBillDetail),
  takeEvery(deleteBillLineRequest.toString(), runRequestDeleteBillLine),
];

export default demandSagas;
