import React from 'react';
import PropTypes from 'prop-types';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';
import Table from '../../components/Table';

const PerBillAllIncomeList = ({ data, lastkname, firstkname, gdePerBill, onDelete }) => (
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
          <td><GuideButton onClick={() => gdePerBill(index)} /></td>
          <td><Chip onDelete={() => onDelete(index)} /></td>
          <td>{rec.perId}</td>
          <td />
          <td>{rec.perId && `${rec.lastname} ${rec.firstname} (${lastkname}  ${firstkname})`}</td>
          <td />
          <td>{rec.perId && `${rec.age}歳`}</td>
          <td />
          <td>{rec.gender}</td>
          <td />
          <td>{rec.rsvno}</td>
          <td />
          <td>{rec.billno}</td>
        </tr>
      ))
      }
    </tbody>
  </Table>
);

PerBillAllIncomeList.defaultProps = {
  lastkname: '',
  firstkname: '',
};

// propTypesの定義
PerBillAllIncomeList.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  lastkname: PropTypes.string,
  firstkname: PropTypes.string,
  gdePerBill: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
};
export default PerBillAllIncomeList;
