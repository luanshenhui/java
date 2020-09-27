// @flow

import { call, takeEvery, put, select } from 'redux-saga/effects';

// タイプのインポート
import {
  type SelectableItemClass,
  type SelectableRequestItem,
  type SelectableItem,
  type SelectableGroup,
} from '../../types/common/itemAndGroupGuide';

// API Serviceのインポート
import groupService, { type Group } from '../../services/preference/groupService';
import itemService, { type ItemClass, type RequestItem, type Item } from '../../services/preference/itemService';

// Action, Action Creatorのインポート
import { actionTypes, actions, type ItemAndGroupGuideState } from '../../modules/common/itemAndGroupGuideModule';

// ガイドオープン時に呼び出される関数
function* runOpen(action) {
  try {
    // 検査分類一覧取得処理実行
    const data: Array<ItemClass> = yield call(itemService.getItemClassList, action.payload);
    // State用の形式に変換
    const itemClasses: Array<SelectableItemClass> = data.map((rec) => ({
      classCd: rec.classcd,
      className: rec.classname,
    }));
    // ガイドオープン処理成功Actionを発行
    yield put(actions.itemAndGroupGuideOpenSuccess({ itemClasses }));
  } catch (error) {
    // 例外時はガイドオープン処理失敗Actionを発行
    yield put(actions.itemAndGroupGuideOpenFailure(error.response));
  }
}

// 条件選択時に呼び出される関数
function* runSelectCondition() {
  // 初期処理
  let selectableRequestItems: Array<SelectableRequestItem> = [];
  let selectableItems: Array<SelectableItem> = [];
  let selectableGroups: Array<SelectableGroup> = [];

  // stateの依頼／結果モード、テーブル選択区分、検査分類コード、選択済み項目を参照
  const itemAndGroupGuide: ItemAndGroupGuideState = yield select((state) => state.app.common.itemAndGroupGuide);
  const { itemMode, tableDiv, classCd, selectedValues } = itemAndGroupGuide;

  try {
    for (;;) {
      // テーブル選択区分が検査項目の場合
      if (tableDiv === 1) {
        // 依頼項目の場合
        if (itemMode === 1) {
          // 指定検査分類の依頼項目一覧を取得
          const data: Array<RequestItem> = yield call(itemService.getRequestItemList, { classCd });
          // 選択依頼項目の形式に変換
          selectableRequestItems = data.map((rec) => ({
            itemCd: rec.itemcd,
            itemName: rec.requestname,
            checked: selectedValues.findIndex((selectedValue) => (
              ((selectedValue.itemCd === rec.itemcd) && (selectedValue.suffix === undefined))
            )) >= 0,
          }));
          break;
        }

        // 検査項目の場合
        if (itemMode === 2) {
          // 指定検査分類の検査項目一覧を取得
          const data: Array<Item> = yield call(itemService.getItemList, { classCd });
          // 選択検査項目の形式に変換
          selectableItems = data.map((rec) => ({
            itemCd: rec.itemcd,
            suffix: rec.suffix,
            itemName: rec.itemname,
            checked: selectedValues.findIndex((selectedValue) => (
              ((selectedValue.itemCd === rec.itemcd) && (selectedValue.suffix === rec.suffix))
            )) >= 0,
          }));
          break;
        }

        break;
      }

      // テーブル選択区分がグループの場合
      if (tableDiv === 2) {
        // 指定条件のグループ一覧を取得
        const data: Array<Group> = yield call(groupService.getGroupListByDivision, itemMode, { classCd, noDataFound: 1 });
        // 選択グループの形式に変換
        selectableGroups = data.map((rec) => ({
          grpCd: rec.grpcd,
          grpName: rec.grpname,
          checked: selectedValues.findIndex((selectedValue) => (selectedValue.grpCd === rec.grpcd)) >= 0,
        }));
        break;
      }

      break;
    }

    // 条件選択成功Actionを発行
    yield put(actions.itemAndGroupGuideSelectConditionSuccess({
      selectableRequestItems,
      selectableItems,
      selectableGroups,
    }));
  } catch (error) {
    // 例外発生時は条件選択処理失敗Actionを実行
    yield put(actions.itemAndGroupGuideSelectConditionFailure(error.response));
  }
}

// 確定時に呼び出される関数
function* runConfirm() {
  // stateの選択済み項目、確定時イベントを参照
  const itemAndGroupGuide: ItemAndGroupGuideState = yield select((state) => state.app.common.itemAndGroupGuide);
  const { onConfirm, selectedValues } = itemAndGroupGuide;
  // 確定時イベントを呼び出す
  if (onConfirm) {
    onConfirm(selectedValues);
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const itemAndGroupGuideSagas = [
  takeEvery(actionTypes.ITEM_AND_GROUP_GUIDE_OPEN_REQUEST, runOpen),
  takeEvery(actionTypes.ITEM_AND_GROUP_GUIDE_SELECT_CONDITION_REQUEST, runSelectCondition),
  takeEvery(actionTypes.ITEM_AND_GROUP_GUIDE_CONFIRM, runConfirm),
];

export default itemAndGroupGuideSagas;
