import React from 'react';
import PropTypes from 'prop-types';
import Button from '../../../components/control/Button';
import Table from '../../../components/Table';
import CtrSetGuidePrice from './CtrSetGuidePrice';

const CtrSetGuidePrices = (props) => {
  const { orgdata, formValues, onCalculate } = props;
  const { orgprices, totalprice, totaltax } = formValues;
  return (
    <Table>
      <thead>
        <tr bgcolor="#eeeeee">
          <th colSpan="2">負担元</th>
          <th width="90px" >負担金額</th>
          <th width="90px" >消費税</th>
          <th>請求書・領収書出力名</th>
          <th>請求書・領収書出力名（英語）</th>
        </tr>
      </thead>
      <tbody>
        {props.fields.map((orgprice, index) => <CtrSetGuidePrice {...props} key={`${orgprice}`} index={index} orgprice={orgprice} orgdata={orgdata} values={orgprices} />)}
        <tr>
          <td>負担金額総計</td>
          <td><Button onClick={() => onCalculate(formValues)} value="再計算" /></td>
          <td style={{ textAlign: 'right' }}>{totalprice !== null && totalprice !== undefined && <span>\{totalprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</span>}</td>
          <td style={{ textAlign: 'right' }}>{totaltax !== null && totaltax !== undefined && <span>\{totaltax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</span>}</td>
          <td colSpan="2"><span style={{ color: '#999999' }}>※出力名（日本語）は未指定の場合、セット名が適用されます。</span></td>
        </tr>
      </tbody>
    </Table>
  );
};

// propTypesの定義
CtrSetGuidePrices.propTypes = {
  fields: PropTypes.shape().isRequired,
  orgdata: PropTypes.shape().isRequired,
  onCalculate: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
};

CtrSetGuidePrices.defaultProps = {
  formValues: undefined,
};

export default CtrSetGuidePrices;
