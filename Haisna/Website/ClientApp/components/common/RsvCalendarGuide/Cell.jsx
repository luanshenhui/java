/**
 * @file カレンダー検索ガイド用カレンダーセル
 */
import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Td = styled.td`
  text-align: center;
  border: 1px solid #000;
`;

const Cell = (props) => {
  const { value, onClick, style } = props;

  const handleOnClick = () => {
    if (onClick) {
      onClick();
    }
  };

  return (
    <Td style={style} onClick={() => handleOnClick()}>
      { value }
    </Td>
  );
};

Cell.propTypes = {
  value: PropTypes.string,
  onClick: PropTypes.func,
  style: PropTypes.shape(),
};

Cell.defaultProps = {
  value: '',
  onClick: undefined,
  style: undefined,
};

export default Cell;
