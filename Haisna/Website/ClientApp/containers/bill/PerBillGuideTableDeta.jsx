import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import DropDown from '../../components/control/dropdown/DropDown';

// 個人検査情報
const PerBillGuideTableDeta = ({ consultmInfo, index, formValues }) => {
  const pieces = [];
  let count = 1;
  if (formValues !== undefined) {
    count = formValues.dropdownitem;
  }

  if (count > 1) {
    pieces.push({ value: 0, name: '' });
  }

  for (let i = 1; i <= count; i += 1) {
    pieces.push({ value: i, name: `${i}枚目` });
  }
  return (
    <tr bgcolor="#eeeeee">
      {(consultmInfo.dmddate !== null && consultmInfo.billseq !== null && consultmInfo.branchno !== null) ?
        <td>作成済み</td> :
        <td><Field name={`piece${index + 1}`} component={DropDown} items={pieces} /></td>}
      <td>{consultmInfo.linename}</td>
      <td>&#165;{consultmInfo.price.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
      <td>&#165;{consultmInfo.editprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
      <td>&#165;{consultmInfo.taxprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
      <td>&#165;{consultmInfo.edittax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
    </tr>
  );
};

// propTypesの定義
PerBillGuideTableDeta.propTypes = {
  consultmInfo: PropTypes.shape().isRequired,
  index: PropTypes.number.isRequired,
  formValues: PropTypes.shape().isRequired,
};

export default PerBillGuideTableDeta;
