import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';
import Table from '../../components/Table';

const name = (rec) => {
  let res;
  if (rec.perId !== null) {
    res = <td>{rec.lastname} {rec.firstname}({rec.lastkname} {rec.firstkname})</td>;
  } else {
    res = <td />;
  }
  return res;
};

const gender = (rec) => {
  let res;
  if (rec.perId !== null) {
    res = <td>{rec.gender === 1 ? ' 男性' : ' 女性'}</td>;
  } else {
    res = <td />;
  }
  return res;
};

const requestNo = (rec) => {
  let res;
  if (rec.perId !== null) {
    res = <td>{rec.perId && moment(rec.dmddate).format('YYYYMMDD')}{`0000${rec.billseq}`.slice(-5)}{rec.branchno}</td>;
  } else {
    res = <td />;
  }
  return res;
};

const MergePerBillList = ({ data, dmdDate, billSeq, branchNo, gdePerBill, onDelete }) => (
  <Table>
    <thead>
      <tr>
        <th />
        <th />
        <th>個人ＩＤ</th>
        <th />
        <th>氏名</th>
        <th />
        <th>年齢</th>
        <th />
        <th>性別</th>
        <th />
        <th>予約番号</th>
        <th />
        <th>請求書No.</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec, index) => (
        <tr key={rec.key}>
          <td><GuideButton onClick={() => gdePerBill(index, 0, 0, 0, 1, null, dmdDate, dmdDate, billSeq, branchNo)} /></td>
          <td><Chip onDelete={() => onDelete(index)} /></td>
          <td>{rec.perId}</td>
          <td />
          {name(rec)}
          <td />
          <td>{rec.perId && `${Math.round(rec.age)}歳`}</td>
          <td />
          {gender(rec)}
          <td />
          <td>{rec.perId && rec.rsvno}</td>
          <td />
          {requestNo(rec)}
        </tr>
      ))
      }
    </tbody>
  </Table>
);

// propTypesの定義
MergePerBillList.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  dmdDate: PropTypes.string.isRequired,
  gdePerBill: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  billSeq: PropTypes.string.isRequired,
  branchNo: PropTypes.string.isRequired,
};
export default MergePerBillList;
