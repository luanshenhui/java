// @flow

import { handleActions } from 'redux-actions';

// タイプのインポート
import {
  type ItemMode,
  type TableDiv,
  type SelectableItemClass,
  type SelectableRequestItem,
  type SelectableItem,
  type SelectableGroup,
  type SelectedValue,
  type OnConfirm,
} from '../../types/common/itemAndGroupGuide';

// Actionの定義
export const actionTypes = {
  ITEM_AND_GROUP_GUIDE_OPEN_REQUEST: 'ITEM_AND_GROUP_GUIDE_OPEN_REQUEST',
  ITEM_AND_GROUP_GUIDE_OPEN_SUCCESS: 'ITEM_AND_GROUP_GUIDE_OPEN_SUCCESS',
  ITEM_AND_GROUP_GUIDE_OPEN_FAILURE: 'ITEM_AND_GROUP_GUIDE_OPEN_FAILURE',
  ITEM_AND_GROUP_GUIDE_CLOSE: 'ITEM_AND_GROUP_GUIDE_CLOSE',
  ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_REQUEST: 'ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_REQUEST',
  ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_SUCCESS: 'ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_SUCCESS',
  ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_FAILURE: 'ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_FAILURE',
  ITEM_AND_GROUP_GUIDE_SELECT_REQUEST_ITEM: 'ITEM_AND_GROUP_GUIDE_SELECT_REQUEST_ITEM',
  ITEM_AND_GROUP_GUIDE_SELECT_ITEM: 'ITEM_AND_GROUP_GUIDE_SELECT_ITEM',
  ITEM_AND_GROUP_GUIDE_SELECT_GROUP: 'ITEM_AND_GROUP_GUIDE_SELECT_GROUP',
  ITEM_AND_GROUP_GUIDE_CONFIRM: 'ITEM_AND_GROUP_GUIDE_CONFIRM',
};

// Action Creatorの定義
export const actions = {
  itemAndGroupGuideOpenRequest: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_OPEN_REQUEST,
    payload,
    meta,
  }),
  itemAndGroupGuideOpenSuccess: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_OPEN_SUCCESS,
    payload,
    meta,
  }),
  itemAndGroupGuideOpenFailure: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_OPEN_FAILURE,
    payload,
    meta,
  }),
  itemAndGroupGuideClose: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_CLOSE,
    payload,
    meta,
  }),
  itemAndGroupGuideSelectConditionRequest: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_REQUEST,
    payload,
    meta,
  }),
  itemAndGroupGuideSelectConditionSuccess: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_SUCCESS,
    payload,
    meta,
  }),
  itemAndGroupGuideSelectConditionFailure: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_FAILURE,
    payload,
    meta,
  }),
  itemAndGroupGuideSelectRequestItem: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_REQUEST_ITEM,
    payload,
    meta,
  }),
  itemAndGroupGuideSelectItem: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_ITEM,
    payload,
    meta,
  }),
  itemAndGroupGuideSelectGroup: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_GROUP,
    payload,
    meta,
  }),
  itemAndGroupGuideConfirm: (payload: Object = {}, meta: Object = {}) => ({
    type: actionTypes.ITEM_AND_GROUP_GUIDE_CONFIRM,
    payload,
    meta,
  }),
};

// stateのタイプ定義
export type ItemAndGroupGuideState = {
  // 依頼／結果モード
  +itemMode: ItemMode,
  // 検査項目を表示するか
  +showItem: boolean,
  // グループを表示するか
  +showGroup: boolean,
  // ガイドが表示されているか
  +open: boolean,
  // ローディング中か
  +isLoading: boolean,
  // 現在の検査分類コード
  +classCd: ?string,
  // 検査分類リスト
  +itemClasses: Array<SelectableItemClass>,
  // テーブル選択区分
  +tableDiv: TableDiv,
  // 選択検査項目リスト
  +selectableRequestItems: Array<SelectableRequestItem>,
  // 選択検査項目リスト
  +selectableItems: Array<SelectableItem>,
  // 選択グループリスト
  +selectableGroups: Array<SelectableGroup>,
  // 選択済みリスト
  +selectedValues: Array<SelectedValue>,
  // 確定時イベント
  +onConfirm?: OnConfirm,
}

// stateの初期値
const initialState: ItemAndGroupGuideState = {
  itemMode: 1,
  showItem: true,
  showGroup: true,
  open: false,
  isLoading: false,
  classCd: null,
  itemClasses: [],
  tableDiv: 1,
  selectableRequestItems: [],
  selectableItems: [],
  selectableGroups: [],
  selectedValues: [],
};

// reducerの作成
export default handleActions({
  // ガイドオープン処理要求
  ITEM_AND_GROUP_GUIDE_OPEN_REQUEST: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        itemMode: ItemMode,
        showGroup: boolean,
        showItem: boolean,
        onConfirm: OnConfirm,
      },
    },
  ) => ({
    ...initialState,
    selectedValues: [],
    ...action.payload,
    open: true,
    isLoading: true,
  }),
  // ガイドオープン処理成功
  ITEM_AND_GROUP_GUIDE_OPEN_SUCCESS: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        itemClasses: Array<SelectableItemClass>,
      },
    },
  ) => ({
    ...state,
    ...action.payload,
    isLoading: false,
  }),
  // ガイドオープン処理失敗
  ITEM_AND_GROUP_GUIDE_OPEN_FAILURE: (state: ItemAndGroupGuideState) => ({
    ...state,
    isLoading: false,
  }),
  // ガイドクローズ
  ITEM_AND_GROUP_GUIDE_CLOSE: (state: ItemAndGroupGuideState) => ({
    ...state,
    open: false,
  }),
  // 条件(検査分類またはテーブル選択区分)選択処理要求
  ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_REQUEST: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        classCd?: string,
        tableDiv?: TableDiv,
      },
    },
  ) => ({
    ...state,
    ...action.payload,
    isLoading: true,
  }),
  // 条件選択処理成功
  ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_SUCCESS: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        selectableRequestItems: Array<SelectableRequestItem>,
        selectableItems: Array<SelectableItem>,
        selectableGroups: Array<SelectableGroup>,
      },
    },
  ) => ({
    ...state,
    ...action.payload,
    isLoading: false,
  }),
  // 条件選択処理失敗
  ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_FAILURE: (state: ItemAndGroupGuideState) => ({
    ...state,
    isLoading: false,
  }),
  // 依頼項目選択
  ITEM_AND_GROUP_GUIDE_SELECT_REQUEST_ITEM: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        selectedValue: SelectableRequestItem,
        selectedIndex: number,
      },
    },
  ) => {
    // 選択要素とそのインデックスとを取得
    const { selectedValue, selectedIndex } = action.payload;
    // Stateの選択グループ、選択済み項目を取得
    const { selectableRequestItems, selectedValues } = state;

    // Stateの同一インデックス要素を置換
    selectableRequestItems.splice(selectedIndex, 1, selectedValue);

    // 選択済み項目に同一コードの要素が存在するかを検索し、そのインデックスを得る
    const foundIndex = selectedValues.findIndex((rec) => (
      ((rec.itemCd === selectedValue.itemCd) && (rec.suffix === undefined))
    ));

    // 選択済み項目に存在せず、かつ選択された場合は末尾に追加
    if (foundIndex < 0 && selectedValue.checked) {
      const { itemCd, itemName } = selectedValue;
      selectedValues.push({
        tableDiv: 1,
        itemCd,
        itemName,
      });
    }

    // 選択済み項目に存在し、かつ選択解除された場合は削除
    if (foundIndex >= 0 && !selectedValue.checked) {
      selectedValues.splice(foundIndex, 1);
    }

    // Stateを更新
    return {
      ...state,
      selectableRequestItems,
      selectedValues,
    };
  },
  // 検査項目選択
  ITEM_AND_GROUP_GUIDE_SELECT_ITEM: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        selectedValue: SelectableItem,
        selectedIndex: number,
      },
    },
  ) => {
    // 選択要素とそのインデックスとを取得
    const { selectedValue, selectedIndex } = action.payload;
    // Stateの選択グループ、選択済み項目を取得
    const { selectableItems, selectedValues } = state;

    // Stateの同一インデックス要素を置換
    selectableItems.splice(selectedIndex, 1, selectedValue);

    // 選択済み項目に同一コードの要素が存在するかを検索し、そのインデックスを得る
    const foundIndex = selectedValues.findIndex((rec) => (
      (rec.itemCd === selectedValue.itemCd) && (rec.suffix === selectedValue.suffix)
    ));

    // 選択済み項目に存在せず、かつ選択された場合は末尾に追加
    if (foundIndex < 0 && selectedValue.checked) {
      const { itemCd, suffix, itemName } = selectedValue;
      selectedValues.push({
        tableDiv: 1,
        itemCd,
        suffix,
        itemName,
      });
    }

    // 選択済み項目に存在し、かつ選択解除された場合は削除
    if (foundIndex >= 0 && !selectedValue.checked) {
      selectedValues.splice(foundIndex, 1);
    }

    // Stateを更新
    return {
      ...state,
      selectableItems,
      selectedValues,
    };
  },
  // グループ選択
  ITEM_AND_GROUP_GUIDE_SELECT_GROUP: (
    state: ItemAndGroupGuideState,
    action: {
      payload: {
        selectedValue: SelectableGroup,
        selectedIndex: number,
      },
    },
  ) => {
    // 選択要素とそのインデックスとを取得
    const { selectedValue, selectedIndex } = action.payload;
    // Stateの選択グループ、選択済み項目を取得
    const { selectableGroups, selectedValues } = state;

    // Stateの同一インデックス要素を置換
    selectableGroups.splice(selectedIndex, 1, selectedValue);

    // 選択済み項目に同一コードの要素が存在するかを検索し、そのインデックスを得る
    const foundIndex = selectedValues.findIndex((rec) => (rec.grpCd === selectedValue.grpCd));

    // 選択済み項目に存在せず、かつ選択された場合は末尾に追加
    if (foundIndex < 0 && selectedValue.checked) {
      const { grpCd, grpName } = selectedValue;
      selectedValues.push({
        tableDiv: 2,
        grpCd,
        itemName: grpName,
      });
    }

    // 選択済み項目に存在し、かつ選択解除された場合は削除
    if (foundIndex >= 0 && !selectedValue.checked) {
      selectedValues.splice(foundIndex, 1);
    }

    // Stateを更新
    return {
      ...state,
      selectableGroups,
      selectedValues,
    };
  },
  ITEM_AND_GROUP_GUIDE_CONFIRM: (state: ItemAndGroupGuideState) => ({
    ...state,
    open: false,
  }),
}, initialState);
