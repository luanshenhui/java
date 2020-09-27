// @flow

import * as React from 'react';
import MuiCircularProgress from '@material-ui/core/CircularProgress';

// cssのインポート
import styles from './CircularProgress.css';

// コンポーネントの定義
const CircularProgress = () => (
  <div className={styles.main}>
    <span className={styles.progress}><MuiCircularProgress /></span>
  </div>
);

export default CircularProgress;
