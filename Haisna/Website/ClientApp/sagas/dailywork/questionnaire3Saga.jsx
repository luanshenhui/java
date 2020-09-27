import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import moment from 'moment';

import consultService from '../../services/reserve/consultService';
import perResultService from '../../services/preference/perResultService';
import questionnaire3Service from '../../services/dailywork/questionnaire3Service';
import hainsUserService from '../../services/preference/hainsUserService';
import itemService from '../../services/preference/sentenceService';

import { OcrNyuryokuBody } from '../../constants/common';

import {
  getOcrNyuryokuSpBody201210Request,
  getOcrNyuryokuSpBody201210ConsultSuccess,
  getOcrNyuryokuSpBody201210ConsultFailure,
  getOcrNyuryokuSpBody201210PerResultGrpSuccess,
  getOcrNyuryokuSpBody201210PerResultGrpFailure,
  getOcrNyuryokuSpBody201210EditOcrDateSuccess,
  getOcrNyuryokuSpBody201210EditOcrDateFailure,
  getOcrNyuryokuSpBody201210OcrNyuryokuSuccess,
  getOcrNyuryokuSpBody201210OcrNyuryokuFailure,
} from '../../modules/dailywork/questionnaire3Module';

const constants = OcrNyuryokuBody.OcrNyuryokuSpBody201210;

// OCR入力結果確認（ボディ）情報の取得
function* runRequestOcrNyuryokuSpBody201210(action) {
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
    yield put(getOcrNyuryokuSpBody201210ConsultSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBody201210ConsultFailure({ ...error.response, rsvno }));
    return;
  }

  try {
    // 個人検査結果情報取得（薬剤（ブスコパン）アレルギー）
    payload = yield call(perResultService.getPerResultList, { perid: payload.perid, grpCd: constants.GRPCD_ALLERGY, getSeqMode: 0, allDataMode: 1 });
    yield put(getOcrNyuryokuSpBody201210PerResultGrpSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBody201210PerResultGrpFailure({ ...error.response, perid: payload.perid }));
    return;
  }

  try {
    // OCR内容確認修正日時を取得する
    payload = yield call(questionnaire3Service.getEditOcrDate, { rsvno });
    yield put(getOcrNyuryokuSpBody201210EditOcrDateSuccess(payload));
  } catch (error) {
    yield put(getOcrNyuryokuSpBody201210EditOcrDateFailure({ ...error.response, rsvno }));
    return;
  }

  if (!act || act === '') {
    // OCR入力結果を取得する
    try {
      payload = yield call(questionnaire3Service.getOcrNyuryoku, { rsvno, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 2, csGrp: 'MONSHIN' });
      yield put(getOcrNyuryokuSpBody201210OcrNyuryokuSuccess(payload));
      ocrNyuryoku = payload;
    } catch (error) {
      yield put(getOcrNyuryokuSpBody201210OcrNyuryokuFailure({ ...error.response, rsvno }));
      return;
    }
  } else {
    // チェック
    if (act === 'check') {
      // OCR入力結果を取得する
      try {
        payload = yield call(questionnaire3Service.checkOcrNyuryoku, { rsvno, data: { results, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 0, csGrp: '' } });
      } catch (error) {
        yield put(getOcrNyuryokuSpBody201210OcrNyuryokuFailure({ ...error.response, rsvno }));
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
          payload = yield call(questionnaire3Service.getOcrNyuryoku, { rsvno, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 0, csGrp: '' });
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
          yield put(getOcrNyuryokuSpBody201210OcrNyuryokuSuccess(payload));
        } catch (error) {
          yield put(getOcrNyuryokuSpBody201210OcrNyuryokuFailure({ ...error.response, rsvno }));
          return;
        }
      }
    }

    // 保存
    if (act === 'save') {
      // 検査結果更新
      try {
        payload = yield call(questionnaire3Service.updateOcrNyuryoku, { rsvno, results });
      } catch (error) {
        act = '';
      }

      // OCR入力結果を取得する(検査結果、エラー情報はチェック結果を使用)
      try {
        payload = yield call(questionnaire3Service.getOcrNyuryoku, { rsvno, grpCd: constants.GRPCD_OCRNYURYOKU2, lastDspMode: 0, csGrp: '' });
        yield put(getOcrNyuryokuSpBody201210OcrNyuryokuSuccess(payload));
        ocrNyuryoku = payload;
        nomsg = 1;
      } catch (error_) {
        yield put(getOcrNyuryokuSpBody201210OcrNyuryokuFailure({ ...error_.response, rsvno }));
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
      // chk1_0_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 1].result,
      // chk1_0_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 2].result,
      opt1_0_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 3].result,
      opt1_0_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 4].result,
      opt1_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 59].result,
      opt1_4_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 60].result,
      // chk1_5_1_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 61].result,
      // chk1_5_1_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 62].result,
      // chk1_5_1_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 63].result,
      // chk1_5_1_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 64].result,
      // chk1_5_1_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 65].result,
      // chk1_5_1_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 66].result,
      // chk1_5_1_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 67].result,
      // chk1_5_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 68].result,
      // chk1_5_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 69].result,
      // chk1_5_2_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 70].result,
      // chk1_5_2_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 71].result,
      // chk1_5_2_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 72].result,
      // chk1_5_2_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 73].result,
      // chk1_5_2_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 74].result,
      // chk1_5_2_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 75].result,
      // chk1_5_2_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 76].result,
      // chk1_5_2_10: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 77].result,
      // chk1_5_2_11: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 78].result,
      // chk1_5_3_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 79].result,
      // chk1_5_3_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 80].result,
      // chk1_5_3_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 81].result,
      // chk1_5_3_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 82].result,
      // chk1_5_3_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 83].result,
      // chk1_5_3_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 84].result,
      // chk1_5_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 85].result,
      // chk1_5_4_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 86].result,
      // chk1_5_4_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 87].result,
      // chk1_5_4_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 88].result,
      opt1_5_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START1 + 89].result,

      opt2_1_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 1].result,
      opt2_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 2].result,
      opt2_3_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 12].result,
      opt2_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 16].result,
      opt2_4_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 18].result,
      opt2_4_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 19].result,
      opt2_4_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 20].result,

      // chk3_1_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START3].result,
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
      // chk3_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 12].result,
      opt3_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 13].result,
      opt3_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 14].result,
      opt3_2_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 15].result,
      opt3_2_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 16].result,
      opt3_2_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 17].result,
      opt3_2_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 18].result,
      opt3_2_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 19].result,
      opt3_2_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 20].result,
      opt3_2_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START3 + 21].result,

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
      // chk4_7_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 18].result,
      // chk4_7_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 19].result,
      // chk4_7_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 20].result,
      // chk4_7_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 21].result,
      // chk4_7_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 22].result,
      // chk4_7_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 23].result,
      // chk4_7_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 24].result,
      // chk4_7_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 25].result,
      // chk4_7_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 26].result,
      // chk4_7_10: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 27].result,
      // chk4_7_11: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 28].result,
      // chk4_7_12: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 29].result,
      // chk4_7_13: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 30].result,
      // chk4_7_14: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 31].result,
      // chk4_7_15: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 32].result,
      // chk4_7_16: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 33].result,
      opt4_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 34].result,
      // chk4_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 37].result,
      opt4_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 38].result,
      // chk4_9_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 39].result,
      opt4_9_1_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 41].result,
      opt4_9_1_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 40].result,
      opt4_9_1_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 43].result,
      // chk4_9_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 44].result,
      opt4_9_2_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 46].result,
      opt4_9_2_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 45].result,
      opt4_9_2_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 48].result,
      // chk4_9_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 49].result,
      opt4_9_3_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 50].result,
      opt4_9_3_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 52].result,
      // chk4_9_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 53].result,
      opt4_9_4_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 55].result,
      // chk4_9_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 56].result,
      opt4_9_5_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 58].result,
      // chk4_9_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 59].result,
      opt4_9_6_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 61].result,
      // chk4_9_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 62].result,
      opt4_9_7_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 64].result,
      // chk4_9_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 65].result,
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
      // chk4_16_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 90].result,
      // chk4_16_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 91].result,
      // chk4_16_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 92].result,
      opt4_17_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 93].result,
      // chk4_17_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 94].result,
      // chk4_17_2: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 95].result,
      // chk4_17_3: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 96].result,
      // chk4_17_4: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 97].result,
      // chk4_17_5: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 98].result,
      // chk4_17_6: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 99].result,
      // chk4_17_7: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 100].result,
      // chk4_17_8: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 101].result,
      // chk4_17_9: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 102].result,
      // chk4_17_10: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 103].result,
      // chk4_17_11: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 104].result,
      // chk4_17_12: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 105].result,
      // chk4_17_13: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 106].result,
      // chk4_17_14: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 107].result,
      // chk4_17_15: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 108].result,
      // chk4_17_16: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 109].result,
      // chk4_17_17: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 110].result,
      // chk4_17_18: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 111].result,
      // chk4_17_19: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 112].result,
      // chk4_17_20: ocrNyuryoku.ocrresult[constants.OCRGRP_START4 + 113].result,
      // chk5_1: ocrNyuryoku.ocrresult[constants.OCRGRP_START5].result,
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
      listjikaku1[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 23 + i * 4].result;
      listjikaku2[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 24 + i * 4].result;
      listjikaku3[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 25 + i * 4].result;
      listjikaku4[i + 1] = ocrNyuryoku.ocrresult[constants.OCRGRP_START2 + 26 + i * 4].result;
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
  takeEvery(getOcrNyuryokuSpBody201210Request.toString(), runRequestOcrNyuryokuSpBody201210),
];

export default questionnaire3Sagas;
