import React from 'react';
import PropTypes from 'prop-types';

const LabelCourseWebColor = ({ webcolor }) => (
  <span style={{ color: `#${webcolor}` }}>■</span>
);
// propTypesの定義
LabelCourseWebColor.propTypes = {
  webcolor: PropTypes.string.isRequired,

};
export default LabelCourseWebColor;
