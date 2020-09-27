import React from 'react';
import PropTypes from 'prop-types';

const ReportParameter = ({ children, label, isRequired }) => (
  <div className="ReportParameter" style={{ display: 'flex', alignItems: 'center' }}>
    <span>
      {label}
      {isRequired && <span style={{ color: 'red' }}>*</span>}：
    </span>
    <span style={{ display: 'flex' }}>
      {children}
    </span>
  </div>
);

ReportParameter.propTypes = {
  children: PropTypes.node,
  label: PropTypes.node,
  isRequired: PropTypes.bool,
};

ReportParameter.defaultProps = {
  children: undefined,
  label: '',
  isRequired: false,
};

export default ReportParameter;
