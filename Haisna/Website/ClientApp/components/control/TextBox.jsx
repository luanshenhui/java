import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Input = styled.input`
  background-color: #ffffff;
  border: 1px solid #9aa9b7;
  color: #333333;
  font-size: 15px;
  padding: 2px 7px 0;
`;

const TextBox = ({ input, ...others }) => (
  <Input type="text" {...input} {...others} />
);

// propTypesの定義
TextBox.propTypes = {
  input: PropTypes.shape(),
};

// defaultPropsの定義
TextBox.defaultProps = {
  input: undefined,
};

export default TextBox;
