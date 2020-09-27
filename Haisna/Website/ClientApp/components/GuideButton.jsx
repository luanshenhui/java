import React from 'react';
import PropTypes from 'prop-types';
import Help from '@material-ui/icons/Help';
import styled from 'styled-components';

const GuideIcon = styled(Help)`
  && {
    color: #9aa9b7;
    cursor: pointer;
    font-size: 29px;
    padding: 0 5px 0 0;
  }
`;

const Wrapper = styled.div`
  display: flex;
`;

const GuideButton = ({ onClick }) => (
  <Wrapper>
    <GuideIcon onClick={onClick} />
  </Wrapper>
);

// propTypesの定義
GuideButton.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default GuideButton;
