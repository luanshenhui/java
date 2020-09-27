import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Label from '../../components/control/Label';
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

const RslList = ({
  field,
  item,
  handleonOpenRslCmtGuide,
  rslCmtGuideTargets1,
  rslCmtGuideTargets2,
  resulterror,
  callStcGuide,
  actions,
  sentenceGuideOpenTargets,
  handleResultChange,
  index,
  handleRslcmtcd1Change,
  handleRslcmtcd2Change,
}) => (
  <tr>
    <td>
      <span style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
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
      <td>
        <GuideButton
          onClick={() => actions.sentenceGuideOpenRequest({
            itemCd: item.itemcd,
            itemType: item.itemtype,
            onConfirm: (itemgrpdata) => callStcGuide(itemgrpdata, sentenceGuideOpenTargets),
          })}
        />
      </td>
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
        <span style={item.resulttype === 0 ? { textAlign: 'right', width: '224px', color: showColor(item.stdflg) } : { width: '224px', color: showColor(item.stdflg) }} >
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
    <td>
      <div>
        {item.shortstc}
      </div>
    </td>
    <td>
      <GuideButton onClick={() => handleonOpenRslCmtGuide(rslCmtGuideTargets1)} />
    </td>
    <td>
      <input type="text" name={`${field}.rslcmtcd1`} maxLength="8" style={{ width: '95px' }} value={item.rslcmtcd1} onChange={(event) => handleRslcmtcd1Change(event, index)} />
    </td>
    <td>
      <div>
        {item.rslcmtname1}
      </div>
    </td>
    <td>
      <GuideButton onClick={() => handleonOpenRslCmtGuide(rslCmtGuideTargets2)} />
    </td>
    <td>
      <Label>
        <input type="text" name={`${field}.rslcmtcd2`} maxLength="8" style={{ width: '95px' }} value={item.rslcmtcd2} onChange={(event) => handleRslcmtcd2Change(event, index)} />
      </Label>
    </td>
    <td>
      <div>
        {item.rslcmtname2}
      </div>
    </td>
    <td>{item.resulttype === 4 ? item.befshortstc : item.befresult}</td>
  </tr>
);

// propTypesの定義
RslList.propTypes = {
  field: PropTypes.string.isRequired,
  item: PropTypes.shape(),
  handleonOpenRslCmtGuide: PropTypes.func.isRequired,
  callStcGuide: PropTypes.func.isRequired,
  index: PropTypes.number.isRequired,
  handleResultChange: PropTypes.func.isRequired,
  handleRslcmtcd1Change: PropTypes.func.isRequired,
  handleRslcmtcd2Change: PropTypes.func.isRequired,
  actions: PropTypes.func.isRequired,
  rslCmtGuideTargets1: PropTypes.string.isRequired,
  rslCmtGuideTargets2: PropTypes.string.isRequired,
  sentenceGuideOpenTargets: PropTypes.string.isRequired,
  resulterror: PropTypes.string.isRequired,
};

RslList.defaultProps = {
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

export default connect(setStateToProps, mapDispatchToProps)(RslList);

