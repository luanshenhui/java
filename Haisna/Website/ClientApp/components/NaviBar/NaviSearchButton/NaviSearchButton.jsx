// @flow

import * as React from 'react';
import Search from '@material-ui/icons/Search';

// cssのインポート
import styles from './NaviSearchButton.css';

// コンポーネントの定義
const NaviSearchButton = () => (
  <button className={styles.button}>
    <span className={styles.flex}>
      <Search />
    </span>
  </button>
);

export default NaviSearchButton;
