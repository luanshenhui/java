import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Wrapper = styled.div`
  display: flex;
  line-height: 27px;
  padding: 3px 0;
`;

const FieldSet = ({ children }) => (
  <Wrapper>
    {children}
  </Wrapper>
);

FieldSet.propTypes = {
  children: PropTypes.node,
};

FieldSet.defaultProps = {
  children: undefined,
};

export default FieldSet;
