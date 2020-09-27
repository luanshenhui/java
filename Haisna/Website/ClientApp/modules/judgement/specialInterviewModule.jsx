import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getSpecialRslViewRequest,
  getSpecialRslViewSuccess,
  getSpecialRslViewFailure,
  getSpecialJudCmtRequest,
  getSpecialJudCmtSuccess,
  getSpecialJudCmtFailure,
  getSpecialResultRequest,
  getSpecialResultSuccess,
  getSpecialResultFailure,
  getRslRequest,
  getRslSuccess,
  getRslFailure,
  getSubSpecialJudCmtRequest,
  getSubSpecialJudCmtSuccess,
  getSubSpecialJudCmtFailure,
  getSubEntitySpJudRequest,
  getSubEntitySpJudSuccess,
  getSubEntitySpJudFailure,
  changeSpecialJudCmtRequest,
  updateSpecialJudCmtRequest,
  updateSpecialJudCmtSuccess,
  updateSpecialJudCmtFailure,
  updateEntitySpJudRequest,
  updateEntitySpJudSuccess,
  updateEntitySpJudFailure,
  closeSpecialJudCmtGuide,
  closeEntitySpJudGuide,
} = createActions(
  // 受診者の検査結果を取得
  'GET_SPECIAL_RSL_VIEW_REQUEST',
  'GET_SPECIAL_RSL_VIEW_SUCCESS',
  'GET_SPECIAL_RSL_VIEW_FAILURE',
  // 階層化コメントを取得
  'GET_SPECIAL_JUD_CMT_REQUEST',
  'GET_SPECIAL_JUD_CMT_SUCCESS',
  'GET_SPECIAL_JUD_CMT_FAILURE',
  // 予約番号をもって検査結果を取得
  'GET_SPECIAL_RESULT_REQUEST',
  'GET_SPECIAL_RESULT_SUCCESS',
  'GET_SPECIAL_RESULT_FAILURE',
  // 検査結果レコードの検査結果を取得
  'GET_RSL_REQUEST',
  'GET_RSL_SUCCESS',
  'GET_RSL_FAILURE',
  // 特定保健指導区分登録を取得
  'GET_SUB_SPECIAL_JUD_CMT_REQUEST',
  'GET_SUB_SPECIAL_JUD_CMT_SUCCESS',
  'GET_SUB_SPECIAL_JUD_CMT_FAILURE',
  // 特定健診判定コメントを取得
  'GET_SUB_ENTITY_SP_JUD_REQUEST',
  'GET_SUB_ENTITY_SP_JUD_SUCCESS',
  'GET_SUB_ENTITY_SP_JUD_FAILURE',
  // 特定健診コメントを更新する
  'CHANGE_SPECIAL_JUD_CMT_REQUEST',
  // 特定健診コメントを保存する
  'UPDATE_SPECIAL_JUD_CMT_REQUEST',
  'UPDATE_SPECIAL_JUD_CMT_SUCCESS',
  'UPDATE_SPECIAL_JUD_CMT_FAILURE',
  // 特定保健指導区分を保存する
  'UPDATE_ENTITY_SP_JUD_REQUEST',
  'UPDATE_ENTITY_SP_JUD_SUCCESS',
  'UPDATE_ENTITY_SP_JUD_FAILURE',
  // 特定健診コメントを閉じる
  'CLOSE_SPECIAL_JUD_CMT_GUIDE',
  // 特定保健指導区分を取得する
  'CLOSE_ENTITY_SP_JUD_GUIDE',
);

// stateの初期値
const initialState = {
  specialJudViewList: {
    rslviewdata: [],
    rslviewdataLeft: [],
    rslviewdataRight: [],
    judcmtdata: [],
    resultdata: [],
    rsldata: null,
    message: [],
  },
  spJudCommentGuide: {
    judcmtdata: [],
    visible: false,
  },
  entitySpJudGuide: {
    rsldata: null,
    visible: false,
    message: [],
  },
};

// reducerの作成
export default handleActions({
  // 受診者の検査結果を取得成功時の処理
  [getSpecialRslViewSuccess]: (state, action) => {
    const { specialJudViewList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { rslviewdataLeft, rslviewdataRight } = action.payload;
    return { ...state, specialJudViewList: { ...specialJudViewList, rslviewdataLeft, rslviewdataRight } };
  },
  // 受診者の検査結果を取得失敗時の処理
  [getSpecialRslViewFailure]: (state, action) => {
    const { specialJudViewList } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`検査結果が取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, specialJudViewList: { ...specialJudViewList, message } };
  },
  // 階層化コメントを取得成功時の処理
  [getSpecialJudCmtSuccess]: (state, action) => {
    const { specialJudViewList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { judcmtdata } = action.payload;
    return { ...state, specialJudViewList: { ...specialJudViewList, judcmtdata } };
  },
  // 階層化コメントを取得失敗時の処理
  [getSpecialJudCmtFailure]: (state, action) => {
    const { specialJudViewList } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`判定コメントが取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, specialJudViewList: { ...specialJudViewList, message } };
  },
  // 予約番号をもって検査結果を取得成功時の処理
  [getSpecialResultSuccess]: (state, action) => {
    const { specialJudViewList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { resultdata } = action.payload;
    return { ...state, specialJudViewList: { ...specialJudViewList, resultdata } };
  },
  // 検査結果レコードの検査結果を取得成功時の処理
  [getRslSuccess]: (state, action) => {
    const { specialJudViewList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { rsldata } = action.payload;
    return { ...state, specialJudViewList: { ...specialJudViewList, rsldata } };
  },
  // 特定保健指導区分登録画面初期化の処理
  [getSubEntitySpJudRequest]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { entitySpJudGuide } = initialState;
    return { ...state, entitySpJudGuide: { ...entitySpJudGuide, visible } };
  },
  // 特定保健指導区分を取得成功時の処理
  [getSubEntitySpJudSuccess]: (state, action) => {
    const { entitySpJudGuide } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { rsldata } = action.payload;
    return { ...state, entitySpJudGuide: { ...entitySpJudGuide, rsldata, message: [] } };
  },
  // 特定保健指導区分を取得失敗時の処理
  [getSubEntitySpJudFailure]: (state, action) => {
    const { entitySpJudGuide } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { rsldata } = action.payload;
    let message = [];
    if (!rsldata) {
      message = ['現在、特定保健指導区分が登録されていません。'];
    }
    return { ...state, entitySpJudGuide: { ...entitySpJudGuide, rsldata: 1, message } };
  },
  // 特定健診判定コメント画面初期化の処理
  [getSubSpecialJudCmtRequest]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { spJudCommentGuide } = initialState;
    return { ...state, spJudCommentGuide: { ...spJudCommentGuide, visible } };
  },
  // 特定健診コメントを取得成功時の処理
  [getSubSpecialJudCmtSuccess]: (state, action) => {
    const { spJudCommentGuide } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { judcmtdata } = action.payload;
    return { ...state, spJudCommentGuide: { ...spJudCommentGuide, judcmtdata } };
  },
  // 特定健診コメントを取得失敗時の処理
  [getSubSpecialJudCmtFailure]: (state, action) => {
    const { spJudCommentGuide } = state;
    const { status, rsvno } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`判定コメントが取得できません。（予約番号 = ${rsvno})`];
    }

    return { ...state, spJudCommentGuide: { ...spJudCommentGuide, message } };
  },
  // 特定健診コメントを更新アクション時の処理
  [changeSpecialJudCmtRequest]: (state, action) => {
    const { spJudCommentGuide } = state;
    const { judcmtdata } = spJudCommentGuide;
    const { selectSpecialJudlist, mode } = action.payload;
    const data = judcmtdata.slice(0);
    if (mode === 'I' || mode === 'D' || mode === 'C') {
      if (selectSpecialJudlist) {
        if (mode === 'I') {
          // TODO
        }
        if (mode === 'D') {
          data.splice(data.findIndex((rec) => (rec.judcmtseq === parseInt(selectSpecialJudlist, 10))), 1);
        }
        if (mode === 'C') {
          // TODO
        }
      } else {
        alert('編集する行が選択されていません。');
      }
    } else {
      // TODO
    }
    return { ...state, spJudCommentGuide: { ...spJudCommentGuide, judcmtdata: data } };
  },
  // 特定健診コメントを更新成功のアクション時の処理
  [updateSpecialJudCmtSuccess]: (state) => {
    // 可視状態をfalseにする
    const visible = false;
    const { spJudCommentGuide } = initialState;
    return { ...state, spJudCommentGuide: { ...spJudCommentGuide, visible } };
  },
  // 特定保健指導区分を更新成功のアクション時の処理
  [updateEntitySpJudSuccess]: (state) => {
    // 可視状態をfalseにする
    const visible = false;
    const { entitySpJudGuide } = initialState;
    return { ...state, entitySpJudGuide: { ...entitySpJudGuide, visible } };
  },
  // 特定保健指導区分を更新失敗のアクション時の処理
  [updateEntitySpJudFailure]: (state, action) => {
    const { entitySpJudGuide } = state;
    const { data } = action.payload;
    let message = '';
    if (data !== '') {
      message = data;
      message.push('特定保健指導対象区分の登録ができませんでした。');
    }
    return { ...state, entitySpJudGuide: { ...entitySpJudGuide, message } };
  },
  //  特定健診コメントを閉じるアクション時の処理
  [closeSpecialJudCmtGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { spJudCommentGuide } = initialState;
    return { ...state, spJudCommentGuide };
  },
  // 特定保健指導区分登録を閉じるアクション時の処理
  [closeEntitySpJudGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { entitySpJudGuide } = initialState;
    return { ...state, entitySpJudGuide };
  },
}, initialState);
