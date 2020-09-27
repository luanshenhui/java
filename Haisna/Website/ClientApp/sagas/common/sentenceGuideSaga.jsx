// @flow

/**
 * @file Saga定義(文章ガイド用)
 */

import { call, takeEvery, put, select } from 'redux-saga/effects';

// タイプのインポート
import type { StateSentenceClass, StateSentence } from '../../types/common/sentenceGuide';

// API Serviceのインポート
import sentenceService, { type SentenceClass, type Sentence } from '../../services/preference/sentenceService';

// Action, Action Creatorのインポート
import {
  actionTypes,
  actions,
  type SentenceGuideState,
  type PayloadSentenceGuideOpenRequest,
  type PayloadSentenceGuideSearchRequest,
  type PayloadSentenceGuideSelectRequest,
} from '../../modules/common/sentenceGuideModule';

// ガイドオープン時に呼び出される関数
function* runOpen(action: { payload: PayloadSentenceGuideOpenRequest }) {
  try {
    // 文章分類一覧取得処理実行
    const { itemCd, itemType } = action.payload;
    const data: Array<SentenceClass> = yield call(sentenceService.getSentenceClassList, { itemCd, itemType });
    // State用の形式に変換
    const sentenceClasses: Array<StateSentenceClass> = data.map((rec) => ({
      stcClassCd: rec.stcclasscd,
      stcClassName: rec.stcclassname,
    }));
    // ガイドオープン処理成功Actionを発行
    yield put(actions.sentenceGuideOpenSuccess({ sentenceClasses }));
    // 文章検索要求Actionを発行
    yield put(actions.sentenceGuideSearchSentenceRequest());
  } catch (error) {
    // 例外時はガイドオープン処理失敗Actionを発行
    yield put(actions.sentenceGuideOpenFailure(error.response));
  }
}

// 文章検索時に呼び出される関数
function* runSearchSentence(action: { payload: ?PayloadSentenceGuideSearchRequest }) {
  // stateの検査項目コード、項目タイプを取得
  const sentenceGuide: SentenceGuideState = yield select((state) => state.app.common.sentenceGuide);
  const { itemCd, itemType } = sentenceGuide;
  // 引数指定された文章分類コードを取得
  const { stcClassCd } = { ...action.payload };
  try {
    // 文章一覧取得処理実行
    const data: Array<Sentence> = yield call(sentenceService.getSentenceList, { itemCd, itemType, stcClassCd });
    // State用の形式に変換
    const sentences: Array<StateSentence> = data.map((rec) => ({
      stcCd: rec.stccd,
      shortStc: rec.shortstc,
    }));
    // 文章検索成功Actionを発行
    yield put(actions.sentenceGuideSearchSentenceSuccess({ sentences }));
  } catch (error) {
    // 例外時は文章検索失敗Actionを発行
    yield put(actions.sentenceGuideSearchSentenceFailure(error.response));
  }
}

// 文章選択時に呼び出される関数
function* runSelectSentence(action: { payload: PayloadSentenceGuideSelectRequest }) {
  // stateの確定時イベントを参照
  const sentenceGuide: SentenceGuideState = yield select((state) => state.app.common.sentenceGuide);
  const { itemCd, itemType, onConfirm } = sentenceGuide;
  try {
    // 文章取得処理実行
    const data: Sentence = yield call(sentenceService.getSentence, { itemCd, itemType, ...action.payload });
    // State用の形式に変換
    const sentence: StateSentence = {
      stcCd: data.stccd,
      shortStc: data.shortstc,
    };
    // 文章選択成功Actionを発行
    yield put(actions.sentenceGuideSelectSentenceSuccess());
    // ガイドクローズActionを発行
    yield put(actions.sentenceGuideClose());
    // 確定時イベントを呼び出す
    if (onConfirm) {
      onConfirm(sentence);
    }
  } catch (error) {
    // 例外時は文章選択失敗Actionを発行
    yield put(actions.sentenceGuideSelectSentenceFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const sentenceGuideSagas = [
  takeEvery(actionTypes.SENTENCE_GUIDE_OPEN_REQUEST, runOpen),
  takeEvery(actionTypes.SENTENCE_GUIDE_SEARCH_SENTENCE_REQUEST, runSearchSentence),
  takeEvery(actionTypes.SENTENCE_GUIDE_SELECT_SENTENCE_REQUEST, runSelectSentence),
];

export default sentenceGuideSagas;
