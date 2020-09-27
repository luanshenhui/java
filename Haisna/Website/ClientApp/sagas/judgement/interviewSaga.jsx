import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import moment from 'moment';
import interviewService from '../../services/judgement/interviewService';
import consultService from '../../services/reserve/consultService';
import pubNoteService from '../../services/preference/pubNoteService';
import followService from '../../services/followup/followService';
import specialInterviewService from '../../services/judgement/specialinterviewService';
import perResultService from '../../services/preference/perResultService';
import freeService from '../../services/preference/freeService';
import judgementService from '../../services/judgement/judgementService';
import { getMenResultGrpInfo } from '../../containers/judgement/InterviewResult';
import resultService from '../../services/result/resultService';
import judgementControllService from '../../services/judgement/judgementControllService';

import * as constants from '../../constants/common';

import {
  getInterviewConsultRequest,
  getInterviewConsultSuccess,
  getInterviewConsultFailure,
  getHistoryRslLifeRequest,
  getHistoryRslLifeSuccess,
  getHistoryRslLifeFailure,
  getHistoryRslSelfRequest,
  getHistoryRslSelfSuccess,
  getHistoryRslSelfFailure,
  selectJudHistoryRslListSuccess,
  selectJudHistoryRslListFailure,
  getTotalJudCmtSuccess,
  getTotalJudCmtFailure,
  getHistoriesRequest,
  getHistoryRslSuccess,
  getHistoryRslFailure,
  getHistoryRslDisSuccess,
  getHistoryRslDisFailure,
  getHistoryRslJikakuSuccess,
  getHistoryRslJikakuFailure,
  getPubNoteChartSuccess,
  getPubNoteChartFailure,
  getPubNoteCautionSuccess,
  getPubNoteCautionFailure,
  getFollowBeforeSuccess,
  getFollowBeforeFailure,
  getFollowInfoSuccess,
  getFollowInfoFailure,
  getTargetFollowSuccess,
  getTargetFollowFailure,
  getSetClassCdSuccess,
  getSetClassCdFailure,
  getConsultHistorySuccess,
  getConsultHistoryFailure,
  getCsGrpRequest,
  getCsGrpSuccess,
  getCsGrpFailure,
  getOrderNo1Request,
  getOrderNo1Success,
  getOrderNo1Failure,
  getOrderNo2Request,
  getOrderNo2Success,
  getOrderNo2Failure,
  getOrderNo3Request,
  getOrderNo3Success,
  getOrderNo3Failure,
  getChangePerIdRequest,
  getChangePerIdSuccess,
  getChangePerIdFailure,
  getUpdateLogListRequest,
  getUpdateLogListSuccess,
  getUpdateLogListFailure,
  getHistoryRslListRequest,
  getHistoryRslListSuccess,
  getHistoryRslListFailure,
  getPatientHistoryRequest,
  getPatientHistorySuccess,
  getPatientHistoryFailure,
  getDiseaseHistoryRequest,
  getDiseaseHistorySuccess,
  getDiseaseHistoryFailure,
  updateTotalJudCmtRequest,
  updateTotalJudCmtSuccess,
  updateTotalJudCmtFailure,
  getEntryRecogLevelList,
  getEntryListSuccess,
  getEntryListFailure,
  getCsGrpDataRequest,
  getCsGrpDataSuccess,
  getCsGrpDataFailure,
  getViewOldConsultHistoryRequest,
  getViewOldConsultHistorySuccess,
  getViewOldConsultHistoryFailure,
  getViewOldTotalJudCmtSuccess,
  getViewOldTotalJudCmtFailure,
  getInterviewHeaderRequest,
  getInterviewHeaderSuccess,
  getInterviewHeaderFailure,
  getConsultHistoryJudHeaderRequest,
  getConsultHistoryJudHeaderSuccess,
  getConsultHistoryJudHeaderFailure,
  getConsultHistoryMenResultRequest,
  getConsultHistoryMenResultSuccess,
  getConsultHistoryMenResultFailure,
  getHistoryRslListMenResultRequest,
  getHistoryRslListMenResult1Success,
  getHistoryRslListMenResult1Failure,
  getHistoryRslListMenResult3Success,
  getHistoryRslListMenResult3Failure,
  openMenFoodCommentGuide,
  updateJudCmtRequest,
  getVer201210Success,
  getVer201210Failure,
  getTotalJudEditBodyRequest,
  getMdrdHistorySuccess,
  getMdrdHistoryFailure,
  getNewGfrHistorySuccess,
  getNewGfrHistoryFailure,
  getJudListSuccess,
  getJudListFailure,
  saveTotalJudRequest,
  saveTotalJudSuccess,
  saveTotalJudFailure,
  getFollowUpHeaderRequest,
  getFollowUpHeaderSuccess,
  getFollowUpHeaderFailure,
  updateEntryListSuccess,
  getShokusyukanListRequest,
  getShokusyukanListSuccess,
  getShokusyukanListFailure,
  calcRequest,
  calcRequestSuccess,
  calcRequestFailure,
} from '../../modules/judgement/interviewModule';

// グローバル変数
let indexflag = '0';
let itemName = '';
let listArr = [];
const items = [{ value: '', name: '' },
  { value: '1', name: '☆' },
  { value: '2', name: '☆☆' },
  { value: '3', name: '☆☆☆' },
  { value: '4', name: '☆☆☆☆' },
  { value: '5', name: '☆☆☆☆☆' },
  { value: '0', name: '面接未実施' }];

// 受診情報取得Action発生時に起動するメソッド
function* runRequestInterviewConsult(action) {
  try {
    // 受診情報取得処理実行
    const payload = yield call(consultService.getConsult, action.payload);
    // 受診情報取得成功Actionを発生させる
    yield put(getInterviewConsultSuccess(payload));
  } catch (error) {
    const { rsvno } = action.payload;
    // 受診情報取得失敗Actionを発生させる
    yield put(getInterviewConsultFailure({ ...error.response, rsvno }));
  }
}

// 質問内容情報取得Action発生時に起動するメソッド
function* runRequestHistoryRslLife(action) {
  try {
    // 質問内容情報取得処理実行
    const payload = yield call(interviewService.getHistoryRslList, action.payload);
    // 質問内容情報取得成功Actionを発生させる
    yield put(getHistoryRslLifeSuccess(payload));
  } catch (error) {
    // 質問内容情報取得失敗Actionを発生させる
    yield put(getHistoryRslLifeFailure(error.response));
  }
}

// 自覚症状情報取得Action発生時に起動するメソッド
function* runRequestHistoryRslSelf(action) {
  try {
    // 自覚症状情報取得処理実行
    const payload = yield call(interviewService.getHistoryRslList, action.payload);
    // 自覚症状情報取得成功Actionを発生させる
    yield put(getHistoryRslSelfSuccess(payload));
  } catch (error) {
    // 自覚症状情報取得失敗Actionを発生させる
    yield put(getHistoryRslSelfFailure(error.response));
  }
}

// 受診情報一覧を取得するメソッド
function* runRequestHistories(action) {
  // 今回コースコード退避
  let strCsCd = '';
  let params;
  try {
    // 受診歴一覧を取得する処理実行
    params = { ...action.payload, getRowCount: 3 };
    const payload = yield call(interviewService.GetConsultHistory, params);
    if (payload.consultHistoryData && payload.consultHistoryData.length > 0) {
      strCsCd = payload.consultHistoryData[0].cscd;
    }
    // 受診歴一覧を取得する成功Actionを発生させる
    yield put(getConsultHistorySuccess(payload));
  } catch (error) {
    // 受診歴一覧を取得する失敗Actionを発生させる
    yield put(getConsultHistoryFailure(error.response));
    return;
  }

  try {
    // 判定結果一覧を取得処理実行
    params = { ...action.payload, hisCount: 3, seqMode: 1 };
    const payloadJudHistoryRsl = yield call(interviewService.selectJudHistoryRslList, params);
    // 判定結果一覧を取得成功Actionを発生させる
    yield put(selectJudHistoryRslListSuccess(payloadJudHistoryRsl));
  } catch (error) {
    // 判定結果一覧を取得失敗Actionを発生させる
    yield put(selectJudHistoryRslListFailure(error.response));
    return;
  }

  try {
    // 判定医を取得処理実行
    params = { rsvno: action.payload.rsvNo, hisCount: 1, grpcd: 'X049', lastDspMode: action.payload.lastDspMode, csgrp: action.payload.csGrp, getSeqMode: 0 };
    const payloadHistoryRsl = yield call(interviewService.getHistoryRslList, params);
    // 判定医を取得成功Actionを発生させる
    yield put(getHistoryRslSuccess(payloadHistoryRsl));
  } catch (error) {
    // 判定医を取得失敗Actionを発生させる
    yield put(getHistoryRslFailure(error.response));
  }

  try {
    // 病歴を取得処理実行
    params = { ...action.payload, hisCount: 1, getSeqMode: 0, grpCd: 'X026', csGrp: strCsCd };
    const payloadHistoryRslDis = yield call(interviewService.getHistoryRslListDis, params);
    // 病歴を取得成功Actionを発生させる
    yield put(getHistoryRslDisSuccess(payloadHistoryRslDis));
  } catch (error) {
    // 病歴を取得失敗Actionを発生させる
    yield put(getHistoryRslDisFailure(error.response));
  }

  try {
    // 自覚症状を取得処理実行
    params = { ...action.payload, hisCount: 1, getSeqMode: 0, grpCd: 'X025', csGrp: strCsCd, selectMode: 0, allDataMode: 0 };
    const payloadHistoryRslJikaku = yield call(interviewService.getHistoryRslListJikaku, params);
    // 自覚症状を取得成功Actionを発生させる
    yield put(getHistoryRslJikakuSuccess(payloadHistoryRslJikaku));
  } catch (error) {
    // 自覚症状を取得失敗Actionを発生させる
    yield put(getHistoryRslJikakuFailure(error.response));
  }

  try {
    // 総合コメントを取得する処理実行
    params = { ...action.payload, dispMode: 1, hisCount: 1, csGrp: strCsCd, lastDspMode: 1, selectMode: 0 };
    const payloadTotalJudCmt = yield call(interviewService.getTotalJudCmt, params);
    // 総合コメントを取得する成功Actionを発生させる
    yield put(getTotalJudCmtSuccess(payloadTotalJudCmt));
  } catch (error) {
    // 総合コメントを取得する失敗Actionを発生させる
    yield put(getTotalJudCmtFailure(error.response));
  }

  try {
    // チャート情報を取得する処理実行
    params = { ...action.payload, selInfo: 0, histFlg: 0, seq: 0, pubNoteDivCd: 500, dispKbn: 1 };
    const payloadPubNote = yield call(pubNoteService.getPubNote, params);
    // チャート情報を取得する成功Actionを発生させる
    yield put(getPubNoteChartSuccess(payloadPubNote));
  } catch (error) {
    // チャート情報を取得する失敗Actionを発生させる
    yield put(getPubNoteChartFailure(error.response));
  }

  try {
    // 注意事項を取得する処理実行
    params = { ...action.payload, selInfo: 0, histFlg: 0, seq: 0, pubNoteDivCd: 100, dispKbn: 1 };
    const payloadgetPubNoteNotice = yield call(pubNoteService.getPubNote, params);
    // 注意事項を取得する成功Actionを発生させる
    yield put(getPubNoteCautionSuccess(payloadgetPubNoteNotice));
  } catch (error) {
    // 注意事項を取得する失敗Actionを発生させる
    yield put(getPubNoteCautionFailure(error.response));
  }

  try {
    // 前回フォロー情報を取得する処理実行
    params = { rsvno: action.payload.rsvNo };
    const payloadbefore = yield call(followService.getFollowBefore, params);
    // 前回フォロー情報を取得する成功Actionを発生させる
    yield put(getFollowBeforeSuccess({ followBeforeData: payloadbefore }));
  } catch (error) {
    // 前回フォロー情報を取得する失敗Actionを発生させる
    yield put(getFollowBeforeFailure(error.response));
  }

  try {
    // フォローアップ情報を取得する処理実行
    params = { rsvno: action.payload.rsvNo, judclasscd: 999 };
    const payloadFollowInfo = yield call(followService.getFollowInfo, params);
    // フォローアップ情報を取得する成功Actionを発生させる
    yield put(getFollowInfoSuccess(payloadFollowInfo));
  } catch (error) {
    // フォローアップ情報を取得する失敗Actionを発生させる
    yield put(getFollowInfoFailure(error.response));
  }

  try {
    // フォローアップ対象者を取得する処理実行
    params = { rsvno: action.payload.rsvNo, judflg: true };
    const payloadTargetFollow = yield call(followService.getTargetFollow, params);
    // フォローアップ対象者を取得する成功Actionを発生させる
    yield put(getTargetFollowSuccess(payloadTargetFollow));
  } catch (error) {
    // フォローアップ対象者を取得する失敗Actionを発生させる
    yield put(getTargetFollowFailure(error.response));
  }

  try {
    // 特定健診対象区分を取得する処理実行
    params = { ...action.payload };
    const payloadSetClassCd = yield call(specialInterviewService.getSetClassCd, params);
    // 特定健診対象区分を取得する成功Actionを発生させる
    yield put(getSetClassCdSuccess(payloadSetClassCd));
  } catch (error) {
    // 特定健診対象区分を取得する失敗Actionを発生させる
    yield put(getSetClassCdFailure(error.response));
  }
}

// コースグループを取得するメソッド
function* runRequestCsGrp(action) {
  try {
    // コースグループを取得する処理実行
    const payload = yield call(interviewService.GetCsGrp, action.payload);
    // コースグループを取得する成功Actionを発生させる
    yield put(getCsGrpSuccess(payload));

    const { csGrpData } = payload;
    const { formName } = action.payload;
    if (formName === 'TotalJudView') {
      // コースグループ情報をredux-formへセットするActionを発生させる
      if (csGrpData && csGrpData.length > 0) {
        yield put(initialize(formName, { csgrp: csGrpData[0].csgrpcd }));
      } else {
        yield put(initialize(formName, { csgrp: '0' }));
      }
    }
  } catch (error) {
    // コースグループを取得する失敗Actionを発生させる
    yield put(getCsGrpFailure(error.response));
  }
}

// 指定された予約番号のオーダ番号、送信日を取得する
function* runRequestOrderNo1(action) {
  try {
    // オーダ番号、送信日を取得する処理実行
    const payload = yield call(interviewService.GetOrderNo, action.payload);
    // オーダ番号、送信日を取得する成功Actionを発生させる
    yield put(getOrderNo1Success(payload));
  } catch (error) {
    // オーダ番号、送信日を取得する失敗Actionを発生させる
    yield put(getOrderNo1Failure(error.response));
  }
}

// 指定された予約番号のオーダ番号、送信日を取得する
function* runRequestOrderNo2(action) {
  try {
    // オーダ番号、送信日を取得する処理実行
    const payload = yield call(interviewService.GetOrderNo, action.payload);
    // オーダ番号、送信日を取得する成功Actionを発生させる
    yield put(getOrderNo2Success(payload));
  } catch (error) {
    // オーダ番号、送信日を取得する失敗Actionを発生させる
    yield put(getOrderNo2Failure(error.response));
  }
}

// 指定された予約番号のオーダ番号、送信日を取得する
function* runRequestOrderNo3(action) {
  try {
    // オーダ番号、送信日を取得する処理実行
    const payload = yield call(interviewService.GetOrderNo, action.payload);
    // オーダ番号、送信日を取得する成功Actionを発生させる
    yield put(getOrderNo3Success(payload));
  } catch (error) {
    // オーダ番号、送信日を取得する失敗Actionを発生させる
    yield put(getOrderNo3Failure(error.response));
  }
}

// 変更前のIDと変更後のIDを取得する
function* runRequestChangePerId(action) {
  try {
    // 変更前のIDと変更後のIDを取得する処理実行
    const payload = yield call(interviewService.GetChangePerId, action.payload);
    // 変更前のIDと変更後のIDを取得する成功Actionを発生させる
    yield put(getChangePerIdSuccess(payload));
  } catch (error) {
    // 変更前のIDと変更後のIDを取得する失敗Actionを発生させる
    yield put(getChangePerIdFailure(error.response));
  }
}

// 変更履歴一覧取得Action発生時に起動するメソッド
function* runRequestUpdateLogList(action) {
  try {
    // 変更履歴一覧取得処理実行
    const payload = yield call(interviewService.getUpdateLogList, action.payload);
    // 変更履歴一覧取得成功Actionを発生させる
    yield put(getUpdateLogListSuccess(payload));
  } catch (error) {
    // 変更履歴一覧取得失敗Actionを発生させる
    yield put(getUpdateLogListFailure(error.response));
  }
}

// 指定対象受診者の検査結果歴を取得Action発生時に起動するメソッド
function* runRequestHistoryRslList(action) {
  let perid = null;
  try {
    let consultdata = null;
    let historydata = null;
    const { cscd, rsvno } = action.payload;
    try {
      // 指定予約番号の受診情報を取得する
      consultdata = yield call(consultService.getConsult, action.payload);
    } catch (error) {
      yield put(getInterviewConsultFailure({ ...error.response, rsvno }));
      return;
    }
    ({ perid } = consultdata);
    const newcscd = consultdata.cscd;
    if (cscd == null) {
      historydata = yield call(interviewService.getHistoryRslList, { ...action.payload, cscd: newcscd });
      yield put(getHistoryRslListSuccess({ historydata }));
    } else {
      // 指定対象受診者の検査結果歴を取得処理実行
      historydata = yield call(interviewService.getHistoryRslList, { ...action.payload });
      // 指定対象受診者の検査結果歴を取得成功Actionを発生させる
      yield put(getHistoryRslListSuccess({ historydata }));
    }
  } catch (error) {
    // 指定対象受診者の検査結果歴を取得失敗Actionを発生させる
    yield put(getHistoryRslListFailure({ ...error.response, perid }));
  }
}

// 入院・外来歴を取得Action発生時に起動するメソッド
function* runRequestPatientHistory(action) {
  try {
    let patientdata = null;
    // 入院・外来歴を取得処理実行
    patientdata = yield call(interviewService.getPatientHistory, action.payload);
    // 入院・外来歴を取得成功Actionを発生させる
    yield put(getPatientHistorySuccess({ patientdata }));
  } catch (error) {
    // 入院・外来歴を取得失敗Actionを発生させる
    yield put(getPatientHistoryFailure(error.response));
  }
}

// 病歴を取得Action発生時に起動するメソッド
function* runRequestDiseaseHistory(action) {
  try {
    let diseasedata = null;
    // 病歴を取得処理実行
    diseasedata = yield call(interviewService.getDiseaseHistory, action.payload);
    // 病歴を取得成功Actionを発生させる
    yield put(getDiseaseHistorySuccess({ diseasedata }));
  } catch (error) {
    // 病歴を取得失敗Actionを発生させる
    yield put(getDiseaseHistoryFailure(error.response));
  }
}
// コースグループ取得Action発生時に起動するメソッド
function* runRequestCsGrpData(action) {
  try {
    const { rsvno } = action.payload;
    // コースグループ取得処理実行
    const payload = yield call(interviewService.GetCsGrp, { rsvNo: rsvno });
    // コースグループ取得成功Actionを発生させる
    yield put(getCsGrpDataSuccess(payload));
  } catch (error) {
    // コースグループ取得失敗Actionを発生させる
    yield put(getCsGrpDataFailure(error.response));
  }
}
// 指定された予約番号の個人ＩＤの受診歴一覧と総合コメント取得Action発生時に起動するメソッド
function* runRequestViewOldConsultHistory(action) {
  try {
    const { rsvno, csgrpcd, cscd } = action.payload;

    let selCsGrp = 0;
    let lastdspmode = 0;
    let csgrp = '';

    if (csgrpcd === null || csgrpcd === '' || csgrpcd === undefined) {
      selCsGrp = 0;
    } else {
      selCsGrp = csgrpcd;
    }
    switch (selCsGrp) {
      case '0':
        lastdspmode = 0;
        csgrp = '';
        break;
      case '1':
        lastdspmode = 1;
        csgrp = cscd;
        break;
      case '2':
        lastdspmode = 2;
        csgrp = selCsGrp;
        break;
      default:
        break;
    }

    try {
      // 指定された予約番号の個人ＩＤの受診歴一覧取得処理実行
      const consultHistoryData = yield call(interviewService.GetConsultHistory, { rsvNo: rsvno, receptonly: true, lastdspmode, csgrp });
      // 指定された予約番号の個人ＩＤの受診歴一覧取得成功Actionを発生させる
      yield put(getViewOldConsultHistorySuccess(consultHistoryData));
    } catch (error) {
      // 指定された予約番号の個人ＩＤの受診歴一覧取得失敗Actionを発生させる
      yield put(getViewOldConsultHistoryFailure({ ...error.response, rsvno }));
      return;
    }

    // 総合コメント取得処理実行
    const conditions = { rsvno, dispmode: 1, hiscount: '*', lastdspmode, csgrp, selectmode: 1 };
    const commentData = yield call(interviewService.getTotalJudCmt, conditions);
    yield put(getViewOldTotalJudCmtSuccess({ commentData }));
  } catch (error) {
    // 総合コメント取得失敗Actionを発生させる
    yield put(getViewOldTotalJudCmtFailure(error.response));
  }
}

// 総合コメントの保存Action発生時に起動するメソッド
function* runUpdateTotalJudCmtRequest(action) {
  try {
    if (listArr.length > 0) {
      const result = action.payload.data.recoglevel;
      const { rsvno, suffix, itemcd, rslcmtcd1, rslcmtcd2 } = listArr[0];
      const param = {};
      param.results = [];
      const resultRec = {};
      resultRec.result = result;
      resultRec.suffix = suffix;
      resultRec.itemcd = itemcd;
      resultRec.rslcmtcd1 = rslcmtcd1;
      resultRec.rslcmtcd2 = rslcmtcd2;
      param.results.push(resultRec);
      param.rsvno = rsvno;
      yield call(resultService.updateResult, param);
    }
    if (action.payload.act === 'del') {
      const { CmtDelFlag, formName } = action.payload.data;
      const flagArr = CmtDelFlag;
      for (let i = 1; i < flagArr.length; i += 1) {
        const { payload } = action;
        const { list } = payload.data;
        if (flagArr[i]) {
          // trueなら  CmtDelFlag に 1 に値を与える
          list[i - 1].CmtDelFlag = 1;
        } else {
          // falseなら  CmtDelFlag に 0 に値を与える
          list[i - 1].CmtDelFlag = 0;
        }
      }
      const arr = action.payload.data.list;
      const fromBody = {};
      fromBody.dispMode = 2;
      fromBody.seqs = [];
      fromBody.judCmtCd = [];
      fromBody.judCmtCdStc = [];
      for (let i = 1; i <= arr.length; i += 1) {
        // 削除しないと
        if (!arr[i - 1].CmtDelFlag || arr[i - 1].CmtDelFlag === 0) {
          fromBody.seqs.push(arr[i - 1].seq);
          fromBody.judCmtCd.push(arr[i - 1].judcmtcd);
          fromBody.judCmtCdStc.push(arr[i - 1].judcmtstc);
        }
      }
      const conditions = { ...action.payload, data: fromBody };
      // 総合コメントの保存処理実行
      yield call(interviewService.updateTotalJudCmt, conditions);
      const { params } = action.payload;
      // 総合コメントの保存成功Actionを発生させる
      yield put(getEntryRecogLevelList({ formName, params }));
      yield put(updateEntryListSuccess());
    } else {
      const info = action.payload.data;
      const { formName, list } = info;
      const fromBody = {};
      fromBody.dispMode = 2;
      fromBody.seqs = [];
      fromBody.judCmtCd = [];
      fromBody.judCmtCdStc = [];
      for (let i = 1; i <= list.length; i += 1) {
        fromBody.seqs.push(i);
        fromBody.judCmtCd.push(list[i - 1].judcmtcd);
        fromBody.judCmtCdStc.push(list[i - 1].judcmtstc);
      }
      const conditions = { ...action.payload, data: fromBody };
      // 総合コメントの保存処理実行
      yield call(interviewService.updateTotalJudCmt, conditions);
      const { params } = action.payload;
      // 総合コメントの保存成功Actionを発生させる
      yield put(getEntryRecogLevelList({ formName, params }));
      yield put(updateEntryListSuccess());
    }
  } catch (error) {
    // 総合コメントの保存失败Actionを発生させる
    yield put(updateTotalJudCmtFailure(error.response));
  }
}

// 総合コメント取得Action発生時に起動するメソッド
function* runRequestEntryList(action) {
  try {
    const { params } = action.payload;
    const conditionsHead = { ...params, hiscount: 2, lastDspMode: 0, grpCd: 'X018', csGrp: 100, rsvNo: params.rsvno };
    // 総合コメント取得処理実行
    const payloadHead = yield call(interviewService.getHistoryRsList, conditionsHead);
    // 総合コメント取得成功Actionを発生させる
    const arr = payloadHead.historyRslData;
    let recoglevel = -1;
    for (let i = 0; i < arr.length; i += 1) {
      if (arr[i].hisno === 1) {
        // recoglevel = i === 0 ? '' : i;
        recoglevel = arr[i].rslvalue;
        itemName = arr[i].uppervalue;
      }
      if (arr[i].hisno === 2) {
        recoglevel = arr[i].result.substring(5, 6).toString();
        itemName = arr[i].uppervalue;
      }
    }
    listArr = arr;
    indexflag = recoglevel;
    const conditions = { ...params, hiscount: 1, dispmode: 2, rsvNo: params.rsvno, csGrp: 100 };
    // 総合コメント取得処理実行
    const payload = yield call(interviewService.getTotalJudCmt, conditions);
    // 総合コメント取得成功Actionを発生させる
    const newpayload = {};
    newpayload.list = payload;
    newpayload.recoglevel = indexflag;
    newpayload.itemName = itemName;
    newpayload.items = items;
    yield put(getEntryListSuccess(newpayload));
  } catch (error) {
    // 総合コメント取得败Actionを発生させる
    yield put(getEntryListFailure(error.response));
  }
}

// 面接支援ヘッダを取得Action発生時に起動するメソッド
function* runRequestInterviewHeader(action) {
  try {
    const { rsvno } = action.payload;
    let consultdata = {};
    // 受診情報取得処理実行
    try {
      consultdata = yield call(consultService.getConsult, { rsvno });
    } catch (error) {
      // 受診情報取得失敗Actionを発生させる
      const message = [`受診情報が存在しません。（予約番号 = ${rsvno} )`];
      yield put(getInterviewHeaderFailure(message));
      return;
    }

    const { birth, cscd, csldate, orgcd1, orgcd2, perid, ctrptcd } = consultdata;
    const defaultdate = moment(csldate).format('YYYY/MM/DD');
    // ジャンプ先のURL選択肢
    const selecturlItems = [
      { value: 0, name: '総合判定', grpno: 0, rsvno, cscd },
      { value: 1, name: '診察・体格・血圧・肺機能', grpno: 1, rsvno, cscd },
      { value: 2, name: '心電図', grpno: 2, rsvno, cscd },
      { value: 3, name: '胸部Ｘ線', grpno: 3, rsvno, cscd },
      { value: 4, name: '上部消化管Ｘ線内視鏡・大腸便潜血', grpno: 4, rsvno, cscd },
      { value: 5, name: '上腹部超音波', grpno: 5, rsvno, cscd },
      { value: 6, name: '血液', grpno: 6, rsvno, cscd },
      { value: 7, name: '糖代謝・脂質代謝', grpno: 7, rsvno, cscd },
      { value: 8, name: '尿酸・肝機能・腎機能', grpno: 8, rsvno, cscd },
      { value: 9, name: '電解質・血清・尿検査・前立腺', grpno: 9, rsvno, cscd },
      { value: 10, name: '視力・眼底・聴力・骨密度', grpno: 10, rsvno, cscd },
      { value: 11, name: '乳房・婦人科・婦人科超音波', grpno: 11, rsvno, cscd },
      { value: 12, name: '大腸内視鏡', grpno: 12, rsvno, cscd },
      { value: 13, name: 'ヘリカルＣＴ／喀痰／ＣＴ肺気腫', grpno: 13, rsvno, cscd },
      { value: 14, name: '大腸３Ｄ－ＣＴ', grpno: 15, rsvno, cscd },
      { value: 15, name: '内臓脂肪面積', grpno: 18, rsvno, cscd },
      { value: 16, name: '心不全スクリーニング', grpno: 19, rsvno, cscd },
      { value: 17, name: '頸動脈超音波', grpno: 16, rsvno, cscd },
      { value: 18, name: '動脈硬化', grpno: 17, rsvno },
      { value: 19, name: '虚血性心疾患指導表パターン', grpno: 14, rsvno, cscd },
      { value: 20, name: '失点分布', grpno: 15, rsvno, cscd },
      { value: 21, name: '認識レベル～生活指導', grpno: 16, rsvno, cscd },
      { value: 22, name: '栄養指導', grpno: 17, rsvno, cscd },
      { value: 23, name: '食習慣問診', grpno: 18, rsvno, cscd },
      { value: 24, name: 'ＣＵ経年変化', grpno: 19, rsvno, cscd },
      { value: 25, name: '変更履歴', grpno: 20, rsvno, cscd },
      { value: 26, name: '病歴情報', grpno: 21, rsvno, cscd },
      { value: 27, name: 'チャート情報', grpno: 22, rsvno, cscd, startdate: defaultdate, enddate: defaultdate, orgcd1, orgcd2, perid, ctrptcd },
      { value: 28, name: '注意事項', grpno: 22, rsvno, cscd, startdate: defaultdate, enddate: defaultdate, orgcd1, orgcd2, perid, ctrptcd },
      { value: 29, name: '問診', grpno: 24, rsvno, cscd },
      { value: 30, name: '胃検査、他院での指摘', grpno: 25, rsvno, cscd },
      { value: 31, name: '多項目検査からみたあなたの傾向', grpno: 27, rsvno, cscd },
      { value: 32, name: 'フォローアップ照会', grpno: 31, rsvno, cscd },
    ];

    let realage = null;
    let optitems = [];
    let specialcheck = 0;
    try {
      // 実年齢の計算
      if (birth !== null && birth !== '') {
        const calcage = yield call(freeService.calcAge, { birth });
        const { realAge } = calcage;
        if (realAge !== null) {
          realage = Number.parseInt(realAge, 10);
        }
      }
      // オプション検査名称読み込み
      optitems = yield call(interviewService.getInteviewOptItem, { rsvno });
      // 特定保険指導対象者チェック処理実行
      const specialtarget = yield call(specialInterviewService.checkSpecialTarget, action.payload);
      specialcheck = specialtarget;
    } catch (error) {
      yield put(getInterviewHeaderFailure(error.response));
    }
    let resultgrpdata = [];
    try {
      // 個人検査結果情報取得
      resultgrpdata = yield call(perResultService.getPerResultList, { perid, grpcd: 'X039', getseqmode: 2, alldatamode: 0 });
    } catch (error) {
      // 個人検査結果情報失敗Actionを発生させる
      const message = [`個人検査結果情報が存在しません。（個人ID = ${perid})`];
      yield put(getInterviewHeaderFailure(message));
    }

    // 面接支援ヘッダを取得成功Actionを発生させる
    yield put(getInterviewHeaderSuccess({ consult: consultdata, optitems, perResultGrps: resultgrpdata.perResultGrp, realage, specialcheck, selecturlItems }));
  } catch (error) {
    yield put(getInterviewHeaderFailure(error.response));
  }
}

// 指定された個人ＩＤの受診歴一覧を取得する
function* runRequestConsultHistoryJudHeader(action) {
  try {
    // 指定された個人ＩＤの受診歴一覧を取得する処理実行
    const payload = yield call(interviewService.GetConsultHistory, action.payload);
    // 指定された個人ＩＤの受診歴一覧を取得する成功Actionを発生させる
    yield put(getConsultHistoryJudHeaderSuccess(payload));
  } catch (error) {
    // 指定された個人ＩＤの受診歴一覧を取得する失敗Actionを発生させる
    yield put(getConsultHistoryJudHeaderFailure(error.response));
  }
}

// 指定された予約番号の受診歴一覧を取得する
function* runRequestConsultHistoryMenResult(action) {
  try {
    // 指定された予約番号の受診歴一覧を取得する処理実行
    const payload = yield call(interviewService.GetConsultHistory, action.payload);
    // 指定された予約番号の受診歴一覧を取得する成功Actionを発生させる
    yield put(getConsultHistoryMenResultSuccess(payload));
  } catch (error) {
    // 指定された予約番号の受診歴一覧を取得する失敗Actionを発生させる
    yield put(getConsultHistoryMenResultFailure(error.response));
  }
}

// 指定対象受診者の検査結果を取得する
function* runRequestHistoryRslListMenResult(action) {
  // 初期値
  let payload;
  const { params, formName } = action.payload;
  // 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
  let lngLastDspMode;
  // 前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
  let vntCsGrp;
  let strSelCsGrp = params.csgrp;

  if (formName === 'TotalJudView' || formName === 'MenResultForm') {
    if (!strSelCsGrp || strSelCsGrp === '') {
      try {
        // コースグループを取得する処理実行
        payload = yield call(interviewService.GetCsGrp, { rsvNo: params.rsvno });
        // コースグループを取得する成功Actionを発生させる
        yield put(getCsGrpSuccess(payload));

        const { csGrpData } = payload;
        // コースグループ情報をredux-formへセットするActionを発生させる
        // コースしばりのデフォルト値を判断する
        if (csGrpData && csGrpData.length > 0) {
          yield put(initialize(formName, { csgrp: csGrpData[0].csgrpcd }));
          strSelCsGrp = csGrpData[0].csgrpcd;
        } else {
          yield put(initialize(formName, { csgrp: '0' }));
          strSelCsGrp = '0';
        }
      } catch (error) {
        // コースグループを取得する失敗Actionを発生させる
        yield put(getCsGrpFailure(error.response));
      }
    }
  }

  strSelCsGrp = ((!strSelCsGrp || strSelCsGrp === '') ? '0' : strSelCsGrp);

  // グループ情報取得
  const {
    lngMenResultTypeNo,
    strMenResultGrpCd3,
    strMenResultGrpCd1,
    strRayPaxOrdDiv,
    strRayPaxOrdDiv2,
    strRayPaxOrdDiv3,
  } = getMenResultGrpInfo(params.resultdispmode);

  switch (strSelCsGrp) {
    // すべてのコース
    case '0':
      lngLastDspMode = 0;
      vntCsGrp = '';
      break;
    // 同一コース
    case '1':
      lngLastDspMode = 1;
      vntCsGrp = params.cscd;
      break;
    default:
      lngLastDspMode = 2;
      vntCsGrp = strSelCsGrp;
  }

  try {
    payload = yield call(interviewService.GetConsultHistory, {
      rsvNo: params.rsvno,
      receptOnly: false,
      lastDspMode: lngLastDspMode,
      csGrp: vntCsGrp,
      getRowCount: 3,
      selectMode: 0,
    });
    // 指定された予約番号の受診歴一覧を取得する成功Actionを発生させる
    yield put(getConsultHistoryMenResultSuccess(payload));
  } catch (error) {
    // 指定された予約番号の受診歴一覧を取得する失敗Actionを発生させる
    yield put(getConsultHistoryMenResultFailure(error.response));
    return;
  }

  // 指定された予約番号の受診歴一覧を取得する処理実行
  const { consultHistoryData } = payload;
  if (consultHistoryData && consultHistoryData.length > 0) {
    const historyRsParam3 = {
      rsvNo: params.rsvno,
      hisCount: consultHistoryData.length,
      grpCd: strMenResultGrpCd3,
      lastDspMode: lngLastDspMode,
      csGrp: vntCsGrp,
      getSeqMode: 2,
      selectMode: 0,
      allDataMode: 1,
      rslCmtName1: true,
      rslCmtName2: true,
    };
    const historyRsParam1 = {
      rsvNo: params.rsvno,
      hisCount: consultHistoryData.length,
      grpCd: strMenResultGrpCd1,
      lastDspMode: lngLastDspMode,
      csGrp: vntCsGrp,
      getSeqMode: 0,
      selectMode: 0,
      allDataMode: 1,
      rslCmtName1: true,
      rslCmtName2: true,
      lowerValue: true,
      upperValue: true,
    };
    if (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE1) {
      try {
        // 指定対象受診者の検査結果一覧を取得する処理実行
        payload = yield call(interviewService.getHistoryRsList, historyRsParam1);
        // 指定対象受診者の検査結果一覧を取得する成功Actionを発生させる
        yield put(getHistoryRslListMenResult1Success({ historyRslData1: payload.historyRslData }));
      } catch (error) {
        // 指定対象受診者の検査結果一覧を取得する失敗Actionを発生させる
        yield put(getHistoryRslListMenResult1Failure(error.response));
      }
    } else if (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE2) {
      try {
        // 指定対象受診者の検査結果一覧を取得する処理実行
        payload = yield call(interviewService.getHistoryRsList, historyRsParam3);
        // 指定対象受診者の検査結果一覧を取得する成功Actionを発生させる
        yield put(getHistoryRslListMenResult3Success({ historyRslData3: payload.historyRslData }));
      } catch (error) {
        // 指定対象受診者の検査結果一覧を取得する失敗Actionを発生させる
        yield put(getHistoryRslListMenResult3Failure(error.response));
      }
      try {
        // 指定対象受診者の検査結果一覧を取得する処理実行
        payload = yield call(interviewService.getHistoryRsList, historyRsParam1);
        // 指定対象受診者の検査結果一覧を取得する成功Actionを発生させる
        yield put(getHistoryRslListMenResult1Success({ historyRslData1: payload.historyRslData }));
      } catch (error) {
        // 指定対象受診者の検査結果一覧を取得する失敗Actionを発生させる
        yield put(getHistoryRslListMenResult1Failure(error.response));
      }
    } else if (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE3) {
      // 指定対象受診者の検査結果一覧を取得する処理実行
      payload = yield call(interviewService.getHistoryRsList, historyRsParam3);
      // 指定対象受診者の検査結果一覧を取得する成功Actionを発生させる
      yield put(getHistoryRslListMenResult3Success({ historyRslData3: payload.historyRslData }));
    }

    try {
      // オーダ番号、送信日を取得する処理実行
      payload = yield call(interviewService.GetOrderNo, { rsvNo: params.rsvno, orderDiv: strRayPaxOrdDiv });
      // オーダ番号、送信日を取得する成功Actionを発生させる
      yield put(getOrderNo1Success(payload));
    } catch (error) {
      // オーダ番号、送信日を取得する失敗Actionを発生させる
      yield put(getOrderNo1Failure(error.response));
    }

    try {
      // オーダ番号、送信日を取得する処理実行
      payload = yield call(interviewService.GetOrderNo, { rsvNo: params.rsvno, orderDiv: strRayPaxOrdDiv2 });
      // オーダ番号、送信日を取得する成功Actionを発生させる
      yield put(getOrderNo2Success(payload));
    } catch (error) {
      // オーダ番号、送信日を取得する失敗Actionを発生させる
      yield put(getOrderNo2Failure(error.response));
    }

    try {
      // オーダ番号、送信日を取得する処理実行
      payload = yield call(interviewService.GetOrderNo, { rsvNo: params.rsvno, orderDiv: strRayPaxOrdDiv3 });
      // オーダ番号、送信日を取得する成功Actionを発生させる
      yield put(getOrderNo2Success(payload));
    } catch (error) {
      // オーダ番号、送信日を取得する失敗Actionを発生させる
      yield put(getOrderNo2Failure(error.response));
    }

    try {
      // 変更前のIDと変更後のIDを取得する処理実行
      payload = yield call(interviewService.GetChangePerId, { rsvNo: params.rsvno });
      // 変更前のIDと変更後のIDを取得する成功Actionを発生させる
      yield put(getChangePerIdSuccess(payload));
    } catch (error) {
      // 変更前のIDと変更後のIDを取得する失敗Actionを発生させる
      yield put(getChangePerIdFailure(error.response));
    }
  }
}

function* runUpdateTotalJudCmt(action) {
  try {
    const { params, data } = action.payload;
    const { foodadvicedata, menuadvicedata, verflag } = data;
    const { rsvno } = params;
    const seqs = [];
    const judCmtCd = [];
    const judCmtCdStc = [];
    const menuSeqs = [];
    const menuJudCmtCd = [];
    const menuJudCmtCdStc = [];
    let dispmode = null;
    if (verflag) {
      dispmode = constants.DISPMODE_FOODADVICE;
    } else {
      dispmode = constants.DISPMODE_FOODADVICE201210;
    }
    if (foodadvicedata.length > 0) {
      for (let i = 0; i < foodadvicedata.length; i += 1) {
        seqs[i] = i + 1;
        judCmtCd[i] = foodadvicedata[i].judcmtcd;
        judCmtCdStc[i] = foodadvicedata[i].judcmtstc;
      }
      // 総合コメントを更新処理実行
      const payload = yield call(interviewService.updateTotalJudCmt, {
        ...action.payload,
        data: {
          dispMode: dispmode,
          seqs,
          judCmtCd,
          judCmtCdStc } });
      // 総合コメントを更新成功Actionを発生させる
      yield put(updateTotalJudCmtSuccess(payload));
    }
    if (menuadvicedata.length > 0) {
      for (let i = 0; i < menuadvicedata.length; i += 1) {
        menuSeqs[i] = i + 1;
        menuJudCmtCd[i] = menuadvicedata[i].judcmtcd;
        menuJudCmtCdStc[i] = menuadvicedata[i].judcmtstc;
      }
      const payload = yield call(interviewService.updateTotalJudCmt, {
        ...action.payload,
        data: {
          ...data,
          dispMode: constants.DISPMODE_MENUADVICE,
          seqs: menuSeqs,
          judCmtCd: menuJudCmtCd,
          judCmtCdStc: menuJudCmtCdStc } });
      // 総合コメントを更新成功Actionを発生させる
      yield put(updateTotalJudCmtSuccess(payload));
    }
    yield put(openMenFoodCommentGuide({ params: { rsvno } }));
  } catch (error) {
    // 総合コメントを更新失敗Actionを発生させる
    yield put(updateTotalJudCmtFailure(error.response));
  }
}

// 2012年10月バージョン対象チェックAction発生時に起動するメソッド
function* runOpenMenFoodCommentGuide(action) {
  let foodadvicedata = null;
  let menuadvicedata = null;
  const { params } = action.payload;
  const { rsvno } = params;
  try {
    let verflag = true;
    let freedata = null;
    let consultdata = null;
    let freeelement = null;
    // 切替日の取得
    freedata = yield call(freeService.getFree, { mode: 0, freeCd: constants.FREECD_CHG201210 });
    // 受診情報検索取得処理実行
    consultdata = yield call(consultService.getConsult, params);
    const { csldate } = consultdata;
    if (freedata.length >= 0) {
      ([freeelement] = freedata);
    }
    const { freefield1 } = freeelement;
    // 切替日以降の受診日かを判定
    if (freefield1 !== null && (moment(csldate).format('YYYY/MM/DD') >= moment(freefield1).format('YYYY/MM/DD'))) {
      verflag = false;
    }
    // バージョン対象チェック成功Actionを発生させる
    yield put(getVer201210Success(verflag));
    // 総合コメントを取得
    if (!verflag) {
      // 食習慣コメントを取得する処理実行
      foodadvicedata = yield call(interviewService.getTotalJudCmt, {
        ...params,
        dispMode: constants.DISPMODE_FOODADVICE201210,
        hiscount: constants.HISCOUNT,
        lastdspmode: constants.LAST_DSP_MODE_ZERO,
      });
      // 食習慣コメントを取得する成功Actionを発生させる
      yield put(getTotalJudCmtSuccess({ foodadvicedata, rsvno }));
      return;
    }
  } catch (error) {
    // 変更履歴一覧取得失敗Actionを発生させる
    yield put(getVer201210Failure(error.response));
  }
  // 食習慣コメントを取得する処理実行
  foodadvicedata = yield call(interviewService.getTotalJudCmt, {
    ...params,
    dispMode: constants.DISPMODE_FOODADVICE,
    hiscount: constants.HISCOUNT,
    lastdspmode: constants.LAST_DSP_MODE_ZERO,
  });
  // 献立コメントを取得する処理実行
  menuadvicedata = yield call(interviewService.getTotalJudCmt, {
    ...params,
    dispMode: constants.DISPMODE_MENUADVICE,
    hiscount: constants.HISCOUNT,
    lastdspmode: constants.LAST_DSP_MODE_ZERO,
  });
  // 総合コメントを取得する成功Actionを発生させる
  yield put(getTotalJudCmtSuccess({ foodadvicedata, menuadvicedata, rsvno }));
}

// 総合判定（判定修正画面）を取得するメソッド
function* runRequestTotalJudEditBody(action) {
  // 今回コースコード退避
  let strCsCd = '';
  let params;
  const p = action.payload;
  const judcd = [];
  const editCmtData = [];
  try {
    // 検索条件に従い受診情報一覧を抽出する
    params = { rsvNo: p.rsvNo, lastDspMode: p.lastDspMode, csGrp: p.csGrp, getRowCount: 3 };
    const payload = yield call(interviewService.GetConsultHistory, params);

    if (payload.consultHistoryData && payload.consultHistoryData.length > 0) {
      // 今回コースコード退避
      strCsCd = payload.consultHistoryData[0].cscd;
    } else {
      // 受診歴一覧を取得する失敗Actionを発生させる
      yield put(getConsultHistoryFailure({ status: 404 }));
      return;
    }

    // 受診歴一覧を取得する成功Actionを発生させる
    yield put(getConsultHistorySuccess(payload));
  } catch (error) {
    // 受診歴一覧を取得する失敗Actionを発生させる
    yield put(getConsultHistoryFailure(error.response));
    return;
  }

  try {
    // 検索条件に従い判定結果一覧を抽出する
    params = { rsvNo: p.rsvNo, hisCount: 3, lastDspMode: p.lastDspMode, csGrp: p.csGrp, seqMode: 1 };
    const payload = yield call(interviewService.selectJudHistoryRslList, params);

    if (!payload.data || payload.data.length === 0) {
      // 判定結果一覧を取得する失敗Actionを発生させる
      yield put(selectJudHistoryRslListFailure({ status: 404 }));
      return;
    }

    // 判定結果一覧を取得成功Actionを発生させる
    yield put(selectJudHistoryRslListSuccess(payload));
    for (let i = 0; i < payload.data.length; i += 1) {
      judcd[i] = payload.data[i].judcd;
    }
  } catch (error) {
    // 判定結果一覧を取得失敗Actionを発生させる
    yield put(selectJudHistoryRslListFailure(error.response));
    return;
  }

  try {
    // 検索条件に従いeGFR(MDRD式）計算結果一覧を抽出する
    params = { rsvno: p.rsvNo, hisCount: 3, csGrp: p.csGrp };
    const payload = yield call(interviewService.getMdrdHistory, params);
    // 判定医を取得成功Actionを発生させる
    yield put(getMdrdHistorySuccess(payload));
  } catch (error) {
    // 判定医を取得失敗Actionを発生させる
    yield put(getMdrdHistoryFailure(error.response));
  }

  try {
    // 検索条件に従いGFR(日本人推算式）計算結果一覧を抽出する
    params = { rsvno: p.rsvNo, hisCount: 3, csGrp: p.csGrp };
    const payload = yield call(interviewService.getNewGfrHistory, params);
    // 判定医を取得成功Actionを発生させる
    yield put(getNewGfrHistorySuccess(payload));
  } catch (error) {
    // 判定医を取得失敗Actionを発生させる
    yield put(getNewGfrHistoryFailure(error.response));
  }

  try {
    // 総合コメントを取得する処理実行
    params = { rsvno: p.rsvNo, dispMode: 1, hisCount: 1, lastDspMode: 1, csGrp: strCsCd, selectMode: 0 };
    const payload = yield call(interviewService.getTotalJudCmt, params);

    if (payload && payload.length > 0) {
      for (let i = 0; i < payload.length; i += 1) {
        editCmtData.push({ ...payload[i], value: `${i + 1}`, name: payload[i].judcmtstc });
      }
    }

    // 総合コメントを取得成功Actionを発生させる
    yield put(getTotalJudCmtSuccess({ commentData: payload }));
  } catch (error) {
    // 総合コメントを取得失敗Actionを発生させる
    yield put(getTotalJudCmtFailure(error.response));
  }

  try {
    // 判定の一覧を取得する
    const payload = yield call(interviewService.getJudList);
    const judList = [];
    if (payload && payload.length > 0) {
      for (let i = 0; i < payload.length; i += 1) {
        judList.push({ ...payload[i], value: payload[i].judcd, name: payload[i].judcd });
      }
    }
    // 判定の一覧を取得成功Actionを発生させる
    yield put(getJudListSuccess(judList));
  } catch (error) {
    // 判定の一覧を取得失敗Actionを発生させる
    yield put(getJudListFailure(error.response));
  }

  yield put(initialize(p.formName, { judcd, editCmtData, editJudData: [] }));
}

// 判定結果の保存
function* runSaveTotalJud(action) {
  let params;
  const p = action.payload;
  let lngNewCount;
  let lngNewCmtCnt;
  const { vntJudData, vntEditJudData, vntCmtData, vntEditCmtData, cmtmode, cscd } = p;
  let strArrMessage;
  let payload;
  let blnUpdated;
  let vntNewJudData = [];
  let vntNewCmtData = [];
  const updJudData = [];
  let i;
  let j;
  let lngUpdCount;
  try {
    // 最新の判定結果再取得
    params = { rsvNo: p.rsvNo, hisCount: 3, lastDspMode: p.lastDspMode, csGrp: p.csGrp, seqMode: 1 };
    payload = yield call(interviewService.selectJudHistoryRslList, params);

    lngNewCount = payload.data ? payload.data.length : 0;
  } catch (error) {
    // 判定結果一覧を取得失敗Actionを発生させる
    lngNewCount = 0;
  }

  vntNewJudData = payload.data;

  strArrMessage = '';
  // 修正前とサーバー内の状態が変わっているかチェック
  if (lngNewCount !== vntJudData.length) {
    strArrMessage = '判定データが他の人によって更新されているため保存できません。';
  } else {
    for (i = 0; i < lngNewCount; i += 1) {
      if (vntNewJudData[i].seq === 1 && vntNewJudData[i].judcd !== vntJudData[i].judcd) {
        strArrMessage = '判定データが他の人によって更新されているため保存できません。';
        break;
      }
    }
  }
  if (strArrMessage === '') {
    // 実際に更新を行う項目のみを抽出(初期表示データと異なるデータが更新対象)
    lngUpdCount = 0;
    for (i = 0; i < vntEditJudData.length; i += 1) {
      // 判定が更新されていたらデータ更新
      blnUpdated = false;
      if (vntEditJudData[i] && vntEditJudData[i].judclasscd && vntEditJudData[i].judclasscd !== '') {
        for (j = 0; j < vntNewJudData.length; j += 1) {
          if (vntNewJudData[j].seq === 1
            && vntNewJudData[j].judclasscd === vntEditJudData[i].judclasscd
            && vntNewJudData[j].judcd !== vntEditJudData[i].judcd) {
            blnUpdated = true;
            break;
          }
        }
      }

      // データ更新状態なら配列を拡張して保存状態をセット
      if (blnUpdated) {
        updJudData[lngUpdCount] = {
          rsvno: Number(p.rsvNo),
          judclasscd: vntEditJudData[i].judclasscd,
          judcd: vntEditJudData[i].judcd,
          judcmtcd: vntNewJudData[j].judcmtcd,
        };
        lngUpdCount += 1;
      }
    }

    // 更新対象データが存在するときのみ判定結果保存
    if (lngUpdCount > 0) {
      try {
        yield call(judgementService.insertJudRslWithUpdate, { updJudData });
      } catch (error) {
        yield put(saveTotalJudFailure(error.response));
      }
    }
  }

  blnUpdated = false;
  if (strArrMessage === '' && cmtmode === 'save') {
    try {
      // 最新の総合コメント再取得
      params = { rsvno: p.rsvNo, dispMode: 1, hisCount: 1, lastDspMode: 1, csGrp: cscd, selectMode: 0 };
      payload = yield call(interviewService.getTotalJudCmt, params);

      lngNewCmtCnt = payload ? payload.length : 0;
    } catch (error) {
      // 判定結果一覧を取得失敗Actionを発生させる
      lngNewCmtCnt = 0;
    }

    vntNewCmtData = payload;

    strArrMessage = '';
    // 修正前とサーバー内の状態が変わっているかチェック
    if (lngNewCmtCnt !== vntCmtData.length) {
      strArrMessage = '総合コメントが他の人によって更新されているため保存できません。';
    } else {
      for (i = 0; i < lngNewCmtCnt; i += 1) {
        if (vntNewCmtData[i].seq !== vntCmtData[i].seq || vntNewCmtData[i].judcmtcd !== vntCmtData[i].judcmtcd) {
          strArrMessage = '総合コメントが他の人によって更新されているため保存できません。';
          break;
        }
      }
    }

    if (vntEditCmtData.length !== lngNewCmtCnt) {
      blnUpdated = true;
    } else {
      for (i = 0; i < vntEditCmtData.length; i += 1) {
        if (vntEditCmtData[i].judcmtcd !== vntNewCmtData[i].judcmtcd) {
          blnUpdated = true;
          break;
        }
      }
    }
    if (strArrMessage === '' && blnUpdated) {
      // 総合コメントの保存
      try {
        const seqs = [];
        const judCmtCd = [];
        const judCmtCdStc = [];
        for (i = 0; i < vntEditCmtData.length; i += 1) {
          seqs[i] = vntEditCmtData[i].seq;
          judCmtCd[i] = vntEditCmtData[i].judcmtcd;
          judCmtCdStc[i] = vntEditCmtData[i].judcmtstc;
        }
        const data = {
          dispMode: 1,
          seqs,
          judCmtCd,
          judCmtCdStc,
        };
        yield call(interviewService.updateTotalJudCmt, { params: { rsvno: Number(p.rsvNo) }, data });
      } catch (error) {
        yield put(saveTotalJudFailure(error.response));
      }
    }
  }

  if (strArrMessage === '' && (lngUpdCount > 0 || blnUpdated)) {
    yield put(saveTotalJudSuccess());
  }

  if (strArrMessage !== '') {
    yield put(saveTotalJudSuccess({ messages: [strArrMessage] }));
  }
}

// フォローアップヘッダーを取得Action発生時に起動するメソッド
function* runRequestFollowUpHeader(action) {
  try {
    const { rsvno } = action.payload;
    let consultdata = {};
    // 受診情報取得処理実行
    try {
      consultdata = yield call(consultService.getConsult, { rsvno });
    } catch (error) {
      // 受診情報取得失敗Actionを発生させる
      const message = [`受診情報が存在しません。（予約番号 = ${rsvno} )`];
      yield put(getFollowUpHeaderFailure(message));
      return;
    }

    const { birth, perid } = consultdata;

    let realage = null;
    let optitems = [];
    let specialcheck = 0;
    try {
      // 実年齢の計算
      if (birth !== null && birth !== '') {
        const calcage = yield call(freeService.calcAge, { birth });
        const { realAge } = calcage;
        if (realAge !== null) {
          realage = Number.parseInt(realAge, 10);
        }
      }
      // オプション検査名称読み込み
      optitems = yield call(interviewService.getInteviewOptItem, { rsvno });
      // 特定保険指導対象者チェック処理実行
      const specialtarget = yield call(specialInterviewService.checkSpecialTarget, action.payload);
      specialcheck = specialtarget;
    } catch (error) {
      yield put(getFollowUpHeaderFailure(error.response));
    }
    let resultgrpdata = [];
    try {
      // 個人検査結果情報取得
      resultgrpdata = yield call(perResultService.getPerResultList, { perid, grpcd: 'X039', getseqmode: 2, alldatamode: 0 });
    } catch (error) {
      // 個人検査結果情報失敗Actionを発生させる
      const message = [`個人検査結果情報が存在しません。（個人ID = ${perid})`];
      yield put(getFollowUpHeaderFailure(message));
    }

    // 面接支援ヘッダを取得成功Actionを発生させる
    yield put(getFollowUpHeaderSuccess({ consult: consultdata, optitems, perResultGrps: resultgrpdata.perResultGrp, realage, specialcheck }));
  } catch (error) {
    yield put(getFollowUpHeaderFailure(error.response));
  }
}

function* runRequestShokusyukanList(action) {
  try {
    let message = '';
    let payload1 = null;
    let payload2 = null;
    try {
      yield call(consultService.getConsult, action.payload);
      payload1 = yield call(interviewService.getHistoryRslList, action.payload);
    } catch (error) {
      message = `受診情報が存在しません。（予約番号 = ${action.payload.rsvno} )`;
    }
    try {
      payload2 = yield call(interviewService.getTotalJudCmt, action.payload);
    } catch (error) {
      payload2 = [];
    }
    yield put(getShokusyukanListSuccess({ payload1, message, payload2 }));
  } catch (error) {
    yield put(getShokusyukanListFailure(error.response));
  }
}
function* runRequestCalc(action) {
  try {
    let message = '';
    try {
      const payload = yield call(consultService.getConsult, action.payload);
      const calcFlg = [0, 0, 0, 0, 0, 0, 0, 1];
      const params = { csldate: payload.csldate, calcFlg, dayIdFlg: 1, endDayId: payload.dayid, strDayId: payload.dayid, arrDayId: [0], csCd: '', judClassCd: '', entryCheck: 0, reJudge: 0 };
      try {
        yield call(judgementControllService.judgeAutomaticallyMain, params);
      } catch (error) {
        message = '自動判定が異常終了しました。（詳細は？）';
      }
    } catch (error) {
      message = `受診情報が存在しません。（予約番号 = ${action.payload.rsvno} )`;
    }
    yield put(calcRequestSuccess(message));
  } catch (error) {
    yield put(calcRequestFailure());
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const interviewSagas = [
  takeEvery(getInterviewConsultRequest.toString(), runRequestInterviewConsult),
  takeEvery(getHistoryRslLifeRequest.toString(), runRequestHistoryRslLife),
  takeEvery(getHistoryRslSelfRequest.toString(), runRequestHistoryRslSelf),
  takeEvery(getHistoriesRequest.toString(), runRequestHistories),
  takeEvery(getCsGrpRequest.toString(), runRequestCsGrp),
  takeEvery(getOrderNo1Request.toString(), runRequestOrderNo1),
  takeEvery(getOrderNo2Request.toString(), runRequestOrderNo2),
  takeEvery(getOrderNo3Request.toString(), runRequestOrderNo3),
  takeEvery(getChangePerIdRequest.toString(), runRequestChangePerId),
  takeEvery(getUpdateLogListRequest.toString(), runRequestUpdateLogList),
  takeEvery(getHistoryRslListRequest.toString(), runRequestHistoryRslList),
  takeEvery(getPatientHistoryRequest.toString(), runRequestPatientHistory),
  takeEvery(getDiseaseHistoryRequest.toString(), runRequestDiseaseHistory),
  takeEvery(updateTotalJudCmtRequest.toString(), runUpdateTotalJudCmtRequest),
  takeEvery(updateJudCmtRequest.toString(), runUpdateTotalJudCmt),
  takeEvery(getEntryRecogLevelList.toString(), runRequestEntryList),
  takeEvery(getCsGrpDataRequest.toString(), runRequestCsGrpData),
  takeEvery(getViewOldConsultHistoryRequest.toString(), runRequestViewOldConsultHistory),
  takeEvery(getInterviewHeaderRequest.toString(), runRequestInterviewHeader),
  takeEvery(getConsultHistoryJudHeaderRequest.toString(), runRequestConsultHistoryJudHeader),
  takeEvery(getConsultHistoryMenResultRequest.toString(), runRequestConsultHistoryMenResult),
  takeEvery(getHistoryRslListMenResultRequest.toString(), runRequestHistoryRslListMenResult),
  takeEvery(openMenFoodCommentGuide.toString(), runOpenMenFoodCommentGuide),
  takeEvery(getTotalJudEditBodyRequest.toString(), runRequestTotalJudEditBody),
  takeEvery(saveTotalJudRequest.toString(), runSaveTotalJud),
  takeEvery(getFollowUpHeaderRequest.toString(), runRequestFollowUpHeader),
  takeEvery(getShokusyukanListRequest.toString(), runRequestShokusyukanList),
  takeEvery(calcRequest.toString(), runRequestCalc),
];
export default interviewSagas;
