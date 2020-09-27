// @flow
import * as React from 'react';

import styles from './NaviDailyListButton.css';

const Icon = () => (
  <svg x="0px" y="0px" width="24px" height="24px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <g>
      <path
        fill="#FFFFFF"
        d="M82.12,98.741c-0.762,0.873-1.862,1.373-3.018,1.373h-62.94L0.097,118.333h77.17l50.627-57.364h-12.43
        L82.12,98.741z"
      />
      <path
        fill="#FFFFFF"
        d="M82.12,72.427c-0.762,0.859-1.862,1.367-3.018,1.367h-62.92L0.098,92.02h77.17l50.634-57.373h-12.434
          L82.12,72.427z"
      />
      <polygon
        fill="#FFFFFF"
        points="0.099,65.691 77.27,65.691 127.902,8.333 50.723,8.333"
      />
    </g>
  </svg>
);

// コンポーネントの定義
const NaviDailyListButton = () => (
  <button className={styles.button}>
    <Icon />
  </button>
);

export default NaviDailyListButton;
