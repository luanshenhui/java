import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import moment from 'moment';

import consultService from '../../services/reserve/consultService';
import perResultService from '../../services/preference/perResultService';
import questionnaire2Service from '../../services/dailywork/questionnaire2Service';
import hainsUserService from '../../services/preference/hainsUserService';
import itemService from '../../services/preference/sentenceService';

import { OcrNyuryokuBody } from '../../constants/common';

import {
  getOcrNyuryokuSpBody2Request,
  getOcrNyuryokuSpBody2ConsultSuccess,
  getOcrNyuryokuSpBody2ConsultFailure,
  getOcrNyuryokuSpBody2PerResultGrpSuccess,
  getOcrNyuryokuSpBody2PerResultGrpFailure,
  getOcrNyuryokuSpBody2OcrNyuryokuSuccess,
  getOcrNyuryokuSpBody2OcrNyuryokuFailure,
} from '../../modules/dailywork/questionnaire2Module';

const constants = OcrNyuryokuBody.OcrNyuryokuSpBody2;

// OCR入力結果確認（ボディ）情報の取得
function* runRequestOcrNyuryokuSpBody2(action) {
  const { rsvno, formName } = action.payload;
  let { chgRsl = [] } = action.payload;
  let { act } = action.payload;
  let payload;
  let i;
  let lngErrCntE = 0;
  let lngErrCntW = 0;
  let ocrNyuryoku;
  let initFormValues = {};
  let nomsg = 0;

  const results = [];
  for (i = 0; i < chgRsl.length; i += 1) {
    if (chgRsl[i]) {
      results.push(chgRsl[i]);
    }
  }

  try {
    // 受診情報検索（予約番号より個人情報取得）
    payload = yield call(consultService.getConsult, { rsvno });
    yield put(getOcrNyuryokuSpBody2ConsultSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBody2ConsultFailure({ ...error.response, rsvno }));
    return;
  }

  try {
    // 個人検査結果情報取得（薬剤（ブスコパン）アレルギー）
    payload = yield call(perResultService.getPerResultList, { perid: payload.perid, grpCd: constants.GRPCD_ALLERGY, getSeqMode: 0, allDataMode: 1 });
    yield put(getOcrNyuryokuSpBody2PerResultGrpSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBody2PerResultGrpFailure({ ...error.response, perid: payload.perid }));
    return;
  }

  if (!act || act === '') {
    // OCR入力結果を取得する
    try {
      payload = yield call(questionnaire2Service.getOcrNyuryoku, { rsvno, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 2, csGrp: 'MONSHIN' });
      yield put(getOcrNyuryokuSpBody2OcrNyuryokuSuccess(payload));
      ocrNyuryoku = payload;
    } catch (error) {
      yield put(getOcrNyuryokuSpBody2OcrNyuryokuFailure({ ...error.response, rsvno }));
      return;
    }
  } else {
    // チェック
    if (act === 'check') {
      // OCR入力結果を取得する
      try {
        payload = yield call(questionnaire2Service.checkOcrNyuryoku, { rsvno, data: { results, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 0, csGrp: '' } });
      } catch (error) {
        yield put(getOcrNyuryokuSpBody2OcrNyuryokuFailure({ ...error.response, rsvno }));
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
          payload = yield call(questionnaire2Service.getOcrNyuryoku, { rsvno, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 0, csGrp: '' });
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
          yield put(getOcrNyuryokuSpBody2OcrNyuryokuSuccess(payload));
        } catch (error) {
          yield put(getOcrNyuryokuSpBody2OcrNyuryokuFailure({ ...error.response, rsvno }));
          return;
        }
      }
    }

    // 保存
    if (act === 'save') {
      // 検査結果更新
      try {
        payload = yield call(questionnaire2Service.updateOcrNyuryoku, { rsvno, results });
      } catch (error) {
        act = '';
      }

      // OCR入力結果を取得する(検査結果、エラー情報はチェック結果を使用)
      try {
        payload = yield call(questionnaire2Service.getOcrNyuryoku, { rsvno, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 0, csGrp: '' });
        yield put(getOcrNyuryokuSpBody2OcrNyuryokuSuccess(payload));
        ocrNyuryoku = payload;
        nomsg = 1;
      } catch (error_) {
        yield put(getOcrNyuryokuSpBody2OcrNyuryokuFailure({ ...error_.response, rsvno }));
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
      opt1_0_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1].result,
      opt1_0_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3].result,
      opt1_0_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 4].result,
      opt1_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 59].result,
      opt1_4_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 60].result,
      opt1_5_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 89].result,

      opt2_1_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 1].result,
      opt2_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 2].result,
      opt2_3_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 12].result,
      opt2_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 16].result,
      opt2_4_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 18].result,
      opt2_4_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 19].result,
      opt2_4_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 20].result,

      opt2_4_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 23].result,
      opt2_4_7_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 24].result,
      opt2_71: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 24].result,
      opt2_4_7_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 25].result,
      opt2_4_7_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 26].result,
      opt2_4_7_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 29].result,
      chk2_4_7_6_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 30].result,
      chk2_4_7_6_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 31].result,
      chk2_4_7_6_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 32].result,
      chk2_4_7_6_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 33].result,
      chk2_4_7_6_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 34].result,
      opt2_4_7_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 35].result,
      opt2_4_7_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 36].result,

      opt3_1_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 1].result,
      opt3_1_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 2].result,
      opt3_1_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 3].result,
      opt3_1_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 4].result,
      opt3_1_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 5].result,
      opt3_1_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 6].result,
      opt3_1_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 7].result,
      opt3_1_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 8].result,
      opt3_1_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 9].result,
      opt3_1_10: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 10].result,
      opt3_1_11: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 11].result,
      opt3_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 13].result,
      opt3_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 14].result,
      opt3_2_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 15].result,
      opt3_2_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 16].result,
      opt3_2_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 17].result,
      opt3_2_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 18].result,
      opt3_2_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 19].result,
      opt3_2_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 20].result,
      opt3_2_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 21].result,
      opt3_2_10: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 22].result,
      opt3_2_11: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 23].result,
      opt3_2_12: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 24].result,

      opt4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4].result,
      opt4_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 1].result,
      opt4_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 2].result,
      opt4_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 3].result,
      opt4_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 4].result,
      opt4_4_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 5].result,
      opt4_4_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 6].result,
      opt4_4_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 7].result,
      opt4_4_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 8].result,
      opt4_5_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 9].result,
      opt4_5_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 10].result,
      opt4_5_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 11].result,
      opt4_5_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 12].result,
      opt4_6_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 13].result,
      opt4_6_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 14].result,
      opt4_6_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 15].result,
      opt4_6_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 16].result,
      opt4_6_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 17].result,

      opt4_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 34].result,

      opt4_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 38].result,

      opt4_9_1_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 41].result,
      opt4_9_1_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 40].result,
      opt4_9_1_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 43].result,

      opt4_9_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 46].result,
      opt4_9_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 45].result,
      opt4_9_2_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 48].result,

      opt4_9_3_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 50].result,
      opt4_9_3_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 52].result,

      opt4_9_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 55].result,

      opt4_9_5_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 58].result,

      opt4_9_6_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 61].result,

      opt4_9_7_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 64].result,

      opt4_9_8_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 67].result,
      opt4_10_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 68].result,
      opt4_11_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 69].result,
      opt4_13_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 73].result,
      date14_1: moment([
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 75].result,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 76].result - 1,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 77].result]),
      date14_2: moment([
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 75].result,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 78].result - 1,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 79].result]),
      date14_3: moment([
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 80].result,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 81].result - 1,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 82].result]),
      date14_4: moment([
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 80].result,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 83].result - 1,
        ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 84].result]),
      opt4_14_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 85].result,
      opt4_14_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 86].result,
      opt4_15_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 87].result,
      opt4_15_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 88].result,
      opt4_16_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 89].result,

      opt4_17_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 93].result,

      opt5_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 1].result,
      opt5_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 2].result,
      opt5_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 3].result,
      opt5_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 4].result,
      opt5_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 5].result,
      opt5_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 6].result,
      opt5_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 7].result,
      opt5_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 8].result,
      opt5_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 9].result,
      opt5_10: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 10].result,
      opt5_11: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 11].result,
      opt5_12: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 12].result,
      opt5_13: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 13].result,
      opt5_14: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 14].result,
      opt5_15: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 15].result,
      opt5_16: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 16].result,
      opt5_17: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 17].result,
      opt5_18: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 18].result,
      opt5_19: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 19].result,
      opt5_20: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 20].result,
      opt5_21: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 21].result,

      opt5_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 3].result,
      opt5_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 4].result,
      opt5_2_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 5].result,
      opt5_2_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 7].result,
      opt5_2_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 8].result,
      opt5_2_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 9].result,
      opt5_2_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 10].result,
      opt5_2_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 11].result,
      opt5_2_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 13].result,

      opt6_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START6].result,
      opt7_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START7].result,
      opt8_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START8].result,

      opt9_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START9].result,
      opt9_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START9 + 1].result,

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

    for (i = 0; i < constants.NOWDISEASE_COUNT; i += 1) {
      list111[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 5 + i * 3].result;
      Rsl[constants.OCRGRP_START1 + 6 + i * 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 6 + i * 3].result;
      list112[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 7 + i * 3].result;
    }

    for (i = 0; i < constants.DISEASEHIST_COUNT; i += 1) {
      list121[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 23 + i * 3].result;
      Rsl[constants.OCRGRP_START1 + 24 + i * 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 24 + i * 3].result;
      list122[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 25 + i * 3].result;
    }

    for (i = 0; i < constants.FAMILYHIST_COUNT; i += 1) {
      list131[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 41 + i * 3].result;
      Rsl[constants.OCRGRP_START1 + 42 + i * 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 42 + i * 3].result;
      list132[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 43 + i * 3].result;
    }

    for (i = 0; i < constants.JIKAKUSHOUJYOU_COUNT; i += 1) {
      listjikaku1[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 37 + i * 4].result;
      listjikaku2[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 38 + i * 4].result;
      listjikaku3[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 39 + i * 4].result;
      listjikaku4[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 40 + i * 4].result;
    }

    Rsl[constants.OCRGRP_START2] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2].result;
    Rsl[constants.OCRGRP_START2 + 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 3].result;
    Rsl[constants.OCRGRP_START2 + 4] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 4].result;
    Rsl[constants.OCRGRP_START2 + 5] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 5].result;
    Rsl[constants.OCRGRP_START2 + 6] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 6].result;
    Rsl[constants.OCRGRP_START2 + 7] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 7].result;
    Rsl[constants.OCRGRP_START2 + 8] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 8].result;
    Rsl[constants.OCRGRP_START2 + 9] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 9].result;
    Rsl[constants.OCRGRP_START2 + 10] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 10].result;
    Rsl[constants.OCRGRP_START2 + 11] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 11].result;
    Rsl[constants.OCRGRP_START2 + 13] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 13].result;
    Rsl[constants.OCRGRP_START2 + 14] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 14].result;
    Rsl[constants.OCRGRP_START2 + 15] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 15].result;
    Rsl[constants.OCRGRP_START2 + 17] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 17].result;
    Rsl[constants.OCRGRP_START2 + 21] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 21].result;
    Rsl[constants.OCRGRP_START2 + 22] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 22].result;
    Rsl[constants.OCRGRP_START2 + 27] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 27].result;
    Rsl[constants.OCRGRP_START2 + 28] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 28].result;

    Rsl[constants.OCRGRP_START4 + 35] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 35].result;
    Rsl[constants.OCRGRP_START4 + 36] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 36].result;
    Rsl[constants.OCRGRP_START4 + 42] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 42].result;
    Rsl[constants.OCRGRP_START4 + 47] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 47].result;
    Rsl[constants.OCRGRP_START4 + 51] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 51].result;
    Rsl[constants.OCRGRP_START4 + 54] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 54].result;
    Rsl[constants.OCRGRP_START4 + 57] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 57].result;
    Rsl[constants.OCRGRP_START4 + 60] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 60].result;
    Rsl[constants.OCRGRP_START4 + 63] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 63].result;
    Rsl[constants.OCRGRP_START4 + 66] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 66].result;
    Rsl[constants.OCRGRP_START4 + 70] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 70].result;
    Rsl[constants.OCRGRP_START4 + 71] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 71].result;
    Rsl[constants.OCRGRP_START4 + 72] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 72].result;
    Rsl[constants.OCRGRP_START4 + 74] = ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 74].result;

    Rsl[constants.OCRGRP_START2 + 27] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 27].result;
    Rsl[constants.OCRGRP_START2 + 28] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 28].result;
    Rsl[constants.OCRGRP_START5 + 6] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 6].result;
    Rsl[constants.OCRGRP_START5 + 12] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 12].result;
    Rsl[constants.OCRGRP_START5 + 2] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 2].result;

    Rsl[constants.OCRGRP_START6 + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 1].result;
    Rsl[constants.OCRGRP_START6 + 2] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 2].result;
    Rsl[constants.OCRGRP_START6 + 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 3].result;
    Rsl[constants.OCRGRP_START6 + 4] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 4].result;
    Rsl[constants.OCRGRP_START6 + 5] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 5].result;
    Rsl[constants.OCRGRP_START6 + 6] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 6].result;
    Rsl[constants.OCRGRP_START6 + 7] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 7].result;
    Rsl[constants.OCRGRP_START6 + 8] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 8].result;
    Rsl[constants.OCRGRP_START6 + 9] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 9].result;
    Rsl[constants.OCRGRP_START6 + 10] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 10].result;
    Rsl[constants.OCRGRP_START6 + 11] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 11].result;
    Rsl[constants.OCRGRP_START6 + 12] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 12].result;
    Rsl[constants.OCRGRP_START6 + 13] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 13].result;
    Rsl[constants.OCRGRP_START6 + 14] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 14].result;
    Rsl[constants.OCRGRP_START6 + 15] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 15].result;
    Rsl[constants.OCRGRP_START6 + 16] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 16].result;
    Rsl[constants.OCRGRP_START6 + 17] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 17].result;
    Rsl[constants.OCRGRP_START6 + 18] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 18].result;
    Rsl[constants.OCRGRP_START6 + 19] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 19].result;
    Rsl[constants.OCRGRP_START6 + 20] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 20].result;
    Rsl[constants.OCRGRP_START6 + 21] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 21].result;
    Rsl[constants.OCRGRP_START6 + 22] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 22].result;
    Rsl[constants.OCRGRP_START6 + 23] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 23].result;
    Rsl[constants.OCRGRP_START6 + 24] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 24].result;
    Rsl[constants.OCRGRP_START6 + 25] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 25].result;
    Rsl[constants.OCRGRP_START6 + 26] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 26].result;
    Rsl[constants.OCRGRP_START6 + 27] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 27].result;
    Rsl[constants.OCRGRP_START6 + 28] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 28].result;
    Rsl[constants.OCRGRP_START6 + 29] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 29].result;
    Rsl[constants.OCRGRP_START6 + 30] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 30].result;
    Rsl[constants.OCRGRP_START6 + 31] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 31].result;
    Rsl[constants.OCRGRP_START6 + 32] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 32].result;
    Rsl[constants.OCRGRP_START6 + 33] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 33].result;
    Rsl[constants.OCRGRP_START6 + 34] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 34].result;
    Rsl[constants.OCRGRP_START6 + 35] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 35].result;
    Rsl[constants.OCRGRP_START6 + 36] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 36].result;
    Rsl[constants.OCRGRP_START6 + 37] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 37].result;
    Rsl[constants.OCRGRP_START6 + 42] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 42].result;
    Rsl[constants.OCRGRP_START6 + 43] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 43].result;
    Rsl[constants.OCRGRP_START6 + 44] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 44].result;
    Rsl[constants.OCRGRP_START6 + 38] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 38].result;
    Rsl[constants.OCRGRP_START6 + 39] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 39].result;
    Rsl[constants.OCRGRP_START6 + 40] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 40].result;
    Rsl[constants.OCRGRP_START6 + 41] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 41].result;
    Rsl[constants.OCRGRP_START6 + 45] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 45].result;
    Rsl[constants.OCRGRP_START6 + 46] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 46].result;
    Rsl[constants.OCRGRP_START6 + 47] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 47].result;
    Rsl[constants.OCRGRP_START6 + 48] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 48].result;
    Rsl[constants.OCRGRP_START6 + 49] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 49].result;
    Rsl[constants.OCRGRP_START6 + 50] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 50].result;
    Rsl[constants.OCRGRP_START6 + 51] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 51].result;
    Rsl[constants.OCRGRP_START6 + 52] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 52].result;
    Rsl[constants.OCRGRP_START6 + 53] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 53].result;
    Rsl[constants.OCRGRP_START6 + 54] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 54].result;
    Rsl[constants.OCRGRP_START6 + 55] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 55].result;
    Rsl[constants.OCRGRP_START6 + 56] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 56].result;
    Rsl[constants.OCRGRP_START6 + 57] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 57].result;
    Rsl[constants.OCRGRP_START6 + 58] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 58].result;
    Rsl[constants.OCRGRP_START6 + 59] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 59].result;
    Rsl[constants.OCRGRP_START6 + 60] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 60].result;
    Rsl[constants.OCRGRP_START6 + 61] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 61].result;
    Rsl[constants.OCRGRP_START6 + 62] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 62].result;
    Rsl[constants.OCRGRP_START6 + 63] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 63].result;
    Rsl[constants.OCRGRP_START6 + 64] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 64].result;
    Rsl[constants.OCRGRP_START6 + 65] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 65].result;
    Rsl[constants.OCRGRP_START6 + 66] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 66].result;
    Rsl[constants.OCRGRP_START6 + 67] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 67].result;
    Rsl[constants.OCRGRP_START6 + 68] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 68].result;
    Rsl[constants.OCRGRP_START6 + 69] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 69].result;
    Rsl[constants.OCRGRP_START6 + 70] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 70].result;
    Rsl[constants.OCRGRP_START6 + 71] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 71].result;
    Rsl[constants.OCRGRP_START6 + 72] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 72].result;
    Rsl[constants.OCRGRP_START6 + 73] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 73].result;
    Rsl[constants.OCRGRP_START6 + 74] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 74].result;
    Rsl[constants.OCRGRP_START6 + 75] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 75].result;
    Rsl[constants.OCRGRP_START6 + 76] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 76].result;
    Rsl[constants.OCRGRP_START6 + 77] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 77].result;
    Rsl[constants.OCRGRP_START6 + 78] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 78].result;
    Rsl[constants.OCRGRP_START6 + 79] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 79].result;
    Rsl[constants.OCRGRP_START6 + 80] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 80].result;
    Rsl[constants.OCRGRP_START6 + 81] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 81].result;
    Rsl[constants.OCRGRP_START6 + 82] = ocrNyuryoku.ocrresult[constants.OCRGRP_START6 + 82].result;

    Rsl[constants.OCRGRP_START7 + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 1].result;
    Rsl[constants.OCRGRP_START7 + 2] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 2].result;
    Rsl[constants.OCRGRP_START7 + 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 3].result;
    Rsl[constants.OCRGRP_START7 + 4] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 4].result;
    Rsl[constants.OCRGRP_START7 + 5] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 5].result;
    Rsl[constants.OCRGRP_START7 + 6] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 6].result;
    Rsl[constants.OCRGRP_START7 + 7] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 7].result;
    Rsl[constants.OCRGRP_START7 + 8] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 8].result;
    Rsl[constants.OCRGRP_START7 + 9] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 9].result;
    Rsl[constants.OCRGRP_START7 + 10] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 10].result;
    Rsl[constants.OCRGRP_START7 + 11] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 11].result;
    Rsl[constants.OCRGRP_START7 + 12] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 12].result;
    Rsl[constants.OCRGRP_START7 + 13] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 13].result;
    Rsl[constants.OCRGRP_START7 + 14] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 14].result;
    Rsl[constants.OCRGRP_START7 + 15] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 15].result;
    Rsl[constants.OCRGRP_START7 + 16] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 16].result;
    Rsl[constants.OCRGRP_START7 + 17] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 17].result;
    Rsl[constants.OCRGRP_START7 + 18] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 18].result;
    Rsl[constants.OCRGRP_START7 + 19] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 19].result;
    Rsl[constants.OCRGRP_START7 + 20] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 20].result;
    Rsl[constants.OCRGRP_START7 + 21] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 21].result;
    Rsl[constants.OCRGRP_START7 + 22] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 22].result;
    Rsl[constants.OCRGRP_START7 + 23] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 23].result;
    Rsl[constants.OCRGRP_START7 + 24] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 24].result;
    Rsl[constants.OCRGRP_START7 + 25] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 25].result;
    Rsl[constants.OCRGRP_START7 + 26] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 26].result;
    Rsl[constants.OCRGRP_START7 + 27] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 27].result;
    Rsl[constants.OCRGRP_START7 + 28] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 28].result;
    Rsl[constants.OCRGRP_START7 + 29] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 29].result;
    Rsl[constants.OCRGRP_START7 + 30] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 30].result;
    Rsl[constants.OCRGRP_START7 + 31] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 31].result;
    Rsl[constants.OCRGRP_START7 + 32] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 32].result;
    Rsl[constants.OCRGRP_START7 + 33] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 33].result;
    Rsl[constants.OCRGRP_START7 + 34] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 34].result;
    Rsl[constants.OCRGRP_START7 + 35] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 35].result;
    Rsl[constants.OCRGRP_START7 + 36] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 36].result;
    Rsl[constants.OCRGRP_START7 + 37] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 37].result;
    Rsl[constants.OCRGRP_START7 + 38] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 38].result;
    Rsl[constants.OCRGRP_START7 + 39] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 39].result;
    Rsl[constants.OCRGRP_START7 + 40] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 40].result;
    Rsl[constants.OCRGRP_START7 + 41] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 41].result;
    Rsl[constants.OCRGRP_START7 + 42] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 42].result;
    Rsl[constants.OCRGRP_START7 + 43] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 43].result;
    Rsl[constants.OCRGRP_START7 + 44] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 44].result;
    Rsl[constants.OCRGRP_START7 + 45] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 45].result;
    Rsl[constants.OCRGRP_START7 + 46] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 46].result;
    Rsl[constants.OCRGRP_START7 + 47] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 47].result;
    Rsl[constants.OCRGRP_START7 + 48] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 48].result;
    Rsl[constants.OCRGRP_START7 + 49] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 49].result;
    Rsl[constants.OCRGRP_START7 + 50] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 50].result;
    Rsl[constants.OCRGRP_START7 + 51] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 51].result;
    Rsl[constants.OCRGRP_START7 + 52] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 52].result;
    Rsl[constants.OCRGRP_START7 + 53] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 53].result;
    Rsl[constants.OCRGRP_START7 + 54] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 54].result;
    Rsl[constants.OCRGRP_START7 + 55] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 55].result;
    Rsl[constants.OCRGRP_START7 + 56] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 56].result;
    Rsl[constants.OCRGRP_START7 + 57] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 57].result;
    Rsl[constants.OCRGRP_START7 + 58] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 58].result;
    Rsl[constants.OCRGRP_START7 + 59] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 59].result;
    Rsl[constants.OCRGRP_START7 + 60] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 60].result;
    Rsl[constants.OCRGRP_START7 + 61] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 61].result;
    Rsl[constants.OCRGRP_START7 + 62] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 62].result;
    Rsl[constants.OCRGRP_START7 + 63] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 63].result;
    Rsl[constants.OCRGRP_START7 + 64] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 64].result;
    Rsl[constants.OCRGRP_START7 + 65] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 65].result;
    Rsl[constants.OCRGRP_START7 + 66] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 66].result;
    Rsl[constants.OCRGRP_START7 + 67] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 67].result;
    Rsl[constants.OCRGRP_START7 + 68] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 68].result;
    Rsl[constants.OCRGRP_START7 + 69] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 69].result;
    Rsl[constants.OCRGRP_START7 + 70] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 70].result;
    Rsl[constants.OCRGRP_START7 + 71] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 71].result;
    Rsl[constants.OCRGRP_START7 + 72] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 72].result;
    Rsl[constants.OCRGRP_START7 + 73] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 73].result;
    Rsl[constants.OCRGRP_START7 + 74] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 74].result;
    Rsl[constants.OCRGRP_START7 + 75] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 75].result;
    Rsl[constants.OCRGRP_START7 + 76] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 76].result;
    Rsl[constants.OCRGRP_START7 + 77] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 77].result;
    Rsl[constants.OCRGRP_START7 + 78] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 78].result;
    Rsl[constants.OCRGRP_START7 + 79] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 79].result;
    Rsl[constants.OCRGRP_START7 + 80] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 80].result;
    Rsl[constants.OCRGRP_START7 + 81] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 81].result;
    Rsl[constants.OCRGRP_START7 + 82] = ocrNyuryoku.ocrresult[constants.OCRGRP_START7 + 82].result;

    Rsl[constants.OCRGRP_START8 + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 1].result;
    Rsl[constants.OCRGRP_START8 + 2] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 2].result;
    Rsl[constants.OCRGRP_START8 + 3] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 3].result;
    Rsl[constants.OCRGRP_START8 + 4] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 4].result;
    Rsl[constants.OCRGRP_START8 + 5] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 5].result;
    Rsl[constants.OCRGRP_START8 + 6] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 6].result;
    Rsl[constants.OCRGRP_START8 + 7] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 7].result;
    Rsl[constants.OCRGRP_START8 + 8] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 8].result;
    Rsl[constants.OCRGRP_START8 + 9] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 9].result;
    Rsl[constants.OCRGRP_START8 + 10] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 10].result;
    Rsl[constants.OCRGRP_START8 + 11] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 11].result;
    Rsl[constants.OCRGRP_START8 + 12] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 12].result;
    Rsl[constants.OCRGRP_START8 + 13] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 13].result;
    Rsl[constants.OCRGRP_START8 + 14] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 14].result;
    Rsl[constants.OCRGRP_START8 + 15] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 15].result;
    Rsl[constants.OCRGRP_START8 + 16] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 16].result;
    Rsl[constants.OCRGRP_START8 + 17] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 17].result;
    Rsl[constants.OCRGRP_START8 + 18] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 18].result;
    Rsl[constants.OCRGRP_START8 + 19] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 19].result;
    Rsl[constants.OCRGRP_START8 + 20] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 20].result;
    Rsl[constants.OCRGRP_START8 + 21] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 21].result;
    Rsl[constants.OCRGRP_START8 + 22] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 22].result;
    Rsl[constants.OCRGRP_START8 + 23] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 23].result;
    Rsl[constants.OCRGRP_START8 + 24] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 24].result;
    Rsl[constants.OCRGRP_START8 + 25] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 25].result;
    Rsl[constants.OCRGRP_START8 + 26] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 26].result;
    Rsl[constants.OCRGRP_START8 + 27] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 27].result;
    Rsl[constants.OCRGRP_START8 + 28] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 28].result;
    Rsl[constants.OCRGRP_START8 + 29] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 29].result;
    Rsl[constants.OCRGRP_START8 + 30] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 30].result;
    Rsl[constants.OCRGRP_START8 + 31] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 31].result;
    Rsl[constants.OCRGRP_START8 + 32] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 32].result;
    Rsl[constants.OCRGRP_START8 + 33] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 33].result;
    Rsl[constants.OCRGRP_START8 + 34] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 34].result;
    Rsl[constants.OCRGRP_START8 + 35] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 35].result;
    Rsl[constants.OCRGRP_START8 + 36] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 36].result;
    Rsl[constants.OCRGRP_START8 + 37] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 37].result;
    Rsl[constants.OCRGRP_START8 + 38] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 38].result;
    Rsl[constants.OCRGRP_START8 + 39] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 39].result;
    Rsl[constants.OCRGRP_START8 + 40] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 40].result;
    Rsl[constants.OCRGRP_START8 + 41] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 41].result;
    Rsl[constants.OCRGRP_START8 + 42] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 42].result;
    Rsl[constants.OCRGRP_START8 + 43] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 43].result;
    Rsl[constants.OCRGRP_START8 + 44] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 44].result;
    Rsl[constants.OCRGRP_START8 + 45] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 45].result;
    Rsl[constants.OCRGRP_START8 + 46] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 46].result;
    Rsl[constants.OCRGRP_START8 + 47] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 47].result;
    Rsl[constants.OCRGRP_START8 + 48] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 48].result;
    Rsl[constants.OCRGRP_START8 + 49] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 49].result;
    Rsl[constants.OCRGRP_START8 + 50] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 50].result;
    Rsl[constants.OCRGRP_START8 + 51] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 51].result;
    Rsl[constants.OCRGRP_START8 + 52] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 52].result;
    Rsl[constants.OCRGRP_START8 + 53] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 53].result;
    Rsl[constants.OCRGRP_START8 + 54] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 54].result;
    Rsl[constants.OCRGRP_START8 + 55] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 55].result;
    Rsl[constants.OCRGRP_START8 + 56] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 56].result;
    Rsl[constants.OCRGRP_START8 + 57] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 57].result;
    Rsl[constants.OCRGRP_START8 + 58] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 58].result;
    Rsl[constants.OCRGRP_START8 + 59] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 59].result;
    Rsl[constants.OCRGRP_START8 + 60] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 60].result;
    Rsl[constants.OCRGRP_START8 + 61] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 61].result;
    Rsl[constants.OCRGRP_START8 + 62] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 62].result;
    Rsl[constants.OCRGRP_START8 + 63] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 63].result;
    Rsl[constants.OCRGRP_START8 + 64] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 64].result;
    Rsl[constants.OCRGRP_START8 + 65] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 65].result;
    Rsl[constants.OCRGRP_START8 + 66] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 66].result;
    Rsl[constants.OCRGRP_START8 + 67] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 67].result;
    Rsl[constants.OCRGRP_START8 + 68] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 68].result;
    Rsl[constants.OCRGRP_START8 + 69] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 69].result;
    Rsl[constants.OCRGRP_START8 + 70] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 70].result;
    Rsl[constants.OCRGRP_START8 + 71] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 71].result;
    Rsl[constants.OCRGRP_START8 + 72] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 72].result;
    Rsl[constants.OCRGRP_START8 + 73] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 73].result;
    Rsl[constants.OCRGRP_START8 + 74] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 74].result;
    Rsl[constants.OCRGRP_START8 + 75] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 75].result;
    Rsl[constants.OCRGRP_START8 + 76] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 76].result;
    Rsl[constants.OCRGRP_START8 + 77] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 77].result;
    Rsl[constants.OCRGRP_START8 + 78] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 78].result;
    Rsl[constants.OCRGRP_START8 + 79] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 79].result;
    Rsl[constants.OCRGRP_START8 + 80] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 80].result;
    Rsl[constants.OCRGRP_START8 + 81] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 81].result;
    Rsl[constants.OCRGRP_START8 + 82] = ocrNyuryoku.ocrresult[constants.OCRGRP_START8 + 82].result;

    Rsl[constants.OCRGRP_START5 + 14] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 14].result;
    Rsl[constants.OCRGRP_START5 + 15] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 15].result;
    Rsl[constants.OCRGRP_START5 + 16] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 16].result;
    Rsl[constants.OCRGRP_START5 + 17] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 17].result;
    Rsl[constants.OCRGRP_START5 + 18] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 18].result;
    Rsl[constants.OCRGRP_START5 + 19] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 19].result;
    Rsl[constants.OCRGRP_START5 + 20] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 20].result;
    Rsl[constants.OCRGRP_START5 + 21] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 21].result;
    Rsl[constants.OCRGRP_START5 + 22] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 22].result;
    Rsl[constants.OCRGRP_START5 + 23] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 23].result;
    Rsl[constants.OCRGRP_START5 + 24] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 24].result;
    Rsl[constants.OCRGRP_START5 + 25] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 25].result;
    Rsl[constants.OCRGRP_START5 + 26] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 26].result;
    Rsl[constants.OCRGRP_START5 + 27] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 27].result;
    Rsl[constants.OCRGRP_START5 + 28] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 28].result;
    Rsl[constants.OCRGRP_START5 + 29] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 29].result;
    Rsl[constants.OCRGRP_START5 + 30] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 30].result;
    Rsl[constants.OCRGRP_START5 + 31] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 31].result;
    Rsl[constants.OCRGRP_START5 + 32] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 32].result;
    Rsl[constants.OCRGRP_START5 + 33] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 33].result;
    Rsl[constants.OCRGRP_START5 + 34] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 34].result;
    Rsl[constants.OCRGRP_START5 + 35] = ocrNyuryoku.ocrresult[constants.OCRGRP_START5 + 35].result;

    // OCR入力担当者 未設定の場合はログインユーザをデフォルトとする
    let strOpeNameStc;
    try {
      if (!ocrNyuryoku.ocrresult[constants.OCRGRP_START10].result || ocrNyuryoku.ocrresult[constants.OCRGRP_START10].result === '') {
        payload = yield call(hainsUserService.getHainsUser, { userid: 'HAINS$', passDecode: true });
        ocrNyuryoku.ocrresult[constants.OCRGRP_START10].result = payload.usrgrpcd;
      }
      if (ocrNyuryoku.ocrresult[constants.OCRGRP_START10].result && ocrNyuryoku.ocrresult[constants.OCRGRP_START10].result !== '') {
        // OCR入力担当者の名称取得
        payload = yield call(itemService.getSentenceWithSuffix, {
          itemCd: ocrNyuryoku.ocrresult[constants.OCRGRP_START10].itemcd,
          itemType: 0,
          stcCd: ocrNyuryoku.ocrresult[constants.OCRGRP_START10].result,
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
      errInfo,
      nomsg,
    };
    yield put(initialize(formName, initFormValues));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const questionnaire3Sagas = [
  takeEvery(getOcrNyuryokuSpBody2Request.toString(), runRequestOcrNyuryokuSpBody2),
];

export default questionnaire3Sagas;
