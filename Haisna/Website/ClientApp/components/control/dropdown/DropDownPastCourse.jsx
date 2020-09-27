import React from 'react';

import DropDown from './DropDown';

// 前回値対象コース選択肢
const items = [
  { value: 'CSC01', name: '一日人間ドック＋企業検診' },
  { value: '0', name: 'すべてのコース' },
  { value: '1', name: '同一コースのみ' },
];

export default (props) => <DropDown {...props} items={items} />;
