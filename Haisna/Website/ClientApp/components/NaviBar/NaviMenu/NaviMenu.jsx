// @flow

import * as React from 'react';
import classNames from 'classnames';

// cssのインポート
import styles from './NaviMenu.css';

// Propsの定義
type Props = {
  className?: string,
  children: React.Node,
};

// コンポーネントの定義
const NaviMenu = ({ className, children }: Props) => (
  <div className={classNames(styles.menu, className)}>
    {children}
  </div>
);

// defaultPropsの定義
NaviMenu.defaultProps = {
  className: undefined,
};

export default NaviMenu;
