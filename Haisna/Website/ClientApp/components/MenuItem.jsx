import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';
import PropTypes from 'prop-types';

const Wrapper = styled.div`
 font-size: 16px;
 margin-left: 80px;
`;
const WrapperDes = styled.div`
 margin-left: 80px;
`;

const MenuItem = ({ title, link, description, image }) => (
  <div>
    {image && image !== '' && (
      <div style={{ float: 'left' }}>
        <img src={image} alt={image} />
      </div>
    )}
    <Wrapper>
      {(link && link !== '') ? (<Link to={link}>{title}</Link>) : title}
    </Wrapper>
    <WrapperDes>{description}</WrapperDes>
    <div style={{ height: '15px' }} />
  </div >
);

MenuItem.propTypes = {
  title: PropTypes.string.isRequired,
  link: PropTypes.string,
  description: PropTypes.string.isRequired,
  image: PropTypes.string,
};

// defaultProps‚Ì’è‹`
MenuItem.defaultProps = {
  image: undefined,
  link: undefined,
};

export default MenuItem;

