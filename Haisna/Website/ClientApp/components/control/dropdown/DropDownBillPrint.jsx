import React from 'react';

import DropDown from './DropDown';

// 請求書出力選択肢
const items = [
  { value: 1, name: '本人' },
  { value: 2, name: '家族' },
];

export default (props) => <DropDown {...props} items={items} />;
