// @flow

import * as React from 'react';
import classNames from 'classnames';
import ButtonBase from '@material-ui/core/ButtonBase';

// cssのインポート
import styles from './ListItem.css';

// Propsの定義
type Props = {
  className?: string,
  children: React.Node,
  onClick?: Function,
};

// コンポーネントの定義
const ListItem = ({ className, children, onClick }: Props) => (
  <div className={styles.main}>
    <ButtonBase disableRipple className={styles.button} onClick={onClick}>
      <span className={classNames(styles.inner, className)}>{children}</span>
    </ButtonBase>
  </div>
);

// defaultPropsの定義
ListItem.defaultProps = {
  className: undefined,
  onClick: undefined,
};

export default ListItem;
