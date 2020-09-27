import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getFollowBeforeRequest,
  getFollowBeforeSuccess,
  getFollowBeforeFailure,
} = createActions(
  // 前回フォロー情報登録有無チェック及びキーデータ取得
  'GET_FOLLOW_BEFORE_REQUEST',
  'GET_FOLLOW_BEFORE_SUCCESS',
  'GET_FOLLOW_BEFORE_FAILURE',
);
export const {
  getFollowItemRequest,
  getFollowItemSuccess,
  getFollowItemFailure,
  getConsultInfoRequest,
  getConsultInfoSuccess,
  getConsultInfoFailure,
  getFollowHistoryRequest,
  getFollowHistorySuccess,
  getFollowHistoryFailure,
  getTargetFollowInfoRequest,
  getTargetFollowInfoSuccess,
  getTargetFollowInfoFailure,
  registerFollowInfoRequest,
  registerFollowInfoSuccess,
  registerFollowInfoFailure,
  openFollowInfoGuide,
  closeFollowInfoGuide,
  getPubNoteRequest,
  getPubNoteSuccess,
  getPubNoteFailure,
} = createActions(
  // フォロー対象検査情報
  'GET_FOLLOW_ITEM_REQUEST',
  'GET_FOLLOW_ITEM_SUCCESS',
  'GET_FOLLOW_ITEM_FAILURE',
  // 受診情報
  'GET_CONSULT_INFO_REQUEST',
  'GET_CONSULT_INFO_SUCCESS',
  'GET_CONSULT_INFO_FAILURE',
  // 受診歴情報
  'GET_FOLLOW_HISTORY_REQUEST',
  'GET_FOLLOW_HISTORY_SUCCESS',
  'GET_FOLLOW_HISTORY_FAILURE',
  // フォロー対象情報
  'GET_TARGET_FOLLOW_INFO_REQUEST',
  'GET_TARGET_FOLLOW_INFO_SUCCESS',
  'GET_TARGET_FOLLOW_INFO_FAILURE',
  // テーブル登録
  'REGISTER_FOLLOW_INFO_REQUEST',
  'REGISTER_FOLLOW_INFO_SUCCESS',
  'REGISTER_FOLLOW_INFO_FAILURE',
  // フォローアップ検索ガイド
  'OPEN_FOLLOW_INFO_GUIDE',
  'CLOSE_FOLLOW_INFO_GUIDE',
  // チャート情報の件数取得
  'GET_PUB_NOTE_REQUEST',
  'GET_PUB_NOTE_SUCCESS',
  'GET_PUB_NOTE_FAILURE',
);

// フォローアップ検索
export const {
  initializeFollowInfoList,
  getFollowItemInfoRequest,
  getFollowItemInfoSuccess,
  getFollowItemInfoFailure,
  getTargetFollowListRequest,
  getTargetFollowListSuccess,
  getTargetFollowListFailure,
  registerFollowInfoListRequest,
  registerFollowInfoListSuccess,
  registerFollowInfoListFailure,
} = createActions(
  'initialize_Follow_Info_List',
  'GET_FOLLOW_ITEM_INFO_REQUEST',
  'GET_FOLLOW_ITEM_INFO_SUCCESS',
  'GET_FOLLOW_ITEM_INFO_FAILURE',
  'GET_TARGET_FOLLOW_LIST_REQUEST',
  'GET_TARGET_FOLLOW_LIST_SUCCESS',
  'GET_TARGET_FOLLOW_LIST_FAILURE',
  'REGISTER_FOLLOW_INFO_LIST_REQUEST',
  'REGISTER_FOLLOW_INFO_LIST_SUCCESS',
  'REGISTER_FOLLOW_INFO_LIST_FAILURE',
);

// フォローアップの変更履歴
export const {
  openFolUpdateHistoryGuide,
  closeFolUpdateHistoryGuide,
  getFollowLogListRequest,
  getFollowLogListSuccess,
  getFollowLogListFailure,
} = createActions(
  'OPEN_FOL_UPDATE_HISTORY_GUIDE',
  'CLOSE_FOL_UPDATE_HISTORY_GUIDE',
  'GET_FOLLOW_LOG_LIST_REQUEST',
  'GET_FOLLOW_LOG_LIST_SUCCESS',
  'GET_FOLLOW_LOG_LIST_FAILURE',
);

// フォローアップの印刷履歴
export const {
  getFolReqHistoryRequest,
  getFolReqHistorySuccess,
  getFolReqHistoryFailure,
  closeFollowReqHistoryGuide,
} = createActions(
  'GET_FOL_REQ_HISTORY_REQUEST',
  'GET_FOL_REQ_HISTORY_SUCCESS',
  'GET_FOL_REQ_HISTORY_FAILURE',
  'CLOSE_FOLLOW_REQ_HISTORY_GUIDE',
);

// フォローアップの二次検診情報登録
export const {
  openFollowInfoEditGuideRequest,
  openFollowInfoEditGuideSuccess,
  openFollowInfoEditGuideFailure,
  chkWrite,
  updateFollowInfoRequest,
  updateFollowInfoSuccess,
  updateFollowInfoFailure,
  deleteFollowInfoRequest,
  deleteFollowInfoSuccess,
  deleteFollowInfoFailure,
  updateFollowInfoConfirmRequest,
  updateFollowInfoConfirmSuccess,
  updateFollowInfoConfirmFailure,
  closeFollowInfoEditGuide,
} = createActions(
  'OPEN_FOLLOW_INFO_EDIT_GUIDE_REQUEST',
  'OPEN_FOLLOW_INFO_EDIT_GUIDE_SUCCESS',
  'OPEN_FOLLOW_INFO_EDIT_GUIDE_FAILURE',
  'CHK_WRITE',
  'UPDATE_FOLLOW_INFO_REQUEST',
  'UPDATE_FOLLOW_INFO_SUCCESS',
  'UPDATE_FOLLOW_INFO_FAILURE',
  'DELETE_FOLLOW_INFO_REQUEST',
  'DELETE_FOLLOW_INFO_SUCCESS',
  'DELETE_FOLLOW_INFO_FAILURE',
  'UPDATE_FOLLOW_INFO_CONFIRM_REQUEST',
  'UPDATE_FOLLOW_INFO_CONFIRM_SUCCESS',
  'UPDATE_FOLLOW_INFO_CONFIRM_FAILURE',
  'CLOSE_FOLLOW_INFO_EDIT_GUIDE',
);

// フォローアップの二次検診結果登録
export const {
  openFollowRslEditGuideRequest,
  openFollowRslEditGuideSuccess,
  openFollowRslEditGuideFailure,
  deleteFollowRslRequest,
  deleteFollowRslSuccess,
  deleteFollowRslFailure,
  updateFollowRslRequest,
  updateFollowRslSuccess,
  updateFollowRslFailure,
  shortStcHandle,
  closeFollowRslEditGuide,
} = createActions(
  'OPEN_FOLLOW_RSL_EDIT_GUIDE_REQUEST',
  'OPEN_FOLLOW_RSL_EDIT_GUIDE_SUCCESS',
  'OPEN_FOLLOW_RSL_EDIT_GUIDE_FAILURE',
  'DELETE_FOLLOW_RSL_REQUEST',
  'DELETE_FOLLOW_RSL_SUCCESS',
  'DELETE_FOLLOW_RSL_FAILURE',
  'UPDATE_FOLLOW_RSL_REQUEST',
  'UPDATE_FOLLOW_RSL_SUCCESS',
  'UPDATE_FOLLOW_RSL_FAILURE',
  'SHORT_STC_HANDLE',
  'CLOSE_FOLLOW_RSL_EDIT_GUIDE',
);

// フォローアップの依頼状作成
export const {
  openFollowReqEditGuideRequest,
  openFollowReqEditGuideSuccess,
  openFollowReqEditGuideFailure,
  closeFollowReqEditGuide,
} = createActions(
  'OPEN_FOLLOW_REQ_EDIT_GUIDE_REQUEST',
  'OPEN_FOLLOW_REQ_EDIT_GUIDE_SUCCESS',
  'OPEN_FOLLOW_REQ_EDIT_GUIDE_FAILURE',
  'CLOSE_FOLLOW_REQ_EDIT_GUIDE',
);

// stateの初期値
const initialState = {
  prepaInfo: {
    message: [],
    followBeforeData: null,
  },
  followInfo: {
    message: [],
    followItemData: [],
    consultData: {},
    followHistoryData: [],
    targetFollowData: [],
    visible: false,
    rsvNo: null,
    pubNoteData: [],
  },
  // フォローアップ検索
  followInfoList: {
    message: [],
    followItem: [],
    targetFollowList: [],
    totalcount: 0,
    actions: '',
    conditions: {
      startCslDate: null,
      endCslDate: null,
      judClassCd: '',
      equipDiv: '',
      confirmDiv: '',
      addUser: '',
      perId: '',
      pageMaxLine: '',
      startPos: 1,
    },
  },
  // フォローアップの変更履歴
  folUpdateHistoryGuide: {
    visible: false,
    message: [],
    followLogList: [],
    totalcount: 0,
    rsvno: null,
    winmode: '',
    actions: '',
    conditions: {
      startUpdDate: null,
      endUpdDate: null,
      searchUpdClass: '',
      searchUpdUser: '',
      orderbyItem: '',
      orderbyMode: '',
      limit: '',
      page: 1,
    },
  },
  // フォローアップの印刷履歴
  folReqHistoryGuide: {
    visible: false,
    message: [],
    rsvno: null,
    followItem: [],
    folReqHistory: [],
    totalcount: 0,
  },
  // フォローアップの二次検診情報登録
  followInfoEditGuide: {
    conditions: {}, // フォローアップ検索画面の条件
    visible: false,
    message: [],
    rsvno: null,
    judclasscd: null,
    judList: [],
    followInfo: {},
    followRslList: [],
    followRslItemList: [],
    judCd: '',
    secEquipDiv: null,
    secPlanDate: null,
    rsvTestUS: null,
    rsvTestCT: null,
    rsvTestMRI: null,
    rsvTestBF: null,
    rsvTestGF: null,
    rsvTestCF: null,
    rsvTestEM: null,
    rsvTestTM: null,
    rsvTestRefer: null,
    rsvTestReferText: null,
    rsvTestETC: null,
    rsvTestRemark: null,
    statusCd: null,
    secRemark: null,
    secEquipName: null,
    secEquipCourse: null,
    secDoctor: null,
    secEquipAddr: null,
    secEquipTel: null,
  },
  // フォローアップの二次検診結果登録
  followRslEditGuide: {
    visible: false,
    refreshFlg: 0,
    message: [],
    rsvno: null,
    judclasscd: null,
    seq: null,
    followInfo: {},
    followRsl: {},
    followRslItemList: [],
    secCslDate: null,
    testUS: null,
    testCT: null,
    testMRI: null,
    testBF: null,
    testGF: null,
    testCF: null,
    testEM: null,
    testTM: null,
    testRefer: null,
    testReferText: null,
    testETC: null,
    testRemark: null,
    resultDiv: null,
    disRemark: null,
    polWithout: null,
    polFollowup: null,
    polMonth: null,
    polReExam: null,
    polDiagSt: null,
    polDiag: null,
    polETC1: null,
    polRemark1: null,
    polSugery: null,
    polEndoscope: null,
    polChemical: null,
    polRadiation: null,
    polReferSt: null,
    polRefer: null,
    polETC2: null,
    polRemark2: null,
  },
  // フォローアップの依頼状作成
  followReqEditGuide: {
    visible: false,
    message: [],
    rsvno: null,
    judclasscd: null,
    userid: null,
    username: null,
    consult: {},
    followInfo: {},
    folItem: null,
    folNote: null,
    secEquipName: null,
    secEquipCourse: null,
    secDoctor: null,
    secEquipAddr: null,
    secEquipTel: null,
    judClassName: null,
    prtdiv: 1,
    cslDate: null,
    perId: null,
    realAge: null,
    dayId: null,
    name: null,
    kName: null,
    birth: null,
    gender: null,
  },
};

// reducerの作成
export default handleActions({
  // フォローアップの依頼状作成ガイドを開く成功時の処理
  [openFollowReqEditGuideSuccess]: (state, action) => {
    const { consult, followInfo, rsvno, judclasscd, userid, username, folNote, secEquipCourse } = action.payload;
    const { followReqEditGuide } = state;
    return {
      ...state,
      followReqEditGuide:
      {
        ...followReqEditGuide,
        consult,
        followInfo,
        rsvno,
        judclasscd,
        userid,
        username,
        visible: true,
        folItem: judclasscd === 24 ? '乳房異常所見' : followInfo.judclassname,
        folNote,
        secEquipName: followInfo.secequipname,
        secEquipCourse,
        secDoctor: followInfo.secdoctor,
        secEquipAddr: followInfo.secequipaddr,
        secEquipTel: followInfo.secequiptel,
        judClassName: followInfo.judclassname,
        cslDate: consult.csldate,
        perId: consult.perid,
        realAge: consult.age,
        dayId: consult.dayid,
        name: consult.lastname,
        kName: consult.lastkname,
        birth: consult.birth,
        gender: consult.gender,
      },
    };
  },

  // フォローアップの依頼状作成ガイドを開く失敗時の処理
  [openFollowReqEditGuideFailure]: (state, action) => {
    const { rsvno } = action.payload;
    const { followReqEditGuide } = initialState;
    const message = [`受診情報が存在しません。（予約番号= ${rsvno} )`];
    return { ...state, followReqEditGuide: { ...followReqEditGuide, message, rsvno, visible: true } };
  },

  // フォローアップの依頼状作成ガイドを閉じるアクション時の処理
  [closeFollowReqEditGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { followReqEditGuide } = initialState;
    return { ...state, followReqEditGuide };
  },

  // 結果疾患（文章）の処理
  [shortStcHandle]: (state, action) => {
    const { index, stcCd, shortStc } = action.payload;
    const { followRslEditGuide } = state;
    const { followRslItemList } = followRslEditGuide;
    let { refreshFlg } = followRslEditGuide;
    followRslItemList[index].shortstc = null;
    followRslItemList[index].result = null;
    if (stcCd !== undefined) {
      followRslItemList[index].shortstc = shortStc;
      followRslItemList[index].result = stcCd;
    }
    refreshFlg += 1;
    return { ...state, followRslEditGuide: { ...followRslEditGuide, followRslItemList, refreshFlg } };
  },

  // 判定分類別フォローアップ情報保存成功時の処理
  [updateFollowRslSuccess]: (state) => {
    const { followRslEditGuide } = initialState;
    return { ...state, followRslEditGuide: { ...followRslEditGuide, message: [] } };
  },

  // 判定分類別フォローアップ情報保存失敗時の処理
  [updateFollowRslFailure]: (state, action) => {
    const { followRslEditGuide } = state;
    const { data } = action.payload;
    let messages = [];
    if (data.length === 0) {
      messages = ['フォローアップ結果情報登録に失敗しました。'];
    } else {
      messages = data;
    }
    return { ...state, followRslEditGuide: { ...followRslEditGuide, message: messages } };
  },

  // 判定分類別フォローアップ情報削除成功時の処理
  [deleteFollowRslSuccess]: (state) => {
    const { followRslEditGuide } = initialState;
    return { ...state, followRslEditGuide: { ...followRslEditGuide, message: [] } };
  },

  // 判定分類別フォローアップ情報削除失敗時の処理
  [deleteFollowInfoFailure]: (state) => {
    const { followRslEditGuide } = state;
    const message = ['フォローアップ結果情報削除に失敗しました。'];
    return { ...state, followRslEditGuide: { ...followRslEditGuide, message } };
  },

  // フォローアップの二次検診結果登録を取得成功時の処理
  [openFollowRslEditGuideSuccess]: (state, action) => {
    const { followInfo, followRsl, followRslItemList, rsvno, judclasscd, seq } = action.payload;
    const { followRslEditGuide } = state;
    return {
      ...state,
      followRslEditGuide:
      {
        ...followRslEditGuide,
        followInfo,
        followRsl,
        followRslItemList,
        rsvno,
        judclasscd,
        seq,
        visible: true,
        secCslDate: followRsl.seccsldate === undefined ? null : followRsl.seccsldate,
        testUS: followRsl.testus === undefined ? null : followRsl.testus,
        testCT: followRsl.testct === undefined ? null : followRsl.testct,
        testMRI: followRsl.testmri === undefined ? null : followRsl.testmri,
        testBF: followRsl.testbf === undefined ? null : followRsl.testbf,
        testGF: followRsl.testgf === undefined ? null : followRsl.testgf,
        testCF: followRsl.testcf === undefined ? null : followRsl.testcf,
        testEM: followRsl.testem === undefined ? null : followRsl.testem,
        testTM: followRsl.testtm === undefined ? null : followRsl.testtm,
        testRefer: followRsl.testrefer === undefined ? null : followRsl.testrefer,
        testReferText: followRsl.testrefertext === undefined ? null : followRsl.testrefertext,
        testETC: followRsl.testetc === undefined ? null : followRsl.testetc,
        testRemark: followRsl.testremark === undefined ? null : followRsl.testremark,
        resultDiv: followRsl.resultdiv === undefined ? null : followRsl.resultdiv,
        disRemark: followRsl.disremark === undefined ? null : followRsl.disremark,
        polWithout: followRsl.polwithout === undefined ? null : followRsl.polwithout,
        polFollowup: followRsl.polfollowup === undefined ? null : followRsl.polfollowup,
        polMonth: followRsl.polmonth === undefined ? null : followRsl.polmonth,
        polReExam: followRsl.polreexam === undefined ? null : followRsl.polreexam,
        polDiagSt: followRsl.poldiagst === undefined ? null : followRsl.poldiagst,
        polDiag: followRsl.poldiag === undefined ? null : followRsl.poldiag,
        polETC1: followRsl.poletc1 === undefined ? null : followRsl.poletc1,
        polRemark1: followRsl.polremark1 === undefined ? null : followRsl.polremark1,
        polSugery: followRsl.polsugery === undefined ? null : followRsl.polsugery,
        polEndoscope: followRsl.polendoscope === undefined ? null : followRsl.polendoscope,
        polChemical: followRsl.polchemical === undefined ? null : followRsl.polchemical,
        polRadiation: followRsl.polradiation === undefined ? null : followRsl.polradiation,
        polReferSt: followRsl.polreferst === undefined ? null : followRsl.polreferst,
        polRefer: followRsl.polrefer === undefined ? null : followRsl.polrefer,
        polETC2: followRsl.poletc2 === undefined ? null : followRsl.poletc2,
        polRemark2: followRsl.polremark2 === undefined ? null : followRsl.polremark2,
      },
    };
  },

  // フォローアップの二次検診結果登録ガイドを閉じるアクション時の処理
  [closeFollowRslEditGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { followRslEditGuide } = initialState;
    return { ...state, followRslEditGuide };
  },

  // フォローアップ情報承認（又は承認解除）成功時の処理
  [updateFollowInfoConfirmSuccess]: (state) => {
    const { followInfoEditGuide } = state;
    const message = ['保存が完了しました。'];
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, message } };
  },

  // フォローアップ情報承認（又は承認解除）失敗時の処理
  [updateFollowInfoConfirmFailure]: (state) => {
    const { followInfoEditGuide } = state;
    const message = ['フォローアップ情報更新に失敗しました。'];
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, message } };
  },

  // フォローアップ情報削除成功時の処理
  [deleteFollowInfoSuccess]: (state) => {
    const { followInfoEditGuide } = state;
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, visible: false, message: [] } };
  },

  // フォローアップ情報削除失敗時の処理
  [deleteFollowInfoFailure]: (state) => {
    const { followInfoEditGuide } = state;
    const message = ['フォローアップ情報削除に失敗しました。'];
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, message } };
  },
  // フォローアップ情報更新成功時の処理
  [updateFollowInfoSuccess]: (state) => {
    const { followInfoEditGuide } = state;
    const message = ['保存が完了しました。'];
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, message } };
  },

  // フォローアップ情報更新失敗時の処理
  [updateFollowInfoFailure]: (state, action) => {
    const { followInfoEditGuide } = state;
    const { data } = action.payload;
    let messages = [];
    if (data.length === 0) {
      messages = ['フォローアップ情報更新に失敗しました。'];
    } else {
      messages = data;
    }
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, message: messages } };
  },

  [chkWrite]: (state, action) => {
    const { followInfoEditGuide, followRslEditGuide } = state;
    const { followInfo } = followInfoEditGuide;
    const { followRsl } = followRslEditGuide;
    const { name, value } = action.payload;
    if (name === 'rsvTestReferText') {
      if (value === 1) {
        followInfo.rsvtestrefer = null;
      } else {
        followInfo.rsvtestrefer = 1;
      }
    }
    if (name === 'rsvTestRemark') {
      if (value === 1) {
        followInfo.rsvtestetc = null;
      } else {
        followInfo.rsvtestetc = 1;
      }
    }
    if (name === 'testReferText') {
      if (value === 1) {
        followRsl.testrefer = null;
      } else {
        followRsl.testrefer = 1;
      }
    }
    if (name === 'testRemark') {
      if (value === 1) {
        followRsl.testetc = null;
      } else {
        followRsl.testetc = 1;
      }
    }
    if (name === 'polMonth') {
      if (value === 1) {
        followRsl.polfollowup = null;
      } else {
        followRsl.polfollowup = 1;
      }
    }
    if (name === 'polRemark1') {
      if (value === 1) {
        followRsl.poletc1 = null;
      } else {
        followRsl.poletc1 = 1;
      }
    }
    if (name === 'polRemark2') {
      if (value === 1) {
        followRsl.poletc2 = null;
      } else {
        followRsl.poletc2 = 1;
      }
    }
    return {
      ...state,
      followInfoEditGuide: { ...followInfoEditGuide, followInfo },
      followRslEditGuide: { ...followRslEditGuide, followRsl },
    };
  },

  // フォローアップの二次検診情報登録を取得成功時の処理
  [openFollowInfoEditGuideSuccess]: (state, action) => {
    const { judList, followInfo, followRslList, disRslItemList, rsvno, judclasscd } = action.payload;
    const { followInfoEditGuide } = state;
    return {
      ...state,
      followInfoEditGuide:
      {
        ...followInfoEditGuide,
        judList,
        followInfo,
        followRslList,
        followRslItemList: disRslItemList,
        rsvno,
        judclasscd,
        visible: true,
        judCd: followInfo.judcd,
        secEquipDiv: followInfo.secequipdiv,
        secPlanDate: followInfo.secplandate,
        rsvTestUS: followInfo.rsvtestus,
        rsvTestCT: followInfo.rsvtestct,
        rsvTestMRI: followInfo.rsvtestmri,
        rsvTestBF: followInfo.rsvtestbf,
        rsvTestGF: followInfo.rsvtestgf,
        rsvTestCF: followInfo.rsvtestcf,
        rsvTestEM: followInfo.rsvtestem,
        rsvTestTM: followInfo.rsvtesttm,
        rsvTestRefer: followInfo.rsvtestrefer,
        rsvTestReferText: followInfo.rsvtestrefertext,
        rsvTestETC: followInfo.rsvtestetc,
        rsvTestRemark: followInfo.rsvtestremark,
        statusCd: followInfo.statuscd,
        secRemark: followInfo.secremark,
        secEquipName: followInfo.secequipname,
        secEquipCourse: followInfo.secequipcourse,
        secDoctor: followInfo.secdoctor,
        secEquipAddr: followInfo.secequipaddr,
        secEquipTel: followInfo.secequiptel,
      },
    };
  },
  // フォローアップの二次検診情報登録ガイドを閉じるアクション時の処理
  [closeFollowInfoEditGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { followInfoEditGuide } = state;
    return { ...state, followInfoEditGuide: { ...followInfoEditGuide, visible: false, message: [] } };
  },
  // 指定検索条件の印刷履歴を取得開始時の処理
  [getFolReqHistorySuccess]: (state, action) => {
    const { folReqHistoryGuide } = state;
    const { followItem, folReqHistory, rsvno } = action.payload;
    let totalcount = 0;
    if (folReqHistory.length > 0) {
      totalcount = folReqHistory.length;
    }
    return { ...state, folReqHistoryGuide: { ...folReqHistoryGuide, visible: true, followItem, folReqHistory, rsvno, totalcount } };
  },
  // 指定検索条件の印刷履歴を取得失敗時の処理
  [getFolReqHistoryFailure]: (state) => {
    const { folReqHistoryGuide } = initialState;
    return { ...state, folReqHistoryGuide: { ...folReqHistoryGuide, visible: true } };
  },
  // フォローアップの印刷履歴ガイドを閉じるアクション時の処理
  [closeFollowReqHistoryGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { folReqHistoryGuide } = initialState;
    return { ...state, folReqHistoryGuide };
  },
  // 指定検索条件の変更履歴を取得開始時の処理
  [getFollowLogListRequest]: (state, action) => {
    const { folUpdateHistoryGuide } = state;
    // 検索条件を更新する
    const { conditions } = action.payload;

    return { ...state, folUpdateHistoryGuide: { ...folUpdateHistoryGuide, conditions } };
  },
  // 指定検索条件の変更履歴を取得成功時の処理
  [getFollowLogListSuccess]: (state, action) => {
    const { folUpdateHistoryGuide } = state;
    const { data, totalcount } = action.payload;
    return { ...state, folUpdateHistoryGuide: { ...folUpdateHistoryGuide, followLogList: data, totalcount, message: [], actions: 'search' } };
  },
  // 指定検索条件の変更履歴を取得失敗時の処理
  [getFollowLogListFailure]: (state) => {
    const { folUpdateHistoryGuide } = state;
    const message = ['検索条件を満たす履歴は存在しません。'];
    return { ...state, folUpdateHistoryGuide: { ...folUpdateHistoryGuide, totalcount: 0, message, actions: 'search' } };
  },
  // フォローアップの変更履歴ガイドを開くアクション時の処理
  [openFolUpdateHistoryGuide]: (state, action) => {
    const { rsvno, winmode } = action.payload;
    // 可視状態をtrueにする
    const visible = true;
    const { folUpdateHistoryGuide } = state;
    return { ...state, folUpdateHistoryGuide: { ...folUpdateHistoryGuide, visible, rsvno, winmode } };
  },
  // フォローアップの変更履歴ガイドを閉じるアクション時の処理
  [closeFolUpdateHistoryGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { folUpdateHistoryGuide } = initialState;
    return { ...state, folUpdateHistoryGuide };
  },
  // フォローアップ検索登録成功時の処理
  [registerFollowInfoListSuccess]: (state) => {
    const { followInfoList } = state;
    return { ...state, followInfoList: { ...followInfoList, actions: 'save' } };
  },
  // フォローアップ検索登録失敗時の処理
  [registerFollowInfoListFailure]: (state) => {
    const { followInfoList } = state;
    const message = ['保存に失敗しました。'];
    return { ...state, followInfoList: { ...followInfoList, message } };
  },
  // フォローアップ検索を開始時の処理
  [getTargetFollowListRequest]: (state, action) => {
    const { followInfoList } = state;
    // 検索条件を更新する
    const conditions = action.payload;

    return { ...state, followInfoList: { ...followInfoList, conditions } };
  },
  // フォローアップ検索取得成功時の処理
  [getTargetFollowListSuccess]: (state, action) => {
    const { followInfoList, followInfoEditGuide } = state;
    const { actions } = followInfoList;
    let messages = [];
    if (actions === 'save') {
      messages = ['保存が完了しました。'];
    }
    const { targetFollowList, totalcount, conditions } = action.payload;
    return {
      ...state,
      followInfoList: { ...followInfoList, targetFollowList, totalcount, message: messages, actions: 'search' },
      followInfoEditGuide: { ...followInfoEditGuide, conditions },
    };
  },
  // フォローアップ検索取得失敗時の処理
  [getTargetFollowListFailure]: (state, action) => {
    const { followInfoList } = state;
    const { message } = action.payload;
    let messages = [];
    if (message !== undefined) {
      messages = message;
    }
    return { ...state, followInfoList: { ...followInfoList, targetFollowList: [], totalcount: 0, message: messages, actions: 'search' } };
  },
  // フォロー対象検査情報取得成功時の処理
  [getFollowItemInfoSuccess]: (state, action) => {
    const { followInfoList } = state;
    const followItem = action.payload;
    return { ...state, followInfoList: { ...followInfoList, followItem } };
  },
  // フォローアップ検索画面を初期化の処理
  [initializeFollowInfoList]: (state) => {
    const { followInfoList } = initialState;
    return { ...state, followInfoList };
  },
  // 前回フォロー情報登録有無チェック及びキーデータ取得成功時の処理
  [getFollowBeforeSuccess]: (state, action) => {
    const { prepaInfo } = state;
    let { followBeforeData } = prepaInfo;
    if (action.payload !== undefined && action.payload !== '') {
      followBeforeData = action.payload;
    }
    return { ...state, prepaInfo: { ...prepaInfo, followBeforeData } };
  },
  // 前回フォロー情報登録有無チェック及びキーデータ取得失敗時の処理
  [getFollowBeforeFailure]: (state, action) => {
    const { prepaInfo } = state;
    const { data } = action.payload;
    const message = [data];
    return { ...state, prepaInfo: { ...prepaInfo, message } };
  },
  // フォロー対象検査情報取得成功時の処理
  [getFollowItemSuccess]: (state, action) => {
    const { followInfo } = state;
    const data = action.payload;
    return { ...state, followInfo: { ...followInfo, followItemData: data } };
  },
  // 受診情報取得成功時の処理
  [getConsultInfoSuccess]: (state, action) => {
    const { followInfo } = state;
    const { consultData, followHistoryData } = action.payload;
    return { ...state, followInfo: { ...followInfo, consultData, followHistoryData } };
  },
  // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得開始時の処理
  [getTargetFollowInfoRequest]: (state) => {
    const { followInfo } = state;
    const message = [];
    return { ...state, followInfo: { ...followInfo, message } };
  },
  // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得成功時の処理
  [getTargetFollowInfoSuccess]: (state, action) => {
    const { followInfo } = state;
    const data = action.payload;
    return { ...state, followInfo: { ...followInfo, targetFollowData: data } };
  },
  // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得失敗時の処理
  [getTargetFollowInfoFailure]: (state) => {
    const { followInfo } = state;
    return { ...state, followInfo: { ...followInfo, targetFollowData: null } };
  },
  // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録成功時の処理
  [registerFollowInfoSuccess]: (state) => {
    const { followInfo } = state;
    const message = ['正常に保存できました。'];
    return { ...state, followInfo: { ...followInfo, message } };
  },
  // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録失敗時の処理
  [registerFollowInfoFailure]: (state) => {
    const { followInfo } = state;
    const message = ['保存に失敗しました'];
    return { ...state, followInfo: { ...followInfo, message } };
  },
  // フォローアップ検索ガイドを開くアクション時の処理
  [openFollowInfoGuide]: (state, action) => {
    const rsvno = action.payload;
    // 可視状態をtrueにする
    const visible = true;
    const { followInfo } = initialState;
    return { ...state, followInfo: { ...followInfo, visible, rsvNo: rsvno } };
  },
  // フォローアップ検索ガイドを閉じるアクション時の処理
  [closeFollowInfoGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { followInfo } = initialState;
    return { ...state, followInfo };
  },
  // チャート情報の件数取得成功時の処理
  [getPubNoteSuccess]: (state, action) => {
    const { followInfo } = state;
    const { data } = action.payload;
    return { ...state, followInfo: { ...followInfo, pubNoteData: data } };
  },
}, initialState);
