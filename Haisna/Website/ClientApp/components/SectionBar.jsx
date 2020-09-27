import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Wrapper = styled.div`
  background-color: #b8b4ac;
  color: #fff;
  font-size: 17px;
  line-height: 1;
  margin: 10px 0;
  padding: 6px 9px;
`;

const SectionBar = (props) => (
  <Wrapper>
    {props.title}
  </Wrapper>
);

SectionBar.propTypes = {
  title: PropTypes.string.isRequired,
};

export default SectionBar;
