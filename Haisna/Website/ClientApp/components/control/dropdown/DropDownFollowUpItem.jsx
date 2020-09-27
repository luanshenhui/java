import React from 'react';

import DropDown from './DropDown';

// フォローアップ用検査分類
const items = [
  { value: 6, name: '胸部X線' },
  { value: 7, name: '上部消化管' },
  { value: 8, name: '便潜血' },
  { value: 9, name: '上腹部超音波' },
  { value: 10, name: '血液' },
  { value: 18, name: '前立腺' },
  { value: 26, name: '大腸内視鏡' },
  { value: 27, name: '胸部CT' },
  { value: 29, name: '喀痰' },
];

export default (props) => <DropDown {...props} items={items} />;
