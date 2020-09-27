import React from 'react';
import { Field } from 'redux-form';
import PropTypes from 'prop-types';
import TextBox from '../../../components/control/TextBox';
import GuideButton from '../../../components/GuideButton';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import Label from '../../../components/control/Label';
import * as Contants from '../../../constants/common';

// 個人検査情報の入力フィールド
const MntPerInspectionItem = ({ field, item, index, handleGuildClick, handleClear }) => (
  <tr>
    { /* TODO 検査項目説明呼び出し */ }
    { /* <td width="390"><Link to="/.../.../.../DtlGuide></Link>{item.itemname</td> */ }
    <td width="390">{item.itemname}</td>
    {(item.resulttype === Contants.RESULTTYPE_TEISEI1 || item.resulttype === Contants.RESULTTYPE_TEISEI2 || item.resulttype === Contants.RESULTTYPE_SENTENCE) ?
      <td width="21"><GuideButton onClick={() => handleGuildClick(index, `${field}`)} /> </td> : <td />}
    {(item.resulttype === Contants.RESULTTYPE_CALC) ? <td width="100"><Label>{item.result}</Label></td> :
    <td width="100"><Field name={`${field}.result`} component={TextBox} maxLength="8" onChange={() => handleClear(index)} /></td>}
    <td>{item.shortstc}</td>
    <td width="200"><Field name={`${field}.ispdate`} component={DatePicker} minDate={Contants.DATERANGE_MIN} maxDate={Contants.DATERANGE_MAX} /></td>
  </tr>
);

// propTypesの定義
MntPerInspectionItem.propTypes = {
  field: PropTypes.string.isRequired,
  item: PropTypes.shape(),
  index: PropTypes.number.isRequired,
  /* TODO ガイド */
  handleGuildClick: PropTypes.func.isRequired,
  handleClear: PropTypes.func.isRequired,
};

MntPerInspectionItem.defaultProps = {
  item: {},
};

export default MntPerInspectionItem;

