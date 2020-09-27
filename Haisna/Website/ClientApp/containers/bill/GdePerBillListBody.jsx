import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import MoneyFormat from './MoneyFormat';
import Table from '../../components/Table';
import LabelCourseWebColor from '../../components/control/label/LabelCourseWebColor';

const GdePerBillListBody = ({ data, onSelectGdePerBill, index }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th>請求日</th>
        <th>請求書No</th>
        <th>対象予約番号</th>
        <th>受診コース</th>
        <th>個人氏名</th>
        <th>受診団体</th>
        <th style={{ textAlign: 'right' }}>合計</th>
        <th style={{ textAlign: 'right' }}>入金額</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec) => (
        <tr key={rec.key} >
          <td>{moment(rec.dmdDate).format('YYYY/MM/DD')}</td>
          <td>{moment(rec.dmdDate).format('YYYYMMDD')}{`0000${rec.billSeq}`.slice(-5)}{rec.branchNo}</td>
          <td><Link to={`/contents/reserve/rsvMain/${rec.rsvNo}`}>{rec.rsvNo}</Link></td>
          <td><LabelCourseWebColor webcolor={rec.webColor} />{rec.csName}</td>
          <td>
            <a
              href="#"
              onClick={() => { onSelectGdePerBill(rec, index); }}
              style={{ color: '#0000ff' }}
            >
              {rec.lastName} {rec.firstName}
              <span style={{ color: '#666666' }}>({rec.lastKname} {rec.firstKname})</span>
            </a>
          </td>
          <td>{rec.orgSName}</td>
          <td
            style={{ textAlign: 'right' }}
          >
            {rec.toTalPrice != null &&
              <strong><MoneyFormat money={rec.toTalPrice} /></strong>
            }
          </td>
          <td
            style={{ textAlign: 'right' }}
          >
            {rec.paymentDate == null ?
              <span>未収</span>
              : <span><MoneyFormat money={rec.toTalPrice} /></span>
            }
          </td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
GdePerBillListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onSelectGdePerBill: PropTypes.func.isRequired,
  index: PropTypes.number,
};
// defaultPropsの定義
GdePerBillListBody.defaultProps = {
  index: null,
};

export default GdePerBillListBody;

