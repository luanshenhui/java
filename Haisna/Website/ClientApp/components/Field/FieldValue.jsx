import React from 'react';
import PropTypes from 'prop-types';

const FieldValue = ({ children }) => (
  <div className="fieldvalue">
    {children}
  </div>
);

FieldValue.propTypes = {
  children: PropTypes.node,
};

FieldValue.defaultProps = {
  children: undefined,
};

export default FieldValue;
