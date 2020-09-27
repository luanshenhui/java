// @flow

import * as React from 'react';
import classNames from 'classnames';

// cssのインポート
import styles from './NaviMenuSeparator.css';

// Propsの定義
type Props = {
  className?: string,
};

// コンポーネントの定義
const NaviMenuSeparator = ({ className }: Props) => (
  <span className={classNames(styles.separator, className)} />
);

// defaultPropsの定義
NaviMenuSeparator.defaultProps = {
  className: undefined,
};

export default NaviMenuSeparator;
