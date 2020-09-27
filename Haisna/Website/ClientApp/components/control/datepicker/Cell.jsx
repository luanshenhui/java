import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

// cssのインポート
import styles from './Cell.css';

const Cell = ({ value, className }) => <div className={classNames(className, styles.cell)}>{value}</div>;

Cell.propTypes = {
  value: PropTypes.string,
  className: PropTypes.string,
};

// defaultPropsの定義
Cell.defaultProps = {
  value: '',
  className: undefined,
};

export default Cell;
