import { call, takeEvery, put } from 'redux-saga/effects';
import moment from 'moment';
import { initialize } from 'redux-form';
import freeService from '../../services/preference/freeService';
import consultService from '../../services/reserve/consultService';
import specialinterviewService from '../../services/judgement/specialinterviewService';
import perResultService from '../../services/preference/perResultService';
import questionnaire1Service from '../../services/dailywork/questionnaire1Service';
import hainsUserService from '../../services/preference/hainsUserService';
import itemService from '../../services/preference/sentenceService';
import interviewService from '../../services/judgement/interviewService';
import * as constants from '../../constants/common';

import {
  loadOcrNyuryokuSuccess,
  loadOcrNyuryokuFailure,
  loadOcrNyuryokuComHeaderSuccess,
  loadOcrNyuryokuComHeaderFailure,
  openOcrNyuryouku,
  loadOcrNyuryokuComHeaderInfo,

  getEditOcrDateRequest,
  getEditOcrDateSuccess,
  getEditOcrDateFailure,
  getOcrNyuryokuSpBodyRequest,
  getOcrNyuryokuSpBodyConsultSuccess,
  getOcrNyuryokuSpBodyConsultFailure,
  getOcrNyuryokuSpBodyPerResultGrpSuccess,
  getOcrNyuryokuSpBodyPerResultGrpFailure,
  getOcrNyuryokuSpBodyOcrNyuryokuSuccess,
  getOcrNyuryokuSpBodyOcrNyuryokuFailure,
  getOcrNyuryokuSpBodyErrInfoSuccess,
} from '../../modules/dailywork/questionnaire1Module';

const constantsSp = constants.OcrNyuryokuBody.OcrNyuryokuSpBody;

// OCR内容確認画面を初期化
function* runloadOcrNyuryokuInfo(action) {
  let freedata = [];
  let ret = false;
  let consultdata = [];
  let checkcsldata = [];
  let freedate = [];
  try {
    // 汎用マスタより切り替え日取得
    freedate = yield call(freeService.getFreeByClassCd, { mode: 0, freeClassCd: constants.FREECLASSCD_CHG });

    const { rsvno } = action.payload;
    const data = { rsvno };

    // 受診情報検索
    consultdata = yield call(consultService.getConsult, data);

    if (consultdata) {
      // 切替日の取得
      freedata = yield call(freeService.getFree, { mode: 0, freecd: constants.FREECD_CHG201210 });

      // 切替日以降の受診日かを判定
      if (consultdata && consultdata.csldate && freedata && freedata[0].freefield1) {
        const strcsldate = moment(consultdata.csldate).format('YYYYMMDD');
        const strchgdate = moment(freedata[0].freefield1).format('YYYYMMDD');
        if (strchgdate && strcsldate >= strchgdate) {
          ret = true;
        }
      } else if (consultdata && !consultdata.csldate && freedata && !freedata[0].freefield1) {
        ret = true;
      }
    }

    // 該当受診者の受診日チェック
    checkcsldata = yield call(questionnaire1Service.checkCslDate, data);

    const nextpagedata = { ret, checkcsldata, freedate };
    yield put(loadOcrNyuryokuSuccess({ data: nextpagedata }));
  } catch (error) {
    if (error.status) {
      if (error.status === 404) {
        const nextpagedata = { ret, checkcsldata, freedate };
        yield put(loadOcrNyuryokuSuccess({ data: nextpagedata }));
      } else {
        // Actionをエラー発生時
        yield put(loadOcrNyuryokuFailure({ error: error.response }));
      }
    }
  }
}

// OCR内容確認2010画面を初期化
function* runloadOcrNyuryokuComHeaderInfo(action) {
  // 実年齢
  let realagetxt = '';
  // エラーメッセージ
  const message = [];
  // 受診情報
  let consultdata = '';
  // オプション検査名称
  let optdata = '';
  // 特定保険指導対象者チェック
  let spcheckdata = '';
  // 個人検査結果情報
  let perrsldata = '';
  // OCR内容確認修正日時
  let editorcdate = '';
  // 内視鏡チェックリストの状態
  let gfchecklist = '';
  // 使用番号
  const { rsvno } = action.payload;
  const parms = { rsvno };
  let errstat = false;

  const perrsldatalist = [];

  // 受診情報検索
  try {
    consultdata = yield call(consultService.getConsult, parms);
  } catch (error) {
    // 来院処理受付確定失敗Actionを発生させる
    message.push = [`受診情報が存在しません。（予約番号 = ${rsvno})`];
    const data = { message };
    yield put(loadOcrNyuryokuComHeaderFailure(data));
    return;
  }

  // 実年齢の計算
  if (consultdata != null) {
    if (consultdata.birth != null) {
      try {
        // 実年齢を取得
        const data = { birth: consultdata.birth };
        const payload = yield call(freeService.calcAge, data);
        const realage = payload.realAge;
        if (realage != null) {
          realagetxt = Math.floor(realage.toString());
        }
      } catch (error) {
        message.push = ['実年齢取得エラー。'];
        errstat = true;
      }
    }
  }

  try {
    // オプション検査名称読み込み
    optdata = yield call(interviewService.getInteviewOptItem, parms);

    // 特定保険指導対象者チェック
    spcheckdata = yield call(specialinterviewService.checkSpecialTarget, parms);
  } catch (error) {
    // Actionをエラー発生時
    yield put(loadOcrNyuryokuComHeaderFailure({ error: error.response }));
  }

  // 個人検査結果情報取得
  try {
    const perrslparms = { perid: consultdata.perid, grpcd: 'X039', getseqmode: 2, alldatamode: 0 };
    perrsldata = yield call(perResultService.getPerResultList, perrslparms);
    perrsldatalist.push(perrsldata);
  } catch (error) {
    // 来院処理受付確定失敗Actionを発生させる
    message.push = [`個人検査結果情報が存在しません。（個人ID= ${consultdata.perid})`];
    errstat = true;
  }

  // OCR内容確認修正日時を取得する
  try {
    editorcdate = yield call(questionnaire1Service.getEditOcrDate, parms);
  } catch (error) {
    // 来院処理受付確定失敗Actionを発生させる
    message.push = [`OCR内容確認修正日時が取得できません。（予約番号 = ${rsvno})`];
    errstat = true;
  }

  // 内視鏡チェックリストの状態取得
  try {
    gfchecklist = yield call(questionnaire1Service.checkGF, parms);
  } catch (error) {
    // 来院処理受付確定失敗Actionを発生させる
    message.push = [`内視鏡チェックリストの状態が取得できません。（予約番号 = ${rsvno})`];
    errstat = true;
  }

  const data = { realagetxt, consultdata, optdata, spcheckdata, perrsldata: perrsldatalist, editorcdate, gfchecklist };
  if (!errstat) {
    yield put(loadOcrNyuryokuComHeaderSuccess(data));
  } else {
    const errdata = { realagetxt, consultdata, optdata, spcheckdata, perrsldata: perrsldatalist, editorcdate, message };
    yield put(loadOcrNyuryokuComHeaderFailure(errdata));
  }
}

// OCR内容確認修正日時を取得
function* rungetEditOcrDate(action) {
  try {
    // OCR内容確認修正日時を取得処理実行
    const payload = yield call(questionnaire1Service.getEditOcrDate, action.payload);
    yield put(getEditOcrDateSuccess(payload));
  } catch (error) {
    // OCR内容確認修正日時を取得失敗Actionを発生させる
    yield put(getEditOcrDateFailure(error.response));
  }
}

// OCR入力結果確認（ボディ）情報の取得
function* runRequestOcrNyuryokuSpBody(action) {
  const { rsvno, formName } = action.payload;
  let { chgRsl = [] } = action.payload;
  let { act } = action.payload;
  let payload;
  let i;
  let lngErrCntE = 0;
  let lngErrCntW = 0;
  let ocrNyuryoku;
  let initFormValues = {};

  const results = [];
  for (i = 0; i < chgRsl.length; i += 1) {
    if (chgRsl[i]) {
      results.push(chgRsl[i]);
    }
  }

  try {
    // 受診情報検索（予約番号より個人情報取得）
    payload = yield call(consultService.getConsult, { rsvno });
    yield put(getOcrNyuryokuSpBodyConsultSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBodyConsultFailure({ ...error.response, rsvno }));
    return;
  }

  try {
    // 個人検査結果情報取得（薬剤（ブスコパン）アレルギー）
    payload = yield call(perResultService.getPerResultList, { perid: payload.perid, grpCd: constantsSp.GRPCD_ALLERGY, getSeqMode: 0, allDataMode: 1 });
    yield put(getOcrNyuryokuSpBodyPerResultGrpSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBodyPerResultGrpFailure({ ...error.response, perid: payload.perid }));
    return;
  }

  if (!act || act === '') {
    // OCR入力結果を取得する
    try {
      payload = yield call(questionnaire1Service.getOcrNyuryoku, { rsvno, grpCd: constantsSp.GRPCD_OCRNYURYOKU, lastDspMode: 0, csGrp: '' });
      yield put(getOcrNyuryokuSpBodyOcrNyuryokuSuccess(payload));
      ocrNyuryoku = payload;
    } catch (error) {
      yield put(getOcrNyuryokuSpBodyOcrNyuryokuFailure({ ...error.response, rsvno }));
      return;
    }
  } else {
    // チェック
    if (act === 'check') {
      // OCR入力結果を取得する
      try {
        payload = yield call(questionnaire1Service.checkOcrNyuryoku, { rsvno, data: { results, grpCd: constantsSp.GRPCD_OCRNYURYOKU, lastDspMode: 0, csGrp: '' } });
      } catch (error) {
        yield put(getOcrNyuryokuSpBodyOcrNyuryokuFailure({ ...error.response, rsvno }));
        return;
      }

      const { result, stopflg, errcount, arrerrstate = [], arrerrno = [], arrerrmsg = [] } = payload;
      if (errcount === 0) {
        // エラーなしのときは引き続き保存処理を行う
        act = 'save';
      } else {
        // 状態別エラー数カウント
        for (i = 0; i < errcount; i += 1) {
          switch (arrerrstate[i]) {
            // エラー
            case '1': lngErrCntE += 1; break;
            // 警告
            case '2': lngErrCntW += 1; break;
            default: break;
          }
        }

        // OCR入力結果を取得する(検査結果、検査中止フラグ、エラー情報はチェック結果を使用)
        try {
          payload = yield call(questionnaire1Service.getOcrNyuryoku, { rsvno, grpCd: constantsSp.GRPCD_OCRNYURYOKU, lastDspMode: 0, csGrp: '' });
          ocrNyuryoku = payload;
          if (result && stopflg && result.length > 0 && stopflg.length > 0 && result.length === stopflg.length) {
            for (i = 0; i < result.length; i += 1) {
              ocrNyuryoku.ocrresult[i].result = result[i];
              ocrNyuryoku.ocrresult[i].stopflg = stopflg[i];
            }
          }
          ocrNyuryoku.errcount = errcount;
          ocrNyuryoku.arrerrstate = arrerrstate;
          ocrNyuryoku.arrerrno = arrerrno;
          ocrNyuryoku.arrerrmsg = arrerrmsg;
          yield put(getOcrNyuryokuSpBodyOcrNyuryokuSuccess(payload));
        } catch (error) {
          yield put(getOcrNyuryokuSpBodyOcrNyuryokuFailure({ ...error.response, rsvno }));
          return;
        }
      }
    }

    // 保存
    if (act === 'save') {
      // 検査結果更新
      try {
        payload = yield call(questionnaire1Service.updateOcrNyuryoku, { rsvno, results });
      } catch (error) {
        act = '';
      }

      // OCR入力結果を取得する(検査結果、エラー情報はチェック結果を使用)
      try {
        payload = yield call(questionnaire1Service.getOcrNyuryoku, { rsvno, grpCd: constantsSp.GRPCD_OCRNYURYOKU, lastDspMode: 0, csGrp: '' });
        yield put(getOcrNyuryokuSpBodyOcrNyuryokuSuccess(payload));
        ocrNyuryoku = payload;
      } catch (error_) {
        yield put(getOcrNyuryokuSpBodyOcrNyuryokuFailure({ ...error_.response, rsvno }));
        return;
      }

      act = '';
    }
  }

  chgRsl = [];
  if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
    for (i = 0; i < ocrNyuryoku.ocrresult.length; i += 1) {
      chgRsl[i] = {
        itemcd: ocrNyuryoku.ocrresult[i].itemcd,
        suffix: ocrNyuryoku.ocrresult[i].suffix,
        result: ocrNyuryoku.ocrresult[i].result,
        lstresult: ocrNyuryoku.ocrresult[i].lstresult,
        stopflg: ocrNyuryoku.ocrresult[i].stopflg,
      };
    }

    initFormValues = {
      ...initFormValues,
      opt1_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 0].result,
      opt1_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 1].result,
      opt1_3: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 56].result,
      opt1_4: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 57].result,

      opt2_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 1].result,
      opt2_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 2].result,
      opt2_3: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 12].result,
      opt2_41: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 16].result,
      opt2_43: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 18].result,
      opt2_44: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 19].result,
      opt2_5: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 20].result,
      opt2_6: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 23].result,
      opt2_71: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 24].result,
      opt2_72: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 25].result,
      opt2_73: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 26].result,
      opt2_75: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 29].result,
      opt2_77: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 35].result,
      opt2_78: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 36].result,
      opt2_79: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 37].result,
      opt2_710: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 38].result,

      opt3_1_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 1].result,
      opt3_1_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 2].result,
      opt3_1_3: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 3].result,
      opt3_1_4: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 4].result,
      opt3_1_5: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 5].result,
      opt3_1_6: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 6].result,
      opt3_1_7: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 7].result,
      opt3_1_8: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 8].result,
      opt3_1_9: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 9].result,
      opt3_1_10: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 10].result,
      opt3_1_11: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 11].result,
      opt3_2_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 13].result,
      opt3_2_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 14].result,
      opt3_2_3: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 15].result,
      opt3_2_4: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 16].result,
      opt3_2_5: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 17].result,
      opt3_2_6: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 18].result,
      opt3_2_7: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 19].result,
      opt3_2_8: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 20].result,
      opt3_2_9: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 21].result,
      opt3_2_10: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 22].result,
      opt3_2_11: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 23].result,
      opt3_2_12: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START3 + 24].result,

      opt4_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 0].result,
      opt4_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 1].result,
      opt4_3: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 2].result,
      opt4_5: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 15].result,
      opt4_6: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 18].result,
      opt4_6_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 23].result,
      opt4_9: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 29].result,
      opt4_10: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 30].result,

      date11_1: moment([
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 32].result,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 33].result - 1,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 34].result]),
      date11_2: moment([
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 32].result,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 35].result - 1,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 36].result]),
      date11_3: moment([
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 37].result,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 38].result - 1,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 39].result]),
      date11_4: moment([
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 37].result,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 40].result - 1,
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 41].result]),

      opt4_11_5: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 46].result,
      opt4_11_6: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 47].result,
      opt4_12: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 48].result,
      opt4_14: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 55].result,

      opt5_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 1].result,
      opt5_2_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 3].result,
      opt5_2_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 4].result,
      opt5_2_3: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 5].result,
      opt5_2_4: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 7].result,
      opt5_2_5: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 8].result,
      opt5_2_6: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 9].result,
      opt5_2_7: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 10].result,
      opt5_2_8: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 11].result,
      opt5_2_9: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 13].result,

      opt6_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START6 + 0].result,
      opt7_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START7 + 0].result,
      opt8_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START8 + 0].result,

      opt9_1: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START9 + 0].result,
      opt9_2: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START9 + 1].result,
    };

    const Rsl = [];

    const list111 = [];
    const list112 = [];

    const list121 = [];
    const list122 = [];

    const list131 = [];
    const list132 = [];

    const listjikaku1 = [];
    const listjikaku2 = [];
    const listjikaku3 = [];
    const listjikaku4 = [];

    for (i = 0; i < constantsSp.NOWDISEASE_COUNT; i += 1) {
      list111[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 2 + i * 3].result;
      Rsl[constantsSp.OCRGRP_START1 + 3 + i * 3] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 3 + i * 3].result;
      list112[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 4 + i * 3].result;
    }

    for (i = 0; i < constantsSp.DISEASEHIST_COUNT; i += 1) {
      list121[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 20 + i * 3].result;
      Rsl[constantsSp.OCRGRP_START1 + 21 + i * 3] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 21 + i * 3].result;
      list122[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 22 + i * 3].result;
    }

    for (i = 0; i < constantsSp.FAMILYHIST_COUNT; i += 1) {
      list131[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 38 + i * 3].result;
      Rsl[constantsSp.OCRGRP_START1 + 39 + i * 3] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 39 + i * 3].result;
      list132[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START1 + 40 + i * 3].result;
    }

    for (i = 0; i < constantsSp.JIKAKUSHOUJYOU_COUNT; i += 1) {
      listjikaku1[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 39 + i * 4].result;
      listjikaku2[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 40 + i * 4].result;
      listjikaku3[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 41 + i * 4].result;
      listjikaku4[i + 1] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 42 + i * 4].result;
    }

    Rsl[constantsSp.OCRGRP_START2 + 0] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 0].result;
    Rsl[constantsSp.OCRGRP_START2 + 3] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 3].result;
    Rsl[constantsSp.OCRGRP_START2 + 4] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 4].result;
    Rsl[constantsSp.OCRGRP_START2 + 5] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 5].result;
    Rsl[constantsSp.OCRGRP_START2 + 6] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 6].result;
    Rsl[constantsSp.OCRGRP_START2 + 7] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 7].result;
    Rsl[constantsSp.OCRGRP_START2 + 8] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 8].result;
    Rsl[constantsSp.OCRGRP_START2 + 9] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 9].result;
    Rsl[constantsSp.OCRGRP_START2 + 10] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 10].result;
    Rsl[constantsSp.OCRGRP_START2 + 11] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 11].result;
    Rsl[constantsSp.OCRGRP_START2 + 13] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 13].result;
    Rsl[constantsSp.OCRGRP_START2 + 14] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 14].result;
    Rsl[constantsSp.OCRGRP_START2 + 15] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 15].result;
    Rsl[constantsSp.OCRGRP_START2 + 17] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 17].result;
    Rsl[constantsSp.OCRGRP_START2 + 21] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 21].result;
    Rsl[constantsSp.OCRGRP_START2 + 22] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 22].result;
    Rsl[constantsSp.OCRGRP_START2 + 27] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 27].result;
    Rsl[constantsSp.OCRGRP_START2 + 28] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START2 + 28].result;

    Rsl[constantsSp.OCRGRP_START4 + 16] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 16].result;
    Rsl[constantsSp.OCRGRP_START4 + 17] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 17].result;
    Rsl[constantsSp.OCRGRP_START4 + 20] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 20].result;
    Rsl[constantsSp.OCRGRP_START4 + 22] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 22].result;
    Rsl[constantsSp.OCRGRP_START4 + 25] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 25].result;
    Rsl[constantsSp.OCRGRP_START4 + 26] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 26].result;
    Rsl[constantsSp.OCRGRP_START4 + 27] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 27].result;
    Rsl[constantsSp.OCRGRP_START4 + 28] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 28].result;
    Rsl[constantsSp.OCRGRP_START4 + 31] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 31].result;
    Rsl[constantsSp.OCRGRP_START4 + 42] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 42].result;
    Rsl[constantsSp.OCRGRP_START4 + 44] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START4 + 44].result;

    Rsl[constantsSp.OCRGRP_START5 + 2] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 2].result;
    Rsl[constantsSp.OCRGRP_START5 + 6] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 6].result;
    Rsl[constantsSp.OCRGRP_START5 + 12] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 12].result;
    Rsl[constantsSp.OCRGRP_START5 + 14] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 14].result;
    Rsl[constantsSp.OCRGRP_START5 + 23] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 23].result;
    Rsl[constantsSp.OCRGRP_START5 + 15] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 15].result;
    Rsl[constantsSp.OCRGRP_START5 + 24] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 24].result;
    Rsl[constantsSp.OCRGRP_START5 + 16] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 16].result;
    Rsl[constantsSp.OCRGRP_START5 + 25] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 25].result;
    Rsl[constantsSp.OCRGRP_START5 + 17] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 17].result;
    Rsl[constantsSp.OCRGRP_START5 + 26] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 26].result;
    Rsl[constantsSp.OCRGRP_START5 + 18] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 18].result;
    Rsl[constantsSp.OCRGRP_START5 + 27] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 27].result;
    Rsl[constantsSp.OCRGRP_START5 + 19] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 19].result;
    Rsl[constantsSp.OCRGRP_START5 + 28] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 28].result;
    Rsl[constantsSp.OCRGRP_START5 + 20] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 20].result;
    Rsl[constantsSp.OCRGRP_START5 + 29] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 29].result;
    Rsl[constantsSp.OCRGRP_START5 + 21] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 21].result;
    Rsl[constantsSp.OCRGRP_START5 + 30] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 30].result;
    Rsl[constantsSp.OCRGRP_START5 + 22] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 22].result;
    Rsl[constantsSp.OCRGRP_START5 + 31] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 31].result;
    Rsl[constantsSp.OCRGRP_START5 + 32] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 32].result;
    Rsl[constantsSp.OCRGRP_START5 + 34] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 34].result;
    Rsl[constantsSp.OCRGRP_START5 + 33] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 33].result;
    Rsl[constantsSp.OCRGRP_START5 + 35] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START5 + 35].result;

    for (i = 1; i <= 82; i += 1) {
      Rsl[constantsSp.OCRGRP_START6 + i] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START6 + i].result;
      Rsl[constantsSp.OCRGRP_START7 + i] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START7 + i].result;
      Rsl[constantsSp.OCRGRP_START8 + i] = ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START8 + i].result;
    }

    // OCR入力担当者 未設定の場合はログインユーザをデフォルトとする
    let strOpeNameStc;
    try {
      if (!ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].result || ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].result === '') {
        payload = yield call(hainsUserService.getHainsUser, { userid: 'HAINS$', passDecode: true });
        ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].result = payload.usrgrpcd;
      }
      if (ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].result && ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].result !== '') {
        // OCR入力担当者の名称取得
        payload = yield call(itemService.getSentenceWithSuffix, {
          itemCd: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].itemcd,
          itemType: 0,
          stcCd: ocrNyuryoku.ocrresult[constantsSp.OCRGRP_START10].result,
          suffix: '00',
        });
        strOpeNameStc = payload.shortstc;
      } else {
        strOpeNameStc = '※設定なし';
      }
    } catch (error) {
      strOpeNameStc = '';
    }

    let errInfo = {};
    if (ocrNyuryoku && ocrNyuryoku.ocrresult && ocrNyuryoku.ocrresult.length > 0) {
      errInfo = {
        ...errInfo,
        errCount: ocrNyuryoku.errcount,
        errNo: ocrNyuryoku.arrerrno,
        errState: ocrNyuryoku.arrerrstate,
        errMessage: ocrNyuryoku.arrerrmsg,
      };
      try {
        yield put(getOcrNyuryokuSpBodyErrInfoSuccess(errInfo));
      } catch (error) {
        yield put(getOcrNyuryokuSpBodyErrInfoSuccess({ errCount: 0, errNo: [], errState: [], errMessage: [] }));
      }
    }

    initFormValues = {
      ...initFormValues,
      chgRsl,
      Rsl,
      list1_1_1: list111,
      list1_1_2: list112,
      list1_2_1: list121,
      list1_2_2: list122,
      list1_3_1: list131,
      list1_3_2: list132,
      listjikaku1,
      listjikaku2,
      listjikaku3,
      listjikaku4,
      strOpeNameStc,
      lngErrCntE,
      lngErrCntW,
      act,
    };
    yield put(initialize(formName, initFormValues));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const questionnaire1Sagas = [
  // OCR画面を初期化
  takeEvery(loadOcrNyuryokuComHeaderInfo.toString(), runloadOcrNyuryokuComHeaderInfo),
  // OCR内容確認画面を初期化
  takeEvery(openOcrNyuryouku.toString(), runloadOcrNyuryokuInfo),

  takeEvery(getEditOcrDateRequest.toString(), rungetEditOcrDate),
  takeEvery(getOcrNyuryokuSpBodyRequest.toString(), runRequestOcrNyuryokuSpBody),
];

export default questionnaire1Sagas;
