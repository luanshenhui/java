import { call, takeEvery, put } from 'redux-saga/effects';

import sentenceService from '../../services/preference/sentenceService';
import hainsUserService from '../../services/preference/hainsUserService';

import {
  getHainsUserSuccess,
  getHainsUserFailure,
  getSentenceRequest,
  getSentenceSuccess,
  getSentenceFailure,

} from '../../modules/preference/sentenceModule';

//  内視鏡医フラグ取得Action発生時に起動するメソッド
function* runRequestSentence(action) {
  try {
    // 内視鏡医フラグ取得処理実行
    const payload = yield call(hainsUserService.getHainsUser, action.payload);
    // 内視鏡医フラグ取得成功Actionを発生させる
    yield put(getHainsUserSuccess(payload));

    const { sentencecd, menflg, hanflg, kanflg, eiflg, shinflg, naiflg } = payload;

    const itemtype = 0;
    const suffix = '00';
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
        const stcDataMen = yield call(sentenceService.getSentence, { itemcd: itemparameter[0], itemtype, stccd: sentencecd, suffix });
        if (stcDataMen !== null) {
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
        const stcDataJud = yield call(sentenceService.getSentence, { itemcd: itemparameter[1], itemtype, stccd: sentencecd, suffix });
        if (stcDataJud !== null) {
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
        const stcDataKan = yield call(sentenceService.getSentence, { itemcd: itemparameter[2], itemtype, stccd: sentencecd, suffix });
        if (stcDataKan !== null) {
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
        const stcDataEif = yield call(sentenceService.getSentence, { itemcd: itemparameter[3], itemtype, stccd: sentencecd, suffix });
        if (stcDataEif !== null) {
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
        const stcShi = yield call(sentenceService.getSentence, { itemcd: itemparameter[4], itemtype, stccd: sentencecd, suffix });
        if (stcShi !== null) {
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
        const stcDataNai = yield call(sentenceService.getSentence, { itemcd: itemparameter[5], itemtype, stccd: sentencecd, suffix });
        if (stcDataNai !== null) {
          flagCheck += 1;
          flagNai += 1;
          checkValue[5] = flagCheck;
        }
      } catch (error) {
        // 文章参照コード取得失敗Actionを発生させる
        yield put(getSentenceFailure(error.response));
      }
    }
    yield put(getSentenceSuccess({ flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue }));
  } catch (error) {
    // 内視鏡医フラグ取得失敗Actionを発生させる
    yield put(getHainsUserFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const sentenceSagas = [
  takeEvery(getSentenceRequest.toString(), runRequestSentence),
];

export default sentenceSagas;