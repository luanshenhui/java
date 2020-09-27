/**
 * @file 年ドロップダウン
 */
import React from 'react';

import DropDown from './DropDown';

// 年選択肢
const items = Array.from({ length: 231 }, (_, i) => {
  const year = 1970 + i;
  return { name: year, value: year };
});

export default (props) => <DropDown {...props} items={items} />;
