// reduxエコシステムの1つであるredux-actionsを利用し、コードを簡便化する
import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  getGroupListRequest,
  getGroupListSuccess,
  getGroupListFailure,
  initializeGroup,
  getGroupRequest,
  getGroupSuccess,
  getGroupFailure,
  registerGroupRequest,
  registerGroupSuccess,
  registerGroupFailure,
  deleteGroupRequest,
  deleteGroupSuccess,
  deleteGroupFailure,
  selectGroupEditItem,
  getGroupGuideListRequest,
  getGroupGuideListSuccess,
  getGroupGuideListFailure,
  getGroupGuideItem,
  openGroupGuide,
  closeGroupGuide,
  getGroupParamRequest,
  getGroupParamSuccess,
  getGroupParamFailure,
  getItemsandresults,
  getGrpItemList,
  getRemoveGrpItem,
  getItemsandresultsSuccess,
  getItemsandresultsFailure,
  getGrpIItemListSuccess,
  getGrpIItemListFailure,
  getResetGrpItem,
  getInitCondtion,
} = createActions(
  // 一覧取得
  'GET_GROUP_LIST_REQUEST',
  'GET_GROUP_LIST_SUCCESS',
  'GET_GROUP_LIST_FAILURE',
  // 初期化
  'INITIALIZE_GROUP',
  // 取得
  'GET_GROUP_REQUEST',
  'GET_GROUP_SUCCESS',
  'GET_GROUP_FAILURE',
  // 登録
  'REGISTER_GROUP_REQUEST',
  'REGISTER_GROUP_SUCCESS',
  'REGISTER_GROUP_FAILURE',
  // 削除
  'DELETE_GROUP_REQUEST',
  'DELETE_GROUP_SUCCESS',
  'DELETE_GROUP_FAILURE',
  // グループ内検査項目選択
  'SELECT_GROUP_EDIT_ITEM',
  // ガイド
  'GET_GROUP_GUIDE_LIST_REQUEST',
  'GET_GROUP_GUIDE_LIST_SUCCESS',
  'GET_GROUP_GUIDE_LIST_FAILURE',
  'GET_GROUP_GUIDE_ITEM',
  'OPEN_GROUP_GUIDE',
  'CLOSE_GROUP_GUIDE',
  // グループパラメータ
  'GET_GROUP_PARAM_REQUEST',
  'GET_GROUP_PARAM_SUCCESS',
  'GET_GROUP_PARAM_FAILURE',
  // 検査結果を一括して入力
  'GET_ITEMSANDRESULTS',
  'GET_GRP_ITEM_LIST',
  'GET_REMOVE_GRP_ITEM',
  'GET_ITEMSANDRESULTS_SUCCESS',
  'GET_ITEMSANDRESULTS_FAILURE',
  'GET_GRP_I_ITEM_LIST_SUCCESS',
  'GET_GRP_I_ITEM_LIST_FAILURE',
  'GET_RESET_GRP_ITEM',
  'GET_INIT_CONDTION',
);

// 非同期アクション(今回の場合はグループ一覧読み込み)を作成するためには要求の開始、正常終了、失敗という3つの状態変更をreducerに通知する

// actionは以下のように記述しても同義
// (createActionをimportする必要あり)
// export const getGroupListRequest = createAction('GET_GROUP_LIST_REQUEST');
// export const getGroupListSuccess = createAction('GET_GROUP_LIST_SUCCESS');
// export const getGroupListFailure = createAction('GET_GROUP_LIST_FAILURE');

// (参考)
// https://redux-actions.js.org/docs/api/createAction.html

// stateの初期値
const initialState = {
  groupList: {
    conditions: {
      keyword: '',
      page: 1,
      limit: 20,
    },
    totalCount: 0,
    data: [],
    message: [],
  },
  groupEdit: {
    group: {},
    item: [],
    message: [],
    showItemGuide: false,
    selectedItems: {},
    username: '',
    itemclassmodellist: [],
  },
  groupGuide: {
    conditions: {
      classcd: '',
      page: 1,
      limit: 20,
    },
    totalcount: 0,
    data: [],
    message: [],
    selectedItem: undefined,
    searched: false,
    visible: false,
    itemclasses: [],
    onSelected: undefined,
    grpdiv: null,
  },
  itemList: {
    itemData: {},
    message: [],
    itemLoad: {},
    zt: '1',
    allResultClear: [null],
    render: false,
    step2grpcd: '',
  },
};

// reducerの作成
export default handleActions({
  [getGroupListRequest]: (state, action) => {
    // 要求開始時は検索条件のみを変更する
    const { groupList } = state;
    const conditions = action.payload;
    return { ...state, groupList: { ...groupList, conditions } };
  },
  [getGroupListSuccess]: (state, action) => {
    // 成功時は総件数とデータを変更する
    const { groupList } = state;
    const { totalCount, data } = action.payload;
    return { ...state, groupList: { ...groupList, totalCount, data } };
  },
  [getGroupListFailure]: (state, action) => {
    // グループ一覧の現state値を取得
    const { groupList } = state;
    // グループ一覧の総レコード数及びデータの初期値を取得
    const { groupList: { totalCount, data } } = initialState;
    // payloadのdataプロパティが持つmessageプロパティにメッセージが含まれているのでその内容を取得
    const { message } = action.payload.data;
    // グループ一覧の総レコード数及びデータを初期化し、かつエラーメッセージを設定してstateを更新する
    return { ...state, groupList: { ...groupList, totalCount, data, message } };
  },
  [initializeGroup]: (state) => {
    // 初期化
    const { groupEdit } = state;
    const { group, item, message } = initialState.groupEdit;
    return { ...state, groupEdit: { ...groupEdit, group, item, message } };
  },
  [getGroupSuccess]: (state, action) => {
    // グループ取得成功時は取得したデータを設定する
    const { groupEdit } = state;
    const { message } = initialState.groupEdit;
    return { ...state, groupEdit: { ...groupEdit, ...action.payload, message } };
  },
  [getGroupFailure]: (state, action) => {
    // グループ登録の現state値を取得
    const { groupEdit } = state;
    // payloadのdataプロパティが持つerrorプロパティにメッセージが含まれているのでその内容を取得
    const { message } = action.payload.data;
    // stateのメッセージ値を更新する
    return { ...state, groupEdit: { ...groupEdit, message } };
  },
  [registerGroupSuccess]: (state) => {
    // 登録成功時はメッセージを設定する
    const { groupEdit } = state;
    const message = ['保存が完了しました。'];
    return { ...state, groupEdit: { ...groupEdit, message } };
  },
  [registerGroupFailure]: (state, action) => {
    // グループ登録の現state値を取得
    const { groupEdit } = state;
    // 応答ステータス、メッセージの取得
    const { status, data } = action.payload;
    const { errors } = data;
    let { message } = data;
    // 致命的エラーメッセージが発生していない場合
    if (!message) {
      // statusが409(Conflict)であれば定型メッセージを、さもなくばerrorsに格納されているバリデーションエラーメッセージを取得
      message = status === 409 ? '指定されたグループコードはすでに存在します。' : errors;
    }
    return { ...state, groupEdit: { ...groupEdit, message } };
  },
  [deleteGroupSuccess]: (state) => {
    // グループの初期値を取得
    const { groupEdit } = initialState;
    // 削除成功時はメッセージを設定する
    const message = ['削除が完了しました。'];
    // stateのグループを初期値でクリアし、かつメッセージを設定
    return { ...state, groupEdit: { ...groupEdit, message } };
  },
  [deleteGroupFailure]: (state, action) => {
    // 失敗時はメッセージを設定する
    const { groupEdit } = state;
    const { message } = action.payload.data;
    return { ...state, groupEdit: { ...groupEdit, message } };
  },
  [selectGroupEditItem]: (state, action) => {
    // グループ内検査項目選択時の処理
    const { groupEdit } = state;
    const { item } = groupEdit;
    const index = item.findIndex((element) => (
      (element.itemcd === action.payload.itemcd) && (element.suffix === action.payload.suffix)
    ));
    if (index < 0) {
      return state;
    }
    item[index].selected = !item[index].selected;
    return { ...state, groupEdit: { ...groupEdit, item } };
  },
  [getGroupGuideListRequest]: (state, action) => {
    // 要求開始時は検索条件のみを変更する
    const conditions = { ...initialState.groupGuide.conditions, ...action.payload };
    return { ...state, groupGuide: { ...state.groupGuide, conditions } };
  },
  [getGroupGuideListSuccess]: (state, action) => {
    // グループガイド一覧取得処理
    const { data, totalcount } = action.payload;
    // メッセージは初期化する
    const { message } = initialState.groupGuide;
    // 検索済みフラグを立てる
    const searched = true;
    const groupGuide = { ...state.groupGuide, data, totalcount, message, searched };
    return { ...state, groupGuide };
  },
  [getGroupGuideItem]: (state, action) => {
    // 選択された要素をセット
    const selectedItem = action.payload;
    const groupGuide = { ...state.groupGuide, selectedItem };
    return { ...state, groupGuide };
  },
  [openGroupGuide]: (state, action) => {
    // グループガイドを開く
    const visible = true;
    const { onSelected, grpdiv } = action.payload;
    return { ...state, groupGuide: { ...state.groupGuide, visible, onSelected, grpdiv } };
  },
  [closeGroupGuide]: (state) => {
    // グループガイドを閉じる
    const { groupGuide } = initialState;
    return { ...state, groupGuide };
  },

  [getItemsandresultsSuccess]: (state, action) => {
    // 成功時は総件数とデータを変更する
    const { itemList } = state;
    const { data, render } = action.payload;
    const itemData = {};
    itemData.data = data;
    const zt = '2';
    let { allResultClear } = action.payload;
    if (allResultClear && allResultClear === 1) {
      allResultClear = [1];
    } else {
      allResultClear = [null];
    }
    return { ...state, itemList: { ...itemList, itemData, zt, render, allResultClear } };
  },

  [getInitCondtion]: (state, action) => {
    // 成功時は総件数とデータを変更する
    const { itemLoad } = action.payload.data;
    if (itemLoad.data && itemLoad.data.length > 0) {
      for (let i = 0; i < itemLoad.data.length; i += 1) {
        if (itemLoad.data[i].defresult) {
          itemLoad.data[i].defresult = null;
        }
        itemLoad.data[i].shortstc = null;
      }
    }
    const { itemList } = state;
    return { ...state, itemList: { ...itemList, itemLoad } };
  },

  [getItemsandresultsFailure]: (state, action) => {
    // 結果初期値一覧の現state値を取得
    const { itemList } = state;
    // payloadのdataプロパティが持つmessageプロパティにメッセージが含まれているのでその内容を取得
    const { message } = action.payload.data;
    // 結果初期値一覧の総レコード数及びデータを初期化し、かつエラーメッセージを設定してstateを更新する
    return { ...state, itemList: { ...itemList, message } };
  },

  [getResetGrpItem]: (state, action) => {
    const { itemList } = state;
    const { itemRestList, zt, index, stcCd, shortStc, render } = action.payload;
    const boo = !render;
    const itemMore = {};
    itemMore.data = [];
    itemMore.allResultClear = itemRestList.allResultClear;
    itemMore.grpcd = itemRestList.grpcd;
    if (itemRestList && itemRestList.data && itemRestList.data.length > 0) {
      const list = itemRestList.data.slice(0);
      itemMore.data = list;
      itemMore.data[index].defresult = stcCd;
      itemMore.data[index].shortstc = shortStc;
    }

    if (zt && zt === '1') {
      return { ...state, itemList: { ...itemList, itemLoad: itemMore, render: boo } };
    }
    return { ...state, itemList: { ...itemList, itemData: itemMore, render: boo } };
  },

  // step2の初期値
  [getRemoveGrpItem]: (state) => {
    const { itemList } = initialState;
    return { ...state, itemList };
  },

  [getGrpIItemListSuccess]: (state, action) => {
    // 成功時は総件数とデータを変更する
    const { itemList } = state;
    const itemLoad = action.payload;
    const { grpcd, render } = action.payload;
    for (let i = 0; i < itemLoad.data.length; i += 1) {
      if (!itemLoad.data[i].shortstc) {
        itemLoad.data[i].shortstc = null;
      }
    }
    let { allResultClear } = action.payload;
    const zt = '1';
    if (allResultClear && allResultClear === 1) {
      allResultClear = [1];
    } else {
      allResultClear = [null];
    }
    return { ...state, itemList: { ...itemList, itemLoad, zt, allResultClear, itemData: [], step2grpcd: grpcd, render } };
  },
  [getGrpIItemListFailure]: (state, action) => {
    // 結果初期値一覧の現state値を取得
    const { itemList } = state;
    const { grpcd } = action.payload;
    // payloadのdataプロパティが持つmessageプロパティにメッセージが含まれているのでその内容を取得
    const { message } = action.payload.data;
    // 結果初期値一覧の総レコード数及びデータを初期化し、かつエラーメッセージを設定してstateを更新する
    return { ...state, itemList: { ...itemList, message, itemData: [], step2grpcd: grpcd } };
  },
}, initialState);
