import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { compose, withState } from 'recompose';
import Button from '@material-ui/core/Button';

import { actions as itemAndGroupGuideActions } from '../../modules/common/itemAndGroupGuideModule';

// eslint-disable-next-line react/prop-types
const Guide = ({ actions, selectedItem, setSelectedItem }) => (
  <div>
    <Button
      onClick={() => actions.itemAndGroupGuideOpenRequest({
        itemMode: 1,
        showGroup: true,
        showItem: true,
        onConfirm: (data) => setSelectedItem(JSON.stringify(data, null, '  ')),
      })}
    >
      open
    </Button>
    <pre>{selectedItem}</pre>
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
