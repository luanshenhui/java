import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  getInterviewConsultRequest,
  getInterviewConsultSuccess,
  getInterviewConsultFailure,
  getHistoryRslLifeRequest,
  getHistoryRslLifeSuccess,
  getHistoryRslLifeFailure,
  getHistoryRslSelfRequest,
  getHistoryRslSelfSuccess,
  getHistoryRslSelfFailure,
  selectJudHistoryRslListRequest,
  selectJudHistoryRslListSuccess,
  selectJudHistoryRslListFailure,
  getTotalJudCmtRequest,
  getTotalJudCmtSuccess,
  getTotalJudCmtFailure,
  getHistoriesRequest,
  getHistoriesSuccess,
  getHistoriesFailure,
  getHistoryRslRequest,
  getHistoryRslSuccess,
  getHistoryRslFailure,
  getHistoryRslDisRequest,
  getHistoryRslDisSuccess,
  getHistoryRslDisFailure,
  getHistoryRslJikakuRequest,
  getHistoryRslJikakuSuccess,
  getHistoryRslJikakuFailure,
  getPubNoteChartRequest,
  getPubNoteChartSuccess,
  getPubNoteChartFailure,
  getPubNoteCautionRequest,
  getPubNoteCautionSuccess,
  getPubNoteCautionFailure,
  getFollowBeforeRequest,
  getFollowBeforeSuccess,
  getFollowBeforeFailure,
  getFollowInfoRequest,
  getFollowInfoSuccess,
  getFollowInfoFailure,
  getTargetFollowRequest,
  getTargetFollowSuccess,
  getTargetFollowFailure,
  getSetClassCdRequest,
  getSetClassCdSuccess,
  getSetClassCdFailure,
  getConsultHistoryRequest,
  getConsultHistorySuccess,
  getConsultHistoryFailure,
  openMenResultGuide,
  closeMenResultGuide,
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
  initializeLogList,
  getUpdateLogListRequest,
  getUpdateLogListSuccess,
  getUpdateLogListFailure,
  setLogListParams,
  openUpdateLogGuide,
  closeUpdateLogGuide,
  getHistoryRslListRequest,
  getHistoryRslListSuccess,
  getHistoryRslListFailure,
  getPatientHistoryRequest,
  getPatientHistorySuccess,
  getPatientHistoryFailure,
  getDiseaseHistoryRequest,
  getDiseaseHistorySuccess,
  getDiseaseHistoryFailure,
  openDiseaseHistoryGuide,
  closeDiseaseHistoryGuide,
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
  getViewOldTotalJudCmtRequest,
  getViewOldTotalJudCmtSuccess,
  getViewOldTotalJudCmtFailure,
  openViewOldJudCommentGuide,
  closeViewOldJudCommentGuide,
  getInterviewHeaderRequest,
  getInterviewHeaderSuccess,
  getInterviewHeaderFailure,
  openMonshinNyuryokuGuide,
  closeMonshinNyuryokuGuide,
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
  changeFoodCommentRequest,
  changeFoodCommentSuccess,
  changeFoodCommentFailure,
  changeMenuCommentRequest,
  changeMenuCommentSuccess,
  changeMenuCommentFailure,
  updateJudCmtRequest,
  getVer201210Request,
  getVer201210Success,
  getVer201210Failure,
  openMenFoodCommentGuide,
  closeMenFoodCommentGuide,
  getTotalJudEditBodyRequest,
  getMdrdHistoryRequest,
  getMdrdHistorySuccess,
  getMdrdHistoryFailure,
  getNewGfrHistoryRequest,
  getNewGfrHistorySuccess,
  getNewGfrHistoryFailure,
  getJudListRequest,
  getJudListSuccess,
  getJudListFailure,
  saveTotalJudRequest,
  saveTotalJudSuccess,
  saveTotalJudFailure,
  initializeInterview,
  getFollowUpHeaderRequest,
  getFollowUpHeaderSuccess,
  getFollowUpHeaderFailure,
  setSelectedEntryRecogLevelItem,
  openEntryRecogLevelGuide,
  closeEntryRecogLevelGuide,
  updateEntryListSuccess,
  getShokusyukanListRequest,
  getShokusyukanListSuccess,
  getShokusyukanListFailure,
  openShokusyukan201210Guide,
  closeShokusyukan201210Guide,
  calcRequest,
  calcRequestSuccess,
  calcRequestFailure,
  setModeValue,
  deleteValue,
} = createActions(
  // 指定予約番号の受診情報取得
  'GET_INTERVIEW_CONSULT_REQUEST',
  'GET_INTERVIEW_CONSULT_SUCCESS',
  'GET_INTERVIEW_CONSULT_FAILURE',
  // 指定対象受診者の検査結果歴取得(質問内容)
  'GET_HISTORY__RSL_LIFE_REQUEST',
  'GET_HISTORY__RSL_LIFE_SUCCESS',
  'GET_HISTORY__RSL_LIFE_FAILURE',
  // 指定対象受診者の検査結果歴取得(自覚症状)
  'GET_HISTORY__RSL_SELF_REQUEST',
  'GET_HISTORY__RSL_SELF_SUCCESS',
  'GET_HISTORY__RSL_SELF_FAILURE',
  // 指定対象受診者の判定結果
  'SELECT_JUD_HISTORY_RSL_LIST_REQUEST',
  'SELECT_JUD_HISTORY_RSL_LIST_SUCCESS',
  'SELECT_JUD_HISTORY_RSL_LIST_FAILURE',
  // 総合コメント
  'GET_TOTAL_JUD_CMT_REQUEST',
  'GET_TOTAL_JUD_CMT_SUCCESS',
  'GET_TOTAL_JUD_CMT_FAILURE',
  // 受診情報一覧
  'GET_HISTORIES_REQUEST',
  'GET_HISTORIES_SUCCESS',
  'GET_HISTORIES_FAILURE',
  // 判定医
  'GET_HISTORY_RSL_REQUEST',
  'GET_HISTORY_RSL_SUCCESS',
  'GET_HISTORY_RSL_FAILURE',
  // 病歴
  'GET_HISTORY_RSL_DIS_REQUEST',
  'GET_HISTORY_RSL_DIS_SUCCESS',
  'GET_HISTORY_RSL_DIS_FAILURE',
  // 自覚症状
  'GET_HISTORY_RSL_JIKAKU_REQUEST',
  'GET_HISTORY_RSL_JIKAKU_SUCCESS',
  'GET_HISTORY_RSL_JIKAKU_FAILURE',
  // チャート情報
  'GET_PUB_NOTE_CHART_REQUEST',
  'GET_PUB_NOTE_CHART_SUCCESS',
  'GET_PUB_NOTE_CHART_FAILURE',
  // 注意事項
  'GET_PUB_NOTE_CAUTION_REQUEST',
  'GET_PUB_NOTE_CAUTION_SUCCESS',
  'GET_PUB_NOTE_CAUTION_FAILURE',
  // 前回フォロー情報
  'GET_FOLLOW_BEFORE_REQUEST',
  'GET_FOLLOW_BEFORE_SUCCESS',
  'GET_FOLLOW_BEFORE_FAILURE',
  // フォローアップ情報
  'GET_FOLLOW_INFO_REQUEST',
  'GET_FOLLOW_INFO_SUCCESS',
  'GET_FOLLOW_INFO_FAILURE',
  // フォローアップ対象者
  'GET_TARGET_FOLLOW_REQUEST',
  'GET_TARGET_FOLLOW_SUCCESS',
  'GET_TARGET_FOLLOW_FAILURE',
  // 特定健診対象区分
  'GET_SET_CLASS_CD_REQUEST',
  'GET_SET_CLASS_CD_SUCCESS',
  'GET_SET_CLASS_CD_FAILURE',
  // 受診歴一覧
  'GET_CONSULT_HISTORY_REQUEST',
  'GET_CONSULT_HISTORY_SUCCESS',
  'GET_CONSULT_HISTORY_FAILURE',
  // 検査分類毎結果
  'OPEN_MEN_RESULT_GUIDE',
  'CLOSE_MEN_RESULT_GUIDE',
  // コースグループ取得
  'GET_CS_GRP_REQUEST',
  'GET_CS_GRP_SUCCESS',
  'GET_CS_GRP_FAILURE',
  // オーダ番号1
  'GET_ORDER_NO1_REQUEST',
  'GET_ORDER_NO1_SUCCESS',
  'GET_ORDER_NO1_FAILURE',
  // オーダ番号2
  'GET_ORDER_NO2_REQUEST',
  'GET_ORDER_NO2_SUCCESS',
  'GET_ORDER_NO2_FAILURE',
  // オーダ番号3
  'GET_ORDER_NO3_REQUEST',
  'GET_ORDER_NO3_SUCCESS',
  'GET_ORDER_NO3_FAILURE',
  // 変更前のIDと変更後のIDを取得する
  'GET_CHANGE_PER_ID_REQUEST',
  'GET_CHANGE_PER_ID_SUCCESS',
  'GET_CHANGE_PER_ID_FAILURE',
  // 変更履歴一覧初期化
  'INITIALIZE_LOG_LIST',
  // 変更履歴一覧取得
  'GET_UPDATE_LOG_LIST_REQUEST',
  'GET_UPDATE_LOG_LIST_SUCCESS',
  'GET_UPDATE_LOG_LIST_FAILURE',
  // 変更履歴一覧引数値設定
  'SET_LOG_LIST_PARAMS',
  // 変更履歴ガイド
  'OPEN_UPDATE_LOG_GUIDE',
  'CLOSE_UPDATE_LOG_GUIDE',
  // 指定対象受診者の検査結果歴を取得する
  'GET_HISTORY_RSL_LIST_REQUEST',
  'GET_HISTORY_RSL_LIST_SUCCESS',
  'GET_HISTORY_RSL_LIST_FAILURE',
  // 入院・外来歴取得する
  'GET_PATIENT_HISTORY_REQUEST',
  'GET_PATIENT_HISTORY_SUCCESS',
  'GET_PATIENT_HISTORY_FAILURE',
  // 病歴取得する
  'GET_DISEASE_HISTORY_REQUEST',
  'GET_DISEASE_HISTORY_SUCCESS',
  'GET_DISEASE_HISTORY_FAILURE',
  // 病歴情報ガイド
  'OPEN_DISEASE_HISTORY_GUIDE',
  'CLOSE_DISEASE_HISTORY_GUIDE',
  // 受診情報
  'UPDATE_TOTAL_JUD_CMT_REQUEST',
  'UPDATE_TOTAL_JUD_CMT_SUCCESS',
  'UPDATE_TOTAL_JUD_CMT_FAILURE',
  'GET_ENTRY_RECOG_LEVEL_LIST',
  'GET_ENTRY_LIST_SUCCESS',
  'GET_ENTRY_LIST_FAILURE',
  // コースグループ取得
  'GET_CS_GRP_DATA_REQUEST',
  'GET_CS_GRP_DATA_SUCCESS',
  'GET_CS_GRP_DATA_FAILURE',
  // 指定された予約番号の個人ＩＤの受診歴一覧取得
  'GET_VIEW_OLD_CONSULT_HISTORY_REQUEST',
  'GET_VIEW_OLD_CONSULT_HISTORY_SUCCESS',
  'GET_VIEW_OLD_CONSULT_HISTORY_FAILURE',
  // 総合コメント取得
  'GET_VIEW_OLD_TOTAL_JUD_CMT_REQUEST',
  'GET_VIEW_OLD_TOTAL_JUD_CMT_SUCCESS',
  'GET_VIEW_OLD_TOTAL_JUD_CMT_FAILURE',
  // 過去総合コメント一覧
  'OPEN_VIEW_OLD_JUD_COMMENT_GUIDE',
  'CLOSE_VIEW_OLD_JUD_COMMENT_GUIDE',
  // 面接支援ヘッダ表示
  'GET_INTERVIEW_HEADER_REQUEST',
  'GET_INTERVIEW_HEADER_SUCCESS',
  'GET_INTERVIEW_HEADER_FAILURE',
  // 生活習慣ガイド
  'OPEN_MONSHIN_NYURYOKU_GUIDE',
  'CLOSE_MONSHIN_NYURYOKU_GUIDE',
  // 指定された個人ＩＤの受診歴一覧
  'GET_CONSULT_HISTORY_JUD_HEADER_REQUEST',
  'GET_CONSULT_HISTORY_JUD_HEADER_SUCCESS',
  'GET_CONSULT_HISTORY_JUD_HEADER_FAILURE',
  // 指定された予約番号の受診歴一覧
  'GET_CONSULT_HISTORY_MEN_RESULT_REQUEST',
  'GET_CONSULT_HISTORY_MEN_RESULT_SUCCESS',
  'GET_CONSULT_HISTORY_MEN_RESULT_FAILURE',
  // 指定対象受診者の検査結果を取得する
  'GET_HISTORY_RSL_LIST_MEN_RESULT_REQUEST',
  'GET_HISTORY_RSL_LIST_MEN_RESULT1_SUCCESS',
  'GET_HISTORY_RSL_LIST_MEN_RESULT1_FAILURE',
  'GET_HISTORY_RSL_LIST_MEN_RESULT3_SUCCESS',
  'GET_HISTORY_RSL_LIST_MEN_RESULT3_FAILURE',
  // 食習慣, 献立コメント
  'UPDATE_JUD_CMT_REQUEST',
  // 食習慣コメント追加, 挿入, 修正, 削除時の処理
  'CHANGE_FOOD_COMMENT_REQUEST',
  'CHANGE_FOOD_COMMENT_SUCCESS',
  'CHANGE_FOOD_COMMENT_FAILURE',
  // 献立コメント追加, 挿入, 修正, 削除時の処理
  'CHANGE_MENU_COMMENT_REQUEST',
  'CHANGE_MENU_COMMENT_SUCCESS',
  'CHANGE_MENU_COMMENT_FAILURE',
  // 2012年10月バージョン対象チェック
  'GET_VER_201210_REQUEST',
  'GET_VER_201210_SUCCESS',
  'GET_VER_201210_FAILURE',
  // 食習慣、献立コメントガイド
  'OPEN_MEN_FOOD_COMMENT_GUIDE',
  'CLOSE_MEN_FOOD_COMMENT_GUIDE',
  // 担当者初期値設定の処理
  'GET_DOC_INDEX_REQUEST',
  'GET_DOC_INDEX_SUCCESS',
  'GET_DOC_INDEX_FAILURE',
  // 総合判定（判定修正画面）
  'GET_TOTAL_JUD_EDIT_BODY_REQUEST',
  // 検索条件に従いeGFR(MDRD式）計算結果一覧を抽出する
  'GET_MDRD_HISTORY_REQUEST',
  'GET_MDRD_HISTORY_SUCCESS',
  'GET_MDRD_HISTORY_FAILURE',
  // 検索条件に従いGFR(日本人推算式）計算結果一覧を抽出する
  'GET_NEW_GFR_HISTORY_REQUEST',
  'GET_NEW_GFR_HISTORY_SUCCESS',
  'GET_NEW_GFR_HISTORY_FAILURE',
  // 判定の一覧を取得する
  'GET_JUD_LIST_REQUEST',
  'GET_JUD_LIST_SUCCESS',
  'GET_JUD_LIST_FAILURE',
  // 判定の更新
  'SAVE_TOTAL_JUD_REQUEST',
  'SAVE_TOTAL_JUD_SUCCESS',
  'SAVE_TOTAL_JUD_FAILURE',
  // 面接支援初期化
  'INITIALIZE_INTERVIEW',
  // フォローアップヘッダー情報
  'GET_FOLLOW_UP_HEADER_REQUEST',
  'GET_FOLLOW_UP_HEADER_SUCCESS',
  'GET_FOLLOW_UP_HEADER_FAILURE',
  // 生活指導コメント
  'SET_SELECTED_ENTRY_RECOG_LEVEL_ITEM',
  'OPEN_ENTRY_RECOG_LEVEL_GUIDE',
  'CLOSE_ENTRY_RECOG_LEVEL_GUIDE',
  'UPDATE_ENTRY_LIST_SUCCESS',

  'GET_SHOKUSYUKAN_LIST_REQUEST',
  'GET_SHOKUSYUKAN_LIST_SUCCESS',
  'GET_SHOKUSYUKAN_LIST_FAILURE',
  'OPEN_SHOKUSYUKAN201210_GUIDE',
  'CLOSE_SHOKUSYUKAN201210_GUIDE',
  'CALC_REQUEST',
  'CALC_REQUEST_SUCCESS',
  'CALC_REQUEST_FAILURE',
  'SET_MODE_VALUE',
  'DELETE_VALUE',
);

// stateの初期値
const initialState = {
  historyRslList: {
    dataLife: [],
    dataSelf: [],
    visible: false,
  },
  consultData: {
    message: [],
    data: {},
  },
  interView: {
    message: [],
    // 以下一覧用
    conditions: {
      strDate: null,
      endDate: null,
    }, // 検索条件
    judHistoryRslList: [],
    historiesData: [],
    commentData: [],
    historyRslData: [],
    historyRslDisData: [],
    historyRslJikakuData: [],
    pubNoteChartData: [],
    pubNoteCautionData: [],
    followBeforeData: {},
    followInfoData: {},
    targetFollowData: [],
    classCdData: false,
    orderNoData: [],
    consultHistoryData: [],
    // 総合判定（ヘッダ）
    judHeader: {
      consultHistoryData: [],
      message: [],
    },
    // eGFR(MDRD式）計算結果一覧
    mdrdHistory: [],
    newGfrHistory: [],
    judList: [],
  },
  menResult: {
    message: [],
    visible: false,
    resultdispmode: null,
    orderNoData1: {},
    orderNoData2: {},
    orderNoData3: {},
    peridData: {},
    consultHistoryData: [],
    conditions: {},
    historyRslData1: [],
    historyRslData3: [],
  },
  csGrpData: [],

  rslUpdateHistoryList: {
    message: [],
    // 以下一覧用
    conditions: {
      startupddate: moment(new Date()).format('YYYY/MM/DD'),
      endupddate: moment(new Date()).format('YYYY/MM/DD'),
      searchupduser: '',
      searchupdclass: null,
      orderbyitem: null,
      orderbymode: null,
      page: 1,
      limit: 50,
    }, // 検索条件
    totalCount: 0,
    data: [],
    searched: false,
    visible: false,
  },
  diseaseHistoryList: {
    historydata: [],
    perid: '',
    cscd: '',
    message: [],
    visible: false,
  },
  entryRecogLevel: {
    message: [],
    commentData: [],
    recoglevel: [],
    itemName: '',
    items: [],
    list: [],
    judcmtcd: [],
    visible: false,
  },
  entryRecogEdit: {
    // エラー等のメッセージ
    message: [],
  },
  viewOldJudCommentList: {
    message: [],
    csGrpData: [],
    consultHistoryData: [],
    totalJudCmtData: [],
    visible: true,
  },
  interviewHeader: {
    message: [],
    // 予約番号
    rsvno: null,
    // 特定保険指導対象者チェック
    specialcheck: null,
    // 受診情報
    consult: {},
    // オプション検査名
    optitems: [],
    // 個人検査結果情報
    perResultGrps: [],
    // 実年齢
    realage: null,
    // ジャンプ先のURL選択肢
    selecturlItems: [],
    // ジャンプ先のURL選択肢
    winmode: null,
    // ウインドウで
    selecturl: null,
  },
  menFoodCommentGuide: {
    foodadvicedata: [],
    menuadvicedata: [],
    rsvno: null,
    visible: false,
    mode: '',
    selectfoodlist: '',
    verflag: false,
    commentFlag: '',
  },
  entryAutherList: {
    message: [],
    visible: true,
    hainsUserData: {},
    flagMen: 0,
    flagJud: 0,
    flagKan: 0,
    flagEif: 0,
    flagShi: 0,
    flagNai: 0,
    flagCheck: 0,
    docindex: '',
    checkValue: [],
  },
  followUpHeader: {
    message: [],
    // 特定保険指導対象者チェック
    specialcheck: null,
    // 受診情報
    consult: {},
    // オプション検査名
    optitems: [],
    // 個人検査結果情報
    perResultGrps: [],
    // 実年齢
    realage: null,
    // ジャンプ先のURL選択肢
  },
  getShokusyukanList: {
    data: [],
    message: '',
    arrFoodCmtCnt: [],
    visible: false,
  },
};
// reducerの作成
export default handleActions({
  // 受診情報取得開始時の処理
  [getInterviewConsultRequest]: (state, action) => {
    const { consultData } = state;
    const { data, rsvno } = action.payload;
    return { ...state, consultData: { ...consultData, data, rsvno } };
  },

  // 受診情報取得成功時の処理
  [getInterviewConsultSuccess]: (state, action) => {
    const { consultData, diseaseHistoryList } = state;
    const data = action.payload;
    const cscd = action.payload;
    const perid = action.payload;
    const newcscd = cscd;
    if (cscd === null) {
      return { ...state, consultData: { ...consultData, data }, diseaseHistoryList: { ...diseaseHistoryList, perid, newcscd } };
    }
    return { ...state, consultData: { ...consultData, data }, diseaseHistoryList: { ...diseaseHistoryList, perid } };
  },
  // 受診情報取得失敗時の処理
  [getInterviewConsultFailure]: (state, action) => {
    const { consultData, diseaseHistoryList } = state;
    const { status, rsvno } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報が存在しません。（予約番号= "${rsvno}")`];
    }
    return { ...state, consultData: { ...consultData, message }, diseaseHistoryList: { ...diseaseHistoryList, message } };
  },
  // 質問内容情報取得成功時の処理
  [getHistoryRslLifeSuccess]: (state, action) => {
    const { historyRslList } = state;
    const data = action.payload;
    return { ...state, historyRslList: { ...historyRslList, dataLife: data } };
  },
  // 自覚症状情報取得成功時の処理
  [getHistoryRslSelfSuccess]: (state, action) => {
    const { historyRslList } = state;
    const data = action.payload;
    return { ...state, historyRslList: { ...historyRslList, dataSelf: data } };
  },
  // 判定結果一覧を抽出する時の処理
  [selectJudHistoryRslListRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 判定結果一覧を抽出する成功時の処理
  [selectJudHistoryRslListSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { data } = action.payload;
    return { ...state, interView: { ...interView, judHistoryRslList: data } };
  },
  // 判定結果一覧を抽出する失敗時の処理
  [selectJudHistoryRslListFailure]: (state, action) => {
    const { interView } = state;
    const { status } = action.payload;
    const { rsvNo } = interView.conditions;
    let message;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`判定結果がありません。RsvNo= ${rsvNo}`];
    }
    return { ...state, interView: { ...interView, message } };
  },
  // 総合コメントを取得時の処理
  [getTotalJudCmtRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 総合コメントを取得成功時の処理
  [getTotalJudCmtSuccess]: (state, action) => {
    const { interView, menFoodCommentGuide } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const { commentData, foodadvicedata, menuadvicedata, rsvno } = action.payload;
    return { ...state, interView: { ...interView, searched, commentData }, menFoodCommentGuide: { ...menFoodCommentGuide, foodadvicedata, menuadvicedata, rsvno } };
  },
  // 受診情報一覧を取得時の処理
  [getHistoriesRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 受診情報一覧を取得成功時の処理
  [getHistoriesSuccess]: (state, action) => {
    const { interView } = state;
    // 総件数とデータとを更新する
    const { historiesData } = action.payload;
    return { ...state, interView: { ...interView, historiesData } };
  },
  // 受診情報一覧を取得失敗時の処理
  [getHistoriesFailure]: (state, action) => {
    const { interView } = state;
    const { status } = action.payload;
    const { rsvNo } = interView.conditions;
    const { lastDspMode } = interView.conditions;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報がありません。 RsvNo = ${lastDspMode} ( ${rsvNo}`];
    }

    return { ...state, interView: { ...interView, message } };
  },
  // 判定医を取得時の処理
  [getHistoryRslRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 判定医を取得成功時の処理
  [getHistoryRslSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const historyRslData = action.payload;
    return { ...state, interView: { ...interView, searched, historyRslData: !historyRslData ? [] : historyRslData } };
  },
  // 病歴を取得時の処理
  [getHistoryRslDisRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 病歴を取得成功時の処理
  [getHistoryRslDisSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const { historyRslDisData } = action.payload;
    return { ...state, interView: { ...interView, searched, historyRslDisData } };
  },
  // 自覚症を取得時の処理
  [getHistoryRslJikakuRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 自覚症を取得成功時の処理
  [getHistoryRslJikakuSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const { historyRslJikakuData } = action.payload;

    return { ...state, interView: { ...interView, searched, historyRslJikakuData } };
  },
  // チャート情報を取得時の処理
  [getPubNoteChartRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // チャート情報を取得成功時の処理
  [getPubNoteChartSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const pubNoteChartData = action.payload;

    return { ...state, interView: { ...interView, searched, pubNoteChartData } };
  },
  // 注意事項を取得時の処理
  [getPubNoteCautionRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 注意事項を取得成功時の処理
  [getPubNoteCautionSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const pubNoteCautionData = action.payload;

    return { ...state, interView: { ...interView, searched, pubNoteCautionData: pubNoteCautionData !== '' ? pubNoteCautionData : [] } };
  },
  // 前回フォロー情報を取得時の処理
  [getFollowBeforeRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 前回フォロー情報を取得成功時の処理
  [getFollowBeforeSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const { followBeforeData } = action.payload;

    return {
      ...state, interView: { ...interView, searched, followBeforeData: followBeforeData === '' ? {} : followBeforeData },
    };
  },
  // フォローアップ情報を取得時の処理
  [getFollowInfoRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // フォローアップ情報を取得成功時の処理
  [getFollowInfoSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const followInfoData = action.payload;

    return {
      ...state, interView: { ...interView, searched, followInfoData: followInfoData === '' ? {} : followInfoData },
    };
  },
  // フォローアップ対象者を取得時の処理
  [getTargetFollowRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // フォローアップ対象者を取得成功時の処理
  [getTargetFollowSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const targetFollowData = action.payload;

    return { ...state, interView: { ...interView, searched, targetFollowData } };
  },
  // 特定健診対象区分を取得時の処理
  [getSetClassCdRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 特定健診対象区分を取得成功時の処理
  [getSetClassCdSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    const { classCdData } = action.payload;

    return { ...state, interView: { ...interView, searched, classCdData } };
  },
  // 受診歴一覧を取得時の処理
  [getConsultHistoryRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 受診歴一覧を取得成功時の処理
  [getConsultHistorySuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { consultHistoryData } = action.payload;
    return { ...state, interView: { ...interView, consultHistoryData } };
  },
  // 受診歴一覧を取得失敗時の処理
  [getConsultHistoryFailure]: (state, action) => {
    const { interView } = state;
    const { status } = action.payload;
    const { rsvNo, lastDspMode } = interView.conditions;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報がありません。RsvNo=${lastDspMode}(${rsvNo}`];
    }

    return { ...state, interView: { ...interView, message } };
  },
  // 検査分類毎結果を開くアクション時の処理
  [openMenResultGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;

    const resultdispmode = action.payload;
    const { menResult } = state;
    return { ...state, menResult: { ...menResult, visible, resultdispmode } };
  },
  // 検査分類毎結果を閉じるアクション時の処理
  [closeMenResultGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { menResult } = initialState;
    return { ...state, menResult };
  },
  // 受診歴一覧を取得成功時の処理
  [getCsGrpSuccess]: (state, action) => {
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { csGrpData } = action.payload;
    return { ...state, csGrpData };
  },
  // オーダ番号、送信日を取得時の処理
  [getOrderNo1Request]: (state, action) => {
    const { menResult } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, menResult: { ...menResult, conditions } };
  },
  // オーダ番号、送信日を取得成功時の処理
  [getOrderNo1Success]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { orderNoData } = action.payload;
    return { ...state, menResult: { ...menResult, orderNoData1: orderNoData } };
  },
  // オーダ番号、送信日を取得時の処理
  [getOrderNo2Request]: (state, action) => {
    const { menResult } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, menResult: { ...menResult, conditions } };
  },
  // オーダ番号、送信日を取得成功時の処理
  [getOrderNo2Success]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { orderNoData } = action.payload;
    return { ...state, menResult: { ...menResult, orderNoData2: orderNoData } };
  },
  // オーダ番号、送信日を取得時の処理
  [getOrderNo3Request]: (state, action) => {
    const { menResult } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, menResult: { ...menResult, conditions } };
  },
  // オーダ番号、送信日を取得成功時の処理
  [getOrderNo3Success]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { orderNoData } = action.payload;
    return { ...state, menResult: { ...menResult, orderNoData3: orderNoData } };
  },
  // 変更前のIDと変更後のIDを取得する
  [getChangePerIdRequest]: (state, action) => {
    const { menResult } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, menResult: { ...menResult, conditions } };
  },
  // 変更前のIDと変更後のIDを取得する
  [getChangePerIdSuccess]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { peridData } = action.payload;
    return { ...state, menResult: { ...menResult, peridData } };
  },
  // 指定された個人ＩＤの受診歴一覧を取得成功時の処理
  [getConsultHistoryJudHeaderSuccess]: (state, action) => {
    const { interView } = state;
    const { judHeader } = interView;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { consultHistoryData } = action.payload;
    return {
      ...state, interView: { ...interView, judHeader: { ...judHeader, consultHistoryData } },
    };
  },
  // 指定された個人ＩＤの受診歴一覧を取得失敗時の処理
  [getConsultHistoryJudHeaderFailure]: (state, action) => {
    const { interView } = state;
    const { judHeader } = interView;
    const { status } = action.payload;
    const { rsvNo } = interView.conditions;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診歴が取得できません。（予約番号 = ${rsvNo})`];
    }

    return { ...state, interView: { ...interView, judHeader: { ...judHeader, message } } };
  },
  // 指定された予約番号の受診歴一覧を取得成功時の処理
  [getConsultHistoryMenResultSuccess]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { consultHistoryData } = action.payload;
    return {
      ...state, menResult: { ...menResult, consultHistoryData },
    };
  },
  // 指定された予約番号の受診歴一覧を取得失敗時の処理
  [getConsultHistoryMenResultFailure]: (state, action) => {
    const { menResult } = state;
    const { status } = action.payload;
    const { rsvNo } = menResult.conditions;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診歴が取得できません。（予約番号 = ${rsvNo})`];
    }

    return { ...state, menResult: { ...menResult, message } };
  },
  // 指定対象受診者の検査結果を取得成功時の処理
  [getHistoryRslListMenResult1Success]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { historyRslData1 } = action.payload;
    return {
      ...state, menResult: { ...menResult, historyRslData1 },
    };
  },
  // 指定対象受診者の検査結果を取得失敗時の処理
  [getHistoryRslListMenResult1Failure]: (state, action) => {
    const { menResult } = state;
    const { status } = action.payload;
    const { rsvNo } = menResult.conditions;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`検査結果が取得できません。（予約番号 = ${rsvNo})`];
    }

    return { ...state, menResult: { ...menResult, message } };
  },
  // 指定対象受診者の検査結果を取得成功時の処理
  [getHistoryRslListMenResult3Success]: (state, action) => {
    const { menResult } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const { historyRslData3 } = action.payload;
    return {
      ...state, menResult: { ...menResult, historyRslData3 },
    };
  },
  // 指定対象受診者の検査結果を取得失敗時の処理
  [getHistoryRslListMenResult3Failure]: (state, action) => {
    const { menResult } = state;
    const { status } = action.payload;
    const { rsvNo } = menResult.conditions;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`検査結果が取得できません。（予約番号 = ${rsvNo})`];
    }

    return { ...state, menResult: { ...menResult, message } };
  },
  // 変更履歴一覧初期化処理
  [initializeLogList]: (state) => {
    const { rslUpdateHistoryList } = initialState;
    return { ...state, rslUpdateHistoryList };
  },
  // 変更履歴一覧取得開始時の処理
  [getUpdateLogListRequest]: (state, action) => {
    const { rslUpdateHistoryList } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, rslUpdateHistoryList: { ...rslUpdateHistoryList, conditions } };
  },
  // 変更履歴一覧取得成功時の処理
  [getUpdateLogListSuccess]: (state, action) => {
    const { rslUpdateHistoryList } = state;
    // 検索指示状態とする
    const searched = true;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { totalCount, data } = action.payload;
    return { ...state, rslUpdateHistoryList: { ...rslUpdateHistoryList, searched, totalCount, data } };
  },
  // 変更履歴一覧引数値設定の処理
  [setLogListParams]: (state, action) => {
    const { rslUpdateHistoryList } = state;
    const { conditions } = rslUpdateHistoryList;
    // (これに伴い一覧が再描画される)
    const { newParams } = action.payload;
    return {
      ...state, rslUpdateHistoryList: { ...rslUpdateHistoryList, conditions: { ...conditions, ...newParams } },
    };
  },
  // 変更履歴一覧ガイドを開くアクション時の処理
  [openUpdateLogGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { rslUpdateHistoryList } = initialState;
    return { ...state, rslUpdateHistoryList: { ...rslUpdateHistoryList, visible } };
  },

  // 生活指導コメントを開くアクション時の処理
  [openEntryRecogLevelGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { entryRecogLevel } = state;
    return { ...state, entryRecogLevel: { ...entryRecogLevel, visible } };
  },
  // 生活指導コメント
  [closeEntryRecogLevelGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const visible = false;
    const { entryRecogLevel } = state;
    return { ...state, entryRecogLevel: { ...entryRecogLevel, visible } };
  },
  // 生活指導コメント
  [updateEntryListSuccess]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const visible = false;
    const { entryRecogLevel } = state;
    return { ...state, entryRecogLevel: { ...entryRecogLevel, visible } };
  },
  // 変更履歴一覧ガイドを閉じるアクション時の処理
  [closeUpdateLogGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { rslUpdateHistoryList } = initialState;
    return { ...state, rslUpdateHistoryList };
  },
  // 受診者の検査結果歴取得成功時の処理
  [getHistoryRslListSuccess]: (state, action) => {
    const { diseaseHistoryList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { historydata } = action.payload;
    return { ...state, diseaseHistoryList: { ...diseaseHistoryList, historydata } };
  },
  // 受診者の検査結果歴を取得失敗時の処理
  [getHistoryRslListFailure]: (state, action) => {
    const { diseaseHistoryList } = state;
    const { status, perid } = action.payload;
    let message = '';
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`検査結果が取得できません。（個人ＩＤ = ${perid})`];
    }

    return { ...state, diseaseHistoryList: { ...diseaseHistoryList, message } };
  },
  // 入院・外来歴取得成功時の処理
  [getPatientHistorySuccess]: (state, action) => {
    const { diseaseHistoryList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { patientdata } = action.payload;
    return { ...state, diseaseHistoryList: { ...diseaseHistoryList, patientdata } };
  },
  // 病歴取得成功時の処理
  [getDiseaseHistorySuccess]: (state, action) => {
    const { diseaseHistoryList } = state;
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { diseasedata } = action.payload;
    return { ...state, diseaseHistoryList: { ...diseaseHistoryList, diseasedata } };
  },
  // 病歴情報ガイドを開くアクション時の処理
  [openDiseaseHistoryGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { diseaseHistoryList } = initialState;
    return { ...state, diseaseHistoryList: { ...diseaseHistoryList, visible } };
  },
  // 病歴情報ガイドを閉じるアクション時の処理
  [closeDiseaseHistoryGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { diseaseHistoryList } = initialState;
    return { ...state, diseaseHistoryList };
  },
  // 生活指導コメント 一覧取得成功時の処理
  [getEntryListSuccess]: (state, action) => {
    const { entryRecogLevel } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    // (これに伴い一覧が再描画される)
    const { commentData, recoglevel, itemName, items, list } = action.payload;
    const judcmtcd = [];
    for (let i = 0; i < list.length; i += 1) {
      judcmtcd.push(list[i].judcmtcd);
    }
    return { ...state, entryRecogLevel: { ...entryRecogLevel, commentData, recoglevel, itemName, items, list, judcmtcd } };
  },

  [setSelectedEntryRecogLevelItem]: (state, action) => {
    const { entryRecogLevel } = state;
    const { recoglevel } = action.payload.formValues;
    const list = action.payload.params;
    for (let i = 1; i <= list.length; i += 1) {
      list[i - 1].seq = i;
    }
    return { ...state, entryRecogLevel: { ...entryRecogLevel, list, recoglevel } };
  },

  // 面接支援 一覧取得失败時の処理
  [getEntryListFailure]: (state, action) => {
    const { entryRecogLevel } = state;
    const { status, commentData } = action.payload;

    let message = commentData.errors;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (!message && status === 404) {
      message = ['指定の情報は存在しませんでした。'];
    }
    return { ...state, entryRecogLevel: { ...entryRecogLevel, message } };
  },

  // 面接支援 画面保存成功時 の処理
  [updateTotalJudCmtSuccess]: (state) => {
    const { entryRecogEdit, menFoodCommentGuide } = state;
    const { verflag } = menFoodCommentGuide;
    const message = ['保存が完了しました。'];
    let visible = true;
    if (verflag === false) {
      visible = false;
    }
    return { ...state, entryRecogEdit: { ...entryRecogEdit, message }, menFoodCommentGuide: { ...menFoodCommentGuide, visible } };
  },
  // 面接支援 画面保存失败時 の処理
  [updateTotalJudCmtFailure]: (state) => {
    const { entryRecogEdit } = state;
    const message = ['保存失败しませんでした。'];
    return { ...state, entryRecogEdit: { ...entryRecogEdit, message } };
  },
  // コースグループ取得成功時の処理
  [getCsGrpDataSuccess]: (state, action) => {
    const { viewOldJudCommentList } = state;
    const { csGrpData } = action.payload;
    return { ...state, viewOldJudCommentList: { ...viewOldJudCommentList, csGrpData } };
  },
  // 指定された予約番号の個人ＩＤの受診歴一覧取得成功時の処理
  [getViewOldConsultHistorySuccess]: (state, action) => {
    const { viewOldJudCommentList } = state;
    const { consultHistoryData } = action.payload;
    return { ...state, viewOldJudCommentList: { ...viewOldJudCommentList, consultHistoryData } };
  },
  // 指定された予約番号の個人ＩＤの受診歴一覧取得失敗時の処理
  [getViewOldConsultHistoryFailure]: (state, action) => {
    const { viewOldJudCommentList } = state;
    const { status, rsvno } = action.payload;
    let message = [];
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [`受診情報がありません。RsvNo= ${rsvno}`];
    }
    return { ...state, viewOldJudCommentList: { ...viewOldJudCommentList, message } };
  },
  // 総合コメント取得成功時の処理
  [getViewOldTotalJudCmtSuccess]: (state, action) => {
    const { viewOldJudCommentList } = state;
    const { commentData } = action.payload;
    return { ...state, viewOldJudCommentList: { ...viewOldJudCommentList, totalJudCmtData: commentData !== '' ? commentData : [] } };
  },
  // 変更履歴一覧ガイドを開くアクション時の処理
  [openViewOldJudCommentGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { viewOldJudCommentList } = initialState;
    return { ...state, viewOldJudCommentList: { ...viewOldJudCommentList, visible } };
  },
  // 変更履歴一覧ガイドを閉じるアクション時の処理
  [closeViewOldJudCommentGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { viewOldJudCommentList } = initialState;
    return { ...state, viewOldJudCommentList };
  },
  // 面接支援ヘッダ取得成功時の処理
  [getInterviewHeaderSuccess]: (state, action) => {
    const { interviewHeader } = state;
    const { consult, optitems, perResultGrps, realage, specialcheck, selecturlItems } = action.payload;
    return { ...state, interviewHeader: { ...interviewHeader, consult, optitems, perResultGrps, realage, specialcheck, selecturlItems } };
  },
  // 面接支援ヘッダ取得失敗時の処理
  [getInterviewHeaderFailure]: (state, action) => {
    const { interviewHeader } = state;
    const { message } = action.payload;
    let messages = [];
    if (message) {
      messages = message;
    }
    return { ...state, interviewHeader: { ...interviewHeader, message: messages } };
  },
  // 生活習慣ガイドを開くアクション時の処理
  [openMonshinNyuryokuGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { historyRslList } = initialState;
    return { ...state, historyRslList: { ...historyRslList, visible } };
  },
  // 生活習慣ガイドを閉じるアクション時の処理
  [closeMonshinNyuryokuGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { historyRslList } = initialState;
    return { ...state, historyRslList };
  },
  // 食習慣コメント追加, 挿入, 修正時の処理
  [changeFoodCommentRequest]: (state, action) => {
    const { menFoodCommentGuide } = state;
    const { foodadvicedata, menuadvicedata, selectfoodlist, selectmenulist, mode, commentFlag } = menFoodCommentGuide;
    const { selected } = action.payload;
    let comdata = null;
    let index = null;
    let startline = null;
    if (commentFlag === 'Food') {
      comdata = foodadvicedata;
      index = selectfoodlist;
    } else {
      comdata = menuadvicedata;
      index = selectmenulist;
    }
    const vardata = selected.slice(0);
    if (selected !== undefined && selected.length > 0) {
      for (let i = 0; i < selected.length; i += 1) {
        for (let j = 0; j < comdata.length; j += 1) {
          if (selected[i].judcmtcd === comdata[j].judcmtcd) {
            vardata.splice(vardata.findIndex((rec) => (rec.judcmtcd === comdata[j].judcmtcd)), 1);
            break;
          }
        }
      }
    }
    if (mode === 'A') {
      startline = Number(comdata.length) + 1;
    } else if (mode === 'I') {
      startline = Number(index) - 1;
    } else if (mode === 'C') {
      startline = Number(index) - 1;
      comdata.splice(startline, 1);
    }
    for (let i = 0; i < vardata.length; i += 1) {
      comdata.splice(startline + i, 0, vardata[i]);
    }

    const varcomdata = [];
    for (let i = 0; i < comdata.length; i += 1) {
      varcomdata[i] = { ...comdata[i], seq: i + 1, value: i + 1, name: comdata[i].judcmtstc };
    }
    if (commentFlag === 'Food') {
      return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, foodadvicedata: varcomdata } };
    }
    return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, menuadvicedata: varcomdata } };
  },

  // 食習慣コメント削除時の処理
  [deleteValue]: (state, action) => {
    const { menFoodCommentGuide } = state;
    const { foodadvicedata, menuadvicedata } = menFoodCommentGuide;
    const { selectfoodlist, selectmenulist, commentFlag } = action.payload;
    let data = null;
    let index = null;
    if (commentFlag === 'Food') {
      index = selectfoodlist;
      data = foodadvicedata.slice(0);
    } else {
      index = selectmenulist;
      data = menuadvicedata.slice(0);
    }
    data.splice(data.findIndex((rec) => (rec.seq === parseInt(index, 10))), 1);
    if (commentFlag === 'Food') {
      return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, foodadvicedata: data } };
    }
    return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, menuadvicedata: data } };
  },
  // 2012年10月バージョン対象チェック成功時の処理
  [setModeValue]: (state, action) => {
    const { menFoodCommentGuide } = state;
    const { mode, selectfoodlist, commentFlag } = action.payload;
    return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, mode, selectfoodlist, commentFlag } };
  },
  // 2012年10月バージョン対象チェック成功時の処理
  [getVer201210Success]: (state, action) => {
    const { menFoodCommentGuide } = state;
    const verflag = action.payload;
    return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, verflag } };
  },
  // 食習慣、献立コメントガイドを開くアクション時の処理
  [openMenFoodCommentGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { menFoodCommentGuide } = initialState;
    return { ...state, menFoodCommentGuide: { ...menFoodCommentGuide, visible } };
  },
  // 食習慣、献立コメントガイドを閉じるアクション時の処理
  [closeMenFoodCommentGuide]: (state) => {
    // ガイドのstateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { menFoodCommentGuide } = initialState;
    return { ...state, menFoodCommentGuide };
  },
  // 総合判定（判定修正画面）
  [getTotalJudEditBodyRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // GFR(MDRD式）計算結果一覧を抽出する時の処理
  [getMdrdHistoryRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // GFR(MDRD式）計算結果一覧を抽出する成功時の処理
  [getMdrdHistorySuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const data = action.payload;
    return { ...state, interView: { ...interView, mdrdHistory: data } };
  },
  // GFR(MDRD式）計算結果一覧を抽出する失敗時の処理
  [getMdrdHistoryFailure]: (state, action) => {
    const { interView } = state;
    const { status } = action.payload;
    let message;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [];
    }
    return { ...state, interView: { ...interView, message } };
  },
  // GFR(日本人推算式）計算結果一覧を抽出する時の処理
  [getNewGfrHistoryRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // GFR(日本人推算式）計算結果一覧を抽出する成功時の処理
  [getNewGfrHistorySuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const data = action.payload;
    return { ...state, interView: { ...interView, newGfrHistory: data } };
  },
  // GFR(日本人推算式）計算結果一覧を抽出する失敗時の処理
  [getNewGfrHistoryFailure]: (state, action) => {
    const { interView } = state;
    const { status } = action.payload;
    let message;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [];
    }
    return { ...state, interView: { ...interView, message } };
  },
  // 判定の一覧を取得の処理
  [getJudListRequest]: (state, action) => {
    const { interView } = state;
    // 検索条件を更新する
    const conditions = action.payload;
    return { ...state, interView: { ...interView, conditions } };
  },
  // 判定の一覧を取得成功時の処理
  [getJudListSuccess]: (state, action) => {
    const { interView } = state;
    // 検索指示状態とする
    // 総件数とデータとを更新する
    const data = action.payload;
    return { ...state, interView: { ...interView, judList: data } };
  },
  // 判定の一覧を取得失敗時の処理
  [getJudListFailure]: (state, action) => {
    const { interView } = state;
    const { status } = action.payload;
    let message;
    // エラーメッセージがなく、HTTPステータスが404であればデータが存在しない旨のエラーメッセージを格納
    if (status === 404) {
      message = [];
    }
    return { ...state, interView: { ...interView, message } };
  },
  // 判定更新の処理
  [saveTotalJudRequest]: (state) => {
    const { interView } = state;
    const message = [];
    return { ...state, interView: { ...interView, message } };
  },
  // 判定更新成功時の処理
  [saveTotalJudSuccess]: (state, action) => {
    const { interView } = state;
    const message = (action.payload
      && action.payload.messages
      && action.payload.messages.length > 0) ? action.payload.messages : ['保存が完了しました。'];
    return { ...state, interView: { ...interView, message } };
  },
  // 判定更新失敗時の処理
  [saveTotalJudFailure]: (state, action) => {
    const { interView } = state;
    const { message } = interView;
    const { data } = action.payload;
    let i;
    if (data.errors) {
      for (i = 0; i < data.errors.length; i += 1) {
        message.push(data.errors[i]);
      }
    } else {
      message.push(action.payload.statusText);
    }

    return { ...state, interView: { ...interView, message } };
  },
  // 面接支援初期化処理
  [initializeInterview]: (state) => {
    const { interView } = initialState;
    return { ...state, interView };
  },
  // フォローアップヘッダー取得成功時の処理
  [getFollowUpHeaderSuccess]: (state, action) => {
    const { followUpHeader } = state;
    const { consult, optitems, perResultGrps, realage, specialcheck } = action.payload;
    return { ...state, followUpHeader: { ...followUpHeader, consult, optitems, perResultGrps, realage, specialcheck } };
  },
  // フォローアップヘッダー情報取得失敗時の処理
  [getFollowUpHeaderFailure]: (state, action) => {
    const { followUpHeader } = state;
    const { message } = action.payload;
    let messages = [];
    if (message) {
      messages = message;
    }
    return { ...state, followUpHeader: { ...followUpHeader, message: messages } };
  },
  [getShokusyukanListRequest]: (state) => {
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList } };
  },
  [getShokusyukanListSuccess]: (state, action) => {
    const { payload1, message, payload2 } = action.payload;
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList, data: payload1, message, arrFoodCmtCnt: payload2 } };
  },
  [getShokusyukanListFailure]: (state) => {
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList } };
  },
  //  食習慣問診を開くアクション時の処理
  [openShokusyukan201210Guide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList, visible } };
  },
  //  食習慣問診を閉じるアクション時の処理
  [closeShokusyukan201210Guide]: (state) => {
    const visible = false;
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList, visible } };
  },
  [calcRequest]: (state) => {
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList } };
  },
  [calcRequestSuccess]: (state, action) => {
    const { getShokusyukanList } = state;
    const message = action.payload;
    return { ...state, getShokusyukanList: { ...getShokusyukanList, message } };
  },
  [calcRequestFailure]: (state) => {
    const { getShokusyukanList } = state;
    return { ...state, getShokusyukanList: { ...getShokusyukanList } };
  },
}, initialState);
