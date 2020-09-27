/**
 * @file 性別の値から性別を表示するコンポーネント
 */
import React from 'react';
import PropTypes from 'prop-types';

import { Gender } from '../../constants/common';

const GenderName = ({ code }) => (
  <span>
    {code === Gender.Male && '男性'}
    {code === Gender.Female && '女性'}
  </span>
);

// propTypesの定義
GenderName.propTypes = {
  code: PropTypes.number.isRequired,
};

export default GenderName;
