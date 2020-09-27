import React from 'react';

import DropDown from './DropDown';

// 使用状態選択肢
const items = [
  { value: 0, name: '使用中' },
  { value: 1, name: '削除済み' },
];

export default (props) => <DropDown {...props} items={items} />;
