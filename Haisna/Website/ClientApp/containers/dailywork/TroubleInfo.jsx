import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';
import Table from '../../components/Table';
import SectionBar from '../../components/SectionBar';

const Wrapper = styled.div`
  height: 220px;
  width: 780px;
  float: left;
  margin-right: 10px;
  margin-top: 8px;
`;

const TroubleInfo = ({ data }) => (
  <Wrapper>
    <SectionBar title="トラブル情報" />
    <div style={{ height: 220 }}>
      <Table>
        <thead>
          <tr>
            <th bgcolor="#dcdcdc" style={{ width: 80 }}>受診番号</th>
            <th bgcolor="#dcdcdc" style={{ width: 150 }}>氏名</th>
            <th bgcolor="#dcdcdc" style={{ width: 360 }}>トラブル内容</th>
            <th bgcolor="#dcdcdc" style={{ width: 140 }}>登録日時</th>
          </tr>
        </thead>
      </Table>
      <div style={{ height: 210, width: 780, overflowX: 'auto', overflowY: 'auto' }}>
        <Table striped hover>
          <tbody>
            {data && data.map((rec, index) => (
              <tr key={index.toString()}>
                {rec.dayid !== '' ?
                  <td style={{ whiteSpace: 'pre', width: 80 }}>{((rec.dayid).toString().padStart(4, '0000'))}</td>
                  : <td style={{ width: 80 }} />
                }
                <td style={{ whiteSpace: 'pre', width: 150 }}>{rec.lastname}{rec.firstname}</td>
                <td style={{ whiteSpace: 'pre', width: 360 }}>{rec.pubnote}</td>
                <td style={{ whiteSpace: 'pre', width: 140 }}>{moment(rec.upddate).format('YYYY/MM/DD hh:mm:ss')}</td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </div >
  </Wrapper>
);

// propTypesの定義
TroubleInfo.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};
export default TroubleInfo;
