import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Wrapper = styled.div`
  && {
    .fieldValue {
      display: block;
    }
  }
`;

const FieldValueList = ({ children }) => (
  <Wrapper>
    {children}
  </Wrapper>
);

FieldValueList.propTypes = {
  children: PropTypes.node,
};

FieldValueList.defaultProps = {
  children: undefined,
};

export default FieldValueList;
