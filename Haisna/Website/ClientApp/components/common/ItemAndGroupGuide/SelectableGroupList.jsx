// @flow

import * as React from 'react';

// タイプのインポート
import { type SelectableGroup } from '../../../types/common/itemAndGroupGuide';

// コンポーネントのインポート
import LabeledCheckBox from '../../control/CheckBox/LabeledCheckBox';

// cssのインポート
import styles from './SelectableItemList.css';

// Propsの定義
type Props = {
  data: Array<SelectableGroup>,
  onChange?: Function,
}

// コンポーネントの定義
const SelectableGroupList = ({ data, onChange }: Props) => (
  data && (
    data.map((rec, index) => (
      <LabeledCheckBox
        key={rec.grpCd}
        className={styles.item}
        label={`${rec.grpCd}:${rec.grpName}`}
        checked={rec.checked}
        onChange={(event, checked) => onChange && onChange({ ...rec, checked }, index)}
      />
    ))
  )
);

export default SelectableGroupList;
