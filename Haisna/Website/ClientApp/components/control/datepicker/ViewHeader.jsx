import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

// cssのインポート
import styles from './ViewHeader.css';

const ViewHeader = ({ prev, next, titleAction, data }) => (
  <div>
    <span role="presentation" tabIndex="-1" className={styles.icon} onClick={prev}>
      &lt;
    </span>
    <span role="presentation" tabIndex="-1" className={classNames(styles.title, { [styles.navigationTitle]: titleAction !== null })} onClick={titleAction}>
      {data}
    </span>
    <span role="presentation" tabIndex="-1" className={styles.icon} onClick={next}>
      &gt;
    </span>
  </div>
);

ViewHeader.propTypes = {
  prev: PropTypes.func.isRequired,
  next: PropTypes.func.isRequired,
  titleAction: PropTypes.func,
  data: PropTypes.string,
};

ViewHeader.defaultProps = {
  data: '',
  titleAction: null,
};

export default ViewHeader;
