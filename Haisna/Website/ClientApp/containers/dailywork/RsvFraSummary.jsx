import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Table from '../../components/Table';
import SectionBar from '../../components/SectionBar';

const Wrapper = styled.div`
  height: 100%;
  width: 250px;
  float: left;
  margin-right: 10px;
`;

const RsvFraSummary = ({ data }) => (
  <Wrapper>
    <SectionBar title="時間帯別受診者情報" />
    <div style={{ height: 200 }}>
      <Table>
        <thead>
          <tr>
            <th bgcolor="#dcdcdc" style={{ width: 130 }}>開始時間</th>
            <th bgcolor="#dcdcdc" style={{ width: 40 }}>男性</th>
            <th bgcolor="#dcdcdc" style={{ width: 40 }}>女性</th>
          </tr>
        </thead>
      </Table>
      <div style={{ height: 180, width: 250, overflowX: 'auto', overflowY: 'auto' }}>
        <Table striped hover>
          <tbody>
            {data && data.map((rec, index) => (
              <tr key={index.toString()}>
                <td align="left" style={{ whiteSpace: 'pre', width: 130 }}>{rec.rsvgrpname}</td>
                <td align="right" style={{ whiteSpace: 'pre', width: 40 }}>{rec.malecount}</td>
                <td align="right" style={{ whiteSpace: 'pre', width: 40 }}>{rec.femalecount}</td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </div >
  </Wrapper>
);

// propTypesの定義
RsvFraSummary.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};
export default RsvFraSummary;
