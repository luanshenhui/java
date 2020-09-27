// @flow

import * as React from 'react';

// タイプのインポート
import { type SelectedValue } from '../../../types/common/itemAndGroupGuide';

// コンポーネントのインポート
import ListItem from '../../control/ListItem/ListItem';

// Propsの定義
type Props = {
  selectedValues: Array<SelectedValue>,
}

// コンポーネントの定義
const SelectedItemList = ({ selectedValues }: Props) => (
  selectedValues && (
    selectedValues.map((rec, index) => (
      <ListItem key={index.toString()}>{rec.itemName}</ListItem>
    ))
  )
);

export default SelectedItemList;
