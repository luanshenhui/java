import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Table from '../../components/Table';
import SectionBar from '../../components/SectionBar';

const Wrapper = styled.div`
  height: 120px;
  width: 780px;
  float: left;
  margin-right: 10px;
  margin-top: 8px;
`;

const updVolunteer = (data) => {
  const resVolunteer = [];
  let strVolunteer = '';
  switch (data) {
    case 0:
      strVolunteer = '利用なし';
      break;
    case 1:
      strVolunteer = '通訳要';
      break;
    case 2:
      strVolunteer = '介護要';
      break;
    case 3:
      strVolunteer = '通訳＆介護要';
      break;
    case 4:
      strVolunteer = '車椅子要';
      break;
    default:
      strVolunteer = '';
      break;
  }
  resVolunteer.push(strVolunteer);
  return resVolunteer;
};

const DeailInfo = ({ data }) => {
  const res = [];
  const dayid = [];
  const lastname = [];
  const firstname = [];
  const initdayid = [];
  const volunteer = [];
  const volunteername = [];
  let count = 0;

  while (count < data.length && data.length > 0) {
    dayid[count] = data[count].dayid;
    initdayid[count] = (data[count].dayid).toString().padStart(4, '0000');
    lastname[count] = data[count].lastname;
    firstname[count] = data[count].firstname;
    volunteer[count] = data[count].volunteer;
    volunteername[count] = data[count].volunteername;
    count += 1;
  }
  for (let i = 0; i < data.length; i += 1) {
    if ((volunteer[i] !== 0 && volunteer[i] !== null) || volunteername[i] !== null) {
      const td1 = dayid[i] !== '' ? <td style={{ width: 80 }}>{initdayid[i]}</td> : <td style={{ width: 80 }}>&nbsp;</td>;
      const td2 = <td style={{ whiteSpace: 'pre', width: 150 }}>{lastname[i]}{firstname[i]}</td>;
      const td3 = <td style={{ whiteSpace: 'pre', width: 150 }}>{updVolunteer(volunteer[i])}</td>;
      const td4 = <td style={{ whiteSpace: 'pre', width: 360 }}>{volunteername[i]}</td>;
      res.push(<tr key={i}>{td1}{td2}{td3}{td4}</tr>);
    }
  }

  return res;
};
const VolunteerInfo = ({ data }) => (
  <Wrapper>
    <SectionBar title="ボランティア情報" />
    <div style={{ height: 100 }}>
      <Table>
        <thead>
          <tr>
            <th bgcolor="#dcdcdc" style={{ width: 80 }}>受診番号</th>
            <th bgcolor="#dcdcdc" style={{ width: 150 }}>氏名</th>
            <th bgcolor="#dcdcdc" style={{ width: 150 }}>ボランティア区分</th>
            <th bgcolor="#dcdcdc" style={{ width: 360 }}>ボランティア名</th>
          </tr>
        </thead>
      </Table>
      <div style={{ height: 60, width: 780, overflowX: 'auto', overflowY: 'auto' }}>
        <Table striped hover>
          <tbody>
            <DeailInfo data={data} />
          </tbody>
        </Table>
      </div>
    </div >
  </Wrapper>
);

// propTypesの定義
VolunteerInfo.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};
export default VolunteerInfo;
