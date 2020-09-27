/**
 * @file カレンダー検索ガイド用カレンダー
 */
import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Td = styled.td`
  border: 1px solid #000;
  text-align: center;
`;

const Caption = ({ year, month }) => (
  <tr>
    <Td colSpan="7" >
      {year}年{month}月
    </Td>
  </tr>
);

Caption.propTypes = {
  year: PropTypes.string.isRequired,
  month: PropTypes.string.isRequired,
};

export default Caption;
