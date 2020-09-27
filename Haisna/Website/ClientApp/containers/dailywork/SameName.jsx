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

const SameName = ({ data }) => (
  <Wrapper>
    <SectionBar title="同姓同名受診者情報" />
    <div style={{ height: 200 }}>
      <Table>
        <thead>
          <tr>
            <th bgcolor="#dcdcdc" style={{ width: 70 }}>受診番号</th>
            <th bgcolor="#dcdcdc" style={{ width: 135 }}>氏名</th>
          </tr>
        </thead>
      </Table>
      <div style={{ height: 180, width: 250, overflowX: 'auto', overflowY: 'auto' }}>
        <Table striped hover>
          <tbody>
            {data && data.map((rec, index) => (
              <tr key={index.toString()}>
                {rec.dayid !== '' ?
                  <td style={{ width: 80 }}>{((rec.dayid).toString().padStart(4, '0000'))}</td>
                  : <td style={{ width: 80 }} />
                }
                <td style={{ width: 150 }}>{rec.lastname}{rec.firstname}</td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </div >
  </Wrapper>
);

// propTypesの定義
SameName.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};
export default SameName;
