import { call, takeEvery, put } from 'redux-saga/effects';
import moment from 'moment';

import * as constants from '../../constants/common';

import resultService from '../../services/result/resultService';
import judgementService from '../../services/judgement/judgementService';
import freeService from '../../services/preference/freeService';
import consultService from '../../services/reserve/consultService';
import sentenceService from '../../services/preference/sentenceService';
import hainsUserService from '../../services/preference/hainsUserService';
import workStationService from '../../services/preference/workStationService';
import courseService from '../../services/preference/courseService';
import groupService from '../../services/preference/groupService';
import interviewService from '../../services/judgement/interviewService';
import questionnaireService from '../../services/dailywork/questionnaireService';
import judClassService from '../../services/preference/judClassService';
import progressService from '../../services/preference/progressService';
import {
  rslMainLoadRequest,
  rslMainLoadSuccess,
  rslDailyListLoad,
  rslDailyListLoadFailure,
  rslMenuCheckData,
  rslMainShowRequest,
  updateResultForDetailRequest,
  updateResultForDetailSuccess,
  updateResultForDetailFailure,
  getConsultListRequest,
  getConsultListSuccess,
  getConsultListFailure,
  getCurRsvNoPrevNextRequest,
  getCurRsvNoPrevNextSuccess,
  getCurRsvNoPrevNextFailure,
  // 検査結果更新
  registerResultRequest,
  registerResultSuccess,
  registerResultFailure,
  registerEntryAutherRequest,
  registerEntryAutherSuccess,
  registerEntryAutherFailure,
  getProgressListRequest,
  getProgressListSuccess,
  getProgressListFailure,
  getProgressNameRequest,
  getProgressNameSuccess,
  getProgressNameFailure,

  getUpdateResultAll,
  getUpdateResultAllSuccess,
  getUpdateResultAllFailure,
  getRslAllSetListRequest,
  getReloadResultListRequest,
  getRslAllSetListSuccess,
  getRslAllSetListFailure,
  getCheckResultThenSave,
  getMessageDataSuccess,
  updateResultListSuccess,
  openEntryAutherGuide,
  getHainsUserSuccess,
  getHainsUserFailure,
  getSentenceSuccess,
  getSentenceFailure,
  checkCondition,
  getConsultListCheckRequest,
  getConsultSetList,
  getReloadConsultSetList,
  getConsultSetListSuccess,
  updateRslListSet,
  getUpdateRslListSetSuccess,
  getConsultSetListFailure,
  getRslAllSetValueFailure,
  getNaishikyouCheckSuccess,
  getNaishikyouCheckFailure,
  updateResultNoCmtRequest,
  updateResultNoCmtSuccess,
  updateResultNoCmtFailure,
  getCheckGFFailure,
  openNaishikyouCheckGuide,
  getItemResultsSuccess,
  getGrpcdResult,
  getGrpcdResultSuccess,
  getGrpcdResultFailure,
  getRslListSetList,
  getRslListSetListSuccess,
  getRslListSetListFailure,
} from '../../modules/result/resultModule';

import {
  getSubEntitySpJudRequest,
  getSubEntitySpJudSuccess,
  getSubEntitySpJudFailure,
  getRslRequest,
  getRslSuccess,
  getRslFailure,
  updateEntitySpJudRequest,
  updateEntitySpJudSuccess,
  updateEntitySpJudFailure,
} from '../../modules/judgement/specialInterviewModule';

import {
  getItemsandresultsSuccess,
  getInitCondtion,
} from '../../modules/preference/groupModule';
import {
  getConsultListItemSuccess,
  getConsultListCheckFailure,
  getConsultListItemFailure,
} from '../../modules/reserve/consultModule';

const CONSULT_ITEM_T = 1;
let total = 0;
// 結果入力の初期化
function* runrslMenuLoad() {
  let sortkeyitems = [{ value: '', name: '当日ＩＤ順' }, { value: 3, name: '個人ＩＤ順' }];
  const params = {};
  params.mode = 0;
  params.freecd = 'RSLCNTL';
  const data = yield call(freeService.getFree, params);
  const cntlnoflg = data[0].freefield1;
  try {
    params.freecd = 'FILM';
    params.mode = 1;
    sortkeyitems = yield call(freeService.getFree, params);
    yield put(rslMainLoadSuccess({ sortkeyitems, cntlnoflg }));
  } catch (error) {
    yield put(rslMainLoadSuccess({ sortkeyitems, cntlnoflg }));
  }
}

// 受診者の検査結果を取得Action発生時に起動するメソッド
function* runRequestRsl(action) {
  try {
    let rsldata = null;
    // 受診者の検査結果を取得処理実行
    rsldata = yield call(resultService.getRsl, action.payload);
    // 受診者の検査結果を取得成功Actionを発生させる
    yield put(getRslSuccess({ rsldata }));
  } catch (error) {
    // 受診者の検査結果を取得失敗Actionを発生させる
    yield put(getRslFailure(error.response));
  }
}

// 特定保健指導区分を取得するAction発生時に起動するメソッド
function* runGetSubEntitySpJudRequest(action) {
  try {
    let rsldata = null;
    // 特定保健指導区分を取得処理実行
    rsldata = yield call(resultService.getRsl, action.payload);
    // 階層化コメントを取得成功Actionを発生させる
    yield put(getSubEntitySpJudSuccess({ rsldata }));
  } catch (error) {
    // 階層化コメントを取得失敗Actionを発生させる
    yield put(getSubEntitySpJudFailure(error.response));
  }
}

// 特定保健指導区分を登録するAction発生時に起動するメソッド
function* runUpdateEntitySpJudRequest(action) {
  try {
    const { rsvno } = action.payload;
    // 特定保健指導区分登録処理実行
    const payload = yield call(resultService.updateResult, action.payload);
    // 特定保健指導区分登録成功Actionを発生させる
    yield put(updateEntitySpJudSuccess(payload));
    // 特定保健指導区分を再読み込み
    yield put(getRslRequest({ rsvno, itemcd: constants.GUIDANCE_ITEMCD, suffix: constants.GUIDANCE_SUFFIX }));
  } catch (error) {
    // 担当者登録失敗Actionを発生させる
    yield put(updateEntitySpJudFailure(error.response));
  }
}

// 検査結果更新Action発生時に起動するメソッド
function* runRegisterResult(action) {
  try {
    // 検査結果更新処理実行
    yield call(resultService.registerResult, action.payload);
    // 検査結果更新成功Actionを発生させる
    yield put(registerResultSuccess());
  } catch (error) {
    // 検査結果更新失敗Actionを発生させる
    yield put(registerResultFailure(error.response));
  }
}

// 担当者登録Action発生時に起動するメソッド
function* runRegisterEntryAuther(action) {
  try {
    // 担当者登録処理実行
    const payload = yield call(resultService.updateResult, action.payload);
    // 担当者登録成功Actionを発生させる
    yield put(registerEntryAutherSuccess(payload));
  } catch (error) {
    // 担当者登録失敗Actionを発生させる
    yield put(registerEntryAutherFailure(error.response));
  }
}

// 検索条件を満たすレコード件数を取得
function* runGetProgressList(action) {
  try {
    // 件数を取得処理実行
    let payload = {};
    let data = [];
    let strMessage = '';
    let message1 = '';
    let message2 = '';
    if (action.payload.rsvNo) {
      const r = /^\d+$/;
      if (action.payload.rsvNo.length > constants.LENGTH_CONSULT_RSVNO || !r.test(action.payload.rsvNo)) {
        strMessage = `予約番号は${constants.LENGTH_CONSULT_RSVNO}文字以内の半角数字で入力して下さい。`;
      } else {
        const rsvno = parseInt(action.payload.rsvNo, 10);
        const item = yield call(consultService.getConsult, { rsvno });
        const strMessage2 = `氏名=${item.lastname}${item.firstname}（${item.perid}）、コース=${item.csname}（${item.cscd}）`;
        if (item.cancelflg !== constants.CONSULT_USED) {
          strMessage = `指定された予約番号の受診情報はキャンセルされています。 ${strMessage2}`;
        } else if (item.dayid === null) {
          strMessage = `指定された予約番号の受診情報は受付されていません。 ${strMessage2}`;
        }
        data.push(item);
        payload = { totalcount: 1, data };
      }
    } else {
      payload = yield call(consultService.getConsultListProgress, action.payload);
      const array = payload.data;
      data = array;
    }
    // TODO 連携エラーログ情報を取得
    const lngErrLog1 = 0;
    const fileName1 = '';
    const errDate = '';
    if (lngErrLog1 === -3) {
      message1 = '汎用マスタ設定確認。ERRFILE情報がありません！';
    }
    if (lngErrLog1 === -2) {
      message1 = '共有フォルダが見つかりません！';
    }
    // TODO 連携ログ監視用ファイルを検知した場合、警告メッセージを出す
    let lngErrLog2 = 0;
    const fileName2 = '';
    if (lngErrLog2 === 1 && fileName2 !== null) {
      lngErrLog2 = -9;
    }
    if (lngErrLog2 === -2) {
      message2 = 'SendOrder.logの共有フォルダが見つかりません';
    }
    if (lngErrLog2 === -9) {
      message2 = '連携サーバCOM+のリフレッシュが必要ですのでシステム担当へ連絡して下さい。';
    }


    const strRslStatus = [];
    for (let i = 0; i < data.length; i += 1) {
      const payload1 = yield call(progressService.getProgressRsl, data[i].rsvno);
      data[i].strArrEntriedJud = yield call(judgementService.getJudgementStatusAuto, data[i].rsvno);
      data[i].strArrEntriedJudManual = yield call(judgementService.getJudgementStatusManual, data[i].rsvno);
      strRslStatus.push(payload1);
    }
    // 件数を取得成功Actionを発生させる
    yield put(getProgressListSuccess({ ...payload, strRslStatus, strMessage, message1, message2, lngErrLog1, fileName1, errDate }));
  } catch (error) {
    // 件数を取得失敗Actionを発生させる
    yield put(getProgressListFailure(error.response));
  }
}


// 全ての進捗分類情報を取得する
function* runGetProgressName(action) {
  try {
    // 分類情報を取得する処理実行
    const payload = yield call(progressService.getProgressList, action.payload);
    // 分類情報を取得する成功Actionを発生させる
    yield put(getProgressNameSuccess(payload));
  } catch (error) {
    // 分類情報を取得する失敗Actionを発生させる
    yield put(getProgressNameFailure(error.response));
  }
}

function* runGetGrpcdResult() {
  try {
    // 端末情報を読み込む
    const workstation = yield call(workStationService.getWorkstation);
    if (workstation !== '') {
      yield put(getGrpcdResultSuccess(workstation));
    } else {
      const param = {};
      param.grpcd = 'G010';
      yield put(getGrpcdResultSuccess(param));
    }
  } catch (error) {
    yield put(getGrpcdResultFailure(error.response));
  }
}

// 検査結果一括更新
function* runUpdateResultAll(action) {
  try {
    const fromBody = {};
    const selectPerson = [];
    let msgResult = {};
    let person = {};
    fromBody.rsvno = [];

    if (action.payload.data.allResultClear) {
      // このグループの検査結果を全てクリア
      if (action.payload.data.allResultClear[0] === 1) {
        fromBody.allresultclear = '1';
      } else {
        fromBody.allresultclear = null;
      }
    }
    fromBody.resultitems = [];
    if (action.payload.step && action.payload.step === 'step3') {
      const { modelInfoThree } = action.payload.data;
      for (let i = 0; i < modelInfoThree.length; i += 1) {
        if ((modelInfoThree[i].result && modelInfoThree[i].result === '1')) {
          fromBody.rsvno.push(modelInfoThree[i].rsvno);
          person = modelInfoThree[i];
          selectPerson.push(person);
        }
      }
      if (selectPerson.length === 0) {
        action.payload.props.onLast();
        return;
      }
      const param3 = {};
      param3.selectPerson = selectPerson;
      yield put(getUpdateResultAllSuccess(param3));
      action.payload.props.onLast();
      return;
    } else if (action.payload.step && action.payload.step === 'step2') {
      // 来院済み受診者のみ対象
      if (action.payload.type) {
        const { cntlNo, cscd, grpcd, cslDate, dayIdF, dayIdT } = action.payload;
        const checkparam = {};
        if (action.payload.allResultClear && action.payload.allResultClear === 1) {
          checkparam.allResultClear = 1;
        }
        checkparam.cntlNo = cntlNo;
        checkparam.cscd = cscd;
        checkparam.grpcd = grpcd;
        checkparam.cslDate = cslDate;
        if (dayIdF) {
          if (dayIdF.length === 1) {
            checkparam.dayIdF = `000${dayIdF}`;
          } else if (dayIdF.length === 2) {
            checkparam.dayIdF = `00${dayIdF}`;
          } else if (dayIdF.length === 3) {
            checkparam.dayIdF = `0${dayIdF}`;
          } else {
            checkparam.dayIdF = dayIdF;
          }
        }
        if (dayIdT) {
          if (dayIdF.length === 1) {
            checkparam.dayIdT = `000${dayIdT}`;
          } else if (dayIdT.length === 2) {
            checkparam.dayIdT = `00${dayIdT}`;
          } else if (dayIdT.length === 3) {
            checkparam.dayIdT = `0${dayIdT}`;
          } else {
            checkparam.dayIdT = dayIdT;
          }
        }
        checkparam.comeOnly = true;
        checkparam.startDayId = checkparam.dayIdF;
        checkparam.endDayId = checkparam.dayIdT;
        const payload2 = yield call(consultService.getConsultList, checkparam);
        payload2.checkParam = checkparam;
        yield put(getConsultListItemSuccess(payload2));
        if (!(payload2 && payload2.totalCount && payload2.totalCount > 0)) {
          yield put(getConsultListItemFailure(checkparam));
          yield put(getItemResultsSuccess(['指定検査グループの検査を受診している来院済み受診者が存在しません。']));
          return;
        }
      }
      const { cntlNo, cscd, grpcd, cslDate } = action.payload.data;
      const dataBody = {};
      const results = [];
      const { itemData, itemLoad } = action.payload.data;
      let itemDateArr = [];
      // デフォルト値を展開值
      if (itemData && itemData.data && action.payload.zt && action.payload.zt === '2') {
        itemDateArr = itemData.data;
      // 画面を初期化值
      } else if (itemLoad && itemLoad.data && action.payload.zt && action.payload.zt === '1') {
        itemDateArr = itemLoad.data;
      }
      for (let i = 0; i < itemDateArr.length; i += 1) {
        const tresult = {};
        tresult.itemcd = itemDateArr[i].itemcd;
        tresult.suffix = itemDateArr[i].suffix;
        // 画面を初期化值
        if (action.payload.zt && action.payload.zt === '1' && itemDateArr[i].defresult) {
          tresult.result = itemDateArr[i].defresult;
        // デフォルト値を展開值
        } else if (action.payload.zt && action.payload.zt === '2' && itemDateArr[i].defresult) {
          tresult.result = itemDateArr[i].defresult;
        } else {
          tresult.result = null;
        }
        results.push(tresult);
      }
      dataBody.cslDate = cslDate.replace('/', '-').replace('/', '-');
      dataBody.results = results;
      const conditions = { data: dataBody };
      const payloadMsg = yield call(resultService.checkResult, conditions);
      msgResult = payloadMsg;
      // 検証したことがない
      if (payloadMsg.messageData.messages) {
        const errlist = payloadMsg.messageData.results;
        for (let i = 0; i < errlist.length; i += 1) {
          itemDateArr[i].resulterror = errlist[i].resulterror;
          itemDateArr[i].result = errlist[i].result;
        }
        const data = {};
        data.data = itemDateArr;
        data.message = payloadMsg.messageData.messages;
        yield put(getItemsandresultsSuccess(data));
        yield put(getItemResultsSuccess(payloadMsg.messageData.messages));
        return;
      }
      if (action.payload.type && action.payload.type === 'next') {
        yield put(getItemResultsSuccess());
        yield put(getInitCondtion(action.payload));
        yield put(getItemResultsSuccess([]));
        action.payload.props.onNext();
        return;
      }
      // 検査結果処理実行
      const checkparam = {};
      checkparam.cntlNo = cntlNo;
      checkparam.cscd = cscd;
      checkparam.grpcd = grpcd;
      checkparam.cslDate = cslDate;
      const payloadcheck = yield call(consultService.getConsultList, checkparam);
      const rsvnoArr = payloadcheck.data;
      for (let i = 0; i < rsvnoArr.length; i += 1) {
        fromBody.rsvno.push(rsvnoArr[i].rsvno);
      }
    } else {
      // 検査結果処理実行
      const { cntlNo, cscd, grpcd, cslDate } = action.payload.data;
      const checkparam = {};
      checkparam.cntlNo = cntlNo;
      checkparam.cscd = cscd;
      checkparam.grpcd = grpcd;
      checkparam.cslDate = cslDate;
      const payloadcheck = yield call(consultService.getConsultList, checkparam);
      const rsvnoArr = payloadcheck.data.data;
      for (let i = 0; i < rsvnoArr.length; i += 1) {
        fromBody.rsvno.push(rsvnoArr[i].rsvno);
      }
    }
    // 検査結果処理実行
    const { itemData, itemLoad } = action.payload.data;
    let itemDateArr = [];
    if (itemData && itemData.data && action.payload.zt && action.payload.zt === '2') {
      itemDateArr = itemData.data;
    } else if (itemLoad && itemLoad.data && action.payload.zt && action.payload.zt === '1') {
      itemDateArr = itemLoad.data;
    }
    for (let i = 0; i < itemDateArr.length; i += 1) {
      // 検査結果処理実行
      const resultitems = {};
      resultitems.itemcd = itemDateArr[i].itemcd;
      resultitems.suffix = itemDateArr[i].suffix;
      resultitems.result = msgResult.messageData.results[i].result;
      fromBody.resultitems.push(resultitems);
    }
    const conditions = { ...action.payload, data: fromBody };
    const payload = yield call(resultService.updateResultAll, conditions);
    // 検査結果成功Actionを発生させる
    payload.selectPerson = selectPerson;
    yield put(getUpdateResultAllSuccess(payload));
    if ((action.payload.step && action.payload.step === 'step2') || (action.payload.step && action.payload.step === 'step3')) {
      if (action.payload.type && action.payload.type === 'next') {
        action.payload.props.onNext();
      } else {
        action.payload.props.onLast();
      }
    }
  } catch (error) {
    // 失敗Actionを発生させる
    yield put(getUpdateResultAllFailure(error.response));
  }
}


function* runRslAllSetList(action) {
  try {
    // 担当者登録処理実行
    const personList = [];
    const rsvnoArr = action.payload.selectPerson.selectPerson;
    for (let i = 0; i < rsvnoArr.length; i += 1) {
      const conditions = {};
      const personResult = {};
      conditions.rsvno = rsvnoArr[i].rsvno;
      conditions.grpcd = action.payload.grpcd;
      const payloadPerson = yield call(resultService.getRslAllSetList, conditions);
      personResult.infoResult = payloadPerson;
      personResult.info = rsvnoArr[i];
      personList.push(personResult);
    }
    yield put(getRslAllSetListSuccess(personList));
  } catch (error) {
    yield put(getRslAllSetListFailure(error.response));
  }
}

function* runReloadResultList(action) {
  try {
    // 担当者登録処理実行
    const personList = [];
    const rsvnoArr = action.payload.payload.saveItemData.saveItemData;
    for (let i = 0; i < rsvnoArr.length; i += 1) {
      const conditions = {};
      const personResult = {};
      conditions.rsvno = rsvnoArr[i].info.rsvno;
      conditions.grpcd = action.payload.payload.grpcd;
      const payloadPerson = yield call(resultService.getRslAllSetList, conditions);
      personResult.infoResult = payloadPerson;
      personResult.info = rsvnoArr[i].info;
      personList.push(personResult);
    }
    yield put(getRslAllSetListSuccess(personList));
    yield put(updateResultListSuccess());
  } catch (error) {
    yield put(getRslAllSetListFailure(error.response));
  }
}

// 検査項目保存
function* runCheckResultThenSave(action) {
  try {
    const resultLength = action.payload.saveItemData.saveItemData;
    const results = [];
    const fromBody = {};
    const { csldate } = action.payload.saveItemData.saveItemData[0].info;
    // 検査結果処理実行
    for (let i = 0; i < resultLength.length; i += 1) {
      const arrItem = resultLength[i].infoResult;
      for (let j = 0; j < arrItem.length; j += 1) {
        const result = {};
        result.itemcd = arrItem[j].itemcd;
        result.suffix = arrItem[j].suffix;
        result.result = arrItem[j].result;
        if (arrItem[j].resulterror) { // 重置error
          arrItem[j].resulterror = null;
        }
        results.push(result);
      }
    }
    fromBody.cslDate = csldate;
    fromBody.results = results;
    const conditions = { data: fromBody };
    const payloadMsg = yield call(resultService.checkResult, conditions);
    // 検証したことがない
    const errInfo = [];
    if (payloadMsg.messageData.messages) {
      const { saveItemData } = action.payload.saveItemData;
      const errlist = payloadMsg.messageData.results;
      // 検査結果処理実行
      for (let j = 0; j < saveItemData.length; j += 1) {
        const rl = saveItemData[j].infoResult;
        for (let k = 0; k < rl.length; k += 1) {
          rl[k].resulterror = errlist[j * rl.length + k].resulterror;
          if (errlist[j * rl.length + k].resulterror) {
            errInfo.push(saveItemData[j].info);
          }
        }
      }
      if (errInfo.length === payloadMsg.messageData.messages.length) {
        for (let j = 0; j < payloadMsg.messageData.messages.length; j += 1) {
          payloadMsg.messageData.messages[j] = `${errInfo[j].lastname} ${errInfo[j].firstname} ${payloadMsg.messageData.messages[j]}`;
        }
        payloadMsg.message = payloadMsg.messageData.messages;
      } else {
        payloadMsg.message = payloadMsg.messageData.messages;
      }
      // 更新
      let jslag = -1;
      for (let i = 0; i < resultLength.length; i += 1) {
        const rec = [];
        const resultitems = {};
        const arrItem = resultLength[i].infoResult;
        for (let j = 0; j < arrItem.length; j += 1) {
          const r = {};
          jslag += 1;
          if (arrItem[j].resulttype !== 5 && !payloadMsg.messageData.results[jslag].resulterror) {
            r.itemcd = arrItem[j].itemcd;
            r.suffix = arrItem[j].suffix;
            r.result = payloadMsg.messageData.results[jslag].result;
            r.rsvno = resultLength[i].info.rsvno;
            r.resulterror = null;
            rec.push(r);
          }
        }
        resultitems.resultitems = rec;
        const conditionsSave = { data: resultitems };
        yield call(resultService.updateResultList, conditionsSave);
      }
      // 更新後loading
      const personList3 = [];
      const rsvnoArr = action.payload.saveItemData.saveItemData;
      for (let i = 0; i < rsvnoArr.length; i += 1) {
        const conditions3 = {};
        const personResult3 = {};
        conditions3.rsvno = rsvnoArr[i].info.rsvno;
        conditions3.grpcd = action.payload.grpcd;
        const payloadPerson3 = yield call(resultService.getRslAllSetList, conditions3);
        for (let j = 0; j < payloadPerson3.length; j += 1) {
          if (rsvnoArr[i].infoResult[j].resulterror) {
            payloadPerson3[j].resulterror = rsvnoArr[i].infoResult[j].resulterror;
            payloadPerson3[j].result = rsvnoArr[i].infoResult[j].result;
            payloadPerson3[j].shortstc = '';
          }
        }
        personResult3.infoResult = payloadPerson3;
        personResult3.info = rsvnoArr[i].info;
        personList3.push(personResult3);
      }
      payloadMsg.saveItemData = personList3;
      // 更新後に成功する
      yield put(getMessageDataSuccess(payloadMsg));
    } else {
      // 検証による保存
      let add = -1;
      for (let i = 0; i < resultLength.length; i += 1) {
        const rec = [];
        const resultitems = {};
        const arrItem = resultLength[i].infoResult;
        for (let j = 0; j < arrItem.length; j += 1) {
          const r = {};
          add += 1;
          if (arrItem[j].resulttype !== 5) {
            r.itemcd = arrItem[j].itemcd;
            r.suffix = arrItem[j].suffix;
            r.result = payloadMsg.messageData.results[add].result;
            r.rsvno = resultLength[i].info.rsvno;
            r.resulterror = null;
            rec.push(r);
          }
        }
        resultitems.resultitems = rec;
        const conditionsSave = { data: resultitems };
        yield call(resultService.updateResultList, conditionsSave);
      }
      yield put(getReloadResultListRequest(action));
    }
  } catch (error) {
    yield put(getRslAllSetListFailure(error.response));
  }
}

//  内視鏡医フラグ取得Action発生時に起動するメソッド
function* runOpenEntryAutherGuide() {
  try {
    // 内視鏡医フラグ取得処理実行
    // TODO Session.Contents("userId")
    const userid = 'hains$';
    const payload = yield call(hainsUserService.getHainsUser, { userid });
    // 内視鏡医フラグ取得成功Actionを発生させる
    yield put(getHainsUserSuccess(payload));
    const { sentencecd, menflg, hanflg, kanflg, eiflg, shinflg, naiflg } = payload;

    const itemtype = 0;
    const itemparameter = ['30950', '30910', '30960', '30970', '39230', '23320'];
    const checkValue = [0, 0, 0, 0, 0, 0];
    let flagCheck = 0;
    let flagMen = 0;
    let flagJud = 0;
    let flagKan = 0;
    let flagEif = 0;
    let flagShi = 0;
    let flagNai = 0;

    // 面接医として文章テーブルに登録されているかチェック
    if (menflg === 1) {
      try {
        // 文章参照コードで検索するモードActionを発生させる
        const stcDataMen = yield call(sentenceService.getSentence, { itemCd: itemparameter[0], itemType: itemtype, stcCd: sentencecd });
        if (stcDataMen.length !== 0) {
          flagCheck += 1;
          flagMen += 1;
          checkValue[0] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }

    // 判定医として文章テーブルに登録されているかチェック
    if (hanflg === 1) {
      try {
        // 文章参照コードで検索するモードActionを発生させる
        const stcDataJud = yield call(sentenceService.getSentence, { itemCd: itemparameter[1], itemType: itemtype, stcCd: sentencecd });
        if (stcDataJud.length !== 0) {
          flagCheck += 1;
          flagJud += 1;
          checkValue[1] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }

    // 看護師として文章テーブルに登録されているかチェック
    if (kanflg === 1) {
      try {
        // 文章参照コードで検索するモードActionを発生させる
        const stcDataKan = yield call(sentenceService.getSentence, { itemCd: itemparameter[2], itemType: itemtype, stcCd: sentencecd });
        if (stcDataKan.length !== 0) {
          flagCheck += 1;
          flagKan += 1;
          checkValue[2] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }

    // 栄養士として文章テーブルに登録されているかチェック
    if (eiflg === 1) {
      try {
        // 文章参照コードで検索するモードActionを発生させる
        const stcDataEif = yield call(sentenceService.getSentence, { itemCd: itemparameter[3], itemType: itemtype, stcCd: sentencecd });
        if (stcDataEif.length !== 0) {
          flagCheck += 1;
          flagEif += 1;
          checkValue[3] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }

    // 診察医として文章テーブルに登録されているかチェック
    if (shinflg === 1) {
      try {
        // 文章参照コードで検索するモードActionを発生させる
        const stcShi = yield call(sentenceService.getSentence, { itemCd: itemparameter[4], itemType: itemtype, stcCd: sentencecd });
        if (stcShi.length !== 0) {
          flagCheck += 1;
          flagShi += 1;
          checkValue[4] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }

    // 内視鏡医として文章テーブルに登録されているかチェック
    if (naiflg === 1) {
      try {
        // 文章参照コードで検索するモードActionを発生させる
        const stcDataNai = yield call(sentenceService.getSentence, { itemCd: itemparameter[5], itemType: itemtype, stcCd: sentencecd });
        if (stcDataNai.length !== 0) {
          flagCheck += 1;
          flagNai += 1;
          checkValue[5] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }
    yield put(getSentenceSuccess({ flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue, docindex: '0' }));
  } catch (error) {
    // 内視鏡医フラグ取得失敗Actionを発生させる
    yield put(getHainsUserFailure(error.response));
  }
}
// 検査結果テーブルを更新
function* runUpdateResultForDetail(action) {
  const { params, onPrint } = action.payload;
  const { formData, rslListData, rsvno, isprintbutton, echo } = params;
  try {
    const itemcd = [];
    const suffix = [];
    const result = [];
    const rslcmtcd1 = [];
    const rslcmtcd2 = [];
    let updateFlg = true;
    for (let i = 0; i < rslListData.length; i += 1) {
      // 結果、結果コメントの何れも更新されていない場合は追加しない
      if ((rslListData[i].consultflg === CONSULT_ITEM_T) &&
        (rslListData[i].result !== formData[i].result ||
          rslListData[i].rslcmtcd1 !== formData[i].rslcmtcd1 ||
          rslListData[i].rslcmtcd2 !== formData[i].rslcmtcd2)) {
        itemcd.push(formData[i].itemcd);
        suffix.push(formData[i].suffix);
        result.push(formData[i].result);
        rslcmtcd1.push(formData[i].rslcmtcd1);
        rslcmtcd2.push(formData[i].rslcmtcd2);
        updateFlg = false;
      }
    }
    const resultDetail = {};
    resultDetail.itemcd = itemcd;
    resultDetail.suffix = suffix;
    resultDetail.result = result;
    resultDetail.rslcmtcd1 = rslcmtcd1;
    resultDetail.rslcmtcd2 = rslcmtcd2;
    params.rsvno = rsvno;
    params.resultDetail = resultDetail;
    params.rslListData = rslListData;
    if (!updateFlg) {
      yield call(resultService.updateResultForDetail, params);
    }


    let blnEchoFlg;
    let blnEchoShokenFlg;
    let printFlg = 0;
    while (true) {
      // 超音波検査表が出力対象となっていない場合は何もしない
      if (isprintbutton !== '1') {
        break;
      }

      // 有所見者の超音波検査表を自動で出力しない場合は何もしない
      if (echo !== '1') {
        break;
      }

      // 超音波正常所見を判断するための項目情報を汎用テーブルから取得する
      let echoItemData;
      let echoStcData;
      try {
        params.mode = 1;
        params.freecd = '000023';
        echoItemData = yield call(freeService.getFree, params);
      } catch (error) {
        break;
      }

      // 超音波正常所見を判断するための文章コード情報を汎用テーブルから取得する
      try {
        params.mode = 1;
        params.freecd = 'ECHOSKN';
        echoStcData = yield call(freeService.getFree, params);
      } catch (error) {
        break;
      }

      for (let j = 0; j < rslListData.length; j += 1) {
        while (true) {
          // 依頼、または結果が存在しなければスキップ
          if (rslListData[j].consultflg !== '1' || rslListData[j].result !== '') {
            break;
          }
          // 超音波正常所見判断項目であるかを判定
          blnEchoFlg = false;
          for (let k = 0; k < echoItemData.length; k += 1) {
            if (echoItemData[k].freefield1 === rslListData[j].itemcd && echoItemData[k].freefield2 === rslListData[j].suffix && echoItemData[k].freefield3 !== null) {
              blnEchoFlg = true;
              break;
            }
          }

          // 超音波正常所見判断項目でなければスキップ
          if (!blnEchoFlg) {
            break;
          }

          // 結果が存在しない場合はスキップ
          if (rslListData[j].result === '') {
            break;
          }
          // 検査結果が超音波正常所見コードであるかを判定
          blnEchoShokenFlg = false;
          for (let k = 0; k < echoStcData.length; k += 1) {
            if (echoStcData[k].freefield1 === rslListData[j].result) {
              blnEchoShokenFlg = true;
              break;
            }
          }

          // この時点ですでに正常所見でないと判断できるならループを抜ける
          if (!blnEchoShokenFlg) {
            break;
          }

          break;
        }
      }
      // 正常所見者であれば何もしない
      if (blnEchoShokenFlg) {
        break;
      }
      printFlg = 1;
      break;
    }

    yield call(onPrint, printFlg);
    const payload = { formData };
    yield put(updateResultForDetailSuccess(payload));
  } catch (error) {
    const payload = { error, formData };
    yield put(updateResultForDetailFailure(payload));
  }
}
// 結果入力の初期化
function* runRslMainShow(action) {
  try {
    const { redirect, params } = action.payload;

    let curRsvNoPrevNext;
    let consultList;
    let lastInfo;
    let message;
    let getData;
    let redirectFlg = false;
    params.needunreceiptconsult = true;
    params.comeonly = true;
    // 管理番号入力チェック
    if (params.cntlno !== null && params.cntlno !== '0' && params.cntlno !== '' && params.cntlno !== undefined) {
      if (params.cntlno.match('^[0-9]+$') === null) {
        message = ['管理番号には1～9999の値を入力して下さい。'];
        yield put(rslMenuCheckData(message));
        return;
      } else if (Number(params.cntlno) > 9999 || Number(params.cntlno) < 1) {
        message = ['管理番号には1～9999の値を入力して下さい。'];
        yield put(rslMenuCheckData(message));
        return;
      }
    }
    // 当日ID入力チェック
    if (params.dayid !== null && params.dayid !== '' && params.dayid !== undefined) {
      if (params.dayid.match('^[0-9]+$') === null) {
        message = ['当日ＩＤには1～9999の値を入力して下さい。'];
        yield put(rslMenuCheckData(message));
        return;
      } else if (Number(params.dayid) > 9999 || Number(params.dayid) < 1) {
        message = ['当日ＩＤには1～9999の値を入力して下さい。'];
        yield put(rslMenuCheckData(message));
        return;
      }
    }
    if (params.noprevnext === 1) {
      if (params.cntlno === null) {
        params.cntlno = '0';
      }
      // 受付情報をもとに受診情報を読み込む
      curRsvNoPrevNext = yield call(consultService.getConsultFromReceipt, params);
      curRsvNoPrevNext.dayid = params.dayid;
    } else if (params.rsvno !== null && params.rsvno !== undefined && params.rsvno !== '') {
      curRsvNoPrevNext = yield call(consultService.getConsult, params);
      getData = yield call(consultService.getCurRsvNoPrevNext, params);
      redirectFlg = true;
    } else {
      consultList = yield call(consultService.getConsultList, params);
    }
    // 端末情報を読み込む
    const workstation = yield call(workStationService.getWorkstation);
    if (params.mode === null || params.mode === '' || params.mode === undefined) {
      params.mode = 0;
    }
    if (params.rsvno === undefined && curRsvNoPrevNext && curRsvNoPrevNext !== '') {
      params.rsvno = curRsvNoPrevNext.rsvno;
    }
    if (params.code === undefined || params.code === null || params.code === '') {
      if (workstation !== '') {
        params.code = workstation.wkstngrpcd;
      } else {
        params.code = 'all';
      }
    }
    // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
    const rslListData = yield call(resultService.getRslList, params);
    // 前回予約番号が存在する場合
    if (rslListData && rslListData.item[0].lastrsvno !== null) {
      let conditions = { rsvno: rslListData.item[0].lastrsvno };
      const consultData = yield call(consultService.getConsult, conditions);
      conditions = { cscd: consultData.cscd };
      // コース略称取得
      const courseData = yield call(courseService.getCourse, conditions);

      lastInfo = `${moment(consultData.csldate).format('YYYY/MM/DD')}:${courseData.cssname}`;
    }
    let codename = null;
    if (params.mode === 1) {
      // 判定分類名称読み込み
      const judclass = yield call(judClassService.getJudClass, params.code).codename;
      codename = judclass.judclassname;
    } else if (params.mode === 2) {
      // 進捗分類名称読み込み
      const progress = yield call(progressService.getProgress, params.code);
      codename = progress.progressname;
    }
    // 検索条件を満たす受診者処理実行
    const payload = { consultList, params, curRsvNoPrevNext, rslListData, lastInfo, getData, workstation, codename };

    yield put(rslDailyListLoad(payload));
    // 次のURLへ遷移
    if (!redirectFlg) {
      yield call(redirect);
    }
  } catch (error) {
    yield put(rslDailyListLoadFailure());
  }
}

// 検索条件を満たす受診者の一覧を取得
function* rungetConsultList(action) {
  try {
    // 検索条件を満たす受診者処理実行
    const conditions = action.payload;
    conditions.needunreceiptconsult = true;
    conditions.comeonly = true;
    const consultList = yield call(consultService.getConsultList, conditions);
    const payload = { data: consultList.data, totalCount: consultList.totalCount, conditions: action.payload };
    yield put(getConsultListSuccess(payload));
  } catch (error) {
    yield put(getConsultListFailure(error.response));
  }
}
// 結果入力の前後受診者の入力画面へ
function* runGetCurRsvNoPrevNextDetail(action) {
  try {
    // 検索条件を満たす受診者処理実行
    const { state, rslDailyListHeaderConditions, csldate, cscd, sortkey, cntlno } = action.payload;
    let conditionFlg = false;
    // 検索条件が変更されている場合は何もしない
    if (csldate !== undefined && rslDailyListHeaderConditions.csldate !== csldate) {
      conditionFlg = true;
    } else if (cscd !== undefined && rslDailyListHeaderConditions.cscd !== cscd) {
      conditionFlg = true;
    } else if (sortkey !== undefined && rslDailyListHeaderConditions.sortkey !== sortkey) {
      conditionFlg = true;
    } else if (cntlno !== undefined && rslDailyListHeaderConditions.cntlno !== cntlno) {
      conditionFlg = true;
    }

    if (conditionFlg) {
      const message = ['一覧の条件が変更されているので、前次受診者遷移を行うことができません。'];
      yield put(checkCondition(message));
      return;
    }

    let getData;
    getData = yield call(consultService.getCurRsvNoPrevNext, action.payload);
    const params = action.payload;
    if (state === 1) {
      params.rsvno = getData.prevrsvno;
      params.dayid = getData.prevdayid;
    } else {
      params.rsvno = getData.nextrsvno;
      params.dayid = getData.nextdayid;
    }
    const curRsvNoPrevNext = yield call(consultService.getConsult, params);
    if (params.code === null || params.code === '' || params.code === undefined) {
      params.code = 'all';
    }
    // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
    const rslListData = yield call(resultService.getRslList, params);
    let lastInfo;
    getData = yield call(consultService.getCurRsvNoPrevNext, params);

    // 前回予約番号が存在する場合
    if (rslListData && rslListData.item[0].lastrsvno !== null) {
      let conditions = { rsvno: rslListData.item[0].lastrsvno };
      const consultData = yield call(consultService.getConsult, conditions);
      conditions = { cscd: consultData.cscd };
      // コース略称取得
      const courseData = yield call(courseService.getCourse, conditions);

      lastInfo = `${moment(consultData.csldate).format('YYYY/MM/DD')}:${courseData.cssname}`;
    }

    const payload = { curRsvNoPrevNext, rslListData, lastInfo, getData, params };

    yield put(getCurRsvNoPrevNextSuccess(payload));
  } catch (error) {
    yield put(getCurRsvNoPrevNextFailure(error.response));
  }
}

// 来院済み受診者のみ対象
function* runConsultListCheckRequest(action) {
  const { cntlNo, cscd, grpcd, cslDate, dayIdF, dayIdT } = action.payload;
  const checkparam = {};
  try {
    checkparam.cntlNo = cntlNo;
    checkparam.cscd = cscd;
    checkparam.grpcd = grpcd;
    checkparam.cslDate = cslDate;
    checkparam.comeOnly = true;
    if (!dayIdF) {
      checkparam.startDayId = '0000';
    } else {
      checkparam.startDayId = dayIdF;
    }
    if (!dayIdT) {
      checkparam.endDayId = '9999';
    } else {
      checkparam.endDayId = dayIdT;
    }
    const year = action.payload.cslDate.split('/')[0];
    const month = action.payload.cslDate.split('/')[1];
    const day = action.payload.cslDate.split('/')[2];
    const fromBody = {};
    fromBody.year = year;
    fromBody.month = month;
    fromBody.day = day;
    fromBody.dayIdF = checkparam.startDayId;
    fromBody.dayIdT = checkparam.endDayId;
    const conditions = { ...action.payload, data: fromBody };
    const payloadResult = yield call(resultService.checkRslAllSet1Value, conditions);
    if (payloadResult === null) {
      if (dayIdF) {
        if (dayIdF.length === 1) {
          checkparam.dayIdF = `000${dayIdF}`;
        } else if (dayIdF.length === 2) {
          checkparam.dayIdF = `00${dayIdF}`;
        } else if (dayIdF.length === 3) {
          checkparam.dayIdF = `0${dayIdF}`;
        } else {
          checkparam.dayIdF = dayIdF;
        }
      }
      if (dayIdT) {
        if (dayIdF.length === 1) {
          checkparam.dayIdT = `000${dayIdT}`;
        } else if (dayIdT.length === 2) {
          checkparam.dayIdT = `00${dayIdT}`;
        } else if (dayIdT.length === 3) {
          checkparam.dayIdT = `0${dayIdT}`;
        } else {
          checkparam.dayIdT = dayIdT;
        }
      }
      const payload = yield call(consultService.getConsultList, checkparam);
      payload.checkParam = checkparam;
      yield put(getConsultListItemSuccess(payload));
      if (payload && payload.totalCount && payload.totalCount > 0) {
        yield put(getItemResultsSuccess([]));
        action.payload.props.onNext();
      } else {
        yield put(getConsultListItemFailure(checkparam));
        yield put(getItemResultsSuccess(['指定検査グループの検査を受診している来院済み受診者が存在しません。']));
        return;
      }
    } else {
      checkparam.dayIdF = dayIdF;
      checkparam.dayIdT = dayIdT;
      checkparam.message = payloadResult.errorMessage;
      yield put(getConsultListCheckFailure(checkparam));
    }
  } catch (error) {
    yield put(getConsultListItemFailure(checkparam));
  }
}
// 内視鏡チェックリスト入力ガイド初期表示情報取得Action発生時に起動するメソッド
function* runOpenNaishikyouCheckGuide(action) {
  const { params } = action.payload;
  const { rsvno } = params;
  let consultdata = null;
  let historyrsldata = null;
  let realage = null;
  let message = [];
  let rslgrpcd = null;
  let strcscd = null;
  const checkitems = {};
  try {
    // 受診情報取得処理実行
    consultdata = yield call(consultService.getConsult, params);
    const { csldate, birth, cscd } = consultdata;
    strcscd = cscd;
    if (moment(csldate).format('YYYY/MM/DD') >= moment(constants.CHANGE_CSLDATE).format('YYYY/MM/DD')) {
      rslgrpcd = constants.GRPCD_NAISHIKYOU_NEW;
    } else {
      rslgrpcd = constants.GRPCD_NAISHIKYOU;
    }
    // 実年齢の計算
    if (birth !== null && birth !== '') {
      const calcage = yield call(freeService.calcAge, { birth });
      const { realAge } = calcage;
      if (realAge !== null) {
        realage = Number.parseInt(realAge, 10);
      }
    }
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    message = [`受診情報が存在しません。（予約番号 = ${rsvno})`];
    yield put(getNaishikyouCheckFailure({ message }));
  }
  try {
    // 指定対象受診者の検査結果を取得する
    historyrsldata = yield call(interviewService.getHistoryRslList, {
      ...action.payload,
      rsvno,
      hisCount: constants.HISCOUNT,
      grpcd: rslgrpcd,
      lastDspMode: constants.LAST_DSP_MODE,
      csGrp: strcscd,
      getSeqMode: constants.GETSEQMODE,
      allDataMode: constants.ALLDATAMODE,
    });
    for (let i = 0; i < historyrsldata.length; i += 1) {
      const { seq, rslvalue } = historyrsldata[i];
      checkitems[`opt_${seq}`] = rslvalue;
    }
  } catch (error) {
    // 指定対象受診者の検査結果を取得失敗Actionを発生させる
    message = [`検査結果が取得できません。（予約番号 = ${rsvno})`];
    yield put(getNaishikyouCheckFailure({ message }));
  }
  // 内視鏡チェックリスト入力ガイド初期表示情報取得成功Actionを発生させる
  yield put(getNaishikyouCheckSuccess({ consultdata, historyrsldata, realage, checkitems, rsvno }));
}

// ワークシート形式の結果入力
function* runConsultSetList(action) {
  const { grpcd, cslDate, dayIdF, getCount, sortKey, flagBoo } = action.payload;
  let { page } = action.payload;
  if (!page) {
    page = 1;
  }
  if (getCount === '1') {
    page = 0;
  }
  const checkparam = {};
  try {
    checkparam.cntlNo = '';
    checkparam.cscd = '';
    checkparam.grpcd = grpcd;
    checkparam.cslDate = cslDate;
    checkparam.startPos = 1;
    checkparam.limit = getCount;
    checkparam.getCount = getCount;
    checkparam.sortKey = sortKey;
    checkparam.comeOnly = true;
    if (!dayIdF) {
      checkparam.startDayId = '0000';
    } else {
      checkparam.startDayId = dayIdF;
    }
    checkparam.endDayId = '9999';
    const year = action.payload.cslDate.split('/')[0];
    const month = action.payload.cslDate.split('/')[1];
    const day = action.payload.cslDate.split('/')[2];
    const fromBody = {};
    fromBody.year = year;
    fromBody.month = month;
    fromBody.day = day;
    fromBody.dayIdF = checkparam.startDayId;
    fromBody.dayIdT = checkparam.endDayId;
    const conditions = { ...action.payload, data: fromBody };
    const payloadResult = yield call(resultService.checkRslAllSet1Value, conditions);

    if (payloadResult === null) {
      if (dayIdF) {
        if (dayIdF.length === 1) {
          checkparam.dayIdF = `000${dayIdF}`;
        } else if (dayIdF.length === 2) {
          checkparam.dayIdF = `00${dayIdF}`;
        } else if (dayIdF.length === 3) {
          checkparam.dayIdF = `0${dayIdF}`;
        } else {
          checkparam.dayIdF = dayIdF;
        }
      }
      // 検索結果が存在
      const payloadAll = yield call(consultService.getConsultList, checkparam);
      const count = payloadAll.totalCount;
      total = count;
      checkparam.page = page;
      const payload = yield call(consultService.getConsultList, checkparam);
      // グループ内検査項目を取得
      const payloadTitle = yield call(groupService.GetGrpIItemList, action.payload);
      const result = {};
      const data = {};
      const rsvNo = [];
      const lastName = [];
      const firstName = [];
      if (payload.data && payload.data && payload.data.length > 0) {
        const arr = payload.data;
        // 検索結果が存在しない場合はメッセージを編集
        for (let i = 0; i < arr.length; i += 1) {
          rsvNo.push(arr[i].rsvno);
          lastName.push(arr[i].lastname);
          firstName.push(arr[i].firstname);
        }
      }
      result.rsvno = rsvNo;
      result.firstName = firstName;
      result.lastName = lastName;
      data.result = result;
      data.grpCd = checkparam.grpcd;
      const payloadList = yield call(resultService.getRslListSet, data);
      if (payloadList.resultData && payloadList.resultData.length > 0) {
        const resultArr = payloadList.resultData;
        const infoArr = payload.data;
        const num = resultArr.length / infoArr.length;
        for (let i = 0; i < infoArr.length; i += 1) {
          const list = [];
          for (let j = num * i; j < num * i + num; j += 1) {
            infoArr[i].result = {};
            list.push(resultArr[j]);
            infoArr[i].result = list;
          }
        }
      }
      payload.title = payloadTitle.data;
      payload.cslDate = checkparam.cslDate;
      payload.dayIdF = checkparam.startDayId === '0000' ? '' : checkparam.startDayId;
      payload.getCount = checkparam.limit;
      payload.sortKey = checkparam.sortKey;
      payload.grpcd = checkparam.grpcd;
      payload.newDate = checkparam.cslDate.replace('/', '年').replace('/', '月');
      payload.count = count;
      payload.cruPage = page * getCount;
      payload.page = page;
      payload.flagBoo = !flagBoo;
      yield put(getConsultSetListSuccess(payload));
    } else {
      // チェックエラー時は処理を抜ける
      checkparam.dayIdF = dayIdF;
      checkparam.message = payloadResult.errorMessage;
      const errArr = checkparam.message;
      if (errArr) {
        for (let i = 0; i < errArr.length; i += 1) {
          if (errArr[i]) {
            errArr[i] = errArr[i].replace('（自）', '');
          }
        }
      }
      yield put(getRslAllSetValueFailure(checkparam));
    }
  } catch (error) {
    yield put(getConsultSetListFailure(checkparam));
  }
}

// 検査結果更新
function* runUpdateRslListSet(action) {
  try {
    // 結果入力チェック
    const infoList = action.payload.resultData;
    const { cslDate } = action.payload;
    const results = [];
    const fromBody = {};
    for (let i = 0; i < infoList.length; i += 1) {
      const arrItem = infoList[i].result;
      for (let j = 0; j < arrItem.length; j += 1) {
        const result = {};
        result.itemcd = arrItem[j].itemcd;
        result.suffix = arrItem[j].suffix;
        result.result = arrItem[j].result;
        results.push(result);
        arrItem[j].resulterror = null;
      }
    }
    fromBody.cslDate = cslDate.replace('/', '-').replace('/', '-');
    fromBody.results = results;
    const conditions = { data: fromBody };
    const payloadMsg = yield call(resultService.checkResult, conditions);
    const { resultData } = action.payload;
    // エラーが存在する場合
    if (payloadMsg.messageData.messages) {
      const errlist = payloadMsg.messageData.results;
      const errInfo = [];
      for (let j = 0; j < infoList.length; j += 1) {
        const rl = infoList[j].result;
        for (let k = 0; k < rl.length; k += 1) {
          rl[k].resulterror = errlist[j * rl.length + k].resulterror;
          if (errlist[j * rl.length + k].resulterror) {
            errInfo.push(infoList[j]);
          }
        }
      }
      // 検査結果処理実行
      payloadMsg.count = total;
      payloadMsg.title = action.payload.title;
      payloadMsg.cslDate = action.payload.cslDate;
      payloadMsg.dayIdF = action.payload.dayIdF;
      payloadMsg.getCount = action.payload.getCount;
      payloadMsg.sortKey = action.payload.sortKey;
      payloadMsg.grpcd = action.payload.grpcd;
      payloadMsg.newDate = action.payload.newDate;
      payloadMsg.data = resultData;
      if (errInfo.length === payloadMsg.messageData.messages.length) {
        for (let j = 0; j < payloadMsg.messageData.messages.length; j += 1) {
          payloadMsg.messageData.messages[j] = `${errInfo[j].lastname} ${errInfo[j].firstname} ${payloadMsg.messageData.messages[j]}`;
        }
        payloadMsg.message = payloadMsg.messageData.messages;
      } else {
        payloadMsg.message = payloadMsg.messageData.messages;
      }
      // 結果が初期表示時の値から更新されていたらデータ更新
      yield put(getUpdateRslListSetSuccess(payloadMsg));
    } else {
      // 検証による保存
      let add = -1;
      for (let i = 0; i < infoList.length; i += 1) {
        const rec = [];
        const resultitems = {};
        const arrItem = infoList[i].result;
        // 実際に更新を行う項目のみを抽出(結果未入力でチェックなしの項目以外が更新対象)
        for (let j = 0; j < arrItem.length; j += 1) {
          const r = {};
          add += 1;
          if (arrItem[j].resulttype !== 5 && arrItem[j].result) {
            r.itemcd = arrItem[j].itemcd;
            r.suffix = arrItem[j].suffix;
            r.result = payloadMsg.messageData.results[add].result;
            r.rsvno = infoList[i].rsvno;
            rec.push(r);
          }
        }
        resultitems.resultitems = rec;
        const conditionsSave = { data: resultitems };
        yield call(resultService.updateResultList, conditionsSave);
      }
      const { payload } = action;
      payload.data = resultData;
      payload.count = total;
      payload.message = ['保存が完了しました。'];
      yield put(getReloadConsultSetList(action.payload));
    }
  } catch (error) {
    yield put(getConsultListFailure(error.response));
  }
}

// 端末情報を読み込む
function* runGetRslListSetList() {
  try {
    const workstation = yield call(workStationService.getWorkstation);
    if (workstation !== '') {
      yield put(getRslListSetListSuccess(workstation));
    } else {
      const param = {};
      param.grpcd = 'G010';
      yield put(getRslListSetListSuccess(param));
    }
  } catch (error) {
    yield put(getRslListSetListFailure(error.response));
  }
}

// ワークシート形式の結果入力
function* runReloadConsultSetList(action) {
  const { grpcd, cslDate, dayIdF, getCount, sortKey, page } = action.payload;
  const checkparam = {};
  try {
    checkparam.cntlNo = '';
    checkparam.cscd = '';
    checkparam.grpcd = grpcd;
    checkparam.cslDate = cslDate;
    checkparam.startPos = 1;
    checkparam.limit = getCount;
    checkparam.getCount = getCount;
    checkparam.sortKey = sortKey;
    checkparam.comeOnly = true;
    if (!dayIdF) {
      checkparam.startDayId = '0000';
    } else {
      checkparam.startDayId = dayIdF;
    }
    checkparam.endDayId = '9999';
    if (dayIdF) {
      if (dayIdF.length === 1) {
        checkparam.dayIdF = `000${dayIdF}`;
      } else if (dayIdF.length === 2) {
        checkparam.dayIdF = `00${dayIdF}`;
      } else if (dayIdF.length === 3) {
        checkparam.dayIdF = `0${dayIdF}`;
      } else {
        checkparam.dayIdF = dayIdF;
      }
    }
    checkparam.page = page;
    const payload = yield call(consultService.getConsultList, checkparam);
    const count = payload.totalCount;
    total = count;
    const result = {};
    const data = {};
    const rsvNo = [];
    const lastName = [];
    const firstName = [];
    if (payload.data && payload.data && payload.data.length > 0) {
      const arr = payload.data;
      // 検索結果が存在しない場合はメッセージを編集
      for (let i = 0; i < arr.length; i += 1) {
        rsvNo.push(arr[i].rsvno);
        lastName.push(arr[i].lastname);
        firstName.push(arr[i].firstname);
      }
    }
    result.rsvno = rsvNo;
    result.firstName = firstName;
    result.lastName = lastName;
    data.result = result;
    data.grpCd = checkparam.grpcd;
    const payloadList = yield call(resultService.getRslListSet, data);
    if (payloadList.resultData && payloadList.resultData.length > 0) {
      const resultArr = payloadList.resultData;
      const infoArr = payload.data;
      const num = resultArr.length / infoArr.length;
      for (let i = 0; i < infoArr.length; i += 1) {
        const list = [];
        for (let j = num * i; j < num * i + num; j += 1) {
          infoArr[i].result = {};
          list.push(resultArr[j]);
          infoArr[i].result = list;
        }
      }
    }
    payload.title = action.payload.title;
    payload.cslDate = checkparam.cslDate;
    payload.dayIdF = checkparam.startDayId === '0000' ? '' : checkparam.startDayId;
    payload.getCount = checkparam.limit;
    payload.sortKey = checkparam.sortKey;
    payload.grpcd = checkparam.grpcd;
    payload.newDate = checkparam.cslDate.replace('/', '年').replace('/', '月');
    payload.count = count;
    payload.cruPage = page * getCount;
    payload.page = page;
    payload.message = ['保存が完了しました。'];
    yield put(getConsultSetListSuccess(payload));
  } catch (error) {
    yield put(getConsultSetListFailure(checkparam));
  }
}

// 検査結果テーブルを更新(コメント更新なし)Action発生時に起動するメソッド
function* runUpdateResultNoCmt(action) {
  const { params, data } = action.payload;
  const { historyrsldata } = params;
  const itemcd = [];
  const suffix = [];
  const rslvalue = [];
  let count = 0;
  let seq = 1;
  while (count < historyrsldata.length && historyrsldata.length > 0) {
    itemcd[count] = historyrsldata[count].itemcd;
    suffix[count] = historyrsldata[count].suffix;
    rslvalue[count] = data[`opt_${seq}`];
    seq += 1;
    count += 1;
  }
  const resultNoCmt = {};
  resultNoCmt.itemcd = itemcd;
  resultNoCmt.suffix = suffix;
  resultNoCmt.rslvalue = rslvalue;
  params.resultNoCmt = resultNoCmt;
  try {
    // 検査結果更新成功Actionを発生させる
    yield put(updateResultNoCmtSuccess());
    // 検査結果更新処理実行
    yield call(resultService.updateResultNoCmt, params);
  } catch (error) {
    yield put(updateResultNoCmtFailure(error.response));
    return;
  }
  try {
    // 検査結果更新処理実行
    yield call(resultService.updateYudo, params);
    // 胃内視鏡の依頼があるかチェックする
    yield call(questionnaireService.checkGF, params);
  } catch (error) {
    // 内視鏡チェックリストの状態取得失敗Actionを発生させる
    yield put(getCheckGFFailure(error.response));
  }
}

const resultSagas = [
  takeEvery(rslMainLoadRequest.toString(), runrslMenuLoad),
  takeEvery(getRslRequest.toString(), runRequestRsl),
  // 検査結果更新
  takeEvery(registerResultRequest.toString(), runRegisterResult),
  takeEvery(registerEntryAutherRequest.toString(), runRegisterEntryAuther),
  takeEvery(getProgressListRequest.toString(), runGetProgressList),
  takeEvery(getProgressNameRequest.toString(), runGetProgressName),
  takeEvery(getUpdateResultAll.toString(), runUpdateResultAll),
  takeEvery(getRslAllSetListRequest.toString(), runRslAllSetList),
  takeEvery(getReloadResultListRequest.toString(), runReloadResultList),
  takeEvery(getCheckResultThenSave.toString(), runCheckResultThenSave),
  takeEvery(openEntryAutherGuide.toString(), runOpenEntryAutherGuide),
  takeEvery(getSubEntitySpJudRequest.toString(), runGetSubEntitySpJudRequest),
  takeEvery(updateEntitySpJudRequest.toString(), runUpdateEntitySpJudRequest),
  takeEvery(rslMainShowRequest.toString(), runRslMainShow),
  takeEvery(updateResultForDetailRequest.toString(), runUpdateResultForDetail),
  takeEvery(getConsultListRequest.toString(), rungetConsultList),
  takeEvery(getCurRsvNoPrevNextRequest.toString(), runGetCurRsvNoPrevNextDetail),
  takeEvery(getConsultListCheckRequest.toString(), runConsultListCheckRequest),
  takeEvery(getConsultSetList.toString(), runConsultSetList),
  takeEvery(updateRslListSet.toString(), runUpdateRslListSet),
  takeEvery(getReloadConsultSetList.toString(), runReloadConsultSetList),
  takeEvery(openNaishikyouCheckGuide.toString(), runOpenNaishikyouCheckGuide),
  takeEvery(updateResultNoCmtRequest.toString(), runUpdateResultNoCmt),
  takeEvery(getGrpcdResult.toString(), runGetGrpcdResult),
  takeEvery(getRslListSetList.toString(), runGetRslListSetList),
];

export default resultSagas;
