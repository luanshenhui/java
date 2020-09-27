import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  openCommentDetailGuide,
  closeCommentDetailGuide,
  loadCommentDetailSuccess,
  loadCommentDetailFailure,
  registerPubNoteRequest,
  registerPubNoteSuccess,
  registerPubNoteFailure,
  deletePubNoteRequest,
  deletePubNoteSuccess,
  deletePubNoteFailure,
  setPubNoteDivState,
  changePubNoteDiv,
  loadCommentListFlameGuideRequest,
  loadCommentListFlameGuideSuccess,
  loadCommentListFlameGuideFailure,
  searchCommentListRequest,
  searchCommentListSuccess,
  searchCommentListFailure,
  openCommentListFlameGuide,
  closeCommentListFlameGuide,
} = createActions(
  // コメント情報初期処理
  'OPEN_COMMENT_DETAIL_GUIDE',
  'CLOSE_COMMENT_DETAIL_GUIDE',
  'LOAD_COMMENT_DETAIL_SUCCESS',
  'LOAD_COMMENT_DETAIL_FAILURE',
  // コメント情報登録処理
  'REGISTER_PUB_NOTE_REQUEST',
  'REGISTER_PUB_NOTE_SUCCESS',
  'REGISTER_PUB_NOTE_FAILURE',
  // コメント情報削除処理
  'DELETE_PUB_NOTE_REQUEST',
  'DELETE_PUB_NOTE_SUCCESS',
  'DELETE_PUB_NOTE_FAILURE',
  // ノート分類設定
  'SET_PUB_NOTE_DIV_STATE',
  // ノート分類 表示対象設定
  'CHANGE_PUB_NOTE_DIV',
  // コメント検索画面の初期処理
  'LOAD_COMMENT_LIST_FLAME_GUIDE_REQUEST',
  'LOAD_COMMENT_LIST_FLAME_GUIDE_SUCCESS',
  'LOAD_COMMENT_LIST_FLAME_GUIDE_FAILURE',
  // コメント検索
  'SEARCH_COMMENT_LIST_REQUEST',
  'SEARCH_COMMENT_LIST_SUCCESS',
  'SEARCH_COMMENT_LIST_FAILURE',
  // コメント検索ガイドを開
  'OPEN_COMMENT_LIST_FLAME_GUIDE',
  // コメント検索ガイドを閉
  'CLOSE_COMMENT_LIST_FLAME_GUIDE',
);

// stateの初期値
const initialState = {

  commentDetailGuide: {
    message: [],
    // ガイドの表示状態
    visible: false,
    // 受診情報
    consultdata: {},
    // 個人ＩＤ情報
    perdata: {},
    // ユーザ情報
    userdata: {},
    // コメント情報
    data: {},
    // ノート分類
    pubnotediv: [],
  },

  commentListFlameGuide: {
    message: [],
    hainsUserData: null,
    pubNoteData1: null,
    pubNoteData2: null,
    pubNoteData3: null,
    pubNoteData4: null,
    pubNoteData5: null,
    pubNoteData6: null,
    free: null,
    consult: null,
    // ガイドの表示状態
    visible: false,
    params: {
      orgcd1: null,
      orgcd2: null,
      dispmode: null,
      cmtmode: null,
      perid: null,
      rsvno: null,
      ctrptcd: null,
      startdate: null,
      enddate: null,
      pubnotedivcd: null,
      pubnotedivcdctr: null,
      pubnotedivcdorg: null,
      dispkbn: null,
      delnote: null,
      winmode: null,
      act: null,
      selinfo: null,
      histflg: null,
      incdelnote: null,
      Chk: '0',
    },
    detailRefresh: false,
  },
};

// reducerの作成
export default handleActions({
  // コメント情報詳細ガイドを開くアクション時の処理
  [openCommentDetailGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { commentDetailGuide } = initialState;
    const { commentListFlameGuide } = state;
    return { ...state, commentDetailGuide: { ...commentDetailGuide, visible }, commentListFlameGuide: { ...commentListFlameGuide, detailRefresh: false } };
  },
  // コメント情報詳細ガイドを閉じるアクション時の処理
  [closeCommentDetailGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { commentDetailGuide } = initialState;
    return { ...state, commentDetailGuide };
  },
  // コメント情報詳細取得成功時の処理
  [loadCommentDetailSuccess]: (state, action) => {
    const { commentDetailGuide } = state;
    const { consultdata, perdata, userdata, data } = action.payload;
    return { ...state, commentDetailGuide: { ...commentDetailGuide, consultdata, perdata, userdata, data } };
  },
  // コメント情報詳細取得失敗時の処理
  [loadCommentDetailFailure]: (state, action) => {
    const { commentDetailGuide } = state;
    const { errkbn, error, rsvno, perid, seq } = action.payload;
    let message = [];
    if (errkbn) {
      if (errkbn === 1) {
        message = error;
      } else if (errkbn === 2) {
        message = [`受診情報が存在しません。（予約番号= ${rsvno} ）`];
      } else if (errkbn === 3) {
        message = [`個人情報が取得できません。（個人ＩＤ= ${perid} ）`];
      } else if (errkbn === 4) {
        message = [`コメント情報が取得できません。（SEQ= ${seq} ）`];
      }
    }
    return { ...state, commentDetailGuide: { ...commentDetailGuide, message } };
  },
  // コメント情報詳細登録成功時の処理
  [registerPubNoteSuccess]: (state) => {
    const { commentListFlameGuide } = state;
    const { commentDetailGuide } = initialState;
    return {
      ...state, commentDetailGuide, commentListFlameGuide: { ...commentListFlameGuide, detailRefresh: true } };
  },
  // コメント情報詳細登録失敗時の処理
  [registerPubNoteFailure]: (state, action) => {
    const { commentDetailGuide } = state;
    const { status, data } = action.payload;
    let message = [];
    if (status && status === 400) {
      message = data;
    } else {
      message = ['指定のコメント情報は保存失敗しました。'];
    }
    return { ...state, commentDetailGuide: { ...commentDetailGuide, message } };
  },
  // コメント情報詳細削除成功時の処理
  [deletePubNoteSuccess]: (state) => {
    const { commentListFlameGuide } = state;
    const { commentDetailGuide } = initialState;
    return {
      ...state, commentDetailGuide, commentListFlameGuide: { ...commentListFlameGuide, detailRefresh: true } };
  },
  // コメント情報詳細削除失敗時の処理
  [deletePubNoteFailure]: (state) => {
    const { commentDetailGuide } = state;
    const message = ['指定のコメント情報は削除失敗しました。'];
    return { ...state, commentDetailGuide: { ...commentDetailGuide, message } };
  },
  // ノート分類設定アクション時の処理
  [setPubNoteDivState]: (state, action) => {
    const { commentDetailGuide } = state;
    return { ...state, commentDetailGuide: { ...commentDetailGuide, pubnotediv: action.payload } };
  },
  // コメント分類選択時処理
  [changePubNoteDiv]: (state, action) => {
    const { commentDetailGuide } = state;
    const { data, pubnotediv } = commentDetailGuide;
    const { params, values } = action.payload;
    const { pubnotedivcd, authnote } = params;
    Object.assign(data, values);
    let dispkbn = '';
    const element = pubnotediv.find((rec) => (rec.pubnotedivcd === pubnotedivcd));
    if (element) {
      // デフォルトの表示対象セット
      dispkbn = element.defaultdispkbn;
      // デフォルトの表示対象に対する権限が無い場合
      if ((authnote === 1 && dispkbn === 2) || (authnote === 2 && dispkbn === 1)) {
        // 権限のある表示対象へ
        dispkbn = authnote;
      }
      return { ...state, commentDetailGuide: { ...commentDetailGuide, data: { ...data, pubnotedivcd, dispkbn, onlydispkbn: element.onlydispkbn } } };
    }
    return { ...state, commentDetailGuide: { ...commentDetailGuide, data } };
  },

  // コメント検索g画面の初期成功時の処理
  [loadCommentListFlameGuideSuccess]: (state, action) => {
    const { commentListFlameGuide } = state;
    const { consult, free, hainsUserData, params, pubNoteData1, pubNoteData2, pubNoteData3, pubNoteData4, pubNoteData5, pubNoteData6 } = action.payload;
    const { incdelnote, dispkbn, pubnotedivcd, enddate, startdate } = params;
    return {
      ...state,
      commentListFlameGuide: {
        ...commentListFlameGuide,
        consult,
        free,
        hainsUserData,
        pubNoteData1,
        pubNoteData2,
        pubNoteData3,
        pubNoteData4,
        pubNoteData5,
        pubNoteData6,
        params: {
          ...params, incdelnote, dispkbn, pubnotedivcd, enddate, startdate,
        },
      },
    };
  },
  // コメント検索画面の初期失敗時の処理
  [loadCommentListFlameGuideFailure]: (state, action) => {
    const { commentListFlameGuide } = state;
    const { error } = action.payload;
    const message = error.data;
    return { ...state, commentListFlameGuide: { ...commentListFlameGuide, message } };
  },
  // コメント検索成功時の処理
  [searchCommentListSuccess]: (state, action) => {
    const { commentListFlameGuide } = state;
    const { params, pubNoteData1, pubNoteData2, pubNoteData3, pubNoteData4, pubNoteData5, pubNoteData6 } = action.payload;
    const { incdelnote, dispkbn, pubnotedivcd, enddate, startdate } = params;
    let Chk;
    if (params.dispmode === '1') {
      Chk = 1;
    }
    return {
      ...state,
      commentListFlameGuide: {
        ...commentListFlameGuide,
        pubNoteData1,
        pubNoteData2,
        pubNoteData3,
        pubNoteData4,
        pubNoteData5,
        pubNoteData6,
        params: {
          ...params, incdelnote, Chk, dispkbn, pubnotedivcd, enddate, startdate,
        },
      },
    };
  },
  // コメント検索失敗時の処理
  [searchCommentListFailure]: (state, action) => {
    const { commentListFlameGuide } = state;
    const { error } = action.payload;
    const message = error.data;
    return { ...state, commentListFlameGuide: { ...commentListFlameGuide, message } };
  },
  // コメント検索画面ガイドを開くアクション時の処理
  [openCommentListFlameGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { commentListFlameGuide } = initialState;
    let params = {};
    if (action.payload !== undefined) {
      const commment = action.payload.params;
      params = commment;
    }
    return {
      ...state,
      commentListFlameGuide: { ...commentListFlameGuide, visible, params },
    };
  },
  // コメント検索画面ガイドを閉じるアクション時の処理
  [closeCommentListFlameGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { commentListFlameGuide } = initialState;
    return { ...state, commentListFlameGuide };
  },
}, initialState);
