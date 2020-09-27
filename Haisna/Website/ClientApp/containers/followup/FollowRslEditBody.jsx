import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { actions as sentenceGuideActions } from '../../modules/common/sentenceGuideModule';
import GuideButton from '../../components/GuideButton';
import Chip from '../../components/Chip';

const FollowRslEditBody = ({ followRslItemList, onShortStcClear, onShortStcSet, actions }: { actions: typeof sentenceGuideActions }) => (
  <table style={{ backgroundColor: '#999999', width: '100%' }}>
    <tbody>
      <tr style={{ backgroundColor: '#cccccc', textAlign: 'center' }}>
        <td style={{ width: '15%', whiteSpace: 'pre' }}>分類</td>
        <td style={{ width: '15%', whiteSpace: 'pre' }}>臓器（部位）</td>
        <td style={{ whiteSpace: 'pre', width: '70%' }} colSpan="3">診断名</td>
      </tr>
      {followRslItemList && followRslItemList.map((rec, index) => (
        <tr key={rec.key} style={{ backgroundColor: '#ffffff', textAlign: 'left' }}>
          <td style={{ width: '15%', whwhiteSpace: 'pre', textAlign: 'left' }}>{rec.grpname}</td>
          <td style={{ width: '15%', whiteSpace: 'pre', textAlign: 'left' }}>{rec.itemname}</td>
          <td style={{ width: '1%' }}>
            <GuideButton
              onClick={() =>
                actions.sentenceGuideOpenRequest({
                  itemCd: rec.itemcd,
                  itemType: 0,
                  onConfirm: (data) => onShortStcSet({ ...data, index }),
                })
              }
            >
              open
            </GuideButton>
          </td>
          <td style={{ width: '1%' }}>
            <span><Chip onDelete={() => onShortStcClear(index)} /></span>
          </td>
          <td style={{ width: '68%', whiteSpace: 'pre' }}>{rec.shortstc}</td>
        </tr>
      ))}
    </tbody>
  </table>
);

// propTypesの定義
FollowRslEditBody.propTypes = {
  onShortStcClear: PropTypes.func.isRequired,
  onShortStcSet: PropTypes.func.isRequired,
  followRslItemList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  refreshFlg: state.app.followup.follow.followRslEditGuide.refreshFlg,
});

export default connect(
  mapStateToProps,
  (dispatch) => ({
    actions: bindActionCreators(sentenceGuideActions, dispatch),
  }),
)(FollowRslEditBody);
