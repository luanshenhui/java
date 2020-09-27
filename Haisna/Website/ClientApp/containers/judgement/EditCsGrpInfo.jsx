import React from 'react';
import { Field } from 'redux-form';
import PropTypes from 'prop-types';

import DropDownCsGrp from '../../components/control/dropdown/DropDownCsGrp';
import Button from '../../components/control/Button';
import GuideButton from '../../components/GuideButton';

const handleHainsEgmainConnectClick = () => {
  this.alert('電子チャート情報');
};

// 電子チャート情報
const getHainsEgmainConnect = (data) => {
  let res;
  if (data) {
    if (data.length > 0) {
      const perId = data[0].perid.slice(0, 1);
      if (perId !== '@') {
        res = <GuideButton onClick={handleHainsEgmainConnectClick} />;
      }
    }
  }
  return res;
};


const EditCsGrpInfo = (props) => (
  <div>
    <div style={{ float: 'left' }}>前回値:<Field name="csgrp" component={DropDownCsGrp} rsvNo={props.rsvno} /></div>
    <div style={{ float: 'left' }}>を</div>
    <div style={{ float: 'left' }}><Button className="btn" onClick={props.handleSubmit(props.dispCalledFunction)} value="表示" /></div>
    <div style={{ float: 'left' }}>{getHainsEgmainConnect(props.data)}</div>
    <div style={{ clear: 'left' }} />
  </div>
);

// propTypesの定義
EditCsGrpInfo.propTypes = {
  rsvno: PropTypes.number.isRequired,
  dispCalledFunction: PropTypes.func,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
};

// defaultPropsの定義
EditCsGrpInfo.defaultProps = {
  dispCalledFunction: undefined,
};

export default EditCsGrpInfo;
