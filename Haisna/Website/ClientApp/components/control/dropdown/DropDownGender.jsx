import React from 'react';

import DropDown from './DropDown';
import { Gender } from '../../../constants/common';

// 性別選択肢
const items = [
  { value: Gender.Male, name: '男性' },
  { value: Gender.Female, name: '女性' },
];

export default (props) => <DropDown {...props} items={items} />;
