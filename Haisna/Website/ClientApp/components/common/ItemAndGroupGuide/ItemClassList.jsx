// @flow

import * as React from 'react';

// タイプのインポート
import { type SelectableItemClass } from '../../../types/common/itemAndGroupGuide';

// コンポーネントのインポート
import ListItem from '../../control/ListItem/ListItem';

// cssのインポート
import styles from './ItemClassList.css';

// Propsの定義
type Props = {
  itemClasses: Array<SelectableItemClass>,
  classCd: ?string,
  onClick?: Function,
}

// コンポーネントの定義
const ItemClassList = ({ itemClasses, classCd, onClick }: Props) => (
  <div>
    <ListItem className={classCd === null ? styles.selected : undefined} onClick={() => onClick && onClick(null)}>すべて</ListItem>
    {itemClasses && itemClasses.map((rec) => (
      <ListItem key={rec.classCd} className={rec.classCd === classCd ? styles.selected : undefined} onClick={() => onClick && onClick(rec.classCd)}>{rec.className}</ListItem>
    ))}
  </div>
);

// defaultPropsの定義
ItemClassList.defaultProps = {
  onClick: undefined,
};

export default ItemClassList;
