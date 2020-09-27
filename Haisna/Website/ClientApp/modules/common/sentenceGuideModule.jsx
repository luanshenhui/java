// @flow

/**
 * @file Action、Reducer定義(文章ガイド用)
 */

import { handleActions } from 'redux-actions';

// タイプのインポート
import type { ItemType } from '../../types/type';
import type { StateSentenceClass, StateSentence } from '../../types/common/sentenceGuide';

// タイプ定義
export type OnConfirm = (data: StateSentence) => void;
export type PayloadSentenceGuideOpenRequest = { itemCd: string, itemType: ItemType, onConfirm?: OnConfirm };
export type PayloadSentenceGuideSearchRequest = { stcClassCd: ?string };
export type PayloadSentenceGuideSelectRequest = { stcCd: string };

// Actionの定義
export const actionTypes = {
  SENTENCE_GUIDE_OPEN_REQUEST: 'SENTENCE_GUIDE_OPEN_REQUEST',
  SENTENCE_GUIDE_OPEN_SUCCESS: 'SENTENCE_GUIDE_OPEN_SUCCESS',
  SENTENCE_GUIDE_OPEN_FAILURE: 'SENTENCE_GUIDE_OPEN_FAILURE',
  SENTENCE_GUIDE_CLOSE: 'SENTENCE_GUIDE_CLOSE',
  SENTENCE_GUIDE_SEARCH_SENTENCE_REQUEST: 'SENTENCE_GUIDE_SEARCH_SENTENCE_REQUEST',
  SENTENCE_GUIDE_SEARCH_SENTENCE_SUCCESS: 'SENTENCE_GUIDE_SEARCH_SENTENCE_SUCCESS',
  SENTENCE_GUIDE_SEARCH_SENTENCE_FAILURE: 'SENTENCE_GUIDE_SEARCH_SENTENCE_FAILURE',
  SENTENCE_GUIDE_SELECT_SENTENCE_REQUEST: 'SENTENCE_GUIDE_SELECT_SENTENCE_REQUEST',
  SENTENCE_GUIDE_SELECT_SENTENCE_SUCCESS: 'SENTENCE_GUIDE_SELECT_SENTENCE_SUCCESS',
  SENTENCE_GUIDE_SELECT_SENTENCE_FAILURE: 'SENTENCE_GUIDE_SELECT_SENTENCE_FAILURE',
};

// Action Creatorの定義
export const actions = {
  sentenceGuideOpenRequest: (payload: PayloadSentenceGuideOpenRequest, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_OPEN_REQUEST,
    payload,
    meta,
  }),
  sentenceGuideOpenSuccess: (payload: { sentenceClasses: Array<StateSentenceClass> }, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_OPEN_SUCCESS,
    payload,
    meta,
  }),
  sentenceGuideOpenFailure: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_OPEN_FAILURE,
    payload,
    meta,
  }),
  sentenceGuideClose: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_CLOSE,
    payload,
    meta,
  }),
  sentenceGuideSearchSentenceRequest: (payload: ?PayloadSentenceGuideSearchRequest, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_SEARCH_SENTENCE_REQUEST,
    payload,
    meta,
  }),
  sentenceGuideSearchSentenceSuccess: (payload: { sentences: Array<StateSentence> }, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_SEARCH_SENTENCE_SUCCESS,
    payload,
    meta,
  }),
  sentenceGuideSearchSentenceFailure: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_SEARCH_SENTENCE_FAILURE,
    payload,
    meta,
  }),
  sentenceGuideSelectSentenceRequest: (payload: PayloadSentenceGuideSelectRequest, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_SELECT_SENTENCE_REQUEST,
    payload,
    meta,
  }),
  sentenceGuideSelectSentenceSuccess: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_SELECT_SENTENCE_SUCCESS,
    payload,
    meta,
  }),
  sentenceGuideSelectSentenceFailure: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.SENTENCE_GUIDE_SELECT_SENTENCE_FAILURE,
    payload,
    meta,
  }),
};

// stateのタイプ定義
export type SentenceGuideState = {
  // ガイドが表示されているか
  +open: boolean,
  // ローディング中か
  +isLoading: boolean,
  // 検査項目コード
  +itemCd?: string,
  // 項目タイプ
  +itemType?: ItemType,
  // 文章分類一覧
  +sentenceClasses: Array<StateSentenceClass>,
  // 文章リスト
  +sentences: Array<StateSentence>,
  // 確定時イベント
  +onConfirm?: OnConfirm,
};

// stateの初期値
const initialState: SentenceGuideState = {
  open: false,
  isLoading: false,
  sentenceClasses: [],
  sentences: [],
};

// reducerの作成
export default handleActions({
  // ガイドオープン処理要求
  SENTENCE_GUIDE_OPEN_REQUEST: (state: SentenceGuideState, action: { payload: PayloadSentenceGuideOpenRequest }) => ({
    ...initialState,
    ...action.payload,
    open: true,
    isLoading: true,
  }),
  // ガイドオープン処理成功
  SENTENCE_GUIDE_OPEN_SUCCESS: (state: SentenceGuideState, action: { payload: { sentenceClasses: Array<StateSentenceClass> } }) => ({
    ...state,
    ...action.payload,
    isLoading: false,
  }),
  // ガイドオープン処理失敗
  SENTENCE_GUIDE_OPEN_FAILURE: (state: SentenceGuideState) => ({
    ...state,
    isLoading: false,
  }),
  // ガイドクローズ
  SENTENCE_GUIDE_CLOSE: (state: SentenceGuideState) => ({
    ...state,
    open: false,
  }),
  // 文章検索要求
  SENTENCE_GUIDE_SEARCH_SENTENCE_REQUEST: (state: SentenceGuideState) => ({
    ...state,
    isLoading: true,
  }),
  // 文章検索成功
  SENTENCE_GUIDE_SEARCH_SENTENCE_SUCCESS: (state: SentenceGuideState, action: { payload: { sentences: Array<StateSentence> } }) => ({
    ...state,
    ...action.payload,
    isLoading: false,
  }),
  // 文章検索失敗
  SENTENCE_GUIDE_SEARCH_SENTENCE_FAILURE: (state: SentenceGuideState) => ({
    ...state,
    isLoading: false,
  }),
  // 文章選択要求
  SENTENCE_GUIDE_SELECT_SENTENCE_REQUEST: (state: SentenceGuideState) => ({
    ...state,
    isLoading: true,
  }),
  // 文章選択成功
  SENTENCE_GUIDE_SELECT_SENTENCE_SUCCESS: (state: SentenceGuideState) => ({
    ...state,
    isLoading: false,
  }),
  // 文章選択失敗
  SENTENCE_GUIDE_SELECT_SENTENCE_FAILURE: (state: SentenceGuideState) => ({
    ...state,
    isLoading: false,
  }),
}, initialState);
