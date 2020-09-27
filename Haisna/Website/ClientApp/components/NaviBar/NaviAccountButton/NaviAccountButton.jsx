// @flow
import * as React from 'react';

import styles from './NaviAccountButton.css';

const Icon = () => (
  <svg x="0px" y="0px" width="24px" height="24px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <g>
      <path
        fill="#FFFFFF"
        d="M118.999,8.997H9.001v110h17.588V83.645L44.01,70.257c5.399,3.38,11.804,5.371,18.64,5.371
        c7.491,0,14.422-2.344,20.125-6.313l18.644,14.336v35.354h17.578L118.999,8.997L118.999,8.997z M62.65,65.102
        c-13.756,0-24.918-11.151-24.918-24.913c0-13.761,11.162-24.912,24.918-24.912c13.758,0,24.913,11.151,24.913,24.912
        C87.563,53.949,76.408,65.102,62.65,65.102z"
      />
    </g>
  </svg>
);

// コンポーネントの定義
const NaviAccountButton = () => (
  <button className={styles.button}>
    <Icon />
  </button>
);

export default NaviAccountButton;
