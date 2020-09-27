import React from 'react';

import DropDown from './DropDown';

// レジ番号択肢
const items = [
  { value: 1, name: '1' },
  { value: 2, name: '2' },
  { value: 3, name: '3' },
];

export default (props) => <DropDown {...props} items={items} />;
