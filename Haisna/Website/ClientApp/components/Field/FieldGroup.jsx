import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Wrapper = styled.div`
  && {
    .fielditem {
      width: ${(props) => ((props.width > 0) ? `${props.width}px` : 'inherit')}
    }
  }
`;

const FieldGroup = ({ children, itemWidth }) => (
  <Wrapper width={itemWidth}>
    {children}
  </Wrapper>
);

FieldGroup.propTypes = {
  children: PropTypes.node,
  itemWidth: PropTypes.number,
};

FieldGroup.defaultProps = {
  children: undefined,
  itemWidth: undefined,
};

export default FieldGroup;
