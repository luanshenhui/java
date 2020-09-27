import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Link } from 'react-router-dom';

import Table from '../../components/Table';

const Wrapper = styled.div`
  white-space: nowrap;
`;

const HistoryRsl = (historydata) => {
  const { data } = historydata;
  let resRslList = [];
  const arrDisease = [];
  const res = [];
  const itemcd = [];
  const shortstc = [];
  const seq = [];
  let count = 0;

  while (count < data.length && data.length > 0) {
    itemcd[count] = data[count].itemcd;
    shortstc[count] = data[count].result;
    seq[count] = data[count].seq;
    count += 1;
  }

  for (let i = 0; i <= (data.length / 3 - 1); i += 1) {
    resRslList = [];
    arrDisease[i] = [];
    while (itemcd[i * 3 + 0] !== null || itemcd[i * 3 + 1] !== null || itemcd[i * 3 + 2] !== null) {
      for (let bdnCount = 0; bdnCount < 3; bdnCount += 1) {
        arrDisease[i][bdnCount] = shortstc[i * 3 + bdnCount];
        resRslList.push(arrDisease[i][bdnCount] !== null ? <td key={arrDisease[i][bdnCount]} style={{ whiteSpace: 'pre' }}>{arrDisease[i][bdnCount]}</td> : <td>&nbsp;</td>);
      }
      break;
    }
    res.push(<tr key={i}>{resRslList}</tr>);
  }

  return res;
};


const DiseaseHistoryBody1 = ({ data, rsvno }) => (
  <div>
    <Wrapper><b>現病歴・既往歴</b>&emsp;&nbsp;
      <Link to={`/.../contents/monshin/ocrNyuryoku/${rsvno}/1`}>入力する</Link>
    </Wrapper>
    <Table>
      <thead>
        <tr>
          <th style={{ width: 100 }}>病名</th>
          <th align="center">年齢</th>
          <th style={{ width: 200 }}>治療状態</th>
        </tr>
      </thead>
      <tbody>
        <HistoryRsl data={data} />
      </tbody>
    </Table>
  </div>
);

// propTypesの定義
DiseaseHistoryBody1.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rsvno: PropTypes.string.isRequired,
};

export default DiseaseHistoryBody1;
