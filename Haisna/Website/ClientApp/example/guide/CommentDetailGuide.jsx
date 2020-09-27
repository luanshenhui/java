import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import Button from '../../components/control/Button';

import CommentDetailGuide from '../../containers/preference//comment/CommentDetailGuide';
import { openCommentDetailGuide } from '../../modules/preference/pubNoteModule';

const CommentDetailGuideExample = (props) => {
  const { onOpenCommentDetailGuide } = props;
  return (
    <form>
      <CommentDetailGuide rsvno={580259} perid="8455479" orgcd1="06005" orgcd2="00000" ctrptcd="23442" cmtmode="0,0,0,1" seq={13} />
      <Button
        value="OPEN"
        onClick={() => {
          onOpenCommentDetailGuide();
        }}
      />
    </form>
  );
};

// propTypesの定義
CommentDetailGuideExample.propTypes = {
  onOpenCommentDetailGuide: PropTypes.func.isRequired,
};

const form = 'CommentDetailGuideExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
  };
}, (dispatch) => ({
  onOpenCommentDetailGuide: () => {
    // 開くアクションを呼び出す
    const conditions = { rsvno: 580259, perid: '8455479', orgcd1: '06005', orgcd2: '00000', ctrptcd: '23442', cmtmode: '0,0,0,1', seq: 13 };
    dispatch(openCommentDetailGuide({ conditions }));
  },
}))(reduxForm({ form })(CommentDetailGuideExample));
