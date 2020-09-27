import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';

import Table from '../../components/Table';

const PerCloseMngInfoList = ({ data }) => {
  const toDispbillno = (rec) => {
    let dispBillNo = '';
    // 0詰めのための定義
    const workNo = '0000';
    if (rec.closedate !== '') {
      dispBillNo = `${rec.closedate}`.substr(0, 4);
      dispBillNo += `${rec.closedate}`.substr(5, 2);
      dispBillNo += `${rec.closedate}`.substr(8, 2);
      dispBillNo += workNo.substr(0, workNo.length);
      dispBillNo += '-'`${rec.closebillseq}`.length;
      dispBillNo += rec.closebillseq;
      dispBillNo += rec.closebranchno;
    }
    return dispBillNo;
  };
  return (
    <Table>
      <thead>
        <tr>
          <td>●請求書Noが表示されている場合、数字をクリックすると請求書情報画面が表示されます。</td>
        </tr>
        <tr>
          <th>負担元</th>
          <th>請求書No</th>
        </tr>
      </thead>
      <tbody>
        {data && data.map((rec) => (
          <tr key={rec.closebillseq}>
            <td>{rec.closeorgname}</td>
            <td><Link to={`/contents/demand/dmdburdenmodify/${rec.billno}/${rec.dispbillno}`}>{toDispbillno(rec)}</Link></td>
          </tr>
        ))}
      </tbody>
    </Table>
  );
};

PerCloseMngInfoList.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default PerCloseMngInfoList;
