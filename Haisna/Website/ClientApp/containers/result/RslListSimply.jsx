import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import GuideButton from '../../components/GuideButton';
import { actions as sentenceGuideActions } from '../../modules/common/sentenceGuideModule';

// 基準値フラグにより色を設定する
const showColor = (stdflg) => {
  let color = '#000000';
  if (stdflg === 'H') {
    color = '#ff0000';
  } else if (stdflg === 'U') {
    color = '#ff4500';
  } else if (stdflg === 'D') {
    color = '#00ffff';
  } else if (stdflg === 'L') {
    color = '#0000ff';
  } else if (stdflg === '*') {
    color = '#ff0000';
  } else if (stdflg === '@') {
    color = '#800080';
  }
  return color;
};


const RslListSimply = ({ field, item, callStcGuide, actions, sentenceGuideOpenTargets, handleResultChange, index, resulterror }) => (

  <tr>
    <td>
      <span style={{ width: '180px', textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
        <a role="presentation" >
          {item.itemname}
        </a>
      </span>
    </td>
    { /* 定性ガイド表示 */}
    {(item.resulttype === 1 || item.resulttype === 2) && (
      <td>
        <GuideButton />
      </td>
    )}
    { /* 文章ガイド表示 */}
    {item.resulttype === 4 && (
      <GuideButton
        onClick={() => actions.sentenceGuideOpenRequest({
          itemCd: item.itemcd,
          itemType: item.itemtype,
          onConfirm: (itemgrpdata) => callStcGuide(itemgrpdata, sentenceGuideOpenTargets),
        })}
      />
    )}
    { /* ガイド表示なし */}
    {item.resulttype !== 4 && item.resulttype !== 1 && item.resulttype !== 2 && (
      <td>
        &nbsp;
      </td>
    )}
    { /* 計算結果の場合 */}
    {item.resulttype === 5 && (
      <td>
        <span style={item.resulttype === 0 ? { textAlign: 'right', color: showColor(item.stdflg) } : { color: showColor(item.stdflg) }} >
          {item.result}
        </span>
      </td>
    )}
    { /* それ以外の場合 */}
    {item.resulttype !== 5 && (
      <td>
        <input
          value={item.result}
          type="text"
          name={`${field}.result`}
          maxLength="8"
          style={item.resulttype === 0 ?
              { width: '95px', textAlign: 'right', color: showColor(item.stdflg), backgroundColor: resulterror !== '' && resulterror !== undefined ? '#ffccff' : '' }
              : { width: '95px', color: showColor(item.stdflg), backgroundColor: resulterror !== '' && resulterror !== undefined ? '#ffccff' : '' }}
          onChange={(event) => handleResultChange(event, index)}
        />
      </td>
    )}
    <td>{item.befresult}</td>
  </tr>
);

// propTypesの定義
RslListSimply.propTypes = {
  field: PropTypes.string.isRequired,
  item: PropTypes.shape(),
  index: PropTypes.number.isRequired,
  handleResultChange: PropTypes.func.isRequired,
  callStcGuide: PropTypes.func.isRequired,
  actions: PropTypes.func.isRequired,
  sentenceGuideOpenTargets: PropTypes.string.isRequired,
  resulterror: PropTypes.string.isRequired,
};

RslListSimply.defaultProps = {
  item: {},
};

const setStateToProps = (state, props) => {
  const { field } = props;

  return {
    rslCmtGuideTargets1: {
      rslcmtcd: `${field}.rslcmtcd1`,
      rslcmtname: `${field}.rslcmtname1`,
    },
    rslCmtGuideTargets2: {
      rslcmtcd: `${field}.rslcmtcd2`,
      rslcmtname: `${field}.rslcmtname2`,
    },
    sentenceGuideOpenTargets: {
      result: `${field}.result`,
      shortstc: `${field}.shortstc`,
    },
  };
};
const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators(sentenceGuideActions, dispatch),
});

export default connect(setStateToProps, mapDispatchToProps)(RslListSimply);

