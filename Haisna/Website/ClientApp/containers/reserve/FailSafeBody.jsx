import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import Table from '../../components/Table';
import { FieldSet } from '../../components/Field';

const commaSplit = (strItem) => {
  let arrayItem = [];
  arrayItem = strItem.split(',');
  return arrayItem;
};

const valJoin = (val1, val2, val3) => {
  let morgcd1 = '';
  let morgcd2 = '';
  let joinItem1 = [];
  let joinItem2 = [];
  const divArr = [];
  joinItem1 = commaSplit(val1);
  joinItem2 = commaSplit(val2);
  for (let i = 0; i < joinItem1.length; i += 1) {
    if (morgcd1 !== joinItem1[i] && morgcd2 !== joinItem2[i]) {
      morgcd1 = joinItem1[i];
      morgcd2 = joinItem2[i];
      if (val3) {
        divArr.push(commaSplit(val3)[i]);
      } else {
        divArr.push(`${morgcd1}-${morgcd2}`);
      }
    }
  }
  return divArr;
};

const FailSafeBody = ({ count, data }) => (
  <div>
    <FieldSet>
      <span style={{ marginTop: 27 }}>{`該当者は  ${count}名です。`}</span>
      <span style={{ marginLeft: 700 }}>
        区：契約のｵﾌﾟｼｮﾝと矛盾が生じた場合に年[年齢]、受[受診区分]、性[性別]が表示されます。<br />
        限：予約作成後に契約の限度額が変更され矛盾が発生した場合に○が表示されます。
      </span>
    </FieldSet>
    <Table striped hover>
      <thead>
        <tr>
          <th>予約番号</th>
          <th>受診日</th>
          <th>個人ID</th>
          <th>氏名</th>
          <th>コース</th>
          <th>コース名</th>
          <th>予歳</th>
          <th>契歳</th>
          <th>限</th>
          <th>区</th>
          <th>負担元</th>
          <th>負担元名</th>
          <th>オプション</th>
          <th>オプション名</th>
          <th>予約時金額</th>
          <th>予約時消費税</th>
          <th>契約金額</th>
          <th >契約消費税</th>
        </tr>
      </thead>
      <tbody>
        {data.map((rec, index) => (
          <tr key={`${rec.csldate}-${index.toString()}`}>
            <td style={{ verticalAlign: 'top' }}>{rec.rsvno}</td>
            <td style={{ verticalAlign: 'top' }}>{moment(rec.csldate).format('YYYY/MM/DD')}</td>
            <td style={{ verticalAlign: 'top' }}>{rec.perid}</td>
            <td style={{ verticalAlign: 'top' }}>{rec.lastname}　{rec.irstname}</td>
            <td style={{ verticalAlign: 'top' }}>{rec.cscd}</td>
            <td style={{ verticalAlign: 'top' }}>{rec.csname}</td>
            {rec.age !== rec.p_age ?
              <td style={{ verticalAlign: 'top' }}><span style={{ backgroundColor: '#eeeeee' }}>{rec.age}</span></td> : <td>{rec.age}</td>
            }
            {rec.age !== rec.p_age ?
              <td style={{ verticalAlign: 'top' }}><span style={{ backgroundColor: '#cccccc' }}>{rec.p_age}</span></td> : <td>{rec.p_age}</td>
            }
            {rec.limitflg === 1 ?
              <td style={{ verticalAlign: 'top' }}><span style={{ backgroundColor: '#cccccc' }}>○</span></td> : <td>&nbsp;</td>
            }
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.optmsg &&
                commaSplit(rec.optmsg).map((optmsg, optmsgIdx) => (
                  <div key={`optmsg${optmsgIdx.toString()}`} >{optmsg}</div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 &&
                valJoin(rec.morgcd1, rec.morgcd2, null).map((morgcd, morgcdIdx) => (
                  <div key={`morgcd${morgcdIdx.toString()}`} >{morgcd}</div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 &&
                valJoin(rec.morgcd1, rec.morgcd2, rec.orgsname).map((orgsname, orgsnameIdx) => (
                  <div key={`orgsname${orgsnameIdx.toString()}`} >{orgsname}</div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.optcd && rec.optbranchno &&
                commaSplit(rec.optcd).map((optcd, optcdIdx) => (
                  <div key={`optcd${optcdIdx.toString()}`} >{`${optcd}-${commaSplit(rec.optbranchno)[optcdIdx]}`}</div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.optname &&
                commaSplit(rec.optname).map((optname, optnameIdx) => (
                  <div key={`optname${optnameIdx.toString()}`} >{optname}</div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.mprice &&
                commaSplit(rec.mprice).map((mprice, mpriceIdx) => (
                  <div style={{ textAlign: 'right' }} key={`mprice${mpriceIdx.toString()}`}>
                    <span style={commaSplit(rec.mprice)[mpriceIdx] !== commaSplit(rec.cprice)[mpriceIdx] ? { backgroundColor: '#cccccc' } : {}}>{mprice}</span>
                  </div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.mtax &&
                commaSplit(rec.mtax).map((mtax, mtaxIdx) => (
                  <div style={{ textAlign: 'right' }} key={`mtax${mtaxIdx.toString()}`}>
                    <span style={commaSplit(rec.mtax)[mtaxIdx] !== commaSplit(rec.ctax)[mtaxIdx] ? { backgroundColor: '#cccccc' } : {}}>{mtax}</span>
                  </div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.cprice &&
                commaSplit(rec.cprice).map((cprice, cpriceIdx) => (
                  <div style={{ textAlign: 'right' }} key={`cprice${cpriceIdx.toString()}`}>
                    <span style={commaSplit(rec.mprice)[cpriceIdx] !== commaSplit(rec.cprice)[cpriceIdx] ? { backgroundColor: '#cccccc' } : {}}>{cprice}</span>
                  </div>
                ))
              }
            </td>
            <td style={{ verticalAlign: 'top' }}>
              {rec.morgcd1 && rec.ctax &&
                commaSplit(rec.ctax).map((ctax, ctaxIdx) => (
                  <div style={{ textAlign: 'right' }} key={`ctax${ctaxIdx.toString()}`}>
                    <span style={commaSplit(rec.mtax)[ctaxIdx] !== ctax ? { backgroundColor: '#cccccc' } : {}}>{ctax}</span>
                  </div>
                ))
              }
            </td>
          </tr>
        ))}
      </tbody>
    </Table>
  </div>
);

// propTypesの定義
FailSafeBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  count: PropTypes.number.isRequired,
};

export default FailSafeBody;
