import { createActions, handleActions } from 'redux-actions';
import moment from 'moment';

// actionの作成
export const {
  initializeWebOrgRsv,
  webOrgRsvMainLoadRequest,
  webOrgRsvMainLoadSuccess,
  webOrgRsvMainLoadFailure,
  openWebOrgRsvMainGuide,
  closeWebOrgRsvMainGuide,
  onChangeCsldivRequset,
  onChangeCsldivSuccess,
  onChangeCsldivFailure,
  registRequest,
  registSuccess,
  registFailure,
  openWebOrgRsvPersonalDetailGuide,
  closeWebOrgRsvPersonalDetailGuide,
  perDetailSave,
  // web団体予約情報検索
  initializeWebOrgRsvList,
  getWebOrgRsvListRequest,
  getWebOrgRsvListSuccess,
  getWebOrgRsvListFailure,
  setOrgName,
  changeColor,
} = createActions(
  // 初期化
  'INITIALIZE_WEB_ORG_RSV',
  // web団体予約情報登録初期化
  'WEB_ORG_RSV_MAIN_LOAD_REQUEST',
  'WEB_ORG_RSV_MAIN_LOAD_SUCCESS',
  'WEB_ORG_RSV_MAIN_LOAD_FAILURE',
  // web団体予約情報ガイドを開
  'OPEN_WEB_ORG_RSV_MAIN_GUIDE',
  'CLOSE_WEB_ORG_RSV_MAIN_GUIDE',
  // web団体予約情報選択受診区分
  'ON_CHANGE_CSLDIV_REQUSET',
  'ON_CHANGE_CSLDIV_SUCCESS',
  'ON_CHANGE_CSLDIV_FAILURE',
  // web団体予約情報保存
  'REGIST_REQUEST',
  'REGIST_SUCCESS',
  'REGIST_FAILURE',
  // 受診付属情報ガイドを開
  'OPEN_WEB_ORG_RSV_PERSONAL_DETAIL_GUIDE',
  'CLOSE_WEB_ORG_RSV_PERSONAL_DETAIL_GUIDE',
  // 受診付属情報保存
  'PER_DETAIL_SAVE',
  // web団体予約情報検索
  'INITIALIZE_WEB_ORG_RSV_LIST',
  'GET_WEB_ORG_RSV_LIST_REQUEST',
  'GET_WEB_ORG_RSV_LIST_SUCCESS',
  'GET_WEB_ORG_RSV_LIST_FAILURE',
  'SET_ORG_NAME',
  'CHANGE_COLOR',
  'REGIST_SUCCESS',
);

// stateの初期値
const initialState = {
  webOrgRsvList: {
    message: [],
    visible: false, // 可視状態
    frameUsedData: {
      cscd: null,
      csldivcd: null,
      rsvgrpcd: null,
      csldate: null,
      realage: null,
    },
    webOrgRsvData: null,
    consultDetail: null,
    consultO: null,
    personLukes: null,
    csldate: null,
    regflg: null,
    consultData: null,
    params: null,
    csldivitems: [],
    orglukes: null,
  },
  webOrgRsvOptionList: {
    ctrptoptfromconsult: null,
    ctrmng: null,
    realage: null,
    age: null,
    newctrptcd: null,
    opt: [],
    showall: null,
    ctrpt: null,
    params: null,
    message: [],
    loadFlg: true,
  },
  webOrgRsvMain: {
    visible: false,
    params: null,
  },
  webOrgRsvPersonalDetailGuide: {
    visible: false,
    message: [],
  },
  // web団体予約情報検索
  webOrgRsvSearch: {
    message: [],
    // 検索条件
    conditions: {
      strcsldate: '',
      endcsldate: '',
      key: '',
      stropdate: '',
      endopdate: '',
      opmode: '',
      orgcd1: '',
      orgcd2: '',
      regflg: '',
      moushikbn: '',
      order: '',
      page: 1,
      limit: 20,
    },
    totalCount: null,
    data: [],
    orgname: null,
  },
};

// 文字列のバイト数を求める
const getByte = (stream) => {
  let count = 0;
  if (stream === '' || stream === null || stream === undefined) {
    return null;
  }
  // １文字ずつエンコードしつつバイト数を求める
  for (let i = 0; i < stream.length; i += 1) {
    const token = escape(stream.charAt(i));
    if (token.length < 4) {
      count += 1;
    } else {
      count += 2;
    }
  }
  return count;
};

// reducerの作成
export default handleActions({

  // web団体予約情報画面の初期化
  [initializeWebOrgRsv]: (state) => {
    const { webOrgRsvList } = initialState;
    const visible = true;
    return { ...state, webOrgRsvList, visible };
  },
  // web団体予約情報ガイドを開くアクション時の処理
  [openWebOrgRsvMainGuide]: (state, action) => {
    // 可視状態をtrueにする
    const visible = true;
    const { webOrgRsvMain, webOrgRsvOptionList } = state;
    const { params } = action.payload;
    return { ...state, webOrgRsvOptionList: { ...webOrgRsvOptionList, showall: null }, webOrgRsvMain: { ...webOrgRsvMain, params, visible } };
  },
  // web団体予約情報ガイド閉じるアクション時の処理
  [closeWebOrgRsvMainGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)

    const { webOrgRsvMain } = initialState;
    return { ...state, webOrgRsvMain };
  },
  // web団体予約情報選択受診区分成功時の処理
  [onChangeCsldivSuccess]: (state, action) => {
    const { webOrgRsvOptionList, webOrgRsvList } = state;
    const { ctrptoptfromconsult, ctrmng, realage, age, newctrptcd, params, ctrpt, frameUsedData } = action.payload;
    // 読み込んだオプション検査情報の検索
    let prevoptcd = '';
    let optgrpseq = -1;
    const opt = [];
    for (let i = 0; ctrptoptfromconsult && i < ctrptoptfromconsult.length; i += 1) {
      // 直前レコードとオプションコードが異なる場合
      if (ctrptoptfromconsult[i].optcd !== prevoptcd && (ctrptoptfromconsult[i].hidersv === null || params.showall === 1)) {
        optgrpseq += 1;
        // まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
        ctrptoptfromconsult[i].elementtype = ctrptoptfromconsult[i].branchcount;
        ctrptoptfromconsult[i].elementname = `opt[${optgrpseq}]`;
      } else {
        ctrptoptfromconsult[i].elementtype = ctrptoptfromconsult[i].branchcount;
        ctrptoptfromconsult[i].elementname = `opt[${optgrpseq}]`;
      }
      ctrptoptfromconsult[i].checkedValue = `${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`;
      if (ctrptoptfromconsult[i].consults === 1 && (ctrptoptfromconsult[i].hidersv === null || params.showall === 1)) {
        opt.push(`${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`);
        ctrptoptfromconsult[i].checkValue = `${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`;
      } else if (ctrptoptfromconsult[i].optcd !== prevoptcd
        && (ctrptoptfromconsult[i].hidersv === null || params.showall === 1)
        && ctrptoptfromconsult[i].branchcount === 1) {
        ctrptoptfromconsult[i].checkValue = null;
        opt.push(null);
      } else {
        ctrptoptfromconsult[i].checkValue = null;
      }
      prevoptcd = ctrptoptfromconsult[i].optcd;
    }
    const { showall } = params;
    return {
      ...state,
      webOrgRsvOptionList: { ...webOrgRsvOptionList, ctrptoptfromconsult, ctrmng, realage, age, newctrptcd, opt, showall, ctrpt, params, message: [] },
      webOrgRsvList: { ...webOrgRsvList, frameUsedData },
    };
  },
  // web団体予約情報選択受診区分失敗時の処理
  [onChangeCsldivFailure]: (state, action) => {
    const { webOrgRsvOptionList } = state;
    const { message, realage, age } = action.payload;
    return { ...state, webOrgRsvOptionList: { ...webOrgRsvOptionList, message, realage, age } };
  },
  // web団体予約情報保存失敗時の処理
  [registFailure]: (state, action) => {
    const { webOrgRsvList } = state;
    const { message } = action.payload;
    return { ...state, webOrgRsvList: { ...webOrgRsvList, message } };
  },
  // web団体予約情報保存成功時の処理
  [registSuccess]: (state, action) => {
    const { webOrgRsvList, webOrgRsvOptionList } = state;
    const { frameUsedData, webOrgRsvData, consultDetail, consultO, personLukes, params, consultData, message, age, realage, ctrptoptfromconsult, ctrmng, newctrptcd, ctrpt } = action.payload;
    const { allcsldiv, orglukes } = action.payload;
    const csldivitems = [];
    for (let i = 0; i < allcsldiv.length; i += 1) {
      csldivitems.push({ name: allcsldiv[i].csldivname, value: allcsldiv[i].csldivcd });
    }
    // 読み込んだオプション検査情報の検索
    let prevoptcd = '';
    let optgrpseq = -1;
    const opt = [];
    for (let i = 0; ctrptoptfromconsult && i < ctrptoptfromconsult.length; i += 1) {
      // 直前レコードとオプションコードが異なる場合
      if (ctrptoptfromconsult[i].optcd !== prevoptcd) {
        optgrpseq += 1;
        // まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
        ctrptoptfromconsult[i].elementtype = ctrptoptfromconsult[i].branchcount;
        ctrptoptfromconsult[i].elementname = `opt[${optgrpseq}]`;
      } else {
        ctrptoptfromconsult[i].elementtype = ctrptoptfromconsult[i].branchcount;
        ctrptoptfromconsult[i].elementname = `opt[${optgrpseq}]`;
      }
      ctrptoptfromconsult[i].checkedValue = `${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`;
      prevoptcd = ctrptoptfromconsult[i].optcd;
      if (ctrptoptfromconsult[i].consults === 1) {
        opt.push(`${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`);
        ctrptoptfromconsult[i].checkValue = `${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`;
      } else {
        ctrptoptfromconsult[i].checkValue = null;
      }
    }

    const csldate = moment(params.csldate).format('YYYY/MM/DD');
    const { regflg } = params;
    return {
      ...state,
      webOrgRsvList: {
        ...webOrgRsvList, frameUsedData, webOrgRsvData, consultDetail, consultO, personLukes, csldate, regflg, consultData, params, csldivitems, message: ['保存が完了しました。'], orglukes,
      },
      webOrgRsvOptionList: {
        ...webOrgRsvOptionList, message, realage, age, ctrptoptfromconsult, ctrmng, newctrptcd, opt, ctrpt, params,
      },
    };
  },
  // ガイドを開くアクション時の処理
  [webOrgRsvMainLoadSuccess]: (state, action) => {
    const { webOrgRsvList, webOrgRsvOptionList } = state;
    const { frameUsedData, webOrgRsvData, consultDetail, consultO, personLukes, params, consultData, message, age, realage, ctrptoptfromconsult, ctrmng, newctrptcd, ctrpt } = action.payload;
    const { allcsldiv, orglukes } = action.payload;
    const csldivitems = [];
    for (let i = 0; i < allcsldiv.length; i += 1) {
      csldivitems.push({ name: allcsldiv[i].csldivname, value: allcsldiv[i].csldivcd });
    }
    // 読み込んだオプション検査情報の検索
    let prevoptcd = '';
    let optgrpseq = -1;
    const opt = [];
    for (let i = 0; ctrptoptfromconsult && i < ctrptoptfromconsult.length; i += 1) {
      // 直前レコードとオプションコードが異なる場合
      if (ctrptoptfromconsult[i].optcd !== prevoptcd) {
        optgrpseq += 1;
        // まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
        ctrptoptfromconsult[i].elementtype = ctrptoptfromconsult[i].branchcount;
        ctrptoptfromconsult[i].elementname = `opt[${optgrpseq}]`;
      } else {
        ctrptoptfromconsult[i].elementtype = ctrptoptfromconsult[i].branchcount;
        ctrptoptfromconsult[i].elementname = `opt[${optgrpseq}]`;
      }
      ctrptoptfromconsult[i].checkedValue = `${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`;
      prevoptcd = ctrptoptfromconsult[i].optcd;
      if (ctrptoptfromconsult[i].consults === 1) {
        opt.push(`${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`);
        ctrptoptfromconsult[i].checkValue = `${ctrptoptfromconsult[i].optcd},${ctrptoptfromconsult[i].optbranchno}`;
      } else {
        ctrptoptfromconsult[i].checkValue = null;
      }
    }

    const csldate = moment(params.csldate).format('YYYY/MM/DD');
    const { regflg } = params;
    return {
      ...state,
      webOrgRsvList: {
        ...webOrgRsvList, frameUsedData, webOrgRsvData, consultDetail, consultO, personLukes, csldate, regflg, consultData, params, csldivitems, message: [], orglukes,
      },
      webOrgRsvOptionList: {
        ...webOrgRsvOptionList, message, realage, age, ctrptoptfromconsult, ctrmng, newctrptcd, opt, ctrpt, params,
      },
    };
  },
  // 受診付属情報ガイドを開くアクション時の処理
  [openWebOrgRsvPersonalDetailGuide]: (state) => {
    // 可視状態をtrueにする
    const visible = true;
    const { webOrgRsvPersonalDetailGuide } = state;
    return { ...state, webOrgRsvPersonalDetailGuide: { ...webOrgRsvPersonalDetailGuide, visible } };
  },
  // 受診付属情報ガイド閉じるアクション時の処理
  [closeWebOrgRsvPersonalDetailGuide]: (state) => {
    // stateを初期状態に戻す
    // (これに伴い可視状態もfalseとなり、画面がクローズしたように見える)
    const { webOrgRsvPersonalDetailGuide } = initialState;
    const { webOrgRsvList } = state;
    return { ...state, webOrgRsvPersonalDetailGuide, webOrgRsvList };
  },
  // 受診付属情報ガイドを保存の処理
  [perDetailSave]: (state, action) => {
    const { webOrgRsvList, webOrgRsvPersonalDetailGuide } = state;
    const message = [];
    const frameUsedData = action.payload;
    // ボランティア名の文字列長チェック
    if (getByte(frameUsedData.volunteername) > 50) {
      message.push('ボランティア名の入力内容が長すぎます。');
    }

    // 保険証記号の文字列長チェック
    if (getByte(frameUsedData.isrsign) > 16) {
      message.push('保険証記号の入力内容が長すぎます。');
    }

    // 保険証番号の文字列長チェック
    if (getByte(frameUsedData.isrno) > 16) {
      message.push('保険証番号の入力内容が長すぎます。');
    }

    // 保険者番号の文字列長チェック
    if (getByte(frameUsedData.isrmanno) > 16) {
      message.push('保険者番号の入力内容が長すぎます。');
    }

    // 社員番号の文字列長チェック
    if (getByte(frameUsedData.empno) > 12) {
      message.push('社員番号の入力内容が長すぎます。');
    }

    // メッセージ存在時は編集
    if (message.length > 0) {
      return { ...state, webOrgRsvPersonalDetailGuide: { ...webOrgRsvPersonalDetailGuide, message } };
    }
    const visible = false;

    return { ...state, webOrgRsvList: { ...webOrgRsvList, frameUsedData }, webOrgRsvPersonalDetailGuide: { ...webOrgRsvPersonalDetailGuide, visible } };
  },

  // web団体予約情報検索一覧初期化処理
  [initializeWebOrgRsvList]: (state) => {
    const { webOrgRsvSearch } = initialState;
    return { ...state, webOrgRsvSearch };
  },

  // web団体予約情報検索一覧取得開始時の処理
  [getWebOrgRsvListRequest]: (state, action) => {
    const { webOrgRsvSearch } = state;
    // 検索条件を更新する
    const conditions = action.payload;

    return { ...state, webOrgRsvSearch: { ...webOrgRsvSearch, conditions } };
  },

  // web団体予約情報検索一覧取得成功時の処理
  [getWebOrgRsvListSuccess]: (state, action) => {
    const { webOrgRsvSearch } = state;

    // 総件数とデータとを更新する
    const { totalCount, data } = action.payload;

    const message = [];
    if (totalCount === 0) {
      message.push('検索条件を満たす受診情報は存在しません。');
    }

    return { ...state, webOrgRsvSearch: { ...webOrgRsvSearch, totalCount, data, message } };
  },

  [setOrgName]: (state, action) => {
    const { webOrgRsvSearch } = state;

    const { orgname } = action.payload;

    return { ...state, webOrgRsvSearch: { ...webOrgRsvSearch, orgname } };
  },
  [changeColor]: (state, action) => {
    const { webOrgRsvOptionList } = state;

    const { ctrptoptfromconsult } = action.payload;

    return { ...state, webOrgRsvOptionList: { ...webOrgRsvOptionList, ctrptoptfromconsult } };
  },
}, initialState);
