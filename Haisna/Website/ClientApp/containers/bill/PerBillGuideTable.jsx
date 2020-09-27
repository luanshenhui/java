import React from 'react';
import PropTypes from 'prop-types';
import Table from '../../components/Table';
import PerBillGuideTableDeta from './PerBillGuideTableDeta';


// 個人検査情報
const PerBillGuideTable = (props) => {
  const { formValues } = props;
  return (
    <Table>
      <thead>
        <tr bgcolor="#cccccc">
          <td>請求書No.</td>
          <td>請求明細分類</td>
          <td>金額</td>
          <td>調整金額</td>
          <td>税額</td>
          <td>調整税額</td>
        </tr>
      </thead>
      <tbody>
        {props.data.map((consultmInfo, index) => <PerBillGuideTableDeta {...props} key={consultmInfo.priceseq} index={index} formValues={formValues} consultmInfo={consultmInfo} />)}
      </tbody>
    </Table>
  );
};

// propTypesの定義
PerBillGuideTable.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  formValues: PropTypes.shape().isRequired,
};

export default PerBillGuideTable;
