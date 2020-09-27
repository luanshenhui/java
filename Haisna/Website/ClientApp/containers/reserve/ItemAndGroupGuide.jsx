import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { compose, withState } from 'recompose';
import GuideButton from '../../components/GuideButton';

import { actions as itemAndGroupGuideActions } from '../../modules/common/itemAndGroupGuideModule';

// eslint-disable-next-line react/prop-types
const Guide = ({ setItemInfo, actions }) => (
  <div>
    <GuideButton
      onClick={() => actions.itemAndGroupGuideOpenRequest({
        itemMode: 1,
        showGroup: true,
        showItem: true,
        onConfirm: (data) => {
          setItemInfo(data);
        },
      })}
    />
  </div>
);

export default compose(
  withState('selectedItem', 'setSelectedItem', null),
  connect(
    null,
    (dispatch) => ({
      actions: bindActionCreators(itemAndGroupGuideActions, dispatch),
    }),
  ),
)(Guide);
