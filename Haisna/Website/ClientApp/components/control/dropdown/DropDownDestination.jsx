import React from 'react';

import DropDown from './DropDown';

// 宛先選択肢
const items = [
  { value: '1', name: '住所（自宅）' },
  { value: '2', name: '住所（勤務先）' },
  { value: '3', name: '住所（その他）' },
  { value: '', name: 'なし' },
];

export default (props) => <DropDown {...props} items={items} />;
