// @flow

// 依頼／結果モード(1:依頼項目、2:結果項目)
export type ItemMode = 1 | 2;

// テーブル選択区分(1:検査項目、2:グループ)
export type TableDiv = 1 | 2;

// 検査分類
export type SelectableItemClass = {
  classCd: string,
  className: string,
};

// 選択依頼項目
export type SelectableRequestItem = {
  itemCd: string,
  itemName: string,
  checked: boolean,
};

// 選択検査項目
export type SelectableItem = {
  itemCd: string,
  suffix: string,
  itemName: string,
  checked: boolean,
};

// 選択グループ
export type SelectableGroup = {
  grpCd: string,
  grpName: string,
  checked: boolean,
};

// 選択済み項目
export type SelectedValue = {
  tableDiv: TableDiv,
  grpCd?: string,
  itemCd?: string,
  suffix?: string,
  itemName: string,
};

export type OnConfirm = (data: Array<SelectedValue>) => void;
