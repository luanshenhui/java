import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Table from '../../components/Table';
import SectionBar from '../../components/SectionBar';

const Wrapper = styled.div`
  height: 100%;
  width: 540px;
  float: left;
  margin-right: 10px;
`;

const FriendInfo = ({ data }) => {
  const res = [];
  const compflag = [];
  const compdayid = [];
  const complastname = [];
  const compfirstname = [];
  const dayid = [];
  const lastname = [];
  const firstname = [];
  const rsvno = [];
  const initdayid = [];
  const initcompdayid = [];
  let td1 = null;
  let td2 = null;
  let count = 0;
  let prersvno = '';

  while (count < data.length && data.length > 0) {
    compflag[count] = data[count].compflag;
    compdayid[count] = data[count].compdayid;
    complastname[count] = data[count].complastname;
    compfirstname[count] = data[count].compfirstname;
    dayid[count] = data[count].dayid;
    initdayid[count] = (data[count].dayid).toString().padStart(4, '0000');
    initcompdayid[count] = (data[count].compdayid).toString().padStart(4, '0000');
    lastname[count] = data[count].lastname;
    firstname[count] = data[count].firstname;
    rsvno[count] = data[count].rsvno;
    count += 1;
  }

  for (let i = 0; i < data.length; i += 1) {
    if (prersvno !== rsvno[i]) {
      prersvno = rsvno[i];
      td1 = dayid[i] !== '' ? <td style={{ width: 70 }}>{initdayid[i]}</td> : <td style={{ width: 70 }} />;
      td2 = <td style={{ whiteSpace: 'pre', width: 135 }}>{lastname[i]}{firstname[i]}</td>;
    } else {
      td1 = <td style={{ width: 70 }} />;
      td2 = <td style={{ width: 135 }} />;
    }
    const td3 = compflag[i] === '1' ? <td align="center" style={{ width: 40 }}>&#x02606;</td> : <td style={{ width: 40 }} />;
    const td4 = compdayid[i] !== '' ? <td style={{ width: 100 }}>{initcompdayid[i]}</td> : <td style={{ width: 100 }} />;
    const td5 = <td style={{ whiteSpace: 'pre', width: 135 }}>{complastname[i]}{compfirstname[i]}</td>;

    res.push(<tr key={i}>{td1}{td2}{td3}{td4}{td5}</tr>);
  }

  return res;
};
const FriendSummary = ({ data }) => (
  <Wrapper>
    <SectionBar title="同伴者（お連れ様）受診者情報" />
    <div style={{ height: 200 }}>
      <Table>
        <thead>
          <tr>
            <th bgcolor="#dcdcdc" style={{ width: 70 }}>受診番号</th>
            <th bgcolor="#dcdcdc" style={{ width: 135 }}>受診者氏名</th>
            <th bgcolor="#dcdcdc" style={{ width: 40 }}>同伴</th>
            <th bgcolor="#dcdcdc" style={{ width: 100 }}>同伴受診番号</th>
            <th bgcolor="#dcdcdc" style={{ width: 135 }}>同伴者氏名</th>
          </tr>
        </thead>
      </Table>
      <div style={{ height: 180, width: 540, overflowX: 'auto', overflowY: 'auto' }}>
        <Table striped hover>
          <tbody>
            <FriendInfo data={data} />
          </tbody>
        </Table>
      </div>
    </div >
  </Wrapper>
);

// propTypesの定義
FriendSummary.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};
export default FriendSummary;

