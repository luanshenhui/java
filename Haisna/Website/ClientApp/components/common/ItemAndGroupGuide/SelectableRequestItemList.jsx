// @flow

import * as React from 'react';

// タイプのインポート
import { type SelectableRequestItem } from '../../../types/common/itemAndGroupGuide';

// コンポーネントのインポート
import LabeledCheckBox from '../../control/CheckBox/LabeledCheckBox';

// cssのインポート
import styles from './SelectableItemList.css';

// Propsの定義
type Props = {
  data: Array<SelectableRequestItem>,
  onChange?: Function,
}

// コンポーネントの定義
const SelectableRequestItemList = ({ data, onChange }: Props) => (
  data.map((rec, index) => (
    <LabeledCheckBox
      key={rec.itemCd}
      className={styles.item}
      label={`${rec.itemCd}:${rec.itemName}`}
      checked={rec.checked}
      onChange={(event, checked) => onChange && onChange({ ...rec, checked }, index)}
    />
  ))
);

export default SelectableRequestItemList;
