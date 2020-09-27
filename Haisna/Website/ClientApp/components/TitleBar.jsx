// @flow

import * as React from 'react';
import classNames from 'classnames';

// コンポーネントのインポート
import BusinessIcon from './BusinessIcon/BusinessIcon';

// cssのインポート
import styles from './TitleBar.css';

// Propsの定義
type Props = {
  children: React.Node,
  className?: string,
  type: 'report' | 'maintenance',
};

// コンポーネントの定義
const TitleBar = ({ children, className, type }: Props) => (
  <div className={classNames(styles.titleBar, className)}>
    <BusinessIcon type={type} className={styles.icon} />
    <span className={styles.title}>{children}</span>
  </div>
);

// defaultPropsの定義
TitleBar.defaultProps = {
  className: undefined,
};

export default TitleBar;
