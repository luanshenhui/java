import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';

import moment from 'moment';

import perBillService from '../../services/bill/perBillService';
import personService from '../../services/preference/personService';

import consultService from '../../services/reserve/consultService';
import contractService from '../../services/preference/contractService';

import freeService from '../../services/preference/freeService';

import scheduleService from '../../services/preference/scheduleService';
import demandService from '../../services/bill/demandService';

import {
  openPerbillallincomeGuide,
  getRslConsultPerBillSuccess,
  getRslConsultPerBillFailure,
  getFriendsPerbillRequest,
  getFriendsPerbillSuccess,
  getFriendsPerbillFailure,
  getPerBillInfoRequest,
  getPerBillInfoSuccess,
  getPerBillInfoFailure,
  deletePerBillInfoRequest,
  deletePerBillInfoFailure,

  // 受診セット変更
  closePerbillOptionGuide,
  openPerbillOptionGuideRequest,
  openPerbillOptionGuideSuccess,
  openPerbillOptionGuideFailure,
  updateConsultOptionRequest,
  updateConsultOptionFailure,

  // 請求書統合処理
  openMergeGuideRequest,
  openMergeGuideSuccess,
  openMergeGuideFailure,
  getPersonLukesRequest,
  getPersonLukesSuccess,
  getPersonLukesFailure,
  registerMergePerbillRequest,
  registerMergePerbillSuccess,
  registerMergePerbillFailure,
  // 個人入金情報
  openPerBillIncomeGuide,
  getPerBillIncomeSuccess,
  getPerBillIncomeFailure,
  registerPerBillIncomeRequest,
  registerPerBillIncomeSuccess,
  registerPerBillIncomeFailure,
  deletePerPaymentRequest,
  deletePerPaymentSuccess,
  deletePerPaymentFailure,
  // 領収書・請求書印刷
  getPrtPerBillRequest,
  getPrtPerBillSuccess,
  getPrtPerBillFailure,
  updatePrtPerBillRequest,
  updatePrtPerBillSuccess,
  updatePrtPerBillFailure,
  // 請求明細登録修正
  openEditPerBillGuideRequest,
  openEditPerBillGuideSuccess,
  openEditPerBillGuideFailure,
  checkValueAndUpdatePerBillcRequest,
  checkValueAndUpdatePerBillcSuccess,
  checkValueAndUpdatePerBillcFailure,
  deletePerBillcRequest,
  deletePerBillcSuccess,
  deletePerBillcFailure,
  // 個人請求書の検索
  openGdePerBillGuideRequest,
  openGdePerBillGuideSuccess,
  openGdePerBillGuideFailure,
  getListPerBillRequest,
  getListPerBillSuccess,
  getListPerBillFailure,
  // --
  createPerBillPersonSuccess,
  createPerBillPersonFailure,
  updatePerBillPersonSuccess,
  updatePerBillPersonFailure,
  closePerBillGuide,
  getPerBillPersonRequest,
  getPerBillPersonSuccess,
  getPerBillPersonFailure,
  getPerBillPersonCRequest,
  getPerBillPersonCSuccess,
  getPerBillPersonCFailure,
  getPerBillNoRequest,
  getPerBillNoSuccess,
  getPerBillNoFailure,
  getPerBillCRequest,
  getPerBillCSuccess,
  getPerBillCFailure,
  getPerPaymentRequest,
  getPerPaymentSuccess,
  getPerPaymentFailure,
  deletePerBillRequest,
  deletePerBillSuccess,
  deletePerBillFailure,
  getPerBillListRequest,
  getPerBillListFailure,
  getPerBillListSuccess,
  updataPerBillCommentRequest,
  updataPerBillCommentSuccess,
  updataPerBillCommentFailure,
  createPerBillRequest,
} from '../../modules/bill/perBillModule';

import { getPaymentRequest } from '../../modules/bill/demandModule';

function* runRequestListPerBill(action) {
  const { index, requestNo, startDmdDate, endDmdDate } = action.payload.params;
  const disListPerBill = [];
  let newRequestNo;
  let t = 0;
  try {
    // 検索条件に従い個人請求書一覧を抽出する
    const listPerBill = yield call(perBillService.getListPerBill, action.payload);
    for (let i = 0; i < listPerBill.totalCount; i += 1) {
      newRequestNo = moment(listPerBill.data[i].dmddate).format('YYYYMMDD') + `0000${listPerBill.data[i].billseq}`.slice(-5) + listPerBill.data[i].branchno;
      if (requestNo !== newRequestNo) {
        disListPerBill.push({
          key: t,
          age: null,
          gender: null,
          perId: null,
          dmdDate: null,
          billSeq: null,
          branchNo: null,
          rsvNo: null,
          webColor: null,
          csName: null,
          lastName: null,
          firstName: null,
          lastKname: null,
          firstKName: null,
          orgSName: null,
          toTalPrice: null,
          paymentDate: null,
        });
        disListPerBill[t].age = listPerBill.data[i].age;
        disListPerBill[t].gender = listPerBill.data[i].gender;
        disListPerBill[t].perId = listPerBill.data[i].perid;
        disListPerBill[t].dmdDate = listPerBill.data[i].dmddate;
        disListPerBill[t].billSeq = listPerBill.data[i].billseq;
        disListPerBill[t].branchNo = listPerBill.data[i].branchno;
        disListPerBill[t].rsvNo = listPerBill.data[i].rsvno;
        disListPerBill[t].webColor = listPerBill.data[i].webcolor;
        disListPerBill[t].csName = listPerBill.data[i].csname;
        disListPerBill[t].lastName = listPerBill.data[i].lastname;
        disListPerBill[t].firstName = listPerBill.data[i].firstname;
        disListPerBill[t].lastKname = listPerBill.data[i].lastkname;
        disListPerBill[t].firstKName = listPerBill.data[i].firstkname;
        disListPerBill[t].orgSName = listPerBill.data[i].orgsname;
        disListPerBill[t].toTalPrice = listPerBill.data[i].totalprice;
        disListPerBill[t].paymentDate = listPerBill.data[i].paymentdate;
        t += 1;
      }
    }

    // 検索条件に従い個人請求書一覧を抽出成功
    yield put(getListPerBillSuccess({ disListPerBill, startDmdDate, endDmdDate, index }));
  } catch (error) {
    // 検索条件に従い個人請求書一覧を抽出失敗Actionを発生させる
    yield put(getListPerBillFailure({ startDmdDate, endDmdDate }));
  }
}

function* runRequestOpenGdePerBillGuide(action) {
  const formName = 'GdePerBillListHeader';
  const { index, startDmdDate, endDmdDate, key, billSeq, branchNo } = action.payload.params;
  const values = { startDmdDate, endDmdDate, key };
  const disListPerBill = [];
  const requestNo = moment(startDmdDate).format('YYYYMMDD') + `0000${billSeq}`.slice(-5) + branchNo;
  let newRequestNo;
  let t = 0;
  try {
    // 検索条件に従い個人請求書一覧を抽出する
    const listPerBill = yield call(perBillService.getListPerBill, action.payload);
    for (let i = 0; i < listPerBill.totalCount; i += 1) {
      newRequestNo = moment(listPerBill.data[i].dmddate).format('YYYYMMDD') + `0000${listPerBill.data[i].billseq}`.slice(-5) + listPerBill.data[i].branchno;
      if (requestNo !== newRequestNo) {
        disListPerBill.push({
          key: t,
          age: null,
          gender: null,
          perId: null,
          dmdDate: null,
          billSeq: null,
          branchNo: null,
          rsvNo: null,
          webColor: null,
          csName: null,
          lastName: null,
          firstName: null,
          lastKname: null,
          firstKName: null,
          orgSName: null,
          toTalPrice: null,
          paymentDate: null,
        });
        disListPerBill[t].age = listPerBill.data[i].age;
        disListPerBill[t].gender = listPerBill.data[i].gender;
        disListPerBill[t].perId = listPerBill.data[i].perid;
        disListPerBill[t].dmdDate = listPerBill.data[i].dmddate;
        disListPerBill[t].billSeq = listPerBill.data[i].billseq;
        disListPerBill[t].branchNo = listPerBill.data[i].branchno;
        disListPerBill[t].rsvNo = listPerBill.data[i].rsvno;
        disListPerBill[t].webColor = listPerBill.data[i].webcolor;
        disListPerBill[t].csName = listPerBill.data[i].csname;
        disListPerBill[t].lastName = listPerBill.data[i].lastname;
        disListPerBill[t].firstName = listPerBill.data[i].firstname;
        disListPerBill[t].lastKname = listPerBill.data[i].lastkname;
        disListPerBill[t].firstKName = listPerBill.data[i].firstkname;
        disListPerBill[t].orgSName = listPerBill.data[i].orgsname;
        disListPerBill[t].toTalPrice = listPerBill.data[i].totalprice;
        disListPerBill[t].paymentDate = listPerBill.data[i].paymentdate;
        t += 1;
      }
    }

    yield put(openGdePerBillGuideSuccess({ disListPerBill, requestNo, startDmdDate, index }));
    yield put(initialize(formName, values));
  } catch (error) {
    // 検索条件に従い個人請求書一覧を抽出失敗Actionを発生させる
    yield put(openGdePerBillGuideFailure());
  }
}

function* runDeletePerBillc(action) {
  const params = action.payload.params.rsvno;
  try {
    // セット外請求明細の削除を行う
    yield call(perBillService.deletePerBillc, action.payload);
    yield put(getPaymentRequest({ params }));
    // セット外請求明細の削除を成功
    yield put(deletePerBillcSuccess());
  } catch (error) {
    // 請求書情報を削除失敗Actionを発生させる
    yield put(deletePerBillcFailure(error.response));
  }
}

function* runCheckValueAndUpdatePerBillc(action) {
  try {
    const { dmddate, billseq, branchno, billlineno } = action.payload.params;
    const { price, editprice, taxprice, edittax, rsvno, dspdivname, dsplinename, priceseq, omittaxflg, divcd } = action.payload.params;
    const params = rsvno;
    let linename = dsplinename;
    let omitTaxFlg = 1;
    if (omittaxflg === null || omittaxflg === undefined) {
      omitTaxFlg = 0;
    }
    if (dspdivname === dsplinename) {
      linename = '';
    }
    // 入力チェックとr受診確定金額情報、個人請求明細情報の登録
    yield call(perBillService.checkValueAndUpdatePerBillc, {
      dmddate,
      billseq,
      branchno,
      billlineno,
      price: price === '' ? 0 : price,
      editprice: editprice === '' ? 0 : editprice,
      taxprice: taxprice === '' ? 0 : taxprice,
      edittax: edittax === '' ? 0 : edittax,
      linename,
      linenamedmd: dsplinename,
      rsvno,
      priceseq,
      omittaxflg: omitTaxFlg,
      otherlinedivcd: divcd,
    });
    // 情報取得成功Actionを発生させる
    yield put(checkValueAndUpdatePerBillcSuccess());
    yield put(getPaymentRequest({ params }));
  } catch (error) {
    // 入力チェックと受診確定金額情報、個人請求明細情報の登録失敗Actionを発生させる
    yield put(checkValueAndUpdatePerBillcFailure(error.response));
  }
}

function* runOpenEditPerBillGuide(action) {
  const params = action.payload.rsvno;
  const { price, editprice, taxprice, edittax, line, flg } = action.payload;
  let formName = '';
  let divname = '';

  if (flg === 1) {
    formName = 'editPerBill1Form';
  } else {
    formName = 'editPerBill2Form';
  }

  try {
    // 締め管理情報取得する
    const paymentConsultTotal = yield call(demandService.getPaymentConsultTotal, { params });

    if (flg === 2) {
      // セット外請求明細を取得する
      const otherLineDiv = yield call(perBillService.getOtherLineDiv);

      for (let i = 0; i < otherLineDiv.length; i += 1) {
        if (otherLineDiv[i].otherlinedivcd === paymentConsultTotal[line].otherlinedivcd) {
          divname = otherLineDiv[i].otherlinedivname;
        }
      }
    }

    const initialValues = {
      // divcd: divcd == null ? '' : divcd,
      dspdivname: divname == null ? '' : divname,
      dsplinename: paymentConsultTotal[line].linename == null ? '' : paymentConsultTotal[line].linename,
      price: price == null ? '0' : price,
      editprice: editprice == null ? '0' : editprice,
      taxprice: taxprice == null ? '0' : taxprice,
      edittax: edittax == null ? '0' : edittax,
      omittaxflg: paymentConsultTotal[line].omittaxflg !== 0 ? 1 : paymentConsultTotal[line].omittaxflg,
    };
    yield put(initialize(formName, initialValues));

    // 情報取得成功Actionを発生させる
    yield put(openEditPerBillGuideSuccess({ paymentConsultTotal, line, flg, params }));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(openEditPerBillGuideFailure());
  }
}

function* runRegisterMergePerbill(action) {
  const { retPerBillList } = action.payload;
  let data = null;
  let params = null;
  let message = [];
  if (retPerBillList.length === 1) {
    yield put(registerMergePerbillSuccess());
  }
  for (let i = 1; i < retPerBillList.length; i += 1) {
    data = {
      dmddate: retPerBillList[0].dmdDate,
      billseq: retPerBillList[0].billSeq,
      branchno: retPerBillList[0].branchNo,
      olddmddate: retPerBillList[i].dmdDate,
      oldbillseq: retPerBillList[i].billSeq,
      oldbranchno: retPerBillList[i].branchNo,
    };
    params = { dmddate: retPerBillList[i].dmdDate, billseq: retPerBillList[i].billSeq, branchno: retPerBillList[i].branchNo };
    try {
      // 請求書統合処理を行う
      yield call(perBillService.registerMergePerbill, data);
    } catch (error) {
      message = ['請求書統合に失敗しました。１'];
      yield put(registerMergePerbillFailure({ message }));
      return;
    }
    try {
      // 請求書情報を削除処理実行
      yield call(perBillService.deletePerBill, { params });
    } catch (error) {
      message = ['元の請求書の取消に失敗しました。'];
      yield put(registerMergePerbillFailure({ message }));
      return;
    }
  }
  yield put(registerMergePerbillSuccess());
}

function* runRequestPersonLukes(action) {
  const { disPerBillList, dispCnt } = action.payload;
  let params = null;
  let personLukes = null;
  let perBillBillNo = null;
  let t = 0;
  const retPerBillList = [];
  try {
    for (let i = 0; i < dispCnt; i += 1) {
      if (disPerBillList[i].perid != null) {
        retPerBillList.push({
          key: t,
          perId: null,
          lastKName: null,
          firstKName: null,
          lastName: null,
          firstName: null,
          price: null,
          editPrice: null,
          taxPrice: null,
          editTax: null,
          priceTotal: null,
          dmdDate: null,
          billSeq: null,
          branchNo: null,
        });
        params = { perid: disPerBillList[i].perid, dmddate: disPerBillList[i].dmddate, billseq: disPerBillList[i].billseq, branchno: disPerBillList[i].branchno };
        // 個人ＩＤより氏名を取得する
        personLukes = yield call(personService.getPersonLukes, { params });
        // 個人請求管理情報の取得
        perBillBillNo = yield call(perBillService.getPerBillBillNo, { params });
        retPerBillList[t].perId = personLukes.perid;
        retPerBillList[t].lastKName = personLukes.lastkname;
        retPerBillList[t].firstKName = personLukes.firstkname;
        retPerBillList[t].lastName = personLukes.lastname;
        retPerBillList[t].firstName = personLukes.firstname;
        retPerBillList[t].price = perBillBillNo[0].price_all;
        retPerBillList[t].editPrice = perBillBillNo[0].editprice_all;
        retPerBillList[t].taxPrice = perBillBillNo[0].taxprice_all;
        retPerBillList[t].editTax = perBillBillNo[0].edittax_all;
        retPerBillList[t].priceTotal = perBillBillNo[0].price_all + perBillBillNo[0].editprice_all + perBillBillNo[0].taxprice_all + perBillBillNo[0].edittax_all;
        retPerBillList[t].dmdDate = disPerBillList[i].dmddate;
        retPerBillList[t].billSeq = disPerBillList[i].billseq;
        retPerBillList[t].branchNo = disPerBillList[i].branchno;
        t += 1;
      }
    }
    // 情報取得成功Actionを発生させる
    yield put(getPersonLukesSuccess({ params, retPerBillList }));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPersonLukesFailure({ ...error.response, params }));
  }
}

function* runOpenMergeGuide(action) {
  const { params } = action.payload;
  let perBillCsl = null;
  let perBillBillNo = null;
  try {
    // 請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
    perBillCsl = yield call(perBillService.getPerBillCsl, action.payload);
    // 個人請求管理情報の取得
    perBillBillNo = yield call(perBillService.getPerBillBillNo, action.payload);
    // 情報取得成功Actionを発生させる
    yield put(openMergeGuideSuccess({ params, perBillCsl, perBillBillNo }));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(openMergeGuideFailure({ ...error.response, params }));
  }
}

// 受診情報と個人請求書管理情報を取得するAction発生時に起動するメソッド
function* runRequestRslConsultPerBill(action) {
  const { rsvno } = action.payload;
  let rslConsult = null;
  let perBill = null;
  try {
    // 受診情報取得処理実行
    rslConsult = yield call(consultService.getRslConsult, action.payload);

    // 個人請求書管理情報取得処理実行
    perBill = yield call(perBillService.getPerBill, action.payload);

    // 受診情報と個人請求書管理情報取得成功Actionを発生させる
    yield put(getRslConsultPerBillSuccess({ rslConsult, perBill }));
  } catch (error) {
    // 受診情報と個人請求書管理情報取得失敗Actionを発生させる
    yield put(getRslConsultPerBillFailure({ ...error.response, rslConsult, perBill, rsvno }));
  }
}

// 同伴者請求書を取得するAction発生時に起動するメソッド
function* runRequestFriendsPerBill(action) {
  const { formName } = action.payload;
  try {
    // 同伴者請求書取得処理実行
    const friendsPerBill = yield call(perBillService.getFriendsPerBill, action.payload);

    // 同伴者請求書取得成功Actionを発生させる
    yield put(getFriendsPerbillSuccess({ friendsPerBill, formName }));
  } catch (error) {
    // 同伴者請求書取得失敗Actionを発生させる
    yield put(getFriendsPerbillFailure(error.response));
  }
}

// 請求書情報を取得する
function* runRequestPerBillInfo(action) {
  let perBillCsl = null;
  let perBillC = null;
  let perBillBillNo = null;
  let perPayment = null;
  const { params } = action.payload;
  try {
    // 請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
    perBillCsl = yield call(perBillService.getPerBillCsl, action.payload);
    // 個人請求明細情報の取得
    perBillC = yield call(perBillService.getPerBillC, action.payload);
    // 個人請求管理情報の取得
    perBillBillNo = yield call(perBillService.getPerBillBillNo, action.payload);
    // 入金情報の取得
    if (perBillBillNo[0].paymentdate != null) {
      perPayment = yield call(perBillService.getPerPayment, { params: { ...params, paymentdate: perBillBillNo[0].paymentdate, paymentseq: perBillBillNo[0].paymentseq } });
    }

    // 請求書情報取得成功Actionを発生させる
    yield put(getPerBillInfoSuccess({ perBillCsl, perBillC, perBillBillNo, perPayment }));
  } catch (error) {
    // 請求書情報取得失敗Actionを発生させる
    yield put(getPerBillInfoFailure({ ...error.response, params, perBillCsl, perBillC, perBillBillNo, perPayment }));
  }
}

// 請求書情報を削除するAction発生時に起動するメソッド
function* runRequestDelPerBillInfo(action) {
  const { redirect } = action.payload;
  try {
    // 請求書情報を削除処理実行
    yield call(perBillService.deletePerBill, action.payload);

    // 請求書情報を削除成功時次のURLへ遷移
    redirect();
  } catch (error) {
    // 請求書情報を削除失敗Actionを発生させる
    yield put(deletePerBillInfoFailure(error.response));
  }
}
// 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得する
function* runRequestopenPerbillOptionGuide(action) {
  try {
    // 受診情報読み込み
    const consult = yield call(consultService.getConsult, action.payload);
    const { rsvno } = action.payload;

    // 指定契約パターンの全オプション検査を取得
    const { csldate, csldivcd, ctrptcd, perid } = consult;
    const consultoptionall = yield call(contractService.getCtrPtOptFromConsult, { csldate, csldivcd, ctrptcd, perid, exceptnomatch: true, includetax: false });

    yield put(openPerbillOptionGuideSuccess({ consultoptionall, rsvno, ctrptcd }));
  } catch (error) {
    // 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得失敗Actionを発生させる
    yield put(openPerbillOptionGuideFailure(error.response));
  }

  try {
    // 現在の受診オプション検査読み込み
    const consultoptions = yield call(consultService.getConsultO, action.payload);

    const checkItems = {};
    for (let i = 0; i < consultoptions.length; i += 1) {
      const { optcd, optbranchno } = consultoptions[i];
      checkItems[`opt_${optcd}`] = optbranchno;
    }
    yield put(initialize('perBillOptionGuide', checkItems));
  } catch (error) {
    // 現在の受診オプション検査読み込み失敗Actionを発生させる
    yield put(initialize('perBillOptionGuide', {}));
  }
}

// 受診オプション管理レコードを更新する
function* runRequestupdateConsultOption(action) {
  try {
    const { rsvno, ctrptcd } = action.payload;
    const { values, consultoptionall } = action.payload;
    const params = rsvno;

    const optcd = [];
    const optbranchno = [];
    const consults = [];

    for (let i = 0, len = consultoptionall.length; i < len; i += 1) {
      optcd[i] = consultoptionall[i].optcd;
      optbranchno[i] = consultoptionall[i].optbranchno;

      // チェック状態により受診要否を設定
      if (values[`opt_${optcd[i]}`] === optbranchno[i]) {
        consults[i] = 1;
      } else {
        consults[i] = 0;
      }
    }

    // 受診オプション管理レコードの更新
    yield call(consultService.updateConsultO, { rsvno, ctrptcd, optcd, optbranchno, consults });

    // エラーがなければ呼び元画面をリロードして自身を閉じる
    yield put(closePerbillOptionGuide());

    // perPaymentInfoのActionを指定
    yield put(getPaymentRequest({ params }));
  } catch (error) {
    // 受診オプション管理レコードを更新失敗Actionを発生させる
    yield put(updateConsultOptionFailure(error.response));
  }
}

// 個人入金情報
function* runRequestPerBillIncome(action) {
  // 引数を取得
  const { rsvno, perid, dmddate, billseq, branchno, reqdmddate, reqbillseq, reqbranchno } = action.payload;

  const formName = 'perBillIncomeGuide';

  const values = { rsvno, perid, dmddate, billseq, branchno };

  // レジ番号
  values.registerno = 1;

  // 入金日 未入金の場合、システム年月日を適用する
  const paymentDate = moment().format('YYYY-MM-DD');
  values.paymentDate = paymentDate;

  values.strMode = '';

  values.keyDate = null;

  values.keySeq = '';

  // 領収書印刷日
  values.printDate = null;

  // 書き込みＯＫフラグ
  values.wrtOkFlg = '';

  values.credit = '';
  values.happyTicket = '';
  values.card = '';
  values.jdebit = '';
  values.cheque = '';
  values.transfer = '';
  values.cardkind = '';
  values.creditslipno = '';
  values.bankcode = '';

  // 来院情報
  let welComeInfo = null;

  // 個人情報
  let personLukes = null;

  // 個人請求書管理情報
  let perBill = null;

  // 対象請求書番号
  const billNo = [];

  // 請求日 配列
  let dmdDateArray = [];

  // 請求書Ｓｅｑ 配列
  let billSeqArray = [];

  // 請求書枝番 配列
  let branchNoArray = [];

  // おつり
  let changePrice = 0;

  try {
    // 締め日の取得
    const free = yield call(freeService.getFree, { freecd: 'DAILYCLS', mode: 0 });
    const closeDate = moment(free[0].freedate).format('YYYY-MM-DD');
    values.closeDate = closeDate;

    // 計上日の取得
    values.calcDate = yield call(scheduleService.GetCalcDate, { params: { paymentDate, closeDate } });

    // 予約番号がある場合
    if (rsvno !== undefined && rsvno != null && rsvno !== 0) {
      welComeInfo = yield call(consultService.getWelComeInfo, action.payload);

      // 受診日
      values.csldate = moment(welComeInfo.csldate).format('YYYY/MM/DD');
      // 個人ＩＤ
      values.perid = welComeInfo.perid;
      // 受診コース
      values.csname = welComeInfo.csname;
      // 姓
      values.lastname = welComeInfo.lastname;
      // 名
      values.firstname = welComeInfo.firstname;
      // カナ姓
      values.lastkname = welComeInfo.lastkname;
      // カナ名
      values.firstkname = welComeInfo.firstkname;
      // 生年月日
      values.birth = moment(welComeInfo.birth).format('YYYY年M月DD日生');
      // 年齢
      values.age = welComeInfo.age;
      // 性別
      values.gender = Number(welComeInfo.gender);
      // 当日ＩＤ（受付済みチェック用）
      values.dayid = welComeInfo.dayid;
      // 当日ＩＤ（受付済みチェック用）
      values.comedate = welComeInfo.comedate;

      // 受付済み ＆ 来院済み
      if (welComeInfo.dayid !== '' && welComeInfo.comedate !== '') {
        values.wrtOkFlg = '1';
      }
    }

    // 個人ＩＤがある場合
    if (!(perid === undefined || perid === '' || perid == null)) {
      // 個人ＩＤ情報を取得する
      personLukes = yield call(personService.getPerson, { params: { perid } });

      // 姓
      values.lastname = personLukes.lastname;
      // 名
      values.firstname = personLukes.firstname;
      // カナ姓
      values.lastkname = personLukes.lastkname;
      // カナ名
      values.firstkname = personLukes.firstkname;
      // 性別
      values.gender = personLukes.gender;
      // 生年月日
      const { birth } = personLukes;
      values.birth = birth;

      // 年齢の計算
      const calcAge = yield call(freeService.calcAge, { birth });
      values.birth = birth;
      values.age = calcAge.realAge;

      // 無条件に受付済状態
      values.wrtOkFlg = '1';
    }

    // 請求日 フォーマット
    let dmddateFormat;
    // 請求書Ｓｅｑ フォーマット
    let billseqFormat;

    if (dmddate == null || dmddate === '') {
      // 表示モード(1:まとめて入金、0:それ以外）
      values.dispMode = '1';
      dmdDateArray = reqdmddate.toString().split(',');
      billSeqArray = reqbillseq.toString().split(',');
      branchNoArray = reqbranchno.toString().split(',');

      // 請求金額
      values.priceTotal = 0;

      for (let i = 0; i < dmdDateArray.length; i += 1) {
        if (dmdDateArray[i] !== null && dmdDateArray[i] !== '') {
          // 請求書Ｎｏから個人請求書管理情報を取得する
          perBill = yield call(perBillService.getPerBillBillNo, { params: { dmddate: dmdDateArray[i], billseq: billSeqArray[i], branchno: branchNoArray[i] } });

          // 請求金額合計
          values.priceTotal += perBill[0].price_all + perBill[0].editprice_all + perBill[0].taxprice_all + perBill[0].edittax_all;

          values.delflg = perBill[0].delflg;

          const name = yield call(perBillService.getName, { params: { dmddate: dmdDateArray[i], billseq: billSeqArray[i], branchno: branchNoArray[i] } });

          if (name !== null) {
            dmddateFormat = moment(dmdDateArray[i]).format('YYYYMMDD');
            billseqFormat = `0000${billSeqArray[i]}`.slice(-5);
            billNo.push(`${dmddateFormat}${billseqFormat}${branchNoArray[i]}（ ${name[i].lastname} ${name[i].firstname == null ? '' : name[i].firstname}）`);
          }
        }
      }

      if (values.strMode === '') {
        values.strMode = 'insert';
        const index = 0;
        values.dmddate = dmdDateArray[index];
        values.billseq = billSeqArray[index];
        values.branchno = branchNoArray[index];

        values.maxDmdDate = dmdDateArray[index];
      } else {
        values.strMode = 'update';

        values.paymentDate = paymentDate;

        for (let i = 0; i < dmdDateArray.length; i += 1) {
          if (values.maxDmdDate < dmdDateArray[i]) {
            values.maxDmdDate = dmdDateArray[i];
          }
        }
      }
    } else {
      // 表示モード(1:まとめて入金、0:それ以外）
      values.dispMode = '0';

      // 請求書Ｎｏから個人請求書管理情報を取得する
      perBill = yield call(perBillService.getPerBillBillNo, { params: { dmddate, billseq, branchno } });

      // 請求金額合計
      values.priceTotal = perBill[0].price_all + perBill[0].editprice_all + perBill[0].taxprice_all + perBill[0].edittax_all;

      values.delflg = perBill[0].delflg;

      values.printDate = perBill[0].printdate;

      values.paymentseq = 1;
      values.keySeq = 1;

      if (perBill !== null && perBill[0].paymentdate == null) {
        values.strMode = 'insert';

        dmdDateArray[dmdDateArray.length] = dmddate;
        billSeqArray[billSeqArray.length] = billseq;
        branchNoArray[branchNoArray.length] = branchno;
        // 一番新しい請求日
        values.maxDmdDate = dmddate;

        // 対象請求書番号
        dmddateFormat = moment(dmddate).format('YYYYMMDD');
        billseqFormat = `0000${billseq}`.slice(-5);
        billNo.push(`${dmddateFormat}${billseqFormat}${branchno}（ ${values.lastname} ${values.firstname == null ? '' : values.firstname}）`);
      } else {
        values.strMode = 'update';

        // 入金日
        values.paymentDate = perBill[0].paymentdate;

        values.paymentseq = perBill[0].paymentseq;

        // 元の入金日
        values.keyDate = perBill[0].paymentdate;
        // 元の入金Ｓｅｑ
        values.keySeq = perBill[0].paymentseq;

        const billNoPayment = yield call(perBillService.getBillNoPayment, { params: { paymentdate: values.keyDate, paymentseq: values.keySeq } });

        values.maxDmdDate = billNoPayment[0].dmddate;
        for (let i = 0; i < billNoPayment.length; i += 1) {
          dmdDateArray[dmdDateArray.length] = billNoPayment[i].dmddate;
          billSeqArray[billSeqArray.length] = billNoPayment[i].billseq;
          branchNoArray[branchNoArray.length] = billNoPayment[i].branchno;

          dmddateFormat = moment(billNoPayment[i].dmddate).format('YYYYMMDD');
          billseqFormat = `0000${billNoPayment[i].billseq}`.slice(-5);
          billNo.push(`${dmddateFormat}${billseqFormat}${billNoPayment[i].branchno}（ ${billNoPayment[i].lastname} ${billNoPayment[i].firstname == null ? '' : billNoPayment[i].firstname}）`);

          if (values.maxDmdDate < billNoPayment[i].dmddate) {
            values.maxDmdDate = billNoPayment[i].dmddate;
          }
        }
      }
    }

    if (values.strMode === 'insert') {
      changePrice = -1;
    }

    if (values.strMode === 'update' && billNo.length > 0) {
      const perPayment = yield call(perBillService.getPerPayment, { params: { paymentdate: perBill[0].paymentdate, paymentseq: perBill[0].paymentseq } });

      values.credit = perPayment[0].credit > 0 ? perPayment[0].credit : '';
      values.checkCredit = values.credit !== '' ? 1 : 0;

      values.happyTicket = perPayment[0].happy_ticket > 0 ? perPayment[0].happy_ticket : '';
      values.checkHappy = values.happyTicket !== '' ? 2 : 0;

      values.card = perPayment[0].card > 0 ? perPayment[0].card : '';
      values.checkCard = values.card !== '' ? 3 : 0;

      values.jdebit = perPayment[0].jdebit > 0 ? perPayment[0].jdebit : '';
      values.checkJdebit = values.jdebit !== '' ? 4 : 0;

      values.cheque = perPayment[0].cheque > 0 ? perPayment[0].cheque : '';
      values.checkCheque = values.cheque !== '' ? 5 : 0;

      values.transfer = perPayment[0].transfer > 0 ? perPayment[0].transfer : '';
      values.checkTransfer = values.transfer !== '' ? 6 : 0;

      // おつり
      changePrice = Number(perPayment[0].credit) + Number(values.happyTicket) + Number(perPayment[0].card) + Number(perPayment[0].jdebit)
        + Number(perPayment[0].cheque) + Number(perPayment[0].transfer) - Number(perPayment[0].pricetotal);

      // 計上日の取得
      values.calcDate = perPayment[0].calcdate;

      // レジ番号
      values.registerno = perPayment[0].registerno;
      // 請求金額合計
      values.priceTotal = perPayment[0].pricetotal;
      // カード種別
      values.cardkind = perPayment[0].cardkind == null ? '' : perPayment[0].cardkind;
      // 伝票No
      values.creditslipno = perPayment[0].creditslipno > 0 ? perPayment[0].creditslipno : '';
      // 金融機関コード
      values.bankcode = perPayment[0].bankcode == null ? '' : perPayment[0].bankcode;
      // 更新日付
      values.updDate = perPayment[0].upddate;
      // 更新者
      values.updUser = perPayment[0].upduser;
      // ユーザ名
      values.userName = perPayment[0].username;
    }

    values.dmdDateArray = dmdDateArray;
    values.billSeqArray = billSeqArray;
    values.branchNoArray = branchNoArray;

    values.calcDate = moment(values.calcDate).format('YYYY-MM-DD');

    // カード情報の読み込み
    const cardKindList = yield call(freeService.getFreeDate, { mode: 3, freeCd: 'CARD', freeDate: values.csldate == null ? values.dmddate : values.csldate });

    const cardKindItems = [{ value: '', name: '' }];
    for (let i = 0; i < cardKindList.length; i += 1) {
      cardKindItems.push({ value: cardKindList[i].freecd, name: cardKindList[i].freefield1 });
    }

    // 銀行情報の読み込み
    const bankList = yield call(freeService.getFree, { mode: 3, freeCd: 'BANK' });

    const bankItems = [{ value: '', name: '' }];
    for (let i = 0; i < bankList.length; i += 1) {
      bankItems.push({ value: bankList[i].freecd, name: bankList[i].freefield1 });
    }

    let changepriceLabel = '';
    // 未受付の場合
    if (changePrice < 0 && values.wrtOkFlg === '' && values.dayid === '') {
      changepriceLabel = 'まだ受け付けていません';
    } else {
      changepriceLabel = '請求金額に達していません';

      // 未来院の場合
      if (values.wrtOkFlg === '' && values.comedate === '') {
        changepriceLabel = 'まだ来院していません';
      }
    }

    if (changePrice >= 0) {
      const changePriceFormat = changePrice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,');
      changepriceLabel = `おつりは   \\${changePriceFormat}   です`;
    }
    values.changepriceLabel = changepriceLabel;

    yield put(getPerBillIncomeSuccess({ cardKindItems, bankItems, billNo }));

    yield put(initialize(formName, values));
  } catch (error) {
    // 入金情報を取得失敗Actionを発生させる
    yield put(getPerBillIncomeFailure(error.response));
  }
}

// 個人入金情報を登録する
function* runRequestRegisterPerBillIncome(action) {
  const { strMode } = action.payload.data;
  try {
    // 個人入金情報を登録処理実行
    if (strMode === 'insert') {
      yield call(perBillService.registerPerBillIncome, { ...action.payload, mode: 1 });
    } else if (strMode === 'update') {
      yield call(perBillService.updatePerBillIncome, { ...action.payload, mode: 1 });
    }
    // 個人入金情報を登録成功Actionを発生させる
    yield put(registerPerBillIncomeSuccess());
  } catch (error) {
    // 個人入金情報を登録失敗Actionを発生させる
    yield put(registerPerBillIncomeFailure(error.response));
  }
}

// 個人入金情報テーブルレコードを削除する
function* runRequestDeletePerPayment(action) {
  try {
    // 個人入金情報テーブルレコードを削除処理実行
    yield call(perBillService.deletePerPayment, action.payload);

    // 個人入金情報テーブルレコードを削除成功Actionを発生させる
    yield put(deletePerPaymentSuccess());
  } catch (error) {
    // 個人入金情報を登録失敗Actionを発生させる
    yield put(deletePerPaymentFailure(error.response));
  }
}

// 領収書・請求書印刷情報を取得する
function* runRequestPrtPerBill(action) {
  const formName = 'prtPerBill';

  const { dmddate, billseq, branchno, prtKbn, disp } = action.payload;

  // 請求日 配列
  const dmddateArray = dmddate.split(',');
  // 請求書Ｓｅｑ 配列
  const billseqArray = billseq.split(',');
  // 請求書枝番 配列
  const branchnoArray = branchno.split(',');
  // 受診情報
  let perBillCsl = null;
  // 個人請求管理情報
  let perBill = null;

  const prtBillItem = [];

  // 入力項目の初期値
  const values = { dmddateArray, billseqArray, branchnoArray, prtKbn, disp };

  try {
    for (let i = 0, len = dmddateArray.length; i < len; i += 1) {
      // 請求書Ｎｏから予約番号を取得しそれぞれの受診情報を取得する
      perBillCsl = yield call(perBillService.getPerBillCsl, { params: { dmddate: dmddateArray[i], billseq: billseqArray[i], branchno: branchnoArray[i] } });

      // 個人請求管理情報の取得
      perBill = yield call(perBillService.getPerBillBillNo, { params: { dmddate: dmddateArray[i], billseq: billseqArray[i], branchno: branchnoArray[i] } });

      const mddateFormat = moment(dmddateArray[i]).format('YYYYMMDD');
      const billseqFormat = `0000${billseqArray[i]}`.slice(-5);
      prtBillItem.push({ item: `${mddateFormat}${billseqFormat}${branchnoArray[i]}  ${perBillCsl[0].csname}  ${perBillCsl[0].lastname} ${perBillCsl[0].firstname}`, key: i });

      // 請求宛先 初期値
      if (perBill[0].billname == null) {
        values[`billName${i + 1}`] = `${perBillCsl[0].lastname} ${perBillCsl[0].firstname}`;
      } else {
        values[`billName${i + 1}`] = perBill[0].billname;
      }
      // 敬称 初期値
      if (perBill[0].keishou == null) {
        values[`keishou${i + 1}`] = '様';
      } else {
        values[`keishou${i + 1}`] = perBill[0].keishou;
      }
    }
    // 領収書・請求書印刷情報を取得成功Actionを発生させる
    yield put(getPrtPerBillSuccess({ prtBillItem }));
    // 領収書・請求書印刷情報をredux - formへセットするActionを発生させる
    yield put(initialize(formName, values));
  } catch (error) {
    // 領収書・請求書印刷情報を取得失敗Actionを発生させる
    yield put(getPrtPerBillFailure(error.response));
  }
}

// 請求書管理情報を更新する
function* runRequestUpdatePerBill(action) {
  const { values, act } = action.payload;
  const { dmddateArray, billseqArray, branchnoArray, prtKbn } = values;

  // 請求宛先 配列
  const billNameArray = [];
  // 敬称 配列
  const keishouArray = [];

  let i = 1;
  while (true) {
    const billNameItem = `billName${i}`;
    const keishouItem = `keishou${i}`;
    if (typeof (values[billNameItem]) !== 'undefined' && typeof (values[keishouItem]) !== 'undefined') {
      billNameArray.push(values[billNameItem]);
      keishouArray.push(values[keishouItem]);
    } else {
      break;
    }

    i += 1;
  }

  try {
    // 請求書管理情報を更新処理実行
    yield call(perBillService.updatePerBill, { dmddateArray, billseqArray, branchnoArray, billNameArray, keishouArray, prtKbn, act });

    // 請求書管理情報を更新成功Actionを発生させる
    yield put(updatePrtPerBillSuccess());
  } catch (error) {
    // 請求書管理情報を更新失敗Actionを発生させる
    yield put(updatePrtPerBillFailure(error.response));
  }
}
// 個人請求管理情報の更新Action発生時に起動するメソッド
function* runRequestUpdataPerBillComment(action) {
  try {
    // 請求書コメント処理実行
    yield call(perBillService.updataPerBillComment, action.payload);
    // 請求書コメント成功Actionを発生させる
    const { data } = action.payload;
    const payloadNo = yield call(perBillService.getPerBillNo, data);
    yield put(getPerBillNoSuccess(payloadNo));
    yield put(closePerBillGuide());
    yield put(updataPerBillCommentSuccess(action.payload));
  } catch (error) {
    //  請求書コメント失敗Actionを発生させる
    yield put(updataPerBillCommentFailure(error.response));
  }
}

// 個人請求書の検索情報取得Action発生時に起動するメソッド
function* runRequestPerBillList(action) {
  try {
    // 一覧取得処理実行
    const payload = yield call(perBillService.getPerList, action.payload);
    // 一覧取得成功Actionを発生させる
    yield put(getPerBillListSuccess(payload));
  } catch (error) {
    // 一覧取得失敗Actionを発生させる
    yield put(getPerBillListFailure(error.response));
  }
}

// 請求書情報取得Action発生時に起動するメソッド
function* runRequestPerBill(action) {
  try {
    const { params } = action.payload;
    // 情報取得処理実行
    const payload = yield call(perBillService.getPerBillNo, params);
    // 情報をredux-formへセットするActionを発生させる  生成Action以将组信息设置为redux-form
    // yield put(initialize(formName, payload));
    // 情報取得成功Actionを発生させる
    yield put(getPerBillNoSuccess(payload));
    for (let i = 0; i < 1; i += 1) {
      // パラメータ設定
      if (payload[i].paymentdate !== null) {
        try {
          // 情報取得処理実行
          const payload1 = yield call(perBillService.getPerPayment, { params: { paymentdate: payload[i].paymentdate, paymentseq: payload[i].paymentseq } });
          // 情報取得成功Actionを発生させる
          yield put(getPerPaymentSuccess(payload1));
        } catch (error) {
          // 情報取得失敗Actionを発生させる
          yield put(getPerPaymentFailure(error.response));
        }
      }
    }
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPerBillNoFailure(error.response));
  }
}
// 請求書情報削除Action発生時に起動するメソッド
function* runRequestDeletePerBill(action) {
  try {
    // 情報取得処理実行
    const payload = yield call(perBillService.deletePerBill, action.payload);
    // 情報処理成功Actionを発生させる
    yield put(deletePerBillSuccess(payload));
  } catch (error) {
    // 請求書情報削除失敗Actionを発生させる
    yield put(deletePerBillFailure(error.response));
  }
}
// 個人請求明細情報の取得Action発生時に起動するメソッド
function* runRequestPerBillC(action) {
  try {
    // 情報取得処理実行
    const payload = yield call(perBillService.getPerBillC, action.payload);
    // 情報取得成功Actionを発生させる
    yield put(getPerBillCSuccess(payload));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPerBillCFailure(error.response));
  }
}
// 入金情報の取得Action発生時に起動するメソッド
function* runRequestPerPayment(action) {
  try {
    // 情報取得処理実行
    const payload = yield call(perBillService.getPerPayment, action.payload);
    // 情報取得成功Actionを発生させる
    yield put(getPerPaymentSuccess(payload));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPerPaymentFailure(error.response));
  }
}
// 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得する
function* runRequestPerBillPerson(action) {
  try {
    // 情報取得処理実行
    const payload = yield call(perBillService.getPerBillPerson, action.payload);
    // 情報取得成功Actionを発生させる
    yield put(getPerBillPersonSuccess(payload));
    yield put(getPerBillCRequest(action.payload));
    yield put(getPerBillNoRequest(action.payload));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPerBillPersonFailure(error.response));
  }
}
// 個人請求明細情報の取得取得する
function* runRequestPerBillPersonC(action) {
  try {
    // 情報取得処理実行
    const payload = yield call(perBillService.getPerBillPersonC, action.payload);
    // 情報取得成功Actionを発生させる
    yield put(getPerBillPersonCSuccess(payload));
  } catch (error) {
    // 情報取得失敗Actionを発生させる
    yield put(getPerBillPersonCFailure(error.response));
  }
}

function* runRequestcreatePerBill(action) {
  const { formValues, params, perCountData, billCountData, mode, redirect1 } = action.payload;
  // 指定可能個人id
  const perId = [];
  const otherLine = [];
  const items = [];
  const data = {};
  // 指定可能個人を数量
  let perCnt = 0;
  // 指定可能明細を数量
  let billCnt = 0;
  perCountData.forEach((value, index) => {
    if (value.perid !== undefined) {
      if (value.perid == null) {
        perId.push('');
      } else {
        perId.push(value.perid);
      }
      perCnt += 1;
      Object.assign(perCountData[index], params);
    }
  });
  billCountData.forEach((value, index) => {
    if (value.otherlinedivcd !== undefined) {
      if (value.otherlinedivcd == null) {
        otherLine.push('');
      } else {
        otherLine.push(value.otherlinedivcd);
      }
      billCnt += 1;
      Object.assign(billCountData[index], params, { perid: '' });
    }
  });
  const item = perCountData.concat(billCountData);
  for (let i = 0; i < item.length; i += 1) {
    if (item[i].constructor === Object) {
      items.push(item[i]);
    }
  }
  data.perids = perId;
  data.otherLineDivCds = otherLine;
  data.item = items;
  Object.assign(data, params, formValues);
  data.perCount = perCnt;
  data.billCount = billCnt;
  if (mode === 'update') {
    data.newdmddate = data.dmddate;
    // 請求書修正処理
    try {
      // 情報取得処理実行
      const payload = yield call(perBillService.getUpdatePerBillPerson, { data });
      // 情報取得成功Actionを発生させる
      yield put(updatePerBillPersonSuccess(payload));
    } catch (error) {
      // 情報取得失敗Actionを発生させる
      yield put(updatePerBillPersonFailure(error.response));
    }
  } else {
    // 請求書新規作成処理
    try {
      // 新規作成処理実行
      const payload = yield call(perBillService.getCreatePerBillPerson, { data });
      // 新規作成処理成功Actionを発生させる
      yield put(createPerBillPersonSuccess(payload));
      redirect1(payload);
      try {
        // 情報取得処理実行
        const payload1 = yield call(perBillService.getPerBillPerson, { params: payload });
        // 情報取得成功Actionを発生させる
        yield put(getPerBillPersonSuccess(payload1));
      } catch (error) {
        // 情報取得失敗Actionを発生させる
        yield put(getPerBillPersonFailure(error.response));
      }
      try {
        // 情報取得処理実行
        const payload2 = yield call(perBillService.getPerBillC, { params: payload });
        // 情報取得成功Actionを発生させる
        yield put(getPerBillCSuccess(payload2));
      } catch (error) {
        // 情報取得失敗Actionを発生させる
        yield put(getPerBillCFailure(error.response));
      }
      try {
        // 情報取得処理実行
        const payload3 = yield call(perBillService.getPerBillNo, payload);
        // 情報をredux-formへセットするActionを発生させる  生成Action以将组信息设置为redux-form
        // yield put(initialize(formName, payload));
        // 情報取得成功Actionを発生させる
        yield put(getPerBillNoSuccess(payload3));
        for (let i = 0; i < 1; i += 1) {
          // パラメータ設定
          if (payload3[i].paymentdate !== null) {
            try {
              // 情報取得処理実行
              const payload11 = yield call(perBillService.getPerPayment, { params: { paymentdate: payload3[i].paymentdate, paymentseq: payload[i].paymentseq } });
              // 情報取得成功Actionを発生させる
              yield put(getPerPaymentSuccess(payload11));
            } catch (error) {
              // 情報取得失敗Actionを発生させる
              yield put(getPerPaymentFailure(error.response));
            }
          }
        }
      } catch (error) {
        // 情報取得失敗Actionを発生させる
        yield put(getPerBillNoFailure(error.response));
      }
    } catch (error) {
      // 新規作成処理失敗Actionを発生させる
      yield put(createPerBillPersonFailure(error.response));
    }
  }
}

// Actionとその発生時にメソッドをリンクさせる実行する

// Actionとその発生時に実行するメソッドをリンクさせる
const perBillSagas = [
  takeEvery(openPerbillallincomeGuide.toString(), runRequestRslConsultPerBill),
  takeEvery(getFriendsPerbillRequest.toString(), runRequestFriendsPerBill),
  takeEvery(getPerBillInfoRequest.toString(), runRequestPerBillInfo),
  takeEvery(deletePerBillInfoRequest.toString(), runRequestDelPerBillInfo),
  takeEvery(openPerbillOptionGuideRequest.toString(), runRequestopenPerbillOptionGuide),
  takeEvery(updateConsultOptionRequest.toString(), runRequestupdateConsultOption),
  takeEvery(openMergeGuideRequest.toString(), runOpenMergeGuide),
  takeEvery(getPersonLukesRequest.toString(), runRequestPersonLukes),
  takeEvery(registerMergePerbillRequest.toString(), runRegisterMergePerbill),
  takeEvery(openPerBillIncomeGuide.toString(), runRequestPerBillIncome),
  takeEvery(registerPerBillIncomeRequest.toString(), runRequestRegisterPerBillIncome),
  takeEvery(deletePerPaymentRequest.toString(), runRequestDeletePerPayment),
  takeEvery(getPrtPerBillRequest.toString(), runRequestPrtPerBill),
  takeEvery(updatePrtPerBillRequest.toString(), runRequestUpdatePerBill),
  takeEvery(openEditPerBillGuideRequest.toString(), runOpenEditPerBillGuide),
  takeEvery(checkValueAndUpdatePerBillcRequest.toString(), runCheckValueAndUpdatePerBillc),
  takeEvery(deletePerBillcRequest.toString(), runDeletePerBillc),
  takeEvery(openGdePerBillGuideRequest.toString(), runRequestOpenGdePerBillGuide),
  takeEvery(getListPerBillRequest.toString(), runRequestListPerBill),

  takeEvery(updataPerBillCommentRequest.toString(), runRequestUpdataPerBillComment),
  takeEvery(getPerBillListRequest.toString(), runRequestPerBillList),
  takeEvery(getPerBillNoRequest.toString(), runRequestPerBill),
  takeEvery(deletePerBillRequest.toString(), runRequestDeletePerBill),
  takeEvery(getPerBillCRequest.toString(), runRequestPerBillC),
  takeEvery(getPerPaymentRequest.toString(), runRequestPerPayment),
  takeEvery(getPerBillPersonRequest.toString(), runRequestPerBillPerson),
  takeEvery(getPerBillPersonCRequest.toString(), runRequestPerBillPersonC),
  takeEvery(createPerBillRequest.toString(), runRequestcreatePerBill),
];

export default perBillSagas;
