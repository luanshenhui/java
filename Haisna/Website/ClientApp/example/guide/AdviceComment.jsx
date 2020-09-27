import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { compose, withState } from 'recompose';
import Button from '@material-ui/core/Button';

import AdviceCommentGuide from '../../containers/common/AdviceCommentGuide';
import { actions as judCmtStcActions } from '../../modules/preference/judCmtStcModule';

const judClassCd = 57;
const initialSelected = ['310001'];

// eslint-disable-next-line react/prop-types
const AdviceComment = ({ open, actions, selectedItem, setSelectedItem }) => (
  <div>
    <AdviceCommentGuide
      open={open}
      onSelect={(selected) => {
        setSelectedItem(JSON.stringify(selected, null, '  '));
      }}
    />
    <Button onClick={() => actions.openAdviceCommentGuideRequest({ judClassCd, initialSelected })}>
      open
    </Button>
    <pre>{selectedItem}</pre>
  </div>
);

export default compose(
  withState('selectedItem', 'setSelectedItem', null),
  connect(
    (state) => ({
      open: state.app.preference.judCmtStc.adviceCommentGuide.open,
    }),
    (dispatch) => ({
      actions: bindActionCreators(judCmtStcActions, dispatch),
    }),
  ),
)(AdviceComment);
