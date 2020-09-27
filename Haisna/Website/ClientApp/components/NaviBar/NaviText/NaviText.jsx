// @flow

import * as React from 'react';

// cssのインポート
import styles from './NaviText.css';

// コンポーネントの定義
const NaviText = (props: Object) => (
  <input {...props} className={styles.naviText} type="text" />
);

export default NaviText;
