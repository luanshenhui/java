/**
 * @file 基準値フラグの値を対応するマークに変更する
 */
import React from 'react';
import PropTypes from 'prop-types';

// 基準値フラグと対応するマーク
const marks = [
  { code: 'H', mark: '▲' },
  { code: 'U', mark: '▲' },
  { code: 'D', mark: '▼' },
  { code: 'L', mark: '▼' },
  { code: '*', mark: '■' },
  { code: '@', mark: '■' },
];

const StdFlgMark = ({ code }) => (
  <span>
    {marks.filter((rec) => rec.code === code).filter((_, i) => i === 0).map((rec) => rec.mark)}
  </span>
);

// propTypes定義
StdFlgMark.propTypes = {
  code: PropTypes.string,
};

// defaultProps定義
StdFlgMark.defaultProps = {
  code: null,
};

export default StdFlgMark;
