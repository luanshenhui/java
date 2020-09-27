import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import PlayArrow from '@material-ui/icons/PlayArrow';

const Wrapper = styled.div`
  color: #666;
  display: flex;
  justify-content: space-between;
  padding: 0 2px 0 0;
`;

const Icon = styled(PlayArrow)`
&& {
  font-size: 14px;
  height: 27px;
}
`;

const FieldItem = ({ children }) => (
  <Wrapper className="fielditem">
    {children}
    <Icon />
  </Wrapper>
);

FieldItem.propTypes = {
  children: PropTypes.node,
};

FieldItem.defaultProps = {
  children: undefined,
};

export default FieldItem;
