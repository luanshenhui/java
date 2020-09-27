/**
 * @file 月ドロップダウン
 */
import React from 'react';

import DropDown from './DropDown';

// 月選択肢
const items = Array.from({ length: 12 }, (_, i) => {
  const month = 1 + i;
  return { name: month, value: month };
});

export default (props) => <DropDown {...props} items={items} />;
