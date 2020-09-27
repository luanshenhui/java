import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import BodySignIcon from '../../containers/common/BodySignIcon';

const PerrslListBody = ({ data }) => (
  <div style={{ width: '1050px', height: '40px' }} >
    {data.getperrsldata && data.getperrsldata.perResultGrp && data.getperrsldata.perResultGrp.map((rec, i) => (
      <div style={{ width: '30px', float: 'left' }} key={i.toString()}><BodySignIcon name={rec.imagefilename} /></div>
    ))}
  </div>
);

// propTypesの定義
PerrslListBody.propTypes = {
  data: PropTypes.shape(),
};

PerrslListBody.defaultProps = {
  data: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.reserve.consult.receiptMainGuide.data,
});

export default connect(mapStateToProps)(PerrslListBody);
