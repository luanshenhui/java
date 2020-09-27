import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

// cssのインポート
import styles from './Icon.css';

const Icon = ({ customIcon, hideIcon, disabled }, toggleClick) => {
  if (customIcon == null) {
    return hideIcon || disabled ? (
      ''
    ) : (
      <span role="presentation" className={classNames(styles.iconWrapper, styles.calendarIcon)} onClick={toggleClick}>
        <svg width="16" height="16" viewBox="0 0 16 16">
          <path d="M5 6h2v2h-2zM8 6h2v2h-2zM11 6h2v2h-2zM2 12h2v2h-2zM5
            12h2v2h-2zM8 12h2v2h-2zM5 9h2v2h-2zM8 9h2v2h-2zM11 9h2v2h-2zM2
            9h2v2h-2zM13 0v1h-2v-1h-7v1h-2v-1h-2v16h15v-16h-2zM14
            15h-13v-11h13v11z"
          />
        </svg>
      </span>
    );
  }
  // } else {
  return (
    <span role="presentation" className={classNames(styles.iconWrapper, styles.calendarIcon, customIcon)} onClick={toggleClick} />
  );
  // }
};

Icon.propTypes = {
  customIcon: PropTypes.string,
  hideIcon: PropTypes.bool,
  disabled: PropTypes.bool,
};

Icon.defaultProps = {
  customIcon: null,
  hideIcon: false,
  disabled: false,
};

export default Icon;
