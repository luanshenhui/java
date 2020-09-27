// @flow

import * as React from 'react';

// タイプのインポート
import { type SelectableItem } from '../../../types/common/itemAndGroupGuide';

// コンポーネントのインポート
import LabeledCheckBox from '../../control/CheckBox/LabeledCheckBox';

// cssのインポート
import styles from './SelectableItemList.css';

// Propsの定義
type Props = {
  data: Array<SelectableItem>,
  onChange?: Function,
}

// コンポーネントの定義
const SelectableItemList = ({ data, onChange }: Props) => (
  data.map((rec, index) => (
    <LabeledCheckBox
      key={`${rec.itemCd}-${rec.suffix}`}
      className={styles.item}
      label={`${rec.itemCd}-${rec.suffix}:${rec.itemName}`}
      checked={rec.checked}
      onChange={(event, checked) => onChange && onChange({ ...rec, checked }, index)}
    />
  ))
);

export default SelectableItemList;
