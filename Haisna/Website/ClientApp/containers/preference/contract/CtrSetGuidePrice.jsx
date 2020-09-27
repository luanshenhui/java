import React from 'react';
import { Field } from 'redux-form';
import PropTypes from 'prop-types';
import TextBox from '../../../components/control/TextBox';
import * as Contants from '../../../constants/common';


// 請求情報の入力フィールド
const CtrSetGuidePrice = ({ orgprice, orgdata, values, index }) => (
  <tr>
    <td colSpan="2">{(values[index].apdiv === Contants.APDIV_MYORG) ? orgdata.orgname : values[index].orgname}</td>
    <td align="right"><Field component={TextBox} name={`${orgprice}.price`} maxLength="7" style={{ textAlign: 'right', width: 100, imeMode: 'disabled' }} /></td>
    <td align="right"><Field component={TextBox} name={`${orgprice}.tax`} maxLength="7" style={{ textAlign: 'right', width: 100, imeMode: 'disabled' }} /></td>
    <td align="left"><Field component={TextBox} name={`${orgprice}.billprintname`} maxLength={Contants.LENGTH_OPTSNAME} style={{ width: 320 }} /></td>
    <td align="left"><Field component={TextBox} name={`${orgprice}.billprintename`} maxLength={Contants.LENGTH_OPTSNAME} style={{ width: 320 }} /></td>
  </tr>
);

// propTypesの定義
CtrSetGuidePrice.propTypes = {
  orgdata: PropTypes.shape().isRequired,
  orgprice: PropTypes.string,
  values: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  index: PropTypes.number.isRequired,
};

CtrSetGuidePrice.defaultProps = {
  orgprice: undefined,
};

export default CtrSetGuidePrice;

