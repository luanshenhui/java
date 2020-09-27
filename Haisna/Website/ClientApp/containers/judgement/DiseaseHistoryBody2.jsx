import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';

import Table from '../../components/Table';

const Wrapper = styled.div`
  white-space: nowrap;
`;

const DiseaseHistoryBody2 = ({ data }) => (
  <div>
    <Wrapper><b>病名</b></Wrapper>
    <Table striped hover>
      <thead>
        <tr>
          <th style={{ width: 100 }}>入院日</th>
          <th style={{ width: 788 }}>病名</th>
        </tr>
      </thead>
      <tbody>
        {data && data.map((rec, index) => (
          <tr key={index.toString()}>
            <td><Wrapper>{moment(rec.indate).format('YYYY/MM/DD')}</Wrapper></td>
            <td><Wrapper>{rec.disname}</Wrapper></td>
          </tr>
        ))}
      </tbody>
    </Table>

  </div>
);

// propTypesの定義
DiseaseHistoryBody2.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default DiseaseHistoryBody2;
