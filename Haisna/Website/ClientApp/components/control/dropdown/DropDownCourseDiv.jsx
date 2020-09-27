import React from 'react';

import DropDown from './DropDown';

// 健診コース区分択肢
const items = [
  { value: '100', name: '一日人間ドック' },
  { value: '105', name: '職員定期健診（ドック）' },
  { value: '110', name: '企業健診' },
];

export default (props) => <DropDown {...props} items={items} />;
