// @flow

import * as React from 'react';
import classNames from 'classnames';

// cssのインポート
import styles from './ListBoxItems.css';

// Propsの定義
type Props = {
  className?: string,
  children: React.Node,
};

// コンポーネントの定義
const ListBoxItems = ({ className, children }: Props) => (
  <div className={classNames(styles.main, className)}>
    {children}
  </div>
);

// defaultPropsの定義
ListBoxItems.defaultProps = {
  className: undefined,
};

export default ListBoxItems;
