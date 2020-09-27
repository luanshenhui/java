// @flow

import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { compose, withState } from 'recompose';
import Button from '@material-ui/core/Button';

import { actions as sentenceGuideActions } from '../../modules/common/sentenceGuideModule';

// eslint-disable-next-line react/prop-types
const Guide = ({ actions, selectedItem, setSelectedItem }: { actions: typeof sentenceGuideActions, selectedItem: string, setSelectedItem: Function }) => (
  <div>
    <Button
      onClick={() =>
        actions.sentenceGuideOpenRequest({
          itemCd: '11030',
          itemType: 0,
          onConfirm: (data) => setSelectedItem(JSON.stringify(data, null, '  ')),
        })
      }
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
      actions: bindActionCreators(sentenceGuideActions, dispatch),
    }),
  ),
)(Guide);
